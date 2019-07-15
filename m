Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33279 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730046AbfGOMz3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 08:55:29 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 3/3] generic: cross-device copy_file_range test
Date: Mon, 15 Jul 2019 15:55:16 +0300
Message-Id: <20190715125516.7367-4-amir73il@gmail.com>
In-Reply-To: <20190715125516.7367-1-amir73il@gmail.com>
References: <20190715125516.7367-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

Old kernels do not support cross-device copy_file_range.

This is a regression test for kernel commit:

  5dae222a5ff0 vfs: allow copy_file_range to copy across devices

[Amir] Split out cross-device copy_range test to a new test and
_notrun if kernel/filesystem do not support cross-device copy_range.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/991     | 64 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/991.out |  4 +++
 tests/generic/group   |  1 +
 3 files changed, 69 insertions(+)
 create mode 100755 tests/generic/991
 create mode 100644 tests/generic/991.out

diff --git a/tests/generic/991 b/tests/generic/991
new file mode 100755
index 00000000..69b8d3d5
--- /dev/null
+++ b/tests/generic/991
@@ -0,0 +1,64 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 991
+#
+# Exercise copy_file_range() across devices supported by some
+# filesystems since kernel commit:
+#
+# 5dae222a5ff0 vfs: allow copy_file_range to copy across devices
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
+_require_scratch
+_require_xfs_io_command "copy_range"
+
+_scratch_mkfs 2>&1 >> $seqres.full
+_scratch_mount
+
+
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
+rm -f $seqres.full
+
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 128k" $testdir/file >> $seqres.full 2>&1
+
+# expect success or EXDEV on filesystem/kernel that do not support
+# cross-device copy_range
+testio=`$XFS_IO_PROG -f -c "copy_range -l 128k $testdir/file" $SCRATCH_MNT/copy 2>&1`
+echo $testio | grep -q "cross-device" && \
+	_notrun "$FSTYP does not support cross-device copy_file_range"
+echo -n $testio
+cmp $testdir/file $SCRATCH_MNT/copy
+echo "md5sums after xdev copy:"
+md5sum $testdir/file $SCRATCH_MNT/copy | _filter_test_dir | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/991.out b/tests/generic/991.out
new file mode 100644
index 00000000..19c22dfe
--- /dev/null
+++ b/tests/generic/991.out
@@ -0,0 +1,4 @@
+QA output created by 991
+md5sums after xdev copy:
+81615449a98aaaad8dc179b3bec87f38  TEST_DIR/test-991/file
+81615449a98aaaad8dc179b3bec87f38  SCRATCH_MNT/copy
diff --git a/tests/generic/group b/tests/generic/group
index 8e764597..b1a7c594 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -566,3 +566,4 @@
 561 auto stress dedupe
 562 auto clone
 990 auto quick copy_range
+991 auto quick copy_range
-- 
2.17.1
