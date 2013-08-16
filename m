Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0274C7CBE
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 00:29:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E679F8F8078
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 22:29:00 -0700 (PDT)
Received: from mail-pa0-f44.google.com (mail-pa0-f44.google.com
	[209.85.220.44]) by cuda.sgi.com with ESMTP id pRvRP9IBL1LOxZqH
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 15 Aug 2013 22:28:58 -0700 (PDT)
Received: by mail-pa0-f44.google.com with SMTP id fz6so1474964pac.3
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 22:28:58 -0700 (PDT)
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v7] xfstests: add a new test case for ext4 indirect-based file
Date: Fri, 16 Aug 2013 13:28:07 +0800
Message-Id: <1376630887-3829-1-git-send-email-wenqing.lz@taobao.com>
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
To: xfs@oss.sgi.com, linux-ext4@vger.kernel.org, Rich Johnston <rjohnston@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Zheng Liu <wenqing.lz@taobao.com>

From: Zheng Liu <wenqing.lz@taobao.com>

After applied this commit (864688d3), xfstests #255 will not test a
file system that cannot support fallocate(2), such as a indirect-based
file in ext4.  So we need to add a new generic test case to test it.

The difference between #255 and this test case is only to use pwrite to
allocate blocks.  Other filesystems should survive in this test case.
In the mean time, a new argument '-u' is added into _test_generic_punch
not to run unwritten tests.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>
---
changelog:
 * rebase against the latest xfstests/master branch
 * don't change test case #255 because the problem has been fixed

Hi Rich,

Could you please look at this patch?

Thanks,
						- Zheng

 common/punch          |  164 ++++++++++++++++++++++++++----------------------
 tests/generic/316     |   67 ++++++++++++++++++++
 tests/generic/316.out |  165 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |    1 +
 4 files changed, 322 insertions(+), 75 deletions(-)
 create mode 100755 tests/generic/316
 create mode 100644 tests/generic/316.out

diff --git a/common/punch b/common/punch
index d8f73d0..7b3c009 100644
--- a/common/punch
+++ b/common/punch
@@ -285,19 +285,25 @@ die_now()
 # Use the -d flag to not sync the file between tests.
 # This will test the handling of delayed extents
 #
+# Use the -u flag to not run unwritten tests.
+# This will eliminate some unnecessary information.
+#
 _test_generic_punch()
 {
 
 	remove_testfile=1
 	sync_cmd="-c fsync"
+	unwritten_tests=1
 	OPTIND=1
-	while getopts 'dk' OPTION
+	while getopts 'dku' OPTION
 	do
 		case $OPTION in
 		k)	remove_testfile=
 		;;
 		d)	sync_cmd=
 		;;
+		u)	unwritten_tests=
+		;;
 		?)	echo Invalid flag
 		exit 1
 		;;
@@ -333,16 +339,18 @@ _test_generic_punch()
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
 
-	echo "	3. into unwritten space"
-	if [ "$remove_testfile" ]; then
-		rm -f $testfile
+	if [ "$unwritten_tests" ]; then
+		echo "	3. into unwritten space"
+		if [ "$remove_testfile" ]; then
+			rm -f $testfile
+		fi
+		$XFS_IO_PROG -f -c "truncate 20k" \
+			-c "$alloc_cmd 0 20k" \
+			-c "$zero_cmd 4k 8k" \
+			-c "$map_cmd -v" $testfile | $filter_cmd
+		[ $? -ne 0 ] && die_now
+		_md5_checksum $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "$alloc_cmd 0 20k" \
-		-c "$zero_cmd 4k 8k" \
-		-c "$map_cmd -v" $testfile | $filter_cmd
-	[ $? -ne 0 ] && die_now
-	_md5_checksum $testfile
 
 	echo "	4. hole -> data"
 	if [ "$remove_testfile" ]; then
@@ -355,16 +363,18 @@ _test_generic_punch()
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
 
-	echo "	5. hole -> unwritten"
-	if [ "$remove_testfile" ]; then
-		rm -f $testfile
+	if [ "$unwritten_tests" ]; then
+		echo "	5. hole -> unwritten"
+		if [ "$remove_testfile" ]; then
+			rm -f $testfile
+		fi
+		$XFS_IO_PROG -f -c "truncate 20k" \
+			-c "$alloc_cmd 8k 8k" \
+			-c "$zero_cmd 4k 8k" \
+			-c "$map_cmd -v" $testfile | $filter_cmd
+		[ $? -ne 0 ] && die_now
+		_md5_checksum $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "$alloc_cmd 8k 8k" \
-		-c "$zero_cmd 4k 8k" \
-		-c "$map_cmd -v" $testfile | $filter_cmd
-	[ $? -ne 0 ] && die_now
-	_md5_checksum $testfile
 
 	echo "	6. data -> hole"
 	if [ "$remove_testfile" ]; then
