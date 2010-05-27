Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4RGN8va145098 for <xfs@oss.sgi.com>; Thu, 27 May 2010 11:23:08 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47A6C37C97D
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 09:25:31 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id PyyCVphd3Vqv8OPK
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 09:25:31 -0700 (PDT)
Received: by bwz20 with SMTP id 20so11040bwz.26
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 09:25:30 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] xfstests-dev: add one more stress test
Date: Thu, 27 May 2010 20:25:23 +0400
Message-Id: <1274977524-19741-2-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1274977524-19741-1-git-send-email-dmonakhov@openvz.org>
References: <1274977524-19741-1-git-send-email-dmonakhov@openvz.org>
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

During stress testing we want to cover most of code paths.
fsstress is very good for this purpose. But it has expandable
nature (disk usage almost continually grow). So once we
goes it no ENOSPC condition we will be where till the end.

But by running 'dd' in parallel we can regularly trigger
ENOSPC but only for a limited periods of time.

This is my favorite stress test case configuration
https://bugzilla.kernel.org/show_bug.cgi?id=15742
https://bugzilla.kernel.org/show_bug.cgi?id=15792
https://bugzilla.kernel.org/show_bug.cgi?id=15827

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 236     |  103 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 236.out |    5 +++
 group   |    1 +
 3 files changed, 109 insertions(+), 0 deletions(-)
 create mode 100755 236
 create mode 100644 236.out

diff --git a/236 b/236
new file mode 100755
index 0000000..9e8e34a
--- /dev/null
+++ b/236
@@ -0,0 +1,103 @@
+#! /bin/bash
+# FS QA Test No. 236
+#
+# Perform fsstress test with parallel dd
+# This proven to be a good stress test
+# * Continuous dd retult in ENOSPC condition but only for a limited periods
+#   of time.
+# * Fsstress test cover many code paths
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
+_cleanup()
+{
+    rm -f $tmp.*
+}
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
+
+    # Kill actual stress workers
+    for ((i = 0; i < $kill_tries; i++))
+    do
+	killall -r -q -TERM fsstress 2> /dev/null
+	sleep 1
+    done
+    unlink $SCRATCH_MNT/BIG_FILE    
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+
+rm -f $seq.full
+
+umount $TEST_DEV >/dev/null 2>&1
+umount $SCRATCH_DEV >/dev/null 2>&1
+echo "*** MKFS ***"                         >>$seq.full
+echo ""                                     >>$seq.full
+SIZE=`expr 128 \* 1024 \* 1024`
+_scratch_mkfs_sized $SIZE      > /dev/null 2>&1 || _fail "mkfs failed"
+_scratch_mount >> $seq.full 2>&1 || _fail "mount failed"
+workout
+umount $SCRATCH_MNT
+echo 
+echo Checking filesystem
+_check_scratch_fs
+status=$?
+exit
diff --git a/236.out b/236.out
new file mode 100644
index 0000000..03ffccd
--- /dev/null
+++ b/236.out
@@ -0,0 +1,5 @@
+QA output created by 236
+Running fsstress.
+Running ENOSPC hitters.
+
+Checking filesystem
diff --git a/group b/group
index cc76175..6402020 100644
--- a/group
+++ b/group
@@ -349,3 +349,4 @@ deprecated
 233 auto quota
 234 auto quota
 235 auto quota quick
+236 auto
\ No newline at end of file
-- 
1.6.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
