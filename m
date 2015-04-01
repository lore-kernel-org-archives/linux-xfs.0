Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 252537F5A
	for <xfs@oss.sgi.com>; Wed,  1 Apr 2015 09:09:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 76624AC005
	for <xfs@oss.sgi.com>; Wed,  1 Apr 2015 07:09:15 -0700 (PDT)
Received: from mail-wg0-f47.google.com (mail-wg0-f47.google.com
	[74.125.82.47]) by cuda.sgi.com with ESMTP id 7gUPrSsR12aXtRKF
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Apr 2015 07:09:12 -0700 (PDT)
Received: by wgoe14 with SMTP id e14so54565107wgo.0
	for <xfs@oss.sgi.com>; Wed, 01 Apr 2015 07:09:11 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 1 Apr 2015 17:09:11 +0300
Message-ID: <CAC=x_0iFLbJwbKCKEe7XTKexex29wvbVQDvuN=SO5j9gX=u4rw@mail.gmail.com>
Subject: xfs corruption issue
From: Danny Shavit <danny@zadarastorage.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0504282425849346613=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>
Cc: Lev Vainblat <lev@zadarastorage.com>, Alex Lyakas <alex@zadarastorage.com>

--===============0504282425849346613==
Content-Type: multipart/alternative; boundary=001a11338f6c661fed0512aa42e9

--001a11338f6c661fed0512aa42e9
Content-Type: text/plain; charset=UTF-8

Hello Dave,
My name is Danny Shavit and I am with Zadara storage.
We will appreciate your feedback reagrding an xfs_corruption and xfs_reapir
issue.

We found a corrupted xfs volume in one of our systems. It is around 1 TB
size and about 12 M files.
We run xfs_repair on the volume which succeeded after 42 minutes.
We noticed that memory consumption raised to about 7.5 GB.
Since some customers are using only 4GB (and sometimes even 2 GB) we tried
running "xfs_repair -m 3200" on a 4GB RAM machine.
However, this time an OOM event happened during handling of AG 26 during
step 3.
The log of xfs_repair is enclosed below.
We will appreciate your feedback on the amount of memory needed for
xfs_repair in general and when using "-m" option specifically.
The xfs metadata dump (prior to xfs_repair) can be found here:
https://zadarastorage-public.s3.amazonaws.com/xfs/xfsdump-prod-ebs_2015-03-30_23-00-38.tgz
It is a 1.2 GB file (and 5.7 GB uncompressed).

We will appreciate your feedback on the corruption pattern as well.
-- 
Thank you,
Danny Shavit
Zadarastorage

---------- xfs_repair log  ----------------
root@vsa-00000428-vc-1:/export/4xfsdump# date; xfs_repair -v /dev/dm-55;
date
Tue Mar 31 02:28:04 PDT 2015
Phase 1 - find and verify superblock...
        - block cache size set to 735288 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 1920 tail block 1920
        - scan filesystem freespace and inode maps...
agi_freecount 54, counted 55 in ag 7
sb_ifree 947, counted 948
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
bad . entry in directory inode 5691013154, was 5691013170: correcting
bad . entry in directory inode 5691013156, was 5691013172: correcting
bad . entry in directory inode 5691013157, was 5691013173: correcting
bad . entry in directory inode 5691013163, was 5691013179: correcting
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26   (Danny: OOM occurred here with -m 3200)
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - agno = 32
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
Phase 5 - rebuild AG headers and trees...
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
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
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
entry "SavedXML" in dir inode 2992927241 inconsistent with .. value
(4324257659) in ino 5691013156
        will clear entry "SavedXML"
rebuilding directory inode 2992927241
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
entry "Out" in dir inode 4324257659 inconsistent with .. value (2992927241)
in ino 5691013172
        will clear entry "Out"
rebuilding directory inode 4324257659
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
entry "tocs_file" in dir inode 5691012138 inconsistent with .. value
(3520464676) in ino 5691013154
        will clear entry "tocs_file"
entry "trees.log" in dir inode 5691012138 inconsistent with .. value
(3791956240) in ino 5691013155
        will clear entry "trees.log"
rebuilding directory inode 5691012138
entry "filelist.xml" in directory inode 5691012139 not consistent with ..
value (1909707067) in inode 5691013157,
junking entry
fixing i8count in inode 5691012139
entry "image001.jpg" in directory inode 5691012140 not consistent with ..
value (2450176033) in inode 5691013163,
junking entry
fixing i8count in inode 5691012140
entry "OCR" in dir inode 5691013154 inconsistent with .. value (5691013170)
in ino 1909707065
        will clear entry "OCR"
entry "Tmp" in dir inode 5691013154 inconsistent with .. value (5691013170)
in ino 2179087403
        will clear entry "Tmp"
