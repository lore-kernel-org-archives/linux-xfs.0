Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Aug 2008 06:16:33 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7JDFgWw022886
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 06:15:42 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 725761BC6737
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 06:17:01 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id a5zuiMjSaSXmlrAd for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 06:17:01 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KVR4v-0008BQ-0e
	for xfs@oss.sgi.com; Tue, 19 Aug 2008 23:16:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 20/28] XFS: Never call mark_inode_dirty_sync() directly
Date: Tue, 19 Aug 2008 23:16:36 +1000
Message-Id: <1219151804-30749-21-git-send-email-david@fromorbit.com>
In-Reply-To: <1219151804-30749-1-git-send-email-david@fromorbit.com>
References: <1219151804-30749-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Once the Linux inode and the XFS inode are combined, we cannot rely
on just check if the linux inode exists as a method of determining
if it is valid or not. Hence we should always call
xfs_mark_inode_dirty_sync() instead as it does the correct checks to
determine if the liinux inode is in a valid state or not.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_aops.c  |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c  |    2 +-
 fs/xfs/linux-2.6/xfs_super.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index f42f80a..d932579 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -191,7 +191,7 @@ xfs_setfilesize(
 		ip->i_d.di_size = isize;
 		ip->i_update_core = 1;
 		ip->i_update_size = 1;
-		mark_inode_dirty_sync(ioend->io_inode);
+		xfs_mark_inode_dirty_sync(ip);
 	}
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 91bcd97..600165f 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -128,7 +128,7 @@ xfs_ichgtime(
 	if (sync_it) {
 		SYNCHRONIZE();
 		ip->i_update_core = 1;
-		mark_inode_dirty_sync(inode);
+		xfs_mark_inode_dirty_sync(ip);
 	}
 }
 
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 0da7879..ed12c5e 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -949,7 +949,7 @@ xfs_fs_write_inode(
 	 * it dirty again so we'll try again later.
 	 */
 	if (error)
-		mark_inode_dirty_sync(inode);
+		xfs_mark_inode_dirty_sync(XFS_I(inode));
 
 	return -error;
 }
-- 
1.5.6
