Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43406 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbeJaC6O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Oct 2018 22:58:14 -0400
Subject: [PATCH 2/3] xfs: test repair regression of dir w/ single leafn block
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 30 Oct 2018 11:03:35 -0700
Message-ID: <154092261507.14882.18255990570055324009.stgit@magnolia>
In-Reply-To: <154092260885.14882.10714249211090490549.stgit@magnolia>
References: <154092260885.14882.10714249211090490549.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/1421     |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1421.out |    7 +++++
 tests/xfs/group    |    1 +
 3 files changed, 78 insertions(+)
 create mode 100644 tests/xfs/1421
 create mode 100644 tests/xfs/1421.out


diff --git a/tests/xfs/1421 b/tests/xfs/1421
new file mode 100644
index 00000000..a63705bb
--- /dev/null
+++ b/tests/xfs/1421
@@ -0,0 +1,70 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 1421
+#
+# Test for two related regressions -- first, check that repair doesn't
+# repeatedly rebuild directories with a single leafn block; and check that
+# repair also doesn't crash when it hits a corrupt da btree with a zero before
+# pointer.
+#
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
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+filter_nbrepair() {
+	grep rebuilding | sed -e 's/directory inode [0-9]*/directory inode XXX/g'
+}
+
+run_repair() {
+	_scratch_xfs_repair > $tmp.repair 2>&1
+	cat $tmp.repair >> $seqres.full
+	cat $tmp.repair | filter_nbrepair
+}
+
+echo "Check leafn rebuilds"
+run_repair
+run_repair
+
+echo "Fuzz nbtree[0].before to zero"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_NODE)
+blk_sz=$(_get_block_size $SCRATCH_MNT)
+_scratch_unmount
+leaf_offset=$(( (2 ** 35) / blk_sz ))
+_scratch_xfs_fuzz_metadata_field "nbtree[0].before" "zeroes" "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+
+echo "Check nbtree[0].before repair"
+run_repair
+run_repair
+
+# success, all done
+echo Done
+status=0
+exit
diff --git a/tests/xfs/1421.out b/tests/xfs/1421.out
new file mode 100644
index 00000000..69711ab0
--- /dev/null
+++ b/tests/xfs/1421.out
@@ -0,0 +1,7 @@
+QA output created by 1421
+Format and populate
+Check leafn rebuilds
+Fuzz nbtree[0].before to zero
+Check nbtree[0].before repair
+rebuilding directory inode XXX
+Done
diff --git a/tests/xfs/group b/tests/xfs/group
index de66378f..4b0552b9 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -492,3 +492,4 @@
 492 auto quick fuzz
 493 auto quick fuzz
 734 auto quick
+1421 auto quick repair
