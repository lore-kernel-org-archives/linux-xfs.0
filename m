Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728943AbeKEUeU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Nov 2018 15:34:20 -0500
From: fdmanana@kernel.org
Subject: [PATCH 2/3] generic: test attempt to reflink eof block into the middle of a file
Date: Mon,  5 Nov 2018 11:15:01 +0000
Message-Id: <20181105111501.11920-1-fdmanana@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>

From: Filipe Manana <fdmanana@suse.com>

Test that we can not clone a range from a file A into the middle of a file B
when the range includes the last block of file A and file A's size is not
aligned with the filesystem's block size. Allowing such case would lead to
data corruption since the data between EOF and the end of its block is
undefined.

This is motivated by a bug recently found that affects both Btrfs and XFS
and is fixed by the following commits/patches for the linux kernel:

 07d19dc9fbe9 ("vfs: avoid problematic remapping requests into partial EOF block")
 b39989009bdb ("xfs: fix data corruption w/ unaligned reflink ranges")
 Btrfs: fix data corruption due to cloning of eof block

The VFS patch landed in kernel 4.20-rc1 and the XFS patch landed in 4.19.
The Btrfs fix is very recent and it is not yet in Linus' tree.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/518     | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/518.out | 10 +++++++++
 tests/generic/group   |  1 +
 3 files changed, 71 insertions(+)
 create mode 100755 tests/generic/518
 create mode 100644 tests/generic/518.out

diff --git a/tests/generic/518 b/tests/generic/518
new file mode 100755
index 00000000..c75110d1
--- /dev/null
+++ b/tests/generic/518
@@ -0,0 +1,60 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2018 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FS QA Test No. 518
+#
+# Test that we can not clone a range from a file A into the middle of a file B
+# when the range includes the last block of file A and file A's size is not
+# aligned with the filesystem's block size. Allowing such case would lead to
+# data corruption since the data between EOF and the end of its block is
+# undefined.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
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
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch_reflink
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+foo_size=$((256 * 1024 + 100)) # 256Kb + 100 bytes
+bar_size="1M"
+
+$XFS_IO_PROG -f -c "pwrite -S 0x3c 0 $foo_size" $SCRATCH_MNT/foo | _filter_xfs_io
+$XFS_IO_PROG -f -c "pwrite -S 0xb5 0 $bar_size" $SCRATCH_MNT/bar | _filter_xfs_io
+
+# Cloning the EOF block of a file into the middle of another file should fail
+# with an invalid argument error.
+$XFS_IO_PROG -c "reflink $SCRATCH_MNT/foo 0 512K $foo_size" $SCRATCH_MNT/bar
+
+# Unmount the filesystem and mount it again. This guarantees any file data in
+# the page cache is dropped.
+_scratch_cycle_mount
+
+# Verify no changes were made to the file.
+echo "File content after failed reflink:"
+od -A d -t x1 $SCRATCH_MNT/bar
+
+status=0
+exit
diff --git a/tests/generic/518.out b/tests/generic/518.out
new file mode 100644
index 00000000..726c2073
--- /dev/null
+++ b/tests/generic/518.out
@@ -0,0 +1,10 @@
+QA output created by 518
+wrote 262244/262244 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1048576/1048576 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+XFS_IOC_CLONE_RANGE: Invalid argument
+File content after failed reflink:
+0000000 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5
+*
+1048576
diff --git a/tests/generic/group b/tests/generic/group
index 326d3a1d..ef24f578 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -520,3 +520,4 @@
 515 auto quick clone
 516 auto quick dedupe clone
 517 auto quick dedupe clone
+518 auto quick clone
-- 
2.11.0
