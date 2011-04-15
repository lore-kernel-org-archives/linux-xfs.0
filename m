Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3FJRYIV087216 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 14:27:35 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E450BDBBDC
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 12:30:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id y0zbWhQfV2qZahVW for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2011 12:30:57 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p3FJUvJD000505
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 15:30:57 -0400
Received: from test1244.test.redhat.com (test1244.test.redhat.com
	[10.10.10.244])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id p3FJUuw5021589
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 15:30:57 -0400
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] xfstests 252: add test for fallocate with hole punching
Date: Fri, 15 Apr 2011 15:19:59 -0400
Message-Id: <1302895199-24618-1-git-send-email-josef@redhat.com>
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

As Dave Chinner requested I moved the major test meat of 242 into common.punch
and made it take all the arguments for alloc/punch/zero/map and such.  This way
242 and 252 can use the same base test and just pass in their specific commands
they are testing.  I ran both 242 and 252 on XFS and the both pass.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 242          |  141 +---------------------------------------------------
 252          |   57 +++++++++++++++++++++
 252.out      |   47 +++++++++++++++++
 common.punch |  157 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common.rc    |   27 ++++++++++
 group        |    1 +
 6 files changed, 291 insertions(+), 139 deletions(-)
 create mode 100644 252
 create mode 100644 252.out

diff --git a/242 b/242
index 083aa31..9a0c89e 100755
--- a/242
+++ b/242
@@ -41,6 +41,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 # get standard environment, filters and checks
 . ./common.rc
 . ./common.filter
+. ./common.punch
 
 # real QA test starts here
 _supported_fs xfs
@@ -55,147 +56,9 @@ _test_io_zero()
 
 [ $(_test_io_zero) -eq 0 ] && _notrun "zero command not supported"
 
-die_now()
-{
-	status=1
-	exit
-}
-
-_filter_bmap()
-{
-    awk '$3 ~ /hole/ { print $1, $2, $3; next }
-         $7 ~ /10000/ { print $1, $2, "unwritten"; next }
-         $7 ~ /00000/ {print $1, $2, "data" }'
-}
-
-# test the different corner cases for zeroing a range:
-#
-#	1. into a hole
-#	2. into allocated space
-#	3. into unwritten space
-#	4. hole -> data
-#	5. hole -> unwritten
-#	6. data -> hole
-#	7. data -> unwritten
-#	8. unwritten -> hole
-#	9. unwritten -> data
-#	10. hole -> data -> hole
-#	11. data -> hole -> data
-#	12. unwritten -> data -> unwritten
-#	13. data -> unwritten -> data
 
 testfile=$TEST_DIR/242.$$
 
