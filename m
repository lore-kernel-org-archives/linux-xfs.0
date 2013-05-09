Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7318129E13
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 20:21:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2AFE78F8049
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 18:21:58 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	REllThEyI6Byz9XV for <xfs@oss.sgi.com>;
	Wed, 08 May 2013 18:21:56 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UaFYF-00039Q-Sz
	for xfs@oss.sgi.com; Thu, 09 May 2013 11:21:43 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UaFYF-0003vc-QP
	for xfs@oss.sgi.com; Thu, 09 May 2013 11:21:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfstests: generic/235 breaks /etc/mtab symlinks breaks
	xfs/189
Date: Thu,  9 May 2013 11:21:41 +1000
Message-Id: <1368062501-15046-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1368062501-15046-1-git-send-email-david@fromorbit.com>
References: <1368062501-15046-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Serenity lost.
Insanity looms darkly.
/etc/mtab

Random behaviour.
xfs/189 fails
After a week passing.

-SCRATCH_DEV on SCRATCH_MNT type xfs (ro,filestreams)
+SCRATCH_DEV on SCRATCH_MNT type xfs (ro,relatime,attr2,filestreams,inode64,noquota)

Confusion prevails.
/proc/mounts can never give success.
Anything but golden.

ls -l
/etc/mtab shows:
lrwxrwxrwx 1 root root 12 May  8 16:05 /etc/mtab -> /proc/mounts

symlink modified.
Stealth. Deception. WTF?
Ninjas go unseen.

"git grep mtab". Yay!
generic/235: sad
SElinux hack.

Remount context grot.
Mount uses all options from
/etc/mtab

Kernel rejects mount.
sed hacks /etc/mtab
Symlink becomes file.

Test frobulation.
xfs/189 passes
Randomness tamed.

Double face-palm. Tears.
Crack-inspired insanity.
mount(8) needs fixing.

Schizophrenia.
/etc/mtab. Same thing.
Test psychiatry.

Hack, slash, glue, polish.
xfs/189 fixed.
Made shiny again.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/generic/235 |    8 ++---
 tests/xfs/189     |   86 +++++++++++++++++++++++++++++++++++++----------------
 tests/xfs/189.out |   32 ++++++++++----------
 3 files changed, 81 insertions(+), 45 deletions(-)

diff --git a/tests/generic/235 b/tests/generic/235
index f430ba2..0fabc24 100755
--- a/tests/generic/235
+++ b/tests/generic/235
@@ -60,11 +60,11 @@ chown $qa_user:$qa_user $SCRATCH_MNT/testfile
 
 repquota -u -g $SCRATCH_MNT  | grep -v "^root" | _filter_scratch
 
-# XXX This is a nasty hack.  remount doesn't work on a fileystem
-# with a context; see https://bugzilla.redhat.com/show_bug.cgi?id=563267
+# If remount fails with this problem:
 #
-# We work around it by editing the context out of mtab.  Sigh.
-sed -i "s#^$SCRATCH_DEV\(.*\),context=\"system_u:object_r:nfs_t:s0\"#$SCRATCH_DEV\1#" /etc/mtab
+# https://bugzilla.redhat.com/show_bug.cgi?id=563267
+#
+# then you need a more recent mount binary.
 mount -o remount,ro $SCRATCH_DEV 2>&1 | tee -a $seqres.full | _filter_scratch
 touch $SCRATCH_MNT/failed 2>&1 | tee -a $seqres.full | _filter_scratch
 mount -o remount,rw $SCRATCH_DEV 2>&1 | tee -a $seqres.full | _filter_scratch
diff --git a/tests/xfs/189 b/tests/xfs/189
index d79b7fa..27bfb63 100755
--- a/tests/xfs/189
+++ b/tests/xfs/189
@@ -4,6 +4,32 @@
 # Test remount behaviour
 # Initial motivation was for pv#985710 and pv#983964
 #
+# mount(8) adds all options from mtab and fstab to the mount command line.  So
+# the filesystem either must not reject any option at all if it can't change it,
+# or compare the value on the command line to the existing state and only reject
+# it if it would change something that can't be changed.
+#
+# Test this behaviour by mounting a filesystem read-only with a non- default
+# option and then try to remount it rw.
+#
+# note that mount(8) doesn't add the options when specifying both the device
+# node and mount point, so test out the various mounting alternatives
+#
+# <---- Bbbzzzzzzztttt ---->
+#
+# Right, but the kernel /proc/mounts output in no way reflects what mount passes
+# into the kernel, so the entire assumption of this test that what mount outputs
+# is the same as what it inputs is completely wrong.
+#
+# Hence the test now checks to see if the expected options are in the mount
+# options in /etc/mtab rather than looking for an exact match. Hence the tests
+# check what we know should change, not what mount thinks has changed. As a
+# result, the test now passes regardless of whether mount or the kernel controls
+# the contents of /etc/mtab....
+#
+# <---- Normal programming is resumed ---->
+#
+#
 #-----------------------------------------------------------------------
 # Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
 #
