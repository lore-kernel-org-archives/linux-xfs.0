Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAS8Sch3225889 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 02:28:38 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9BDEF16E1BB1
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 00:28:37 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	MYKvQP9Mavx8C9E9 for <xfs@oss.sgi.com>;
	Mon, 28 Nov 2011 00:28:37 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RUwZo-0000uW-NZ
	for xfs@oss.sgi.com; Mon, 28 Nov 2011 08:28:36 +0000
Message-Id: <20111128082836.676707771@bombadil.infradead.org>
Date: Mon, 28 Nov 2011 03:27:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/16] xfs: remove xfs_qm_sync
References: <20111128082722.604873274@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-remove-xfs_qm_sync
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

Now that we can't have any dirty dquots around that aren't in the AIL we
can get rid of the explicit dquot syncing from xfssyncd and xfs_fs_sync_fs.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_qm.c    |   94 -----------------------------------------------------
 fs/xfs/xfs_qm.h    |    6 ---
 fs/xfs/xfs_quota.h |    5 --
 fs/xfs/xfs_super.c |   11 +-----
 fs/xfs/xfs_sync.c  |    6 ---
 5 files changed, 3 insertions(+), 119 deletions(-)

Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-11-25 11:45:35.875391556 +0100
+++ xfs/fs/xfs/xfs_qm.c	2011-11-25 11:45:37.468716258 +0100
@@ -879,100 +879,6 @@ xfs_qm_dqdetach(
 	}
 }
 
-int
-xfs_qm_sync(
-	struct xfs_mount	*mp,
-	int			flags)
-{
-	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	int			recl, restarts;
-	struct xfs_dquot	*dqp;
-	int			error;
-
-	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
-		return 0;
-
-	restarts = 0;
-
-  again:
-	mutex_lock(&q->qi_dqlist_lock);
-	/*
-	 * dqpurge_all() also takes the mplist lock and iterate thru all dquots
-	 * in quotaoff. However, if the QUOTA_ACTIVE bits are not cleared
-	 * when we have the mplist lock, we know that dquots will be consistent
-	 * as long as we have it locked.
-	 */
-	if (!XFS_IS_QUOTA_ON(mp)) {
-		mutex_unlock(&q->qi_dqlist_lock);
-		return 0;
-	}
-	ASSERT(mutex_is_locked(&q->qi_dqlist_lock));
-	list_for_each_entry(dqp, &q->qi_dqlist, q_mplist) {
-		/*
-		 * If this is vfs_sync calling, then skip the dquots that
-		 * don't 'seem' to be dirty. ie. don't acquire dqlock.
-		 * This is very similar to what xfs_sync does with inodes.
-		 */
-		if (flags & SYNC_TRYLOCK) {
-			if (!XFS_DQ_IS_DIRTY(dqp))
-				continue;
-			if (!xfs_qm_dqlock_nowait(dqp))
-				continue;
-		} else {
-			xfs_dqlock(dqp);
-		}
-
-		/*
-		 * Now, find out for sure if this dquot is dirty or not.
-		 */
-		if (! XFS_DQ_IS_DIRTY(dqp)) {
-			xfs_dqunlock(dqp);
-			continue;
-		}
-
-		/* XXX a sentinel would be better */
-		recl = q->qi_dqreclaims;
-		if (!xfs_dqflock_nowait(dqp)) {
-			if (flags & SYNC_TRYLOCK) {
-				xfs_dqunlock(dqp);
-				continue;
-			}
-			/*
-			 * If we can't grab the flush lock then if the caller
-			 * really wanted us to give this our best shot, so
-			 * see if we can give a push to the buffer before we wait
-			 * on the flush lock. At this point, we know that
-			 * even though the dquot is being flushed,
-			 * it has (new) dirty data.
-			 */
-			xfs_qm_dqflock_pushbuf_wait(dqp);
-		}
-		/*
-		 * Let go of the mplist lock. We don't want to hold it
-		 * across a disk write
-		 */
-		mutex_unlock(&q->qi_dqlist_lock);
-		error = xfs_qm_dqflush(dqp, flags);
-		xfs_dqunlock(dqp);
-		if (error && XFS_FORCED_SHUTDOWN(mp))
-			return 0;	/* Need to prevent umount failure */
-		else if (error)
-			return error;
-
-		mutex_lock(&q->qi_dqlist_lock);
-		if (recl != q->qi_dqreclaims) {
-			if (++restarts >= XFS_QM_SYNC_MAX_RESTARTS)
-				break;
-
-			mutex_unlock(&q->qi_dqlist_lock);
-			goto again;
-		}
-	}
-
-	mutex_unlock(&q->qi_dqlist_lock);
-	return 0;
-}
-
 /*
  * The hash chains and the mplist use the same xfs_dqhash structure as
  * their list head, but we can take the mplist qh_lock and one of the
Index: xfs/fs/xfs/xfs_qm.h
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.h	2011-11-05 08:54:00.740993267 +0100
+++ xfs/fs/xfs/xfs_qm.h	2011-11-25 11:45:37.468716258 +0100
@@ -33,12 +33,6 @@ extern kmem_zone_t	*qm_dqzone;
 extern kmem_zone_t	*qm_dqtrxzone;
 
 /*
- * Used in xfs_qm_sync called by xfs_sync to count the max times that it can
- * iterate over the mountpt's dquot list in one call.
- */
-#define XFS_QM_SYNC_MAX_RESTARTS	7
-
-/*
  * Ditto, for xfs_qm_dqreclaim_one.
  */
 #define XFS_QM_RECLAIM_MAX_RESTARTS	4
