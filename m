Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C52E07F54
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 04:42:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 77792304043
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 02:42:32 -0800 (PST)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.232.25]) by cuda.sgi.com
	with ESMTP id DsHfUxYPSmJYBfPb (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Feb 2013 02:42:29 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 09/10] xfstest: add defragmentation stress tests for ext4
Date: Wed, 20 Feb 2013 14:42:14 +0400
Message-Id: <1361356935-29153-10-git-send-email-dmonakhov@openvz.org>
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

Perform various regression tests for ext4defrag  subsystem

 299'th Test1: Defragment file while other task does direct AIO
 300'th Test2: Perform defragmentation on file under buffered AIO
 	while third task does direct AIO to donor file
 301'th Test3: Two defrag tasks use common donor file.
 302'th Test4: Stress defragmentation. Several threads pefrorm
 	fragmentation at random position use inplace=1 will
	allocate and free blocks inside defrag event improve
	load pressure.

This tests are considered dengerous because 300'th and 301'th are known
to trigger OOPS on recent kernels see:https://gist.github.com/dmonakhov/4770294

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 299           |  126 +++++++++++++++++++++++++++++++++++++++++++++++
 299.out       |    4 ++
 300           |  143 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 300.out       |    4 ++
 301           |  153 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 301.out       |    4 ++
 302           |  130 ++++++++++++++++++++++++++++++++++++++++++++++++
 302.out       |    4 ++
 common.defrag |    4 +-
 group         |    6 ++-
 10 files changed, 575 insertions(+), 3 deletions(-)
 create mode 100755 299
 create mode 100644 299.out
 create mode 100755 300
 create mode 100644 300.out
 create mode 100755 301
 create mode 100644 301.out
 create mode 100755 302
 create mode 100644 302.out

