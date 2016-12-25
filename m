Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:36306 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750967AbcLYSKA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Dec 2016 13:10:00 -0500
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 1/3] xfs/348: test handling of invalid inode modes
Date: Sun, 25 Dec 2016 20:09:34 +0200
Message-Id: <1482689376-23553-2-git-send-email-amir73il@gmail.com>
In-Reply-To: <1482689376-23553-1-git-send-email-amir73il@gmail.com>
References: <1482689376-23553-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Set all possible file type values for different types of files
and verify that xfs_repair detects the correct errors.

When setting invalid file type values (e.g. core.mode = 0170644),
all files are expected to have been junked by xfs_repair.

When setting valid file type values to non matching file types,
xfs_repair would either detect wrong format and junk the file, e.g.:
  would have junked entry "FILE" in directory PARENT_INO
or detect a ftype mismatch error, e.g.:
  would fix ftype mismatch (5/3) in directory/child PARENT_INO/FIFO_INO

If ftype feature is enabled, when setting file type to one of the
special types (i.e. FIFO(1), CHRDEV(2),BLKDEV(6),SOCKET(14)),
xfs_repair is expected to detect ftype mismatch error. Otherewise,
xfs_repair is not expected to detect ftype mismatch error.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/xfs/348     | 128 ++++++++++++++++++++++++++++++++
 tests/xfs/348.out | 216 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/group   |   1 +
 3 files changed, 345 insertions(+)
 create mode 100755 tests/xfs/348
 create mode 100644 tests/xfs/348.out

