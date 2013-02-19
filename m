Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 71DEA7F63
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 05:37:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 00026AC002
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 03:37:46 -0800 (PST)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.232.25]) by cuda.sgi.com
	with ESMTP id JjrHEO0oB1RIrqql (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 Feb 2013 03:37:45 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 09/11] xfstest: add fallocate/punch_hole vs AIO/DIO stress test
Date: Tue, 19 Feb 2013 15:37:21 +0400
Message-Id: <1361273843-16094-9-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1361273843-16094-1-git-send-email-dmonakhov@openvz.org>
References: <1361273843-16094-1-git-send-email-dmonakhov@openvz.org>
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
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

Run  random AIO/DIO activity (fio's job:direct_aio_raicer)
random fallocate activity(fio's job:falloc_raicer)
and random punch_hole activity(punch_hole_raicer) on a common
file in parallel. If race exist old dio request may rewrite
punched block after it was allocated to another file, we will
catch that by verifier fio's job: "aio-dio-verifier".

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 287     |  153 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 287.out |    4 ++
 group   |    1 +
 3 files changed, 158 insertions(+), 0 deletions(-)
 create mode 100755 287
 create mode 100644 287.out

diff --git a/287 b/287
new file mode 100755
index 0000000..4a22b6d
--- /dev/null
+++ b/287
@@ -0,0 +1,153 @@
+#! /bin/bash
+# FSQA Test No. 287
+#
+# AIO/DIO stress test
+# Run random AIO/DIO activity and fallocate/punch_hole simultaneously
+# Test will operate on huge sparsed file so ENOSPC is expected.
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
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_need_to_be_root
+_require_scratch
+
+NUM_JOBS=$((4*LOAD_FACTOR))
+BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
+if [ $((BLK_DEV_SIZE)) -gt 1048576 ]
+then
+    BLK_DEV_SIZE=1048576
+fi 
+FS_SIZE=$((BLK_DEV_SIZE * 512))
+
+cat >$tmp-$seq.fio <<EOF
+###########
+# $seq test fio activity
+# Run  DIO, fallocate and punch_hole threads on a single in parallel 
+#
+# If race exist old dio request may rewrite punched block after it was
+# allocated to another file, we will catch that by verifying blocks content
+#
+[global]
+directory=${SCRATCH_MNT}
+filesize=${FS_SIZE}
+size=999G
+continue_on_error=write
+ignore_error=,ENOSPC
+error_dump=0
+
+create_on_open=1
+fallocate=none
+exitall=1
+
+## Perform direct aio, to files which may be truncated
+## by external task
+[direct_aio_raicer]
+ioengine=libaio
+iodepth=128*${LOAD_FACTOR} 
+bs=128k 
+direct=1
+numjobs=${NUM_JOBS}
+rw=randwrite
+runtime=100*${TIME_FACTOR}
+time_based
+filename=racer
+
+# Run falloc and punch_hole threads in parallel
+# After activity file will be highly fragmented
+[falloc_raicer]
+ioengine=falloc
+runtime=100*${TIME_FACTOR}
+iodepth=1
+bssplit=128k/80:512k/10:32k/10
+rw=randwrite
+numjobs=1
+filename=racer
+
+[punch_hole_raicer]
+ioengine=falloc
+runtime=100*${TIME_FACTOR}
+bs=4k
+time_based=10
+rw=randtrim
+numjobs=2
+filename=racer
+time_based
+
+# Verifier thread continiously write to newly allcated blocks
+# and veryfy written content
+[aio-dio-verifier]
+ioengine=libaio 
+iodepth=128*${LOAD_FACTOR}
+numjobs=1
+verify=crc32c-intel
+verify_fatal=1
+verify_dump=1
+verify_backlog=1024
+verify_async=4
+verifysort=1
+direct=1
+bs=4k
+rw=randwrite
+filename=aio-dio-verifier
+EOF
+
+_workout()
+{
+	echo ""
+	echo "Run fio with random aio-dio pattern"
+	echo ""
+	cat $tmp-$seq.fio >>  $seq.full
+	run_check $FIO_PROG $tmp-$seq.fio
+}
+
+_require_fio $tmp-$seq.fio
+
+_scratch_mkfs_sized $FS_SIZE >> $seq.full 2>&1
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
diff --git a/287.out b/287.out
new file mode 100644
index 0000000..d22e097
--- /dev/null
+++ b/287.out
@@ -0,0 +1,4 @@
+QA output created by 287
+
+Run fio with random aio-dio pattern
+
diff --git a/group b/group
index 01fb35b..fcd9174 100644
--- a/group
+++ b/group
@@ -410,3 +410,4 @@ stress
 284 auto
 285 auto dump quota quick
 286 auto rw enospc aio stress
+287 auto rw enospc aio prealloc stress
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