diff --git a/299 b/299
new file mode 100755
index 0000000..4a7a98c
--- /dev/null
+++ b/299
@@ -0,0 +1,126 @@
+#! /bin/bash
+# FSQA Test No. 299
+#
+# Ext4 defragmentation stress test
+# Defragment file while other task does direct io
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
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+. ./common.defrag
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs ext4
+_need_to_be_root
+_require_scratch
+_require_defrag
+
+BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
+# We need space for 2 files (test file, and donor one)
+# reserve 30% in order to avoid ENOSPC 
+FILE_SIZE=$((BLK_DEV_SIZE * (512 / (2 + 1))))
+
+cat >$tmp-$seq.fio <<EOF
+# Common e4defrag regression tests
+[global]
+ioengine=ioe_e4defrag
+iodepth=1
+directory=${SCRATCH_MNT}
+filesize=${FILE_SIZE}
+size=999G
+buffered=0
+fadvise_hint=0
+group_reporting
+
+#################################
+# Test1
+# Defragment file while other task does direct io
+
+# Continious sequential defrag activity
+[defrag-4k]
+ioengine=e4defrag
+iodepth=1
+bs=128k
+donorname=test1.def
+filename=test1
+inplace=0
+rw=write
+numjobs=${NUM_JOBS}
+runtime=30*${TIME_FACTOR}
+time_based
+
+# Verifier
+[aio-dio-verifier]
+ioengine=libaio 
+iodepth=128*${LOAD_FACTOR}
+numjobs=1
+verify=crc32c-intel
+verify_fatal=1
+verify_dump=1
+verify_backlog=1024
+verify_async=1
+verifysort=1
+direct=1
+bs=64k
+rw=randwrite
+filename=test1
+runtime=30*${TIME_FACTOR}
+time_based
+EOF
+
+_workout()
+{
+	echo ""
+	echo " Start defragment activity "
+	echo ""
+	cat $tmp-$seq.fio >>  $seq.full
+	run_check $FIO_PROG $tmp-$seq.fio
+}
+
+_require_fio $tmp-$seq.fio
+
+_scratch_mkfs  >> $seq.full 2>&1
+_scratch_mount
+
+if ! _workout; then
+	umount $SCRATCH_DEV 2>/dev/null
+	exit
+fi
+
+if ! _scratch_unmount; then
+	echo "failed to umount"
+	status=1
+	exit
+fi
+_check_scratch_fs
+status=$?
+exit diff --git a/299.out b/299.out new file mode 100644 index 0000000..b215a3f
diff --git a/299.out b/299.out
new file mode 100644
index 0000000..c2b0b4c
--- /dev/null
+++ b/299.out
@@ -0,0 +1,4 @@
+QA output created by 299
+
+ Start defragment activity 
+
diff --git a/300 b/300
new file mode 100755
index 0000000..ff24765
--- /dev/null
+++ b/300
@@ -0,0 +1,143 @@
+#! /bin/bash
+# FSQA Test No. 300
+#
+# Ext4 defragmentation stress test
+# Perform defragmentation on file under buffered io
+# while third task does direct io to donor file
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
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+. ./common.defrag
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs ext4
+_need_to_be_root
+_require_scratch
+_require_defrag
+
+BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
+# We need space for 2 files (test file, and donor one)
+# reserve 30% in order to avoid ENOSPC 
+FILE_SIZE=$((BLK_DEV_SIZE * (512 / (2 + 1))))
+
+cat >$tmp-$seq.fio <<EOF
+# Common e4defrag regression tests
+[global]
+ioengine=ioe_e4defrag
+iodepth=1
+directory=${SCRATCH_MNT}
+filesize=${FILE_SIZE}
+size=999G
+buffered=0
+fadvise_hint=0
+group_reporting
+
+##########################################
+# Test2 
+# Perform defragmentation on file under buffered io
+# while third task does direct io to donor file
+#
+# Continious sequential defrag activity
+[defrag-4k]
+stonewall
+ioengine=e4defrag
+iodepth=1
+bs=128k
+donorname=test2.def
+filename=test2
+inplace=0
+rw=write
+numjobs=${LOAD_FACTOR}
+runtime=30*${TIME_FACTOR}
+time_based
+
+# Run DIO/AIO for donor file
+[donor-file-fuzzer]
+ioengine=libaio 
+iodepth=128*${LOAD_FACTOR}
+numjobs=${LOAD_FACTOR}
+verify=0
+direct=1
+bs=64k
+rw=randwrite
+filename=test2.def
+runtime=30*${TIME_FACTOR}
+time_based
+
+# Verifier thread
+[aio-dio-verifier]
+ioengine=libaio 
+iodepth=128*${LOAD_FACTOR}
+numjobs=1
+verify=crc32c-intel
+verify_fatal=1
+verify_dump=1
+verify_backlog=1024
+verify_async=1
+verifysort=1
+buffered=1
+bs=64k
+rw=randrw
+filename=test2
+runtime=30*${TIME_FACTOR}
+time_based
+
+EOF
+
+_workout()
+{
+	echo ""
+	echo " Start defragment activity "
+	echo ""
+	cat $tmp-$seq.fio >>  $seq.full
+	run_check $FIO_PROG $tmp-$seq.fio
+}
+
+_require_fio $tmp-$seq.fio
+
+_scratch_mkfs  >> $seq.full 2>&1
+_scratch_mount
+
+if ! _workout; then
+	umount $SCRATCH_DEV 2>/dev/null
+	exit
+fi
+
+if ! _scratch_unmount; then
+	echo "failed to umount"
+	status=1
+	exit
+fi
+_check_scratch_fs
+status=$?
+exit
diff --git a/300.out b/300.out
new file mode 100644
index 0000000..926d985
--- /dev/null
+++ b/300.out
@@ -0,0 +1,4 @@
+QA output created by 300
+
+ Start defragment activity 
+
diff --git a/301 b/301
new file mode 100755
index 0000000..7700c36
--- /dev/null
+++ b/301
@@ -0,0 +1,153 @@
+#! /bin/bash
+# FSQA Test No. 299
+#
+# Ext4 defragmentation stress test
+# Two defrag tasks use common donor file
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
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+. ./common.defrag
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs ext4
+_need_to_be_root
+_require_scratch
+_require_defrag
+
+BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
+# We need space for 3 files (one donor file and two test files)
+# Reserve space for 4 files in order to avoid ENOSPC
+FILE_SIZE=$((BLK_DEV_SIZE * (512 / (3+1))))
+
+cat >$tmp-$seq.fio <<EOF
+# Common e4defrag regression tests
+[global]
+ioengine=ioe_e4defrag
+iodepth=1
+directory=${SCRATCH_MNT}
+filesize=${FILE_SIZE}
+size=999G
+buffered=0
+fadvise_hint=0
+group_reporting
+
+#################################
+# Test3
+# Two defrag tasks use common donor file
+[defrag-1]
+ioengine=e4defrag
+iodepth=1
+bs=128k
+donorname=test3.def
+filename=test31
+inplace=0
+rw=write
+numjobs=${LOAD_FACTOR}
+runtime=30*${TIME_FACTOR}
+time_based
+
+[defrag-2]
+ioengine=e4defrag
+iodepth=1
+bs=128k
+donorname=test3.def
+filename=test32
+inplace=0
+rw=write
+numjobs=${LOAD_FACTOR}
+runtime=30*${TIME_FACTOR}
+time_based
+
+[aio-dio-verifier-1]
+ioengine=libaio 
+iodepth=128*${LOAD_FACTOR}
+numjobs=1
+verify=crc32c-intel
+verify_fatal=1
+verify_dump=1
+verify_backlog=1024
+verify_async=1
+verifysort=1
+direct=1
+bs=64k
+rw=write
+filename=test31
+runtime=30*${TIME_FACTOR}
+time_based
+
+[aio-buffer-verifier-2]
+ioengine=libaio 
+numjobs=1
+verify=crc32c-intel
+verify_fatal=1
+verify_dump=1
+verify_backlog=1024
+verify_async=1
+verifysort=1
+buffered=1
+bs=64k
+rw=randrw
+filename=test32
+runtime=30*${TIME_FACTOR}
+time_based
+
+EOF
+
+_workout()
+{
+	echo ""
+	echo " Start defragment activity "
+	echo ""
+	cat $tmp-$seq.fio >>  $seq.full
+	run_check $FIO_PROG $tmp-$seq.fio
+}
+
+_require_fio $tmp-$seq.fio
+
+_scratch_mkfs  >> $seq.full 2>&1
+_scratch_mount
+
+if ! _workout; then
+	umount $SCRATCH_DEV 2>/dev/null
+	exit
+fi
+
+if ! _scratch_unmount; then
+	echo "failed to umount"
+	status=1
+	exit
+fi
+_check_scratch_fs
+status=$?
+exit
diff --git a/301.out b/301.out
new file mode 100644
index 0000000..961c3bf
--- /dev/null
+++ b/301.out
@@ -0,0 +1,4 @@
+QA output created by 301
+
+ Start defragment activity 
+
diff --git a/302 b/302
new file mode 100755
index 0000000..3bd82a4
--- /dev/null
+++ b/302
@@ -0,0 +1,130 @@
+#! /bin/bash
+# FSQA Test No. 299
+#
+# Ext4 defragmentation stress test
+# Several threads pefrorm defragmentatin at random position
+# using 'inplace' mode (allocate and free blocks inside defrag event)
+# which significantly improve load pressure on block allocator.
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
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+. ./common.defrag
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs ext4
+_need_to_be_root
+_require_scratch
+_require_defrag
+
+BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
+# We need space for 2 files (test file, and donor one)
+# reserve 30% in order to avoid ENOSPC 
+FILE_SIZE=$((BLK_DEV_SIZE * (512 / (2 + 1))))
+
+cat >$tmp-$seq.fio <<EOF
+# Common e4defrag regression tests
+[global]
+ioengine=ioe_e4defrag
+iodepth=1
+directory=${SCRATCH_MNT}
+filesize=${FILE_SIZE}
+size=999G
+buffered=0
+fadvise_hint=0
+group_reporting
+
+#################################
+# Test4
+# Stress test defragmentation engine
+# Several threads pefrorm defragmentatin at random position
+# use inplace=1 will allocate and free blocks inside defrag event
+# which highly increase defragmentation
+[defrag-fuzzer]
+ioengine=e4defrag
+iodepth=1
+bs=8k
+donorname=test4.def
+filename=test4
+inplace=1
+rw=randwrite
+numjobs=4*${LOAD_FACTOR}
+runtime=30*${TIME_FACTOR}
+time_based
+
+[aio-dio-verifier]
+ioengine=libaio 
+iodepth=128
+iomem_align=4k
+numjobs=1
+verify=crc32c-intel
+verify_fatal=1
+verify_dump=1
+verify_backlog=1024
+verify_async=1
+verifysort=1
+direct=1
+bs=64k
+rw=write
+filename=test4
+runtime=30*${TIME_FACTOR}
+time_based
+
+EOF
+
+_workout()
+{
+	echo ""
+	echo " Start defragment activity "
+	echo ""
+	cat $tmp-$seq.fio >>  $seq.full
+	run_check $FIO_PROG $tmp-$seq.fio
+}
+
+_require_fio $tmp-$seq.fio
+
+_scratch_mkfs  >> $seq.full 2>&1
+_scratch_mount
+
+if ! _workout; then
+	umount $SCRATCH_DEV 2>/dev/null
+	exit
+fi
+
+if ! _scratch_unmount; then
+	echo "failed to umount"
+	status=1
+	exit
+fi
+_check_scratch_fs
+status=$?
+exit
diff --git a/302.out b/302.out
new file mode 100644
index 0000000..a80ab81
--- /dev/null
+++ b/302.out
@@ -0,0 +1,4 @@
+QA output created by 302
+
+ Start defragment activity 
+
diff --git a/common.defrag b/common.defrag
index ea6c14c..84b1e65 100644
--- a/common.defrag
+++ b/common.defrag
@@ -24,10 +24,10 @@ _require_defrag()
 {
     case "$FSTYP" in
     xfs)
-        DEFRAG_PROG=/usr/sbin/xfs_fsr
+        DEFRAG_PROG="`set_prog_path xfs_fsr`"
 	;;
     ext4|ext4dev)
-        DEFRAG_PROG=/usr/bin/e4defrag
+        DEFRAG_PROG="`set_prog_path e4defrag`"
 	;;
     btrfs)
 	DEFRAG_PROG="$BTRFS_UTIL_PROG filesystem defragment"
diff --git a/group b/group
index ff893ac..2fe406b 100644
--- a/group
+++ b/group
@@ -421,4 +421,8 @@ stress
 295 auto logprint quick
 296 dump auto quick
 297 auto aio enospc rw stress
-298 auto aio enospc preallocrw stress
\ No newline at end of file
+298 auto aio enospc preallocrw stress
+299 aio dangerous ioctl rw stress
+300 aio dangerous ioctl rw stress
+301 aio dangerous ioctl rw stress
+302 aio dangerous ioctl rw stress
\ No newline at end of file
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
