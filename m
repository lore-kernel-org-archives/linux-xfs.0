Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20302 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933888AbdKAVsF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2017 17:48:05 -0400
Subject: [PATCH 14/14] generic: test IO at maximum file offset
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 01 Nov 2017 14:47:54 -0700
Message-ID: <150957287448.18388.6362701157489515704.stgit@magnolia>
In-Reply-To: <150957278824.18388.17975162441125293654.stgit@magnolia>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we can write to and read from the highest possible offset
that Linux will allow.  Format the filesystem with a variety of
possible blocksizes to stress the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/705     |   97 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/705.out |    2 +
 tests/generic/group   |    1 +
 3 files changed, 100 insertions(+)
 create mode 100755 tests/generic/705
 create mode 100644 tests/generic/705.out


diff --git a/tests/generic/705 b/tests/generic/705
new file mode 100755
index 0000000..4ab97e5
--- /dev/null
+++ b/tests/generic/705
@@ -0,0 +1,97 @@
+#! /bin/bash
+# FS QA Test No. 705
+#
+# Check that high-offset reads and writes work.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch
+
+rm -f $seqres.full
+
+echo "Silence is golden"
+
+echo "Starting test" > $seqres.full
+for blocksize in 512 1024 2048 4096 8192 16384 32768 65536; do
+	echo "+ Format blocksize $blocksize and mount" >> $seqres.full
+	devsize=$(blockdev --getsize64 $SCRATCH_DEV)
+	_scratch_unmount > /dev/null 2>&1
+	# Try to format and mount with the given blocksize.  If they don't
+	# succeed, move on to the next block size.
+	if ! _scratch_mkfs_sized $devsize $blocksize >> $seqres.full 2>&1 ||
+	   ! _scratch_mount >> $seqres.full 2>&1 ||
+	   test "$(stat -f -c '%S' $SCRATCH_MNT)" -ne "$blocksize"; then
+		echo "+++ Format and mount failed" >> $seqres.full
+		continue
+	fi
+
+	testdir=$SCRATCH_MNT/test-$seq
+	mkdir $testdir
+
+	echo "++ Create the original files" >> $seqres.full
+	bigoff=9223372036854775806
+	len=9223372036854775807
+	$XFS_IO_PROG -f -c "truncate $len" $testdir/file0 >> $seqres.full 2>&1
+	if [ ! -s $testdir/file0 ]; then
+		# If we can't set a large file size then don't bother
+		# with this blocksize because the fs doesn't support it.
+		echo "+++ High offset ftruncate failed" >> $seqres.full
+		continue
+	fi
+	_pwrite_byte 0x61 $bigoff 1 $testdir/file1 >> $seqres.full
+
+	echo "++ Check file creation" >> $seqres.full
+	_scratch_cycle_mount
+
+	expected="7ffffffffffffffe:  61  a"
+	actual="$($XFS_IO_PROG -c "pread -v -q $bigoff 1" $testdir/file1)"
+	if [ "$expected" = "$actual" ]; then
+		echo "+++ Success!" >> $seqres.full
+	else
+		echo "+++ Discrepancy @ blocksize $blocksize" >> $seqres.full
+		echo "Discrepancy @ blocksize $blocksize"
+	fi
+
+	echo "++ Check scratchfs" >> $seqres.full
+	_check_scratch_fs
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/705.out b/tests/generic/705.out
new file mode 100644
index 0000000..6fcdec0
--- /dev/null
+++ b/tests/generic/705.out
@@ -0,0 +1,2 @@
+QA output created by 705
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index fbe0a7f..2c55b93 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -468,3 +468,4 @@
 463 auto quick clone dangerous
 464 auto rw
 465 auto rw quick aio
+705 auto quick rw

