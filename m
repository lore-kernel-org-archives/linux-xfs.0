Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4KINRHi105730 for <xfs@oss.sgi.com>; Fri, 20 May 2011 13:23:28 -0500
Received: from smtp-out.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 17F4FCF8006
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 11:23:24 -0700 (PDT)
Received: from smtp-out.google.com (smtp-out.google.com [74.125.121.67]) by
	cuda.sgi.com with ESMTP id 4XtDp1pAyddTJc6F for
	<xfs@oss.sgi.com>; Fri, 20 May 2011 11:23:24 -0700 (PDT)
From: haldar@google.com
Subject: [PATCH] xfstests: test fallocate, write, ftruncate combinations.
Date: Fri, 20 May 2011 11:22:51 -0700
Message-Id: <1305915771-8003-1-git-send-email-haldar@google.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: sandeen@redhat.com, haldar@google.com

From: Vivek Haldar <haldar@google.com>

Scenarios covered:
1. Fallocate X bytes
2. Write Y bytes
3. Truncate to Z bytes
for various values of X, Y and Z, and check both file size and
number of filesystem blocks used by the file after each of
1, 2 and 3.

Signed-off-by: Vivek Haldar <haldar@google.com>
---
 254     |  254 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 254.out |   48 ++++++++++++
 group   |    1 +
 3 files changed, 303 insertions(+), 0 deletions(-)
 create mode 100644 254
 create mode 100644 254.out

