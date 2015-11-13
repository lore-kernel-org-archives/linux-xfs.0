Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B7A727F7B
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 15:37:54 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6404C8F8035
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 13:37:54 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id RnXv8TR5z17BzZZ5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Nov 2015 13:37:48 -0800 (PST)
Subject: [PATCH 06/12] reflink: test the various fallocate modes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 13 Nov 2015 13:37:22 -0800
Message-ID: <20151113213722.31124.56074.stgit@birch.djwong.org>
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

Check that the variants of fallocate (allocate, punch, zero range,
collapse range, insert range) do the right thing when they're run
against a range of reflinked blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/144     |  142 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/144.out |   16 ++++++
 tests/generic/145     |  142 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/145.out |   19 +++++++
 tests/generic/146     |  136 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/146.out |   19 +++++++
 tests/generic/147     |  139 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/147.out |   19 +++++++
 tests/generic/148     |  116 ++++++++++++++++++++++++++++++++++++++++
 tests/generic/148.out |   15 +++++
 tests/generic/149     |  136 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/149.out |   19 +++++++
 tests/generic/group   |    6 ++
 13 files changed, 924 insertions(+)
 create mode 100755 tests/generic/144
 create mode 100644 tests/generic/144.out
 create mode 100755 tests/generic/145
 create mode 100644 tests/generic/145.out
 create mode 100755 tests/generic/146
 create mode 100644 tests/generic/146.out
 create mode 100755 tests/generic/147
 create mode 100644 tests/generic/147.out
 create mode 100755 tests/generic/148
 create mode 100644 tests/generic/148.out
 create mode 100755 tests/generic/149
 create mode 100644 tests/generic/149.out


