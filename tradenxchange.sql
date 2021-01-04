CREATE TABLE USER_T(
email_id VARCHAR(30) NOT NULL PRIMARY KEY,
USER_id DECIMAL(10) NOT NULL unique,
password VARCHAR(25) NOT NULL,
first_name VARCHAR(25) NOT NULL,
last_name VARCHAR(25) NOT NULL,
Phone DECIMAL(10) NOT  NULL,
ZIP DECIMAL(5) NOT NULL,
DOB DATE NOT NULL,
User_type CHAR(1) NOT NULL);

CREATE TABLE Category(
category_ID DECIMAL(12)NOT NULL PRIMARY KEY,
category_name VARCHAR(64)NOT NULL);

CREATE TABLE Item(
Item_ID DECIMAL(12) NOT NULL PRIMARY KEY,
Item_name VARCHAR(25)NOT NULL,
Item_zip DECIMAL(5) NOT NULL,
Item_image BLOB NOT NULL,
Item_post_date DATE,
Item_cost DECIMAL(6) NOT NULL,
USER_ID DECIMAL(10) NOT NULL,
Category_id DECIMAL(12) NOT NULL,
FOREIGN KEY (USER_id) References USER_T(USER_id) ,
FOREIGN KEY (category_id) References Category(category_id),
Item_description VARCHAR(255) NOT NULL,
Item_status CHAR(1) NOT NULL);

CREATE TABLE Seller_service (
Seller_ID DECIMAL(12) NOT NULL PRIMARY KEY,
Trust_rating DECIMAL(1),
Seller_location VARCHAR(100) NOT NULL,
Item_ID DECIMAL(12) NOT NULL,
FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID));

CREATE TABLE Buyer(
Buyer_ID DECIMAL(12) NOT NULL PRIMARY KEY,
Buyer_location VARCHAR(100) NOT NULL);


CREATE TABLE Message(
message_ID DECIMAL(15) PRIMARY KEY,
Seller_ID DECIMAL(12) NOT NULL,
Buyer_ID DECIMAL(12) NOT NULL,
FOREIGN KEY (Seller_ID) REFERENCES Seller_service(seller_ID),
FOREIGN KEY (Buyer_ID) REFERENCES Buyer(Buyer_ID),
Message_datetime DATE,
Message_text VARCHAR(255));

--PROCUDURE FUNCTION
create or replace function add_new_user(
	email_id IN VARCHAR,
	user_id IN DECIMAL,
	first_name IN VARCHAR,
	last_name IN VARCHAR,
	PASS IN VARCHAR,
	phone IN DECIMAL,
	ZIP IN DECIMAL,
	DOB IN DATE,
	USER_TYPE IN CHAR
)
	RETURNS VOID LANGUAGE plpgsql
AS
$reusableproc$
begin
	insert into user_t(email_id, user_id, first_name, last_name,PASS, Phone, ZIP, DOB, User_type )
	values(email_id, user_id, first_name, last_name,PASS, phone, ZIP,DOB,User_type);
end;
$reusableproc$;
DO 
	$$ 
		BEGIN 
			EXECUTE add_new_user('abc1@xyz.com','11231', 'Robert0', 'Frosty','MERIBA', '1232456890', '02451', '13-March-1962', 'f');
			EXECUTE add_new_user('abcd@xyz.com','31241', 'Mark', 'Jacobs', 'BHAIKYA','1234567989', '02151', '23-March-1972', 'm');
		END;
	$$;

