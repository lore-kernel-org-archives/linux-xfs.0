Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50922 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935595AbeF1Qgi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jun 2018 12:36:38 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3F47C4007874
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:38 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A921111CA17
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:38 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 13/24] xfs: use ->t_dfops for all xfs_bunmapi() callers
Date: Thu, 28 Jun 2018 12:36:25 -0400
Message-Id: <20180628163636.52564-14-bfoster@redhat.com>
In-Reply-To: <20180628163636.52564-1-bfoster@redhat.com>
References: <20180628163636.52564-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Use ->t_dfops for all remaining xfs_bunmapi() callers. This prepares
the latter to no longer require a dfops parameter.

Note that xfs_itruncate_extents_flags() associates a local dfops
with a transaction provided from the caller. Since there are
multiple callers, set and reset ->t_dfops before the function
returns to avoid exposure of stack memory to the caller.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c |  9 +++++----
 fs/xfs/xfs_inode.c     | 12 ++++++++----
 fs/xfs/xfs_reflink.c   | 27 +++++++++++++++------------
 fs/xfs/xfs_symlink.c   |  9 +++++----
 4 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index c40cb711447f..78189cf385f2 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1043,13 +1043,14 @@ xfs_unmap_extent(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	xfs_defer_init(&dfops, &firstfsb);
+	tp->t_dfops = &dfops;
 	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, &firstfsb,
-			&dfops, done);
+			tp->t_dfops, done);
 	if (error)
 		goto out_bmap_cancel;
 
-	xfs_defer_ijoin(&dfops, ip);
-	error = xfs_defer_finish(&tp, &dfops);
+	xfs_defer_ijoin(tp->t_dfops, ip);
+	error = xfs_defer_finish(&tp, tp->t_dfops);
 	if (error)
 		goto out_bmap_cancel;
 
