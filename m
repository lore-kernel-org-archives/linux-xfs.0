Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2E7YLcs142507 for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 02:34:22 -0500
Date: Wed, 14 Mar 2012 03:34:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: remove the per-filesystem list of dquots
Message-ID: <20120314073418.GA8455@infradead.org>
References: <20120313085232.134690907@bombadil.infradead.org>
	<20120313085308.997632929@bombadil.infradead.org>
	<20120313200354.GI7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120313200354.GI7762@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Mar 13, 2012 at 03:03:54PM -0500, Ben Myers wrote:
> Eesh.. that probably doesn't need to go onto the stack.  I know we are
> doing it elsewhere too, and that we also sometimes complain about other
> peoples' stack usage.  Don't necessarily have to clean it up now,
> though.  ;)

See the comment from Dave.

> > +		/* bail out if the filesystem is corrupted.  */
> > +		if (error == EFSCORRUPTED) {
> 		    last_error
> 
> Error can be overwritten in the nr_found loop above.  I think last_error
> is what you want.

Fixed.

> One caller of this function, xfs_qm_scall_quotaoff, treats the return
> value not as an error, but as a counter of the number of dquots left to
> purge.  If you really do have an error in here, we probably don't want
> to loop.  If we do, lets make it clearer that we're checking for an
> error and not a count.

We couldn't handle an error during umount/quotaoff anyway.  I changed
xfs_qm_dqpurge_all to return void, and just leave the print in
xfs_qm_dqpurge.

Updated version below:

-- 

From: Christoph Hellwig <hch@lst.de>
Subject: xfs: remove the per-filesystem list of dquots

Instead of keeping a separate per-filesystem list of dquots we can walk
the radix tree for the two places where we need to iterate all quota
structures.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_dquot.c       |   95 ----------
 fs/xfs/xfs_dquot.h       |    2 
 fs/xfs/xfs_qm.c          |  415 ++++++++++++++++++++++++-----------------------
 fs/xfs/xfs_qm.h          |    6 
 fs/xfs/xfs_qm_syscalls.c |   12 -
 5 files changed, 226 insertions(+), 304 deletions(-)

V2: remove the useless flags/type argument to the iterator callbacks
V3: error handling fixes

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2012-03-13 09:37:53.240121608 +0100
+++ xfs/fs/xfs/xfs_dquot.c	2012-03-14 08:17:46.910039791 +0100
@@ -44,10 +44,9 @@
  *
  * ip->i_lock
  *   qi->qi_tree_lock
- *     qi->qi_dqlist_lock
- *       dquot->q_qlock (xfs_dqlock() and friends)
- *         dquot->q_flush (xfs_dqflock() and friends)
- *         qi->qi_lru_lock
+ *     dquot->q_qlock (xfs_dqlock() and friends)
+ *       dquot->q_flush (xfs_dqflock() and friends)
+ *       qi->qi_lru_lock
  *
  * If two dquots need to be locked the order is user before group/project,
  * otherwise by the lowest id first, see xfs_dqlock2.
@@ -729,20 +728,12 @@ restart:
 	}
 
 	/*
-	 * Attach this dquot to this filesystem's list of all dquots,
-	 * kept inside the mount structure in m_quotainfo field
-	 */
-	mutex_lock(&qi->qi_dqlist_lock);
-
-	/*
 	 * We return a locked dquot to the caller, with a reference taken
 	 */
 	xfs_dqlock(dqp);
 	dqp->q_nrefs = 1;
 
-	list_add(&dqp->q_mplist, &qi->qi_dqlist);
 	qi->qi_dquots++;
-	mutex_unlock(&qi->qi_dqlist_lock);
 	mutex_unlock(&qi->qi_tree_lock);
 
  dqret:
