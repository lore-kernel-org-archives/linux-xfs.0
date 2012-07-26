Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q9StOM006981 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 04:28:56 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	QTeGtVuNQn4U1s8Q for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 02:28:53 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuKNB-0001Bc-Kb
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:45 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuKN1-0005WL-Fu
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 18/18] xfstests: fix _link_out_file callers
Date: Thu, 26 Jul 2012 19:28:12 +1000
Message-Id: <1343294892-20991-19-git-send-email-david@fromorbit.com>
In-Reply-To: <1343294892-20991-1-git-send-email-david@fromorbit.com>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
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

Currently the callers pass $seq, rather than the full path to the
test. As a result, it creates the link in the top level directory
and it points nowhere.  Fix it to create the link in the correct
place.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common.rc         |   26 +++++++++++++-------------
 tests/generic/088 |    3 ++-
 tests/xfs/018     |    9 +++++----
 tests/xfs/022     |    3 ++-
 tests/xfs/023     |    3 ++-
 tests/xfs/030     |    3 ++-
 tests/xfs/031     |    3 ++-
 tests/xfs/033     |    3 ++-
 tests/xfs/035     |    3 ++-
 tests/xfs/036     |    3 ++-
 tests/xfs/039     |    3 ++-
 tests/xfs/043     |    3 ++-
 tests/xfs/055     |    3 ++-
 tests/xfs/082     |    9 +++++----
 tests/xfs/146     |    3 ++-
 15 files changed, 47 insertions(+), 33 deletions(-)

diff --git a/common.rc b/common.rc
index b53734b..7c0d3a8 100644
--- a/common.rc
+++ b/common.rc
@@ -1720,19 +1720,19 @@ _cleanup_testdir()
 
 _link_out_file()
 {
-   if [ -z "$1" ]; then
-      echo Error must pass \$seq.
-      exit
-   fi
-   rm -f $1
-   if [ "`uname`" == "IRIX64" ] || [ "`uname`" == "IRIX" ]; then
-      ln -s $1.irix $1
-   elif [ "`uname`" == "Linux" ]; then
-      ln -s $1.linux $1
-   else
-      echo Error test $seq does not run on the operating system: `uname`
-      exit
-   fi
+	if [ -z "$1" -o -z "$2" ]; then
+		echo Error must pass src and dst.
+		exit
+	fi
+	rm -f $1
+	if [ "`uname`" == "IRIX64" ] || [ "`uname`" == "IRIX" ]; then
+		ln -s $1.irix $2
+	elif [ "`uname`" == "Linux" ]; then
+		ln -s $1.linux $2
+	else
+		echo Error test $seq does not run on the operating system: `uname`
+		exit
+	fi
 }
 
 _die()
diff --git a/tests/generic/088 b/tests/generic/088
index 1386322..1158b46 100755
--- a/tests/generic/088
+++ b/tests/generic/088
@@ -23,6 +23,7 @@
 #-----------------------------------------------------------------------
 #
 
+seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
@@ -42,7 +43,7 @@ _filter()
 }
 
 # link correct .out file
-_link_out_file $seq.out
+_link_out_file $seq.out $seqfull.out
 
 # real QA test starts here
 _supported_fs generic
diff --git a/tests/xfs/018 b/tests/xfs/018
index ed99f20..7f22b54 100755
--- a/tests/xfs/018
+++ b/tests/xfs/018
@@ -22,6 +22,7 @@
 #-----------------------------------------------------------------------
 #
 
+seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
@@ -53,7 +54,7 @@ _require_scratch
 _require_v2log
 
 # link correct .out file
-_link_out_file $seq.op
+_link_out_file $seq.op $seqfull.op
 
 
 echo "*** init FS"
@@ -88,13 +89,13 @@ do
     _check_log
 
     _print_operation
-    _cmp_op_output $seq.op $filtered
+    _cmp_op_output $seqfull.op $filtered
 
     _print_transaction_inode $start_blk
-    _cmp_output $seq.trans_inode $filtered
+    _cmp_output $seqfull.trans_inode $filtered
 
     _print_transaction_buf $start_blk
-    _cmp_output $seq.trans_buf $filtered
+    _cmp_output $seqfull.trans_buf $filtered
 done
 
 # got thru it all so we may have success
diff --git a/tests/xfs/022 b/tests/xfs/022
index 0251936..39f4b02 100755
--- a/tests/xfs/022
+++ b/tests/xfs/022
@@ -25,6 +25,7 @@
 #-----------------------------------------------------------------------
 #
 
+seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
@@ -38,7 +39,7 @@ trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
 . ./common.dump
 
 # link correct .out file
-_link_out_file $seq.out
+_link_out_file $seq.out $seqfull.out
 
 # real QA test starts here
 _supported_fs xfs
diff --git a/tests/xfs/023 b/tests/xfs/023
index 7bb77da..b133055 100755
--- a/tests/xfs/023
+++ b/tests/xfs/023
@@ -23,6 +23,7 @@
 #-----------------------------------------------------------------------
 #
 
+seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
@@ -37,7 +38,7 @@ trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
 . ./common.dump
 
 # link correct .out file
-_link_out_file $seq.out
+_link_out_file $seq.out $seqfull.out
 
 # real QA test starts here
 _supported_fs xfs
diff --git a/tests/xfs/030 b/tests/xfs/030
index f9c1dfb..b189128 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -22,6 +22,7 @@
 #-----------------------------------------------------------------------
 #
 
+seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
@@ -45,7 +46,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 . ./common.repair
 
 # link correct .out file
-_link_out_file $seq.out
+_link_out_file $seq.out $seqfull.out
 
 # nuke the superblock, AGI, AGF, AGFL; then try repair the damage
 #
diff --git a/tests/xfs/031 b/tests/xfs/031
index 3dec089..c089021 100755
--- a/tests/xfs/031
+++ b/tests/xfs/031
@@ -22,6 +22,7 @@
 #-----------------------------------------------------------------------
 #
 
+seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
@@ -38,7 +39,7 @@ rm -f $seqres.full
 . ./common.filter
 
 # link correct .out file
-_link_out_file $seq.out
+_link_out_file $seq.out $seqfull.out
 
 _check_repair()
 {
diff --git a/tests/xfs/033 b/tests/xfs/033
index 1540a1c..e95cae4 100755
--- a/tests/xfs/033
+++ b/tests/xfs/033
@@ -22,6 +22,7 @@
 #-----------------------------------------------------------------------
 #
 
+seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
@@ -45,7 +46,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 . ./common.repair
 
 # link correct .out file
-_link_out_file $seq.out
+_link_out_file $seq.out $seqfull.out
 
 # nuke the root, rt bitmap, and rt summary inodes
 # 
diff --git a/tests/xfs/035 b/tests/xfs/035
index cd743f6..de9b9df 100755
--- a/tests/xfs/035
+++ b/tests/xfs/035
@@ -22,6 +22,7 @@
 #-----------------------------------------------------------------------
 #
 
+seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
@@ -36,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common.dump
 
 # link correct .out file
-_link_out_file $seq.out
+_link_out_file $seq.out $seqfull.out
 
 # real QA test starts here
 _supported_fs xfs
diff --git a/tests/xfs/036 b/tests/xfs/036
index 5a7ee01..1578e8e 100755
--- a/tests/xfs/036
+++ b/tests/xfs/036
@@ -22,6 +22,7 @@
 #-----------------------------------------------------------------------
 #
 
+seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
@@ -36,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common.dump
 
 # link correct .out file
-_link_out_file $seq.out
+_link_out_file $seq.out $seqfull.out
 
 # real QA test starts here
 _supported_fs xfs
diff --git a/tests/xfs/039 b/tests/xfs/039
index 21574d6..ebab798 100755
--- a/tests/xfs/039
+++ b/tests/xfs/039
@@ -22,6 +22,7 @@
 #-----------------------------------------------------------------------
 #
 
+seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
@@ -36,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common.dump
 
 # link correct .out file
-_link_out_file $seq.out
+_link_out_file $seq.out $seqfull.out
 
 # real QA test starts here
 _supported_fs xfs
diff --git a/tests/xfs/043 b/tests/xfs/043
index 75c2d38..9c56ac1 100755
--- a/tests/xfs/043
+++ b/tests/xfs/043
@@ -24,6 +24,7 @@
 #-----------------------------------------------------------------------
 #
 
+seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
@@ -38,7 +39,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common.dump
 
 # link correct .out file
-_link_out_file $seq.out
+_link_out_file $seq.out $seqfull.out
 
 # real QA test starts here
 _supported_fs xfs
diff --git a/tests/xfs/055 b/tests/xfs/055
index 1804727..4c04b0a 100755
--- a/tests/xfs/055
+++ b/tests/xfs/055
@@ -22,6 +22,7 @@
 #-----------------------------------------------------------------------
 #
 
+seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
@@ -36,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common.dump
 
 # link correct .out file
-_link_out_file $seq.out
+_link_out_file $seq.out $seqfull.out
 
 # real QA test starts here
 _supported_fs xfs
diff --git a/tests/xfs/082 b/tests/xfs/082
index 652f362..9ab1611 100755
--- a/tests/xfs/082
+++ b/tests/xfs/082
@@ -22,6 +22,7 @@
 #-----------------------------------------------------------------------
 #
 
+seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
@@ -54,7 +55,7 @@ _require_scratch
 _require_v2log 
 
 # link correct .out file
-_link_out_file $seq.op
+_link_out_file $seq.op $seqfull.op
 
 echo "*** init FS"
 umount $SCRATCH_DEV >/dev/null 2>&1
@@ -118,14 +119,14 @@ for s in sync nosync ; do
 	    :
 	else
 	    _print_operation
-	    _cmp_op_output $seq.op $filtered
+	    _cmp_op_output $seqfull.op $filtered
 	fi
 
 	_print_transaction_inode $start
-	_cmp_output $seq.trans_inode $filtered
+	_cmp_output $seqfull.trans_inode $filtered
 
 	_print_transaction_buf $start
-	_cmp_output $seq.trans_buf $filtered
+	_cmp_output $seqfull.trans_buf $filtered
     done
 done
 
diff --git a/tests/xfs/146 b/tests/xfs/146
index 2091db1..e79d59e 100755
--- a/tests/xfs/146
+++ b/tests/xfs/146
@@ -22,6 +22,7 @@
 #-----------------------------------------------------------------------
 #
 
+seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
@@ -52,7 +53,7 @@ _supported_fs xfs
 _supported_os Linux IRIX
 
 # link correct .out file
-_link_out_file $seq.out
+_link_out_file $seq.out $seqfull.out
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
