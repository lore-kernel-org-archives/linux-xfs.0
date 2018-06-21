Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52152 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754012AbeFUSdB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 14:33:01 -0400
Subject: [PATCH 4/4] xfs: fuzz every field of every structure and test
 kernel crashes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jun 2018 11:32:55 -0700
Message-ID: <152960597579.26479.1694478608504574104.stgit@magnolia>
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

Fuzz every field of every structure and then try to write the
filesystem, to see how many of these writes can crash the kernel.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/fuzzy       |   42 ++++++++++++++++++++++++------------------
 tests/xfs/1387     |   45 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1387.out |    4 ++++
 tests/xfs/1388     |   45 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1388.out |    4 ++++
 tests/xfs/1389     |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1389.out |    6 ++++++
 tests/xfs/1390     |   45 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1390.out |    4 ++++
 tests/xfs/1391     |   45 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1391.out |    4 ++++
 tests/xfs/1392     |   45 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1392.out |    4 ++++
 tests/xfs/1393     |   45 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1393.out |    4 ++++
 tests/xfs/1394     |   45 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1394.out |    4 ++++
 tests/xfs/1395     |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1395.out |    4 ++++
 tests/xfs/1396     |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1396.out |    4 ++++
 tests/xfs/1397     |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1397.out |    4 ++++
 tests/xfs/1398     |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1398.out |    4 ++++
 tests/xfs/1399     |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1399.out |    5 +++++
 tests/xfs/1400     |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1400.out |    5 +++++
 tests/xfs/1401     |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1401.out |    5 +++++
 tests/xfs/1402     |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1402.out |    5 +++++
 tests/xfs/1403     |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1403.out |    5 +++++
 tests/xfs/1404     |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1404.out |    5 +++++
 tests/xfs/1405     |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1405.out |    5 +++++
 tests/xfs/1406     |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1406.out |    5 +++++
 tests/xfs/1407     |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1407.out |    5 +++++
 tests/xfs/1408     |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1408.out |    5 +++++
 tests/xfs/1409     |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1409.out |    5 +++++
 tests/xfs/1410     |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1410.out |    5 +++++
 tests/xfs/1411     |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1411.out |    5 +++++
 tests/xfs/1412     |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1412.out |    5 +++++
 tests/xfs/1413     |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1413.out |    5 +++++
 tests/xfs/1414     |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1414.out |    5 +++++
 tests/xfs/1415     |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1415.out |    4 ++++
 tests/xfs/1416     |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1416.out |    4 ++++
 tests/xfs/1417     |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1417.out |    4 ++++
 tests/xfs/1418     |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1418.out |    5 +++++
 tests/xfs/1419     |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1419.out |    5 +++++
 tests/xfs/1420     |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1420.out |    5 +++++
 tests/xfs/1421     |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1421.out |    4 ++++
 tests/xfs/1422     |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1422.out |    4 ++++
 tests/xfs/1423     |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1423.out |    4 ++++
 tests/xfs/group    |   37 +++++++++++++++++++++++++++++++++++++
 76 files changed, 2028 insertions(+), 18 deletions(-)
 create mode 100755 tests/xfs/1387
 create mode 100644 tests/xfs/1387.out
 create mode 100755 tests/xfs/1388
 create mode 100644 tests/xfs/1388.out
 create mode 100755 tests/xfs/1389
 create mode 100644 tests/xfs/1389.out
 create mode 100755 tests/xfs/1390
 create mode 100644 tests/xfs/1390.out
 create mode 100755 tests/xfs/1391
 create mode 100644 tests/xfs/1391.out
 create mode 100755 tests/xfs/1392
 create mode 100644 tests/xfs/1392.out
 create mode 100755 tests/xfs/1393
 create mode 100644 tests/xfs/1393.out
 create mode 100755 tests/xfs/1394
 create mode 100644 tests/xfs/1394.out
 create mode 100755 tests/xfs/1395
 create mode 100644 tests/xfs/1395.out
 create mode 100755 tests/xfs/1396
 create mode 100644 tests/xfs/1396.out
 create mode 100755 tests/xfs/1397
 create mode 100644 tests/xfs/1397.out
 create mode 100755 tests/xfs/1398
 create mode 100644 tests/xfs/1398.out
 create mode 100755 tests/xfs/1399
 create mode 100644 tests/xfs/1399.out
 create mode 100755 tests/xfs/1400
 create mode 100644 tests/xfs/1400.out
 create mode 100755 tests/xfs/1401
 create mode 100644 tests/xfs/1401.out
 create mode 100755 tests/xfs/1402
 create mode 100644 tests/xfs/1402.out
 create mode 100755 tests/xfs/1403
 create mode 100644 tests/xfs/1403.out
 create mode 100755 tests/xfs/1404
 create mode 100644 tests/xfs/1404.out
 create mode 100755 tests/xfs/1405
 create mode 100644 tests/xfs/1405.out
 create mode 100755 tests/xfs/1406
 create mode 100644 tests/xfs/1406.out
 create mode 100755 tests/xfs/1407
 create mode 100644 tests/xfs/1407.out
 create mode 100755 tests/xfs/1408
 create mode 100644 tests/xfs/1408.out
 create mode 100755 tests/xfs/1409
 create mode 100644 tests/xfs/1409.out
 create mode 100755 tests/xfs/1410
 create mode 100644 tests/xfs/1410.out
 create mode 100755 tests/xfs/1411
 create mode 100644 tests/xfs/1411.out
 create mode 100755 tests/xfs/1412
 create mode 100644 tests/xfs/1412.out
 create mode 100755 tests/xfs/1413
 create mode 100644 tests/xfs/1413.out
 create mode 100755 tests/xfs/1414
 create mode 100644 tests/xfs/1414.out
 create mode 100755 tests/xfs/1415
 create mode 100644 tests/xfs/1415.out
 create mode 100755 tests/xfs/1416
 create mode 100644 tests/xfs/1416.out
 create mode 100755 tests/xfs/1417
 create mode 100644 tests/xfs/1417.out
 create mode 100755 tests/xfs/1418
 create mode 100644 tests/xfs/1418.out
 create mode 100755 tests/xfs/1419
 create mode 100644 tests/xfs/1419.out
 create mode 100755 tests/xfs/1420
 create mode 100644 tests/xfs/1420.out
 create mode 100755 tests/xfs/1421
 create mode 100644 tests/xfs/1421.out
 create mode 100755 tests/xfs/1422
 create mode 100644 tests/xfs/1422.out
 create mode 100755 tests/xfs/1423
 create mode 100644 tests/xfs/1423.out