Index: xfs/fs/xfs/xfs_quota.h
===================================================================
--- xfs.orig/fs/xfs/xfs_quota.h	2011-11-05 08:54:00.748995021 +0100
+++ xfs/fs/xfs/xfs_quota.h	2011-11-25 11:45:37.468716258 +0100
@@ -326,7 +326,6 @@ extern int xfs_qm_dqattach_locked(struct
 extern void xfs_qm_dqdetach(struct xfs_inode *);
 extern void xfs_qm_dqrele(struct xfs_dquot *);
 extern void xfs_qm_statvfs(struct xfs_inode *, struct kstatfs *);
-extern int xfs_qm_sync(struct xfs_mount *, int);
 extern int xfs_qm_newmount(struct xfs_mount *, uint *, uint *);
 extern void xfs_qm_mount_quotas(struct xfs_mount *);
 extern void xfs_qm_unmount(struct xfs_mount *);
@@ -366,10 +365,6 @@ static inline int xfs_trans_reserve_quot
 #define xfs_qm_dqdetach(ip)
 #define xfs_qm_dqrele(d)
 #define xfs_qm_statvfs(ip, s)
-static inline int xfs_qm_sync(struct xfs_mount *mp, int flags)
-{
-	return 0;
-}
 #define xfs_qm_newmount(mp, a, b)					(0)
 #define xfs_qm_mount_quotas(mp)
 #define xfs_qm_unmount(mp)
Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c	2011-11-25 11:43:20.222793115 +0100
+++ xfs/fs/xfs/xfs_super.c	2011-11-25 11:45:37.472049573 +0100
@@ -1025,17 +1025,10 @@ xfs_fs_sync_fs(
 	int			error;
 
 	/*
-	 * Not much we can do for the first async pass.  Writing out the
-	 * superblock would be counter-productive as we are going to redirty
-	 * when writing out other data and metadata (and writing out a single
-	 * block is quite fast anyway).
-	 *
-	 * Try to asynchronously kick off quota syncing at least.
+	 * Doing anything during the async pass would be counterproductive.
 	 */
-	if (!wait) {
-		xfs_qm_sync(mp, SYNC_TRYLOCK);
+	if (!wait)
 		return 0;
-	}
 
 	error = xfs_quiesce_data(mp);
 	if (error)
Index: xfs/fs/xfs/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.c	2011-11-24 13:44:18.138524837 +0100
+++ xfs/fs/xfs/xfs_sync.c	2011-11-25 11:45:37.472049573 +0100
@@ -359,10 +359,7 @@ xfs_quiesce_data(
 {
 	int			error, error2 = 0;
 
-	xfs_qm_sync(mp, SYNC_TRYLOCK);
-	xfs_qm_sync(mp, SYNC_WAIT);
-
-	/* force out the newly dirtied log buffers */
+	/* force out the log */
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
 	/* write superblock and hoover up shutdown errors */
@@ -470,7 +467,6 @@ xfs_sync_worker(
 			error = xfs_fs_log_dummy(mp);
 		else
 			xfs_log_force(mp, 0);
-		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
 
 		/* start pushing all the metadata that is currently dirty */
 		xfs_ail_push_all(mp->m_ail);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
