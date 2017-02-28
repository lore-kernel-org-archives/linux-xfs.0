Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:23845 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751761AbdB1VAg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 16:00:36 -0500
Date: Tue, 28 Feb 2017 12:57:10 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 4/4] xfs: stress test xfs_scrub
Message-ID: <20170228205710.GC26275@birch.djwong.org>
References: <148798515933.25833.2842247083803775089.stgit@birch.djwong.org>
 <148798518415.25833.11653991983531432757.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148798518415.25833.11653991983531432757.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Three new tests:

- Repair files that are mapped into memory in running programs
- Run scrub -n concurrently with fsstress
- Run scrub -y concurrently with fsstress

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: fix checks for external programs per eryu guan's recommendations
---
 common/config      |    2 +
 tests/xfs/1375     |   70 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1375.out |    3 ++
 tests/xfs/1376     |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1376.out |    4 ++
 tests/xfs/1377     |   87 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1377.out |    4 ++
 tests/xfs/group    |    3 ++
 8 files changed, 258 insertions(+)
 create mode 100755 tests/xfs/1375
 create mode 100644 tests/xfs/1375.out
 create mode 100755 tests/xfs/1376
 create mode 100644 tests/xfs/1376.out
 create mode 100755 tests/xfs/1377
 create mode 100644 tests/xfs/1377.out

diff --git a/common/config b/common/config
index 3ef401b..5f3202b 100644
--- a/common/config
+++ b/common/config
@@ -205,6 +205,8 @@ export SETRICHACL_PROG="`set_prog_path setrichacl`"
 export KEYCTL_PROG="`set_prog_path keyctl`"
 export XZ_PROG="`set_prog_path xz`"
 export FLOCK_PROG="`set_prog_path flock`"
+export LDD_PROG="`set_prog_path ldd`"
+export TIMEOUT_PROG="`set_prog_path timeout`"
 
 # use 'udevadm settle' or 'udevsettle' to wait for lv to be settled.
 # newer systems have udevadm command but older systems like RHEL5 don't.
diff --git a/tests/xfs/1375 b/tests/xfs/1375
new file mode 100755
index 0000000..f1b0a84
--- /dev/null
+++ b/tests/xfs/1375
@@ -0,0 +1,70 @@
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
+_require_command "$LDD_PROG" ldd
+_require_scrub
+_require_scratch
+# xfs_scrub will turn on error injection itself
+_require_xfs_io_error_injection "force_repair"
+
+echo "Format and populate"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+cp $XFS_SCRUB_PROG $SCRATCH_MNT/xfs_scrub
+$LDD_PROG $XFS_SCRUB_PROG | sed -e '/\//!d;/linux-gate/d;/=>/ {s/.*=>[[:blank:]]*\([^[:blank:]]*\).*/\1/};s/[[:blank:]]*\([^[:blank:]]*\) (.*)/\1/' | while read lib; do
+	cp $lib $SCRATCH_MNT/
+done
+LD_LIBRARY_PATH=$SCRATCH_MNT $LDD_PROG $SCRATCH_MNT/xfs_scrub >> $seqres.full
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
index 0000000..91ed8dd
--- /dev/null
+++ b/tests/xfs/1376
@@ -0,0 +1,85 @@
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
+_require_test_program "feature"
+_require_command "$KILLALL_PROG" killall
+_require_command "$TIMEOUT_PROG" timeout
+_require_scrub
+_require_scratch
+
+echo "Format and populate"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+STRESS_DIR="$SCRATCH_MNT/testdir"
+mkdir -p $STRESS_DIR
+
+cpus=$(( $(src/feature -o) * 4 * LOAD_FACTOR))
+$FSSTRESS_PROG -d $STRESS_DIR -p $cpus -n $((cpus * 100000)) $FSSTRESS_AVOID >/dev/null 2>&1 &
+$XFS_SCRUB_PROG -d -T -v -n $SCRATCH_MNT >> $seqres.full
+
+killstress() {
+	sleep $(( 60 * TIME_FACTOR ))
+	$KILLALL_PROG -q $FSSTRESS_PROG
+}
+
+echo "Concurrent scrub"
+start=$(date +%s)
+end=$((start + (60 * LOAD_FACTOR) ))
+killstress &
+echo "Scrub started at $(date --date="@${start}"), ending at $(date --date="@${end}")" >> $seqres.full
+while [ "$(date +%s)" -lt "$end" ]; do
+	$TIMEOUT_PROG -s TERM $(( end - $(date +%s) + 2 )) $XFS_SCRUB_PROG -d -T -v -n $SCRATCH_MNT >> $seqres.full 2>&1
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
index 0000000..601b1dc
--- /dev/null
+++ b/tests/xfs/1377
@@ -0,0 +1,87 @@
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
+_require_test_program "feature"
+_require_command "$KILLALL_PROG" killall
+_require_command "$TIMEOUT_PROG" timeout
+_require_scrub
+_require_scratch
+# xfs_scrub will turn on error injection itself
+_require_xfs_io_error_injection "force_repair"
+
+echo "Format and populate"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+STRESS_DIR="$SCRATCH_MNT/testdir"
+mkdir -p $STRESS_DIR
+
+cpus=$(( $(src/feature -o) * 4 * LOAD_FACTOR))
+$FSSTRESS_PROG -d $STRESS_DIR -p $cpus -n $((cpus * 100000)) $FSSTRESS_AVOID >/dev/null 2>&1 &
+$XFS_SCRUB_PROG -d -T -v -n $SCRATCH_MNT >> $seqres.full
+
+killstress() {
+	sleep $(( 60 * TIME_FACTOR ))
+	$KILLALL_PROG -q $FSSTRESS_PROG
+}
+
+echo "Concurrent repair"
+start=$(date +%s)
+end=$((start + (60 * LOAD_FACTOR) ))
+killstress &
+echo "Repair started at $(date --date="@${start}"), ending at $(date --date="@${end}")" >> $seqres.full
+while [ "$(date +%s)" -lt "$end" ]; do
+	XFS_SCRUB_FORCE_REPAIR=1 $TIMEOUT_PROG -s TERM $(( end - $(date +%s) + 2 )) $XFS_SCRUB_PROG -d -T -v -y $SCRATCH_MNT >> $seqres.full
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
index de1c39b..0b6c8cf 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -410,3 +410,6 @@
 416 dangerous_fuzzers dangerous_scrub dangerous_repair
 417 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 418 dangerous_fuzzers dangerous_scrub dangerous_repair
+1375 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1376 dangerous_fuzzers dangerous_scrub
+1377 dangerous_fuzzers dangerous_scrub dangerous_online_repair
