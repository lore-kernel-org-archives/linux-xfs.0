Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C8B3729EFE
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:13:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B2E268F8049
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:13:57 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id i4EyrKQW136igWzW (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:13:53 -0700 (PDT)
Subject: [PATCH 06/12] reflink: test the various fallocate modes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:13:44 -0700
Message-ID: <20151007051344.3260.75717.stgit@birch.djwong.org>
In-Reply-To: <20151007051257.3260.73072.stgit@birch.djwong.org>
References: <20151007051257.3260.73072.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Check that the variants of fallocate (allocate, punch, zero range,
collapse range, insert range) do the right thing when they're run
against a range of reflinked blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/811     |  126 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/811.out |    6 ++
 tests/generic/812     |  116 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/812.out |    5 ++
 tests/generic/813     |  112 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/813.out |    5 ++
 tests/generic/814     |  112 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/814.out |    5 ++
 tests/generic/815     |  103 ++++++++++++++++++++++++++++++++++++++++
 tests/generic/815.out |    5 ++
 tests/generic/816     |  112 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/816.out |    5 ++
 tests/generic/group   |    6 ++
 13 files changed, 718 insertions(+)
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
index 0000000..8d3aa90
--- /dev/null
+++ b/tests/generic/811
@@ -0,0 +1,126 @@
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
+_require_xfs_io_command "reflink"
+_require_xfs_io_command "falloc"
+_require_cp_reflink
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
+$XFS_IO_PROG -f -c "truncate $((BLKSZ * 5))" -c "pwrite -S 0x61 0 $(( (BLKSZ * 5) + 37))" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $((BLKSZ * 5))" -c "reflink $TESTDIR/file1 $BLKSZ $BLKSZ $(( (BLKSZ * 4) + 37))" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $((BLKSZ * 5))" -c "reflink $TESTDIR/file1 0 0 $BLKSZ" $TESTDIR/file3 >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $((BLKSZ * 5))" -c "reflink $TESTDIR/file1 $BLKSZ $BLKSZ $BLKSZ" $TESTDIR/file4 >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $((BLKSZ * 5))" -c "reflink $TESTDIR/file1 $((BLKSZ * 3)) $((BLKSZ * 3)) $BLKSZ" $TESTDIR/file4 >> $seqres.full
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file5
+_test_remount
+
+echo "Compare sections"
+c0=$(_md5_range_checksum $TESTDIR/file1 $BLKSZ $(( BLKSZ * 4 + 37 )))
+c1=$(_md5_range_checksum $TESTDIR/file2 $BLKSZ $(( BLKSZ * 4 + 37 )))
+test $c0 = $c1 || echo "shared parts of files 1-2 changed"
+
+c0=$(_md5_range_checksum $TESTDIR/file1 0 $BLKSZ)
+c1=$(_md5_range_checksum $TESTDIR/file3 0 $BLKSZ)
+test $c0 = $c1 || echo "shared parts of files 1-3 changed"
+
+c0=$(_md5_range_checksum $TESTDIR/file1 $BLKSZ $BLKSZ)
+c1=$(_md5_range_checksum $TESTDIR/file4 $BLKSZ $BLKSZ)
+test $c0 = $c1 || echo "shared parts of files 1-4 changed"
+
+c0=$(_md5_range_checksum $TESTDIR/file1 0 $((BLKSZ * 5 + 37)))
+c1=$(_md5_range_checksum $TESTDIR/file5 0 $((BLKSZ * 5 + 37)))
+test $c0 = $c1 || echo "shared parts of files 1-5 changed"
+
+echo "Compare files"
+C1="$(_md5_checksum $TESTDIR/file1)"
+C2="$(_md5_checksum $TESTDIR/file2)"
+C3="$(_md5_checksum $TESTDIR/file3)"
+C4="$(_md5_checksum $TESTDIR/file4)"
+C5="$(_md5_checksum $TESTDIR/file5)"
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
+$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * 5))" $TESTDIR/file2
+$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * 5))" $TESTDIR/file3
+$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * 5))" $TESTDIR/file4
+_test_remount
+
+echo "Compare files"
+D1="$(_md5_checksum $TESTDIR/file1)"
+D2="$(_md5_checksum $TESTDIR/file2)"
+D3="$(_md5_checksum $TESTDIR/file3)"
+D4="$(_md5_checksum $TESTDIR/file4)"
+D5="$(_md5_checksum $TESTDIR/file5)"
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
index 0000000..d9fa011
--- /dev/null
+++ b/tests/generic/811.out
@@ -0,0 +1,6 @@
+QA output created by 811
+Create the original files
+Compare sections
+Compare files
+falloc everything
+Compare files
diff --git a/tests/generic/812 b/tests/generic/812
new file mode 100755
index 0000000..0564ec3
--- /dev/null
+++ b/tests/generic/812
@@ -0,0 +1,116 @@
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
+_require_xfs_io_command "fcollapse"
+_require_cp_reflink
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
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $BLKSZ $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file1 >> $seqres.full
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file2
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file3
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file4
+$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * 4))" $TESTDIR/file1
+$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * 4))" $TESTDIR/file2
+$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * 4))" $TESTDIR/file3
+$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * 4))" $TESTDIR/file4
+
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $BLKSZ" -c "pwrite -S 0x63 $BLKSZ $BLKSZ" -c "pwrite -S 0x00 $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file2.chk >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" -c "pwrite -S 0x63 $BLKSZ $BLKSZ" -c "pwrite -S 0x00 $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file3.chk >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" -c "pwrite -S 0x62 $BLKSZ $BLKSZ" -c "pwrite -S 0x00 $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file4.chk >> $seqres.full
+_test_remount
+
+C1="$(_md5_checksum $TESTDIR/file1)"
+C2="$(_md5_checksum $TESTDIR/file2)"
+C3="$(_md5_checksum $TESTDIR/file3)"
+C4="$(_md5_checksum $TESTDIR/file4)"
+
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${C1}" = "${C3}" || echo "file1 and file3 should match"
+test "${C1}" = "${C4}" || echo "file1 and file4 should match"
+test "${C2}" = "${C3}" || echo "file2 and file3 should match"
+test "${C2}" = "${C4}" || echo "file2 and file4 should match"
+test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+
+echo "fcollapse files"
+$XFS_IO_PROG -f -c "fcollapse 0 $BLKSZ" $TESTDIR/file2
+$XFS_IO_PROG -f -c "fcollapse $BLKSZ $BLKSZ" $TESTDIR/file3
+$XFS_IO_PROG -f -c "fcollapse $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file4
+_test_remount
+
+echo "Compare files"
+C1="$(_md5_checksum $TESTDIR/file1)"
+C2="$(_md5_checksum $TESTDIR/file2)"
+C3="$(_md5_checksum $TESTDIR/file3)"
+C4="$(_md5_checksum $TESTDIR/file4)"
+
+test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
+test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
+test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
+test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
+test "${C3}" != "${C4}" || echo "file3 and file4 should not match"
+
+echo "Compare against check files"
+cmp -s $TESTDIR/file2 $TESTDIR/file2.chk || echo "file2 and file2.chk do not match"
+cmp -s $TESTDIR/file3 $TESTDIR/file3.chk || echo "file3 and file3.chk do not match"
+cmp -s $TESTDIR/file4 $TESTDIR/file4.chk || echo "file4 and file4.chk do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/812.out b/tests/generic/812.out
new file mode 100644
index 0000000..6f3e403
--- /dev/null
+++ b/tests/generic/812.out
@@ -0,0 +1,5 @@
+QA output created by 812
+Create the original files
+fcollapse files
+Compare files
+Compare against check files
diff --git a/tests/generic/813 b/tests/generic/813
new file mode 100755
index 0000000..ee399fc
--- /dev/null
+++ b/tests/generic/813
@@ -0,0 +1,112 @@
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
+_require_xfs_io_command "fpunch"
+_require_cp_reflink
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
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $BLKSZ $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file1 >> $seqres.full
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file2
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file3
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file4
+
+$XFS_IO_PROG -f -c "pwrite -S 0x00 0 $BLKSZ" -c "pwrite -S 0x62 $BLKSZ $BLKSZ" -c "pwrite -S 0x63 $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file2.chk >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" -c "pwrite -S 0x00 $BLKSZ $BLKSZ" -c "pwrite -S 0x63 $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file3.chk >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" -c "pwrite -S 0x62 $BLKSZ $BLKSZ" -c "pwrite -S 0x00 $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file4.chk >> $seqres.full
+_test_remount
+
+C1="$(_md5_checksum $TESTDIR/file1)"
+C2="$(_md5_checksum $TESTDIR/file2)"
+C3="$(_md5_checksum $TESTDIR/file3)"
+C4="$(_md5_checksum $TESTDIR/file4)"
+
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${C1}" = "${C3}" || echo "file1 and file3 should match"
+test "${C1}" = "${C4}" || echo "file1 and file4 should match"
+test "${C2}" = "${C3}" || echo "file2 and file3 should match"
+test "${C2}" = "${C4}" || echo "file2 and file4 should match"
+test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+
+echo "fpunch files"
+$XFS_IO_PROG -f -c "fpunch 0 $BLKSZ" $TESTDIR/file2
+$XFS_IO_PROG -f -c "fpunch $BLKSZ $BLKSZ" $TESTDIR/file3
+$XFS_IO_PROG -f -c "fpunch $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file4
+_test_remount
+
+echo "Compare files"
+C1="$(_md5_checksum $TESTDIR/file1)"
+C2="$(_md5_checksum $TESTDIR/file2)"
+C3="$(_md5_checksum $TESTDIR/file3)"
+C4="$(_md5_checksum $TESTDIR/file4)"
+
+test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
+test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
+test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
+test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
+test "${C3}" != "${C4}" || echo "file3 and file4 should not match"
+
+echo "Compare against check files"
+cmp -s $TESTDIR/file2 $TESTDIR/file2.chk || echo "file2 and file2.chk do not match"
+cmp -s $TESTDIR/file3 $TESTDIR/file3.chk || echo "file3 and file3.chk do not match"
+cmp -s $TESTDIR/file4 $TESTDIR/file4.chk || echo "file4 and file4.chk do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/813.out b/tests/generic/813.out
new file mode 100644
index 0000000..c4de817
--- /dev/null
+++ b/tests/generic/813.out
@@ -0,0 +1,5 @@
+QA output created by 813
+Create the original files
+fpunch files
+Compare files
+Compare against check files
diff --git a/tests/generic/814 b/tests/generic/814
new file mode 100755
index 0000000..55ac879
--- /dev/null
+++ b/tests/generic/814
@@ -0,0 +1,112 @@
+#! /bin/bash
+# FS QA Test No. 814
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
+_require_xfs_io_command "finsert"
+_require_cp_reflink
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
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $BLKSZ $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file1 >> $seqres.full
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file2
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file3
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file4
+
+$XFS_IO_PROG -f -c "pwrite -S 0x00 0 $BLKSZ" -c "pwrite -S 0x61 $BLKSZ $BLKSZ" -c "pwrite -S 0x62 $((BLKSZ * 2)) $BLKSZ" -c "pwrite -S 0x63 $((BLKSZ * 3)) $BLKSZ" $TESTDIR/file2.chk >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" -c "pwrite -S 0x00 $BLKSZ $BLKSZ" -c "pwrite -S 0x62 $((BLKSZ * 2)) $BLKSZ" -c "pwrite -S 0x63 $((BLKSZ * 3)) $BLKSZ" $TESTDIR/file3.chk >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" -c "pwrite -S 0x62 $BLKSZ $BLKSZ" -c "pwrite -S 0x00 $((BLKSZ * 2)) $BLKSZ" -c "pwrite -S 0x63 $((BLKSZ * 3)) $BLKSZ" $TESTDIR/file4.chk >> $seqres.full
+_test_remount
+
+C1="$(_md5_checksum $TESTDIR/file1)"
+C2="$(_md5_checksum $TESTDIR/file2)"
+C3="$(_md5_checksum $TESTDIR/file3)"
+C4="$(_md5_checksum $TESTDIR/file4)"
+
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${C1}" = "${C3}" || echo "file1 and file3 should match"
+test "${C1}" = "${C4}" || echo "file1 and file4 should match"
+test "${C2}" = "${C3}" || echo "file2 and file3 should match"
+test "${C2}" = "${C4}" || echo "file2 and file4 should match"
+test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+
+echo "finsert files"
+$XFS_IO_PROG -f -c "finsert 0 $BLKSZ" $TESTDIR/file2
+$XFS_IO_PROG -f -c "finsert $BLKSZ $BLKSZ" $TESTDIR/file3
+$XFS_IO_PROG -f -c "finsert $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file4
+_test_remount
+
+echo "Compare files"
+C1="$(_md5_checksum $TESTDIR/file1)"
+C2="$(_md5_checksum $TESTDIR/file2)"
+C3="$(_md5_checksum $TESTDIR/file3)"
+C4="$(_md5_checksum $TESTDIR/file4)"
+
+test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
+test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
+test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
+test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
+test "${C3}" != "${C4}" || echo "file3 and file4 should not match"
+
+echo "Compare against check files"
+cmp -s $TESTDIR/file2 $TESTDIR/file2.chk || echo "file2 and file2.chk do not match"
+cmp -s $TESTDIR/file3 $TESTDIR/file3.chk || echo "file3 and file3.chk do not match"
+cmp -s $TESTDIR/file4 $TESTDIR/file4.chk || echo "file4 and file4.chk do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/814.out b/tests/generic/814.out
new file mode 100644
index 0000000..c80eccb
--- /dev/null
+++ b/tests/generic/814.out
@@ -0,0 +1,5 @@
+QA output created by 814
+Create the original files
+finsert files
+Compare files
+Compare against check files
diff --git a/tests/generic/815 b/tests/generic/815
new file mode 100755
index 0000000..eb835ef
--- /dev/null
+++ b/tests/generic/815
@@ -0,0 +1,103 @@
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
+_require_xfs_io_command "truncate"
+_require_cp_reflink
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
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $BLKSZ 37" $TESTDIR/file1 >> $seqres.full
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file2
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file3
+
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" $TESTDIR/file2.chk >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $BLKSZ 34" $TESTDIR/file2.chk >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" $TESTDIR/file3.chk >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $BLKSZ 37" $TESTDIR/file3.chk >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x00 $((BLKSZ + 37)) 3" $TESTDIR/file3.chk >> $seqres.full
+_test_remount
+
+C1="$(_md5_checksum $TESTDIR/file1)"
+C2="$(_md5_checksum $TESTDIR/file2)"
+C3="$(_md5_checksum $TESTDIR/file3)"
+
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${C1}" = "${C3}" || echo "file1 and file3 should match"
+test "${C2}" = "${C3}" || echo "file2 and file3 should match"
+
+echo "truncate files"
+$XFS_IO_PROG -f -c "truncate $((BLKSZ + 34))" $TESTDIR/file2
+$XFS_IO_PROG -f -c "truncate $((BLKSZ + 40))" $TESTDIR/file3
+_test_remount
+
+echo "Compare files"
+C1="$(_md5_checksum $TESTDIR/file1)"
+C2="$(_md5_checksum $TESTDIR/file2)"
+C3="$(_md5_checksum $TESTDIR/file3)"
+
+test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
+test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
+
+echo "Compare against check files"
+cmp -s $TESTDIR/file2 $TESTDIR/file2.chk || echo "file2 and file2.chk do not match"
+cmp -s $TESTDIR/file3 $TESTDIR/file3.chk || echo "file3 and file3.chk do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/815.out b/tests/generic/815.out
new file mode 100644
index 0000000..1804af5
--- /dev/null
+++ b/tests/generic/815.out
@@ -0,0 +1,5 @@
+QA output created by 815
+Create the original files
+truncate files
+Compare files
+Compare against check files
diff --git a/tests/generic/816 b/tests/generic/816
new file mode 100755
index 0000000..121cde0
--- /dev/null
+++ b/tests/generic/816
@@ -0,0 +1,112 @@
+#! /bin/bash
+# FS QA Test No. 816
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
+_require_xfs_io_command "fzero"
+_require_cp_reflink
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
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $BLKSZ $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file1 >> $seqres.full
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file2
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file3
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file4
+
+$XFS_IO_PROG -f -c "pwrite -S 0x00 0 $BLKSZ" -c "pwrite -S 0x62 $BLKSZ $BLKSZ" -c "pwrite -S 0x63 $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file2.chk >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" -c "pwrite -S 0x00 $BLKSZ $BLKSZ" -c "pwrite -S 0x63 $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file3.chk >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" -c "pwrite -S 0x62 $BLKSZ $BLKSZ" -c "pwrite -S 0x00 $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file4.chk >> $seqres.full
+_test_remount
+
+C1="$(_md5_checksum $TESTDIR/file1)"
+C2="$(_md5_checksum $TESTDIR/file2)"
+C3="$(_md5_checksum $TESTDIR/file3)"
+C4="$(_md5_checksum $TESTDIR/file4)"
+
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${C1}" = "${C3}" || echo "file1 and file3 should match"
+test "${C1}" = "${C4}" || echo "file1 and file4 should match"
+test "${C2}" = "${C3}" || echo "file2 and file3 should match"
+test "${C2}" = "${C4}" || echo "file2 and file4 should match"
+test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+
+echo "fzero files"
+$XFS_IO_PROG -f -c "fzero 0 $BLKSZ" $TESTDIR/file2
+$XFS_IO_PROG -f -c "fzero $BLKSZ $BLKSZ" $TESTDIR/file3
+$XFS_IO_PROG -f -c "fzero $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file4
+_test_remount
+
+echo "Compare files"
+C1="$(_md5_checksum $TESTDIR/file1)"
+C2="$(_md5_checksum $TESTDIR/file2)"
+C3="$(_md5_checksum $TESTDIR/file3)"
+C4="$(_md5_checksum $TESTDIR/file4)"
+
+test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
+test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
+test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
+test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
+test "${C3}" != "${C4}" || echo "file3 and file4 should not match"
+
+echo "Compare against check files"
+cmp -s $TESTDIR/file2 $TESTDIR/file2.chk || echo "file2 and file2.chk do not match"
+cmp -s $TESTDIR/file3 $TESTDIR/file3.chk || echo "file3 and file3.chk do not match"
+cmp -s $TESTDIR/file4 $TESTDIR/file4.chk || echo "file4 and file4.chk do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/816.out b/tests/generic/816.out
new file mode 100644
index 0000000..2071d87
--- /dev/null
+++ b/tests/generic/816.out
@@ -0,0 +1,5 @@
+QA output created by 816
+Create the original files
+fzero files
+Compare files
+Compare against check files
diff --git a/tests/generic/group b/tests/generic/group
index 6734822..b4ba56a 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -218,6 +218,12 @@
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
