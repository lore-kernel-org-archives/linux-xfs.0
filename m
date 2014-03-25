Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2F7087F3F
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 16:12:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BA17FAC001
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 14:12:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4h34LEcw2IPvyy8i for
	<xfs@oss.sgi.com>; Tue, 25 Mar 2014 14:12:00 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2PLBxbD024979
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 17:11:59 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] xfstests: Make shared/243 ext4 specific
Date: Tue, 25 Mar 2014 22:11:51 +0100
Message-Id: <1395781911-13084-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1395781911-13084-1-git-send-email-lczerner@redhat.com>
References: <1395781911-13084-1-git-send-email-lczerner@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Lukas Czerner <lczerner@redhat.com>

The test shared/243 really is ext4 specific even though currently we
would run it on other file systems as well, it would not actually do any
testing.

So move it to ext4 specific directory and rename it to 002.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 tests/ext4/002       | 180 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/002.out   |  13 ++++
 tests/ext4/group     |   1 +
 tests/shared/243     | 180 ---------------------------------------------------
 tests/shared/243.out |  13 ----
 tests/shared/group   |   1 -
 6 files changed, 194 insertions(+), 194 deletions(-)
 create mode 100755 tests/ext4/002
 create mode 100644 tests/ext4/002.out
 delete mode 100755 tests/shared/243
 delete mode 100644 tests/shared/243.out

