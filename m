Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CB98129DFF
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 08:37:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2803AAC002
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 06:37:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ArCAAgq5SAisAHnZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 06:37:01 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2] xfstests: Check the file system consistency on SCRATCH_DEV
Date: Tue, 24 Jun 2014 15:36:53 +0200
Message-Id: <1403617014-17870-1-git-send-email-lczerner@redhat.com>
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
To: fstests@vger.kernel.org
Cc: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

There are about 198 tests which requires scratch_dev, but does not check
the file system consistency afterwards. Xfstests infrastructure does not
do it automatically, so fix it by running _check_scratch_fs() after the
test if access time changed on the scratch device.

Also remove all the _check_scratch_fs() calls that are not actually needed
and will be covered by the check script.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 check             | 5 +++++
 tests/btrfs/024   | 1 -
 tests/btrfs/043   | 2 --
 tests/btrfs/044   | 2 --
 tests/btrfs/045   | 2 --
 tests/btrfs/046   | 2 --
 tests/btrfs/047   | 2 --
 tests/btrfs/048   | 2 --
 tests/btrfs/050   | 2 --
 tests/btrfs/051   | 2 --
 tests/btrfs/053   | 2 --
 tests/btrfs/054   | 2 --
 tests/ext4/271    | 3 +--
 tests/ext4/301    | 3 +--
 tests/ext4/302    | 3 +--
 tests/ext4/303    | 3 +--
 tests/ext4/304    | 3 +--
 tests/generic/009 | 0
 tests/generic/017 | 6 ------
 tests/generic/019 | 1 -
 tests/generic/026 | 0
 tests/generic/027 | 1 -
 tests/generic/068 | 2 --
 tests/generic/076 | 1 -
 tests/generic/083 | 1 -
 tests/generic/097 | 7 -------
 tests/generic/099 | 7 -------
 tests/generic/100 | 1 -
 tests/generic/117 | 2 --
 tests/generic/124 | 3 ---
 tests/generic/204 | 2 --
 tests/generic/269 | 3 +--
 tests/generic/270 | 3 +--
 tests/generic/273 | 3 +--
 tests/generic/299 | 3 +--
 tests/generic/300 | 3 +--
 tests/generic/312 | 1 -
 tests/generic/315 | 0
 tests/generic/320 | 1 -
 tests/generic/321 | 2 --
 tests/generic/322 | 2 --
 tests/shared/006  | 1 -
 tests/shared/272  | 3 +--
 tests/xfs/010     | 1 -
 tests/xfs/011     | 1 -
 tests/xfs/013     | 1 -
 tests/xfs/014     | 1 -
 tests/xfs/019     | 3 ---
 tests/xfs/019.out | 1 -
 tests/xfs/034     | 2 --
 tests/xfs/042     | 1 -
 tests/xfs/042.out | 1 -
 tests/xfs/085     | 6 ------
 tests/xfs/085.out | 1 -
 tests/xfs/104     | 1 -
 tests/xfs/110     | 2 --
 tests/xfs/121     | 3 ---
 tests/xfs/181     | 3 ---
 tests/xfs/278     | 5 -----
 tests/xfs/297     | 1 -
 tests/xfs/306     | 1 -
 61 files changed, 16 insertions(+), 119 deletions(-)
 mode change 100644 => 100755 tests/generic/009
 mode change 100644 => 100755 tests/generic/026
 mode change 100644 => 100755 tests/generic/315
 mode change 100644 => 100755 tests/generic/321
 mode change 100644 => 100755 tests/generic/322

diff --git a/check b/check
index b1eaed2..40f99d7 100755
--- a/check
+++ b/check
@@ -543,6 +543,7 @@ for section in $HOST_OPTIONS_SECTIONS; do
 		fi
 		rm -f core $seqres.notrun
 
