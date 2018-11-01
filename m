Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54134 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbeKBIYc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Nov 2018 04:24:32 -0400
Subject: [PATCH 3/8] generic/050: fix ro blockdev mount of xfs with quota
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 01 Nov 2018 16:19:21 -0700
Message-ID: <154111436126.6577.15057711037961689350.stgit@magnolia>
In-Reply-To: <154111434286.6577.15010861884505931015.stgit@magnolia>
References: <154111434286.6577.15010861884505931015.stgit@magnolia>
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
Since this is expected, work around this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/050 |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)


diff --git a/tests/generic/050 b/tests/generic/050
index 90e924db..33da228d 100755
--- a/tests/generic/050
+++ b/tests/generic/050
@@ -36,6 +36,21 @@ _require_norecovery
 
 _scratch_mkfs >/dev/null 2>&1
 
+filter_ro_mount() {
+	local arg=""
+
+	# Mounting with quota on XFS requires a writable fs, which means
+	# we fail the ro blockdev test with with EPERM.
+	if [ "$FSTYP" = "xfs" ] && echo "$MOUNT_OPTIONS" | grep -q quota ; then
+		arg="s|mount: $SCRATCH_MNT: permission denied|mount: device write-protected, mounting read-only|g"
+	fi
+	sed -e "$arg" | _filter_ro_mount
+}
+
+filter_umount() {
+	sed -e "\|umount: $SCRATCH_DEV: not mounted.|d" | _filter_scratch
+}
+
 #
 # Mark the device read-only
 #
@@ -46,7 +61,7 @@ blockdev --setro $SCRATCH_DEV
 # Mount it, and make sure we can't write to it, and we can unmount it again
 #
 echo "mounting read-only block device:"
-_try_scratch_mount 2>&1 | _filter_ro_mount
+_try_scratch_mount 2>&1 | filter_ro_mount
 
 echo "touching file on read-only filesystem (should fail)"
 touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
@@ -56,7 +71,7 @@ touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
 #	http://oss.sgi.com/bugzilla/show_bug.cgi?id=807
 #
 echo "unmounting read-only filesystem"
-_scratch_unmount 2>&1 | _filter_scratch
+_scratch_unmount 2>&1 | filter_umount
 
 echo "setting device read-write"
 blockdev --setrw $SCRATCH_DEV
@@ -92,10 +107,10 @@ _scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
 # data recovery hack.
 #
 echo "mounting filesystem with -o norecovery on a read-only device:"
-_try_scratch_mount -o norecovery 2>&1 | _filter_ro_mount
+_try_scratch_mount -o norecovery 2>&1 | filter_ro_mount
 
 echo "unmounting read-only filesystem"
-_scratch_unmount 2>&1 | _filter_scratch
+_scratch_unmount 2>&1 | filter_umount
 
 echo "setting device read-write"
 blockdev --setrw $SCRATCH_DEV
