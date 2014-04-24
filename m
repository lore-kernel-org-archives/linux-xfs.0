Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 03F0B7F52
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 11:01:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D368E304051
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 09:01:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id iVc9KpV5dyoiuO0Y for
	<xfs@oss.sgi.com>; Thu, 24 Apr 2014 09:01:49 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3OG1l8U020513
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 12:01:48 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] xfstests: Use _require_xfs_io_command() instead of helpers
Date: Thu, 24 Apr 2014 18:01:43 +0200
Message-Id: <1398355303-29348-1-git-send-email-lczerner@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Lukas Czerner <lczerner@redhat.com>

Number of helpers for checking xfs_io functionality is slowly growing.
But it's as easy to simply use _require_xfs_io_command() directly and
just specify the command we want to check. It will also avoid the need
to create helper every time we need to check a new command in xfs_io.

Remove all the helpers and use _require_xfs_io_command() in the tests.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 common/defrag     |  2 +-
 common/rc         | 41 -----------------------------------------
 tests/btrfs/026   |  2 +-
 tests/btrfs/027   |  2 +-
 tests/btrfs/028   |  2 +-
 tests/btrfs/047   |  2 +-
 tests/ext4/001    |  2 +-
 tests/ext4/002    |  2 +-
 tests/generic/009 |  2 +-
 tests/generic/012 |  8 ++++----
 tests/generic/016 |  8 ++++----
 tests/generic/017 |  4 ++--
 tests/generic/021 |  8 ++++----
 tests/generic/022 |  8 ++++----
 tests/generic/213 |  2 +-
 tests/generic/214 |  2 +-
 tests/generic/223 |  2 +-
 tests/generic/228 |  2 +-
 tests/generic/255 |  6 +++---
 tests/generic/256 |  2 +-
 tests/generic/274 |  2 +-
 tests/generic/300 |  4 ++--
 tests/generic/311 |  2 +-
 tests/generic/312 |  2 +-
 tests/generic/316 |  4 ++--
 tests/shared/298  |  2 +-
 tests/xfs/252     |  4 ++--
 tests/xfs/290     |  2 +-
 28 files changed, 45 insertions(+), 86 deletions(-)

diff --git a/common/defrag b/common/defrag
index a4bc976..732cd64 100644
--- a/common/defrag
+++ b/common/defrag
@@ -38,7 +38,7 @@ _require_defrag()
     esac
 
     _require_command $DEFRAG_PROG
-    _require_xfs_io_fiemap
+    _require_xfs_io_command "fiemap"
 }
 
 _extent_count()
diff --git a/common/rc b/common/rc
index 07acbc5..5c13db5 100644
--- a/common/rc
+++ b/common/rc
@@ -1260,47 +1260,6 @@ _require_xfs_io_command()
 		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
 }
 
-# check that xfs_io, kernel, and filesystem all support zero
-_require_xfs_io_zero()
-{
-	_require_xfs_io_command "zero"
-}
-
-# check that xfs_io, glibc, kernel, and filesystem all (!) support
-# fallocate
-#
-_require_xfs_io_falloc()
-{
-	_require_xfs_io_command "falloc"
-}
-
-# check that xfs_io, kernel and filesystem all support fallocate with hole
-# punching
-_require_xfs_io_falloc_punch()
-{
-	_require_xfs_io_command "fpunch"
-}
-
-# check that xfs_io, kernel and filesystem all support fallocate with collapse
-# range
-_require_xfs_io_falloc_collapse()
-{
-	_require_xfs_io_command "fcollapse"
-}
-
-# check that xfs_io, kernel, and filesystem all support fallocate with zero
-# range
-_require_xfs_io_falloc_zero()
-{
-	_require_xfs_io_command "fzero"
-}
-
-# check that xfs_io, kernel and filesystem support fiemap
-_require_xfs_io_fiemap()
-{
-	_require_xfs_io_command "fiemap"
-}
-
 # Check that a fs has enough free space (in 1024b blocks)
 #
 _require_fs_space()