@@ -1018,86 +1009,6 @@ xfs_dqlock2(
 }
 
 /*
- * Take a dquot out of the mount's dqlist as well as the hashlist.  This is
- * called via unmount as well as quotaoff, and the purge will always succeed.
- */
-void
-xfs_qm_dqpurge(
-	struct xfs_dquot	*dqp)
-{
-	struct xfs_mount	*mp = dqp->q_mount;
-	struct xfs_quotainfo	*qi = mp->m_quotainfo;
-
-	xfs_dqlock(dqp);
-
-	/*
-	 * If we're turning off quotas, we have to make sure that, for
-	 * example, we don't delete quota disk blocks while dquots are
-	 * in the process of getting written to those disk blocks.
-	 * This dquot might well be on AIL, and we can't leave it there
-	 * if we're turning off quotas. Basically, we need this flush
-	 * lock, and are willing to block on it.
-	 */
-	if (!xfs_dqflock_nowait(dqp)) {
-		/*
-		 * Block on the flush lock after nudging dquot buffer,
-		 * if it is incore.
-		 */
-		xfs_dqflock_pushbuf_wait(dqp);
-	}
-
-	/*
-	 * If we are turning this type of quotas off, we don't care
-	 * about the dirty metadata sitting in this dquot. OTOH, if
-	 * we're unmounting, we do care, so we flush it and wait.
-	 */
-	if (XFS_DQ_IS_DIRTY(dqp)) {
-		int	error;
-
-		/*
-		 * We don't care about getting disk errors here. We need
-		 * to purge this dquot anyway, so we go ahead regardless.
-		 */
-		error = xfs_qm_dqflush(dqp, SYNC_WAIT);
-		if (error)
-			xfs_warn(mp, "%s: dquot %p flush failed",
-				__func__, dqp);
-		xfs_dqflock(dqp);
-	}
-
-	ASSERT(atomic_read(&dqp->q_pincount) == 0);
-	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
-	       !(dqp->q_logitem.qli_item.li_flags & XFS_LI_IN_AIL));
-
-	xfs_dqfunlock(dqp);
-	xfs_dqunlock(dqp);
-
-	mutex_lock(&qi->qi_tree_lock);
-	radix_tree_delete(XFS_DQUOT_TREE(qi, dqp->q_core.d_flags),
-			  be32_to_cpu(dqp->q_core.d_id));
-	mutex_unlock(&qi->qi_tree_lock);
-
-	mutex_lock(&qi->qi_dqlist_lock);
-	list_del_init(&dqp->q_mplist);
-	qi->qi_dqreclaims++;
-	qi->qi_dquots--;
-	mutex_unlock(&qi->qi_dqlist_lock);
-
-	/*
-	 * We move dquots to the freelist as soon as their reference count
-	 * hits zero, so it really should be on the freelist here.
-	 */
-	mutex_lock(&qi->qi_lru_lock);
-	ASSERT(!list_empty(&dqp->q_lru));
-	list_del_init(&dqp->q_lru);
-	qi->qi_lru_count--;
-	XFS_STATS_DEC(xs_qm_dquot_unused);
-	mutex_unlock(&qi->qi_lru_lock);
-
-	xfs_qm_dqdestroy(dqp);
-}
-
-/*
  * Give the buffer a little push if it is incore and
  * wait on the flush lock.
  */
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2012-03-13 09:37:53.236788274 +0100
+++ xfs/fs/xfs/xfs_qm.c	2012-03-14 08:25:10.443381351 +0100
@@ -169,6 +169,187 @@ xfs_qm_rele_quotafs_ref(
 }
 
 /*
+ * We use the batch lookup interface to iterate over the dquots as it
+ * currently is the only interface into the radix tree code that allows
+ * fuzzy lookups instead of exact matches.  Holding the lock over multiple
+ * operations is fine as all callers are used either during mount/umount
+ * or quotaoff.
+ */
+#define XFS_DQ_LOOKUP_BATCH	32
+
+STATIC int
+xfs_qm_dquot_walk(
+	struct xfs_mount	*mp,
+	int			type,
+	int			(*execute)(struct xfs_dquot *dqp))
+{
+	struct xfs_quotainfo	*qi = mp->m_quotainfo;
+	struct radix_tree_root	*tree = XFS_DQUOT_TREE(qi, type);
+	uint32_t		next_index;
+	int			last_error = 0;
+	int			skipped;
+	int			nr_found;
+
+restart:
+	skipped = 0;
+	next_index = 0;
+	nr_found = 0;
+
+	while (1) {
+		struct xfs_dquot *batch[XFS_DQ_LOOKUP_BATCH];
+		int		error = 0;
+		int		i;
+
+		mutex_lock(&qi->qi_tree_lock);
+		nr_found = radix_tree_gang_lookup(tree, (void **)batch,
+					next_index, XFS_DQ_LOOKUP_BATCH);
+		if (!nr_found) {
+			mutex_unlock(&qi->qi_tree_lock);
+			break;
+		}
+
+		for (i = 0; i < nr_found; i++) {
+			struct xfs_dquot *dqp = batch[i];
+
+			next_index = be32_to_cpu(dqp->q_core.d_id) + 1;
+
+			error = execute(batch[i]);
+			if (error == EAGAIN) {
+				skipped++;
+				continue;
+			}
+			if (error && last_error != EFSCORRUPTED)
+				last_error = error;
+		}
+
+		mutex_unlock(&qi->qi_tree_lock);
+
+		/* bail out if the filesystem is corrupted.  */
+		if (last_error == EFSCORRUPTED) {
+			skipped = 0;
+			break;
+		}
+	}
+
+	if (skipped) {
+		delay(1);
+		goto restart;
+	}
+
+	return last_error;
+}
+
+
+/*
+ * Purge a dquot from all tracking data structures and free it.
+ */
+STATIC int
+xfs_qm_dqpurge(
+	struct xfs_dquot	*dqp)
+{
+	struct xfs_mount	*mp = dqp->q_mount;
+	struct xfs_quotainfo	*qi = mp->m_quotainfo;
+	struct xfs_dquot	*gdqp = NULL;
+
+	xfs_dqlock(dqp);
+	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0) {
+		xfs_dqunlock(dqp);
+		return EAGAIN;
+	}
+
+	/*
+	 * If this quota has a group hint attached, prepare for releasing it
+	 * now.
+	 */
+	gdqp = dqp->q_gdquot;
+	if (gdqp) {
+		xfs_dqlock(gdqp);
+		dqp->q_gdquot = NULL;
+	}
+
+	dqp->dq_flags |= XFS_DQ_FREEING;
+
+	/*
+	 * If we're turning off quotas, we have to make sure that, for
+	 * example, we don't delete quota disk blocks while dquots are
+	 * in the process of getting written to those disk blocks.
+	 * This dquot might well be on AIL, and we can't leave it there
+	 * if we're turning off quotas. Basically, we need this flush
+	 * lock, and are willing to block on it.
+	 */
+	if (!xfs_dqflock_nowait(dqp)) {
+		/*
+		 * Block on the flush lock after nudging dquot buffer,
+		 * if it is incore.
+		 */
+		xfs_dqflock_pushbuf_wait(dqp);
+	}
+
+	/*
+	 * If we are turning this type of quotas off, we don't care
+	 * about the dirty metadata sitting in this dquot. OTOH, if
+	 * we're unmounting, we do care, so we flush it and wait.
+	 */
+	if (XFS_DQ_IS_DIRTY(dqp)) {
+		int	error;
+
+		/*
+		 * We don't care about getting disk errors here. We need
+		 * to purge this dquot anyway, so we go ahead regardless.
+		 */
+		error = xfs_qm_dqflush(dqp, SYNC_WAIT);
+		if (error)
+			xfs_warn(mp, "%s: dquot %p flush failed",
+				__func__, dqp);
+		xfs_dqflock(dqp);
+	}
+
+	ASSERT(atomic_read(&dqp->q_pincount) == 0);
+	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
+	       !(dqp->q_logitem.qli_item.li_flags & XFS_LI_IN_AIL));
+
+	xfs_dqfunlock(dqp);
+	xfs_dqunlock(dqp);
+
+	radix_tree_delete(XFS_DQUOT_TREE(qi, dqp->q_core.d_flags),
+			  be32_to_cpu(dqp->q_core.d_id));
+	qi->qi_dquots--;
+
+	/*
+	 * We move dquots to the freelist as soon as their reference count
+	 * hits zero, so it really should be on the freelist here.
+	 */
+	mutex_lock(&qi->qi_lru_lock);
+	ASSERT(!list_empty(&dqp->q_lru));
+	list_del_init(&dqp->q_lru);
+	qi->qi_lru_count--;
+	XFS_STATS_DEC(xs_qm_dquot_unused);
+	mutex_unlock(&qi->qi_lru_lock);
+
+	xfs_qm_dqdestroy(dqp);
+
+	if (gdqp)
+		xfs_qm_dqput(gdqp);
+	return 0;
+}
+
+/*
+ * Purge the dquot cache.
+ */
+void
+xfs_qm_dqpurge_all(
+	struct xfs_mount	*mp,
+	uint			flags)
+{
+	if (flags & XFS_QMOPT_UQUOTA)
+		xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge);
+	if (flags & XFS_QMOPT_GQUOTA)
+		xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_dqpurge);
+	if (flags & XFS_QMOPT_PQUOTA)
+		xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_dqpurge);
+}
+
+/*
  * Just destroy the quotainfo structure.
  */
 void
