Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 44A8D7F5A
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 15:37:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 35EC5304032
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 13:37:37 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 2vIBF4vxJdRltIvg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Nov 2015 13:37:34 -0800 (PST)
Subject: [PATCH 03/12] reflink: add test support routines to a separate file
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 13 Nov 2015 13:37:03 -0800
Message-ID: <20151113213703.31124.57109.stgit@birch.djwong.org>
In-Reply-To: <20151113213643.31124.80975.stgit@birch.djwong.org>
References: <20151113213643.31124.80975.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

Put all the reflink/dedupe-related test support routines in a separate
file, then modify the existing reflink tests to use them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc         |   51 +++++++++------
 common/reflink    |  185 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/029   |    1 
 tests/btrfs/031   |    1 
 tests/btrfs/108   |    1 
 tests/btrfs/109   |    1 
 tests/generic/110 |    3 +
 tests/generic/111 |    3 +
 tests/generic/115 |    3 +
 9 files changed, 225 insertions(+), 24 deletions(-)
 create mode 100644 common/reflink


diff --git a/common/rc b/common/rc
index adf1edf..4c2f42c 100644
--- a/common/rc
+++ b/common/rc
@@ -82,6 +82,27 @@ _md5_checksum()
 	md5sum $1 | cut -d ' ' -f1
 }
 
+# Write a byte into a range of a file
+_pwrite_byte() {
+	pattern="$1"
+	offset="$2"
+	len="$3"
+	file="$4"
+	xfs_io_args="$5"
+
+	"$XFS_IO_PROG" $xfs_io_args -f -c "pwrite -S $pattern $offset $len" "$file"
+}
+
+# mmap-write a byte into a range of a file
+_mwrite_byte() {
+	pattern="$1"
+	offset="$2"
+	len="$3"
+	mmap_len="$4"
+	file="$5"
+
+	"$XFS_IO_PROG" -f -c "mmap -rw 0 $mmap_len" -c "mwrite -S $pattern $offset $len" "$file"
+}
 
 # ls -l w/ selinux sometimes puts a dot at the end:
 # -rwxrw-r--. id1 id2 file1
@@ -2569,12 +2590,6 @@ _require_ugid_map()
 	fi
 }
 
-_require_cp_reflink()
-{
-       cp --help | grep -q reflink || \
-               _notrun "This test requires a cp with --reflink support."
-}
-
 _require_fssum()
 {
 	FSSUM_PROG=$here/src/fssum
@@ -2588,21 +2603,6 @@ _require_cloner()
 		_notrun "cloner binary not present at $CLONER_PROG"
 }
 
-# Given 2 files, verify that they have the same mapping but different
-# inodes - i.e. an undisturbed reflink
-# Silent if so, make noise if not
-_verify_reflink()
-{
-       # not a hard link or symlink?
-       cmp -s  <(stat -c '%i' $1) <(stat -c '%i' $2) \
-               && echo "$1 and $2 are not reflinks: same inode number"
-
-       # same mapping?
-       diff -u <($XFS_IO_PROG -c "fiemap" $1 | grep -v $1) \
-               <($XFS_IO_PROG -c "fiemap" $2 | grep -v $2) \
-               || echo "$1 and $2 are not reflinks: different extents"
-}
-
 _require_atime()
 {
 	if [ "$FSTYP" == "nfs" ]; then
@@ -2764,6 +2764,15 @@ _require_btrfs_dev_del_by_devid()
 			"(must support 'btrfs device delete <devid> /<mnt>')"
 }
 