diff --git a/tests/xfs/348 b/tests/xfs/348
new file mode 100755
index 0000000..9ec696a
--- /dev/null
+++ b/tests/xfs/348
@@ -0,0 +1,128 @@
+#! /bin/bash
+# FSQA Test No. 348
+#
+# Test handling of invalid inode modes
+#
+# Set all possible file type values for different types of files
+# and verify that xfs_repair detects the correct errors.
+#
+#-----------------------------------------------------------------------
+#
+# Copyright (C) 2016 CTERA Networks. All Rights Reserved.
+# Author: Amir Goldstein <amir73il@gmail.com>
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
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/repair
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+
+_scratch_mount
+
+# Create our test files.
+testdir=$SCRATCH_MNT/test
+mkdir -p $testdir
+mkdir $testdir/DIR
+echo 123 > $testdir/FILE
+ln -s $testdir/FILE $testdir/SYMLINK
+mknod $testdir/CHRDEV c 1 1
+mknod $testdir/BLKDEV b 1 1
+mknod $testdir/FIFO p
+
+xfs_info $SCRATCH_MNT | grep -q "ftype=1" && FTYPE_FEATURE=1
+
+# Record test dir inode for xfs_repair filter
+inode_filter=$tmp.sed
+rm -f $inode_filter
+pino=$(ls -id $testdir | awk '{print $1}')
+echo "s/inode $pino/PARENT_INO/" >> $inode_filter
+echo "s/directory $pino/directory PARENT_INO/" >> $inode_filter
+
+inodes=""
+# Record inode numbers for xfs_db commands and xfs_repair filter
+for f in DIR FILE SYMLINK CHRDEV BLKDEV FIFO; do
+	ino=$(ls -id $testdir/$f | awk '{print $1}')
+	inodes="$inodes $ino"
+	echo "s/inode $ino/${f}_INO/" >> $inode_filter
+done
+
+_scratch_unmount
+
+# Possible mode file type values (mode & S_IFMT) >> 12
+dtypes="0 1 2 3 4 5 6 7 10 11 12 13 14 15 16 17"
+echo "===== Find inode by file type:"
+for dt in $dtypes; do
+	# Set all our test files to dt value
+	for ino in $inodes; do
+		_scratch_xfs_db -c "inode $ino" -c "print core.mode" | \
+			grep -q "0${dt}0...$" && \
+			(echo "dt=$dt => inode $ino" | sed -f $inode_filter)
+	done
+done
+for dt in $dtypes; do
+	echo
+	echo "===== Setting dt=$dt to all files:"
+	# Set all our test files to dt value
+	for ino in $inodes; do
+		_scratch_xfs_db -x -c "inode $ino" -c "write core.mode 0${dt}0644"
+	done
+	# Repair should detect the inconsistencies
+	# For invalid dt values, all files would have been junked.
+	# For valid dt values, one test file is expected to be valid.
+	# The rest would either have wrong format or non matching dir ftype.
+	_scratch_xfs_repair -n 2>&1  | tee -a $seqres.full | \
+		_filter_repair | grep "^would have junked" | sed -f $inode_filter | sort -u
+	# If ftype feature is enabled, when setting file type to one of the
+	# special types (i.e. FIFO(1), CHRDEV(2),BLKDEV(6),SOCKET(14)),
+	# xfs_repair is expected to detect ftype mismatch error. Otherewise,
+	# xfs_repair is not expected to detect ftype mismatch error.
+	if [ "$FTYPE_FEATURE" = 1 ] && (echo ':1:2:6:14:' | grep -q ":$dt:"); then
+		_scratch_xfs_repair -n 2>&1 | grep -q "^would fix ftype mismatch" || \
+			_fail "xfs_repair should fix ftype mismatch"
+	else
+		_scratch_xfs_repair -n 2>&1 | grep -q -v "^would fix ftype mismatch" || \
+			_fail "xfs_repair should not fix ftype mismatch"
+	fi
+done
+
+# Repair should detect and junk all test files
+_scratch_xfs_repair 2>&1 >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/348.out b/tests/xfs/348.out
new file mode 100644
index 0000000..bf4924b
--- /dev/null
+++ b/tests/xfs/348.out
@@ -0,0 +1,216 @@
+QA output created by 348
+===== Find inode by file type:
+dt=1 => FIFO_INO
+dt=2 => CHRDEV_INO
+dt=4 => DIR_INO
+dt=6 => BLKDEV_INO
+dt=10 => FILE_INO
+dt=12 => SYMLINK_INO
+
+===== Setting dt=0 to all files:
+core.mode = 0644
+core.mode = 0644
+core.mode = 0644
+core.mode = 0644
+core.mode = 0644
+core.mode = 0644
+would have junked entry "BLKDEV" in directory PARENT_INO
+would have junked entry "CHRDEV" in directory PARENT_INO
+would have junked entry "DIR" in directory PARENT_INO
+would have junked entry "FIFO" in directory PARENT_INO
+would have junked entry "FILE" in directory PARENT_INO
+would have junked entry "SYMLINK" in directory PARENT_INO
+
+===== Setting dt=1 to all files:
+core.mode = 010644
+core.mode = 010644
+core.mode = 010644
+core.mode = 010644
+core.mode = 010644
+core.mode = 010644
+would have junked entry "DIR" in directory PARENT_INO
+would have junked entry "FILE" in directory PARENT_INO
+would have junked entry "SYMLINK" in directory PARENT_INO
+
+===== Setting dt=2 to all files:
+core.mode = 020644
+core.mode = 020644
+core.mode = 020644
+core.mode = 020644
+core.mode = 020644
+core.mode = 020644
+would have junked entry "DIR" in directory PARENT_INO
+would have junked entry "FILE" in directory PARENT_INO
+would have junked entry "SYMLINK" in directory PARENT_INO
+
+===== Setting dt=3 to all files:
+core.mode = 030644
+core.mode = 030644
+core.mode = 030644
+core.mode = 030644
+core.mode = 030644
+core.mode = 030644
+would have junked entry "BLKDEV" in directory PARENT_INO
+would have junked entry "CHRDEV" in directory PARENT_INO
+would have junked entry "DIR" in directory PARENT_INO
+would have junked entry "FIFO" in directory PARENT_INO
+would have junked entry "FILE" in directory PARENT_INO
+would have junked entry "SYMLINK" in directory PARENT_INO
+
+===== Setting dt=4 to all files:
+core.mode = 040644
+core.mode = 040644
+core.mode = 040644
+core.mode = 040644
+core.mode = 040644
+core.mode = 040644
+would have junked entry "BLKDEV" in directory PARENT_INO
+would have junked entry "CHRDEV" in directory PARENT_INO
+would have junked entry "FIFO" in directory PARENT_INO
+would have junked entry "FILE" in directory PARENT_INO
+
+===== Setting dt=5 to all files:
+core.mode = 050644
+core.mode = 050644
+core.mode = 050644
+core.mode = 050644
+core.mode = 050644
+core.mode = 050644
+would have junked entry "BLKDEV" in directory PARENT_INO
+would have junked entry "CHRDEV" in directory PARENT_INO
+would have junked entry "DIR" in directory PARENT_INO
+would have junked entry "FIFO" in directory PARENT_INO
+would have junked entry "FILE" in directory PARENT_INO
+would have junked entry "SYMLINK" in directory PARENT_INO
+
+===== Setting dt=6 to all files:
+core.mode = 060644
+core.mode = 060644
+core.mode = 060644
+core.mode = 060644
+core.mode = 060644
+core.mode = 060644
+would have junked entry "DIR" in directory PARENT_INO
+would have junked entry "FILE" in directory PARENT_INO
+would have junked entry "SYMLINK" in directory PARENT_INO
+
+===== Setting dt=7 to all files:
+core.mode = 070644
+core.mode = 070644
+core.mode = 070644
+core.mode = 070644
+core.mode = 070644
+core.mode = 070644
+would have junked entry "BLKDEV" in directory PARENT_INO
+would have junked entry "CHRDEV" in directory PARENT_INO
+would have junked entry "DIR" in directory PARENT_INO
+would have junked entry "FIFO" in directory PARENT_INO
+would have junked entry "FILE" in directory PARENT_INO
+would have junked entry "SYMLINK" in directory PARENT_INO
+
+===== Setting dt=10 to all files:
+core.mode = 0100644
+core.mode = 0100644
+core.mode = 0100644
+core.mode = 0100644
+core.mode = 0100644
+core.mode = 0100644
+would have junked entry "BLKDEV" in directory PARENT_INO
+would have junked entry "CHRDEV" in directory PARENT_INO
+would have junked entry "DIR" in directory PARENT_INO
+would have junked entry "FIFO" in directory PARENT_INO
+would have junked entry "SYMLINK" in directory PARENT_INO
+
+===== Setting dt=11 to all files:
+core.mode = 0110644
+core.mode = 0110644
+core.mode = 0110644
+core.mode = 0110644
+core.mode = 0110644
+core.mode = 0110644
+would have junked entry "BLKDEV" in directory PARENT_INO
+would have junked entry "CHRDEV" in directory PARENT_INO
+would have junked entry "DIR" in directory PARENT_INO
+would have junked entry "FIFO" in directory PARENT_INO
+would have junked entry "FILE" in directory PARENT_INO
+would have junked entry "SYMLINK" in directory PARENT_INO
+
+===== Setting dt=12 to all files:
+core.mode = 0120644
+core.mode = 0120644
+core.mode = 0120644
+core.mode = 0120644
+core.mode = 0120644
+core.mode = 0120644
+would have junked entry "BLKDEV" in directory PARENT_INO
+would have junked entry "CHRDEV" in directory PARENT_INO
+would have junked entry "DIR" in directory PARENT_INO
+would have junked entry "FIFO" in directory PARENT_INO
+would have junked entry "FILE" in directory PARENT_INO
+
+===== Setting dt=13 to all files:
+core.mode = 0130644
+core.mode = 0130644
+core.mode = 0130644
+core.mode = 0130644
+core.mode = 0130644
+core.mode = 0130644
+would have junked entry "BLKDEV" in directory PARENT_INO
+would have junked entry "CHRDEV" in directory PARENT_INO
+would have junked entry "DIR" in directory PARENT_INO
+would have junked entry "FIFO" in directory PARENT_INO
+would have junked entry "FILE" in directory PARENT_INO
+would have junked entry "SYMLINK" in directory PARENT_INO
+
+===== Setting dt=14 to all files:
+core.mode = 0140644
+core.mode = 0140644
+core.mode = 0140644
+core.mode = 0140644
+core.mode = 0140644
+core.mode = 0140644
+would have junked entry "DIR" in directory PARENT_INO
+would have junked entry "FILE" in directory PARENT_INO
+would have junked entry "SYMLINK" in directory PARENT_INO
+
+===== Setting dt=15 to all files:
+core.mode = 0150644
+core.mode = 0150644
+core.mode = 0150644
+core.mode = 0150644
+core.mode = 0150644
+core.mode = 0150644
+would have junked entry "BLKDEV" in directory PARENT_INO
+would have junked entry "CHRDEV" in directory PARENT_INO
+would have junked entry "DIR" in directory PARENT_INO
+would have junked entry "FIFO" in directory PARENT_INO
+would have junked entry "FILE" in directory PARENT_INO
+would have junked entry "SYMLINK" in directory PARENT_INO
+
+===== Setting dt=16 to all files:
+core.mode = 0160644
+core.mode = 0160644
+core.mode = 0160644
+core.mode = 0160644
+core.mode = 0160644
+core.mode = 0160644
+would have junked entry "BLKDEV" in directory PARENT_INO
+would have junked entry "CHRDEV" in directory PARENT_INO
+would have junked entry "DIR" in directory PARENT_INO
+would have junked entry "FIFO" in directory PARENT_INO
+would have junked entry "FILE" in directory PARENT_INO
+would have junked entry "SYMLINK" in directory PARENT_INO
+
+===== Setting dt=17 to all files:
+core.mode = 0170644
+core.mode = 0170644
+core.mode = 0170644
+core.mode = 0170644
+core.mode = 0170644
+core.mode = 0170644
+would have junked entry "BLKDEV" in directory PARENT_INO
+would have junked entry "CHRDEV" in directory PARENT_INO
+would have junked entry "DIR" in directory PARENT_INO
+would have junked entry "FIFO" in directory PARENT_INO
+would have junked entry "FILE" in directory PARENT_INO
+would have junked entry "SYMLINK" in directory PARENT_INO
diff --git a/tests/xfs/group b/tests/xfs/group
index c237b50..68c2bb6 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -334,3 +334,4 @@
 345 auto quick clone
 346 auto quick clone
 347 auto quick clone
+348 auto quick repair
-- 
2.7.4