@@ -306,175 +487,6 @@ xfs_qm_unmount_quotas(
 	}
 }
 
-/*
- * Flush all dquots of the given file system to disk. The dquots are
- * _not_ purged from memory here, just their data written to disk.
- */
-STATIC int
-xfs_qm_dqflush_all(
-	struct xfs_mount	*mp)
-{
-	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	int			recl;
-	struct xfs_dquot	*dqp;
-	int			error;
-
-	if (!q)
-		return 0;
-again:
-	mutex_lock(&q->qi_dqlist_lock);
-	list_for_each_entry(dqp, &q->qi_dqlist, q_mplist) {
-		xfs_dqlock(dqp);
-		if ((dqp->dq_flags & XFS_DQ_FREEING) ||
-		    !XFS_DQ_IS_DIRTY(dqp)) {
-			xfs_dqunlock(dqp);
-			continue;
-		}
-
-		/* XXX a sentinel would be better */
-		recl = q->qi_dqreclaims;
-		if (!xfs_dqflock_nowait(dqp)) {
-			/*
-			 * If we can't grab the flush lock then check
-			 * to see if the dquot has been flushed delayed
-			 * write.  If so, grab its buffer and send it
-			 * out immediately.  We'll be able to acquire
-			 * the flush lock when the I/O completes.
-			 */
-			xfs_dqflock_pushbuf_wait(dqp);
-		}
-		/*
-		 * Let go of the mplist lock. We don't want to hold it
-		 * across a disk write.
-		 */
-		mutex_unlock(&q->qi_dqlist_lock);
-		error = xfs_qm_dqflush(dqp, 0);
-		xfs_dqunlock(dqp);
-		if (error)
-			return error;
-
-		mutex_lock(&q->qi_dqlist_lock);
-		if (recl != q->qi_dqreclaims) {
-			mutex_unlock(&q->qi_dqlist_lock);
-			/* XXX restart limit */
-			goto again;
-		}
-	}
-
-	mutex_unlock(&q->qi_dqlist_lock);
-	/* return ! busy */
-	return 0;
-}
-
-/*
- * Release the group dquot pointers the user dquots may be
- * carrying around as a hint. mplist is locked on entry and exit.
- */
-STATIC void
-xfs_qm_detach_gdquots(
-	struct xfs_mount	*mp)
-{
-	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	struct xfs_dquot	*dqp, *gdqp;
-
- again:
-	ASSERT(mutex_is_locked(&q->qi_dqlist_lock));
-	list_for_each_entry(dqp, &q->qi_dqlist, q_mplist) {
-		xfs_dqlock(dqp);
-		if (dqp->dq_flags & XFS_DQ_FREEING) {
-			xfs_dqunlock(dqp);
-			mutex_unlock(&q->qi_dqlist_lock);
-			delay(1);
-			mutex_lock(&q->qi_dqlist_lock);
-			goto again;
-		}
-
-		gdqp = dqp->q_gdquot;
-		if (gdqp)
-			dqp->q_gdquot = NULL;
-		xfs_dqunlock(dqp);
-
-		if (gdqp)
-			xfs_qm_dqrele(gdqp);
-	}
-}
-
-/*
- * Go through all the incore dquots of this file system and take them
- * off the mplist and hashlist, if the dquot type matches the dqtype
- * parameter. This is used when turning off quota accounting for
- * users and/or groups, as well as when the filesystem is unmounting.
- */
-STATIC int
-xfs_qm_dqpurge_int(
-	struct xfs_mount	*mp,
-	uint			flags)
-{
-	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	struct xfs_dquot	*dqp, *n;
-	uint			dqtype;
-	int			nmisses = 0;
-	LIST_HEAD		(dispose_list);
-
-	if (!q)
-		return 0;
-
-	dqtype = (flags & XFS_QMOPT_UQUOTA) ? XFS_DQ_USER : 0;
-	dqtype |= (flags & XFS_QMOPT_PQUOTA) ? XFS_DQ_PROJ : 0;
-	dqtype |= (flags & XFS_QMOPT_GQUOTA) ? XFS_DQ_GROUP : 0;
-
-	mutex_lock(&q->qi_dqlist_lock);
-
-	/*
-	 * In the first pass through all incore dquots of this filesystem,
-	 * we release the group dquot pointers the user dquots may be
-	 * carrying around as a hint. We need to do this irrespective of
-	 * what's being turned off.
-	 */
-	xfs_qm_detach_gdquots(mp);
-
-	/*
-	 * Try to get rid of all of the unwanted dquots.
-	 */
-	list_for_each_entry_safe(dqp, n, &q->qi_dqlist, q_mplist) {
-		xfs_dqlock(dqp);
-		if ((dqp->dq_flags & dqtype) != 0 &&
-		    !(dqp->dq_flags & XFS_DQ_FREEING)) {
-			if (dqp->q_nrefs == 0) {
-				dqp->dq_flags |= XFS_DQ_FREEING;
-				list_move_tail(&dqp->q_mplist, &dispose_list);
-			} else
-				nmisses++;
-		}
-		xfs_dqunlock(dqp);
-	}
-	mutex_unlock(&q->qi_dqlist_lock);
-
-	list_for_each_entry_safe(dqp, n, &dispose_list, q_mplist)
-		xfs_qm_dqpurge(dqp);
-
-	return nmisses;
-}
-
-int
-xfs_qm_dqpurge_all(
-	xfs_mount_t	*mp,
-	uint		flags)
-{
-	int		ndquots;
-
-	/*
-	 * Purge the dquot cache.
-	 * None of the dquots should really be busy at this point.
-	 */
-	if (mp->m_quotainfo) {
-		while ((ndquots = xfs_qm_dqpurge_int(mp, flags))) {
-			delay(ndquots * 10);
-		}
-	}
-	return 0;
-}
-
 STATIC int
 xfs_qm_dqattach_one(
 	xfs_inode_t	*ip,
@@ -749,15 +761,10 @@ xfs_qm_init_quotainfo(
 	INIT_RADIX_TREE(&qinf->qi_gquota_tree, GFP_NOFS);
 	mutex_init(&qinf->qi_tree_lock);
 
-	INIT_LIST_HEAD(&qinf->qi_dqlist);
-	mutex_init(&qinf->qi_dqlist_lock);
-
 	INIT_LIST_HEAD(&qinf->qi_lru_list);
 	qinf->qi_lru_count = 0;
 	mutex_init(&qinf->qi_lru_lock);
 
-	qinf->qi_dqreclaims = 0;
-
 	/* mutex used to serialize quotaoffs */
 	mutex_init(&qinf->qi_quotaofflock);
 
@@ -854,9 +861,6 @@ xfs_qm_destroy_quotainfo(
 	 */
 	xfs_qm_rele_quotafs_ref(mp);
 
-	ASSERT(list_empty(&qi->qi_dqlist));
-	mutex_destroy(&qi->qi_dqlist_lock);
-
 	if (qi->qi_uquotaip) {
 		IRELE(qi->qi_uquotaip);
 		qi->qi_uquotaip = NULL; /* paranoia */
@@ -1307,6 +1311,28 @@ error0:
 	return error;
 }
 
+STATIC int
+xfs_qm_flush_one(
+	struct xfs_dquot	*dqp)
+{
+	int			error = 0;
+
+	xfs_dqlock(dqp);
+	if (dqp->dq_flags & XFS_DQ_FREEING)
+		goto out_unlock;
+	if (!XFS_DQ_IS_DIRTY(dqp))
+		goto out_unlock;
+
+	if (!xfs_dqflock_nowait(dqp))
+		xfs_dqflock_pushbuf_wait(dqp);
+
+	error = xfs_qm_dqflush(dqp, 0);
+
+out_unlock:
+	xfs_dqunlock(dqp);
+	return error;
+}
+
 /*
  * Walk thru all the filesystem inodes and construct a consistent view
  * of the disk quota world. If the quotacheck fails, disable quotas.
@@ -1315,7 +1341,7 @@ int
 xfs_qm_quotacheck(
 	xfs_mount_t	*mp)
 {
-	int		done, count, error;
+	int		done, count, error, error2;
 	xfs_ino_t	lastino;
 	size_t		structsz;
 	xfs_inode_t	*uip, *gip;
@@ -1329,12 +1355,6 @@ xfs_qm_quotacheck(
 	ASSERT(mp->m_quotainfo->qi_uquotaip || mp->m_quotainfo->qi_gquotaip);
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
-	/*
-	 * There should be no cached dquots. The (simplistic) quotacheck
-	 * algorithm doesn't like that.
-	 */
-	ASSERT(list_empty(&mp->m_quotainfo->qi_dqlist));
-
 	xfs_notice(mp, "Quotacheck needed: Please wait.");
 
 	/*
@@ -1373,12 +1393,21 @@ xfs_qm_quotacheck(
 	} while (!done);
 
 	/*
-	 * We've made all the changes that we need to make incore.
-	 * Flush them down to disk buffers if everything was updated
-	 * successfully.
+	 * We've made all the changes that we need to make incore.  Flush them
+	 * down to disk buffers if everything was updated successfully.
 	 */
-	if (!error)
-		error = xfs_qm_dqflush_all(mp);
+	if (XFS_IS_UQUOTA_ON(mp))
+		error = xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_flush_one);
+	if (XFS_IS_GQUOTA_ON(mp)) {
+		error2 = xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_flush_one);
+		if (!error)
+			error = error2;
+	}
+	if (XFS_IS_PQUOTA_ON(mp)) {
+		error2 = xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_flush_one);
+		if (!error)
+			error = error2;
+	}
 
 	/*
 	 * We can get this error if we couldn't do a dquot allocation inside
@@ -1517,13 +1546,9 @@ xfs_qm_dqfree_one(
 	mutex_lock(&qi->qi_tree_lock);
 	radix_tree_delete(XFS_DQUOT_TREE(qi, dqp->q_core.d_flags),
 			  be32_to_cpu(dqp->q_core.d_id));
-	mutex_unlock(&qi->qi_tree_lock);
 
-	mutex_lock(&qi->qi_dqlist_lock);
-	list_del_init(&dqp->q_mplist);
 	qi->qi_dquots--;
-	qi->qi_dqreclaims++;
-	mutex_unlock(&qi->qi_dqlist_lock);
+	mutex_unlock(&qi->qi_tree_lock);
 
 	xfs_qm_dqdestroy(dqp);
 }
@@ -1556,8 +1581,6 @@ xfs_qm_dqreclaim_one(
 		return;
 	}
 
-	ASSERT(!list_empty(&dqp->q_mplist));
-
 	/*
 	 * Try to grab the flush lock. If this dquot is in the process of
 	 * getting flushed to disk, we don't want to reclaim it.
Index: xfs/fs/xfs/xfs_qm.h
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.h	2012-03-13 09:37:53.000000000 +0100
+++ xfs/fs/xfs/xfs_qm.h	2012-03-14 08:20:56.263376635 +0100
@@ -63,11 +63,7 @@ typedef struct xfs_quotainfo {
 	struct list_head qi_lru_list;
 	struct mutex	 qi_lru_lock;
 	int		 qi_lru_count;
-	struct list_head qi_dqlist;	 /* all dquots in filesys */
-	struct mutex	 qi_dqlist_lock;
 	int		 qi_dquots;
