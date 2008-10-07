Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:40:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97LdxiM031002
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:39:59 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A092F129BB50
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 14:41:37 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 8B0uEPsV72uKDQAS for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 14:41:37 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKJA-0001gE-QU
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 08:41:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] XFS: Use the inode tree for finding dirty inodes V3
Date: Wed,  8 Oct 2008 08:41:30 +1100
Message-Id: <1223415692-6354-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1223415692-6354-1-git-send-email-david@fromorbit.com>
References: <1223415692-6354-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Update xfs_sync_inodes to walk the inode radix tree cache to find
dirty inodes. This removes a huge bunch of nasty, messy code for
traversing the mount inode list safely and removes another user of
the mount inode list.

Version 3
o rediff against new linux-2.6/xfs_sync.c code

Version 2
o add comment explaining use of gang lookups for a single inode
o use IRELE, not VN_RELE
o move check for ag initialisation to caller.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |  361 ++++++++++++-------------------------------
 1 files changed, 101 insertions(+), 260 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index cd82ba5..53d85ec 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -121,356 +121,197 @@ xfs_sync(
 }
 
 /*
- * xfs sync routine for internal use
- *
- * This routine supports all of the flags defined for the generic vfs_sync
- * interface as explained above under xfs_sync.
- *
+ * Sync all the inodes in the given AG according to the
+ * direction given by the flags.
  */
-int
-xfs_sync_inodes(
+STATIC int
+xfs_sync_inodes_ag(
 	xfs_mount_t	*mp,
+	int		ag,
 	int		flags,
-	int             *bypassed)
+	int		*bypassed)
 {
 	xfs_inode_t	*ip = NULL;
 	struct inode	*vp = NULL;
-	int		error;
-	int		last_error;
-	uint64_t	fflag;
-	uint		lock_flags;
-	uint		base_lock_flags;
-	boolean_t	mount_locked;
-	boolean_t	vnode_refed;
-	int		preempt;
-	xfs_iptr_t	*ipointer;
-#ifdef DEBUG
-	boolean_t	ipointer_in = B_FALSE;
-
-#define IPOINTER_SET	ipointer_in = B_TRUE
-#define IPOINTER_CLR	ipointer_in = B_FALSE
-#else
-#define IPOINTER_SET
-#define IPOINTER_CLR
-#endif
-
-
-/* Insert a marker record into the inode list after inode ip. The list
- * must be locked when this is called. After the call the list will no
- * longer be locked.
- */
-#define IPOINTER_INSERT(ip, mp)	{ \
-		ASSERT(ipointer_in == B_FALSE); \
-		ipointer->ip_mnext = ip->i_mnext; \
-		ipointer->ip_mprev = ip; \
-		ip->i_mnext = (xfs_inode_t *)ipointer; \
-		ipointer->ip_mnext->i_mprev = (xfs_inode_t *)ipointer; \
-		preempt = 0; \
-		XFS_MOUNT_IUNLOCK(mp); \
-		mount_locked = B_FALSE; \
-		IPOINTER_SET; \
-	}
-
-/* Remove the marker from the inode list. If the marker was the only item
- * in the list then there are no remaining inodes and we should zero out
- * the whole list. If we are the current head of the list then move the head
- * past us.
- */
-#define IPOINTER_REMOVE(ip, mp)	{ \
-		ASSERT(ipointer_in == B_TRUE); \
-		if (ipointer->ip_mnext != (xfs_inode_t *)ipointer) { \
-			ip = ipointer->ip_mnext; \
-			ip->i_mprev = ipointer->ip_mprev; \
-			ipointer->ip_mprev->i_mnext = ip; \
-			if (mp->m_inodes == (xfs_inode_t *)ipointer) { \
-				mp->m_inodes = ip; \
-			} \
-		} else { \
-			ASSERT(mp->m_inodes == (xfs_inode_t *)ipointer); \
-			mp->m_inodes = NULL; \
-			ip = NULL; \
-		} \
-		IPOINTER_CLR; \
-	}
-
-#define XFS_PREEMPT_MASK	0x7f
-
-	ASSERT(!(flags & SYNC_BDFLUSH));
-
-	if (bypassed)
-		*bypassed = 0;
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
-		return 0;
-	error = 0;
-	last_error = 0;
-	preempt = 0;
-
-	/* Allocate a reference marker */
-	ipointer = (xfs_iptr_t *)kmem_zalloc(sizeof(xfs_iptr_t), KM_SLEEP);
+	xfs_perag_t	*pag = &mp->m_perag[ag];
+	boolean_t	vnode_refed = B_FALSE;
+	int		nr_found;
+	int		first_index = 0;
+	int		error = 0;
+	int		last_error = 0;
+	int		fflag = XFS_B_ASYNC;
+	int		lock_flags = XFS_ILOCK_SHARED;
 
