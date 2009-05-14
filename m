Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4EHFqU3234946 for <xfs@oss.sgi.com>; Thu, 14 May 2009 12:15:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60A25FAECAF
	for <xfs@oss.sgi.com>; Thu, 14 May 2009 10:20:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ZiJBA0eyqF4Fo1CF for
	<xfs@oss.sgi.com>; Thu, 14 May 2009 10:20:45 -0700 (PDT)
Message-Id: <20090514171558.649403000@bombadil.infradead.org>
Date: Thu, 14 May 2009 13:12:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/7] xfs: remove unused parameter from xfs_reclaim_inodes
References: <20090514171233.942489000@bombadil.infradead.org>
Content-Disposition: inline; filename=sync5.diff
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

From: Dave Chinner <david@fromorbit.com>

The noblock parameter of xfs_reclaim_inodes is only ever set to zero. Remove
it and all the conditional code that is never executed.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-05-14 16:20:34.251688779 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2009-05-14 16:20:37.012658983 +0200
@@ -383,7 +383,7 @@ xfs_quiesce_fs(
 	int	count = 0, pincount;
 
 	xfs_flush_buftarg(mp->m_ddev_targp, 0);
-	xfs_reclaim_inodes(mp, 0, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
+	xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
 
 	/*
 	 * This loop must run at least twice.  The first instance of the loop
@@ -507,7 +507,7 @@ xfs_sync_worker(
 
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
 		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
-		xfs_reclaim_inodes(mp, 0, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
+		xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
 		/* dgc: errors ignored here */
 		error = xfs_qm_sync(mp, SYNC_BDFLUSH);
 		error = xfs_sync_fsdata(mp, SYNC_BDFLUSH);
@@ -701,7 +701,6 @@ STATIC void
 xfs_reclaim_inodes_ag(
 	xfs_mount_t	*mp,
 	int		ag,
-	int		noblock,
 	int		mode)
 {
 	xfs_inode_t	*ip = NULL;
@@ -747,25 +746,13 @@ restart:
 			continue;
 		}
 
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
 
@@ -780,7 +767,6 @@ restart:
 int
 xfs_reclaim_inodes(
 	xfs_mount_t	*mp,
-	int		 noblock,
 	int		mode)
 {
 	int		i;
@@ -788,7 +774,7 @@ xfs_reclaim_inodes(
 	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
 		if (!mp->m_perag[i].pag_ici_init)
 			continue;
-		xfs_reclaim_inodes_ag(mp, i, noblock, mode);
+		xfs_reclaim_inodes_ag(mp, i, mode);
 	}
 	return 0;
 }
Index: xfs/fs/xfs/linux-2.6/xfs_sync.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.h	2009-05-14 16:19:44.268809697 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.h	2009-05-14 16:20:37.012658983 +0200
@@ -50,7 +50,7 @@ void xfs_quiesce_attr(struct xfs_mount *
 void xfs_flush_inodes(struct xfs_inode *ip);
 
 int xfs_reclaim_inode(struct xfs_inode *ip, int locked, int sync_mode);
-int xfs_reclaim_inodes(struct xfs_mount *mp, int noblock, int mode);
+int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 void xfs_inode_clear_reclaim_tag(struct xfs_inode *ip);
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2009-05-14 16:19:44.318659340 +0200
+++ xfs/fs/xfs/xfs_mount.c	2009-05-14 16:20:37.013659110 +0200
@@ -1371,7 +1371,7 @@ xfs_unmountfs(
 	 * need to force the log first.
 	 */
 	xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE | XFS_LOG_SYNC);
-	xfs_reclaim_inodes(mp, 0, XFS_IFLUSH_ASYNC);
+	xfs_reclaim_inodes(mp, XFS_IFLUSH_ASYNC);
 
 	xfs_qm_unmount(mp);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
