Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9CNms1S113238 for <xfs@oss.sgi.com>; Wed, 12 Oct 2011 18:48:55 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7DBAE1C1721
	for <xfs@oss.sgi.com>; Wed, 12 Oct 2011 16:48:52 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	bpwxs6bjd4tZHKou for <xfs@oss.sgi.com>;
	Wed, 12 Oct 2011 16:48:52 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RE8XP-0002Eq-GY
	for xfs@oss.sgi.com; Thu, 13 Oct 2011 10:48:39 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RE8XP-0003iV-2h
	for xfs@oss.sgi.com; Thu, 13 Oct 2011 10:48:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfstests: fix 165 for different block sizes
Date: Thu, 13 Oct 2011 10:48:39 +1100
Message-Id: <1318463319-14257-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

xfs_io uses the filesystem block size as the default write buffer
size. 165 does not filter the ops counts out of the golden output,
and hnce causes failures because the ops count doesn't match for a
given sized write. Fix this by changing the filter to the generic
xfs_io no-numbers filter.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 165     |    9 +--------
 165.out |   26 +++++++++++++-------------
 2 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/165 b/165
index d47ad8e..ec349da 100755
--- a/165
+++ b/165
@@ -41,16 +41,9 @@ _cleanup()
     rm -f $tmp.*
 }
 
-#
-# Filter out these lines partially
-# From:
-#   40 KiB, 10 ops; 0.0000 sec (4.070 MiB/sec and 1041.9923 ops/sec)
-# To:
-#   40 KiB, 10 ops
-#
 _filter_io()
 {
-    tee -a $seq.full | sed 's/ops;.*/ops/'
+    tee -a $seq.full | _filter_xfs_io
 }
 
 #
diff --git a/165.out b/165.out
index e7c6213..7054431 100644
--- a/165.out
+++ b/165.out
@@ -1,36 +1,36 @@
 QA output created by 165
 wrote 40960/40960 bytes at offset 0
-40 KiB, 10 ops
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 
 *** offset = 0k ***
 
 wrote 4096/4096 bytes at offset 0
-4 KiB, 1 ops
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 
 *** offset = 8k ***
 
 wrote 4096/4096 bytes at offset 8192
-4 KiB, 1 ops
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 
 *** offset = 16k ***
 
 wrote 4096/4096 bytes at offset 16384
-4 KiB, 1 ops
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 
 *** offset = 24k ***
 
 wrote 4096/4096 bytes at offset 24576
-4 KiB, 1 ops
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 
 *** offset = 32k ***
 
 wrote 4096/4096 bytes at offset 32768
-4 KiB, 1 ops
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 
 *** offset = 40k ***
 
 wrote 4096/4096 bytes at offset 40960
-4 KiB, 1 ops
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 00000000:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 00000010:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 00000020:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
@@ -288,7 +288,7 @@ wrote 4096/4096 bytes at offset 40960
 00000fe0:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 00000ff0:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 read 4096/4096 bytes at offset 0
-4 KiB, 1 ops
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 00004000:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 00004010:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 00004020:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
@@ -546,7 +546,7 @@ read 4096/4096 bytes at offset 0
 00004fe0:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 00004ff0:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 read 4096/4096 bytes at offset 16384
-4 KiB, 1 ops
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 00006000:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 00006010:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 00006020:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
@@ -804,7 +804,7 @@ read 4096/4096 bytes at offset 16384
 00006fe0:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 00006ff0:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 read 4096/4096 bytes at offset 24576
-4 KiB, 1 ops
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 00008000:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 00008010:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 00008020:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
@@ -1062,7 +1062,7 @@ read 4096/4096 bytes at offset 24576
 00008fe0:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 00008ff0:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 read 4096/4096 bytes at offset 32768
-4 KiB, 1 ops
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 0000a000:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 0000a010:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 0000a020:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
@@ -1320,7 +1320,7 @@ read 4096/4096 bytes at offset 32768
 0000afe0:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 0000aff0:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 read 4096/4096 bytes at offset 40960
-4 KiB, 1 ops
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 00002000:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 00002010:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 00002020:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
@@ -1578,4 +1578,4 @@ read 4096/4096 bytes at offset 40960
 00002fe0:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 00002ff0:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
 read 4096/4096 bytes at offset 8192
-4 KiB, 1 ops
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
