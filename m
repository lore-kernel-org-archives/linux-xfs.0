Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8B40729E02
	for <xfs@oss.sgi.com>; Sun,  6 Oct 2013 15:14:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0A20BAC001
	for <xfs@oss.sgi.com>; Sun,  6 Oct 2013 13:14:03 -0700 (PDT)
Received: from mail-pa0-f48.google.com (mail-pa0-f48.google.com
	[209.85.220.48]) by cuda.sgi.com with ESMTP id TAESaTgVHHxD4sHC
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 06 Oct 2013 13:14:01 -0700 (PDT)
Received: by mail-pa0-f48.google.com with SMTP id bj1so6404247pad.21
	for <xfs@oss.sgi.com>; Sun, 06 Oct 2013 13:14:00 -0700 (PDT)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH RESEND 5/7] xfstest: Add test case to check various corner
	cases for collapsing range
Date: Mon,  7 Oct 2013 05:13:52 +0900
Message-Id: <1381090432-2863-1-git-send-email-linkinjeon@gmail.com>
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
To: viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, tytso@mit.edu, adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org, hch@infradead.org, david@fromorbit.com
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This patch checks various corner cases for collapsing a range.
This patch is based on generic/255 test case which checks various corner
cases for punch hole.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 common/collapse      |  264 ++++++++++++++++++++++++++++++++++++++++++++++++++
 common/rc            |   14 +++
 tests/shared/316     |   70 +++++++++++++
 tests/shared/316.out |  221 ++++++++++++++++++++++++++++++++++++++++++
 tests/shared/group   |    2 +-
 5 files changed, 570 insertions(+), 1 deletion(-)
 create mode 100644 common/collapse
 create mode 100644 tests/shared/316
 create mode 100644 tests/shared/316.out

