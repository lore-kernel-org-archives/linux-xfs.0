Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44012 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755122AbdKNMde (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Nov 2017 07:33:34 -0500
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2 3/3] fstests: filter readonly mount error messages
Date: Tue, 14 Nov 2017 20:33:10 +0800
Message-Id: <20171114123310.25286-4-eguan@redhat.com>
In-Reply-To: <20171114123310.25286-1-eguan@redhat.com>
References: <20171114123310.25286-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: misono.tomohiro@jp.fujitsu.com, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

util-linux commit 6dede2f2f7c5 ("libmount: support MS_RDONLY on
write-protected devices") changed the error message on read-only
block device, and in the failure case printed one line message
instead of two (for details please see comments in common/filter),
and this change broke generic/050 and overlay/035.

Fix it by adding more filter rules to _filter_ro_mount and updating
associated .out files to unify the output from both old and new
util-linux versions.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 common/filter         | 35 ++++++++++++++++++++++++++++++++++-
 tests/generic/050     |  8 ++++----
 tests/generic/050.out |  8 ++++----
 tests/overlay/035     |  9 +++++++--
 4 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/common/filter b/common/filter
index b1cd558ab0e1..357c4c9357c3 100644
--- a/common/filter
+++ b/common/filter
@@ -399,9 +399,42 @@ _filter_ending_dot()
 
 # Older mount output referred to "block device" when mounting RO devices
 # It's gone in newer versions
+#
+# And util-linux v2.30 changed the output again, e.g.
+# for a successful ro mount:
+# prior to v2.30:  mount: <device> is write-protected, mounting read-only
+# v2.30 and later: mount: <mountpoint>: WARNING: device write-protected, mounted read-only.
+#
+# a failed ro mount:
+# prior to v2.30:
+# mount: <device> is write-protected, mounting read-only
+# mount: cannot mount <device> read-only
+# v2.30 and later:
+# mount: <mountpoint>: cannot mount <device> read-only.
+#
+# a failed rw remount:
+# prior to v2.30:  mount: cannot remount <device> read-write, is write-protected
+# v2.30 and later: mount: <mountpoint>: cannot remount <device> read-write, is write-protected.
+#
+# Now use _filter_ro_mount to unify all these differences across old & new
+# util-linux versions.
 _filter_ro_mount() {
 	sed -e "s/mount: block device/mount:/g" \
-	    -e "s/mount: cannot mount block device/mount: cannot mount/g"
+	    -e "s/mount: cannot mount block device/mount: cannot mount/g" | \
+	_filter_ending_dot | \
+	perl -ne '
+	if (/write-protected, mount.*read-only/) {
+		print "mount: device write-protected, mounting read-only\n";
+	} elsif (/mount: .*: cannot mount.*read-only/) {
+		print "mount: device write-protected, mounting read-only\n";
+		print "mount: cannot mount read-only\n";
+	} elsif (/mount: .*: cannot remount (.*) read-write.*/) {
+		print "mount: cannot remount $1 read-write, is write-protected\n";
+	} elsif (/(^mount: cannot mount) .* (read-only$)/) {
+		print "$1 $2\n";
+	} else {
+		print "$_";
+	}'
 }
 
 # Filter a failed mount output, util-linux changed the message several times.
diff --git a/tests/generic/050 b/tests/generic/050
index 5fa28a7648e5..efa45f04825b 100755
--- a/tests/generic/050
+++ b/tests/generic/050
@@ -60,7 +60,7 @@ blockdev --setro $SCRATCH_DEV
 # Mount it, and make sure we can't write to it, and we can unmount it again
 #
 echo "mounting read-only block device:"
-_scratch_mount 2>&1 | _filter_scratch | _filter_ro_mount
+_scratch_mount 2>&1 | _filter_ro_mount
 
 echo "touching file on read-only filesystem (should fail)"
 touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
@@ -95,10 +95,10 @@ blockdev --setro $SCRATCH_DEV
 # -o norecovery is used.
 #
 echo "mounting filesystem that needs recovery on a read-only device:"
-_scratch_mount 2>&1 | _filter_scratch | _filter_ro_mount
+_scratch_mount 2>&1 | _filter_ro_mount
 
 echo "unmounting read-only filesystem"
-_scratch_unmount 2>&1 | _filter_scratch
+_scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
 
 #
 # This is the way out if the underlying device really is read-only.
@@ -106,7 +106,7 @@ _scratch_unmount 2>&1 | _filter_scratch
 # data recovery hack.
 #
 echo "mounting filesystem with -o norecovery on a read-only device:"
-_scratch_mount -o norecovery 2>&1 | _filter_scratch | _filter_ro_mount
+_scratch_mount -o norecovery 2>&1 | _filter_ro_mount
 
 echo "unmounting read-only filesystem"
 _scratch_unmount 2>&1 | _filter_scratch
diff --git a/tests/generic/050.out b/tests/generic/050.out
index fb90f6ea5819..2187d16fa328 100644
--- a/tests/generic/050.out
+++ b/tests/generic/050.out
@@ -1,7 +1,7 @@
 QA output created by 050
 setting device read-only
 mounting read-only block device:
-mount: SCRATCH_DEV is write-protected, mounting read-only
+mount: device write-protected, mounting read-only
 touching file on read-only filesystem (should fail)
 touch: cannot touch 'SCRATCH_MNT/foo': Read-only file system
 unmounting read-only filesystem
@@ -12,12 +12,12 @@ going down:
 unmounting shutdown filesystem:
 setting device read-only
 mounting filesystem that needs recovery on a read-only device:
-mount: SCRATCH_DEV is write-protected, mounting read-only
-mount: cannot mount SCRATCH_DEV read-only
+mount: device write-protected, mounting read-only
+mount: cannot mount read-only
 unmounting read-only filesystem
 umount: SCRATCH_DEV: not mounted
 mounting filesystem with -o norecovery on a read-only device:
-mount: SCRATCH_DEV is write-protected, mounting read-only
+mount: device write-protected, mounting read-only
 unmounting read-only filesystem
 setting device read-write
 mounting filesystem that needs recovery with -o ro:
diff --git a/tests/overlay/035 b/tests/overlay/035
index 64fcd708105e..d285d44ae9df 100755
--- a/tests/overlay/035
+++ b/tests/overlay/035
@@ -45,6 +45,11 @@ _cleanup()
 . ./common/rc
 . ./common/filter
 
+filter_mount()
+{
+	_filter_scratch | _filter_ro_mount
+}
+
 # remove previous $seqres.full before test
 rm -f $seqres.full
 
@@ -69,7 +74,7 @@ mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
 $MOUNT_PROG -t overlay -o"lowerdir=$lowerdir2:$lowerdir1" \
 			$OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
 touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
-_scratch_remount rw 2>&1 | _filter_scratch
+_scratch_remount rw 2>&1 | filter_mount
 $UMOUNT_PROG $SCRATCH_MNT
 
 # Make workdir immutable to prevent workdir re-create on mount
@@ -79,7 +84,7 @@ $CHATTR_PROG +i $workdir
 # Verify that overlay is mounted read-only and that it cannot be remounted rw.
 _overlay_scratch_mount_dirs $lowerdir2 $upperdir $workdir
 touch $SCRATCH_MNT/bar 2>&1 | _filter_scratch
-_scratch_remount rw 2>&1 | _filter_scratch
+_scratch_remount rw 2>&1 | filter_mount
 
 # success, all done
 status=0
-- 
2.13.6

