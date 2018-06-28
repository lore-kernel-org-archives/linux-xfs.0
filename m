Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33710 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935611AbeF1Qgj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jun 2018 12:36:39 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2CC084075740
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:39 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17F59111CA17
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:39 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 21/24] xfs: use ->t_dfops for rmap extent swap operations
Date: Thu, 28 Jun 2018 12:36:33 -0400
Message-Id: <20180628163636.52564-22-bfoster@redhat.com>
In-Reply-To: <20180628163636.52564-1-bfoster@redhat.com>
References: <20180628163636.52564-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_swap_extent_rmap() uses a local dfops instance with a
transaction from the caller. Since there is only one caller, pull
the dfops structure into the caller and attach it to the
transaction. This avoids the need to clear ->t_dfops to prevent
invalid stack memory access.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2c0c9534941c..4fdf013603ab 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1570,6 +1570,8 @@ xfs_swap_extent_rmap(
 	struct xfs_inode		*ip,
 	struct xfs_inode		*tip)
 {
+	struct xfs_trans		*tp = *tpp;
+	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_bmbt_irec		irec;
 	struct xfs_bmbt_irec		uirec;
 	struct xfs_bmbt_irec		tirec;
@@ -1577,7 +1579,6 @@ xfs_swap_extent_rmap(
 	xfs_fileoff_t			end_fsb;
 	xfs_filblks_t			count_fsb;
 	xfs_fsblock_t			firstfsb;
-	struct xfs_defer_ops		dfops;
 	int				error;
 	xfs_filblks_t			ilen;
 	xfs_filblks_t			rlen;
@@ -1613,7 +1614,7 @@ xfs_swap_extent_rmap(
 
 		/* Unmap the old blocks in the source file. */
 		while (tirec.br_blockcount) {
-			xfs_defer_init(&dfops, &firstfsb);
+			xfs_defer_init(tp->t_dfops, &firstfsb);
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &tirec);
 
 			/* Read extent from the source file */
@@ -1635,31 +1636,32 @@ xfs_swap_extent_rmap(
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
 
 			/* Remove the mapping from the donor file. */
-			error = xfs_bmap_unmap_extent((*tpp)->t_mountp, &dfops,
-					tip, &uirec);
+			error = xfs_bmap_unmap_extent(mp, tp->t_dfops, tip,
+					&uirec);
 			if (error)
 				goto out_defer;
 
 			/* Remove the mapping from the source file. */
-			error = xfs_bmap_unmap_extent((*tpp)->t_mountp, &dfops,
-					ip, &irec);
+			error = xfs_bmap_unmap_extent(mp, tp->t_dfops, ip,
+					&irec);
 			if (error)
 				goto out_defer;
 
 			/* Map the donor file's blocks into the source file. */
-			error = xfs_bmap_map_extent((*tpp)->t_mountp, &dfops,
-					ip, &uirec);
+			error = xfs_bmap_map_extent(mp, tp->t_dfops, ip,
+					&uirec);
 			if (error)
 				goto out_defer;
 
 			/* Map the source file's blocks into the donor file. */
-			error = xfs_bmap_map_extent((*tpp)->t_mountp, &dfops,
-					tip, &irec);
+			error = xfs_bmap_map_extent(mp, tp->t_dfops, tip,
+					&irec);
 			if (error)
 				goto out_defer;
 
-			xfs_defer_ijoin(&dfops, ip);
-			error = xfs_defer_finish(tpp, &dfops);
+			xfs_defer_ijoin(tp->t_dfops, ip);
+			error = xfs_defer_finish(tpp, tp->t_dfops);
+			tp = *tpp;
 			if (error)
 				goto out_defer;
 
@@ -1679,7 +1681,7 @@ xfs_swap_extent_rmap(
 	return 0;
 
 out_defer:
-	xfs_defer_cancel(&dfops);
+	xfs_defer_cancel(tp->t_dfops);
 out:
 	trace_xfs_swap_extent_rmap_error(ip, error, _RET_IP_);
 	tip->i_d.di_flags2 = tip_flags2;
@@ -1846,6 +1848,7 @@ xfs_swap_extents(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
+	struct xfs_defer_ops	dfops;
 	struct xfs_bstat	*sbp = &sxp->sx_stat;
 	int			src_log_flags, target_log_flags;
 	int			error = 0;
@@ -1853,6 +1856,7 @@ xfs_swap_extents(
 	struct xfs_ifork	*cowfp;
 	uint64_t		f;
 	int			resblks = 0;
+	xfs_fsblock_t		firstfsb;
 
 	/*
 	 * Lock the inodes against other IO, page faults and truncate to
@@ -1915,6 +1919,8 @@ xfs_swap_extents(
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
 	if (error)
 		goto out_unlock;
+	xfs_defer_init(&dfops, &firstfsb);
+	tp->t_dfops = &dfops;
 
 	/*
 	 * Lock and join the inodes to the tansaction so that transaction commit
-- 
2.17.1