diff --git a/tests/generic/144 b/tests/generic/144
new file mode 100755
index 0000000..bee0893
--- /dev/null
+++ b/tests/generic/144
@@ -0,0 +1,142 @@
+#! /bin/bash
+# FS QA Test No. 144
+#
+# Ensure that fallocate steps around reflinked ranges:
+#   - Reflink parts of two files together
+#   - Fallocate all the other sparse space.
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
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "truncate"
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original files"
+BLKSZ=65536
+_pwrite_byte 0x61 0 $((BLKSZ * 5 + 37)) "$TESTDIR/file1" >> "$seqres.full"
+
+_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $BLKSZ \
+		$((BLKSZ * 4 + 37)) >> "$seqres.full"
+
+"$XFS_IO_PROG" -f -c "truncate $((BLKSZ * 5 + 37))" "$TESTDIR/file3" >> "$seqres.full"
+_reflink_range "$TESTDIR/file1" 0 "$TESTDIR/file3" 0 $BLKSZ >> "$seqres.full"
+
+"$XFS_IO_PROG" -f -c "truncate $((BLKSZ * 5 + 37))" "$TESTDIR/file4" >> "$seqres.full"
+_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file4" $BLKSZ $BLKSZ >> "$seqres.full"
+_reflink_range "$TESTDIR/file1" $((BLKSZ * 3)) "$TESTDIR/file4" $((BLKSZ * 3)) \
+		$BLKSZ >> "$seqres.full"
+
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file5"
+_test_remount
+
+echo "Compare sections"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$TESTDIR/file4" | _filter_test_dir
+md5sum "$TESTDIR/file5" | _filter_test_dir
+
+_compare_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $BLKSZ \
+		$((BLKSZ * 4 + 37)) \
+	|| echo "shared parts of files 1-2 changed"
+
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file3" 0 $BLKSZ \
+	|| echo "shared parts of files 1-3 changed"
+
+_compare_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file4" $BLKSZ $BLKSZ \
+	|| echo "shared parts of files 1-4 changed"
+
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file5" 0 $((BLKSZ * 5 + 37)) \
+	|| echo "shared parts of files 1-5 changed"
+
+echo "Compare files"
+C1="$(_md5_checksum "$TESTDIR/file1")"
+C2="$(_md5_checksum "$TESTDIR/file2")"
+C3="$(_md5_checksum "$TESTDIR/file3")"
+C4="$(_md5_checksum "$TESTDIR/file4")"
+C5="$(_md5_checksum "$TESTDIR/file5")"
+
+test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
+test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
+test "${C1}"  = "${C5}" || echo "file1 and file5 should match"
+test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
+test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
+test "${C2}" != "${C5}" || echo "file2 and file5 should not match"
+test "${C3}" != "${C4}" || echo "file3 and file4 should not match"
+test "${C3}" != "${C5}" || echo "file3 and file5 should not match"
+test "${C4}" != "${C5}" || echo "file4 and file5 should not match"
+
+echo "falloc everything"
+"$XFS_IO_PROG" -f -c "falloc 0 $((BLKSZ * 5))" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "falloc 0 $((BLKSZ * 5))" "$TESTDIR/file3" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "falloc 0 $((BLKSZ * 5))" "$TESTDIR/file4" >> "$seqres.full"
+_test_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$TESTDIR/file4" | _filter_test_dir
+md5sum "$TESTDIR/file5" | _filter_test_dir
+
+D1="$(_md5_checksum "$TESTDIR/file1")"
+D2="$(_md5_checksum "$TESTDIR/file2")"
+D3="$(_md5_checksum "$TESTDIR/file3")"
+D4="$(_md5_checksum "$TESTDIR/file4")"
+D5="$(_md5_checksum "$TESTDIR/file5")"
+
+test "${C1}" = "${D1}" || echo "file1 should not change"
+test "${C2}" = "${D2}" || echo "file2 should not change"
+test "${C3}" = "${D3}" || echo "file3 should not change"
+test "${C4}" = "${D4}" || echo "file4 should not change"
+test "${C5}" = "${D5}" || echo "file2 should not change"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/144.out b/tests/generic/144.out
new file mode 100644
index 0000000..0bcf4b9
--- /dev/null
+++ b/tests/generic/144.out
@@ -0,0 +1,16 @@
+QA output created by 144
+Create the original files
+Compare sections
+ee8004e6298fa128477bd4aa1adc69fb  TEST_DIR/test-144/file1
+a7cb8cb9697d59413e0d10495d226398  TEST_DIR/test-144/file2
+7d42a0a2865c94f45435a2ce7627da02  TEST_DIR/test-144/file3
+7f528bc76f4d61ff9cff7bc1906579c6  TEST_DIR/test-144/file4
+ee8004e6298fa128477bd4aa1adc69fb  TEST_DIR/test-144/file5
+Compare files
+falloc everything
+Compare files
+ee8004e6298fa128477bd4aa1adc69fb  TEST_DIR/test-144/file1
+a7cb8cb9697d59413e0d10495d226398  TEST_DIR/test-144/file2
+7d42a0a2865c94f45435a2ce7627da02  TEST_DIR/test-144/file3
+7f528bc76f4d61ff9cff7bc1906579c6  TEST_DIR/test-144/file4
+ee8004e6298fa128477bd4aa1adc69fb  TEST_DIR/test-144/file5
diff --git a/tests/generic/145 b/tests/generic/145
new file mode 100755
index 0000000..8a14f82
--- /dev/null
+++ b/tests/generic/145
@@ -0,0 +1,142 @@
+#! /bin/bash
+# FS QA Test No. 145
+#
+# Ensure that collapse range steps around reflinked ranges:
+#   - Create three reflink clones of a file
+#   - Collapse the start, middle, and end of the reflink range of each
+#     of the three files, respectively
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
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fcollapse"
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original files"
+BLKSZ=65536
+_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
+
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file3"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file4"
+
+"$XFS_IO_PROG" -f -c "falloc 0 $((BLKSZ * 4))" "$TESTDIR/file1"
+"$XFS_IO_PROG" -f -c "falloc 0 $((BLKSZ * 4))" "$TESTDIR/file2"
+"$XFS_IO_PROG" -f -c "falloc 0 $((BLKSZ * 4))" "$TESTDIR/file3"
+"$XFS_IO_PROG" -f -c "falloc 0 $((BLKSZ * 4))" "$TESTDIR/file4"
+
+_pwrite_byte 0x62 0 $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x63 $BLKSZ $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x63 $BLKSZ $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$TESTDIR/file4" | _filter_test_dir
+md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+md5sum "$TESTDIR/file3.chk" | _filter_test_dir
+md5sum "$TESTDIR/file4.chk" | _filter_test_dir
+
+C1="$(_md5_checksum "$TESTDIR/file1")"
+C2="$(_md5_checksum "$TESTDIR/file2")"
+C3="$(_md5_checksum "$TESTDIR/file3")"
+C4="$(_md5_checksum "$TESTDIR/file4")"
+
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${C1}" = "${C3}" || echo "file1 and file3 should match"
+test "${C1}" = "${C4}" || echo "file1 and file4 should match"
+test "${C2}" = "${C3}" || echo "file2 and file3 should match"
+test "${C2}" = "${C4}" || echo "file2 and file4 should match"
+test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+
+echo "fcollapse files"
+"$XFS_IO_PROG" -f -c "fcollapse 0 $BLKSZ" "$TESTDIR/file2"
+"$XFS_IO_PROG" -f -c "fcollapse $BLKSZ $BLKSZ" "$TESTDIR/file3"
+"$XFS_IO_PROG" -f -c "fcollapse $((BLKSZ * 2)) $BLKSZ" "$TESTDIR/file4"
+_test_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$TESTDIR/file4" | _filter_test_dir
+md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+md5sum "$TESTDIR/file3.chk" | _filter_test_dir
+md5sum "$TESTDIR/file4.chk" | _filter_test_dir
+
+C1="$(_md5_checksum "$TESTDIR/file1")"
+C2="$(_md5_checksum "$TESTDIR/file2")"
+C3="$(_md5_checksum "$TESTDIR/file3")"
+C4="$(_md5_checksum "$TESTDIR/file4")"
+
+test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
+test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
+test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
+test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
+test "${C3}" != "${C4}" || echo "file3 and file4 should not match"
+
+echo "Compare against check files"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s "$TESTDIR/file3" "$TESTDIR/file3.chk" || echo "file3 and file3.chk do not match"
+cmp -s "$TESTDIR/file4" "$TESTDIR/file4.chk" || echo "file4 and file4.chk do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/145.out b/tests/generic/145.out
new file mode 100644
index 0000000..e36c61d
--- /dev/null
+++ b/tests/generic/145.out
@@ -0,0 +1,19 @@
+QA output created by 145
+Create the original files
+564b34fb4a562f6d864f371248e48540  TEST_DIR/test-145/file1
+564b34fb4a562f6d864f371248e48540  TEST_DIR/test-145/file2
+564b34fb4a562f6d864f371248e48540  TEST_DIR/test-145/file3
+564b34fb4a562f6d864f371248e48540  TEST_DIR/test-145/file4
+9a239246ce4bee20f2de1b0ba41a41e0  TEST_DIR/test-145/file2.chk
+859c251680d8bbf0f859f5c6d7a6a2a2  TEST_DIR/test-145/file3.chk
+c931e8500c1a56a5b7369f7f1b971690  TEST_DIR/test-145/file4.chk
+fcollapse files
+Compare files
+564b34fb4a562f6d864f371248e48540  TEST_DIR/test-145/file1
+9a239246ce4bee20f2de1b0ba41a41e0  TEST_DIR/test-145/file2
+859c251680d8bbf0f859f5c6d7a6a2a2  TEST_DIR/test-145/file3
+c931e8500c1a56a5b7369f7f1b971690  TEST_DIR/test-145/file4
+9a239246ce4bee20f2de1b0ba41a41e0  TEST_DIR/test-145/file2.chk
+859c251680d8bbf0f859f5c6d7a6a2a2  TEST_DIR/test-145/file3.chk
+c931e8500c1a56a5b7369f7f1b971690  TEST_DIR/test-145/file4.chk
+Compare against check files
diff --git a/tests/generic/146 b/tests/generic/146
new file mode 100755
index 0000000..9e3eff6
--- /dev/null
+++ b/tests/generic/146
@@ -0,0 +1,136 @@
+#! /bin/bash
+# FS QA Test No. 146
+#
+# Ensure that punch-hole steps around reflinked ranges:
+#   - Create three reflink clones of a file
+#   - Punch the start, middle, and end of the reflink range of each
+#     of the three files, respectively
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
+_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
+
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file3"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file4"
+
+_pwrite_byte 0x00 0 $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $BLKSZ $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$TESTDIR/file4" | _filter_test_dir
+md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+md5sum "$TESTDIR/file3.chk" | _filter_test_dir
+md5sum "$TESTDIR/file4.chk" | _filter_test_dir
+
+C1="$(_md5_checksum "$TESTDIR/file1")"
+C2="$(_md5_checksum "$TESTDIR/file2")"
+C3="$(_md5_checksum "$TESTDIR/file3")"
+C4="$(_md5_checksum "$TESTDIR/file4")"
+
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${C1}" = "${C3}" || echo "file1 and file3 should match"
+test "${C1}" = "${C4}" || echo "file1 and file4 should match"
+test "${C2}" = "${C3}" || echo "file2 and file3 should match"
+test "${C2}" = "${C4}" || echo "file2 and file4 should match"
+test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+
+echo "fpunch files"
+"$XFS_IO_PROG" -f -c "fpunch 0 $BLKSZ" "$TESTDIR/file2"
+"$XFS_IO_PROG" -f -c "fpunch $BLKSZ $BLKSZ" "$TESTDIR/file3"
+"$XFS_IO_PROG" -f -c "fpunch $((BLKSZ * 2)) $BLKSZ" "$TESTDIR/file4"
+_test_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$TESTDIR/file4" | _filter_test_dir
+md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+md5sum "$TESTDIR/file3.chk" | _filter_test_dir
+md5sum "$TESTDIR/file4.chk" | _filter_test_dir
+
+C1="$(_md5_checksum "$TESTDIR/file1")"
+C2="$(_md5_checksum "$TESTDIR/file2")"
+C3="$(_md5_checksum "$TESTDIR/file3")"
+C4="$(_md5_checksum "$TESTDIR/file4")"
+
+test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
+test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
+test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
+test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
+test "${C3}" != "${C4}" || echo "file3 and file4 should not match"
+
+echo "Compare against check files"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s "$TESTDIR/file3" "$TESTDIR/file3.chk" || echo "file3 and file3.chk do not match"
+cmp -s "$TESTDIR/file4" "$TESTDIR/file4.chk" || echo "file4 and file4.chk do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/146.out b/tests/generic/146.out
new file mode 100644
index 0000000..ead7e90
--- /dev/null
+++ b/tests/generic/146.out
@@ -0,0 +1,19 @@
+QA output created by 146
+Create the original files
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-146/file1
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-146/file2
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-146/file3
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-146/file4
+e263fae701bc40c23a3edb20aad5573e  TEST_DIR/test-146/file2.chk
+91722d7c8baf83f300a8dc35f1ffcce2  TEST_DIR/test-146/file3.chk
+c931e8500c1a56a5b7369f7f1b971690  TEST_DIR/test-146/file4.chk
+fpunch files
+Compare files
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-146/file1
+e263fae701bc40c23a3edb20aad5573e  TEST_DIR/test-146/file2
+91722d7c8baf83f300a8dc35f1ffcce2  TEST_DIR/test-146/file3
+c931e8500c1a56a5b7369f7f1b971690  TEST_DIR/test-146/file4
+e263fae701bc40c23a3edb20aad5573e  TEST_DIR/test-146/file2.chk
+91722d7c8baf83f300a8dc35f1ffcce2  TEST_DIR/test-146/file3.chk
+c931e8500c1a56a5b7369f7f1b971690  TEST_DIR/test-146/file4.chk
+Compare against check files
diff --git a/tests/generic/147 b/tests/generic/147
new file mode 100755
index 0000000..c35bdd9
--- /dev/null
+++ b/tests/generic/147
@@ -0,0 +1,139 @@
+#! /bin/bash
+# FS QA Test No. 812
+#
+# Ensure that insert range steps around reflinked ranges:
+#   - Create three reflink clones of a file
+#   - Insert into the start, middle, and end of the reflink range of each
+#     of the three files, respectively
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
+_require_xfs_io_command "finsert"
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original files"
+BLKSZ=65536
+_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
+
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file3"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file4"
+
+_pwrite_byte 0x00 0 $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 $BLKSZ $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x62 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $BLKSZ $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x62 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$TESTDIR/file4" | _filter_test_dir
+md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+md5sum "$TESTDIR/file3.chk" | _filter_test_dir
+md5sum "$TESTDIR/file4.chk" | _filter_test_dir
+
+C1="$(_md5_checksum "$TESTDIR/file1")"
+C2="$(_md5_checksum "$TESTDIR/file2")"
+C3="$(_md5_checksum "$TESTDIR/file3")"
+C4="$(_md5_checksum "$TESTDIR/file4")"
+
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${C1}" = "${C3}" || echo "file1 and file3 should match"
+test "${C1}" = "${C4}" || echo "file1 and file4 should match"
+test "${C2}" = "${C3}" || echo "file2 and file3 should match"
+test "${C2}" = "${C4}" || echo "file2 and file4 should match"
+test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+
+echo "finsert files"
+"$XFS_IO_PROG" -f -c "finsert 0 $BLKSZ" "$TESTDIR/file2"
+"$XFS_IO_PROG" -f -c "finsert $BLKSZ $BLKSZ" "$TESTDIR/file3"
+"$XFS_IO_PROG" -f -c "finsert $((BLKSZ * 2)) $BLKSZ" "$TESTDIR/file4"
+_test_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$TESTDIR/file4" | _filter_test_dir
+md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+md5sum "$TESTDIR/file3.chk" | _filter_test_dir
+md5sum "$TESTDIR/file4.chk" | _filter_test_dir
+
+C1="$(_md5_checksum "$TESTDIR/file1")"
+C2="$(_md5_checksum "$TESTDIR/file2")"
+C3="$(_md5_checksum "$TESTDIR/file3")"
+C4="$(_md5_checksum "$TESTDIR/file4")"
+
+test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
+test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
+test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
+test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
+test "${C3}" != "${C4}" || echo "file3 and file4 should not match"
+
+echo "Compare against check files"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s "$TESTDIR/file3" "$TESTDIR/file3.chk" || echo "file3 and file3.chk do not match"
+cmp -s "$TESTDIR/file4" "$TESTDIR/file4.chk" || echo "file4 and file4.chk do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/147.out b/tests/generic/147.out
new file mode 100644
index 0000000..bee79c2
--- /dev/null
+++ b/tests/generic/147.out
@@ -0,0 +1,19 @@
+QA output created by 147
+Create the original files
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-147/file1
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-147/file2
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-147/file3
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-147/file4
+2b0921503c9f661b7690ac5b42f01f97  TEST_DIR/test-147/file2.chk
+c424badbaad621c331a8ef213b78ac2a  TEST_DIR/test-147/file3.chk
+33b4940294a1d94bee813907d6105ff7  TEST_DIR/test-147/file4.chk
+finsert files
+Compare files
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-147/file1
+2b0921503c9f661b7690ac5b42f01f97  TEST_DIR/test-147/file2
+c424badbaad621c331a8ef213b78ac2a  TEST_DIR/test-147/file3
+33b4940294a1d94bee813907d6105ff7  TEST_DIR/test-147/file4
+2b0921503c9f661b7690ac5b42f01f97  TEST_DIR/test-147/file2.chk
+c424badbaad621c331a8ef213b78ac2a  TEST_DIR/test-147/file3.chk
+33b4940294a1d94bee813907d6105ff7  TEST_DIR/test-147/file4.chk
+Compare against check files
diff --git a/tests/generic/148 b/tests/generic/148
new file mode 100755
index 0000000..3d7a762
--- /dev/null
+++ b/tests/generic/148
@@ -0,0 +1,116 @@
+#! /bin/bash
+# FS QA Test No. 148
+#
+# Ensure that truncating the last block in a reflinked file CoWs appropriately:
+#   - Create a file that doesn't end on a block boundary
+#   - Create two reflink clones of the file
+#   - Shorten one of the clones with truncate
+#   - Lengthen the other clone with truncate
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
+_require_xfs_io_command "truncate"
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original files"
+BLKSZ=65536
+_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 $BLKSZ 37 "$TESTDIR/file1" >> "$seqres.full"
+
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file3"
+
+_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x62 $BLKSZ 34 "$TESTDIR/file2.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x62 $BLKSZ 37 "$TESTDIR/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $((BLKSZ + 37)) 3 "$TESTDIR/file3.chk" >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+md5sum "$TESTDIR/file3.chk" | _filter_test_dir
+
+C1="$(_md5_checksum "$TESTDIR/file1")"
+C2="$(_md5_checksum "$TESTDIR/file2")"
+C3="$(_md5_checksum "$TESTDIR/file3")"
+
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${C1}" = "${C3}" || echo "file1 and file3 should match"
+test "${C2}" = "${C3}" || echo "file2 and file3 should match"
+
+echo "truncate files"
+"$XFS_IO_PROG" -f -c "truncate $((BLKSZ + 34))" "$TESTDIR/file2"
+"$XFS_IO_PROG" -f -c "truncate $((BLKSZ + 40))" "$TESTDIR/file3"
+_test_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+md5sum "$TESTDIR/file3.chk" | _filter_test_dir
+
+C1="$(_md5_checksum "$TESTDIR/file1")"
+C2="$(_md5_checksum "$TESTDIR/file2")"
+C3="$(_md5_checksum "$TESTDIR/file3")"
+
+test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
+test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
+
+echo "Compare against check files"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s "$TESTDIR/file3" "$TESTDIR/file3.chk" || echo "file3 and file3.chk do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/148.out b/tests/generic/148.out
new file mode 100644
index 0000000..1896d95
--- /dev/null
+++ b/tests/generic/148.out
@@ -0,0 +1,15 @@
+QA output created by 148
+Create the original files
+f924bdda449af63913cad4357e39301e  TEST_DIR/test-148/file1
+f924bdda449af63913cad4357e39301e  TEST_DIR/test-148/file2
+f924bdda449af63913cad4357e39301e  TEST_DIR/test-148/file3
+16cb529abe447a9f203a3d5eb3433c8b  TEST_DIR/test-148/file2.chk
+6f042ad39f6c74f4b73936db89baa2e2  TEST_DIR/test-148/file3.chk
+truncate files
+Compare files
+f924bdda449af63913cad4357e39301e  TEST_DIR/test-148/file1
+16cb529abe447a9f203a3d5eb3433c8b  TEST_DIR/test-148/file2
+6f042ad39f6c74f4b73936db89baa2e2  TEST_DIR/test-148/file3
+16cb529abe447a9f203a3d5eb3433c8b  TEST_DIR/test-148/file2.chk
+6f042ad39f6c74f4b73936db89baa2e2  TEST_DIR/test-148/file3.chk
+Compare against check files
diff --git a/tests/generic/149 b/tests/generic/149
new file mode 100755
index 0000000..44b5ae4
--- /dev/null
+++ b/tests/generic/149
@@ -0,0 +1,136 @@
+#! /bin/bash
+# FS QA Test No. 813
+#
+# Ensure that zero-range steps around reflinked ranges:
+#   - Create three reflink clones of a file
+#   - Zero-range the start, middle, and end of the reflink range of each
+#     of the three files, respectively
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
+_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
+
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file3"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file4"
+
+_pwrite_byte 0x00 0 $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $BLKSZ $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x63 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$TESTDIR/file4" | _filter_test_dir
+md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+md5sum "$TESTDIR/file3.chk" | _filter_test_dir
+md5sum "$TESTDIR/file4.chk" | _filter_test_dir
+
+C1="$(_md5_checksum "$TESTDIR/file1")"
+C2="$(_md5_checksum "$TESTDIR/file2")"
+C3="$(_md5_checksum "$TESTDIR/file3")"
+C4="$(_md5_checksum "$TESTDIR/file4")"
+
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${C1}" = "${C3}" || echo "file1 and file3 should match"
+test "${C1}" = "${C4}" || echo "file1 and file4 should match"
+test "${C2}" = "${C3}" || echo "file2 and file3 should match"
+test "${C2}" = "${C4}" || echo "file2 and file4 should match"
+test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+
+echo "fzero files"
+"$XFS_IO_PROG" -f -c "fzero 0 $BLKSZ" "$TESTDIR/file2"
+"$XFS_IO_PROG" -f -c "fzero $BLKSZ $BLKSZ" "$TESTDIR/file3"
+"$XFS_IO_PROG" -f -c "fzero $((BLKSZ * 2)) $BLKSZ" "$TESTDIR/file4"
+_test_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$TESTDIR/file4" | _filter_test_dir
+md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+md5sum "$TESTDIR/file3.chk" | _filter_test_dir
+md5sum "$TESTDIR/file4.chk" | _filter_test_dir
+
+C1="$(_md5_checksum "$TESTDIR/file1")"
+C2="$(_md5_checksum "$TESTDIR/file2")"
+C3="$(_md5_checksum "$TESTDIR/file3")"
+C4="$(_md5_checksum "$TESTDIR/file4")"
+
+test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
+test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
+test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
+test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
+test "${C3}" != "${C4}" || echo "file3 and file4 should not match"
+
+echo "Compare against check files"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s "$TESTDIR/file3" "$TESTDIR/file3.chk" || echo "file3 and file3.chk do not match"
+cmp -s "$TESTDIR/file4" "$TESTDIR/file4.chk" || echo "file4 and file4.chk do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/149.out b/tests/generic/149.out
new file mode 100644
index 0000000..dc3ceda
--- /dev/null
+++ b/tests/generic/149.out
@@ -0,0 +1,19 @@
+QA output created by 149
+Create the original files
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-149/file1
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-149/file2
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-149/file3
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-149/file4
+e263fae701bc40c23a3edb20aad5573e  TEST_DIR/test-149/file2.chk
+91722d7c8baf83f300a8dc35f1ffcce2  TEST_DIR/test-149/file3.chk
+c931e8500c1a56a5b7369f7f1b971690  TEST_DIR/test-149/file4.chk
+fzero files
+Compare files
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-149/file1
+e263fae701bc40c23a3edb20aad5573e  TEST_DIR/test-149/file2
+91722d7c8baf83f300a8dc35f1ffcce2  TEST_DIR/test-149/file3
+c931e8500c1a56a5b7369f7f1b971690  TEST_DIR/test-149/file4
+e263fae701bc40c23a3edb20aad5573e  TEST_DIR/test-149/file2.chk
+91722d7c8baf83f300a8dc35f1ffcce2  TEST_DIR/test-149/file3.chk
+c931e8500c1a56a5b7369f7f1b971690  TEST_DIR/test-149/file4.chk
+Compare against check files
diff --git a/tests/generic/group b/tests/generic/group
index 7b55707..477c52b 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -146,6 +146,12 @@
 141 rw auto quick
 142 auto quick clone
 143 auto quick clone
+144 auto quick clone
+145 auto quick clone
+146 auto quick clone
+147 auto quick clone
+148 auto quick clone
+149 auto quick clone
 169 rw metadata auto quick
 184 metadata auto quick
 192 atime auto

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
