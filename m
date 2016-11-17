Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:65460 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752338AbcKQX5H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2016 18:57:07 -0500
Received: from disappointment.disaster.area ([192.168.1.110] helo=disappointment)
        by dastard with esmtp (Exim 4.80)
        (envelope-from <dave@fromorbit.com>)
        id 1c7WWq-0008NS-PY
        for linux-xfs@vger.kernel.org; Fri, 18 Nov 2016 10:55:40 +1100
Received: from dave by disappointment with local (Exim 4.87)
        (envelope-from <dave@disappointment.disaster>)
        id 1c7WWr-00020N-NV
        for linux-xfs@vger.kernel.org; Fri, 18 Nov 2016 10:55:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfs: defer indirect delalloc rmap reservations
Date: Fri, 18 Nov 2016 10:55:35 +1100
Message-Id: <1479426935-7112-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1479426935-7112-1-git-send-email-david@fromorbit.com>
References: <20161117213224.GD28177@dastard>
 <1479426935-7112-1-git-send-email-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When we do rmap additions for delalloc extents, we need to ensure we
have space reserved for them. We do this by keeping the space
required in the indirect length associated with a delalloc extent.

However, when we allocate the extent, we immediately release the
unused portion of the indlen reservation, and hence when we come to
needing it when processing the deferred rmap btree insertion, it's
no longer available. Because it gets returned to the global free
space pool, other delalloc reservations can take it before we use
it, resulting in having no space available to fix up the free list
to the correct length before doing the rmap insertion. This results
in an insertion failure and shutdown.

To avoid this problem, rather than releasing the unused indlen
reservation, store it in the transaction to be released when the
transaction is finally committed. When we roll a transaction during
defer ops processing, we transfer the unused block reservation to
the new transaction before we commit the old one. This keeps the
unused reservation local to the deferred ops context. On final
commit, the unused reservation space can be returned to the global
pool.

The final piece of the puzzle is hooking this up to the free list
fixup that ensures we have enough blocks on the free list for the
rmap insert. In this case, ensure that xfs_rmapbt_alloc_block()
always decrements a block from the reservation on the transaction.
This will track the number of blocks we've actually consumed from
the free list for the rmapbt, hence ensuring that we accurately
account of those blocks when the final transaction commit occurs.

Because we now hold the delalloc rmapbt block reservation until
we've done all the rmapbt block allocation, we should not see ENOSPC
problems as a result of the AGFL being emptied during rmap btree
insertion operations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 14 ++++++++++++++
 fs/xfs/libxfs/xfs_bmap.c  | 16 ++++++++++++----
 fs/xfs/xfs_trans.c        | 28 ++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h        |  1 +
 4 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index a5a9d8360e74..e835bf24a85b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2228,6 +2228,20 @@ xfs_alloc_fix_freelist(
 							agflbp, bno, 0);
 			if (error)
 				goto out_agflbp_relse;
