Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B8BC47F5F
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 21:31:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 95C23304051
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 19:31:07 -0700 (PDT)
Received: from mail-ob0-f169.google.com (mail-ob0-f169.google.com
	[209.85.214.169]) by cuda.sgi.com with ESMTP id
	tUyArXHMnBrdZlCF (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Oct 2014 19:31:03 -0700 (PDT)
Received: by mail-ob0-f169.google.com with SMTP id m8so2182950obr.0
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 19:31:02 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 16 Oct 2014 10:31:02 +0800
Message-ID: <CAGdb-8dvNOdBfZ3K_g_o22vN30yBJN+pwr-0sORC+Aubv5=9Cg@mail.gmail.com>
Subject: xfsdump not work in 3.17
From: Tommy Wu <wu.tommy@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3811601091897266957=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs <xfs@oss.sgi.com>

--===============3811601091897266957==
Content-Type: multipart/alternative; boundary=001a11335ad626e4e00505810abc

--001a11335ad626e4e00505810abc
Content-Type: text/plain; charset=UTF-8

Hi!

   xfsdump 3.1.4
   xfsprogs 3.2.1
   linux kerenl 3.17/3.17.1

   xfsdump will create a small backup file in 3.17 (test in 3.17, 3.17.1).
   it report SUCCESS, like this:

fw1:/vol/backup/fw1# /sbin/xfsdump -v trace,drive=debug,media=debug -l 0 -o
-J -F - /dev/vg/root | gzip > test.gz
/sbin/xfsdump: using file dump (drive_simple) strategy
/sbin/xfsdump: version 3.1.4 (dump format 3.0)
/sbin/xfsdump: level 0 dump of fw1.teatime.com.tw:/
/sbin/xfsdump: dump date: Thu Oct 16 10:27:26 2014
/sbin/xfsdump: session id: e409f4d1-8714-4919-a82d-c982d814fa4d
/sbin/xfsdump: session label: ""
/sbin/xfsdump: ino map phase 1: constructing initial dump list
/sbin/xfsdump: ino map phase 2: skipping (no pruning necessary)
/sbin/xfsdump: ino map phase 3: skipping (only one dump stream)
/sbin/xfsdump: ino map construction complete
/sbin/xfsdump: estimated dump size: 668196544 bytes
/sbin/xfsdump: Media op: begin media file
/sbin/xfsdump: creating dump session media file 0 (media 0, file 0)
/sbin/xfsdump: dumping ino map
/sbin/xfsdump: dumping directories
/sbin/xfsdump: dumping directory ino 192
/sbin/xfsdump: dumping directory ino 202
/sbin/xfsdump: dumping directory ino 203
/sbin/xfsdump: dumping directory ino 204
/sbin/xfsdump: dumping directory ino 205
/sbin/xfsdump: dumping directory ino 206
/sbin/xfsdump: dumping directory ino 207
/sbin/xfsdump: dumping directory ino 208
/sbin/xfsdump: dumping directory ino 209
/sbin/xfsdump: dumping directory ino 210
/sbin/xfsdump: dumping directory ino 211
/sbin/xfsdump: dumping directory ino 212
/sbin/xfsdump: dumping directory ino 214
/sbin/xfsdump: dumping directory ino 215
/sbin/xfsdump: dumping directory ino 216
/sbin/xfsdump: dumping directory ino 217
/sbin/xfsdump: dumping directory ino 218
/sbin/xfsdump: dumping directory ino 219
/sbin/xfsdump: dumping directory ino 220
/sbin/xfsdump: dumping directory ino 221
/sbin/xfsdump: dumping directory ino 222
/sbin/xfsdump: dumping directory ino 223
/sbin/xfsdump: dumping directory ino 224
/sbin/xfsdump: dumping directory ino 225
/sbin/xfsdump: dumping directory ino 226
/sbin/xfsdump: dumping directory ino 227
/sbin/xfsdump: dumping directory ino 228
/sbin/xfsdump: dumping directory ino 229
/sbin/xfsdump: dumping directory ino 230
/sbin/xfsdump: dumping directory ino 231
/sbin/xfsdump: dumping directory ino 232
/sbin/xfsdump: dumping directory ino 233
/sbin/xfsdump: dumping directory ino 235
/sbin/xfsdump: dumping directory ino 236
/sbin/xfsdump: dumping directory ino 237
/sbin/xfsdump: dumping directory ino 238
/sbin/xfsdump: dumping directory ino 239
/sbin/xfsdump: dumping directory ino 240
/sbin/xfsdump: dumping directory ino 241
/sbin/xfsdump: dumping directory ino 242
/sbin/xfsdump: dumping directory ino 243
/sbin/xfsdump: dumping directory ino 244
/sbin/xfsdump: dumping directory ino 245
/sbin/xfsdump: dumping directory ino 246
/sbin/xfsdump: dumping directory ino 247
/sbin/xfsdump: dumping directory ino 253
/sbin/xfsdump: dumping directory ino 254
/sbin/xfsdump: dumping directory ino 255
/sbin/xfsdump: dumping directory ino 4194670
/sbin/xfsdump: dumping directory ino 4194694
/sbin/xfsdump: dumping directory ino 4194707
/sbin/xfsdump: dumping directory ino 4194709
/sbin/xfsdump: dumping directory ino 4194711
/sbin/xfsdump: dumping directory ino 8389442
/sbin/xfsdump: dumping directory ino 8389454
/sbin/xfsdump: dumping directory ino 8389460
/sbin/xfsdump: dumping directory ino 8389462
/sbin/xfsdump: dumping directory ino 8389464
/sbin/xfsdump: dumping directory ino 8389466
/sbin/xfsdump: dumping directory ino 8389471
/sbin/xfsdump: dumping directory ino 8389496
/sbin/xfsdump: dumping non-directory files
/sbin/xfsdump: dumping regular file ino 195 offset 0 to offset 3839 (size
3839)
/sbin/xfsdump: dumping regular file ino 196 offset 0 to offset 1649 (size
1649)
/sbin/xfsdump: dumping regular file ino 197 offset 0 to offset 19917 (size
19917)
/sbin/xfsdump: dumping regular file ino 198 offset 0 to offset 150177 (size
150177)
/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x40000
/sbin/xfsdump: dumping regular file ino 199 offset 0 to offset 196 (size
196)
/sbin/xfsdump: dumping regular file ino 200 offset 0 to offset 828 (size
828)
/sbin/xfsdump: dumping regular file ino 201 offset 0 to offset 8805 (size
8805)
/sbin/xfsdump: dumping regular file ino 213 offset 0 to offset 1003 (size
1003)
/sbin/xfsdump: dumping special file ino 234 mode 0xa1ff
/sbin/xfsdump: dumping regular file ino 248 offset 0 to offset 28 (size 28)
/sbin/xfsdump: dumping special file ino 249 mode 0xa1ff
/sbin/xfsdump: dumping regular file ino 250 offset 0 to offset 1736 (size
1736)
/sbin/xfsdump: dumping special file ino 251 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 252 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194656 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194657 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194658 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194659 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194660 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194661 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194662 mode 0xa1ff
/sbin/xfsdump: dumping regular file ino 4194663 offset 0 to offset 85 (size
85)
/sbin/xfsdump: dumping special file ino 4194664 mode 0xa1ff
/sbin/xfsdump: dumping regular file ino 4194665 offset 0 to offset 24656
(size 24656)
/sbin/xfsdump: dumping special file ino 4194666 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194667 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194668 mode 0xa1ff
/sbin/xfsdump: dumping regular file ino 4194669 offset 0 to offset 4135
(size 4135)
/sbin/xfsdump: dumping regular file ino 4194671 offset 0 to offset 52 (size
52)
/sbin/xfsdump: dumping special file ino 4194672 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194673 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194674 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194675 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194676 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194677 mode 0xa1ff
/sbin/xfsdump: dumping regular file ino 4194678 offset 0 to offset 71501
(size 71501)
/sbin/xfsdump: dumping special file ino 4194679 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194680 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194681 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194682 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194683 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194684 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194685 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194686 mode 0xa1ff
/sbin/xfsdump: dumping regular file ino 4194687 offset 0 to offset 5432
(size 5432)
/sbin/xfsdump: dumping special file ino 4194688 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194689 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 4194690 mode 0xa1ff
/sbin/xfsdump: dumping regular file ino 4194691 offset 0 to offset 16224
(size 16224)
/sbin/xfsdump: dumping regular file ino 4194692 offset 0 to offset 17344
(size 17344)
/sbin/xfsdump: dumping regular file ino 4194693 offset 0 to offset 463
(size 463)
/sbin/xfsdump: dumping regular file ino 4194695 offset 0 to offset 15808
(size 15808)
/sbin/xfsdump: dumping regular file ino 4194696 offset 0 to offset 62768
(size 62768)
/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x40000
/sbin/xfsdump: dumping regular file ino 4194697 offset 0 to offset 116072
(size 116072)
/sbin/xfsdump: dumping regular file ino 4194698 offset 0 to offset 795
(size 795)
/sbin/xfsdump: dumping regular file ino 4194699 offset 0 to offset 64352
(size 64352)
/sbin/xfsdump: dumping regular file ino 4194700 offset 0 to offset 43576
(size 43576)
/sbin/xfsdump: dumping regular file ino 4194701 offset 0 to offset 28840
(size 28840)
/sbin/xfsdump: dumping regular file ino 4194702 offset 0 to offset 28928
(size 28928)
/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x40000
/sbin/xfsdump: dumping regular file ino 4194703 offset 0 to offset 70184
(size 70184)
/sbin/xfsdump: dumping regular file ino 4194704 offset 0 to offset 20336
(size 20336)
/sbin/xfsdump: dumping regular file ino 4194705 offset 0 to offset 67752
(size 67752)
/sbin/xfsdump: dumping regular file ino 4194706 offset 0 to offset 33640
(size 33640)
/sbin/xfsdump: dumping regular file ino 4194708 offset 0 to offset 175984
(size 175984)
/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x40000
/sbin/xfsdump: dumping regular file ino 4194710 offset 0 to offset 58816
(size 58816)
/sbin/xfsdump: dumping regular file ino 4194712 offset 0 to offset 22720
(size 22720)
/sbin/xfsdump: dumping regular file ino 4194713 offset 0 to offset 22128
(size 22128)
/sbin/xfsdump: dumping regular file ino 4194714 offset 0 to offset 15160
(size 15160)
/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x40000
/sbin/xfsdump: dumping regular file ino 4194715 offset 0 to offset 8104
(size 8104)
/sbin/xfsdump: dumping regular file ino 4194716 offset 0 to offset 145816
(size 145816)
/sbin/xfsdump: dumping regular file ino 4194717 offset 0 to offset 11064
(size 11064)
/sbin/xfsdump: dumping regular file ino 4194718 offset 0 to offset 15024
(size 15024)
/sbin/xfsdump: dumping regular file ino 4194719 offset 0 to offset 14968
(size 14968)
/sbin/xfsdump: dumping regular file ino 8389440 offset 0 to offset 1267832
(size 1267832)
/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x40000
/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x40000
/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x40000
/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x40000
/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x40000
/sbin/xfsdump: dumping regular file ino 8389441 offset 0 to offset 9212
(size 9212)
/sbin/xfsdump: dumping regular file ino 8389443 offset 0 to offset 1798
(size 1798)
/sbin/xfsdump: dumping regular file ino 8389444 offset 0 to offset 640488
(size 640488)
/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x40000
/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x40000
/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x40000
/sbin/xfsdump: dumping regular file ino 8389445 offset 0 to offset 1032
(size 1032)
/sbin/xfsdump: dumping regular file ino 8389446 offset 0 to offset 641
(size 641)
/sbin/xfsdump: dumping regular file ino 8389447 offset 0 to offset 226
(size 226)
/sbin/xfsdump: dumping special file ino 8389448 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 8389449 mode 0xa1ff
/sbin/xfsdump: dumping regular file ino 8389450 offset 0 to offset 2767
(size 2767)
/sbin/xfsdump: dumping special file ino 8389451 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 8389452 mode 0xa1ff
/sbin/xfsdump: dumping regular file ino 8389453 offset 0 to offset 856
(size 856)
/sbin/xfsdump: dumping special file ino 8389455 mode 0xa1ff
/sbin/xfsdump: dumping regular file ino 8389456 offset 0 to offset 118280
(size 118280)
/sbin/xfsdump: dumping regular file ino 8389457 offset 0 to offset 75 (size
75)
/sbin/xfsdump: dumping regular file ino 8389458 offset 0 to offset 117
(size 117)
/sbin/xfsdump: dumping regular file ino 8389459 offset 0 to offset 126712
(size 126712)
/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x40000
/sbin/xfsdump: dumping regular file ino 8389461 offset 0 to offset 288072
(size 288072)
/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x40000
/sbin/xfsdump: dumping regular file ino 8389463 offset 0 to offset 30096
(size 30096)
/sbin/xfsdump: dumping regular file ino 8389465 offset 0 to offset 123768
(size 123768)
/sbin/xfsdump: dumping regular file ino 8389467 offset 0 to offset 24512
(size 24512)
/sbin/xfsdump: dumping regular file ino 8389468 offset 0 to offset 18440
(size 18440)
/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x40000
/sbin/xfsdump: dumping regular file ino 8389469 offset 0 to offset 1241
(size 1241)
/sbin/xfsdump: dumping regular file ino 8389470 offset 0 to offset 47824
(size 47824)
/sbin/xfsdump: dumping regular file ino 8389472 offset 0 to offset 2427
(size 2427)
/sbin/xfsdump: dumping regular file ino 8389473 offset 0 to offset 2711
(size 2711)
/sbin/xfsdump: dumping special file ino 8389474 mode 0xa1ff
/sbin/xfsdump: dumping regular file ino 8389475 offset 0 to offset 2512
(size 2512)
/sbin/xfsdump: dumping regular file ino 8389476 offset 0 to offset 93096
(size 93096)
/sbin/xfsdump: dumping regular file ino 8389477 offset 0 to offset 5582
(size 5582)
/sbin/xfsdump: dumping regular file ino 8389478 offset 0 to offset 148
(size 148)
/sbin/xfsdump: dumping regular file ino 8389479 offset 0 to offset 42872
(size 42872)
/sbin/xfsdump: dumping regular file ino 8389480 offset 0 to offset 22800
(size 22800)
/sbin/xfsdump: dumping regular file ino 8389481 offset 0 to offset 29 (size
29)
/sbin/xfsdump: dumping regular file ino 8389482 offset 0 to offset 65 (size
65)
/sbin/xfsdump: dumping regular file ino 8389483 offset 0 to offset 5976
(size 5976)
/sbin/xfsdump: dumping special file ino 8389484 mode 0xa1ff
/sbin/xfsdump: dumping regular file ino 8389485 offset 0 to offset 2146
(size 2146)
/sbin/xfsdump: dumping regular file ino 8389486 offset 0 to offset 7808
(size 7808)
/sbin/xfsdump: dumping regular file ino 8389487 offset 0 to offset 9615
(size 9615)
/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x40000
/sbin/xfsdump: dumping regular file ino 8389488 offset 0 to offset 1225
(size 1225)
/sbin/xfsdump: dumping regular file ino 8389489 offset 0 to offset 1454
(size 1454)
/sbin/xfsdump: dumping regular file ino 8389490 offset 0 to offset 1634
(size 1634)
/sbin/xfsdump: dumping regular file ino 8389491 offset 0 to offset 1042
(size 1042)
/sbin/xfsdump: dumping special file ino 8389492 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 8389493 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 8389494 mode 0xa1ff
/sbin/xfsdump: dumping regular file ino 8389495 offset 0 to offset 148
(size 148)
/sbin/xfsdump: dumping regular file ino 8389497 offset 0 to offset 78008
(size 78008)
/sbin/xfsdump: dumping regular file ino 8389498 offset 0 to offset 2037
(size 2037)
/sbin/xfsdump: dumping regular file ino 8389499 offset 0 to offset 7695
(size 7695)
/sbin/xfsdump: dumping regular file ino 8389500 offset 0 to offset 9560
(size 9560)
/sbin/xfsdump: dumping special file ino 8389501 mode 0xa1ff
/sbin/xfsdump: dumping regular file ino 8389502 offset 0 to offset 5337
(size 5337)
/sbin/xfsdump: dumping special file ino 8389503 mode 0xa1ff
/sbin/xfsdump: dumping special file ino 12585024 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585025 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585026 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585027 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585028 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585029 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585030 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585031 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585032 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585033 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585034 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585035 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585036 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585037 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585038 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585039 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585040 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585041 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585042 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585043 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585044 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585045 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585046 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585047 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585048 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585049 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585050 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585051 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585052 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585053 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585054 mode 0x61b0
/sbin/xfsdump: dumping special file ino 12585055 mode 0x61b0
/sbin/xfsdump: ending media file
/sbin/xfsdump: Media op: end media file
/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x1fea0
/sbin/xfsdump: media file size 4587168 bytes
/sbin/xfsdump: ending stream: 1 seconds elapsed
/sbin/xfsdump: dump size (non-dir files) : 4455280 bytes
/sbin/xfsdump: dump complete: 1 seconds elapsed
/sbin/xfsdump: Dump Status: SUCCESS
fw1:/vol/backup/fw1#

   It just create  a small dump file, and if I run the same xfsdump again
(or umount the filesystem), it will hang, like:

fw1:/vol/backup/fw1# /sbin/xfsdump -v trace,drive=debug,media=debug -l 0 -o
-J -F - /dev/vg/root | gzip > test.gz
/sbin/xfsdump: using file dump (drive_simple) strategy
/sbin/xfsdump: version 3.1.4 (dump format 3.0)
/sbin/xfsdump: level 0 dump of fw1.teatime.com.tw:/
/sbin/xfsdump: dump date: Thu Oct 16 10:30:09 2014
/sbin/xfsdump: session id: b8354300-d54c-4131-b39c-7c0b63968208
/sbin/xfsdump: session label: ""
/sbin/xfsdump: ino map phase 1: constructing initial dump list


   switch back to kernel 3.16, the same command work fine.


-- 

Tommy Wu

--001a11335ad626e4e00505810abc
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Hi!<br><br></div><div>=C2=A0=C2=A0 xfsdump 3.1.4=
<br></div><div>=C2=A0=C2=A0 xfsprogs 3.2.1<br></div><div>=C2=A0=C2=A0 linux=
 kerenl 3.17/3.17.1<br><br></div>=C2=A0=C2=A0 xfsdump will create a small b=
ackup file in 3.17 (test in 3.17, 3.17.1).<br></div>=C2=A0=C2=A0 it report =
SUCCESS, like this:<br><br>fw1:/vol/backup/fw1# /sbin/xfsdump -v trace,driv=
e=3Ddebug,media=3Ddebug -l 0 -o -J -F - /dev/vg/root | gzip &gt; test.gz<br=
>/sbin/xfsdump: using file dump (drive_simple) strategy<br>/sbin/xfsdump: v=
ersion 3.1.4 (dump format 3.0)<br>/sbin/xfsdump: level 0 dump of fw1.teatim=
e.com.tw:/<br>/sbin/xfsdump: dump date: Thu Oct 16 10:27:26 2014<br>/sbin/x=
fsdump: session id: e409f4d1-8714-4919-a82d-c982d814fa4d<br>/sbin/xfsdump: =
session label: &quot;&quot;<br>/sbin/xfsdump: ino map phase 1: constructing=
 initial dump list<br>/sbin/xfsdump: ino map phase 2: skipping (no pruning =
necessary)<br>/sbin/xfsdump: ino map phase 3: skipping (only one dump strea=
m)<br>/sbin/xfsdump: ino map construction complete<br>/sbin/xfsdump: estima=
ted dump size: 668196544 bytes<br>/sbin/xfsdump: Media op: begin media file=
<br>/sbin/xfsdump: creating dump session media file 0 (media 0, file 0)<br>=
/sbin/xfsdump: dumping ino map<br>/sbin/xfsdump: dumping directories<br>/sb=
in/xfsdump: dumping directory ino 192<br>/sbin/xfsdump: dumping directory i=
no 202<br>/sbin/xfsdump: dumping directory ino 203<br>/sbin/xfsdump: dumpin=
g directory ino 204<br>/sbin/xfsdump: dumping directory ino 205<br>/sbin/xf=
sdump: dumping directory ino 206<br>/sbin/xfsdump: dumping directory ino 20=
7<br>/sbin/xfsdump: dumping directory ino 208<br>/sbin/xfsdump: dumping dir=
ectory ino 209<br>/sbin/xfsdump: dumping directory ino 210<br>/sbin/xfsdump=
: dumping directory ino 211<br>/sbin/xfsdump: dumping directory ino 212<br>=
/sbin/xfsdump: dumping directory ino 214<br>/sbin/xfsdump: dumping director=
y ino 215<br>/sbin/xfsdump: dumping directory ino 216<br>/sbin/xfsdump: dum=
ping directory ino 217<br>/sbin/xfsdump: dumping directory ino 218<br>/sbin=
/xfsdump: dumping directory ino 219<br>/sbin/xfsdump: dumping directory ino=
 220<br>/sbin/xfsdump: dumping directory ino 221<br>/sbin/xfsdump: dumping =
directory ino 222<br>/sbin/xfsdump: dumping directory ino 223<br>/sbin/xfsd=
ump: dumping directory ino 224<br>/sbin/xfsdump: dumping directory ino 225<=
br>/sbin/xfsdump: dumping directory ino 226<br>/sbin/xfsdump: dumping direc=
tory ino 227<br>/sbin/xfsdump: dumping directory ino 228<br>/sbin/xfsdump: =
dumping directory ino 229<br>/sbin/xfsdump: dumping directory ino 230<br>/s=
bin/xfsdump: dumping directory ino 231<br>/sbin/xfsdump: dumping directory =
ino 232<br>/sbin/xfsdump: dumping directory ino 233<br>/sbin/xfsdump: dumpi=
ng directory ino 235<br>/sbin/xfsdump: dumping directory ino 236<br>/sbin/x=
fsdump: dumping directory ino 237<br>/sbin/xfsdump: dumping directory ino 2=
38<br>/sbin/xfsdump: dumping directory ino 239<br>/sbin/xfsdump: dumping di=
rectory ino 240<br>/sbin/xfsdump: dumping directory ino 241<br>/sbin/xfsdum=
p: dumping directory ino 242<br>/sbin/xfsdump: dumping directory ino 243<br=
>/sbin/xfsdump: dumping directory ino 244<br>/sbin/xfsdump: dumping directo=
ry ino 245<br>/sbin/xfsdump: dumping directory ino 246<br>/sbin/xfsdump: du=
mping directory ino 247<br>/sbin/xfsdump: dumping directory ino 253<br>/sbi=
n/xfsdump: dumping directory ino 254<br>/sbin/xfsdump: dumping directory in=
o 255<br>/sbin/xfsdump: dumping directory ino 4194670<br>/sbin/xfsdump: dum=
ping directory ino 4194694<br>/sbin/xfsdump: dumping directory ino 4194707<=
br>/sbin/xfsdump: dumping directory ino 4194709<br>/sbin/xfsdump: dumping d=
irectory ino 4194711<br>/sbin/xfsdump: dumping directory ino 8389442<br>/sb=
in/xfsdump: dumping directory ino 8389454<br>/sbin/xfsdump: dumping directo=
ry ino 8389460<br>/sbin/xfsdump: dumping directory ino 8389462<br>/sbin/xfs=
dump: dumping directory ino 8389464<br>/sbin/xfsdump: dumping directory ino=
 8389466<br>/sbin/xfsdump: dumping directory ino 8389471<br>/sbin/xfsdump: =
dumping directory ino 8389496<br>/sbin/xfsdump: dumping non-directory files=
<br>/sbin/xfsdump: dumping regular file ino 195 offset 0 to offset 3839 (si=
ze 3839)<br>/sbin/xfsdump: dumping regular file ino 196 offset 0 to offset =
1649 (size 1649)<br>/sbin/xfsdump: dumping regular file ino 197 offset 0 to=
 offset 19917 (size 19917)<br>/sbin/xfsdump: dumping regular file ino 198 o=
ffset 0 to offset 150177 (size 150177)<br>/sbin/xfsdump: flushing write buf=
 addr 0xdc76f000 size 0x40000<br>/sbin/xfsdump: dumping regular file ino 19=
9 offset 0 to offset 196 (size 196)<br>/sbin/xfsdump: dumping regular file =
ino 200 offset 0 to offset 828 (size 828)<br>/sbin/xfsdump: dumping regular=
 file ino 201 offset 0 to offset 8805 (size 8805)<br>/sbin/xfsdump: dumping=
 regular file ino 213 offset 0 to offset 1003 (size 1003)<br>/sbin/xfsdump:=
 dumping special file ino 234 mode 0xa1ff<br>/sbin/xfsdump: dumping regular=
 file ino 248 offset 0 to offset 28 (size 28)<br>/sbin/xfsdump: dumping spe=
cial file ino 249 mode 0xa1ff<br>/sbin/xfsdump: dumping regular file ino 25=
0 offset 0 to offset 1736 (size 1736)<br>/sbin/xfsdump: dumping special fil=
e ino 251 mode 0xa1ff<br>/sbin/xfsdump: dumping special file ino 252 mode 0=
xa1ff<br>/sbin/xfsdump: dumping special file ino 4194656 mode 0xa1ff<br>/sb=
in/xfsdump: dumping special file ino 4194657 mode 0xa1ff<br>/sbin/xfsdump: =
dumping special file ino 4194658 mode 0xa1ff<br>/sbin/xfsdump: dumping spec=
ial file ino 4194659 mode 0xa1ff<br>/sbin/xfsdump: dumping special file ino=
 4194660 mode 0xa1ff<br>/sbin/xfsdump: dumping special file ino 4194661 mod=
e 0xa1ff<br>/sbin/xfsdump: dumping special file ino 4194662 mode 0xa1ff<br>=
/sbin/xfsdump: dumping regular file ino 4194663 offset 0 to offset 85 (size=
 85)<br>/sbin/xfsdump: dumping special file ino 4194664 mode 0xa1ff<br>/sbi=
n/xfsdump: dumping regular file ino 4194665 offset 0 to offset 24656 (size =
24656)<br>/sbin/xfsdump: dumping special file ino 4194666 mode 0xa1ff<br>/s=
bin/xfsdump: dumping special file ino 4194667 mode 0xa1ff<br>/sbin/xfsdump:=
 dumping special file ino 4194668 mode 0xa1ff<br>/sbin/xfsdump: dumping reg=
ular file ino 4194669 offset 0 to offset 4135 (size 4135)<br>/sbin/xfsdump:=
 dumping regular file ino 4194671 offset 0 to offset 52 (size 52)<br>/sbin/=
xfsdump: dumping special file ino 4194672 mode 0xa1ff<br>/sbin/xfsdump: dum=
ping special file ino 4194673 mode 0xa1ff<br>/sbin/xfsdump: dumping special=
 file ino 4194674 mode 0xa1ff<br>/sbin/xfsdump: dumping special file ino 41=
94675 mode 0xa1ff<br>/sbin/xfsdump: dumping special file ino 4194676 mode 0=
xa1ff<br>/sbin/xfsdump: dumping special file ino 4194677 mode 0xa1ff<br>/sb=
in/xfsdump: dumping regular file ino 4194678 offset 0 to offset 71501 (size=
 71501)<br>/sbin/xfsdump: dumping special file ino 4194679 mode 0xa1ff<br>/=
sbin/xfsdump: dumping special file ino 4194680 mode 0xa1ff<br>/sbin/xfsdump=
: dumping special file ino 4194681 mode 0xa1ff<br>/sbin/xfsdump: dumping sp=
ecial file ino 4194682 mode 0xa1ff<br>/sbin/xfsdump: dumping special file i=
no 4194683 mode 0xa1ff<br>/sbin/xfsdump: dumping special file ino 4194684 m=
ode 0xa1ff<br>/sbin/xfsdump: dumping special file ino 4194685 mode 0xa1ff<b=
r>/sbin/xfsdump: dumping special file ino 4194686 mode 0xa1ff<br>/sbin/xfsd=
ump: dumping regular file ino 4194687 offset 0 to offset 5432 (size 5432)<b=
r>/sbin/xfsdump: dumping special file ino 4194688 mode 0xa1ff<br>/sbin/xfsd=
ump: dumping special file ino 4194689 mode 0xa1ff<br>/sbin/xfsdump: dumping=
 special file ino 4194690 mode 0xa1ff<br>/sbin/xfsdump: dumping regular fil=
e ino 4194691 offset 0 to offset 16224 (size 16224)<br>/sbin/xfsdump: dumpi=
ng regular file ino 4194692 offset 0 to offset 17344 (size 17344)<br>/sbin/=
xfsdump: dumping regular file ino 4194693 offset 0 to offset 463 (size 463)=
<br>/sbin/xfsdump: dumping regular file ino 4194695 offset 0 to offset 1580=
8 (size 15808)<br>/sbin/xfsdump: dumping regular file ino 4194696 offset 0 =
to offset 62768 (size 62768)<br>/sbin/xfsdump: flushing write buf addr 0xdc=
76f000 size 0x40000<br>/sbin/xfsdump: dumping regular file ino 4194697 offs=
et 0 to offset 116072 (size 116072)<br>/sbin/xfsdump: dumping regular file =
ino 4194698 offset 0 to offset 795 (size 795)<br>/sbin/xfsdump: dumping reg=
ular file ino 4194699 offset 0 to offset 64352 (size 64352)<br>/sbin/xfsdum=
p: dumping regular file ino 4194700 offset 0 to offset 43576 (size 43576)<b=
r>/sbin/xfsdump: dumping regular file ino 4194701 offset 0 to offset 28840 =
(size 28840)<br>/sbin/xfsdump: dumping regular file ino 4194702 offset 0 to=
 offset 28928 (size 28928)<br>/sbin/xfsdump: flushing write buf addr 0xdc76=
f000 size 0x40000<br>/sbin/xfsdump: dumping regular file ino 4194703 offset=
 0 to offset 70184 (size 70184)<br>/sbin/xfsdump: dumping regular file ino =
4194704 offset 0 to offset 20336 (size 20336)<br>/sbin/xfsdump: dumping reg=
ular file ino 4194705 offset 0 to offset 67752 (size 67752)<br>/sbin/xfsdum=
p: dumping regular file ino 4194706 offset 0 to offset 33640 (size 33640)<b=
r>/sbin/xfsdump: dumping regular file ino 4194708 offset 0 to offset 175984=
 (size 175984)<br>/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x=
40000<br>/sbin/xfsdump: dumping regular file ino 4194710 offset 0 to offset=
 58816 (size 58816)<br>/sbin/xfsdump: dumping regular file ino 4194712 offs=
et 0 to offset 22720 (size 22720)<br>/sbin/xfsdump: dumping regular file in=
o 4194713 offset 0 to offset 22128 (size 22128)<br>/sbin/xfsdump: dumping r=
egular file ino 4194714 offset 0 to offset 15160 (size 15160)<br>/sbin/xfsd=
ump: flushing write buf addr 0xdc76f000 size 0x40000<br>/sbin/xfsdump: dump=
ing regular file ino 4194715 offset 0 to offset 8104 (size 8104)<br>/sbin/x=
fsdump: dumping regular file ino 4194716 offset 0 to offset 145816 (size 14=
5816)<br>/sbin/xfsdump: dumping regular file ino 4194717 offset 0 to offset=
 11064 (size 11064)<br>/sbin/xfsdump: dumping regular file ino 4194718 offs=
et 0 to offset 15024 (size 15024)<br>/sbin/xfsdump: dumping regular file in=
o 4194719 offset 0 to offset 14968 (size 14968)<br>/sbin/xfsdump: dumping r=
egular file ino 8389440 offset 0 to offset 1267832 (size 1267832)<br>/sbin/=
xfsdump: flushing write buf addr 0xdc76f000 size 0x40000<br>/sbin/xfsdump: =
flushing write buf addr 0xdc76f000 size 0x40000<br>/sbin/xfsdump: flushing =
write buf addr 0xdc76f000 size 0x40000<br>/sbin/xfsdump: flushing write buf=
 addr 0xdc76f000 size 0x40000<br>/sbin/xfsdump: flushing write buf addr 0xd=
c76f000 size 0x40000<br>/sbin/xfsdump: dumping regular file ino 8389441 off=
set 0 to offset 9212 (size 9212)<br>/sbin/xfsdump: dumping regular file ino=
 8389443 offset 0 to offset 1798 (size 1798)<br>/sbin/xfsdump: dumping regu=
lar file ino 8389444 offset 0 to offset 640488 (size 640488)<br>/sbin/xfsdu=
mp: flushing write buf addr 0xdc76f000 size 0x40000<br>/sbin/xfsdump: flush=
ing write buf addr 0xdc76f000 size 0x40000<br>/sbin/xfsdump: flushing write=
 buf addr 0xdc76f000 size 0x40000<br>/sbin/xfsdump: dumping regular file in=
o 8389445 offset 0 to offset 1032 (size 1032)<br>/sbin/xfsdump: dumping reg=
ular file ino 8389446 offset 0 to offset 641 (size 641)<br>/sbin/xfsdump: d=
umping regular file ino 8389447 offset 0 to offset 226 (size 226)<br>/sbin/=
xfsdump: dumping special file ino 8389448 mode 0xa1ff<br>/sbin/xfsdump: dum=
ping special file ino 8389449 mode 0xa1ff<br>/sbin/xfsdump: dumping regular=
 file ino 8389450 offset 0 to offset 2767 (size 2767)<br>/sbin/xfsdump: dum=
ping special file ino 8389451 mode 0xa1ff<br>/sbin/xfsdump: dumping special=
 file ino 8389452 mode 0xa1ff<br>/sbin/xfsdump: dumping regular file ino 83=
89453 offset 0 to offset 856 (size 856)<br>/sbin/xfsdump: dumping special f=
ile ino 8389455 mode 0xa1ff<br>/sbin/xfsdump: dumping regular file ino 8389=
456 offset 0 to offset 118280 (size 118280)<br>/sbin/xfsdump: dumping regul=
ar file ino 8389457 offset 0 to offset 75 (size 75)<br>/sbin/xfsdump: dumpi=
ng regular file ino 8389458 offset 0 to offset 117 (size 117)<br>/sbin/xfsd=
ump: dumping regular file ino 8389459 offset 0 to offset 126712 (size 12671=
2)<br>/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x40000<br>/sb=
in/xfsdump: dumping regular file ino 8389461 offset 0 to offset 288072 (siz=
e 288072)<br>/sbin/xfsdump: flushing write buf addr 0xdc76f000 size 0x40000=
<br>/sbin/xfsdump: dumping regular file ino 8389463 offset 0 to offset 3009=
6 (size 30096)<br>/sbin/xfsdump: dumping regular file ino 8389465 offset 0 =
to offset 123768 (size 123768)<br>/sbin/xfsdump: dumping regular file ino 8=
389467 offset 0 to offset 24512 (size 24512)<br>/sbin/xfsdump: dumping regu=
lar file ino 8389468 offset 0 to offset 18440 (size 18440)<br>/sbin/xfsdump=
: flushing write buf addr 0xdc76f000 size 0x40000<br>/sbin/xfsdump: dumping=
 regular file ino 8389469 offset 0 to offset 1241 (size 1241)<br>/sbin/xfsd=
ump: dumping regular file ino 8389470 offset 0 to offset 47824 (size 47824)=
<br>/sbin/xfsdump: dumping regular file ino 8389472 offset 0 to offset 2427=
 (size 2427)<br>/sbin/xfsdump: dumping regular file ino 8389473 offset 0 to=
 offset 2711 (size 2711)<br>/sbin/xfsdump: dumping special file ino 8389474=
 mode 0xa1ff<br>/sbin/xfsdump: dumping regular file ino 8389475 offset 0 to=
 offset 2512 (size 2512)<br>/sbin/xfsdump: dumping regular file ino 8389476=
 offset 0 to offset 93096 (size 93096)<br>/sbin/xfsdump: dumping regular fi=
le ino 8389477 offset 0 to offset 5582 (size 5582)<br>/sbin/xfsdump: dumpin=
g regular file ino 8389478 offset 0 to offset 148 (size 148)<br>/sbin/xfsdu=
mp: dumping regular file ino 8389479 offset 0 to offset 42872 (size 42872)<=
br>/sbin/xfsdump: dumping regular file ino 8389480 offset 0 to offset 22800=
 (size 22800)<br>/sbin/xfsdump: dumping regular file ino 8389481 offset 0 t=
o offset 29 (size 29)<br>/sbin/xfsdump: dumping regular file ino 8389482 of=
fset 0 to offset 65 (size 65)<br>/sbin/xfsdump: dumping regular file ino 83=
89483 offset 0 to offset 5976 (size 5976)<br>/sbin/xfsdump: dumping special=
 file ino 8389484 mode 0xa1ff<br>/sbin/xfsdump: dumping regular file ino 83=
89485 offset 0 to offset 2146 (size 2146)<br>/sbin/xfsdump: dumping regular=
 file ino 8389486 offset 0 to offset 7808 (size 7808)<br>/sbin/xfsdump: dum=
ping regular file ino 8389487 offset 0 to offset 9615 (size 9615)<br>/sbin/=
xfsdump: flushing write buf addr 0xdc76f000 size 0x40000<br>/sbin/xfsdump: =
dumping regular file ino 8389488 offset 0 to offset 1225 (size 1225)<br>/sb=
in/xfsdump: dumping regular file ino 8389489 offset 0 to offset 1454 (size =
1454)<br>/sbin/xfsdump: dumping regular file ino 8389490 offset 0 to offset=
 1634 (size 1634)<br>/sbin/xfsdump: dumping regular file ino 8389491 offset=
 0 to offset 1042 (size 1042)<br>/sbin/xfsdump: dumping special file ino 83=
89492 mode 0xa1ff<br>/sbin/xfsdump: dumping special file ino 8389493 mode 0=
xa1ff<br>/sbin/xfsdump: dumping special file ino 8389494 mode 0xa1ff<br>/sb=
in/xfsdump: dumping regular file ino 8389495 offset 0 to offset 148 (size 1=
48)<br>/sbin/xfsdump: dumping regular file ino 8389497 offset 0 to offset 7=
8008 (size 78008)<br>/sbin/xfsdump: dumping regular file ino 8389498 offset=
 0 to offset 2037 (size 2037)<br>/sbin/xfsdump: dumping regular file ino 83=
89499 offset 0 to offset 7695 (size 7695)<br>/sbin/xfsdump: dumping regular=
 file ino 8389500 offset 0 to offset 9560 (size 9560)<br>/sbin/xfsdump: dum=
ping special file ino 8389501 mode 0xa1ff<br>/sbin/xfsdump: dumping regular=
 file ino 8389502 offset 0 to offset 5337 (size 5337)<br>/sbin/xfsdump: dum=
ping special file ino 8389503 mode 0xa1ff<br>/sbin/xfsdump: dumping special=
 file ino 12585024 mode 0x61b0<br>/sbin/xfsdump: dumping special file ino 1=
2585025 mode 0x61b0<br>/sbin/xfsdump: dumping special file ino 12585026 mod=
e 0x61b0<br>/sbin/xfsdump: dumping special file ino 12585027 mode 0x61b0<br=
>/sbin/xfsdump: dumping special file ino 12585028 mode 0x61b0<br>/sbin/xfsd=
ump: dumping special file ino 12585029 mode 0x61b0<br>/sbin/xfsdump: dumpin=
g special file ino 12585030 mode 0x61b0<br>/sbin/xfsdump: dumping special f=
ile ino 12585031 mode 0x61b0<br>/sbin/xfsdump: dumping special file ino 125=
85032 mode 0x61b0<br>/sbin/xfsdump: dumping special file ino 12585033 mode =
0x61b0<br>/sbin/xfsdump: dumping special file ino 12585034 mode 0x61b0<br>/=
sbin/xfsdump: dumping special file ino 12585035 mode 0x61b0<br>/sbin/xfsdum=
p: dumping special file ino 12585036 mode 0x61b0<br>/sbin/xfsdump: dumping =
special file ino 12585037 mode 0x61b0<br>/sbin/xfsdump: dumping special fil=
e ino 12585038 mode 0x61b0<br>/sbin/xfsdump: dumping special file ino 12585=
039 mode 0x61b0<br>/sbin/xfsdump: dumping special file ino 12585040 mode 0x=
61b0<br>/sbin/xfsdump: dumping special file ino 12585041 mode 0x61b0<br>/sb=
in/xfsdump: dumping special file ino 12585042 mode 0x61b0<br>/sbin/xfsdump:=
 dumping special file ino 12585043 mode 0x61b0<br>/sbin/xfsdump: dumping sp=
ecial file ino 12585044 mode 0x61b0<br>/sbin/xfsdump: dumping special file =
ino 12585045 mode 0x61b0<br>/sbin/xfsdump: dumping special file ino 1258504=
6 mode 0x61b0<br>/sbin/xfsdump: dumping special file ino 12585047 mode 0x61=
b0<br>/sbin/xfsdump: dumping special file ino 12585048 mode 0x61b0<br>/sbin=
/xfsdump: dumping special file ino 12585049 mode 0x61b0<br>/sbin/xfsdump: d=
umping special file ino 12585050 mode 0x61b0<br>/sbin/xfsdump: dumping spec=
ial file ino 12585051 mode 0x61b0<br>/sbin/xfsdump: dumping special file in=
o 12585052 mode 0x61b0<br>/sbin/xfsdump: dumping special file ino 12585053 =
mode 0x61b0<br>/sbin/xfsdump: dumping special file ino 12585054 mode 0x61b0=
<br>/sbin/xfsdump: dumping special file ino 12585055 mode 0x61b0<br>/sbin/x=
fsdump: ending media file<br>/sbin/xfsdump: Media op: end media file<br>/sb=
in/xfsdump: flushing write buf addr 0xdc76f000 size 0x1fea0<br>/sbin/xfsdum=
p: media file size 4587168 bytes<br>/sbin/xfsdump: ending stream: 1 seconds=
 elapsed<br>/sbin/xfsdump: dump size (non-dir files) : 4455280 bytes<br>/sb=
in/xfsdump: dump complete: 1 seconds elapsed<br>/sbin/xfsdump: Dump Status:=
 SUCCESS<br>fw1:/vol/backup/fw1#<br><div><div><br></div><div>=C2=A0=C2=A0 I=
t just create=C2=A0 a small dump file, and if I run the same xfsdump again =
(or umount the filesystem), it will hang, like:<br><br>fw1:/vol/backup/fw1#=
 /sbin/xfsdump -v trace,drive=3Ddebug,media=3Ddebug -l 0 -o -J -F - /dev/vg=
/root | gzip &gt; test.gz<br>/sbin/xfsdump: using file dump (drive_simple) =
strategy<br>/sbin/xfsdump: version 3.1.4 (dump format 3.0)<br>/sbin/xfsdump=
: level 0 dump of fw1.teatime.com.tw:/<br>/sbin/xfsdump: dump date: Thu Oct=
 16 10:30:09 2014<br>/sbin/xfsdump: session id: b8354300-d54c-4131-b39c-7c0=
b63968208<br>/sbin/xfsdump: session label: &quot;&quot;<br>/sbin/xfsdump: i=
no map phase 1: constructing initial dump list<br><br><br></div><div>=C2=A0=
=C2=A0 switch back to kernel 3.16, the same command work fine.<br></div><di=
v><br clear=3D"all"><div><br>-- <br><br>Tommy Wu
</div></div></div></div>

--001a11335ad626e4e00505810abc--


--===============3811601091897266957==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3811601091897266957==--