diff --git a/common/collapse b/common/collapse
new file mode 100644
index 0000000..dd3be5e
--- /dev/null
+++ b/common/collapse
@@ -0,0 +1,264 @@
+##/bin/bash
+#
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
+# Test procedure for checking collapse range feature
+
+# Test different corner cases for collapsing a range:
+#
+#	1. into a hole
+#	2. into allocated space
+#	3. into unwritten space
+#	4. hole -> data
+#	5. hole -> unwritten
+#	6. data -> hole
+#	7. data -> unwritten
+#	8. unwritten -> hole
+#	9. unwritten -> data
+#	10. hole -> data -> hole
+#	11. data -> hole -> data
+#	12. unwritten -> data -> unwritten
+#	13. data -> unwritten -> data
+#	14. data -> hole @ EOF
+#	15. data -> hole @ 0
+#	16. data -> cache cold ->hole
+#
+# Test file is removed, created and sync'd between tests.
+#
+# Use -k flag to keep the file between tests.  This will
+# test the handling of pre-existing holes.
+#
+# Use the -d flag to not sync the file between tests.
+# This will test the handling of delayed extents
+#
+_test_generic_collapse()
+{
+
+	remove_testfile=1
+	sync_cmd="-c fsync"
+	OPTIND=1
+	while getopts 'dk' OPTION
+	do
+		case $OPTION in
+		k)	remove_testfile=
+		;;
+		d)	sync_cmd=
+		;;
+		?)	echo Invalid flag
+		exit 1
+		;;
+		esac
+	done
+	shift $(($OPTIND - 1))
+
+	alloc_cmd=$1
+	collapse_cmd=$2
+	punch_cmd=$3
+	map_cmd=$4
+	filter_cmd=$5
+	testfile=$6
+
+	echo "	1. into a hole"
+	if [ "$remove_testfile" ]; then
+		rm -f $testfile
+	fi
+	$XFS_IO_PROG -f -c "truncate 80k" \
+		-c "$collapse_cmd 16k 32k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
+
+	echo "	2. into allocated space"
+	if [ "$remove_testfile" ]; then
+		rm -f $testfile
+	fi
+	$XFS_IO_PROG -f -c "truncate 80k" \
+		-c "pwrite 0 80k" $sync_cmd \
+		-c "$collapse_cmd 16k 32k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
+
+	echo "	3. into unwritten space"
+	if [ "$remove_testfile" ]; then
+		rm -f $testfile
+	fi
+	$XFS_IO_PROG -f -c "truncate 80k" \
+		-c "$alloc_cmd 0 80k" \
+		-c "$collapse_cmd 16k 32k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
+
+	echo "	4. hole -> data"
+	if [ "$remove_testfile" ]; then
+		rm -f $testfile
+	fi
+	$XFS_IO_PROG -f -c "truncate 80k" \
+		-c "pwrite 32k 32k" $sync_cmd \
+		-c "$collapse_cmd 16k 32k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
+
+	echo "	5. hole -> unwritten"
+	if [ "$remove_testfile" ]; then
+		rm -f $testfile
+	fi
+	$XFS_IO_PROG -f -c "truncate 80k" \
+		-c "$alloc_cmd 32k 32k" \
+		-c "$collapse_cmd 16k 32k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
+
+	echo "	6. data -> hole"
+	if [ "$remove_testfile" ]; then
+		rm -f $testfile
+	fi
+	$XFS_IO_PROG -f -c "truncate 80k" \
+		-c "pwrite 0 32k" $sync_cmd \
+		-c "$collapse_cmd 16k 32k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
+
+	echo "	7. data -> unwritten"
+	if [ "$remove_testfile" ]; then
+		rm -f $testfile
+	fi
+	$XFS_IO_PROG -f -c "truncate 80k" \
+		-c "pwrite 0 32k" $sync_cmd \
+		-c "$alloc_cmd 32k 32k" \
+		-c "$collapse_cmd 16k 32k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
+
+	echo "	8. unwritten -> hole"
+	if [ "$remove_testfile" ]; then
+		rm -f $testfile
+	fi
+	$XFS_IO_PROG -f -c "truncate 80k" \
+		-c "$alloc_cmd 0 32k" \
+		-c "$collapse_cmd 16k 32k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
+
+	echo "	9. unwritten -> data"
+	if [ "$remove_testfile" ]; then
+		rm -f $testfile
+	fi
+	$XFS_IO_PROG -f -c "truncate 80k" \
+		-c "$alloc_cmd 0 32k" \
+		-c "pwrite 32k 32k" $sync_cmd \
+		-c "$collapse_cmd 16k 32k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
+
+	echo "	10. hole -> data -> hole"
+	if [ "$remove_testfile" ]; then
+		rm -f $testfile
+	fi
+	$XFS_IO_PROG -f -c "truncate 80k" \
+		-c "pwrite 32k 16k" $sync_cmd \
+		-c "$collapse_cmd 16k 48k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
+
+	echo "	11. data -> hole -> data"
+	if [ "$remove_testfile" ]; then
+		rm -f $testfile
+	fi
+	$XFS_IO_PROG -f -c "truncate 80k" \
+		-c "$alloc_cmd 0 80k" \
+		-c "pwrite 0 32k" \
+		-c "pwrite 48k 32k" $sync_cmd \
+		-c "$punch_cmd 32k 16k" \
+		-c "$collapse_cmd 8k 48k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
+
+	echo "	12. unwritten -> data -> unwritten"
+	if [ "$remove_testfile" ]; then
+		rm -f $testfile
+	fi
+	$XFS_IO_PROG -f -c "truncate 80k" \
+		-c "$alloc_cmd 0 80k" \
+		-c "pwrite 32k 16k" $sync_cmd \
+		-c "$collapse_cmd 16k 48k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
+
+	echo "	13. data -> unwritten -> data"
+	if [ "$remove_testfile" ]; then
+		rm -f $testfile
+	fi
+	$XFS_IO_PROG -f -c "truncate 80k" \
+		-c "$alloc_cmd 0 80k" \
+		-c "pwrite 0k 32k" $sync_cmd \
+		-c "pwrite 48k 32k" -c "fsync" \
+		-c "$collapse_cmd 16k 48k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
+
+	echo "	14. data -> hole @ EOF"
+	rm -f $testfile
+	$XFS_IO_PROG -f -c "truncate 80k" \
+		-c "pwrite 0 80k" $sync_cmd \
+		-c "$collapse_cmd 48k 32k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
+
+	echo "	15. data -> hole @ 0"
+	if [ "$remove_testfile" ]; then
+		rm -f $testfile
+	fi
+	$XFS_IO_PROG -f -c "truncate 80k" \
+		-c "pwrite 0 80k" $sync_cmd \
+		-c "$collapse_cmd 0k 32k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
+
+	echo "	16. data -> cache cold ->hole"
+	if [ "$remove_testfile" ]; then
+		rm -f $testfile
+		rm -f $testfile.2
+	else
+		cp $testfile $testfile.2
+	fi
+	$XFS_IO_PROG -f -c "truncate 48k" \
+		-c "pwrite 0k 48k" -c "fsync" $testfile.2 \
+		> /dev/null
+	$XFS_IO_PROG -f -c "truncate 80k" \
+		-c "pwrite 0 80k" $sync_cmd \
+		-c "$collapse_cmd 0k 32k" \
+		-c "fadvise -d" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	diff $testfile $testfile.2
+	[ $? -ne 0 ] && die_now
+	rm -f $testfile.2
+	_md5_checksum $testfile
+
+}
diff --git a/common/rc b/common/rc
index 77e96c4..1779eed 100644
--- a/common/rc
+++ b/common/rc
@@ -1248,6 +1248,20 @@ _require_xfs_io_falloc_punch()
 		_notrun "xfs_io fallocate punch command failed (no fs support?)"
 }
 
