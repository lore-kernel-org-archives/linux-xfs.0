Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227145932.6spourlpkrmxnf7t@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from userp1040.oracle.com ([156.151.31.81]:22018 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbdBYBNJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Feb 2017 20:13:09 -0500
Subject: [PATCH 4/4] xfs: stress test xfs_scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 24 Feb 2017 17:13:04 -0800
Message-ID: <148798518415.25833.11653991983531432757.stgit@birch.djwong.org>
In-Reply-To: <148798515933.25833.2842247083803775089.stgit@birch.djwong.org>
References: <148798515933.25833.2842247083803775089.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Three new tests:

- Repair files that are mapped into memory in running programs
- Run scrub -n concurrently with fsstress
- Run scrub -y concurrently with fsstress

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/1375     |   69 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1375.out |    3 ++
 tests/xfs/1376     |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1376.out |    4 ++
 tests/xfs/1377     |   84 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1377.out |    4 ++
 tests/xfs/group    |    3 ++
 7 files changed, 250 insertions(+)
 create mode 100755 tests/xfs/1375
 create mode 100644 tests/xfs/1375.out
 create mode 100755 tests/xfs/1376
 create mode 100644 tests/xfs/1376.out
 create mode 100755 tests/xfs/1377
 create mode 100644 tests/xfs/1377.out


diff --git a/tests/xfs/1375 b/tests/xfs/1375
new file mode 100755
index 0000000..d3119ef
--- /dev/null
+++ b/tests/xfs/1375
@@ -0,0 +1,69 @@
+#! /bin/bash
+# FS QA Test No. 1375
+#
+# Copy xfs_scrub to the scratch device, then run xfs_scrub in forced
+# repair mode (which will rebuild the data forks of the running scrub
+# executable and libraries!) to see what happens.
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
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_command /usr/bin/ldd "ldd"
+_require_scrub
+_require_scratch
+_require_xfs_io_error_injection "force_repair"
+
+echo "Format and populate"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+cp $XFS_SCRUB_PROG $SCRATCH_MNT/xfs_scrub
+ldd $XFS_SCRUB_PROG | sed -e '/\//!d;/linux-gate/d;/=>/ {s/.*=>[[:blank:]]*\([^[:blank:]]*\).*/\1/};s/[[:blank:]]*\([^[:blank:]]*\) (.*)/\1/' | while read lib; do
+	cp $lib $SCRATCH_MNT/
+done
+LD_LIBRARY_PATH=$SCRATCH_MNT ldd $SCRATCH_MNT/xfs_scrub >> $seqres.full
+
+echo "Force online repairs"
+XFS_SCRUB_FORCE_REPAIR=1 LD_LIBRARY_PATH=$SCRATCH_MNT $SCRATCH_MNT/xfs_scrub -dTvy $SCRATCH_MNT >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1375.out b/tests/xfs/1375.out
new file mode 100644
index 0000000..dd7025e
--- /dev/null
+++ b/tests/xfs/1375.out
@@ -0,0 +1,3 @@
+QA output created by 1375
+Format and populate
+Force online repairs
diff --git a/tests/xfs/1376 b/tests/xfs/1376
new file mode 100755
index 0000000..f037b43
--- /dev/null
+++ b/tests/xfs/1376
@@ -0,0 +1,83 @@
+#! /bin/bash
+# FS QA Test No. 1376
+#
+# Race fio and xfs_scrub for a while to see if we crash or livelock.
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
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scrub
+_require_scratch
+_require_command "$KILLALL_PROG" killall
+
+echo "Format and populate"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+STRESS_DIR="$SCRATCH_MNT/testdir"
+mkdir -p $STRESS_DIR
+
+cpus=$((16 * LOAD_FACTOR))
+$FSSTRESS_PROG -d $STRESS_DIR -p $cpus -n $((cpus * 100000)) $FSSTRESS_AVOID >/dev/null 2>&1 &
+$XFS_SCRUB_PROG -d -T -v -n $SCRATCH_MNT >> $seqres.full
+
+killstress() {
+	sleep $(( 60 * LOAD_FACTOR ))
+	$KILLALL_PROG -q $FSSTRESS_PROG
+}
+
+echo "Concurrent scrub"
+start=$(date +%s)
+end=$((start + (60 * LOAD_FACTOR) ))
+killstress &
+echo "Scrub started at $(date --date="@${start}"), ending at $(date --date="@${end}")" >> $seqres.full
+while [ "$(date +%s)" -lt "$end" ]; do
+	timeout -s TERM $(( end - $(date +%s) + 2 )) $XFS_SCRUB_PROG -d -T -v -n $SCRATCH_MNT >> $seqres.full 2>&1
+done
+
+echo "Test done"
+echo "Scrub finished at $(date)" >> $seqres.full
+$KILLALL_PROG -q $FSSTRESS_PROG
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1376.out b/tests/xfs/1376.out
new file mode 100644
index 0000000..155f424
--- /dev/null
+++ b/tests/xfs/1376.out
@@ -0,0 +1,4 @@
+QA output created by 1376
+Format and populate
+Concurrent scrub
+Test done
diff --git a/tests/xfs/1377 b/tests/xfs/1377
new file mode 100755
index 0000000..1e0814c
--- /dev/null
+++ b/tests/xfs/1377
@@ -0,0 +1,84 @@
+#! /bin/bash
+# FS QA Test No. 1377
+#
+# Race fio and xfs_scrub -y for a while to see if we crash or livelock.
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
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scrub
+_require_scratch
+_require_command "$KILLALL_PROG" killall
+_require_xfs_io_error_injection "force_repair"
+
+echo "Format and populate"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+STRESS_DIR="$SCRATCH_MNT/testdir"
+mkdir -p $STRESS_DIR
+
+cpus=$((16 * LOAD_FACTOR))
+$FSSTRESS_PROG -d $STRESS_DIR -p $cpus -n $((cpus * 100000)) $FSSTRESS_AVOID >/dev/null 2>&1 &
+$XFS_SCRUB_PROG -d -T -v -n $SCRATCH_MNT >> $seqres.full
+
+killstress() {
+	sleep $(( 60 * LOAD_FACTOR ))
+	$KILLALL_PROG -q $FSSTRESS_PROG
+}
+
+echo "Concurrent repair"
+start=$(date +%s)
+end=$((start + (60 * LOAD_FACTOR) ))
+killstress &
+echo "Repair started at $(date --date="@${start}"), ending at $(date --date="@${end}")" >> $seqres.full
+while [ "$(date +%s)" -lt "$end" ]; do
+	XFS_SCRUB_FORCE_REPAIR=1 timeout -s TERM $(( end - $(date +%s) + 2 )) $XFS_SCRUB_PROG -d -T -v -y $SCRATCH_MNT >> $seqres.full
+done
+
+echo "Test done"
+echo "Repair finished at $(date)" >> $seqres.full
+$KILLALL_PROG -q $FSSTRESS_PROG
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1377.out b/tests/xfs/1377.out
new file mode 100644
index 0000000..0454a87
--- /dev/null
+++ b/tests/xfs/1377.out
@@ -0,0 +1,4 @@
+QA output created by 1377
+Format and populate
+Concurrent repair
+Test done
diff --git a/tests/xfs/group b/tests/xfs/group
index eaa65b1..7fce0a0 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -408,3 +408,6 @@
 416 dangerous_fuzzers dangerous_scrub dangerous_repair
 417 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 418 dangerous_fuzzers dangerous_scrub dangerous_repair
+1375 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1376 dangerous_fuzzers dangerous_scrub
+1377 dangerous_fuzzers dangerous_scrub dangerous_online_repair