+_require_test_lsattr()
+{
+	testio=$(lsattr -d $TEST_DIR 2>&1)
+	echo $testio | grep -q "Operation not supported" && \
+		_notrun "lsattr not supported by test filesystem type: $FSTYP"
+	echo $testio | grep -q "Inappropriate ioctl for device" && \
+		_notrun "lsattr not supported by test filesystem type: $FSTYP"
+}
+
 _get_total_inode()
 {
 	if [ -z "$1" ]; then
diff --git a/common/reflink b/common/reflink
new file mode 100644
index 0000000..eab7f66
--- /dev/null
+++ b/common/reflink
@@ -0,0 +1,185 @@
+##/bin/bash
+# Routines for reflinking, deduping, and comparing parts of files.
+#-----------------------------------------------------------------------
+#  Copyright (c) 2015 Oracle.  All Rights Reserved.
+#  This program is free software; you can redistribute it and/or modify
+#  it under the terms of the GNU General Public License as published by
+#  the Free Software Foundation; either version 2 of the License, or
+#  (at your option) any later version.
+#
+#  This program is distributed in the hope that it will be useful,
+#  but WITHOUT ANY WARRANTY; without even the implied warranty of
+#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+#  GNU General Public License for more details.
+#
+#  You should have received a copy of the GNU General Public License
+#  along with this program; if not, write to the Free Software
+#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
+#  USA
+#
+#  Contact information: Oracle Corporation, 500 Oracle Parkway,
+#  Redwood Shores, CA 94065, USA, or: http://www.oracle.com/
+#-----------------------------------------------------------------------
+
+# Check that cp has a reflink argument
+_require_cp_reflink()
+{
+       cp --help | grep -q reflink || \
+               _notrun "This test requires a cp with --reflink support."
+}
+
+# Given 2 files, verify that they have the same mapping but different
+# inodes - i.e. an undisturbed reflink
+# Silent if so, make noise if not
+_verify_reflink()
+{
+       # not a hard link or symlink?
+       cmp -s  <(stat -c '%i' $1) <(stat -c '%i' $2) \
+               && echo "$1 and $2 are not reflinks: same inode number"
+
+       # same mapping?
+       diff -u <($XFS_IO_PROG -c "fiemap" $1 | grep -v $1) \
+               <($XFS_IO_PROG -c "fiemap" $2 | grep -v $2) \
+               || echo "$1 and $2 are not reflinks: different extents"
+}
+
+# New reflink/dedupe helpers
+
+# this test requires the test fs support reflink...
+_require_test_reflink()
+{
+	_require_test
+	_require_xfs_io_command "reflink"
+
+	rm -rf "$TEST_DIR/file1" "$TEST_DIR/file2"
+	"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 65536" "$TEST_DIR/file1" > /dev/null
+	"$XFS_IO_PROG" -f -c "reflink $TEST_DIR/file1 0 0 65536" "$TEST_DIR/file2" > /dev/null
+	if [ ! -s "$TEST_DIR/file2" ]; then
+		rm -rf "$TEST_DIR/file1" "$TEST_DIR/file2"
+		_notrun "Reflink not supported by test filesystem type: $FSTYP"
+	fi
+	rm -rf "$TEST_DIR/file1" "$TEST_DIR/file2"
+}
+
+# this test requires the scratch fs support reflink...
+_require_scratch_reflink()
+{
+	_require_scratch
+	_require_xfs_io_command "reflink"
+
+	_scratch_mkfs > /dev/null
+	_scratch_mount
+	"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 65536" "$SCRATCH_MNT/file1" > /dev/null
+	"$XFS_IO_PROG" -f -c "reflink $SCRATCH_MNT/file1 0 0 65536" "$SCRATCH_MNT/file2" > /dev/null
+	if [ ! -s "$SCRATCH_MNT/file2" ]; then
+		_scratch_unmount
+		_notrun "Reflink not supported by scratch filesystem type: $FSTYP"
+	fi
+	_scratch_unmount
+}
+
+# this test requires the test fs support dedupe...
+_require_test_dedupe()
+{
+	_require_test
+	_require_xfs_io_command "dedupe"
+
+	rm -rf "$TEST_DIR/file1" "$TEST_DIR/file2"
+	"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 65536" "$TEST_DIR/file1" > /dev/null
+	"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 65536" "$TEST_DIR/file2" > /dev/null
+	testio="$("$XFS_IO_PROG" -f -c "dedupe $TEST_DIR/file1 0 0 65536" "$TEST_DIR/file2" 2>&1)"
+	echo $testio | grep -q "Operation not supported" && \
+		_notrun "Dedupe not supported by test filesystem type: $FSTYP"
+	echo $testio | grep -q "Inappropriate ioctl for device" && \
+		_notrun "Dedupe not supported by test filesystem type: $FSTYP"
+	rm -rf "$TEST_DIR/file1" "$TEST_DIR/file2"
+}
+
+# this test requires the scratch fs support dedupe...
+_require_scratch_dedupe()
+{
+	_require_scratch
+	_require_xfs_io_command "dedupe"
+
+	_scratch_mkfs > /dev/null
+	_scratch_mount
+	"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 65536" "$SCRATCH_MNT/file1" > /dev/null
+	"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 65536" "$SCRATCH_MNT/file2" > /dev/null
+	testio="$("$XFS_IO_PROG" -f -c "dedupe $TEST_DIR/file1 0 0 65536" "$TEST_DIR/file2" 2>&1)"
+	echo $testio | grep -q "Operation not supported" && \
+		_notrun "Dedupe not supported by test filesystem type: $FSTYP"
+	echo $testio | grep -q "Inappropriate ioctl for device" && \
+		_notrun "Dedupe not supported by test filesystem type: $FSTYP"
+	_scratch_unmount
+}
+
+# Prints a range of a file as a hex dump
+_read_range() {
+	file="$1"
+	offset="$2"
+	len="$3"
+	xfs_io_args="$4"
+
+	$XFS_IO_PROG $xfs_io_args -f -c "pread -q -v $offset $len" "$file" | cut -d ' ' -f '3-18'
+}
+
+# Compare ranges of two files
+_compare_range() {
+	file1="$1"
+	offset1="$2"
+	file2="$3"
+	offset2="$4"
+	len="$5"
+
+	cmp -s <(_read_range "$file1" "$offset1" "$len") \
+	       <(_read_range "$file2" "$offset2" "$len")
+}
+
+# Prints the md5 checksum of a hexdump of a part of a given file
+_md5_range_checksum() {
+	file="$1"
+	offset="$2"
+	len="$3"
+
+	md5sum <(_read_range "$file" "$offset" "$len") | cut -d ' ' -f 1
+}
+
+# Reflink some file1 into file2 via cp
+_cp_reflink() {
+	file1="$1"
+	file2="$2"
+
+	cp --reflink=always "$file1" "$file2"
+}
+
+# Reflink some file1 into file2
+_reflink() {
+	file1="$1"
+	file2="$2"
+
+	"$XFS_IO_PROG" -f -c "reflink $file1" "$file2"
+}
+
+# Reflink some part of file1 into another part of file2
+_reflink_range() {
+	file1="$1"
+	offset1="$2"
+	file2="$3"
+	offset2="$4"
+	len="$5"
+	xfs_io_args="$6"
+
+	"$XFS_IO_PROG" $xfs_io_args -f -c "reflink $file1 $offset1 $offset2 $len" "$file2"
+}
+
+# Dedupe some part of file1 into another part of file2
+_dedupe_range() {
+	file1="$1"
+	offset1="$2"
+	file2="$3"
+	offset2="$4"
+	len="$5"
+	xfs_io_args="$6"
+
+	"$XFS_IO_PROG" $xfs_io_args -f -c "dedupe $file1 $offset1 $offset2 $len" "$file2"
+}
diff --git a/tests/btrfs/029 b/tests/btrfs/029
index 0b77b33..175317a 100755
--- a/tests/btrfs/029
+++ b/tests/btrfs/029
@@ -47,6 +47,7 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/reflink
 
 # real QA test starts here
 _supported_fs btrfs
diff --git a/tests/btrfs/031 b/tests/btrfs/031
index bcd332c..c5763da 100755
--- a/tests/btrfs/031
+++ b/tests/btrfs/031
@@ -48,6 +48,7 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/reflink
 
 # real QA test starts here
 _supported_fs btrfs
diff --git a/tests/btrfs/108 b/tests/btrfs/108
index 5e3a403..18e5b99 100755
--- a/tests/btrfs/108
+++ b/tests/btrfs/108
@@ -41,6 +41,7 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/reflink
 
 # real QA test starts here
 _supported_fs btrfs
diff --git a/tests/btrfs/109 b/tests/btrfs/109
index e2aeb73..b86336c 100755
--- a/tests/btrfs/109
+++ b/tests/btrfs/109
@@ -41,6 +41,7 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/reflink
 
 # real QA test starts here
 _supported_fs btrfs
diff --git a/tests/generic/110 b/tests/generic/110
index ec74357..468d859 100755
--- a/tests/generic/110
+++ b/tests/generic/110
@@ -43,9 +43,10 @@ _cleanup()
 # get standard environment, filters and checks
 . common/rc
 . common/filter
+. common/reflink
 
 # real QA test starts here
-_supported_fs btrfs
+_require_test_reflink
 _supported_os Linux
 
 _require_xfs_io_command "fiemap"
diff --git a/tests/generic/111 b/tests/generic/111
index 9da3f40..1797233 100755
--- a/tests/generic/111
+++ b/tests/generic/111
@@ -43,9 +43,10 @@ _cleanup()
 # get standard environment, filters and checks
 . common/rc
 . common/filter
+. common/reflink
 
 # real QA test starts here
-_supported_fs btrfs
+_require_test_reflink
 _supported_os Linux
 
 _require_xfs_io_command "fiemap"
diff --git a/tests/generic/115 b/tests/generic/115
index 35f0417..b5c64ec 100755
--- a/tests/generic/115
+++ b/tests/generic/115
@@ -41,9 +41,10 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/reflink
 
 # real QA test starts here
-_supported_fs btrfs
+_require_test_reflink
 _supported_os Linux
 
 _require_xfs_io_command "fiemap"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
