Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 23:37:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2K6anIW029063
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 23:36:52 -0700
Date: Thu, 20 Mar 2008 17:37:13 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH] XFSQA 166: support varying page sizes
Message-ID: <20080320063713.GC103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Make the filter check the resultant output based on
the initial written region size. hence page size of the
machine will not affect the output of the filter.
Modify the golden output to match.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 xfstests/166     |   38 +++++++++++++++++++++++++++++++-------
 xfstests/166.out |   10 +++++-----
 2 files changed, 36 insertions(+), 12 deletions(-)

Index: xfs-cmds/xfstests/166.out
===================================================================
--- xfs-cmds.orig/xfstests/166.out	2007-06-20 13:42:46.000000000 +1000
+++ xfs-cmds/xfstests/166.out	2008-03-19 09:40:03.518840554 +1100
@@ -1,6 +1,6 @@
 QA output created by 166
-0: [0..31]: XX..YY AG (AA..BB) 32
-1: [32..127]: XX..YY AG (AA..BB) 96 10000
-2: [128..159]: XX..YY AG (AA..BB) 32
-3: [160..223]: XX..YY AG (AA..BB) 64 10000
-4: [224..255]: XX..YY AG (AA..BB) 32
+0: [AA..BB] XX..YY AG (AA..BB) RIGHT GOOD
+1: [AA..BB] XX..YY AG (AA..BB) RIGHT GOOD
+2: [AA..BB] XX..YY AG (AA..BB) RIGHT GOOD
+3: [AA..BB] XX..YY AG (AA..BB) RIGHT GOOD
+4: [AA..BB] XX..YY AG (AA..BB) RIGHT GOOD
Index: xfs-cmds/xfstests/166
===================================================================
--- xfs-cmds.orig/xfstests/166	2007-06-20 13:42:46.000000000 +1000
+++ xfs-cmds/xfstests/166	2008-03-19 09:40:03.518840554 +1100
@@ -27,14 +27,38 @@ _cleanup()
 . ./common.rc
 . ./common.filter
 
+# assumes 1st, 3rd and 5th blocks are single written blocks,
+# the others are unwritten.
 _filter_blocks()
 {
-	$AWK_PROG '/[0-9]/ {
-		if ($7)
-			print $1, $2, "XX..YY", "AG", "(AA..BB)", $6, $7;
-		else
-			print $1, $2, "XX..YY", "AG", "(AA..BB)", $6;
-	}'
+	$AWK_PROG '
+/[0-9]/ {
+	if (!written_size) {
+		written_size = $6
+		unwritten1 = ((1048576/512) / 2) - written_size
+		unwritten2 = ((1048576/512) / 2) - 2 * written_size
+	}
+
+	if ($7) {
+		size = "RIGHT"
+		flags = "GOOD"
+		if (unwritten1) {
+			if ($6 != unwritten1)
+				size = "WRONG"
+			unwritten1 = 0;
+		} else if ($6 != unwritten2) {
+			size = "WRONG"
+		}
+		if ($7 < 10000)
+			flags = "BAD"
+	} else {
+		size = "RIGHT"
+		flags = "GOOD"
+		if ($6 != written_size)
+			size = "WRONG"
+	}
+	print $1, "[AA..BB]", "XX..YY", "AG", "(AA..BB)", size, flags
+}'
 }
 
 # real QA test starts here
@@ -48,7 +72,7 @@ _scratch_mount
 
 TEST_FILE=$SCRATCH_MNT/test_file
 TEST_PROG=$here/src/unwritten_mmap
-FILE_SIZE=131072
+FILE_SIZE=1048576
 
 rm -f $TEST_FILE
 $TEST_PROG $FILE_SIZE $TEST_FILE