-echo "	1. into a hole"
-rm -f $testfile
-$XFS_IO_PROG -f -c "truncate 20k" \
-	-c "zero 4k 8k" \
-	-c "bmap -vp" $testfile | _filter_bmap
-[ $? -ne 0 ] && die_now
-
-echo "	2. into allocated space"
-rm -f $testfile
-$XFS_IO_PROG -f -c "truncate 20k" \
-	-c "pwrite 0 20k" -c "fsync" \
-	-c "zero 4k 8k" \
-	-c "bmap -vp" $testfile | _filter_bmap
-[ $? -ne 0 ] && die_now
-
-echo "	3. into unwritten space"
-rm -f $testfile
-$XFS_IO_PROG -f -c "truncate 20k" \
-	-c "resvsp 0 20k" \
-	-c "zero 4k 8k" \
-	-c "bmap -vp" $testfile | _filter_bmap
-[ $? -ne 0 ] && die_now
-
-echo "	4. hole -> data"
-rm -f $testfile
-$XFS_IO_PROG -f -c "truncate 20k" \
-	-c "pwrite 8k 8k" -c "fsync" \
-	-c "zero 4k 8k" \
-	-c "bmap -vp" $testfile | _filter_bmap
-[ $? -ne 0 ] && die_now
-
-echo "	5. hole -> unwritten"
-rm -f $testfile
-$XFS_IO_PROG -f -c "truncate 20k" \
-	-c "resvsp 8k 8k" \
-	-c "zero 4k 8k" \
-	-c "bmap -vp" $testfile | _filter_bmap
-[ $? -ne 0 ] && die_now
-
-echo "	6. data -> hole"
-rm -f $testfile
-$XFS_IO_PROG -f -c "truncate 20k" \
-	-c "pwrite 0 8k" -c "fsync" \
-	-c "zero 4k 8k" \
-	-c "bmap -vp" $testfile | _filter_bmap
-[ $? -ne 0 ] && die_now
-
-echo "	7. data -> unwritten"
-rm -f $testfile
-$XFS_IO_PROG -f -c "truncate 20k" \
-	-c "pwrite 0 8k" -c "fsync" \
-	-c "resvsp 8k 8k" \
-	-c "zero 4k 8k" \
-	-c "bmap -vp" $testfile | _filter_bmap
-[ $? -ne 0 ] && die_now
-
-echo "	8. unwritten -> hole"
-rm -f $testfile
-$XFS_IO_PROG -f -c "truncate 20k" \
-	-c "resvsp 0 8k" \
-	-c "zero 4k 8k" \
-	-c "bmap -vp" $testfile | _filter_bmap
-[ $? -ne 0 ] && die_now
-
-echo "	9. unwritten -> data"
-rm -f $testfile
-$XFS_IO_PROG -f -c "truncate 20k" \
-	-c "resvsp 0 8k" \
-	-c "pwrite 8k 8k" -c "fsync" \
-	-c "zero 4k 8k" \
-	-c "bmap -vp" $testfile | _filter_bmap
-[ $? -ne 0 ] && die_now
-
-echo "	10. hole -> data -> hole"
-rm -f $testfile
-$XFS_IO_PROG -f -c "truncate 20k" \
-	-c "pwrite 8k 4k" -c "fsync" \
-	-c "zero 4k 12k" \
-	-c "bmap -vp" $testfile | _filter_bmap
-[ $? -ne 0 ] && die_now
-
-echo "	11. data -> hole -> data"
-rm -f $testfile
-$XFS_IO_PROG -f -c "truncate 20k" \
-	-c "resvsp 0 20k" \
-	-c "pwrite 0 8k" \
-	-c "pwrite 12k 8k" -c "fsync" \
-	-c "unresvsp 8k 4k" \
-	-c "zero 4k 12k" \
-	-c "bmap -vp" $testfile | _filter_bmap
-[ $? -ne 0 ] && die_now
-
-echo "	12. unwritten -> data -> unwritten"
-rm -f $testfile
-$XFS_IO_PROG -f -c "truncate 20k" \
-	-c "resvsp 0 20k" \
-	-c "pwrite 8k 4k" -c "fsync" \
-	-c "zero 4k 12k" \
-	-c "bmap -vp" $testfile | _filter_bmap
-[ $? -ne 0 ] && die_now
-
-
-echo "	13. data -> unwritten -> data"
-rm -f $testfile
-$XFS_IO_PROG -f -c "truncate 20k" \
-	-c "resvsp 0 20k" \
-	-c "pwrite 0k 8k" -c "fsync" \
-	-c "pwrite 12k 8k" -c "fsync" \
-	-c "zero 4k 12k" \
-	-c "bmap -vp" $testfile | _filter_bmap
-[ $? -ne 0 ] && die_now
+_test_generic_punch resvsp unresvsp zero 'bmap -p' _filter_bmap $testfile
 
 status=0 ; exit