-	fflag = XFS_B_ASYNC;		/* default is don't wait */
 	if (flags & SYNC_DELWRI)
 		fflag = XFS_B_DELWRI;
 	if (flags & SYNC_WAIT)
 		fflag = 0;		/* synchronous overrides all */
 
-	base_lock_flags = XFS_ILOCK_SHARED;
 	if (flags & (SYNC_DELWRI | SYNC_CLOSE)) {
 		/*
 		 * We need the I/O lock if we're going to call any of
 		 * the flush/inval routines.
 		 */
-		base_lock_flags |= XFS_IOLOCK_SHARED;
+		lock_flags |= XFS_IOLOCK_SHARED;
 	}
 
-	XFS_MOUNT_ILOCK(mp);
-
-	ip = mp->m_inodes;
-
-	mount_locked = B_TRUE;
-	vnode_refed  = B_FALSE;
-
-	IPOINTER_CLR;
-
 	do {
-		ASSERT(ipointer_in == B_FALSE);
-		ASSERT(vnode_refed == B_FALSE);
-
-		lock_flags = base_lock_flags;
-
 		/*
-		 * There were no inodes in the list, just break out
-		 * of the loop.
+		 * use a gang lookup to find the next inode in the tree
+		 * as the tree is sparse and a gang lookup walks to find
+		 * the number of objects requested.
 		 */
-		if (ip == NULL) {
-			break;
-		}
+		read_lock(&pag->pag_ici_lock);
+		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
+				(void**)&ip, first_index, 1);
 
