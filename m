Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44307 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752026AbdFUV6b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2017 17:58:31 -0400
Subject: [PATCH 8/8] xfs: scrub while appending to a file
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 21 Jun 2017 14:58:22 -0700
Message-ID: <149808230214.8924.10706838164588131554.stgit@birch.djwong.org>
In-Reply-To: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
References: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

It turns out that there was a bug in xfs_bmap_count_blocks wherein the
block count returned would count or not count delalloc blocks depending
on the fork format.  This is a bug that is easily exposed via scrub, so
check the output of that function here -- the buggy version of the
function produces online fsck errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/1379     |   82 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1379.out |    6 ++++
 tests/xfs/group    |    1 +
 3 files changed, 89 insertions(+)
 create mode 100755 tests/xfs/1379
 create mode 100644 tests/xfs/1379.out


diff --git a/tests/xfs/1379 b/tests/xfs/1379
new file mode 100755
index 0000000..acb797e
--- /dev/null
+++ b/tests/xfs/1379
@@ -0,0 +1,82 @@
+#! /bin/bash
+# FS QA Test No. 1379
+#
+# Race scrubbing the inode record while appending to a file.
+# This exposes a bug in xfs_bmap_count_blocks where we count delalloc
+# extents for di_nblocks if the fork is in extents format, but we don't
+# count them if the fork is in btree format.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Oracle, Inc.  All Rights Reserved.
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
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1335  USA
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
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_test_program "punch-alternating"
+_require_xfs_io_command "scrub"
+_require_scratch
+
+echo "Format and populate"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+$XFS_IO_PROG -f -c 'falloc 0 10m' $SCRATCH_MNT/a >> $seqres.full
+$XFS_IO_PROG -f -c 'falloc 0 10m' $SCRATCH_MNT/b >> $seqres.full
+./src/punch-alternating $SCRATCH_MNT/b
+sync
+
+echo "Set up delalloc extents"
+$XFS_IO_PROG -c 'pwrite -S 0x66 10m 128k' $SCRATCH_MNT/a >> $seqres.full
+$XFS_IO_PROG -c 'pwrite -S 0x66 10m 128k' $SCRATCH_MNT/b >> $seqres.full
+$XFS_IO_PROG -c 'bmap -ev' $SCRATCH_MNT/a $SCRATCH_MNT/b > $SCRATCH_MNT/before
+cat $SCRATCH_MNT/before >> $seqres.full
+
+echo "Scrub a and b"
+$XFS_IO_PROG -x -c 'scrub inode' $SCRATCH_MNT/a >> $seqres.full
+$XFS_IO_PROG -x -c 'scrub inode' $SCRATCH_MNT/b >> $seqres.full
+$XFS_IO_PROG -c 'bmap -ev' $SCRATCH_MNT/a $SCRATCH_MNT/b > $SCRATCH_MNT/after
+cat $SCRATCH_MNT/after >> $seqres.full
+
+echo "Compare extent maps"
+diff -u $SCRATCH_MNT/before $SCRATCH_MNT/after
+
+echo "Test done"
+status=0
+exit
diff --git a/tests/xfs/1379.out b/tests/xfs/1379.out
new file mode 100644
index 0000000..67ad05f
--- /dev/null
+++ b/tests/xfs/1379.out
@@ -0,0 +1,6 @@
+QA output created by 1379
+Format and populate
+Set up delalloc extents
+Scrub a and b
+Compare extent maps
+Test done
diff --git a/tests/xfs/group b/tests/xfs/group
index d0a6831..dd10df3 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -420,3 +420,4 @@
 901 auto quick clone dedupe
 902 auto quick clone dedupe
 1378 dangerous_scrub dangerous_online_repair
+1379 dangerous_scrub

