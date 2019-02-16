Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34510 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfBPAl0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Feb 2019 19:41:26 -0500
Date: Fri, 15 Feb 2019 16:41:19 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: test mkfs extent size hint validation
Message-ID: <20190216004119.GW32253@magnolia>
References: <20190216003923.GV32253@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190216003923.GV32253@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure mkfs won't format filesystems that fail extent size hint
validation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/738     |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/738.out |    2 ++
 tests/xfs/group   |    1 +
 3 files changed, 51 insertions(+)
 create mode 100755 tests/xfs/738
 create mode 100644 tests/xfs/738.out

diff --git a/tests/xfs/738 b/tests/xfs/738
new file mode 100755
index 00000000..ee0ffaae
--- /dev/null
+++ b/tests/xfs/738
@@ -0,0 +1,48 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 738
+#
+# Make sure we can't format a filesystem with insane extent hints.
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
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_scratch_nocheck
+
+rm -f $seqres.full
+
+# Try regular extent size hint
+echo extszinherit >> $seqres.full
+_scratch_mkfs -d extszinherit=8388608 >> $seqres.full 2>&1
+test $? -eq 1 || echo "should have failed extszinherit"
+
+# Try cow extent size hint if supported
+$MKFS_XFS_PROG -N -f $SCRATCH_DEV > $tmp.mkfs
+if grep -q 'reflink=' $tmp.mkfs ; then
+	echo cowextsize >> $seqres.full
+	_scratch_mkfs -m reflink=1 -d cowextsize=8388608 >> $seqres.full 2>&1
+	test $? -eq 1 || echo "should have failed cowextsize"
+fi
+
+echo silence is golden
+status=0
+exit
diff --git a/tests/xfs/738.out b/tests/xfs/738.out
new file mode 100644
index 00000000..703fe23b
--- /dev/null
+++ b/tests/xfs/738.out
@@ -0,0 +1,2 @@
+QA output created by 738
+silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index 677396fb..b2fea9ef 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -515,6 +515,7 @@
 731 dangerous_scrub dangerous_online_repair
 736 auto quick unlink
 737 auto quick unlink
+738 auto quick
 1500 auto prealloc rw
 1501 auto prealloc rw
 1502 auto prealloc rw
