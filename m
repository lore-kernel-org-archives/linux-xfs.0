Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55840 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbeJ3DCb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Oct 2018 23:02:31 -0400
Date: Mon, 29 Oct 2018 11:12:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: test packaged crc32c code
Message-ID: <20181029181242.GA4131@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the new crc32selftest command in xfs_io to check the correct
operation of the packaged xfsprogs, on the off chance that the packages
were cross compiled on a different machine type (which means the build
time test doesn't hold much water).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/734     |   44 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/734.out |    3 +++
 tests/xfs/group   |    1 +
 3 files changed, 48 insertions(+)
 create mode 100755 tests/xfs/734
 create mode 100644 tests/xfs/734.out

diff --git a/tests/xfs/734 b/tests/xfs/734
new file mode 100755
index 00000000..847c5bfd
--- /dev/null
+++ b/tests/xfs/734
@@ -0,0 +1,44 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 734
+#
+# Ensure that xfsprogs crc32 works correctly via xfs_io crc32selftest command.
+#
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -rf "$tmp".*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_xfs_io_command "crc32selftest"
+
+rm -f "$seqres.full"
+
+filter_selftest() {
+	sed -e 's/bytes in [0-9]* usec/bytes in XXX usec/g'
+}
+
+$XFS_IO_PROG -c 'crc32selftest' | filter_selftest
+
+echo "Silence is golden."
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/734.out b/tests/xfs/734.out
new file mode 100644
index 00000000..f2a3fdc1
--- /dev/null
+++ b/tests/xfs/734.out
@@ -0,0 +1,3 @@
+QA output created by 734
+crc32c: tests passed, 225944 bytes in XXX usec
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index 2cec0585..de66378f 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -491,3 +491,4 @@
 491 auto quick fuzz
 492 auto quick fuzz
 493 auto quick fuzz
+734 auto quick
