Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33694 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752737AbdKWLK5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Nov 2017 06:10:57 -0500
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v3 3/3] fstests: filter readonly mount error messages
Date: Thu, 23 Nov 2017 19:10:31 +0800
Message-Id: <20171123111031.6550-4-eguan@redhat.com>
In-Reply-To: <20171123111031.6550-1-eguan@redhat.com>
References: <20171123111031.6550-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: misono.tomohiro@jp.fujitsu.com, linux-xfs@vger.kernel.org, amir73il@gmail.com, Eryu Guan <eguan@redhat.com>

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
v3:
- document the filtered format in comments
- remove legacy sed filter, the perl filter covers the legacy case well
- filter out $SCRATCH_DEV/MNT too and use a consistent output
- remove the new filter_mount helper in overlay/035

 common/filter         | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
 tests/generic/050     |  8 ++++----
 tests/generic/050.out |  8 ++++----
 tests/overlay/035     |  4 ++--
 tests/overlay/035.out |  4 ++--
 5 files changed, 58 insertions(+), 14 deletions(-)

diff --git a/common/filter b/common/filter
index a212c09aa138..6140b331017f 100644
--- a/common/filter
+++ b/common/filter
@@ -399,9 +399,53 @@ _filter_ending_dot()
 
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
+# util-linux versions. So the filtered format would be:
+#
+# successful ro mount:
+# mount: device write-protected, mounting read-only
+#
+# failed ro mount:
+# mount: device write-protected, mounting read-only
+# mount: cannot mount read-only
+#
+# failed rw remount:
+# mount: cannot remount device read-write, is write-protected
 _filter_ro_mount() {
-	sed -e "s/mount: block device/mount:/g" \
-	    -e "s/mount: cannot mount block device/mount: cannot mount/g"
+	perl -ne '
+	if (/write-protected, mount.*read-only/) {
+		# successful ro mount
+		print "mount: device write-protected, mounting read-only\n";
+	} elsif (/mount: .*: cannot mount.*read-only/) {
+		# filter v2.30 format failed ro mount
+		print "mount: device write-protected, mounting read-only\n";
+		print "mount: cannot mount read-only\n";
+	} elsif (/(^mount: cannot mount) .* (read-only$)/) {
+		# filter prior to v2.30 format failed ro mount
+		print "$1 $2\n";
+	} elsif (/mount:.* cannot remount .* read-write.*/) {
+		# failed rw remount
+		print "mount: cannot remount device read-write, is write-protected\n";
+	} else {
+		print "$_";
+	}' | _filter_ending_dot
 }
 
 # Filter a failed mount output due to EUCLEAN and USTALE, util-linux changed
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
index 64fcd708105e..05447741a1ba 100755
--- a/tests/overlay/035
+++ b/tests/overlay/035
@@ -69,7 +69,7 @@ mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
 $MOUNT_PROG -t overlay -o"lowerdir=$lowerdir2:$lowerdir1" \
 			$OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
 touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
-_scratch_remount rw 2>&1 | _filter_scratch
+_scratch_remount rw 2>&1 | _filter_ro_mount
 $UMOUNT_PROG $SCRATCH_MNT
 
 # Make workdir immutable to prevent workdir re-create on mount
@@ -79,7 +79,7 @@ $CHATTR_PROG +i $workdir
 # Verify that overlay is mounted read-only and that it cannot be remounted rw.
 _overlay_scratch_mount_dirs $lowerdir2 $upperdir $workdir
 touch $SCRATCH_MNT/bar 2>&1 | _filter_scratch
-_scratch_remount rw 2>&1 | _filter_scratch
+_scratch_remount rw 2>&1 | _filter_ro_mount
 
 # success, all done
 status=0
diff --git a/tests/overlay/035.out b/tests/overlay/035.out
index 5a5f67771402..e08ba2ebc691 100644
--- a/tests/overlay/035.out
+++ b/tests/overlay/035.out
@@ -1,5 +1,5 @@
 QA output created by 035
 touch: cannot touch 'SCRATCH_MNT/foo': Read-only file system
-mount: cannot remount SCRATCH_DEV read-write, is write-protected
+mount: cannot remount device read-write, is write-protected
 touch: cannot touch 'SCRATCH_MNT/bar': Read-only file system
-mount: cannot remount SCRATCH_DEV read-write, is write-protected
+mount: cannot remount device read-write, is write-protected
-- 
2.14.3

