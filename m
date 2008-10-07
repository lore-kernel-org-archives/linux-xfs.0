Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:53:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97Lr4rw005438
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:53:05 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE4334C633C
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 14:54:43 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id yP2NQywfYYyLoVzu for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 14:54:43 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKVs-00022Y-Ax
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 08:54:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/6] XFS: move inode reclaim functions to xfs_sync.c
Date: Wed,  8 Oct 2008 08:54:35 +1100
Message-Id: <1223416480-7701-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1223416480-7701-1-git-send-email-david@fromorbit.com>
References: <1223416480-7701-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Background inode reclaim is run by the xfssyncd. Move the
reclaim worker functions to be close to the sync code as
the are very similar in structure and are both run from
the same background thread.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   91 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/linux-2.6/xfs_sync.h |    3 +
 fs/xfs/xfs_inode.h          |    2 -
 fs/xfs/xfs_vnodeops.c       |   90 ------------------------------------------
 4 files changed, 94 insertions(+), 92 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index b2b7082..79038ea 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -583,3 +583,94 @@ xfs_syncd_stop(
 	kthread_stop(mp->m_sync_task);
 }
 
+int
+xfs_finish_reclaim(
+	xfs_inode_t	*ip,
+	int		locked,
+	int		sync_mode)
+{
+	xfs_perag_t	*pag = xfs_get_perag(ip->i_mount, ip->i_ino);
+
+	/* The hash lock here protects a thread in xfs_iget_core from
+	 * racing with us on linking the inode back with a vnode.
+	 * Once we have the XFS_IRECLAIM flag set it will not touch
+	 * us.
+	 */
+	write_lock(&pag->pag_ici_lock);
+	spin_lock(&ip->i_flags_lock);
+	if (__xfs_iflags_test(ip, XFS_IRECLAIM) ||
+	    !__xfs_iflags_test(ip, XFS_IRECLAIMABLE)) {
+		spin_unlock(&ip->i_flags_lock);
+		write_unlock(&pag->pag_ici_lock);
+		if (locked) {
+			xfs_ifunlock(ip);
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		}
+		return 1;
+	}
+	__xfs_iflags_set(ip, XFS_IRECLAIM);
+	spin_unlock(&ip->i_flags_lock);
+	write_unlock(&pag->pag_ici_lock);
+	xfs_put_perag(ip->i_mount, pag);
+
+	/*
+	 * If the inode is still dirty, then flush it out.  If the inode
+	 * is not in the AIL, then it will be OK to flush it delwri as
+	 * long as xfs_iflush() does not keep any references to the inode.
+	 * We leave that decision up to xfs_iflush() since it has the
+	 * knowledge of whether it's OK to simply do a delwri flush of
+	 * the inode or whether we need to wait until the inode is
+	 * pulled from the AIL.
+	 * We get the flush lock regardless, though, just to make sure
+	 * we don't free it while it is being flushed.
+	 */
+	if (!locked) {
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		xfs_iflock(ip);
+	}
+
+	/*
+	 * In the case of a forced shutdown we rely on xfs_iflush() to
+	 * wait for the inode to be unpinned before returning an error.
+	 */
+	if (!is_bad_inode(VFS_I(ip)) && xfs_iflush(ip, sync_mode) == 0) {
+		/* synchronize with xfs_iflush_done */
+		xfs_iflock(ip);
+		xfs_ifunlock(ip);
+	}
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_ireclaim(ip);
+	return 0;
+}
+
+int
+xfs_finish_reclaim_all(
+	xfs_mount_t	*mp,
+	int		 noblock,
+	int		mode)
+{
+	xfs_inode_t	*ip, *n;
+
+restart:
+	XFS_MOUNT_ILOCK(mp);
+	list_for_each_entry_safe(ip, n, &mp->m_del_inodes, i_reclaim) {
+		if (noblock) {
+			if (xfs_ilock_nowait(ip, XFS_ILOCK_EXCL) == 0)
+				continue;
+			if (xfs_ipincount(ip) ||
+			    !xfs_iflock_nowait(ip)) {
+				xfs_iunlock(ip, XFS_ILOCK_EXCL);
+				continue;
+			}
+		}
+		XFS_MOUNT_IUNLOCK(mp);
+		if (xfs_finish_reclaim(ip, noblock, mode))
+			delay(1);
+		goto restart;
+	}
+	XFS_MOUNT_IUNLOCK(mp);
+	return 0;
+}
+
+
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index 3b49aa3..23117a1 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -45,4 +45,7 @@ void xfs_quiesce_attr(struct xfs_mount *mp);
 void xfs_flush_inode(struct xfs_inode *ip);
 void xfs_flush_device(struct xfs_inode *ip);
 
