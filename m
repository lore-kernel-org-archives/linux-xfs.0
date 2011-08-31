Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7VKcMqH226715 for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 15:38:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B390212A5DB
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 13:38:20 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	OS2SLzGJAhWdXX1k for <xfs@oss.sgi.com>;
	Wed, 31 Aug 2011 13:38:20 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QyrYB-00071T-Pr
	for xfs@oss.sgi.com; Wed, 31 Aug 2011 20:38:19 +0000
Message-Id: <20110831203819.747312972@bombadil.infradead.org>
Date: Wed, 31 Aug 2011 16:36:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/14] xfs: flatten the dquot lock ordering
References: <20110831203647.455809764@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-add-DQ_FREEING
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

Introduce a new XFS_DQ_FREEING flag that tells lookup and mplist walks
to skip a dquot that is beeing freed, and use this avoid the trylock
on the hash and mplist locks in xfs_qm_dqreclaim_one.  Also simplify
xfs_dqpurge by moving the inodes to a dispose list after marking them
XFS_DQ_FREEING and avoid the locker ordering constraints.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-08-31 09:59:29.113124748 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2011-08-31 10:17:41.829108522 +0200
@@ -725,6 +725,12 @@ xfs_qm_dqlookup(
 		trace_xfs_dqlookup_found(dqp);
 
 		xfs_dqlock(dqp);
+		if (dqp->dq_flags & XFS_DQ_FREEING) {
+			*O_dqpp = NULL;
+			xfs_dqunlock(dqp);
+			return -1;
+		}
+
 		XFS_DQHOLD(dqp);
 
 		/*
@@ -778,11 +784,7 @@ xfs_qm_dqget(
 			return (EIO);
 		}
 	}
-#endif
 
- again:
-
-#ifdef DEBUG
 	ASSERT(type == XFS_DQ_USER ||
 	       type == XFS_DQ_PROJ ||
 	       type == XFS_DQ_GROUP);
@@ -794,13 +796,20 @@ xfs_qm_dqget(
 			ASSERT(ip->i_gdquot == NULL);
 	}
 #endif
+
+restart:
 	mutex_lock(&h->qh_lock);
 
 	/*
 	 * Look in the cache (hashtable).
 	 * The chain is kept locked during lookup.
 	 */
-	if (xfs_qm_dqlookup(mp, id, h, O_dqpp) == 0) {
+	switch (xfs_qm_dqlookup(mp, id, h, O_dqpp)) {
+	case -1:
+		mutex_unlock(&h->qh_lock);
+		delay(1);
+		goto restart;
+	case 0:
 		XQM_STATS_INC(xqmstats.xs_qm_dqcachehits);
 		/*
 		 * The dquot was found, moved to the front of the chain,
@@ -811,7 +820,9 @@ xfs_qm_dqget(
 		ASSERT(XFS_DQ_IS_LOCKED(*O_dqpp));
 		mutex_unlock(&h->qh_lock);
 		trace_xfs_dqget_hit(*O_dqpp);
-		return (0);	/* success */
+		return 0;	/* success */
+	default:
+		break;
 	}
 	XQM_STATS_INC(xqmstats.xs_qm_dqcachemisses);
 
@@ -910,16 +921,21 @@ xfs_qm_dqget(
 		 * lock order between the two dquots here since dqp isn't
 		 * on any findable lists yet.
 		 */
-		if (xfs_qm_dqlookup(mp, id, h, &tmpdqp) == 0) {
+		switch (xfs_qm_dqlookup(mp, id, h, &tmpdqp)) {
+		case 0:
+		case -1:
 			/*
-			 * Duplicate found. Just throw away the new dquot
-			 * and start over.
+			 * Duplicate found, either in cache or on its way out.
+			 * Just throw away the new dquot and start over.
 			 */
-			xfs_qm_dqput(tmpdqp);
+			if (tmpdqp)
+				xfs_qm_dqput(tmpdqp);
 			mutex_unlock(&h->qh_lock);
 			xfs_qm_dqdestroy(dqp);
 			XQM_STATS_INC(xqmstats.xs_qm_dquot_dups);
-			goto again;
+			goto restart;
+		default:
+			break;
 		}
 	}
 
@@ -1247,51 +1263,18 @@ xfs_dqlock2(
 	}
 }
 
-
 /*
- * Take a dquot out of the mount's dqlist as well as the hashlist.
- * This is called via unmount as well as quotaoff, and the purge
- * will always succeed unless there are soft (temp) references
- * outstanding.
- *
- * This returns 0 if it was purged, 1 if it wasn't. It's not an error code
- * that we're returning! XXXsup - not cool.
+ * Take a dquot out of the mount's dqlist as well as the hashlist.  This is
+ * called via unmount as well as quotaoff, and the purge will always succeed.
  */
-/* ARGSUSED */
-int
+void
 xfs_qm_dqpurge(
-	xfs_dquot_t	*dqp)
+	struct xfs_dquot	*dqp)
 {
-	xfs_dqhash_t	*qh = dqp->q_hash;
-	xfs_mount_t	*mp = dqp->q_mount;
-
-	ASSERT(mutex_is_locked(&mp->m_quotainfo->qi_dqlist_lock));
-	ASSERT(mutex_is_locked(&dqp->q_hash->qh_lock));
-
-	/*
-	 * XXX(hch): horrible locking order, will get cleaned up ASAP.
-	 */
-	if (!mutex_trylock(&xfs_Gqm->qm_dqfrlist_lock)) {
-		mutex_unlock(&dqp->q_hash->qh_lock);
-		return 1;
-	}
+	struct xfs_mount	*mp = dqp->q_mount;
+	struct xfs_dqhash	*qh = dqp->q_hash;
 
 	xfs_dqlock(dqp);
-	/*
-	 * We really can't afford to purge a dquot that is
-	 * referenced, because these are hard refs.
-	 * It shouldn't happen in general because we went thru _all_ inodes in
-	 * dqrele_all_inodes before calling this and didn't let the mountlock go.
-	 * However it is possible that we have dquots with temporary
-	 * references that are not attached to an inode. e.g. see xfs_setattr().
-	 */
-	if (dqp->q_nrefs != 0) {
-		xfs_dqunlock(dqp);
-		mutex_unlock(&dqp->q_hash->qh_lock);
-		return (1);
-	}
-
-	ASSERT(!list_empty(&dqp->q_freelist));
 
 	/*
 	 * If we're turning off quotas, we have to make sure that, for
@@ -1310,19 +1293,14 @@ xfs_qm_dqpurge(
 	}
 
 	/*
-	 * XXXIf we're turning this type of quotas off, we don't care
+	 * If we are turning this type of quotas off, we don't care
 	 * about the dirty metadata sitting in this dquot. OTOH, if
 	 * we're unmounting, we do care, so we flush it and wait.
 	 */
 	if (XFS_DQ_IS_DIRTY(dqp)) {
 		int	error;
 
-		/* dqflush unlocks dqflock */
 		/*
-		 * Given that dqpurge is a very rare occurrence, it is OK
-		 * that we're holding the hashlist and mplist locks
-		 * across the disk write. But, ... XXXsup
-		 *
 		 * We don't care about getting disk errors here. We need
 		 * to purge this dquot anyway, so we go ahead regardless.
 		 */
@@ -1332,31 +1310,34 @@ xfs_qm_dqpurge(
 				__func__, dqp);
 		xfs_dqflock(dqp);
 	}
+
 	ASSERT(atomic_read(&dqp->q_pincount) == 0);
 	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
 	       !(dqp->q_logitem.qli_item.li_flags & XFS_LI_IN_AIL));
 
+	xfs_dqfunlock(dqp);
+	xfs_dqunlock(dqp);
+
+	mutex_lock(&qh->qh_lock);
 	list_del_init(&dqp->q_hashlist);
 	qh->qh_version++;
+	mutex_unlock(&qh->qh_lock);
 
+	mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
 	list_del_init(&dqp->q_mplist);
 	mp->m_quotainfo->qi_dqreclaims++;
 	mp->m_quotainfo->qi_dquots--;
+	mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
 
+	mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
+	ASSERT(!list_empty(&dqp->q_freelist));
 	list_del_init(&dqp->q_freelist);
 	xfs_Gqm->qm_dqfrlist_cnt--;
-
-	xfs_dqfunlock(dqp);
-	xfs_dqunlock(dqp);
-
 	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
-	mutex_unlock(&qh->qh_lock);
 
 	xfs_qm_dqdestroy(dqp);
-	return (0);
 }
 