+		scratch_atime=`stat -c %X $SCRATCH_DEV`
 		start=`_wallclock`
 		$timestamp && echo -n "	["`date "+%T"`"]"
 		[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
@@ -626,6 +627,10 @@ for section in $HOST_OPTIONS_SECTIONS; do
 		try="$try $seqnum"
 		n_try=`expr $n_try + 1`
 		_check_test_fs
+		atime=`stat -c %X $SCRATCH_DEV`
+		if [ $atime -ne $scratch_atime ]; then
+			_check_scratch_fs
+		fi
 	    fi
 
 	    seq="after_$seqnum"
diff --git a/tests/btrfs/024 b/tests/btrfs/024
index cb8a6e4..03d105a 100755
--- a/tests/btrfs/024
+++ b/tests/btrfs/024
@@ -77,7 +77,6 @@ _scratch_mkfs > /dev/null 2>&1
 _scratch_mount "-o compress-force=no"
 __workout
 _scratch_unmount
-_check_scratch_fs
 
 echo "*** done"
 status=0 ; exit
diff --git a/tests/btrfs/043 b/tests/btrfs/043
index b1fef96..4993349 100644
--- a/tests/btrfs/043
+++ b/tests/btrfs/043
@@ -143,7 +143,5 @@ run_check $FSSUM_PROG -r $tmp/1.fssum $SCRATCH_MNT/mysnap1
 _run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/2.snap
 run_check $FSSUM_PROG -r $tmp/2.fssum $SCRATCH_MNT/mysnap2
 
-_check_scratch_fs
-
 status=0
 exit
diff --git a/tests/btrfs/044 b/tests/btrfs/044
index dae189e..5565b86 100644
--- a/tests/btrfs/044
+++ b/tests/btrfs/044
@@ -123,7 +123,5 @@ run_check $FSSUM_PROG -r $tmp/1.fssum $SCRATCH_MNT/mysnap1
 _run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/2.snap
 run_check $FSSUM_PROG -r $tmp/2.fssum $SCRATCH_MNT/mysnap2
 
-_check_scratch_fs
-
 status=0
 exit
diff --git a/tests/btrfs/045 b/tests/btrfs/045
index 4567a3f..8570fa6 100755
--- a/tests/btrfs/045
+++ b/tests/btrfs/045
@@ -370,7 +370,5 @@ run_check $FSSUM_PROG -r $tmp/1.fssum $SCRATCH_MNT/mysnap1
 _run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/2.snap
 run_check $FSSUM_PROG -r $tmp/2.fssum $SCRATCH_MNT/mysnap2
 
-_check_scratch_fs
-
 status=0
 exit
diff --git a/tests/btrfs/046 b/tests/btrfs/046
index 685e359..c0d10e1 100644
--- a/tests/btrfs/046
+++ b/tests/btrfs/046
@@ -298,7 +298,5 @@ echo "File digests in the replica filesystem:"
 md5sum $SCRATCH_MNT/mysnap1/foo | _filter_scratch
 md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
 
-_check_scratch_fs
-
 status=0
 exit
diff --git a/tests/btrfs/047 b/tests/btrfs/047
index 2dc6499..8b20e79 100755
--- a/tests/btrfs/047
+++ b/tests/btrfs/047
@@ -116,7 +116,5 @@ $XFS_IO_PROG -r -c "seek -r -a 0" $SCRATCH_MNT/mysnap2/foo
 # the file's size.
 $XFS_IO_PROG -r -c "fiemap -v" $SCRATCH_MNT/mysnap2/foo | _filter_fiemap
 
-_check_scratch_fs
-
 status=0
 exit
diff --git a/tests/btrfs/048 b/tests/btrfs/048
index e998f97..2a9bfc3 100755
--- a/tests/btrfs/048
+++ b/tests/btrfs/048
@@ -214,7 +214,5 @@ $BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1 compression
 touch $SCRATCH_MNT/sv1/file2
 $BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1/file2 compression
 
-_check_scratch_fs
-
 status=0
 exit
diff --git a/tests/btrfs/050 b/tests/btrfs/050
index 6e4bd13..9079408 100755
--- a/tests/btrfs/050
+++ b/tests/btrfs/050
@@ -103,7 +103,5 @@ _scratch_mount
 _run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
 run_check $FSSUM_PROG -r $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
 
-_check_scratch_fs
-
 status=0
 exit
diff --git a/tests/btrfs/051 b/tests/btrfs/051
index 53df664..deaa765 100755
--- a/tests/btrfs/051
+++ b/tests/btrfs/051
@@ -79,7 +79,5 @@ _scratch_mount
 _run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
 run_check $FSSUM_PROG -r $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
 
-_check_scratch_fs
-
 status=0
 exit
diff --git a/tests/btrfs/053 b/tests/btrfs/053
index 3994110..7eef55f 100755
--- a/tests/btrfs/053
+++ b/tests/btrfs/053
@@ -103,7 +103,5 @@ run_check $FSSUM_PROG -r $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
 _run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/2.snap
 run_check $FSSUM_PROG -r $send_files_dir/2.fssum $SCRATCH_MNT/mysnap2
 
-_check_scratch_fs
-
 status=0
 exit
diff --git a/tests/btrfs/054 b/tests/btrfs/054
index 215861c..258eead 100755
--- a/tests/btrfs/054
+++ b/tests/btrfs/054
@@ -103,7 +103,5 @@ _run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/2.snap
 [ -e $SCRATCH_MNT/testdir ] && \
 	echo "Directory testdir was supposed to be deleted after incremental send!"
 
-_check_scratch_fs
-
 status=0
 exit
diff --git a/tests/ext4/271 b/tests/ext4/271
index 274e904..e77ae57 100755
--- a/tests/ext4/271
+++ b/tests/ext4/271
@@ -62,6 +62,5 @@ if ! _scratch_unmount; then
 	exit
 fi
 echo "Check filesystem"
-_check_scratch_fs
-status=$?
+status=0
 exit
diff --git a/tests/ext4/301 b/tests/ext4/301
index 0ca3622..568327d 100755
--- a/tests/ext4/301
+++ b/tests/ext4/301
@@ -121,5 +121,4 @@ if ! _scratch_unmount; then
 	status=1
 	exit
 fi
-_check_scratch_fs
-status=$?
+status=0
diff --git a/tests/ext4/302 b/tests/ext4/302
index 497f4c6..1e90016 100755
--- a/tests/ext4/302
+++ b/tests/ext4/302
@@ -137,6 +137,5 @@ if ! _scratch_unmount; then
 	status=1
 	exit
 fi
-_check_scratch_fs
-status=$?
+status=0
 exit
diff --git a/tests/ext4/303 b/tests/ext4/303
index 93354e5..9573872 100755
--- a/tests/ext4/303
+++ b/tests/ext4/303
@@ -147,6 +147,5 @@ if ! _scratch_unmount; then
 	status=1
 	exit
 fi
-_check_scratch_fs
-status=$?
+status=0
 exit
diff --git a/tests/ext4/304 b/tests/ext4/304
index 74e601a..b9b4356 100755
--- a/tests/ext4/304
+++ b/tests/ext4/304
@@ -124,6 +124,5 @@ if ! _scratch_unmount; then
 	status=1
 	exit
 fi
-_check_scratch_fs
-status=$?
+status=0
 exit
diff --git a/tests/generic/009 b/tests/generic/009
old mode 100644
new mode 100755
diff --git a/tests/generic/017 b/tests/generic/017
index 11705bf..c769dd8 100755
--- a/tests/generic/017
+++ b/tests/generic/017
@@ -67,12 +67,6 @@ done
 # Check if 80 extents are present
 $XFS_IO_PROG -c "fiemap -v" $testfile | grep "^ *[0-9]*:" |wc -l
 
-_check_scratch_fs
-if [ $? -ne 0 ]; then
-	status=1
-	exit
-fi
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/019 b/tests/generic/019
index 7a019ad..b387507 100755
--- a/tests/generic/019
+++ b/tests/generic/019
@@ -171,7 +171,6 @@ _workout()
 	# perform mount/umount, after that all errors should be fixed
 	run_check _scratch_mount
 	run_check _scratch_unmount
-	_check_scratch_fs
 }
 
 # real QA test starts here
