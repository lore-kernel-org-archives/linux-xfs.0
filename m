Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB1JUUVv160982 for <xfs@oss.sgi.com>; Tue, 1 Dec 2009 13:30:30 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ECEB914EDDE5
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2009 11:30:41 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 8ozYLmVyUwvJNeaN for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2009 11:30:41 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 30CB8A4E360
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2009 13:30:40 -0600 (CST)
Message-ID: <4B156ED2.9000209@sandeen.net>
Date: Tue, 01 Dec 2009 13:30:26 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: fix for lazy-sb
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Fix tests which would be affected by a change to lazy-sb
by default.

All tests now explicitly -specify- -l lazy-sb=1 where appropriate,
so this can go in prior to a userspace change.

Unfortunately many of the logprint outputs must just be taken on faith.

Also, the irix flavors for e.g. 018.op.irix will need fixing up
if anyone cares.

This also needs the patch I just sent for xfs_db clearing attr2
in bad_features2 to complete w/o error.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/018.op.linux b/018.op.linux
index 5c626da..5fb2cc6 100644
--- a/018.op.linux
+++ b/018.op.linux
@@ -6,7 +6,7 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: LOG flags: UNMOUNT
 Unmount filesystem
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -47,15 +47,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 15
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -96,15 +91,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 24
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -145,15 +135,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 33
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -194,15 +179,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 42
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -243,15 +223,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 51
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -292,15 +267,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 60
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -341,15 +311,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 69
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -390,15 +355,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 78
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -439,15 +399,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 87
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -488,15 +443,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 96
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -537,15 +487,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 105
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -586,15 +531,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 114
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -635,15 +575,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 123
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -684,15 +619,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 132
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -733,15 +663,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 141
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -782,15 +707,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 150
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 9
+TRAN: type: CREATE tid: <TID> num_items: 8
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -850,15 +770,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -902,15 +817,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -954,15 +864,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1006,15 +911,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1058,15 +958,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1110,15 +1005,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1162,15 +1052,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1214,15 +1099,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1266,17 +1146,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-Left over region from split log item
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1320,15 +1193,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1372,15 +1240,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1411,28 +1274,17 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
  blkno: <BLKNO> len:<LEN> boff: <BOFF>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-INODE CORE
-magic 0x494e mode 040755 version <VERS> format <FORMAT>
-nlink 2 uid 0 gid 0
-atime <TIME> mtime <TIME> ctime <TIME>
-size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
-naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
-flags 0x0 gen <GEN>
+Not printing rest
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-EXTENTS inode data
+Left over region from split log item
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1476,15 +1328,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1528,15 +1375,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1580,15 +1422,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1632,15 +1469,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1684,15 +1516,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1736,15 +1563,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1788,15 +1610,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1840,15 +1657,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1892,15 +1704,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1944,15 +1751,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1996,15 +1798,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2048,15 +1845,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2099,18 +1891,11 @@ EXTENTS inode data
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-Not printing rest
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-Left over region from split log item
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
+BUF DATA
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2154,15 +1939,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2206,15 +1986,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2258,15 +2033,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2281,7 +2051,7 @@ bucket[16 - 19]: 0xffffffff
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF DATA
+Not printing rest
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
  blkno: <BLKNO> len:<LEN> boff: <BOFF>
@@ -2310,15 +2080,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2362,15 +2127,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2414,15 +2174,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2466,15 +2221,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2518,15 +2268,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2570,15 +2315,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2622,15 +2362,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2674,15 +2409,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2726,15 +2456,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2778,19 +2503,21 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-Not printing rest
+AGI Buffer: XAGI
+ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
+level: 1 free#: 0x6 newino: <INO>
+bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
+bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
+bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
+bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
+bucket[16 - 19]: 0xffffffff
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2823,15 +2550,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2875,15 +2597,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2927,15 +2644,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2979,26 +2691,14 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-AGI Buffer: XAGI
-ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
-level: 1 free#: 0x2 newino: <INO>
-bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
-bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
-bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
-bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
-bucket[16 - 19]: 0xffffffff
+Not printing rest
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3031,15 +2731,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3083,15 +2778,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3135,15 +2825,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 8
+TRAN: type: CREATE tid: <TID> num_items: 7
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3183,15 +2868,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3235,15 +2915,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3286,18 +2961,11 @@ EXTENTS inode data
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-Not printing rest
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-Left over region from split log item
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
+BUF DATA
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3341,15 +3009,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3393,15 +3056,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3445,15 +3103,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3496,16 +3149,13 @@ EXTENTS inode data
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
+Not printing rest
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
+Left over region from split log item
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3549,15 +3199,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3601,15 +3246,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3653,15 +3293,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3705,15 +3340,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3757,15 +3387,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3809,15 +3434,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3860,18 +3480,11 @@ EXTENTS inode data
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-Not printing rest
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-Left over region from split log item
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
+BUF DATA
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3915,15 +3528,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3967,15 +3575,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4019,15 +3622,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4071,15 +3669,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4099,13 +3692,7 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
  blkno: <BLKNO> len:<LEN> boff: <BOFF>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-INODE CORE
