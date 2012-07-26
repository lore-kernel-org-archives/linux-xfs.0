Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q9SqOV006952 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 04:28:52 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	z0qQHfKDbj3u0jHV for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 02:28:48 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuKMw-0001B7-Sl
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:30 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuKMr-0005Vw-AE
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/18] xfstests: move remaining tests out of top level
	directory
Date: Thu, 26 Jul 2012 19:28:07 +1000
Message-Id: <1343294892-20991-14-git-send-email-david@fromorbit.com>
In-Reply-To: <1343294892-20991-1-git-send-email-david@fromorbit.com>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

These are tests that are shared between multiple filesystems (moved
to shared), and udf/btrfs/ext4 specific tests, moved to appropriate
directories.

I created the "shared" directory to indicate tests that are not
truly generic, but also not filesystem specific. They might rely on
a feature that is only implmented in a few filesystems and so can't
be truly generic.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 check                           |   16 +++++++---------
 group                           |   23 -----------------------
 254 => tests/btrfs/254          |    0
 254.out => tests/btrfs/254.out  |    0
 264 => tests/btrfs/264          |    0
 264.out => tests/btrfs/264.out  |    0
 265 => tests/btrfs/265          |    0
 265.out => tests/btrfs/265.out  |    0
 276 => tests/btrfs/276          |    0
 276.out => tests/btrfs/276.out  |    0
 284 => tests/btrfs/284          |    0
 284.out => tests/btrfs/284.out  |    0
 tests/btrfs/group               |   10 ++++++++++
 271 => tests/ext4/271           |    0
 271.out => tests/ext4/271.out   |    0
 tests/ext4/group                |    6 ++++++
 051 => tests/shared/051         |    0
 051.out => tests/shared/051.out |    0
 068 => tests/shared/068         |    0
 068.out => tests/shared/068.out |    0
 218 => tests/shared/218         |    0
 218.out => tests/shared/218.out |    0
 243 => tests/shared/243         |    0
 243.out => tests/shared/243.out |    0
 272 => tests/shared/272         |    0
 272.out => tests/shared/272.out |    0
 tests/shared/group              |   10 ++++++++++
 098 => tests/udf/098            |    0
 098.out => tests/udf/098.out    |    0
 101 => tests/udf/101            |    0
 101.out => tests/udf/101.out    |    0
 102 => tests/udf/102            |    0
 102.out => tests/udf/102.out    |    0
 tests/udf/group                 |    8 ++++++++
 040 => tests/xfs/040            |    0
 040.good => tests/xfs/040.good  |    0
 040.out => tests/xfs/040.out    |    0
 177 => tests/xfs/177            |    0
 177.out => tests/xfs/177.out    |    0
 252 => tests/xfs/252            |    0
 252.out => tests/xfs/252.out    |    0
 tests/xfs/group                 |    3 +++
 42 files changed, 44 insertions(+), 32 deletions(-)
 rename 254 => tests/btrfs/254 (100%)
 rename 254.out => tests/btrfs/254.out (100%)
 rename 264 => tests/btrfs/264 (100%)
 rename 264.out => tests/btrfs/264.out (100%)
 rename 265 => tests/btrfs/265 (100%)
 rename 265.out => tests/btrfs/265.out (100%)
 rename 276 => tests/btrfs/276 (100%)
 rename 276.out => tests/btrfs/276.out (100%)
 rename 284 => tests/btrfs/284 (100%)
 rename 284.out => tests/btrfs/284.out (100%)
 create mode 100644 tests/btrfs/group
 rename 271 => tests/ext4/271 (100%)
 rename 271.out => tests/ext4/271.out (100%)
 create mode 100644 tests/ext4/group
 rename 051 => tests/shared/051 (100%)
 rename 051.out => tests/shared/051.out (100%)
 rename 068 => tests/shared/068 (100%)
 rename 068.out => tests/shared/068.out (100%)
 rename 218 => tests/shared/218 (100%)
 rename 218.out => tests/shared/218.out (100%)
 rename 243 => tests/shared/243 (100%)
 rename 243.out => tests/shared/243.out (100%)
 rename 272 => tests/shared/272 (100%)
 rename 272.out => tests/shared/272.out (100%)
 create mode 100644 tests/shared/group
 rename 098 => tests/udf/098 (100%)
 rename 098.out => tests/udf/098.out (100%)
 rename 101 => tests/udf/101 (100%)
 rename 101.out => tests/udf/101.out (100%)
 rename 102 => tests/udf/102 (100%)
 rename 102.out => tests/udf/102.out (100%)
 create mode 100644 tests/udf/group
 rename 040 => tests/xfs/040 (100%)
 rename 040.good => tests/xfs/040.good (100%)
 rename 040.out => tests/xfs/040.out (100%)
 rename 177 => tests/xfs/177 (100%)
 rename 177.out => tests/xfs/177.out (100%)
 rename 252 => tests/xfs/252 (100%)
 rename 252.out => tests/xfs/252.out (100%)

