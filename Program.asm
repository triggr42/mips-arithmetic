.data #Data section for the prompts, displays and string outputs in the form of labels that will be called
# in the text sesction of the program 

menu_prompt: .asciiz "Menu:\n1. Enter Number 1\n2. Enter Number 2\n3. Display num1 and num2\n4. Display sum of num1 and num2\n5. Display product of num1 and num2\n6. Divide num1 by num2\n7. Exchange numbers 1 and 2\n8. Display Numbers between num1 and num2\n9. Sum numbers between num1 and num2\n10. Raise num1 to the power of num2\n11. Display prime numbers between num1 and num2\n12. Quit the program\nEnter your choice: "
error_message: .asciiz "Invalid choice. Please select a valid option.\n"
number1_prompt: .asciiz "Please enter number 1 (Integer between -2,147,483,648 and +2,147,483,647): \n"
number2_prompt: .asciiz "Please enter number 2 (Integer between -2,147,483,648 and +2,147,483,647): \n"
number1_display: .asciiz "Number 1 is: \n"
number2_display: .asciiz "Number 2 is: \n"
SumNum1Num2_display: .asciiz "The sum of number 1 and number 2 is:  \n"
ProductNum1Num2_display: .asciiz "The product of number 1 and number 2 is: \n"
DivisionNum1Num2_display: .asciiz "Number 1 divided by number 2 is: \n"
DivisionError_message: .asciiz "Number 1 cannot be divided by 0 \n"
DisplayRangeEnd_NewLine: .asciiz "\n"
DisplayRange_Comma: .asciiz ","
DisplayRange_display: .asciiz "Numbers between number 1 and number 2: \n"
SumRange_display: .asciiz "The sum of numbers between number 1 and number 2 is: \n"
Power_display: .asciiz "Number 1 to the power of number 2 is: \n"
Primes_NewLine: .asciiz "\n"






#In the text section this is where the actual instructions are written that the arithmetic logic unit will perform 
# the below instructions after they are decoded 
.text
main:
    # Initialize num1 and num2 to 0
    li $t0, 0
    li $t1, 0

menu:
    # Display the main menu
    li $v0, 4						# Loading a 4 into the $v0 register instructs the assembler to print the string - the string is a label and started by "ascii" to indicate to the assembler that this is what it should be translated to" 
    la $a0, menu_prompt				# As above, loads the address location of "menu_prompt" into the register 
    syscall							# With the instruction in "$v0" indicating that a print is required, and the string in address, syscall causes this to execute and output the label contents"

    # Read user input
    li $v0, 5
    syscall
    move $t2, $v0					#$t0 and $t1 temporary registers are taken up so we have to use the next one in line to take the users input 

    # Check user's choice and match against the label which will then find the relevant function and begin executing this. This is done through beq 
    beq $t2, 1, enter_num1								
    beq $t2, 2, enter_num2
    beq $t2, 3, display_nums
    beq $t2, 4, display_sum
    beq $t2, 5, display_product
    beq $t2, 6, divide_numbers
    beq $t2, 7, exchange_numbers
    beq $t2, 8, display_range
    beq $t2, 9, sum_range
    beq $t2, 10, power
    beq $t2, 11, display_primes
    beq $t2, 12, exit_program

    # Invalid choice
    li $v0, 4
    la $a0, error_message
    syscall
    j menu
#**************************************** OPTION 1 - ENTER FIRST NUMBER ********************************************************************************
enter_num1:
    # Prompt for and read num1
    li $v0, 4
    la $a0, number1_prompt
    syscall
    li $v0, 5							
    # 5 instruction used to take the user input, syscall executed beforehand to execute the prompt, clear the register and then ask user 
    syscall
    move $t0, $v0
    j menu
#**************************************** OPTION 2 - ENTER SECOND NUMBER *****************************************************************************
enter_num2:
    # Prompt for and read num2
    li $v0, 4
    la $a0, number2_prompt
    syscall
    li $v0, 5
    syscall
    move $t1, $v0
    j menu
#**************************************** OPTION 3 - DISPLAY FIRST NUMBER AND SECOND NUMBER *****************************************************************************
display_nums:
    # Display num1 and num2
    li $v0, 4
    la $a0, number1_display
    syscall
    li $v0, 1
    move $a0, $t0
    syscall
    li $v0, 4
    la $a0, number2_display
    syscall
    li $v0, 1
    move $a0, $t1
    syscall
    j menu
#***************************************** OPTION 4 - DISPLAY SUM OF BOTH NUMBERS *****************************************************************************
display_sum:
    # Display the sum of num1 and num2
    add $t3, $t0, $t1
    li $v0, 4
    la $a0, SumNum1Num2_display
    syscall
    li $v0, 1
    move $a0, $t3
    syscall
    j menu
#***************************************** OPTION 5 - DISPLAY MULTIPILICATION OF BOTH NUMEBERS *****************************************************************************
display_product:
    # Display the product of num1 and num2 #Product result must not be exponential 
    mul $t3, $t0, $t1
    li $v0, 4
    la $a0, ProductNum1Num2_display
    syscall
    li $v0, 1
    move $a0, $t3
    syscall
    j menu
