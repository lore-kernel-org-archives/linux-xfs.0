Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:42450 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753480AbeEVXeQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 May 2018 19:34:16 -0400
Received: by mail-pf0-f179.google.com with SMTP id p14-v6so9509694pfh.9
        for <linux-xfs@vger.kernel.org>; Tue, 22 May 2018 16:34:16 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v3 3/5] generic: add test for dedupe on an active swapfile
Date: Tue, 22 May 2018 16:33:58 -0700
Message-Id: <0f7d8ca0b6f63711eccc51bd2a5aab1aa448e3f6.1527031843.git.osandov@fb.com>
In-Reply-To: <cover.1527031843.git.osandov@fb.com>
References: <cover.1527031843.git.osandov@fb.com>
In-Reply-To: <cover.1527031843.git.osandov@fb.com>
References: <cover.1527031843.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Eryu Guan <guaneryu@gmail.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, kernel-team@fb.com

From: Omar Sandoval <osandov@fb.com>

Similar to the reflink test generic/356, but makes sure we can't dedupe
an active swapfile.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 tests/generic/492     | 76 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/492.out |  7 ++++
 tests/generic/group   |  1 +
 3 files changed, 84 insertions(+)
 create mode 100755 tests/generic/492
 create mode 100644 tests/generic/492.out

diff --git a/tests/generic/492 b/tests/generic/492
new file mode 100755
index 00000000..54a2553d
--- /dev/null
+++ b/tests/generic/492
@@ -0,0 +1,76 @@
+#! /bin/bash
+# FS QA Test 492
+#
+# Check that we can't dedupe a swapfile.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2018 Facebook.  All Rights Reserved.
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
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+rm -f $seqres.full
+
+_supported_fs generic
+_supported_os Linux
+_require_scratch_swapfile
+_require_scratch_dedupe
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+mkdir "$testdir"
+
+blocks=160
+blksz=65536
+
+echo "Initialize file"
+_format_swapfile "$testdir/file1" $((blocks * blksz))
+swapon "$testdir/file1"
+
+touch "$testdir/file2"
+$CHATTR_PROG +C "$testdir/file2" >/dev/null 2>&1
+
+echo "Try to dedupe"
+cp "$testdir/file1" "$testdir/file2"
+_dedupe_range "$testdir/file1" 0 "$testdir/file2" 0 $((blocks * blksz))
+_dedupe_range "$testdir/file2" 0 "$testdir/file1" 0 $((blocks * blksz))
+
+echo "Tear it down"
+swapoff "$testdir/file1"
+
+status=0
+exit
diff --git a/tests/generic/492.out b/tests/generic/492.out
new file mode 100644
index 00000000..e1f3cc69
--- /dev/null
+++ b/tests/generic/492.out
@@ -0,0 +1,7 @@
+QA output created by 492
+Format and mount
+Initialize file
+Try to dedupe
+XFS_IOC_FILE_EXTENT_SAME: Text file busy
+XFS_IOC_FILE_EXTENT_SAME: Text file busy
+Tear it down
diff --git a/tests/generic/group b/tests/generic/group
index 111e42e7..dc5adf04 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -494,3 +494,4 @@
 489 auto quick attr
 490 auto quick rw
 491 auto quick freeze mount
+492 auto quick swap
-- 
2.17.0

