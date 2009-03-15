Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FBlI94008381 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 06:47:38 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB9C619A0E2
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:46:55 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail08.adl2.internode.on.net
	[203.16.214.72]) by cuda.sgi.com with ESMTP id QEermwpQRRQgzHRF
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:46:55 -0700 (PDT)
Received: from destruction.internal (unverified [203.206.165.193])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	44231942-1927428
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 22:16:54 +1030 (CDT)
Received: from dave by destruction.internal with local (Exim 4.69)
	(envelope-from <dave@destruction>) id 1Lionj-0006nR-SV
	for xfs@oss.sgi.com; Sun, 15 Mar 2009 22:46:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6] [XFS] Remove unused parameter from xfs_reclaim_inodes
Date: Sun, 15 Mar 2009 22:46:42 +1100
Message-Id: <1237117603-26071-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1237117603-26071-1-git-send-email-david@fromorbit.com>
References: <1237117603-26071-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The noblock parameter of xfs_reclaim_inodes() is only
ever set to zero. Remove it and all the conditional
code that is never executed.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   23 ++++-------------------
 fs/xfs/linux-2.6/xfs_sync.h |    2 +-
 fs/xfs/xfs_mount.c          |    2 +-
 3 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 1fa29de..f9c2a56 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -398,7 +398,7 @@ xfs_quiesce_fs(
 	int	count = 0, pincount;
 
 	xfs_flush_buftarg(mp->m_ddev_targp, 0);
-	xfs_reclaim_inodes(mp, 0, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
+	xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
 
 	/*
 	 * This loop must run at least twice.  The first instance of the loop
@@ -522,7 +522,7 @@ xfs_sync_worker(
 
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
 		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
-		xfs_reclaim_inodes(mp, 0, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
+		xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
 		/* dgc: errors ignored here */
 		error = XFS_QM_DQSYNC(mp, SYNC_BDFLUSH);
 		error = xfs_sync_fsdata(mp, SYNC_BDFLUSH);
@@ -728,7 +728,6 @@ STATIC void
 xfs_reclaim_inodes_ag(
 	xfs_mount_t	*mp,
 	int		ag,
-	int		noblock,
 	int		mode)
 {
 	xfs_inode_t	*ip = NULL;
@@ -775,26 +774,13 @@ restart:
 			read_unlock(&pag->pag_ici_lock);
 			continue;
 		}
-
-		if (noblock) {
-			if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
-				read_unlock(&pag->pag_ici_lock);
-				continue;
-			}
-			if (xfs_ipincount(ip) ||
-			    !xfs_iflock_nowait(ip)) {
-				xfs_iunlock(ip, XFS_ILOCK_EXCL);
-				read_unlock(&pag->pag_ici_lock);
-				continue;
-			}
-		}
 		read_unlock(&pag->pag_ici_lock);
 
 		/*
 		 * hmmm - this is an inode already in reclaim. Do
 		 * we even bother catching it here?
 		 */
-		if (xfs_reclaim_inode(ip, noblock, mode))
+		if (xfs_reclaim_inode(ip, 0, mode))
 			skipped++;
 	} while (nr_found);
 
@@ -809,7 +795,6 @@ restart:
 int
 xfs_reclaim_inodes(
 	xfs_mount_t	*mp,
-	int		 noblock,
 	int		mode)
 {
 	int		i;
@@ -817,7 +802,7 @@ xfs_reclaim_inodes(
 	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
 		if (!mp->m_perag[i].pag_ici_init)
 			continue;
-		xfs_reclaim_inodes_ag(mp, i, noblock, mode);
+		xfs_reclaim_inodes_ag(mp, i, mode);
 	}
 	return 0;
 }
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index 308d5bf..d7b2b5f 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -48,7 +48,7 @@ void xfs_quiesce_attr(struct xfs_mount *mp);
 void xfs_flush_inodes(struct xfs_inode *ip);
 
 int xfs_reclaim_inode(struct xfs_inode *ip, int locked, int sync_mode);
-int xfs_reclaim_inodes(struct xfs_mount *mp, int noblock, int mode);
+int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 void xfs_inode_clear_reclaim_tag(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 664961e..30918da 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1235,7 +1235,7 @@ xfs_unmountfs(
 	 * need to force the log first.
 	 */
 	xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE | XFS_LOG_SYNC);
-	xfs_reclaim_inodes(mp, 0, XFS_IFLUSH_ASYNC);
+	xfs_reclaim_inodes(mp, XFS_IFLUSH_ASYNC);
 
 	XFS_QM_DQPURGEALL(mp, XFS_QMOPT_QUOTALL | XFS_QMOPT_UMOUNTING);
 
-- 
1.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
