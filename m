Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Aug 2008 06:15:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7JDFbVt022822
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 06:15:37 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C746C12F9416
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 06:16:56 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id tFwwp6sIjmVX8FxS for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 06:16:56 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KVR4n-0008AP-PM
	for xfs@oss.sgi.com; Tue, 19 Aug 2008 23:16:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/28] XFS: Use struct inodes instead of vnodes to kill vn_grab
Date: Tue, 19 Aug 2008 23:16:25 +1000
Message-Id: <1219151804-30749-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1219151804-30749-1-git-send-email-david@fromorbit.com>
References: <1219151804-30749-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

With the sync code relocated to the linux-2.6 directory we can use
struct inodes directly. If we do the same thing for the quota
release code, we can remove vn_grab altogether.  While here, convert
the VN_BAD() checks to is_bad_inode() so we can remove vnodes
entirely from this code.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c    |   53 +++++++++++++++++++--------------------
 fs/xfs/linux-2.6/xfs_vnode.c   |    6 ++--
 fs/xfs/linux-2.6/xfs_vnode.h   |    5 ----
 fs/xfs/quota/xfs_qm_syscalls.c |   16 ++++++------
 4 files changed, 37 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 59da332..461c1dc 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -131,10 +131,7 @@ xfs_sync_inodes_ag(
 	int		flags,
 	int		*bypassed)
 {
-	xfs_inode_t	*ip = NULL;
-	struct inode	*vp = NULL;
 	xfs_perag_t	*pag = &mp->m_perag[ag];
-	boolean_t	vnode_refed = B_FALSE;
 	int		nr_found;
 	int		first_index = 0;
 	int		error = 0;
@@ -156,6 +153,10 @@ xfs_sync_inodes_ag(
 	}
 
 	do {
+		struct inode	*inode;
+		boolean_t	inode_refed;
+		xfs_inode_t	*ip = NULL;
+
 		/*
 		 * use a gang lookup to find the next inode in the tree
 		 * as the tree is sparse and a gang lookup walks to find
@@ -177,14 +178,14 @@ xfs_sync_inodes_ag(
 		 * skip inodes in reclaim. Let xfs_syncsub do that for
 		 * us so we don't need to worry.
 		 */
-		vp = VFS_I(ip);
-		if (!vp) {
+		if (xfs_iflags_test(ip, (XFS_IRECLAIM|XFS_IRECLAIMABLE))) {
 			read_unlock(&pag->pag_ici_lock);
 			continue;
 		}
 
 		/* bad inodes are dealt with elsewhere */
-		if (VN_BAD(vp)) {
+		inode = VFS_I(ip);
+		if (is_bad_inode(inode)) {
 			read_unlock(&pag->pag_ici_lock);
 			continue;
 		}
@@ -196,30 +197,29 @@ xfs_sync_inodes_ag(
 		}
 
 		/*
-		 * The inode lock here actually coordinates with the almost
-		 * spurious inode lock in xfs_ireclaim() to prevent the vnode
-		 * we handle here without a reference from being freed while we
-		 * reference it.  If we lock the inode while it's on the mount
-		 * list here, then the spurious inode lock in xfs_ireclaim()
-		 * after the inode is pulled from the mount list will sleep
-		 * until we release it here.  This keeps the vnode from being
-		 * freed while we reference it.
+		 * If we can't get a reference on the VFS_I, the inode must be
+		 * in reclaim. If we can get the inode lock without blocking,
+		 * it is safe to flush the inode because we hold the tree lock
+		 * and xfs_iextract will block right now. Hence if we lock the
+		 * inode while holding the tree lock, xfs_ireclaim() is
+		 * guaranteed to block on the inode lock we now hold and hence
+		 * it is safe to reference the inode until we drop the inode
+		 * locks completely.
 		 */
-		if (xfs_ilock_nowait(ip, lock_flags) == 0) {
-			vp = vn_grab(vp);
+		inode_refed = B_FALSE;
+		if (igrab(inode)) {
 			read_unlock(&pag->pag_ici_lock);
-			if (!vp)
-				continue;
 			xfs_ilock(ip, lock_flags);
-
-			ASSERT(vp == VFS_I(ip));
-			ASSERT(ip->i_mount == mp);
-
-			vnode_refed = B_TRUE;
+			inode_refed = B_TRUE;
 		} else {
-			/* safe to unlock here as we have a reference */
+			if (!xfs_ilock_nowait(ip, lock_flags)) {
+				/* leave it to reclaim */
+				read_unlock(&pag->pag_ici_lock);
+				continue;
+			}
 			read_unlock(&pag->pag_ici_lock);
 		}
+
 		/*
 		 * If we have to flush data or wait for I/O completion
 		 * we need to drop the ilock that we currently hold.
@@ -240,7 +240,7 @@ xfs_sync_inodes_ag(
 			xfs_ilock(ip, XFS_ILOCK_SHARED);
 		}
 
-		if ((flags & SYNC_DELWRI) && VN_DIRTY(vp)) {
+		if ((flags & SYNC_DELWRI) && VN_DIRTY(inode)) {
 			xfs_iunlock(ip, XFS_ILOCK_SHARED);
 			error = xfs_flush_pages(ip, 0, -1, fflag, FI_NONE);
 			if (flags & SYNC_IOWAIT)
@@ -268,9 +268,8 @@ xfs_sync_inodes_ag(
 		if (lock_flags)
 			xfs_iunlock(ip, lock_flags);
 
-		if (vnode_refed) {
+		if (inode_refed) {
 			IRELE(ip);
-			vnode_refed = B_FALSE;
 		}
 
 		if (error)
diff --git a/fs/xfs/linux-2.6/xfs_vnode.c b/fs/xfs/linux-2.6/xfs_vnode.c
index b52528b..dceb6db 100644
--- a/fs/xfs/linux-2.6/xfs_vnode.c
+++ b/fs/xfs/linux-2.6/xfs_vnode.c
@@ -90,10 +90,10 @@ vn_ioerror(
  */
 static inline int xfs_icount(struct xfs_inode *ip)
 {
-	struct inode *vp = VFS_I(ip);
+	struct inode *inode = VFS_I(ip);
 
-	if (vp)
-		return vn_count(vp);
+	if (!inode)
+		return atomic_read(&inode->i_count);
 	return -1;
 }
 
diff --git a/fs/xfs/linux-2.6/xfs_vnode.h b/fs/xfs/linux-2.6/xfs_vnode.h
index 683ce16..bf89e41 100644
--- a/fs/xfs/linux-2.6/xfs_vnode.h
+++ b/fs/xfs/linux-2.6/xfs_vnode.h
@@ -80,11 +80,6 @@ do { \
 	iput(VFS_I(ip)); \
 } while (0)
 
-static inline struct inode *vn_grab(struct inode *vp)
-{
-	return igrab(vp);
-}
-
 /*
  * Dealing with bad inodes
  */
diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
index 26152b9..4254b07 100644
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -1031,13 +1031,13 @@ xfs_qm_dqrele_inodes_ag(
 	uint		flags)
 {
 	xfs_inode_t	*ip = NULL;
-	struct inode	*vp = NULL;
 	xfs_perag_t	*pag = &mp->m_perag[ag];
 	int		first_index = 0;
 	int		nr_found;
 
 	do {
-		boolean_t	vnode_refd = B_FALSE;
+		boolean_t	inode_refed;
+		struct inode	*inode;
 
 		/*
 		 * use a gang lookup to find the next inode in the tree
@@ -1057,19 +1057,19 @@ xfs_qm_dqrele_inodes_ag(
 		first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
 
 		/* skip quota inodes and those in reclaim */
-		vp = VFS_I(ip);
-		if (!vp || ip == XFS_QI_UQIP(mp) || ip == XFS_QI_GQIP(mp)) {
+		inode = VFS_I(ip);
+		if (!inode || ip == XFS_QI_UQIP(mp) || ip == XFS_QI_GQIP(mp)) {
 			ASSERT(ip->i_udquot == NULL);
 			ASSERT(ip->i_gdquot == NULL);
 			read_unlock(&pag->pag_ici_lock);
 			continue;
 		}
 		if (xfs_ilock_nowait(ip, XFS_ILOCK_EXCL) == 0) {
-			vp = vn_grab(vp);
+			inode = igrab(inode);
 			read_unlock(&pag->pag_ici_lock);
-			if (!vp)
+			if (!inode)
 				continue;
-			vnode_refd = B_TRUE;
+			inode_refed = B_TRUE;
 			xfs_ilock(ip, XFS_ILOCK_EXCL);
 		} else {
 			read_unlock(&pag->pag_ici_lock);
@@ -1084,7 +1084,7 @@ xfs_qm_dqrele_inodes_ag(
 			ip->i_gdquot = NULL;
 		}
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		if (vnode_refd)
+		if (inode_refed)
 			IRELE(ip);
 	} while (nr_found);
 }
-- 
1.5.6
