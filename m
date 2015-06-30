Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E54567F8A
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 23:16:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C43DA304039
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 21:16:05 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id zCHqiPFRAzyProbH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 21:16:03 -0700 (PDT)
Subject: [PATCH 05/11] test CoW behaviors of reflinked files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Jun 2015 21:15:55 -0700
Message-ID: <20150630041555.2476.50997.stgit@birch.djwong.org>
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

Ensure that CoW happens correctly with buffered, directio, and mmap writes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/808     |  138 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/808.out |   16 ++++++
 tests/generic/809     |  138 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/809.out |   16 ++++++
 tests/generic/810     |  138 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/810.out |   16 ++++++
 tests/generic/837     |   88 +++++++++++++++++++++++++++++++
 tests/generic/837.out |    7 ++
 tests/generic/838     |   88 +++++++++++++++++++++++++++++++
 tests/generic/838.out |    7 ++
 tests/generic/group   |    5 ++
 11 files changed, 657 insertions(+)
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
index 0000000..10a79b5
--- /dev/null
+++ b/tests/generic/808
@@ -0,0 +1,138 @@
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
+_require_xfs_io_command "fiemap"
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
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 196605' $TESTDIR/file1 >> $seqres.full
+cp --reflink $TESTDIR/file1 $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 196605' $TESTDIR/file3 >> $seqres.full
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+
+echo "CoW the second file"
+$XFS_IO_PROG -f -c "pwrite 0 17" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite 0 17" $TESTDIR/file3 >> $seqres.full
+
+$XFS_IO_PROG -f -c "pwrite 60000 17" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite 60000 17" $TESTDIR/file3 >> $seqres.full
+
+$XFS_IO_PROG -f -c "pwrite 196600 17" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite 196600 17" $TESTDIR/file3 >> $seqres.full
+sync
+echo 3 > /proc/sys/vm/drop_caches
+
+echo "Checksum both files"
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+
+echo "Compare the CoW'd section to the before file"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 0 17' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 0 17' $TESTDIR/file2) \
+       || echo "Sections do not match (intentional)"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 60000 17' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 60000 17' $TESTDIR/file2) \
+       || echo "Sections do not match (intentional)"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 196600 17' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 196600 17' $TESTDIR/file2) \
+       || echo "Sections do not match (intentional)"
+
+echo "Compare the CoW'd section to the after file"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 0 17' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 0 17' $TESTDIR/file3) \
+       || echo "Sections do not match"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 60000 17' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 60000 17' $TESTDIR/file3) \
+       || echo "Sections do not match"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 196600 17' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 196600 17' $TESTDIR/file3) \
+       || echo "Sections do not match"
+
+echo "Compare the not CoW'd sections"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 18 17' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 18 17' $TESTDIR/file2) \
+       || echo "Sections do not match"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 18 17' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 18 17' $TESTDIR/file3) \
+       || echo "Sections do not match"
+
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 60018 82' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 60018 82' $TESTDIR/file2) \
+       || echo "Sections do not match"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 60018 82' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 60018 82' $TESTDIR/file3) \
+       || echo "Sections do not match"
+
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 196500 100' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 196500 100' $TESTDIR/file2) \
+       || echo "Sections do not match"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 196500 100' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 196500 100' $TESTDIR/file3) \
+       || echo "Sections do not match"
+
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 50000 10000' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 50000 10000' $TESTDIR/file2) \
+       || echo "Sections do not match"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 50000 10000' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 50000 10000' $TESTDIR/file3) \
+       || echo "Sections do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/808.out b/tests/generic/808.out
new file mode 100644
index 0000000..b2ca56c
--- /dev/null
+++ b/tests/generic/808.out
@@ -0,0 +1,16 @@
+QA output created by 808
+Create the original files
+a1e4db1af2c4414774d4096bc86e04f7  TEST_DIR/test-808/file1
+a1e4db1af2c4414774d4096bc86e04f7  TEST_DIR/test-808/file2
+a1e4db1af2c4414774d4096bc86e04f7  TEST_DIR/test-808/file3
+CoW the second file
+Checksum both files
+a1e4db1af2c4414774d4096bc86e04f7  TEST_DIR/test-808/file1
+90ca72fc3bacfe136ab1b1be1a4d2bd3  TEST_DIR/test-808/file2
+90ca72fc3bacfe136ab1b1be1a4d2bd3  TEST_DIR/test-808/file3
+Compare the CoW'd section to the before file
+Sections do not match (intentional)
+Sections do not match (intentional)
+Sections do not match (intentional)
+Compare the CoW'd section to the after file
+Compare the not CoW'd sections
diff --git a/tests/generic/809 b/tests/generic/809
new file mode 100755
index 0000000..9dce44d
--- /dev/null
+++ b/tests/generic/809
@@ -0,0 +1,138 @@
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
+_require_xfs_io_command "fiemap"
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
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 196605' $TESTDIR/file1 >> $seqres.full
+cp --reflink $TESTDIR/file1 $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 196605' $TESTDIR/file3 >> $seqres.full
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+
+echo "directio CoW the second file"
+$XFS_IO_PROG -f -c "pwrite 0 4096" -d $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite 0 4096" -d $TESTDIR/file3 >> $seqres.full
+
+$XFS_IO_PROG -f -c "pwrite 65024 512" -d $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite 65024 512" -d $TESTDIR/file3 >> $seqres.full
+
+$XFS_IO_PROG -f -c "pwrite 196096 4096" -d $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite 196096 4096" -d $TESTDIR/file3 >> $seqres.full
+sync
+echo 3 > /proc/sys/vm/drop_caches
+
+echo "Checksum both files"
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+
+echo "Compare the CoW'd section to the before file"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 0 4096' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 0 4096' $TESTDIR/file2) \
+       || echo "Sections do not match (intentional)"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 65024 512' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 65024 512' $TESTDIR/file2) \
+       || echo "Sections do not match (intentional)"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 196096 4096' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 196096 4096' $TESTDIR/file2) \
+       || echo "Sections do not match (intentional)"
+
+echo "Compare the CoW'd section to the after file"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 0 4096' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 0 4096' $TESTDIR/file3) \
+       || echo "Sections do not match"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 65024 512' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 65024 512' $TESTDIR/file3) \
+       || echo "Sections do not match"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 196096 4096' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 196096 4096' $TESTDIR/file3) \
+       || echo "Sections do not match"
+
+echo "Compare the not CoW'd sections"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 4096 512' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 4096 512' $TESTDIR/file2) \
+       || echo "Sections do not match"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 4096 512' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 4096 512' $TESTDIR/file3) \
+       || echo "Sections do not match"
+
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 64512 512' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 64512 512' $TESTDIR/file2) \
+       || echo "Sections do not match"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 64512 512' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 64512 512' $TESTDIR/file3) \
+       || echo "Sections do not match"
+
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 195584 512' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 195584 512' $TESTDIR/file2) \
+       || echo "Sections do not match"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 195584 512' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 195584 512' $TESTDIR/file3) \
+       || echo "Sections do not match"
+
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 65536 512' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 65536 512' $TESTDIR/file2) \
+       || echo "Sections do not match"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 65536 512' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 65536 512' $TESTDIR/file3) \
+       || echo "Sections do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/809.out b/tests/generic/809.out
new file mode 100644
index 0000000..d23f30c
--- /dev/null
+++ b/tests/generic/809.out
@@ -0,0 +1,16 @@
+QA output created by 809
+Create the original files
+a1e4db1af2c4414774d4096bc86e04f7  TEST_DIR/test-809/file1
+a1e4db1af2c4414774d4096bc86e04f7  TEST_DIR/test-809/file2
+a1e4db1af2c4414774d4096bc86e04f7  TEST_DIR/test-809/file3
+directio CoW the second file
+Checksum both files
+a1e4db1af2c4414774d4096bc86e04f7  TEST_DIR/test-809/file1
+5f9e2359b2e8e18eabd8f6cd46d0e823  TEST_DIR/test-809/file2
+5f9e2359b2e8e18eabd8f6cd46d0e823  TEST_DIR/test-809/file3
+Compare the CoW'd section to the before file
+Sections do not match (intentional)
+Sections do not match (intentional)
+Sections do not match (intentional)
+Compare the CoW'd section to the after file
+Compare the not CoW'd sections
diff --git a/tests/generic/810 b/tests/generic/810
new file mode 100755
index 0000000..a0090fc
--- /dev/null
+++ b/tests/generic/810
@@ -0,0 +1,138 @@
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
+_require_xfs_io_command "fiemap"
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
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 196605' $TESTDIR/file1 >> $seqres.full
+cp --reflink $TESTDIR/file1 $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 196605' $TESTDIR/file3 >> $seqres.full
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+
+echo "mmap CoW the second file"
+$XFS_IO_PROG -f -c "mmap -rw 0 196605" -c "mwrite 0 17" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "mmap -rw 0 196605" -c "mwrite 0 17" $TESTDIR/file3 >> $seqres.full
+
+$XFS_IO_PROG -f -c "mmap -rw 0 196605" -c "mwrite 60000 17" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "mmap -rw 0 196605" -c "mwrite 60000 17" $TESTDIR/file3 >> $seqres.full
+
+$XFS_IO_PROG -f -c "mmap -rw 0 196605" -c "mwrite 196588 17" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "mmap -rw 0 196605" -c "mwrite 196588 17" $TESTDIR/file3 >> $seqres.full
+sync
+echo 3 > /proc/sys/vm/drop_caches
+
+echo "Checksum both files"
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+
+echo "Compare the CoW'd section to the before file"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 0 17' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 0 17' $TESTDIR/file2) \
+       || echo "Sections do not match (intentional)"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 60000 17' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 60000 17' $TESTDIR/file2) \
+       || echo "Sections do not match (intentional)"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 196588 17' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 196588 17' $TESTDIR/file2) \
+       || echo "Sections do not match (intentional)"
+
+echo "Compare the CoW'd section to the after file"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 0 17' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 0 17' $TESTDIR/file3) \
+       || echo "Sections do not match"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 60000 17' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 60000 17' $TESTDIR/file3) \
+       || echo "Sections do not match"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 196588 17' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 196588 17' $TESTDIR/file3) \
+       || echo "Sections do not match"
+
+echo "Compare the not CoW'd sections"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 18 17' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 18 17' $TESTDIR/file2) \
+       || echo "Sections do not match"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 18 17' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 18 17' $TESTDIR/file3) \
+       || echo "Sections do not match"
+
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 60018 82' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 60018 82' $TESTDIR/file2) \
+       || echo "Sections do not match"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 60018 82' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 60018 82' $TESTDIR/file3) \
+       || echo "Sections do not match"
+
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 196500 88' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 196500 88' $TESTDIR/file2) \
+       || echo "Sections do not match"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 196500 88' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 196500 88' $TESTDIR/file3) \
+       || echo "Sections do not match"
+
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 50000 10000' $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 50000 10000' $TESTDIR/file2) \
+       || echo "Sections do not match"
+cmp -s <($XFS_IO_PROG -f -c 'pread -q -v 50000 10000' $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c 'pread -q -v 50000 10000' $TESTDIR/file3) \
+       || echo "Sections do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/810.out b/tests/generic/810.out
new file mode 100644
index 0000000..f2e9bb1
--- /dev/null
+++ b/tests/generic/810.out
@@ -0,0 +1,16 @@
+QA output created by 810
+Create the original files
+a1e4db1af2c4414774d4096bc86e04f7  TEST_DIR/test-810/file1
+a1e4db1af2c4414774d4096bc86e04f7  TEST_DIR/test-810/file2
+a1e4db1af2c4414774d4096bc86e04f7  TEST_DIR/test-810/file3
+mmap CoW the second file
+Checksum both files
+a1e4db1af2c4414774d4096bc86e04f7  TEST_DIR/test-810/file1
+9ce45bcb3bcfb0194ffee83f34e26beb  TEST_DIR/test-810/file2
+9ce45bcb3bcfb0194ffee83f34e26beb  TEST_DIR/test-810/file3
+Compare the CoW'd section to the before file
+Sections do not match (intentional)
+Sections do not match (intentional)
+Sections do not match (intentional)
+Compare the CoW'd section to the after file
+Compare the not CoW'd sections
diff --git a/tests/generic/837 b/tests/generic/837
new file mode 100755
index 0000000..2153b72
--- /dev/null
+++ b/tests/generic/837
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test No. 837
+#
+# Ensure that reflinking a file N times and CoWing the copies leaves the
+# original intact.
+#   - Create a file and record its hash and fiemap
+#   - Create some reflink copies
+#   - Rewrite all the reflink copies
+#   - Compare the contents and fiemap of the original file
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
+SZ=$((1 * 1048576))
+NR=9
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $SZ" $TESTDIR/file1 >> $seqres.full
+sync
+md5sum $TESTDIR/file1 | _filter_test_dir
+$XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 > $TESTDIR/fiemap
+
+echo "Create the reflink copies"
+for i in `seq 2 $NR`; do
+	cp --reflink=always $TESTDIR/file1 $TESTDIR/file.$i
+done
+sync
+
+echo "Rewrite the copies"
+for i in `seq 2 $NR`; do
+	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $SZ" $TESTDIR/file.$i >> $seqres.full
+	sync
+done
+
+echo "Examine original file"
+md5sum $TESTDIR/file1 | _filter_test_dir
+$XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 > $TESTDIR/fiemap.new
+cmp -s $TESTDIR/fiemap $TESTDIR/fiemap.new
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/837.out b/tests/generic/837.out
new file mode 100644
index 0000000..86d04c6
--- /dev/null
+++ b/tests/generic/837.out
@@ -0,0 +1,7 @@
+QA output created by 837
+Create the original file blocks
+7202826a7791073fe2787f0c94603278  TEST_DIR/test-837/file1
+Create the reflink copies
+Rewrite the copies
+Examine original file
+7202826a7791073fe2787f0c94603278  TEST_DIR/test-837/file1
diff --git a/tests/generic/838 b/tests/generic/838
new file mode 100755
index 0000000..33498c3
--- /dev/null
+++ b/tests/generic/838
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test No. 837
+#
+# Ensure that reflinking a file N times and DIO CoWing the copies leaves the
+# original intact.
+#   - Create a file and record its hash and fiemap
+#   - Create some reflink copies
+#   - Rewrite all the reflink copies with directio
+#   - Compare the contents and fiemap of the original file
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
+SZ=$((1 * 1048576))
+NR=9
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $SZ" $TESTDIR/file1 >> $seqres.full
+sync
+md5sum $TESTDIR/file1 | _filter_test_dir
+$XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 > $TESTDIR/fiemap
+
+echo "Create the reflink copies"
+for i in `seq 2 $NR`; do
+	cp --reflink=always $TESTDIR/file1 $TESTDIR/file.$i
+done
+sync
+
+echo "Rewrite the copies"
+for i in `seq 2 $NR`; do
+	$XFS_IO_PROG -d -f -c "pwrite -S 0x62 0 $SZ" $TESTDIR/file.$i >> $seqres.full
+	sync
+done
+
+echo "Examine original file"
+md5sum $TESTDIR/file1 | _filter_test_dir
+$XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 > $TESTDIR/fiemap.new
+cmp -s $TESTDIR/fiemap $TESTDIR/fiemap.new
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/838.out b/tests/generic/838.out
new file mode 100644
index 0000000..6c07b9f
--- /dev/null
+++ b/tests/generic/838.out
@@ -0,0 +1,7 @@
+QA output created by 838
+Create the original file blocks
+7202826a7791073fe2787f0c94603278  TEST_DIR/test-838/file1
+Create the reflink copies
+Rewrite the copies
+Examine original file
+7202826a7791073fe2787f0c94603278  TEST_DIR/test-838/file1
diff --git a/tests/generic/group b/tests/generic/group
index 98d875a..9af1ef8 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -202,7 +202,12 @@
 805 auto quick clone
 806 auto quick clone
 807 auto quick clone
+808 auto quick clone
+809 auto quick clone
+810 auto quick clone
 817 auto quick clone
 818 auto quick clone
 819 auto quick clone
 820 auto quick clone
+837 auto quick clone
+838 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