diff --git a/tests/btrfs/026 b/tests/btrfs/026
index 6c54590..c2ac561 100644
--- a/tests/btrfs/026
+++ b/tests/btrfs/026
@@ -48,7 +48,7 @@ _cleanup()
 _supported_fs btrfs
 _supported_os Linux
 
-_require_xfs_io_fiemap
+_require_xfs_io_command "fiemap"
 _require_cp_reflink
 
 TESTDIR1=$TEST_DIR/test-$seq
diff --git a/tests/btrfs/027 b/tests/btrfs/027
index b2dff1c..d615efd 100644
--- a/tests/btrfs/027
+++ b/tests/btrfs/027
@@ -48,7 +48,7 @@ _cleanup()
 _supported_fs btrfs
 _supported_os Linux
 
-_require_xfs_io_fiemap
+_require_xfs_io_command "fiemap"
 _require_cp_reflink
 
 TESTDIR1=$TEST_DIR/test-$seq
diff --git a/tests/btrfs/028 b/tests/btrfs/028
index f17f102..50cffd3 100644
--- a/tests/btrfs/028
+++ b/tests/btrfs/028
@@ -46,7 +46,7 @@ _cleanup()
 _supported_fs btrfs
 _supported_os Linux
 
-_require_xfs_io_fiemap
+_require_xfs_io_command "fiemap"
 _require_cp_reflink
 
 rm -f $seqres.full
diff --git a/tests/btrfs/047 b/tests/btrfs/047
index cc1936d..2dc6499 100755
--- a/tests/btrfs/047
+++ b/tests/btrfs/047
@@ -59,7 +59,7 @@ _supported_fs btrfs
 _supported_os Linux
 _require_scratch
 _require_fssum
-_require_xfs_io_fiemap
+_require_xfs_io_command "fiemap"
 _require_btrfs_send_stream_version
 _need_to_be_root
 
diff --git a/tests/ext4/001 b/tests/ext4/001
index 8239f0e..827d806 100755
--- a/tests/ext4/001
+++ b/tests/ext4/001
@@ -45,7 +45,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs ext4
 _supported_os Linux
-_require_xfs_io_falloc_zero
+_require_xfs_io_command "fzero"
 
 testfile=$TEST_DIR/001.$$
 
diff --git a/tests/ext4/002 b/tests/ext4/002
index 12be253..8cb3fd1 100755
--- a/tests/ext4/002
+++ b/tests/ext4/002
@@ -119,7 +119,7 @@ _check_ext4_eof_flag()
 # Prerequisites for the test run.
 _supported_fs ext4
 _supported_os Linux
-_require_xfs_io_falloc
+_require_xfs_io_command "falloc"
 
 # Real QA test starts here.
 rm -f $seqres.full
diff --git a/tests/generic/009 b/tests/generic/009
index b4d3e4b..65abe3c 100644
--- a/tests/generic/009
+++ b/tests/generic/009
@@ -44,7 +44,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_os Linux
-_require_xfs_io_falloc_zero
+_require_xfs_io_command "fzero"
 
 testfile=$TEST_DIR/009.$$
 
diff --git a/tests/generic/012 b/tests/generic/012
index e689299..730625b 100755
--- a/tests/generic/012
+++ b/tests/generic/012
@@ -51,10 +51,10 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
-_require_xfs_io_falloc_punch
-_require_xfs_io_falloc
-_require_xfs_io_fiemap
-_require_xfs_io_falloc_collapse
+_require_xfs_io_command "fpunch"
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "fcollapse"
 
 testfile=$TEST_DIR/$seq.$$
 
diff --git a/tests/generic/016 b/tests/generic/016
index 13a4488..15a2551 100755
--- a/tests/generic/016
+++ b/tests/generic/016
@@ -51,10 +51,10 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
-_require_xfs_io_falloc_punch
-_require_xfs_io_falloc
-_require_xfs_io_fiemap
-_require_xfs_io_falloc_collapse
+_require_xfs_io_command "fpunch"
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "fcollapse"
 
 testfile=$TEST_DIR/$seq.$$
 