-	int		 qi_dqreclaims;	 /* a change here indicates
-					    a removal in the dqlist */
 	time_t		 qi_btimelimit;	 /* limit for blks timer */
 	time_t		 qi_itimelimit;	 /* limit for inodes timer */
 	time_t		 qi_rtbtimelimit;/* limit for rt blks timer */
@@ -126,7 +122,7 @@ extern int		xfs_qm_quotacheck(xfs_mount_
 extern int		xfs_qm_write_sb_changes(xfs_mount_t *, __int64_t);
 
 /* dquot stuff */
-extern int		xfs_qm_dqpurge_all(xfs_mount_t *, uint);
+extern void		xfs_qm_dqpurge_all(xfs_mount_t *, uint);
 extern void		xfs_qm_dqrele_all_inodes(xfs_mount_t *, uint);
 
 /* quota ops */
Index: xfs/fs/xfs/xfs_dquot.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.h	2012-03-13 09:37:53.000000000 +0100
+++ xfs/fs/xfs/xfs_dquot.h	2012-03-13 09:39:12.483456411 +0100
@@ -38,7 +38,6 @@ struct xfs_trans;
 typedef struct xfs_dquot {
 	uint		 dq_flags;	/* various flags (XFS_DQ_*) */
 	struct list_head q_lru;		/* global free list of dquots */
-	struct list_head q_mplist;	/* mount's list of dquots */
 	struct xfs_mount*q_mount;	/* filesystem this relates to */
 	struct xfs_trans*q_transp;	/* trans this belongs to currently */
 	uint		 q_nrefs;	/* # active refs from inodes */
@@ -143,7 +142,6 @@ extern int		xfs_qm_dqread(struct xfs_mou
 					uint, struct xfs_dquot	**);
 extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
 extern int		xfs_qm_dqflush(xfs_dquot_t *, uint);
-extern void		xfs_qm_dqpurge(xfs_dquot_t *);
 extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
 extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *,
 					xfs_disk_dquot_t *);
Index: xfs/fs/xfs/xfs_qm_syscalls.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm_syscalls.c	2012-03-02 07:56:29.000000000 +0100
+++ xfs/fs/xfs/xfs_qm_syscalls.c	2012-03-14 08:26:01.983382305 +0100
@@ -66,7 +66,6 @@ xfs_qm_scall_quotaoff(
 	int			error;
 	uint			inactivate_flags;
 	xfs_qoff_logitem_t	*qoffstart;
-	int			nculprits;
 
 	/*
 	 * No file system can have quotas enabled on disk but not in core.
@@ -172,18 +171,13 @@ xfs_qm_scall_quotaoff(
 	 * This isn't protected by a particular lock directly, because we
 	 * don't want to take a mrlock every time we depend on quotas being on.
 	 */
-	mp->m_qflags &= ~(flags);
+	mp->m_qflags &= ~flags;
 
 	/*
 	 * Go through all the dquots of this file system and purge them,
-	 * according to what was turned off. We may not be able to get rid
-	 * of all dquots, because dquots can have temporary references that
-	 * are not attached to inodes. eg. xfs_setattr, xfs_create.
-	 * So, if we couldn't purge all the dquots from the filesystem,
-	 * we can't get rid of the incore data structures.
+	 * according to what was turned off.
 	 */
-	while ((nculprits = xfs_qm_dqpurge_all(mp, dqtype)))
-		delay(10 * nculprits);
+	xfs_qm_dqpurge_all(mp, dqtype);
 
 	/*
 	 * Transactions that had started before ACTIVE state bit was cleared

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
