Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5B0957F5F
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 04:42:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CFF81AC003
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 02:42:30 -0800 (PST)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.232.25]) by cuda.sgi.com
	with ESMTP id MPwdXOisbc4bqCeR (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Feb 2013 02:42:28 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 10/10] xfstests: add disk failure simulation test
Date: Wed, 20 Feb 2013 14:42:15 +0400
Message-Id: <1361356935-29153-11-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
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
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org, dchinner@redhat.com

There are many situations where disk may fail for example
1) brutal usb dongle unplug
2) iscsi (or any other netbdev) failure due to network issues
In this situation filesystem which use this blockdevice is
expected to fail(force RO remount, abort, etc) but whole system
should still be operational. In other words:
1) Kernel should not panic
2) Memory should not leak
3) Data integrity operations (sync,fsync,fdatasync, directio) should fail
   for affected filesystem
4) It should be possible to umount broken filesystem

Later when disk becomes available again we expect(only for journaled filesystems):
5) It will be possible to mount filesystem w/o explicit fsck (in order to caught
   issues like https://patchwork.kernel.org/patch/1983981/)
6) Filesystem should be operational
7) After mount/umount has being done all errors should be fixed so fsck should
   not spot any issues.

This test use fault enjection (CONFIG_FAIL_MAKE_REQUEST=y config option )
which force all new IO requests to fail for a given device. Xfs already has
XFS_IOC_GOINGDOWN ioctl which provides similar behaviour, but it is fsspeciffic
and it does it in an easy way because it perform freeze_bdev() before actual
shotdown.

Test run fsstress in background and then force disk failure.
Once disk failed it check that (1)-(4) is true.
Then makes disk available again and check that (5)-(7) is also true

BE CAREFUL!! test known to cause memory corruption for XFS
see: https://gist.github.com/dmonakhov/4953045

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 303           |  186 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 303.out       |    9 +++
 common.config |    1 +
 common.rc     |   13 ++++
 group         |    3 +-
 5 files changed, 211 insertions(+), 1 deletions(-)
 create mode 100755 303
 create mode 100644 303.out