diff --git a/common/fuzzy b/common/fuzzy
index 025f2615..5f46d4fb 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -169,7 +169,7 @@ __fuzz_notify() {
 # Fuzz one field of some piece of metadata.
 # First arg is the field name
 # Second arg is the fuzz verb (ones, zeroes, random, add, sub...)
-# Third arg is the repair mode (online, offline, both)
+# Third arg is the repair mode (online, offline, both, none)
 __scratch_xfs_fuzz_field_test() {
 	field="$1"
 	fuzzverb="$2"
@@ -190,12 +190,14 @@ __scratch_xfs_fuzz_field_test() {
 	if [ $res -eq 0 ]; then
 		# Try an online scrub unless we're fuzzing ag 0's sb,
 		# which scrub doesn't know how to fix.
-		echo "++ Online scrub"
-		if [ "$1" != "sb 0" ]; then
-			_scratch_scrub -n -a 1 -e continue 2>&1
-			res=$?
-			test $res -eq 0 && \
-				(>&2 echo "scrub didn't fail with ${field} = ${fuzzverb}.")
+		if [ "${repair}" != "none" ]; then
+			echo "++ Online scrub"
+			if [ "$1" != "sb 0" ]; then
+				_scratch_scrub -n -a 1 -e continue 2>&1
+				res=$?
+				test $res -eq 0 && \
+					(>&2 echo "scrub didn't fail with ${field} = ${fuzzverb}.")
+			fi
 		fi
 
 		# Try fixing the filesystem online?!
@@ -222,11 +224,13 @@ __scratch_xfs_fuzz_field_test() {
 	fi
 
 	# See if repair finds a clean fs
-	echo "+ Make sure error is gone (offline)"
-        _scratch_xfs_repair -n 2>&1
-	res=$?
-	test $res -ne 0 && \
-		(>&2 echo "offline re-scrub ($res) with ${field} = ${fuzzverb}.")
+	if [ "${repair}" != "none" ]; then
+		echo "+ Make sure error is gone (offline)"
+		_scratch_xfs_repair -n 2>&1
+		res=$?
+		test $res -ne 0 && \
+			(>&2 echo "offline re-scrub ($res) with ${field} = ${fuzzverb}.")
+	fi
 
 	# See if scrub finds a clean fs
 	echo "+ Make sure error is gone (online)"
@@ -235,12 +239,14 @@ __scratch_xfs_fuzz_field_test() {
 	if [ $res -eq 0 ]; then
 		# Try an online scrub unless we're fuzzing ag 0's sb,
 		# which scrub doesn't know how to fix.
-		echo "++ Online scrub"
-		if [ "$1" != "sb 0" ]; then
-			_scratch_scrub -n -e continue 2>&1
-			res=$?
-			test $res -ne 0 && \
-				(>&2 echo "online re-scrub ($res) with ${field} = ${fuzzverb}.")
+		if [ "${repair}" != "none" ]; then
+			echo "++ Online scrub"
+			if [ "$1" != "sb 0" ]; then
+				_scratch_scrub -n -e continue 2>&1
+				res=$?
+				test $res -ne 0 && \
+					(>&2 echo "online re-scrub ($res) with ${field} = ${fuzzverb}.")
+			fi
 		fi
 
 		# Try modifying the filesystem again!
diff --git a/tests/xfs/1387 b/tests/xfs/1387
new file mode 100755
index 00000000..6e7c3ec4
--- /dev/null
+++ b/tests/xfs/1387
@@ -0,0 +1,45 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1387
+#
+# Populate a XFS filesystem and fuzz every superblock field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Fuzz superblock"
+_scratch_xfs_fuzz_metadata '' 'none' 'sb 1' >> $seqres.full
+echo "Done fuzzing superblock"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1387.out b/tests/xfs/1387.out
new file mode 100644
index 00000000..67adab71
--- /dev/null
+++ b/tests/xfs/1387.out
@@ -0,0 +1,4 @@
+QA output created by 1387
+Format and populate
+Fuzz superblock
+Done fuzzing superblock
diff --git a/tests/xfs/1388 b/tests/xfs/1388
new file mode 100755
index 00000000..dab00852
--- /dev/null
+++ b/tests/xfs/1388
@@ -0,0 +1,45 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1388
+#
+# Populate a XFS filesystem and fuzz every AGF field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Fuzz AGF"
+_scratch_xfs_fuzz_metadata '' 'none' 'agf 0' >> $seqres.full
+echo "Done fuzzing AGF"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1388.out b/tests/xfs/1388.out
new file mode 100644
index 00000000..5b3b8077
--- /dev/null
+++ b/tests/xfs/1388.out
@@ -0,0 +1,4 @@
+QA output created by 1388
+Format and populate
+Fuzz AGF
+Done fuzzing AGF
diff --git a/tests/xfs/1389 b/tests/xfs/1389
new file mode 100755
index 00000000..2c4c79b1
--- /dev/null
+++ b/tests/xfs/1389
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1389
+#
+# Populate a XFS filesystem and fuzz every AGFL field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Fuzz AGFL"
+_scratch_xfs_fuzz_metadata '' 'none' 'agfl 0' >> $seqres.full
+echo "Done fuzzing AGFL"
+
+echo "Fuzz AGFL flfirst"
+flfirst=$(_scratch_xfs_db -c 'agf 0' -c 'p flfirst' | sed -e 's/flfirst = //g')
+SCRATCH_XFS_LIST_METADATA_FIELDS="bno[${flfirst}]" _scratch_xfs_fuzz_metadata '' 'none' 'agfl 0' >> $seqres.full
+echo "Done fuzzing AGFL flfirst"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1389.out b/tests/xfs/1389.out
new file mode 100644
index 00000000..7f7db14c
--- /dev/null
+++ b/tests/xfs/1389.out
@@ -0,0 +1,6 @@
+QA output created by 1389
+Format and populate
+Fuzz AGFL
+Done fuzzing AGFL
+Fuzz AGFL flfirst
+Done fuzzing AGFL flfirst
diff --git a/tests/xfs/1390 b/tests/xfs/1390
new file mode 100755
index 00000000..2d22d5df
--- /dev/null
+++ b/tests/xfs/1390
@@ -0,0 +1,45 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1390
+#
+# Populate a XFS filesystem and fuzz every AGI field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Fuzz AGI"
+_scratch_xfs_fuzz_metadata '' 'none' 'agi 0' >> $seqres.full
+echo "Done fuzzing AGI"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1390.out b/tests/xfs/1390.out
new file mode 100644
index 00000000..0119f32b
--- /dev/null
+++ b/tests/xfs/1390.out
@@ -0,0 +1,4 @@
+QA output created by 1390
+Format and populate
+Fuzz AGI
+Done fuzzing AGI
diff --git a/tests/xfs/1391 b/tests/xfs/1391
new file mode 100755
index 00000000..8ae90e0c
--- /dev/null
+++ b/tests/xfs/1391
@@ -0,0 +1,45 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1391
+#
+# Populate a XFS filesystem and fuzz every bnobt field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Fuzz bnobt recs"
+_scratch_xfs_fuzz_metadata '' 'none'  'agf 0' 'addr bnoroot' 'addr ptrs[1]' >> $seqres.full
+echo "Done fuzzing bnobt recs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1391.out b/tests/xfs/1391.out
new file mode 100644
index 00000000..382b0902
--- /dev/null
+++ b/tests/xfs/1391.out
@@ -0,0 +1,4 @@
+QA output created by 1391
+Format and populate
+Fuzz bnobt recs
+Done fuzzing bnobt recs
diff --git a/tests/xfs/1392 b/tests/xfs/1392
new file mode 100755
index 00000000..1b3e6fd4
--- /dev/null
+++ b/tests/xfs/1392
@@ -0,0 +1,45 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1392
+#
+# Populate a XFS filesystem and fuzz every bnobt key/pointer.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Fuzz bnobt keyptr"
+_scratch_xfs_fuzz_metadata '' 'none'  'agf 0' 'addr bnoroot' >> $seqres.full
+echo "Done fuzzing bnobt keyptr"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1392.out b/tests/xfs/1392.out
new file mode 100644
index 00000000..e7b9c660
--- /dev/null
+++ b/tests/xfs/1392.out
@@ -0,0 +1,4 @@
+QA output created by 1392
+Format and populate
+Fuzz bnobt keyptr
+Done fuzzing bnobt keyptr
diff --git a/tests/xfs/1393 b/tests/xfs/1393
new file mode 100755
index 00000000..d1f87f0d
--- /dev/null
+++ b/tests/xfs/1393
@@ -0,0 +1,45 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1393
+#
+# Populate a XFS filesystem and fuzz every cntbt field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Fuzz cntbt"
+_scratch_xfs_fuzz_metadata '' 'none'  'agf 0' 'addr cntroot' 'addr ptrs[1]' >> $seqres.full
+echo "Done fuzzing cntbt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1393.out b/tests/xfs/1393.out
new file mode 100644
index 00000000..d63c8ca9
--- /dev/null
+++ b/tests/xfs/1393.out
@@ -0,0 +1,4 @@
+QA output created by 1393
+Format and populate
+Fuzz cntbt
+Done fuzzing cntbt
diff --git a/tests/xfs/1394 b/tests/xfs/1394
new file mode 100755
index 00000000..e95627cd
--- /dev/null
+++ b/tests/xfs/1394
@@ -0,0 +1,45 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1394
+#
+# Populate a XFS filesystem and fuzz every inobt field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Fuzz inobt"
+_scratch_xfs_fuzz_metadata '' 'none'  'agi 1' 'addr root' >> $seqres.full
+echo "Done fuzzing inobt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1394.out b/tests/xfs/1394.out
new file mode 100644
index 00000000..83277856
--- /dev/null
+++ b/tests/xfs/1394.out
@@ -0,0 +1,4 @@
+QA output created by 1394
+Format and populate
+Fuzz inobt
+Done fuzzing inobt
diff --git a/tests/xfs/1395 b/tests/xfs/1395
new file mode 100755
index 00000000..3d828740
--- /dev/null
+++ b/tests/xfs/1395
@@ -0,0 +1,46 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1395
+#
+# Populate a XFS filesystem and fuzz every finobt field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+_require_xfs_finobt
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz finobt"
+_scratch_xfs_fuzz_metadata '' 'none'  'agi 0' 'addr free_root' >> $seqres.full
+echo "Done fuzzing finobt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1395.out b/tests/xfs/1395.out
new file mode 100644
index 00000000..408f894b
--- /dev/null
+++ b/tests/xfs/1395.out
@@ -0,0 +1,4 @@
+QA output created by 1395
+Format and populate
+Fuzz finobt
+Done fuzzing finobt
diff --git a/tests/xfs/1396 b/tests/xfs/1396
new file mode 100755
index 00000000..09504c0a
--- /dev/null
+++ b/tests/xfs/1396
@@ -0,0 +1,46 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1396
+#
+# Populate a XFS filesystem and fuzz every rmapbt field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_xfs_scratch_rmapbt
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz rmapbt recs"
+_scratch_xfs_fuzz_metadata '' 'none' 'agf 0' 'addr rmaproot' 'addr ptrs[1]' >> $seqres.full
+echo "Done fuzzing rmapbt recs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1396.out b/tests/xfs/1396.out
new file mode 100644
index 00000000..ee974659
--- /dev/null
+++ b/tests/xfs/1396.out
@@ -0,0 +1,4 @@
+QA output created by 1396
+Format and populate
+Fuzz rmapbt recs
+Done fuzzing rmapbt recs
diff --git a/tests/xfs/1397 b/tests/xfs/1397
new file mode 100755
index 00000000..23f4cc3e
--- /dev/null
+++ b/tests/xfs/1397
@@ -0,0 +1,46 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1397
+#
+# Populate a XFS filesystem and fuzz every rmapbt key/pointer field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_xfs_scratch_rmapbt
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz rmapbt keyptr"
+_scratch_xfs_fuzz_metadata '' 'none' 'agf 0' 'addr rmaproot' >> $seqres.full
+echo "Done fuzzing rmapbt keyptr"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1397.out b/tests/xfs/1397.out
new file mode 100644
index 00000000..01258bbe
--- /dev/null
+++ b/tests/xfs/1397.out
@@ -0,0 +1,4 @@
+QA output created by 1397
+Format and populate
+Fuzz rmapbt keyptr
+Done fuzzing rmapbt keyptr
diff --git a/tests/xfs/1398 b/tests/xfs/1398
new file mode 100755
index 00000000..fbd9d454
--- /dev/null
+++ b/tests/xfs/1398
@@ -0,0 +1,47 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1398
+#
+# Populate a XFS filesystem and fuzz every refcountbt field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz refcountbt"
+_scratch_xfs_fuzz_metadata '' 'none'  'agf 0' 'addr refcntroot' >> $seqres.full
+echo "Done fuzzing refcountbt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1398.out b/tests/xfs/1398.out
new file mode 100644
index 00000000..ab572804
--- /dev/null
+++ b/tests/xfs/1398.out
@@ -0,0 +1,4 @@
+QA output created by 1398
+Format and populate
+Fuzz refcountbt
+Done fuzzing refcountbt
diff --git a/tests/xfs/1399 b/tests/xfs/1399
new file mode 100755
index 00000000..9c3c7849
--- /dev/null
+++ b/tests/xfs/1399
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1399
+#
+# Populate a XFS filesystem and fuzz every btree-format directory inode field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Find btree-format dir inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_BTREE)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'none'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1399.out b/tests/xfs/1399.out
new file mode 100644
index 00000000..f57a3648
--- /dev/null
+++ b/tests/xfs/1399.out
@@ -0,0 +1,5 @@
+QA output created by 1399
+Format and populate
+Find btree-format dir inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1400 b/tests/xfs/1400
new file mode 100755
index 00000000..99baf6f9
--- /dev/null
+++ b/tests/xfs/1400
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1400
+#
+# Populate a XFS filesystem and fuzz every extents-format file inode field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Find extents-format file inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFREG.FMT_EXTENTS)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'none'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1400.out b/tests/xfs/1400.out
new file mode 100644
index 00000000..5415c8d6
--- /dev/null
+++ b/tests/xfs/1400.out
@@ -0,0 +1,5 @@
+QA output created by 1400
+Format and populate
+Find extents-format file inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1401 b/tests/xfs/1401
new file mode 100755
index 00000000..eea55ae4
--- /dev/null
+++ b/tests/xfs/1401
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1401
+#
+# Populate a XFS filesystem and fuzz every btree-format file inode field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Find btree-format file inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFREG.FMT_BTREE)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'none'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1401.out b/tests/xfs/1401.out
new file mode 100644
index 00000000..6dbf00f0
--- /dev/null
+++ b/tests/xfs/1401.out
@@ -0,0 +1,5 @@
+QA output created by 1401
+Format and populate
+Find btree-format file inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1402 b/tests/xfs/1402
new file mode 100755
index 00000000..53bf64e7
--- /dev/null
+++ b/tests/xfs/1402
@@ -0,0 +1,52 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1402
+#
+# Populate a XFS filesystem and fuzz every bmbt block field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Find bmbt block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFREG.FMT_BTREE)
+_scratch_unmount
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "inode ${inum}")
+
+echo "Fuzz bmbt"
+_scratch_xfs_fuzz_metadata '' 'none'  "inode ${inum}" "addr u${inode_ver}.bmbt.ptrs[1]" >> $seqres.full
+echo "Done fuzzing bmbt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1402.out b/tests/xfs/1402.out
new file mode 100644
index 00000000..78f7424e
--- /dev/null
+++ b/tests/xfs/1402.out
@@ -0,0 +1,5 @@
+QA output created by 1402
+Format and populate
+Find bmbt block
+Fuzz bmbt
+Done fuzzing bmbt
diff --git a/tests/xfs/1403 b/tests/xfs/1403
new file mode 100755
index 00000000..f504cc35
--- /dev/null
+++ b/tests/xfs/1403
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1403
+#
+# Populate a XFS filesystem and fuzz every symlink remote block field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Find symlink remote block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFLNK.FMT_EXTENTS)
+_scratch_unmount
+
+echo "Fuzz symlink remote block"
+_scratch_xfs_fuzz_metadata '' 'none' "inode ${inum}" 'dblock 0' >> $seqres.full
+echo "Done fuzzing symlink remote block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1403.out b/tests/xfs/1403.out
new file mode 100644
index 00000000..3ff10063
--- /dev/null
+++ b/tests/xfs/1403.out
@@ -0,0 +1,5 @@
+QA output created by 1403
+Format and populate
+Find symlink remote block
+Fuzz symlink remote block
+Done fuzzing symlink remote block
diff --git a/tests/xfs/1404 b/tests/xfs/1404
new file mode 100755
index 00000000..e3b1978b
--- /dev/null
+++ b/tests/xfs/1404
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1404
+#
+# Populate a XFS filesystem and fuzz every inline directory inode field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Find inline-format dir inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_INLINE)
+_scratch_unmount
+
+echo "Fuzz inline-format dir inode"
+_scratch_xfs_fuzz_metadata '' 'none'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inline-format dir inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1404.out b/tests/xfs/1404.out
new file mode 100644
index 00000000..106ff63e
--- /dev/null
+++ b/tests/xfs/1404.out
@@ -0,0 +1,5 @@
+QA output created by 1404
+Format and populate
+Find inline-format dir inode
+Fuzz inline-format dir inode
+Done fuzzing inline-format dir inode
diff --git a/tests/xfs/1405 b/tests/xfs/1405
new file mode 100755
index 00000000..7d6dbbdb
--- /dev/null
+++ b/tests/xfs/1405
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1405
+#
+# Populate a XFS filesystem and fuzz every block-format dir block field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Find data-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_BLOCK)
+_scratch_unmount
+
+echo "Fuzz data-format dir block"
+_scratch_xfs_fuzz_metadata '' 'none'  "inode ${inum}" 'dblock 0' >> $seqres.full
+echo "Done fuzzing data-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1405.out b/tests/xfs/1405.out
new file mode 100644
index 00000000..3f194d24
--- /dev/null
+++ b/tests/xfs/1405.out
@@ -0,0 +1,5 @@
+QA output created by 1405
+Format and populate
+Find data-format dir block
+Fuzz data-format dir block
+Done fuzzing data-format dir block
diff --git a/tests/xfs/1406 b/tests/xfs/1406
new file mode 100755
index 00000000..f5df8f65
--- /dev/null
+++ b/tests/xfs/1406
@@ -0,0 +1,51 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1406
+#
+# Populate a XFS filesystem and fuzz every data-format dir block field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Find data-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_LEAF)
+blk_sz=$(_get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+echo "Fuzz data-format dir block"
+_scratch_xfs_fuzz_metadata '' 'none'  "inode ${inum}" "dblock 0" >> $seqres.full
+echo "Done fuzzing data-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1406.out b/tests/xfs/1406.out
new file mode 100644
index 00000000..32e8749f
--- /dev/null
+++ b/tests/xfs/1406.out
@@ -0,0 +1,5 @@
+QA output created by 1406
+Format and populate
+Find data-format dir block
+Fuzz data-format dir block
+Done fuzzing data-format dir block
diff --git a/tests/xfs/1407 b/tests/xfs/1407
new file mode 100755
index 00000000..d9ba2bef
--- /dev/null
+++ b/tests/xfs/1407
@@ -0,0 +1,52 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1407
+#
+# Populate a XFS filesystem and fuzz every leaf1-format dir block field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Find leaf1-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_LEAF)
+blk_sz=$(_get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+leaf_offset=$(( (2 ** 35) / blk_sz))
+echo "Fuzz leaf1-format dir block"
+_scratch_xfs_fuzz_metadata '' 'none'  "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+echo "Done fuzzing leaf1-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1407.out b/tests/xfs/1407.out
new file mode 100644
index 00000000..f9b8c3e1
--- /dev/null
+++ b/tests/xfs/1407.out
@@ -0,0 +1,5 @@
+QA output created by 1407
+Format and populate
+Find leaf1-format dir block
+Fuzz leaf1-format dir block
+Done fuzzing leaf1-format dir block
diff --git a/tests/xfs/1408 b/tests/xfs/1408
new file mode 100755
index 00000000..609080ce
--- /dev/null
+++ b/tests/xfs/1408
@@ -0,0 +1,52 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1408
+#
+# Populate a XFS filesystem and fuzz every leafn-format dir block field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Find leafn-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_NODE)
+blk_sz=$(_get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+leaf_offset=$(( ( (2 ** 35) / blk_sz) + 1))
+echo "Fuzz leafn-format dir block"
+_scratch_xfs_fuzz_metadata '' 'none'  "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+echo "Done fuzzing leafn-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1408.out b/tests/xfs/1408.out
new file mode 100644
index 00000000..b404dd87
--- /dev/null
+++ b/tests/xfs/1408.out
@@ -0,0 +1,5 @@
+QA output created by 1408
+Format and populate
+Find leafn-format dir block
+Fuzz leafn-format dir block
+Done fuzzing leafn-format dir block
diff --git a/tests/xfs/1409 b/tests/xfs/1409
new file mode 100755
index 00000000..5af0f572
--- /dev/null
+++ b/tests/xfs/1409
@@ -0,0 +1,52 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1409
+#
+# Populate a XFS filesystem and fuzz every node-format dir block field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Find node-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_NODE)
+blk_sz=$(_get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+leaf_offset=$(( (2 ** 35) / blk_sz ))
+echo "Fuzz node-format dir block"
+_scratch_xfs_fuzz_metadata '' 'none'  "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+echo "Done fuzzing node-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1409.out b/tests/xfs/1409.out
new file mode 100644
index 00000000..e0b5ae0b
--- /dev/null
+++ b/tests/xfs/1409.out
@@ -0,0 +1,5 @@
+QA output created by 1409
+Format and populate
+Find node-format dir block
+Fuzz node-format dir block
+Done fuzzing node-format dir block
diff --git a/tests/xfs/1410 b/tests/xfs/1410
new file mode 100755
index 00000000..b98ca791
--- /dev/null
+++ b/tests/xfs/1410
@@ -0,0 +1,52 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1410
+#
+# Populate a XFS filesystem and fuzz every freeindex-format dir block field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Find freeindex-format dir block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_NODE)
+blk_sz=$(_get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+leaf_offset=$(( (2 ** 36) / blk_sz ))
+echo "Fuzz freeindex-format dir block"
+_scratch_xfs_fuzz_metadata '' 'none'  "inode ${inum}" "dblock ${leaf_offset}" >> $seqres.full
+echo "Done fuzzing freeindex-format dir block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1410.out b/tests/xfs/1410.out
new file mode 100644
index 00000000..0e60d89d
--- /dev/null
+++ b/tests/xfs/1410.out
@@ -0,0 +1,5 @@
+QA output created by 1410
+Format and populate
+Find freeindex-format dir block
+Fuzz freeindex-format dir block
+Done fuzzing freeindex-format dir block
diff --git a/tests/xfs/1411 b/tests/xfs/1411
new file mode 100755
index 00000000..8f6de99a
--- /dev/null
+++ b/tests/xfs/1411
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1411
+#
+# Populate a XFS filesystem and fuzz every inline attr inode field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Find inline-format attr inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_LOCAL)
+_scratch_unmount
+
+echo "Fuzz inline-format attr inode"
+_scratch_xfs_fuzz_metadata '' 'none'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inline-format attr inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1411.out b/tests/xfs/1411.out
new file mode 100644
index 00000000..16cfbfa6
--- /dev/null
+++ b/tests/xfs/1411.out
@@ -0,0 +1,5 @@
+QA output created by 1411
+Format and populate
+Find inline-format attr inode
+Fuzz inline-format attr inode
+Done fuzzing inline-format attr inode
diff --git a/tests/xfs/1412 b/tests/xfs/1412
new file mode 100755
index 00000000..f63e59ec
--- /dev/null
+++ b/tests/xfs/1412
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1412
+#
+# Populate a XFS filesystem and fuzz every leaf-format attr block field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Find leaf-format attr block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_LEAF)
+_scratch_unmount
+
+echo "Fuzz leaf-format attr block"
+_scratch_xfs_fuzz_metadata '' 'none'  "inode ${inum}" 'ablock 0' >> $seqres.full
+echo "Done fuzzing leaf-format attr block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1412.out b/tests/xfs/1412.out
new file mode 100644
index 00000000..41614772
--- /dev/null
+++ b/tests/xfs/1412.out
@@ -0,0 +1,5 @@
+QA output created by 1412
+Format and populate
+Find leaf-format attr block
+Fuzz leaf-format attr block
+Done fuzzing leaf-format attr block
diff --git a/tests/xfs/1413 b/tests/xfs/1413
new file mode 100755
index 00000000..22cae22e
--- /dev/null
+++ b/tests/xfs/1413
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1413
+#
+# Populate a XFS filesystem and fuzz every node-format attr block field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Find node-format attr block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_NODE)
+_scratch_unmount
+
+echo "Fuzz node-format attr block"
+_scratch_xfs_fuzz_metadata '' 'none'  "inode ${inum}" "ablock 0" >> $seqres.full
+echo "Done fuzzing node-format attr block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1413.out b/tests/xfs/1413.out
new file mode 100644
index 00000000..7c295771
--- /dev/null
+++ b/tests/xfs/1413.out
@@ -0,0 +1,5 @@
+QA output created by 1413
+Format and populate
+Find node-format attr block
+Fuzz node-format attr block
+Done fuzzing node-format attr block
diff --git a/tests/xfs/1414 b/tests/xfs/1414
new file mode 100755
index 00000000..a6c96d8e
--- /dev/null
+++ b/tests/xfs/1414
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1414
+#
+# Populate a XFS filesystem and fuzz every external attr block field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Find external attr block"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_EXTENTS_REMOTE3K)
+_scratch_unmount
+
+echo "Fuzz external attr block"
+_scratch_xfs_fuzz_metadata '' 'none'  "inode ${inum}" "ablock 1" >> $seqres.full
+echo "Done fuzzing external attr block"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1414.out b/tests/xfs/1414.out
new file mode 100644
index 00000000..ede45f43
--- /dev/null
+++ b/tests/xfs/1414.out
@@ -0,0 +1,5 @@
+QA output created by 1414
+Format and populate
+Find external attr block
+Fuzz external attr block
+Done fuzzing external attr block
diff --git a/tests/xfs/1415 b/tests/xfs/1415
new file mode 100755
index 00000000..711b9ec0
--- /dev/null
+++ b/tests/xfs/1415
@@ -0,0 +1,49 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1415
+#
+# Populate a XFS filesystem and fuzz every rtrmapbt record field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_realtime
+_require_xfs_scratch_rmapbt
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'sb 0' 'addr rrmapino')
+
+echo "Fuzz rtrmapbt recs"
+_scratch_xfs_fuzz_metadata '' 'none' 'sb 0' 'addr rrmapino' "addr u${inode_ver}.rtrmapbt.ptrs[1]" >> $seqres.full
+echo "Done fuzzing rtrmapbt recs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1415.out b/tests/xfs/1415.out
new file mode 100644
index 00000000..d23b46bf
--- /dev/null
+++ b/tests/xfs/1415.out
@@ -0,0 +1,4 @@
+QA output created by 1415
+Format and populate
+Fuzz rtrmapbt recs
+Done fuzzing rtrmapbt recs
diff --git a/tests/xfs/1416 b/tests/xfs/1416
new file mode 100755
index 00000000..addc9342
--- /dev/null
+++ b/tests/xfs/1416
@@ -0,0 +1,47 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1416
+#
+# Populate a XFS filesystem and fuzz every rtrmapbt keyptr field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_realtime
+_require_xfs_scratch_rmapbt
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz rtrmapbt keyptrs"
+_scratch_xfs_fuzz_metadata '(rtrmapbt)' 'offline' 'sb 0' 'addr rrmapino' >> $seqres.full
+echo "Done fuzzing rtrmapbt keyptrs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1416.out b/tests/xfs/1416.out
new file mode 100644
index 00000000..e368a20e
--- /dev/null
+++ b/tests/xfs/1416.out
@@ -0,0 +1,4 @@
+QA output created by 1416
+Format and populate
+Fuzz rtrmapbt keyptrs
+Done fuzzing rtrmapbt keyptrs
diff --git a/tests/xfs/1417 b/tests/xfs/1417
new file mode 100755
index 00000000..c7a990a2
--- /dev/null
+++ b/tests/xfs/1417
@@ -0,0 +1,47 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1417
+#
+# Populate a XFS filesystem and fuzz every refcountbt field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+. ./common/populate
+. ./common/fuzzy
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz refcountbt"
+_scratch_xfs_fuzz_metadata '' 'none'  'agf 0' 'addr refcntroot' 'addr ptrs[1]' >> $seqres.full
+echo "Done fuzzing refcountbt"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1417.out b/tests/xfs/1417.out
new file mode 100644
index 00000000..4a505f1c
--- /dev/null
+++ b/tests/xfs/1417.out
@@ -0,0 +1,4 @@
+QA output created by 1417
+Format and populate
+Fuzz refcountbt
+Done fuzzing refcountbt
diff --git a/tests/xfs/1418 b/tests/xfs/1418
new file mode 100755
index 00000000..d722d233
--- /dev/null
+++ b/tests/xfs/1418
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1418
+#
+# Populate a XFS filesystem and fuzz every btree-format attr inode field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Find btree-format attr inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_BTREE)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'none'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1418.out b/tests/xfs/1418.out
new file mode 100644
index 00000000..d5864640
--- /dev/null
+++ b/tests/xfs/1418.out
@@ -0,0 +1,5 @@
+QA output created by 1418
+Format and populate
+Find btree-format attr inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1419 b/tests/xfs/1419
new file mode 100755
index 00000000..79467be8
--- /dev/null
+++ b/tests/xfs/1419
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1419
+#
+# Populate a XFS filesystem and fuzz every blockdev inode field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Find blockdev inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFBLK)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'none'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1419.out b/tests/xfs/1419.out
new file mode 100644
index 00000000..10af3bb3
--- /dev/null
+++ b/tests/xfs/1419.out
@@ -0,0 +1,5 @@
+QA output created by 1419
+Format and populate
+Find blockdev inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1420 b/tests/xfs/1420
new file mode 100755
index 00000000..b07205bd
--- /dev/null
+++ b/tests/xfs/1420
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1420
+#
+# Populate a XFS filesystem and fuzz every local-format symlink inode field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+echo "Find local-format symlink inode"
+_scratch_mount
+inum=$(stat -c '%i' $SCRATCH_MNT/S_IFLNK.FMT_LOCAL)
+_scratch_unmount
+
+echo "Fuzz inode"
+_scratch_xfs_fuzz_metadata '' 'none'  "inode ${inum}" >> $seqres.full
+echo "Done fuzzing inode"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1420.out b/tests/xfs/1420.out
new file mode 100644
index 00000000..c82242ce
--- /dev/null
+++ b/tests/xfs/1420.out
@@ -0,0 +1,5 @@
+QA output created by 1420
+Format and populate
+Find local-format symlink inode
+Fuzz inode
+Done fuzzing inode
diff --git a/tests/xfs/1421 b/tests/xfs/1421
new file mode 100755
index 00000000..81f83e11
--- /dev/null
+++ b/tests/xfs/1421
@@ -0,0 +1,48 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1421
+#
+# Populate a XFS filesystem and fuzz every user dquot field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+. ./common/populate
+. ./common/fuzzy
+. ./common/quota
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+_require_quota
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+echo "${MOUNT_OPTIONS}" | grep -q 'usrquota' || _notrun "user quota disabled"
+
+echo "Fuzz user 0 dquot"
+_scratch_xfs_fuzz_metadata '' 'none'  "dquot -u 0" >> $seqres.full
+echo "Done fuzzing dquot"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1421.out b/tests/xfs/1421.out
new file mode 100644
index 00000000..8a50226a
--- /dev/null
+++ b/tests/xfs/1421.out
@@ -0,0 +1,4 @@
+QA output created by 1421
+Format and populate
+Fuzz user 0 dquot
+Done fuzzing dquot
diff --git a/tests/xfs/1422 b/tests/xfs/1422
new file mode 100755
index 00000000..8a74edad
--- /dev/null
+++ b/tests/xfs/1422
@@ -0,0 +1,48 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1422
+#
+# Populate a XFS filesystem and fuzz every group dquot field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+. ./common/populate
+. ./common/fuzzy
+. ./common/quota
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+_require_quota
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+echo "${MOUNT_OPTIONS}" | grep -q 'grpquota' || _notrun "group quota disabled"
+
+echo "Fuzz group 0 dquot"
+_scratch_xfs_fuzz_metadata '' 'none'  "dquot -g 0" >> $seqres.full
+echo "Done fuzzing dquot"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1422.out b/tests/xfs/1422.out
new file mode 100644
index 00000000..728e73f7
--- /dev/null
+++ b/tests/xfs/1422.out
@@ -0,0 +1,4 @@
+QA output created by 1422
+Format and populate
+Fuzz group 0 dquot
+Done fuzzing dquot
diff --git a/tests/xfs/1423 b/tests/xfs/1423
new file mode 100755
index 00000000..f49fbfde
--- /dev/null
+++ b/tests/xfs/1423
@@ -0,0 +1,48 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
+#
+# FS QA Test No. 1423
+#
+# Populate a XFS filesystem and fuzz every project dquot field.
+# Do not fix the filesystem, to test metadata verifiers.
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
+. ./common/populate
+. ./common/fuzzy
+. ./common/quota
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_xfs_fuzz_fields
+_require_quota
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+echo "${MOUNT_OPTIONS}" | grep -q 'prjquota' || _notrun "project quota disabled"
+
+echo "Fuzz project 0 dquot"
+_scratch_xfs_fuzz_metadata '' 'none'  "dquot -p 0" >> $seqres.full
+echo "Done fuzzing dquot"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1423.out b/tests/xfs/1423.out
new file mode 100644
index 00000000..8a679f76
--- /dev/null
+++ b/tests/xfs/1423.out
@@ -0,0 +1,4 @@
+QA output created by 1423
+Format and populate
+Fuzz project 0 dquot
+Done fuzzing dquot
diff --git a/tests/xfs/group b/tests/xfs/group
index 2f1c8467..b70b4134 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -448,3 +448,40 @@
 448 auto quick fuzzers
 449 auto quick
 712 auto quick rmap
+1387 dangerous_fuzzers dangerous_norepair
+1388 dangerous_fuzzers dangerous_norepair
+1389 dangerous_fuzzers dangerous_norepair
+1390 dangerous_fuzzers dangerous_norepair
+1391 dangerous_fuzzers dangerous_norepair
+1392 dangerous_fuzzers dangerous_norepair
+1393 dangerous_fuzzers dangerous_norepair
+1394 dangerous_fuzzers dangerous_norepair
+1395 dangerous_fuzzers dangerous_norepair
+1396 dangerous_fuzzers dangerous_norepair
+1397 dangerous_fuzzers dangerous_norepair
+1398 dangerous_fuzzers dangerous_norepair
+1399 dangerous_fuzzers dangerous_norepair
+1400 dangerous_fuzzers dangerous_norepair
+1401 dangerous_fuzzers dangerous_norepair
+1402 dangerous_fuzzers dangerous_norepair
+1403 dangerous_fuzzers dangerous_norepair
+1404 dangerous_fuzzers dangerous_norepair
+1405 dangerous_fuzzers dangerous_norepair
+1406 dangerous_fuzzers dangerous_norepair
+1407 dangerous_fuzzers dangerous_norepair
+1408 dangerous_fuzzers dangerous_norepair
+1409 dangerous_fuzzers dangerous_norepair
+1410 dangerous_fuzzers dangerous_norepair
+1411 dangerous_fuzzers dangerous_norepair
+1412 dangerous_fuzzers dangerous_norepair
+1413 dangerous_fuzzers dangerous_norepair
+1414 dangerous_fuzzers dangerous_norepair
+1415 dangerous_fuzzers dangerous_norepair
+1416 dangerous_fuzzers dangerous_norepair
+1417 dangerous_fuzzers dangerous_norepair
+1418 dangerous_fuzzers dangerous_norepair
+1419 dangerous_fuzzers dangerous_norepair
+1420 dangerous_fuzzers dangerous_norepair
+1421 dangerous_fuzzers dangerous_norepair
+1422 dangerous_fuzzers dangerous_norepair
+1423 dangerous_fuzzers dangerous_norepair

