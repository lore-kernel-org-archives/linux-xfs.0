Return-Path: linux-xfs-owner@vger.kernel.org
Received: from userp2130.oracle.com ([156.151.31.86]:52860 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfHOPTF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Aug 2019 11:19:05 -0400
Subject: [PATCH 1/3] generic/081: fix lvm config not being cleaned up
 properly
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 15 Aug 2019 08:18:59 -0700
Message-ID: <156588233944.24775.714828611169800436.stgit@magnolia>
In-Reply-To: <156588233330.24775.15183725500886844319.stgit@magnolia>
References: <156588233330.24775.15183725500886844319.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix a race between _cleanup and dmeventd that causes the lvm
configuration not to be cleaned up and subsequent tests to fail.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/081 |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)


diff --git a/tests/generic/081 b/tests/generic/081
index 10f4a186..e8f4f5b5 100755
--- a/tests/generic/081
+++ b/tests/generic/081
@@ -19,12 +19,29 @@ _cleanup()
 {
 	cd /
 	rm -f $tmp.*
-	# lvm may have umounted it on I/O error, but in case it does not
-	# wait a bit for lvm to settle, sigh..
-	sleep 2
-	$UMOUNT_PROG $mnt >/dev/null 2>&1
-	$LVM_PROG vgremove -f $vgname >>$seqres.full 2>&1
-	$LVM_PROG pvremove -f $SCRATCH_DEV >>$seqres.full 2>&1
+
+	# Tear down the lvm vg and snapshot.
+	#
+	# NOTE: We do the unmount and {vg,pv}remove in a loop here because
+	# dmeventd could be configured to unmount the filesystem automatically
+	# after the IO errors.  That is racy with the umount we're trying to do
+	# here because there's a window in which the directory tree has been
+	# removed from the mount namespaces (so the umount call here sees no
+	# mount and exits) but the filesystem hasn't yet released the block
+	# device, which causes the vgremove here to fail.
+	#
+	# We "solve" the race by repeating the umount/lvm teardown until the
+	# block device goes away, because we cannot exit this test without
+	# removing the lvm devices from the scratch device -- this will cause
+	# other tests to fail.
+	while test -e /dev/mapper/$vgname-$snapname || \
+	      test -e /dev/mapper/$vgname-$lvname; do
+		$UMOUNT_PROG $mnt >> $seqres.full 2>&1
+		$LVM_PROG vgremove -f $vgname >>$seqres.full 2>&1
+		$LVM_PROG pvremove -f $SCRATCH_DEV >>$seqres.full 2>&1
+		test $? -eq 0 && break
+		sleep 2
+	done
 }
 
 # get standard environment, filters and checks
