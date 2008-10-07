Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:53:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97Lr347005416
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:53:03 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E7AF24C6336
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 14:54:42 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id KzBNtahr5MOPh5sa for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 14:54:42 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKVs-00022b-Cx
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 08:54:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] XFS: rename inode reclaim functions
Date: Wed,  8 Oct 2008 08:54:36 +1100
Message-Id: <1223416480-7701-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1223416480-7701-1-git-send-email-david@fromorbit.com>
References: <1223416480-7701-1-git-send-email-david@fromorbit.com>
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
index 79038ea..34413ce 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -364,7 +364,7 @@ xfs_quiesce_fs(
 	int	count = 0, pincount;
 
 	xfs_flush_buftarg(mp->m_ddev_targp, 0);
-	xfs_finish_reclaim_all(mp, 0, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
+	xfs_reclaim_inodes(mp, 0, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
 
 	/*
 	 * This loop must run at least twice.  The first instance of the loop
@@ -505,7 +505,7 @@ xfs_sync_worker(
 
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
 		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
-		xfs_finish_reclaim_all(mp, 1, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
+		xfs_reclaim_inodes(mp, 0, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
 		/* dgc: errors ignored here */
 		error = XFS_QM_DQSYNC(mp, SYNC_BDFLUSH);
 		error = xfs_sync_fsdata(mp, SYNC_BDFLUSH);
@@ -584,7 +584,7 @@ xfs_syncd_stop(
 }
 
 int
-xfs_finish_reclaim(
+xfs_reclaim_inode(
 	xfs_inode_t	*ip,
 	int		locked,
 	int		sync_mode)
@@ -645,7 +645,7 @@ xfs_finish_reclaim(
 }
 
 int
-xfs_finish_reclaim_all(
+xfs_reclaim_inodes(
 	xfs_mount_t	*mp,
 	int		 noblock,
 	int		mode)
@@ -665,7 +665,7 @@ restart:
 			}
 		}
 		XFS_MOUNT_IUNLOCK(mp);
-		if (xfs_finish_reclaim(ip, noblock, mode))
+		if (xfs_reclaim_inode(ip, noblock, mode))
 			delay(1);
 		goto restart;
 	}
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index 23117a1..c1bcd50 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -45,7 +45,7 @@ void xfs_quiesce_attr(struct xfs_mount *mp);
 void xfs_flush_inode(struct xfs_inode *ip);
 void xfs_flush_device(struct xfs_inode *ip);
 
-int xfs_finish_reclaim(struct xfs_inode *ip, int locked, int sync_mode);
-int xfs_finish_reclaim_all(struct xfs_mount *mp, int noblock, int mode);
+int xfs_reclaim_inode(struct xfs_inode *ip, int locked, int sync_mode);
+int xfs_reclaim_inodes(struct xfs_mount *mp, int noblock, int mode);
 
 #endif
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 1e10882..a230d8f 100644
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
index f6d016e..1addcc7 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2809,7 +2809,7 @@ xfs_reclaim(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_iflock(ip);
 		xfs_iflags_set(ip, XFS_IRECLAIMABLE);
-		return xfs_finish_reclaim(ip, 1, XFS_IFLUSH_DELWRI_ELSE_SYNC);
+		return xfs_reclaim_inode(ip, 1, XFS_IFLUSH_DELWRI_ELSE_SYNC);
 	} else {
 		xfs_mount_t	*mp = ip->i_mount;
 
-- 
1.5.6.5
