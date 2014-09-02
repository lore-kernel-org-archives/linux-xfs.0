Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9BF1A7F62
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 09:22:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 15C24AC003
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 07:22:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id D5eZzs7IAQDU43JH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Sep 2014 07:22:46 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/2] xfs/051: test buffer use after free race on I/O failure
	in XFS log recovery
Date: Tue,  2 Sep 2014 10:22:41 -0400
Message-Id: <1409667761-50248-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1409667761-50248-1-git-send-email-bfoster@redhat.com>
References: <1409667761-50248-1-git-send-email-bfoster@redhat.com>
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
To: fstests@vger.kernel.org
Cc: xfs@oss.sgi.com

A buffer use after free race was discovered in the XFS log recovery
codepath if I/O failures occur during recovery. The I/O submission path
can abort the mount and release the only reference held on some buffers
before I/O completion processing (e.g., async workqueue processing)
might have completed. Badness ensues if the I/O completion path
subsequently attempts to access said buffers.

The test manufactures the race by forcing all writes to fail (via
dm-flakey) after a fixed period of time. A delay is inserted into the
mount codepath to synchronize write failures with log recovery.

Credit for discovery of the race and definition of the reproducible test
case goes to Alex Lyakas.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reported-by: Alex Lyakas <alex@zadarastorage.com>
---
 tests/xfs/051     | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/051.out |  2 ++
 tests/xfs/group   |  1 +
 3 files changed, 98 insertions(+)
 create mode 100755 tests/xfs/051
 create mode 100644 tests/xfs/051.out

diff --git a/tests/xfs/051 b/tests/xfs/051
new file mode 100755
index 0000000..a84746b
--- /dev/null
+++ b/tests/xfs/051
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. 051
+#
+# Simulate a buffer use after free race in XFS log recovery. The race triggers
+# on I/O failures during log recovery. Note that this test is dangerous as it
+# causes BUG() errors or a panic.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Oracle, Inc.  All Rights Reserved.
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
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	killall -9 $FSSTRESS_PROG > /dev/null 2>&1
+	_scratch_unmount > /dev/null 2>&1
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/dmflakey
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+_require_dm_flakey
+_require_xfs_sysfs debug/log_recovery_delay
+
+echo "Silence is golden."
+
+_scratch_mkfs_xfs >/dev/null 2>&1
+_scratch_mount
+
+# Start a workload and shutdown the fs. The subsequent mount will require log
+# recovery.
+$FSSTRESS_PROG -n 9999 -p 2 -w -d $SCRATCH_MNT > /dev/null 2>&1 &
+sleep 5
+src/godown -f $SCRATCH_MNT
+killall -q $FSSTRESS_PROG
+wait
+_scratch_unmount
+
+# Initialize a dm-flakey device that will pass I/Os for 5s and fail thereafter.
+_init_flakey
+BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
+FLAKEY_TABLE="0 $BLK_DEV_SIZE flakey $SCRATCH_DEV 0 5 180"
+_load_flakey_table $FLAKEY_ALLOW_WRITES
+
+# Set a 10s log recovery delay and mount the flakey device. This should allow
+# initial writes to proceed (e.g., stale log block reset) and then let the
+# flakey uptime timer expire such that I/Os will fail by the time log recovery
+# starts.
+echo 10 > /sys/fs/xfs/debug/log_recovery_delay
+
+# The mount should fail due to dm-flakey. Note that this is dangerous on kernels
+# without the xfs_buf log recovery race fixes.
+_mount_flakey > /dev/null 2>&1
+
+echo 0 > /sys/fs/xfs/debug/log_recovery_delay
+
+_cleanup_flakey
+
+# replay the log
+_scratch_mount
+_scratch_unmount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/051.out b/tests/xfs/051.out
new file mode 100644
index 0000000..5180bc4
--- /dev/null
+++ b/tests/xfs/051.out
@@ -0,0 +1,2 @@
+QA output created by 051
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index 4d35df5..9784dea 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -47,6 +47,7 @@
 048 other auto quick
 049 rw auto quick
 050 quota auto quick
+051 dangerous
 052 quota db auto quick
 054 quota auto quick
 055 dump ioctl remote tape
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
