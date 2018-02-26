Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:44719 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbeBZHbc (ORCPT
        <rfc822;groupwise-linux-xfs@vger.kernel.org:0:0>);
        Mon, 26 Feb 2018 02:31:32 -0500
From: Qu Wenruo <wqu@suse.com>
Subject: [RFC PATCH] fstests: Check if a fs can survive random (emulated) power loss
Date: Mon, 26 Feb 2018 15:31:11 +0800
Message-Id: <20180226073111.3066-1-wqu@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

This test case is originally designed to expose unexpected corruption
for btrfs, where there are several reports about btrfs serious metadata
corruption after power loss.

The test case itself will trigger heavy fsstress for the fs, and use
dm-flakey to emulate power loss by dropping all later writes.

For btrfs, it should be completely fine, as long as superblock write
(FUA write) finishes atomically, since with metadata CoW, superblock
either points to old trees or new tress, the fs should be as atomic as
superblock.

For journal based filesystems, each metadata update should be journaled,
so metadata operation is as atomic as journal updates.

It does show that XFS is doing the best work among the tested
filesystems (Btrfs, XFS, ext4), no kernel nor xfs_repair problem at all.

For btrfs, although btrfs check doesn't report any problem, kernel
reports some data checksum error, which is a little unexpected as data
is CoWed by default, which should be as atomic as superblock.
(Unfortunately, still not the exact problem I'm chasing for)

For EXT4, kernel is fine, but later e2fsck reports problem, which may
indicates there is still something to be improved.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/generic/479     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/479.out |   2 +
 tests/generic/group   |   1 +
 3 files changed, 112 insertions(+)
 create mode 100755 tests/generic/479
 create mode 100644 tests/generic/479.out

diff --git a/tests/generic/479 b/tests/generic/479
new file mode 100755
index 00000000..ab530231
--- /dev/null
+++ b/tests/generic/479
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test 479
+#
+# Test if a filesystem can survive emulated powerloss.
+#
+# No matter what the solution a filesystem uses (journal or CoW),
+# it should survive unexpected powerloss, without major metadata
+# corruption.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2018 SuSE.  All Rights Reserved.
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
+	ps -e | grep fsstress > /dev/null 2>&1
+	while [ $? -eq 0 ]; do
+		$KILLALL_PROG -KILL fsstress > /dev/null 2>&1
+		wait > /dev/null 2>&1
+		ps -e | grep fsstress > /dev/null 2>&1
+	done
+	_unmount_flakey &> /dev/null
+	_cleanup_flakey
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmflakey
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_dm_target flakey
+_require_command "$KILLALL_PROG" "killall"
+
+runtime=$(($TIME_FACTOR * 15))
+loops=$(($LOAD_FACTOR * 4))
+
+for i in $(seq -w $loops); do
+	echo "=== Loop $i: $(date) ===" >> $seqres.full
+
+	_scratch_mkfs >/dev/null 2>&1
+	_init_flakey
+	_mount_flakey
+
+	($FSSTRESS_PROG $FSSTRESS_AVOID -w -d $SCRATCH_MNT -n 1000000 \
+		-p 100 >> $seqres.full &) > /dev/null 2>&1
+
+	sleep $runtime
+
+	# Here we only want to drop all write, don't need to umount the fs
+	_load_flakey_table $FLAKEY_DROP_WRITES
+
+	ps -e | grep fsstress > /dev/null 2>&1
+	while [ $? -eq 0 ]; do
+		$KILLALL_PROG -KILL fsstress > /dev/null 2>&1
+		wait > /dev/null 2>&1
+		ps -e | grep fsstress > /dev/null 2>&1
+	done
+
+	_unmount_flakey
+	_cleanup_flakey
+
+	# Mount the fs to do proper log replay for journal based fs
+	# so later check won't report annoying dirty log and only
+	# report real problem.
+	_scratch_mount
+	_scratch_unmount
+
+	_check_scratch_fs
+done
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/479.out b/tests/generic/479.out
new file mode 100644
index 00000000..290f18b3
--- /dev/null
+++ b/tests/generic/479.out
@@ -0,0 +1,2 @@
+QA output created by 479
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 1e808865..5ce3db1d 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -481,3 +481,4 @@
 476 auto rw
 477 auto quick exportfs
 478 auto quick
+479 auto
-- 
2.15.1