diff --git a/tests/generic/026 b/tests/generic/026
old mode 100644
new mode 100755
diff --git a/tests/generic/027 b/tests/generic/027
index b9232ec..8dab117 100755
--- a/tests/generic/027
+++ b/tests/generic/027
@@ -101,7 +101,6 @@ while [ $i -le $loop ]; do
 	let i=$i+1
 done
 _scratch_unmount
-_check_scratch_fs
 
 status=0
 exit
diff --git a/tests/generic/068 b/tests/generic/068
index a764019..7794326 100755
--- a/tests/generic/068
+++ b/tests/generic/068
@@ -130,6 +130,4 @@ rm $tmp.running
 # wait for fsstresses to finish
 wait
 
-_check_scratch_fs
-
 exit 1
diff --git a/tests/generic/076 b/tests/generic/076
index a53840f..02af762 100755
--- a/tests/generic/076
+++ b/tests/generic/076
@@ -77,7 +77,6 @@ FSSTRESS_ARGS=`_scale_fsstress_args -p 2 -n 2000 $FSSTRESS_AVOID`
 echo "run fsstress with args: $FSSTRESS_ARGS" >>$seqres.full
 $FSSTRESS_PROG $FSSTRESS_ARGS >>$seqres.full
 _lets_get_pidst