-magic 0x494e mode 0100644 version <VERS> format <FORMAT>
-nlink 1 uid 0 gid 0
-atime <TIME> mtime <TIME> ctime <TIME>
-size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
-naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
-flags 0x0 gen <GEN>
+Left over region from split log item
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
  blkno: <BLKNO> len:<LEN> boff: <BOFF>
@@ -4123,15 +3710,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4175,15 +3757,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4227,15 +3804,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4279,15 +3851,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4331,15 +3898,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4383,15 +3945,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4435,15 +3992,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4487,15 +4039,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4539,15 +4086,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4591,15 +4133,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4642,16 +4179,13 @@ EXTENTS inode data
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
+Not printing rest
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
+Left over region from split log item
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4695,15 +4229,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4747,15 +4276,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4799,15 +4323,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4851,15 +4370,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4902,18 +4416,11 @@ EXTENTS inode data
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-Not printing rest
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-Left over region from split log item
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
+BUF DATA
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4957,15 +4464,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -5009,15 +4511,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -5061,15 +4558,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -5113,15 +4605,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -5164,16 +4651,13 @@ EXTENTS inode data
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
+Not printing rest
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
+Left over region from split log item
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -5217,14 +4701,14 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
+Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
+Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
+Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
+Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
+Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
+Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
+Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
+Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: LOG flags: UNMOUNT
-Unmount filesystem
-xfs_logprint: skipped <COUNT> zeroed blocks in range: <COUNT> - <COUNT>
-xfs_logprint: physical end of log
-xfs_logprint: logical end of log
diff --git a/018.out b/018.out
index 53840f0..4d51a1f 100644
--- a/018.out
+++ b/018.out
@@ -1,17 +1,17 @@
 QA output created by 018
 *** init FS