@@ -377,40 +387,42 @@ _test_generic_punch()
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
 
-	echo "	7. data -> unwritten"
-	if [ "$remove_testfile" ]; then
-		rm -f $testfile
-	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "pwrite 0 8k" $sync_cmd \
-		-c "$alloc_cmd 8k 8k" \
-		-c "$zero_cmd 4k 8k" \
-		-c "$map_cmd -v" $testfile | $filter_cmd
-	[ $? -ne 0 ] && die_now
-	_md5_checksum $testfile
-
-	echo "	8. unwritten -> hole"
-	if [ "$remove_testfile" ]; then
-		rm -f $testfile
-	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "$alloc_cmd 0 8k" \
-		-c "$zero_cmd 4k 8k" \
-		-c "$map_cmd -v" $testfile | $filter_cmd
-	[ $? -ne 0 ] && die_now
-	_md5_checksum $testfile
-
-	echo "	9. unwritten -> data"
-	if [ "$remove_testfile" ]; then
-		rm -f $testfile
+	if [ "$unwritten_tests" ]; then
+		echo "	7. data -> unwritten"
+		if [ "$remove_testfile" ]; then
+			rm -f $testfile
+		fi
+		$XFS_IO_PROG -f -c "truncate 20k" \
+			-c "pwrite 0 8k" $sync_cmd \
+			-c "$alloc_cmd 8k 8k" \
+			-c "$zero_cmd 4k 8k" \
+			-c "$map_cmd -v" $testfile | $filter_cmd
+		[ $? -ne 0 ] && die_now
+		_md5_checksum $testfile
+
+		echo "	8. unwritten -> hole"
+		if [ "$remove_testfile" ]; then
+			rm -f $testfile
+		fi
+		$XFS_IO_PROG -f -c "truncate 20k" \
+			-c "$alloc_cmd 0 8k" \
+			-c "$zero_cmd 4k 8k" \
+			-c "$map_cmd -v" $testfile | $filter_cmd
+		[ $? -ne 0 ] && die_now
+		_md5_checksum $testfile
+
+		echo "	9. unwritten -> data"
+		if [ "$remove_testfile" ]; then
+			rm -f $testfile
+		fi
+		$XFS_IO_PROG -f -c "truncate 20k" \
+			-c "$alloc_cmd 0 8k" \
+			-c "pwrite 8k 8k" $sync_cmd \
+			-c "$zero_cmd 4k 8k" \
+			-c "$map_cmd -v" $testfile | $filter_cmd
+		[ $? -ne 0 ] && die_now
+		_md5_checksum $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "$alloc_cmd 0 8k" \
-		-c "pwrite 8k 8k" $sync_cmd \
-		-c "$zero_cmd 4k 8k" \
-		-c "$map_cmd -v" $testfile | $filter_cmd
-	[ $? -ne 0 ] && die_now
-	_md5_checksum $testfile
 
 	echo "	10. hole -> data -> hole"
 	if [ "$remove_testfile" ]; then
@@ -437,30 +449,32 @@ _test_generic_punch()
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
 
-	echo "	12. unwritten -> data -> unwritten"
-	if [ "$remove_testfile" ]; then
-		rm -f $testfile
-	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "$alloc_cmd 0 20k" \
-		-c "pwrite 8k 4k" $sync_cmd \
-		-c "$zero_cmd 4k 12k" \
-		-c "$map_cmd -v" $testfile | $filter_cmd
-	[ $? -ne 0 ] && die_now
-	_md5_checksum $testfile
-
-	echo "	13. data -> unwritten -> data"
-	if [ "$remove_testfile" ]; then
-		rm -f $testfile
+	if [ "$unwritten_tests" ]; then
+		echo "	12. unwritten -> data -> unwritten"
+		if [ "$remove_testfile" ]; then
+			rm -f $testfile
+		fi
+		$XFS_IO_PROG -f -c "truncate 20k" \
+			-c "$alloc_cmd 0 20k" \
+			-c "pwrite 8k 4k" $sync_cmd \
+			-c "$zero_cmd 4k 12k" \
+			-c "$map_cmd -v" $testfile | $filter_cmd
+		[ $? -ne 0 ] && die_now
+		_md5_checksum $testfile
+
+		echo "	13. data -> unwritten -> data"
+		if [ "$remove_testfile" ]; then
+			rm -f $testfile
+		fi
+		$XFS_IO_PROG -f -c "truncate 20k" \
+			-c "$alloc_cmd 0 20k" \
+			-c "pwrite 0k 8k" $sync_cmd \
+			-c "pwrite 12k 8k" -c "fsync" \
+			-c "$zero_cmd 4k 12k" \
+			-c "$map_cmd -v" $testfile | $filter_cmd
+		[ $? -ne 0 ] && die_now
+		_md5_checksum $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "$alloc_cmd 0 20k" \
-		-c "pwrite 0k 8k" $sync_cmd \
-		-c "pwrite 12k 8k" -c "fsync" \
-		-c "$zero_cmd 4k 12k" \
-		-c "$map_cmd -v" $testfile | $filter_cmd
-	[ $? -ne 0 ] && die_now
-	_md5_checksum $testfile
 
 	echo "	14. data -> hole @ EOF"
 	rm -f $testfile
