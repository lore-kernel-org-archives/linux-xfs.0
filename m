Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 017A029EAD
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:12:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ACF99304059
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:12:07 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id DqFPmnyU7HF9nnYo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:12:00 -0800 (PST)
Subject: [PATCH 09/11] reflink: test CoW with blocksize < pagesize
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:11:52 -0800
Message-ID: <20151219091152.15320.2176.stgit@birch.djwong.org>
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

Test CoW operations when blocksize < pagesize and the only reflink
block is in the middle of the page.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/reflink        |   30 +++++++++
 tests/generic/868     |  102 +++++++++++++++++++++++++++++++
 tests/generic/868.out |    7 ++
 tests/generic/869     |  102 +++++++++++++++++++++++++++++++
 tests/generic/869.out |    7 ++
 tests/generic/870     |  103 +++++++++++++++++++++++++++++++
 tests/generic/870.out |    7 ++
 tests/generic/871     |  103 +++++++++++++++++++++++++++++++
 tests/generic/871.out |    7 ++
 tests/generic/872     |   97 +++++++++++++++++++++++++++++
 tests/generic/872.out |    7 ++
 tests/generic/873     |   97 +++++++++++++++++++++++++++++
 tests/generic/873.out |    7 ++
 tests/generic/874     |  103 +++++++++++++++++++++++++++++++
 tests/generic/874.out |    7 ++
 tests/generic/875     |  103 +++++++++++++++++++++++++++++++
 tests/generic/875.out |    7 ++
 tests/generic/876     |  163 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/876.out |   83 +++++++++++++++++++++++++
 tests/generic/877     |  163 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/877.out |   83 +++++++++++++++++++++++++
 tests/generic/group   |   10 +++
 22 files changed, 1398 insertions(+)
 create mode 100755 tests/generic/868
 create mode 100644 tests/generic/868.out
 create mode 100755 tests/generic/869
 create mode 100644 tests/generic/869.out
 create mode 100755 tests/generic/870
 create mode 100644 tests/generic/870.out
 create mode 100755 tests/generic/871
 create mode 100644 tests/generic/871.out
 create mode 100755 tests/generic/872
 create mode 100644 tests/generic/872.out
 create mode 100755 tests/generic/873
 create mode 100644 tests/generic/873.out
 create mode 100755 tests/generic/874
 create mode 100644 tests/generic/874.out
 create mode 100755 tests/generic/875
 create mode 100644 tests/generic/875.out
 create mode 100755 tests/generic/876
 create mode 100644 tests/generic/876.out
 create mode 100755 tests/generic/877
 create mode 100644 tests/generic/877.out


diff --git a/common/reflink b/common/reflink
index eab7f66..de8e56d 100644
--- a/common/reflink
+++ b/common/reflink
@@ -183,3 +183,33 @@ _dedupe_range() {
 
 	"$XFS_IO_PROG" $xfs_io_args -f -c "dedupe $file1 $offset1 $offset2 $len" "$file2"
 }