-*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-lversion=1.filtered
-*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-lversion=1.filtered
-*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-lversion=1.filtered
-*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=64k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=64k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=64k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=128k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=128k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=128k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=256k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=256k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=256k.mkfs-lsize=2000b-lversion=2.filtered
+*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=1.filtered
+*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=1.filtered
+*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=1.filtered
+*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
+*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
+*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
+*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=64k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
+*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=64k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
+*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=64k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
+*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=128k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
+*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=128k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
+*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=128k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
+*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=256k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
+*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=256k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
+*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=256k.mkfs-lsize=2000b-llazy-count=1-lversion=2.filtered
diff --git a/018.trans_buf b/018.trans_buf
index a55f628..158f06a 100644
--- a/018.trans_buf
+++ b/018.trans_buf
@@ -4,7 +4,7 @@ xfs_logprint:
  log device: <DEVICE> daddr: <DADDR> length: <LENGTH>
  log tail: <COUNT> head: <COUNT> state: <CLEAN>
  override tail: <TAIL_BLK>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -20,12 +20,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:16
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -41,12 +36,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:24
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -62,12 +52,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:36
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -83,12 +68,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:44
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -104,12 +84,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:52
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -125,12 +100,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:60
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -146,12 +116,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:72
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -167,12 +132,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:80
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -188,12 +148,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:88
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -209,12 +164,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:96
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -230,12 +180,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:108
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -251,12 +196,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:116
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -272,12 +212,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:124
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -293,12 +228,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:132
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -314,12 +244,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:144
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -335,12 +260,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:152
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:9 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -371,12 +291,7 @@ BUF: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -394,12 +309,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -417,12 +327,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -440,12 +345,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -463,12 +363,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -486,12 +381,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -509,12 +399,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -532,12 +417,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -555,12 +435,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -578,12 +453,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -601,12 +471,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -624,12 +489,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -647,12 +507,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -670,12 +525,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -693,12 +543,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -716,12 +561,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -739,12 +579,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -762,12 +597,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -785,12 +615,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -808,12 +633,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -831,12 +651,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -854,12 +669,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -877,12 +687,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -900,12 +705,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -923,12 +723,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -946,12 +741,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -969,12 +759,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -992,12 +777,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1015,12 +795,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1038,12 +813,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1061,12 +831,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1084,12 +849,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1107,12 +867,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1130,12 +885,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1153,12 +903,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1176,12 +921,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1199,12 +939,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1222,12 +957,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1245,12 +975,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1268,12 +993,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1291,12 +1011,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1314,12 +1029,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1337,12 +1047,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1360,12 +1065,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1383,12 +1083,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1416,12 +1111,7 @@ BUF: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1439,12 +1129,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1462,12 +1147,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1485,12 +1165,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1508,12 +1183,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1531,12 +1201,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1554,12 +1219,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1577,12 +1237,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1600,12 +1255,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1623,12 +1273,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1646,12 +1291,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1669,12 +1309,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1692,12 +1327,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1715,12 +1345,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1738,12 +1363,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1761,12 +1381,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1784,12 +1399,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1807,12 +1417,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1830,12 +1435,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1853,12 +1453,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1876,12 +1471,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1899,12 +1489,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1922,12 +1507,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1945,12 +1525,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1968,12 +1543,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1991,12 +1561,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2014,12 +1579,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2037,12 +1597,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2060,12 +1615,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2083,12 +1633,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2106,12 +1651,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2129,12 +1669,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2152,12 +1687,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2175,12 +1705,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2198,12 +1723,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2221,12 +1741,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2244,12 +1759,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2267,12 +1777,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2290,12 +1795,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2313,6 +1813,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
+TRANS: tid:<TID> type:SB_COUNT #items:1 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	SUPER Block Buffer:
diff --git a/018.trans_inode b/018.trans_inode
index 8ec3cf8..902bb1f 100644
--- a/018.trans_inode
+++ b/018.trans_inode
@@ -4,7 +4,7 @@ xfs_logprint:
  log device: <DEVICE> daddr: <DADDR> length: <LENGTH>
  log tail: <COUNT> head: <COUNT> state: <CLEAN>
  override tail: <TAIL_BLK>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -28,10 +28,7 @@ INO: cnt:C total:T
 		size:0xf nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -55,10 +52,7 @@ INO: cnt:C total:T
 		size:0x18 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -82,10 +76,7 @@ INO: cnt:C total:T
 		size:0x21 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -109,10 +100,7 @@ INO: cnt:C total:T
 		size:0x2a nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -136,10 +124,7 @@ INO: cnt:C total:T
 		size:0x33 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -163,10 +148,7 @@ INO: cnt:C total:T
 		size:0x3c nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -190,10 +172,7 @@ INO: cnt:C total:T
 		size:0x45 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -217,10 +196,7 @@ INO: cnt:C total:T
 		size:0x4e nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -244,10 +220,7 @@ INO: cnt:C total:T
 		size:0x57 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -271,10 +244,7 @@ INO: cnt:C total:T
 		size:0x60 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -298,10 +268,7 @@ INO: cnt:C total:T
 		size:0x69 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -325,10 +292,7 @@ INO: cnt:C total:T
 		size:0x72 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -352,10 +316,7 @@ INO: cnt:C total:T
 		size:0x7b nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -379,10 +340,7 @@ INO: cnt:C total:T
 		size:0x84 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -406,10 +364,7 @@ INO: cnt:C total:T
 		size:0x8d nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -433,10 +388,7 @@ INO: cnt:C total:T
 		size:0x96 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:9 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -471,10 +423,7 @@ BUF: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -500,10 +449,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -529,10 +475,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -558,10 +501,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -587,10 +527,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -616,10 +553,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -645,10 +579,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -674,10 +605,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -703,10 +631,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -732,10 +657,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -761,10 +683,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -790,10 +709,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -819,10 +735,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -848,10 +761,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -877,10 +787,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -906,10 +813,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -935,10 +839,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -964,10 +865,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -993,10 +891,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1022,10 +917,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1051,10 +943,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1080,10 +969,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1109,10 +995,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1138,10 +1021,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1167,10 +1047,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1196,10 +1073,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1225,10 +1099,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1254,10 +1125,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1283,10 +1151,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1312,10 +1177,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1341,10 +1203,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1370,10 +1229,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1399,10 +1255,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1428,10 +1281,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1457,10 +1307,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1486,10 +1333,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1515,10 +1359,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1544,10 +1385,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1573,10 +1411,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1602,10 +1437,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1631,10 +1463,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1660,10 +1489,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1689,10 +1515,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1718,10 +1541,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1747,10 +1567,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1772,10 +1589,7 @@ BUF: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1801,10 +1615,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1830,10 +1641,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1859,10 +1667,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1888,10 +1693,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1917,10 +1719,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1946,10 +1745,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1975,10 +1771,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2004,10 +1797,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2033,10 +1823,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2062,10 +1849,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2091,10 +1875,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2120,10 +1901,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2149,10 +1927,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2178,10 +1953,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2207,10 +1979,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2236,10 +2005,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2265,10 +2031,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2294,10 +2057,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2323,10 +2083,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2352,10 +2109,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2381,10 +2135,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2410,10 +2161,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2439,10 +2187,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2468,10 +2213,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2497,10 +2239,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2526,10 +2265,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2555,10 +2291,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2584,10 +2317,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2613,10 +2343,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2642,10 +2369,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2671,10 +2395,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2700,10 +2421,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2729,10 +2447,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2758,10 +2473,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2787,10 +2499,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2816,10 +2525,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2845,10 +2551,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2874,10 +2577,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2903,6 +2603,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
+TRANS: tid:<TID> type:SB_COUNT #items:1 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	SUPER Block Buffer:
diff --git a/081.out b/081.out
index bf533a4..fb2abe5 100644
--- a/081.out
+++ b/081.out
@@ -1,4 +1,4 @@
 QA output created by 081
 *** init FS
-*** compare logprint: 081.ugquota.trans_inode with 081.fulldir/trans_inode.mnt-oquota,gquota.mkfs-lsize=2000b-lversion=1.filtered
+*** compare logprint: 081.ugquota.trans_inode with 081.fulldir/trans_inode.mnt-oquota,gquota.mkfs-lsize=2000b-llazy-count=1-lversion=1.filtered
 *** unmount
diff --git a/081.ugquota.trans_inode b/081.ugquota.trans_inode
index be3a1d8..647c9cd 100644
--- a/081.ugquota.trans_inode
+++ b/081.ugquota.trans_inode
@@ -40,7 +40,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	SUPER Block Buffer:
-TRANS: tid:<TID> type:QM_DQALLOC #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:QM_DQALLOC #items:5 trans:0x0 q:<Q>
 INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x1 dsize:16
 	CORE inode:
@@ -61,10 +61,7 @@ BUF: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:QM_DQALLOC #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:QM_DQALLOC #items:5 trans:0x0 q:<Q>
 INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x1 dsize:16
 	CORE inode:
@@ -85,14 +82,11 @@ BUF: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 TRANS: tid:<TID> type:QM_SBCHANGE #items:1 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -116,14 +110,11 @@ INO: cnt:C total:T
 		size:0xf nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -147,14 +138,11 @@ INO: cnt:C total:T
 		size:0x18 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -178,14 +166,11 @@ INO: cnt:C total:T
 		size:0x21 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -209,14 +194,11 @@ INO: cnt:C total:T
 		size:0x2a nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -240,14 +222,11 @@ INO: cnt:C total:T
 		size:0x33 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -271,14 +250,11 @@ INO: cnt:C total:T
 		size:0x3c nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -302,14 +278,11 @@ INO: cnt:C total:T
 		size:0x45 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -333,14 +306,11 @@ INO: cnt:C total:T
 		size:0x4e nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -364,14 +334,11 @@ INO: cnt:C total:T
 		size:0x57 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -395,14 +362,11 @@ INO: cnt:C total:T
 		size:0x60 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -426,14 +390,11 @@ INO: cnt:C total:T
 		size:0x69 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -457,14 +418,11 @@ INO: cnt:C total:T
 		size:0x72 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -488,14 +446,11 @@ INO: cnt:C total:T
 		size:0x7b nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -519,14 +474,11 @@ INO: cnt:C total:T
 		size:0x84 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -550,14 +502,11 @@ INO: cnt:C total:T
 		size:0x8d nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -581,14 +530,11 @@ INO: cnt:C total:T
 		size:0x96 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:11 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:10 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -623,14 +569,11 @@ BUF: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -656,14 +599,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -689,14 +629,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -722,14 +659,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -755,14 +689,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -788,14 +719,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -821,14 +749,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -854,14 +779,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -887,14 +809,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -920,14 +839,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -953,14 +869,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -986,14 +899,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1019,14 +929,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1052,14 +959,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1085,14 +989,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1118,14 +1019,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1151,14 +1049,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1184,14 +1079,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1217,14 +1109,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1250,14 +1139,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1283,14 +1169,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1316,14 +1199,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1349,14 +1229,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1382,14 +1259,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1415,14 +1289,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1448,14 +1319,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1481,14 +1349,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1514,14 +1379,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1547,14 +1409,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1580,14 +1439,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1613,14 +1469,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1646,14 +1499,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1679,14 +1529,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1712,14 +1559,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1745,14 +1589,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1778,14 +1619,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1811,14 +1649,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1844,14 +1679,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1877,14 +1709,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1910,14 +1739,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1943,14 +1769,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1976,14 +1799,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2009,14 +1829,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2038,10 +1855,7 @@ BUF: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2067,14 +1881,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2100,14 +1911,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2133,14 +1941,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2166,14 +1971,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2199,14 +2001,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2232,14 +2031,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2265,14 +2061,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2298,14 +2091,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2331,14 +2121,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2364,14 +2151,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2397,14 +2181,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2430,14 +2211,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2463,14 +2241,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2496,14 +2271,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2529,14 +2301,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2562,14 +2331,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2595,14 +2361,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2628,14 +2391,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2661,14 +2421,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2694,14 +2451,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2727,14 +2481,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2760,14 +2511,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2793,14 +2541,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2826,14 +2571,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2859,14 +2601,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2892,14 +2631,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2925,14 +2661,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2958,14 +2691,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2991,14 +2721,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -3024,14 +2751,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -3057,14 +2781,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -3090,14 +2811,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -3123,14 +2841,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -3156,14 +2871,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -3189,14 +2901,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -3222,14 +2931,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -3255,14 +2961,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -3288,14 +2991,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -3321,14 +3021,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -3354,14 +3051,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -3387,10 +3081,11 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
 DQ : cnt:2 total:2 a:<A> len:<LEN> a:<A> len:<LEN>
 	DQUOT: #regs:R blkno: <BLKNO> boffset:0 id: 0
+TRANS: tid:<TID> type:SB_COUNT #items:1 trans:0x0 q:<Q>
+BUF: cnt:C total:T
+	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
+	SUPER Block Buffer:
diff --git a/082.op.linux b/082.op.linux
index 5c626da..5fb2cc6 100644
--- a/082.op.linux
+++ b/082.op.linux
@@ -6,7 +6,7 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: LOG flags: UNMOUNT
 Unmount filesystem
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -47,15 +47,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 15
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -96,15 +91,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 24
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -145,15 +135,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 33
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -194,15 +179,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 42
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -243,15 +223,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 51
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -292,15 +267,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 60
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -341,15 +311,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 69
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -390,15 +355,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 78
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -439,15 +399,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 87
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -488,15 +443,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 96
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -537,15 +487,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 105
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -586,15 +531,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 114
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -635,15 +575,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 123
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -684,15 +619,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 132
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -733,15 +663,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 141
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 5
+TRAN: type: CREATE tid: <TID> num_items: 4
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -782,15 +707,10 @@ flags 0x0 gen <GEN>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 LOCAL inode data
 SHORTFORM DIRECTORY size 150
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 9
+TRAN: type: CREATE tid: <TID> num_items: 8
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -850,15 +770,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -902,15 +817,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -954,15 +864,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1006,15 +911,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1058,15 +958,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1110,15 +1005,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1162,15 +1052,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1214,15 +1099,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1266,17 +1146,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-Left over region from split log item
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1320,15 +1193,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1372,15 +1240,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1411,28 +1274,17 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
  blkno: <BLKNO> len:<LEN> boff: <BOFF>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-INODE CORE