--call procedure function 
DO 
	$$ 
		BEGIN 
			EXECUTE add_new_user ('mhurley0@artisteer.com', '1', 'Marybelle', 'Hurley', 'vuQqLGagdlU','8248184660' , '5104', '1973-01-10 ', 'F') ;
			EXECUTE add_new_user ('ljanman1@yelp.com','2',  'Leyla', 'Janman', 'DWzOsB', '8997282789',  '26000', '1957-07-08 ', 'T');
			EXECUTE add_new_user ('sbenadette2@umich.edu', '3', 'Sharlene', 'Benadette', 'gUfj9p2X',  '4142307510','02134', '1973-06-10 ', 'F');
			EXECUTE add_new_user('sdall3@nps.gov','4',  'Sheridan', 'Dall', 'vB9FFe', '6016993977',  '39204', '1980-07-07', 'F');
			EXECUTE add_new_user ('srosberg4@gravatar.com','5',  'Sibella', 'Rosberg', 'XcTa4R1', '1197116092',  '02134', '1983-05-30', 'F');
			EXECUTE add_new_user ('cbacon5@amazon.com','6',  'Clemmy', 'Bacon', 'zzfktK2', '1882904001',  '2109', '1976-12-05 ', 'T');
			EXECUTE add_new_user ('lwickie6@reference.com','7',  'Lainey', 'Wickie', 'Gdj30J6RxEwf', '9019095598', '02134', '1964-09-14 ', 'F');
			EXECUTE add_new_user ('mchanner7@networksolutions.com','8',  'Madlin', 'Channer', 'BRk21T1oG8bf', '7922772427', '68000', '1985-07-30 ', 'F');
			EXECUTE add_new_user ('bpavolillo8@archive.org','9',  'Beverley', 'Pavolillo', 'tif5pf9dC2ix', '6424469424', '5072', '1962-10-10 ','F');
			EXECUTE add_new_user ('tmactrustie9@pinterest.com','10',  'Tabor', 'MacTrustie', 'iGJU3rsb', '6192128208',  '36200', '1994-02-04 ','F');
			EXECUTE add_new_user ('rpetkova@reuters.com', '11', 'Rozella', 'Petkov', 'hNXDh9hjF5', '9453745129',  '02134', '1996-12-25 ', 'F');
		END;
	$$;
--Trigger function to change password

CREATE OR REPLACE FUNCTION Change_password()
	RETURNS TRIGGER LANGUAGE plpgsql
	AS
	$trigfunc$
	
	BEGIN 
		IF (Old.PASS<> New.PASS) THEN
			INSERT INTO USER_T(email_id, user_id, first_name, last_name,PASS, Phone, ZIP, DOB, User_type)
			VALUES(email_id, user_id, first_name, last_name,New.PASS,phone ,DOB, USER_type);
		END IF;
		RETURN NEW;
	END;
	$trigfunc$;

CREATE TRIGGER Post_changed_trg_password
Before update on user_t
FOR EACH ROW
EXECUTE PROCEDURE change_password();

--Trigger function to change phone number

CREATE OR REPLACE FUNCTION Change_phone()
	RETURNS TRIGGER LANGUAGE plpgsql
	AS
	$trigfunc$
	
	BEGIN 
		IF (Old.PHONE<> New.PHONE) THEN
			INSERT INTO USER_T(email_id, user_id, first_name, last_name,PASS, Phone, ZIP, DOB, User_type)
			VALUES(email_id, user_id, first_name, last_name,PASS,New.phone ,DOB, USER_type);
		END IF;
		RETURN NEW;
	END;
	$trigfunc$;

CREATE TRIGGER Post_changed_trg
Before update on user_t
FOR EACH ROW
EXECUTE PROCEDURE change_phone();

--Balance change 
CREATE TABLE BalanceCharges (
	change_id DECIMAL(12) NOT NULL PRIMARY KEY,
	OldBalance DECIMAL(7,2) NOT NULL,
	NewBalance DECIMAL(7,2) NOT NULL,
	User_ID DECIMAL(12) NOT NULL,
	CHANGEDATE DATE NOT NULL,
	FOREIGN KEY (User_ID) REFERENCES User_T(User_ID));

--identifyusers is same location
SELECT FIRST_NAME ,LAST_NAME , DOB
FROM USER_T
WHERE USER_T.ZIP ='02134';