diff --git a/tests/generic/017 b/tests/generic/017
index 93a4045..13b7254 100755
--- a/tests/generic/017
+++ b/tests/generic/017
@@ -43,8 +43,8 @@ _supported_fs generic
 _supported_os Linux
 
 _require_scratch
-_require_xfs_io_fiemap
-_require_xfs_io_falloc_collapse
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "fcollapse"
 _do_die_on_error=y
 testfile=$SCRATCH_MNT/$seq.$$
 BLOCKS=10240
diff --git a/tests/generic/021 b/tests/generic/021
index 7f3753a..eb88e01 100755
--- a/tests/generic/021
+++ b/tests/generic/021
@@ -51,10 +51,10 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
-_require_xfs_io_falloc_punch
-_require_xfs_io_falloc
-_require_xfs_io_fiemap
-_require_xfs_io_falloc_collapse
+_require_xfs_io_command "fpunch"
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "fcollapse"
 
 testfile=$TEST_DIR/$seq.$$
 
diff --git a/tests/generic/022 b/tests/generic/022
index 55e7206..55bf8c5 100755
--- a/tests/generic/022
+++ b/tests/generic/022
@@ -51,10 +51,10 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
-_require_xfs_io_falloc_punch
-_require_xfs_io_falloc
-_require_xfs_io_fiemap
-_require_xfs_io_falloc_collapse
+_require_xfs_io_command "fpunch"
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "fcollapse"
 
 testfile=$TEST_DIR/$seq.$$
 
diff --git a/tests/generic/213 b/tests/generic/213
index 3c8a304..c99520f 100755
--- a/tests/generic/213
+++ b/tests/generic/213
@@ -54,7 +54,7 @@ _supported_os Linux
 
 rm -f $seqres.full
 
-_require_xfs_io_falloc
+_require_xfs_io_command "falloc"
 
 # check there's enough freespace on $TEST_DIR ... (1GiB + 1MiB)
 avail=`df -P $TEST_DIR | awk 'END {print $4}'`
diff --git a/tests/generic/214 b/tests/generic/214
index 1885534..444c1fe 100755
--- a/tests/generic/214
+++ b/tests/generic/214
@@ -53,7 +53,7 @@ _supported_os Linux
 rm -f $seqres.full
 rm -f $TEST_DIR/ouch*
 
-_require_xfs_io_falloc
+_require_xfs_io_command "falloc"
 
 # Ok, off we go.
 
diff --git a/tests/generic/223 b/tests/generic/223
index 7b0e584..a67b8d5 100755
--- a/tests/generic/223
+++ b/tests/generic/223
@@ -46,7 +46,7 @@ _supported_fs generic
 _supported_os Linux
 
 _require_scratch
-_require_xfs_io_falloc
+_require_xfs_io_command "falloc"
 
 rm -f $seqres.full
 
diff --git a/tests/generic/228 b/tests/generic/228
index 03d4491..7ac0872 100755
--- a/tests/generic/228
+++ b/tests/generic/228
@@ -53,7 +53,7 @@ _supported_os Linux
 rm -f $seqres.full
 
 # Sanity check to see if fallocate works
-_require_xfs_io_falloc
+_require_xfs_io_command "falloc"
 
 # Check if we have good enough space available
 avail=`df -P $TEST_DIR | awk 'END {print $4}'`
diff --git a/tests/generic/255 b/tests/generic/255
index dd329b4..8419065 100755
--- a/tests/generic/255
+++ b/tests/generic/255
@@ -46,9 +46,9 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_fs generic 
 _supported_os Linux
 
-_require_xfs_io_falloc_punch
-_require_xfs_io_falloc
-_require_xfs_io_fiemap
+_require_xfs_io_command "fpunch"
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fiemap"
 
 testfile=$TEST_DIR/255.$$
 
