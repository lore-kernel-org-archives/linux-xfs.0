Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3283529E06
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 12:16:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 17E0B304066
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:13 -0800 (PST)
Received: from mail-yh0-f73.google.com (mail-yh0-f73.google.com
	[209.85.213.73]) by cuda.sgi.com with ESMTP id BcVKu5NomZAMA17y
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:11 -0800 (PST)
Received: by mail-yh0-f73.google.com with SMTP id f64so1145yha.0
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:10 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH v3 10/12] xfstests: do not unmount tmpfs during remount.
Date: Wed, 18 Dec 2013 10:16:01 -0800
Message-Id: <1387390563-27064-10-git-send-email-jayr@google.com>
In-Reply-To: <1387390563-27064-1-git-send-email-jayr@google.com>
References: <1387390563-27064-1-git-send-email-jayr@google.com>
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
Cc: tytso@mit.edu, hughd@google.com, branto@redhat.com, Junho Ryu <jayr@google.com>

Several tests unmount then re-mount the scratch filesystem, to check
that the content is unchanged; but unmounting a tmpfs is designed to
lose its content, which causes such tests to fail unnecessarily.  Add
_scratch_remount(), which instead uses remount on a tmpfs to preserve
its contents.  Also add _test_remount() to do the same for the test
device.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Junho Ryu <jayr@google.com>
---

v3: same as v1

v2: same as v1

 common/rc             | 34 ++++++++++++++++++++++++++++++++--
 tests/generic/135     | 17 +++--------------
 tests/generic/169     | 20 ++++++--------------
 tests/generic/169.out |  6 ++----
 tests/generic/192     |  3 +--
 tests/generic/226     |  3 +--
 tests/generic/258     |  3 +--
 tests/generic/306     |  3 +--
 8 files changed, 47 insertions(+), 42 deletions(-)

diff --git a/common/rc b/common/rc
index 3878069..e15dce2 100644
--- a/common/rc
+++ b/common/rc
@@ -302,8 +302,20 @@ _scratch_unmount()
 
 _scratch_remount()
 {
-    _scratch_unmount
-    _scratch_mount
+    CWD=`pwd`
+    cd /
+
+    case $FSTYP in
+    tmpfs)
+        mount -o remount "$@" $SCRATCH_MNT
+        ;;
+    *)
+        _scratch_unmount
+        _scratch_mount "$@"
+        ;;
+    esac
+
+    cd $CWD
 }
 
 _test_mount()
@@ -312,6 +324,24 @@ _test_mount()
     _mount -t $FSTYP $TEST_OPTIONS $TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS $* $TEST_DEV $TEST_DIR
 }
 
