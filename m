Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3133A7FF3
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 10:38:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9F2EEAC004
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 08:38:49 -0800 (PST)
Received: from mail-pd0-f180.google.com (mail-pd0-f180.google.com
	[209.85.192.180]) by cuda.sgi.com with ESMTP id
	QWwsD85aqHmkr9mK (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 18 Feb 2014 08:38:47 -0800 (PST)
Received: by mail-pd0-f180.google.com with SMTP id x10so16515113pdj.11
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 08:38:47 -0800 (PST)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v5 5/10] xfstest: shared/001: Standard collapse range tests
Date: Wed, 19 Feb 2014 01:38:33 +0900
Message-Id: <1392741513-20165-1-git-send-email-linkinjeon@gmail.com>
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
To: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com, lczerner@redhat.com
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This testcase(001) tries to test various corner cases
for fcollapse range functionality over different type of extents.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 common/punch         | 156 ++++++++++++++++++++++++++++++---------------------
 common/rc            |  14 +++++
 tests/shared/001     |  65 +++++++++++++++++++++
 tests/shared/001.out |  49 ++++++++++++++++
 tests/shared/group   |   1 +
 5 files changed, 222 insertions(+), 63 deletions(-)
 create mode 100755 tests/shared/001
 create mode 100644 tests/shared/001.out

diff --git a/common/punch b/common/punch
index 49715a7..9340d3b 100644
--- a/common/punch
+++ b/common/punch
@@ -317,14 +317,29 @@ _test_generic_punch()
 	map_cmd=$4
 	filter_cmd=$5
 	testfile=$6
+	multiple=1
+
+	#
+	# If we are testing collapse range, we increare all the offsets of this
+	# test by a factor of 4. We do this because unlike punch, collapse
+	# range also decreases the size of file hence require bigger offsets.
+	#
+	if [ "$zero_cmd" == "fcollapse" ]; then
+		multiple=4
+	fi
+
+	_4k="$((multiple * 4))k"
+	_8k="$((multiple * 8))k"
+	_12k="$((multiple * 12))k"
+	_20k="$((multiple * 20))k"
 
 	# initial test state must be defined, otherwise the first test can fail
 	# due ot stale file state left from previous tests.
 	rm -f $testfile
 
 	echo "	1. into a hole"
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "$zero_cmd 4k 8k" \
+	$XFS_IO_PROG -f -c "truncate $_20k" \
+		-c "$zero_cmd $_4k $_8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
@@ -333,9 +348,9 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "pwrite 0 20k" $sync_cmd \
-		-c "$zero_cmd 4k 8k" \
+	$XFS_IO_PROG -f -c "truncate $_20k" \
+		-c "pwrite 0 $_20k" $sync_cmd \
+		-c "$zero_cmd $_4k $_8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
@@ -345,9 +360,9 @@ _test_generic_punch()
 		if [ "$remove_testfile" ]; then
 			rm -f $testfile
 		fi
-		$XFS_IO_PROG -f -c "truncate 20k" \
-			-c "$alloc_cmd 0 20k" \
-			-c "$zero_cmd 4k 8k" \
+		$XFS_IO_PROG -f -c "truncate $_20k" \
+			-c "$alloc_cmd 0 $_20k" \
+			-c "$zero_cmd $_4k $_8k" \
 			-c "$map_cmd -v" $testfile | $filter_cmd
 		[ $? -ne 0 ] && die_now
 		_md5_checksum $testfile
@@ -357,9 +372,9 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "pwrite 8k 8k" $sync_cmd \
-		-c "$zero_cmd 4k 8k" \
+	$XFS_IO_PROG -f -c "truncate $_20k" \
+		-c "pwrite $_8k $_8k" $sync_cmd \
+		-c "$zero_cmd $_4k $_8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
@@ -369,9 +384,9 @@ _test_generic_punch()
 		if [ "$remove_testfile" ]; then
 			rm -f $testfile
 		fi
-		$XFS_IO_PROG -f -c "truncate 20k" \
-			-c "$alloc_cmd 8k 8k" \
-			-c "$zero_cmd 4k 8k" \
+		$XFS_IO_PROG -f -c "truncate $_20k" \
+			-c "$alloc_cmd $_8k $_8k" \
+			-c "$zero_cmd $_4k $_8k" \
 			-c "$map_cmd -v" $testfile | $filter_cmd
 		[ $? -ne 0 ] && die_now
 		_md5_checksum $testfile
