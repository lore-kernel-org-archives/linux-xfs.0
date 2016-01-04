Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C16677F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 10:03:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5CFFFAC002
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 08:03:44 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xtIyNEWjI8aqhPJx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2016 08:03:43 -0800 (PST)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfs: test XFS torn log write detection
Date: Mon,  4 Jan 2016 11:03:41 -0500
Message-Id: <1451923421-16647-1-git-send-email-bfoster@redhat.com>
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

XFS torn log write detection includes a mechanism to inject CRC errors
into log records at runtime and shutdown the fs accordingly. This
ensures that the CRC verification pass on the subsequent mount discovers
an invalid record near the head of the log and considers it a torn
write.

This test runs a workload with error injection enabled and verifies that
the subsequent mount is successful. The test repeats for several
iterations using a random frequency factor for the error event each
time.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Here's a v2 of the XFS log crc verification test case now that the
associated kernel code has been merged. The only change is the bugfix
noted in the changelog below.

Brian

v2:
- Update random failure frequency calculation to ensure factor is never
  0.
v1: http://article.gmane.org/gmane.comp.file-systems.fstests/1406

 tests/xfs/350     | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/350.out |  2 ++
 tests/xfs/group   |  1 +
 3 files changed, 88 insertions(+)
 create mode 100755 tests/xfs/350
 create mode 100644 tests/xfs/350.out

diff --git a/tests/xfs/350 b/tests/xfs/350
new file mode 100755
index 0000000..1a1de6f
--- /dev/null
+++ b/tests/xfs/350
@@ -0,0 +1,85 @@
+#! /bin/bash
+# FS QA Test No. 350
+#
+# Use the XFS log record CRC error injection mechanism to test torn writes to
+# the log. The error injection mechanism writes an invalid CRC and shuts down
+# the filesystem. The test verifies that a subsequent remount recovers the log
+# and that the filesystem is consistent.
+#
+# Note that this test requires a DEBUG mode kernel.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Red Hat, Inc. All Rights Reserved.
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
+	killall -9 fsstress > /dev/null 2>&1
+	wait > /dev/null 2>&1
+}
+
+rm -f $seqres.full
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_xfs_sysfs $(_short_dev $SCRATCH_DEV)/log/log_badcrc_factor
+_require_scratch
+
+echo "Silence is golden."
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount
+
+sdev=$(_short_dev $SCRATCH_DEV)
+
+for i in $(seq 1 5); do
+	# Enable error injection. Use a random bad crc factor up to 100
+	# (increase this value to run fsstress longer).
+	factor=$((RANDOM % 100 + 1))
+	echo iteration $i log_badcrc_factor: $factor >> $seqres.full 2>&1
+	echo $factor > /sys/fs/xfs/$sdev/log/log_badcrc_factor
+
+	# Run fsstress until the filesystem shuts down. It will shut down
+	# automatically when error injection triggers.
+	$FSSTRESS_PROG -d $SCRATCH_MNT -p 4 -n 999999 >> $seqres.full 2>&1
+
+	# Verify that we can remount the fs. Log recovery should handle the torn
+	# write.
+	_scratch_unmount
+	_scratch_mount || _fail "failed to mount"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/350.out b/tests/xfs/350.out
new file mode 100644
index 0000000..c725135
--- /dev/null
+++ b/tests/xfs/350.out
@@ -0,0 +1,2 @@
+QA output created by 350
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index 634f7e7..5fbace9 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -232,3 +232,4 @@
 303 auto quick quota
 304 auto quick quota
 305 auto quota
+350 auto log metadata
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