-magic 0x494e mode 040755 version <VERS> format <FORMAT>
-nlink 2 uid 0 gid 0
-atime <TIME> mtime <TIME> ctime <TIME>
-size 0x1000 nblocks 0x1 extsize 0x0 nextents 0x1
-naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
-flags 0x0 gen <GEN>
+Not printing rest
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-EXTENTS inode data
+Left over region from split log item
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1476,15 +1328,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1528,15 +1375,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1580,15 +1422,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1632,15 +1469,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1684,15 +1516,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1736,15 +1563,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1788,15 +1610,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1840,15 +1657,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1892,15 +1704,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1944,15 +1751,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -1996,15 +1798,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2048,15 +1845,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2099,18 +1891,11 @@ EXTENTS inode data
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-Not printing rest
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-Left over region from split log item
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
+BUF DATA
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2154,15 +1939,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2206,15 +1986,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2258,15 +2033,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2281,7 +2051,7 @@ bucket[16 - 19]: 0xffffffff
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF DATA
+Not printing rest
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
  blkno: <BLKNO> len:<LEN> boff: <BOFF>
@@ -2310,15 +2080,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2362,15 +2127,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2414,15 +2174,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2466,15 +2221,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2518,15 +2268,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2570,15 +2315,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2622,15 +2362,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2674,15 +2409,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2726,15 +2456,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2778,19 +2503,21 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-Not printing rest
+AGI Buffer: XAGI
+ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
+level: 1 free#: 0x6 newino: <INO>
+bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
+bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
+bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
+bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
+bucket[16 - 19]: 0xffffffff
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2823,15 +2550,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2875,15 +2597,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2927,15 +2644,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -2979,26 +2691,14 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-AGI Buffer: XAGI
-ver: 1 seq#: 0 len:<LEN> cnt: 64 root: 3
-level: 1 free#: 0x2 newino: <INO>
-bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
-bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
-bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
-bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff
-bucket[16 - 19]: 0xffffffff
+Not printing rest
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3031,15 +2731,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3083,15 +2778,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3135,15 +2825,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 8
+TRAN: type: CREATE tid: <TID> num_items: 7
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3183,15 +2868,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3235,15 +2915,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3286,18 +2961,11 @@ EXTENTS inode data
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-Not printing rest
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-Left over region from split log item
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
+BUF DATA
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3341,15 +3009,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3393,15 +3056,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3445,15 +3103,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3496,16 +3149,13 @@ EXTENTS inode data
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
+Not printing rest
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
+Left over region from split log item
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3549,15 +3199,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3601,15 +3246,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3653,15 +3293,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3705,15 +3340,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3757,15 +3387,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3809,15 +3434,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3860,18 +3480,11 @@ EXTENTS inode data
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-Not printing rest
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-Left over region from split log item
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
+BUF DATA
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3915,15 +3528,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -3967,15 +3575,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4019,15 +3622,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4071,15 +3669,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4099,13 +3692,7 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 INODE: #regs:R ino: <INO> flags: 0x1 dsize: 0
  blkno: <BLKNO> len:<LEN> boff: <BOFF>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-INODE CORE
-magic 0x494e mode 0100644 version <VERS> format <FORMAT>
-nlink 1 uid 0 gid 0
-atime <TIME> mtime <TIME> ctime <TIME>
-size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
-naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
-flags 0x0 gen <GEN>
+Left over region from split log item
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 INODE: #regs:R ino: <INO> flags: 0x5 dsize: 16
  blkno: <BLKNO> len:<LEN> boff: <BOFF>
@@ -4123,15 +3710,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4175,15 +3757,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4227,15 +3804,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4279,15 +3851,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4331,15 +3898,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4383,15 +3945,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4435,15 +3992,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4487,15 +4039,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4539,15 +4086,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4591,15 +4133,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4642,16 +4179,13 @@ EXTENTS inode data
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
+Not printing rest
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
+Left over region from split log item
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4695,15 +4229,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4747,15 +4276,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4799,15 +4323,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4851,15 +4370,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4902,18 +4416,11 @@ EXTENTS inode data
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-Not printing rest
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-Left over region from split log item
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
+BUF DATA
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -4957,15 +4464,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -5009,15 +4511,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -5061,15 +4558,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -5113,15 +4605,10 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -5164,16 +4651,13 @@ EXTENTS inode data
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF DATA
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
+Not printing rest
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
+Left over region from split log item
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-TRAN: type: CREATE tid: <TID> num_items: 6
+TRAN: type: CREATE tid: <TID> num_items: 5
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
@@ -5217,14 +4701,14 @@ Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 2
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 BUF DATA
+Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
+Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
+Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
+Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
+Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
+Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
+Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: START
+Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-BUF: #regs:R start blkno: <BLKNO> (<BLKNO>) len:<LEN> bmap size: 1
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: none
-SUPER BLOCK Buffer:
-icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
 Oper (OPNUM): tid: <TID> len:<LEN> clientid: TRANS flags: COMMIT
