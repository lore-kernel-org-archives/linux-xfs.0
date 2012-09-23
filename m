Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8NJNYUT027030 for <xfs@oss.sgi.com>; Sun, 23 Sep 2012 14:23:34 -0500
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
	[209.85.217.181]) by cuda.sgi.com with ESMTP id
	BR6uiRwc14PS4Fun (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Sep 2012 12:24:49 -0700 (PDT)
Received: by mail-lb0-f181.google.com with SMTP id gg6so1076250lbb.26
	for <xfs@oss.sgi.com>; Sun, 23 Sep 2012 12:24:49 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 6/6] xfstest: add defragmentation stress test for ext4
Date: Sun, 23 Sep 2012 23:24:36 +0400
Message-Id: <1348428276-13161-6-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1348428276-13161-1-git-send-email-dmonakhov@openvz.org>
References: <a>
 <1348428276-13161-1-git-send-email-dmonakhov@openvz.org>
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
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, hch@lst.de, xfs@oss.sgi.com

Perform various regression tests for ext4defrag  subsystem

 Test1: Defragment file while other task does direct AIO
 Test2: Perform defragmentation on file under buffered AIO
 	while third task does direct AIO to donor file
 Test3: Two defrag tasks use common donor file.
 Test4: Stress defragmentation. Several threads pefrorm
 	fragmentation at random position use inplace=1 will
	allocate and free blocks inside defrag event improve
	load pressure.

This test known to caught most known e4defrag bugs.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 288     |  277 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 288.out |    4 +
 group   |    1 +
 3 files changed, 282 insertions(+), 0 deletions(-)
 create mode 100755 288
 create mode 100644 288.out

diff --git a/288 b/288
new file mode 100755
index 0000000..c972f88
--- /dev/null
+++ b/288
@@ -0,0 +1,277 @@
+#! /bin/bash
+# FSQA Test No. 288
+#
+# Ext4 defragmentatio stress test
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.
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
+run_check()
+{
+	echo "# $@" >> $seq.full 2>&1
+	"$@" >> $seq.full 2>&1 || _fail "failed: '$@'"
+}
+
+
+NUM_JOBS=$((4*LOAD_FACTOR))
+BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
+# We need space for 8 files 
+FILE_SIZE=$((BLK_DEV_SIZE * (512 /12)))
+
+cat >$tmp-$seq.fio <<EOF
+# Various e4defrag regression tests
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
+numjobs=1
+runtime=30
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
+runtime=30
+time_based
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
+numjobs=1
+runtime=30
+time_based
+
+# Run DIO/AIO for donor file
+[donor-file-fuzzer]
+ioengine=libaio 
+iodepth=128*${LOAD_FACTOR}
+numjobs=1
+verify=0
+direct=1
+bs=64k
+rw=randwrite
+filename=test2.def
+runtime=30
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
+runtime=30
+time_based
+
+#################################
+# Test3
+# Two defrag tasks use common donor file
+
+[defrag-1]
+ioengine=e4defrag
+iodepth=1
+bs=128k
+donorname=test3.def
+filename=test31
+inplace=0
+rw=write
+numjobs=1
+runtime=30
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
+numjobs=1
+runtime=30
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
+runtime=30
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
+runtime=30
+time_based
+
+#################################
+# Test4
+# Stress test defragmentation
+# Several threads pefrorm defragmentatin at random position
+# use inplace=1 will allocate and free blocks inside defrag event
+# improve load pressure
+[defrag-fuzzer]
+ioengine=e4defrag
+iodepth=1
+bs=8k
+donorname=test4.def
+filename=test4
+inplace=1
+rw=randwrite
+numjobs=4*${LOAD_FACTOR}
+runtime=30
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
+runtime=30
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
+	run_check $FIO_PROG $tmp-$seq.fio >>  $seq.full
+}
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_supported_fs ext4
+_need_to_be_root
+_require_scratch
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
diff --git a/288.out b/288.out
new file mode 100644
index 0000000..b215a3f
--- /dev/null
+++ b/288.out
@@ -0,0 +1,4 @@
+QA output created by 288
+
+ Start defragment activity 
+
diff --git a/group b/group
index 37f3256..8bd5c21 100644
--- a/group
+++ b/group
@@ -406,3 +406,4 @@ deprecated
 285 auto dump quota quick
 286 auto rw enospc aio
 287 auto rw enospc aio prealloc
+288 auto rw aio
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
