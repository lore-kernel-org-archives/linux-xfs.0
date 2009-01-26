Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q7Wkww203757 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:32:47 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C889185E916
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:04 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id vGGEEHN5XA4xt6Hl for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:04 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LRLwx-00039t-Qd
	for xfs@oss.sgi.com; Mon, 26 Jan 2009 07:32:03 +0000
Message-Id: <20090126073203.727645000@bombadil.infradead.org>
Date: Mon, 26 Jan 2009 02:31:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 17/17] xfs: sanitize qh_lock wrappers
References: <20090126073136.384490000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-remove-qh_lock-wrappers
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

Get rid of various obsfucating wrappers for accessing the quota hash lock,
we only keep the accessors for accessing the mplist and freelist locks as
they encode a multi-level datastructure walk.  But make sure all of them
are defined in the same way as simple macros.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.c	2009-01-21 21:03:27.832295131 +0100
+++ xfs/fs/xfs/quota/xfs_dquot.c	2009-01-24 18:59:09.587428189 +0100
@@ -804,7 +804,7 @@ xfs_qm_dqlookup(
 	uint			flist_locked;
 	xfs_dquot_t		*d;
 
-	ASSERT(XFS_DQ_IS_HASH_LOCKED(qh));
+	ASSERT(mutex_is_locked(&qh->qh_lock));
 
 	flist_locked = B_FALSE;
 
@@ -877,7 +877,7 @@ xfs_qm_dqlookup(
 			/*
 			 * move the dquot to the front of the hashchain
 			 */
-			ASSERT(XFS_DQ_IS_HASH_LOCKED(qh));
+			ASSERT(mutex_is_locked(&qh->qh_lock));
 			if (dqp->HL_PREVP != &qh->qh_next) {
 				xfs_dqtrace_entry(dqp,
 						  "DQLOOKUP: HASH MOVETOFRONT");
@@ -892,13 +892,13 @@ xfs_qm_dqlookup(
 			}
 			xfs_dqtrace_entry(dqp, "LOOKUP END");
 			*O_dqpp = dqp;
-			ASSERT(XFS_DQ_IS_HASH_LOCKED(qh));
+			ASSERT(mutex_is_locked(&qh->qh_lock));
 			return (0);
 		}
 	}
 
 	*O_dqpp = NULL;
-	ASSERT(XFS_DQ_IS_HASH_LOCKED(qh));
+	ASSERT(mutex_is_locked(&qh->qh_lock));
 	return (1);
 }
 
@@ -956,7 +956,7 @@ xfs_qm_dqget(
 			ASSERT(ip->i_gdquot == NULL);
 	}
 #endif
-	XFS_DQ_HASH_LOCK(h);
+	mutex_lock(&h->qh_lock);
 
 	/*
 	 * Look in the cache (hashtable).
@@ -971,7 +971,7 @@ xfs_qm_dqget(
 		 */
 		ASSERT(*O_dqpp);
 		ASSERT(XFS_DQ_IS_LOCKED(*O_dqpp));
-		XFS_DQ_HASH_UNLOCK(h);
+		mutex_unlock(&h->qh_lock);
 		xfs_dqtrace_entry(*O_dqpp, "DQGET DONE (FROM CACHE)");
 		return (0);	/* success */
 	}
