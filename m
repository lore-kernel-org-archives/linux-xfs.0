Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Apr 2008 20:36:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3B3ZsPF007307
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 20:35:56 -0700
Date: Fri, 11 Apr 2008 13:36:28 +1000
From: David Chinner <dgc@sgi.com>
Subject: [patch] xfsqa - 166 - fix filter for stripe aligned filesystems
Message-ID: <20080411033628.GN103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Flags has extra bits set in it xfs_bmap output when
the filesyste is using stripe alignment. Fix the test
to only look at the unwritten flag. Capture the xfs_bmap
output as well so failures can be debugged easily.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 xfstests/166 |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

Index: xfs-cmds/xfstests/166
===================================================================
--- xfs-cmds.orig/xfstests/166	2008-03-25 15:29:35.000000000 +1100
+++ xfs-cmds/xfstests/166	2008-04-11 13:33:31.220068950 +1000
@@ -17,6 +17,7 @@ here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
 trap "_cleanup; exit \$status" 0 1 2 3 15
+rm $seq.full
 
 _cleanup()
 {
@@ -39,9 +40,14 @@ _filter_blocks()
 		unwritten2 = ((1048576/512) / 2) - 2 * written_size
 	}
 
-	if ($7) {
-		size = "RIGHT"
-		flags = "GOOD"
+	/* is the extent unwritten? */
+	unwritten_ext = 0;
+	if ($7 >= 10000)
+		unwritten_ext = 1;
+
+	size = "RIGHT"
+	flags = "GOOD"
+	if (unwritten_ext) {
 		if (unwritten1) {
 			if ($6 != unwritten1)
 				size = "WRONG"
@@ -49,11 +55,7 @@ _filter_blocks()
 		} else if ($6 != unwritten2) {
 			size = "WRONG"
 		}
-		if ($7 < 10000)
-			flags = "BAD"
 	} else {
-		size = "RIGHT"
-		flags = "GOOD"
 		if ($6 != written_size)
 			size = "WRONG"
 	}
@@ -77,6 +79,7 @@ FILE_SIZE=1048576
 rm -f $TEST_FILE
 $TEST_PROG $FILE_SIZE $TEST_FILE
 
+xfs_bmap -vp $TEST_FILE >> $seq.full
 xfs_bmap -vp $TEST_FILE | _filter_blocks
 
 status=0
