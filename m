Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49852 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727265AbfBLCRo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Feb 2019 21:17:44 -0500
Subject: [PATCH 3/3] generic: check for reasonable inode creation time
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 11 Feb 2019 18:17:39 -0800
Message-ID: <154993785921.1948.13721935036926653125.stgit@magnolia>
In-Reply-To: <154993784038.1948.7502664832930298472.stgit@magnolia>
References: <154993784038.1948.7502664832930298472.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If statx returns inode creation time (aka btime), check it to make sure
that the filesystem is setting a creation time that's reasonably close
to when it creates a file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/709     |   53 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/709.out |    2 ++
 tests/generic/group   |    1 +
 3 files changed, 56 insertions(+)
 create mode 100755 tests/generic/709
 create mode 100644 tests/generic/709.out


diff --git a/tests/generic/709 b/tests/generic/709
new file mode 100755
index 00000000..ebec10de
--- /dev/null
+++ b/tests/generic/709
@@ -0,0 +1,53 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 709
+#
+# Check that statx btime (aka creation time) is plausibly close to when
+# we created a file.  A bug caught during code review of xfs patches revealed
+# that there weren't any sanity checks of the btime values.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+tmp=/tmp/$$
+status=1	# failure is the default!
+testfile=$TEST_DIR/$seq.txt
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.* $testfile
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/attr
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_xfs_io_command "statx" "-r"
+_require_btime
+
+rm -f $seqres.full
+rm -f $testfile
+
+# Create a file and the time we created it
+now=$(date +%s)
+touch $testfile
+
+# Make sure the reported btime is within 5 seconds of the time we recorded
+# just prior to creating the file.
+btime=$(date +%s -d "$($XFS_IO_PROG -c "statx -v -m $STATX_BTIME" $testfile | \
+	grep 'stat.btime =' | cut -d '=' -f 2)")
+test -n "$btime" || echo "error: did not see btime in output??"
+
+_within_tolerance "btime" "$btime" "$now" 0 5 -v
+
+status=0
+exit
diff --git a/tests/generic/709.out b/tests/generic/709.out
new file mode 100644
index 00000000..d8495ace
--- /dev/null
+++ b/tests/generic/709.out
@@ -0,0 +1,2 @@
+QA output created by 709
+btime is in range
diff --git a/tests/generic/group b/tests/generic/group
index cfd003d3..f56eb475 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -528,3 +528,4 @@
 523 auto quick attr
 524 auto quick
 525 auto quick rw
+709 auto quick
