Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Jun 2008 20:06:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5Q36Niv027522
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 20:06:23 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F351D55BED
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 20:07:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id kl3qhS9BdcS4RHRD for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 20:07:23 -0700 (PDT)
Message-ID: <486307EA.7080007@sandeen.net>
Date: Wed, 25 Jun 2008 22:07:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] disable queue flag test in barrier check
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>

md raid1 can pass down barriers, but does not set an ordered flag 
on the queue, so xfs does not even attempt a barrier write, and 
will never use barriers on these block devices.

I propose removing the flag check and just let the barrier write
test determine barrier support.

The risk here, I suppose, is that if something does not set an ordered
flag and also does not properly return an error on a barrier write...
but if it's any consolation jbd/ext3/reiserfs never test the flag, 
and don't even do a test write, they just disable barriers the first 
time an actual journal barrier write fails.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6.25.1/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6.25.1.orig/fs/xfs/linux-2.6/xfs_super.c
+++ linux-2.6.25.1/fs/xfs/linux-2.6/xfs_super.c
@@ -733,14 +733,6 @@ xfs_mountfs_check_barriers(xfs_mount_t *
 		return;
 	}
 
-	if (mp->m_ddev_targp->bt_bdev->bd_disk->queue->ordered ==
-					QUEUE_ORDERED_NONE) {
-		xfs_fs_cmn_err(CE_NOTE, mp,
-		  "Disabling barriers, not supported by the underlying device");
-		mp->m_flags &= ~XFS_MOUNT_BARRIER;
-		return;
-	}
-
 	if (xfs_readonly_buftarg(mp->m_ddev_targp)) {
 		xfs_fs_cmn_err(CE_NOTE, mp,
 		  "Disabling barriers, underlying device is readonly");