-Oper (OPNUM): tid: <TID> len:<LEN> clientid: LOG flags: UNMOUNT
-Unmount filesystem
-xfs_logprint: skipped <COUNT> zeroed blocks in range: <COUNT> - <COUNT>
-xfs_logprint: physical end of log
-xfs_logprint: logical end of log
diff --git a/082.out b/082.out
index e875ab5..94686b6 100644
--- a/082.out
+++ b/082.out
@@ -1,39 +1,39 @@
 QA output created by 082
 *** init FS
 --- mkfs=version=2, mnt=logbsize=32k, sync=sync ---
-*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2.sync.filtered
-*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2.sync.filtered
+*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2.sync.filtered
+*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2.sync.filtered
 --- mkfs=version=2,su=4096, mnt=logbsize=32k, sync=sync ---
-*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=4096.sync.filtered
-*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=4096.sync.filtered
+*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2,su=4096.sync.filtered
+*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2,su=4096.sync.filtered
 --- mkfs=version=2,su=32768, mnt=logbsize=32k, sync=sync ---
-*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=32768.sync.filtered
-*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=32768.sync.filtered
+*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2,su=32768.sync.filtered
+*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2,su=32768.sync.filtered
 --- mkfs=version=2,su=36864, mnt=logbsize=32k, sync=sync ---
 
-*** Cannot mkfs for this test using option specified: -l size=2000b -l version=2,su=36864 ***
+*** Cannot mkfs for this test using option specified: -l size=2000b -l lazy-count=1 -l version=2,su=36864 ***
 
 --- mkfs=version=2,su=5120, mnt=logbsize=32k, sync=sync ---
 
-*** Cannot mkfs for this test using option specified: -l size=2000b -l version=2,su=5120 ***
+*** Cannot mkfs for this test using option specified: -l size=2000b -l lazy-count=1 -l version=2,su=5120 ***
 
 --- mkfs=version=2, mnt=logbsize=32k, sync=nosync ---
-*** compare logprint: 082.op with 082.fulldir/op.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2.nosync.filtered
-*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2.nosync.filtered
-*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2.nosync.filtered
+*** compare logprint: 082.op with 082.fulldir/op.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2.nosync.filtered
+*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2.nosync.filtered
+*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2.nosync.filtered
 --- mkfs=version=2,su=4096, mnt=logbsize=32k, sync=nosync ---
-*** compare logprint: 082.op with 082.fulldir/op.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=4096.nosync.filtered
-*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=4096.nosync.filtered
-*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=4096.nosync.filtered
+*** compare logprint: 082.op with 082.fulldir/op.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2,su=4096.nosync.filtered
+*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2,su=4096.nosync.filtered
+*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2,su=4096.nosync.filtered
 --- mkfs=version=2,su=32768, mnt=logbsize=32k, sync=nosync ---
-*** compare logprint: 082.op with 082.fulldir/op.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=32768.nosync.filtered
-*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=32768.nosync.filtered
-*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=32768.nosync.filtered
+*** compare logprint: 082.op with 082.fulldir/op.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2,su=32768.nosync.filtered
+*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2,su=32768.nosync.filtered
+*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=1-lversion=2,su=32768.nosync.filtered
 --- mkfs=version=2,su=36864, mnt=logbsize=32k, sync=nosync ---
 
-*** Cannot mkfs for this test using option specified: -l size=2000b -l version=2,su=36864 ***
+*** Cannot mkfs for this test using option specified: -l size=2000b -l lazy-count=1 -l version=2,su=36864 ***
 
 --- mkfs=version=2,su=5120, mnt=logbsize=32k, sync=nosync ---
 
-*** Cannot mkfs for this test using option specified: -l size=2000b -l version=2,su=5120 ***
+*** Cannot mkfs for this test using option specified: -l size=2000b -l lazy-count=1 -l version=2,su=5120 ***
 