@@ -33,6 +59,8 @@ status=1	# failure is the default!
 trap "_cleanup; exit \$status" 0 1 2 3 15
 tag="added by qa $seq"
 
+rm -f $seqres.full
+
 _cleanup()
 {
 	cd /
@@ -48,26 +76,32 @@ _scratch_filter()
 	    -e "s#,context.*s0\"##"
 }
 
+#
+# the output from /proc/mounts in no way matches what mount puts into the kernel
+# as options. Work around it as best possible by matching the strings passed in
+# rather than assuming they are the only options that will be set. If they match
+# output them to the output file so that the golden image and the filtering
+# doesn't need to care about what options may or may not be present in /etc/mtab
+#
 _check_mount()
 {
-	# assumes that we don't have extra ops in fstab
-	_mount | grep $SCRATCH_MNT | _scratch_filter
+	rw_or_ro=$1
+	expected_val=$2
+
+	[ -z "$expected_val" ] && expected_val=$1
+
+	_mount | grep $SCRATCH_MNT | _scratch_filter | \
+		tee -a $seqres.full |
+		grep $rw_or_ro | grep $expected_val > /dev/null
+	if [ $? -eq 0 ]; then
+		echo -n "SCRATCH_DEV on SCRATCH_MNT type xfs ($rw_or_ro"
+		if [ ! -z "$2" ]; then
+			echo -n ",$2"
+		fi
+		echo ")"
+	fi
 }
 
-#
-# mount(8) adds all options from mtab and fstab to the mount command
-# line.  So the filesystem either must not reject any option at all
-# if it can't change it, or compare the value on the command line
-# to the existing state and only reject it if it would change
-# something that can't be changed.
-#
-# Test this behaviour by mounting a filesystem read-only with a non-
-# default option and then try to remount it rw.
-#
-# note that mount(8) doesn't add the options when specifying both the
-# device node and mount point, so test out the various mounting
-# alternatives
-#
 _test_remount_rw()
 {
 	# use filestreams as a hopefully never default option
@@ -76,29 +110,32 @@ _test_remount_rw()
 	echo
 	_scratch_mount -o ro,filestreams
 	[ $? -eq 0 ] || echo "ro,filestreams mount failed unexpectedly"
-	_check_mount
+	_check_mount ro filestreams
 
 	for dev_mnt in $SCRATCH_DEV $SCRATCH_MNT "$SCRATCH_DEV $SCRATCH_MNT"; do
 		echo "mounting given: $dev_mnt" | _scratch_filter
-		_mount -o remount,rw $dev_mnt
+		_mount -o remount,rw,filestreams $dev_mnt
 		[ $? -eq 0 ] || echo "remount rw failed"
-		_check_mount
+		_check_mount rw filestreams
 	done
 
 	umount $SCRATCH_MNT
 
+	# remount ignores attr2, and noattr2 mount option does does not result
+	# in any "attr2" specific option in /proc/mounts, so we can only check
+	# for ro/rw here.
 	echo
 	echo "try remount ro,noattr2 -> rw,attr2"
 	echo
 	_scratch_mount -o ro,noattr2
 	[ $? -eq 0 ] || echo "ro,noattr2 mount failed unexpectedly"
-	_check_mount
+	_check_mount ro
 
 	for dev_mnt in $SCRATCH_DEV $SCRATCH_MNT "$SCRATCH_DEV $SCRATCH_MNT"; do
 		echo "mounting given: $dev_mnt" | _scratch_filter
 		_mount -o remount,rw,attr2 $dev_mnt
 		[ $? -eq 0 ] || echo "remount rw,attr2 failed"
-		_check_mount
+		_check_mount rw
 	done
 
 	umount $SCRATCH_MNT
@@ -146,15 +183,15 @@ _test_remount_barrier()
 	# mention barrier explicitly even if it's currently the default just to be sure
 	_scratch_mount -o barrier
 	[ $? -eq 0 ] || echo "mount failed unexpectedly!"
-	_check_mount
+	_check_mount rw
 
 	_scratch_mount -o remount,nobarrier
 	[ $? -eq 0 ] || _fail "remount nobarrier failed"
-	_check_mount
+	_check_mount rw nobarrier
 
 	_scratch_mount -o remount,barrier
 	[ $? -eq 0 ] || _fail "remount barrier failed"
-	_check_mount
+	_check_mount rw
 
 	umount $SCRATCH_MNT
 }
