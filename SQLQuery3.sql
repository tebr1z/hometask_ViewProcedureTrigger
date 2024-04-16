CREATE DATABASE Restorants
USE Restorants

CREATE TABLE Yemekler (
    Id INT PRIMARY KEY,
    adi VARCHAR(50),
    qiymeti DECIMAL(10, 2)
);

CREATE TABLE Masalar (
    nomre INT PRIMARY KEY
);

CREATE TABLE Sifarisler (
    Id INT PRIMARY KEY,
    yemek_id INT,
    masa_nomre INT,
    tarix_ve_saat DATETIME,
    FOREIGN KEY (yemek_id) REFERENCES Yemekler(Id),
    FOREIGN KEY (masa_nomre) REFERENCES Masalar(nomre)
);

INSERT INTO Yemekler (Id, adi, qiymeti) VALUES
(1, 'Pizza', 15.99),
(2, 'Burger', 9.99),
(3, 'Salat', 7.99);

INSERT INTO Masalar (nomre) VALUES
(1),
(2),
(3),
(4);

INSERT INTO Sifarisler (Id, yemek_id, masa_nomre, tarix_ve_saat) VALUES
(1, 1, 1, '2024-04-15 12:30:00'),
(2, 2, 2, '2024-04-15 13:45:00'),
(3, 1, 1, '2024-04-15 14:20:00'),
(4, 3, 3, '2024-04-15 15:00:00');

--Bütün masadatalarını yanında o masaya edilmiş sifariş sayı ilə birlikdə select edən query
SELECT Masalar.nomre, COUNT(Sifarisler.Id) AS sifaris_sayı
FROM Masalar
LEFT JOIN Sifarisler ON Masalar.nomre = Sifarisler.masa_nomre
GROUP BY Masalar.nomre;

--Bütün yeməkləri o yeməyin sifariş sayı ilə select edən query
SELECT Yemekler.adi, COUNT(Sifarisler.Id) AS sifaris_sayi
FROM Yemekler
LEFT JOIN Sifarisler ON Yemekler.Id = Sifarisler.yemek_id
GROUP BY Yemekler.adi;

--Bütün sifariş datalarını yanında yeməyin adı ilə select edən query
SELECT Sifarisler.*, Yemekler.adi
FROM Sifarisler
LEFT JOIN Yemekler ON Sifarisler.yemek_id = Yemekler.Id;

--Bütün sifariş datalarını yanında yeməyin adı və masanın nomresi ilə select edən query:
SELECT Sifarisler.*, Yemekler.adi, Masalar.nomre
FROM Sifarisler
LEFT JOIN Yemekler ON Sifarisler.yemek_id = Yemekler.Id
LEFT JOIN Masalar ON Sifarisler.masa_nomre = Masalar.nomre;

--Bütün masa datalarını yanında o masanın sifarişlərinin ümumi əmələği ilə select edən query:
SELECT Masalar.nomre, SUM(Yemekler.qiymeti) AS umumi_mebleg
FROM Masalar
LEFT JOIN Sifarisler ON Masalar.nomre = Sifarisler.masa_nomre
LEFT JOIN Yemekler ON Sifarisler.yemek_id = Yemekler.Id
GROUP BY Masalar.nomre;

--1-idli masaya verilmiş ilk sifarişlə son sifariş arasında neçə saat fərq olduğunu select edən query
SELECT DATEDIFF(hour, MIN(tarix_ve_saat), MAX(tarix_ve_saat)) AS saat_ferq
FROM Sifarisler
WHERE masa_nomre = 1;

--Ən son 30 dəqiqədən əvvəl verilmiş sifarişləri select edən query
SELECT *
FROM Sifarisler
WHERE tarix_ve_saat >= DATEADD(minute, -30, GETDATE());


--Heç sifariş verməmiş masaları select edən query:
SELECT Masalar.nomre
FROM Masalar
LEFT JOIN Sifarisler ON Masalar.nomre =Sifarisler.masa_nomre
WHERE Sifarisler.Id IS NULL;


--Son 60 dəqiqədə heç sifariş verməmiş masaları select edən query:
SELECT Masalar.nomre
FROM Masalar
LEFT JOIN Sifarisler ON Masalar.nomre = Sifarisler.masa_nomre
GROUP BY Masalar.nomre
HAVING MAX(Sifarisler.tarix_ve_saat) < DATEADD(minute, -60, GETDATE());