entry "images" in dir inode 5691013154 inconsistent with .. value
(5691013170) in ino 2450176007
        will clear entry "images"
rebuilding directory inode 5691013154
entry "286_Kellman_Hoffer_Master.pdf_files" in dir inode 5691013156
inconsistent with .. value (5691013172) in ino 834535727
        will clear entry "286_Kellman_Hoffer_Master.pdf_files"
rebuilding directory inode 5691013156
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
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected dir inode 834535727, moving to lost+found
disconnected dir inode 1909707065, moving to lost+found
disconnected dir inode 2179087403, moving to lost+found
disconnected dir inode 2450176007, moving to lost+found
disconnected dir inode 5691013154, moving to lost+found
disconnected dir inode 5691013155, moving to lost+found
disconnected dir inode 5691013156, moving to lost+found
disconnected dir inode 5691013157, moving to lost+found
disconnected dir inode 5691013163, moving to lost+found
disconnected dir inode 5691013172, moving to lost+found
Phase 7 - verify and correct link counts...
resetting inode 81777983 nlinks from 2 to 12
resetting inode 1909210410 nlinks from 1 to 2
resetting inode 1909707067 nlinks from 3 to 2
resetting inode 2450176033 nlinks from 18 to 17
resetting inode 2992927241 nlinks from 13 to 12
resetting inode 3520464676 nlinks from 13 to 12
resetting inode 3791956240 nlinks from 13 to 12
resetting inode 4324257659 nlinks from 13 to 12
resetting inode 5691013154 nlinks from 5 to 2
resetting inode 5691013156 nlinks from 3 to 2

        XFS_REPAIR Summary    Tue Mar 31 03:11:00 2015

Phase           Start           End             Duration
Phase 1:        03/31 02:28:04  03/31 02:28:05  1 second
Phase 2:        03/31 02:28:05  03/31 02:28:42  37 seconds
Phase 3:        03/31 02:28:42  03/31 02:48:29  19 minutes, 47 seconds
Phase 4:        03/31 02:48:29  03/31 02:55:40  7 minutes, 11 seconds
Phase 5:        03/31 02:55:40  03/31 02:55:43  3 seconds
Phase 6:        03/31 02:55:43  03/31 03:10:57  15 minutes, 14 seconds
Phase 7:        03/31 03:10:57  03/31 03:10:57

Total run time: 42 minutes, 53 seconds
done
Tue Mar 31 03:11:01 PDT 2015

