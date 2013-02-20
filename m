Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0B00B7F5D
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 04:42:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D6D9D304043
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 02:42:27 -0800 (PST)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.232.25]) by cuda.sgi.com
	with ESMTP id 6T3jgwzzSEGSqyFy (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Feb 2013 02:42:25 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 08/10] xfstest: add fallocate/punch_hole vs AIO/DIO stress test
Date: Wed, 20 Feb 2013 14:42:13 +0400
Message-Id: <1361356935-29153-9-git-send-email-dmonakhov@openvz.org>
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

Run  random AIO/DIO activity (fio's job:direct_aio_raicer)
random fallocate activity(fio's job:falloc_raicer)
and random punch_hole activity(punch_hole_raicer) on a common
file in parallel. If race exist old dio request may rewrite
punched block after it was allocated to another file, we will
catch that by verifier fio's job: "aio-dio-verifier".

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 298     |  153 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 298.out |    4 ++
 group   |    3 +-
 3 files changed, 159 insertions(+), 1 deletions(-)
 create mode 100755 298
 create mode 100644 298.out

diff --git a/298 b/298
new file mode 100755
index 0000000..3264b8e
--- /dev/null
+++ b/298
@@ -0,0 +1,153 @@
+#! /bin/bash
+# FSQA Test No. 298
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
diff --git a/298.out b/298.out
new file mode 100644
index 0000000..faedc77
--- /dev/null
+++ b/298.out
@@ -0,0 +1,4 @@
+QA output created by 298
+
+Run fio with random aio-dio pattern
+
diff --git a/group b/group
index 2783286..ff893ac 100644
--- a/group
+++ b/group
@@ -420,4 +420,5 @@ stress
 294 auto quick
 295 auto logprint quick
 296 dump auto quick
-297 auto aio enospc rw stress
\ No newline at end of file
+297 auto aio enospc rw stress
+298 auto aio enospc preallocrw stress
\ No newline at end of file
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
