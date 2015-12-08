Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E64267F37
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 00:29:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 584A4AC002
	for <xfs@oss.sgi.com>; Mon,  7 Dec 2015 22:29:38 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 3HmgDrgUDArAakDQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Dec 2015 22:29:34 -0800 (PST)
Subject: [PATCH 3/3] reflink: more tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 07 Dec 2015 22:29:05 -0800
Message-ID: <20151208062904.21871.30589.stgit@birch.djwong.org>
In-Reply-To: <20151208062844.21871.23644.stgit@birch.djwong.org>
References: <20151208062844.21871.23644.stgit@birch.djwong.org>
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

Add more tests for unaligned copy-on-write things, and explicitly
test the ability to pass "len == 0" to mean reflink/dedupe all
the way to the end of the file".

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/820     |   77 ++++++++++++++++++++++++++++++++
 tests/generic/820.out |    8 +++
 tests/generic/847     |   96 ++++++++++++++++++++++++++++++++++++++++
 tests/generic/847.out |   11 +++++
 tests/generic/848     |   96 ++++++++++++++++++++++++++++++++++++++++
 tests/generic/848.out |   11 +++++
 tests/generic/849     |   80 ++++++++++++++++++++++++++++++++++
 tests/generic/849.out |    6 +++
 tests/generic/850     |  117 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/850.out |   17 +++++++
 tests/generic/group   |    5 ++
 11 files changed, 524 insertions(+)
 create mode 100755 tests/generic/820
 create mode 100644 tests/generic/820.out
 create mode 100755 tests/generic/847
 create mode 100644 tests/generic/847.out
 create mode 100755 tests/generic/848
 create mode 100644 tests/generic/848.out
 create mode 100755 tests/generic/849
 create mode 100644 tests/generic/849.out
 create mode 100755 tests/generic/850
 create mode 100644 tests/generic/850.out