diff --git a/252 b/252
new file mode 100644
index 0000000..dfdf3f8
--- /dev/null
+++ b/252
@@ -0,0 +1,57 @@
+#! /bin/bash
+# FS QA Test No. 252
+#
+# Test fallocate hole punching
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 Red Hat.  All Rights Reserved.
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
+# creator
+owner=josef@redhat.com
+
+seq=`basename $0`
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
+. ./common.rc
+. ./common.filter
+. ./common.punch
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_xfs_io_falloc_punch
+_require_xfs_io_fiemap
+
+testfile=$TEST_DIR/252.$$
+
+_test_generic_punch falloc fpunch fpunch fiemap _filter_fiemap $testfile -F
+
+status=0 ; exit
diff --git a/252.out b/252.out
new file mode 100644
index 0000000..cd8e4b4
--- /dev/null
+++ b/252.out
@@ -0,0 +1,47 @@
+QA output created by 252
+	1. into a hole
+	2. into allocated space
+0: [0..7]: data
+1: [8..23]: hole
+2: [24..39]: data
+	3. into unwritten space
+0: [0..7]: unwritten
+1: [8..23]: hole
+2: [24..39]: unwritten
+	4. hole -> data
+0: [0..23]: hole
+1: [24..31]: data
+2: [32..39]: hole
+	5. hole -> unwritten
+0: [0..23]: hole
+1: [24..31]: unwritten
+2: [32..39]: hole
+	6. data -> hole
+0: [0..7]: data
+1: [8..39]: hole
+	7. data -> unwritten
+0: [0..7]: data
+1: [8..23]: hole
+2: [24..31]: unwritten
+3: [32..39]: hole
+	8. unwritten -> hole
+0: [0..7]: unwritten
+1: [8..39]: hole
+	9. unwritten -> data
+0: [0..7]: unwritten
+1: [8..23]: hole
+2: [24..31]: data
+3: [32..39]: hole
+	10. hole -> data -> hole
+	11. data -> hole -> data
+0: [0..7]: data
+1: [8..31]: hole
+2: [32..39]: data
+	12. unwritten -> data -> unwritten
+0: [0..7]: unwritten
+1: [8..31]: hole
+2: [32..39]: unwritten
+	13. data -> unwritten -> data
+0: [0..7]: data
+1: [8..31]: hole
+2: [32..39]: data
diff --git a/common.punch b/common.punch
index b6576f6..fb20d58 100644
--- a/common.punch
+++ b/common.punch
@@ -176,3 +176,160 @@ _test_punch() {
 		_do_bmap $filename		# print out the state of the file
 	done
 }