+
+# Create fs of certain blocksize on scratch device
+# _scratch_mkfs_blocksized blocksize
+_scratch_mkfs_blocksized()
+{
+    blocksize=$1
+
+    re='^[0-9]+$'
+    if ! [[ $blocksize =~ $re ]] ; then
+        _notrun "error: _scratch_mkfs_sized: block size \"$blocksize\" not an integer."
+    fi
+
+    case $FSTYP in
+    xfs)
+	# don't override MKFS_OPTIONS that set a block size.
+	echo $MKFS_OPTIONS |egrep -q "b?size="
+	if [ $? -eq 0 ]; then
+		_scratch_mkfs_xfs
+	else
+		_scratch_mkfs_xfs -b size=$blocksize
+	fi
+	;;
+    ext2|ext3|ext4|ocfs2)
+	${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV
+	;;
+    *)
+	_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_blocksized"
+	;;
+    esac
+}
diff --git a/tests/generic/868 b/tests/generic/868
new file mode 100755
index 0000000..0de4f75
--- /dev/null
+++ b/tests/generic/868
@@ -0,0 +1,102 @@
+#! /bin/bash
+# FS QA Test No. 868
+#
+# See what happens if we CoW blocks 2-4 of a page's worth of blocks when the
+# second block is a regular block.
+#
+# This test is dependent on the system page size, so we cannot use md5 in
+# the golden output; we can only compare to a check file.
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
+PAGESZ=$(getconf PAGE_SIZE)
+BLKSZ=$((PAGESZ / 4))
+
+echo "Format and mount"
+_scratch_mkfs_blocksized $BLKSZ > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+REAL_BLKSZ=$(stat -f -c '%S' $TESTDIR)
+test "$REAL_BLKSZ" != "$BLKSZ" && _notrun "Failed to format with small blocksize."
+
+echo "Create the original files"
+_pwrite_byte 0x61 0 $PAGESZ "$TESTDIR/file1" >> "$seqres.full"
+
+"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 $BLKSZ $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x61 $BLKSZ $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+
+_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) $BLKSZ >> "$seqres.full"
+_pwrite_byte 0x61 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) $((BLKSZ * 3 - 34))" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) $((BLKSZ * 3 - 34))" "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/868.out b/tests/generic/868.out
new file mode 100644
index 0000000..d4a4e42
--- /dev/null
+++ b/tests/generic/868.out
@@ -0,0 +1,7 @@
+QA output created by 868
+Format and mount
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+Check for damage
diff --git a/tests/generic/869 b/tests/generic/869
new file mode 100755
index 0000000..b64407c
--- /dev/null
+++ b/tests/generic/869
@@ -0,0 +1,102 @@
+#! /bin/bash
+# FS QA Test No. 869
+#
+# See what happens if we DIO CoW blocks 2-4 of a page's worth of blocks when
+# the second block is a regular block.
+#
+# This test is dependent on the system page size, so we cannot use md5 in
+# the golden output; we can only compare to a check file.
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
+PAGESZ=$(getconf PAGE_SIZE)
+BLKSZ=$((PAGESZ / 4))
+
+echo "Format and mount"
+_scratch_mkfs_blocksized $BLKSZ > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+REAL_BLKSZ=$(stat -f -c '%S' $TESTDIR)
+test "$REAL_BLKSZ" != "$BLKSZ" && _notrun "Failed to format with small blocksize."
+
+echo "Create the original files"
+_pwrite_byte 0x61 0 $PAGESZ "$TESTDIR/file1" >> "$seqres.full"
+
+"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 $BLKSZ $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x61 $BLKSZ $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+
+_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) $BLKSZ >> "$seqres.full"
+_pwrite_byte 0x61 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $BLKSZ $((BLKSZ * 3))" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $BLKSZ $((BLKSZ * 3))" "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/869.out b/tests/generic/869.out
new file mode 100644
index 0000000..612da46
--- /dev/null
+++ b/tests/generic/869.out
@@ -0,0 +1,7 @@
+QA output created by 869
+Format and mount
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+Check for damage
diff --git a/tests/generic/870 b/tests/generic/870
new file mode 100755
index 0000000..3efb2d3
--- /dev/null
+++ b/tests/generic/870
@@ -0,0 +1,103 @@
+#! /bin/bash
+# FS QA Test No. 870
+#
+# See what happens if we CoW blocks 2-4 of a page's worth of blocks when the
+# second block is a unwritten block.
+#
+# This test is dependent on the system page size, so we cannot use md5 in
+# the golden output; we can only compare to a check file.
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
+PAGESZ=$(getconf PAGE_SIZE)
+BLKSZ=$((PAGESZ / 4))
+
+echo "Format and mount"
+_scratch_mkfs_blocksized $BLKSZ > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+REAL_BLKSZ=$(stat -f -c '%S' $TESTDIR)
+test "$REAL_BLKSZ" != "$BLKSZ" && _notrun "Failed to format with small blocksize."
+
+echo "Create the original files"
+_pwrite_byte 0x61 0 $PAGESZ "$TESTDIR/file1" >> "$seqres.full"
+
+"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2.chk" >> "$seqres.full"
+
+"$XFS_IO_PROG" -f -c "falloc -k $BLKSZ $BLKSZ" "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x00 $BLKSZ $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+
+"$XFS_IO_PROG" -f -c "falloc -k $((BLKSZ * 3)) $BLKSZ" "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x00 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+
+_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) $BLKSZ >> "$seqres.full"
+_pwrite_byte 0x61 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) $((BLKSZ * 3 - 34))" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) $((BLKSZ * 3 - 34))" "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/870.out b/tests/generic/870.out
new file mode 100644
index 0000000..d67b27c
--- /dev/null
+++ b/tests/generic/870.out
@@ -0,0 +1,7 @@
+QA output created by 870
+Format and mount
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+Check for damage
diff --git a/tests/generic/871 b/tests/generic/871
new file mode 100755
index 0000000..f0cc148
--- /dev/null
+++ b/tests/generic/871
@@ -0,0 +1,103 @@
+#! /bin/bash
+# FS QA Test No. 871
+#
+# See what happens if we DIO CoW blocks 2-4 of a page's worth of blocks when
+# the second block is a unwritten block.
+#
+# This test is dependent on the system page size, so we cannot use md5 in
+# the golden output; we can only compare to a check file.
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
+PAGESZ=$(getconf PAGE_SIZE)
+BLKSZ=$((PAGESZ / 4))
+
+echo "Format and mount"
+_scratch_mkfs_blocksized $BLKSZ > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+REAL_BLKSZ=$(stat -f -c '%S' $TESTDIR)
+test "$REAL_BLKSZ" != "$BLKSZ" && _notrun "Failed to format with small blocksize."
+
+echo "Create the original files"
+_pwrite_byte 0x61 0 $PAGESZ "$TESTDIR/file1" >> "$seqres.full"
+
+"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2.chk" >> "$seqres.full"
+
+"$XFS_IO_PROG" -f -c "falloc -k $BLKSZ $BLKSZ" "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x00 $BLKSZ $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+
+"$XFS_IO_PROG" -f -c "falloc -k $((BLKSZ * 3)) $BLKSZ" "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x00 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+
+_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) $BLKSZ >> "$seqres.full"
+_pwrite_byte 0x61 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $BLKSZ $((BLKSZ * 3))" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $BLKSZ $((BLKSZ * 3))" "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/871.out b/tests/generic/871.out
new file mode 100644
index 0000000..b2e20a4
--- /dev/null
+++ b/tests/generic/871.out
@@ -0,0 +1,7 @@
+QA output created by 871
+Format and mount
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+Check for damage
diff --git a/tests/generic/872 b/tests/generic/872
new file mode 100755
index 0000000..9ba0d71
--- /dev/null
+++ b/tests/generic/872
@@ -0,0 +1,97 @@
+#! /bin/bash
+# FS QA Test No. 872
+#
+# See what happens if we CoW blocks 2-4 of a page's worth of blocks when the
+# second block is a hole.
+#
+# This test is dependent on the system page size, so we cannot use md5 in
+# the golden output; we can only compare to a check file.
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
+PAGESZ=$(getconf PAGE_SIZE)
+BLKSZ=$((PAGESZ / 4))
+
+echo "Format and mount"
+_scratch_mkfs_blocksized $BLKSZ > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+REAL_BLKSZ=$(stat -f -c '%S' $TESTDIR)
+test "$REAL_BLKSZ" != "$BLKSZ" && _notrun "Failed to format with small blocksize."
+
+echo "Create the original files"
+_pwrite_byte 0x61 0 $PAGESZ "$TESTDIR/file1" >> "$seqres.full"
+
+"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2.chk" >> "$seqres.full"
+
+_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) $BLKSZ >> "$seqres.full"
+_pwrite_byte 0x61 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) $((BLKSZ * 3 - 34))" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) $((BLKSZ * 3 - 34))" "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/872.out b/tests/generic/872.out
new file mode 100644
index 0000000..40eff65
--- /dev/null
+++ b/tests/generic/872.out
@@ -0,0 +1,7 @@
+QA output created by 872
+Format and mount
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+Check for damage
diff --git a/tests/generic/873 b/tests/generic/873
new file mode 100755
index 0000000..589d12b
--- /dev/null
+++ b/tests/generic/873
@@ -0,0 +1,97 @@
+#! /bin/bash
+# FS QA Test No. 873
+#
+# See what happens if we DIO CoW blocks 2-4 of a page's worth of blocks when
+# the second block is a unwritten block.
+#
+# This test is dependent on the system page size, so we cannot use md5 in
+# the golden output; we can only compare to a check file.
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
+PAGESZ=$(getconf PAGE_SIZE)
+BLKSZ=$((PAGESZ / 4))
+
+echo "Format and mount"
+_scratch_mkfs_blocksized $BLKSZ > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+REAL_BLKSZ=$(stat -f -c '%S' $TESTDIR)
+test "$REAL_BLKSZ" != "$BLKSZ" && _notrun "Failed to format with small blocksize."
+
+echo "Create the original files"
+_pwrite_byte 0x61 0 $PAGESZ "$TESTDIR/file1" >> "$seqres.full"
+
+"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2.chk" >> "$seqres.full"
+
+_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) $BLKSZ >> "$seqres.full"
+_pwrite_byte 0x61 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $BLKSZ $((BLKSZ * 3))" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $BLKSZ $((BLKSZ * 3))" "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/873.out b/tests/generic/873.out
new file mode 100644
index 0000000..c6a5399
--- /dev/null
+++ b/tests/generic/873.out
@@ -0,0 +1,7 @@
+QA output created by 873
+Format and mount
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+Check for damage
diff --git a/tests/generic/874 b/tests/generic/874
new file mode 100755
index 0000000..e89b910
--- /dev/null
+++ b/tests/generic/874
@@ -0,0 +1,103 @@
+#! /bin/bash
+# FS QA Test No. 874
+#
+# See what happens if we CoW blocks 2-4 of a page's worth of blocks when the
+# second block is delalloc.
+#
+# This test is dependent on the system page size, so we cannot use md5 in
+# the golden output; we can only compare to a check file.
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
+PAGESZ=$(getconf PAGE_SIZE)
+BLKSZ=$((PAGESZ / 4))
+
+echo "Format and mount"
+_scratch_mkfs_blocksized $BLKSZ > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+REAL_BLKSZ=$(stat -f -c '%S' $TESTDIR)
+test "$REAL_BLKSZ" != "$BLKSZ" && _notrun "Failed to format with small blocksize."
+
+echo "Create the original files"
+_pwrite_byte 0x61 0 $PAGESZ "$TESTDIR/file1" >> "$seqres.full"
+
+"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2.chk" >> "$seqres.full"
+
+_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) $BLKSZ >> "$seqres.full"
+_pwrite_byte 0x61 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+
+echo "CoW and unmount"
+_pwrite_byte 0x61 $BLKSZ $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x61 $BLKSZ $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) $((BLKSZ * 3 - 34))" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) $((BLKSZ * 3 - 34))" "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/874.out b/tests/generic/874.out
new file mode 100644
index 0000000..0ded3bf
--- /dev/null
+++ b/tests/generic/874.out
@@ -0,0 +1,7 @@
+QA output created by 874
+Format and mount
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+Check for damage
diff --git a/tests/generic/875 b/tests/generic/875
new file mode 100755
index 0000000..d7ac31c
--- /dev/null
+++ b/tests/generic/875
@@ -0,0 +1,103 @@
+#! /bin/bash
+# FS QA Test No. 875
+#
+# See what happens if we DIO CoW blocks 2-4 of a page's worth of blocks when
+# the second block is delalloc.
+#
+# This test is dependent on the system page size, so we cannot use md5 in
+# the golden output; we can only compare to a check file.
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
+PAGESZ=$(getconf PAGE_SIZE)
+BLKSZ=$((PAGESZ / 4))
+
+echo "Format and mount"
+_scratch_mkfs_blocksized $BLKSZ > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+REAL_BLKSZ=$(stat -f -c '%S' $TESTDIR)
+test "$REAL_BLKSZ" != "$BLKSZ" && _notrun "Failed to format with small blocksize."
+
+echo "Create the original files"
+_pwrite_byte 0x61 0 $PAGESZ "$TESTDIR/file1" >> "$seqres.full"
+
+"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2.chk" >> "$seqres.full"
+
+_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) $BLKSZ >> "$seqres.full"
+_pwrite_byte 0x61 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+
+echo "CoW and unmount"
+_pwrite_byte 0x61 $BLKSZ $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x61 $BLKSZ $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $BLKSZ $((BLKSZ * 3))" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $BLKSZ $((BLKSZ * 3))" "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/875.out b/tests/generic/875.out
new file mode 100644
index 0000000..968fe4b
--- /dev/null
+++ b/tests/generic/875.out
@@ -0,0 +1,7 @@
+QA output created by 875
+Format and mount
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+Check for damage
diff --git a/tests/generic/876 b/tests/generic/876
new file mode 100755
index 0000000..c38690e
--- /dev/null
+++ b/tests/generic/876
@@ -0,0 +1,163 @@
+#! /bin/bash
+# FS QA Test No. 876
+#
+# See what happens if we CoW blocks 2-4 of a page's worth of blocks when the
+# surrounding blocks vary between unwritten/regular/delalloc/hole.
+#
+# This test is dependent on the system page size, so we cannot use md5 in
+# the golden output; we can only compare to a check file.
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
+PAGESZ=$(getconf PAGE_SIZE)
+BLKSZ=$((PAGESZ / 4))
+
+echo "Format and mount"
+_scratch_mkfs_blocksized $BLKSZ > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+REAL_BLKSZ=$(stat -f -c '%S' $TESTDIR)
+test "$REAL_BLKSZ" != "$BLKSZ" && _notrun "Failed to format with small blocksize."
+
+runtest() {
+	echo "runtest $1 $2"
+	b2=$1
+	b4=$2
+	dir=$3
+
+	echo "Create the original files"
+	mkdir -p "$dir"
+	_pwrite_byte 0x61 0 $PAGESZ "$dir/file1" >> "$seqres.full"
+
+	"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$dir/file2" >> "$seqres.full"
+	"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$dir/file2.chk" >> "$seqres.full"
+
+	case "$b2" in
+	"regular")
+		_pwrite_byte 0x61 $BLKSZ $BLKSZ "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x61 $BLKSZ $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+		;;
+	"unwritten")
+		"$XFS_IO_PROG" -f -c "falloc -k $BLKSZ $BLKSZ" "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x00 $BLKSZ $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+		;;
+	"hole")
+		;;
+	esac
+
+
+
+	case "$b4" in
+	"regular")
+		_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+		;;
+	"unwritten")
+		"$XFS_IO_PROG" -f -c "falloc -k $((BLKSZ * 3)) $BLKSZ" "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x00 $((BLKSZ * 3)) $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+		;;
+	"hole")
+		;;
+	esac
+
+	_reflink_range "$dir/file1" $BLKSZ "$dir/file2" $((BLKSZ * 2)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x61 $((BLKSZ * 2)) $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+	_scratch_remount
+
+	echo "Compare files"
+	! cmp -s "$dir/file1" "$dir/file2" || _fail "file1 and file2 don't match."
+	cmp -s "$dir/file2" "$dir/file2.chk" || _fail "file2 and file2.chk don't match."
+
+	echo "CoW and unmount"
+	if [ "$b2" = "delalloc" ]; then
+		_pwrite_byte 0x61 $BLKSZ $BLKSZ "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x61 $BLKSZ $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+	fi
+
+	if [ "$b4" = "delalloc" ]; then
+		_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+	fi
+
+	"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) $((BLKSZ * 3 - 34))" "$dir/file2" >> "$seqres.full"
+	"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) $((BLKSZ * 3 - 34))" "$dir/file2.chk" >> "$seqres.full"
+	_scratch_remount
+
+	echo "Compare files"
+	! cmp -s "$dir/file1" "$dir/file2" || _fail "file1 and file2 don't match."
+	cmp -s "$dir/file2" "$dir/file2.chk" || _fail "file2 and file2.chk don't match."
+}
+
+runtest regular delalloc "$TESTDIR/r-d"
+runtest regular unwritten "$TESTDIR/r-u"
+runtest regular hole "$TESTDIR/r-h"
+runtest regular regular "$TESTDIR/r-r"
+
+runtest hole delalloc "$TESTDIR/h-d"
+runtest hole unwritten "$TESTDIR/h-u"
+runtest hole hole "$TESTDIR/h-h"
+runtest hole regular "$TESTDIR/h-r"
+
+runtest unwritten delalloc "$TESTDIR/u-d"
+runtest unwritten unwritten "$TESTDIR/u-u"
+runtest unwritten hole "$TESTDIR/u-h"
+runtest unwritten regular "$TESTDIR/u-r"
+
+runtest delalloc delalloc "$TESTDIR/d-d"
+runtest delalloc unwritten "$TESTDIR/d-u"
+runtest delalloc hole "$TESTDIR/d-h"
+runtest delalloc regular "$TESTDIR/d-r"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/876.out b/tests/generic/876.out
new file mode 100644
index 0000000..b93781d
--- /dev/null
+++ b/tests/generic/876.out
@@ -0,0 +1,83 @@
+QA output created by 876
+Format and mount
+runtest regular delalloc
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest regular unwritten
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest regular hole
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest regular regular
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest hole delalloc
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest hole unwritten
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest hole hole
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest hole regular
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest unwritten delalloc
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest unwritten unwritten
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest unwritten hole
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest unwritten regular
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest delalloc delalloc
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest delalloc unwritten
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest delalloc hole
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest delalloc regular
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+Check for damage
diff --git a/tests/generic/877 b/tests/generic/877
new file mode 100755
index 0000000..dc063f9
--- /dev/null
+++ b/tests/generic/877
@@ -0,0 +1,163 @@
+#! /bin/bash
+# FS QA Test No. 877
+#
+# See what happens if we DIO CoW blocks 2-4 of a page's worth of blocks when
+# the surrounding blocks vary between unwritten/regular/delalloc/hole.
+#
+# This test is dependent on the system page size, so we cannot use md5 in
+# the golden output; we can only compare to a check file.
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
+PAGESZ=$(getconf PAGE_SIZE)
+BLKSZ=$((PAGESZ / 4))
+
+echo "Format and mount"
+_scratch_mkfs_blocksized $BLKSZ > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+REAL_BLKSZ=$(stat -f -c '%S' $TESTDIR)
+test "$REAL_BLKSZ" != "$BLKSZ" && _notrun "Failed to format with small blocksize."
+
+runtest() {
+	echo "runtest $1 $2"
+	b2=$1
+	b4=$2
+	dir=$3
+
+	echo "Create the original files"
+	mkdir -p "$dir"
+	_pwrite_byte 0x61 0 $PAGESZ "$dir/file1" >> "$seqres.full"
+
+	"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$dir/file2" >> "$seqres.full"
+	"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$dir/file2.chk" >> "$seqres.full"
+
+	case "$b2" in
+	"regular")
+		_pwrite_byte 0x61 $BLKSZ $BLKSZ "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x61 $BLKSZ $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+		;;
+	"unwritten")
+		"$XFS_IO_PROG" -f -c "falloc -k $BLKSZ $BLKSZ" "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x00 $BLKSZ $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+		;;
+	"hole")
+		;;
+	esac
+
+
+
+	case "$b4" in
+	"regular")
+		_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+		;;
+	"unwritten")
+		"$XFS_IO_PROG" -f -c "falloc -k $((BLKSZ * 3)) $BLKSZ" "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x00 $((BLKSZ * 3)) $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+		;;
+	"hole")
+		;;
+	esac
+
+	_reflink_range "$dir/file1" $BLKSZ "$dir/file2" $((BLKSZ * 2)) $BLKSZ >> "$seqres.full"
+	_pwrite_byte 0x61 $((BLKSZ * 2)) $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+	_scratch_remount
+
+	echo "Compare files"
+	! cmp -s "$dir/file1" "$dir/file2" || _fail "file1 and file2 don't match."
+	cmp -s "$dir/file2" "$dir/file2.chk" || _fail "file2 and file2.chk don't match."
+
+	echo "CoW and unmount"
+	if [ "$b2" = "delalloc" ]; then
+		_pwrite_byte 0x61 $BLKSZ $BLKSZ "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x61 $BLKSZ $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+	fi
+
+	if [ "$b4" = "delalloc" ]; then
+		_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+	fi
+
+	"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $BLKSZ $((BLKSZ * 3))" "$dir/file2" >> "$seqres.full"
+	"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $BLKSZ $((BLKSZ * 3))" "$dir/file2.chk" >> "$seqres.full"
+	_scratch_remount
+
+	echo "Compare files"
+	! cmp -s "$dir/file1" "$dir/file2" || _fail "file1 and file2 don't match."
+	cmp -s "$dir/file2" "$dir/file2.chk" || _fail "file2 and file2.chk don't match."
+}
+
+runtest regular delalloc "$TESTDIR/r-d"
+runtest regular unwritten "$TESTDIR/r-u"
+runtest regular hole "$TESTDIR/r-h"
+runtest regular regular "$TESTDIR/r-r"
+
+runtest hole delalloc "$TESTDIR/h-d"
+runtest hole unwritten "$TESTDIR/h-u"
+runtest hole hole "$TESTDIR/h-h"
+runtest hole regular "$TESTDIR/h-r"
+
+runtest unwritten delalloc "$TESTDIR/u-d"
+runtest unwritten unwritten "$TESTDIR/u-u"
+runtest unwritten hole "$TESTDIR/u-h"
+runtest unwritten regular "$TESTDIR/u-r"
+
+runtest delalloc delalloc "$TESTDIR/d-d"
+runtest delalloc unwritten "$TESTDIR/d-u"
+runtest delalloc hole "$TESTDIR/d-h"
+runtest delalloc regular "$TESTDIR/d-r"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/877.out b/tests/generic/877.out
new file mode 100644
index 0000000..b97ef2f
--- /dev/null
+++ b/tests/generic/877.out
@@ -0,0 +1,83 @@
+QA output created by 877
+Format and mount
+runtest regular delalloc
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest regular unwritten
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest regular hole
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest regular regular
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest hole delalloc
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest hole unwritten
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest hole hole
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest hole regular
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest unwritten delalloc
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest unwritten unwritten
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest unwritten hole
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest unwritten regular
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest delalloc delalloc
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest delalloc unwritten
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest delalloc hole
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+runtest delalloc regular
+Create the original files
+Compare files
+CoW and unmount
+Compare files
+Check for damage
diff --git a/tests/generic/group b/tests/generic/group
index ea4901b..f3e3e2c 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -279,3 +279,13 @@
 865 auto quick clone
 866 auto quick clone
 867 auto quick clone
+868 auto quick clone
+869 auto quick clone
+870 auto quick clone
+871 auto quick clone
+872 auto quick clone
+873 auto quick clone
+874 auto quick clone
+875 auto quick clone
+876 auto quick clone
+877 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