diff --git a/tests/generic/820 b/tests/generic/820
new file mode 100755
index 0000000..e475f71
--- /dev/null
+++ b/tests/generic/820
@@ -0,0 +1,77 @@
+#! /bin/bash
+# FS QA Test No. 820
+#
+# Ensure that punch-hole doesn't clobber CoW.
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
+_require_test_reflink
+_require_cp_reflink
+_require_xfs_io_command "fpunch"
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original files"
+BLKSZ=65536
+NR=512
+_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
+
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+
+echo "Write and punch"
+_pwrite_byte 0x62 0 $((BLKSZ * 256)) "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "fpunch $BLKSZ $((BLKSZ * 254))" "$TESTDIR/file2"
+_test_remount
+
+echo "Compare results"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/820.out b/tests/generic/820.out
new file mode 100644
index 0000000..527617d
--- /dev/null
+++ b/tests/generic/820.out
@@ -0,0 +1,8 @@
+QA output created by 820
+Create the original files
+bc3d7c2ff64219e33239f2e13c2d21db  TEST_DIR/test-820/file1
+bc3d7c2ff64219e33239f2e13c2d21db  TEST_DIR/test-820/file2
+Write and punch
+Compare results
+bc3d7c2ff64219e33239f2e13c2d21db  TEST_DIR/test-820/file1
+95cfd19ce56010430dc2057413d7efc5  TEST_DIR/test-820/file2
diff --git a/tests/generic/847 b/tests/generic/847
new file mode 100755
index 0000000..ee8b53b
--- /dev/null
+++ b/tests/generic/847
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FS QA Test No. 847
+#
+# Ensure that unaligned punch-hole steps around reflinked ranges:
+#   - Create a reflink clone of a file
+#   - Perform an unaligned punch in the middle of the file.
+#   - Check that the reflinked areas are still there.
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
+_require_test_reflink
+_require_cp_reflink
+_require_xfs_io_command "fpunch"
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original files"
+BLKSZ=65536
+_pwrite_byte 0x61 0 $((BLKSZ * 3)) "$TESTDIR/file1" >> "$seqres.full"
+
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
+
+_pwrite_byte 0x61 0 $((BLKSZ * 3)) "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $((BLKSZ - 17)) $((BLKSZ + 17)) "$TESTDIR/file2.chk" >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+
+C1="$(_md5_checksum "$TESTDIR/file1")"
+C2="$(_md5_checksum "$TESTDIR/file2")"
+
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+
+echo "fpunch files"
+"$XFS_IO_PROG" -f -c "fpunch $((BLKSZ - 17)) $((BLKSZ + 17))" "$TESTDIR/file2"
+_test_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+
+C1="$(_md5_checksum "$TESTDIR/file1")"
+C2="$(_md5_checksum "$TESTDIR/file2")"
+
+test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+
+echo "Compare against check files"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/847.out b/tests/generic/847.out
new file mode 100644
index 0000000..8139857
--- /dev/null
+++ b/tests/generic/847.out
@@ -0,0 +1,11 @@
+QA output created by 847
+Create the original files
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-847/file1
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-847/file2
+8cdf70c9cfb33bdc7397806b87e7c7ea  TEST_DIR/test-847/file2.chk
+fpunch files
+Compare files
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-847/file1
+8cdf70c9cfb33bdc7397806b87e7c7ea  TEST_DIR/test-847/file2
+8cdf70c9cfb33bdc7397806b87e7c7ea  TEST_DIR/test-847/file2.chk
+Compare against check files
diff --git a/tests/generic/848 b/tests/generic/848
new file mode 100755
index 0000000..cb848fb
--- /dev/null
+++ b/tests/generic/848
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FS QA Test No. 848
+#
+# Ensure that unaligned zero-range steps around reflinked ranges:
+#   - Create a reflink clone of a file
+#   - Perform an unaligned zero-range in the middle of the file.
+#   - Check that the reflinked areas are still there.
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
+_require_test_reflink
+_require_cp_reflink
+_require_xfs_io_command "fzero"
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original files"
+BLKSZ=65536
+_pwrite_byte 0x61 0 $((BLKSZ * 3)) "$TESTDIR/file1" >> "$seqres.full"
+
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
+
+_pwrite_byte 0x61 0 $((BLKSZ * 3)) "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $((BLKSZ - 17)) $((BLKSZ + 17)) "$TESTDIR/file2.chk" >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+
+C1="$(_md5_checksum "$TESTDIR/file1")"
+C2="$(_md5_checksum "$TESTDIR/file2")"
+
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+
+echo "fzero files"
+"$XFS_IO_PROG" -f -c "fzero $((BLKSZ - 17)) $((BLKSZ + 17))" "$TESTDIR/file2"
+_test_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+
+C1="$(_md5_checksum "$TESTDIR/file1")"
+C2="$(_md5_checksum "$TESTDIR/file2")"
+
+test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+
+echo "Compare against check files"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/848.out b/tests/generic/848.out
new file mode 100644
index 0000000..94c674b
--- /dev/null
+++ b/tests/generic/848.out
@@ -0,0 +1,11 @@
+QA output created by 848
+Create the original files
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-848/file1
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-848/file2
+8cdf70c9cfb33bdc7397806b87e7c7ea  TEST_DIR/test-848/file2.chk
+fzero files
+Compare files
+998b4ba52f2940dc515001e75926b19f  TEST_DIR/test-848/file1
+8cdf70c9cfb33bdc7397806b87e7c7ea  TEST_DIR/test-848/file2
+8cdf70c9cfb33bdc7397806b87e7c7ea  TEST_DIR/test-848/file2.chk
+Compare against check files
diff --git a/tests/generic/849 b/tests/generic/849
new file mode 100755
index 0000000..76f1e70
--- /dev/null
+++ b/tests/generic/849
@@ -0,0 +1,80 @@
+#! /bin/bash
+# FS QA Test No. 849
+#
+# Test the convention that reflink with length == 0 means "to the end of fileA"
+#   - Create a file.
+#   - Try to reflink "zero" bytes.
+#   - Check that the reflink happened.
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
+_require_test_reflink
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original files"
+BLKSZ=65536
+_pwrite_byte 0x61 0 $((BLKSZ * 256)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((BLKSZ * 256)) "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((BLKSZ * 2)) "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 $((BLKSZ * 2)) $((BLKSZ * 255)) "$TESTDIR/file2.chk" >> "$seqres.full"
+_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) 0 >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+
+C1="$(_md5_checksum "$TESTDIR/file1")"
+C2="$(_md5_checksum "$TESTDIR/file2")"
+
+test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+
+echo "Compare against check files"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/849.out b/tests/generic/849.out
new file mode 100644
index 0000000..159305a
--- /dev/null
+++ b/tests/generic/849.out
@@ -0,0 +1,6 @@
+QA output created by 849
+Create the original files
+f4820540fc0ac02750739896fe028d56  TEST_DIR/test-849/file1
+dc881c004745c49f7f4e9cc766f57bc8  TEST_DIR/test-849/file2
+dc881c004745c49f7f4e9cc766f57bc8  TEST_DIR/test-849/file2.chk
+Compare against check files
diff --git a/tests/generic/850 b/tests/generic/850
new file mode 100755
index 0000000..954d41d
--- /dev/null
+++ b/tests/generic/850
@@ -0,0 +1,117 @@
+#! /bin/bash
+# FS QA Test No. 850
+#
+# Test the convention that reflink with length == 0 means "to the end of fileA"
+#   - Create a file.
+#   - Try to reflink "zero" bytes (which means reflink to EOF).
+#   - Check that the reflink happened.
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
+_require_test_reflink
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original files"
+BLKSZ=65536
+_pwrite_byte 0x61 0 $((BLKSZ * 256)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((BLKSZ * 257)) "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((BLKSZ * 257)) "$TESTDIR/file2.chk" >> "$seqres.full"
+_dedupe_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) 0 >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+
+C1="$(_md5_checksum "$TESTDIR/file1")"
+C2="$(_md5_checksum "$TESTDIR/file2")"
+
+test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+
+echo "Compare against check files"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+
+echo "Make the original file almost dedup-able"
+_pwrite_byte 0x61 0 $((BLKSZ * 256)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((BLKSZ * 256)) "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((BLKSZ * 256)) "$TESTDIR/file2.chk" >> "$seqres.full"
+_dedupe_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) 0 >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+
+C1="$(_md5_checksum "$TESTDIR/file1")"
+C2="$(_md5_checksum "$TESTDIR/file2")"
+
+test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+
+echo "Compare against check files"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+
+echo "Make the original file dedup-able"
+_pwrite_byte 0x61 0 $((BLKSZ * 256)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((BLKSZ * 257)) "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((BLKSZ * 257)) "$TESTDIR/file2.chk" >> "$seqres.full"
+_dedupe_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) 0 >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+
+C1="$(_md5_checksum "$TESTDIR/file1")"
+C2="$(_md5_checksum "$TESTDIR/file2")"
+
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+
+echo "Compare against check files"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/850.out b/tests/generic/850.out
new file mode 100644
index 0000000..126187e
--- /dev/null
+++ b/tests/generic/850.out
@@ -0,0 +1,17 @@
+QA output created by 850
+Create the original files
+f4820540fc0ac02750739896fe028d56  TEST_DIR/test-850/file1
+69ad53078a16243d98e21d9f8704a071  TEST_DIR/test-850/file2
+69ad53078a16243d98e21d9f8704a071  TEST_DIR/test-850/file2.chk
+Compare against check files
+Make the original file almost dedup-able
+f4820540fc0ac02750739896fe028d56  TEST_DIR/test-850/file1
+158d4e3578b94b89cbb44493a2110fb9  TEST_DIR/test-850/file2
+158d4e3578b94b89cbb44493a2110fb9  TEST_DIR/test-850/file2.chk
+Compare against check files
+Make the original file dedup-able
+f4820540fc0ac02750739896fe028d56  TEST_DIR/test-850/file1
+113c7055ffe3d24d2dec27e82ab55abd  TEST_DIR/test-850/file2
+113c7055ffe3d24d2dec27e82ab55abd  TEST_DIR/test-850/file2.chk
+file1 and file2 should match
+Compare against check files
diff --git a/tests/generic/group b/tests/generic/group
index 355603f..bf33541 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -257,3 +257,8 @@
 323 auto aio stress
 324 auto fsr quick
 325 auto quick data log
+820 auto quick clone
+847 auto quick clone
+848 auto quick clone
+849 auto quick clone
+850 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
