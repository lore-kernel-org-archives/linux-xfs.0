Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8U2P2BA114038 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 21:25:02 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 25FC7188D335
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 19:26:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id eiADkDhECE3qdz8O for
	<xfs@oss.sgi.com>; Wed, 29 Sep 2010 19:26:02 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1P18qP-0007xr-OT
	for xfs@oss.sgi.com; Thu, 30 Sep 2010 02:26:01 +0000
Message-Id: <20100930022601.566811585@bombadil.infradead.org>
Date: Wed, 29 Sep 2010 22:25:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] [PATCH 3/3] xfs: do not use xfs_mod_incore_sb_batch for
	per-cpu counters
References: <20100930022553.391390964@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-simplify-icsb-updates
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

Update the per-cpu counters manually in xfs_trans_unreserve_and_mod_sb and
remove support for per-cpu counters from xfs_mod_incore_sb_batch to
simplify it.  And added benefit is that we don't have to take m_sb_lock
for transactions that only modify per-cpu counters.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2010-09-30 08:11:54.332709458 +0900
+++ xfs/fs/xfs/xfs_mount.c	2010-09-30 08:12:46.899709458 +0900
@@ -1856,98 +1856,54 @@ xfs_mod_incore_sb(
 }
 
 /*
- * xfs_mod_incore_sb_batch() is used to change more than one field
- * in the in-core superblock structure at a time.  This modification
- * is protected by a lock internal to this module.  The fields and
- * changes to those fields are specified in the array of xfs_mod_sb
- * structures passed in.
- *
- * Either all of the specified deltas will be applied or none of
- * them will.  If any modified field dips below 0, then all modifications
- * will be backed out and EINVAL will be returned.
+ * Change more than one field in the in-core superblock structure at a time.
+ *
+ * The fields and changes to those fields are specified in the array of
+ * xfs_mod_sb structures passed in.  Either all of the specified deltas
+ * will be applied or none of them will.  If any modified field dips below 0,
+ * then all modifications will be backed out and EINVAL will be returned.
+ *
+ * Note that this function may not be used for the superblock values that
+ * are tracked with the in-memory per-cpu counters - a direct call to
+ * xfs_icsb_modify_counters is required for these.
  */
 int
