Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35713 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754885AbdGUWFF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 18:05:05 -0400
Subject: [PATCH 5/5] xfs: test fuzzing every field of a dquot
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 21 Jul 2017 15:04:58 -0700
Message-ID: <150067469875.30639.1164952553984333812.stgit@magnolia>
In-Reply-To: <150067465981.30639.14801416171688538711.stgit@magnolia>
References: <150067465981.30639.14801416171688538711.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

See what happens when we fuzz every field of a quota information structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/1380     |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1380.out |    4 +++
 tests/xfs/1381     |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1381.out |    4 +++
 tests/xfs/1382     |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1382.out |    4 +++
 tests/xfs/1383     |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1383.out |    4 +++
 tests/xfs/1384     |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1384.out |    4 +++
 tests/xfs/1385     |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1385.out |    4 +++
 tests/xfs/group    |    6 +++++
 13 files changed, 408 insertions(+)
 create mode 100755 tests/xfs/1380
 create mode 100644 tests/xfs/1380.out
 create mode 100755 tests/xfs/1381
 create mode 100644 tests/xfs/1381.out
 create mode 100755 tests/xfs/1382
 create mode 100644 tests/xfs/1382.out
 create mode 100755 tests/xfs/1383
 create mode 100644 tests/xfs/1383.out
 create mode 100755 tests/xfs/1384
 create mode 100644 tests/xfs/1384.out
 create mode 100755 tests/xfs/1385
 create mode 100644 tests/xfs/1385.out


diff --git a/tests/xfs/1380 b/tests/xfs/1380
new file mode 100755
index 0000000..6ce5cdf
--- /dev/null
+++ b/tests/xfs/1380
@@ -0,0 +1,63 @@
+#! /bin/bash
+# FS QA Test No. 1380
+#
+# Populate a XFS filesystem and fuzz every user dquot field.
+# Use xfs_repair to fix the corruption.
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
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
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
+_scratch_xfs_fuzz_metadata '' 'offline'  "dquot -u 0" >> $seqres.full
+echo "Done fuzzing dquot"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1380.out b/tests/xfs/1380.out
new file mode 100644
index 0000000..206445e
--- /dev/null
+++ b/tests/xfs/1380.out
@@ -0,0 +1,4 @@
+QA output created by 1380
+Format and populate
+Fuzz user 0 dquot
+Done fuzzing dquot
diff --git a/tests/xfs/1381 b/tests/xfs/1381
new file mode 100755
index 0000000..fc5bca9
--- /dev/null
+++ b/tests/xfs/1381
@@ -0,0 +1,63 @@
+#! /bin/bash
+# FS QA Test No. 1381
+#
+# Populate a XFS filesystem and fuzz every user dquot field.
+# Use xfs_scrub to fix the corruption.
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
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
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
+_scratch_xfs_fuzz_metadata '' 'online'  "dquot -u 0" >> $seqres.full
+echo "Done fuzzing dquot"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1381.out b/tests/xfs/1381.out
new file mode 100644
index 0000000..f656609
--- /dev/null
+++ b/tests/xfs/1381.out
@@ -0,0 +1,4 @@
+QA output created by 1381
+Format and populate
+Fuzz user 0 dquot
+Done fuzzing dquot
diff --git a/tests/xfs/1382 b/tests/xfs/1382
new file mode 100755
index 0000000..fd7e50d
--- /dev/null
+++ b/tests/xfs/1382
@@ -0,0 +1,63 @@
+#! /bin/bash
+# FS QA Test No. 1380
+#
+# Populate a XFS filesystem and fuzz every group dquot field.
+# Use xfs_repair to fix the corruption.
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
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
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
+_scratch_xfs_fuzz_metadata '' 'offline'  "dquot -g 0" >> $seqres.full
+echo "Done fuzzing dquot"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1382.out b/tests/xfs/1382.out
new file mode 100644
index 0000000..5350eb6
--- /dev/null
+++ b/tests/xfs/1382.out
@@ -0,0 +1,4 @@
+QA output created by 1382
+Format and populate
+Fuzz group 0 dquot
+Done fuzzing dquot
diff --git a/tests/xfs/1383 b/tests/xfs/1383
new file mode 100755
index 0000000..0095b67
--- /dev/null
+++ b/tests/xfs/1383
@@ -0,0 +1,63 @@
+#! /bin/bash
+# FS QA Test No. 1383
+#
+# Populate a XFS filesystem and fuzz every group dquot field.
+# Use xfs_scrub to fix the corruption.
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
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
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
+_scratch_xfs_fuzz_metadata '' 'online'  "dquot -g 0" >> $seqres.full
+echo "Done fuzzing dquot"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1383.out b/tests/xfs/1383.out
new file mode 100644
index 0000000..3af271b
--- /dev/null
+++ b/tests/xfs/1383.out
@@ -0,0 +1,4 @@
+QA output created by 1383
+Format and populate
+Fuzz group 0 dquot
+Done fuzzing dquot
diff --git a/tests/xfs/1384 b/tests/xfs/1384
new file mode 100755
index 0000000..53b0450
--- /dev/null
+++ b/tests/xfs/1384
@@ -0,0 +1,63 @@
+#! /bin/bash
+# FS QA Test No. 1384
+#
+# Populate a XFS filesystem and fuzz every project dquot field.
+# Use xfs_repair to fix the corruption.
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
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
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
+_scratch_xfs_fuzz_metadata '' 'offline'  "dquot -p 0" >> $seqres.full
+echo "Done fuzzing dquot"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1384.out b/tests/xfs/1384.out
new file mode 100644
index 0000000..0bba74e
--- /dev/null
+++ b/tests/xfs/1384.out
@@ -0,0 +1,4 @@
+QA output created by 1384
+Format and populate
+Fuzz project 0 dquot
+Done fuzzing dquot
diff --git a/tests/xfs/1385 b/tests/xfs/1385
new file mode 100755
index 0000000..f6fc7b7
--- /dev/null
+++ b/tests/xfs/1385
@@ -0,0 +1,63 @@
+#! /bin/bash
+# FS QA Test No. 1385
+#
+# Populate a XFS filesystem and fuzz every project dquot field.
+# Use xfs_scrub to fix the corruption.
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
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1303  USA
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
+_scratch_xfs_fuzz_metadata '' 'online'  "dquot -p 0" >> $seqres.full
+echo "Done fuzzing dquot"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1385.out b/tests/xfs/1385.out
new file mode 100644
index 0000000..e980490
--- /dev/null
+++ b/tests/xfs/1385.out
@@ -0,0 +1,4 @@
+QA output created by 1385
+Format and populate
+Fuzz project 0 dquot
+Done fuzzing dquot
diff --git a/tests/xfs/group b/tests/xfs/group
index ffdb061..079dc48 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -421,3 +421,9 @@
 421 auto quick clone dedupe
 422 dangerous_scrub dangerous_online_repair
 423 dangerous_scrub
+1380 dangerous_fuzzers dangerous_scrub dangerous_repair
+1381 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1382 dangerous_fuzzers dangerous_scrub dangerous_repair
+1383 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1384 dangerous_fuzzers dangerous_scrub dangerous_repair
+1385 dangerous_fuzzers dangerous_scrub dangerous_online_repair

