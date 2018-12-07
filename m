Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:34586 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725952AbeLGGYu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Dec 2018 01:24:50 -0500
Subject: [PATCH 12/12] generic: long fsx soak tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 06 Dec 2018 22:24:45 -0800
Message-ID: <154416388577.15344.12576557765635823075.stgit@magnolia>
In-Reply-To: <154416379233.15344.4377231692638417530.stgit@magnolia>
References: <154416379233.15344.4377231692638417530.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a few tests to implement long soak tests of fsx.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/938     |   61 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/938.out |    2 ++
 tests/generic/939     |   55 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/939.out |    2 ++
 tests/generic/group   |    2 ++
 5 files changed, 122 insertions(+)
 create mode 100755 tests/generic/938
 create mode 100644 tests/generic/938.out
 create mode 100755 tests/generic/939
 create mode 100644 tests/generic/939.out


diff --git a/tests/generic/938 b/tests/generic/938
new file mode 100755
index 00000000..9a860579
--- /dev/null
+++ b/tests/generic/938
@@ -0,0 +1,61 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle.  All Rights Reserved.
+#
+# FS QA Test 938
+#
+# Long-soak directio fsx test
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1        # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+        cd /
+        rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_odirect
+
+# Run fsx for a million ops or more
+nr_ops=$((1000000 * TIME_FACTOR))
+op_sz=$((128000 * LOAD_FACTOR))
+file_sz=$((600000 * LOAD_FACTOR))
+fsx_file=$TEST_DIR/fsx.$seq
+min_dio_sz=$(_min_dio_alignment)
+
+fsx_args=(-q)
+fsx_args+=(-N $nr_ops)
+fsx_args+=(-p $((nr_ops / 100)))
+fsx_args+=(-o $op_sz)
+fsx_args+=(-l $file_sz)
+fsx_args+=(-r $min_dio_sz)
+fsx_args+=(-t $min_dio_sz)
+fsx_args+=(-w $min_dio_sz)
+fsx_args+=(-Z)
+
+run_fsx "${fsx_args[@]}" | sed -e '/^fsx.*/d'
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/generic/938.out b/tests/generic/938.out
new file mode 100644
index 00000000..11b565ee
--- /dev/null
+++ b/tests/generic/938.out
@@ -0,0 +1,2 @@
+QA output created by 938
+Silence is golden
diff --git a/tests/generic/939 b/tests/generic/939
new file mode 100755
index 00000000..6a251fdd
--- /dev/null
+++ b/tests/generic/939
@@ -0,0 +1,55 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle.  All Rights Reserved.
+#
+# FS QA Test 938
+#
+# Long-soak buffered fsx test
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1        # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+        cd /
+        rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_test
+
+# Run fsx for a million ops or more
+nr_ops=$((1000000 * TIME_FACTOR))
+op_sz=$((128000 * LOAD_FACTOR))
+file_sz=$((600000 * LOAD_FACTOR))
+fsx_file=$TEST_DIR/fsx.$seq
+
+fsx_args=(-q)
+fsx_args+=(-N $nr_ops)
+fsx_args+=(-p $((nr_ops / 100)))
+fsx_args+=(-o $op_sz)
+fsx_args+=(-l $file_sz)
+
+run_fsx "${fsx_args[@]}" | sed -e '/^fsx.*/d'
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/generic/939.out b/tests/generic/939.out
new file mode 100644
index 00000000..a86e90c5
--- /dev/null
+++ b/tests/generic/939.out
@@ -0,0 +1,2 @@
+QA output created by 939
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index eb5e4ce9..9025d24e 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -523,3 +523,5 @@
 518 auto quick clone
 519 auto quick
 520 auto quick log
+938 soak long_rw
+939 soak long_rw
