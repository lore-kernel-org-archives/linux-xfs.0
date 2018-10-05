Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53020 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbeJEHPT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 03:15:19 -0400
Subject: [PATCH 1/6] generic: add bfoster's alternate reproducer
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 04 Oct 2018 17:19:14 -0700
Message-ID: <153869875404.26648.4736407885559502992.stgit@magnolia>
In-Reply-To: <153869874763.26648.516233620615833277.stgit@magnolia>
References: <153869874763.26648.516233620615833277.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add Brian Foster's alternate reproducer code for the mread-after-eof
problem so that we increase the chances that either this or generic/499
will catch the problem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/707     |   55 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/707.out |    2 ++
 tests/generic/group   |    1 +
 3 files changed, 58 insertions(+)
 create mode 100755 tests/generic/707
 create mode 100644 tests/generic/707.out


diff --git a/tests/generic/707 b/tests/generic/707
new file mode 100755
index 00000000..74193c55
--- /dev/null
+++ b/tests/generic/707
@@ -0,0 +1,55 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 707
+#
+# Test a specific sequence of fsx operations that causes an mmap read past
+# eof to return nonzero contents.
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
+. ./common/punch
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_xfs_io_command "fcollapse"
+_require_xfs_io_command "fzero"
+
+rm -f $seqres.full
+
+_scratch_mkfs_sized $((1024 * 1024 * 100)) >>$seqres.full 2>&1
+_scratch_mount
+
+$XFS_IO_PROG -fc "pwrite 0 100m" -c fsync $SCRATCH_MNT/file >>$seqres.full 2>&1
+rm -f $SCRATCH_MNT/file
+
+cat >> $tmp.fsxops << ENDL
+truncate 0x0 0x1f0d6 0x380e1
+write 0x1ad87 0x6c99 0x180d6
+zero_range 0x14426 0xd3aa 0x21a20 keep_size
+mapread 0x1f69a 0x2386 0x21a20
+ENDL
+
+victim=$SCRATCH_MNT/a
+touch $victim
+$here/ltp/fsx --replay-ops $tmp.fsxops $victim > $tmp.output 2>&1 || cat $tmp.output
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/generic/707.out b/tests/generic/707.out
new file mode 100644
index 00000000..8e57a1d8
--- /dev/null
+++ b/tests/generic/707.out
@@ -0,0 +1,2 @@
+QA output created by 707
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 4da0e188..06b062e1 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -508,3 +508,4 @@
 503 auto quick dax punch collapse zero
 504 auto quick locks
 505 shutdown auto quick metadata
+707 auto quick rw collapse zero
