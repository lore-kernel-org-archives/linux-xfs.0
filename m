Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51902 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754012AbeFUScs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 14:32:48 -0400
Subject: [PATCH 2/4] xfs: regression test for rmapbt fdblocks accounting
 problems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jun 2018 11:32:42 -0700
Message-ID: <152960596196.26479.13083497192197135552.stgit@magnolia>
In-Reply-To: <152960594943.26479.1457883867468749220.stgit@magnolia>
References: <152960594943.26479.1457883867468749220.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In "xfs: fix fdblocks accounting w/ RMAPBT per-AG reservation", we fixed
the per-ag reservation code so that we always decrease fdblocks by the
reserved size because rmapbt blocks are counted as free space.

The primary symptom of this bug is that if the rmapbt has expanded since
mount time, the disk block counters reported via statfs will change
across a remount.  Therefore, we exercise this as a regression test.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/712     |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/712.out |    1 +
 tests/xfs/group   |    1 +
 3 files changed, 64 insertions(+)
 create mode 100755 tests/xfs/712
 create mode 100644 tests/xfs/712.out


diff --git a/tests/xfs/712 b/tests/xfs/712
new file mode 100755
index 00000000..f90c7ec9
--- /dev/null
+++ b/tests/xfs/712
@@ -0,0 +1,62 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 712
+#
+# Make sure that the statfs b_avail counter doesn't change across remount
+# after the rmapbt has grown in size.
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
+. ./common/filter
+
+# remove previous \$seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_test_program "punch-alternating"
+_require_xfs_scratch_rmapbt
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+# Make sure we allocate a big enough file such that punching out every other
+# block will cause the rmapbt to expand by at least one block.
+blksz=$(_get_file_block_size $SCRATCH_MNT)
+nr_rmap_per_rmapbt=$(( (blksz - 56) / 24))
+blks=$(( (nr_rmap_per_rmapbt + 2) * 2))
+$XFS_IO_PROG -f -c "falloc 0 $((blks * blksz))" $SCRATCH_MNT/a >> $seqres.full
+./src/punch-alternating $SCRATCH_MNT/a
+
+# Do the stat counters change across the remount?
+before=$(stat -f -c '%b %f' $SCRATCH_MNT)
+_scratch_cycle_mount
+after=$(stat -f -c '%b %f' $SCRATCH_MNT)
+
+if [ "${before}" != "${after}" ]; then
+	echo "counters changed: ${before} ${after}"
+	echo "before: ${before}" >> $seqres.full
+	echo "after: ${after}" >> $seqres.full
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/712.out b/tests/xfs/712.out
new file mode 100644
index 00000000..4e900419
--- /dev/null
+++ b/tests/xfs/712.out
@@ -0,0 +1 @@
+QA output created by 712
diff --git a/tests/xfs/group b/tests/xfs/group
index 932ab909..2f1c8467 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -447,3 +447,4 @@
 447 auto mount
 448 auto quick fuzzers
 449 auto quick
+712 auto quick rmap

