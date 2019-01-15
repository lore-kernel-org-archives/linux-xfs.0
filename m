Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35466 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727369AbfAOOJr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Jan 2019 09:09:47 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] tests/generic: test writepage cached mapping validity
Date: Tue, 15 Jan 2019 09:09:45 -0500
Message-Id: <20190115140945.25293-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

XFS has a bug where page writeback can end up sending data to the
wrong location due to a stale, cached file mapping. Add a test to
trigger this problem by racing background writeback with a
truncate/rewrite of the final page of the file.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Note again that this test is expected to occasionally fail on upstream
XFS. The fix is undergoing development and review.

Brian

v2:
- Fix up copyright header.
- Fix up _require statements and _scratch_mount* error checks.
v1: https://marc.info/?l=fstests&m=154721349921715&w=2

 tests/generic/999     | 80 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 83 insertions(+)
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

diff --git a/tests/generic/999 b/tests/generic/999
new file mode 100755
index 00000000..0546125e
--- /dev/null
+++ b/tests/generic/999
@@ -0,0 +1,80 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2017-2019 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 999
+#
+# Test XFS page writeback code for races with the cached file mapping. XFS
+# caches the file -> block mapping for a full extent once it is initially looked
+# up. The cached mapping is used for all subsequent pages in the same writeback
+# cycle that cover the associated extent. Under certain conditions, it is
+# possible for concurrent operations on the file to invalidate the cached
+# mapping without the knowledge of writeback. Writeback ends up sending I/O to a
+# partly stale mapping and potentially leaving delalloc blocks in the current
+# mapping unconverted.
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
+}
+
+# get standard environment, filters and checks
+. ./common/rc
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
+_require_test_program "feature"
+_require_xfs_io_command "sync_range"
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount
+
+file=$SCRATCH_MNT/file
+filesize=$((1024 * 1024 * 32))
+pagesize=`src/feature -s`
+truncsize=$((filesize - pagesize))
+
+for i in $(seq 0 15); do
+	# Truncate the file and fsync to persist the final size on-disk. This is
+	# required so the subsequent truncate will not wait on writeback.
+	$XFS_IO_PROG -fc "truncate 0" $file
+	$XFS_IO_PROG -c "truncate $filesize" -c fsync $file
+
+	# create a small enough delalloc extent to likely be contiguous
+	$XFS_IO_PROG -c "pwrite 0 $filesize" $file >> $seqres.full 2>&1
+
+	# Start writeback and a racing truncate and rewrite of the final page.
+	$XFS_IO_PROG -c "sync_range -w 0 0" $file &
+	sync_pid=$!
+	$XFS_IO_PROG -c "truncate $truncsize" \
+		     -c "pwrite $truncsize $pagesize" $file >> $seqres.full 2>&1
+
+	# If the test fails, the most likely outcome is an sb_fdblocks mismatch
+	# and/or an associated delalloc assert failure on inode reclaim. Cycle
+	# the mount to trigger detection.
+	wait $sync_pid
+	_scratch_cycle_mount
+done
+
+echo Silence is golden
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/999.out b/tests/generic/999.out
new file mode 100644
index 00000000..3b276ca8
--- /dev/null
+++ b/tests/generic/999.out
@@ -0,0 +1,2 @@
+QA output created by 999
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index ea5aa7aa..ce165981 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -525,3 +525,4 @@
 520 auto quick log
 521 soak long_rw
 522 soak long_rw
+999 auto quick
-- 
2.17.2
