Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7DE2829EA1
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:11:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C803EAC003
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:11:58 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id LRDlodZ8yW8LXJfa (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:11:49 -0800 (PST)
Subject: [PATCH 08/11] reflink: more CoW tests for reflink and dedupe
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:11:45 -0800
Message-ID: <20151219091145.15320.47370.stgit@birch.djwong.org>
In-Reply-To: <20151219091052.15320.94973.stgit@birch.djwong.org>
References: <20151219091052.15320.94973.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

These tests examine the behavior of advanced and tricky copy on write
situations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/851     |  101 ++++++++++++++++++++++++++++++++++
 tests/generic/851.out |   15 +++++
 tests/generic/852     |  101 ++++++++++++++++++++++++++++++++++
 tests/generic/852.out |   15 +++++
 tests/generic/853     |  146 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/853.out |   15 +++++
 tests/generic/854     |  146 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/854.out |   15 +++++
 tests/generic/855     |   96 ++++++++++++++++++++++++++++++++
 tests/generic/855.out |   13 ++++
 tests/generic/856     |   96 ++++++++++++++++++++++++++++++++
 tests/generic/856.out |   13 ++++
 tests/generic/857     |   96 ++++++++++++++++++++++++++++++++
 tests/generic/857.out |   13 ++++
 tests/generic/858     |   96 ++++++++++++++++++++++++++++++++
 tests/generic/858.out |   13 ++++
 tests/generic/859     |  101 ++++++++++++++++++++++++++++++++++
 tests/generic/859.out |   13 ++++
 tests/generic/860     |  101 ++++++++++++++++++++++++++++++++++
 tests/generic/860.out |   13 ++++
 tests/generic/861     |   96 ++++++++++++++++++++++++++++++++
 tests/generic/861.out |   13 ++++
 tests/generic/862     |   96 ++++++++++++++++++++++++++++++++
 tests/generic/862.out |   13 ++++
 tests/generic/863     |  125 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/863.out |   13 ++++
 tests/generic/864     |  125 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/864.out |   13 ++++
 tests/generic/865     |   86 +++++++++++++++++++++++++++++
 tests/generic/865.out |    9 +++
 tests/generic/866     |   86 +++++++++++++++++++++++++++++
 tests/generic/866.out |   13 ++++
 tests/generic/867     |   86 +++++++++++++++++++++++++++++
 tests/generic/867.out |   13 ++++
 tests/generic/group   |   17 ++++++
 35 files changed, 2022 insertions(+)
 create mode 100755 tests/generic/851
 create mode 100644 tests/generic/851.out
 create mode 100755 tests/generic/852
 create mode 100644 tests/generic/852.out
 create mode 100755 tests/generic/853
 create mode 100644 tests/generic/853.out
 create mode 100755 tests/generic/854
 create mode 100644 tests/generic/854.out
 create mode 100755 tests/generic/855
 create mode 100644 tests/generic/855.out
 create mode 100755 tests/generic/856
 create mode 100644 tests/generic/856.out
 create mode 100755 tests/generic/857
 create mode 100644 tests/generic/857.out
 create mode 100755 tests/generic/858
 create mode 100644 tests/generic/858.out
 create mode 100755 tests/generic/859
 create mode 100644 tests/generic/859.out
 create mode 100755 tests/generic/860
 create mode 100644 tests/generic/860.out
 create mode 100755 tests/generic/861
 create mode 100644 tests/generic/861.out
 create mode 100755 tests/generic/862
 create mode 100644 tests/generic/862.out
 create mode 100755 tests/generic/863
 create mode 100644 tests/generic/863.out
 create mode 100755 tests/generic/864
 create mode 100644 tests/generic/864.out
 create mode 100755 tests/generic/865
 create mode 100644 tests/generic/865.out
 create mode 100755 tests/generic/866
 create mode 100644 tests/generic/866.out
 create mode 100755 tests/generic/867
 create mode 100644 tests/generic/867.out


diff --git a/tests/generic/851 b/tests/generic/851
new file mode 100755
index 0000000..62db9a4
--- /dev/null
+++ b/tests/generic/851
@@ -0,0 +1,101 @@
+#! /bin/bash
+# FS QA Test No. 851
+#
+# Ensuring that copy on write in direct-io mode works when the CoW
+# range originally covers multiple extents.
+#   - Create two files
+#   - Reflink the odd blocks of the first file into a third file.
+#   - Reflink the even blocks of the second file into the third file.
+#   - directio CoW across the halfway mark.
+#   - Check that the files are now different where we say they're different.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ=65536
+NR=64
+_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((BLKSZ * NR)) "$TESTDIR/file2" >> "$seqres.full"
+seq 0 2 $((NR-1)) | while read f; do
+	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+seq 1 2 $NR | while read f; do
+	_reflink_range "$TESTDIR/file2" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file2" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "directio CoW across the transition"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file2" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/851.out b/tests/generic/851.out
new file mode 100644
index 0000000..8ca4a05
--- /dev/null
+++ b/tests/generic/851.out
@@ -0,0 +1,15 @@
+QA output created by 851
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-851/file1
+b83f9394092e15bdcda585cd8e776dc6  SCRATCH_MNT/test-851/file2
+d3959a68638c50af07f0258e032cb554  SCRATCH_MNT/test-851/file3
+d3959a68638c50af07f0258e032cb554  SCRATCH_MNT/test-851/file3.chk
+directio CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-851/file1
+b83f9394092e15bdcda585cd8e776dc6  SCRATCH_MNT/test-851/file2
+55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-851/file3
+55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-851/file3.chk
+Check for damage
diff --git a/tests/generic/852 b/tests/generic/852
new file mode 100755
index 0000000..c48ec16
--- /dev/null
+++ b/tests/generic/852
@@ -0,0 +1,101 @@
+#! /bin/bash
+# FS QA Test No. 852
+#
+# Ensuring that copy on write in buffered mode works when the CoW
+# range originally covers multiple extents.
+#   - Create two files
+#   - Reflink the odd blocks of the first file into a third file.
+#   - Reflink the even blocks of the second file into the third file.
+#   - CoW across the halfway mark.
+#   - Check that the files are now different where we say they're different.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ=65536
+NR=64
+_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((BLKSZ * NR)) "$TESTDIR/file2" >> "$seqres.full"
+seq 0 2 $((NR-1)) | while read f; do
+	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+seq 1 2 $NR | while read f; do
+	_reflink_range "$TESTDIR/file2" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file2" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "CoW across the transition"
+_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file2" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/852.out b/tests/generic/852.out
new file mode 100644
index 0000000..02b5854
--- /dev/null
+++ b/tests/generic/852.out
@@ -0,0 +1,15 @@
+QA output created by 852
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-852/file1
+b83f9394092e15bdcda585cd8e776dc6  SCRATCH_MNT/test-852/file2
+d3959a68638c50af07f0258e032cb554  SCRATCH_MNT/test-852/file3
+d3959a68638c50af07f0258e032cb554  SCRATCH_MNT/test-852/file3.chk
+CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-852/file1
+b83f9394092e15bdcda585cd8e776dc6  SCRATCH_MNT/test-852/file2
+55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-852/file3
+55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-852/file3.chk
+Check for damage
diff --git a/tests/generic/853 b/tests/generic/853
new file mode 100755
index 0000000..433c1ee
--- /dev/null
+++ b/tests/generic/853
@@ -0,0 +1,146 @@
+#! /bin/bash
+# FS QA Test No. 853
+#
+# Ensuring that copy on write in buffered mode works when free space
+# is heavily fragmented.
+#   - Create two files
+#   - Reflink the odd blocks of the first file into a third file.
+#   - Reflink the even blocks of the second file into the third file.
+#   - Try to fragment the free space by allocating a huge file and
+#     punching out every other block.
+#   - CoW across the halfway mark.
+#   - Check that the files are now different where we say they're different.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+#    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fpunch"
+test "$FSTYP" = "btrfs" && _notrun "Can't fragment free space on btrfs."
+
+rm -f "$seqres.full"
+
+_fragment_freesp()
+{
+	file="$1"
+
+	# consume nearly all available space (leave ~1MB)
+	avail=`_get_available_space $SCRATCH_MNT`
+	echo "$avail bytes left"
+	filesize=$((avail - 1048576))
+	$XFS_IO_PROG -fc "truncate $filesize" "$file"
+
+	chunks=20
+	chunksizemb=$((filesize / chunks / 1048576))
+	seq 1 $chunks | while read f; do
+		echo "$((f * chunksizemb)) file size $f / 20"
+		$XFS_IO_PROG -fc "falloc -k $(( (f - 1) * chunksizemb))m ${chunksizemb}m" "$file"
+	done
+
+	chunks=100
+	chunksizemb=$((filesize / chunks / 1048576))
+	seq 80 $chunks | while read f; do
+		echo "$((f * chunksizemb)) file size $f / $chunks"
+		$XFS_IO_PROG -fc "falloc -k $(( (f - 1) * chunksizemb))m ${chunksizemb}m" "$file"
+	done
+
+	filesizemb=$((filesize / 1048576))
+	$XFS_IO_PROG -fc "falloc -k 0 ${filesizemb}m" "$file"
+
+	# Try again anyway
+	avail=`_get_available_space $SCRATCH_MNT`
+	$XFS_IO_PROG -fc "pwrite -S 0x65 0 $avail" "${file}.${i}"
+
+	# Punch out whatever we need
+	seq 1 $((NR * 4)) | while read f; do
+		$XFS_IO_PROG -f -c "fpunch $((f * 2 * BLKSZ)) $BLKSZ" "$file"
+	done
+}
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ=65536
+NR=1024
+_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((BLKSZ * NR)) "$TESTDIR/file2" >> "$seqres.full"
+seq 0 2 $((NR-1)) | while read f; do
+	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+seq 1 2 $NR | while read f; do
+	_reflink_range "$TESTDIR/file2" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+_fragment_freesp "$TESTDIR/bigfile" >> "$seqres.full" 2>&1
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file2" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "CoW with multiple extents?"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file2" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/853.out b/tests/generic/853.out
new file mode 100644
index 0000000..06622de
--- /dev/null
+++ b/tests/generic/853.out
@@ -0,0 +1,15 @@
+QA output created by 853
+Format and mount
+Create the original files
+Compare files
+6488f52f2d2351fa5ca1f6410df8684d  SCRATCH_MNT/test-853/file1
+35219c511215d00a857243965ea5ed9c  SCRATCH_MNT/test-853/file2
+8d9ea4925db533da10a45d2919d8d2d9  SCRATCH_MNT/test-853/file3
+8d9ea4925db533da10a45d2919d8d2d9  SCRATCH_MNT/test-853/file3.chk
+CoW with multiple extents?
+Compare files
+6488f52f2d2351fa5ca1f6410df8684d  SCRATCH_MNT/test-853/file1
+35219c511215d00a857243965ea5ed9c  SCRATCH_MNT/test-853/file2
+1801718b8daeb8d3ad4900bd9137b3e8  SCRATCH_MNT/test-853/file3
+1801718b8daeb8d3ad4900bd9137b3e8  SCRATCH_MNT/test-853/file3.chk
+Check for damage
diff --git a/tests/generic/854 b/tests/generic/854
new file mode 100755
index 0000000..9776388
--- /dev/null
+++ b/tests/generic/854
@@ -0,0 +1,146 @@
+#! /bin/bash
+# FS QA Test No. 854
+#
+# Ensuring that copy on write in directio mode works when free space
+# is heavily fragmented.
+#   - Create two files
+#   - Reflink the odd blocks of the first file into a third file.
+#   - Reflink the even blocks of the second file into the third file.
+#   - Try to fragment the free space by allocating a huge file and
+#     punching out every other block.
+#   - CoW across the halfway mark.
+#   - Check that the files are now different where we say they're different.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+#    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fpunch"
+test "$FSTYP" = "btrfs" && _notrun "Can't fragment free space on btrfs."
+
+rm -f "$seqres.full"
+
+_fragment_freesp()
+{
+	file="$1"
+
+	# consume nearly all available space (leave ~1MB)
+	avail=`_get_available_space $SCRATCH_MNT`
+	echo "$avail bytes left"
+	filesize=$((avail - 1048576))
+	$XFS_IO_PROG -fc "truncate $filesize" "$file"
+
+	chunks=20
+	chunksizemb=$((filesize / chunks / 1048576))
+	seq 1 $chunks | while read f; do
+		echo "$((f * chunksizemb)) file size $f / 20"
+		$XFS_IO_PROG -fc "falloc -k $(( (f - 1) * chunksizemb))m ${chunksizemb}m" "$file"
+	done
+
+	chunks=100
+	chunksizemb=$((filesize / chunks / 1048576))
+	seq 80 $chunks | while read f; do
+		echo "$((f * chunksizemb)) file size $f / $chunks"
+		$XFS_IO_PROG -fc "falloc -k $(( (f - 1) * chunksizemb))m ${chunksizemb}m" "$file"
+	done
+
+	filesizemb=$((filesize / 1048576))
+	$XFS_IO_PROG -fc "falloc -k 0 ${filesizemb}m" "$file"
+
+	# Try again anyway
+	avail=`_get_available_space $SCRATCH_MNT`
+	$XFS_IO_PROG -fc "pwrite -S 0x65 0 $avail" "${file}.${i}"
+
+	# Punch out whatever we need
+	seq 1 $((NR * 4)) | while read f; do
+		$XFS_IO_PROG -f -c "fpunch $((f * 2 * BLKSZ)) $BLKSZ" "$file"
+	done
+}
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ=65536
+NR=1024
+_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((BLKSZ * NR)) "$TESTDIR/file2" >> "$seqres.full"
+seq 0 2 $((NR-1)) | while read f; do
+	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+seq 1 2 $NR | while read f; do
+	_reflink_range "$TESTDIR/file2" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+_fragment_freesp "$TESTDIR/bigfile" >> "$seqres.full" 2>&1
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file2" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "CoW with multiple extents?"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file2" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/854.out b/tests/generic/854.out
new file mode 100644
index 0000000..a96c8c4
--- /dev/null
+++ b/tests/generic/854.out
@@ -0,0 +1,15 @@
+QA output created by 854
+Format and mount
+Create the original files
+Compare files
+6488f52f2d2351fa5ca1f6410df8684d  SCRATCH_MNT/test-854/file1
+35219c511215d00a857243965ea5ed9c  SCRATCH_MNT/test-854/file2
+8d9ea4925db533da10a45d2919d8d2d9  SCRATCH_MNT/test-854/file3
+8d9ea4925db533da10a45d2919d8d2d9  SCRATCH_MNT/test-854/file3.chk
+CoW with multiple extents?
+Compare files
+6488f52f2d2351fa5ca1f6410df8684d  SCRATCH_MNT/test-854/file1
+35219c511215d00a857243965ea5ed9c  SCRATCH_MNT/test-854/file2
+1801718b8daeb8d3ad4900bd9137b3e8  SCRATCH_MNT/test-854/file3
+1801718b8daeb8d3ad4900bd9137b3e8  SCRATCH_MNT/test-854/file3.chk
+Check for damage
diff --git a/tests/generic/855 b/tests/generic/855
new file mode 100755
index 0000000..017be2e
--- /dev/null
+++ b/tests/generic/855
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FS QA Test No. 855
+#
+# Ensuring that copy on write in direct-io mode works when the CoW
+# range originally covers multiple extents, some unwritten, some not.
+#   - Create a file and fallocate a second file.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - directio CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ=65536
+NR=64
+_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * NR))" "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((BLKSZ * NR)) "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 0 2 $((NR-1)) | while read f; do
+	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "directio CoW across the transition"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/855.out b/tests/generic/855.out
new file mode 100644
index 0000000..ca3aaab
--- /dev/null
+++ b/tests/generic/855.out
@@ -0,0 +1,13 @@
+QA output created by 855
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-855/file1
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-855/file3
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-855/file3.chk
+directio CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-855/file1
+09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-855/file3
+09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-855/file3.chk
+Check for damage
diff --git a/tests/generic/856 b/tests/generic/856
new file mode 100755
index 0000000..dfaa491
--- /dev/null
+++ b/tests/generic/856
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FS QA Test No. 856
+#
+# Ensuring that copy on write in buffered mode works when the CoW
+# range originally covers multiple extents, some unwritten, some not.
+#   - Create a file and fallocate a second file.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ=65536
+NR=64
+_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * NR))" "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((BLKSZ * NR)) "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 0 2 $((NR-1)) | while read f; do
+	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "CoW across the transition"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/856.out b/tests/generic/856.out
new file mode 100644
index 0000000..41675db
--- /dev/null
+++ b/tests/generic/856.out
@@ -0,0 +1,13 @@
+QA output created by 856
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-856/file1
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-856/file3
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-856/file3.chk
+CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-856/file1
+09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-856/file3
+09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-856/file3.chk
+Check for damage
diff --git a/tests/generic/857 b/tests/generic/857
new file mode 100755
index 0000000..ddf7c50
--- /dev/null
+++ b/tests/generic/857
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FS QA Test No. 857
+#
+# Ensuring that copy on write in direct-io mode works when the CoW
+# range originally covers multiple extents, some holes, some not.
+#   - Create a file and truncate a second file.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - directio CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ=65536
+NR=64
+_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $((BLKSZ * NR))" "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((BLKSZ * NR)) "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 0 2 $((NR-1)) | while read f; do
+	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "directio CoW across the transition"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/857.out b/tests/generic/857.out
new file mode 100644
index 0000000..b82e365
--- /dev/null
+++ b/tests/generic/857.out
@@ -0,0 +1,13 @@
+QA output created by 857
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-857/file1
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-857/file3
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-857/file3.chk
+directio CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-857/file1
+09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-857/file3
+09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-857/file3.chk
+Check for damage
diff --git a/tests/generic/858 b/tests/generic/858
new file mode 100755
index 0000000..0a341d0
--- /dev/null
+++ b/tests/generic/858
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FS QA Test No. 858
+#
+# Ensuring that copy on write in buffered mode works when the CoW
+# range originally covers multiple extents, some holes, some not.
+#   - Create a file and truncate a second file.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ=65536
+NR=64
+_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $((BLKSZ * NR))" "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((BLKSZ * NR)) "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 0 2 $((NR-1)) | while read f; do
+	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "CoW across the transition"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/858.out b/tests/generic/858.out
new file mode 100644
index 0000000..171fb4b
--- /dev/null
+++ b/tests/generic/858.out
@@ -0,0 +1,13 @@
+QA output created by 858
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-858/file1
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-858/file3
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-858/file3.chk
+CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-858/file1
+09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-858/file3
+09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-858/file3.chk
+Check for damage
diff --git a/tests/generic/859 b/tests/generic/859
new file mode 100755
index 0000000..0929c2a
--- /dev/null
+++ b/tests/generic/859
@@ -0,0 +1,101 @@
+#! /bin/bash
+# FS QA Test No. 859
+#
+# Ensuring that copy on write in direct-io mode works when the CoW
+# range originally covers multiple extents, some delalloc, some not.
+#   - Create a file.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - Buffered write the even blocks of the second file.
+#   - directio CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ=65536
+NR=64
+_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $((BLKSZ * NR))" "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((BLKSZ * NR)) "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 0 2 $((NR-1)) | while read f; do
+	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "directio CoW across the transition"
+seq 1 2 $NR | while read f; do
+	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3" >> "$seqres.full"
+	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/859.out b/tests/generic/859.out
new file mode 100644
index 0000000..120da3c
--- /dev/null
+++ b/tests/generic/859.out
@@ -0,0 +1,13 @@
+QA output created by 859
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-859/file1
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-859/file3
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-859/file3.chk
+directio CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-859/file1
+55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-859/file3
+55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-859/file3.chk
+Check for damage
diff --git a/tests/generic/860 b/tests/generic/860
new file mode 100755
index 0000000..432f5ad
--- /dev/null
+++ b/tests/generic/860
@@ -0,0 +1,101 @@
+#! /bin/bash
+# FS QA Test No. 860
+#
+# Ensuring that copy on write in buffered mode works when the CoW
+# range originally covers multiple extents, some delalloc, some not.
+#   - Create a file.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - Buffered write the even blocks of the second file.
+#   - CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ=65536
+NR=64
+_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $((BLKSZ * NR))" "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((BLKSZ * NR)) "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 0 2 $((NR-1)) | while read f; do
+	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "CoW across the transition"
+seq 1 2 $NR | while read f; do
+	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3" >> "$seqres.full"
+	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/860.out b/tests/generic/860.out
new file mode 100644
index 0000000..69b3a96
--- /dev/null
+++ b/tests/generic/860.out
@@ -0,0 +1,13 @@
+QA output created by 860
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-860/file1
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-860/file3
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-860/file3.chk
+CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-860/file1
+55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-860/file3
+55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-860/file3.chk
+Check for damage
diff --git a/tests/generic/861 b/tests/generic/861
new file mode 100755
index 0000000..c011ab7
--- /dev/null
+++ b/tests/generic/861
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FS QA Test No. 861
+#
+# Ensuring that copy on write in direct-io mode works when the CoW
+# range originally covers multiple extents, some unwritten, some not.
+#   - Create two files.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - directio CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ=65536
+NR=64
+_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((BLKSZ * NR)) "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((BLKSZ * NR)) "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 0 2 $((NR-1)) | while read f; do
+	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "directio CoW across the transition"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/861.out b/tests/generic/861.out
new file mode 100644
index 0000000..70154ae
--- /dev/null
+++ b/tests/generic/861.out
@@ -0,0 +1,13 @@
+QA output created by 861
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-861/file1
+d3959a68638c50af07f0258e032cb554  SCRATCH_MNT/test-861/file3
+d3959a68638c50af07f0258e032cb554  SCRATCH_MNT/test-861/file3.chk
+directio CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-861/file1
+55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-861/file3
+55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-861/file3.chk
+Check for damage
diff --git a/tests/generic/862 b/tests/generic/862
new file mode 100755
index 0000000..034dfb1
--- /dev/null
+++ b/tests/generic/862
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FS QA Test No. 862
+#
+# Ensuring that copy on write in buffered mode works when the CoW
+# range originally covers multiple extents, some unwritten, some not.
+#   - Create two files.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ=65536
+NR=64
+_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((BLKSZ * NR)) "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((BLKSZ * NR)) "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 0 2 $((NR-1)) | while read f; do
+	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "CoW across the transition"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/862.out b/tests/generic/862.out
new file mode 100644
index 0000000..ad1dc8e
--- /dev/null
+++ b/tests/generic/862.out
@@ -0,0 +1,13 @@
+QA output created by 862
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-862/file1
+d3959a68638c50af07f0258e032cb554  SCRATCH_MNT/test-862/file3
+d3959a68638c50af07f0258e032cb554  SCRATCH_MNT/test-862/file3.chk
+CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-862/file1
+55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-862/file3
+55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-862/file3.chk
+Check for damage
diff --git a/tests/generic/863 b/tests/generic/863
new file mode 100755
index 0000000..4aa2a42
--- /dev/null
+++ b/tests/generic/863
@@ -0,0 +1,125 @@
+#! /bin/bash
+# FS QA Test No. 863
+#
+# Ensuring that copy on write in direct-io mode works when the CoW
+# range originally covers multiple extents, some unwritten, some not.
+#   - Create a file with the following repeating sequence of blocks:
+#     1. reflinked
+#     2. unwritten
+#     3. hole
+#     4. regular block
+#     5. delalloc
+#   - directio CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fpunch"
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ=65536
+NR=64
+_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $((BLKSZ * NR))" "$TESTDIR/file3" >> "$seqres.full"
+# 0 blocks are reflinked
+seq 0 5 $NR | while read f; do
+	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+sync
+# 1 blocks are unwritten
+seq 1 5 $NR | while read f; do
+	$XFS_IO_PROG -f -c "falloc $((BLKSZ * f)) $BLKSZ" "$TESTDIR/file3" >> "$seqres.full"
+	_pwrite_byte 0x00 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+sync
+# 2 blocks are holes
+seq 2 5 $NR | while read f; do
+	_pwrite_byte 0x00 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+# 3 blocks are regular
+seq 3 5 $NR | while read f; do
+	_pwrite_byte 0x71 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3" >> "$seqres.full"
+	_pwrite_byte 0x71 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+sync
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "directio CoW across the transition"
+# 4 blocks are delalloc (do later)
+seq 4 5 $NR | while read f; do
+	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3" >> "$seqres.full"
+	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+# now cow
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/863.out b/tests/generic/863.out
new file mode 100644
index 0000000..7cd4b2e
--- /dev/null
+++ b/tests/generic/863.out
@@ -0,0 +1,13 @@
+QA output created by 863
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-863/file1
+6366fd359371414186688a0ef6988893  SCRATCH_MNT/test-863/file3
+6366fd359371414186688a0ef6988893  SCRATCH_MNT/test-863/file3.chk
+directio CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-863/file1
+36f6b5317a9a921fc91175390ccf7f69  SCRATCH_MNT/test-863/file3
+36f6b5317a9a921fc91175390ccf7f69  SCRATCH_MNT/test-863/file3.chk
+Check for damage
diff --git a/tests/generic/864 b/tests/generic/864
new file mode 100755
index 0000000..899cf90
--- /dev/null
+++ b/tests/generic/864
@@ -0,0 +1,125 @@
+#! /bin/bash
+# FS QA Test No. 864
+#
+# Ensuring that copy on write in buffered mode works when the CoW
+# range originally covers multiple extents, some unwritten, some not.
+#   - Create a file with the following repeating sequence of blocks:
+#     1. reflinked
+#     2. unwritten
+#     3. hole
+#     4. regular block
+#     5. delalloc
+#   - CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fpunch"
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ=65536
+NR=64
+_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $((BLKSZ * NR))" "$TESTDIR/file3" >> "$seqres.full"
+# 0 blocks are reflinked
+seq 0 5 $NR | while read f; do
+	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+sync
+# 1 blocks are unwritten
+seq 1 5 $NR | while read f; do
+	$XFS_IO_PROG -f -c "falloc $((BLKSZ * f)) $BLKSZ" "$TESTDIR/file3" >> "$seqres.full"
+	_pwrite_byte 0x00 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+sync
+# 2 blocks are holes
+seq 2 5 $NR | while read f; do
+	_pwrite_byte 0x00 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+# 3 blocks are regular
+seq 3 5 $NR | while read f; do
+	_pwrite_byte 0x71 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3" >> "$seqres.full"
+	_pwrite_byte 0x71 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+sync
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "directio CoW across the transition"
+# 4 blocks are delalloc (do later)
+seq 4 5 $NR | while read f; do
+	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3" >> "$seqres.full"
+	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+# now cow
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/864.out b/tests/generic/864.out
new file mode 100644
index 0000000..b62ab33
--- /dev/null
+++ b/tests/generic/864.out
@@ -0,0 +1,13 @@
+QA output created by 864
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-864/file1
+6366fd359371414186688a0ef6988893  SCRATCH_MNT/test-864/file3
+6366fd359371414186688a0ef6988893  SCRATCH_MNT/test-864/file3.chk
+directio CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-864/file1
+36f6b5317a9a921fc91175390ccf7f69  SCRATCH_MNT/test-864/file3
+36f6b5317a9a921fc91175390ccf7f69  SCRATCH_MNT/test-864/file3.chk
+Check for damage
diff --git a/tests/generic/865 b/tests/generic/865
new file mode 100755
index 0000000..1527971
--- /dev/null
+++ b/tests/generic/865
@@ -0,0 +1,86 @@
+#! /bin/bash
+# FS QA Test No. 865
+#
+# See what happens if we dirty a lot of pages via CoW and immediately
+# unlink the file.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ=65536
+NR=64
+_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((BLKSZ * NR)) "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((BLKSZ * NR)) "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 0 2 $((NR-1)) | while read f; do
+	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file3.chk" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
+rm "$TESTDIR/file3"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/865.out b/tests/generic/865.out
new file mode 100644
index 0000000..c4837a1
--- /dev/null
+++ b/tests/generic/865.out
@@ -0,0 +1,9 @@
+QA output created by 865
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-865/file1
+d3959a68638c50af07f0258e032cb554  SCRATCH_MNT/test-865/file3
+d3959a68638c50af07f0258e032cb554  SCRATCH_MNT/test-865/file3.chk
+CoW and unmount
+Check for damage
diff --git a/tests/generic/866 b/tests/generic/866
new file mode 100755
index 0000000..3ebfb91
--- /dev/null
+++ b/tests/generic/866
@@ -0,0 +1,86 @@
+#! /bin/bash
+# FS QA Test No. 866
+#
+# See what happens if we CoW across not-block-aligned EOF.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ=65536
+_pwrite_byte 0x61 0 $((BLKSZ + 17)) "$TESTDIR/file1" >> "$seqres.full"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
+_pwrite_byte 0x61 0 $((BLKSZ + 17)) "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file2" | _filter_scratch
+md5sum "$TESTDIR/file2.chk" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) 17" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) 17" "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file2" | _filter_scratch
+md5sum "$TESTDIR/file2.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/866.out b/tests/generic/866.out
new file mode 100644
index 0000000..7782c58
--- /dev/null
+++ b/tests/generic/866.out
@@ -0,0 +1,13 @@
+QA output created by 866
+Format and mount
+Create the original files
+Compare files
+75f550706b7d54e6ae59a8220b532285  SCRATCH_MNT/test-866/file1
+75f550706b7d54e6ae59a8220b532285  SCRATCH_MNT/test-866/file2
+75f550706b7d54e6ae59a8220b532285  SCRATCH_MNT/test-866/file2.chk
+CoW and unmount
+Compare files
+75f550706b7d54e6ae59a8220b532285  SCRATCH_MNT/test-866/file1
+7cd112044b63b2c979f45e7c1e7cc85f  SCRATCH_MNT/test-866/file2
+7cd112044b63b2c979f45e7c1e7cc85f  SCRATCH_MNT/test-866/file2.chk
+Check for damage
diff --git a/tests/generic/867 b/tests/generic/867
new file mode 100755
index 0000000..87f220c
--- /dev/null
+++ b/tests/generic/867
@@ -0,0 +1,86 @@
+#! /bin/bash
+# FS QA Test No. 867
+#
+# See what happens if we DIO CoW across not-block-aligned EOF.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ=65536
+_pwrite_byte 0x61 0 $((BLKSZ + 17)) "$TESTDIR/file1" >> "$seqres.full"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
+_pwrite_byte 0x61 0 $((BLKSZ + 17)) "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file2" | _filter_scratch
+md5sum "$TESTDIR/file2.chk" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $BLKSZ $BLKSZ" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $BLKSZ $BLKSZ" "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file2" | _filter_scratch
+md5sum "$TESTDIR/file2.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/867.out b/tests/generic/867.out
new file mode 100644
index 0000000..9489e93
--- /dev/null
+++ b/tests/generic/867.out
@@ -0,0 +1,13 @@
+QA output created by 867
+Format and mount
+Create the original files
+Compare files
+75f550706b7d54e6ae59a8220b532285  SCRATCH_MNT/test-867/file1
+75f550706b7d54e6ae59a8220b532285  SCRATCH_MNT/test-867/file2
+75f550706b7d54e6ae59a8220b532285  SCRATCH_MNT/test-867/file2.chk
+CoW and unmount
+Compare files
+75f550706b7d54e6ae59a8220b532285  SCRATCH_MNT/test-867/file1
+227f44bb2dcf251ebf0217edaeb1e365  SCRATCH_MNT/test-867/file2
+227f44bb2dcf251ebf0217edaeb1e365  SCRATCH_MNT/test-867/file2.chk
+Check for damage
diff --git a/tests/generic/group b/tests/generic/group
index bf33541..ea4901b 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -262,3 +262,20 @@
 848 auto quick clone
 849 auto quick clone
 850 auto quick clone
+851 auto quick clone
+852 auto quick clone
+853 auto quick clone
+854 auto quick clone
+855 auto quick clone
+856 auto quick clone
+857 auto quick clone
+858 auto quick clone
+859 auto quick clone
+860 auto quick clone
+861 auto quick clone
+862 auto quick clone
+863 auto quick clone
+864 auto quick clone
+865 auto quick clone
+866 auto quick clone
+867 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