diff --git a/tests/generic/256 b/tests/generic/256
index cfe7237..e6cc7dc 100755
--- a/tests/generic/256
+++ b/tests/generic/256
@@ -46,7 +46,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
-_require_xfs_io_falloc_punch
+_require_xfs_io_command "fpunch"
 _require_scratch
 _require_user
 
diff --git a/tests/generic/274 b/tests/generic/274
index 7c4887f..2d8d496 100755
--- a/tests/generic/274
+++ b/tests/generic/274
@@ -48,7 +48,7 @@ _cleanup()
 _supported_fs generic
 _supported_os IRIX Linux
 _require_scratch
-_require_xfs_io_falloc
+_require_xfs_io_command "falloc"
 
 echo "------------------------------"
 echo "preallocation test"
diff --git a/tests/generic/300 b/tests/generic/300
index 4e07f8a..01d4600 100755
--- a/tests/generic/300
+++ b/tests/generic/300
@@ -46,8 +46,8 @@ _require_scratch
 
 # xfs_io is not required for this test, but it's the best way to verify
 # the test system supports fallocate() for allocation and hole punching
-_require_xfs_io_falloc
-_require_xfs_io_falloc_punch
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fpunch"
 
 rm -f $seqres.full
 
diff --git a/tests/generic/311 b/tests/generic/311
index 284b59d..e389049 100755
--- a/tests/generic/311
+++ b/tests/generic/311
@@ -59,7 +59,7 @@ _require_dm_flakey
 
 # xfs_io is not required for this test, but it's the best way to verify
 # the test system supports fallocate() for allocation
-_require_xfs_io_falloc
+_require_xfs_io_command "falloc"
 
 [ -x $here/src/fsync-tester ] || _notrun "fsync-tester not built"
 
diff --git a/tests/generic/312 b/tests/generic/312
index eaec43c..1ed4962 100755
--- a/tests/generic/312
+++ b/tests/generic/312
@@ -46,7 +46,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
-_require_xfs_io_falloc
+_require_xfs_io_command "falloc"
 _require_scratch
 
 # 5G in byte
diff --git a/tests/generic/316 b/tests/generic/316
index 8cb2975..29a4331 100755
--- a/tests/generic/316
+++ b/tests/generic/316
@@ -45,8 +45,8 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
-_require_xfs_io_falloc_punch
-_require_xfs_io_fiemap
+_require_xfs_io_command "fpunch"
+_require_xfs_io_command "fiemap"
 
 testfile=$TEST_DIR/$seq.$$
 
diff --git a/tests/shared/298 b/tests/shared/298
index 6b5402c..f13c14b 100755
--- a/tests/shared/298
+++ b/tests/shared/298
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _supported_fs ext4 xfs
 _supported_os Linux
 _require_fstrim
-_require_xfs_io_fiemap
+_require_xfs_io_command "fiemap"
 _require_fs_space $TEST_DIR 307200
 [ "$FSTYP" = "ext4" ] && _require_dumpe2fs
 
diff --git a/tests/xfs/252 b/tests/xfs/252
index 00be41a..b2c4c08 100755
--- a/tests/xfs/252
+++ b/tests/xfs/252
@@ -46,8 +46,8 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_fs xfs 
 _supported_os Linux
 
-_require_xfs_io_falloc_punch
-_require_xfs_io_fiemap
+_require_xfs_io_command "fpunch"
+_require_xfs_io_command "fiemap"
 
 testfile=$TEST_DIR/252.$$
 
diff --git a/tests/xfs/290 b/tests/xfs/290
index cbe7108..55322ec 100755
--- a/tests/xfs/290
+++ b/tests/xfs/290
@@ -46,7 +46,7 @@ trap "exit \$status" 0 1 2 3 15
 _supported_fs xfs
 _supported_os Linux
 
-_require_xfs_io_zero
+_require_xfs_io_command "zero"
 
 testfile=$TEST_DIR/290.$$
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
