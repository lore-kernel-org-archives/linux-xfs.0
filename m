Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 214547CA3
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:40:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 10DD88F8033
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:40:08 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id XYBHgH9Ch70LO4sx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:40:06 -0800 (PST)
Subject: [PATCH 07/32] common: create _require_test_program to look for
	programs in src/
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:40:02 -0800
Message-ID: <20160211234002.2202.899.stgit@birch.djwong.org>
In-Reply-To: <20160211233916.2202.40961.stgit@birch.djwong.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Create a helper that looks for a test program in src/ and fails the
test if it doesn't exist.  Refactor the existing testcases to use it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc         |    9 +++++++++
 tests/generic/010 |    2 +-
 tests/generic/094 |    2 +-
 tests/generic/225 |    2 +-
 tests/generic/285 |    2 +-
 tests/generic/286 |    2 +-
 tests/generic/311 |    2 +-
 tests/xfs/032     |    3 +--
 tests/xfs/044     |    2 +-
 9 files changed, 17 insertions(+), 9 deletions(-)


diff --git a/common/rc b/common/rc
index 84f794a..63eb90b 100644
--- a/common/rc
+++ b/common/rc
@@ -1684,6 +1684,15 @@ _require_aiodio()
     _require_odirect
 }
 
+# this test requires that a test program exists under src/
+# $1 - command (require)
+#
+_require_test_program()
+{
+    SRC_TEST=src/$1
+    [ -x $SRC_TEST ] || _notrun "$SRC_TEST not built"
+}
+
 # run an aio-dio program
 # $1 - command
 _run_aiodio()
diff --git a/tests/generic/010 b/tests/generic/010
index ea8ea50..1c9d8f7 100755
--- a/tests/generic/010
+++ b/tests/generic/010
@@ -51,7 +51,7 @@ _filter_dbtest()
 . ./common/rc
 . ./common/filter
 
-[ -x $here/src/dbtest ] || _notrun "dbtest was not built for this platform"
+_require_test_program "dbtest"
 
 # real QA test starts here
 _supported_fs generic
diff --git a/tests/generic/094 b/tests/generic/094
index 4e4b668..a51738a 100644
--- a/tests/generic/094
+++ b/tests/generic/094
@@ -53,7 +53,7 @@ _scratch_mount > /dev/null 2>&1
 rm -f $seqres.full
 fiemapfile=$SCRATCH_MNT/$seq.fiemap
 
-[ -x $here/src/fiemap-tester ] || _notrun "fiemap-tester not built"
+_require_test_program "fiemap-tester"
 
 seed=`date +%s`
 
diff --git a/tests/generic/225 b/tests/generic/225
index 6134c8c..c8e0f64 100755
--- a/tests/generic/225
+++ b/tests/generic/225
@@ -53,7 +53,7 @@ rm -f $seqres.full
 fiemapfile=$SCRATCH_MNT/$seq.fiemap
 fiemaplog=$SCRATCH_MNT/$seq.log
 
-[ -x $here/src/fiemap-tester ] || _notrun "fiemap-tester not built"
+_require_test_program "fiemap-tester"
 
 seed=`date +%s`
 
diff --git a/tests/generic/285 b/tests/generic/285
index d6275b5..16e70b1 100755
--- a/tests/generic/285
+++ b/tests/generic/285
@@ -45,7 +45,7 @@ _require_seek_data_hole
 
 BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
 
-[ -x $here/src/seek_sanity_test ] || _notrun "seek_sanitfy_tester not built"
+_require_test_program "seek_sanity_test"
 
 # Disable extent zeroing for ext4 as that change where holes are created
 if [ "$FSTYP" = "ext4" ]; then
diff --git a/tests/generic/286 b/tests/generic/286
index f6bf356..f88f079 100755
--- a/tests/generic/286
+++ b/tests/generic/286
@@ -44,7 +44,7 @@ _require_seek_data_hole
 src=$TEST_DIR/seek_copy_testfile
 dest=$TEST_DIR/seek_copy_testfile.dest
 
-[ -x $here/src/seek_copy_test ] || _notrun "seek_copy_test not built"
+_require_test_program "seek_copy_test"
 
 _cleanup()
 {
diff --git a/tests/generic/311 b/tests/generic/311
index f552011..69bc1bf 100755
--- a/tests/generic/311
+++ b/tests/generic/311
@@ -62,7 +62,7 @@ _require_metadata_journaling $SCRATCH_DEV
 # the test system supports fallocate() for allocation
 _require_xfs_io_command "falloc"
 
-[ -x $here/src/fsync-tester ] || _notrun "fsync-tester not built"
+_require_test_program "fsync-tester"
 
 rm -f $seqres.full
 SEED=1
diff --git a/tests/xfs/032 b/tests/xfs/032
index 063f272..6216379 100755
--- a/tests/xfs/032
+++ b/tests/xfs/032
@@ -40,8 +40,7 @@ _supported_fs xfs
 _supported_os IRIX Linux
 
 _require_scratch
-
-[ $here/src/feature ] || _notrun "src/feature not built, skipping this test"
+_require_test_program "feature"
 
 [ "$USE_EXTERNAL" = yes ] && _notrun "Cannot xfs_copy with external devices"
 [ -n "$XFS_COPY_PROG" ] || _notrun "xfs_copy binary not yet installed"
diff --git a/tests/xfs/044 b/tests/xfs/044
index 2ffd74f..ea58c07 100755
--- a/tests/xfs/044
+++ b/tests/xfs/044
@@ -124,7 +124,7 @@ _filter_mkfs <$tmp.mkfs0 2>$tmp.mkfs1
 [ $lversion -ne 1 ] && \
     _notrun "Cannot run this test yet using MKFS_OPTIONS specified"
 
-[ $here/src/loggen ] || _notrun "loggen not built, skipping test"
+_require_test_program "loggen"
 
 _check_mount
 _check_require_logdev

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
