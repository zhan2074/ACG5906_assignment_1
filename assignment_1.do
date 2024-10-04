clear all
*set more off

cd "C:\Users\zhan2\Dropbox\Class\ACG5906\assignment\ACG5906_assignment_1"

cap log close
log using assignment1.log, replace

import delimited "dataset_nobel_chocolate-1.csv", clear
compress
save "dataset_nobel_chocolate.dta", replace

*describe
*codebook

* ssc install outreg2, replace
* ssc install asdoc, replace
* ssc install cortex, replace

outreg2 using p1.tex, replace sum(log) ti(Table 1: Summary Statistics)

set graphics off
#delimit ;
twoway scatter nobel chocolate, 
	mlabel(name) 
	title("Nobel Laureates vs. Chocolate Consumption") 
	xtitle("Chocolate Consumption (kg per capita per year)") 
	ytitle("Nobel Laureates per 10 Million Population") 
	xlabel(0(5)15) 
	ylabel(0(5)30)|| 
	lfit nobel chocolate;
#delimit cr

graph export "fig1.png", replace

corrtex nobel chocolate, file(p3a) sig title(Correlation Table) replace

corrtex nobel chocolate if name != "Sweden", file(p3b) sig title(Correlation Excluding Sweden) replace

reg nobel chocolate
outreg2 using p3c.tex, label ctitle(Model 1) replace

scalar beta_inv = 1/_b[chocolate]
di "Total kg of chocolate needed for the US: " beta_inv * 330

reg nobel chocolate if name != "Sweden"
outreg2 using p5c.tex, replace

use "dataset_nobel_chocolate_extended-1.dta", replace
replace name = substr(name, 2, .)
replace name=subinstr(name," ","",.)
save "dataset_nobel_chocolate_extended_cleaned.dta", replace

use "dataset_nobel_chocolate.dta", replace
merge 1:1 name using "dataset_nobel_chocolate_extended_cleaned.dta"

save "dataset_nobel_chocolate_extended_cleaned_merged.dta", replace

reg nobel chocolate gdp hdi energy protein life
outreg2 using p8a.tex, replace

corrtex nobel chocolate gdp hdi energy protein life, file(p8b) sig replace

reg nobel chocolate gdp hdi
outreg2 using p8c.tex, replace

cap log close