-
 /*
  * Give the buffer a little push if it is incore and
  * wait on the flush lock.
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-08-31 09:59:29.125109545 +0200
+++ xfs/fs/xfs/xfs_qm.c	2011-08-31 10:20:16.401169019 +0200
@@ -399,7 +399,8 @@ again:
 	mutex_lock(&q->qi_dqlist_lock);
 	list_for_each_entry(dqp, &q->qi_dqlist, q_mplist) {
 		xfs_dqlock(dqp);
-		if (! XFS_DQ_IS_DIRTY(dqp)) {
+		if ((dqp->dq_flags & XFS_DQ_FREEING) ||
+		    !XFS_DQ_IS_DIRTY(dqp)) {
 			xfs_dqunlock(dqp);
 			continue;
 		}
@@ -438,6 +439,7 @@ again:
 	/* return ! busy */
 	return 0;
 }
+
 /*
  * Release the group dquot pointers the user dquots may be
  * carrying around as a hint. mplist is locked on entry and exit.
@@ -454,6 +456,13 @@ xfs_qm_detach_gdquots(
 	ASSERT(mutex_is_locked(&q->qi_dqlist_lock));
 	list_for_each_entry(dqp, &q->qi_dqlist, q_mplist) {
 		xfs_dqlock(dqp);
+		if (dqp->dq_flags & XFS_DQ_FREEING) {
+			xfs_dqunlock(dqp);
+			mutex_unlock(&q->qi_dqlist_lock);
+			delay(1);
+			mutex_lock(&q->qi_dqlist_lock);
+			goto again;
+		}
 		if ((gdqp = dqp->q_gdquot)) {
 			xfs_dqlock(gdqp);
 			dqp->q_gdquot = NULL;
@@ -490,8 +499,8 @@ xfs_qm_dqpurge_int(
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	struct xfs_dquot	*dqp, *n;
 	uint			dqtype;
-	int			nrecl;
-	int			nmisses;
+	int			nmisses = 0;
+	LIST_HEAD		(dispose_list);
 
 	if (!q)
 		return 0;
@@ -510,46 +519,27 @@ xfs_qm_dqpurge_int(
 	 */
 	xfs_qm_detach_gdquots(mp);
 
