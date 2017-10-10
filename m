Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34442 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752068AbdJJHmN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Oct 2017 03:42:13 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2 1/2] generic: test race between block map change and writeback
Date: Tue, 10 Oct 2017 15:42:07 +0800
Message-Id: <20171010074208.15389-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

Run delalloc writes & append writes & non-data-integrity syncs
concurrently to test the race between block map change vs writeback.

This is to cover an XFS bug that data could be written to wrong
block and delay allocated blocks are leaked because the block map
was changed due to the removal of speculative allocated eofblocks
when writeback is in progress.

And this test partially mimics what lustre-racer[1] test does, using
which this bug was first found.

[1] https://git.hpdd.intel.com/?p=fs/lustre-release.git;a=tree;f=lustre/tests/racer;hb=HEAD

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
v2:
- reduce LOOP_CNT to save some run time
- fix line over 80 chars

 tests/generic/463     | 131 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/463.out |   2 +
 tests/generic/group   |   1 +
 3 files changed, 134 insertions(+)
 create mode 100755 tests/generic/463
 create mode 100644 tests/generic/463.out

diff --git a/tests/generic/463 b/tests/generic/463
new file mode 100755
index 000000000000..7ab551bacf94
--- /dev/null
+++ b/tests/generic/463
@@ -0,0 +1,131 @@
+#! /bin/bash
+# FS QA Test 463
+#
+# Run delalloc writes & append writes & non-data-integrity syncs concurrently
+# to test the race between block map change vs writeback.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Red Hat Inc. All Rights Reserved.
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
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+MAXFILES=200
+BLOCK_SZ=65536
+
+LOOP_CNT=10
+LOOP_TIME=5
+PROC_CNT=16
+
+stop=$tmp.stop
+
+# get a random file to work on
+getfile()
+{
+	echo $SCRATCH_MNT/$((RANDOM % MAXFILES))
+}
+
+# delalloc write a relative big file to get enough dirty pages to be written
+# back, and XFS needs big enough file to trigger speculative preallocations, so
+# freeing these eofblocks could change the extent record
+do_write()
+{
+	local blockcount=$((RANDOM % 100))
+	local filesize=$((blockcount * BLOCK_SZ))
+	$XFS_IO_PROG -ftc "pwrite -b $BLOCK_SZ 0 $filesize" `getfile` \
+		>/dev/null 2>&1
+}
+
+# append another dirty page to the file, the writeback might pick it up too if
+# the file is already under writeback
+do_append()
+{
+	echo "test string" >> `getfile`
+}
+
+# issue WB_SYNC_NONE writeback with the '-w' option of sync_range xfs_io
+# command, so that the last dirty page from append write can be picked up in
+# this writeback cycle. This is not mandatory but could help reproduce XFS
+# corruption more easily.
+do_writeback()
+{
+	$XFS_IO_PROG -c "sync_range -w 0 0" `getfile` >/dev/null 2>&1
+}
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+# do fsck after each iteration in test
+_require_scratch_nocheck
+_require_xfs_io_command "sync_range"
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+# loop for $LOOP_CNT iterations, and each iteration starts $PROC_CNT processes
+# for each operation and runs for $LOOP_TIME seconds, and check filesystem
+# consistency after each iteration
+for i in `seq 1 $LOOP_CNT`; do
+	rm -f $stop
+	for j in `seq 1 $PROC_CNT`; do
+		while [ ! -e $stop ]; do
+			do_write
+		done &
+
+		while [ ! -e $stop ]; do
+			do_append
+		done &
+
+		while [ ! -e $stop ]; do
+			do_writeback
+		done &
+	done
+	sleep $LOOP_TIME
+	touch $stop
+	wait
+
+	_scratch_unmount
+	# test exits here if fs is inconsistent
+	_check_scratch_fs
+	_scratch_mount
+done
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/463.out b/tests/generic/463.out
new file mode 100644
index 000000000000..dd61371a26d4
--- /dev/null
+++ b/tests/generic/463.out
@@ -0,0 +1,2 @@
+QA output created by 463
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index f2a6cdadf130..9f173e7a63c9 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -465,3 +465,4 @@
 460 auto quick rw
 461 auto shutdown stress
 462 auto quick dax
+463 auto rw
-- 
2.13.6