diff --git a/tests/ext4/002 b/tests/ext4/002
new file mode 100755
index 0000000..12be253
--- /dev/null
+++ b/tests/ext4/002
@@ -0,0 +1,180 @@
+#! /bin/bash
+# FS QA Test No. ext4/002
+#
+# Test to ensure that the EOFBLOCK_FL gets set/unset correctly.
+#
+# As found by Theodore Ts'o:
+# If a 128K file is falloc'ed using the KEEP_SIZE flag, and then
+# write exactly 128K, the EOFBLOCK_FL doesn't get cleared correctly.
+# This is bad since it forces e2fsck to complain about that inode.
+# If you have a large number of inodes that are written with fallocate
+# using KEEP_SIZE, and then fill them up to their expected size,
+# e2fsck will potentially complain about a _huge_ number of inodes.
+# This would also cause a huge increase in the time taken by e2fsck
+# to complete its check.
+#
+# Test scenarios covered:
+# 1. Fallocating X bytes and writing Y (Y<X) (buffered and direct io)
+# 2. Fallocating X bytes and writing Y (Y=X) (buffered and direct io)
+# 3. Fallocating X bytes and writing Y (Y>X) (buffered and direct io)
+#
+# These test cases exercise the normal and edge case conditions using
+# falloc (and KEEP_SIZE).
+#
+# Ref: http://thread.gmane.org/gmane.comp.file-systems.ext4/20682
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 Google, Inc.  All Rights Reserved.
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
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1        # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# Test specific macros.
+BIT_NOT_SET=0   # inode flag - 0x400000 bit is not set.
+BIT_SET=1       # inode flag - 0x400000 bit is set.
+
+# Generic test cleanup function.
+_cleanup()
+{
+  cd /
+  rm -f $tmp.*
+}
+
+# Ext4 uses the EOFBLOCKS_FL bit when fallocating blocks with KEEP_SIZE
+# enabled. The only time this bit should be set is when extending the allocated
+# blocks further than what the i_size represents. In the situations wherein the
+# i_size covers all allocated blocks, this bit should be cleared.
+
+# Checks the state of the sample file in the filesystem and returns whether
+# the inode flag 0x400000 is set or not.
+_check_ext4_eof_flag()
+{
+  # Check whether EOFBLOCK_FL is set.
+  # For ext4 filesystems: use debugfs to check if EOFBLOCKS_FL is set.
+  # Other filesystems: do nothing. The default fsck at the end of the test
+  # should catch any potential errors.
+  if [ "${FSTYP}" == "ext4" ]; then
+    bit_set=1
+
+    # Unmount the ${TEST_DEV}
+    umount ${TEST_DEV}
+
+    # Run debugfs to gather file_parameters - specifically iflags.
+    file_params=`debugfs ${TEST_DEV} -R "stat ${1}" 2>&1 | grep -e Flags:`
+    iflags=${file_params#*Flags: }
+
+    # Ensure that the iflags value was parsed correctly.
+    if [ -z ${iflags} ]; then
+      echo "iFlags value was not parsed successfully." >> $seqres.full
+      status=1
+      exit ${status}
+    fi
+
+    # Check if EOFBLOCKS_FL is set.
+    if ((${iflags} & 0x400000)); then
+      echo "EOFBLOCK_FL bit is set." >> $seqres.full
+      bit_set=1
+    else
+      echo "EOFBLOCK_FL bit is not set." >> $seqres.full
+      bit_set=0
+    fi
+
+    # Check current bit state to expected value.
+    if [ ${bit_set} -ne ${2} ]; then
+      echo "Error: Current bit state incorrect." >> $seqres.full
+      status=1
+      exit ${status}
+    fi
+
+    # Mount the ${TEST_DEV}
+    mount ${TEST_DEV} -t ${FSTYP} ${TEST_DIR}
+  fi
+}
+
+# Get standard environment, filters and checks.
+. ./common/rc
+. ./common/filter
+
+# Prerequisites for the test run.
+_supported_fs ext4
+_supported_os Linux
+_require_xfs_io_falloc
+
+# Real QA test starts here.
+rm -f $seqres.full
+
+# Remove any leftover files from last run.
+rm -f ${TEST_DIR}/test_?
+
+# Begin test cases.
+echo "Test 1: Fallocate 40960 bytes and write 4096 bytes (buffered io)." \
+    >> $seqres.full
+${XFS_IO_PROG} -f                       \
+    -c 'falloc -k 0 40960'              \
+    -c 'pwrite 0 4096'                  \
+    ${TEST_DIR}/test_1 | _filter_xfs_io_unique
+_check_ext4_eof_flag test_1 ${BIT_SET}
+
+echo "Test 2: Fallocate 40960 bytes and write 4096 bytes (direct io)." \
+    >> $seqres.full
+${XFS_IO_PROG} -f -d                    \
+    -c 'falloc -k 0 40960'              \
+    -c 'pwrite 0 4096'                  \
+    ${TEST_DIR}/test_2 | _filter_xfs_io_unique
+_check_ext4_eof_flag test_2 ${BIT_SET}
+
+echo "Test 3: Fallocate 40960 bytes and write 40960 bytes (buffered io)." \
+    >> $seqres.full
+${XFS_IO_PROG} -f                       \
+    -c 'falloc -k 0 40960'              \
+    -c 'pwrite 0 40960'                 \
+    ${TEST_DIR}/test_3 | _filter_xfs_io_unique
+_check_ext4_eof_flag test_3 ${BIT_NOT_SET}
+
+echo "Test 4: Fallocate 40960 bytes and write 40960 bytes (direct io)." \
+    >> $seqres.full
+${XFS_IO_PROG} -f -d                    \
+    -c 'falloc -k 0 40960'              \
+    -c 'pwrite 0 40960'                 \
+    ${TEST_DIR}/test_4 | _filter_xfs_io_unique
+_check_ext4_eof_flag test_4 ${BIT_NOT_SET}
+
+echo "Test 5: Fallocate 128k, seek 256k and write 4k block (buffered io)." \
+    >> $seqres.full
+${XFS_IO_PROG} -f                       \
+    -c 'falloc -k 0 128k'               \
+    -c 'pwrite 256k 4k'                 \
+    ${TEST_DIR}/test_5 | _filter_xfs_io_unique
+_check_ext4_eof_flag test_5 ${BIT_NOT_SET}
+
+echo "Test 6: Fallocate 128k, seek to 256k and write a 4k block (direct io)." \
+    >> $seqres.full
+${XFS_IO_PROG} -f -d                    \
+    -c 'falloc -k 0 128k'               \
+    -c 'pwrite 256k 4k'                 \
+    ${TEST_DIR}/test_6 | _filter_xfs_io_unique
+_check_ext4_eof_flag test_6 ${BIT_NOT_SET}
+
+status=0
+exit ${status}
diff --git a/tests/ext4/002.out b/tests/ext4/002.out
new file mode 100644
index 0000000..3dcca87
--- /dev/null
+++ b/tests/ext4/002.out
@@ -0,0 +1,13 @@
+QA output created by 002
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 40960/40960 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 40960/40960 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 262144
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 262144
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/ext4/group b/tests/ext4/group
index dd2841e..7e66035 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -4,6 +4,7 @@
 # - comment line before each group is "new" description
 #
 001 auto prealloc quick
+002 auto quick prealloc
 271 auto rw quick
 301 aio dangerous ioctl rw stress
 302 aio dangerous ioctl rw stress
diff --git a/tests/shared/243 b/tests/shared/243
deleted file mode 100755
index e0f2db2..0000000
--- a/tests/shared/243
+++ /dev/null
@@ -1,180 +0,0 @@
-#! /bin/bash
-# FS QA Test No. 243
-#
-# Test to ensure that the EOFBLOCK_FL gets set/unset correctly.
-#
-# As found by Theodore Ts'o:
-# If a 128K file is falloc'ed using the KEEP_SIZE flag, and then
-# write exactly 128K, the EOFBLOCK_FL doesn't get cleared correctly.
-# This is bad since it forces e2fsck to complain about that inode.
-# If you have a large number of inodes that are written with fallocate
-# using KEEP_SIZE, and then fill them up to their expected size,
-# e2fsck will potentially complain about a _huge_ number of inodes.
-# This would also cause a huge increase in the time taken by e2fsck
-# to complete its check.
-#
-# Test scenarios covered:
-# 1. Fallocating X bytes and writing Y (Y<X) (buffered and direct io)
-# 2. Fallocating X bytes and writing Y (Y=X) (buffered and direct io)
-# 3. Fallocating X bytes and writing Y (Y>X) (buffered and direct io)
-#
-# These test cases exercise the normal and edge case conditions using
-# falloc (and KEEP_SIZE).
-#
-# Ref: http://thread.gmane.org/gmane.comp.file-systems.ext4/20682
-#
-#-----------------------------------------------------------------------
-# Copyright (c) 2010 Google, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#-----------------------------------------------------------------------
-#
-
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=/tmp/$$
-status=1        # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-# Test specific macros.
-BIT_NOT_SET=0   # inode flag - 0x400000 bit is not set.
-BIT_SET=1       # inode flag - 0x400000 bit is set.
-
-# Generic test cleanup function.
-_cleanup()
-{
-  cd /
-  rm -f $tmp.*
-}
-
-# Ext4 uses the EOFBLOCKS_FL bit when fallocating blocks with KEEP_SIZE
-# enabled. The only time this bit should be set is when extending the allocated
-# blocks further than what the i_size represents. In the situations wherein the
-# i_size covers all allocated blocks, this bit should be cleared.
-
-# Checks the state of the sample file in the filesystem and returns whether
-# the inode flag 0x400000 is set or not.
-_check_ext4_eof_flag()
-{
-  # Check whether EOFBLOCK_FL is set.
-  # For ext4 filesystems: use debugfs to check if EOFBLOCKS_FL is set.
-  # Other filesystems: do nothing. The default fsck at the end of the test
-  # should catch any potential errors.
-  if [ "${FSTYP}" == "ext4" ]; then
-    bit_set=1
-
-    # Unmount the ${TEST_DEV}
-    umount ${TEST_DEV}
-
-    # Run debugfs to gather file_parameters - specifically iflags.
-    file_params=`debugfs ${TEST_DEV} -R "stat ${1}" 2>&1 | grep -e Flags:`
-    iflags=${file_params#*Flags: }
-
-    # Ensure that the iflags value was parsed correctly.
-    if [ -z ${iflags} ]; then
-      echo "iFlags value was not parsed successfully." >> $seqres.full
-      status=1
-      exit ${status}
-    fi
-
-    # Check if EOFBLOCKS_FL is set.
-    if ((${iflags} & 0x400000)); then
-      echo "EOFBLOCK_FL bit is set." >> $seqres.full
-      bit_set=1
-    else
-      echo "EOFBLOCK_FL bit is not set." >> $seqres.full
-      bit_set=0
-    fi
-
-    # Check current bit state to expected value.
-    if [ ${bit_set} -ne ${2} ]; then
-      echo "Error: Current bit state incorrect." >> $seqres.full
-      status=1
-      exit ${status}
-    fi
-
-    # Mount the ${TEST_DEV}
-    mount ${TEST_DEV} -t ${FSTYP} ${TEST_DIR}
-  fi
-}
-
-# Get standard environment, filters and checks.
-. ./common/rc
-. ./common/filter
-
-# Prerequisites for the test run.
-_supported_fs ext4 xfs btrfs gfs2
-_supported_os Linux
-_require_xfs_io_falloc
-
-# Real QA test starts here.
-rm -f $seqres.full
-
-# Remove any leftover files from last run.
-rm -f ${TEST_DIR}/test_?
-
-# Begin test cases.
-echo "Test 1: Fallocate 40960 bytes and write 4096 bytes (buffered io)." \
-    >> $seqres.full
-${XFS_IO_PROG} -f                       \
-    -c 'falloc -k 0 40960'              \
-    -c 'pwrite 0 4096'                  \
-    ${TEST_DIR}/test_1 | _filter_xfs_io_unique
-_check_ext4_eof_flag test_1 ${BIT_SET}
-
-echo "Test 2: Fallocate 40960 bytes and write 4096 bytes (direct io)." \
-    >> $seqres.full
-${XFS_IO_PROG} -f -d                    \
-    -c 'falloc -k 0 40960'              \
-    -c 'pwrite 0 4096'                  \
-    ${TEST_DIR}/test_2 | _filter_xfs_io_unique
-_check_ext4_eof_flag test_2 ${BIT_SET}
-
-echo "Test 3: Fallocate 40960 bytes and write 40960 bytes (buffered io)." \
-    >> $seqres.full
-${XFS_IO_PROG} -f                       \
-    -c 'falloc -k 0 40960'              \
-    -c 'pwrite 0 40960'                 \
-    ${TEST_DIR}/test_3 | _filter_xfs_io_unique
-_check_ext4_eof_flag test_3 ${BIT_NOT_SET}
-
-echo "Test 4: Fallocate 40960 bytes and write 40960 bytes (direct io)." \
-    >> $seqres.full
-${XFS_IO_PROG} -f -d                    \
-    -c 'falloc -k 0 40960'              \
-    -c 'pwrite 0 40960'                 \
-    ${TEST_DIR}/test_4 | _filter_xfs_io_unique
-_check_ext4_eof_flag test_4 ${BIT_NOT_SET}
-
-echo "Test 5: Fallocate 128k, seek 256k and write 4k block (buffered io)." \
-    >> $seqres.full
-${XFS_IO_PROG} -f                       \
-    -c 'falloc -k 0 128k'               \
-    -c 'pwrite 256k 4k'                 \
-    ${TEST_DIR}/test_5 | _filter_xfs_io_unique
-_check_ext4_eof_flag test_5 ${BIT_NOT_SET}
-
-echo "Test 6: Fallocate 128k, seek to 256k and write a 4k block (direct io)." \
-    >> $seqres.full
-${XFS_IO_PROG} -f -d                    \
-    -c 'falloc -k 0 128k'               \
-    -c 'pwrite 256k 4k'                 \
-    ${TEST_DIR}/test_6 | _filter_xfs_io_unique
-_check_ext4_eof_flag test_6 ${BIT_NOT_SET}
-
-status=0
-exit ${status}
diff --git a/tests/shared/243.out b/tests/shared/243.out
deleted file mode 100644
index 290a005..0000000
--- a/tests/shared/243.out
+++ /dev/null
@@ -1,13 +0,0 @@
-QA output created by 243
-wrote 4096/4096 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 4096/4096 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 40960/40960 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 40960/40960 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 4096/4096 bytes at offset 262144
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 4096/4096 bytes at offset 262144
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/shared/group b/tests/shared/group
index 1c6fffb..2165aac 100644
--- a/tests/shared/group
+++ b/tests/shared/group
@@ -5,7 +5,6 @@
 #
 032 mkfs auto quick
 051 acl udf auto quick
-243 auto quick prealloc
 272 auto enospc rw
 289 auto quick
 298 auto trim
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