+_test_remount()
+{
+    CWD=`pwd`
+    cd /
+
+    case $FSTYP in
+    tmpfs)
+        mount -o remount "$@" $TEST_DIR
+        ;;
+    *)
+        umount $TEST_DIR
+        _test_mount "$@"
+        ;;
+    esac
+
+    cd $CWD
+}
+
 _scratch_mkfs_options()
 {
     _scratch_options mkfs
diff --git a/tests/generic/135 b/tests/generic/135
index 79558f5..cfa9779 100755
--- a/tests/generic/135
+++ b/tests/generic/135
@@ -41,19 +41,8 @@ _supported_os Linux IRIX
 
 _require_odirect
 _require_scratch
-_scratch_mkfs >/dev/null 2>&1
-
-_umount_mount()
-{
-    CWD=`pwd`
-    cd /
-    # pipe error into /dev/null, in case not mounted (after _require_scratch)
-    umount $SCRATCH_MNT 2>/dev/null
-    _scratch_mount
-    cd "$CWD"
-}
-
-_umount_mount
+_scratch_mkfs >/dev/null 2>&1 || _fail "mkfs failed"
+_scratch_mount > /dev/null 2>&1 || _fail "mount failed"
 
 cd $SCRATCH_MNT
 
@@ -71,7 +60,7 @@ $XFS_IO_PROG -f -c 'pwrite -b 4k -S 0x78 0 4k' trunc_file > /dev/null
 $XFS_IO_PROG -f -c 'truncate 2k' trunc_file > /dev/null
 $XFS_IO_PROG -c 'pwrite 1k 0 1k' trunc_file > /dev/null
 
-_umount_mount
+_scratch_remount
 
 # check file size and contents
 od -Ad -x async_file
diff --git a/tests/generic/169 b/tests/generic/169
index ebeffa7..ebfb106 100755
--- a/tests/generic/169
+++ b/tests/generic/169
@@ -73,13 +73,9 @@ $XFS_IO_PROG -a -c "pwrite 0 5k" -c "fsync" \
 	$SCRATCH_MNT/testfile \
 	| _show_wrote_and_stat_only
 
-echo "# unmounting scratch"
-umount $SCRATCH_MNT>>$seqres.full 2>&1 \
-    || _fail "unmount failed"
-
-echo "# mounting scratch"
-_scratch_mount >>$seqres.full 2>&1 \
-    || _fail "mount failed: $MOUNT_OPTIONS"
+echo "# remounting scratch"
+_scratch_remount >>$seqres.full 2>&1 \
+    || _fail "remount failed: $MOUNT_OPTIONS"
 
 echo "# stating file to confirm correct size"
 $XFS_IO_PROG -r -c "stat" $SCRATCH_MNT/testfile \
@@ -90,13 +86,9 @@ $XFS_IO_PROG -f -c "pwrite 0 5" -c s -c "pwrite 5 5" \
 	-c "stat" $SCRATCH_MNT/nextfile \
 	| _show_wrote_and_stat_only
 
-echo "# unmounting scratch"
-umount $SCRATCH_MNT>>$seqres.full 2>&1 \
-    || _fail "unmount failed"
-
-echo "# mounting scratch"
-_scratch_mount >>$seqres.full 2>&1 \
-    || _fail "mount failed: $MOUNT_OPTIONS"
+echo "# remounting scratch"
+_scratch_remount >>$seqres.full 2>&1 \
+    || _fail "remount failed: $MOUNT_OPTIONS"
 
 echo "# stating file to confirm correct size"
 $XFS_IO_PROG -r -c "stat" $SCRATCH_MNT/nextfile \
diff --git a/tests/generic/169.out b/tests/generic/169.out
index 22a5b77..5f7df39 100644
--- a/tests/generic/169.out
+++ b/tests/generic/169.out
@@ -5,15 +5,13 @@ wrote 5120/5120 bytes at offset 0
 wrote 5120/5120 bytes at offset 5120
 wrote 5120/5120 bytes at offset 10240
 stat.size = 15360
-# unmounting scratch
-# mounting scratch
+# remounting scratch
 # stating file to confirm correct size
 stat.size = 15360
 # appending 10 bytes to new file, sync at 5 bytes
 wrote 5/5 bytes at offset 0
 wrote 5/5 bytes at offset 5
 stat.size = 10
-# unmounting scratch
-# mounting scratch
+# remounting scratch
 # stating file to confirm correct size
 stat.size = 10
diff --git a/tests/generic/192 b/tests/generic/192
index 2b4e41c..ec069b0 100755
--- a/tests/generic/192
+++ b/tests/generic/192
@@ -76,8 +76,7 @@ cat $testfile
 time2=`_access_time $testfile | tee -a $seqres.full`
 
 cd /
-umount $TEST_DIR
-_test_mount
+_test_remount
 time3=`_access_time $testfile | tee -a $seqres.full`
 
 delta1=`expr $time2 - $time1`
diff --git a/tests/generic/226 b/tests/generic/226
index 4ad56a5..1327c9e 100755
--- a/tests/generic/226
+++ b/tests/generic/226
@@ -61,8 +61,7 @@ for I in `seq 1 $loops`; do
 done
 
 echo
-umount $SCRATCH_DEV
-_scratch_mount
+_scratch_remount
 
 echo "--> $loops direct 64m writes in a loop"
 for I in `seq 1 $loops`; do
diff --git a/tests/generic/258 b/tests/generic/258
index 3aeb5ce..567a39a 100755
--- a/tests/generic/258
+++ b/tests/generic/258
@@ -61,8 +61,7 @@ fi
 
 # unmount, remount, and check the timestamp
 echo "Remounting to flush cache"
-umount $TEST_DEV
-_test_mount
+_test_remount
 
 # Should yield -315593940 (prior to epoch)
 echo "Testing for negative seconds since epoch"
diff --git a/tests/generic/306 b/tests/generic/306
index 04d28df..56313f2 100755
--- a/tests/generic/306
+++ b/tests/generic/306
@@ -66,8 +66,7 @@ touch $BINDFILE || _fail "Could not create bind mount file"
 touch $TARGET || _fail "Could not create symlink target"
 ln -s $TARGET $SYMLINK
 
-_scratch_unmount || _fail "Could not unmount scratch device"
-_scratch_mount -o ro || _fail "Could not mount scratch readonly"
+_scratch_remount -o ro || _fail "Could not remount scratch readonly"
 
 # We should be able to read & write to/from these devices even on an RO fs
 echo "== try to create new file"
-- 
1.8.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