@@ -381,9 +396,9 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "pwrite 0 8k" $sync_cmd \
-		-c "$zero_cmd 4k 8k" \
+	$XFS_IO_PROG -f -c "truncate $_20k" \
+		-c "pwrite 0 $_8k" $sync_cmd \
+		 -c "$zero_cmd $_4k $_8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
@@ -393,10 +408,10 @@ _test_generic_punch()
 		if [ "$remove_testfile" ]; then
 			rm -f $testfile
 		fi
-		$XFS_IO_PROG -f -c "truncate 20k" \
-			-c "pwrite 0 8k" $sync_cmd \
-			-c "$alloc_cmd 8k 8k" \
-			-c "$zero_cmd 4k 8k" \
+		$XFS_IO_PROG -f -c "truncate $_20k" \
+			-c "pwrite 0 $_8k" $sync_cmd \
+			-c "$alloc_cmd $_8k $_8k" \
+			-c "$zero_cmd $_4k $_8k" \
 			-c "$map_cmd -v" $testfile | $filter_cmd
 		[ $? -ne 0 ] && die_now
 		_md5_checksum $testfile
@@ -405,9 +420,9 @@ _test_generic_punch()
 		if [ "$remove_testfile" ]; then
 			rm -f $testfile
 		fi
-		$XFS_IO_PROG -f -c "truncate 20k" \
-			-c "$alloc_cmd 0 8k" \
-			-c "$zero_cmd 4k 8k" \
+		$XFS_IO_PROG -f -c "truncate $_20k" \
+			-c "$alloc_cmd 0 $_8k" \
+			-c "$zero_cmd $_4k $_8k" \
 			-c "$map_cmd -v" $testfile | $filter_cmd
 		[ $? -ne 0 ] && die_now
 		_md5_checksum $testfile
@@ -416,10 +431,10 @@ _test_generic_punch()
 		if [ "$remove_testfile" ]; then
 			rm -f $testfile
 		fi
-		$XFS_IO_PROG -f -c "truncate 20k" \
-			-c "$alloc_cmd 0 8k" \
-			-c "pwrite 8k 8k" $sync_cmd \
-			-c "$zero_cmd 4k 8k" \
+		$XFS_IO_PROG -f -c "truncate $_20k" \
+			-c "$alloc_cmd 0 $_8k" \
+			-c "pwrite $_8k $_8k" $sync_cmd \
+			-c "$zero_cmd $_4k $_8k" \
 			-c "$map_cmd -v" $testfile | $filter_cmd
 		[ $? -ne 0 ] && die_now
 		_md5_checksum $testfile
@@ -429,9 +444,9 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "pwrite 8k 4k" $sync_cmd \
-		-c "$zero_cmd 4k 12k" \
+	$XFS_IO_PROG -f -c "truncate $_20k" \
+		-c "pwrite $_8k $_4k" $sync_cmd \
+		-c "$zero_cmd $_4k $_12k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
@@ -440,12 +455,12 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "$alloc_cmd 0 20k" \
-		-c "pwrite 0 8k" \
-		-c "pwrite 12k 8k" $sync_cmd \
-		-c "$punch_cmd 8k 4k" \
-		-c "$zero_cmd 4k 12k" \
+	$XFS_IO_PROG -f -c "truncate $_20k" \
+		-c "$alloc_cmd 0 $_20k" \
+		-c "pwrite 0 $_8k" \
+		-c "pwrite $_12k $_8k" $sync_cmd \
+		-c "$punch_cmd $_8k $_4k" \
+		-c "$zero_cmd $_4k $_12k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
@@ -455,10 +470,10 @@ _test_generic_punch()
 		if [ "$remove_testfile" ]; then
 			rm -f $testfile
 		fi
