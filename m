Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E747229E03
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 04:01:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 65ACBAC007
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 02:01:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gerS7ISE8PPOmjzK for
	<xfs@oss.sgi.com>; Sun, 12 May 2013 02:01:50 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r4C91oiM008296
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 05:01:50 -0400
From: Tomas Racek <tracek@redhat.com>
Subject: [PATCH 2/2] xfstests: unify apostrophes in output files
Date: Sun, 12 May 2013 11:01:13 +0200
Message-Id: <1368349273-23968-2-git-send-email-tracek@redhat.com>
In-Reply-To: <1368349273-23968-1-git-send-email-tracek@redhat.com>
References: <1368349273-23968-1-git-send-email-tracek@redhat.com>
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
To: xfs@oss.sgi.com
Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>

With coreutils v8.16 the style of apostrophes changed from `word' to
'word'. This is breaking some tests which use the older form.

This commit introduces function _filter_apostrophes and changes the
affected tests.

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 common/filter         |  5 +++++
 tests/generic/193     | 16 ++++++++--------
 tests/generic/193.out | 16 ++++++++--------
 tests/generic/230     |  4 ++--
 tests/generic/230.out |  8 ++++----
 tests/generic/235     |  2 +-
 tests/generic/235.out |  2 +-
 tests/generic/245     |  2 +-
 tests/generic/245.out |  2 +-
 tests/generic/294     |  8 ++++----
 tests/generic/294.out |  8 ++++----
 tests/generic/306     |  2 +-
 tests/generic/306.out |  2 +-
 tests/xfs/103         |  2 +-
 tests/xfs/103.out     |  2 +-
 tests/xfs/200         |  2 +-
 tests/xfs/200.out     |  2 +-
 17 files changed, 45 insertions(+), 40 deletions(-)

diff --git a/common/filter b/common/filter
index bdd6427..4340dbe 100644
--- a/common/filter
+++ b/common/filter
@@ -280,5 +280,10 @@ _filter_size_to_bytes()
 	echo $((${size:0:${#size}-1}*$mul))
 }
 
+_filter_apostrophes()
+{
+	sed 's/`/'\''/g'
+}
+
 # make sure this script returns success
 /bin/true
diff --git a/tests/generic/193 b/tests/generic/193
index cdf04c2..d5d74c7 100755
--- a/tests/generic/193
+++ b/tests/generic/193
@@ -83,17 +83,17 @@ echo
 _create_files
 
 echo "user: chown root owned file to qa_user (should fail)"
-su ${qa_user} -c "chown ${qa_user} test.root"
+su ${qa_user} -c "chown ${qa_user} test.root" 2>&1 | _filter_apostrophes
 
 echo "user: chown root owned file to root (should fail)"
-su ${qa_user} -c "chown root test.root"
+su ${qa_user} -c "chown root test.root" 2>&1 | _filter_apostrophes
 
 echo "user: chown qa_user owned file to qa_user (should succeed)"
 su ${qa_user} -c "chown ${qa_user} test.${qa_user}"
 
 # this would work without _POSIX_CHOWN_RESTRICTED
 echo "user: chown qa_user owned file to root (should fail)"
-su ${qa_user} -c "chown root test.${qa_user}"
+su ${qa_user} -c "chown root test.${qa_user}" 2>&1 | _filter_apostrophes
 
 _cleanup_files
 
@@ -107,13 +107,13 @@ echo
 _create_files
 
 echo "user: chgrp root owned file to root (should fail)"
-su ${qa_user} -c "chgrp root test.root"
+su ${qa_user} -c "chgrp root test.root" 2>&1 | _filter_apostrophes
 
 echo "user: chgrp qa_user owned file to root (should fail)"
-su ${qa_user} -c "chgrp root test.${qa_user}"
+su ${qa_user} -c "chgrp root test.${qa_user}" 2>&1 | _filter_apostrophes
 
 echo "user: chgrp root owned file to qa_user (should fail)"
-su ${qa_user} -c "chgrp ${qa_user} test.root"
+su ${qa_user} -c "chgrp ${qa_user} test.root" 2>&1 | _filter_apostrophes
 
 echo "user: chgrp qa_user owned file to qa_user (should succeed)"
 su ${qa_user} -c "chgrp ${qa_user} test.${qa_user}"
