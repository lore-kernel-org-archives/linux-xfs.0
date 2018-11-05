Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728961AbeKEUeH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Nov 2018 15:34:07 -0500
From: fdmanana@kernel.org
Subject: [PATCH 1/3] generic: test attempt to dedup eof block into the middle of a file
Date: Mon,  5 Nov 2018 11:14:45 +0000
Message-Id: <20181105111445.11870-1-fdmanana@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>

From: Filipe Manana <fdmanana@suse.com>

Test that deduplication of an entire file that has a size that is not
aligned to the filesystem's block size into the middle of a different
file does not corrupt the destination's file data by reflinking the last
(eof) block.

This test is motivated by a bug recently found that affects both Btrfs
and XFS, and is fixed by the following commits/patches for the linux
kernel:

 07d19dc9fbe9 ("vfs: avoid problematic remapping requests into partial EOF block")
 dceeb47b0ed6 ("xfs: fix data corruption w/ unaligned dedupe ranges")
 de02b9f6bb65 ("Btrfs: fix data corruption when deduplicating between different files")
 Btrfs: fix infinite loop on inode eviction after deduplication of eof block

The VFS patch was added to kernel 4.20-rc1 and the XFS and first Btrfs
patches were added to kernel 4.19. The second patch for Btrfs is very
recent and it is not yet in Linus' tree.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/517     | 98 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/517.out | 45 +++++++++++++++++++++++
 tests/generic/group   |  1 +
 3 files changed, 144 insertions(+)
 create mode 100755 tests/generic/517
 create mode 100644 tests/generic/517.out

diff --git a/tests/generic/517 b/tests/generic/517
new file mode 100755
index 00000000..601bb24e
--- /dev/null
+++ b/tests/generic/517
@@ -0,0 +1,98 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2018 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FS QA Test No. 517
+#
+# Test that deduplication of an entire file that has a size that is not aligned
+# to the filesystem's block size into the middle of a different file does not
+# corrupt the destination's file data by reflinking the last (eof) block.
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
+_require_scratch_dedupe
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+# The first byte with a value of 0xae starts at an offset (2518890) which is not
+# a multiple of the block size.
+$XFS_IO_PROG -f \
+	-c "pwrite -S 0x6b 0 2518890" \
+	-c "pwrite -S 0xae 2518890 102398" \
+	$SCRATCH_MNT/foo | _filter_xfs_io
+
+# Create a second file with a length not aligned to the block size, whose bytes
+# all have the value 0x6b, so that its extent(s) can be deduplicated with the
+# first file.
+$XFS_IO_PROG -f -c "pwrite -S 0x6b 0 557771" $SCRATCH_MNT/bar | _filter_xfs_io
+
+# The file is filled with bytes having the value 0x6b from offset 0 to offset
+# 2518889 and with the value 0xae from offset 2518890 to offset 2621287.
+echo "File content before first deduplication:"
+od -t x1 $SCRATCH_MNT/foo
+
+# Now deduplicate the entire second file into a range of the first file that
+# also has all bytes with the value 0x6b. The destination range's end offset
+# must not be aligned to the block size and must be less then the offset of
+# the first byte with the value 0xae (byte at offset 2518890).
+$XFS_IO_PROG -c "dedupe $SCRATCH_MNT/bar 0 1957888 557771" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+
+# We should have exactly the same data we had before we asked for deduplication.
+echo "File content after first deduplication and before unmounting:"
+od -A d -t x1 $SCRATCH_MNT/foo
+
+# Unmount the filesystem and mount it again. This guarantees any file data in
+# the page cache is dropped.
+_scratch_cycle_mount
+
+# We should have exactly the same data we had before we asked for deduplication.
+echo "File content after first unmount:"
+od -A d -t x1 $SCRATCH_MNT/foo
+
+# Now do a similar test when trying to dedup just the last (eof) block of a file
+# into the middle of another file. This triggered a different bug on btrfs.
+$XFS_IO_PROG -f -c "pwrite -S 0xae 0 100" $SCRATCH_MNT/baz | _filter_xfs_io
+
+# Unmount the filesystem and mount it again before attempting to dedupe baz's
+# last block into foo. This is necessary to trigger that btrfs bug mentioned
+# before.
+_scratch_cycle_mount
+
+# Now attempt to dedupe the single block of baz into foo.
+$XFS_IO_PROG -c "dedupe $SCRATCH_MNT/baz 0 2519040 100" $SCRATCH_MNT/foo \
+    | _filter_xfs_io
+
+# Now attempt to unmount the filesystem before reading from the file. This is
+# meant to trigger the btrfs bug which caused an infinite loop during inode
+# eviction.
+_scratch_cycle_mount
+
+# We should have exactly the same data we had before we asked for deduplication.
+echo "File content after second deduplication:"
+od -A d -t x1 $SCRATCH_MNT/foo
+
+status=0
+exit
diff --git a/tests/generic/517.out b/tests/generic/517.out
new file mode 100644
index 00000000..137a9719
--- /dev/null
+++ b/tests/generic/517.out
@@ -0,0 +1,45 @@
+QA output created by 517
+wrote 2518890/2518890 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 102398/102398 bytes at offset 2518890
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 557771/557771 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File content before first deduplication:
+0000000 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
+*
+11467540 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b ae ae ae ae ae ae
+11467560 ae ae ae ae ae ae ae ae ae ae ae ae ae ae ae ae
+*
+11777540 ae ae ae ae ae ae ae ae
+11777550
+deduped 557771/557771 bytes at offset 1957888
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File content after first deduplication and before unmounting:
+0000000 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
+*
+2518880 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b ae ae ae ae ae ae
+2518896 ae ae ae ae ae ae ae ae ae ae ae ae ae ae ae ae
+*
+2621280 ae ae ae ae ae ae ae ae
+2621288
+File content after first unmount:
+0000000 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
+*
+2518880 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b ae ae ae ae ae ae
+2518896 ae ae ae ae ae ae ae ae ae ae ae ae ae ae ae ae
+*
+2621280 ae ae ae ae ae ae ae ae
+2621288
+wrote 100/100 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+deduped 100/100 bytes at offset 2519040
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File content after second deduplication:
+0000000 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
+*
+2518880 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b ae ae ae ae ae ae
+2518896 ae ae ae ae ae ae ae ae ae ae ae ae ae ae ae ae
+*
+2621280 ae ae ae ae ae ae ae ae
+2621288
diff --git a/tests/generic/group b/tests/generic/group
index 54d71d55..326d3a1d 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -519,3 +519,4 @@
 514 auto quick clone
 515 auto quick clone
 516 auto quick dedupe clone
+517 auto quick dedupe clone
-- 
2.11.0
