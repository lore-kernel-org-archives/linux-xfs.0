Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44018 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933471AbeFVSEC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Jun 2018 14:04:02 -0400
From: Marco Benatto <mbenatto@redhat.com>
Subject: [PATCH v2] xfstests: Test root inode parent pointer repairing
Date: Fri, 22 Jun 2018 15:03:57 -0300
Message-Id: <20180622180357.10322-1-mbenatto@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, guaneryu@gmail.com, sandeen@redhat.com

Recently we found out xfs_repair were not repairing
root inode parent pointer when root inode is on short-form
and parent points to an invalid inode number (refer to:
"xfs_repair: Fix root inode's parent when it's bogus for sf
directory" on xfs-devel list).

This test checks if xfs_repair successfully repair the
filesystem in the scenario mentioned before.

Signed-off-by: Marco Benatto <mbenatto@redhat.com>
---
 tests/xfs/450     | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/450.out |  2 ++
 tests/xfs/group   |  1 +
 3 files changed, 60 insertions(+)
 create mode 100755 tests/xfs/450
 create mode 100644 tests/xfs/450.out

diff --git a/tests/xfs/450 b/tests/xfs/450
new file mode 100755
index 0000000..b9c585f
--- /dev/null
+++ b/tests/xfs/450
@@ -0,0 +1,57 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Red Hat Inc.  All Rights Reserved.
+#
+# FS QA Test 450
+#
+# Make sure xfs_repair can repair root inode parent's pointer
+# when it contains a bogus ino when it's using shot form directory
+
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
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+echo "Silence is golden"
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+
+_scratch_mkfs >> /dev/null 2>&1
+
+rootino=$(_scratch_xfs_get_metadata_field 'rootino' 'sb 0')
+
+prefix=$(_scratch_get_sfdir_prefix ${rootino} || \
+			_fail "Cannot determine sfdir prefix")
+
+# Corrupt root inode parent pointer
+_scratch_xfs_set_metadata_field "${prefix}.hdr.parent.i4" 0 "inode ${rootino}"\
+						>> $seqres.full 2>&1
+
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+# Post-test integrity check will detect any remaining corruption
+
+status=0
+exit
diff --git a/tests/xfs/450.out b/tests/xfs/450.out
new file mode 100644
index 0000000..f2d76bd
--- /dev/null
+++ b/tests/xfs/450.out
@@ -0,0 +1,2 @@
+QA output created by 450
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index 932ab90..a7f753e 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -447,3 +447,4 @@
 447 auto mount
 448 auto quick fuzzers
 449 auto quick
+450 auto quick metadata repair
-- 
2.9.5