diff --git a/303 b/303
new file mode 100755
index 0000000..01bc5f1
--- /dev/null
+++ b/303
@@ -0,0 +1,186 @@
+#! /bin/bash
+# FSQA Test No. 303
+#
+# Run fsstress and fio(dio/aio and mmap) and simulate disk failure
+# check filesystem consistency at the end.
+#
+#-----------------------------------------------------------------------
+# (c) 2013 Dmitry Monakhov
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+# creator
+owner=dmonakhov@openvz.org
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+_supported_fs ext3 ext4 xfs btrfs reiserfs
+_supported_os Linux
+_need_to_be_root
+_require_scratch
+_require_fail_make_request
+
+# TODO: Function are common enough to be moved to common.blkdev
+SCRATCH_REAL_DEV=`readlink -f $SCRATCH_DEV`
+SCRATCH_BDEV=`basename $SCRATCH_REAL_DEV`
+
+allow_fail_make_request()
+{
+    echo "Allow global fail_make_request feature"
+    echo 100 > $DEBUGFS_MNT/fail_make_request/probability
+    echo 9999999 > $DEBUGFS_MNT/fail_make_request/times
+    echo 0 >  /sys/kernel/debug/fail_make_request/verbose
+}
+
+disallow_fail_make_request()
+{
+    echo "Disallow global fail_make_request feature"
+    echo 0 > $DEBUGFS_MNT/fail_make_request/probability
+    echo 0 > $DEBUGFS_MNT/fail_make_request/times
+}
+
+start_fail_scratch_dev()
+{
+    echo "Force SCRATCH_DEV device failure"
+    echo " echo 1 > /sys/block/$SCRATCH_BDEV/make-it-fail" >> $here/$seq.full
+    echo 1 > /sys/block/$SCRATCH_BDEV/make-it-fail
+
+}
+
+stop_fail_scratch_dev()
+{
+    echo "Make SCRATCH_DEV device operable again"
+    echo " echo 0 > /sys/block/$SCRATCH_BDEV/make-it-fail" >> $here/$seq.full
+    echo 0 > /sys/block/$SCRATCH_BDEV/make-it-fail
+
+}
+
+_cleanup()
+{
+    poweron_scratch_dev
+    disallow_fail_make_request
+}
+trap "_cleanup; exit \$status" 1 2 3 15
+
+RUN_TIME=$((20+10*$TIME_FACTOR))
+NUM_JOBS=$((4*LOAD_FACTOR))
+BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
+FILE_SIZE=$((BLK_DEV_SIZE * 512))
+
+cat >$tmp-$seq.fio <<EOF
+###########
+# $seq test's fio activity
+# Filenames derived from jobsname and jobid like follows:
+# ${JOB_NAME}.${JOB_ID}.${ITERATION_ID}
+[global]
+ioengine=libaio
+bs=4k
+directory=${SCRATCH_MNT}
+filesize=${FILE_SIZE}
+size=9999T
+continue_on_error=write
+ignore_error=EIO,ENOSPC:EIO
+error_dump=0
+
+[stress_dio_aio_activity]
+create_on_open=1
+fallocate=none
+iodepth=128*${LOAD_FACTOR}
+direct=1
+buffered=0
+numjobs=${NUM_JOBS}
+rw=randwrite
+runtime=40+${RUN_TIME}
+time_based
+
+[stress_mmap_activity]
+ioengine=mmap
+create_on_open=0
+fallocate=1
+fdatasync=40960
+filesize=8M
+size=9999T
+numjobs=${NUM_JOBS}
+rw=randwrite
+runtime=40+${RUN_TIME}
+time_based
+
+EOF
+
+_require_fio $tmp-$seq.fio
+
+# Disable all sync operations to get higher load
+FSSTRESS_AVOID="$FSSTRESS_AVOID -ffsync=0 -fsync=0 -ffdatasync=0 -f setattr=1"
+
+_workout()
+{
+	out=$SCRATCH_MNT/fsstress.$$
+	args=`_scale_fsstress_args -p 1 -n999999999 -f setattr=0 $FSSTRESS_AVOID -d $out`
+	echo ""
+	echo "Start fsstress.."
+	echo ""
+	echo "fsstress $args" >> $here/$seq.full
+	$FSSTRESS_PROG $args > /dev/null 2>&1 &
+	fs_pid=$!
+	echo "Start fio.."
+	cat $tmp-$seq.fio >>  $seq.full
+	$FIO_PROG $tmp-$seq.fio >> $here/$seq.full 2>&1 &
+	fio_pid=$!
+
+	# Let's it work for awhile, and force device failure
+	sleep $RUN_TIME
+	start_fail_scratch_dev
+	# After device turns in to failed state filesystem may yet not know about
+	# that so buffered write(2) may succeed, but any integrity operations
+	# such as (sync, fsync, fdatasync, direct-io) should fail.
+	dd if=/dev/zero of=$SCRATCH_MNT/touch_failed_filesystem count=1 bs=4k conv=fsync \
+	    >> $here/$seq.full 2>&1 && \
+	    _fail "failed: still able to perform integrity fsync on $SCRATCH_MNT"
+
+	kill $fs_pid
+	wait $fs_pid
+	wait $fio_pid
+
+	# We expect that broken FS still can be umounted
+	run_check umount $SCRATCH_DEV
+	# Once filesystem was umounted no one is able to write to block device
+	# It is now safe to bring device back to normal state
+	stop_fail_scratch_dev
+
+	# In order to check that filesystem is able to recover journal on mount(2)
+	# perform mount/umount, after that all errors should be fixed
+	run_check _scratch_mount
+	run_check _scratch_unmount
+	_check_scratch_fs
+}
+
+# real QA test starts here
+
+_scratch_mkfs >> $here/$seq.full 2>&1 || _fail "mkfs failed"
+_scratch_mount || _fail "mount failed"
+allow_fail_make_request
+_workout
+status=$?
+disallow_fail_make_request
+exit
diff --git a/303.out b/303.out
new file mode 100644
index 0000000..a936471
--- /dev/null
+++ b/303.out
@@ -0,0 +1,9 @@
+QA output created by 303
+Allow global fail_make_request feature
+
+Start fsstress..
+
+Start fio..
+Force SCRATCH_DEV device failure
+Make SCRATCH_DEV device operable again
+Disallow global fail_make_request feature
diff --git a/common.config b/common.config
index 8efc7f8..8643c0b 100644
--- a/common.config
+++ b/common.config
@@ -75,6 +75,7 @@ export BENCH_PASSES=${BENCH_PASSES:=5}
 export XFS_MKFS_OPTIONS=${XFS_MKFS_OPTIONS:=-bsize=4096}
 export TIME_FACTOR=${TIME_FACTOR:=1}
 export LOAD_FACTOR=${LOAD_FACTOR:=1}
+export DEBUGFS_MNT=${DEBUGFS_MNT:="/sys/kernel/debug"}
 
 export PWD=`pwd`
 #export DEBUG=${DEBUG:=...} # arbitrary CFLAGS really.
diff --git a/common.rc b/common.rc
index e7ae9bf..b795c22 100644
--- a/common.rc
+++ b/common.rc
@@ -1049,6 +1049,19 @@ _require_sparse_files()
     esac
 }
 
+_require_debugfs()
+{
+    #boot_params always present in debugfs
+    [ -d "$DEBUGFS_MNT/boot_params" ] || _notrun "Debugfs not mounted"
+}
+
+_require_fail_make_request()
+{
+    [ -f "$DEBUGFS_MNT/fail_make_request/probability" ] \
+	|| _notrun "$DEBUGFS_MNT/fail_make_request \
+ not found. Seems that CONFIG_FAIL_MAKE_REQUEST kernel config option not enabled"
+}
+
 # check that a FS on a device is mounted
 # if so, return mount point
 #
diff --git a/group b/group
index 2fe406b..20b7a9c 100644
--- a/group
+++ b/group
@@ -425,4 +425,5 @@ stress
 299 aio dangerous ioctl rw stress
 300 aio dangerous ioctl rw stress
 301 aio dangerous ioctl rw stress
-302 aio dangerous ioctl rw stress
\ No newline at end of file
+302 aio dangerous ioctl rw stress
+303 aio dangerous enospc rw stress
\ No newline at end of file
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
