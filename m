Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36084 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbeJaC6P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Oct 2018 22:58:15 -0400
Subject: [PATCH 3/3] xfs: fuzz directories containing single leafn blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 30 Oct 2018 11:03:41 -0700
Message-ID: <154092262132.14882.9439371379100909096.stgit@magnolia>
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

Test scrub, repair, and metadata verifiers on directories containing
fuzzed single-leafn blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/1422     |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1422.out |    5 +++++
 tests/xfs/1423     |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1423.out |    5 +++++
 tests/xfs/1424     |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1424.out |    5 +++++
 tests/xfs/group    |    3 +++
 7 files changed, 174 insertions(+)
 create mode 100755 tests/xfs/1422
 create mode 100644 tests/xfs/1422.out
 create mode 100755 tests/xfs/1423
 create mode 100644 tests/xfs/1423.out
 create mode 100755 tests/xfs/1424
 create mode 100644 tests/xfs/1424.out


diff --git a/tests/xfs/1422 b/tests/xfs/1422
new file mode 100755
index 00000000..cd2cbc2a
--- /dev/null
+++ b/tests/xfs/1422
@@ -0,0 +1,52 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 1422
+#
+# Populate a XFS filesystem and fuzz every single-leafn-format dir block field.
+# Use xfs_repair to fix the corruption.
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
+echo "Find single-leafn-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_LEAFN)
+blk_sz=$(_get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+leaf_offset=$(( (2 ** 35) / blk_sz ))
+echo "Fuzz single-leafn-format dir block"
+_scratch_xfs_fuzz_metadata '' 'offline'  "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+echo "Done fuzzing single-leafn-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1422.out b/tests/xfs/1422.out
new file mode 100644
index 00000000..76cb50a5
--- /dev/null
+++ b/tests/xfs/1422.out
@@ -0,0 +1,5 @@
+QA output created by 1422
+Format and populate
+Find single-leafn-format dir block
+Fuzz single-leafn-format dir block
+Done fuzzing single-leafn-format dir block
diff --git a/tests/xfs/1423 b/tests/xfs/1423
new file mode 100755
index 00000000..3220264f
--- /dev/null
+++ b/tests/xfs/1423
@@ -0,0 +1,52 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 1423
+#
+# Populate a XFS filesystem and fuzz every single-leafn-format dir block field.
+# Use xfs_scrub to fix the corruption.
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
+echo "Find single-leafn-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_LEAFN)
+blk_sz=$(_get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+leaf_offset=$(( (2 ** 35) / blk_sz ))
+echo "Fuzz single-leafn-format dir block"
+_scratch_xfs_fuzz_metadata '' 'online'  "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+echo "Done fuzzing single-leafn-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1423.out b/tests/xfs/1423.out
new file mode 100644
index 00000000..bca6d99d
--- /dev/null
+++ b/tests/xfs/1423.out
@@ -0,0 +1,5 @@
+QA output created by 1423
+Format and populate
+Find single-leafn-format dir block
+Fuzz single-leafn-format dir block
+Done fuzzing single-leafn-format dir block
diff --git a/tests/xfs/1424 b/tests/xfs/1424
new file mode 100755
index 00000000..c8666f5d
--- /dev/null
+++ b/tests/xfs/1424
@@ -0,0 +1,52 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 1424
+#
+# Populate a XFS filesystem and fuzz every single-leafn-format dir block field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Find single-leafn-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_LEAFN)
+blk_sz=$(_get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+leaf_offset=$(( (2 ** 35) / blk_sz ))
+echo "Fuzz single-leafn-format dir block"
+_scratch_xfs_fuzz_metadata '' 'none'  "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+echo "Done fuzzing single-leafn-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1424.out b/tests/xfs/1424.out
new file mode 100644
index 00000000..50d09f48
--- /dev/null
+++ b/tests/xfs/1424.out
@@ -0,0 +1,5 @@
+QA output created by 1424
+Format and populate
+Find single-leafn-format dir block
+Fuzz single-leafn-format dir block
+Done fuzzing single-leafn-format dir block
diff --git a/tests/xfs/group b/tests/xfs/group
index 4b0552b9..b3afe31a 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -493,3 +493,6 @@
 493 auto quick fuzz
 734 auto quick
 1421 auto quick repair
+1422 dangerous_fuzzers dangerous_scrub dangerous_repair
+1423 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1424 dangerous_fuzzers dangerous_norepair
