Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 213F929DFC
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 15:29:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0E3708F8035
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 13:29:31 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id EwvoMbv8RYgmXVk8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Sep 2013 13:29:30 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 8661A7C0685
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 14:29:29 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: introduce _filter_backtick
Date: Wed, 18 Sep 2013 16:29:26 -0400
Message-ID: <1379536166-19232-1-git-send-email-jbacik@fusionio.com>
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
To: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org

Apparently the GNU guys decided to change their error output from something like

Error `Error message'

To

Error 'Error message'

So to fix this I've introduced _filter_backtick which will change any ` to ' and
then changed the output of the tests that were failing for me because of this
output.  I tested this on a new box that has the new output and an old box which
has the old output and it appears to fix the issue.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 common/filter         |  7 +++++++
 tests/generic/193     | 18 ++++++++++--------
 tests/generic/193.out | 16 ++++++++--------
 tests/generic/245     |  3 ++-
 tests/generic/245.out |  2 +-
 tests/generic/294     |  2 +-
 tests/generic/294.out |  8 ++++----
 tests/generic/306     |  2 +-
 tests/generic/306.out |  2 +-
 9 files changed, 35 insertions(+), 25 deletions(-)

diff --git a/common/filter b/common/filter
index ee738ca..ec49e18 100644
--- a/common/filter
+++ b/common/filter
@@ -280,5 +280,12 @@ _filter_size_to_bytes()
 	echo $((${size:0:${#size}-1}*$mul))
 }
 
+# Old gnu utils used to spit out something like "Error `blah'" but the new ones
+# do "Error 'blah'" so fix the ` to be a ' so we are consistent
+_filter_backtick()
+{
+	sed -e "s/\`/\'/g"
+}
+
 # make sure this script returns success
 /bin/true
diff --git a/tests/generic/193 b/tests/generic/193
index 4fa20ff..2186997 100755
--- a/tests/generic/193
+++ b/tests/generic/193
@@ -91,17 +91,18 @@ echo
 _create_files
 
 echo "user: chown root owned file to qa_user (should fail)"
-su ${qa_user} -c "chown ${qa_user} $test_root" 2>&1 | _filter_files
+su ${qa_user} -c "chown ${qa_user} $test_root" 2>&1 | _filter_files | \
+	_filter_backtick
 
 echo "user: chown root owned file to root (should fail)"
-su ${qa_user} -c "chown root $test_root" 2>&1 | _filter_files
+su ${qa_user} -c "chown root $test_root" 2>&1 | _filter_files | _filter_backtick
 
 echo "user: chown qa_user owned file to qa_user (should succeed)"
 su ${qa_user} -c "chown ${qa_user} $test_user"
 
 # this would work without _POSIX_CHOWN_RESTRICTED
 echo "user: chown qa_user owned file to root (should fail)"
-su ${qa_user} -c "chown root $test_user" 2>&1 | _filter_files
+su ${qa_user} -c "chown root $test_user" 2>&1 | _filter_files | _filter_backtick
 
 _cleanup_files
 
@@ -115,13 +116,14 @@ echo
 _create_files
 
 echo "user: chgrp root owned file to root (should fail)"
-su ${qa_user} -c "chgrp root $test_root" 2>&1 | _filter_files
+su ${qa_user} -c "chgrp root $test_root" 2>&1 | _filter_files | _filter_backtick
 
 echo "user: chgrp qa_user owned file to root (should fail)"
-su ${qa_user} -c "chgrp root $test_user" 2>&1 | _filter_files
+su ${qa_user} -c "chgrp root $test_user" 2>&1 | _filter_files | _filter_backtick
 
 echo "user: chgrp root owned file to qa_user (should fail)"
-su ${qa_user} -c "chgrp ${qa_user} $test_root" 2>&1 | _filter_files
+su ${qa_user} -c "chgrp ${qa_user} $test_root" 2>&1 | _filter_files | \
+	_filter_backtick
 
 echo "user: chgrp qa_user owned file to qa_user (should succeed)"
 su ${qa_user} -c "chgrp ${qa_user} $test_user"
@@ -144,7 +146,7 @@ echo "user: chmod a+r on qa_user owned file (should succeed)"
 su ${qa_user} -c "chmod a+r $test_user"
 
 echo "user: chmod a+r on root owned file (should fail)"
-su ${qa_user} -c "chmod a+r $test_root" 2>&1 | _filter_files
+su ${qa_user} -c "chmod a+r $test_root" 2>&1 | _filter_files | _filter_backtick
 
 #
 # Setup a file owned by the qa_user, but with a group ID that
@@ -283,7 +285,7 @@ echo "user: touch qa_user file (should succeed)"
 su ${qa_user} -c "touch $test_user"
 
 echo "user: touch root file (should fail)"
-su ${qa_user} -c "touch $test_root" 2>&1 | _filter_files
+su ${qa_user} -c "touch $test_root" 2>&1 | _filter_files | _filter_backtick
 
 _cleanup_files
 
diff --git a/tests/generic/193.out b/tests/generic/193.out
index 357a7c1..7a7f89a 100644
--- a/tests/generic/193.out
+++ b/tests/generic/193.out
@@ -3,28 +3,28 @@ QA output created by 193
 testing ATTR_UID
 
 user: chown root owned file to qa_user (should fail)
-chown: changing ownership of `test.root': Operation not permitted
+chown: changing ownership of 'test.root': Operation not permitted
 user: chown root owned file to root (should fail)
-chown: changing ownership of `test.root': Operation not permitted
+chown: changing ownership of 'test.root': Operation not permitted
 user: chown qa_user owned file to qa_user (should succeed)
 user: chown qa_user owned file to root (should fail)
-chown: changing ownership of `test.user': Operation not permitted
+chown: changing ownership of 'test.user': Operation not permitted
 
 testing ATTR_GID
 
 user: chgrp root owned file to root (should fail)
-chgrp: changing group of `test.root': Operation not permitted
+chgrp: changing group of 'test.root': Operation not permitted
 user: chgrp qa_user owned file to root (should fail)
-chgrp: changing group of `test.user': Operation not permitted
+chgrp: changing group of 'test.user': Operation not permitted
 user: chgrp root owned file to qa_user (should fail)
-chgrp: changing group of `test.root': Operation not permitted
+chgrp: changing group of 'test.root': Operation not permitted
 user: chgrp qa_user owned file to qa_user (should succeed)
 
 testing ATTR_MODE
 
 user: chmod a+r on qa_user owned file (should succeed)
 user: chmod a+r on root owned file (should fail)
-chmod: changing permissions of `test.root': Operation not permitted
+chmod: changing permissions of 'test.root': Operation not permitted
 check that the sgid bit is cleared
 -rw-rw-rw-
 check that suid bit is not cleared
@@ -60,5 +60,5 @@ testing ATTR_*TIMES_SET
 
 user: touch qa_user file (should succeed)
 user: touch root file (should fail)
-touch: cannot touch `test.root': Permission denied
+touch: cannot touch 'test.root': Permission denied
 *** done
diff --git a/tests/generic/245 b/tests/generic/245
index 9b87fbb..a2811ce 100755
--- a/tests/generic/245
+++ b/tests/generic/245
@@ -65,7 +65,8 @@ touch $dir/aa/1
 mkdir $dir/ab/aa
 touch $dir/ab/aa/2
 
-mv $dir/ab/aa/ $dir 2>&1 | _filter_test_dir | _filter_directory_not_empty
+mv $dir/ab/aa/ $dir 2>&1 | _filter_test_dir | _filter_directory_not_empty | \
+	_filter_backtick
 
 status=0
 exit $status
diff --git a/tests/generic/245.out b/tests/generic/245.out
index 8322aac..f5b5f18 100644
--- a/tests/generic/245.out
+++ b/tests/generic/245.out
@@ -1,2 +1,2 @@
 QA output created by 245
-mv: cannot move `TEST_DIR/test-mv/ab/aa/' to `TEST_DIR/test-mv/aa': File exists
+mv: cannot move 'TEST_DIR/test-mv/ab/aa/' to 'TEST_DIR/test-mv/aa': File exists
diff --git a/tests/generic/294 b/tests/generic/294
index fa7f339..ef02e18 100755
--- a/tests/generic/294
+++ b/tests/generic/294
@@ -65,7 +65,7 @@ mkdir $THIS_TEST_DIR || _fail "Could not create dir for test"
 
 _create_files 2>&1 | _filter_scratch
 _scratch_mount -o remount,ro || _fail "Could not remount scratch readonly"
-_create_files 2>&1 | _filter_scratch
+_create_files 2>&1 | _filter_scratch | _filter_backtick
 
 # success, all done
 status=0
diff --git a/tests/generic/294.out b/tests/generic/294.out
index 027d9fc..1ac1c67 100644
--- a/tests/generic/294.out
+++ b/tests/generic/294.out
@@ -1,5 +1,5 @@
 QA output created by 294
-mknod: `SCRATCH_MNT/294.test/testnode': File exists
-mkdir: cannot create directory `SCRATCH_MNT/294.test/testdir': File exists
-touch: cannot touch `SCRATCH_MNT/294.test/testtarget': Read-only file system
-ln: creating symbolic link `SCRATCH_MNT/294.test/testlink': File exists
+mknod: 'SCRATCH_MNT/294.test/testnode': File exists
+mkdir: cannot create directory 'SCRATCH_MNT/294.test/testdir': File exists
+touch: cannot touch 'SCRATCH_MNT/294.test/testtarget': Read-only file system
+ln: creating symbolic link 'SCRATCH_MNT/294.test/testlink': File exists
diff --git a/tests/generic/306 b/tests/generic/306
index 04d28df..47235ec 100755
--- a/tests/generic/306
+++ b/tests/generic/306
@@ -71,7 +71,7 @@ _scratch_mount -o ro || _fail "Could not mount scratch readonly"
 
 # We should be able to read & write to/from these devices even on an RO fs
 echo "== try to create new file"
-touch $SCRATCH_MNT/this_should_fail 2>&1 | _filter_scratch
+touch $SCRATCH_MNT/this_should_fail 2>&1 | _filter_scratch | _filter_backtick
 echo "== pwrite to null device"
 $XFS_IO_PROG -c "pwrite 0 512" $DEVNULL | _filter_xfs_io
 echo "== pread from zero device"
diff --git a/tests/generic/306.out b/tests/generic/306.out
index 69bfb42..fb3748b 100644
--- a/tests/generic/306.out
+++ b/tests/generic/306.out
@@ -1,6 +1,6 @@
 QA output created by 306
 == try to create new file
-touch: cannot touch `SCRATCH_MNT/this_should_fail': Read-only file system
+touch: cannot touch 'SCRATCH_MNT/this_should_fail': Read-only file system
 == pwrite to null device
 wrote 512/512 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
