Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:20179 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750758AbeEKCL4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 22:11:56 -0400
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: test mount vs superblock shrinker races
Date: Fri, 11 May 2018 12:11:52 +1000
Message-Id: <20180511021152.10803-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Test case for superblock shrinkers running while the filesystem is
being set up and/or torn down and tripping over inconsistent state.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 tests/xfs/451     | 72 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/451.out |  2 ++
 tests/xfs/group   |  1 +
 3 files changed, 75 insertions(+)
 create mode 100755 tests/xfs/451
 create mode 100644 tests/xfs/451.out

diff --git a/tests/xfs/451 b/tests/xfs/451
new file mode 100755
index 000000000000..d8a4a5b93bf3
--- /dev/null
+++ b/tests/xfs/451
@@ -0,0 +1,72 @@
+#! /bin/bash
+# FS QA Test 451
+#
+# Exercise mount vs superblock shrinker races.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2018 Red Hat, Inc.  All Rights Reserved.
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
+	echo 0 > /sys/fs/xfs/debug/mount_delay
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
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+_require_xfs_sysfs debug/mount_delay
+
+echo "Silence is golden"
+
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount
+
+$XFS_IO_PROG -fxc "pwrite 0 4k" -c fsync \
+		-c "shutdown" $SCRATCH_MNT/foo 2>&1 > /dev_null
+
+_scratch_unmount
+
+echo 30 > /sys/fs/xfs/debug/mount_delay
+_scratch_mount
+echo 0 > /sys/fs/xfs/debug/mount_delay
+_scratch_unmount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/451.out b/tests/xfs/451.out
new file mode 100644
index 000000000000..db924411b72f
--- /dev/null
+++ b/tests/xfs/451.out
@@ -0,0 +1,2 @@
+QA output created by 451
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index 2a7f5eb68e82..72f65b6aff0a 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -443,3 +443,4 @@
 444 auto quick
 445 auto quick filestreams
 450 auto quick
+451 auto mount
-- 
2.17.0