diff --git a/082.trans_buf b/082.trans_buf
index a55f628..158f06a 100644
--- a/082.trans_buf
+++ b/082.trans_buf
@@ -4,7 +4,7 @@ xfs_logprint:
  log device: <DEVICE> daddr: <DADDR> length: <LENGTH>
  log tail: <COUNT> head: <COUNT> state: <CLEAN>
  override tail: <TAIL_BLK>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -20,12 +20,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:16
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -41,12 +36,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:24
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -62,12 +52,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:36
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -83,12 +68,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:44
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -104,12 +84,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:52
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -125,12 +100,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:60
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -146,12 +116,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:72
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -167,12 +132,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:80
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -188,12 +148,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:88
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -209,12 +164,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:96
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -230,12 +180,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:108
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -251,12 +196,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:116
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -272,12 +212,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:124
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -293,12 +228,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:132
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -314,12 +244,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:144
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -335,12 +260,7 @@ INO: cnt:C total:T
 	INODE: #regs:R ino:<INO> flags:0x3 dsize:152
 	CORE inode:
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:9 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -371,12 +291,7 @@ BUF: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -394,12 +309,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -417,12 +327,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -440,12 +345,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -463,12 +363,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -486,12 +381,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -509,12 +399,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -532,12 +417,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -555,12 +435,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -578,12 +453,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -601,12 +471,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -624,12 +489,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -647,12 +507,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -670,12 +525,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -693,12 +543,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -716,12 +561,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -739,12 +579,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -762,12 +597,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -785,12 +615,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -808,12 +633,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -831,12 +651,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -854,12 +669,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -877,12 +687,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -900,12 +705,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -923,12 +723,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -946,12 +741,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -969,12 +759,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -992,12 +777,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1015,12 +795,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1038,12 +813,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1061,12 +831,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1084,12 +849,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1107,12 +867,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1130,12 +885,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1153,12 +903,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1176,12 +921,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1199,12 +939,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1222,12 +957,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1245,12 +975,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1268,12 +993,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1291,12 +1011,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1314,12 +1029,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1337,12 +1047,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1360,12 +1065,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1383,12 +1083,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1416,12 +1111,7 @@ BUF: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1439,12 +1129,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1462,12 +1147,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1485,12 +1165,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1508,12 +1183,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1531,12 +1201,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1554,12 +1219,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1577,12 +1237,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1600,12 +1255,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1623,12 +1273,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1646,12 +1291,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1669,12 +1309,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1692,12 +1327,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1715,12 +1345,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1738,12 +1363,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1761,12 +1381,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1784,12 +1399,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1807,12 +1417,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1830,12 +1435,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1853,12 +1453,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1876,12 +1471,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1899,12 +1489,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1922,12 +1507,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1945,12 +1525,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1968,12 +1543,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1991,12 +1561,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2014,12 +1579,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2037,12 +1597,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2060,12 +1615,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2083,12 +1633,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2106,12 +1651,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2129,12 +1669,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2152,12 +1687,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2175,12 +1705,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2198,12 +1723,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2221,12 +1741,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2244,12 +1759,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2267,12 +1777,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2290,12 +1795,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-		icount:<COUNT> ifree:<FREE> fdblks:<BLOCKS> frext:<COUNT>
-		sunit:<SUNIT> swidth:<SWIDTH>
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2313,6 +1813,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
+TRANS: tid:<TID> type:SB_COUNT #items:1 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	SUPER Block Buffer:
diff --git a/082.trans_inode b/082.trans_inode
index 8ec3cf8..902bb1f 100644
--- a/082.trans_inode
+++ b/082.trans_inode
@@ -4,7 +4,7 @@ xfs_logprint:
  log device: <DEVICE> daddr: <DADDR> length: <LENGTH>
  log tail: <COUNT> head: <COUNT> state: <CLEAN>
  override tail: <TAIL_BLK>
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -28,10 +28,7 @@ INO: cnt:C total:T
 		size:0xf nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -55,10 +52,7 @@ INO: cnt:C total:T
 		size:0x18 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -82,10 +76,7 @@ INO: cnt:C total:T
 		size:0x21 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -109,10 +100,7 @@ INO: cnt:C total:T
 		size:0x2a nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -136,10 +124,7 @@ INO: cnt:C total:T
 		size:0x33 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -163,10 +148,7 @@ INO: cnt:C total:T
 		size:0x3c nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -190,10 +172,7 @@ INO: cnt:C total:T
 		size:0x45 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -217,10 +196,7 @@ INO: cnt:C total:T
 		size:0x4e nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -244,10 +220,7 @@ INO: cnt:C total:T
 		size:0x57 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -271,10 +244,7 @@ INO: cnt:C total:T
 		size:0x60 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -298,10 +268,7 @@ INO: cnt:C total:T
 		size:0x69 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -325,10 +292,7 @@ INO: cnt:C total:T
 		size:0x72 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -352,10 +316,7 @@ INO: cnt:C total:T
 		size:0x7b nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -379,10 +340,7 @@ INO: cnt:C total:T
 		size:0x84 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -406,10 +364,7 @@ INO: cnt:C total:T
 		size:0x8d nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:4 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -433,10 +388,7 @@ INO: cnt:C total:T
 		size:0x96 nblks:0x0 exsize:0 nextents:0 anextents:0
 		forkoff:0 dmevmask:0x0 dmstate:0 flags:0x0 gen:<GEN>
 		DATA FORK LOCAL inode data:
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:9 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -471,10 +423,7 @@ BUF: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -500,10 +449,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -529,10 +475,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -558,10 +501,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -587,10 +527,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -616,10 +553,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -645,10 +579,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -674,10 +605,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -703,10 +631,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -732,10 +657,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -761,10 +683,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -790,10 +709,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -819,10 +735,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -848,10 +761,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -877,10 +787,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -906,10 +813,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -935,10 +839,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -964,10 +865,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -993,10 +891,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1022,10 +917,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1051,10 +943,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1080,10 +969,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1109,10 +995,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1138,10 +1021,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1167,10 +1047,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1196,10 +1073,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1225,10 +1099,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1254,10 +1125,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1283,10 +1151,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1312,10 +1177,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1341,10 +1203,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1370,10 +1229,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1399,10 +1255,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1428,10 +1281,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1457,10 +1307,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1486,10 +1333,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1515,10 +1359,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1544,10 +1385,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1573,10 +1411,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1602,10 +1437,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1631,10 +1463,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1660,10 +1489,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1689,10 +1515,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1718,10 +1541,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1747,10 +1567,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:8 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:7 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1772,10 +1589,7 @@ BUF: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1801,10 +1615,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1830,10 +1641,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1859,10 +1667,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1888,10 +1693,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1917,10 +1719,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1946,10 +1745,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -1975,10 +1771,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2004,10 +1797,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2033,10 +1823,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2062,10 +1849,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2091,10 +1875,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2120,10 +1901,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2149,10 +1927,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2178,10 +1953,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2207,10 +1979,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2236,10 +2005,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2265,10 +2031,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2294,10 +2057,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2323,10 +2083,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2352,10 +2109,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2381,10 +2135,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2410,10 +2161,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2439,10 +2187,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2468,10 +2213,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2497,10 +2239,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2526,10 +2265,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2555,10 +2291,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2584,10 +2317,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2613,10 +2343,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2642,10 +2369,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2671,10 +2395,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2700,10 +2421,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2729,10 +2447,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2758,10 +2473,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2787,10 +2499,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2816,10 +2525,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2845,10 +2551,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2874,10 +2577,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
-BUF: cnt:C total:T
-	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
-	SUPER Block Buffer:
-TRANS: tid:<TID> type:CREATE #items:6 trans:0x0 q:<Q>
+TRANS: tid:<TID> type:CREATE #items:5 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	AGI Buffer: (XAGI)
@@ -2903,6 +2603,7 @@ INO: cnt:C total:T
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:2
 	BUF DATA
