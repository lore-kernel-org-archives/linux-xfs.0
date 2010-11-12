Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oACM37Dk165407 for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 16:03:07 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 983E113B5738
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 14:04:37 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id igpTv651JOo8MSKw for
	<xfs@oss.sgi.com>; Fri, 12 Nov 2010 14:04:37 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oACM4a5V027206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 17:04:37 -0500
Received: from localhost.localdomain (test1244.test.redhat.com [10.10.10.244])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id oACM4aFO016192
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 17:04:36 -0500
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] xfstests: add test for fallocate with hole punching
Date: Fri, 12 Nov 2010 16:55:49 -0500
Message-Id: <1289598949-19216-1-git-send-email-josef@redhat.com>
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

This test is based on 242, just modified to use fiemap, fallocate and fallocate
-p.  I've looked at all of the output by hand and verified that it's working
properly.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 245       |  189 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 245.out   |   47 +++++++++++++++
 common.rc |   27 +++++++++
 group     |    1 +
 4 files changed, 264 insertions(+), 0 deletions(-)
 create mode 100755 245
 create mode 100644 245.out

diff --git a/245 b/245
new file mode 100755
index 0000000..6f7a502
--- /dev/null
+++ b/245
@@ -0,0 +1,189 @@
+#! /bin/bash
+# FS QA Test No. 242
+#
+# Test XFS_IOC_ZERO_RANGE
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
+owner=dchinner@redhat.com
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
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_xfs_io_falloc_punch
+_require_xfs_io_fiemap
+
+_filter_bmap()
+{
+    awk --posix '$3 ~ /hole/ { print $1, $2, $3; next }
+		 $5 ~ /0x[[:digit:]]*8[[:digit:]]{2}/ { print $1, $2, "unwritten"; next }
+		 $5 ~ /0x[[:digit:]]+/ {print $1, $2, "data" }'
+}
+
+# test the different corner cases for falloc -ping a range:
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
+
+testfile=$TEST_DIR/242.$$
+
+echo "	1. into a hole"
+rm -f $testfile
+$XFS_IO_PROG -F -f -c "truncate 20k" \
+	-c "falloc -p 4k 8k" \
+	-c "fiemap -v" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	2. into allocated space"
+rm -f $testfile
+$XFS_IO_PROG -F -f -c "truncate 20k" \
+	-c "pwrite 0 20k" -c "fsync" \
+	-c "falloc -p 4k 8k" \
+	-c "fiemap -v" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	3. into unwritten space"
+rm -f $testfile
+$XFS_IO_PROG -F -f -c "truncate 20k" \
+	-c "falloc 0 20k" \
+	-c "falloc -p 4k 8k" \
+	-c "fiemap -v" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	4. hole -> data"
+rm -f $testfile
+$XFS_IO_PROG -F -f -c "truncate 20k" \
+	-c "pwrite 8k 8k" -c "fsync" \
+	-c "falloc -p 4k 8k" \
+	-c "fiemap -v" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	5. hole -> unwritten"
+rm -f $testfile
+$XFS_IO_PROG -F -f -c "truncate 20k" \
+	-c "falloc 8k 8k" \
+	-c "falloc -p 4k 8k" \
+	-c "fiemap -v" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	6. data -> hole"
+rm -f $testfile
+$XFS_IO_PROG -F -f -c "truncate 20k" \
+	-c "pwrite 0 8k" -c "fsync" \
+	-c "falloc -p 4k 8k" \
+	-c "fiemap -v" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	7. data -> unwritten"
+rm -f $testfile
+$XFS_IO_PROG -F -f -c "truncate 20k" \
+	-c "pwrite 0 8k" -c "fsync" \
+	-c "falloc 8k 8k" \
+	-c "falloc -p 4k 8k" \
+	-c "fiemap -v" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	8. unwritten -> hole"
+rm -f $testfile
+$XFS_IO_PROG -F -f -c "truncate 20k" \
+	-c "falloc 0 8k" \
+	-c "falloc -p 4k 8k" \
+	-c "fiemap -v" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	9. unwritten -> data"
+rm -f $testfile
+$XFS_IO_PROG -F -f -c "truncate 20k" \
+	-c "falloc 0 8k" \
+	-c "pwrite 8k 8k" -c "fsync" \
+	-c "falloc -p 4k 8k" \
+	-c "fiemap -v" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	10. hole -> data -> hole"
+rm -f $testfile
+$XFS_IO_PROG -F -f -c "truncate 20k" \
+	-c "pwrite 8k 4k" -c "fsync" \
+	-c "falloc -p 4k 12k" \
+	-c "fiemap -v" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	11. data -> hole -> data"
+rm -f $testfile
+$XFS_IO_PROG -F -f -c "truncate 20k" \
+	-c "falloc 0 20k" \
+	-c "pwrite 0 8k" \
+	-c "pwrite 12k 8k" -c "fsync" \
+	-c "falloc -p 8k 4k" \
+	-c "falloc -p 4k 12k" \
+	-c "fiemap -v" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	12. unwritten -> data -> unwritten"
+rm -f $testfile
+$XFS_IO_PROG -F -f -c "truncate 20k" \
+	-c "falloc 0 20k" \
+	-c "pwrite 8k 4k" -c "fsync" \
+	-c "falloc -p 4k 12k" \
+	-c "fiemap -v" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+
+echo "	13. data -> unwritten -> data"
+rm -f $testfile
+$XFS_IO_PROG -F -f -c "truncate 20k" \
+	-c "falloc 0 20k" \
+	-c "pwrite 0k 8k" -c "fsync" \
+	-c "pwrite 12k 8k" -c "fsync" \
+	-c "falloc -p 4k 12k" \
+	-c "fiemap -v" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+status=0 ; exit
diff --git a/245.out b/245.out
new file mode 100644
index 0000000..b6cbf9c
--- /dev/null
+++ b/245.out
@@ -0,0 +1,47 @@
+QA output created by 245
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
diff --git a/common.rc b/common.rc
index b3bb65c..63c3a01 100644
--- a/common.rc
+++ b/common.rc
@@ -844,6 +844,33 @@ _require_xfs_io_falloc()
 		_notrun "xfs_io fallocate command failed (old kernel/wrong fs?)"
 }
 
+# check that xfs_io, kernel and filesystem all support fallocate with hole
+# punching
+_require_xfs_io_falloc_punch()
+{
+	testfile=$TEST_DIR/$$.falloc
+	testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
+		-c "falloc -p 4k 8k" $testfile 2>&1`
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
index d45c266..38909b1 100644
--- a/group
+++ b/group
@@ -358,3 +358,4 @@ deprecated
 242 auto quick prealloc
 243 auto quick prealloc
 244 auto quota quick
+245 auto quick prealloc
-- 
1.6.6.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
