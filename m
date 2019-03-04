Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42206 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfCDVTk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Mar 2019 16:19:40 -0500
Subject: [PATCH 4/5] generic: test statx attribute_mask setting
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 04 Mar 2019 13:19:35 -0800
Message-ID: <155173437536.767.4083133841860983852.stgit@magnolia>
In-Reply-To: <155173434205.767.15128498725168844621.stgit@magnolia>
References: <155173434205.767.15128498725168844621.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure the filesystem reports attribute_mask for the attributes it
supports.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/713     |   67 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/713.out |    1 +
 tests/generic/group   |    1 +
 3 files changed, 69 insertions(+)
 create mode 100755 tests/generic/713
 create mode 100644 tests/generic/713.out


diff --git a/tests/generic/713 b/tests/generic/713
new file mode 100755
index 00000000..cd128d9c
--- /dev/null
+++ b/tests/generic/713
@@ -0,0 +1,67 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 713
+#
+# Regression test for a bug where XFS fails to set statx attributes_mask but
+# sets attribute flags anyway.
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
+	rm -f $tmp.* $testfile
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_test
+
+get_attributes() {
+	$XFS_IO_PROG -r -c "statx -r" $1 | grep 'stat.attributes =' | cut -d ' ' -f 3
+}
+
+get_attributes_mask() {
+	$XFS_IO_PROG -r -c "statx -r" $1 | grep 'stat.attributes_mask =' | cut -d ' ' -f 3
+}
+
+check_statx_attributes()
+{
+	attrs=$(get_attributes $testfile)
+	mask=$(get_attributes_mask $testfile)
+
+	echo "MASK:$mask:ATTRS:$attrs:" >> $seqres.full
+
+	test -z "$mask" && _notrun "xfs_io statx command does not support attributes_mask"
+	test $(( mask )) -eq 0 && echo "attributes mask is zero"
+	test $(( attrs & ~(mask) )) -ne 0 && echo "attributes $attrs do not appear in mask $mask"
+}
+
+# Create file, check for incorrect mask
+testfile=$TEST_DIR/$$.test
+touch $testfile
+check_statx_attributes
+
+# Do it again, but this time try to turn on one of the attributes.
+if chattr +i $testfile > /dev/null 2>&1; then
+	check_statx_attributes
+	chattr -i $testfile
+fi
+if chattr +a $testfile > /dev/null 2>&1; then
+	check_statx_attributes
+	chattr -a $testfile
+fi
+
+status=0
+exit
diff --git a/tests/generic/713.out b/tests/generic/713.out
new file mode 100644
index 00000000..066598d3
--- /dev/null
+++ b/tests/generic/713.out
@@ -0,0 +1 @@
+QA output created by 713
diff --git a/tests/generic/group b/tests/generic/group
index 15227b67..d04bf39f 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -534,3 +534,4 @@
 529 auto quick attr
 530 auto quick unlink
 531 auto quick unlink
+713 auto quick
