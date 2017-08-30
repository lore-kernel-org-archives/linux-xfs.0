Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:37196 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751763AbdH3Ovk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 10:51:40 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 14/14] fstests: add crash consistency fsx test using dm-log-writes
Date: Wed, 30 Aug 2017 17:51:46 +0300
Message-Id: <1504104706-11965-15-git-send-email-amir73il@gmail.com>
In-Reply-To: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

DO NOT MERGE!!! this test fails most likely due to test bug.

The random seed values in this patch fail the test consistently on ext4
always with the same fsck error ((end of extent exceeds allowed value).
btrfs also fails, but with slightly different fsck errors each run.
xfs fails sometimes on file checksum error.

Cherry-picked the test from commit 70d41e17164b
in Josef Bacik's fstests tree (https://github.com/josefbacik/fstests).
Quoting from Josef's commit message:

  The test just runs some ops and exits, then finds all of the good buffers
  in the directory we provided and:
  - replays up to the mark given
  - mounts the file system and compares the md5sum
  - unmounts and fsck's to check for metadata integrity

  dm-log-writes will pretend to do discard and the replay-log tool will
  replay it properly depending on the underlying device, either by writing
  0's or actually calling the discard ioctl, so I've enabled discard in the
  test for maximum fun.

[Amir:]
- Removed unneeded _test_falloc_support dynamic FSX_OPTS
- Added place holders for using constant random seeds
- Add test to new 'replay' group

Cc: Josef Bacik <jbacik@fb.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/500     | 138 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/500.out |   2 +
 tests/generic/group   |   1 +
 3 files changed, 141 insertions(+)
 create mode 100755 tests/generic/500
 create mode 100644 tests/generic/500.out

diff --git a/tests/generic/500 b/tests/generic/500
new file mode 100755
index 0000000..81d45ef
--- /dev/null
+++ b/tests/generic/500
@@ -0,0 +1,138 @@
+#! /bin/bash
+# FS QA Test No. 500
+#
+# Run fsx with log writes to verify power fail safeness.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Facebook. All Rights Reserved.
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
+status=1	# failure is the default!
+
+_cleanup()
+{
+	_cleanup_log_writes
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmlogwrites
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_scratch_nocheck
+_require_log_writes
+
+rm -f $seqres.full
+rm -rf $TEST_DIR/fsxtests
+
+check_files()
+{
+	local _name=$1
+
+	# Now look for our files
+	for i in $(find $SANITY_DIR -type f | grep $_name | grep mark)
+	do
+		local filename=$(basename $i)
+		local mark="${filename##*.}"
+		local expected_size=$(_ls_l -h $i | awk '{ print $5 }')
+		echo "checking $filename ($expected_size)" >> $seqres.full
+		_replay_log $filename
+		_scratch_mount
+		local expected_md5=$(md5sum $i | cut -f 1 -d ' ')
+		local md5=$(md5sum $SCRATCH_MNT/$_name | cut -f 1 -d ' ')
+		local size=$(_ls_l -h $SCRATCH_MNT/$_name | awk '{ print $5 }')
+		[ "${md5}" != "${expected_md5}" ] && _fatal "$filename ($size) md5sum mismatched"
+		_scratch_unmount
+		_check_scratch_fs
+	done
+}
+
+SANITY_DIR=$TEST_DIR/fsxtests
+mkdir $SANITY_DIR
+
+# Create the log
+_init_log_writes
+
+_log_writes_mkfs >> $seqres.full 2>&1
+
+# Log writes emulates discard support, turn it on for maximum crying.
+_mount_log_writes -o discard
+
+NUM_FILES=4
+NUM_OPS=200
+FSX_OPTS="-N $NUM_OPS -d -P $SANITY_DIR -i $LOGWRITES_DMDEV"
+# Set random seeds for fsx runs (0 for timestamp + pid)
+seeds=(- 2885 2886 2887 2888)
+# Run fsx for a while
+for j in `seq 1 $NUM_FILES`
+do
+	run_check $here/ltp/fsx $FSX_OPTS -S ${seeds[$j]} -j $j $SCRATCH_MNT/testfile$j &
+done
+wait
+
+test_md5=()
+test_size=()
+for j in `seq 1 $NUM_FILES`
+do
+	test_md5[$j]=$(md5sum $SCRATCH_MNT/testfile$j | cut -f 1 -d ' ')
+	test_size[$j]=$(_ls_l -h $SCRATCH_MNT/testfile$j | awk '{ print $5 }')
+done
+
+# Unmount the scratch dir and tear down the log writes target
+_log_writes_mark last
+_unmount_log_writes
+_log_writes_mark end
+_log_writes_remove
+_check_scratch_fs
+
+# check pre umount
+_replay_log last
+_scratch_mount
+_scratch_unmount
+_check_scratch_fs
+
+for j in `seq 1 $NUM_FILES`
+do
+	check_files testfile$j
+done
+
+# Check the end
+_replay_log end
+_scratch_mount
+for j in `seq 1 $NUM_FILES`
+do
+	md5=$(md5sum $SCRATCH_MNT/testfile$j | cut -f 1 -d ' ')
+	size=$(_ls_l -h $SCRATCH_MNT/testfile$j | awk '{ print $5 }')
+	[ "${md5}" != "${test_md5[$j]}" ] && _fatal "testfile$j end md5sum mismatched ($size:${test_size[$j]})"
+done
+_scratch_unmount
+_check_scratch_fs
+
+echo "Silence is golden"
+status=0
+exit
+
diff --git a/tests/generic/500.out b/tests/generic/500.out
new file mode 100644
index 0000000..883b2ca
--- /dev/null
+++ b/tests/generic/500.out
@@ -0,0 +1,2 @@
+QA output created by 500
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 044ec3f..2396b72 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -453,3 +453,4 @@
 448 auto quick rw
 449 auto quick acl enospc
 450 auto quick rw
+500 auto log replay
-- 
2.7.4

