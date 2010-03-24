Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2O3PbRm183958 for <xfs@oss.sgi.com>; Tue, 23 Mar 2010 22:25:38 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B75D91A34DDC
	for <xfs@oss.sgi.com>; Tue, 23 Mar 2010 20:27:18 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id EzTXd80FEHEqFNI2 for
	<xfs@oss.sgi.com>; Tue, 23 Mar 2010 20:27:18 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id E94E99E847E
	for <xfs@oss.sgi.com>; Tue, 23 Mar 2010 22:27:16 -0500 (CDT)
Message-ID: <4BA98694.2070506@sandeen.net>
Date: Tue, 23 Mar 2010 22:27:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: filter 203 mount point
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

Right now this only works if TEST_DIR == /mnt/test

diff --git a/203 b/203
index 174bdae..80c449d 100755
--- a/203
+++ b/203
@@ -48,6 +48,7 @@ _write_holes()
 #       1: [8..2047]: hole
 _filter_bmap()
 {
+	sed "s#$TEST_DIR#TEST_DIR#g" | \
 	awk '$3 ~ /hole/ { print $1, $2, $3; next }
              {print $1, $2; next}'
 }
diff --git a/203.out b/203.out
index 1b1bddc..1694457 100644
--- a/203.out
+++ b/203.out
@@ -1,5 +1,5 @@
 QA output created by 203
-/mnt/test/hole_file10: 
+TEST_DIR/hole_file10: 
 0: [0..7]:
 1: [8..2047]: hole
 2: [2048..2055]:
@@ -24,7 +24,7 @@ QA output created by 203
 21: [20488..22527]: hole
 22: [22528..22535]:
 
-/mnt/test/hole_file14: 
+TEST_DIR/hole_file14: 
 0: [0..7]:
 1: [8..2047]: hole
 2: [2048..2055]:
@@ -57,7 +57,7 @@ QA output created by 203
 29: [28680..30719]: hole
 30: [30720..30727]:
 
-/mnt/test/hole_file15: 
+TEST_DIR/hole_file15: 
 0: [0..7]:
 1: [8..2047]: hole
 2: [2048..2055]:
@@ -92,7 +92,7 @@ QA output created by 203
 31: [30728..32767]: hole
 32: [32768..32775]:
 
-/mnt/test/hole_file16: 
+TEST_DIR/hole_file16: 
 0: [0..7]:
 1: [8..2047]: hole
 2: [2048..2055]:
@@ -129,7 +129,7 @@ QA output created by 203
 33: [32776..34815]: hole
 34: [34816..34823]:
 
-/mnt/test/hole_file17: 
+TEST_DIR/hole_file17: 
 0: [0..7]:
 1: [8..2047]: hole
 2: [2048..2055]:
@@ -168,7 +168,7 @@ QA output created by 203
 35: [34824..36863]: hole
 36: [36864..36871]:
 
-/mnt/test/hole_file28: 
+TEST_DIR/hole_file28: 
 0: [0..7]:
 1: [8..2047]: hole
 2: [2048..2055]:
@@ -229,7 +229,7 @@ QA output created by 203
 57: [57352..59391]: hole
 58: [59392..59399]:
 
-/mnt/test/hole_file29: 
+TEST_DIR/hole_file29: 
 0: [0..7]:
 1: [8..2047]: hole
 2: [2048..2055]:
@@ -292,7 +292,7 @@ QA output created by 203
 59: [59400..61439]: hole
 60: [61440..61447]:
 
-/mnt/test/hole_file30: 
+TEST_DIR/hole_file30: 
 0: [0..7]:
 1: [8..2047]: hole
 2: [2048..2055]:
@@ -357,7 +357,7 @@ QA output created by 203
 61: [61448..63487]: hole
 62: [63488..63495]:
 
-/mnt/test/hole_file31: 
+TEST_DIR/hole_file31: 
 0: [0..7]:
 1: [8..2047]: hole
 2: [2048..2055]:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