-		/*
-		 * We found another sync thread marker - skip it
-		 */
-		if (ip->i_mount == NULL) {
-			ip = ip->i_mnext;
-			continue;
+		if (!nr_found) {
+			read_unlock(&pag->pag_ici_lock);
+			break;
 		}
 
-		vp = VFS_I(ip);
+		/* update the index for the next lookup */
+		first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
 
 		/*
-		 * If the vnode is gone then this is being torn down,
-		 * call reclaim if it is flushed, else let regular flush
-		 * code deal with it later in the loop.
+		 * skip inodes in reclaim. Let xfs_syncsub do that for
+		 * us so we don't need to worry.
 		 */
-
-		if (vp == NULL) {
-			/* Skip ones already in reclaim */
-			if (ip->i_flags & XFS_IRECLAIM) {
-				ip = ip->i_mnext;
-				continue;
-			}
-			if (xfs_ilock_nowait(ip, XFS_ILOCK_EXCL) == 0) {
-				ip = ip->i_mnext;
-			} else if ((xfs_ipincount(ip) == 0) &&
-				    xfs_iflock_nowait(ip)) {
-				IPOINTER_INSERT(ip, mp);
-
-				xfs_finish_reclaim(ip, 1,
-						XFS_IFLUSH_DELWRI_ELSE_ASYNC);
-
-				XFS_MOUNT_ILOCK(mp);
-				mount_locked = B_TRUE;
-				IPOINTER_REMOVE(ip, mp);
-			} else {
-				xfs_iunlock(ip, XFS_ILOCK_EXCL);
-				ip = ip->i_mnext;
-			}
+		vp = VFS_I(ip);
+		if (!vp) {
+			read_unlock(&pag->pag_ici_lock);
 			continue;
 		}
 
+		/* bad inodes are dealt with elsewhere */
 		if (VN_BAD(vp)) {
-			ip = ip->i_mnext;
+			read_unlock(&pag->pag_ici_lock);
 			continue;
 		}
 
+		/* nothing to sync during shutdown */
 		if (XFS_FORCED_SHUTDOWN(mp) && !(flags & SYNC_CLOSE)) {
-			XFS_MOUNT_IUNLOCK(mp);
-			kmem_free(ipointer);
+			read_unlock(&pag->pag_ici_lock);
 			return 0;
 		}
 
 		/*
-		 * Try to lock without sleeping.  We're out of order with
-		 * the inode list lock here, so if we fail we need to drop
-		 * the mount lock and try again.  If we're called from
-		 * bdflush() here, then don't bother.
-		 *
-		 * The inode lock here actually coordinates with the
-		 * almost spurious inode lock in xfs_ireclaim() to prevent
-		 * the vnode we handle here without a reference from
-		 * being freed while we reference it.  If we lock the inode
-		 * while it's on the mount list here, then the spurious inode
-		 * lock in xfs_ireclaim() after the inode is pulled from
-		 * the mount list will sleep until we release it here.
-		 * This keeps the vnode from being freed while we reference
-		 * it.
+		 * The inode lock here actually coordinates with the almost
+		 * spurious inode lock in xfs_ireclaim() to prevent the vnode
+		 * we handle here without a reference from being freed while we
+		 * reference it.  If we lock the inode while it's on the mount
+		 * list here, then the spurious inode lock in xfs_ireclaim()
+		 * after the inode is pulled from the mount list will sleep
+		 * until we release it here.  This keeps the vnode from being
+		 * freed while we reference it.
 		 */
 		if (xfs_ilock_nowait(ip, lock_flags) == 0) {
-			if (vp == NULL) {
-				ip = ip->i_mnext;
-				continue;
-			}
-
 			vp = vn_grab(vp);
-			if (vp == NULL) {
-				ip = ip->i_mnext;
+			read_unlock(&pag->pag_ici_lock);
+			if (!vp)
 				continue;
-			}
-
-			IPOINTER_INSERT(ip, mp);
 			xfs_ilock(ip, lock_flags);
 
 			ASSERT(vp == VFS_I(ip));
 			ASSERT(ip->i_mount == mp);
 
 			vnode_refed = B_TRUE;
+		} else {
+			/* safe to unlock here as we have a reference */
+			read_unlock(&pag->pag_ici_lock);
 		}
-
-		/* From here on in the loop we may have a marker record
-		 * in the inode list.
-		 */
-
 		/*
 		 * If we have to flush data or wait for I/O completion
 		 * we need to drop the ilock that we currently hold.
 		 * If we need to drop the lock, insert a marker if we
 		 * have not already done so.
 		 */
-		if ((flags & (SYNC_CLOSE|SYNC_IOWAIT)) ||
-		    ((flags & SYNC_DELWRI) && VN_DIRTY(vp))) {
-			if (mount_locked) {
-				IPOINTER_INSERT(ip, mp);
-			}
+		if (flags & SYNC_CLOSE) {
 			xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-			if (flags & SYNC_CLOSE) {
-				/* Shutdown case. Flush and invalidate. */
-				if (XFS_FORCED_SHUTDOWN(mp))
-					xfs_tosspages(ip, 0, -1,
-							     FI_REMAPF);
-				else
-					error = xfs_flushinval_pages(ip,
-							0, -1, FI_REMAPF);
-			} else if ((flags & SYNC_DELWRI) && VN_DIRTY(vp)) {
-				error = xfs_flush_pages(ip, 0,
-							-1, fflag, FI_NONE);
-			}
-
-			/*
-			 * When freezing, we need to wait ensure all I/O (including direct
-			 * I/O) is complete to ensure no further data modification can take
-			 * place after this point
-			 */
+			if (XFS_FORCED_SHUTDOWN(mp))
+				xfs_tosspages(ip, 0, -1, FI_REMAPF);
+			else
+				error = xfs_flushinval_pages(ip, 0, -1,
+							FI_REMAPF);
+			/* wait for I/O on freeze */
 			if (flags & SYNC_IOWAIT)
 				vn_iowait(ip);
 
 			xfs_ilock(ip, XFS_ILOCK_SHARED);
 		}
 
-		if ((flags & SYNC_ATTR) &&
-		    (ip->i_update_core ||
-		     (ip->i_itemp && ip->i_itemp->ili_format.ilf_fields))) {
-			if (mount_locked)
-				IPOINTER_INSERT(ip, mp);
+		if ((flags & SYNC_DELWRI) && VN_DIRTY(vp)) {
+			xfs_iunlock(ip, XFS_ILOCK_SHARED);
+			error = xfs_flush_pages(ip, 0, -1, fflag, FI_NONE);
+			if (flags & SYNC_IOWAIT)
+				vn_iowait(ip);
+			xfs_ilock(ip, XFS_ILOCK_SHARED);
+		}
 
+		if ((flags & SYNC_ATTR) && !xfs_inode_clean(ip)) {
 			if (flags & SYNC_WAIT) {
 				xfs_iflock(ip);
-				error = xfs_iflush(ip, XFS_IFLUSH_SYNC);
-
-			/*
-			 * If we can't acquire the flush lock, then the inode
-			 * is already being flushed so don't bother waiting.
-			 *
-			 * If we can lock it then do a delwri flush so we can
-			 * combine multiple inode flushes in each disk write.
-			 */
+				if (!xfs_inode_clean(ip))
+					error = xfs_iflush(ip, XFS_IFLUSH_SYNC);
+				else
+					xfs_ifunlock(ip);
 			} else if (xfs_iflock_nowait(ip)) {
-				error = xfs_iflush(ip, XFS_IFLUSH_DELWRI);
+				if (!xfs_inode_clean(ip))
+					error = xfs_iflush(ip, XFS_IFLUSH_DELWRI);
+				else
+					xfs_ifunlock(ip);
 			} else if (bypassed) {
 				(*bypassed)++;
 			}
 		}
 
-		if (lock_flags != 0) {
+		if (lock_flags)
 			xfs_iunlock(ip, lock_flags);
-		}
 
 		if (vnode_refed) {
-			/*
-			 * If we had to take a reference on the vnode
-			 * above, then wait until after we've unlocked
-			 * the inode to release the reference.  This is
-			 * because we can be already holding the inode
-			 * lock when IRELE() calls xfs_inactive().
-			 *
-			 * Make sure to drop the mount lock before calling
-			 * IRELE() so that we don't trip over ourselves if
-			 * we have to go for the mount lock again in the
-			 * inactive code.
-			 */
-			if (mount_locked) {
-				IPOINTER_INSERT(ip, mp);
-			}
-
 			IRELE(ip);
-
 			vnode_refed = B_FALSE;
 		}
 
-		if (error) {
+		if (error)
 			last_error = error;
-		}
-
 		/*
 		 * bail out if the filesystem is corrupted.
 		 */
-		if (error == EFSCORRUPTED)  {
-			if (!mount_locked) {
-				XFS_MOUNT_ILOCK(mp);
-				IPOINTER_REMOVE(ip, mp);
-			}
-			XFS_MOUNT_IUNLOCK(mp);
-			ASSERT(ipointer_in == B_FALSE);
-			kmem_free(ipointer);
+		if (error == EFSCORRUPTED)
 			return XFS_ERROR(error);
-		}
-
-		/* Let other threads have a chance at the mount lock
-		 * if we have looped many times without dropping the
-		 * lock.
-		 */
-		if ((++preempt & XFS_PREEMPT_MASK) == 0) {
-			if (mount_locked) {
-				IPOINTER_INSERT(ip, mp);
-			}
-		}
-
-		if (mount_locked == B_FALSE) {
-			XFS_MOUNT_ILOCK(mp);
-			mount_locked = B_TRUE;
-			IPOINTER_REMOVE(ip, mp);
-			continue;
-		}
 
-		ASSERT(ipointer_in == B_FALSE);
-		ip = ip->i_mnext;
+	} while (nr_found);
 
-	} while (ip != mp->m_inodes);
+	return last_error;
+}
 
-	XFS_MOUNT_IUNLOCK(mp);
+int
+xfs_sync_inodes(
+	xfs_mount_t	*mp,
+	int		flags,
+	int             *bypassed)
+{
+	int		error;
+	int		last_error;
+	int		i;
 
-	ASSERT(ipointer_in == B_FALSE);
+	if (bypassed)
+		*bypassed = 0;
+	if (mp->m_flags & XFS_MOUNT_RDONLY)
+		return 0;
+	error = 0;
+	last_error = 0;
 
-	kmem_free(ipointer);
+	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+		if (!mp->m_perag[i].pag_ici_init)
+			continue;
+		error = xfs_sync_inodes_ag(mp, i, flags, bypassed);
+		if (error)
+			last_error = error;
+		if (error == EFSCORRUPTED)
+			break;
+	}
 	return XFS_ERROR(last_error);
 }
 
-- 
1.5.6.5