-      again:
-	nmisses = 0;
-	ASSERT(mutex_is_locked(&q->qi_dqlist_lock));
 	/*
 	 * Try to get rid of all of the unwanted dquots. The idea is to
 	 * get them off mplist and hashlist, but leave them on freelist.
 	 */
 	list_for_each_entry_safe(dqp, n, &q->qi_dqlist, q_mplist) {
 		xfs_dqlock(dqp);
-		if ((dqp->dq_flags & dqtype) == 0) {
-			xfs_dqunlock(dqp);
-			continue;
+		if ((dqp->dq_flags & dqtype) != 0 &&
+		    !(dqp->dq_flags & XFS_DQ_FREEING)) {
+			if (dqp->q_nrefs == 0) {
+				dqp->dq_flags |= XFS_DQ_FREEING;
+				list_move_tail(&dqp->q_mplist, &dispose_list);
+			} else
+				nmisses++;
 		}
 		xfs_dqunlock(dqp);
-
-		if (!mutex_trylock(&dqp->q_hash->qh_lock)) {
-			nrecl = q->qi_dqreclaims;
-			mutex_unlock(&q->qi_dqlist_lock);
-			mutex_lock(&dqp->q_hash->qh_lock);
-			mutex_lock(&q->qi_dqlist_lock);
-
-			/*
-			 * XXXTheoretically, we can get into a very long
-			 * ping pong game here.
-			 * No one can be adding dquots to the mplist at
-			 * this point, but somebody might be taking things off.
-			 */
-			if (nrecl != q->qi_dqreclaims) {
-				mutex_unlock(&dqp->q_hash->qh_lock);
-				goto again;
-			}
-		}
-
-		/*
-		 * Take the dquot off the mplist and hashlist. It may remain on
-		 * freelist in INACTIVE state.
-		 */
-		nmisses += xfs_qm_dqpurge(dqp);
 	}
 	mutex_unlock(&q->qi_dqlist_lock);
+
+	list_for_each_entry_safe(dqp, n, &dispose_list, q_mplist)
+		xfs_qm_dqpurge(dqp);
+
 	return nmisses;
 }
 
@@ -1667,25 +1657,16 @@ xfs_qm_init_quotainos(
 
 
 /*
- * Just pop the least recently used dquot off the freelist and
- * recycle it. The returned dquot is locked.
+ * Pop the least recently used dquot off the freelist and recycle it.
  */
-STATIC xfs_dquot_t *
+STATIC struct xfs_dquot *
 xfs_qm_dqreclaim_one(void)
 {
-	xfs_dquot_t	*dqpout;
-	xfs_dquot_t	*dqp;
-	int		restarts;
-	int		startagain;
-
-	restarts = 0;
-	dqpout = NULL;
+	struct xfs_dquot	*dqp;
+	int			restarts = 0;
 
-	/* lockorder: hashchainlock, freelistlock, mplistlock, dqlock, dqflock */
-again:
-	startagain = 0;
 	mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
-
+restart:
 	list_for_each_entry(dqp, &xfs_Gqm->qm_dqfrlist, q_freelist) {
 		struct xfs_mount *mp = dqp->q_mount;
 		xfs_dqlock(dqp);
@@ -1701,7 +1682,6 @@ again:
 			list_del_init(&dqp->q_freelist);
 			xfs_Gqm->qm_dqfrlist_cnt--;
 			restarts++;
-			startagain = 1;
 			goto dqunlock;
 		}
 
@@ -1737,57 +1717,40 @@ again:
 			}
 			goto dqunlock;
 		}