#***************************************** OPTION 6 - DISPLAY DIVISION RESULT OF BOTH NUMBERS *****************************************************************************
divide_numbers:
    # Check if num2 is not zero and result must not be decimal 
    beqz $t1, division_error

    # Divide num1 by num2
    div $t0, $t1
    mflo $t3  # Quotient

    # Display the result
    li $v0, 4
    la $a0, DivisionNum1Num2_display
    syscall
    li $v0, 1
    move $a0, $t3
    syscall
    j menu

division_error:
    # Handle division by zero error
    li $v0, 4
    la $a0, DivisionError_message
    syscall
    j menu
#****************************************** OPTION 7 - EXCHANGE POSITION OF NUM1 AND NUM2 *****************************************************************************
exchange_numbers:
    # Exchange the values of num1 and num2
    move $t4, $t0
    move $t0, $t1
    move $t1, $t4
    j menu
#****************************************** OPTION 8 - DISPLAY NUMBERS IN RANGE OF BOTH NUMBERS *****************************************************************************
display_range:
    # Check if num1 is greater than num2 - Other words, num2 must be larger than num1 
    bgt $t0, $t1, display_range_end

    # Loop to display numbers
    li $v0, 4
    la $a0, DisplayRange_display
    syscall

display_range_loop:
    # Display the current number (num1)
    li $v0, 1
    move $a0, $t0
    syscall

    # Display a comma and space unless it's the last number
    addi $t0, $t0, 1  # Increment num1
    beq $t0, $t1, display_range_end  # If num1 == num2, exit the loop

    li $v0, 4
    la $a0, DisplayRange_Comma
    syscall

    # Repeat the loop
    j display_range_loop

display_range_end:
    # Display a newline and return to the main menu
    li $v0, 4
    la $a0, DisplayRangeEnd_NewLine
    syscall
    j menu
#******************************************** OPTION 9 - DISPLAY SUM OF INTEGERS IN RANGE OF BOTH NUMBERS  *****************************************************************************
sum_range:
    # Sum numbers between num1 and num2
    # Initialize sum to 0
    li $t3, 0

    # Check if num1 is greater than num2
    bgt $t0, $t1, sum_range_end

    # Loop to sum numbers
sum_range_loop:
    # Add the current number (num1) to the sum
    add $t3, $t3, $t0

    # Increment num1
    addi $t0, $t0, 1

    # Check if num1 <= num2 - there is a limitation here couldn't figure out how to cycle through based
    # on the difference. Would take num 1 from num 2 and increment num 1 and add that many times 
    ble $t0, $t1, sum_range_loop

sum_range_end:
    # Display the sum
    li $v0, 4
    la $a0, SumRange_display
    syscall

    li $v0, 1
    move $a0, $t3
    syscall

    # Return to the main menu
    j menu
#******************************************** OPTION 10 - DISPLAY RESULT OF FIRST NUMBER TO THE POWER OF SECOND NUMBER *****************************************************************************
power:
    # Calculate num1 raised to the power of num2
    # (Assuming num2 is a non-negative integer)
    li $t3, 1         # Initialize result to 1

power_loop:
    # Multiply result by num1, num2 times
    mul $t3, $t3, $t0
    addi $t1, $t1, -1

    # Check if num2 is greater than 0
    bgtz $t1, power_loop

    # Display the result
    li $v0, 4
    la $a0, Power_display
    syscall

    li $v0, 1
    move $a0, $t3
    syscall

    # Return to the main menu
    j menu
#******************************************* OPTION 11 - DISPLAY PRIME NUMBERS BETWEEN FIRST NUMBER AND SECOND NUMBER *****************************************************************************
display_primes:
    # Display prime numbers between num1 and num2
    move $t4, $t0     # Copy num1 to t4 (start of range)
    move $t5, $t1     # Copy num2 to t5 (end of range)

    # Ensure t4 is odd (even numbers greater than 2 cannot be prime)
    addi $t4, $t4, 1
    bnez $t4, display_primes_start  # Skip if t4 becomes zero

    addi $t4, $t4, 1

display_primes_start:
    # Check if t4 is greater than t5
    bgt $t4, $t5, display_primes_end

    # Check if t4 is prime
    jal is_prime

    # If t4 is prime, display it
    beqz $v0, display_primes_continue
    li $v0, 4
    move $a0, $t4
    syscall

display_primes_continue:
    # Increment t4 by 2 (skip even numbers)
    addi $t4, $t4, 2
    j display_primes_start

display_primes_end:
    # Display a newline and return to the main menu
    li $v0, 4
    la $a0, Primes_NewLine
    syscall
    j menu

# Function to check if a number is prime (1 if prime, 0 if not)
is_prime:
    move $t6, $t4         # Copy t4 (number to check) to t6
    li $t7, 2             # Initialize t7 (divisor) to 2

    beq $t6, $zero, is_prime_not_prime  # 0 and 1 are not prime

is_prime_loop:
#Unsure what to put here 

is_prime_not_prime:
    # t6 is not prime
    li $v0, 0


#****************************************** OPTION 12 - EXIT PROGRAM *****************************************************************************
exit_program:
    # Exit the program
    li $v0, 10 #Loading 10 into the register and syscalling ends the program 
    syscall