+
+_filter_fiemap()
+{
+    awk --posix '$3 ~ /hole/ { print $1, $2, $3; next }
+		 $5 ~ /0x[[:digit:]]*8[[:digit:]]{2}/ { print $1, $2, "unwritten"; next }
+		 $5 ~ /0x[[:digit:]]+/ {print $1, $2, "data" }'
+}
+
+_filter_bmap()
+{
+    awk '$3 ~ /hole/ { print $1, $2, $3; next }
+         $7 ~ /10000/ { print $1, $2, "unwritten"; next }
+         $7 ~ /00000/ {print $1, $2, "data" }'
+}
+
+die_now()
+{
+	status=1
+	exit
+}
+
+# test the different corner cases for zeroing a range:
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
+_test_generic_punch()
+{
+	alloc_cmd=$1
+	punch_cmd=$2
+	zero_cmd=$3	#if not testing zero just set to punch
+	map_cmd=$4
+	filter_cmd=$5
+	testfile=$6
+	xfs_io_opt=$7	#needs to be -F if not testing xfs
+
+	echo "	1. into a hole"
+	rm -f $testfile
+	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+		-c "$zero_cmd 4k 8k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+
+	echo "	2. into allocated space"
+	rm -f $testfile
+	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+		-c "pwrite 0 20k" -c "fsync" \
+		-c "$zero_cmd 4k 8k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+
+	echo "	3. into unwritten space"
+	rm -f $testfile
+	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+		-c "$alloc_cmd 0 20k" \
+		-c "$zero_cmd 4k 8k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+
+	echo "	4. hole -> data"
+	rm -f $testfile
+	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+		-c "pwrite 8k 8k" -c "fsync" \
+		-c "$zero_cmd 4k 8k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+
+	echo "	5. hole -> unwritten"
+	rm -f $testfile
+	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+		-c "$alloc_cmd 8k 8k" \
+		-c "$zero_cmd 4k 8k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+
+	echo "	6. data -> hole"
+	rm -f $testfile
+	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+		-c "pwrite 0 8k" -c "fsync" \
+		-c "$zero_cmd 4k 8k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+
+	echo "	7. data -> unwritten"
+	rm -f $testfile
+	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+		-c "pwrite 0 8k" -c "fsync" \
+		-c "$alloc_cmd 8k 8k" \
+		-c "$zero_cmd 4k 8k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+
+	echo "	8. unwritten -> hole"
+	rm -f $testfile
+	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+		-c "$alloc_cmd 0 8k" \
+		-c "$zero_cmd 4k 8k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+
+	echo "	9. unwritten -> data"
+	rm -f $testfile
+	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+		-c "$alloc_cmd 0 8k" \
+		-c "pwrite 8k 8k" -c "fsync" \
+		-c "$zero_cmd 4k 8k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+
+	echo "	10. hole -> data -> hole"
+	rm -f $testfile
+	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+		-c "pwrite 8k 4k" -c "fsync" \
+		-c "$zero_cmd 4k 12k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+
+	echo "	11. data -> hole -> data"
+	rm -f $testfile
+	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+		-c "$alloc_cmd 0 20k" \
+		-c "pwrite 0 8k" \
+		-c "pwrite 12k 8k" -c "fsync" \
+		-c "$punch_cmd 8k 4k" \
+		-c "$zero_cmd 4k 12k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+
+	echo "	12. unwritten -> data -> unwritten"
+	rm -f $testfile
+	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+		-c "$alloc_cmd 0 20k" \
+		-c "pwrite 8k 4k" -c "fsync" \
+		-c "$zero_cmd 4k 12k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+
+	echo "	13. data -> unwritten -> data"
+	rm -f $testfile
+	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+		-c "$alloc_cmd 0 20k" \
+		-c "pwrite 0k 8k" -c "fsync" \
+		-c "pwrite 12k 8k" -c "fsync" \
+		-c "$zero_cmd 4k 12k" \
+		-c "$map_cmd -v" $testfile | $filter_cmd
+	[ $? -ne 0 ] && die_now
+}
diff --git a/common.rc b/common.rc
index 49d59aa..58e7318 100644
--- a/common.rc
+++ b/common.rc
@@ -847,6 +847,33 @@ _require_xfs_io_falloc()
 		_notrun "xfs_io fallocate command failed (old kernel/wrong fs?)"
 }
 
+# check that xfs_io, kernel and filesystem all support fallocate with hole
+# punching
+_require_xfs_io_falloc_punch()
+{
+	testfile=$TEST_DIR/$$.falloc
+	testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
+		-c "fpunch 4k 8k" $testfile 2>&1`
+	rm -f $testfile 2>&1 > /dev/null
+	echo $testio | grep -q "not found" && \
+		_notrun "xfs_io fallocate punch support is missing"
+	echo $testio | grep -q "Operation not supported" && \
+		_notrun "xfs_io fallocate punch command failed (no fs support?)"
+}
+
+# check that xfs_io, kernel and filesystem support fiemap
+_require_xfs_io_fiemap()
+{
+	testfile=$TEST_DIR/$$.fiemap
+	testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
+		-c "fiemap -v" $testfile 2>&1`
+	rm -f $testfile 2>&1 > /dev/null
+	echo $testio | grep -q "not found" && \
+		_notrun "xfs_io fiemap support is missing"
+	echo $testio | grep -q "Operation not supported" && \
+		_notrun "xfs_io fiemap command failed (no fs support?)"
+}
+
 # Check that a fs has enough free space (in 1024b blocks)
 #
 _require_fs_space()
diff --git a/group b/group
index 3e71f1f..2ee921f 100644
--- a/group
+++ b/group
@@ -365,3 +365,4 @@ deprecated
 249 auto quick rw 
 250 auto quick rw prealloc metadata
 251 ioctl trim
+252 auto quick prealloc
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