@@ -136,7 +136,7 @@ echo "user: chmod a+r on qa_user owned file (should succeed)"
 su ${qa_user} -c "chmod a+r test.${qa_user}"
 
 echo "user: chmod a+r on root owned file (should fail)"
-su ${qa_user} -c "chmod a+r test.root"
+su ${qa_user} -c "chmod a+r test.root" 2>&1 | _filter_apostrophes
 
 #
 # Setup a file owned by the qa_user, but with a group ID that
@@ -238,7 +238,7 @@ echo "user: touch qa_user file (should succeed)"
 su ${qa_user} -c "touch test.${qa_user}"
 
 echo "user: touch root file (should fail)"
-su ${qa_user} -c "touch test.root"
+su ${qa_user} -c "touch test.root" 2>&1 | _filter_apostrophes
 
 _cleanup_files
 
diff --git a/tests/generic/193.out b/tests/generic/193.out
index b89add3..e410948 100644
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
-chown: changing ownership of `test.fsgqa': Operation not permitted
+chown: changing ownership of 'test.fsgqa': Operation not permitted
 
 testing ATTR_GID
 
 user: chgrp root owned file to root (should fail)
-chgrp: changing group of `test.root': Operation not permitted
+chgrp: changing group of 'test.root': Operation not permitted
 user: chgrp qa_user owned file to root (should fail)
-chgrp: changing group of `test.fsgqa': Operation not permitted
+chgrp: changing group of 'test.fsgqa': Operation not permitted
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
@@ -47,5 +47,5 @@ testing ATTR_*TIMES_SET
 
 user: touch qa_user file (should succeed)
 user: touch root file (should fail)
-touch: cannot touch `test.root': Permission denied
+touch: cannot touch 'test.root': Permission denied
 *** done
diff --git a/tests/generic/230 b/tests/generic/230
index 797755b..7b1ea74 100755
--- a/tests/generic/230
+++ b/tests/generic/230
@@ -92,14 +92,14 @@ test_enforcement()
 	# Try to exceed inode hardlimit
 	echo "Touch 5+6"
 	su $qa_user -c "touch $SCRATCH_MNT/file5 $SCRATCH_MNT/file6" \
-		2>&1 >>$seqres.full | _filter_scratch | tee -a $seqres.full
+		2>&1 >>$seqres.full | _filter_scratch | _filter_apostrophes | tee -a $seqres.full
 	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
 	# Wait and check grace time enforcement
 	rm -f $SCRATCH_MNT/file5 >>$seqres.full 2>&1
 	sleep $((grace+1))
 	echo "Touch 5"
 	su $qa_user -c "touch $SCRATCH_MNT/file5" 2>&1 >>$seqres.full |
-		_filter_scratch | tee -a $seqres.full
+		_filter_scratch | _filter_apostrophes | tee -a $seqres.full
 	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
 	echo "--- completed IO ($type)" >>$seqres.full
 }
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
diff --git a/tests/generic/235 b/tests/generic/235
index f430ba2..19ecbdf 100755
--- a/tests/generic/235
+++ b/tests/generic/235
@@ -66,7 +66,7 @@ repquota -u -g $SCRATCH_MNT  | grep -v "^root" | _filter_scratch
 # We work around it by editing the context out of mtab.  Sigh.
 sed -i "s#^$SCRATCH_DEV\(.*\),context=\"system_u:object_r:nfs_t:s0\"#$SCRATCH_DEV\1#" /etc/mtab
 mount -o remount,ro $SCRATCH_DEV 2>&1 | tee -a $seqres.full | _filter_scratch
-touch $SCRATCH_MNT/failed 2>&1 | tee -a $seqres.full | _filter_scratch
+touch $SCRATCH_MNT/failed 2>&1 | tee -a $seqres.full | _filter_scratch | _filter_apostrophes
 mount -o remount,rw $SCRATCH_DEV 2>&1 | tee -a $seqres.full | _filter_scratch
 
 $XFS_IO_PROG -F -c 'pwrite 0 8k' -c 'fsync' \
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
diff --git a/tests/generic/245 b/tests/generic/245
index 9b87fbb..93cf7d9 100755
--- a/tests/generic/245
+++ b/tests/generic/245
@@ -65,7 +65,7 @@ touch $dir/aa/1
 mkdir $dir/ab/aa
 touch $dir/ab/aa/2
 