+int xfs_finish_reclaim(struct xfs_inode *ip, int locked, int sync_mode);
+int xfs_finish_reclaim_all(struct xfs_mount *mp, int noblock, int mode);
+
 #endif
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index ab70cf3..f946b13 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -496,8 +496,6 @@ int		xfs_isilocked(xfs_inode_t *, uint);
 uint		xfs_ilock_map_shared(xfs_inode_t *);
 void		xfs_iunlock_map_shared(xfs_inode_t *, uint);
 void		xfs_ireclaim(xfs_inode_t *);
-int		xfs_finish_reclaim(xfs_inode_t *, int, int);
-int		xfs_finish_reclaim_all(struct xfs_mount *, int, int);
 
 /*
  * xfs_inode.c prototypes.
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 8bd8f19..f6d016e 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2824,96 +2824,6 @@ xfs_reclaim(
 	return 0;
 }
 
-int
-xfs_finish_reclaim(
-	xfs_inode_t	*ip,
-	int		locked,
-	int		sync_mode)
-{
-	xfs_perag_t	*pag = xfs_get_perag(ip->i_mount, ip->i_ino);
-
-	/* The hash lock here protects a thread in xfs_iget_core from
-	 * racing with us on linking the inode back with a vnode.
-	 * Once we have the XFS_IRECLAIM flag set it will not touch
-	 * us.
-	 */
-	write_lock(&pag->pag_ici_lock);
-	spin_lock(&ip->i_flags_lock);
-	if (__xfs_iflags_test(ip, XFS_IRECLAIM) ||
-	    !__xfs_iflags_test(ip, XFS_IRECLAIMABLE)) {
-		spin_unlock(&ip->i_flags_lock);
-		write_unlock(&pag->pag_ici_lock);
-		if (locked) {
-			xfs_ifunlock(ip);
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		}
-		return 1;
-	}
-	__xfs_iflags_set(ip, XFS_IRECLAIM);
-	spin_unlock(&ip->i_flags_lock);
-	write_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(ip->i_mount, pag);
-
-	/*
-	 * If the inode is still dirty, then flush it out.  If the inode
-	 * is not in the AIL, then it will be OK to flush it delwri as
-	 * long as xfs_iflush() does not keep any references to the inode.
-	 * We leave that decision up to xfs_iflush() since it has the
-	 * knowledge of whether it's OK to simply do a delwri flush of
-	 * the inode or whether we need to wait until the inode is
-	 * pulled from the AIL.
-	 * We get the flush lock regardless, though, just to make sure
-	 * we don't free it while it is being flushed.
-	 */
-	if (!locked) {
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_iflock(ip);
-	}
-
-	/*
-	 * In the case of a forced shutdown we rely on xfs_iflush() to
-	 * wait for the inode to be unpinned before returning an error.
-	 */
-	if (!is_bad_inode(VFS_I(ip)) && xfs_iflush(ip, sync_mode) == 0) {
-		/* synchronize with xfs_iflush_done */
-		xfs_iflock(ip);
-		xfs_ifunlock(ip);
-	}
-
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	xfs_ireclaim(ip);
-	return 0;
-}
-
-int
-xfs_finish_reclaim_all(
-	xfs_mount_t	*mp,
-	int		 noblock,
-	int		mode)
-{
-	xfs_inode_t	*ip, *n;
-
-restart:
-	XFS_MOUNT_ILOCK(mp);
-	list_for_each_entry_safe(ip, n, &mp->m_del_inodes, i_reclaim) {
-		if (noblock) {
-			if (xfs_ilock_nowait(ip, XFS_ILOCK_EXCL) == 0)
-				continue;
-			if (xfs_ipincount(ip) ||
-			    !xfs_iflock_nowait(ip)) {
-				xfs_iunlock(ip, XFS_ILOCK_EXCL);
-				continue;
-			}
-		}
-		XFS_MOUNT_IUNLOCK(mp);
-		if (xfs_finish_reclaim(ip, noblock, mode))
-			delay(1);
-		goto restart;
-	}
-	XFS_MOUNT_IUNLOCK(mp);
-	return 0;
-}
-
 /*
  * xfs_alloc_file_space()
  *      This routine allocates disk space for the given file.
-- 
1.5.6.5
