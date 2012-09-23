Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8NJNVS4027001 for <xfs@oss.sgi.com>; Sun, 23 Sep 2012 14:23:31 -0500
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
	[209.85.217.181]) by cuda.sgi.com with ESMTP id
	ct8lc7Mrp4VTPCYe (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Sep 2012 12:24:45 -0700 (PDT)
Received: by mail-lb0-f181.google.com with SMTP id gg6so1076250lbb.26
	for <xfs@oss.sgi.com>; Sun, 23 Sep 2012 12:24:45 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/6] xfstest add fallocate/truncate vs AIO/DIO stress test
Date: Sun, 23 Sep 2012 23:24:34 +0400
Message-Id: <1348428276-13161-4-git-send-email-dmonakhov@openvz.org>
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

Run  DIO, fallocate and truncate threads on a common file in parallel.
If race exist old dio request may rewrite blocks after it was allocated
to another file, we will catch that by verifying blocks content.

this patch known to catch deadlock for ext4
http://lists.openwall.net/linux-ext4/2012/09/06/3

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 286     |  153 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 286.out |    5 ++
 group   |    1 +
 3 files changed, 159 insertions(+), 0 deletions(-)
 create mode 100755 286
 create mode 100644 286.out

diff --git a/286 b/286
new file mode 100755
index 0000000..beb9546
--- /dev/null
+++ b/286
@@ -0,0 +1,153 @@
+#! /bin/bash
+# FSQA Test No. 286
+#
+# Test various aio dio vs truncate 
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
+FILE_SIZE=$((BLK_DEV_SIZE * 512))
+
+cat >$tmp-$seq.fio <<EOF
+###########
+# $seq test fio activity
+[global]
+ioengine=libaio 
+bs=128k 
+directory=${SCRATCH_MNT}
+filesize=${FILE_SIZE}
+size=999G
+iodepth=128*${LOAD_FACTOR} 
+continue_on_error=write
+ignore_error=,ENOSPC
+error_dump=0
+create_on_open=1
+fallocate=none
+exitall=1
+
+## Perform direct aio, to files which may be truncated
+## by external task
+[direct_aio]
+direct=1
+buffered=0 
+numjobs=${NUM_JOBS}
+rw=randwrite
+runtime=100*${TIME_FACTOR}
+time_based
+
+# Perform direct aio and verify data
+[aio-dio-verifier]
+numjobs=1
+verify=crc32c-intel
+verify_fatal=1
+verify_dump=1
+verify_backlog=1024
+verify_async=4
+verifysort=1
+direct=1
+bs=4k
+rw=randrw
+filename=aio-dio-verifier
+
+# Perform buffered aio and verify data
+[buffered-aio-verifier]
+numjobs=1
+verify=crc32c-intel
+verify_fatal=1
+verify_dump=1
+verify_backlog=1024
+verify_async=4
+verifysort=1
+direct=0
+buffered=1
+bs=4k
+rw=randrw
+filename=buffered-aio-verifier
+EOF
+
+_workout()
+{
+	echo ""
+	echo "Run fio with random aio-dio pattern"
+	echo ""
+	cat $tmp-$seq.fio >>  $seq.full
+	run_check $FIO_PROG $tmp-$seq.fio >>  $seq.full &
+	pid=$!
+	echo "Start fallocate/truncate loop"
+	for ((i=0; ; i++))
+	do
+	    for ((k=1; k <= NUM_JOBS; k++))
+	    do
+		fallocate -l $FILE_SIZE $SCRATCH_MNT/direct_aio.$k.0 \
+		    	>> $seq.full 2>&1
+	    done
+	    for ((k=1; k <= NUM_JOBS; k++))
+	    do
+		truncate -s 0 $SCRATCH_MNT/direct_aio.$k.0
+	    done
+	    # One fio exit we can stop fallocate/truncate loop
+	    kill -0 $pid > /dev/null 2>&1 || break
+	done
+	wait $pid
+}
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_need_to_be_root
+_require_scratch
+
+_scratch_mkfs >> $seq.full 2>&1
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
diff --git a/286.out b/286.out
new file mode 100644
index 0000000..d721996
--- /dev/null
+++ b/286.out
@@ -0,0 +1,5 @@
+QA output created by 286
+
+Run fio with random aio-dio pattern
+
+Start fallocate/truncate loop
diff --git a/group b/group
index 697269b..2469f80 100644
--- a/group
+++ b/group
@@ -404,3 +404,4 @@ deprecated
 283 dump ioctl auto quick
 284 auto
 285 auto dump quota quick
+286 auto rw enospc aio
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
