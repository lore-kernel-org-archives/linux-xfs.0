Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:37736 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751273AbeEPUi7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 16:38:59 -0400
Received: by mail-pg0-f46.google.com with SMTP id a13-v6so787411pgu.4
        for <linux-xfs@vger.kernel.org>; Wed, 16 May 2018 13:38:58 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 3/5] generic: add test for dedupe on an active swapfile
Date: Wed, 16 May 2018 13:38:47 -0700
Message-Id: <a0b71ac1816cc6dd80f3ace9e406a72137623db2.1526503000.git.osandov@fb.com>
In-Reply-To: <cover.1526503000.git.osandov@fb.com>
References: <cover.1526503000.git.osandov@fb.com>
In-Reply-To: <cover.1526503000.git.osandov@fb.com>
References: <cover.1526503000.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Eryu Guan <guaneryu@gmail.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, kernel-team@fb.com

From: Omar Sandoval <osandov@fb.com>

Similar to generic/356 that makes sure we can't reflink an active
swapfile.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 tests/generic/488     | 76 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/488.out |  7 ++++
 tests/generic/group   |  1 +
 3 files changed, 84 insertions(+)
 create mode 100755 tests/generic/488
 create mode 100644 tests/generic/488.out

diff --git a/tests/generic/488 b/tests/generic/488
new file mode 100755
index 00000000..39fc887c
--- /dev/null
+++ b/tests/generic/488
@@ -0,0 +1,76 @@
+#! /bin/bash
+# FS QA Test 488
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
diff --git a/tests/generic/488.out b/tests/generic/488.out
new file mode 100644
index 00000000..e5a195d1
--- /dev/null
+++ b/tests/generic/488.out
@@ -0,0 +1,7 @@
+QA output created by 488
+Format and mount
+Initialize file
+Try to dedupe
+XFS_IOC_FILE_EXTENT_SAME: Text file busy
+XFS_IOC_FILE_EXTENT_SAME: Text file busy
+Tear it down
diff --git a/tests/generic/group b/tests/generic/group
index cded10f8..1f504ce1 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -490,3 +490,4 @@
 485 auto quick insert
 486 auto quick attr
 487 auto quick
+488 auto quick swap
-- 
2.17.0

