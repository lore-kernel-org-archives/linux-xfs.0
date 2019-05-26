Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44092 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbfEZIps (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 May 2019 04:45:48 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 3/5] generic: copy_file_range swapfile test
Date: Sun, 26 May 2019 11:45:33 +0300
Message-Id: <20190526084535.999-4-amir73il@gmail.com>
In-Reply-To: <20190526084535.999-1-amir73il@gmail.com>
References: <20190526084535.999-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

This test case was split out of Dave Chinner's copy_file_range bounds
check test to reduce the requirements for running the bounds check.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/989     | 56 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/989.out |  4 ++++
 tests/generic/group   |  1 +
 3 files changed, 61 insertions(+)
 create mode 100755 tests/generic/989
 create mode 100644 tests/generic/989.out

diff --git a/tests/generic/989 b/tests/generic/989
new file mode 100755
index 00000000..27c10296
--- /dev/null
+++ b/tests/generic/989
@@ -0,0 +1,56 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 989
+#
+# Check that we cannot copy_file_range() to/from a swapfile
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
+_require_scratch
+_require_xfs_io_command "copy_range"
+_require_scratch_swapfile
+
+_scratch_mkfs 2>&1 >> $seqres.full
+_scratch_mount
+
+testdir=$SCRATCH_MNT
+
+rm -f $seqres.full
+
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 128k" $testdir/file >> $seqres.full 2>&1
+
+echo swap files return ETXTBUSY
+_format_swapfile $testdir/swapfile 16m
+swapon $testdir/swapfile
+$XFS_IO_PROG -f -c "copy_range -l 32k $testdir/file" $testdir/swapfile
+$XFS_IO_PROG -f -c "copy_range -l 32k $testdir/swapfile" $testdir/copy
+swapoff $testdir/swapfile
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/989.out b/tests/generic/989.out
new file mode 100644
index 00000000..32da0ce9
--- /dev/null
+++ b/tests/generic/989.out
@@ -0,0 +1,4 @@
+QA output created by 989
+swap files return ETXTBUSY
+copy_range: Text file busy
+copy_range: Text file busy
diff --git a/tests/generic/group b/tests/generic/group
index 20b95c14..4c100781 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -551,3 +551,4 @@
 546 auto quick clone enospc log
 547 auto quick log
 988 auto quick copy_range
+989 auto quick copy_range swap
-- 
2.17.1
