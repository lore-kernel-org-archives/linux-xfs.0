Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50178 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760042AbdAFTk2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Jan 2017 14:40:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] generic: test racing getxattr requests against xattr add/remove
Date: Fri,  6 Jan 2017 14:39:30 -0500
Message-Id: <1483731570-55208-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

This test reproduces a bug in XFS where a getxattr of an existing xattr
returns failure due to a race with a setxattr that causes inode
attribute fork conversion.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/generic/402     | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/402.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 88 insertions(+)
 create mode 100755 tests/generic/402
 create mode 100644 tests/generic/402.out

diff --git a/tests/generic/402 b/tests/generic/402
new file mode 100755
index 0000000..b9739bb
--- /dev/null
+++ b/tests/generic/402
@@ -0,0 +1,85 @@
+#! /bin/bash
+# FS QA Test 402
+#
+# Test racing getxattr requests against large xattr add and remove loop. This
+# reproduces a bug on XFS where a getxattr of an existing attribute spuriously
+# returned failure due to races with attribute fork conversion.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Red hat, Inc.  All Rights Reserved.
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
+. ./common/attr
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os IRIX Linux
+_require_scratch
+_require_attrs
+
+_scratch_mkfs > $seqres.full 2>&1 || _fail "mkfs"
+_scratch_mount || _fail "mount"
+
+# create xattr small enough for local format on XFS
+touch $SCRATCH_MNT/file
+$SETFATTR_PROG -n trusted.small -v a $SCRATCH_MNT/file
+
+# start a background getxattr loop for the existing xattr
+while [ true ]; do
+	$GETFATTR_PROG --absolute-names -n trusted.small $SCRATCH_MNT/file \
+		> /dev/null || break
+done &
+getfattr_pid=$!
+
+# while the above is spinning, add and remove a large attribute to cause back
+# and forth inode attribute fork conversion
+largeval=`for i in $(seq 0 511); do echo -n a; done`
+for i in $(seq 0 99); do
+	$SETFATTR_PROG -n trusted.big -v $largeval $SCRATCH_MNT/file
+	$SETFATTR_PROG -x trusted.big $SCRATCH_MNT/file
+done
+
+kill -9 $getfattr_pid > /dev/null 2>&1
+wait > /dev/null 2>&1
+
+echo Silence is golden
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/402.out b/tests/generic/402.out
new file mode 100644
index 0000000..28e1501
--- /dev/null
+++ b/tests/generic/402.out
@@ -0,0 +1,2 @@
+QA output created by 402
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 64dae2b..eb11c0f 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -404,3 +404,4 @@
 399 auto encrypt
 400 auto quick quota
 401 auto quick
+402 auto quick attr
-- 
2.7.4

