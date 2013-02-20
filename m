Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B023E7F62
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 04:42:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9AE8A8F8035
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 02:42:31 -0800 (PST)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.232.25]) by cuda.sgi.com
	with ESMTP id kAOQEmoIQQ5EQyZ7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Feb 2013 02:42:29 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 07/10] xfstest: add fallocate/truncate vs AIO/DIO stress test
Date: Wed, 20 Feb 2013 14:42:12 +0400
Message-Id: <1361356935-29153-8-git-send-email-dmonakhov@openvz.org>
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

Run  DIO, fallocate and truncate threads on a common file in parallel.
If race exist old dio request may rewrite blocks after it was allocated
to another file, we will catch that by verifying blocks content.

this patch known to catch deadlock for ext4
http://lists.openwall.net/linux-ext4/2012/09/06/3

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 297     |  157 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 297.out |    5 ++
 group   |    1 +
 3 files changed, 163 insertions(+), 0 deletions(-)
 create mode 100755 297
 create mode 100644 297.out

diff --git a/297 b/297
new file mode 100755
index 0000000..83bc572
--- /dev/null
+++ b/297
@@ -0,0 +1,157 @@
+#! /bin/bash
+# FSQA Test No. 297
+#
+# AIO/DIO stress test
+# Run random AIO/DIO activity and fallocate/truncate simultaneously
+# Test will operate on huge sparsed files so ENOSPC is expected.
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
+FILE_SIZE=$((BLK_DEV_SIZE * 512))
+
+cat >$tmp-$seq.fio <<EOF
+###########
+# $seq test fio activity
+# Filenames derived from jobsname and jobid like follows:
+# ${JOB_NAME}.${JOB_ID}.${ITERATION_ID}
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
+# This test case should check use-after-free issues
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
+# This test case should check use-after-free issues
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
+_require_fio $tmp-$seq.fio
+
+_workout()
+{
+	echo ""
+	echo "Run fio with random aio-dio pattern"
+	echo ""
+	cat $tmp-$seq.fio >>  $seq.full
+	run_check $FIO_PROG $tmp-$seq.fio &
+	pid=$!
+	echo "Start fallocate/truncate loop"
+	
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
+	    # Following like will check that pid is still run.
+	    # Once fio exit we can stop fallocate/truncate loop
+	    kill -0 $pid > /dev/null 2>&1 || break
+	done
+	wait $pid
+}
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
diff --git a/297.out b/297.out
new file mode 100644
index 0000000..435fac7
--- /dev/null
+++ b/297.out
@@ -0,0 +1,5 @@
+QA output created by 297
+
+Run fio with random aio-dio pattern
+
+Start fallocate/truncate loop
diff --git a/group b/group
index 1fb2feb..2783286 100644
--- a/group
+++ b/group
@@ -420,3 +420,4 @@ stress
 294 auto quick
 295 auto logprint quick
 296 dump auto quick
+297 auto aio enospc rw stress
\ No newline at end of file
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
