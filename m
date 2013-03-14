Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id 6D8ED7F5E
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 08:06:12 -0500 (CDT)
Received: from polaris-admin.engr.sgi.com (polaris-admin.engr.sgi.com
	[150.166.41.54])
	by cthulhu.engr.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id
	r2ED6Bx9007460 for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 06:06:11 -0700
Date: Thu, 14 Mar 2013 06:06:11 -0700
Subject: [PATCH 12/18] xfstests: adjusts group files for other fs tests
MIME-Version: 1.0
Message-Id: <20130314130611.995A753DEAF9@polaris-admin.engr.sgi.com>
From: pwhite@sgi.com (Philip White)
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
To: xfs@oss.sgi.com

From: Phil White <pwhite@sgi.com>


This is a rebasing & resubmit of a dchinner patch.  His comments on the
original:
-----------------
These are tests that are shared between multiple filesystems (moved
to shared), and udf/btrfs/ext4 specific tests, moved to appropriate
directories.

I created the "shared" directory to indicate tests that are not
truly generic, but also not filesystem specific. They might rely on
a feature that is only implmented in a few filesystems and so can't
be truly generic.
-----------------

Again, the actual test movements are in a later patch.

Signed-off-by: Phil White <pwhite@sgi.com>
---
 check              |    4 ++--
 common             |   12 +++++-------
 group              |   19 -------------------
 tests/btrfs/group  |   10 ++++++++++
 tests/ext4/group   |    6 ++++++
 tests/shared/group |   10 ++++++++++
 tests/udf/group    |    8 ++++++++
 tests/xfs/group    |    3 +++
 8 files changed, 44 insertions(+), 28 deletions(-)
 create mode 100644 tests/btrfs/group
 create mode 100644 tests/ext4/group
 create mode 100644 tests/shared/group
 create mode 100644 tests/udf/group

diff --git a/check b/check
index dea63d7..9819a84 100755
--- a/check
+++ b/check
@@ -97,7 +97,7 @@ END	{ if (NR > 0) {
 
 	echo "" >>check.log
 	date >>check.log
-	echo $list | fmt | sed -e 's/^/    /' -e 's;tests/;;g' >>check.log
+	echo $list | fmt | sed -e 's/^/    /' -e 's;$SRC_DIR/;;g' >>check.log
 	$interrupt && echo "Interrupted!" >>check.log
         
         if [ ! -z "$n_try" -a $n_try != 0 ]
@@ -178,7 +178,7 @@ do
 
     # the filename for the test and the name output are different.
     # we don't include the tests/ directory in the name output.
-    seqnum=`echo $seq | sed -e 's;tests/;;'`
+    seqnum=`echo $seq | sed -e 's;$SRC_DIR/;;'`
 
     echo -n "$seqnum"
 
diff --git a/common b/common
index 57c3ac5..d7207d6 100644
--- a/common
+++ b/common
@@ -33,9 +33,8 @@ have_test_arg=false
 randomize=false
 timestamp=${TIMESTAMP:=false}
 SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
-TEST_GROUP_DIR="tests"
-GENERIC_GROUP_DIR="$TEST_GROUP_DIR/generic"
-XFS_GROUP_DIR="$TEST_GROUP_DIR/xfs"
+SRC_DIR="tests"
+SRC_GROUPS="generic shared"
 
 _setenvironment()
 {
@@ -46,13 +45,12 @@ _setenvironment()
 get_group_list()
 {
 	grp=$1
-	dirs=". $GENERIC_GROUP_DIR $XFS_GROUP_DIR"
 
-	for d in $dirs; do
-		l=$(sed -n < $d/group \
+	for d in $SRC_GROUPS $FSTYP; do
+		l=$(sed -n < $SRC_DIR/$d/group \
 			-e 's/#.*//' \
 			-e 's/$/ /' \
-			-e "s;\(^[0-9][0-9][0-9]\).* $grp .*;$d/\1;p")
+			-e "s;\(^[0-9][0-9][0-9]\).* $grp .*;$SRC_DIR/$d/\1;p")
 		grpl="$grpl $l"
 	done
 	echo $grpl
diff --git a/group b/group
index 9e8ee53..0f8d1fc 100644
--- a/group
+++ b/group
@@ -114,25 +114,6 @@ deprecated
 # TIME_FACTOR: Usually means factor of run time, or number of operations
 stress
 
-# test-group association ... one line per test
-#
-040 other auto
-051 acl udf auto quick
-068 other auto freeze dangerous stress
-098 udf auto
-101 udf
-102 udf
-177 rw other auto
-218 auto fsr quick
-243 auto quick prealloc
-252 auto quick prealloc
-254 auto quick
-264 auto
-265 auto
-271 auto rw quick
-272 auto enospc rw
-276 auto rw metadata
-284 auto
 285 auto rw
 286 other
 287 auto dump quota quick
diff --git a/tests/btrfs/group b/tests/btrfs/group
new file mode 100644
index 0000000..8926c40
--- /dev/null
+++ b/tests/btrfs/group
@@ -0,0 +1,10 @@
+# QA groups control file
+# Defines test groups and nominal group owners
+# - do not start group names with a digit
+# - comment line before each group is "new" description
+#
+254 auto quick
+264 auto
+265 auto
+276 auto rw metadata
+284 auto
diff --git a/tests/ext4/group b/tests/ext4/group
new file mode 100644
index 0000000..1d6c041
--- /dev/null
+++ b/tests/ext4/group
@@ -0,0 +1,6 @@
+# QA groups control file
+# Defines test groups and nominal group owners
+# - do not start group names with a digit
+# - comment line before each group is "new" description
+#
+271 auto rw quick
diff --git a/tests/shared/group b/tests/shared/group
new file mode 100644
index 0000000..b2ff729
--- /dev/null
+++ b/tests/shared/group
@@ -0,0 +1,10 @@
+# QA groups control file
+# Defines test groups and nominal group owners
+# - do not start group names with a digit
+# - comment line before each group is "new" description
+#
+051 acl udf auto quick
+068 other auto freeze dangerous
+218 auto fsr quick
+243 auto quick prealloc
+272 auto enospc rw
diff --git a/tests/udf/group b/tests/udf/group
new file mode 100644
index 0000000..24f682c
--- /dev/null
+++ b/tests/udf/group
@@ -0,0 +1,8 @@
+# QA groups control file
+# Defines test groups and nominal group owners
+# - do not start group names with a digit
+# - comment line before each group is "new" description
+#
+098 udf auto
+101 udf
+102 udf
diff --git a/tests/xfs/group b/tests/xfs/group
index 0affcba..c165752 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -26,6 +26,7 @@
 037 dump ioctl remote tape
 038 dump ioctl remote tape
 039 dump ioctl remote tape
+040 other auto
 041 growfs ioctl auto
 042 fsr ioctl auto
 043 dump ioctl tape
@@ -124,6 +125,7 @@
 174 rw filestreams auto
 175 dmapi auto
 176 dmapi auto
+177 rw other auto
 178 mkfs other auto
 179 metadata rw auto
 180 metadata rw auto
@@ -158,6 +160,7 @@
 242 auto quick prealloc
 244 auto quota quick
 250 auto quick rw prealloc metadata
+252 auto quick prealloc
 253 auto quick
 259 auto quick
 261 auto quick quota
-- 
1.5.3.8

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