+TRANS: tid:<TID> type:SB_COUNT #items:1 trans:0x0 q:<Q>
 BUF: cnt:C total:T
 	BUF: #regs:R start blkno:<BLKNO> len:<LEN> bmap size:1
 	SUPER Block Buffer:
diff --git a/186 b/186
index cade4d8..524c9ee 100755
--- a/186
+++ b/186
@@ -148,7 +148,7 @@ _supported_os Linux
 _require_scratch
 rm -f $seq.full
 
-_scratch_mkfs -i attr=2,size=512 >/dev/null 2>&1
+_scratch_mkfs -i attr=2,size=512 -l lazy-count=1 >/dev/null 2>&1
 
 # set inum to root dir ino
 # we'll add in dirents and EAs into the root directory
diff --git a/187 b/187
index 0328313..cb5b9ca 100755
--- a/187
+++ b/187
@@ -68,7 +68,7 @@ export MOUNT_OPTIONS=""
 # Make sure that when we think we are testing with morebits off
 # that we really are.
 # Trying to future-proof in case mkfs defaults change.
-_scratch_mkfs -i attr=1 >/dev/null 2>&1
+_scratch_mkfs -i attr=1 -l lazy-count=0 >/dev/null 2>&1
 $XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 >$tmp.db
 if grep -i morebits $tmp.db
 then
diff --git a/199 b/199
index 98290e9..918e849 100755
--- a/199
+++ b/199
@@ -50,7 +50,7 @@ _supported_os Linux
 
 _require_scratch
 
-_scratch_mkfs_xfs >/dev/null 2>&1
+_scratch_mkfs_xfs -l lazy-count=1 >/dev/null 2>&1
 
 #
 # Print the current flags.  Just a dummy so that the test breaks
diff --git a/199.out b/199.out
index 45eaa81..0f299d7 100644
--- a/199.out
+++ b/199.out
@@ -1,13 +1,13 @@
 QA output created by 199
 Default feature2 flags:
-features2 = 0x8
-bad_features2 = 0x8
+features2 = 0xa
+bad_features2 = 0xa
 Clearing features2:
 features2 = 0
 Features 2 after mount rw:
-features2 = 0x8
+features2 = 0xa
 Clearing features2:
 features2 = 0
 Features 2 after mount ro and remount rw:
-features2 = 0x8
+features2 = 0xa
 *** done
diff --git a/216 b/216
old mode 100644
new mode 100755
diff --git a/217 b/217
old mode 100644
new mode 100755
diff --git a/common.log b/common.log
index c4aaf4f..56a2012 100644
--- a/common.log
+++ b/common.log
@@ -286,7 +286,7 @@ _mkfs_log()
 {
     # create the FS
     # mkfs options to append to log size otion can be specified ($*)
-    export MKFS_OPTIONS="-l size=2000b $*"
+    export MKFS_OPTIONS="-l size=2000b -l lazy-count=1 $*"
     _full "mkfs"
     _scratch_mkfs_xfs >>$seq.full 2>&1
     if [ $? -ne 0 ] ; then 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
