Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46743 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdKCE1U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 00:27:20 -0400
Date: Thu, 2 Nov 2017 21:27:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 14/14] generic: test IO at maximum file offset
Message-ID: <20171103042717.GC1233@magnolia>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
 <150957287448.18388.6362701157489515704.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150957287448.18388.6362701157489515704.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we can write to and read from the highest possible offset
that Linux will allow.  Format the filesystem with a variety of
possible blocksizes to stress the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: fixes suggested by eryu
---
 tests/generic/705     |   98 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/705.out |    2 +
 tests/generic/group   |    1 +
 3 files changed, 101 insertions(+)
 create mode 100755 tests/generic/705
 create mode 100644 tests/generic/705.out

diff --git a/tests/generic/705 b/tests/generic/705
new file mode 100755
index 0000000..18916c3
--- /dev/null
+++ b/tests/generic/705
@@ -0,0 +1,98 @@
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
+_require_scratch_nocheck
+
+rm -f $seqres.full
+
+echo "Silence is golden"
+
+echo "Starting test" > $seqres.full
+devsize=$(blockdev --getsize64 $SCRATCH_DEV)
+for blocksize in 512 1024 2048 4096 8192 16384 32768 65536; do
+	echo "+ Format blocksize $blocksize and mount" >> $seqres.full
+	_scratch_unmount > /dev/null 2>&1
+	# Try to format and mount with the given blocksize.  If they don't
+	# succeed, move on to the next block size.
+	unset MKFS_OPTIONS
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
+	bigoff=$(echo "2^63 - 2" | $BC_PROG)
+	len=$(echo "2^63 - 1" | $BC_PROG)
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
