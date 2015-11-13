Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B5EA47F7C
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 15:37:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A6F0B8F804C
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 13:37:45 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 4muQNeN2ljJAe89D (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Nov 2015 13:37:40 -0800 (PST)
Subject: [PATCH 04/12] reflink: basic tests of the reflink and dedupe ioctls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 13 Nov 2015 13:37:09 -0800
Message-ID: <20151113213709.31124.35294.stgit@birch.djwong.org>
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

Test the operation of the btrfs (and now xfs) reflink and dedupe
ioctls at various file offsets and with matching and nonmatching
files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/116     |   92 +++++++++++++++++++++++++++
 tests/generic/116.out |    8 ++
 tests/generic/118     |   93 +++++++++++++++++++++++++++
 tests/generic/118.out |   11 +++
 tests/generic/119     |  170 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/119.out |   30 +++++++++
 tests/generic/121     |   92 +++++++++++++++++++++++++++
 tests/generic/121.out |    8 ++
 tests/generic/122     |   92 +++++++++++++++++++++++++++
 tests/generic/122.out |   12 +++
 tests/generic/134     |  128 +++++++++++++++++++++++++++++++++++++
 tests/generic/134.out |   16 +++++
 tests/generic/136     |  128 +++++++++++++++++++++++++++++++++++++
 tests/generic/136.out |   17 +++++
 tests/generic/137     |  131 ++++++++++++++++++++++++++++++++++++++
 tests/generic/137.out |    8 ++
 tests/generic/group   |    8 ++
 17 files changed, 1044 insertions(+)
 create mode 100755 tests/generic/116
 create mode 100644 tests/generic/116.out
 create mode 100755 tests/generic/118
 create mode 100644 tests/generic/118.out
 create mode 100755 tests/generic/119
 create mode 100644 tests/generic/119.out
 create mode 100755 tests/generic/121
 create mode 100644 tests/generic/121.out
 create mode 100755 tests/generic/122
 create mode 100644 tests/generic/122.out
 create mode 100755 tests/generic/134
 create mode 100644 tests/generic/134.out
 create mode 100755 tests/generic/136
 create mode 100644 tests/generic/136.out
 create mode 100755 tests/generic/137
 create mode 100644 tests/generic/137.out


diff --git a/tests/generic/116 b/tests/generic/116
new file mode 100755
index 0000000..2b4b505
--- /dev/null
+++ b/tests/generic/116
@@ -0,0 +1,92 @@
+#! /bin/bash
+# FS QA Test No. 116
+#
+# Ensure that we can reflink parts of two identical files:
+#   - Reflink identical parts of two identical files
+#   - Check that we still have identical contents
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
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original files"
+BLKSZ=65536
+_pwrite_byte 0x61 $((BLKSZ * 2)) $((BLKSZ * 6)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x61 $((BLKSZ * 2)) $((BLKSZ * 6)) "$TESTDIR/file2" >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 8)) \
+       || echo "Files do not match"
+
+echo "Reflink the middle blocks together"
+free_before="$(stat -f -c '%a' "$TESTDIR")"
+_reflink_range "$TESTDIR/file1" $((BLKSZ * 4)) "$TESTDIR/file2" \
+		$((BLKSZ * 4)) $((BLKSZ * 2)) >> "$seqres.full"
+_test_remount
+free_after="$(stat -f -c '%a' "$TESTDIR")"
+echo "freesp changed by $free_before -> $free_after" >> "$seqres.full"
+
+echo "Compare sections"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 4)) \
+       || echo "Start sections do not match"
+
+_compare_range "$TESTDIR/file1" $((BLKSZ * 4)) "$TESTDIR/file2" \
+		$((BLKSZ * 4)) $((BLKSZ * 2)) \
+       || echo "Middle sections do not match"
+
+_compare_range "$TESTDIR/file1" $((BLKSZ * 6)) "$TESTDIR/file2" \
+		$((BLKSZ * 6)) $((BLKSZ * 2)) \
+       || echo "End sections do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/116.out b/tests/generic/116.out
new file mode 100644
index 0000000..5adfc62
--- /dev/null
+++ b/tests/generic/116.out
@@ -0,0 +1,8 @@
+QA output created by 116
+Create the original files
+35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-116/file1
+35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-116/file2
+Reflink the middle blocks together
+Compare sections
+35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-116/file1
+35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-116/file2
diff --git a/tests/generic/118 b/tests/generic/118
new file mode 100755
index 0000000..651b72c
--- /dev/null
+++ b/tests/generic/118
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FS QA Test No. 118
+#
+# Ensuring that we can reflink non-matching parts of files:
+#   - Reflink identical ranges of two different files
+#   - Check that the non-linked ranges still do not match
+#   - Check that we end up with identical contents in the linked ranges
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
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original files"
+BLKSZ=65536
+_pwrite_byte 0x61 $((BLKSZ * 2)) $((BLKSZ * 6)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 $((BLKSZ * 2)) $((BLKSZ * 6)) "$TESTDIR/file2" >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 8)) \
+       || echo "Files do not match (intentional)"
+
+echo "Reflink the middle blocks together"
+free_before="$(stat -f -c '%a' "$TESTDIR")"
+_reflink_range "$TESTDIR/file1" $((BLKSZ * 4)) "$TESTDIR/file2" \
+		$((BLKSZ * 4)) $((BLKSZ * 2)) >> "$seqres.full"
+_test_remount
+free_after="$(stat -f -c '%a' "$TESTDIR")"
+echo "freesp changed by $free_before -> $free_after" >> "$seqres.full"
+
+echo "Compare sections"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 4)) \
+       || echo "Start sections do not match (intentional)"
+
+_compare_range "$TESTDIR/file1" $((BLKSZ * 4)) "$TESTDIR/file2" \
+		$((BLKSZ * 4)) $((BLKSZ * 2)) \
+       || echo "Middle sections do not match"
+
+_compare_range "$TESTDIR/file1" $((BLKSZ * 6)) "$TESTDIR/file2" \
+		$((BLKSZ * 6)) $((BLKSZ * 2)) \
+       || echo "End sections do not match (intentional)"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/118.out b/tests/generic/118.out
new file mode 100644
index 0000000..8fdaf59
--- /dev/null
+++ b/tests/generic/118.out
@@ -0,0 +1,11 @@
+QA output created by 118
+Create the original files
+35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-118/file1
+5e3501f97fd2669babfcbd3e1972e833  TEST_DIR/test-118/file2
+Files do not match (intentional)
+Reflink the middle blocks together
+Compare sections
+35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-118/file1
+f7f9e44d37909868014e9151f5293ab0  TEST_DIR/test-118/file2
+Start sections do not match (intentional)
+End sections do not match (intentional)
diff --git a/tests/generic/119 b/tests/generic/119
new file mode 100755
index 0000000..9d57379
--- /dev/null
+++ b/tests/generic/119
@@ -0,0 +1,170 @@
+#! /bin/bash
+# FS QA Test No. 119
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
+
+rm -f "$seqres.full"
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ=65536
+_pwrite_byte 0x61 0 $((BLKSZ * 8)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((BLKSZ * 8)) "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x63 0 $((BLKSZ * 8)) "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x64 0 $((BLKSZ * 8)) "$TESTDIR/file4" >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$TESTDIR/file4" | _filter_test_dir
+
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 8)) \
+       || echo "Files 1-2 do not match (intentional)"
+
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file3" 0 $((BLKSZ * 8)) \
+       || echo "Files 1-3 do not match (intentional)"
+
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file4" 0 $((BLKSZ * 8)) \
+       || echo "Files 1-4 do not match (intentional)"
+
+echo "Reflink the first four blocks together, 1-2 3-4"
+free_before="$(stat -f -c '%a' "$TESTDIR")"
+_reflink_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 4)) >> "$seqres.full"
+_reflink_range "$TESTDIR/file3" 0 "$TESTDIR/file4" 0 $((BLKSZ * 4)) >> "$seqres.full"
+_test_remount
+free_after="$(stat -f -c '%a' "$TESTDIR")"
+echo "freesp changed by $free_before -> $free_after" >> "$seqres.full"
+
+echo "Compare sections"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$TESTDIR/file4" | _filter_test_dir
+
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 4)) \
+       || echo "Sections of file 1-2 do not match"
+
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file3" 0 $((BLKSZ * 4)) \
+       || echo "Sections of file 1-3 do not match (intentional)"
+
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file4" 0 $((BLKSZ * 4)) \
+       || echo "Sections of file 1-4 do not match (intentional)"
+
+_compare_range "$TESTDIR/file2" 0 "$TESTDIR/file3" 0 $((BLKSZ * 4)) \
+       || echo "Sections of file 2-3 do not match (intentional)"
+
+_compare_range "$TESTDIR/file2" 0 "$TESTDIR/file4" 0 $((BLKSZ * 4)) \
+       || echo "Sections of file 2-4 do not match (intentional)"
+
+_compare_range "$TESTDIR/file3" 0 "$TESTDIR/file4" 0 $((BLKSZ * 4)) \
+       || echo "Sections of file 3-4 do not match"
+
+echo "Reflink the first two blocks together, 1-3 1-4"
+free_before="$(stat -f -c '%a' $TESTDIR)"
+_reflink_range "$TESTDIR/file1" 0 "$TESTDIR/file3" 0 $((BLKSZ * 2)) >> "$seqres.full"
+_reflink_range "$TESTDIR/file1" 0 "$TESTDIR/file4" 0 $((BLKSZ * 2)) >> "$seqres.full"
+_test_remount
+free_after="$(stat -f -c '%a' $TESTDIR)"
+echo "freesp changed by $free_before -> $free_after" >> "$seqres.full"
+
+echo "Compare sections"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$TESTDIR/file4" | _filter_test_dir
+
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 2)) \
+       || echo "Sections of files 1-2 do not match"
+
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file3" 0 $((BLKSZ * 2)) \
+       || echo "Sections of files 1-3 do not match"
+
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file4" 0 $((BLKSZ * 2)) \
+       || echo "Sections of files 1-4 do not match"
+
+_compare_range "$TESTDIR/file2" 0 "$TESTDIR/file3" 0 $((BLKSZ * 2)) \
+       || echo "Sections of files 2-3 do not match"
+
+_compare_range "$TESTDIR/file2" 0 "$TESTDIR/file4" 0 $((BLKSZ * 2)) \
+       || echo "Sections of files 2-4 do not match"
+
+_compare_range "$TESTDIR/file3" 0 "$TESTDIR/file4" 0 $((BLKSZ * 2)) \
+       || echo "Sections of files 3-4 do not match"
+
+echo "Compare previously reflinked sections"
+_compare_range "$TESTDIR/file1" $((BLKSZ * 2)) "$TESTDIR/file2" \
+		$((BLKSZ * 2)) $((BLKSZ * 2)) \
+       || echo "Sections of file 1-2 do not match"
+
+_compare_range "$TESTDIR/file1" $((BLKSZ * 2)) "$TESTDIR/file3" \
+		$((BLKSZ * 2)) $((BLKSZ * 2)) \
+       || echo "Sections of file 1-3 do not match (intentional)"
+
+_compare_range "$TESTDIR/file1" $((BLKSZ * 2)) "$TESTDIR/file4" \
+		$((BLKSZ * 2)) $((BLKSZ * 2)) \
+       || echo "Sections of file 1-4 do not match (intentional)"
+
+_compare_range "$TESTDIR/file2" $((BLKSZ * 2)) "$TESTDIR/file3" \
+		$((BLKSZ * 2)) $((BLKSZ * 2)) \
+       || echo "Sections of file 2-3 do not match (intentional)"
+
+_compare_range "$TESTDIR/file2" $((BLKSZ * 2)) "$TESTDIR/file4" \
+		$((BLKSZ * 2)) $((BLKSZ * 2)) \
+       || echo "Sections of file 2-4 do not match (intentional)"
+
+_compare_range "$TESTDIR/file3" $((BLKSZ * 2)) "$TESTDIR/file4" \
+		$((BLKSZ * 2)) $((BLKSZ * 2)) \
+       || echo "Sections of file 3-4 do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/119.out b/tests/generic/119.out
new file mode 100644
index 0000000..85893d5
--- /dev/null
+++ b/tests/generic/119.out
@@ -0,0 +1,30 @@
+QA output created by 119
+Create the original files
+30c2557e8302a5beb290c71520d87f42  TEST_DIR/test-119/file1
+efb787f7990e43c7dc30565d8cc344d4  TEST_DIR/test-119/file2
+c83f38d4622a78b74e3480634194b08f  TEST_DIR/test-119/file3
+1c11fd3151d2229f5cf43903386aa432  TEST_DIR/test-119/file4
+Files 1-2 do not match (intentional)
+Files 1-3 do not match (intentional)
+Files 1-4 do not match (intentional)
+Reflink the first four blocks together, 1-2 3-4
+Compare sections
+30c2557e8302a5beb290c71520d87f42  TEST_DIR/test-119/file1
+63bdb182cdf03a8a19e83234d869d00a  TEST_DIR/test-119/file2
+c83f38d4622a78b74e3480634194b08f  TEST_DIR/test-119/file3
+dc2ae3db14e97fad93faf939170b085c  TEST_DIR/test-119/file4
+Sections of file 1-3 do not match (intentional)
+Sections of file 1-4 do not match (intentional)
+Sections of file 2-3 do not match (intentional)
+Sections of file 2-4 do not match (intentional)
+Reflink the first two blocks together, 1-3 1-4
+Compare sections
+30c2557e8302a5beb290c71520d87f42  TEST_DIR/test-119/file1
+63bdb182cdf03a8a19e83234d869d00a  TEST_DIR/test-119/file2
+89a444ff9d6af60ba487e9a0ca2161e2  TEST_DIR/test-119/file3
+0c263058794a54c5e197ece52386f5be  TEST_DIR/test-119/file4
+Compare previously reflinked sections
+Sections of file 1-3 do not match (intentional)
+Sections of file 1-4 do not match (intentional)
+Sections of file 2-3 do not match (intentional)
+Sections of file 2-4 do not match (intentional)
diff --git a/tests/generic/121 b/tests/generic/121
new file mode 100755
index 0000000..9a5b383
--- /dev/null
+++ b/tests/generic/121
@@ -0,0 +1,92 @@
+#! /bin/bash
+# FS QA Test No. 121
+#
+# Ensure that we can dedupe parts of two files:
+#   - Dedupe identical parts of two identical files
+#   - Check that still have identical contents
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
+_require_test_dedupe
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original files"
+BLKSZ=65536
+_pwrite_byte 0x61 $((BLKSZ * 2)) $((BLKSZ * 6)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x61 $((BLKSZ * 2)) $((BLKSZ * 6)) "$TESTDIR/file2" >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 8)) \
+       || echo "Files 1-2 do not match (intentional)"
+
+echo "Dedupe the middle blocks together"
+free_before="$(stat -f -c '%a' "$TESTDIR")"
+_dedupe_range "$TESTDIR/file1" $((BLKSZ * 4)) "$TESTDIR/file2" \
+		$((BLKSZ * 4)) $((BLKSZ * 2)) >> "$seqres.full"
+_test_remount
+free_after="$(stat -f -c '%a' "$TESTDIR")"
+echo "freesp changed by $free_before -> $free_after" >> "$seqres.full"
+
+echo "Compare sections"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 4)) \
+       || echo "Start sections do not match"
+
+_compare_range "$TESTDIR/file1" $((BLKSZ * 4)) "$TESTDIR/file2" \
+		$((BLKSZ * 4)) $((BLKSZ * 2)) \
+       || echo "Middle sections do not match"
+
+_compare_range "$TESTDIR/file1" $((BLKSZ * 6)) "$TESTDIR/file2" \
+		$((BLKSZ * 6)) $((BLKSZ * 2)) \
+       || echo "End sections do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/121.out b/tests/generic/121.out
new file mode 100644
index 0000000..d865c7e
--- /dev/null
+++ b/tests/generic/121.out
@@ -0,0 +1,8 @@
+QA output created by 121
+Create the original files
+35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-121/file1
+35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-121/file2
+Dedupe the middle blocks together
+Compare sections
+35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-121/file1
+35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-121/file2
diff --git a/tests/generic/122 b/tests/generic/122
new file mode 100755
index 0000000..0edb48d
--- /dev/null
+++ b/tests/generic/122
@@ -0,0 +1,92 @@
+#! /bin/bash
+# FS QA Test No. 122
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
+_require_test_dedupe
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original files"
+BLKSZ=65536
+_pwrite_byte 0x61 $((BLKSZ * 2)) $((BLKSZ * 6)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 $((BLKSZ * 2)) $((BLKSZ * 6)) "$TESTDIR/file2" >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 "$((BLKSZ * 8))" \
+       || echo "Files 1-2 do not match (intentional)"
+
+echo "(Fail to) dedupe the middle blocks together"
+free_before="$(stat -f -c '%a' "$TESTDIR")"
+_dedupe_range "$TESTDIR/file1" $((BLKSZ * 4)) "$TESTDIR/file2" \
+		$((BLKSZ * 4)) $((BLKSZ * 2)) >> "$seqres.full"
+_test_remount
+free_after="$(stat -f -c '%a' "$TESTDIR")"
+echo "freesp changed by $free_before -> $free_after" >> "$seqres.full"
+
+echo "Compare sections"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 4)) \
+       || echo "Start sections do not match (intentional)"
+
+_compare_range "$TESTDIR/file1" $((BLKSZ * 4)) "$TESTDIR/file2" \
+		$((BLKSZ * 4)) $((BLKSZ * 2)) \
+       || echo "Middle sections do not match (intentional)"
+
+_compare_range "$TESTDIR/file1" $((BLKSZ * 6)) "$TESTDIR/file2" \
+		$((BLKSZ * 6)) $((BLKSZ * 2)) \
+       || echo "End sections do not match (intentional)"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/122.out b/tests/generic/122.out
new file mode 100644
index 0000000..c7cfec2
--- /dev/null
+++ b/tests/generic/122.out
@@ -0,0 +1,12 @@
+QA output created by 122
+Create the original files
+35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-122/file1
+5e3501f97fd2669babfcbd3e1972e833  TEST_DIR/test-122/file2
+Files 1-2 do not match (intentional)
+(Fail to) dedupe the middle blocks together
+Compare sections
+35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-122/file1
+5e3501f97fd2669babfcbd3e1972e833  TEST_DIR/test-122/file2
+Start sections do not match (intentional)
+Middle sections do not match (intentional)
+End sections do not match (intentional)
diff --git a/tests/generic/134 b/tests/generic/134
new file mode 100755
index 0000000..4dc710c
--- /dev/null
+++ b/tests/generic/134
@@ -0,0 +1,128 @@
+#! /bin/bash
+# FS QA Test No. 134
+#
+# Ensure that we can reflink the last block of a file whose size isn't
+# block-aligned.
+#   - Create two 'a' files file whose size isn't block-aligned.
+#   - Create two 'b' files file whose size isn't block-aligned.
+#   - Reflink the last block of file1 to the last block in file2 and file3.
+#   - Check that files 1-2 match, 3-4 don't match, and that nothing matches 3.
+#   - Check that the ends of 1-3 match, and 1-3 do not match the end of file4.
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
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original files"
+BLKSZ=65536
+_pwrite_byte 0x61 0 $((BLKSZ + 37)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((BLKSZ + 37)) "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((BLKSZ + 37)) "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((BLKSZ + 37)) "$TESTDIR/file4" >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$TESTDIR/file4" | _filter_test_dir
+
+C1="$(_md5_checksum $TESTDIR/file1)"
+C2="$(_md5_checksum $TESTDIR/file2)"
+C3="$(_md5_checksum $TESTDIR/file3)"
+C4="$(_md5_checksum $TESTDIR/file4)"
+
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
+test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
+test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
+test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
+test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+
+echo "Reflink the last blocks together, 1-2 1-3"
+_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $BLKSZ 37 >> "$seqres.full"
+_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file3" $BLKSZ 37 >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$TESTDIR/file4" | _filter_test_dir
+
+C1="$(_md5_checksum $TESTDIR/file1)"
+C2="$(_md5_checksum $TESTDIR/file2)"
+C3="$(_md5_checksum $TESTDIR/file3)"
+C4="$(_md5_checksum $TESTDIR/file4)"
+
+echo "Compare files"
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
+test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
+test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
+test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
+test "${C3}" != "${C4}" || echo "file3 and file4 should match"
+
+echo "Compare sections"
+_compare_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $BLKSZ 37 \
+       || echo "End sections of files 1-2 do not match"
+
+_compare_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file3" $BLKSZ 37 \
+       || echo "End sections of files 1-3 do not match"
+
+_compare_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file4" $BLKSZ 37 \
+       || echo "End sections of files 1-4 do not match (intentional)"
+
+_compare_range "$TESTDIR/file2" $BLKSZ "$TESTDIR/file3" $BLKSZ 37 \
+       || echo "End sections of files 2-3 do not match"
+
+_compare_range "$TESTDIR/file2" $BLKSZ "$TESTDIR/file4" $BLKSZ 37 \
+       || echo "End sections of files 2-4 do not match (intentional)"
+
+_compare_range "$TESTDIR/file3" $BLKSZ "$TESTDIR/file4" $BLKSZ 37 \
+       || echo "End sections of files 3-4 do not match (intentional)"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/134.out b/tests/generic/134.out
new file mode 100644
index 0000000..b5e0f43
--- /dev/null
+++ b/tests/generic/134.out
@@ -0,0 +1,16 @@
+QA output created by 134
+Create the original files
+c4fd505be25a0c91bcca9f502b9a8156  TEST_DIR/test-134/file1
+c4fd505be25a0c91bcca9f502b9a8156  TEST_DIR/test-134/file2
+07ac67bf7f271195442509e79cde4cee  TEST_DIR/test-134/file3
+07ac67bf7f271195442509e79cde4cee  TEST_DIR/test-134/file4
+Reflink the last blocks together, 1-2 1-3
+c4fd505be25a0c91bcca9f502b9a8156  TEST_DIR/test-134/file1
+c4fd505be25a0c91bcca9f502b9a8156  TEST_DIR/test-134/file2
+e236f2fe789f0aa34b50e981a2f0243a  TEST_DIR/test-134/file3
+07ac67bf7f271195442509e79cde4cee  TEST_DIR/test-134/file4
+Compare files
+Compare sections
+End sections of files 1-4 do not match (intentional)
+End sections of files 2-4 do not match (intentional)
+End sections of files 3-4 do not match (intentional)
diff --git a/tests/generic/136 b/tests/generic/136
new file mode 100755
index 0000000..89ee751
--- /dev/null
+++ b/tests/generic/136
@@ -0,0 +1,128 @@
+#! /bin/bash
+# FS QA Test No. 136
+#
+# Ensure that we can dedupe the last block of a file whose size isn't
+# block-aligned.
+#   - Create two 'a' files file whose size isn't block-aligned.
+#   - Create two 'b' files file whose size isn't block-aligned.
+#   - Dedupe the last block of file1 to the last block in file2 and file3.
+#   - Check that files 1-2 match, and that 3-4 match.
+#   - Check that the ends of 1-2 and 3-4 match, and that 1-3 don't match.
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
+_require_test_dedupe
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original files"
+BLKSZ=65536
+_pwrite_byte 0x61 0 $((BLKSZ + 37)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((BLKSZ + 37)) "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((BLKSZ + 37)) "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((BLKSZ + 37)) "$TESTDIR/file4" >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$TESTDIR/file4" | _filter_test_dir
+
+C1="$(_md5_checksum $TESTDIR/file1)"
+C2="$(_md5_checksum $TESTDIR/file2)"
+C3="$(_md5_checksum $TESTDIR/file3)"
+C4="$(_md5_checksum $TESTDIR/file4)"
+
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
+test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
+test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
+test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
+test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+
+echo "Dedupe the last blocks together"
+_dedupe_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $BLKSZ 37 >> "$seqres.full"
+_dedupe_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file3" $BLKSZ 37 >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$TESTDIR/file4" | _filter_test_dir
+
+C1="$(_md5_checksum $TESTDIR/file1)"
+C2="$(_md5_checksum $TESTDIR/file2)"
+C3="$(_md5_checksum $TESTDIR/file3)"
+C4="$(_md5_checksum $TESTDIR/file4)"
+
+echo "Compare files"
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
+test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
+test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
+test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
+test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+
+echo "Compare sections"
+_compare_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $BLKSZ 37 \
+       || echo "End sections of files 1-2 do not match"
+
+_compare_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file3" $BLKSZ 37 \
+       || echo "End sections of files 1-3 do not match (intentional)"
+
+_compare_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file4" $BLKSZ 37 \
+       || echo "End sections of files 1-4 do not match (intentional)"
+
+_compare_range "$TESTDIR/file2" $BLKSZ "$TESTDIR/file3" $BLKSZ 37 \
+       || echo "End sections of files 2-3 do not match (intentional)"
+
+_compare_range "$TESTDIR/file2" $BLKSZ "$TESTDIR/file4" $BLKSZ 37 \
+       || echo "End sections of files 2-4 do not match (intentional)"
+
+_compare_range "$TESTDIR/file3" $BLKSZ "$TESTDIR/file4" $BLKSZ 37 \
+       || echo "End sections of files 3-4 do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/136.out b/tests/generic/136.out
new file mode 100644
index 0000000..99a5465
--- /dev/null
+++ b/tests/generic/136.out
@@ -0,0 +1,17 @@
+QA output created by 136
+Create the original files
+c4fd505be25a0c91bcca9f502b9a8156  TEST_DIR/test-136/file1
+c4fd505be25a0c91bcca9f502b9a8156  TEST_DIR/test-136/file2
+07ac67bf7f271195442509e79cde4cee  TEST_DIR/test-136/file3
+07ac67bf7f271195442509e79cde4cee  TEST_DIR/test-136/file4
+Dedupe the last blocks together
+c4fd505be25a0c91bcca9f502b9a8156  TEST_DIR/test-136/file1
+c4fd505be25a0c91bcca9f502b9a8156  TEST_DIR/test-136/file2
+07ac67bf7f271195442509e79cde4cee  TEST_DIR/test-136/file3
+07ac67bf7f271195442509e79cde4cee  TEST_DIR/test-136/file4
+Compare files
+Compare sections
+End sections of files 1-3 do not match (intentional)
+End sections of files 1-4 do not match (intentional)
+End sections of files 2-3 do not match (intentional)
+End sections of files 2-4 do not match (intentional)
diff --git a/tests/generic/137 b/tests/generic/137
new file mode 100755
index 0000000..a640f4f
--- /dev/null
+++ b/tests/generic/137
@@ -0,0 +1,131 @@
+#! /bin/bash
+# FS QA Test No. 137
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
+_require_test_dedupe
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original file blocks"
+BLKSZ=65536
+_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 $BLKSZ $((BLKSZ * 2)) "$TESTDIR/file1" >> "$seqres.full"
+
+NR_BLKS=1024
+
+echo "fallocate half the file"
+"$XFS_IO_PROG" -f -c "falloc $((NR_BLKS * BLKSZ / 2)) $((NR_BLKS * BLKSZ / 2))" "$TESTDIR/file1" >> "$seqres.full"
+
+echo "Reflink block zero to the threes"
+seq 1 $((NR_BLKS / 3)) | while read nr; do
+	_reflink_range "$TESTDIR/file1" 0 "$TESTDIR/file1" $((nr * 3 * BLKSZ)) \
+			$BLKSZ >> "$seqres.full"
+done
+
+echo "Reflink block one to the fives"
+seq 1 $((NR_BLKS / 5)) | while read nr; do
+	_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file1" \
+			$((nr * 5 * BLKSZ)) $BLKSZ >> "$seqres.full"
+done
+
+echo "Dedupe block two to the sevens"
+seq 1 $((NR_BLKS / 7)) | while read nr; do
+	_dedupe_range "$TESTDIR/file1" $((BLKSZ * 2)) "$TESTDIR/file1" \
+			$((nr * 7 * BLKSZ)) $BLKSZ >> "$seqres.full"
+done
+
+_test_remount
+
+echo "Check block mappings"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+
+crcZ=$(_md5_range_checksum /dev/zero 0 $BLKSZ)
+crc0=$(_md5_range_checksum "$TESTDIR/file1" 0 $BLKSZ)
+crc1=$(_md5_range_checksum "$TESTDIR/file1" $BLKSZ $BLKSZ)
+crc2=$(_md5_range_checksum "$TESTDIR/file1" $((BLKSZ * 2)) $BLKSZ)
+
+check_block() {
+	lblk="$1"
+	rem7=$((lblk % 7))
+	rem5=$((lblk % 5))
+	rem3=$((lblk % 3))
+
+	crc=$(_md5_range_checksum "$TESTDIR/file1" $((lblk * BLKSZ)) $BLKSZ)
+
+	if [ $rem7 -eq 0 ]; then
+		if [ $rem5 -eq 0 ]; then
+			test $crc2 = $crc || echo "lblk $lblk doesn't match block 2"
+		elif [ $rem3 -eq 0 ]; then
+			test $crc0 = $crc || echo "lblk $lblk doesn't match block 0"
+		elif [ $lblk -lt $((NR_BLKS / 2)) ]; then
+			test $crcZ = $crc || echo "lblk $lblk isn't zeroed"
+		fi
+	elif [ $rem5 -eq 0 ]; then
+		test $crc1 = $crc || echo "lblk $lblk doesn't match block 1"
+	elif [ $rem3 -eq 0 ]; then
+		test $crc0 = $crc || echo "lblk $lblk doesn't match block 0"
+	elif [ $lblk -lt $((NR_BLKS / 2)) ]; then
+		test $crcZ = $crc || echo "lblk $lblk isn't zeroed"
+	fi
+}
+
+seq 3 $((NR_BLKS - 1)) | while read lblk; do
+	err="$(check_block $lblk)"
+	test -n "$err" && echo "$lblk: $err"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/137.out b/tests/generic/137.out
new file mode 100644
index 0000000..7808988
--- /dev/null
+++ b/tests/generic/137.out
@@ -0,0 +1,8 @@
+QA output created by 137
+Create the original file blocks
+fallocate half the file
+Reflink block zero to the threes
+Reflink block one to the fives
+Dedupe block two to the sevens
+Check block mappings
+2ea37912bdbd71b9ed4734d3141cbe9c  TEST_DIR/test-137/file1
diff --git a/tests/generic/group b/tests/generic/group
index aa31c8b..50cc132 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -118,8 +118,13 @@
 113 rw aio auto quick
 114 rw aio auto quick
 115 auto quick clone
+116 auto quick clone
 117 attr auto quick
+118 auto quick clone
+119 auto quick clone
 120 other auto quick
+121 auto quick clone
+122 auto quick clone
 123 perms auto quick
 124 pattern auto quick
 125 other auto
@@ -131,7 +136,10 @@
 131 perms auto quick
 132 pattern auto
 133 rw auto
+134 auto quick clone
 135 metadata auto quick
+136 auto quick clone
+137 auto quick clone
 141 rw auto quick
 169 rw metadata auto quick
 184 metadata auto quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
