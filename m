Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55336 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbfFNEuC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jun 2019 00:50:02 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs: test xfs_info on block device and mountpoint
Date: Fri, 14 Jun 2019 12:49:54 +0800
Message-Id: <20190614044954.22022-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

There was a bug, xfs_info fails on a mounted block device:

  # xfs_info /dev/mapper/testdev
  xfs_info: /dev/mapper/testdev contains a mounted filesystem

  fatal error -- couldn't initialize XFS library

xfsprogs has fixed it, this case is used to cover this bug.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 tests/xfs/1000     | 65 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1000.out |  2 ++
 tests/xfs/group    |  1 +
 3 files changed, 68 insertions(+)
 create mode 100755 tests/xfs/1000
 create mode 100644 tests/xfs/1000.out

diff --git a/tests/xfs/1000 b/tests/xfs/1000
new file mode 100755
index 00000000..689fe9e7
--- /dev/null
+++ b/tests/xfs/1000
@@ -0,0 +1,65 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 1000
+#
+# test xfs_info on block device and mountpoint
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
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
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+
+test_xfs_info()
+{
+	local target="$1"
+	local file=$tmp.$seq.info
+
+	$XFS_INFO_PROG $target > $file 2>&1
+	if [ $? -ne 0 ];then
+		echo "$XFS_INFO_PROG $target fails:"
+		cat $file
+	else
+		cat $file >> $seqres.full
+	fi
+}
+
+_scratch_mkfs > $seqres.full 2>&1
+# test unmounted block device(contains XFS)
+# Due to old xfsprogs doesn't support xfs_info a unmounted device, skip it
+$XFS_DB_PROG -c "info" $SCRATCH_DEV | grep -q "command info not found"
+if [ $? -ne 0 ]; then
+	test_xfs_info $SCRATCH_DEV
+fi
+
+_scratch_mount
+# test mounted block device and mountpoint
+test_xfs_info $SCRATCH_DEV
+test_xfs_info $SCRATCH_MNT
+
+echo "Silence is golden"
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1000.out b/tests/xfs/1000.out
new file mode 100644
index 00000000..681b3b48
--- /dev/null
+++ b/tests/xfs/1000.out
@@ -0,0 +1,2 @@
+QA output created by 1000
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index ffe4ae12..047fe332 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -504,3 +504,4 @@
 504 auto quick mkfs label
 505 auto quick spaceman
 506 auto quick health
+1000 auto quick
-- 
2.17.2