diff --git a/check b/check
index 41c1654..6ffede6 100755
--- a/check
+++ b/check
@@ -36,9 +36,8 @@ here=`pwd`
 FSTYP=xfs
 
 SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
-TEST_GROUP_DIR="tests"
-GENERIC_GROUP_DIR="$TEST_GROUP_DIR/generic"
-XFS_GROUP_DIR="$TEST_GROUP_DIR/xfs"
+SRC_DIR="tests"
+SRC_GROUPS="generic shared"
 
 # generic initialization
 iam=check
@@ -81,13 +80,12 @@ _setenvironment()
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
@@ -291,7 +289,7 @@ END	{ if (NR > 0) {
 
 	echo "" >>check.log
 	date >>check.log
-	echo $list | fmt | sed -e 's/^/    /' -e 's;tests/;;g' >>check.log
+	echo $list | fmt | sed -e 's/^/    /' -e "s;$SRC_DIR/;;g" >>check.log
 	$interrupt && echo "Interrupted!" >>check.log
         
         if [ ! -z "$n_try" -a $n_try != 0 ]
@@ -372,7 +370,7 @@ do
 
     # the filename for the test and the name output are different.
     # we don't include the tests/ directory in the name output.
-    seqnum=`echo $seq | sed -e 's;tests/;;'`
+    seqnum=`echo $seq | sed -e "s;$SRC_DIR/;;"`
 
     echo -n "$seqnum"
 
diff --git a/group b/group
index 5c9bb7f..c0ea381 100644
--- a/group
+++ b/group
@@ -113,26 +113,3 @@ dangerous
 # on current systems
 deprecated
 
-#
-# test-group association ... one line per test
-#
-040 other auto
-051 acl udf auto quick
-068 other auto freeze dangerous
-098 udf auto
-101 udf
-102 udf
-# the next three tests are not deterministic enough to get the
-# "right" result on all platforms/configuration, so don't run
-# them by default.
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
diff --git a/254 b/tests/btrfs/254
similarity index 100%
rename from 254
rename to tests/btrfs/254
diff --git a/254.out b/tests/btrfs/254.out
similarity index 100%
rename from 254.out
rename to tests/btrfs/254.out
diff --git a/264 b/tests/btrfs/264
similarity index 100%
rename from 264
rename to tests/btrfs/264
diff --git a/264.out b/tests/btrfs/264.out
similarity index 100%
rename from 264.out
rename to tests/btrfs/264.out
diff --git a/265 b/tests/btrfs/265
similarity index 100%
rename from 265
rename to tests/btrfs/265
diff --git a/265.out b/tests/btrfs/265.out
similarity index 100%
rename from 265.out
rename to tests/btrfs/265.out
diff --git a/276 b/tests/btrfs/276
similarity index 100%
rename from 276
rename to tests/btrfs/276
diff --git a/276.out b/tests/btrfs/276.out
similarity index 100%
rename from 276.out
rename to tests/btrfs/276.out
diff --git a/284 b/tests/btrfs/284
similarity index 100%
rename from 284
rename to tests/btrfs/284
diff --git a/284.out b/tests/btrfs/284.out
similarity index 100%
rename from 284.out
rename to tests/btrfs/284.out
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
diff --git a/271 b/tests/ext4/271
similarity index 100%
rename from 271
rename to tests/ext4/271
diff --git a/271.out b/tests/ext4/271.out
similarity index 100%
rename from 271.out
rename to tests/ext4/271.out
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
diff --git a/051 b/tests/shared/051
similarity index 100%
rename from 051
rename to tests/shared/051
diff --git a/051.out b/tests/shared/051.out
similarity index 100%
rename from 051.out
rename to tests/shared/051.out
diff --git a/068 b/tests/shared/068
similarity index 100%
rename from 068
rename to tests/shared/068
diff --git a/068.out b/tests/shared/068.out
similarity index 100%
rename from 068.out
rename to tests/shared/068.out
diff --git a/218 b/tests/shared/218
similarity index 100%
rename from 218
rename to tests/shared/218
diff --git a/218.out b/tests/shared/218.out
similarity index 100%
rename from 218.out
rename to tests/shared/218.out
diff --git a/243 b/tests/shared/243
similarity index 100%
rename from 243
rename to tests/shared/243
diff --git a/243.out b/tests/shared/243.out
similarity index 100%
rename from 243.out
rename to tests/shared/243.out
diff --git a/272 b/tests/shared/272
similarity index 100%
rename from 272
rename to tests/shared/272
diff --git a/272.out b/tests/shared/272.out
similarity index 100%
rename from 272.out
rename to tests/shared/272.out
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
diff --git a/098 b/tests/udf/098
similarity index 100%
rename from 098
rename to tests/udf/098
diff --git a/098.out b/tests/udf/098.out
similarity index 100%
rename from 098.out
rename to tests/udf/098.out
diff --git a/101 b/tests/udf/101
similarity index 100%
rename from 101
rename to tests/udf/101
diff --git a/101.out b/tests/udf/101.out
similarity index 100%
rename from 101.out
rename to tests/udf/101.out
diff --git a/102 b/tests/udf/102
similarity index 100%
rename from 102
rename to tests/udf/102
diff --git a/102.out b/tests/udf/102.out
similarity index 100%
rename from 102.out
rename to tests/udf/102.out
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
diff --git a/040 b/tests/xfs/040
similarity index 100%
rename from 040
rename to tests/xfs/040
diff --git a/040.good b/tests/xfs/040.good
similarity index 100%
rename from 040.good
rename to tests/xfs/040.good
diff --git a/040.out b/tests/xfs/040.out
similarity index 100%
rename from 040.out
rename to tests/xfs/040.out
diff --git a/177 b/tests/xfs/177
similarity index 100%
rename from 177
rename to tests/xfs/177
diff --git a/177.out b/tests/xfs/177.out
similarity index 100%
rename from 177.out
rename to tests/xfs/177.out
diff --git a/252 b/tests/xfs/252
similarity index 100%
rename from 252
rename to tests/xfs/252
diff --git a/252.out b/tests/xfs/252.out
similarity index 100%
rename from 252.out
rename to tests/xfs/252.out
diff --git a/tests/xfs/group b/tests/xfs/group
index 6686e38..ff13804 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -31,6 +31,7 @@
 037 dump ioctl remote tape
 038 dump ioctl remote tape
 039 dump ioctl remote tape
+040 other auto
 041 growfs ioctl auto
 042 fsr ioctl auto
 043 dump ioctl tape
@@ -129,6 +130,7 @@
 174 rw filestreams auto
 175 dmapi auto
 176 dmapi auto
+177 rw other auto
 178 mkfs other auto
 179 metadata rw auto
 180 metadata rw auto
@@ -163,6 +165,7 @@
 242 auto quick prealloc
 244 auto quota quick
 250 auto quick rw prealloc metadata
+252 auto quick prealloc
 253 auto quick
 259 auto quick
 261 auto quick quota
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