-xfs_mod_incore_sb_batch(xfs_mount_t *mp, xfs_mod_sb_t *msb, uint nmsb, int rsvd)
+xfs_mod_incore_sb_batch(
+	struct xfs_mount	*mp,
+	xfs_mod_sb_t		*msb,
+	uint			nmsb,
+	int			rsvd)
 {
-	int		status=0;
-	xfs_mod_sb_t	*msbp;
+	xfs_mod_sb_t		*msbp = &msb[0];
+	int			error = 0;
 
 	/*
-	 * Loop through the array of mod structures and apply each
-	 * individually.  If any fail, then back out all those
-	 * which have already been applied.  Do all of this within
-	 * the scope of the m_sb_lock so that all of the changes will
-	 * be atomic.
+	 * Loop through the array of mod structures and apply each individually.
+	 * If any fail, then back out all those which have already been applied.
+	 * Do all of this within the scope of the m_sb_lock so that all of the
+	 * changes will be atomic.
 	 */
 	spin_lock(&mp->m_sb_lock);
-	msbp = &msb[0];
 	for (msbp = &msbp[0]; msbp < (msb + nmsb); msbp++) {
-		/*
-		 * Apply the delta at index n.  If it fails, break
-		 * from the loop so we'll fall into the undo loop
-		 * below.
-		 */
-		switch (msbp->msb_field) {
-#ifdef HAVE_PERCPU_SB
-		case XFS_SBS_ICOUNT:
-		case XFS_SBS_IFREE:
-		case XFS_SBS_FDBLOCKS:
-			spin_unlock(&mp->m_sb_lock);
-			status = xfs_icsb_modify_counters(mp,
-						msbp->msb_field,
-						msbp->msb_delta, rsvd);
-			spin_lock(&mp->m_sb_lock);
-			break;
-#endif
-		default:
-			status = xfs_mod_incore_sb_unlocked(mp,
-						msbp->msb_field,
-						msbp->msb_delta, rsvd);
-			break;
-		}
+		ASSERT(msbp->msb_field < XFS_SBS_ICOUNT ||
+		       msbp->msb_field > XFS_SBS_FDBLOCKS);
 
-		if (status != 0) {
-			break;
-		}
+		error = xfs_mod_incore_sb_unlocked(mp, msbp->msb_field,
+						   msbp->msb_delta, rsvd);
+		if (error)
+			goto unwind;
 	}
+	spin_unlock(&mp->m_sb_lock);
+	return 0;
 
-	/*
-	 * If we didn't complete the loop above, then back out
-	 * any changes made to the superblock.  If you add code
-	 * between the loop above and here, make sure that you
-	 * preserve the value of status. Loop back until
-	 * we step below the beginning of the array.  Make sure
-	 * we don't touch anything back there.
-	 */
-	if (status != 0) {
-		msbp--;
-		while (msbp >= msb) {
-			switch (msbp->msb_field) {
-#ifdef HAVE_PERCPU_SB
-			case XFS_SBS_ICOUNT:
-			case XFS_SBS_IFREE:
-			case XFS_SBS_FDBLOCKS:
-				spin_unlock(&mp->m_sb_lock);
-				status = xfs_icsb_modify_counters(mp,
-						msbp->msb_field,
-						-(msbp->msb_delta),
-						rsvd);
-				spin_lock(&mp->m_sb_lock);
-				break;
-#endif
-			default:
-				status = xfs_mod_incore_sb_unlocked(mp,
-							msbp->msb_field,
-							-(msbp->msb_delta),
-							rsvd);
-				break;
-			}
-			ASSERT(status == 0);
-			msbp--;
-		}
+unwind:
+	while (--msbp >= msb) {
+		error = xfs_mod_incore_sb_unlocked(mp, msbp->msb_field,
+						   -msbp->msb_delta, rsvd);
+		ASSERT(error == 0);
 	}
 	spin_unlock(&mp->m_sb_lock);
-	return status;
+	return error;
 }
 
 /*
@@ -2478,7 +2434,7 @@ xfs_icsb_balance_counter(
 	spin_unlock(&mp->m_sb_lock);
 }
 
-STATIC int
+int
 xfs_icsb_modify_counters(
 	xfs_mount_t	*mp,
 	xfs_sb_field_t	field,
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2010-09-30 08:11:54.342709458 +0900
+++ xfs/fs/xfs/xfs_trans.c	2010-09-30 08:24:41.837709458 +0900
@@ -1009,7 +1009,7 @@ void
 xfs_trans_unreserve_and_mod_sb(
 	xfs_trans_t	*tp)
 {
-	xfs_mod_sb_t	msb[14];	/* If you add cases, add entries */
+	xfs_mod_sb_t	msb[9];	/* If you add cases, add entries */
 	xfs_mod_sb_t	*msbp;
 	xfs_mount_t	*mp = tp->t_mountp;
 	/* REFERENCED */
@@ -1017,55 +1017,61 @@ xfs_trans_unreserve_and_mod_sb(
 	int		rsvd;
 	int64_t		blkdelta = 0;
 	int64_t		rtxdelta = 0;
+	int64_t		idelta = 0;
+	int64_t		ifreedelta = 0;
 
 	msbp = msb;
 	rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
 
-	/* calculate free blocks delta */
+	/* calculate deltas */
 	if (tp->t_blk_res > 0)
 		blkdelta = tp->t_blk_res;
-
 	if ((tp->t_fdblocks_delta != 0) &&
 	    (xfs_sb_version_haslazysbcount(&mp->m_sb) ||
 	     (tp->t_flags & XFS_TRANS_SB_DIRTY)))
 	        blkdelta += tp->t_fdblocks_delta;
 
-	if (blkdelta != 0) {
-		msbp->msb_field = XFS_SBS_FDBLOCKS;
-		msbp->msb_delta = blkdelta;
-		msbp++;
-	}
-
-	/* calculate free realtime extents delta */
 	if (tp->t_rtx_res > 0)
 		rtxdelta = tp->t_rtx_res;
-
 	if ((tp->t_frextents_delta != 0) &&
 	    (tp->t_flags & XFS_TRANS_SB_DIRTY))
 		rtxdelta += tp->t_frextents_delta;
 
+	if (xfs_sb_version_haslazysbcount(&mp->m_sb) ||
+	     (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
+		idelta = tp->t_icount_delta;
+		ifreedelta = tp->t_ifree_delta;
+	}
+
+	/* apply the per-cpu counters */
+	if (blkdelta) {
+		error = xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
+						 blkdelta, rsvd);
+		if (error)
+			goto out;
+	}
+
+	if (idelta) {
+		error = xfs_icsb_modify_counters(mp, XFS_SBS_ICOUNT,
+						 idelta, rsvd);
+		if (error)
+			goto out_undo_fdblocks;
+	}
+
+	if (ifreedelta) {
+		error = xfs_icsb_modify_counters(mp, XFS_SBS_IFREE,
+						 ifreedelta, rsvd);
+		if (error)
+			goto out_undo_icount;
+	}
+
+	/* apply remaining deltas */
 	if (rtxdelta != 0) {
 		msbp->msb_field = XFS_SBS_FREXTENTS;
 		msbp->msb_delta = rtxdelta;
 		msbp++;
 	}
 
-	/* apply remaining deltas */
-
-	if (xfs_sb_version_haslazysbcount(&mp->m_sb) ||
-	     (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
-		if (tp->t_icount_delta != 0) {
-			msbp->msb_field = XFS_SBS_ICOUNT;
-			msbp->msb_delta = tp->t_icount_delta;
-			msbp++;
-		}
-		if (tp->t_ifree_delta != 0) {
-			msbp->msb_field = XFS_SBS_IFREE;
-			msbp->msb_delta = tp->t_ifree_delta;
-			msbp++;
-		}
-	}
-
 	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
 		if (tp->t_dblocks_delta != 0) {
 			msbp->msb_field = XFS_SBS_DBLOCKS;
@@ -1115,8 +1121,24 @@ xfs_trans_unreserve_and_mod_sb(
 	if (msbp > msb) {
 		error = xfs_mod_incore_sb_batch(tp->t_mountp, msb,
 			(uint)(msbp - msb), rsvd);
-		ASSERT(error == 0);
+		if (error)
+			goto out_undo_ifreecount;
 	}
+
+	return;
+
+out_undo_ifreecount:
+	if (ifreedelta)
+		xfs_icsb_modify_counters(mp, XFS_SBS_IFREE, -ifreedelta, rsvd);
+out_undo_icount:
+	if (idelta)
+		xfs_icsb_modify_counters(mp, XFS_SBS_ICOUNT, -idelta, rsvd);
+out_undo_fdblocks:
+	if (blkdelta)
+		xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS, -blkdelta, rsvd);
+out:
+	ASSERT(error = 0);
+	return;
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