diff --git a/tests/generic/316 b/tests/generic/316
new file mode 100755
index 0000000..8cb2975
--- /dev/null
+++ b/tests/generic/316
@@ -0,0 +1,67 @@
+#! /bin/bash
+# FS QA Test No. 316
+#
+# Test Generic fallocate hole punching w/o unwritten extent
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Alibaba Group.  All Rights Reserved.
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
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/punch
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_xfs_io_falloc_punch
+_require_xfs_io_fiemap
+
+testfile=$TEST_DIR/$seq.$$
+
+# Standard punch hole tests
+_test_generic_punch -u pwrite fpunch fpunch fiemap _filter_hole_fiemap $testfile
+
+# Delayed allocation punch hole tests
+_test_generic_punch -u -d pwrite fpunch fpunch fiemap _filter_hole_fiemap $testfile
+
+# Multi hole punch tests
+_test_generic_punch -u -k pwrite fpunch fpunch fiemap _filter_hole_fiemap $testfile
+
+# Delayed allocation multi punch hole tests
+_test_generic_punch -u -d -k pwrite fpunch fpunch fiemap _filter_hole_fiemap $testfile
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/316.out b/tests/generic/316.out
new file mode 100644
index 0000000..4bb11ec
--- /dev/null
+++ b/tests/generic/316.out
@@ -0,0 +1,165 @@
+QA output created by 316
+	1. into a hole
+daa100df6e6711906b61c9ab5aa16032
+	2. into allocated space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	4. hole -> data
+0: [0..23]: hole
+1: [24..31]: extent
+2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	6. data -> hole
+0: [0..7]: extent
+1: [8..39]: hole
+1b3779878366498b28c702ef88c4a773
+	10. hole -> data -> hole
+daa100df6e6711906b61c9ab5aa16032
+	11. data -> hole -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: extent
+1: [24..39]: hole
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: extent
+13535fd4d496bf0b74bb2335aa4d1b31
+	1. into a hole
+daa100df6e6711906b61c9ab5aa16032
+	2. into allocated space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	4. hole -> data
+0: [0..23]: hole
+1: [24..31]: extent
+2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	6. data -> hole
+0: [0..7]: extent
+1: [8..39]: hole
+1b3779878366498b28c702ef88c4a773
+	10. hole -> data -> hole
+daa100df6e6711906b61c9ab5aa16032
+	11. data -> hole -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: extent
+1: [24..39]: hole
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: extent
+13535fd4d496bf0b74bb2335aa4d1b31
+	1. into a hole
+0: [0..7]: extent
+1: [8..39]: hole
+5a58e46082be047d0f13bee7974015b9
+	2. into allocated space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	4. hole -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	6. data -> hole
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	10. hole -> data -> hole
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	11. data -> hole -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: extent
+1: [24..39]: hole
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: extent
+13535fd4d496bf0b74bb2335aa4d1b31
+	1. into a hole
+0: [0..7]: extent
+1: [8..39]: hole
+5a58e46082be047d0f13bee7974015b9
+	2. into allocated space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	4. hole -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	6. data -> hole
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	10. hole -> data -> hole
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	11. data -> hole -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: extent
+1: [24..39]: hole
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: extent
+13535fd4d496bf0b74bb2335aa4d1b31
diff --git a/tests/generic/group b/tests/generic/group
index 052b0fe..c94cdde 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -118,3 +118,4 @@
 313 auto quick
 314 auto quick acl
 315 auto quick rw prealloc
+316 auto quick
-- 
1.7.9.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