+
+			/*
+			 * If we've just done a delayed allocation and now we
+			 * are processing a deferred metadata update (such as an
+			 * rmapbt update), we'll have a space reservation for
+			 * the rmapbt blocks that may be needed. These are
+			 * allocated from the freelist, so account for them here
+			 * when we refill the AGFL. We've held the AGF locked
+			 * across the defered transactions, so this should only
+			 * be refilling blocks we consumed from the AGFL in the
+			 * preceeding transaction.
+			 */
+			if (tp->t_blk_deferred)
+				tp->t_blk_deferred--;
 		}
 	}
 	xfs_trans_brelse(tp, agflbp);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6211b4b5e826..f1db9a03e4c4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2203,10 +2203,19 @@ xfs_bmap_add_extent_delay_real(
 		temp2 = xfs_bmap_worst_indlen(bma->ip, temp2);
 		diff = (int)(temp + temp2 - startblockval(PREV.br_startblock) -
 			(bma->cur ? bma->cur->bc_private.b.allocated : 0));
+
 		if (diff > 0) {
+			/*
+			 * XXX (dgc): Ouch! Pulling more blocks from the free pool
+			 * during allocation during delalloc split. This will
+			 * fail at ENOSPC and it screws up rmapbt space
+			 * accounting. We need to know when this happens so
+			 * we can isolate the typical causes of reservation
+			 * underruns so that they never happen in production.
+			 */
+			ASSERT(0);
 			error = xfs_mod_fdblocks(bma->ip->i_mount,
 						 -((int64_t)diff), false);
-			ASSERT(!error);
 			if (error)
 				goto done;
 		}
@@ -2261,8 +2270,7 @@ xfs_bmap_add_extent_delay_real(
 			temp += bma->cur->bc_private.b.allocated;
 		ASSERT(temp <= da_old);
 		if (temp < da_old)
-			xfs_mod_fdblocks(bma->ip->i_mount,
-					(int64_t)(da_old - temp), false);
+			bma->tp->t_blk_deferred += (int64_t)(da_old - temp);
 	}
 
 	/* clear out the allocated field, done with it now in any case. */
@@ -5437,7 +5445,7 @@ xfs_bmap_del_extent(
 	 */
 	ASSERT(da_old >= da_new);
 	if (da_old > da_new)
-		xfs_mod_fdblocks(mp, (int64_t)(da_old - da_new), false);
+		tp->t_blk_deferred += (int64_t)(da_old - da_new);
 done:
 	*logflagsp = flags;
 	return error;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 70f42ea86dfb..0728ff7a04ab 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -103,6 +103,16 @@ xfs_trans_dup(
 	tp->t_rtx_res = tp->t_rtx_res_used;
 	ntp->t_pflags = tp->t_pflags;
 
+	/*
+	 * Transfer deferred block reservations to new transaction so the remain
+	 * available to the ongoing deferred ops processing. We clear the
+	 * existing transaction count so that the deferred block reservation is
+	 * not released when that transaction is committed (i.e. it's not a
+	 * regrantable reservation).
+	 */
+	ntp->t_blk_deferred = tp->t_blk_deferred;
+	tp->t_blk_deferred = 0;
+
 	xfs_trans_dup_dqinfo(tp, ntp);
 
 	atomic_inc(&tp->t_mountp->m_active_trans);
@@ -680,6 +690,21 @@ xfs_trans_unreserve_and_mod_sb(
 }
 
 /*
+ * Release unused defered block reservations back to the global free space pool.
+ * These blocks came from the in-core counter, so return them there.
+ */
+static void
+xfs_trans_release_deferred_blocks(
+	struct xfs_trans	*tp)
+{
+	ASSERT(tp->t_blk_deferred >= 0);
+	if (!tp->t_blk_deferred)
+		return;
+	xfs_mod_fdblocks(tp->t_mountp, tp->t_blk_deferred,
+			 !!(tp->t_flags & XFS_TRANS_RESERVE));
+}
+
+/*
  * Add the given log item to the transaction's list of log items.
  *
  * The log item will now point to its new descriptor with its li_desc field.
@@ -908,6 +933,7 @@ __xfs_trans_commit(
 	/*
 	 * If we need to update the superblock, then do it now.
 	 */
+	xfs_trans_release_deferred_blocks(tp);
 	if (tp->t_flags & XFS_TRANS_SB_DIRTY)
 		xfs_trans_apply_sb_deltas(tp);
 	xfs_trans_apply_dquot_deltas(tp);
@@ -931,6 +957,7 @@ __xfs_trans_commit(
 	return error;
 
 out_unreserve:
+	xfs_trans_release_deferred_blocks(tp);
 	xfs_trans_unreserve_and_mod_sb(tp);
 
 	/*
@@ -991,6 +1018,7 @@ xfs_trans_cancel(
 			ASSERT(!(lidp->lid_item->li_type == XFS_LI_EFD));
 	}
 #endif
+	xfs_trans_release_deferred_blocks(tp);
 	xfs_trans_unreserve_and_mod_sb(tp);
 	xfs_trans_unreserve_and_mod_dquots(tp);
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 61b7fbdd3ebd..6126e6fb9f5c 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -132,6 +132,7 @@ typedef struct xfs_trans {
 	int64_t			t_rblocks_delta;/* superblock rblocks change */
 	int64_t			t_rextents_delta;/* superblocks rextents chg */
 	int64_t			t_rextslog_delta;/* superblocks rextslog chg */
+	int64_t			t_blk_deferred;	/* blocks for deferred ops */
 	struct list_head	t_items;	/* log item descriptors */
 	struct list_head	t_busy;		/* list of busy extents */
 	unsigned long		t_pflags;	/* saved process flags state */
-- 
2.8.0.rc3