@@ -220,5 +257,4 @@ _test_remount_barrier
 
 # success, all done
 echo "*** done"
-rm -f $seqres.full
 status=0
diff --git a/tests/xfs/189.out b/tests/xfs/189.out
index 5e236ef..7e5c34a 100644
--- a/tests/xfs/189.out
+++ b/tests/xfs/189.out
@@ -10,21 +10,21 @@ try remount ro,filestreams -> rw,filestreams
 
 SCRATCH_DEV on SCRATCH_MNT type xfs (ro,filestreams)
 mounting given: SCRATCH_DEV
-SCRATCH_DEV on SCRATCH_MNT type xfs (rw)
+SCRATCH_DEV on SCRATCH_MNT type xfs (rw,filestreams)
 mounting given: SCRATCH_MNT
-SCRATCH_DEV on SCRATCH_MNT type xfs (rw)
+SCRATCH_DEV on SCRATCH_MNT type xfs (rw,filestreams)
 mounting given: SCRATCH_DEV SCRATCH_MNT
-SCRATCH_DEV on SCRATCH_MNT type xfs (rw)
+SCRATCH_DEV on SCRATCH_MNT type xfs (rw,filestreams)
 
 try remount ro,noattr2 -> rw,attr2
 
-SCRATCH_DEV on SCRATCH_MNT type xfs (ro,noattr2)
+SCRATCH_DEV on SCRATCH_MNT type xfs (ro)
 mounting given: SCRATCH_DEV
-SCRATCH_DEV on SCRATCH_MNT type xfs (rw,attr2)
+SCRATCH_DEV on SCRATCH_MNT type xfs (rw)
 mounting given: SCRATCH_MNT
-SCRATCH_DEV on SCRATCH_MNT type xfs (rw,attr2)
+SCRATCH_DEV on SCRATCH_MNT type xfs (rw)
 mounting given: SCRATCH_DEV SCRATCH_MNT
-SCRATCH_DEV on SCRATCH_MNT type xfs (rw,attr2)
+SCRATCH_DEV on SCRATCH_MNT type xfs (rw)
 
 try touching file after remount ro -> rw with options
 
@@ -35,25 +35,25 @@ try remount ro,filestreams -> rw,filestreams
 
 SCRATCH_DEV on SCRATCH_MNT type xfs (ro,filestreams)
 mounting given: SCRATCH_DEV
-SCRATCH_DEV on SCRATCH_MNT type xfs (rw,noikeep)
+SCRATCH_DEV on SCRATCH_MNT type xfs (rw,filestreams)
 mounting given: SCRATCH_MNT
-SCRATCH_DEV on SCRATCH_MNT type xfs (rw,noikeep)
+SCRATCH_DEV on SCRATCH_MNT type xfs (rw,filestreams)
 mounting given: SCRATCH_DEV SCRATCH_MNT
-SCRATCH_DEV on SCRATCH_MNT type xfs (rw)
+SCRATCH_DEV on SCRATCH_MNT type xfs (rw,filestreams)
 
 try remount ro,noattr2 -> rw,attr2
 
-SCRATCH_DEV on SCRATCH_MNT type xfs (ro,noattr2)
+SCRATCH_DEV on SCRATCH_MNT type xfs (ro)
 mounting given: SCRATCH_DEV
-SCRATCH_DEV on SCRATCH_MNT type xfs (rw,noikeep,attr2)
+SCRATCH_DEV on SCRATCH_MNT type xfs (rw)
 mounting given: SCRATCH_MNT
-SCRATCH_DEV on SCRATCH_MNT type xfs (rw,noikeep,attr2)
+SCRATCH_DEV on SCRATCH_MNT type xfs (rw)
 mounting given: SCRATCH_DEV SCRATCH_MNT
-SCRATCH_DEV on SCRATCH_MNT type xfs (rw,attr2)
+SCRATCH_DEV on SCRATCH_MNT type xfs (rw)
 
 Do remount barrier tests
 
-SCRATCH_DEV on SCRATCH_MNT type xfs (rw,barrier)
+SCRATCH_DEV on SCRATCH_MNT type xfs (rw)
 SCRATCH_DEV on SCRATCH_MNT type xfs (rw,nobarrier)
-SCRATCH_DEV on SCRATCH_MNT type xfs (rw,barrier)
+SCRATCH_DEV on SCRATCH_MNT type xfs (rw)
 *** done
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