-_check_scratch_fs
 
 echo "*** done"
 status=0
diff --git a/tests/generic/083 b/tests/generic/083
index f9135f8..61316bf 100755
--- a/tests/generic/083
+++ b/tests/generic/083
@@ -84,7 +84,6 @@ workout()
 	# -w ensures that the only ops are ones which cause write I/O
 	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w -p $procs -n $nops $FSSTRESS_AVOID`
 	$FSSTRESS_PROG $FSSTRESS_ARGS >>$seqres.full
-	_check_scratch_fs
 }
 
 echo "*** test out-of-space handling for random write operations"
diff --git a/tests/generic/097 b/tests/generic/097
index c120422..f40d5d5 100755
--- a/tests/generic/097
+++ b/tests/generic/097
@@ -244,13 +244,6 @@ ${ATTR_PROG} -R -l foo
 
 cd /
 
-# Check the filesystem
-_check_scratch_fs
-
-# optional stuff if your test has verbose output to help resolve problems
-#echo
-#echo "If failure, check $seqres.full (this) and $seqres.full.ok (reference)"
-
 # success, all done
 status=0
 exit
diff --git a/tests/generic/099 b/tests/generic/099
index 7351966..83097e9 100755
--- a/tests/generic/099
+++ b/tests/generic/099
@@ -328,13 +328,6 @@ chacl $acl3 largeaclfile
 _acl_list largeaclfile | _filter_aces_notypes
 
 #-------------------------------------------------------
-
-if [ "$FSTYP" == "udf" ]; then
-    cd /
-    umount $TARGET_DIR
-    # Check the filesystem
-    _check_scratch_fs
-fi
 # success, all done
 status=0
 exit
diff --git a/tests/generic/100 b/tests/generic/100
index 05d766f..00ba23e 100755
--- a/tests/generic/100
+++ b/tests/generic/100
@@ -80,7 +80,6 @@ ls -R -l ${TEST_DIR}${POPULATED_DIR} >>$seqres.full 2>&1
 diff -qr $POPULATED_DIR ${TEST_DIR}${POPULATED_DIR}
 
 cd /
-_check_scratch_fs
 
 status=0
 exit
diff --git a/tests/generic/117 b/tests/generic/117
index f81265b..935dcaf 100755
--- a/tests/generic/117
+++ b/tests/generic/117
@@ -108,8 +108,6 @@ cd /
 umount $SCRATCH_MNT
 echo 
 echo Checking filesystem
-_check_scratch_fs
-_scratch_mount
 
 status=$?
 exit
diff --git a/tests/generic/124 b/tests/generic/124
index 93ec4a1..77f6e7d 100755
--- a/tests/generic/124
+++ b/tests/generic/124
@@ -76,7 +76,4 @@ fi
 
 umount $SCRATCH_DEV
 
-_check_test_fs
-_check_scratch_fs
-
 exit 
diff --git a/tests/generic/204 b/tests/generic/204
index de029c6..d6bb094 100755
--- a/tests/generic/204
+++ b/tests/generic/204
@@ -83,8 +83,6 @@ for i in `seq 1 $files`; do
     echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > $SCRATCH_MNT/$i
 done
 
-_check_scratch_fs
-
 # success, all done
 echo "*** done"
 status=0
diff --git a/tests/generic/269 b/tests/generic/269
index 684cf42..cff5e54 100755
--- a/tests/generic/269
+++ b/tests/generic/269
@@ -79,6 +79,5 @@ if ! _scratch_unmount; then
 	status=1
 	exit
 fi
-_check_scratch_fs
-status=$?
+status=0
 exit
diff --git a/tests/generic/270 b/tests/generic/270
index b5ed7af..cebd377 100755
--- a/tests/generic/270
+++ b/tests/generic/270
@@ -104,6 +104,5 @@ if ! _scratch_unmount; then
 	status=1
 	exit
 fi
-_check_scratch_fs
-status=$?
+status=0
 exit
diff --git a/tests/generic/273 b/tests/generic/273
index 8e121a2..1ceb6c4 100755
--- a/tests/generic/273
+++ b/tests/generic/273
@@ -138,6 +138,5 @@ _scratch_mount
 
 _do_workload
 
-_check_scratch_fs
-status=$?
+status=0
 exit
diff --git a/tests/generic/299 b/tests/generic/299
index bf02c94..e8685a4 100755
--- a/tests/generic/299
+++ b/tests/generic/299
@@ -152,6 +152,5 @@ if ! _scratch_unmount; then
 	status=1
 	exit
 fi
-_check_scratch_fs
-status=$?
+status=0
 exit
diff --git a/tests/generic/300 b/tests/generic/300
index 01d4600..5234d05 100755
--- a/tests/generic/300
+++ b/tests/generic/300
@@ -155,6 +155,5 @@ if ! _scratch_unmount; then
 	status=1
 	exit
 fi
-_check_scratch_fs
-status=$?
+status=0
 exit
diff --git a/tests/generic/312 b/tests/generic/312
index 7611bb9..b035978 100755
--- a/tests/generic/312
+++ b/tests/generic/312
@@ -67,6 +67,5 @@ echo "Silence is golden"
 $XFS_IO_PROG -f -c "falloc 0 6g" $SCRATCH_MNT/testfile.$seq >>$seqres.full 2>&1
 
 _scratch_unmount
-_check_scratch_fs
 status=0
 exit
diff --git a/tests/generic/315 b/tests/generic/315
old mode 100644
new mode 100755
diff --git a/tests/generic/320 b/tests/generic/320
index e1ba970..3dd3bea 100755
--- a/tests/generic/320
+++ b/tests/generic/320
@@ -116,6 +116,5 @@ _scratch_mount >>$seqres.full 2>&1
 
 do_workload
 
-_check_scratch_fs
 status=0
 exit
diff --git a/tests/generic/321 b/tests/generic/321
old mode 100644
new mode 100755
index 345416c..8410d40
--- a/tests/generic/321
+++ b/tests/generic/321
@@ -121,8 +121,6 @@ _replay_rename_test()
 	_ls_l $SCRATCH_MNT | tail -n +2 | awk '{ print $1, $9 }'
 	_ls_l $SCRATCH_MNT/bar | tail -n +2 | awk '{ print $1, $9 }'
 	_unmount_flakey
-	_check_scratch_fs $FLAKEY_DEV
-	[ $? -ne 0 ] && _fatal "fsck failed"
 }
 
 _scratch_mkfs >> $seqres.full 2>&1
diff --git a/tests/generic/322 b/tests/generic/322
old mode 100644
new mode 100755
index c43fcb1..fe1a4d5
--- a/tests/generic/322
+++ b/tests/generic/322
@@ -94,8 +94,6 @@ _write_after_fsync_rename_test()
 	_mount_flakey
 	md5sum $SCRATCH_MNT/bar | _filter_scratch
 	_unmount_flakey
-	_check_scratch_fs $FLAKEY_DEV
-	[ $? -ne 0 ] && _fatal "fsck failed"
 }
 
 _scratch_mkfs >> $seqres.full 2>&1
diff --git a/tests/shared/006 b/tests/shared/006
index 445c35d..55c5965 100755
--- a/tests/shared/006
+++ b/tests/shared/006
@@ -91,7 +91,6 @@ _check_scratch_fs
 rm -rf $SCRATCH_MNT/testdir
 echo "Inode status after deleting all test files" >>$seqres.full
 $DF_PROG -i $SCRATCH_MNT >>$seqres.full
-_check_scratch_fs
 
 status=0
 exit
diff --git a/tests/shared/272 b/tests/shared/272
index 0f812f3..4417535 100755
--- a/tests/shared/272
+++ b/tests/shared/272
@@ -103,6 +103,5 @@ if ! _scratch_unmount; then
 	exit
 fi
 echo "Check filesystem"
-_check_scratch_fs
-status=$?
+status=0
 exit
diff --git a/tests/xfs/010 b/tests/xfs/010
index 2b5ad00..fd2e27c 100755
--- a/tests/xfs/010
+++ b/tests/xfs/010
@@ -127,7 +127,6 @@ _check_scratch_fs
 _corrupt_finobt_root $SCRATCH_DEV
 
 _scratch_xfs_repair 2>&1 | _filter_repair
-_check_scratch_fs
 
 status=0
 exit
diff --git a/tests/xfs/011 b/tests/xfs/011
index 5763af9..658a822 100755
--- a/tests/xfs/011
+++ b/tests/xfs/011
@@ -110,7 +110,6 @@ killall $FSSTRESS_PROG
 wait
 
 umount $SCRATCH_MNT
-_check_scratch_fs
 
 status=0
 exit
diff --git a/tests/xfs/013 b/tests/xfs/013
index d47bf53..dea3d08 100755
--- a/tests/xfs/013
+++ b/tests/xfs/013
@@ -150,7 +150,6 @@ rm -rf $SCRATCH_MNT/fsstress
 rm -rf $SCRATCH_MNT/dir*
 
 umount $SCRATCH_MNT
-_check_scratch_fs
 
 status=0
 exit
diff --git a/tests/xfs/014 b/tests/xfs/014
index 1e092a9..8866bfe 100755
--- a/tests/xfs/014
+++ b/tests/xfs/014
@@ -194,7 +194,6 @@ umount $LOOP_MNT
 echo $orig_sp_time > /proc/sys/fs/xfs/speculative_prealloc_lifetime
 
 umount $SCRATCH_MNT
-_check_scratch_fs
 
 status=0
 exit
diff --git a/tests/xfs/019 b/tests/xfs/019
index d35d15b..09670b9 100755
--- a/tests/xfs/019
+++ b/tests/xfs/019
@@ -136,9 +136,6 @@ _verify_fs()
 	_full "umount"
 	umount $SCRATCH_DEV >>$seqfull 2>&1 \
 		|| _fail "umount failed"
-
-	echo "*** check FS"
-	_check_scratch_fs
 }
 
 #_verify_fs 1
diff --git a/tests/xfs/019.out b/tests/xfs/019.out
index 0c1bf8f..19614d9 100644
--- a/tests/xfs/019.out
+++ b/tests/xfs/019.out
@@ -79,6 +79,5 @@ Device: <DEVICE> Inode: <INODE> Links: 1
  Mode: (0123/l--x-w--wx) Uid: (0) Gid: (0)
 Device: <DEVICE> Inode: <INODE> Links: 1 
 *** unmount FS
-*** check FS
 *** done
 *** unmount
diff --git a/tests/xfs/034 b/tests/xfs/034
index 6f73fdd..6beeb56 100755
--- a/tests/xfs/034
+++ b/tests/xfs/034
@@ -83,8 +83,6 @@ then
 fi
 
 # pv 801241 causes corruption here (inode left in agi_unlinked list)
-_check_scratch_fs
-
 echo "*** done"
 # happy exit
 status=0
diff --git a/tests/xfs/042 b/tests/xfs/042
index db0fa28..77dd704 100755
--- a/tests/xfs/042
+++ b/tests/xfs/042
@@ -162,7 +162,6 @@ if ! _do "diff $tmp.sum1 $tmp.sum2"; then
     status=1; exit
 fi
 echo "done"
-_do "Checking filesystem" "_check_scratch_fs"
 
 # success, all done
 echo "xfs_fsr tests passed."
diff --git a/tests/xfs/042.out b/tests/xfs/042.out
index f5b37b3..41baf09 100644
--- a/tests/xfs/042.out
+++ b/tests/xfs/042.out
@@ -9,5 +9,4 @@ Remove other files... done
 Run xfs_fsr on filesystem... done
 Check fill file... done
 Check large file... done
-Checking filesystem... done
 xfs_fsr tests passed.
diff --git a/tests/xfs/085 b/tests/xfs/085
index af71b77..54c2d01 100755
--- a/tests/xfs/085
+++ b/tests/xfs/085
@@ -88,12 +88,6 @@ umount $SCRATCH_MNT
 echo "logprint after mount and replay..."
 _print_logstate
 
-if _check_scratch_fs; then
-    echo "filesystem is checked ok"
-else
-    echo "filesystem is NOT ok"
-fi
-
 # success, all done
 status=0
 exit
diff --git a/tests/xfs/085.out b/tests/xfs/085.out
index 48e3e73..d2d99a1 100644
--- a/tests/xfs/085.out
+++ b/tests/xfs/085.out
@@ -111,4 +111,3 @@ ls SCRATCH_MNT
 unmount
 logprint after mount and replay...
 clean log
-filesystem is checked ok
diff --git a/tests/xfs/104 b/tests/xfs/104
index e899aca..69fcc69 100755
--- a/tests/xfs/104
+++ b/tests/xfs/104
@@ -113,7 +113,6 @@ done
 wait	# stop for any remaining stress processes
 
 umount $SCRATCH_DEV
-_check_scratch_fs
 
 status=0
 exit
diff --git a/tests/xfs/110 b/tests/xfs/110
index 48bea45..7428faf 100755
--- a/tests/xfs/110
+++ b/tests/xfs/110
@@ -81,7 +81,5 @@ do
 done
 wait
 
-_check_scratch_fs
-
 status=0
 exit
diff --git a/tests/xfs/121 b/tests/xfs/121
index 1e06e45..1457ed1 100755
--- a/tests/xfs/121
+++ b/tests/xfs/121
@@ -106,9 +106,6 @@ fi
 _scratch_mount >> $seqres.full 2>&1 \
     || _fail "mount failed"
 
-# should now be peaches
-_check_scratch_fs
-
 # success, all done
 status=0
 exit
diff --git a/tests/xfs/181 b/tests/xfs/181
index 38d556c..4e7ac3a 100755
--- a/tests/xfs/181
+++ b/tests/xfs/181
@@ -120,9 +120,6 @@ fi
 _scratch_mount >> $seqres.full 2>&1 \
     || _fail "mount failed"
 
-# should now be peaches
-_check_scratch_fs
-
 # success, all done
 status=0
 exit
diff --git a/tests/xfs/278 b/tests/xfs/278
index dacd1fc..2b1db8a 100755
--- a/tests/xfs/278
+++ b/tests/xfs/278
@@ -78,9 +78,4 @@ echo "" >>$seqres.full
 xfs_repair  $SCRATCH_DEV >> $seqres.full 2>&1
 echo "===== END of xfs_repair =====" >> $seqres.full
 
-#if _check_scratch_fs; then
-#	status=0
-#else
-#	status=1
-#fi
 exit
diff --git a/tests/xfs/297 b/tests/xfs/297
index 3fe32f1..1cdbbb9 100755
--- a/tests/xfs/297
+++ b/tests/xfs/297
@@ -82,6 +82,5 @@ echo "Test done" | tee -a $seqres.full
 killall -q $FSSTRESS_PROG
 wait
 
-_check_scratch_fs
 status=0
 exit
diff --git a/tests/xfs/306 b/tests/xfs/306
index 0794de3..3053fd9 100644
--- a/tests/xfs/306
+++ b/tests/xfs/306
@@ -97,7 +97,6 @@ for d in $load_dir/*; do
 done
 wait
 umount $SCRATCH_MNT
-_check_scratch_fs
 
 echo "No output is good. Failures are loud."
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
