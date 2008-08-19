Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Aug 2008 06:16:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7JDFgLI022897
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 06:15:42 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 19EA112F9424
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 06:17:02 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id jo1u0Dh0rHS140ZR for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 06:17:02 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KVR4w-0008Bh-Oy
	for xfs@oss.sgi.com; Tue, 19 Aug 2008 23:16:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 26/28] XFS: rename inode reclaim functions
Date: Tue, 19 Aug 2008 23:16:42 +1000
Message-Id: <1219151804-30749-27-git-send-email-david@fromorbit.com>
In-Reply-To: <1219151804-30749-1-git-send-email-david@fromorbit.com>
References: <1219151804-30749-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The function names xfs_finish_reclaim and xfs_finish_reclaim_all
are not very descriptive of what they are reclaiming. Rename to
xfs_reclaim_inode[s] to match the xfs_sync_inodes() function.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   10 +++++-----
 fs/xfs/linux-2.6/xfs_sync.h |    4 ++--
 fs/xfs/xfs_mount.c          |    2 +-
 fs/xfs/xfs_vnodeops.c       |    2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index ebe2932..3141c25 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -359,7 +359,7 @@ xfs_quiesce_fs(
 	int	count = 0, pincount;
 
 	xfs_flush_buftarg(mp->m_ddev_targp, 0);
-	xfs_finish_reclaim_all(mp, 0, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
+	xfs_reclaim_inodes(mp, 0, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
 
 	/*
 	 * This loop must run at least twice.  The first instance of the loop
@@ -501,7 +501,7 @@ xfs_sync_worker(
 
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
 		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
-		xfs_finish_reclaim_all(mp, 1, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
+		xfs_reclaim_inodes(mp, 0, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
 		/* dgc: errors ignored here */
 		error = XFS_QM_DQSYNC(mp, SYNC_BDFLUSH);
 		error = xfs_sync_fsdata(mp, SYNC_BDFLUSH);
@@ -580,7 +580,7 @@ xfs_syncd_stop(
 }
 
 int
-xfs_finish_reclaim(
+xfs_reclaim_inode(
 	xfs_inode_t	*ip,
 	int		locked,
 	int		sync_mode)
@@ -682,7 +682,7 @@ xfs_inode_clear_reclaim_tag(
 }
 
 int
-xfs_finish_reclaim_all(
+xfs_reclaim_inodes(
 	xfs_mount_t	*mp,
 	int		 noblock,
 	int		mode)
@@ -702,7 +702,7 @@ restart:
 			}
 		}
 		XFS_MOUNT_IUNLOCK(mp);
-		if (xfs_finish_reclaim(ip, noblock, mode))
+		if (xfs_reclaim_inode(ip, noblock, mode))
 			delay(1);
 		goto restart;
 	}
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index fcaf004..5f6de1e 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -45,8 +45,8 @@ void xfs_quiesce_attr(struct xfs_mount *mp);
 void xfs_flush_inode(struct xfs_inode *ip);
 void xfs_flush_device(struct xfs_inode *ip);
 
-int xfs_finish_reclaim(struct xfs_inode *ip, int locked, int sync_mode);
-int xfs_finish_reclaim_all(struct xfs_mount *mp, int noblock, int mode);
+int xfs_reclaim_inode(struct xfs_inode *ip, int locked, int sync_mode);
+int xfs_reclaim_inodes(struct xfs_mount *mp, int noblock, int mode);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 void xfs_inode_clear_reclaim_tag(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 8372b3d..25698ee 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1241,7 +1241,7 @@ xfs_unmountfs(
 	 * need to force the log first.
 	 */
 	xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE | XFS_LOG_SYNC);
-	xfs_finish_reclaim_all(mp, 0, XFS_IFLUSH_ASYNC);
+	xfs_reclaim_inodes(mp, 0, XFS_IFLUSH_ASYNC);
 
 	XFS_QM_DQPURGEALL(mp, XFS_QMOPT_QUOTALL | XFS_QMOPT_UMOUNTING);
 
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 1f56ea1..47b3e68 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2801,7 +2801,7 @@ xfs_reclaim(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_iflock(ip);
 		xfs_iflags_set(ip, XFS_IRECLAIMABLE);
-		return xfs_finish_reclaim(ip, 1, XFS_IFLUSH_DELWRI_ELSE_SYNC);
+		return xfs_reclaim_inode(ip, 1, XFS_IFLUSH_DELWRI_ELSE_SYNC);
 	} else {
 		xfs_mount_t	*mp = ip->i_mount;
 
-- 
1.5.6