-		$XFS_IO_PROG -f -c "truncate 20k" \
-			-c "$alloc_cmd 0 20k" \
-			-c "pwrite 8k 4k" $sync_cmd \
-			-c "$zero_cmd 4k 12k" \
+		$XFS_IO_PROG -f -c "truncate $_20k" \
+			-c "$alloc_cmd 0 $_20k" \
+			-c "pwrite $_8k $_4k" $sync_cmd \
+			-c "$zero_cmd $_4k $_12k" \
 			-c "$map_cmd -v" $testfile | $filter_cmd
 		[ $? -ne 0 ] && die_now
 		_md5_checksum $testfile
@@ -467,36 +482,51 @@ _test_generic_punch()
 		if [ "$remove_testfile" ]; then
 			rm -f $testfile
 		fi
-		$XFS_IO_PROG -f -c "truncate 20k" \
-			-c "$alloc_cmd 0 20k" \
-			-c "pwrite 0k 8k" $sync_cmd \
-			-c "pwrite 12k 8k" -c "fsync" \
-			-c "$zero_cmd 4k 12k" \
+		$XFS_IO_PROG -f -c "truncate $_20k" \
+			-c "$alloc_cmd 0 $_20k" \
+			-c "pwrite 0k $_4k" $sync_cmd \
+			-c "pwrite $_12k $_8k" -c "fsync" \
+			-c "$zero_cmd $_4k $_12k" \
 			-c "$map_cmd -v" $testfile | $filter_cmd
 		[ $? -ne 0 ] && die_now
 		_md5_checksum $testfile
 	fi
 
-	echo "	14. data -> hole @ EOF"
-	rm -f $testfile
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "pwrite 0 20k" $sync_cmd \
-		-c "$zero_cmd 12k 8k" \
-		-c "$map_cmd -v" $testfile | $filter_cmd
-	[ $? -ne 0 ] && die_now
-	_md5_checksum $testfile
+	# Don't need to check EOF case for collapse range.
+	# VFS layer return invalid error in this case,
+	# So it is not a proper case for collapse range test of each local fs.
+	if [ "$zero_cmd" != "fcollapse" ]; then
+		echo "	14. data -> hole @ EOF"
+		rm -f $testfile
+		$XFS_IO_PROG -f -c "truncate $_20k" \
+			-c "pwrite 0 $_20k" $sync_cmd \
+			-c "$zero_cmd $_12k $_8k" \
+			-c "$map_cmd -v" $testfile | $filter_cmd
+		[ $? -ne 0 ] && die_now
+		_md5_checksum $testfile
+	fi
+
+	if [ "$zero_cmd" == "fcollapse" ]; then
+		echo "	14. data -> hole @ 0"
+	else
+		echo "	15. data -> hole @ 0"
+	fi
 
-	echo "	15. data -> hole @ 0"
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "pwrite 0 20k" $sync_cmd \
-		-c "$zero_cmd 0k 8k" \
+	$XFS_IO_PROG -f -c "truncate $_20k" \
+		-c "pwrite 0 $_20k" $sync_cmd \
+		-c "$zero_cmd 0 $_8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
 
+	# If zero_cmd is fcollpase, don't check unaligned offsets
+	if [ "$zero_cmd" == "fcollapse" ]; then
+		return
+	fi
+
 	echo "	16. data -> cache cold ->hole"
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
@@ -504,12 +534,12 @@ _test_generic_punch()
 	else
 		cp $testfile $testfile.2
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "pwrite 8k 12k" -c "fsync" $testfile.2 \
+	$XFS_IO_PROG -f -c "truncate $_20k" \
+		-c "pwrite $_8k $_12k" -c "fsync" $testfile.2 \
 		> /dev/null
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "pwrite 0 20k" $sync_cmd \
-		-c "$zero_cmd 0k 8k" \
+	$XFS_IO_PROG -f -c "truncate $_20k" \
+		-c "pwrite 0 $_20k" $sync_cmd \
+		-c "$zero_cmd 0k $_8k" \
 		-c "fadvise -d" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	diff $testfile $testfile.2
diff --git a/common/rc b/common/rc
index e91568b..ff044de 100644
--- a/common/rc
+++ b/common/rc
@@ -1332,6 +1332,20 @@ _require_xfs_io_falloc_punch()
 		_notrun "xfs_io fallocate punch command failed (no fs support?)"
 }
 
