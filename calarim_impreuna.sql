-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 15, 2025 at 02:52 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `calarim_impreuna`
--

-- --------------------------------------------------------

--
-- Table structure for table `horses`
--

CREATE TABLE `horses` (
  `HorseID` int(11) NOT NULL,
  `Nume` varchar(50) NOT NULL,
  `NivelCompetenta` enum('Incepator','Intermediar','Avansat') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `horses`
--

INSERT INTO `horses` (`HorseID`, `Nume`, `NivelCompetenta`) VALUES
(1, 'Tornado', 'Incepator'),
(2, 'Thunder', 'Intermediar'),
(3, 'Blaze', 'Avansat'),
(4, 'Storm', 'Incepator');

-- --------------------------------------------------------

--
-- Table structure for table `programari`
--

CREATE TABLE `programari` (
  `ProgramareID` int(11) NOT NULL,
  `Data_Programare` date NOT NULL,
  `Ora` time NOT NULL,
  `Mesaj` text DEFAULT NULL,
  `HorseID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `programari`
--

INSERT INTO `programari` (`ProgramareID`, `Data_Programare`, `Ora`, `Mesaj`, `HorseID`, `UserID`) VALUES
(1, '2025-01-21', '15:00:00', 'mi-ar placea pe in cal inalt', 2, 1),
(2, '2025-01-20', '18:30:00', 'cal putere', 3, 3);

--
-- Triggers `programari`
--
DELIMITER $$
CREATE TRIGGER `before_insert_programare` BEFORE INSERT ON `programari` FOR EACH ROW BEGIN
    DECLARE user_level VARCHAR(50);
    DECLARE horse_level VARCHAR(50);
    
    IF EXISTS (SELECT 1 FROM programari WHERE HorseID = NEW.HorseID AND data_programare = NEW.data_programare AND ora = NEW.ora) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Exista deja o programare la aceasta data ai ora pentru acest cal';
    END IF;
    
    SELECT NivelCompetenta INTO user_level FROM users WHERE UserID = NEW.UserID;


    SELECT NivelCompetenta INTO horse_level FROM horses WHERE HorseID = NEW.HorseID;

    IF user_level != horse_level THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nivelul utilizatorului nu corespunde cu nivelul calului ales';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `UserID` int(11) NOT NULL,
  `NumeUtilizator` varchar(50) NOT NULL,
  `ParolaHash` varchar(255) NOT NULL,
  `NivelCompetenta` enum('Incepător','Intermediar','Avansat') NOT NULL,
  `DataCrearii` timestamp NOT NULL DEFAULT current_timestamp(),
  `Nume` varchar(100) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `NrTelefon` varchar(20) DEFAULT NULL,
  `DataNasterii` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`UserID`, `NumeUtilizator`, `ParolaHash`, `NivelCompetenta`, `DataCrearii`, `Nume`, `Email`, `NrTelefon`, `DataNasterii`) VALUES
(1, 'ali04calut', '$2y$10$VVZdTnadzUecbmEXcO2sl.Hx0/rcsnRqpamjB5eNF54DEtshvr9W.', 'Intermediar', '2025-01-09 21:45:59', 'Siciu', 'alinajnia@gmail.com', '0746851708', '2004-12-12'),
(2, 'stefi_frumusica227', '$2y$10$QbzJJZtHRyzBWheQ58e6R.2CmHyPQGdt.ZLLsWnWhLjxgeYFx9.bq', 'Incepător', '2025-01-09 22:12:51', 'Stefania Patko', 'stefipat@email.com', '0754826175', '2003-05-17'),
(3, 'antonia123', '$2y$10$KCMK2hwxTOkCy9o71gTVVOprZfdc1DphVK1ww4JntKhAHtMx4gSP.', 'Avansat', '2025-01-09 22:22:56', 'Antonia', 'antonica@yahoo.com', '0748512332', '2001-06-28');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `horses`
--
ALTER TABLE `horses`
  ADD PRIMARY KEY (`HorseID`);

--
-- Indexes for table `programari`
--
ALTER TABLE `programari`
  ADD PRIMARY KEY (`ProgramareID`),
  ADD KEY `HorseID` (`HorseID`),
  ADD KEY `UserID` (`UserID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `NumeUtilizator` (`NumeUtilizator`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `horses`
--
ALTER TABLE `horses`
  MODIFY `HorseID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `programari`
--
ALTER TABLE `programari`
  MODIFY `ProgramareID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `programari`
--
ALTER TABLE `programari`
  ADD CONSTRAINT `programari_ibfk_1` FOREIGN KEY (`HorseID`) REFERENCES `horses` (`HorseID`) ON DELETE CASCADE,
  ADD CONSTRAINT `programari_ibfk_2` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
