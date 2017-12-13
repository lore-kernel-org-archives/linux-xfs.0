Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45088 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751447AbdLMGIx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 01:08:53 -0500
Subject: [PATCH 5/8] generic: test error shutdown while stressing filesystem
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 12 Dec 2017 22:03:48 -0800
Message-ID: <151314502812.18893.11244203325379063295.stgit@magnolia>
In-Reply-To: <151314499003.18893.8687182548758898133.stgit@magnolia>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/932     |   97 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/932.out |    2 +
 tests/generic/group   |    1 +
 3 files changed, 100 insertions(+)
 create mode 100755 tests/generic/932
 create mode 100644 tests/generic/932.out


diff --git a/tests/generic/932 b/tests/generic/932
new file mode 100755
index 0000000..a440a75
--- /dev/null
+++ b/tests/generic/932
@@ -0,0 +1,97 @@
+#! /bin/bash
+# FS QA Test No. 932
+#
+# Test log recovery with repeated (simulated) disk failures.  We kick
+# off fsstress on the scratch fs, then switch out the underlying device
+# with dm-error to see what happens when the disk goes down.  Having
+# taken down the fs in this manner, remount it and repeat.  This test
+# is a Good Enough (tm) simulation of our internal multipath failure
+# testing efforts.
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
+	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
+	_dmerror_unmount
+	_dmerror_cleanup
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/dmerror
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+
+_require_scratch
+_require_dm_target error
+_require_command "$KILLALL_PROG" "killall"
+
+rm -f $seqres.full
+
+echo "Silence is golden."
+
+_scratch_mkfs >> $seqres.full 2>&1
+_require_metadata_journaling $SCRATCH_DEV
+_dmerror_init
+_dmerror_mount
+
+for i in $(seq 1 $((50 * TIME_FACTOR)) ); do
+	($FSSTRESS_PROG $FSSTRESS_AVOID -d $SCRATCH_MNT -n 999999 -p $((LOAD_FACTOR * 4)) >> $seqres.full &) \
+		> /dev/null 2>&1
+
+	# purposely include 0 second sleeps to test shutdown immediately after
+	# recovery
+	sleep $((RANDOM % 3))
+
+	# Loading error table without "--nolockfs" option. Because "--nolockfs"
+	# won't freeze fs, then some running I/Os may cause XFS to shutdown
+	# prematurely. That's not what we want to test.
+	_dmerror_load_error_table
+
+	ps -e | grep fsstress > /dev/null 2>&1
+	while [ $? -eq 0 ]; do
+		$KILLALL_PROG -9 fsstress > /dev/null 2>&1
+		wait > /dev/null 2>&1
+		ps -e | grep fsstress > /dev/null 2>&1
+	done
+
+	# Mount again to replay log after loading working table, so we have a
+	# consistent XFS after test.
+	_dmerror_unmount || _fail "unmount failed"
+	_dmerror_load_working_table
+	_dmerror_mount || _fail "mount failed"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/932.out b/tests/generic/932.out
new file mode 100644
index 0000000..1bb668c
--- /dev/null
+++ b/tests/generic/932.out
@@ -0,0 +1,2 @@
+QA output created by 932
+Silence is golden.
diff --git a/tests/generic/group b/tests/generic/group
index 6c3bb03..ff1ddc9 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -472,3 +472,4 @@
 467 auto quick exportfs
 468 shutdown auto quick metadata
 469 auto quick
+932 shutdown auto log metadata

