Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32644 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751845AbdEQBHh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2017 21:07:37 -0400
Date: Tue, 16 May 2017 18:07:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] xfs: avoid mount-time deadlock in CoW extent recovery
Message-ID: <20170517010728.GS4519@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Dave Chinner <david@fromorbit.com>

If a malicious user corrupts the refcount btree to cause a cycle between
different levels of the tree, the next mount attempt will deadlock in
the CoW recovery routine while grabbing buffer locks.  We can use the
ability to re-grab a buffer that was previous locked to a transaction to
avoid deadlocks, so do that here.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: leave a comment discussing why we use an empty transaction
---
 fs/xfs/libxfs/xfs_refcount.c |   39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index b177ef3..3d2b29b 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1629,10 +1629,24 @@ xfs_refcount_recover_cow_leftovers(
 	if (mp->m_sb.sb_agblocks >= XFS_REFC_COW_START)
 		return -EOPNOTSUPP;
 
-	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	/*
+	 * In this first part, we use an empty transaction to gather up
+	 * all the leftover CoW extents so that we can subsequently
+	 * delete them.  The empty transaction is used to avoid
+	 * a buffer lock deadlock if there happens to be a loop in the
+	 * refcountbt because we're allowed to re-grab a buffer that is
+	 * already attached to our transaction.  When we're done
+	 * recording the CoW debris we cancel the (empty) transaction
+	 * and everything goes away cleanly.
+	 */
+	error = xfs_trans_alloc_empty(mp, &tp);
 	if (error)
 		return error;
-	cur = xfs_refcountbt_init_cursor(mp, NULL, agbp, agno, NULL);
+
+	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+	if (error)
+		goto out_trans;
+	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
 
 	/* Find all the leftover CoW staging extents. */
 	INIT_LIST_HEAD(&debris);
@@ -1645,10 +1659,11 @@ xfs_refcount_recover_cow_leftovers(
 	if (error)
 		goto out_cursor;
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
-	xfs_buf_relse(agbp);
+	xfs_trans_brelse(tp, agbp);
+	xfs_trans_cancel(tp);
 
 	/* Now iterate the list to free the leftovers */
-	list_for_each_entry(rr, &debris, rr_list) {
+	list_for_each_entry_safe(rr, n, &debris, rr_list) {
 		/* Set up transaction. */
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0, &tp);
 		if (error)
@@ -1676,8 +1691,15 @@ xfs_refcount_recover_cow_leftovers(
 		error = xfs_trans_commit(tp);
 		if (error)
 			goto out_free;
+
+		list_del(&rr->rr_list);
+		kmem_free(rr);
 	}
 
+	return error;
+out_defer:
+	xfs_defer_cancel(&dfops);
+	xfs_trans_cancel(tp);
 out_free:
 	/* Free the leftover list */
 	list_for_each_entry_safe(rr, n, &debris, rr_list) {
@@ -1688,11 +1710,8 @@ xfs_refcount_recover_cow_leftovers(
 
 out_cursor:
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-	xfs_buf_relse(agbp);
-	goto out_free;
-
-out_defer:
-	xfs_defer_cancel(&dfops);
+	xfs_trans_brelse(tp, agbp);
+out_trans:
 	xfs_trans_cancel(tp);
-	goto out_free;
+	return error;
 }