@@ -1059,7 +1060,7 @@ xfs_unmap_extent(
 	return error;
 
 out_bmap_cancel:
-	xfs_defer_cancel(&dfops);
+	xfs_defer_cancel(tp->t_dfops);
 out_trans_cancel:
 	xfs_trans_cancel(tp);
 	goto out_unlock;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e1bc686b70b4..539d96201666 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1545,6 +1545,7 @@ xfs_itruncate_extents_flags(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp = *tpp;
+	struct xfs_defer_ops	*odfops = tp->t_dfops;
 	struct xfs_defer_ops	dfops;
 	xfs_fsblock_t		first_block;
 	xfs_fileoff_t		first_unmap_block;
@@ -1584,9 +1585,10 @@ xfs_itruncate_extents_flags(
 	unmap_len = last_block - first_unmap_block + 1;
 	while (!done) {
 		xfs_defer_init(&dfops, &first_block);
+		tp->t_dfops = &dfops;
 		error = xfs_bunmapi(tp, ip, first_unmap_block, unmap_len, flags,
 				    XFS_ITRUNC_MAX_EXTENTS, &first_block,
-				    &dfops, &done);
+				    tp->t_dfops, &done);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -1594,8 +1596,8 @@ xfs_itruncate_extents_flags(
 		 * Duplicate the transaction that has the permanent
 		 * reservation and commit the old transaction.
 		 */
-		xfs_defer_ijoin(&dfops, ip);
-		error = xfs_defer_finish(&tp, &dfops);
+		xfs_defer_ijoin(tp->t_dfops, ip);
+		error = xfs_defer_finish(&tp, tp->t_dfops);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -1623,6 +1625,8 @@ xfs_itruncate_extents_flags(
 	trace_xfs_itruncate_extents_end(ip, new_size);
 
 out:
+	/* ->t_dfops points to local stack, don't leak it! */
+	tp->t_dfops = odfops;
 	*tpp = tp;
 	return error;
 out_bmap_cancel:
@@ -1631,7 +1635,7 @@ xfs_itruncate_extents_flags(
 	 * the transaction can be properly aborted.  We just need to make sure
 	 * we're not holding any resources that we were not when we came in.
 	 */
-	xfs_defer_cancel(&dfops);
+	xfs_defer_cancel(tp->t_dfops);
 	goto out;
 }
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 3b2b8f5851c0..bb22a17fbca8 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -763,9 +763,10 @@ xfs_reflink_end_cow(
 
 		/* Unmap the old blocks in the data fork. */
 		xfs_defer_init(&dfops, &firstfsb);
+		tp->t_dfops = &dfops;
 		rlen = del.br_blockcount;
 		error = __xfs_bunmapi(tp, ip, del.br_startoff, &rlen, 0, 1,
-				&firstfsb, &dfops);
+				&firstfsb, tp->t_dfops);
 		if (error)
 			goto out_defer;
 
@@ -777,13 +778,14 @@ xfs_reflink_end_cow(
 		trace_xfs_reflink_cow_remap(ip, &del);
 
 		/* Free the CoW orphan record. */
-		error = xfs_refcount_free_cow_extent(tp->t_mountp, &dfops,
+		error = xfs_refcount_free_cow_extent(tp->t_mountp, tp->t_dfops,
 				del.br_startblock, del.br_blockcount);
 		if (error)
 			goto out_defer;
 
 		/* Map the new blocks into the data fork. */
-		error = xfs_bmap_map_extent(tp->t_mountp, &dfops, ip, &del);
+		error = xfs_bmap_map_extent(tp->t_mountp, tp->t_dfops, ip,
+					    &del);
 		if (error)
 			goto out_defer;
 
@@ -794,8 +796,8 @@ xfs_reflink_end_cow(
 		/* Remove the mapping from the CoW fork. */
 		xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
 
-		xfs_defer_ijoin(&dfops, ip);
-		error = xfs_defer_finish(&tp, &dfops);
+		xfs_defer_ijoin(tp->t_dfops, ip);
+		error = xfs_defer_finish(&tp, tp->t_dfops);
 		if (error)
 			goto out_defer;
 		if (!xfs_iext_get_extent(ifp, &icur, &got))
@@ -813,7 +815,7 @@ xfs_reflink_end_cow(
 	return 0;
 
 out_defer:
-	xfs_defer_cancel(&dfops);
+	xfs_defer_cancel(tp->t_dfops);
 out_cancel:
 	xfs_trans_cancel(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -1112,8 +1114,9 @@ xfs_reflink_remap_extent(
 	rlen = unmap_len;
 	while (rlen) {
 		xfs_defer_init(&dfops, &firstfsb);
+		tp->t_dfops = &dfops;
 		error = __xfs_bunmapi(tp, ip, destoff, &rlen, 0, 1,
-				&firstfsb, &dfops);
+				&firstfsb, tp->t_dfops);
 		if (error)
 			goto out_defer;
 
@@ -1134,12 +1137,12 @@ xfs_reflink_remap_extent(
 				uirec.br_blockcount, uirec.br_startblock);
 
 		/* Update the refcount tree */
-		error = xfs_refcount_increase_extent(mp, &dfops, &uirec);
+		error = xfs_refcount_increase_extent(mp, tp->t_dfops, &uirec);
 		if (error)
 			goto out_defer;
 
 		/* Map the new blocks into the data fork. */
-		error = xfs_bmap_map_extent(mp, &dfops, ip, &uirec);
+		error = xfs_bmap_map_extent(mp, tp->t_dfops, ip, &uirec);
 		if (error)
 			goto out_defer;
 
@@ -1160,8 +1163,8 @@ xfs_reflink_remap_extent(
 
 next_extent:
 		/* Process all the deferred stuff. */
-		xfs_defer_ijoin(&dfops, ip);
-		error = xfs_defer_finish(&tp, &dfops);
+		xfs_defer_ijoin(tp->t_dfops, ip);
+		error = xfs_defer_finish(&tp, tp->t_dfops);
 		if (error)
 			goto out_defer;
 	}
@@ -1173,7 +1176,7 @@ xfs_reflink_remap_extent(
 	return 0;
 
 out_defer:
-	xfs_defer_cancel(&dfops);
+	xfs_defer_cancel(tp->t_dfops);
 out_cancel:
 	xfs_trans_cancel(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 2b6bcfd39c14..290ae13d4673 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -444,6 +444,7 @@ xfs_inactive_symlink_rmt(
 	 */
 	done = 0;
 	xfs_defer_init(&dfops, &first_block);
+	tp->t_dfops = &dfops;
 	nmaps = ARRAY_SIZE(mval);
 	error = xfs_bmapi_read(ip, 0, xfs_symlink_blocks(mp, size),
 				mval, &nmaps, 0);
@@ -466,15 +467,15 @@ xfs_inactive_symlink_rmt(
 	 * Unmap the dead block(s) to the dfops.
 	 */
 	error = xfs_bunmapi(tp, ip, 0, size, 0, nmaps,
-			    &first_block, &dfops, &done);
+			    &first_block, tp->t_dfops, &done);
 	if (error)
 		goto error_bmap_cancel;
 	ASSERT(done);
 	/*
 	 * Commit the first transaction.  This logs the EFI and the inode.
 	 */
-	xfs_defer_ijoin(&dfops, ip);
-	error = xfs_defer_finish(&tp, &dfops);
+	xfs_defer_ijoin(tp->t_dfops, ip);
+	error = xfs_defer_finish(&tp, tp->t_dfops);
 	if (error)
 		goto error_bmap_cancel;
 
@@ -499,7 +500,7 @@ xfs_inactive_symlink_rmt(
 	return 0;
 
 error_bmap_cancel:
-	xfs_defer_cancel(&dfops);
+	xfs_defer_cancel(tp->t_dfops);
 error_trans_cancel:
 	xfs_trans_cancel(tp);
 error_unlock:
-- 
2.17.1