@@ -991,7 +991,7 @@ xfs_qm_dqget(
 	 * we don't keep the lock across a disk read
 	 */
 	version = h->qh_version;
-	XFS_DQ_HASH_UNLOCK(h);
+	mutex_unlock(&h->qh_lock);
 
 	/*
 	 * Allocate the dquot on the kernel heap, and read the ondisk
@@ -1056,7 +1056,7 @@ xfs_qm_dqget(
 	/*
 	 * Hashlock comes after ilock in lock order
 	 */
-	XFS_DQ_HASH_LOCK(h);
+	mutex_lock(&h->qh_lock);
 	if (version != h->qh_version) {
 		xfs_dquot_t *tmpdqp;
 		/*
@@ -1072,7 +1072,7 @@ xfs_qm_dqget(
 			 * and start over.
 			 */
 			xfs_qm_dqput(tmpdqp);
-			XFS_DQ_HASH_UNLOCK(h);
+			mutex_unlock(&h->qh_lock);
 			xfs_qm_dqdestroy(dqp);
 			XQM_STATS_INC(xqmstats.xs_qm_dquot_dups);
 			goto again;
@@ -1083,7 +1083,7 @@ xfs_qm_dqget(
 	 * Put the dquot at the beginning of the hash-chain and mp's list
 	 * LOCK ORDER: hashlock, freelistlock, mplistlock, udqlock, gdqlock ..
 	 */
-	ASSERT(XFS_DQ_IS_HASH_LOCKED(h));
+	ASSERT(mutex_is_locked(&h->qh_lock));
 	dqp->q_hash = h;
 	XQM_HASHLIST_INSERT(h, dqp);
 
@@ -1102,7 +1102,7 @@ xfs_qm_dqget(
 	XQM_MPLIST_INSERT(&(XFS_QI_MPL_LIST(mp)), dqp);
 
 	xfs_qm_mplist_unlock(mp);
-	XFS_DQ_HASH_UNLOCK(h);
+	mutex_unlock(&h->qh_lock);
  dqret:
 	ASSERT((ip == NULL) || xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	xfs_dqtrace_entry(dqp, "DQGET DONE");
@@ -1440,7 +1440,7 @@ xfs_qm_dqpurge(
 	xfs_mount_t	*mp = dqp->q_mount;
 
 	ASSERT(XFS_QM_IS_MPLIST_LOCKED(mp));
-	ASSERT(XFS_DQ_IS_HASH_LOCKED(dqp->q_hash));
+	ASSERT(mutex_is_locked(&dqp->q_hash->qh_lock));
 
 	xfs_dqlock(dqp);
 	/*
@@ -1453,7 +1453,7 @@ xfs_qm_dqpurge(
 	 */
 	if (dqp->q_nrefs != 0) {
 		xfs_dqunlock(dqp);
-		XFS_DQ_HASH_UNLOCK(dqp->q_hash);
+		mutex_unlock(&dqp->q_hash->qh_lock);
 		return (1);
 	}
 
@@ -1517,7 +1517,7 @@ xfs_qm_dqpurge(
 	memset(&dqp->q_core, 0, sizeof(dqp->q_core));
 	xfs_dqfunlock(dqp);
 	xfs_dqunlock(dqp);
-	XFS_DQ_HASH_UNLOCK(thishash);
+	mutex_unlock(&thishash->qh_lock);
 	return (0);
 }
 
Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2009-01-24 18:57:29.143429031 +0100
+++ xfs/fs/xfs/quota/xfs_qm.c	2009-01-24 18:59:09.593428604 +0100
@@ -69,8 +69,6 @@ STATIC void	xfs_qm_list_destroy(xfs_dqli
 
 STATIC void	xfs_qm_freelist_init(xfs_frlist_t *);
 STATIC void	xfs_qm_freelist_destroy(xfs_frlist_t *);
-STATIC int	xfs_qm_mplist_nowait(xfs_mount_t *);
-STATIC int	xfs_qm_dqhashlock_nowait(xfs_dquot_t *);
 
 STATIC int	xfs_qm_init_quotainos(xfs_mount_t *);
 STATIC int	xfs_qm_init_quotainfo(xfs_mount_t *);
@@ -576,10 +574,10 @@ xfs_qm_dqpurge_int(
 			continue;
 		}
 
-		if (! xfs_qm_dqhashlock_nowait(dqp)) {
+		if (!mutex_trylock(&dqp->q_hash->qh_lock)) {
 			nrecl = XFS_QI_MPLRECLAIMS(mp);
 			xfs_qm_mplist_unlock(mp);
-			XFS_DQ_HASH_LOCK(dqp->q_hash);
+			mutex_lock(&dqp->q_hash->qh_lock);
 			xfs_qm_mplist_lock(mp);
 
 			/*
@@ -589,7 +587,7 @@ xfs_qm_dqpurge_int(
 			 * this point, but somebody might be taking things off.
 			 */
 			if (nrecl != XFS_QI_MPLRECLAIMS(mp)) {
-				XFS_DQ_HASH_UNLOCK(dqp->q_hash);
+				mutex_unlock(&dqp->q_hash->qh_lock);
 				goto again;
 			}
 		}
@@ -2027,7 +2025,7 @@ xfs_qm_shake_freelist(
 		 * a dqlookup process that holds the hashlock that is
 		 * waiting for the freelist lock.
 		 */
-		if (! xfs_qm_dqhashlock_nowait(dqp)) {
+		if (!mutex_trylock(&dqp->q_hash->qh_lock)) {
 			xfs_dqfunlock(dqp);
 			xfs_dqunlock(dqp);
 			dqp = dqp->dq_flnext;
@@ -2044,7 +2042,7 @@ xfs_qm_shake_freelist(
 			/* XXX put a sentinel so that we can come back here */
 			xfs_dqfunlock(dqp);
 			xfs_dqunlock(dqp);
-			XFS_DQ_HASH_UNLOCK(hash);
+			mutex_unlock(&hash->qh_lock);
 			xfs_qm_freelist_unlock(xfs_Gqm);
 			if (++restarts >= XFS_QM_RECLAIM_MAX_RESTARTS)
 				return nreclaimed;
@@ -2061,7 +2059,7 @@ xfs_qm_shake_freelist(
 		XQM_HASHLIST_REMOVE(hash, dqp);
 		xfs_dqfunlock(dqp);
 		xfs_qm_mplist_unlock(dqp->q_mount);
-		XFS_DQ_HASH_UNLOCK(hash);
+		mutex_unlock(&hash->qh_lock);
 
  off_freelist:
 		XQM_FREELIST_REMOVE(dqp);
@@ -2203,7 +2201,7 @@ xfs_qm_dqreclaim_one(void)
 			continue;
 		}
 
-		if (! xfs_qm_dqhashlock_nowait(dqp))
+		if (!mutex_trylock(&dqp->q_hash->qh_lock))
 			goto mplistunlock;
 
 		ASSERT(dqp->q_nrefs == 0);
@@ -2212,7 +2210,7 @@ xfs_qm_dqreclaim_one(void)
 		XQM_HASHLIST_REMOVE(dqp->q_hash, dqp);
 		XQM_FREELIST_REMOVE(dqp);
 		dqpout = dqp;
-		XFS_DQ_HASH_UNLOCK(dqp->q_hash);
+		mutex_unlock(&dqp->q_hash->qh_lock);
  mplistunlock:
 		xfs_qm_mplist_unlock(dqp->q_mount);
 		xfs_dqfunlock(dqp);
@@ -2715,34 +2713,3 @@ xfs_qm_freelist_append(xfs_frlist_t *ql,
 {
 	xfs_qm_freelist_insert((xfs_frlist_t *)ql->qh_prev, dq);
 }
-
-STATIC int
-xfs_qm_dqhashlock_nowait(
-	xfs_dquot_t *dqp)
-{
-	int locked;
-
-	locked = mutex_trylock(&((dqp)->q_hash->qh_lock));
-	return locked;
-}
-
-int
-xfs_qm_freelist_lock_nowait(
-	xfs_qm_t *xqm)
-{
-	int locked;
-
-	locked = mutex_trylock(&(xqm->qm_dqfreelist.qh_lock));
-	return locked;
-}
-
-STATIC int
-xfs_qm_mplist_nowait(
-	xfs_mount_t	*mp)
-{
-	int locked;
-
-	ASSERT(mp->m_quotainfo);
-	locked = mutex_trylock(&(XFS_QI_MPLLOCK(mp)));
-	return locked;
-}
Index: xfs/fs/xfs/quota/xfs_qm.h
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.h	2009-01-24 18:57:29.143429031 +0100
+++ xfs/fs/xfs/quota/xfs_qm.h	2009-01-24 18:59:09.593428604 +0100
@@ -199,7 +199,6 @@ extern int		xfs_qm_vop_chown_reserve(xfs
 /* list stuff */
 extern void		xfs_qm_freelist_append(xfs_frlist_t *, xfs_dquot_t *);
 extern void		xfs_qm_freelist_unlink(xfs_dquot_t *);
-extern int		xfs_qm_freelist_lock_nowait(xfs_qm_t *);
 
 #ifdef DEBUG
 extern int		xfs_qm_internalqcheck(xfs_mount_t *);
Index: xfs/fs/xfs/quota/xfs_quota_priv.h
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_quota_priv.h	2009-01-21 21:03:27.836295012 +0100
+++ xfs/fs/xfs/quota/xfs_quota_priv.h	2009-01-24 18:59:09.594477411 +0100
@@ -42,34 +42,24 @@
 #define XFS_QI_QOFFLOCK(mp)	((mp)->m_quotainfo->qi_quotaofflock)
 
 #define XFS_QI_MPL_LIST(mp)	((mp)->m_quotainfo->qi_dqlist)
-#define XFS_QI_MPLLOCK(mp)	((mp)->m_quotainfo->qi_dqlist.qh_lock)
 #define XFS_QI_MPLNEXT(mp)	((mp)->m_quotainfo->qi_dqlist.qh_next)
 #define XFS_QI_MPLNDQUOTS(mp)	((mp)->m_quotainfo->qi_dqlist.qh_nelems)
 
-#define XQMLCK(h)			(mutex_lock(&((h)->qh_lock)))
-#define XQMUNLCK(h)			(mutex_unlock(&((h)->qh_lock)))
-#ifdef DEBUG
-struct xfs_dqhash;
-static inline int XQMISLCKD(struct xfs_dqhash *h)
-{
-	if (mutex_trylock(&h->qh_lock)) {
-		mutex_unlock(&h->qh_lock);
-		return 0;
-	}
-	return 1;
-}
-#endif
-
-#define XFS_DQ_HASH_LOCK(h)		XQMLCK(h)
-#define XFS_DQ_HASH_UNLOCK(h)		XQMUNLCK(h)
-#define XFS_DQ_IS_HASH_LOCKED(h)	XQMISLCKD(h)
-
-#define xfs_qm_mplist_lock(mp)		XQMLCK(&(XFS_QI_MPL_LIST(mp)))
-#define xfs_qm_mplist_unlock(mp)	XQMUNLCK(&(XFS_QI_MPL_LIST(mp)))
-#define XFS_QM_IS_MPLIST_LOCKED(mp)	XQMISLCKD(&(XFS_QI_MPL_LIST(mp)))
-
-#define xfs_qm_freelist_lock(qm)	XQMLCK(&((qm)->qm_dqfreelist))
-#define xfs_qm_freelist_unlock(qm)	XQMUNLCK(&((qm)->qm_dqfreelist))
+#define xfs_qm_mplist_lock(mp) \
+	mutex_lock(&(XFS_QI_MPL_LIST(mp).qh_lock))
+#define xfs_qm_mplist_nowait(mp) \
+	mutex_trylock(&(XFS_QI_MPL_LIST(mp).qh_lock))
+#define xfs_qm_mplist_unlock(mp) \
+	mutex_unlock(&(XFS_QI_MPL_LIST(mp).qh_lock))
+#define XFS_QM_IS_MPLIST_LOCKED(mp) \
+	mutex_is_locked(&(XFS_QI_MPL_LIST(mp).qh_lock))
+
+#define xfs_qm_freelist_lock(qm) \
+	mutex_lock(&((qm)->qm_dqfreelist.qh_lock))
+#define xfs_qm_freelist_lock_nowait(qm) \
+	mutex_trylock(&((qm)->qm_dqfreelist.qh_lock))
+#define xfs_qm_freelist_unlock(qm) \
+	mutex_unlock(&((qm)->qm_dqfreelist.qh_lock))
 
 /*
  * Hash into a bucket in the dquot hash table, based on <mp, id>.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
