Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0C9337CBF
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 11:20:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DBD6730404E
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 09:20:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id U6ZopkytRSQZQqrG for
	<xfs@oss.sgi.com>; Thu, 19 Sep 2013 09:20:44 -0700 (PDT)
Message-ID: <523B2455.4000609@redhat.com>
Date: Thu, 19 Sep 2013 11:20:37 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: unify apostrophes in output files
References: <1379536166-19232-1-git-send-email-jbacik@fusionio.com>
	<20130918211325.GB4330@dastard>
In-Reply-To: <20130918211325.GB4330@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>, xfs@oss.sgi.com

xfstests: unify apostrophes in output files

From: Tomas Racek <tracek@redhat.com>

With coreutils v8.16 the style of apostrophes changed from `word' to
'word'. This is breaking some tests which use the older form.

This commit introduces function changes the golden output of the
affected tests and introduces a filter for the older style output.

[dchinner: modified to use a global filter in check rather than
per-test filters]

Signed-off-by: Tomas Racek <tracek@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---

(Resending as proper top-level, modified, reviewed patch --Eric)

 check                 |  4 ++++
 common/config         |  1 +
 tests/generic/193.out | 16 ++++++++--------
 tests/generic/230.out |  8 ++++----
 tests/generic/235.out |  2 +-
 tests/generic/245.out |  2 +-
 tests/generic/294.out |  8 ++++----
 tests/generic/306.out |  2 +-
 tests/xfs/103.out     |  2 +-
 tests/xfs/200.out     |  2 +-
 10 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/check b/check
index 4085eae..ba7fd21 100755
--- a/check
+++ b/check
@@ -478,6 +478,10 @@ do
 		echo " - no qualified output"
 		err=true
 	    else
+
+		# coreutils 2.16+ changed quote formats in error messages from
+		# `foo' to 'foo'. Filter old versions to match the new version.
+		sed -i "s/\`/\'/g" $tmp.out
 		if diff $seq.out $tmp.out >/dev/null 2>&1
 		then
 		    if $err
diff --git a/common/config b/common/config
index 67c1498..b422f87 100644
--- a/common/config
+++ b/common/config
@@ -49,6 +49,7 @@
 # all tests should use a common language setting to prevent golden
 # output mismatches.
 export LANG=C
+export LC_ALL=C
 
 # Warning: don't put freeware before /usr/bsd on IRIX coz you'll
 #  get the wrong hostname and set your system name to -s  
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
diff --git a/tests/generic/230.out b/tests/generic/230.out
index d2d434c..c3dace9 100644
--- a/tests/generic/230.out
+++ b/tests/generic/230.out
@@ -12,9 +12,9 @@ Write 4096...
 pwrite64: Disk quota exceeded
 Touch 3+4
 Touch 5+6
-touch: cannot touch `SCRATCH_MNT/file6': Disk quota exceeded
+touch: cannot touch 'SCRATCH_MNT/file6': Disk quota exceeded
 Touch 5
-touch: cannot touch `SCRATCH_MNT/file5': Disk quota exceeded
+touch: cannot touch 'SCRATCH_MNT/file5': Disk quota exceeded
 
 ### test group limit enforcement
 
@@ -28,6 +28,6 @@ Write 4096...
 pwrite64: Disk quota exceeded
 Touch 3+4
 Touch 5+6
-touch: cannot touch `SCRATCH_MNT/file6': Disk quota exceeded
+touch: cannot touch 'SCRATCH_MNT/file6': Disk quota exceeded
 Touch 5
-touch: cannot touch `SCRATCH_MNT/file5': Disk quota exceeded
+touch: cannot touch 'SCRATCH_MNT/file5': Disk quota exceeded
diff --git a/tests/generic/235.out b/tests/generic/235.out
index a095694..95c1005 100644
--- a/tests/generic/235.out
+++ b/tests/generic/235.out
@@ -15,7 +15,7 @@ Group           used    soft    hard  grace    used  soft  hard  grace
 fsgqa     --       0       0       0              1     0     0       
 
 
-touch: cannot touch `SCRATCH_MNT/failed': Read-only file system
+touch: cannot touch 'SCRATCH_MNT/failed': Read-only file system
 *** Report for user quotas on device SCRATCH_DEV
 Block grace time: 7days; Inode grace time: 7days
                         Block limits                File limits
diff --git a/tests/generic/245.out b/tests/generic/245.out
index 8322aac..f5b5f18 100644
--- a/tests/generic/245.out
+++ b/tests/generic/245.out
@@ -1,2 +1,2 @@
 QA output created by 245
-mv: cannot move `TEST_DIR/test-mv/ab/aa/' to `TEST_DIR/test-mv/aa': File exists
+mv: cannot move 'TEST_DIR/test-mv/ab/aa/' to 'TEST_DIR/test-mv/aa': File exists
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
diff --git a/tests/xfs/103.out b/tests/xfs/103.out
index f939bcd..4ab3ad7 100644
--- a/tests/xfs/103.out
+++ b/tests/xfs/103.out
@@ -4,7 +4,7 @@ QA output created by 103
 *** testing nosymlinks directories
 *** setting nosymlinks bit
 --n-- SCRATCH_MNT/nosymlink
-ln: creating symbolic link `SCRATCH_MNT/nosymlink/target': Operation not permitted
+ln: creating symbolic link 'SCRATCH_MNT/nosymlink/target': Operation not permitted
 *** 1st listing...
 SCRATCH_MNT
 SCRATCH_MNT/nosymlink
diff --git a/tests/xfs/200.out b/tests/xfs/200.out
index 2629541..174838c 100644
--- a/tests/xfs/200.out
+++ b/tests/xfs/200.out
@@ -3,7 +3,7 @@ setting device read-only
 mounting read-only block device:
 mount: block device SCRATCH_DEV is write-protected, mounting read-only
 touching file on read-only filesystem (should fail)
-touch: cannot touch `SCRATCH_MNT/foo': Read-only file system
+touch: cannot touch 'SCRATCH_MNT/foo': Read-only file system
 unmounting read-only filesystem
 setting device read-write
 mounting read-write block device:
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
