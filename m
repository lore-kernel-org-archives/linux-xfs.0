Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54624 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbeLRUgH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 15:36:07 -0500
Subject: [PATCH 3/5] generic/050: fix ro blockdev mount of xfs with quota
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 18 Dec 2018 12:36:03 -0800
Message-ID: <154516536357.31115.14111308107665005322.stgit@magnolia>
In-Reply-To: <154516534392.31115.7010578395334646479.stgit@magnolia>
References: <154516534392.31115.7010578395334646479.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In XFS, mounting with quota always require a writable device.  If the
block device is read only, the mount fails, which fails this test.
Since this is expected, work around this by simulating the golden output
when we expect a mount failure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/050 |   62 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 46 insertions(+), 16 deletions(-)


diff --git a/tests/generic/050 b/tests/generic/050
index 90e924db..9a327165 100755
--- a/tests/generic/050
+++ b/tests/generic/050
@@ -36,6 +36,22 @@ _require_norecovery
 
 _scratch_mkfs >/dev/null 2>&1
 
+filter_ro_mount() {
+	local arg=""
+
+	if [ -n "$expect_mount_failure" ]; then
+		arg="s|mount: $SCRATCH_MNT: permission denied|mount: device write-protected, mounting read-only|g"
+	fi
+	sed -e "$arg" | _filter_ro_mount
+}
+
+# Mounting with quota on XFS requires a writable fs, which means
+# we expect to fail the ro blockdev test with with EPERM.
+expect_mount_failure=
+if [ "$FSTYP" = "xfs" ] && echo "$MOUNT_OPTIONS" | grep -q quota ; then
+	expect_mount_failure=1
+fi
+
 #
 # Mark the device read-only
 #
@@ -46,17 +62,25 @@ blockdev --setro $SCRATCH_DEV
 # Mount it, and make sure we can't write to it, and we can unmount it again
 #
 echo "mounting read-only block device:"
-_try_scratch_mount 2>&1 | _filter_ro_mount
-
-echo "touching file on read-only filesystem (should fail)"
-touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
-
-#
-# Apparently this used to be broken at some point:
-#	http://oss.sgi.com/bugzilla/show_bug.cgi?id=807
-#
-echo "unmounting read-only filesystem"
-_scratch_unmount 2>&1 | _filter_scratch
+_try_scratch_mount 2>&1 | filter_ro_mount
+if [ "${PIPESTATUS[0]}" -eq 0 ]; then
+	echo "touching file on read-only filesystem (should fail)"
+	touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
+
+	#
+	# Apparently this used to be broken at some point:
+	#	http://oss.sgi.com/bugzilla/show_bug.cgi?id=807
+	#
+	echo "unmounting read-only filesystem"
+	_scratch_unmount 2>&1 | _filter_scratch
+elif [ -n "${expect_mount_failure}" ]; then
+	# Mount failed, so simulate EROFS instead of scribbling on root fs
+	echo "touching file on read-only filesystem (should fail)"
+	echo "touch: cannot touch 'SCRATCH_MNT/foo': Read-only file system"
+	echo "unmounting read-only filesystem"
+else
+	echo "Mount failed, though it wasn't supposed to!"
+fi
 
 echo "setting device read-write"
 blockdev --setrw $SCRATCH_DEV
@@ -88,14 +112,20 @@ _scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
 
 #
 # This is the way out if the underlying device really is read-only.
-# Doesn't mean it's a good idea in practive, more a last resort
+# Doesn't mean it's a good idea in practice, more a last resort
 # data recovery hack.
 #
 echo "mounting filesystem with -o norecovery on a read-only device:"
-_try_scratch_mount -o norecovery 2>&1 | _filter_ro_mount
-
-echo "unmounting read-only filesystem"
-_scratch_unmount 2>&1 | _filter_scratch
+_try_scratch_mount -o norecovery 2>&1 | filter_ro_mount
+if [ "${PIPESTATUS[0]}" -eq 0 ]; then
+	echo "unmounting read-only filesystem"
+	_scratch_unmount 2>&1 | _filter_scratch
+elif [ -n "${expect_mount_failure}" ]; then
+	# Mount failed, simulate correct output
+	echo "unmounting read-only filesystem"
+else
+	echo "Mount failed, though it wasn't supposed to!"
+fi
 
 echo "setting device read-write"
 blockdev --setrw $SCRATCH_DEV
