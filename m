Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33164 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751724AbeFWSAs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jun 2018 14:00:48 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v3 3/3] xfstests: dedupe with random io race test
Date: Sun, 24 Jun 2018 02:00:29 +0800
Message-Id: <20180623180029.24497-3-zlang@redhat.com>
In-Reply-To: <20180623180029.24497-1-zlang@redhat.com>
References: <20180623180029.24497-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Run several duperemove processes with fsstress on same directory at
same time. Make sure the race won't break the fs or kernel.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

V3 did below changes:
1) Use $TEST_DIR/${seq}-running file to loop run duperemove.
2) Change kill_all_stress function
3) Change $TEST_DIR/${seq}md5.sum to ${tmp}.md5sum

Thanks,
Zorro

 tests/shared/010     | 94 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/shared/010.out |  2 ++
 tests/shared/group   |  1 +
 3 files changed, 97 insertions(+)
 create mode 100755 tests/shared/010
 create mode 100644 tests/shared/010.out

diff --git a/tests/shared/010 b/tests/shared/010
new file mode 100755
index 00000000..3cf50ddd
--- /dev/null
+++ b/tests/shared/010
@@ -0,0 +1,94 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Red Hat Inc.  All Rights Reserved.
+#
+# FS QA Test 010
+#
+# Dedup & random I/O race test, do multi-threads fsstress and dedupe on
+# same directory/files
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
+	end_test
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# duperemove only supports btrfs and xfs (with reflink feature).
+# Add other filesystems if it supports more later.
+_supported_fs xfs btrfs
+_supported_os Linux
+_require_scratch_dedupe
+_require_command "$DUPEREMOVE_PROG" duperemove
+_require_command "$KILLALL_PROG" killall
+
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+function end_test()
+{
+	local f=1
+
+	# stop duperemove running
+	if [ -e $dupe_run ]; then
+		rm -f $dupe_run
+		wait $dedup_pids
+	fi
+
+	# Make sure all fsstress get killed
+	while [ $f -ne 0 ]; do
+		$KILLALL_PROG -q $FSSTRESS_PROG > /dev/null 2>&1
+		sleep 1
+		f=`ps -eLf | grep $FSSTRESS_PROG | grep -v "grep" | wc -l`
+	done
+}
+
+sleep_time=$((50 * TIME_FACTOR))
+
+# Start fsstress
+fsstress_opts="-r -n 1000 -p $((5 * LOAD_FACTOR))"
+$FSSTRESS_PROG $fsstress_opts -d $SCRATCH_MNT -l 0 >> $seqres.full 2>&1 &
+dedup_pids=""
+dupe_run=$TEST_DIR/${seq}-running
+# Start several dedupe processes on same directory
+touch $dupe_run
+for ((i = 0; i < $((2 * LOAD_FACTOR)); i++)); do
+	while [ -e $dupe_run ]; do
+		$DUPEREMOVE_PROG -dr --dedupe-options=same $SCRATCH_MNT/
+			>>$seqres.full 2>&1
+	done &
+	dedup_pids="$! $dedup_pids"
+done
+
+# End the test after $sleep_time seconds
+sleep $sleep_time
+end_test
+
+# umount and mount again, verify pagecache contents don't mutate and a fresh
+# read from the disk also doesn't show mutations.
+find $testdir -type f -exec md5sum {} \; > ${tmp}.md5sum
+_scratch_cycle_mount
+md5sum -c --quiet ${tmp}.md5sum
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/shared/010.out b/tests/shared/010.out
new file mode 100644
index 00000000..1d83a8d6
--- /dev/null
+++ b/tests/shared/010.out
@@ -0,0 +1,2 @@
+QA output created by 010
+Silence is golden
diff --git a/tests/shared/group b/tests/shared/group
index 9c484794..094da27d 100644
--- a/tests/shared/group
+++ b/tests/shared/group
@@ -12,6 +12,7 @@
 007 dangerous_fuzzers
 008 auto stress dedupe
 009 auto stress dedupe
+010 auto stress dedupe
 032 mkfs auto quick
 272 auto enospc rw
 289 auto quick
-- 
2.14.4

