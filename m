Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56252 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbeJEHPb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 03:15:31 -0400
Subject: [PATCH 2/6] xfs: test mount time summary counter check and fix
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 04 Oct 2018 17:19:20 -0700
Message-ID: <153869876040.26648.11302951509500617148.stgit@magnolia>
In-Reply-To: <153869874763.26648.516233620615833277.stgit@magnolia>
References: <153869874763.26648.516233620615833277.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Tests to ensure that the xfs mount code can detect obviously bad fs
summary counters at mount time and fix them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/722     |   58 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/722.out |    4 +++
 tests/xfs/723     |   58 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/723.out |    4 +++
 tests/xfs/724     |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/724.out |    4 +++
 tests/xfs/group   |    3 ++
 7 files changed, 197 insertions(+)
 create mode 100755 tests/xfs/722
 create mode 100644 tests/xfs/722.out
 create mode 100755 tests/xfs/723
 create mode 100644 tests/xfs/723.out
 create mode 100755 tests/xfs/724
 create mode 100644 tests/xfs/724.out


diff --git a/tests/xfs/722 b/tests/xfs/722
new file mode 100755
index 00000000..1012bd58
--- /dev/null
+++ b/tests/xfs/722
@@ -0,0 +1,58 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle.  All Rights Reserved.
+#
+# FS QA Test 722
+#
+# Test detection & fixing of bad summary block counts at mount time.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap '_cleanup; exit $status' 0 1 2 3 15
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
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+echo "test file" > $SCRATCH_MNT/testfile
+
+echo "Fuzz fdblocks"
+_scratch_unmount
+dblocks=$(_scratch_xfs_get_metadata_field dblocks 'sb 0')
+_scratch_xfs_set_metadata_field fdblocks $((dblocks * 2)) 'sb 0' > $seqres.full 2>&1
+
+echo "Detection and Correction"
+_scratch_mount >> $seqres.full 2>&1
+avail=$(stat -c '%a' -f $SCRATCH_MNT)
+total=$(stat -c '%b' -f $SCRATCH_MNT)
+echo "avail: $avail" >> $seqres.full
+echo "total: $total" >> $seqres.full
+test "$avail" -gt "$total" && echo "free space bad: $avail > $total"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/722.out b/tests/xfs/722.out
new file mode 100644
index 00000000..8d1327b7
--- /dev/null
+++ b/tests/xfs/722.out
@@ -0,0 +1,4 @@
+QA output created by 722
+Format and mount
+Fuzz fdblocks
+Detection and Correction
diff --git a/tests/xfs/723 b/tests/xfs/723
new file mode 100755
index 00000000..c068e496
--- /dev/null
+++ b/tests/xfs/723
@@ -0,0 +1,58 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle.  All Rights Reserved.
+#
+# FS QA Test 723
+#
+# Test detection & fixing of bad summary inode counts at mount time.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap '_cleanup; exit $status' 0 1 2 3 15
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
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+echo "test file" > $SCRATCH_MNT/testfile
+
+echo "Fuzz ifree"
+_scratch_unmount
+icount=$(_scratch_xfs_get_metadata_field icount 'sb 0')
+_scratch_xfs_set_metadata_field ifree $((icount * 2)) 'sb 0' > $seqres.full 2>&1
+
+echo "Detection and Correction"
+_scratch_mount >> $seqres.full 2>&1
+avail=$(stat -c '%d' -f $SCRATCH_MNT)
+total=$(stat -c '%c' -f $SCRATCH_MNT)
+echo "avail: $avail" >> $seqres.full
+echo "total: $total" >> $seqres.full
+test "$avail" -gt "$total" && echo "free inodes bad: $avail > $total"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/723.out b/tests/xfs/723.out
new file mode 100644
index 00000000..e825855a
--- /dev/null
+++ b/tests/xfs/723.out
@@ -0,0 +1,4 @@
+QA output created by 723
+Format and mount
+Fuzz ifree
+Detection and Correction
diff --git a/tests/xfs/724 b/tests/xfs/724
new file mode 100755
index 00000000..f5e44fb6
--- /dev/null
+++ b/tests/xfs/724
@@ -0,0 +1,66 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle.  All Rights Reserved.
+#
+# FS QA Test 724
+#
+# Test detection & fixing of bad summary block counts at mount time.
+# Corrupt the AGFs to test mount failure when mount-fixing fails.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap '_cleanup; exit $status' 0 1 2 3 15
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
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_scratch_nocheck
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+echo "test file" > $SCRATCH_MNT/testfile
+
+echo "Fuzz fdblocks and btreeblks"
+_scratch_unmount
+dblocks=$(_scratch_xfs_get_metadata_field dblocks 'sb 0')
+_scratch_xfs_set_metadata_field fdblocks $((dblocks * 2)) 'sb 0' > $seqres.full 2>&1
+
+aglen=$(_scratch_xfs_get_metadata_field length 'agf 0')
+_scratch_xfs_set_metadata_field btreeblks $aglen 'agf 0' > $seqres.full 2>&1
+
+echo "Detection and Correction"
+if _try_scratch_mount >> $seqres.full 2>&1; then
+	echo "mount should have failed"
+	avail=$(stat -c '%a' -f $SCRATCH_MNT)
+	total=$(stat -c '%b' -f $SCRATCH_MNT)
+	echo "avail: $avail" >> $seqres.full
+	echo "total: $total" >> $seqres.full
+	test "$avail" -gt "$total" && echo "free space bad: $avail > $total"
+	_scratch_unmount
+fi
+_scratch_xfs_repair -n >> $seqres.full 2>&1 && echo "repair didn't find fuzz?"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/724.out b/tests/xfs/724.out
new file mode 100644
index 00000000..6571f9ed
--- /dev/null
+++ b/tests/xfs/724.out
@@ -0,0 +1,4 @@
+QA output created by 724
+Format and mount
+Fuzz fdblocks and btreeblks
+Detection and Correction
diff --git a/tests/xfs/group b/tests/xfs/group
index 821bf2ac..28074f07 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -488,3 +488,6 @@
 488 dangerous_fuzzers dangerous_norepair
 489 dangerous_fuzzers dangerous_norepair
 490 auto quick
+722 auto quick fuzz
+723 auto quick fuzz
+724 auto quick fuzz
