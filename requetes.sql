-- Prix moyen au m² pour les appartements de plus de 4 pièces

SELECT 
    round(avg(v.valeurFonciere / b.surfaceCarrez), 2) AS 'prix_moyen_m²_apt_plus_de_4_pieces',
    r.nomReg AS 'nom_region'
FROM 
	vente v
JOIN
	Bien b ON b.idBien = v.idBien
JOIN
	Commune c ON c.codeDepCodeCom = b.codeDepCodeCom
JOIN
	Region r ON r.codeReg = c.codeReg
WHERE
    b.typeBien = 'Appartement' AND
    b.piecePrincipale > 4 AND
    v.valeurFonciere > 0
GROUP BY
	r.nomReg
ORDER BY
	prix_moyen_m²_apt_plus_de_4_pieces DESC;
 
 
-- Les 20 communes avec le plus de transactions pour les communes dépassant 10k habitants

WITH nb_ventes_population AS(
SELECT
	count(v.valeurFonciere) AS 'nb_ventes',
    c.nomCom AS 'nom_commune',
    c.popMun AS 'population'
FROM
	vente v
JOIN
	bien b ON b.idBien = v.idBien
JOIN
	commune c ON c.codeDepCodeCom = b.codeDepCodeCom
WHERE
	c.popMun > 10000 AND
    v.valeurFonciere > 0 AND
    b.surfaceCarrez > 0
GROUP BY
	c.nomCom, 
    c.popMun
    )
    
SELECT 
	nom_commune,
    population,
    nb_ventes,
    round((nb_ventes / population) * 1000, 2) AS 'nb_ventes_pour_1000_hab'
FROM 
	nb_ventes_population
ORDER BY
	nb_ventes_pour_1000_hab DESC
LIMIT
	20;
    


