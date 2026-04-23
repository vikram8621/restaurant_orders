USE restaurant_db;

-- Objective 1
-- Explore the items table
-- Your first objective is to better understand the items table by finding the number of rows in the table, the least and most expensive items, and the item prices within each category.

-- 1. View the menu_items table and write a query to find the number of items on the menu
SELECT 
-- COUNT(*)
COUNT(DISTINCT menu_item_id) total_items
FROM menu_items;

-- Answer is 32 items

-- 2. What are the least and most expensive items on the menu?

SELECT 
*
FROM menu_items
ORDER BY price;
-- Answer - Shrimp Scampi 19.95 Edamame 5.00











-- 3. How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?
SELECT COUNT(*) from menu_items
WHERE 
	category = 'Italian';
SELECT 
	item_name,
	price
FROM 
	menu_items
WHERE 
	category = 'Italian'
GROUP BY 
	item_name
ORDER BY price DESC;
-- Answer Spaghetti 14.50 Shrimp Scampi 19.95




-- 4.How many dishes are in each category? What is the average dish price within each category?
SELECT 
COUNT(menu_item_id) AS total_items,
category,
ROUND(AVG(price),2) AS avg_price
FROM menu_items
GROUP BY category
ORDER BY avg_price DESC;
-- Answer - Italian 16.75 American 10.07


-- Objective 2
-- Explore the orders table
-- Your second objective is to better understand the orders table by finding the date range, the number of items within each order, and the orders with the highest number of items.

-- 1. View the order_details table. What is the date range of the table?
SELECT * FROM order_details;
SELECT
MIN(order_date) AS min_date,
MAX(order_date) AS max_date
FROM order_details;
-- ORDER BY order_date DESC;
-- Answer 2023-01-01 to 2023-03-31






-- 2. How many orders were made within this date range? How many items were ordered within this date range?
SELECT
COUNT(DISTINCT order_id) AS total_orders
-- order_id
FROM order_details;
-- Answer '5370'







-- 3. Which orders had the most number of items?
SELECT
order_id,
COUNT(item_id) AS total_orders
FROM order_details
GROUP BY order_id
ORDER BY total_orders DESC;








-- 4. How many orders had more than 12 items?
SELECT COUNT(*) FROM 
(SELECT
order_id,
COUNT(item_id) AS total_items
FROM order_details
GROUP BY order_id
HAVING total_items >12)
AS above_12;





-- Objective 3
-- Analyze customer behavior
-- Your final objective is to combine the items and orders tables find the least and most ordered categories, and dive into the details of the highest spend orders.
-- My solution 
-- SELECT 
-- menu_item_id AS m_1,
-- item_name,
-- category,
-- price,
-- (order_details.order_id) AS o_1,
-- (order_details.order_date),
-- (order_details.order_time)
-- FROM menu_items
-- -- UNION ALL
-- LEFT JOIN order_details ON
-- order_details.item_id = menu_items.menu_item_id
-- ORDER BY m_1;

SELECT * FROM
order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
    ORDER BY price DESC;



-- 2. find the least and most ordered categories, and dive into the details of the highest spend orders. 
-- SELECT 
-- 	menu_item_id AS m_1,
-- 	item_name,
-- 	category,
-- 	price,
-- 	COUNT(order_details.order_id) AS o_1,
-- 	(order_details.order_date),
-- 	(order_details.order_time)
-- 	FROM menu_items
-- 	-- UNION ALL
-- 	LEFT JOIN order_details ON
-- 	order_details.item_id = menu_items.menu_item_id
--     GROUP BY Item_name
-- 	ORDER BY o_1 ASC;
--     -- Hamburger, American 622 Chicken Tacos, Mexican 101
SELECT item_name, category, COUNT(order_details_id) AS num_purchases
FROM
order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY item_name, category
ORDER BY num_purchases DESC;

    -- 3. What were the top 5 orders that spent the most money?
-- SELECT 
-- 	menu_item_id AS m_1, item_name, category,
-- 	price,
-- 	(order_details.order_id) AS o_1,
-- 	(order_details.order_date),
-- 	(order_details.order_time)
-- 	FROM menu_items
-- 	-- UNION ALL
-- 	LEFT JOIN order_details ON
-- 	order_details.item_id = menu_items.menu_item_id
--     GROUP BY Item_name
-- 	ORDER BY price DESC
--     LIMIT 5;
   --  'Shrimp Scampi' 'Meat Lasagna' 'Korean Beef Bowl' 'Pork Ramen' 'Spaghetti & Meatballs'
   SELECT
   order_id, SUM(price) AS total_spend
   FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
    GROUP BY order_id
    ORDER BY total_spend DESC
    LIMIT 5;
-- 4.  View the details of the highest spend order. Which specific items were purchased?
-- SELECT menu_item_id AS m_1,
-- 	item_name,
-- 	category,
-- 	SUM(price) AS total_spend,
-- 	(order_details.order_id) AS o_1,
-- 	(order_details.order_date),
-- 	(order_details.order_time)
-- 	FROM menu_items
-- 	-- UNION ALL
-- 	LEFT JOIN order_details ON
-- 	order_details.item_id = menu_items.menu_item_id
--     GROUP BY o_1
-- 	ORDER BY total_spend DESC
--     LIMIT 5;
--    --  'Hot Dog' '192.15'
SELECT order_id, category,
COUNT(item_id) AS num_items
   FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY order_id, category;

440	192.15
2075	191.05
1957	190.10
330	189.70
2675	185.10

