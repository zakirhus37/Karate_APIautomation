Feature:

  #GET Method
  Scenario Outline: Send a GET request to GetBookingIds endpoint and validate the API response
    Given I have query parameter<first_name>
    When I make GET request to the "GetBookingIds" endpoint
    Then response status code is 200 and status message is "OK"
    And Validate the json response
    Examples:
      | first_name   |
      | David        |
      | Robert       |

  #POST Method
  Scenario: Create a new bookingId using POST request
    Given I have request headers
    | Content-Type | application/json |
    | Accept       | application/json |
    And I make "GET" request to "GetBookingIds" end point
    When a POST request is sent with the JSON body "jsonbody"
    Then response status code is 201 and status message is "OK"
    And the response body should contain the created resource details

  #PUT Method
  Scenario Outline: Updates an existing resource for the bookingID- <Booking_Id>
    Given I have request headers
    | Content-Type | application/json |
    | Accept       | application/json |
    | Cookie       | token=abc123     |
    And I have path parameter of existing resource<Booking_Id>
    When a PUT request is sent with JSON"json_Body"
    Then response status code is 200 and status message is "OK"
    And the response body should contain the updated resource details
    Examples:
    |Booking_Id |
    | 7         |
    | 12        |

  #PATCH Method
  Scenario Outline: Update a resource with PATCH request for the Booking ID- <Booking_Id>
    Given I have request headers
    | Content-Type | application/json |
    | Accept       | application/json |
    | Cookie       | token=abc123     |
    And I have path parameter of existing resource<Booking_Id>
    When a PATCH request is sent with JSON"json_Body"
    Then response status code is 200 and status message is "OK"
    And the response body should contain the updated resource details
    Examples:
      |Booking_Id |
      | 4         |
      | 6         |

  Scenario Outline: DELETE an existing resource
    Given I have request headers
    | Content-Type | application/json |
    | Accept       | application/json |
    | Cookie       | token=abc123     |
    And I have path parameter of existing resource<Booking_Id>
    When a DELETE request is sent
    Then response status code is 204 and status message is "OK"
    And the resource should no longer exist
    Examples:
      |Booking_Id |
      | 4         |
      | 6         |

  #Negative Scenarios: BAD Request
  Scenario: User tries to create a resource with invalid data
    Given I have request headers
    | Content-Type | application/json |
    | Accept       | application/json |
    And I make "GET" request to "GetBookingIds" end point
    When a POST request is sent with invalid JSON body
    Then the response status code should be 400
    And the response body should contain an error message

  #Negative Scenarios: UnaAuthorised request
  Scenario: User tries to update a resource with invalid authorization
    Given I make "GET" request to "GetBookingIds" end point
    And I have path parameter of existing resource"Booking_Id"
    And an invalid authorization token in the request header
    When a PUT request is sent with JSON"json_Body"
    Then the response status code should be 401
    And the response body should contain an error message

  #Negative Scenarios: 404 Not Found
  Scenario: User tries to update non-existent resource
    Given I make "GET" request to "GetBookingIds" end point
    And a non-existent resource ID "499"
    When a PATCH request is sent with JSON"json_Body"
    Then the response status code should be 404
    And the response body should contain an error message