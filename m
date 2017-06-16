Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53078 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750798AbdFPQqV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Jun 2017 12:46:21 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] tests/xfs: test for log recovery failure after tail overwrite
Date: Fri, 16 Jun 2017 12:46:19 -0400
Message-Id: <1497631579-14454-1-git-send-email-bfoster@redhat.com>
In-Reply-To: <1497631473-14278-1-git-send-email-bfoster@redhat.com>
References: <1497631473-14278-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org

XFS is susceptible to log recovery problems if the fs crashes under
certain circumstances. If the tail has been pinned for long enough
to the log to fill and the next batch of log buffer submissions
happen to fail, the filesystem shutsdown having potentially
overwritten part of the range between the last good tail->head range
in the log. This causes log recovery to fail with crc mismatch or
invalid log record errors.

This problem is not yet fixed and thus known/expected to fail. At
this time, this test serves as a reminder that the problem exists
and a reproducer for future verification purposes. Note that this
problem is currently only reproducible with larger (non-default) log
buffer sizes (i.e., '-o logbsize=256k') or smaller block sizes (1k).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

This patch uses the XFS debug kernel mechanism recently posted for
review[1] to reproduce an XFS log recovery problem. Note that this test
depends on the aforementioned patch and thus should not be merged
until/unless the corresponding kernel patch is merged.

Brian

[1] "xfs: debug mode sysfs flag to force [un]pin the log tail"

 tests/xfs/999     | 113 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/999.out |   2 +
 tests/xfs/group   |   1 +
 3 files changed, 116 insertions(+)
 create mode 100644 tests/xfs/999
 create mode 100644 tests/xfs/999.out

diff --git a/tests/xfs/999 b/tests/xfs/999
new file mode 100644
index 0000000..6913a43
--- /dev/null
+++ b/tests/xfs/999
@@ -0,0 +1,113 @@
+#! /bin/bash
+# FS QA Test No. 999
+#
+# Attempt to reproduce log recovery failure by writing corrupt log records over
+# the last good tail in the log. The tail is force pinned while a workload runs
+# the head as close as possible behind the tail. Once the head is pinned,
+# corrupted log records are written to the log and the filesystem shuts down.
+#
+# While log recovery should handle the corrupted log records, it has historical
+# problems dealing with the situation where the corrupted log records may have
+# overwritten the tail of the previous good record in the log. If this occurs,
+# log recovery may fail.
+#
+# This can be reproduced more reliably under non-default conditions such as with
+# the smallest supported FSB sizes and/or largest supported log buffer sizes and
+# counts (logbufs and logbsize mount options).
+#
+# Note that this test requires a DEBUG mode kernel.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Red Hat, Inc. All Rights Reserved.
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
+	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
+	[ -e /sys/fs/xfs/$sdev/log/log_pin_tail ] &&
+		echo 0 > /sys/fs/xfs/$sdev/log/log_pin_tail
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
+_require_xfs_sysfs $(_short_dev $TEST_DEV)/log/log_badcrc_factor
+_require_xfs_sysfs $(_short_dev $TEST_DEV)/log/log_pin_tail
+_require_scratch
+_require_command "$KILLALL_PROG" killall
+
+echo "Silence is golden."
+
+sdev=$(_short_dev $SCRATCH_DEV)
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount || _fail "mount failed"
+
+# populate the fs with some data and cycle the mount to reset the log head/tail
+$FSSTRESS_PROG -d $SCRATCH_MNT -z -fcreat=1 -p 4 -n 100000 > /dev/null 2>&1
+_scratch_cycle_mount || _fail "mount failed"
+
+# Pin the tail and start a file removal workload. File removal tends to
+# reproduce the corruption more reliably.
+echo 1 > /sys/fs/xfs/$sdev/log/log_pin_tail
+
+rm -rf $SCRATCH_MNT/* > /dev/null 2>&1 &
+workpid=$!
+
+# wait for the head to stop pushing forward
+prevhead=-1
+head=`cat /sys/fs/xfs/$sdev/log/log_head_lsn`
+while [ "$head" != "$prevhead" ]; do
+	sleep 5
+	prevhead=$head
+	head=`cat /sys/fs/xfs/$sdev/log/log_head_lsn`
+done
+
+# Once the head is pinned behind the tail, enable log record corruption and
+# unpin the tail. All subsequent log buffer writes end up corrupted on-disk and
+# result in log I/O errors.
+echo 1 > /sys/fs/xfs/$sdev/log/log_badcrc_factor
+echo 0 > /sys/fs/xfs/$sdev/log/log_pin_tail
+
+# wait for fs shutdown to kill the workload
+wait $workpid
+
+# cycle mount to test log recovery
+_scratch_cycle_mount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/999.out b/tests/xfs/999.out
new file mode 100644
index 0000000..d254382
--- /dev/null
+++ b/tests/xfs/999.out
@@ -0,0 +1,2 @@
+QA output created by 999
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index 792161a..d94f010 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -416,3 +416,4 @@
 416 dangerous_fuzzers dangerous_scrub dangerous_repair
 417 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 418 dangerous_fuzzers dangerous_scrub dangerous_repair
+999 auto log
-- 
2.7.5