+# check that xfs_io, kernel and filesystem all support fallocate with collapse
+# range
+_require_xfs_io_falloc_collapse()
+{
+	testfile=$TEST_DIR/$$.falloc
+	testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
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
diff --git a/tests/shared/316 b/tests/shared/316
new file mode 100644
index 0000000..66a8489
--- /dev/null
+++ b/tests/shared/316
@@ -0,0 +1,70 @@
+#! /bin/bash
+# FS QA Test No. 316
+#
+# Test fallocate collapse range
+#
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
+. ./common/collapse
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
+testfile=$TEST_DIR/316.$$
+
+# Standard collapse range tests
+_test_generic_collapse falloc fcollapse fpunch fiemap _filter_hole_fiemap $testfile
+
+# Delayed allocation collapse range tests
+_test_generic_collapse -d falloc fcollapse fpunch fiemap _filter_hole_fiemap $testfile
+
+# Multi collapse tests
+_test_generic_collapse -k falloc fcollapse fpunch fiemap _filter_hole_fiemap $testfile
+
+# Delayed allocation multi collapse range tests
+_test_generic_collapse -d -k falloc fcollapse fpunch fiemap _filter_hole_fiemap $testfile
+
+status=0 ; exit
diff --git a/tests/shared/316.out b/tests/shared/316.out
new file mode 100644
index 0000000..09ebf0d
--- /dev/null
+++ b/tests/shared/316.out
@@ -0,0 +1,221 @@
+QA output created by 316
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
+	14. data -> hole @ EOF
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
+	15. data -> hole @ 0
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
+	16. data -> cache cold ->hole
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
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
+	14. data -> hole @ EOF
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
+	15. data -> hole @ 0
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
+	16. data -> cache cold ->hole
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
+	1. into a hole
+0: [0..31]: extent
+1: [32..95]: hole
+f07217d5ac7ffa15dd8910c4aa912674
+	2. into allocated space
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
+	3. into unwritten space
+0: [0..95]: extent
+f07217d5ac7ffa15dd8910c4aa912674
+	4. hole -> data
+0: [0..63]: extent
+1: [64..95]: hole
+e5c94f6299822646f9f57aeacd8bdc01
+	5. hole -> unwritten
+0: [0..63]: extent
+1: [64..95]: hole
+f07217d5ac7ffa15dd8910c4aa912674
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
+f07217d5ac7ffa15dd8910c4aa912674
+	9. unwritten -> data
+0: [0..63]: extent
+1: [64..95]: hole
+e5c94f6299822646f9f57aeacd8bdc01
+	10. hole -> data -> hole
+0: [0..31]: extent
+1: [32..63]: hole
+76cc863b386460b228a493933813a6a0
+	11. data -> hole -> data
+0: [0..63]: extent
+0f0151cbed83e4bf6e5bde26e82ab115
+	12. unwritten -> data -> unwritten
+0: [0..63]: extent
+76cc863b386460b228a493933813a6a0
+	13. data -> unwritten -> data
+0: [0..63]: extent
+0f0151cbed83e4bf6e5bde26e82ab115
+	14. data -> hole @ EOF
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
+	15. data -> hole @ 0
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
+	16. data -> cache cold ->hole
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
+	1. into a hole
+0: [0..31]: extent
+1: [32..95]: hole
+f07217d5ac7ffa15dd8910c4aa912674
+	2. into allocated space
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
+	3. into unwritten space
+0: [0..95]: extent
+f07217d5ac7ffa15dd8910c4aa912674
+	4. hole -> data
+0: [0..63]: extent
+1: [64..95]: hole
+e5c94f6299822646f9f57aeacd8bdc01
+	5. hole -> unwritten
+0: [0..63]: extent
+1: [64..95]: hole
+f07217d5ac7ffa15dd8910c4aa912674
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
+f07217d5ac7ffa15dd8910c4aa912674
+	9. unwritten -> data
+0: [0..63]: extent
+1: [64..95]: hole
+e5c94f6299822646f9f57aeacd8bdc01
+	10. hole -> data -> hole
+0: [0..31]: extent
+1: [32..63]: hole
+76cc863b386460b228a493933813a6a0
+	11. data -> hole -> data
+0: [0..63]: extent
+0f0151cbed83e4bf6e5bde26e82ab115
+	12. unwritten -> data -> unwritten
+0: [0..63]: extent
+76cc863b386460b228a493933813a6a0
+	13. data -> unwritten -> data
+0: [0..63]: extent
+0f0151cbed83e4bf6e5bde26e82ab115
+	14. data -> hole @ EOF
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
+	15. data -> hole @ 0
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
+	16. data -> cache cold ->hole
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
diff --git a/tests/shared/group b/tests/shared/group
index 0ad640b..3a69294 100644
--- a/tests/shared/group
+++ b/tests/shared/group
@@ -11,4 +11,4 @@
 289 auto quick
 298 auto trim
 305 aio dangerous enospc rw stress
-
+316 auto quick collapse
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
