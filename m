Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4A1C47F63
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 13:27:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2C87E304043
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:27:33 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id SlEklS3EWFDkLaID (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:27:28 -0800 (PST)
Subject: [PATCH 05/11] reflink: test the various fallocate modes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Nov 2015 11:27:03 -0800
Message-ID: <20151111192703.15056.62918.stgit@birch.djwong.org>
In-Reply-To: <20151111192628.15056.6451.stgit@birch.djwong.org>
References: <20151111192628.15056.6451.stgit@birch.djwong.org>
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
To: hch@infradead.org, david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

Check that the variants of fallocate (allocate, punch, zero range,
collapse range, insert range) do the right thing when they're run
against a range of reflinked blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/811     |  142 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/811.out |   16 ++++++
 tests/generic/812     |  142 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/812.out |   19 +++++++
 tests/generic/813     |  136 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/813.out |   19 +++++++
 tests/generic/814     |  139 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/814.out |   19 +++++++
 tests/generic/815     |  116 ++++++++++++++++++++++++++++++++++++++++
 tests/generic/815.out |   15 +++++
 tests/generic/816     |  136 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/816.out |   19 +++++++
 tests/generic/group   |    6 ++
 13 files changed, 924 insertions(+)
 create mode 100755 tests/generic/811
 create mode 100644 tests/generic/811.out
 create mode 100755 tests/generic/812
 create mode 100644 tests/generic/812.out
 create mode 100755 tests/generic/813
 create mode 100644 tests/generic/813.out
 create mode 100755 tests/generic/814
 create mode 100644 tests/generic/814.out
 create mode 100755 tests/generic/815
 create mode 100644 tests/generic/815.out
 create mode 100755 tests/generic/816
 create mode 100644 tests/generic/816.out


diff --git a/tests/generic/811 b/tests/generic/811
new file mode 100755
index 0000000..7b09c05
--- /dev/null
+++ b/tests/generic/811
@@ -0,0 +1,142 @@
+#! /bin/bash
+# FS QA Test No. 811
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
diff --git a/tests/generic/811.out b/tests/generic/811.out
new file mode 100644
index 0000000..950613a
--- /dev/null
+++ b/tests/generic/811.out
@@ -0,0 +1,16 @@
+QA output created by 811
+Create the original files
+Compare sections
+ee8004e6298fa128477bd4aa1adc69fb  TEST_DIR/test-811/file1
+a7cb8cb9697d59413e0d10495d226398  TEST_DIR/test-811/file2
+7d42a0a2865c94f45435a2ce7627da02  TEST_DIR/test-811/file3
+7f528bc76f4d61ff9cff7bc1906579c6  TEST_DIR/test-811/file4
+ee8004e6298fa128477bd4aa1adc69fb  TEST_DIR/test-811/file5
+Compare files
+falloc everything
+Compare files
+ee8004e6298fa128477bd4aa1adc69fb  TEST_DIR/test-811/file1
+a7cb8cb9697d59413e0d10495d226398  TEST_DIR/test-811/file2
+7d42a0a2865c94f45435a2ce7627da02  TEST_DIR/test-811/file3
+7f528bc76f4d61ff9cff7bc1906579c6  TEST_DIR/test-811/file4
+ee8004e6298fa128477bd4aa1adc69fb  TEST_DIR/test-811/file5
diff --git a/tests/generic/812 b/tests/generic/812
new file mode 100755
index 0000000..0c7647f
--- /dev/null
+++ b/tests/generic/812
@@ -0,0 +1,142 @@
+#! /bin/bash
+# FS QA Test No. 812
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
diff --git a/tests/generic/812.out b/tests/generic/812.out
new file mode 100644
index 0000000..16dc3df
--- /dev/null
+++ b/tests/generic/812.out
@@ -0,0 +1,19 @@
+QA output created by 812
+Create the original files
+564b34fb4a562f6d864f371248e48540  TEST_DIR/test-812/file1
+564b34fb4a562f6d864f371248e48540  TEST_DIR/test-812/file2
+564b34fb4a562f6d864f371248e48540  TEST_DIR/test-812/file3
+564b34fb4a562f6d864f371248e48540  TEST_DIR/test-812/file4
+9a239246ce4bee20f2de1b0ba41a41e0  TEST_DIR/test-812/file2.chk
+859c251680d8bbf0f859f5c6d7a6a2a2  TEST_DIR/test-812/file3.chk
+c931e8500c1a56a5b7369f7f1b971690  TEST_DIR/test-812/file4.chk
+fcollapse files
+Compare files
+564b34fb4a562f6d864f371248e48540  TEST_DIR/test-812/file1
+9a239246ce4bee20f2de1b0ba41a41e0  TEST_DIR/test-812/file2
+859c251680d8bbf0f859f5c6d7a6a2a2  TEST_DIR/test-812/file3
+c931e8500c1a56a5b7369f7f1b971690  TEST_DIR/test-812/file4
+9a239246ce4bee20f2de1b0ba41a41e0  TEST_DIR/test-812/file2.chk
+859c251680d8bbf0f859f5c6d7a6a2a2  TEST_DIR/test-812/file3.chk
+c931e8500c1a56a5b7369f7f1b971690  TEST_DIR/test-812/file4.chk
+Compare against check files
diff --git a/tests/generic/813 b/tests/generic/813
new file mode 100755
index 0000000..d313bc7
--- /dev/null
+++ b/tests/generic/813
@@ -0,0 +1,136 @@
+#! /bin/bash
+# FS QA Test No. 813
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
diff --git a/tests/generic/813.out b/tests/generic/813.out
new file mode 100644
index 0000000..98fda42
--- /dev/null
+++ b/tests/generic/813.out
@@ -0,0 +1,19 @@
+QA output created by 813
+Create the original files
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-813/file1
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-813/file2
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-813/file3
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-813/file4
+e263fae701bc40c23a3edb20aad5573e  TEST_DIR/test-813/file2.chk
+91722d7c8baf83f300a8dc35f1ffcce2  TEST_DIR/test-813/file3.chk
+c931e8500c1a56a5b7369f7f1b971690  TEST_DIR/test-813/file4.chk
+fpunch files
+Compare files
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-813/file1
+e263fae701bc40c23a3edb20aad5573e  TEST_DIR/test-813/file2
+91722d7c8baf83f300a8dc35f1ffcce2  TEST_DIR/test-813/file3
+c931e8500c1a56a5b7369f7f1b971690  TEST_DIR/test-813/file4
+e263fae701bc40c23a3edb20aad5573e  TEST_DIR/test-813/file2.chk
+91722d7c8baf83f300a8dc35f1ffcce2  TEST_DIR/test-813/file3.chk
+c931e8500c1a56a5b7369f7f1b971690  TEST_DIR/test-813/file4.chk
+Compare against check files
diff --git a/tests/generic/814 b/tests/generic/814
new file mode 100755
index 0000000..c35bdd9
--- /dev/null
+++ b/tests/generic/814
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
diff --git a/tests/generic/814.out b/tests/generic/814.out
new file mode 100644
index 0000000..6093561
--- /dev/null
+++ b/tests/generic/814.out
@@ -0,0 +1,19 @@
+QA output created by 814
+Create the original files
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-814/file1
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-814/file2
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-814/file3
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-814/file4
+2b0921503c9f661b7690ac5b42f01f97  TEST_DIR/test-814/file2.chk
+c424badbaad621c331a8ef213b78ac2a  TEST_DIR/test-814/file3.chk
+33b4940294a1d94bee813907d6105ff7  TEST_DIR/test-814/file4.chk
+finsert files
+Compare files
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-814/file1
+2b0921503c9f661b7690ac5b42f01f97  TEST_DIR/test-814/file2
+c424badbaad621c331a8ef213b78ac2a  TEST_DIR/test-814/file3
+33b4940294a1d94bee813907d6105ff7  TEST_DIR/test-814/file4
+2b0921503c9f661b7690ac5b42f01f97  TEST_DIR/test-814/file2.chk
+c424badbaad621c331a8ef213b78ac2a  TEST_DIR/test-814/file3.chk
+33b4940294a1d94bee813907d6105ff7  TEST_DIR/test-814/file4.chk
+Compare against check files
diff --git a/tests/generic/815 b/tests/generic/815
new file mode 100755
index 0000000..8d545ee
--- /dev/null
+++ b/tests/generic/815
@@ -0,0 +1,116 @@
+#! /bin/bash
+# FS QA Test No. 815
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
diff --git a/tests/generic/815.out b/tests/generic/815.out
new file mode 100644
index 0000000..8c36c2d
--- /dev/null
+++ b/tests/generic/815.out
@@ -0,0 +1,15 @@
+QA output created by 815
+Create the original files
+f924bdda449af63913cad4357e39301e  TEST_DIR/test-815/file1
+f924bdda449af63913cad4357e39301e  TEST_DIR/test-815/file2
+f924bdda449af63913cad4357e39301e  TEST_DIR/test-815/file3
+16cb529abe447a9f203a3d5eb3433c8b  TEST_DIR/test-815/file2.chk
+6f042ad39f6c74f4b73936db89baa2e2  TEST_DIR/test-815/file3.chk
+truncate files
+Compare files
+f924bdda449af63913cad4357e39301e  TEST_DIR/test-815/file1
+16cb529abe447a9f203a3d5eb3433c8b  TEST_DIR/test-815/file2
+6f042ad39f6c74f4b73936db89baa2e2  TEST_DIR/test-815/file3
+16cb529abe447a9f203a3d5eb3433c8b  TEST_DIR/test-815/file2.chk
+6f042ad39f6c74f4b73936db89baa2e2  TEST_DIR/test-815/file3.chk
+Compare against check files
diff --git a/tests/generic/816 b/tests/generic/816
new file mode 100755
index 0000000..44b5ae4
--- /dev/null
+++ b/tests/generic/816
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
diff --git a/tests/generic/816.out b/tests/generic/816.out
new file mode 100644
index 0000000..f3e1396
--- /dev/null
+++ b/tests/generic/816.out
@@ -0,0 +1,19 @@
+QA output created by 816
+Create the original files
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-816/file1
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-816/file2
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-816/file3
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-816/file4
+e263fae701bc40c23a3edb20aad5573e  TEST_DIR/test-816/file2.chk
+91722d7c8baf83f300a8dc35f1ffcce2  TEST_DIR/test-816/file3.chk
+c931e8500c1a56a5b7369f7f1b971690  TEST_DIR/test-816/file4.chk
+fzero files
+Compare files
+856bb58abaf1ac79aa1aa45b7de7218b  TEST_DIR/test-816/file1
+e263fae701bc40c23a3edb20aad5573e  TEST_DIR/test-816/file2
+91722d7c8baf83f300a8dc35f1ffcce2  TEST_DIR/test-816/file3
+c931e8500c1a56a5b7369f7f1b971690  TEST_DIR/test-816/file4
+e263fae701bc40c23a3edb20aad5573e  TEST_DIR/test-816/file2.chk
+91722d7c8baf83f300a8dc35f1ffcce2  TEST_DIR/test-816/file3.chk
+c931e8500c1a56a5b7369f7f1b971690  TEST_DIR/test-816/file4.chk
+Compare against check files
diff --git a/tests/generic/group b/tests/generic/group
index a72d416..58c68c8 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -219,6 +219,12 @@
 808 auto quick clone
 809 auto quick clone
 810 auto quick clone
+811 auto quick clone
+812 auto quick clone
+813 auto quick clone
+814 auto quick clone
+815 auto quick clone
+816 auto quick clone
 817 auto quick clone
 818 auto quick clone
 819 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
