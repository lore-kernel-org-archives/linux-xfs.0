Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4RGN9vT145110 for <xfs@oss.sgi.com>; Thu, 27 May 2010 11:23:10 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6DD4913D6F06
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 09:25:32 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id tJ5uzKD1OX2J7Tll
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 09:25:32 -0700 (PDT)
Received: by bwz20 with SMTP id 20so11042bwz.26
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 09:25:31 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] xfstests-dev: Add one more quota stress test
Date: Thu, 27 May 2010 20:25:24 +0400
Message-Id: <1274977524-19741-3-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1274977524-19741-2-git-send-email-dmonakhov@openvz.org>
References: <1274977524-19741-1-git-send-email-dmonakhov@openvz.org>
	<1274977524-19741-2-git-send-email-dmonakhov@openvz.org>
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
To: jack@suse.cz
Cc: hch@infradead.org, sandeen@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>, xfs@oss.sgi.com

Test is inherent from 236 and runs with quota enabled.
Later when we will fixup quota code to pe reliable for errors
(ENOSPC/ENOMEM) we may merge the test with 236.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 237     |  138 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 237.out |    8 ++++
 group   |    3 +-
 3 files changed, 148 insertions(+), 1 deletions(-)
 create mode 100755 237
 create mode 100644 237.out

diff --git a/237 b/237
new file mode 100755
index 0000000..053c7ad
--- /dev/null
+++ b/237
@@ -0,0 +1,138 @@
+#! /bin/bash
+# FS QA Test No. 237
+#
+# Perform agressive stress testing with quota enabled
+# Derived from 236.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 Dmitry Monakhov.  All Rights Reserved.
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
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+
+filter_scratch()
+{
+	perl -ne "
+s,$SCRATCH_MNT,[SCR_MNT],;
+s,$SCRATCH_DEV,[SCR_DEV],;
+	print;"
+}
+check_usage()
+{
+	quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
+	repquota -u -g -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
+		sort >$tmp.orig
+	quotacheck -u -g $SCRATCH_MNT 2>/dev/null
+	repquota -u -g -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
+		sort >$tmp.checked
+	quotaon -u -g $SCRATCH_MNT 2>/dev/null
+	diff $tmp.orig $tmp.checked
+}
+
+
+tmp=/tmp/$$
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+. ./common.quota
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux #IRIX
+_require_scratch
+_require_quota
+_need_to_be_root
+
+workout()
+{
+    #Timing parameters
+    nr_iterations=5
+    kill_tries=10
+    echo Running fsstress. | tee -a $seq.full
+    mkdir -p $SCRATCH_MNT/fsstress
+    touch $SCRATCH_MNT/BIG_FILE
+    # It is reasonable to disable sync, otherwise most of tasks will simply
+    # stuck in that sync() call.
+
+    $FSSTRESS_PROG -d $SCRATCH_MNT/fsstress \
+	-p 100 -f sync=0 -n 9999999  >>$seq.full 2>&1 &
+    pid=$!
+    echo Running ENOSPC hitters. | tee -a $seq.full
+    for ((i = 0; i < $nr_iterations; i++))
+    do
+	#Open with O_TRUNC and then write until error
+	#hit ENOSPC each time.
+	dd if=/dev/zero of=$SCRATCH_MNT/BIG_FILE bs=1M conv=fsync 2> /dev/null
+    done
+
+    # Kill parent fsstress task to prevent complain from bash 
+    kill $pid 2>/dev/null
+    wait $pid 2>/dev/null
+    # Kill actual stress workers
+    for ((i = 0; i < $kill_tries; i++))
+    do
+	killall -r -q -TERM fsstress 2> /dev/null
+    done
+    unlink $SCRATCH_MNT/BIG_FILE    
+}
+
+
+rm -f $seq.full
+
+umount $TEST_DEV >/dev/null 2>&1
+umount $SCRATCH_DEV >/dev/null 2>&1
+echo "*** MKFS ***"                         >>$seq.full
+echo ""                                     >>$seq.full
+SIZE=`expr 128 \* 1024 \* 1024`
+_scratch_mkfs_sized $SIZE      > /dev/null 2>&1 || _fail "mkfs failed"
+_scratch_mount "-o usrquota,grpquota"
+quotacheck -u -g $SCRATCH_MNT 2>/dev/null
+
+# Currently quota is not able to handle errors from quota internals
+# so quota goes inconsistent after any error. To workaround this let's
+# allocate space for quota files to protect quota from ENOSPC
+# TODO: Remove this logic after quota becomes enospc tolerant -dmon@
+mv $SCRATCH_MNT/aquota.user{,.tmp}
+mv $SCRATCH_MNT/aquota.group{,.tmp}
+dd if=/dev/zero of=$SCRATCH_MNT/aquota.user bs=1M count=10 2>/dev/null
+dd if=/dev/zero of=$SCRATCH_MNT/aquota.group bs=1M count=10 2>/dev/null
+dd if=$SCRATCH_MNT/aquota.user.tmp of=$SCRATCH_MNT/aquota.user conv=notrunc \
+    2>/dev/null 
+dd if=$SCRATCH_MNT/aquota.group.tmp of=$SCRATCH_MNT/aquota.group conv=notrunc \
+    2>/dev/null
+rm -rf $SCRATCH_MNT/aquota.*.tmp
+
+quotaon $SCRATCH_MNT 2>/dev/null
+workout
+if ! check_usage; then
+	umount $SCRATCH_DEV 2>/dev/null
+	status=1
+	exit
+fi
+echo Checking filesystem
+_check_scratch_fs
+status=$?
+exit
diff --git a/237.out b/237.out
new file mode 100644
index 0000000..4cd7f0f
--- /dev/null
+++ b/237.out
@@ -0,0 +1,8 @@
+QA output created by 237
+Running fsstress.
+Running ENOSPC hitters.
+Setting grace times and other flags to default values.
+Assuming number of blocks is 10240.
+Setting grace times and other flags to default values.
+Assuming number of blocks is 10240.
+Checking filesystem
diff --git a/group b/group
index 6402020..389b3ff 100644
--- a/group
+++ b/group
@@ -349,4 +349,5 @@ deprecated
 233 auto quota
 234 auto quota
 235 auto quota quick
-236 auto
\ No newline at end of file
+236 auto
+237 auto quota
\ No newline at end of file
-- 
1.6.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