+# check that xfs_io, kernel and filesystem all support fallocate with collapse
+# range
+_require_xfs_io_falloc_collapse()
+{
+	testfile=$TEST_DIR/$$.falloc
+	testio=`$XFS_IO_PROG -f -c "pwrite 0 20k" -c "fsync" \
+		-c "fcollapse 4k 8k" $testfile 2>&1`
+	rm -f $testfile 2>&1 > /dev/null
+	echo $testio | grep -q "not found" && \
+		_notrun "xfs_io fallocate collapse range support is missing"
+	echo $testio | grep -q "Operation not supported" && \
+		_notrun "xfs_io fallocate collapse range failed (no fs support?)"
+}
+
 # check that xfs_io, kernel and filesystem support fiemap
 _require_xfs_io_fiemap()
 {
diff --git a/tests/shared/001 b/tests/shared/001
new file mode 100755
index 0000000..b3ebbba
--- /dev/null
+++ b/tests/shared/001
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 1
+#
+# Standard collapse range tests 
+# This testcase is one of the 4 testcases (shared 001 - 004) which tries to
+# test various corner cases for fcollapse range functionality over different
+# type of extents. These tests are based on generic/255 test case.
+# For the type of tests, check the description of _test_generic_punch
+# in common/rc.
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Samsung Electronics.  All Rights Reserved.
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
+#
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
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+# we need to include common/punch to get defination fo filter functions
+. ./common/rc
+. ./common/filter
+. ./common/punch
+
+# real QA test starts here
+_supported_fs xfs ext4
+_supported_os Linux
+
+_require_xfs_io_falloc_punch
+_require_xfs_io_falloc
+_require_xfs_io_fiemap
+_require_xfs_io_falloc_collapse
+
+testfile=$TEST_DIR/$seq.$$
+
+_test_generic_punch falloc fpunch fcollapse fiemap _filter_hole_fiemap $testfile
+_check_test_fs
+
+status=0
+exit
diff --git a/tests/shared/001.out b/tests/shared/001.out
new file mode 100644
index 0000000..919dd12
--- /dev/null
+++ b/tests/shared/001.out
@@ -0,0 +1,49 @@
+QA output created by 001
+	1. into a hole
+f4f35d60b3cc18aaa6d8d92f0cd3708a
+	2. into allocated space
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
+	3. into unwritten space
+0: [0..95]: extent
+f4f35d60b3cc18aaa6d8d92f0cd3708a
+	4. hole -> data
+0: [0..31]: hole
+1: [32..63]: extent
+2: [64..95]: hole
+d8f51c20223dbce5c7c90db87bc221b0
+	5. hole -> unwritten
+0: [0..31]: hole
+1: [32..63]: extent
+2: [64..95]: hole
+f4f35d60b3cc18aaa6d8d92f0cd3708a
+	6. data -> hole
+0: [0..31]: extent
+1: [32..95]: hole
+f07217d5ac7ffa15dd8910c4aa912674
+	7. data -> unwritten
+0: [0..63]: extent
+1: [64..95]: hole
+f07217d5ac7ffa15dd8910c4aa912674
+	8. unwritten -> hole
+0: [0..31]: extent
+1: [32..95]: hole
+f4f35d60b3cc18aaa6d8d92f0cd3708a
+	9. unwritten -> data
+0: [0..63]: extent
+1: [64..95]: hole
+d8f51c20223dbce5c7c90db87bc221b0
+	10. hole -> data -> hole
+bb7df04e1b0a2570657527a7e108ae23
+	11. data -> hole -> data
+0: [0..63]: extent
+0f0151cbed83e4bf6e5bde26e82ab115
+	12. unwritten -> data -> unwritten
+0: [0..63]: extent
+bb7df04e1b0a2570657527a7e108ae23
+	13. data -> unwritten -> data
+0: [0..63]: extent
+0f0151cbed83e4bf6e5bde26e82ab115
+	14. data -> hole @ 0
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
diff --git a/tests/shared/group b/tests/shared/group
index 0ad640b..5562f92 100644
--- a/tests/shared/group
+++ b/tests/shared/group
@@ -3,6 +3,7 @@
 # - do not start group names with a digit
 # - comment line before each group is "new" description
 #
+001 auto prealloc
 032 mkfs auto quick
 051 acl udf auto quick
 218 auto fsr quick
-- 
1.7.11-rc0


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
