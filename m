Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F26D57F51
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 23:15:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D1FF58F8040
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 21:15:59 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id qyUWJrqI2aWj9oSD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 21:15:56 -0700 (PDT)
Subject: [PATCH 04/11] basic tests of the reflink and dedupe ioctls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Jun 2015 21:15:47 -0700
Message-ID: <20150630041547.2476.32693.stgit@birch.djwong.org>
In-Reply-To: <20150630041519.2476.23059.stgit@birch.djwong.org>
References: <20150630041519.2476.23059.stgit@birch.djwong.org>
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

Test the operation of the btrfs (and now xfs) reflink and dedupe
ioctls at various file offsets and with matching and nonmatching
files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc             |   44 +++++++++++++++++
 tests/generic/803     |   81 +++++++++++++++++++++++++++++++
 tests/generic/803.out |   11 ++++
 tests/generic/804     |   86 ++++++++++++++++++++++++++++++++
 tests/generic/804.out |   13 +++++
 tests/generic/805     |  113 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/805.out |   26 ++++++++++
 tests/generic/806     |   81 +++++++++++++++++++++++++++++++
 tests/generic/806.out |   11 ++++
 tests/generic/807     |   87 +++++++++++++++++++++++++++++++++
 tests/generic/807.out |   15 ++++++
 tests/generic/817     |   89 ++++++++++++++++++++++++++++++++++
 tests/generic/817.out |   10 ++++
 tests/generic/818     |   94 +++++++++++++++++++++++++++++++++++
 tests/generic/818.out |   12 +++++
 tests/generic/819     |  130 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/819.out |    7 +++
 tests/generic/820     |  118 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/820.out |    7 +++
 tests/generic/group   |    9 +++
 20 files changed, 1044 insertions(+)
 create mode 100755 tests/generic/803
 create mode 100644 tests/generic/803.out
 create mode 100755 tests/generic/804
 create mode 100644 tests/generic/804.out
 create mode 100755 tests/generic/805
 create mode 100644 tests/generic/805.out
 create mode 100755 tests/generic/806
 create mode 100644 tests/generic/806.out
 create mode 100755 tests/generic/807
 create mode 100644 tests/generic/807.out
 create mode 100755 tests/generic/817
 create mode 100644 tests/generic/817.out
 create mode 100755 tests/generic/818
 create mode 100644 tests/generic/818.out
 create mode 100755 tests/generic/819
 create mode 100644 tests/generic/819.out
 create mode 100755 tests/generic/820
 create mode 100644 tests/generic/820.out


diff --git a/common/rc b/common/rc
index 8f20dc8..7521033 100644
--- a/common/rc
+++ b/common/rc
@@ -2604,6 +2604,50 @@ _verify_reflink()
                || echo "$1 and $2 are not reflinks: different extents"
 }
 
