Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47906 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731765AbeGSOch (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jul 2018 10:32:37 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C154B40201CF
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 13:49:20 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD6051C5B0
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 13:49:20 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 11/14] xfs: use internal dfops during [b|c]ui recovery
Date: Thu, 19 Jul 2018 09:49:16 -0400
Message-Id: <20180719134919.29939-12-bfoster@redhat.com>
In-Reply-To: <20180719134919.29939-1-bfoster@redhat.com>
References: <20180719134919.29939-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

bmap and refcount intent processing associates a dfops from the
caller with a local transaction to collect all deferred items for
post-processing. Use the internal dfops in both of these functions
and move the deferred items to the parent dfops before the
transaction commits.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_item.c     | 21 +++++++++++----------
 fs/xfs/xfs_log_recover.c   |  6 +++---
 fs/xfs/xfs_refcount_item.c | 30 ++++++++++++++++--------------
 3 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 478bfc798861..bc5eb2e0ab0c 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -441,7 +441,12 @@ xfs_bui_recover(
 			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
 	if (error)
 		return error;
-	tp->t_dfops = dfops;
+	/*
+	 * Recovery stashes all deferred ops during intent processing and
+	 * finishes them on completion. Transfer current dfops state to this
+	 * transaction and transfer the result back before we return.
+	 */
+	xfs_defer_move(tp->t_dfops, dfops);
 	budp = xfs_trans_get_bud(tp, buip);
 
 	/* Grab the inode. */
@@ -470,7 +475,7 @@ xfs_bui_recover(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	count = bmap->me_len;
-	error = xfs_trans_log_finish_bmap_update(tp, budp, dfops, type,
+	error = xfs_trans_log_finish_bmap_update(tp, budp, tp->t_dfops, type,
 			ip, whichfork, bmap->me_startoff,
 			bmap->me_startblock, &count, state);
 	if (error)
@@ -482,18 +487,14 @@ xfs_bui_recover(
 		irec.br_blockcount = count;
 		irec.br_startoff = bmap->me_startoff;
 		irec.br_state = state;
-		error = xfs_bmap_unmap_extent(tp->t_mountp, dfops, ip, &irec);
+		error = xfs_bmap_unmap_extent(tp->t_mountp, tp->t_dfops, ip,
+					      &irec);
 		if (error)
 			goto err_inode;
 	}
 
 	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
-	/*
-	 * Recovery finishes all deferred ops once intent processing is
-	 * complete. Reset the trans reference because commit expects a finished
-	 * dfops or none at all.
-	 */
-	tp->t_dfops = NULL;
+	xfs_defer_move(dfops, tp->t_dfops);
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	IRELE(ip);
@@ -501,7 +502,7 @@ xfs_bui_recover(
 	return error;
 
 err_inode:
-	tp->t_dfops = NULL;
+	xfs_defer_move(dfops, tp->t_dfops);
 	xfs_trans_cancel(tp);
 	if (ip) {
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 3289811eb076..958e9b96dc6a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4854,10 +4854,10 @@ xlog_finish_defer_ops(
 			0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
-	/* dfops is already populated so assign it manually */
-	tp->t_dfops = dfops;
+	/* transfer all collected dfops to this transaction */
+	xfs_defer_move(tp->t_dfops, dfops);
 
-	error = xfs_defer_finish(&tp, dfops);
+	error = xfs_defer_finish(&tp, tp->t_dfops);
 	if (error)
 		goto out_cancel;
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 2064c689bc72..d3582a06626f 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -452,7 +452,12 @@ xfs_cui_recover(
 			mp->m_refc_maxlevels * 2, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
-	tp->t_dfops = dfops;
+	/*
+	 * Recovery stashes all deferred ops during intent processing and
+	 * finishes them on completion. Transfer current dfops state to this
+	 * transaction and transfer the result back before we return.
+	 */
+	xfs_defer_move(tp->t_dfops, dfops);
 	cudp = xfs_trans_get_cud(tp, cuip);
 
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
@@ -474,8 +479,8 @@ xfs_cui_recover(
 			new_len = refc->pe_len;
 		} else
 			error = xfs_trans_log_finish_refcount_update(tp, cudp,
-				dfops, type, refc->pe_startblock, refc->pe_len,
-				&new_fsb, &new_len, &rcur);
+				tp->t_dfops, type, refc->pe_startblock,
+				refc->pe_len, &new_fsb, &new_len, &rcur);
 		if (error)
 			goto abort_error;
 
@@ -486,21 +491,23 @@ xfs_cui_recover(
 			switch (type) {
 			case XFS_REFCOUNT_INCREASE:
 				error = xfs_refcount_increase_extent(
-						tp->t_mountp, dfops, &irec);
+						tp->t_mountp, tp->t_dfops,
+						&irec);
 				break;
 			case XFS_REFCOUNT_DECREASE:
 				error = xfs_refcount_decrease_extent(
-						tp->t_mountp, dfops, &irec);
+						tp->t_mountp, tp->t_dfops,
+						&irec);
 				break;
 			case XFS_REFCOUNT_ALLOC_COW:
 				error = xfs_refcount_alloc_cow_extent(
-						tp->t_mountp, dfops,
+						tp->t_mountp, tp->t_dfops,
 						irec.br_startblock,
 						irec.br_blockcount);
 				break;
 			case XFS_REFCOUNT_FREE_COW:
 				error = xfs_refcount_free_cow_extent(
-						tp->t_mountp, dfops,
+						tp->t_mountp, tp->t_dfops,
 						irec.br_startblock,
 						irec.br_blockcount);
 				break;
@@ -515,18 +522,13 @@ xfs_cui_recover(
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
 	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
-	/*
-	 * Recovery finishes all deferred ops once intent processing is
-	 * complete. Reset the trans reference because commit expects a finished
-	 * dfops or none at all.
-	 */
-	tp->t_dfops = NULL;
+	xfs_defer_move(dfops, tp->t_dfops);
 	error = xfs_trans_commit(tp);
 	return error;
 
 abort_error:
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-	tp->t_dfops = NULL;
+	xfs_defer_move(dfops, tp->t_dfops);
 	xfs_trans_cancel(tp);
 	return error;
 }
-- 
2.17.1

