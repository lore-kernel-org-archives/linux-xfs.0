Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAT4P9Cr260011 for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 22:25:09 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	qISMuPfMKTHmegxr for <xfs@oss.sgi.com>;
	Wed, 28 Nov 2012 20:27:25 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Tdvie-00073h-CU
	for xfs@oss.sgi.com; Thu, 29 Nov 2012 15:27:24 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Tdvid-0004PO-U9
	for xfs@oss.sgi.com; Thu, 29 Nov 2012 15:27:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfstests: update XFS_IOC_ZERO_RANGE byte range test output
Date: Thu, 29 Nov 2012 15:27:23 +1100
Message-Id: <1354163243-16916-1-git-send-email-david@fromorbit.com>
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

Kernel code now does true byte range zeroing. Update the tests to
validate true byte range zeroing correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 242.out |    4 ++--
 290.out |   14 +++++++++-----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/242.out b/242.out
index 649ac04..72026a3 100644
--- a/242.out
+++ b/242.out
@@ -73,5 +73,5 @@ eecb7aa303d121835de05028751d301c
 1: [16..39]: data
 eecb7aa303d121835de05028751d301c
 	17. data -> hole in single block file
-0: [0..7]: unwritten
-56819989ef2d9f40785adce8c06b64d0
+0: [0..7]: data
+13535fd4d496bf0b74bb2335aa4d1b31
diff --git a/290.out b/290.out
index fc01f36..229c2b3 100644
--- a/290.out
+++ b/290.out
@@ -3,7 +3,8 @@ wrote 4096/4096 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 4096/4096 bytes at offset 4096
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+00000000:  00 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  .AAAAAAAAAAAAAAA
+00000010:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
 *
 00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
 *
@@ -13,8 +14,9 @@ wrote 4096/4096 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 4096/4096 bytes at offset 4096
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 *
+00000ff0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41  ...............A
 00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
 *
 read 8192/8192 bytes at offset 0
@@ -35,7 +37,8 @@ wrote 4096/4096 bytes at offset 4096
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 *
-00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+00001000:  00 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  .BBBBBBBBBBBBBBB
+00001010:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
 *
 read 8192/8192 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
@@ -46,8 +49,9 @@ XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
 *
 00000ff0:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 00  AAAAAAAAAAAAAAA.
-00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+00001000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 *
+00001ff0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42  ...............B
 read 8192/8192 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 4096/4096 bytes at offset 0
@@ -90,7 +94,7 @@ XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 *
 00000400:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 *
-00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+00001400:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
 *
 read 8192/8192 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