+# Check that a particular range is shared
+# args: filename, start, end
+_check_shared_extent()
+{
+	$XFS_IO_PROG -f -c 'fiemap -v' $1 | tr '[].:' '    ' | \
+	awk "BEGIN {x = 0;} {start = \$2 * 512; end = (\$3 + 1) * 512; if (and(strtonum(\$7), 0x2000) && start < ($3 + $2) && end > $2) {x++;}} END {print x;}"
+}
+
+# Retrieve the pblk(s) associated with a file's lblk range
+# args: filename, start, len, cache_file
+_extent_physical()
+{
+	if [ -z "$3" ]; then
+		len="512"
+	else
+		len="$3"
+	fi
+	fiemap_cache_file="$4"
+	rm_cache_file=0
+	if [ -z "$fiemap_cache_file" ]; then
+		fiemap_cache_file="/tmp/fiemap.$$"
+		rm_cache_file=1
+	fi
+	if [ ! -e "$fiemap_cache_file" ]; then
+		$XFS_IO_PROG -f -c 'fiemap -v' "$1" | tr '[].:' '    ' | tail -n +3 > "$fiemap_cache_file"
+	fi
+	cat "$fiemap_cache_file" | \
+	awk "BEGIN {x = 0;} {start = \$2 * 512; end = (\$3 + 1) * 512; phys = \$4 * 512; if (start < ($len + $2) && end > $2) {if (\$4 == \"hole\") {printf(\"-1\n\");} else {printf(\"%d\n\", phys + $2 - start);}}}"
+	if [ "$rm_cache_file" -eq 1 ]; then
+		rm "$fiemap_cache_file"
+	fi
+}
+
+_numbers_equal()
+{
+	n="$1"
+	shift
+	i=1
+	for num in "$@"; do
+		test "$num" -eq "$n" || echo "num #$i does not match #0"
+		i=$((i + 1))
+	done
+}
+
 _require_atime()
 {
 	if [ "$FSTYP" == "nfs" ]; then
diff --git a/tests/generic/803 b/tests/generic/803
new file mode 100755
index 0000000..47d89a7
--- /dev/null
+++ b/tests/generic/803
@@ -0,0 +1,81 @@
+#! /bin/bash
+# FS QA Test No. 803
+#
+# Ensure that we can reflink parts of two files:
+#   - Reflink identical parts of two identical files
+#   - Check that we end up with identical contents
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
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "reflink"
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 196608' $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 196608' $TESTDIR/file2 >> $seqres.full
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+
+echo "Reflink the middle blocks together"
+$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 65536 65536 65536" $TESTDIR/file2 >> $seqres.full
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+
+echo "Check shared extents"
+_check_shared_extent $TESTDIR/file1 65536 65536
+_check_shared_extent $TESTDIR/file2 65536 65536
+
+echo "Check shared extent physical mapping matches"
+_numbers_equal "$(_extent_physical $TESTDIR/file1 65536 65536)" \
+	"$(_extent_physical $TESTDIR/file2 65536 65536)"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/803.out b/tests/generic/803.out
new file mode 100644
index 0000000..894d180
--- /dev/null
+++ b/tests/generic/803.out
@@ -0,0 +1,11 @@
+QA output created by 803
+Create the original files
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-803/file1
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-803/file2
+Reflink the middle blocks together
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-803/file1
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-803/file2
+Check shared extents
+1
+1
+Check shared extent physical mapping matches
diff --git a/tests/generic/804 b/tests/generic/804
new file mode 100755
index 0000000..56a32f9
--- /dev/null
+++ b/tests/generic/804
@@ -0,0 +1,86 @@
+#! /bin/bash
+# FS QA Test No. 804
+#
+# Ensuring that we can reflink non-matching parts of files:
+#   - Reflink identical parts of two different files
+#   - Check that we end up with identical contents in the reflink section
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
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "reflink"
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 196608' $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x62 0 196608' $TESTDIR/file2 >> $seqres.full
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+
+echo "Reflink the middle blocks together"
+$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 65536 65536 65536" $TESTDIR/file2 >> $seqres.full
+
+echo "Checksum both files"
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+
+echo "Compare the reflinked sections"
+diff -u <($XFS_IO_PROG -f -c 'pread -q -v 65536 65536' $TESTDIR/file1) \
+        <($XFS_IO_PROG -f -c 'pread -q -v 65536 65536' $TESTDIR/file2)
+
+echo "Check shared extents"
+_check_shared_extent $TESTDIR/file1 65536 65536
+_check_shared_extent $TESTDIR/file2 65536 65536
+
+echo "Check shared extent physical mapping matches"
+_numbers_equal "$(_extent_physical $TESTDIR/file1 65536 65536)" \
+	"$(_extent_physical $TESTDIR/file2 65536 65536)"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/804.out b/tests/generic/804.out
new file mode 100644
index 0000000..d60fe8e
--- /dev/null
+++ b/tests/generic/804.out
@@ -0,0 +1,13 @@
+QA output created by 804
+Create the original files
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-804/file1
+f419d4baba769b4f017ac91ee1acdcb1  TEST_DIR/test-804/file2
+Reflink the middle blocks together
+Checksum both files
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-804/file1
+86f2e64aa5e9daa4f21a0cdd54a3bd99  TEST_DIR/test-804/file2
+Compare the reflinked sections
+Check shared extents
+1
+1
+Check shared extent physical mapping matches
diff --git a/tests/generic/805 b/tests/generic/805
new file mode 100755
index 0000000..7658fb3
--- /dev/null
+++ b/tests/generic/805
@@ -0,0 +1,113 @@
+#! /bin/bash
+# FS QA Test No. 805
+#
+# Reflinking two sets of files together:
+#   - Reflink identical parts of two identical files
+#   - Reflink identical parts of two other identical files
+#   - Reflink identical parts of all four files
+#   - Check that we end up with identical contents
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
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "reflink"
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 196608' $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 196608' $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 196608' $TESTDIR/file3 >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 196608' $TESTDIR/file4 >> $seqres.full
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+md5sum $TESTDIR/file4 | _filter_test_dir
+
+echo "Reflink the first blocks together"
+$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 0 0 131072" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "reflink $TESTDIR/file3 0 0 131072" $TESTDIR/file4 >> $seqres.full
+sync
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+md5sum $TESTDIR/file4 | _filter_test_dir
+
+echo "Reflink the middle blocks together"
+$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 0 0 65536" $TESTDIR/file3 >> $seqres.full
+$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 0 0 65536" $TESTDIR/file4 >> $seqres.full
+sync
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+md5sum $TESTDIR/file4 | _filter_test_dir
+
+echo "Check shared extents"
+_check_shared_extent $TESTDIR/file1 0 65536
+_check_shared_extent $TESTDIR/file2 0 65536
+_check_shared_extent $TESTDIR/file3 0 65536
+_check_shared_extent $TESTDIR/file4 0 65536
+_check_shared_extent $TESTDIR/file1 65536 65536
+_check_shared_extent $TESTDIR/file2 65536 65536
+_check_shared_extent $TESTDIR/file3 65536 65536
+_check_shared_extent $TESTDIR/file4 65536 65536
+
+echo "Check shared extent physical mapping matches"
+_numbers_equal "$(_extent_physical $TESTDIR/file1 0 65536)" \
+	"$(_extent_physical $TESTDIR/file2 0 65536)" \
+	"$(_extent_physical $TESTDIR/file3 0 65536)" \
+	"$(_extent_physical $TESTDIR/file4 0 65536)"
+_numbers_equal "$(_extent_physical $TESTDIR/file1 65536 65536)" \
+	"$(_extent_physical $TESTDIR/file2 65536 65536)"
+_numbers_equal "$(_extent_physical $TESTDIR/file3 65536 65536)" \
+	"$(_extent_physical $TESTDIR/file4 65536 65536)"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/805.out b/tests/generic/805.out
new file mode 100644
index 0000000..ac6176f
--- /dev/null
+++ b/tests/generic/805.out
@@ -0,0 +1,26 @@
+QA output created by 805
+Create the original files
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-805/file1
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-805/file2
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-805/file3
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-805/file4
+Reflink the first blocks together
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-805/file1
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-805/file2
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-805/file3
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-805/file4
+Reflink the middle blocks together
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-805/file1
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-805/file2
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-805/file3
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-805/file4
+Check shared extents
+1
+1
+1
+1
+1
+1
+1
+1
+Check shared extent physical mapping matches
diff --git a/tests/generic/806 b/tests/generic/806
new file mode 100755
index 0000000..f11cceb
--- /dev/null
+++ b/tests/generic/806
@@ -0,0 +1,81 @@
+#! /bin/bash
+# FS QA Test No. 806
+#
+# Ensure that we can dedupe parts of two files:
+#   - Dedupe identical parts of two identical files
+#   - Check that we end up with identical contents
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
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "dedupe"
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 196608' $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 196608' $TESTDIR/file2 >> $seqres.full
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+
+echo "Dedupe the middle blocks together"
+$XFS_IO_PROG -f -c "dedupe $TESTDIR/file1 65536 65536 65536" $TESTDIR/file2 >> $seqres.full
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+
+echo "Check shared extents"
+_check_shared_extent $TESTDIR/file1 65536 65536
+_check_shared_extent $TESTDIR/file2 65536 65536
+
+echo "Check shared extent physical mapping matches"
+_numbers_equal "$(_extent_physical $TESTDIR/file1 65536 65536)" \
+	"$(_extent_physical $TESTDIR/file2 65536 65536)"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/806.out b/tests/generic/806.out
new file mode 100644
index 0000000..c71bec4
--- /dev/null
+++ b/tests/generic/806.out
@@ -0,0 +1,11 @@
+QA output created by 806
+Create the original files
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-806/file1
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-806/file2
+Dedupe the middle blocks together
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-806/file1
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-806/file2
+Check shared extents
+1
+1
+Check shared extent physical mapping matches
diff --git a/tests/generic/807 b/tests/generic/807
new file mode 100755
index 0000000..3f6e1d3
--- /dev/null
+++ b/tests/generic/807
@@ -0,0 +1,87 @@
+#! /bin/bash
+# FS QA Test No. 807
+#
+# Ensuring that we cannot dedupe non-matching parts of files:
+#   - Fail to dedupe non-identical parts of two different files
+#   - Check that nothing changes in either file
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
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "dedupe"
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 196608' $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x62 0 196608' $TESTDIR/file2 >> $seqres.full
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+
+echo "Dedupe the middle blocks together"
+$XFS_IO_PROG -f -c "dedupe $TESTDIR/file1 65536 65536 65536" $TESTDIR/file2 >> $seqres.full
+
+echo "Checksum both files"
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+
+echo "Compare the deduped sections"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 65536 65536' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 65536 65536' $TESTDIR/file2) \
+       || echo "Sections do not match (intentional)"
+
+echo "Check shared extents"
+_check_shared_extent $TESTDIR/file1 65536 65536
+_check_shared_extent $TESTDIR/file2 65536 65536
+
+echo "Check shared extent physical mapping matches"
+_numbers_equal "$(_extent_physical $TESTDIR/file1 65536 65536)" \
+	"$(_extent_physical $TESTDIR/file2 65536 65536)"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/807.out b/tests/generic/807.out
new file mode 100644
index 0000000..61727be
--- /dev/null
+++ b/tests/generic/807.out
@@ -0,0 +1,15 @@
+QA output created by 807
+Create the original files
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-807/file1
+f419d4baba769b4f017ac91ee1acdcb1  TEST_DIR/test-807/file2
+Dedupe the middle blocks together
+Checksum both files
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-807/file1
+f419d4baba769b4f017ac91ee1acdcb1  TEST_DIR/test-807/file2
+Compare the deduped sections
+Sections do not match (intentional)
+Check shared extents
+0
+0
+Check shared extent physical mapping matches
+num #1 does not match #0
diff --git a/tests/generic/817 b/tests/generic/817
new file mode 100755
index 0000000..64ed4bb
--- /dev/null
+++ b/tests/generic/817
@@ -0,0 +1,89 @@
+#! /bin/bash
+# FS QA Test No. 817
+#
+# Ensure that we can reflink the last block of a file whose size isn't block-aligned.
+#   - Create a file whose size isn't block-aligned
+#   - Reflink the last block
+#   - Check that we end up with identical contents
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
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "reflink"
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ + 37))" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ + 37))" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((BLKSZ + 37))" $TESTDIR/file3 >> $seqres.full
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+
+echo "Reflink the last blocks together"
+$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 0 0 $BLKSZ" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 0 0 $BLKSZ" $TESTDIR/file3 >> $seqres.full
+$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 $BLKSZ $BLKSZ 37" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 $BLKSZ $BLKSZ 37" $TESTDIR/file3 >> $seqres.full
+sync
+echo 3 > /proc/sys/vm/drop_caches
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+
+echo "Check shared extent physical mapping matches"
+_numbers_equal "$(_extent_physical $TESTDIR/file1 $BLKSZ)" \
+	"$(_extent_physical $TESTDIR/file2 $BLKSZ)"
+_numbers_equal "$(_extent_physical $TESTDIR/file1 $BLKSZ)" \
+	"$(_extent_physical $TESTDIR/file3 $BLKSZ)"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/817.out b/tests/generic/817.out
new file mode 100644
index 0000000..97ca8e2
--- /dev/null
+++ b/tests/generic/817.out
@@ -0,0 +1,10 @@
+QA output created by 817
+Create the original files
+ce51fe7e361c6f39e48d003f0c9626d7  TEST_DIR/test-817/file1
+ce51fe7e361c6f39e48d003f0c9626d7  TEST_DIR/test-817/file2
+2eb81ff80b06cee4f341410c6e82cda9  TEST_DIR/test-817/file3
+Reflink the last blocks together
+ce51fe7e361c6f39e48d003f0c9626d7  TEST_DIR/test-817/file1
+ce51fe7e361c6f39e48d003f0c9626d7  TEST_DIR/test-817/file2
+ce51fe7e361c6f39e48d003f0c9626d7  TEST_DIR/test-817/file3
+Check shared extent physical mapping matches
diff --git a/tests/generic/818 b/tests/generic/818
new file mode 100755
index 0000000..1904b76
--- /dev/null
+++ b/tests/generic/818
@@ -0,0 +1,94 @@
+#! /bin/bash
+# FS QA Test No. 818
+#
+# Ensure that we can dedupe the last block of a file whose size isn't block-aligned.
+#   - Create a file whose size isn't block-aligned
+#   - Create a second file identical to the first
+#   - Create a different file of the same size
+#   - Dedupe the last block of the first and second files
+#   - Try to dedupe the last block of the first and third files
+#   - Check that we end up with identical contents in files 1-2, and not
+#     the same in 2-3.
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
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "dedupe"
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ + 37))" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ + 37))" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((BLKSZ + 37))" $TESTDIR/file3 >> $seqres.full
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+
+echo "Dedupe the last blocks together"
+$XFS_IO_PROG -f -c "dedupe $TESTDIR/file1 0 0 $BLKSZ" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "dedupe $TESTDIR/file1 0 0 $BLKSZ" $TESTDIR/file3 >> $seqres.full
+$XFS_IO_PROG -f -c "dedupe $TESTDIR/file1 $BLKSZ $BLKSZ 37" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "dedupe $TESTDIR/file1 $BLKSZ $BLKSZ 37" $TESTDIR/file3 >> $seqres.full
+sync
+echo 3 > /proc/sys/vm/drop_caches
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+
+echo "Check shared extent physical mapping matches"
+_numbers_equal "$(_extent_physical $TESTDIR/file1 0)" \
+	"$(_extent_physical $TESTDIR/file2 0)"
+echo "Check unshared extent physical mapping doesn't match"
+_numbers_equal "$(_extent_physical $TESTDIR/file1 $BLKSZ)" \
+	"$(_extent_physical $TESTDIR/file3 $BLKSZ)"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/818.out b/tests/generic/818.out
new file mode 100644
index 0000000..d3d2de5
--- /dev/null
+++ b/tests/generic/818.out
@@ -0,0 +1,12 @@
+QA output created by 818
+Create the original files
+ce51fe7e361c6f39e48d003f0c9626d7  TEST_DIR/test-818/file1
+ce51fe7e361c6f39e48d003f0c9626d7  TEST_DIR/test-818/file2
+2eb81ff80b06cee4f341410c6e82cda9  TEST_DIR/test-818/file3
+Dedupe the last blocks together
+ce51fe7e361c6f39e48d003f0c9626d7  TEST_DIR/test-818/file1
+ce51fe7e361c6f39e48d003f0c9626d7  TEST_DIR/test-818/file2
+2eb81ff80b06cee4f341410c6e82cda9  TEST_DIR/test-818/file3
+Check shared extent physical mapping matches
+Check unshared extent physical mapping doesn't match
+num #1 does not match #0
diff --git a/tests/generic/819 b/tests/generic/819
new file mode 100755
index 0000000..5f63542
--- /dev/null
+++ b/tests/generic/819
@@ -0,0 +1,130 @@
+#! /bin/bash
+# FS QA Test No. 819
+#
+# Ensure that we can reflink and dedupe blocks within the same file...
+#   - Create a file with three distinct blocks ABB
+#   - Reflink block zero to the multiple-of-three blocks
+#   - Reflink block one to the multiple-of-five blocks
+#   - Dedupe block two to the multiple-of-seven blocks
+#   - Check that we successfully avoid deduping with holes, unwritten
+#     extents, and non-matches; but actually dedupe real matches.
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
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+if [ $FSTYP = "btrfs" ]; then
+	_notrun "btrfs doesn't support dedupe within the same file"
+fi
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "reflink"
+_require_xfs_io_command "dedupe"
+_require_xfs_io_command "falloc"
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original file blocks"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $BLKSZ $((BLKSZ * 2))" $TESTDIR/file1 >> $seqres.full
+
+NR_BLKS=1024
+
+echo "fallocate half the file"
+$XFS_IO_PROG -f -c "falloc $((NR_BLKS * BLKSZ / 2)) $((NR_BLKS * BLKSZ / 2))" $TESTDIR/file1 >> $seqres.full
+
+echo "Reflink block zero to the threes"
+seq 1 $((NR_BLKS / 3)) | while read nr; do
+	$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 0 $((nr * 3 * BLKSZ)) $BLKSZ" $TESTDIR/file1 >> $seqres.full
+done
+
+echo "Reflink block one to the fives"
+seq 1 $((NR_BLKS / 5)) | while read nr; do
+	$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 $BLKSZ $((nr * 5 * BLKSZ)) $BLKSZ" $TESTDIR/file1 >> $seqres.full
+done
+
+echo "Dedupe block two to the sevens"
+seq 1 $((NR_BLKS / 7)) | while read nr; do
+	$XFS_IO_PROG -f -c "dedupe $TESTDIR/file1 $((BLKSZ * 2)) $((nr * 7 * BLKSZ)) $BLKSZ" $TESTDIR/file1 >> $seqres.full
+done
+
+sync
+echo 3 > /proc/sys/vm/drop_caches
+
+echo "Check block mappings"
+pblk0=$(_extent_physical $TESTDIR/file1 0 "" $TESTDIR/file1.fiemap)
+pblk1=$(_extent_physical $TESTDIR/file1 $BLKSZ "" $TESTDIR/file1.fiemap)
+pblk2=$(_extent_physical $TESTDIR/file1 $((BLKSZ * 2)) "" $TESTDIR/file1.fiemap)
+check_block() {
+	lblk="$1"
+	rem7=$((lblk % 7))
+	rem5=$((lblk % 5))
+	rem3=$((lblk % 3))
+
+	pblk=$(_extent_physical $TESTDIR/file1 "$((lblk * BLKSZ))" "" $TESTDIR/file1.fiemap)
+	if [ $rem7 -eq 0 ]; then
+		if [ $rem5 -eq 0 ]; then
+			_numbers_equal $pblk2 $pblk
+		elif [ $rem3 -eq 0 ]; then
+			_numbers_equal $pblk0 $pblk
+		elif [ $lblk -lt $((NR_BLKS / 2)) ]; then
+			_numbers_equal $pblk -1
+		fi
+	elif [ $rem5 -eq 0 ]; then
+		_numbers_equal $pblk1 $pblk
+	elif [ $rem3 -eq 0 ]; then
+		_numbers_equal $pblk0 $pblk
+	elif [ $lblk -lt $((NR_BLKS / 2)) ]; then
+		_numbers_equal -1 $pblk
+	fi
+}
+seq 3 $((NR_BLKS - 1)) | while read lblk; do
+	err="$(check_block $lblk)"
+	test -n "$err" && echo "$lblk: $err"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/819.out b/tests/generic/819.out
new file mode 100644
index 0000000..0ee5b14
--- /dev/null
+++ b/tests/generic/819.out
@@ -0,0 +1,7 @@
+QA output created by 819
+Create the original file blocks
+fallocate half the file
+Reflink block zero to the threes
+Reflink block one to the fives
+Dedupe block two to the sevens
+Check block mappings
diff --git a/tests/generic/820 b/tests/generic/820
new file mode 100755
index 0000000..9bcb513
--- /dev/null
+++ b/tests/generic/820
@@ -0,0 +1,118 @@
+#! /bin/bash
+# FS QA Test No. 820
+#
+# Ensure that we can reflink blocks within the same file...
+#   - Create a file with three distinct blocks ABB
+#   - Reflink block zero to the multiple-of-three blocks
+#   - Reflink block one to the multiple-of-five blocks
+#   - Reflink block two to the multiple-of-seven blocks
+#   - Check that we successfully reflinked all the blocks.
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
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "reflink"
+_require_xfs_io_command "falloc"
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original file blocks"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $BLKSZ $((BLKSZ * 2))" $TESTDIR/file1 >> $seqres.full
+
+NR_BLKS=1024
+
+echo "fallocate half the file"
+$XFS_IO_PROG -f -c "falloc $((NR_BLKS * BLKSZ / 2)) $((NR_BLKS * BLKSZ / 2))" $TESTDIR/file1 >> $seqres.full
+
+echo "Reflink block zero to the threes"
+seq 1 $((NR_BLKS / 3)) | while read nr; do
+	$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 0 $((nr * 3 * BLKSZ)) $BLKSZ" $TESTDIR/file1 >> $seqres.full
+done
+
+echo "Reflink block one to the fives"
+seq 1 $((NR_BLKS / 5)) | while read nr; do
+	$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 $BLKSZ $((nr * 5 * BLKSZ)) $BLKSZ" $TESTDIR/file1 >> $seqres.full
+done
+
+echo "Dedupe block two to the sevens"
+seq 1 $((NR_BLKS / 7)) | while read nr; do
+	$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 $((BLKSZ * 2)) $((nr * 7 * BLKSZ)) $BLKSZ" $TESTDIR/file1 >> $seqres.full
+done
+
+sync
+echo 3 > /proc/sys/vm/drop_caches
+
+echo "Check block mappings"
+pblk0=$(_extent_physical $TESTDIR/file1 0 "" $TESTDIR/file1.fiemap)
+pblk1=$(_extent_physical $TESTDIR/file1 $BLKSZ "" $TESTDIR/file1.fiemap)
+pblk2=$(_extent_physical $TESTDIR/file1 $((BLKSZ * 2)) "" $TESTDIR/file1.fiemap)
+check_block() {
+	lblk="$1"
+	rem7=$((lblk % 7))
+	rem5=$((lblk % 5))
+	rem3=$((lblk % 3))
+
+	pblk=$(_extent_physical $TESTDIR/file1 "$((lblk * BLKSZ))" "" $TESTDIR/file1.fiemap)
+	if [ $rem7 -eq 0 ]; then
+		_numbers_equal $pblk2 $pblk
+	elif [ $rem5 -eq 0 ]; then
+		_numbers_equal $pblk1 $pblk
+	elif [ $rem3 -eq 0 ]; then
+		_numbers_equal $pblk0 $pblk
+	elif [ $lblk -lt $((NR_BLKS / 2)) ]; then
+		_numbers_equal -1 $pblk
+	fi
+}
+seq 3 $((NR_BLKS - 1)) | while read lblk; do
+	err="$(check_block $lblk)"
+	test -n "$err" && echo "$lblk: $err"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/820.out b/tests/generic/820.out
new file mode 100644
index 0000000..1f2784d
--- /dev/null
+++ b/tests/generic/820.out
@@ -0,0 +1,7 @@
+QA output created by 820
+Create the original file blocks
+fallocate half the file
+Reflink block zero to the threes
+Reflink block one to the fives
+Dedupe block two to the sevens
+Check block mappings
diff --git a/tests/generic/group b/tests/generic/group
index 433ac30..98d875a 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -197,3 +197,12 @@
 800 auto quick clone
 801 auto quick clone
 802 auto quick clone
+803 auto quick clone
+804 auto quick clone
+805 auto quick clone
+806 auto quick clone
+807 auto quick clone
+817 auto quick clone
+818 auto quick clone
+819 auto quick clone
+820 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