-mv $dir/ab/aa/ $dir 2>&1 | _filter_test_dir | _filter_directory_not_empty
+mv $dir/ab/aa/ $dir 2>&1 | _filter_test_dir | _filter_directory_not_empty | _filter_apostrophes
 
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
index fa7f339..e954be5 100644
--- a/tests/generic/294
+++ b/tests/generic/294
@@ -52,10 +52,10 @@ THIS_TEST_DIR=$SCRATCH_MNT/$seq.test
 
 _create_files()
 {
-	mknod $THIS_TEST_DIR/testnode c 1 3
-	mkdir $THIS_TEST_DIR/testdir
-	touch $THIS_TEST_DIR/testtarget
-	ln -s $THIS_TEST_DIR/testtarget $THIS_TEST_DIR/testlink 2>&1 | _filter_ln
+	mknod $THIS_TEST_DIR/testnode c 1 3 2>&1 | _filter_apostrophes
+	mkdir $THIS_TEST_DIR/testdir 2>&1 | _filter_apostrophes
+	touch $THIS_TEST_DIR/testtarget 2>&1 | _filter_apostrophes
+	ln -s $THIS_TEST_DIR/testtarget $THIS_TEST_DIR/testlink 2>&1 | _filter_ln | _filter_apostrophes
 }
 
 _scratch_mount
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
index e8e0fc0..b44d580 100644
--- a/tests/generic/306
+++ b/tests/generic/306
@@ -71,7 +71,7 @@ _scratch_mount -o ro || _fail "Could not mount scratch readonly"
 
 # We should be able to read & write to/from these devices even on an RO fs
 echo "== try to create new file"
-touch $SCRATCH_MNT/this_should_fail 2>&1 | _filter_scratch
+touch $SCRATCH_MNT/this_should_fail 2>&1 | _filter_scratch | _filter_apostrophes
 echo "== pwrite to null device"
 $XFS_IO_PROG -F -c "pwrite 0 512" /dev/null | _filter_xfs_io
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
diff --git a/tests/xfs/103 b/tests/xfs/103
index 113f643..8318c43 100755
--- a/tests/xfs/103
+++ b/tests/xfs/103
@@ -79,7 +79,7 @@ _filter_noymlinks_flag
 
 touch $SCRATCH_MNT/nosymlink/source
 ln -s $SCRATCH_MNT/nosymlink/source $SCRATCH_MNT/nosymlink/target 2>&1 \
-	| _filter_scratch | _filter_ln
+	| _filter_scratch | _filter_ln | _filter_apostrophes
 ln $SCRATCH_MNT/nosymlink/source $SCRATCH_MNT/nosymlink/hardlinksareok
 
 echo "*** 1st listing..."
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
diff --git a/tests/xfs/200 b/tests/xfs/200
index a3b7274..a34cf8e 100755
--- a/tests/xfs/200
+++ b/tests/xfs/200
@@ -61,7 +61,7 @@ echo "mounting read-only block device:"
 _scratch_mount 2>&1 | _filter_scratch
 
 echo "touching file on read-only filesystem (should fail)"
-touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
+touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch | _filter_apostrophes
 
 #
 # Apparently this used to be broken at some point:
diff --git a/tests/xfs/200.out b/tests/xfs/200.out
index 27a76c0..40f9163 100644
--- a/tests/xfs/200.out
+++ b/tests/xfs/200.out
@@ -3,7 +3,7 @@ setting device read-only
 mounting read-only block device:
 mount: SCRATCH_DEV is write-protected, mounting read-only
 touching file on read-only filesystem (should fail)
-touch: cannot touch `SCRATCH_MNT/foo': Read-only file system
+touch: cannot touch 'SCRATCH_MNT/foo': Read-only file system
 unmounting read-only filesystem
 setting device read-write
 mounting read-write block device:
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
