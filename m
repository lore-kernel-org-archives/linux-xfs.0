Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41168 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754012AbeFUScx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 14:32:53 -0400
Subject: [PATCH 3/4] generic: mread past eof shows nonzero contents
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jun 2018 11:32:49 -0700
Message-ID: <152960596951.26479.121617216998011751.stgit@magnolia>
In-Reply-To: <152960594943.26479.1457883867468749220.stgit@magnolia>
References: <152960594943.26479.1457883867468749220.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Certain sequences of generic/127 invocations complain about being able
to mread nonzero contents past eof.  Replicate that here as a regression
test.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/708     |   54 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/708.out |    2 ++
 tests/generic/group   |    1 +
 3 files changed, 57 insertions(+)
 create mode 100755 tests/generic/708
 create mode 100644 tests/generic/708.out


diff --git a/tests/generic/708 b/tests/generic/708
new file mode 100755
index 00000000..d380053f
--- /dev/null
+++ b/tests/generic/708
@@ -0,0 +1,54 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 708
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
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+cat >> $tmp.fsxops << ENDL
+fallocate 0x77e2 0x5f06 0x269a2 keep_size
+mapwrite 0x2e7fc 0x42ba 0x3f989
+write 0x67a9 0x714e 0x3f989
+write 0x39f96 0x185a 0x3f989
+collapse_range 0x36000 0x8000 0x3f989
+mapread 0x74c0 0x1bb3 0x3e2d0
+truncate 0x0 0x8aa2 0x3e2d0
+zero_range 0x1265 0x783d 0x8aa2
+mapread 0x7bd8 0xeca 0x8aa2
+ENDL
+
+victim=$SCRATCH_MNT/a
+touch $victim
+$here/ltp/fsx --replay-ops $tmp.fsxops $victim > $tmp.output || cat $tmp.output
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/generic/708.out b/tests/generic/708.out
new file mode 100644
index 00000000..33c478ad
--- /dev/null
+++ b/tests/generic/708.out
@@ -0,0 +1,2 @@
+QA output created by 708
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 83a6fdab..1a1a0a6e 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -501,3 +501,4 @@
 496 auto quick swap
 497 auto quick swap collapse
 498 auto quick log
+708 auto quick rw collapse

