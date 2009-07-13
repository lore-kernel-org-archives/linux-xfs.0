Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6DMnWLg073516
	for <linux-xfs@oss.sgi.com>; Mon, 13 Jul 2009 17:49:37 -0500
Received: from ciao.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D08B2130AD0E
	for <linux-xfs@oss.sgi.com>; Mon, 13 Jul 2009 15:57:34 -0700 (PDT)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2]) by cuda.sgi.com
	with ESMTP id IdElHVMz4emEGZdM for <linux-xfs@oss.sgi.com>;
	Mon, 13 Jul 2009 15:57:34 -0700 (PDT)
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1MQULS-0003LH-RF
	for linux-xfs@oss.sgi.com; Mon, 13 Jul 2009 22:50:02 +0000
Received: from adsl-75-61-228-198.dsl.chcgil.sbcglobal.net ([75.61.228.198])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 13 Jul 2009 22:50:02 +0000
Received: from kononov by adsl-75-61-228-198.dsl.chcgil.sbcglobal.net with
	local (Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 13 Jul 2009 22:50:02 +0000
From: Roman Kononov <kononov@ftml.net>
Subject: failed assertion related to realtime section
Date: Mon, 13 Jul 2009 17:42:43 -0500
Message-ID: <h3gd94$clb$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000202060108050003020206"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------000202060108050003020206
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

In 2.6.30.x Linux kernel, the XFS_RT configuration option does not say "This 
feature is unsupported at this time..." any more. Nevertheless, when 
enabled, the feature crashes the file system in my setup. Is it expected to 
be functional?

The attached assertion log happens every time with a clean and empty file 
system.

Thanks,

Roman Kononov

--------------000202060108050003020206
Content-Type: text/plain;
 name="rt-assertion.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rt-assertion.txt"

QXNzZXJ0aW9uIGZhaWxlZDogeGZzX3RyYW5zX2dldF9ibG9ja19yZXModHApID4gMCwgZmls
ZTogL2hvbWUvc3R1ZmYvYmFzZS9saW51eC0yLjYuMzAuMS9mcy94ZnMveGZzX2JtYXAuYywg
bGluZTogNTYwMgotLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0Ka2VybmVs
IEJVRyBhdCAvaG9tZS9zdHVmZi9iYXNlL2xpbnV4LTIuNi4zMC4xL2ZzL3hmcy9zdXBwb3J0
L2RlYnVnLmM6MTA5IQppbnZhbGlkIG9wY29kZTogMDAwMCBbIzFdIFNNUApsYXN0IHN5c2Zz
IGZpbGU6IC9zeXMvZGV2aWNlcy9wY2kwMDAwOjAwLzAwMDA6MDA6MDEuMS9pMmMtYWRhcHRl
ci9pMmMtMS8xLTAwMmUvdnJtCkNQVSAwCk1vZHVsZXMgbGlua2VkIGluOiBpYl9tdGhjYSBz
YXRhX252ClBpZDogMTM5MiwgY29tbTogcHMgTm90IHRhaW50ZWQgMi42LjMwLjEgIzUKUklQ
OiAwMDEwOls8ZmZmZmZmZmY4MDM5ZjlkYT5dICBbPGZmZmZmZmZmODAzOWY5ZGE+XSBhc3Nm
YWlsKzB4MWEvMHgyMApSU1A6IDAwMTg6ZmZmZjg4MDBhMjA3YmJlOCAgRUZMQUdTOiAwMDAx
MDI5MgpSQVg6IDAwMDAwMDAwMDAwMDAwN2EgUkJYOiAwMDAwMDAwMDAwMDAxZmZmIFJDWDog
MDAwMDAwMDAwMDAwMDAwMApSRFg6IGZmZmY4ODAwMjgwMjIwMDAgUlNJOiAwMDAwMDAwMDAw
MDAwMDQ2IFJESTogZmZmZmZmZmY4MDcxYTg1NApSQlA6IDAwMDAwMDAwMDAwMDAwMDEgUjA4
OiAwMDAwMDAwMDAwMDAwMDAwIFIwOTogMDAwMDAwMDAwMDAwMDAwMgpSMTA6IDAwMDAwMDAw
MDAwMDAwMDAgUjExOiBmZmZmZmZmZjgwM2NmZGEwIFIxMjogZmZmZjg4MDBhYTI5NmYwMApS
MTM6IGZmZmY4ODAwYWEyOTZmMzggUjE0OiBmZmZmODgwMGFhMjk2ZjU4IFIxNTogZmZmZjg4
MDEzYWMxZjAwMApGUzogIDAwMDA3Zjg2MzE4MzE2ZTAoMDAwMCkgR1M6ZmZmZjg4MDAyODAy
MjAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwCkNTOiAgMDAxMCBEUzogMDAwMCBF
UzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMKQ1IyOiAwMDAwN2Y4NjJmODBmMDAwIENS
MzogMDAwMDAwMDAwMDIwMTAwMCBDUjQ6IDAwMDAwMDAwMDAwMDA2ZTAKRFIwOiAwMDAwMDAw
MDAwMDAwMDAwIERSMTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwMDAwMDAwMDAK
RFIzOiAwMDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDBmZmZmMGZmMCBEUjc6IDAwMDAw
MDAwMDAwMDA0MDAKUHJvY2VzcyBwcyAocGlkOiAxMzkyLCB0aHJlYWRpbmZvIGZmZmY4ODAw
YTIwN2EwMDAsIHRhc2sgZmZmZjg4MDA5ODhmYzAwMCkKU3RhY2s6CiAwMDA4MDAwMDAwMDAw
MDAwIGZmZmZmZmZmODAzNDVlOWMgZmZmZjg4MDBhMjA3YmM0OCBmZmZmODgwMGEyMDdiY2M4
CiBmZmZmODgwMGFhMjk3MWIwIDAwMDAwMDAwMDAwMDAwMGUgMDAwMDAwMDAwMDAwMDAwMSAw
MDAwMDAwMDAwMDAwMDI0CiAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDIgMDAw
MDAwMDAwMDAwMDAwMSBmZmZmODgwMGEwNGVkMzUwCkNhbGwgVHJhY2U6CiBbPGZmZmZmZmZm
ODAzNDVlOWM+XSA/IHhmc19idW5tYXBpKzB4YzVjLzB4MTFlMAogWzxmZmZmZmZmZjgwMzZk
ZDUwPl0gPyB4ZnNfaXRydW5jYXRlX2ZpbmlzaCsweDJiMC8weDVkMAogWzxmZmZmZmZmZjgw
MzhlYWUxPl0gPyB4ZnNfZnJlZV9lb2ZibG9ja3MrMHgyNzEvMHgyYzAKIFs8ZmZmZmZmZmY4
MDM5NmY1MD5dID8geGZzX2ZpbGVfcmVsZWFzZSsweDEwLzB4MjAKIFs8ZmZmZmZmZmY4MDI5
ZWQyMj5dID8gX19mcHV0KzB4YzIvMHgyMTAKIFs8ZmZmZmZmZmY4MDI5YjhkNj5dID8gZmls
cF9jbG9zZSsweDU2LzB4OTAKIFs8ZmZmZmZmZmY4MDIzYTdmNj5dID8gcHV0X2ZpbGVzX3N0
cnVjdCsweDc2LzB4ZjAKIFs8ZmZmZmZmZmY4MDIzYzU2MD5dID8gZG9fZXhpdCsweDY3MC8w
eDZlMAogWzxmZmZmZmZmZjgwMjllMzJlPl0gPyB2ZnNfd3JpdGUrMHgxMWUvMHgxNzAKIFs8
ZmZmZmZmZmY4MDIzYzYxNT5dID8gZG9fZ3JvdXBfZXhpdCsweDQ1LzB4YjAKIFs8ZmZmZmZm
ZmY4MDIzYzY5Mj5dID8gc3lzX2V4aXRfZ3JvdXArMHgxMi8weDIwCiBbPGZmZmZmZmZmODAy
MGJkZWI+XSA/IHN5c3RlbV9jYWxsX2Zhc3RwYXRoKzB4MTYvMHgxYgpDb2RlOiAwOCAwMSAw
MCAwMCAwMCBlOCAyNyAxOSAwMyAwMCA0OCA4MyBjNCAxOCBjMyA2NiA5MCA4OSBkMSA0OCA4
MyBlYyAwOCA0OCA4OSBmMiAzMSBjMCA0OCA4OSBmZSA0OCBjNyBjNyBlOCBkOSA1ZSA4MCBl
OCAwNiBjNyAxYSAwMCA8MGY+IDBiIGViIGZlIDY2IDkwIDQ4IDgzIGVjIDI4IDQ4IDg5IDFj
IDI0IDRjIDg5IDZjIDI0IDE4IDg5IGZiClJJUCAgWzxmZmZmZmZmZjgwMzlmOWRhPl0gYXNz
ZmFpbCsweDFhLzB4MjAKIFJTUCA8ZmZmZjg4MDBhMjA3YmJlOD4KLS0tWyBlbmQgdHJhY2Ug
OTc1NjBjNTg0OGRlNTZhYiBdLS0tCkZpeGluZyByZWN1cnNpdmUgZmF1bHQgYnV0IHJlYm9v
dCBpcyBuZWVkZWQhCg==
--------------000202060108050003020206
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------000202060108050003020206--
