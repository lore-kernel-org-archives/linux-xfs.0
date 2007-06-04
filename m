Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 01:07:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5487SWt011430
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 01:07:31 -0700
Date: Mon, 4 Jun 2007 18:07:20 +1000
From: David Chinner <dgc@sgi.com>
Subject: Review: apply transaction deltas atomically to superblock
Message-ID: <20070604080720.GV85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


When testing lazy superblock counters and ENOSPC conditions (test
083), I came across semi-regular assert failures in
xfs_mod_incore_sb_batch() where the assert failure was occurring as
a result of failing to *undo* block reservations for a transaction
that had reserved all the blocks it was going to use up front.

That is, we failed to apply the transaction delta when it should
not have failed, and then we failed to remove the delta's that we
had already applied.

It turns out that that the problem is an interaction between
the per-cpu superblock counters and
xfs_trans_unreserve_and_mod_sb(). Prior to the per-cpu superblock
counters, transaction delta's were applied under the XFS_SB_LOCK()
and so were always applied atomically. The per-cpu superblock
counters don't hold the XFS_SB_LOCK() and hence are not applied
atomically. This was not thought to be a problem because each
cahnge that needed ot be made had already been validated and
reserved.

It turns out that xfs_trans_unreserve_and_mod_sb() does something
incredibly stupid. It applies changes to the free block in *two*
separate deltas. The first change puts back the *entire reservation*
to the superblock and then it takes away what was actually used.

So now we have a window where the transaction reservation is
undone and another thread can come along and use that reservation.
the result is the second delta to mark the blocks as used fails
with ENOSPC, and because the blocks need for the transaction
reservation has been taken by something else, we then fail
to get them back for the transaction reservation when we try
to undo that delta.

So, the fix is to simply calculate what the free block delta is
and apply it in a single atomic delta.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_trans.c |   77 +++++++++++++++++++++++++++--------------------------
 1 file changed, 40 insertions(+), 37 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_trans.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans.c	2007-05-03 15:05:09.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans.c	2007-05-09 12:14:18.429409061 +1000
@@ -638,11 +638,23 @@ xfs_trans_apply_sb_deltas(
 }
 
 /*
- * xfs_trans_unreserve_and_mod_sb() is called to release unused
- * reservations and apply superblock counter changes to the in-core
- * superblock.
+ * xfs_trans_unreserve_and_mod_sb() is called to release unused reservations
+ * and apply superblock counter changes to the in-core superblock.  The
+ * t_res_fdblocks_delta and t_res_frextents_delta fields are explicitly NOT
+ * applied to the in-core superblock.  The idea is that that has already been
+ * done.
  *
  * This is done efficiently with a single call to xfs_mod_incore_sb_batch().
+ * However, we have to ensure that we only modify each superblock field only
+ * once because the application of the delta values may not be atomic. That can
+ * lead to ENOSPC races occurring if we have two separate modifcations of the
+ * free space counter to put back the entire reservation and then take away
+ * what we used.
+ *
+ * If we are not logging superblock counters, then the inode allocated/free and
+ * used block counts are not updated in the on disk superblock. In this case,
+ * XFS_TRANS_SB_DIRTY will not be set when the transaction is updated but we
+ * still need to update the incore superblock with the changes.
  */
 STATIC void
 xfs_trans_unreserve_and_mod_sb(
@@ -654,42 +666,43 @@ xfs_trans_unreserve_and_mod_sb(
 	/* REFERENCED */
 	int		error;
 	int		rsvd;
+	int64_t		blkdelta = 0;
+	int64_t		rtxdelta = 0;
 
 	msbp = msb;
 	rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
 
-	/*
-	 * Release any reserved blocks.  Any that were allocated
-	 * will be taken back again by fdblocks_delta below.
-	 */
-	if (tp->t_blk_res > 0) {
+	/* calculate free blocks delta */
+	if (tp->t_blk_res > 0)
+		blkdelta = tp->t_blk_res;
+
+	if ((tp->t_fdblocks_delta != 0) &&
+	    (xfs_sb_version_haslazysbcount(&mp->m_sb) ||
+	     (tp->t_flags & XFS_TRANS_SB_DIRTY)))
+	        blkdelta += tp->t_fdblocks_delta;
+
+	if (blkdelta != 0) {
 		msbp->msb_field = XFS_SBS_FDBLOCKS;
-		msbp->msb_delta = tp->t_blk_res;
+		msbp->msb_delta = blkdelta;
 		msbp++;
 	}
 
-	/*
-	 * Release any reserved real time extents .  Any that were
-	 * allocated will be taken back again by frextents_delta below.
-	 */
-	if (tp->t_rtx_res > 0) {
+	/* calculate free realtime extents delta */
+	if (tp->t_rtx_res > 0)
+		rtxdelta = tp->t_rtx_res;
+
+	if ((tp->t_frextents_delta != 0) &&
+	    (tp->t_flags & XFS_TRANS_SB_DIRTY))
+		rtxdelta = tp->t_frextents_delta;
+
+	if (rtxdelta != 0) {
 		msbp->msb_field = XFS_SBS_FREXTENTS;
-		msbp->msb_delta = tp->t_rtx_res;
+		msbp->msb_delta = rtxdelta;
 		msbp++;
 	}
 
-	/*
-	 * Apply any superblock modifications to the in-core version.
-	 * The t_res_fdblocks_delta and t_res_frextents_delta fields are
-	 * explicitly NOT applied to the in-core superblock.
-	 * The idea is that that has already been done.
-	 *
-	 * If we are not logging superblock counters, then the inode
-	 * allocated/free and used block counts are not updated in the
-	 * on disk superblock. In this case, XFS_TRANS_SB_DIRTY will
-	 * not be set when the transaction is updated but we still need
-	 * to update the incore superblock with the changes.
-	 */
+	/* apply remaining deltas */
+
 	if (xfs_sb_version_haslazysbcount(&mp->m_sb) ||
 	     (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
 		if (tp->t_icount_delta != 0) {
@@ -702,19 +715,9 @@ xfs_trans_unreserve_and_mod_sb(
 			msbp->msb_delta = tp->t_ifree_delta;
 			msbp++;
 		}
-		if (tp->t_fdblocks_delta != 0) {
-			msbp->msb_field = XFS_SBS_FDBLOCKS;
-			msbp->msb_delta = tp->t_fdblocks_delta;
-			msbp++;
-		}
 	}
 
 	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
-		if (tp->t_frextents_delta != 0) {
-			msbp->msb_field = XFS_SBS_FREXTENTS;
-			msbp->msb_delta = tp->t_frextents_delta;
-			msbp++;
-		}
 		if (tp->t_dblocks_delta != 0) {
 			msbp->msb_field = XFS_SBS_DBLOCKS;
 			msbp->msb_delta = tp->t_dblocks_delta;
