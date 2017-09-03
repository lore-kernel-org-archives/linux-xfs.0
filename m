Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34546 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752878AbdICPH0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 11:07:26 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH] fstests: regression test for xfs leftover CoW extent error
Date: Sun,  3 Sep 2017 18:07:51 +0300
Message-Id: <1504451271-29202-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Eryu Guan <eguan@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

The following error are reported after the test:

*** xfs_check output ***
leftover CoW extent (0/2147483736) len 1
block 0/2147483736 out of range
blocks 0/2147483736..2147483736 claimed by block 0/6
leftover CoW extent (0/2147483738) len 2
blocks 0/2147483738..2147483739 out of range
blocks 0/2147483738..2147483739 claimed by block 0/6
leftover CoW extent (0/2147483741) len 3
blocks 0/2147483741..2147483743 out of range
blocks 0/2147483741..2147483743 claimed by block 0/6
block 0/88 type unknown not expected
block 0/90 type unknown not expected
block 0/91 type unknown not expected
block 0/93 type unknown not expected
block 0/94 type unknown not expected
block 0/95 type unknown not expected

*** xfs_repair -n output ***
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
leftover CoW extent (0/88) len 1
leftover CoW extent (0/90) len 2
leftover CoW extent (0/93) len 3
        - found root inode chunk

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Christoph,

I started playing with crash tests for xfs reflink
and created a variant of the crash test which clones
files and runs fsx on the clones.

I quickly stumbled on an fsck error that is reproduced
without any crash at all.

The sequence of operations (zero,collapse,insert,truncate)
was recorded by fsx, I only bisected the minimal sequence
to reproduce the error.

When you understand what went on, it would be better to
provide less arbitrary values of offset;length and add
commentary to this test before merging it.

Amir.


 tests/generic/503     | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/503.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 72 insertions(+)
 create mode 100755 tests/generic/503
 create mode 100644 tests/generic/503.out

diff --git a/tests/generic/503 b/tests/generic/503
new file mode 100755
index 0000000..ebda756
--- /dev/null
+++ b/tests/generic/503
@@ -0,0 +1,69 @@
+#! /bin/bash
+# FS QA Test No. 503
+#
+# Regression test for xfs leftover CoW extents error
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2017 CTERA Networks. All Rights Reserved.
+# Author: Amir Goldstein <amir73il@gmail.com>
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
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
+
+rm -f $seqres.full
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+$XFS_IO_PROG -f -c "pwrite 0 0x40000" \
+	$SCRATCH_MNT/foo > /dev/null 2>&1
+
+cp --reflink $SCRATCH_MNT/foo $SCRATCH_MNT/bar
+
+$XFS_IO_PROG -f -c "fzero -k 0x169f 0x387c" \
+		-c "fcollapse 0x29000 0xd000" \
+		-c "finsert 0 0x8000" \
+		-c "truncate 0x8000" \
+	$SCRATCH_MNT/foo > /dev/null 2>&1
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/generic/503.out b/tests/generic/503.out
new file mode 100644
index 0000000..6c1400a
--- /dev/null
+++ b/tests/generic/503.out
@@ -0,0 +1,2 @@
+QA output created by 503
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 4324775..7a9cd78 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -460,3 +460,4 @@
 500 auto log replay
 501 auto quick metadata
 502 auto log replay clone
+503 auto quick clone
-- 
2.7.4

