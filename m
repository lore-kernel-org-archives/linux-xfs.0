Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40076 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730012AbfGOMz3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 08:55:29 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 2/3] generic: copy_file_range bounds test
Date: Mon, 15 Jul 2019 15:55:15 +0300
Message-Id: <20190715125516.7367-3-amir73il@gmail.com>
In-Reply-To: <20190715125516.7367-1-amir73il@gmail.com>
References: <20190715125516.7367-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

Test that copy_file_range will return the correct errors for various
error conditions and boundary constraints.

This is a regression test for kernel commit:

  5dae222a5ff0 vfs: allow copy_file_range to copy across devices

[Amir] Split out cross-device copy_range test and use only test dev.
Split out immutable/swapfile test cases to reduce the requirements to
run the bounds check to minimum and get coverage for more filesystems.
Remove the tests for read past EOF and write after chmod -r,
because we decided to stick with read(2)/write(2) semantics.
Add requirements needed for large size copy tests and fifo test.
Use existing char/block devices for char/block dev tests.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/990     | 134 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/990.out |  37 ++++++++++++
 tests/generic/group   |   1 +
 3 files changed, 172 insertions(+)
 create mode 100755 tests/generic/990
 create mode 100644 tests/generic/990.out

diff --git a/tests/generic/990 b/tests/generic/990
new file mode 100755
index 00000000..cdb8302b
--- /dev/null
+++ b/tests/generic/990
@@ -0,0 +1,134 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 990
+#
+# Exercise copy_file_range() syscall error conditions.
+#
+# This is a regression test for kernel commit:
+#   96e6e8f4a68d ("vfs: add missing checks to copy_file_range")
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+	[ -z "$loopdev" ] || _destroy_loop_device $loopdev
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs generic
+
+rm -f $seqres.full
+
+_require_test
+_require_loop
+#
+# This test effectively requires xfs_io with these commits
+#  2a42470b xfs_io: copy_file_range length is a size_t
+#  1a05efba io: open pipes in non-blocking mode
+#
+# Without those commits test will hang on old kernel when copying
+# very large size and when copying from a pipe.
+#
+# We require a new xfs_io feature of passing an open file as the
+# copy source, as an indication that the test can run without hanging
+# with large size argument and to avoid opening pipe in blocking mode.
+#
+_require_xfs_io_command "copy_range" "-f"
+
+testdir="$TEST_DIR/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+rm -f $seqres.full
+
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 128k" $testdir/file >> $seqres.full 2>&1
+
+echo source range overlaps destination range in same file returns EINVAL
+$XFS_IO_PROG -f -c "copy_range -s 32k -d 48k -l 32k $testdir/file" $testdir/file
+
+echo
+echo destination file O_RDONLY returns EBADF
+$XFS_IO_PROG -f -r -c "copy_range -l 32k $testdir/file" $testdir/copy
+
+echo
+echo destination file O_APPEND returns EBADF
+$XFS_IO_PROG -f -a -c "copy_range -l 32k $testdir/file" $testdir/copy
+
+echo
+echo source/destination as directory returns EISDIR
+$XFS_IO_PROG -c "copy_range -l 32k $testdir/file" $testdir
+$XFS_IO_PROG -f -c "copy_range -l 32k $testdir" $testdir/copy
+
+echo
+echo source/destination as blkdev returns EINVAL
+$XFS_IO_PROG -f -c "truncate 128k" $testdir/img >> $seqres.full 2>&1
+loopdev=`_create_loop_device $testdir/img`
+$XFS_IO_PROG -c "copy_range -l 32k $testdir/file" $loopdev
+$XFS_IO_PROG -f -c "copy_range -l 32k $loopdev" $testdir/copy
+_destroy_loop_device $loopdev
+loopdev=
+
+echo
+echo source/destination as chardev returns EINVAL
+$XFS_IO_PROG -c "copy_range -l 32k $testdir/file" /dev/null
+$XFS_IO_PROG -f -c "copy_range -l 32k /dev/zero" $testdir/copy
+
+echo
+echo source/destination as FIFO returns EINVAL
+mkfifo $testdir/fifo
+$XFS_IO_PROG -c "copy_range -l 32k $testdir/file" $testdir/fifo
+# Pass input pipe as non-blocking open file to avoid old xfs_io (<4.20)
+# opening the pipe in blocking mode and causing the test to hang
+$XFS_IO_PROG -r -n -f -c "open $testdir/copy" -C "copy_range -l 32k -f 0" $testdir/fifo
+
+max_off=$((8 * 2**60 - 65536 - 1))
+min_off=65537
+
+echo
+echo length beyond 8EiB wraps around 0 returns EOVERFLOW
+$XFS_IO_PROG -f -c "copy_range -l 10e -s $max_off $testdir/file" $testdir/copy
+$XFS_IO_PROG -f -c "copy_range -l 10e -d $max_off $testdir/file" $testdir/copy
+
+echo
+echo source range beyond 8TiB returns 0
+$XFS_IO_PROG -c "copy_range -s $max_off -l $min_off -d 0 $testdir/file" $testdir/copy
+
+echo
+echo destination range beyond 8TiB returns EFBIG
+$XFS_IO_PROG -c "copy_range -l $min_off -s 0 -d $max_off $testdir/file" $testdir/copy
+
+echo
+echo destination larger than rlimit returns EFBIG
+rm -f $testdir/copy
+$XFS_IO_PROG -c "truncate 128k" $testdir/file
+
+# need a wrapper so the "File size limit exceeded" error can be filtered
+do_rlimit_copy()
+{
+	$XFS_IO_PROG -f -c "copy_range -l 32k -s 0 -d 16m $testdir/file" $testdir/copy
+}
+
+ulimit -f $((8 * 1024))
+ulimit -c 0
+do_rlimit_copy 2>&1 | grep -o "File size limit exceeded"
+ulimit -f unlimited
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/990.out b/tests/generic/990.out
new file mode 100644
index 00000000..05d137de
--- /dev/null
+++ b/tests/generic/990.out
@@ -0,0 +1,37 @@
+QA output created by 990
+source range overlaps destination range in same file returns EINVAL
+copy_range: Invalid argument
+
+destination file O_RDONLY returns EBADF
+copy_range: Bad file descriptor
+
+destination file O_APPEND returns EBADF
+copy_range: Bad file descriptor
+
+source/destination as directory returns EISDIR
+copy_range: Is a directory
+copy_range: Is a directory
+
+source/destination as blkdev returns EINVAL
+copy_range: Invalid argument
+copy_range: Invalid argument
+
+source/destination as chardev returns EINVAL
+copy_range: Invalid argument
+copy_range: Invalid argument
+
+source/destination as FIFO returns EINVAL
+copy_range: Invalid argument
+copy_range: Invalid argument
+
+length beyond 8EiB wraps around 0 returns EOVERFLOW
+copy_range: Value too large for defined data type
+copy_range: Value too large for defined data type
+
+source range beyond 8TiB returns 0
+
+destination range beyond 8TiB returns EFBIG
+copy_range: File too large
+
+destination larger than rlimit returns EFBIG
+File size limit exceeded
diff --git a/tests/generic/group b/tests/generic/group
index 9ceaf317..8e764597 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -565,3 +565,4 @@
 560 auto stress dedupe
 561 auto stress dedupe
 562 auto clone
+990 auto quick copy_range
-- 
2.17.1
