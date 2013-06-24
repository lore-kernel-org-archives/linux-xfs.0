Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 764F57F37
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 11:45:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 36F228F804C
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 09:45:13 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id TfZUSKOu81TRWVRC (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Jun 2013 09:45:11 -0700 (PDT)
Subject: Bug#713994: XFS repair
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.713994.B713994.137209224218430@bugs.debian.org>
MIME-Version: 1.0
Date: Mon, 24 Jun 2013 12:43:55 -0400
Message-ID: <CAMjbrKp164a2CU2SPn94NGP+urwKUCtGz2vKyt6snSWaYdHebA@mail.gmail.com>
From: Wes Deviers <yhetti@gmail.com>
Reply-To: Wes Deviers <yhetti@gmail.com>, 713994@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4666400498623172813=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: 713994@bugs.debian.org

--===============4666400498623172813==
Content-Type: multipart/alternative; boundary=047d7bd76db04c669204dfe91ed7

--047d7bd76db04c669204dfe91ed7
Content-Type: text/plain; charset=ISO-8859-1

Update:

xfs_repair has fixed the problem:

root@ashdbtrk-s008-02:/home/wdeviers# xfs_check /dev/vg0/mysql
agf_freeblks 327676, counted 655100 in ag 4
agf_longest 327676, counted 655100 in ag 4
block 12/1 expected type unknown got btbno
block 12/4 expected type unknown got free2
...
block 12/45268 expected type unknown got free2
block 12/45269 expected type unknown got free2
block 12/45270 expected type unknown got free2
block 12/45271 expected type unknown got free2
block 12/45272 expected type unknown got free2
block 12/45273 expected type unknown got free2
block 12/45274 expected type unknown got free2
block 12/45275 expected type unknown got free2

root@ashdbtrk-s008-02:/home/wdeviers# xfs_repair /dev/vg0/mysql
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
primary/secondary superblock 4 conflict - AG superblock geometry info
conflicts with filesystem geometry
bad sequence # 12 for agf 4
bad length 327680 for agf 4, should be 655104
bad sequence # 12 for agi 4
bad length # 327680 for agi 4, should be 655104
reset bad sb for ag 4
reset bad agf for ag 4
reset bad agi for ag 4
sb_fdblocks 28836636, counted 28509212
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
        - agno = 39
        - agno = 40
        - agno = 41
        - agno = 42
        - agno = 43
        - agno = 44
        - agno = 45
        - agno = 46
        - agno = 47
        - agno = 48
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
        - agno = 39
        - agno = 40
        - agno = 41
        - agno = 42
        - agno = 43
        - agno = 44
        - agno = 45
        - agno = 46
        - agno = 47
        - agno = 48
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done


Thanks!

Wes

--047d7bd76db04c669204dfe91ed7
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+PGRpdj48ZGl2PjxkaXY+VXBkYXRlOjxicj48YnI+PC9kaXY+eGZzX3Jl
cGFpciBoYXMgZml4ZWQgdGhlIHByb2JsZW06PGJyPjxicj5yb290QGFzaGRidHJrLXMwMDgtMDI6
L2hvbWUvd2RldmllcnMjIHhmc19jaGVjayAvZGV2L3ZnMC9teXNxbCA8YnI+YWdmX2ZyZWVibGtz
IDMyNzY3NiwgY291bnRlZCA2NTUxMDAgaW4gYWcgNDxicj5hZ2ZfbG9uZ2VzdCAzMjc2NzYsIGNv
dW50ZWQgNjU1MTAwIGluIGFnIDQ8YnI+DQpibG9jayAxMi8xIGV4cGVjdGVkIHR5cGUgdW5rbm93
biBnb3QgYnRibm88YnI+YmxvY2sgMTIvNCBleHBlY3RlZCB0eXBlIHVua25vd24gZ290IGZyZWUy
PGJyPi4uLjxicj5ibG9jayAxMi80NTI2OCBleHBlY3RlZCB0eXBlIHVua25vd24gZ290IGZyZWUy
PGJyPmJsb2NrIDEyLzQ1MjY5IGV4cGVjdGVkIHR5cGUgdW5rbm93biBnb3QgZnJlZTI8YnI+Ymxv
Y2sgMTIvNDUyNzAgZXhwZWN0ZWQgdHlwZSB1bmtub3duIGdvdCBmcmVlMjxicj4NCmJsb2NrIDEy
LzQ1MjcxIGV4cGVjdGVkIHR5cGUgdW5rbm93biBnb3QgZnJlZTI8YnI+YmxvY2sgMTIvNDUyNzIg
ZXhwZWN0ZWQgdHlwZSB1bmtub3duIGdvdCBmcmVlMjxicj5ibG9jayAxMi80NTI3MyBleHBlY3Rl
ZCB0eXBlIHVua25vd24gZ290IGZyZWUyPGJyPmJsb2NrIDEyLzQ1Mjc0IGV4cGVjdGVkIHR5cGUg
dW5rbm93biBnb3QgZnJlZTI8YnI+YmxvY2sgMTIvNDUyNzUgZXhwZWN0ZWQgdHlwZSB1bmtub3du
IGdvdCBmcmVlMjxicj4NCjxicj5yb290QGFzaGRidHJrLXMwMDgtMDI6L2hvbWUvd2RldmllcnMj
IHhmc19yZXBhaXIgL2Rldi92ZzAvbXlzcWwgPGJyPlBoYXNlIDEgLSBmaW5kIGFuZCB2ZXJpZnkg
c3VwZXJibG9jay4uLjxicj5QaGFzZSAyIC0gdXNpbmcgaW50ZXJuYWwgbG9nPGJyPqCgoKCgoKAg
LSB6ZXJvIGxvZy4uLjxicj6goKCgoKCgIC0gc2NhbiBmaWxlc3lzdGVtIGZyZWVzcGFjZSBhbmQg
aW5vZGUgbWFwcy4uLjxicj4NCnByaW1hcnkvc2Vjb25kYXJ5IHN1cGVyYmxvY2sgNCBjb25mbGlj
dCAtIEFHIHN1cGVyYmxvY2sgZ2VvbWV0cnkgaW5mbyBjb25mbGljdHMgd2l0aCBmaWxlc3lzdGVt
IGdlb21ldHJ5PGJyPmJhZCBzZXF1ZW5jZSAjIDEyIGZvciBhZ2YgNDxicj5iYWQgbGVuZ3RoIDMy
NzY4MCBmb3IgYWdmIDQsIHNob3VsZCBiZSA2NTUxMDQ8YnI+YmFkIHNlcXVlbmNlICMgMTIgZm9y
IGFnaSA0PGJyPmJhZCBsZW5ndGggIyAzMjc2ODAgZm9yIGFnaSA0LCBzaG91bGQgYmUgNjU1MTA0
PGJyPg0KcmVzZXQgYmFkIHNiIGZvciBhZyA0PGJyPnJlc2V0IGJhZCBhZ2YgZm9yIGFnIDQ8YnI+
cmVzZXQgYmFkIGFnaSBmb3IgYWcgNDxicj5zYl9mZGJsb2NrcyAyODgzNjYzNiwgY291bnRlZCAy
ODUwOTIxMjxicj6goKCgoKCgIC0gZm91bmQgcm9vdCBpbm9kZSBjaHVuazxicj5QaGFzZSAzIC0g
Zm9yIGVhY2ggQUcuLi48YnI+oKCgoKCgoCAtIHNjYW4gYW5kIGNsZWFyIGFnaSB1bmxpbmtlZCBs
aXN0cy4uLjxicj4NCqCgoKCgoKAgLSBwcm9jZXNzIGtub3duIGlub2RlcyBhbmQgcGVyZm9ybSBp
bm9kZSBkaXNjb3ZlcnkuLi48YnI+oKCgoKCgoCAtIGFnbm8gPSAwPGJyPqCgoKCgoKAgLSBhZ25v
ID0gMTxicj6goKCgoKCgIC0gYWdubyA9IDI8YnI+oKCgoKCgoCAtIGFnbm8gPSAzPGJyPqCgoKCg
oKAgLSBhZ25vID0gNDxicj6goKCgoKCgIC0gYWdubyA9IDU8YnI+oKCgoKCgoCAtIGFnbm8gPSA2
PGJyPqCgoKCgoKAgLSBhZ25vID0gNzxicj4NCqCgoKCgoKAgLSBhZ25vID0gODxicj6goKCgoKCg
IC0gYWdubyA9IDk8YnI+oKCgoKCgoCAtIGFnbm8gPSAxMDxicj6goKCgoKCgIC0gYWdubyA9IDEx
PGJyPqCgoKCgoKAgLSBhZ25vID0gMTI8YnI+oKCgoKCgoCAtIGFnbm8gPSAxMzxicj6goKCgoKCg
IC0gYWdubyA9IDE0PGJyPqCgoKCgoKAgLSBhZ25vID0gMTU8YnI+oKCgoKCgoCAtIGFnbm8gPSAx
Njxicj6goKCgoKCgIC0gYWdubyA9IDE3PGJyPg0KoKCgoKCgoCAtIGFnbm8gPSAxODxicj6goKCg
oKCgIC0gYWdubyA9IDE5PGJyPqCgoKCgoKAgLSBhZ25vID0gMjA8YnI+oKCgoKCgoCAtIGFnbm8g
PSAyMTxicj6goKCgoKCgIC0gYWdubyA9IDIyPGJyPqCgoKCgoKAgLSBhZ25vID0gMjM8YnI+oKCg
oKCgoCAtIGFnbm8gPSAyNDxicj6goKCgoKCgIC0gYWdubyA9IDI1PGJyPqCgoKCgoKAgLSBhZ25v
ID0gMjY8YnI+oKCgoKCgoCAtIGFnbm8gPSAyNzxicj4NCqCgoKCgoKAgLSBhZ25vID0gMjg8YnI+
oKCgoKCgoCAtIGFnbm8gPSAyOTxicj6goKCgoKCgIC0gYWdubyA9IDMwPGJyPqCgoKCgoKAgLSBh
Z25vID0gMzE8YnI+oKCgoKCgoCAtIGFnbm8gPSAzMjxicj6goKCgoKCgIC0gYWdubyA9IDMzPGJy
PqCgoKCgoKAgLSBhZ25vID0gMzQ8YnI+oKCgoKCgoCAtIGFnbm8gPSAzNTxicj6goKCgoKCgIC0g
YWdubyA9IDM2PGJyPqCgoKCgoKAgLSBhZ25vID0gMzc8YnI+DQqgoKCgoKCgIC0gYWdubyA9IDM4
PGJyPqCgoKCgoKAgLSBhZ25vID0gMzk8YnI+oKCgoKCgoCAtIGFnbm8gPSA0MDxicj6goKCgoKCg
IC0gYWdubyA9IDQxPGJyPqCgoKCgoKAgLSBhZ25vID0gNDI8YnI+oKCgoKCgoCAtIGFnbm8gPSA0
Mzxicj6goKCgoKCgIC0gYWdubyA9IDQ0PGJyPqCgoKCgoKAgLSBhZ25vID0gNDU8YnI+oKCgoKCg
oCAtIGFnbm8gPSA0Njxicj6goKCgoKCgIC0gYWdubyA9IDQ3PGJyPg0KoKCgoKCgoCAtIGFnbm8g
PSA0ODxicj6goKCgoKCgIC0gcHJvY2VzcyBuZXdseSBkaXNjb3ZlcmVkIGlub2Rlcy4uLjxicj5Q
aGFzZSA0IC0gY2hlY2sgZm9yIGR1cGxpY2F0ZSBibG9ja3MuLi48YnI+oKCgoKCgoCAtIHNldHRp
bmcgdXAgZHVwbGljYXRlIGV4dGVudCBsaXN0Li4uPGJyPqCgoKCgoKAgLSBjaGVjayBmb3IgaW5v
ZGVzIGNsYWltaW5nIGR1cGxpY2F0ZSBibG9ja3MuLi48YnI+DQqgoKCgoKCgIC0gYWdubyA9IDA8
YnI+oKCgoKCgoCAtIGFnbm8gPSAxPGJyPqCgoKCgoKAgLSBhZ25vID0gMjxicj6goKCgoKCgIC0g
YWdubyA9IDM8YnI+oKCgoKCgoCAtIGFnbm8gPSA0PGJyPqCgoKCgoKAgLSBhZ25vID0gNTxicj6g
oKCgoKCgIC0gYWdubyA9IDY8YnI+oKCgoKCgoCAtIGFnbm8gPSA3PGJyPqCgoKCgoKAgLSBhZ25v
ID0gODxicj6goKCgoKCgIC0gYWdubyA9IDk8YnI+oKCgoKCgoCAtIGFnbm8gPSAxMDxicj4NCqCg
oKCgoKAgLSBhZ25vID0gMTE8YnI+oKCgoKCgoCAtIGFnbm8gPSAxMjxicj6goKCgoKCgIC0gYWdu
byA9IDEzPGJyPqCgoKCgoKAgLSBhZ25vID0gMTQ8YnI+oKCgoKCgoCAtIGFnbm8gPSAxNTxicj6g
oKCgoKCgIC0gYWdubyA9IDE2PGJyPqCgoKCgoKAgLSBhZ25vID0gMTc8YnI+oKCgoKCgoCAtIGFn
bm8gPSAxODxicj6goKCgoKCgIC0gYWdubyA9IDE5PGJyPqCgoKCgoKAgLSBhZ25vID0gMjA8YnI+
DQqgoKCgoKCgIC0gYWdubyA9IDIxPGJyPqCgoKCgoKAgLSBhZ25vID0gMjI8YnI+oKCgoKCgoCAt
IGFnbm8gPSAyMzxicj6goKCgoKCgIC0gYWdubyA9IDI0PGJyPqCgoKCgoKAgLSBhZ25vID0gMjU8
YnI+oKCgoKCgoCAtIGFnbm8gPSAyNjxicj6goKCgoKCgIC0gYWdubyA9IDI3PGJyPqCgoKCgoKAg
LSBhZ25vID0gMjg8YnI+oKCgoKCgoCAtIGFnbm8gPSAyOTxicj6goKCgoKCgIC0gYWdubyA9IDMw
PGJyPg0KoKCgoKCgoCAtIGFnbm8gPSAzMTxicj6goKCgoKCgIC0gYWdubyA9IDMyPGJyPqCgoKCg
oKAgLSBhZ25vID0gMzM8YnI+oKCgoKCgoCAtIGFnbm8gPSAzNDxicj6goKCgoKCgIC0gYWdubyA9
IDM1PGJyPqCgoKCgoKAgLSBhZ25vID0gMzY8YnI+oKCgoKCgoCAtIGFnbm8gPSAzNzxicj6goKCg
oKCgIC0gYWdubyA9IDM4PGJyPqCgoKCgoKAgLSBhZ25vID0gMzk8YnI+oKCgoKCgoCAtIGFnbm8g
PSA0MDxicj4NCqCgoKCgoKAgLSBhZ25vID0gNDE8YnI+oKCgoKCgoCAtIGFnbm8gPSA0Mjxicj6g
oKCgoKCgIC0gYWdubyA9IDQzPGJyPqCgoKCgoKAgLSBhZ25vID0gNDQ8YnI+oKCgoKCgoCAtIGFn
bm8gPSA0NTxicj6goKCgoKCgIC0gYWdubyA9IDQ2PGJyPqCgoKCgoKAgLSBhZ25vID0gNDc8YnI+
oKCgoKCgoCAtIGFnbm8gPSA0ODxicj5QaGFzZSA1IC0gcmVidWlsZCBBRyBoZWFkZXJzIGFuZCB0
cmVlcy4uLjxicj4NCqCgoKCgoKAgLSByZXNldCBzdXBlcmJsb2NrLi4uPGJyPlBoYXNlIDYgLSBj
aGVjayBpbm9kZSBjb25uZWN0aXZpdHkuLi48YnI+oKCgoKCgoCAtIHJlc2V0dGluZyBjb250ZW50
cyBvZiByZWFsdGltZSBiaXRtYXAgYW5kIHN1bW1hcnkgaW5vZGVzPGJyPqCgoKCgoKAgLSB0cmF2
ZXJzaW5nIGZpbGVzeXN0ZW0gLi4uPGJyPqCgoKCgoKAgLSB0cmF2ZXJzYWwgZmluaXNoZWQgLi4u
PGJyPqCgoKCgoKAgLSBtb3ZpbmcgZGlzY29ubmVjdGVkIGlub2RlcyB0byBsb3N0K2ZvdW5kIC4u
Ljxicj4NClBoYXNlIDcgLSB2ZXJpZnkgYW5kIGNvcnJlY3QgbGluayBjb3VudHMuLi48YnI+ZG9u
ZTxicj48YnI+PGJyPjwvZGl2PlRoYW5rcyE8YnI+PGJyPjwvZGl2Pldlczxicj48L2Rpdj4NCg==
--047d7bd76db04c669204dfe91ed7--


--===============4666400498623172813==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4666400498623172813==--
