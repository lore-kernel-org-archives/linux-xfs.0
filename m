Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 428AE29F05
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:13:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2AAB7304039
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:13:46 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Hr9Ky9Cro7ErOlBb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:13:42 -0700 (PDT)
Subject: [PATCH 05/12] reflink: test CoW behaviors of reflinked files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:13:37 -0700
Message-ID: <20151007051337.3260.59500.stgit@birch.djwong.org>
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

Ensure that CoW happens correctly with buffered, directio, and mmap writes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/808     |  139 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/808.out |   13 +++++
 tests/generic/809     |  139 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/809.out |   13 +++++
 tests/generic/810     |  139 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/810.out |   13 +++++
 tests/generic/837     |   87 +++++++++++++++++++++++++++++++
 tests/generic/837.out |    5 ++
 tests/generic/838     |   87 +++++++++++++++++++++++++++++++
 tests/generic/838.out |    5 ++
 tests/generic/group   |    5 ++
 11 files changed, 645 insertions(+)
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
index 0000000..8275bd9
--- /dev/null
+++ b/tests/generic/808
@@ -0,0 +1,139 @@
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
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ * 48 - 3))" $TESTDIR/file1 >> $seqres.full
+cp --reflink $TESTDIR/file1 $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ * 48 - 3))" $TESTDIR/file3 >> $seqres.full
+_test_remount
+
+echo "Compare files"
+cmp -s $TESTDIR/file1 $TESTDIR/file2 || echo "Files 1-2 do not match"
+cmp -s $TESTDIR/file1 $TESTDIR/file3 || echo "Files 1-3 do not match"
+cmp -s $TESTDIR/file2 $TESTDIR/file3 || echo "Files 2-3 do not match"
+
+echo "pagecache CoW the second file"
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 17" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 17" $TESTDIR/file3 >> $seqres.full
+
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $((BLKSZ * 16 - 34)) 17" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $((BLKSZ * 16 - 34)) 17" $TESTDIR/file3 >> $seqres.full
+
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $((BLKSZ * 48 - 8)) 17" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $((BLKSZ * 48 - 8)) 17" $TESTDIR/file3 >> $seqres.full
+_test_remount
+
+echo "Compare files"
+cmp -s $TESTDIR/file1 $TESTDIR/file2 || echo "Files 1-2 do not match (intentional)"
+cmp -s $TESTDIR/file1 $TESTDIR/file3 || echo "Files 1-3 do not match (intentional)"
+cmp -s $TESTDIR/file2 $TESTDIR/file3 || echo "Files 2-3 do not match"
+
+echo "Compare the CoW'd section to the before file"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 17" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 17" $TESTDIR/file2) \
+       || echo "Start sections do not match (intentional)"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 34)) 17" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 34)) 17" $TESTDIR/file2) \
+       || echo "Middle sections do not match (intentional)"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 8)) 17" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 8)) 17" $TESTDIR/file2) \
+       || echo "End sections do not match (intentional)"
+
+echo "Compare the CoW'd section to the after file"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 17" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 17" $TESTDIR/file3) \
+       || echo "Start sections do not match"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 34)) 17" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 34)) 17" $TESTDIR/file3) \
+       || echo "Middle sections do not match"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 8)) 17" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 8)) 17" $TESTDIR/file3) \
+       || echo "End sections do not match"
+
+echo "Compare the not CoW'd sections"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 18 17" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 18 17" $TESTDIR/file2) \
+       || echo "Start sections of 1-2 do not match"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 18 17" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v 18 17" $TESTDIR/file3) \
+       || echo "Start sections of 2-3 do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 17)) 82" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 17)) 82" $TESTDIR/file2) \
+       || echo "Middle sections of 1-2 do not match"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 17)) 82" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 17)) 82" $TESTDIR/file3) \
+       || echo "Middle sections of 2-3 do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 108)) 100" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 108)) 100" $TESTDIR/file2) \
+       || echo "End sections of 1-2 do not match"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 108)) 100" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 108)) 100" $TESTDIR/file3) \
+       || echo "End sections of 2-3 do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 14)) $BLKSZ" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 14)) $BLKSZ" $TESTDIR/file2) \
+       || echo "Untouched sections of 1-2 do not match"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 14)) $BLKSZ" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 14)) $BLKSZ" $TESTDIR/file3) \
+       || echo "Untouched sections of 2-3 do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/808.out b/tests/generic/808.out
new file mode 100644
index 0000000..ef13e62
--- /dev/null
+++ b/tests/generic/808.out
@@ -0,0 +1,13 @@
+QA output created by 808
+Create the original files
+Compare files
+pagecache CoW the second file
+Compare files
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
index 0000000..09aac9b
--- /dev/null
+++ b/tests/generic/809
@@ -0,0 +1,139 @@
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
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ * 48 - 3))" $TESTDIR/file1 >> $seqres.full
+cp --reflink $TESTDIR/file1 $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ * 48 - 3))" $TESTDIR/file3 >> $seqres.full
+_test_remount
+
+echo "Compare files"
+cmp -s $TESTDIR/file1 $TESTDIR/file2 || echo "Files 1-2 should match"
+cmp -s $TESTDIR/file1 $TESTDIR/file3 || echo "Files 1-3 should match"
+cmp -s $TESTDIR/file2 $TESTDIR/file3 || echo "Files 2-3 should match"
+
+echo "directio CoW the second file"
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $BLKSZ" -d $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $BLKSZ" -d $TESTDIR/file3 >> $seqres.full
+
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $((BLKSZ * 16 - 512)) 512" -d $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $((BLKSZ * 16 - 512)) 512" -d $TESTDIR/file3 >> $seqres.full
+
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $((BLKSZ * 48)) $BLKSZ" -d $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $((BLKSZ * 48)) $BLKSZ" -d $TESTDIR/file3 >> $seqres.full
+_test_remount
+
+echo "Compare files"
+cmp -s $TESTDIR/file1 $TESTDIR/file2 || echo "Files 1-2 should not match (intentional)"
+cmp -s $TESTDIR/file1 $TESTDIR/file3 || echo "Files 1-3 should not match (intentional)"
+cmp -s $TESTDIR/file2 $TESTDIR/file3 || echo "Files 2-3 should match"
+
+echo "Compare the CoW'd section to the before file"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $BLKSZ" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $BLKSZ" $TESTDIR/file2) \
+       || echo "Start sections do not match (intentional)"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 512)) 512" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 512)) 512" $TESTDIR/file2) \
+       || echo "Middle sections do not match (intentional)"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 512)) $BLKSZ" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 512)) $BLKSZ" $TESTDIR/file2) \
+       || echo "End sections do not match (intentional)"
+
+echo "Compare the CoW'd section to the after file"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $BLKSZ" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $BLKSZ" $TESTDIR/file3) \
+       || echo "Start sections do not match"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 512)) 512" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 512)) 512" $TESTDIR/file3) \
+       || echo "Middle sections do not match"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 512)) $BLKSZ" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 512)) $BLKSZ" $TESTDIR/file3) \
+       || echo "End sections do not match"
+
+echo "Compare the not CoW'd sections"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 512" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 512" $TESTDIR/file2) \
+       || echo "Start sections of 1-2 do not match"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 512" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 512" $TESTDIR/file3) \
+       || echo "Start sections of 2-3 do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 1024)) 512" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 1024)) 512" $TESTDIR/file2) \
+       || echo "Middle sections of 1-2 do not match"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 1024)) 512" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 1024)) 512" $TESTDIR/file3) \
+       || echo "Middle sections of 2-3 do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 1024)) 512" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 1024)) 512" $TESTDIR/file2) \
+       || echo "End sections of 1-2 do not match"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 1024)) 512" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 1024)) 512" $TESTDIR/file3) \
+       || echo "End sections of 2-3 do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16)) 512" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16)) 512" $TESTDIR/file2) \
+       || echo "Untouched sections of 1-2 do not match"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16)) 512" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16)) 512" $TESTDIR/file3) \
+       || echo "Untouched sections of 2-3 do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/809.out b/tests/generic/809.out
new file mode 100644
index 0000000..ce91ee2
--- /dev/null
+++ b/tests/generic/809.out
@@ -0,0 +1,13 @@
+QA output created by 809
+Create the original files
+Compare files
+directio CoW the second file
+Compare files
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
index 0000000..3de0b69
--- /dev/null
+++ b/tests/generic/810
@@ -0,0 +1,139 @@
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
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ * 48 - 3))" $TESTDIR/file1 >> $seqres.full
+cp --reflink $TESTDIR/file1 $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ * 48 - 3))" $TESTDIR/file3 >> $seqres.full
+_test_remount
+
+echo "Compare files"
+cmp -s $TESTDIR/file1 $TESTDIR/file2 || echo "Files 1-2 do not match"
+cmp -s $TESTDIR/file1 $TESTDIR/file3 || echo "Files 1-3 do not match"
+cmp -s $TESTDIR/file2 $TESTDIR/file3 || echo "Files 2-3 do not match"
+
+echo "mmap CoW the second file"
+$XFS_IO_PROG -f -c "mmap -rw 0 $((BLKSZ * 48 - 3))" -c "mwrite -S 0x62 0 17" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "mmap -rw 0 $((BLKSZ * 48 - 3))" -c "mwrite -S 0x62 0 17" $TESTDIR/file3 >> $seqres.full
+
+$XFS_IO_PROG -f -c "mmap -rw 0 $((BLKSZ * 48 - 3))" -c "mwrite -S 0x62 $((BLKSZ * 16 - 34)) 17" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "mmap -rw 0 $((BLKSZ * 48 - 3))" -c "mwrite -S 0x62 $((BLKSZ * 16 - 34)) 17" $TESTDIR/file3 >> $seqres.full
+
+$XFS_IO_PROG -f -c "mmap -rw 0 $((BLKSZ * 48 - 3))" -c "mwrite -S 0x62 $((BLKSZ * 48 - 20)) 17" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "mmap -rw 0 $((BLKSZ * 48 - 3))" -c "mwrite -S 0x62 $((BLKSZ * 48 - 20)) 17" $TESTDIR/file3 >> $seqres.full
+_test_remount
+
+echo "Compare files"
+cmp -s $TESTDIR/file1 $TESTDIR/file2 || echo "Files 1-2 do not match (intentional)"
+cmp -s $TESTDIR/file1 $TESTDIR/file3 || echo "Files 1-3 do not match (intentional)"
+cmp -s $TESTDIR/file2 $TESTDIR/file3 || echo "Files 2-3 do not match"
+
+echo "Compare the CoW'd section to the before file"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 17" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 17" $TESTDIR/file2) \
+       || echo "Start sections do not match (intentional)"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 34)) 17" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 34)) 17" $TESTDIR/file2) \
+       || echo "Middle sections do not match (intentional)"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 20)) 17" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 20)) 17" $TESTDIR/file2) \
+       || echo "End sections do not match (intentional)"
+
+echo "Compare the CoW'd section to the after file"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 17" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 17" $TESTDIR/file3) \
+       || echo "Start sections do not match"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 34)) 17" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 34)) 17" $TESTDIR/file3) \
+       || echo "Middle sections do not match"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 20)) 17" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 20)) 17" $TESTDIR/file3) \
+       || echo "End sections do not match"
+
+echo "Compare the not CoW'd sections"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 18 17" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 18 17" $TESTDIR/file2) \
+       || echo "Start sections of 1-2 do not match"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 18 17" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v 18 17" $TESTDIR/file3) \
+       || echo "Start sections of 2-3 do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 17)) 82" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 17)) 82" $TESTDIR/file2) \
+       || echo "Middle sections of 1-2 do not match"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 17)) 82" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 16 - 17)) 82" $TESTDIR/file3) \
+       || echo "Middle sections of 2-3 do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 120)) 100" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 120)) 100" $TESTDIR/file2) \
+       || echo "End sections of 1-2 do not match"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 120)) 100" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 48 - 120)) 100" $TESTDIR/file3) \
+       || echo "End sections of 2-3 do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 14)) $BLKSZ" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 14)) $BLKSZ" $TESTDIR/file2) \
+       || echo "Untouched sections of 1-2 do not match"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 14)) $BLKSZ" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 14)) $BLKSZ" $TESTDIR/file3) \
+       || echo "Untouched sections of 2-3 do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/810.out b/tests/generic/810.out
new file mode 100644
index 0000000..6434e03
--- /dev/null
+++ b/tests/generic/810.out
@@ -0,0 +1,13 @@
+QA output created by 810
+Create the original files
+Compare files
+mmap CoW the second file
+Compare files
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
index 0000000..1824ee0
--- /dev/null
+++ b/tests/generic/837
@@ -0,0 +1,87 @@
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
+_require_cp_reflink
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
+NR=9
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ * 256))" $TESTDIR/file1 >> $seqres.full
+csum="$(_md5_checksum $TESTDIR/file1)"
+
+echo "Create the reflink copies"
+for i in `seq 2 $NR`; do
+	cp --reflink=always $TESTDIR/file1 $TESTDIR/file$i
+done
+_test_remount
+
+echo "Rewrite the copies"
+for i in `seq 2 $NR`; do
+	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((BLKSZ * 256))" $TESTDIR/file$i >> $seqres.full
+	sync
+done
+_test_remount
+
+echo "Examine original file"
+mod_csum="$(_md5_checksum $TESTDIR/file2)"
+new_csum="$(_md5_checksum $TESTDIR/file1)"
+test "${csum}" != "${mod_csum}" || echo "checksums do not match"
+test "${csum}" = "${new_csum}" || echo "checksums do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/837.out b/tests/generic/837.out
new file mode 100644
index 0000000..dd45df8
--- /dev/null
+++ b/tests/generic/837.out
@@ -0,0 +1,5 @@
+QA output created by 837
+Create the original file blocks
+Create the reflink copies
+Rewrite the copies
+Examine original file
diff --git a/tests/generic/838 b/tests/generic/838
new file mode 100755
index 0000000..00977e5
--- /dev/null
+++ b/tests/generic/838
@@ -0,0 +1,87 @@
+#! /bin/bash
+# FS QA Test No. 837
+#
+# Ensure that reflinking a file N times and DIO CoWing the copies leaves the
+# original intact.
+#   - Create a file and record its hash
+#   - Create some reflink copies
+#   - Rewrite all the reflink copies with directio
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
+_require_cp_reflink
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
+NR=9
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ * 256))" $TESTDIR/file1 >> $seqres.full
+csum="$(_md5_checksum $TESTDIR/file1)"
+
+echo "Create the reflink copies"
+for i in `seq 2 $NR`; do
+	cp --reflink=always $TESTDIR/file1 $TESTDIR/file$i
+done
+_test_remount
+
+echo "Rewrite the copies"
+for i in `seq 2 $NR`; do
+	$XFS_IO_PROG -d -f -c "pwrite -S 0x62 0 $((BLKSZ * 256))" $TESTDIR/file$i >> $seqres.full
+	sync
+done
+_test_remount
+
+echo "Examine original file"
+mod_csum="$(_md5_checksum $TESTDIR/file2)"
+new_csum="$(_md5_checksum $TESTDIR/file1)"
+test "${csum}" != "${mod_csum}" || echo "checksums do not match"
+test "${csum}" = "${new_csum}" || echo "checksums do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/838.out b/tests/generic/838.out
new file mode 100644
index 0000000..d1a862e
--- /dev/null
+++ b/tests/generic/838.out
@@ -0,0 +1,5 @@
+QA output created by 838
+Create the original file blocks
+Create the reflink copies
+Rewrite the copies
+Examine original file
diff --git a/tests/generic/group b/tests/generic/group
index 25cffa7..6734822 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -215,6 +215,11 @@
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