+		xfs_dqfunlock(dqp);
 
 		/*
-		 * We're trying to get the hashlock out of order. This races
-		 * with dqlookup; so, we giveup and goto the next dquot if
-		 * we couldn't get the hashlock. This way, we won't starve
-		 * a dqlookup process that holds the hashlock that is
-		 * waiting for the freelist lock.
+		 * Prevent lookups now that we are past the point of no return.
 		 */
-		if (!mutex_trylock(&dqp->q_hash->qh_lock)) {
-			restarts++;
-			goto dqfunlock;
-		}
+		dqp->dq_flags |= XFS_DQ_FREEING;
+		xfs_dqunlock(dqp);
 
-		/*
-		 * This races with dquot allocation code as well as dqflush_all
-		 * and reclaim code. So, if we failed to grab the mplist lock,
-		 * giveup everything and start over.
-		 */
-		if (!mutex_trylock(&mp->m_quotainfo->qi_dqlist_lock)) {
-			restarts++;
-			startagain = 1;
-			goto qhunlock;
-		}
+		mutex_lock(&dqp->q_hash->qh_lock);
+		list_del_init(&dqp->q_hashlist);
+		dqp->q_hash->qh_version++;
+		mutex_unlock(&dqp->q_hash->qh_lock);
 
-		ASSERT(dqp->q_nrefs == 0);
+		mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
 		list_del_init(&dqp->q_mplist);
 		mp->m_quotainfo->qi_dquots--;
 		mp->m_quotainfo->qi_dqreclaims++;
-		list_del_init(&dqp->q_hashlist);
-		dqp->q_hash->qh_version++;
+		mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
+
+		ASSERT(dqp->q_nrefs == 0);
 		list_del_init(&dqp->q_freelist);
 		xfs_Gqm->qm_dqfrlist_cnt--;
-		dqpout = dqp;
-		mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
-qhunlock:
-		mutex_unlock(&dqp->q_hash->qh_lock);
-dqfunlock:
-		xfs_dqfunlock(dqp);
+
+		mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
+		return dqp;
 dqunlock:
 		xfs_dqunlock(dqp);
-		if (dqpout)
-			break;
 		if (restarts >= XFS_QM_RECLAIM_MAX_RESTARTS)
 			break;
-		if (startagain) {
-			mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
-			goto again;
-		}
+		goto restart;
 	}
+
 	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
-	return dqpout;
+	return NULL;
 }
 
 /*
Index: xfs/fs/xfs/xfs_quota.h
===================================================================
--- xfs.orig/fs/xfs/xfs_quota.h	2011-08-31 09:59:29.137109656 +0200
+++ xfs/fs/xfs/xfs_quota.h	2011-08-31 09:59:36.390624338 +0200
@@ -87,6 +87,7 @@ typedef struct xfs_dqblk {
 #define XFS_DQ_PROJ		0x0002		/* project quota */
 #define XFS_DQ_GROUP		0x0004		/* a group quota */
 #define XFS_DQ_DIRTY		0x0008		/* dquot is dirty */
+#define XFS_DQ_FREEING		0x0010		/* dquot is beeing torn down */
 
 #define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
 
@@ -94,7 +95,8 @@ typedef struct xfs_dqblk {
 	{ XFS_DQ_USER,		"USER" }, \
 	{ XFS_DQ_PROJ,		"PROJ" }, \
 	{ XFS_DQ_GROUP,		"GROUP" }, \
-	{ XFS_DQ_DIRTY,		"DIRTY" }
+	{ XFS_DQ_DIRTY,		"DIRTY" }, \
+	{ XFS_DQ_FREEING,	"FREEING" }
 
 /*
  * In the worst case, when both user and group quotas are on,
Index: xfs/fs/xfs/xfs_dquot.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.h	2011-08-31 10:00:50.205109260 +0200
+++ xfs/fs/xfs/xfs_dquot.h	2011-08-31 10:00:56.121136726 +0200
@@ -133,7 +133,7 @@ static inline void xfs_dqunlock_nonotify
 
 extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
 extern int		xfs_qm_dqflush(xfs_dquot_t *, uint);
-extern int		xfs_qm_dqpurge(xfs_dquot_t *);
+extern void		xfs_qm_dqpurge(xfs_dquot_t *);
 extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
 extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *,
 					xfs_disk_dquot_t *);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
