Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BABDC29E2A
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 13:27:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AC8B28F8035
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:27:31 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id gKbeAkjaQ6E9jwMs (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:27:27 -0800 (PST)
Subject: [PATCH 04/11] reflink: test CoW behaviors of reflinked files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Nov 2015 11:26:56 -0800
Message-ID: <20151111192656.15056.46709.stgit@birch.djwong.org>
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

Ensure that CoW happens correctly with buffered, directio, and mmap writes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/808     |  152 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/808.out |   19 ++++++
 tests/generic/809     |  151 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/809.out |   19 ++++++
 tests/generic/810     |  152 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/810.out |   19 ++++++
 tests/generic/837     |   91 +++++++++++++++++++++++++++++
 tests/generic/837.out |    8 +++
 tests/generic/838     |   91 +++++++++++++++++++++++++++++
 tests/generic/838.out |    8 +++
 tests/generic/group   |    5 ++
 11 files changed, 715 insertions(+)
 create mode 100755 tests/generic/808
 create mode 100644 tests/generic/808.out
 create mode 100755 tests/generic/809
 create mode 100644 tests/generic/809.out
 create mode 100755 tests/generic/810
 create mode 100644 tests/generic/810.out
 create mode 100755 tests/generic/837
 create mode 100644 tests/generic/837.out
 create mode 100755 tests/generic/838
 create mode 100644 tests/generic/838.out


diff --git a/tests/generic/808 b/tests/generic/808
new file mode 100755
index 0000000..3a3ec58
--- /dev/null
+++ b/tests/generic/808
@@ -0,0 +1,152 @@
+#! /bin/bash
+# FS QA Test No. 808
+#
+# Ensuring that copy on write through the page cache works:
+#   - Reflink two files together
+#   - Write to the beginning, middle, and end
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
+_pwrite_byte 0x61 0 $((BLKSZ * 48 - 3)) "$TESTDIR/file1" >> "$seqres.full"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((BLKSZ * 48 - 3)) "$TESTDIR/file3" >> "$seqres.full"
+_test_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+
+cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || echo "Files 1-2 do not match"
+cmp -s "$TESTDIR/file1" "$TESTDIR/file3" || echo "Files 1-3 do not match"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file3" || echo "Files 2-3 do not match"
+
+echo "pagecache CoW the second file"
+_pwrite_byte 0x62 0 17 "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x62 0 17 "$TESTDIR/file3" >> "$seqres.full"
+
+_pwrite_byte 0x62 $((BLKSZ * 16 - 34)) 17 "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x62 $((BLKSZ * 16 - 34)) 17 "$TESTDIR/file3" >> "$seqres.full"
+
+_pwrite_byte 0x62 $((BLKSZ * 48 - 8)) 17 "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x62 $((BLKSZ * 48 - 8)) 17 "$TESTDIR/file3" >> "$seqres.full"
+_test_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+
+cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || echo "Files 1-2 do not match (intentional)"
+cmp -s "$TESTDIR/file1" "$TESTDIR/file3" || echo "Files 1-3 do not match (intentional)"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file3" || echo "Files 2-3 do not match"
+
+echo "Compare the CoW'd section to the before file"
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 17 \
+       || echo "Start sections do not match (intentional)"
+
+_compare_range  "$TESTDIR/file1" $((BLKSZ * 16 - 34)) \
+		"$TESTDIR/file2" $((BLKSZ * 16 - 34)) 17 \
+       || echo "Middle sections do not match (intentional)"
+
+_compare_range  "$TESTDIR/file1" $((BLKSZ * 48 - 8)) \
+		"$TESTDIR/file2" $((BLKSZ * 48 - 8)) 17 \
+       || echo "End sections do not match (intentional)"
+
+echo "Compare the CoW'd section to the after file"
+_compare_range "$TESTDIR/file2" 0 "$TESTDIR/file3" 0 17 \
+       || echo "Start sections do not match"
+
+_compare_range  "$TESTDIR/file2" $((BLKSZ * 16 - 34)) \
+		"$TESTDIR/file3" $((BLKSZ * 16 - 34)) 17 \
+       || echo "Middle sections do not match"
+
+_compare_range  "$TESTDIR/file2" $((BLKSZ * 48 - 8)) \
+		"$TESTDIR/file3" $((BLKSZ * 48 - 8)) 17 \
+       || echo "End sections do not match"
+
+echo "Compare the not CoW'd sections"
+_compare_range "$TESTDIR/file1" 18 "$TESTDIR/file2" 18 17 \
+       || echo "Start sections of 1-2 do not match"
+
+_compare_range "$TESTDIR/file2" 18 "$TESTDIR/file3" 18 17 \
+       || echo "Start sections of 2-3 do not match"
+
+
+_compare_range  "$TESTDIR/file1" $((BLKSZ * 16 - 17)) \
+		"$TESTDIR/file2" $((BLKSZ * 16 - 17)) 82 \
+       || echo "Middle sections of 1-2 do not match"
+
+_compare_range  "$TESTDIR/file2" $((BLKSZ * 16 - 17)) \
+		"$TESTDIR/file3" $((BLKSZ * 16 - 17)) 82 \
+       || echo "Middle sections of 2-3 do not match"
+
+_compare_range  "$TESTDIR/file1" $((BLKSZ * 48 - 108)) \
+		"$TESTDIR/file2" $((BLKSZ * 48 - 108)) 100 \
+       || echo "End sections of 1-2 do not match"
+
+_compare_range  "$TESTDIR/file2" $((BLKSZ * 48 - 108)) \
+		"$TESTDIR/file3" $((BLKSZ * 48 - 108)) 100 \
+       || echo "End sections of 2-3 do not match"
+
+
+_compare_range  "$TESTDIR/file1" $((BLKSZ * 14)) \
+		"$TESTDIR/file2" $((BLKSZ * 14)) $BLKSZ \
+       || echo "Untouched sections of 1-2 do not match"
+
+_compare_range  "$TESTDIR/file2" $((BLKSZ * 14)) \
+		"$TESTDIR/file3" $((BLKSZ * 14)) $BLKSZ \
+       || echo "Untouched sections of 2-3 do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/808.out b/tests/generic/808.out
new file mode 100644
index 0000000..1e82e2d
--- /dev/null
+++ b/tests/generic/808.out
@@ -0,0 +1,19 @@
+QA output created by 808
+Create the original files
+Compare files
+60ebe700450b6015c17fa15cacb9493b  TEST_DIR/test-808/file1
+60ebe700450b6015c17fa15cacb9493b  TEST_DIR/test-808/file2
+60ebe700450b6015c17fa15cacb9493b  TEST_DIR/test-808/file3
+pagecache CoW the second file
+Compare files
+60ebe700450b6015c17fa15cacb9493b  TEST_DIR/test-808/file1
+4a879c2f322121f6f4b8ebede1909a7c  TEST_DIR/test-808/file2
+4a879c2f322121f6f4b8ebede1909a7c  TEST_DIR/test-808/file3
+Files 1-2 do not match (intentional)
+Files 1-3 do not match (intentional)
+Compare the CoW'd section to the before file
+Start sections do not match (intentional)
+Middle sections do not match (intentional)
+End sections do not match (intentional)
+Compare the CoW'd section to the after file
+Compare the not CoW'd sections
diff --git a/tests/generic/809 b/tests/generic/809
new file mode 100755
index 0000000..99e88f6
--- /dev/null
+++ b/tests/generic/809
@@ -0,0 +1,151 @@
+#! /bin/bash
+# FS QA Test No. 809
+#
+# Ensuring that copy on write in direct-io mode works:
+#   - Reflink two files together
+#   - Write to the beginning, middle, and end in direct-io mode
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
+_require_test_reflink
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ=65536
+_pwrite_byte 0x61 0 $((BLKSZ * 48 - 3)) "$TESTDIR/file1" >> "$seqres.full"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((BLKSZ * 48 - 3)) "$TESTDIR/file3" >> "$seqres.full"
+_test_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+
+cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || echo "Files 1-2 should match"
+cmp -s "$TESTDIR/file1" "$TESTDIR/file3" || echo "Files 1-3 should match"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file3" || echo "Files 2-3 should match"
+
+echo "directio CoW the second file"
+_pwrite_byte 0x62 0 $BLKSZ "$TESTDIR/file2" -d >> "$seqres.full"
+_pwrite_byte 0x62 0 $BLKSZ "$TESTDIR/file3" -d >> "$seqres.full"
+
+_pwrite_byte 0x62 $((BLKSZ * 16 - 512)) 512 "$TESTDIR/file2" -d >> "$seqres.full"
+_pwrite_byte 0x62 $((BLKSZ * 16 - 512)) 512 "$TESTDIR/file3" -d >> "$seqres.full"
+
+_pwrite_byte 0x62 $((BLKSZ * 48)) $BLKSZ "$TESTDIR/file2" -d >> "$seqres.full"
+_pwrite_byte 0x62 $((BLKSZ * 48)) $BLKSZ "$TESTDIR/file3" -d >> "$seqres.full"
+_test_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+
+cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || echo "Files 1-2 should not match (intentional)"
+cmp -s "$TESTDIR/file1" "$TESTDIR/file3" || echo "Files 1-3 should not match (intentional)"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file3" || echo "Files 2-3 should match"
+
+echo "Compare the CoW'd section to the before file"
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $BLKSZ \
+       || echo "Start sections do not match (intentional)"
+
+_compare_range  "$TESTDIR/file1" $((BLKSZ * 16 - 512)) \
+		"$TESTDIR/file2" $((BLKSZ * 16 - 512)) 512 \
+       || echo "Middle sections do not match (intentional)"
+
+_compare_range  "$TESTDIR/file1" $((BLKSZ * 48 - 512)) \
+		"$TESTDIR/file2" $((BLKSZ * 48 - 512)) $BLKSZ \
+       || echo "End sections do not match (intentional)"
+
+echo "Compare the CoW'd section to the after file"
+_compare_range "$TESTDIR/file2" 0 "$TESTDIR/file3" 0 $BLKSZ \
+       || echo "Start sections do not match"
+
+_compare_range  "$TESTDIR/file2" $((BLKSZ * 16 - 512)) \
+		"$TESTDIR/file3" $((BLKSZ * 16 - 512)) 512 \
+       || echo "Middle sections do not match"
+
+_compare_range  "$TESTDIR/file2" $((BLKSZ * 48 - 512)) \
+		"$TESTDIR/file3" $((BLKSZ * 48 - 512)) $BLKSZ \
+       || echo "End sections do not match"
+
+echo "Compare the not CoW'd sections"
+_compare_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $BLKSZ 512 \
+       || echo "Start sections of 1-2 do not match"
+_compare_range "$TESTDIR/file2" $BLKSZ "$TESTDIR/file3" $BLKSZ 512 \
+       || echo "Start sections of 2-3 do not match"
+
+
+_compare_range  "$TESTDIR/file1" $((BLKSZ * 16 - 1024)) \
+		"$TESTDIR/file2" $((BLKSZ * 16 - 1024)) 512 \
+       || echo "Middle sections of 1-2 do not match"
+
+_compare_range  "$TESTDIR/file2" $((BLKSZ * 16 - 1024)) \
+		"$TESTDIR/file3" $((BLKSZ * 16 - 1024)) 512 \
+       || echo "Middle sections of 2-3 do not match"
+
+_compare_range  "$TESTDIR/file1" $((BLKSZ * 48 - 1024)) \
+		"$TESTDIR/file2" $((BLKSZ * 48 - 1024)) 512 \
+       || echo "End sections of 1-2 do not match"
+
+_compare_range  "$TESTDIR/file2" $((BLKSZ * 48 - 1024)) \
+		"$TESTDIR/file3" $((BLKSZ * 48 - 1024)) 512 \
+       || echo "End sections of 2-3 do not match"
+
+
+_compare_range  "$TESTDIR/file1" $((BLKSZ * 16)) \
+		"$TESTDIR/file2" $((BLKSZ * 16)) 512 \
+       || echo "Untouched sections of 1-2 do not match"
+
+_compare_range  "$TESTDIR/file2" $((BLKSZ * 16)) \
+		"$TESTDIR/file3" $((BLKSZ * 16)) 512 \
+       || echo "Untouched sections of 2-3 do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/809.out b/tests/generic/809.out
new file mode 100644
index 0000000..ad63e4e
--- /dev/null
+++ b/tests/generic/809.out
@@ -0,0 +1,19 @@
+QA output created by 809
+Create the original files
+Compare files
+60ebe700450b6015c17fa15cacb9493b  TEST_DIR/test-809/file1
+60ebe700450b6015c17fa15cacb9493b  TEST_DIR/test-809/file2
+60ebe700450b6015c17fa15cacb9493b  TEST_DIR/test-809/file3
+directio CoW the second file
+Compare files
+60ebe700450b6015c17fa15cacb9493b  TEST_DIR/test-809/file1
+ff5626fb6c71b242d6b1a43de25c9a85  TEST_DIR/test-809/file2
+ff5626fb6c71b242d6b1a43de25c9a85  TEST_DIR/test-809/file3
+Files 1-2 should not match (intentional)
+Files 1-3 should not match (intentional)
+Compare the CoW'd section to the before file
+Start sections do not match (intentional)
+Middle sections do not match (intentional)
+End sections do not match (intentional)
+Compare the CoW'd section to the after file
+Compare the not CoW'd sections
diff --git a/tests/generic/810 b/tests/generic/810
new file mode 100755
index 0000000..3b635f8
--- /dev/null
+++ b/tests/generic/810
@@ -0,0 +1,152 @@
+#! /bin/bash
+# FS QA Test No. 810
+#
+# Ensuring that mmap copy on write through the page cache works:
+#   - Reflink two files together
+#   - Write to the beginning, middle, and end
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
+_pwrite_byte 0x61 0 $((BLKSZ * 48 - 3)) "$TESTDIR/file1" >> "$seqres.full"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((BLKSZ * 48 - 3)) "$TESTDIR/file3" >> "$seqres.full"
+_test_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+
+cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || echo "Files 1-2 do not match"
+cmp -s "$TESTDIR/file1" "$TESTDIR/file3" || echo "Files 1-3 do not match"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file3" || echo "Files 2-3 do not match"
+
+echo "mmap CoW the second file"
+_mwrite_byte 0x62 0 17 $((BLKSZ * 48 - 3)) "$TESTDIR/file2" >> "$seqres.full"
+_mwrite_byte 0x62 0 17 $((BLKSZ * 48 - 3)) "$TESTDIR/file3" >> "$seqres.full"
+
+_mwrite_byte 0x62 $((BLKSZ * 16 - 34)) 17 $((BLKSZ * 48 - 3)) "$TESTDIR/file2" >> "$seqres.full"
+_mwrite_byte 0x62 $((BLKSZ * 16 - 34)) 17 $((BLKSZ * 48 - 3)) "$TESTDIR/file3" >> "$seqres.full"
+
+_mwrite_byte 0x62 $((BLKSZ * 48 - 20)) 17 $((BLKSZ * 48 - 3)) "$TESTDIR/file2" >> "$seqres.full"
+_mwrite_byte 0x62 $((BLKSZ * 48 - 20)) 17 $((BLKSZ * 48 - 3)) "$TESTDIR/file3" >> "$seqres.full"
+_test_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$TESTDIR/file3" | _filter_test_dir
+
+cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || echo "Files 1-2 do not match (intentional)"
+cmp -s "$TESTDIR/file1" "$TESTDIR/file3" || echo "Files 1-3 do not match (intentional)"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file3" || echo "Files 2-3 do not match"
+
+echo "Compare the CoW'd section to the before file"
+_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 17 \
+       || echo "Start sections do not match (intentional)"
+
+_compare_range  "$TESTDIR/file1" $((BLKSZ * 16 - 34)) \
+		"$TESTDIR/file2" $((BLKSZ * 16 - 34)) 17 \
+       || echo "Middle sections do not match (intentional)"
+
+_compare_range  "$TESTDIR/file1" $((BLKSZ * 48 - 20)) \
+		"$TESTDIR/file2" $((BLKSZ * 48 - 20)) 17 \
+       || echo "End sections do not match (intentional)"
+
+echo "Compare the CoW'd section to the after file"
+_compare_range "$TESTDIR/file2" 0 "$TESTDIR/file3" 0 17 \
+       || echo "Start sections do not match"
+
+_compare_range  "$TESTDIR/file2" $((BLKSZ * 16 - 34)) \
+		"$TESTDIR/file3" $((BLKSZ * 16 - 34)) 17 \
+       || echo "Middle sections do not match"
+
+_compare_range  "$TESTDIR/file2" $((BLKSZ * 48 - 20)) \
+		"$TESTDIR/file3" $((BLKSZ * 48 - 20)) 17 \
+       || echo "End sections do not match"
+
+echo "Compare the not CoW'd sections"
+_compare_range "$TESTDIR/file1" 18 "$TESTDIR/file2" 18 17 \
+       || echo "Start sections of 1-2 do not match"
+
+_compare_range "$TESTDIR/file2" 18 "$TESTDIR/file3" 18 17 \
+       || echo "Start sections of 2-3 do not match"
+
+
+_compare_range  "$TESTDIR/file1" $((BLKSZ * 16 - 17)) \
+		"$TESTDIR/file2" $((BLKSZ * 16 - 17)) 82 \
+       || echo "Middle sections of 1-2 do not match"
+
+_compare_range  "$TESTDIR/file2" $((BLKSZ * 16 - 17)) \
+		"$TESTDIR/file3" $((BLKSZ * 16 - 17)) 82 \
+       || echo "Middle sections of 2-3 do not match"
+
+_compare_range  "$TESTDIR/file1" $((BLKSZ * 48 - 120)) \
+		"$TESTDIR/file2" $((BLKSZ * 48 - 120)) 100 \
+       || echo "End sections of 1-2 do not match"
+
+_compare_range  "$TESTDIR/file2" $((BLKSZ * 48 - 120)) \
+		"$TESTDIR/file3" $((BLKSZ * 48 - 120)) 100 \
+       || echo "End sections of 2-3 do not match"
+
+
+_compare_range  "$TESTDIR/file1" $((BLKSZ * 14)) \
+		"$TESTDIR/file2" $((BLKSZ * 14)) $BLKSZ \
+       || echo "Untouched sections of 1-2 do not match"
+
+_compare_range  "$TESTDIR/file2" $((BLKSZ * 14)) \
+		"$TESTDIR/file3" $((BLKSZ * 14)) $BLKSZ \
+       || echo "Untouched sections of 2-3 do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/810.out b/tests/generic/810.out
new file mode 100644
index 0000000..8cc94ab
--- /dev/null
+++ b/tests/generic/810.out
@@ -0,0 +1,19 @@
+QA output created by 810
+Create the original files
+Compare files
+60ebe700450b6015c17fa15cacb9493b  TEST_DIR/test-810/file1
+60ebe700450b6015c17fa15cacb9493b  TEST_DIR/test-810/file2
+60ebe700450b6015c17fa15cacb9493b  TEST_DIR/test-810/file3
+mmap CoW the second file
+Compare files
+60ebe700450b6015c17fa15cacb9493b  TEST_DIR/test-810/file1
+795ecfd281dbda4916431376228e4187  TEST_DIR/test-810/file2
+795ecfd281dbda4916431376228e4187  TEST_DIR/test-810/file3
+Files 1-2 do not match (intentional)
+Files 1-3 do not match (intentional)
+Compare the CoW'd section to the before file
+Start sections do not match (intentional)
+Middle sections do not match (intentional)
+End sections do not match (intentional)
+Compare the CoW'd section to the after file
+Compare the not CoW'd sections
diff --git a/tests/generic/837 b/tests/generic/837
new file mode 100755
index 0000000..de5f233
--- /dev/null
+++ b/tests/generic/837
@@ -0,0 +1,91 @@
+#! /bin/bash
+# FS QA Test No. 837
+#
+# Ensure that reflinking a file N times and CoWing the copies leaves the
+# original intact.
+#   - Create a file and record its hash
+#   - Create some reflink copies
+#   - Rewrite all the reflink copies
+#   - Compare the contents of the original file
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
+echo "Create the original file blocks"
+BLKSZ=65536
+NR=9
+_pwrite_byte 0x61 0 $((BLKSZ * 256)) "$TESTDIR/file1" >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+csum="$(_md5_checksum "$TESTDIR/file1")"
+
+echo "Create the reflink copies"
+seq 2 $NR | while read i; do
+	_cp_reflink "$TESTDIR/file1" "$TESTDIR/file$i"
+done
+_test_remount
+
+echo "Rewrite the copies"
+seq 2 $NR | while read i; do
+	_pwrite_byte 0x62 0 $((BLKSZ * 256)) "$TESTDIR/file$i" >> "$seqres.full"
+done
+_test_remount
+
+echo "Examine original file"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+
+mod_csum="$(_md5_checksum "$TESTDIR/file2")"
+new_csum="$(_md5_checksum "$TESTDIR/file1")"
+test "${csum}" != "${mod_csum}" || echo "checksums do not match"
+test "${csum}" = "${new_csum}" || echo "checksums do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/837.out b/tests/generic/837.out
new file mode 100644
index 0000000..3f9c2e5
--- /dev/null
+++ b/tests/generic/837.out
@@ -0,0 +1,8 @@
+QA output created by 837
+Create the original file blocks
+f4820540fc0ac02750739896fe028d56  TEST_DIR/test-837/file1
+Create the reflink copies
+Rewrite the copies
+Examine original file
+f4820540fc0ac02750739896fe028d56  TEST_DIR/test-837/file1
+eb34153e9ed1e774db28cbbe4090a449  TEST_DIR/test-837/file2
diff --git a/tests/generic/838 b/tests/generic/838
new file mode 100755
index 0000000..1130a2c
--- /dev/null
+++ b/tests/generic/838
@@ -0,0 +1,91 @@
+#! /bin/bash
+# FS QA Test No. 838
+#
+# Ensure that reflinking a file N times and DIO CoWing the copies leaves the
+# original intact.
+#   - Create a file and record its hash
+#   - Create some reflink copies
+#   - Rewrite all the reflink copies w/ directio
+#   - Compare the contents of the original file
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
+echo "Create the original file blocks"
+BLKSZ=65536
+NR=9
+_pwrite_byte 0x61 0 $((BLKSZ * 256)) "$TESTDIR/file1" >> "$seqres.full"
+_test_remount
+
+md5sum "$TESTDIR/file1" | _filter_test_dir
+csum="$(_md5_checksum "$TESTDIR/file1")"
+
+echo "Create the reflink copies"
+seq 2 $NR | while read i; do
+	_cp_reflink "$TESTDIR/file1" "$TESTDIR/file$i"
+done
+_test_remount
+
+echo "Rewrite the copies"
+seq 2 $NR | while read i; do
+	_pwrite_byte 0x62 0 $((BLKSZ * 256)) "$TESTDIR/file$i" -d >> "$seqres.full"
+done
+_test_remount
+
+echo "Examine original file"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+
+mod_csum="$(_md5_checksum "$TESTDIR/file2")"
+new_csum="$(_md5_checksum "$TESTDIR/file1")"
+test "${csum}" != "${mod_csum}" || echo "checksums do not match"
+test "${csum}" = "${new_csum}" || echo "checksums do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/838.out b/tests/generic/838.out
new file mode 100644
index 0000000..cc44815
--- /dev/null
+++ b/tests/generic/838.out
@@ -0,0 +1,8 @@
+QA output created by 838
+Create the original file blocks
+f4820540fc0ac02750739896fe028d56  TEST_DIR/test-838/file1
+Create the reflink copies
+Rewrite the copies
+Examine original file
+f4820540fc0ac02750739896fe028d56  TEST_DIR/test-838/file1
+eb34153e9ed1e774db28cbbe4090a449  TEST_DIR/test-838/file2
diff --git a/tests/generic/group b/tests/generic/group
index 7f25037..a72d416 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -216,6 +216,11 @@
 805 auto quick clone
 806 auto quick clone
 807 auto quick clone
+808 auto quick clone
+809 auto quick clone
+810 auto quick clone
 817 auto quick clone
 818 auto quick clone
 819 auto quick clone
+837 auto quick clone
+838 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
