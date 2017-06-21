Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36918 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752026AbdFUV6U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2017 17:58:20 -0400
Subject: [PATCH 7/8] xfs: test freeze/rmap repair race
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 21 Jun 2017 14:58:11 -0700
Message-ID: <149808229180.8924.4409973593099506918.stgit@birch.djwong.org>
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

The rmapbt repair code plays some dirty tricks with the fs freezer to
avoid running afoul of regular xfs locking requirements.  Add a test to
check that filesystem write activities do not deadlock with the repair
program.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/1378     |  109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1378.out |    4 ++
 tests/xfs/group    |    1 
 3 files changed, 114 insertions(+)
 create mode 100755 tests/xfs/1378
 create mode 100644 tests/xfs/1378.out


diff --git a/tests/xfs/1378 b/tests/xfs/1378
new file mode 100755
index 0000000..79ba6bc
--- /dev/null
+++ b/tests/xfs/1378
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test No. 1378
+#
+# Race freeze and rmapbt repair for a while to see if we crash or livelock.
+# rmapbt repair requires us to freeze the filesystem to stop all filesystem
+# activity, so we can't have userspace wandering in and thawing it.
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
+_require_xfs_scratch_rmapbt
+_require_xfs_io_command "scrub"
+_require_xfs_io_error_injection "force_repair"
+
+echo "Format and populate"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+STRESS_DIR="$SCRATCH_MNT/testdir"
+mkdir -p $STRESS_DIR
+
+for i in $(seq 0 9); do
+	mkdir -p $STRESS_DIR/$i
+	for j in $(seq 0 9); do
+		mkdir -p $STRESS_DIR/$i/$j
+		for k in $(seq 0 9); do
+			echo x > $STRESS_DIR/$i/$j/$k
+		done
+	done
+done
+
+cpus=$(( $(src/feature -o) * 4 * LOAD_FACTOR))
+
+echo "Concurrent repair"
+filter_output() {
+	egrep -v '(Device or resource busy|Invalid argument)'
+}
+freeze_loop() {
+	end="$1"
+
+	while [ "$(date +%s)" -lt $end ]; do
+		$XFS_IO_PROG -x -c 'freeze' -c 'thaw' $SCRATCH_MNT 2>&1 | filter_output
+	done
+}
+repair_loop() {
+	end="$1"
+
+	while [ "$(date +%s)" -lt $end ]; do
+		$XFS_IO_PROG -x -c 'repair rmapbt 0' -c 'repair rmapbt 1' $SCRATCH_MNT 2>&1 | filter_output
+	done
+}
+$XFS_IO_PROG -x -c 'inject force_repair' $SCRATCH_MNT
+
+start=$(date +%s)
+end=$((start + (30 * TIME_FACTOR) ))
+
+echo "Loop started at $(date --date="@${start}"), ending at $(date --date="@${end}")" >> $seqres.full
+freeze_loop $end &
+repair_loop $end &
+
+while [ "$(date +%s)" -lt $end ]; do
+	sleep 1
+done
+echo "Loop finished at $(date)" >> $seqres.full
+echo "Test done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1378.out b/tests/xfs/1378.out
new file mode 100644
index 0000000..030e250
--- /dev/null
+++ b/tests/xfs/1378.out
@@ -0,0 +1,4 @@
+QA output created by 1378
+Format and populate
+Concurrent repair
+Test done
diff --git a/tests/xfs/group b/tests/xfs/group
index faf0095..d0a6831 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -419,3 +419,4 @@
 701 auto quick
 901 auto quick clone dedupe
 902 auto quick clone dedupe
+1378 dangerous_scrub dangerous_online_repair