--001a11338f6c661fed0512aa42e9
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+PGRpdj48ZGl2PjxkaXY+PGRpdj48ZGl2PjxkaXY+PGRpdj48ZGl2Pkhl
bGxvIERhdmUsPGJyPk15IG5hbWUgaXMgRGFubnkgU2hhdml0IGFuZCBJIGFtIHdpdGggWmFkYXJh
IHN0b3JhZ2UuPGJyPjwvZGl2PldlIHdpbGwgYXBwcmVjaWF0ZSB5b3VyIGZlZWRiYWNrIHJlYWdy
ZGluZyBhbiB4ZnNfY29ycnVwdGlvbiBhbmQgeGZzX3JlYXBpciBpc3N1ZS48YnI+PGJyPldlIGZv
dW5kIGEgY29ycnVwdGVkIHhmcyB2b2x1bWUgaW4gb25lIG9mIG91ciBzeXN0ZW1zLiBJdCBpcyBh
cm91bmQgMSBUQiBzaXplIGFuZCBhYm91dCAxMiBNIGZpbGVzLjxicj48L2Rpdj5XZSBydW4geGZz
X3JlcGFpciBvbiB0aGUgdm9sdW1lIHdoaWNoIHN1Y2NlZWRlZCBhZnRlciA0MiBtaW51dGVzLjxi
cj48L2Rpdj48ZGl2PldlIG5vdGljZWQgdGhhdCBtZW1vcnkgY29uc3VtcHRpb24gcmFpc2VkIHRv
IGFib3V0IDcuNSBHQi48YnI+PC9kaXY+PGRpdj5TaW5jZSBzb21lIGN1c3RvbWVycyBhcmUgdXNp
bmcgb25seSA0R0IgKGFuZCBzb21ldGltZXMgZXZlbiAyIEdCKSB3ZSB0cmllZCBydW5uaW5nICZx
dW90O3hmc19yZXBhaXIgLW0gMzIwMCZxdW90OyBvbiBhIDRHQiBSQU0gbWFjaGluZS4gPGJyPkhv
d2V2ZXIsIHRoaXMgdGltZSBhbiBPT00gZXZlbnQgaGFwcGVuZWQgZHVyaW5nIGhhbmRsaW5nIG9m
IEFHIDI2IGR1cmluZyBzdGVwIDMuPGJyPjwvZGl2PjwvZGl2PlRoZSBsb2cgb2YgeGZzX3JlcGFp
ciBpcyBlbmNsb3NlZCBiZWxvdy48YnI+PC9kaXY+V2Ugd2lsbCBhcHByZWNpYXRlIHlvdXIgZmVl
ZGJhY2sgb24gdGhlIGFtb3VudCBvZiBtZW1vcnkgbmVlZGVkIGZvciB4ZnNfcmVwYWlyIGluIGdl
bmVyYWwgYW5kIHdoZW4gdXNpbmcgJnF1b3Q7LW0mcXVvdDsgb3B0aW9uIHNwZWNpZmljYWxseS48
YnI+PC9kaXY+VGhlIHhmcyBtZXRhZGF0YSBkdW1wIChwcmlvciB0byB4ZnNfcmVwYWlyKSBjYW4g
YmUgZm91bmQgaGVyZTo8YnI+PGEgaHJlZj0iaHR0cHM6Ly96YWRhcmFzdG9yYWdlLXB1YmxpYy5z
My5hbWF6b25hd3MuY29tL3hmcy94ZnNkdW1wLXByb2QtZWJzXzIwMTUtMDMtMzBfMjMtMDAtMzgu
dGd6Ij5odHRwczovL3phZGFyYXN0b3JhZ2UtcHVibGljLnMzLmFtYXpvbmF3cy5jb20veGZzL3hm
c2R1bXAtcHJvZC1lYnNfMjAxNS0wMy0zMF8yMy0wMC0zOC50Z3o8L2E+PGJyPjwvZGl2Pkl0IGlz
IGEgMS4yIEdCIGZpbGUgKGFuZCA1LjcgR0IgdW5jb21wcmVzc2VkKS48YnI+PGJyPjwvZGl2Pldl
IHdpbGwgYXBwcmVjaWF0ZSB5b3VyIGZlZWRiYWNrIG9uIHRoZSBjb3JydXB0aW9uIHBhdHRlcm4g
YXMgd2VsbC48YnI+PGRpdj48ZGl2PjxkaXY+PGRpdj48ZGl2PjxkaXY+PGRpdj48ZGl2PjxkaXY+
PGRpdj4tLSA8YnI+PGRpdiBjbGFzcz0iZ21haWxfc2lnbmF0dXJlIj48ZGl2IGRpcj0ibHRyIj48
ZGl2PlRoYW5rIHlvdSw8YnI+PC9kaXY+RGFubnkgU2hhdml0PGJyPjwvZGl2PjxkaXY+WmFkYXJh
c3RvcmFnZTxicj48YnI+PC9kaXY+PGRpdj4tLS0tLS0tLS0tIHhmc19yZXBhaXIgbG9nwqAgLS0t
LS0tLS0tLS0tLS0tLTxicj5yb290QHZzYS0wMDAwMDQyOC12Yy0xOi9leHBvcnQvNHhmc2R1bXAj
IGRhdGU7IHhmc19yZXBhaXIgLXYgL2Rldi9kbS01NTsgZGF0ZcKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA8YnI+VHVl
IE1hciAzMSAwMjoyODowNCBQRFQgMjAxNTxicj5QaGFzZSAxIC0gZmluZCBhbmQgdmVyaWZ5IHN1
cGVyYmxvY2suLi48YnI+wqDCoMKgwqDCoMKgwqAgLSBibG9jayBjYWNoZSBzaXplIHNldCB0byA3
MzUyODggZW50cmllczxicj5QaGFzZSAyIC0gdXNpbmcgaW50ZXJuYWwgbG9nPGJyPsKgwqDCoMKg
wqDCoMKgIC0gemVybyBsb2cuLi48YnI+emVyb19sb2c6IGhlYWQgYmxvY2sgMTkyMCB0YWlsIGJs
b2NrIDE5MjA8YnI+wqDCoMKgwqDCoMKgwqAgLSBzY2FuIGZpbGVzeXN0ZW0gZnJlZXNwYWNlIGFu
ZCBpbm9kZSBtYXBzLi4uPGJyPmFnaV9mcmVlY291bnQgNTQsIGNvdW50ZWQgNTUgaW4gYWcgNzxi
cj5zYl9pZnJlZSA5NDcsIGNvdW50ZWQgOTQ4PGJyPsKgwqDCoMKgwqDCoMKgIC0gZm91bmQgcm9v
dCBpbm9kZSBjaHVuazxicj5QaGFzZSAzIC0gZm9yIGVhY2ggQUcuLi48YnI+wqDCoMKgwqDCoMKg
wqAgLSBzY2FuIGFuZCBjbGVhciBhZ2kgdW5saW5rZWQgbGlzdHMuLi48YnI+wqDCoMKgwqDCoMKg
wqAgLSBwcm9jZXNzIGtub3duIGlub2RlcyBhbmQgcGVyZm9ybSBpbm9kZSBkaXNjb3ZlcnkuLi48
YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMDxicj7CoMKgwqDCoMKgwqDCoCAtIGFnbm8gPSAx
PGJyPsKgwqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMjxicj7CoMKgwqDCoMKgwqDCoCAtIGFnbm8g
PSAzPGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDQ8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25v
ID0gNTxicj7CoMKgwqDCoMKgwqDCoCAtIGFnbm8gPSA2PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdu
byA9IDc8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gODxicj7CoMKgwqDCoMKgwqDCoCAtIGFn
bm8gPSA5PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDEwPGJyPsKgwqDCoMKgwqDCoMKgIC0g
YWdubyA9IDExPGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDEyPGJyPsKgwqDCoMKgwqDCoMKg
IC0gYWdubyA9IDEzPGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDE0PGJyPsKgwqDCoMKgwqDC
oMKgIC0gYWdubyA9IDE1PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDE2PGJyPsKgwqDCoMKg
wqDCoMKgIC0gYWdubyA9IDE3PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDE4PGJyPsKgwqDC
oMKgwqDCoMKgIC0gYWdubyA9IDE5PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDIwPGJyPsKg
wqDCoMKgwqDCoMKgIC0gYWdubyA9IDIxPGJyPmJhZCAuIGVudHJ5IGluIGRpcmVjdG9yeSBpbm9k
ZSA1NjkxMDEzMTU0LCB3YXMgNTY5MTAxMzE3MDogY29ycmVjdGluZzxicj5iYWQgLiBlbnRyeSBp
biBkaXJlY3RvcnkgaW5vZGUgNTY5MTAxMzE1Niwgd2FzIDU2OTEwMTMxNzI6IGNvcnJlY3Rpbmc8
YnI+YmFkIC4gZW50cnkgaW4gZGlyZWN0b3J5IGlub2RlIDU2OTEwMTMxNTcsIHdhcyA1NjkxMDEz
MTczOiBjb3JyZWN0aW5nPGJyPmJhZCAuIGVudHJ5IGluIGRpcmVjdG9yeSBpbm9kZSA1NjkxMDEz
MTYzLCB3YXMgNTY5MTAxMzE3OTogY29ycmVjdGluZzxicj7CoMKgwqDCoMKgwqDCoCAtIGFnbm8g
PSAyMjxicj7CoMKgwqDCoMKgwqDCoCAtIGFnbm8gPSAyMzxicj7CoMKgwqDCoMKgwqDCoCAtIGFn
bm8gPSAyNDxicj7CoMKgwqDCoMKgwqDCoCAtIGFnbm8gPSAyNTxicj7CoMKgwqDCoMKgwqDCoCAt
IGFnbm8gPSAyNsKgwqAgKERhbm55OiBPT00gb2NjdXJyZWQgaGVyZSB3aXRoIC1tIDMyMDApPGJy
PsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDI3PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDI4
PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDI5PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9
IDMwPGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDMxPGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdu
byA9IDMyPGJyPsKgwqDCoMKgwqDCoMKgIC0gcHJvY2VzcyBuZXdseSBkaXNjb3ZlcmVkIGlub2Rl
cy4uLjxicj5QaGFzZSA0IC0gY2hlY2sgZm9yIGR1cGxpY2F0ZSBibG9ja3MuLi48YnI+wqDCoMKg
wqDCoMKgwqAgLSBzZXR0aW5nIHVwIGR1cGxpY2F0ZSBleHRlbnQgbGlzdC4uLjxicj7CoMKgwqDC
oMKgwqDCoCAtIGNoZWNrIGZvciBpbm9kZXMgY2xhaW1pbmcgZHVwbGljYXRlIGJsb2Nrcy4uLjxi
cj7CoMKgwqDCoMKgwqDCoCAtIGFnbm8gPSAwPGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDE8
YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMjxicj7CoMKgwqDCoMKgwqDCoCAtIGFnbm8gPSAz
PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDQ8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0g
NTxicj7CoMKgwqDCoMKgwqDCoCAtIGFnbm8gPSA2PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9
IDc8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gODxicj7CoMKgwqDCoMKgwqDCoCAtIGFnbm8g
PSA5PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDEwPGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdu
byA9IDExPGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDEyPGJyPsKgwqDCoMKgwqDCoMKgIC0g
YWdubyA9IDEzPGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDE0PGJyPsKgwqDCoMKgwqDCoMKg
IC0gYWdubyA9IDE1PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDE2PGJyPsKgwqDCoMKgwqDC
oMKgIC0gYWdubyA9IDE3PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDE4PGJyPsKgwqDCoMKg
wqDCoMKgIC0gYWdubyA9IDE5PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDIwPGJyPsKgwqDC
oMKgwqDCoMKgIC0gYWdubyA9IDIxPGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDIyPGJyPsKg
wqDCoMKgwqDCoMKgIC0gYWdubyA9IDIzPGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDI0PGJy
PsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDI1PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDI2
PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDI3PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9
IDI4PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDI5PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdu
byA9IDMwPGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDMxPGJyPsKgwqDCoMKgwqDCoMKgIC0g
YWdubyA9IDMyPGJyPlBoYXNlIDUgLSByZWJ1aWxkIEFHIGhlYWRlcnMgYW5kIHRyZWVzLi4uPGJy
PsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDA8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMTxi
cj7CoMKgwqDCoMKgwqDCoCAtIGFnbm8gPSAyPGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDM8
YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gNDxicj7CoMKgwqDCoMKgwqDCoCAtIGFnbm8gPSA1
PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDY8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0g
Nzxicj7CoMKgwqDCoMKgwqDCoCAtIGFnbm8gPSA4PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9
IDk8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMTA8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25v
ID0gMTE8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMTI8YnI+wqDCoMKgwqDCoMKgwqAgLSBh
Z25vID0gMTM8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMTQ8YnI+wqDCoMKgwqDCoMKgwqAg
LSBhZ25vID0gMTU8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMTY8YnI+wqDCoMKgwqDCoMKg
wqAgLSBhZ25vID0gMTc8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMTg8YnI+wqDCoMKgwqDC
oMKgwqAgLSBhZ25vID0gMTk8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMjA8YnI+wqDCoMKg
wqDCoMKgwqAgLSBhZ25vID0gMjE8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMjI8YnI+wqDC
oMKgwqDCoMKgwqAgLSBhZ25vID0gMjM8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMjQ8YnI+
wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMjU8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMjY8
YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMjc8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0g
Mjg8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMjk8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25v
ID0gMzA8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMzE8YnI+wqDCoMKgwqDCoMKgwqAgLSBh
Z25vID0gMzI8YnI+wqDCoMKgwqDCoMKgwqAgLSByZXNldCBzdXBlcmJsb2NrLi4uPGJyPlBoYXNl
IDYgLSBjaGVjayBpbm9kZSBjb25uZWN0aXZpdHkuLi48YnI+wqDCoMKgwqDCoMKgwqAgLSByZXNl
dHRpbmcgY29udGVudHMgb2YgcmVhbHRpbWUgYml0bWFwIGFuZCBzdW1tYXJ5IGlub2Rlczxicj7C
oMKgwqDCoMKgwqDCoCAtIHRyYXZlcnNpbmcgZmlsZXN5c3RlbSAuLi48YnI+wqDCoMKgwqDCoMKg
wqAgLSBhZ25vID0gMDxicj7CoMKgwqDCoMKgwqDCoCAtIGFnbm8gPSAxPGJyPsKgwqDCoMKgwqDC
oMKgIC0gYWdubyA9IDI8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMzxicj7CoMKgwqDCoMKg
wqDCoCAtIGFnbm8gPSA0PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDU8YnI+wqDCoMKgwqDC
oMKgwqAgLSBhZ25vID0gNjxicj7CoMKgwqDCoMKgwqDCoCAtIGFnbm8gPSA3PGJyPsKgwqDCoMKg
wqDCoMKgIC0gYWdubyA9IDg8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gOTxicj7CoMKgwqDC
oMKgwqDCoCAtIGFnbm8gPSAxMDxicj7CoMKgwqDCoMKgwqDCoCAtIGFnbm8gPSAxMTxicj5lbnRy
eSAmcXVvdDtTYXZlZFhNTCZxdW90OyBpbiBkaXIgaW5vZGUgMjk5MjkyNzI0MSBpbmNvbnNpc3Rl
bnQgd2l0aCAuLiB2YWx1ZSAoNDMyNDI1NzY1OSkgaW4gaW5vIDU2OTEwMTMxNTY8YnI+wqDCoMKg
wqDCoMKgwqAgd2lsbCBjbGVhciBlbnRyeSAmcXVvdDtTYXZlZFhNTCZxdW90Ozxicj5yZWJ1aWxk
aW5nIGRpcmVjdG9yeSBpbm9kZSAyOTkyOTI3MjQxPGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9
IDEyPGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDEzPGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdu
byA9IDE0PGJyPsKgwqDCoMKgwqDCoMKgIC0gYWdubyA9IDE1PGJyPsKgwqDCoMKgwqDCoMKgIC0g
YWdubyA9IDE2PGJyPmVudHJ5ICZxdW90O091dCZxdW90OyBpbiBkaXIgaW5vZGUgNDMyNDI1NzY1
OSBpbmNvbnNpc3RlbnQgd2l0aCAuLiB2YWx1ZSAoMjk5MjkyNzI0MSkgaW4gaW5vIDU2OTEwMTMx
NzI8YnI+wqDCoMKgwqDCoMKgwqAgd2lsbCBjbGVhciBlbnRyeSAmcXVvdDtPdXQmcXVvdDs8YnI+
cmVidWlsZGluZyBkaXJlY3RvcnkgaW5vZGUgNDMyNDI1NzY1OTxicj7CoMKgwqDCoMKgwqDCoCAt
IGFnbm8gPSAxNzxicj7CoMKgwqDCoMKgwqDCoCAtIGFnbm8gPSAxODxicj7CoMKgwqDCoMKgwqDC
oCAtIGFnbm8gPSAxOTxicj7CoMKgwqDCoMKgwqDCoCAtIGFnbm8gPSAyMDxicj7CoMKgwqDCoMKg
wqDCoCAtIGFnbm8gPSAyMTxicj5lbnRyeSAmcXVvdDt0b2NzX2ZpbGUmcXVvdDsgaW4gZGlyIGlu
b2RlIDU2OTEwMTIxMzggaW5jb25zaXN0ZW50IHdpdGggLi4gdmFsdWUgKDM1MjA0NjQ2NzYpIGlu
IGlubyA1NjkxMDEzMTU0PGJyPsKgwqDCoMKgwqDCoMKgIHdpbGwgY2xlYXIgZW50cnkgJnF1b3Q7
dG9jc19maWxlJnF1b3Q7PGJyPmVudHJ5ICZxdW90O3RyZWVzLmxvZyZxdW90OyBpbiBkaXIgaW5v
ZGUgNTY5MTAxMjEzOCBpbmNvbnNpc3RlbnQgd2l0aCAuLiB2YWx1ZSAoMzc5MTk1NjI0MCkgaW4g
aW5vIDU2OTEwMTMxNTU8YnI+wqDCoMKgwqDCoMKgwqAgd2lsbCBjbGVhciBlbnRyeSAmcXVvdDt0
cmVlcy5sb2cmcXVvdDs8YnI+cmVidWlsZGluZyBkaXJlY3RvcnkgaW5vZGUgNTY5MTAxMjEzODxi
cj5lbnRyeSAmcXVvdDtmaWxlbGlzdC54bWwmcXVvdDsgaW4gZGlyZWN0b3J5IGlub2RlIDU2OTEw
MTIxMzkgbm90IGNvbnNpc3RlbnQgd2l0aCAuLiB2YWx1ZSAoMTkwOTcwNzA2NykgaW4gaW5vZGUg
NTY5MTAxMzE1Nyw8YnI+anVua2luZyBlbnRyeTxicj5maXhpbmcgaThjb3VudCBpbiBpbm9kZSA1
NjkxMDEyMTM5PGJyPmVudHJ5ICZxdW90O2ltYWdlMDAxLmpwZyZxdW90OyBpbiBkaXJlY3Rvcnkg
aW5vZGUgNTY5MTAxMjE0MCBub3QgY29uc2lzdGVudCB3aXRoIC4uIHZhbHVlICgyNDUwMTc2MDMz
KSBpbiBpbm9kZSA1NjkxMDEzMTYzLDxicj5qdW5raW5nIGVudHJ5PGJyPmZpeGluZyBpOGNvdW50
IGluIGlub2RlIDU2OTEwMTIxNDA8YnI+ZW50cnkgJnF1b3Q7T0NSJnF1b3Q7IGluIGRpciBpbm9k
ZSA1NjkxMDEzMTU0IGluY29uc2lzdGVudCB3aXRoIC4uIHZhbHVlICg1NjkxMDEzMTcwKSBpbiBp
bm8gMTkwOTcwNzA2NTxicj7CoMKgwqDCoMKgwqDCoCB3aWxsIGNsZWFyIGVudHJ5ICZxdW90O09D
UiZxdW90Ozxicj5lbnRyeSAmcXVvdDtUbXAmcXVvdDsgaW4gZGlyIGlub2RlIDU2OTEwMTMxNTQg
aW5jb25zaXN0ZW50IHdpdGggLi4gdmFsdWUgKDU2OTEwMTMxNzApIGluIGlubyAyMTc5MDg3NDAz
PGJyPsKgwqDCoMKgwqDCoMKgIHdpbGwgY2xlYXIgZW50cnkgJnF1b3Q7VG1wJnF1b3Q7PGJyPmVu
dHJ5ICZxdW90O2ltYWdlcyZxdW90OyBpbiBkaXIgaW5vZGUgNTY5MTAxMzE1NCBpbmNvbnNpc3Rl
bnQgd2l0aCAuLiB2YWx1ZSAoNTY5MTAxMzE3MCkgaW4gaW5vIDI0NTAxNzYwMDc8YnI+wqDCoMKg
wqDCoMKgwqAgd2lsbCBjbGVhciBlbnRyeSAmcXVvdDtpbWFnZXMmcXVvdDs8YnI+cmVidWlsZGlu
ZyBkaXJlY3RvcnkgaW5vZGUgNTY5MTAxMzE1NDxicj5lbnRyeSAmcXVvdDsyODZfS2VsbG1hbl9I
b2ZmZXJfTWFzdGVyLnBkZl9maWxlcyZxdW90OyBpbiBkaXIgaW5vZGUgNTY5MTAxMzE1NiBpbmNv
bnNpc3RlbnQgd2l0aCAuLiB2YWx1ZSAoNTY5MTAxMzE3MikgaW4gaW5vIDgzNDUzNTcyNzxicj7C
oMKgwqDCoMKgwqDCoCB3aWxsIGNsZWFyIGVudHJ5ICZxdW90OzI4Nl9LZWxsbWFuX0hvZmZlcl9N
YXN0ZXIucGRmX2ZpbGVzJnF1b3Q7PGJyPnJlYnVpbGRpbmcgZGlyZWN0b3J5IGlub2RlIDU2OTEw
MTMxNTY8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMjI8YnI+wqDCoMKgwqDCoMKgwqAgLSBh
Z25vID0gMjM8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMjQ8YnI+wqDCoMKgwqDCoMKgwqAg
LSBhZ25vID0gMjU8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMjY8YnI+wqDCoMKgwqDCoMKg
wqAgLSBhZ25vID0gMjc8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMjg8YnI+wqDCoMKgwqDC
oMKgwqAgLSBhZ25vID0gMjk8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMzA8YnI+wqDCoMKg
wqDCoMKgwqAgLSBhZ25vID0gMzE8YnI+wqDCoMKgwqDCoMKgwqAgLSBhZ25vID0gMzI8YnI+wqDC
oMKgwqDCoMKgwqAgLSB0cmF2ZXJzYWwgZmluaXNoZWQgLi4uPGJyPsKgwqDCoMKgwqDCoMKgIC0g
bW92aW5nIGRpc2Nvbm5lY3RlZCBpbm9kZXMgdG8gbG9zdCtmb3VuZCAuLi48YnI+ZGlzY29ubmVj
dGVkIGRpciBpbm9kZSA4MzQ1MzU3MjcsIG1vdmluZyB0byBsb3N0K2ZvdW5kPGJyPmRpc2Nvbm5l
Y3RlZCBkaXIgaW5vZGUgMTkwOTcwNzA2NSwgbW92aW5nIHRvIGxvc3QrZm91bmQ8YnI+ZGlzY29u
bmVjdGVkIGRpciBpbm9kZSAyMTc5MDg3NDAzLCBtb3ZpbmcgdG8gbG9zdCtmb3VuZDxicj5kaXNj
b25uZWN0ZWQgZGlyIGlub2RlIDI0NTAxNzYwMDcsIG1vdmluZyB0byBsb3N0K2ZvdW5kPGJyPmRp
c2Nvbm5lY3RlZCBkaXIgaW5vZGUgNTY5MTAxMzE1NCwgbW92aW5nIHRvIGxvc3QrZm91bmQ8YnI+
ZGlzY29ubmVjdGVkIGRpciBpbm9kZSA1NjkxMDEzMTU1LCBtb3ZpbmcgdG8gbG9zdCtmb3VuZDxi
cj5kaXNjb25uZWN0ZWQgZGlyIGlub2RlIDU2OTEwMTMxNTYsIG1vdmluZyB0byBsb3N0K2ZvdW5k
PGJyPmRpc2Nvbm5lY3RlZCBkaXIgaW5vZGUgNTY5MTAxMzE1NywgbW92aW5nIHRvIGxvc3QrZm91
bmQ8YnI+ZGlzY29ubmVjdGVkIGRpciBpbm9kZSA1NjkxMDEzMTYzLCBtb3ZpbmcgdG8gbG9zdCtm
b3VuZDxicj5kaXNjb25uZWN0ZWQgZGlyIGlub2RlIDU2OTEwMTMxNzIsIG1vdmluZyB0byBsb3N0
K2ZvdW5kPGJyPlBoYXNlIDcgLSB2ZXJpZnkgYW5kIGNvcnJlY3QgbGluayBjb3VudHMuLi48YnI+
cmVzZXR0aW5nIGlub2RlIDgxNzc3OTgzIG5saW5rcyBmcm9tIDIgdG8gMTI8YnI+cmVzZXR0aW5n
IGlub2RlIDE5MDkyMTA0MTAgbmxpbmtzIGZyb20gMSB0byAyPGJyPnJlc2V0dGluZyBpbm9kZSAx
OTA5NzA3MDY3IG5saW5rcyBmcm9tIDMgdG8gMjxicj5yZXNldHRpbmcgaW5vZGUgMjQ1MDE3NjAz
MyBubGlua3MgZnJvbSAxOCB0byAxNzxicj5yZXNldHRpbmcgaW5vZGUgMjk5MjkyNzI0MSBubGlu
a3MgZnJvbSAxMyB0byAxMjxicj5yZXNldHRpbmcgaW5vZGUgMzUyMDQ2NDY3NiBubGlua3MgZnJv
bSAxMyB0byAxMjxicj5yZXNldHRpbmcgaW5vZGUgMzc5MTk1NjI0MCBubGlua3MgZnJvbSAxMyB0
byAxMjxicj5yZXNldHRpbmcgaW5vZGUgNDMyNDI1NzY1OSBubGlua3MgZnJvbSAxMyB0byAxMjxi
cj5yZXNldHRpbmcgaW5vZGUgNTY5MTAxMzE1NCBubGlua3MgZnJvbSA1IHRvIDI8YnI+cmVzZXR0
aW5nIGlub2RlIDU2OTEwMTMxNTYgbmxpbmtzIGZyb20gMyB0byAyPGJyPjxicj7CoMKgwqDCoMKg
wqDCoCBYRlNfUkVQQUlSIFN1bW1hcnnCoMKgwqAgVHVlIE1hciAzMSAwMzoxMTowMCAyMDE1PGJy
Pjxicj5QaGFzZcKgwqDCoMKgwqDCoMKgwqDCoMKgIFN0YXJ0wqDCoMKgwqDCoMKgwqDCoMKgwqAg
RW5kwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIER1cmF0aW9uPGJyPlBoYXNlIDE6wqDCoMKgwqDC
oMKgwqAgMDMvMzEgMDI6Mjg6MDTCoCAwMy8zMSAwMjoyODowNcKgIDEgc2Vjb25kPGJyPlBoYXNl
IDI6wqDCoMKgwqDCoMKgwqAgMDMvMzEgMDI6Mjg6MDXCoCAwMy8zMSAwMjoyODo0MsKgIDM3IHNl
Y29uZHM8YnI+UGhhc2UgMzrCoMKgwqDCoMKgwqDCoCAwMy8zMSAwMjoyODo0MsKgIDAzLzMxIDAy
OjQ4OjI5wqAgMTkgbWludXRlcywgNDcgc2Vjb25kczxicj5QaGFzZSA0OsKgwqDCoMKgwqDCoMKg
IDAzLzMxIDAyOjQ4OjI5wqAgMDMvMzEgMDI6NTU6NDDCoCA3IG1pbnV0ZXMsIDExIHNlY29uZHM8
YnI+UGhhc2UgNTrCoMKgwqDCoMKgwqDCoCAwMy8zMSAwMjo1NTo0MMKgIDAzLzMxIDAyOjU1OjQz
wqAgMyBzZWNvbmRzPGJyPlBoYXNlIDY6wqDCoMKgwqDCoMKgwqAgMDMvMzEgMDI6NTU6NDPCoCAw
My8zMSAwMzoxMDo1N8KgIDE1IG1pbnV0ZXMsIDE0IHNlY29uZHM8YnI+UGhhc2UgNzrCoMKgwqDC
oMKgwqDCoCAwMy8zMSAwMzoxMDo1N8KgIDAzLzMxIDAzOjEwOjU3PGJyPjxicj5Ub3RhbCBydW4g
dGltZTogNDIgbWludXRlcywgNTMgc2Vjb25kczxicj5kb25lPGJyPlR1ZSBNYXIgMzEgMDM6MTE6
MDEgUERUIDIwMTU8YnI+PGJyPjwvZGl2PjwvZGl2Pg0KPC9kaXY+PC9kaXY+PC9kaXY+PC9kaXY+
PC9kaXY+PC9kaXY+PC9kaXY+PC9kaXY+PC9kaXY+PC9kaXY+PC9kaXY+DQo=
--001a11338f6c661fed0512aa42e9--


--===============0504282425849346613==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0504282425849346613==--