diff --git a/254 b/254
new file mode 100644
index 0000000..bb11b2e
--- /dev/null
+++ b/254
@@ -0,0 +1,254 @@
+#! /bin/bash
+# FS QA Test No. 254
+#
+# Test fallocate, write, ftruncate combinations.
+#
+# Scenarios covered:
+# 1. Fallocate X bytes
+# 2. Write Y bytes
+# 3. Truncate to Z bytes
+# for various values of X, Y and Z, and check both file size and
+# number of filesystem blocks used by the file after each of
+# 1, 2 and 3.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 Google, Inc.  All Rights Reserved.
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
+# creator
+owner=haldar@google.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1        # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# fallocate, write and truncate with various options and checks.
+_test()
+{
+  falloc_size=${1}         # bytes
+  falloc_keep_size=${2}    # boolean
+  expected_size_after_falloc=${3}
+  expected_blocks_after_falloc=${4}
+  write_size=${5}
+  expected_size_after_write=${6}
+  expected_blocks_after_write=${7}
+  trunc_size=${8}
+  expected_size_after_trunc=${9}
+  expected_blocks_after_trunc=${10}
+  dont_delete_test_file=${11}  # boolean
+
+  echo "falloc/write/truncate test: \
+    falloc_size=${falloc_size} \
+    falloc_keep_size=${falloc_keep_size} \
+    expected_size_after_falloc=${expected_size_after_falloc} \
+    expected_blocks_after_falloc=${expected_blocks_after_falloc} \
+    write_size=${write_size} \
+    expected_size_after_write=${expected_size_after_write} \
+    expected_blocks_after_write=${expected_blocks_after_write} \
+    trunc_size=${trunc_size} \
+    expected_size_after_trunc=${expected_size_after_trunc} \
+    expected_blocks_after_trunc=${expected_blocks_after_trunc} \
+    dont_delete_test_file=${dont_delete_test_file}"
+    
+  if [ $dont_delete_test_file ] ; then
+    echo "Re-using test file."
+  else
+    rm -f $test_file
+  fi
+
+  # falloc
+  keep_size_flag=''
+  if $falloc_keep_size ; then
+    keep_size_flag='-k'
+  fi
+  if [ $falloc_size -gt 0 ]; then
+    ${XFS_IO_PROG} -F -f -d \
+      -c "falloc $keep_size_flag 0 $falloc_size" \
+      $test_file | _filter_xfs_io_unique
+  else
+    touch $test_file
+  fi
+
+  # check sizes after falloc
+  size_after_falloc=`stat --format="%s" $test_file`
+  blocks_after_falloc=`du --block-size=4096 -s $test_file | cut -f 1`
+
+  if [ $expected_size_after_falloc -ne $size_after_falloc ]; then
+    status=1
+    echo "Expected size after falloc to be $expected_size_after_falloc \
+      but it was actually $size_after_falloc."
+    exit ${status}
+  fi
+
+  if [ $expected_blocks_after_falloc -ne $blocks_after_falloc ]; then
+    status=1
+    echo "Expected blocks after falloc to be $expected_blocks_after_falloc \
+      but it was actually $blocks_after_falloc."
+    exit ${status}
+  fi
+
+  # write
+  if [ $write_size -gt 0 ]; then
+    ${XFS_IO_PROG} -F -f -d \
+      -c "pwrite 0 $write_size" \
+      $test_file | _filter_xfs_io_unique
+  fi
+
+  # check sizes after write
+  size_after_write=`stat --format="%s" $test_file`
+  blocks_after_write=`du --block-size=4096 -s $test_file | cut -f 1`
+
+  if [ $expected_size_after_write -ne $size_after_write ]; then
+    status=1
+    echo "Expected size after write to be $expected_size_after_write \
+      but it was actually $size_after_write."
+    exit ${status}
+  fi
+
+  if [ $expected_blocks_after_write -ne $blocks_after_write ]; then
+    status=1
+    echo "Expected blocks after write to be $expected_blocks_after_write \
+      but it was actually $blocks_after_write."
+    exit ${status}
+  fi
+
+  # trunc
+  if [ $trunc_size -gt 0 ]; then
+    ${XFS_IO_PROG} -F -f -d \
+      -c "truncate $trunc_size" \
+      $test_file | _filter_xfs_io_unique
+  fi
+
+  # check sizes after trunc
+  size_after_trunc=`stat --format="%s" $test_file`
+  blocks_after_trunc=`du --block-size=4096 -s $test_file | cut -f 1`
+
+  if [ $expected_size_after_trunc -ne $size_after_trunc ]; then
+    status=1
+    echo "Expected size after truncate to be $expected_size_after_trunc \
+      but it was actually $size_after_trunc."
+    exit ${status}
+  fi
+
+  if [ $expected_blocks_after_trunc -ne $blocks_after_trunc ]; then
+    status=1
+    echo "Expected blocks after trunc to be $expected_blocks_after_trunc \
+      but it was actually $blocks_after_trunc."
+    exit ${status}
+  fi
+}
+
+# Check that a file has the given bit pattern.
+_test_file_contents()
+{
+  file_name=${1}
+  offset=${2}
+  len=${3}
+  expected_pattern=${4}
+  expected_count=${5}
+
+  count=`${XFS_IO_PROG} -F -f -d -c \
+    "pread -v $offset $len" $file_name \
+    | grep -w -c $expected_pattern`
+
+  if [ $expected_count -ne $count ]; then
+    status=1
+    echo "Expected count $expected_count for $file_name at \
+      offset $offset for $len bytes for pattern $expected_pattern \
+      but count was $count."
+    exit ${status}
+  fi
+}
+
+# Get standard environment, filters and checks.
+. ./common.rc
+. ./common.filter
+
+# Prerequisites for the test run.
+_supported_fs generic
+_supported_os Linux
+_require_xfs_io_falloc
+
+# Remove any leftover files from last run.
+rm -f ${TEST_DIR}/test*
+
+test_file=${TEST_DIR}/test
+
+# Generic test cleanup function.
+_cleanup()
+{
+  cd /
+  rm -f $tmp.*
+  rm -f $test_file
+}
+
+# Begin test cases.
+
+# KEEP_SIZE
+_test 10240 true  0 3  0    0    3  0   0   3
+_test 8192  true  0 2  0    0    2  0   0   2
+_test 4096  true  0 1  0    0    1  0   0   1
+
+# !KEEP_SIZE
+_test 10240 false 10240  3  0    10240    3  0   10240   3
+_test 8192  false 8192   2  0    8192     2  0   8192    2
+_test 4096  false 4096   1  0    4096     1  0   4096    1
+_test_file_contents $test_file 1024 512 "00" 32   # check null.
+
+_test 10240 true 0 3  4096    4096    3  0   4096   3
+_test 10240 true 0 3  8192    8192    3  0   8192   3
+_test 10240 true 0 3  10240    10240    3  0   10240   3
+
+_test 16384 true 0 4  16384    16384    4  0   16384   4
+
+# just truncate tests, without falloc.
+_test 0 false 0 0   8192 8192 2    8192 8192 2
+_test 0 false 0 0   8192 8192 2    4096 4096 1
+_test 0 false 0 0   8192 8192 2    16384 16384 2
+_test_file_contents $test_file 8192 512 "00" 32   # check null.
+_test_file_contents $test_file 4096 512 "cd" 32   # check non-null.
+
+# write beyond fallocate size and then truncate to the written size.
+_test 8192 true 0 2    16384 16384 4    16384 16384 4
+_test_file_contents $test_file 8192 512 "cd" 32   # check non-null.
+
+# fallocate, write, truncate below the written size, and then truncate up. Then
+# try to read the previously written data to see whether it returns zero or the
+# stale data.
+_test 8192 true 0 2      16384 16384 4    12288 12288 3
+_test 0    true 12288 3  0     12288 3    16384 16384 3   true
+_test_file_contents $test_file 1024 512 "cd" 32    # check non-null.
+_test_file_contents $test_file 12288 512 "00" 32   # check null.
+
+# fallocate, write with the fallocate size, write after the fallocate size, and
+# then truncate to a size smaller than the fallocate size.
+_test 8192 true 0 2      8192 8192 2      0 8192 2
+_test 0    true 8192 2   12288 12288 3    4096 4096 1   true
+
+
+# The following reproduce an existing bug.
+# See http://patchwork.ozlabs.org/patch/96080/
+_test 10240 true 0 3  4096 4096 3  8192 8192 2
+_test 10240 true 0 3  0    0    3  8192 8192 2
+_test 16384 true 0 4  0        0        4  16384   16384   4
+
+
+status=0
+exit ${status}
diff --git a/254.out b/254.out
new file mode 100644
index 0000000..fe70f0e
--- /dev/null
+++ b/254.out
@@ -0,0 +1,48 @@
+QA output created by 254
+falloc/write/truncate test:     falloc_size=10240     falloc_keep_size=true     expected_size_after_falloc=0     expected_blocks_after_falloc=3     write_size=0     expected_size_after_write=0     expected_blocks_after_write=3     trunc_size=0     expected_size_after_trunc=0     expected_blocks_after_trunc=3     dont_delete_test_file=
+falloc/write/truncate test:     falloc_size=8192     falloc_keep_size=true     expected_size_after_falloc=0     expected_blocks_after_falloc=2     write_size=0     expected_size_after_write=0     expected_blocks_after_write=2     trunc_size=0     expected_size_after_trunc=0     expected_blocks_after_trunc=2     dont_delete_test_file=
+falloc/write/truncate test:     falloc_size=4096     falloc_keep_size=true     expected_size_after_falloc=0     expected_blocks_after_falloc=1     write_size=0     expected_size_after_write=0     expected_blocks_after_write=1     trunc_size=0     expected_size_after_trunc=0     expected_blocks_after_trunc=1     dont_delete_test_file=
+falloc/write/truncate test:     falloc_size=10240     falloc_keep_size=false     expected_size_after_falloc=10240     expected_blocks_after_falloc=3     write_size=0     expected_size_after_write=10240     expected_blocks_after_write=3     trunc_size=0     expected_size_after_trunc=10240     expected_blocks_after_trunc=3     dont_delete_test_file=
+falloc/write/truncate test:     falloc_size=8192     falloc_keep_size=false     expected_size_after_falloc=8192     expected_blocks_after_falloc=2     write_size=0     expected_size_after_write=8192     expected_blocks_after_write=2     trunc_size=0     expected_size_after_trunc=8192     expected_blocks_after_trunc=2     dont_delete_test_file=
+falloc/write/truncate test:     falloc_size=4096     falloc_keep_size=false     expected_size_after_falloc=4096     expected_blocks_after_falloc=1     write_size=0     expected_size_after_write=4096     expected_blocks_after_write=1     trunc_size=0     expected_size_after_trunc=4096     expected_blocks_after_trunc=1     dont_delete_test_file=
+falloc/write/truncate test:     falloc_size=10240     falloc_keep_size=true     expected_size_after_falloc=0     expected_blocks_after_falloc=3     write_size=4096     expected_size_after_write=4096     expected_blocks_after_write=3     trunc_size=0     expected_size_after_trunc=4096     expected_blocks_after_trunc=3     dont_delete_test_file=
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+falloc/write/truncate test:     falloc_size=10240     falloc_keep_size=true     expected_size_after_falloc=0     expected_blocks_after_falloc=3     write_size=8192     expected_size_after_write=8192     expected_blocks_after_write=3     trunc_size=0     expected_size_after_trunc=8192     expected_blocks_after_trunc=3     dont_delete_test_file=
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+falloc/write/truncate test:     falloc_size=10240     falloc_keep_size=true     expected_size_after_falloc=0     expected_blocks_after_falloc=3     write_size=10240     expected_size_after_write=10240     expected_blocks_after_write=3     trunc_size=0     expected_size_after_trunc=10240     expected_blocks_after_trunc=3     dont_delete_test_file=
+wrote 10240/10240 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+falloc/write/truncate test:     falloc_size=16384     falloc_keep_size=true     expected_size_after_falloc=0     expected_blocks_after_falloc=4     write_size=16384     expected_size_after_write=16384     expected_blocks_after_write=4     trunc_size=0     expected_size_after_trunc=16384     expected_blocks_after_trunc=4     dont_delete_test_file=
+wrote 16384/16384 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+falloc/write/truncate test:     falloc_size=0     falloc_keep_size=false     expected_size_after_falloc=0     expected_blocks_after_falloc=0     write_size=8192     expected_size_after_write=8192     expected_blocks_after_write=2     trunc_size=8192     expected_size_after_trunc=8192     expected_blocks_after_trunc=2     dont_delete_test_file=
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+falloc/write/truncate test:     falloc_size=0     falloc_keep_size=false     expected_size_after_falloc=0     expected_blocks_after_falloc=0     write_size=8192     expected_size_after_write=8192     expected_blocks_after_write=2     trunc_size=4096     expected_size_after_trunc=4096     expected_blocks_after_trunc=1     dont_delete_test_file=
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+falloc/write/truncate test:     falloc_size=0     falloc_keep_size=false     expected_size_after_falloc=0     expected_blocks_after_falloc=0     write_size=8192     expected_size_after_write=8192     expected_blocks_after_write=2     trunc_size=16384     expected_size_after_trunc=16384     expected_blocks_after_trunc=2     dont_delete_test_file=
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+falloc/write/truncate test:     falloc_size=8192     falloc_keep_size=true     expected_size_after_falloc=0     expected_blocks_after_falloc=2     write_size=16384     expected_size_after_write=16384     expected_blocks_after_write=4     trunc_size=16384     expected_size_after_trunc=16384     expected_blocks_after_trunc=4     dont_delete_test_file=
+wrote 16384/16384 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+falloc/write/truncate test:     falloc_size=8192     falloc_keep_size=true     expected_size_after_falloc=0     expected_blocks_after_falloc=2     write_size=16384     expected_size_after_write=16384     expected_blocks_after_write=4     trunc_size=12288     expected_size_after_trunc=12288     expected_blocks_after_trunc=3     dont_delete_test_file=
+wrote 16384/16384 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+falloc/write/truncate test:     falloc_size=0     falloc_keep_size=true     expected_size_after_falloc=12288     expected_blocks_after_falloc=3     write_size=0     expected_size_after_write=12288     expected_blocks_after_write=3     trunc_size=16384     expected_size_after_trunc=16384     expected_blocks_after_trunc=3     dont_delete_test_file=true
+Re-using test file.
+falloc/write/truncate test:     falloc_size=8192     falloc_keep_size=true     expected_size_after_falloc=0     expected_blocks_after_falloc=2     write_size=8192     expected_size_after_write=8192     expected_blocks_after_write=2     trunc_size=0     expected_size_after_trunc=8192     expected_blocks_after_trunc=2     dont_delete_test_file=
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+falloc/write/truncate test:     falloc_size=0     falloc_keep_size=true     expected_size_after_falloc=8192     expected_blocks_after_falloc=2     write_size=12288     expected_size_after_write=12288     expected_blocks_after_write=3     trunc_size=4096     expected_size_after_trunc=4096     expected_blocks_after_trunc=1     dont_delete_test_file=true
+Re-using test file.
+wrote 12288/12288 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+falloc/write/truncate test:     falloc_size=10240     falloc_keep_size=true     expected_size_after_falloc=0     expected_blocks_after_falloc=3     write_size=4096     expected_size_after_write=4096     expected_blocks_after_write=3     trunc_size=8192     expected_size_after_trunc=8192     expected_blocks_after_trunc=2     dont_delete_test_file=
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+falloc/write/truncate test:     falloc_size=10240     falloc_keep_size=true     expected_size_after_falloc=0     expected_blocks_after_falloc=3     write_size=0     expected_size_after_write=0     expected_blocks_after_write=3     trunc_size=8192     expected_size_after_trunc=8192     expected_blocks_after_trunc=2     dont_delete_test_file=
+falloc/write/truncate test:     falloc_size=16384     falloc_keep_size=true     expected_size_after_falloc=0     expected_blocks_after_falloc=4     write_size=0     expected_size_after_write=0     expected_blocks_after_write=4     trunc_size=16384     expected_size_after_trunc=16384     expected_blocks_after_trunc=4     dont_delete_test_file=
diff --git a/group b/group
index 9f88e75..a5e278d 100644
--- a/group
+++ b/group
@@ -367,3 +367,4 @@ deprecated
 251 ioctl trim
 252 auto quick prealloc
 253 auto quick
+254 auto quick prealloc
-- 
1.7.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
