Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D00EB7F52
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 06:46:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5F9C9AC002
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 04:46:35 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	EcgH4h6c50hah0IJ for <xfs@oss.sgi.com>;
	Mon, 02 Sep 2013 04:46:33 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VGSaV-0000zk-LD
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 21:46:31 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VGSaV-0000G6-KO
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 21:46:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH V2] xfstests: add fsstress/recovery test for XFS
Date: Mon,  2 Sep 2013 21:46:31 +1000
Message-Id: <1378122391-962-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

This has found several issues with recovery on CRC based
filesystems. It is based on a test case for a dir3 assert failure
provided by Michael L Semon.

The test seems to pass now fine with or without CRCs enabled with
all the kernel patches I've posted over the past day.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/xfs/300     | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/300.out |   2 ++
 tests/xfs/group   |   1 +
 3 files changed, 108 insertions(+)
 create mode 100644 tests/xfs/300
 create mode 100644 tests/xfs/300.out

diff --git a/tests/xfs/300 b/tests/xfs/300
new file mode 100644
index 0000000..38ecd65
--- /dev/null
+++ b/tests/xfs/300
@@ -0,0 +1,105 @@
+#!/bin/bash
+# FS QA Test No. xfs/300
+#
+# Basic log recovery stress test - do lots of stuff, shut down in the middle of
+# it and check that recovery runs to completion and everything can be
+# successfully removed afterwards..
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+_cleanup()
+{
+	cd /
+	umount $SCRATCH_MNT 2>/dev/null
+	rm -f $tmp.*
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+
+rm -f $seqres.full
+
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount
+
+SLEEP_TIME=$((30 * $TIME_FACTOR))
+PROCS=$((2 * LOAD_FACTOR))
+
+load_dir=$SCRATCH_MNT/test
+
+# let this run for a while
+$FSSTRESS_PROG -n10000000 -p $PROCS -d $load_dir >> $seqres.full 2>&1 &
+sleep $SLEEP_TIME
+killall -q $FSSTRESS_PROG
+wait
+sync
+umount $SCRATCH_MNT
+
+# now mount again, run the load again, this time with a shutdown.
+_scratch_mount
+$XFS_FSR_PROG -v $load_dir >> $seqres.full 2>&1
+$FSSTRESS_PROG -n10000000 -p $PROCS -d $load_dir >> $seqres.full 2>&1 &
+sleep $SLEEP_TIME
+sync
+
+# now shutdown and unmount
+sleep 5
+$here/src/godown $load_dir
+killall -q $FSSTRESS_PROG
+wait
+
+# for some reason fsstress processes manage to live on beyond the wait?
+sleep 5
+umount $SCRATCH_MNT
+
+# now recover, check the filesystem for consistency
+_scratch_mount
+umount $SCRATCH_MNT
+_check_scratch_fs
+
+# now clean up.
+_scratch_mount
+for d in $load_dir/*; do
+        rm -rf $d > /dev/null 2>&1 &
+done
+wait
+umount $SCRATCH_MNT
+_check_scratch_fs
+
+echo "No output is good. Failures are loud."
+
+status=0
+exit
diff --git a/tests/xfs/300.out b/tests/xfs/300.out
new file mode 100644
index 0000000..c763112
--- /dev/null
+++ b/tests/xfs/300.out
@@ -0,0 +1,2 @@
+QA output created by 300
+No output is good. Failures are loud.
diff --git a/tests/xfs/group b/tests/xfs/group
index 352a4c5..3f1702a 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -179,3 +179,4 @@
 297 auto freeze
 298 auto attr symlink quick
 299 auto quota
+300 auto stress log metadata repair
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
