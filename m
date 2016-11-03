Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34082 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754788AbcKCJwP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Nov 2016 05:52:15 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfs: mount with corrupted inopblock in superblock
Date: Thu,  3 Nov 2016 17:52:00 +0800
Message-Id: <1478166720-14354-1-git-send-email-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

When sb_inopblock is corrupted (out of boundary in this case), XFS
should not crash and refuse to mount.

Kernel commit 392c6de98af1 ("xfs: sanitize sb_inopblock in
xfs_mount_validate_sb") addresses this issue.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/xfs/118     | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/118.out |  2 ++
 tests/xfs/group   |  1 +
 3 files changed, 69 insertions(+)
 create mode 100755 tests/xfs/118
 create mode 100644 tests/xfs/118.out

diff --git a/tests/xfs/118 b/tests/xfs/118
new file mode 100755
index 0000000..680add8
--- /dev/null
+++ b/tests/xfs/118
@@ -0,0 +1,66 @@
+#! /bin/bash
+# FS QA Test 118
+#
+# Mount an XFS with out of bounds inopblock
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Red Hat Inc.,  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
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
+# real QA test starts here
+_supported_fs xfs
+_supported_os IRIX Linux
+# we corrupt scratch dev on purpose
+_require_scratch_nocheck
+
+_scratch_mkfs >>$seqres.full
+
+# corrupt sb_inopblock
+_scratch_xfs_db -x -c "sb 0" -c "write -c inopblock 512" >>$seqres.full
+
+# mount corrupted fs
+_scratch_mount >>$seqres.full 2>&1
+
+# no crash, and SCRATCH_DEV should not be mounted either
+_is_mounted $SCRATCH_DEV
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/xfs/118.out b/tests/xfs/118.out
new file mode 100644
index 0000000..3daed86
--- /dev/null
+++ b/tests/xfs/118.out
@@ -0,0 +1,2 @@
+QA output created by 118
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index 3296eb9..3bfcb80 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -115,6 +115,7 @@
 115 parent attr
 116 quota auto quick
 117 fuzzers
+118 auto quick metadata
 119 log v2log auto freeze dangerous
 120 fuzzers
 121 log auto quick
-- 
2.7.4

