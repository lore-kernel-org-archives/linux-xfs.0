Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752163AbeDJRqd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Apr 2018 13:46:33 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B824A6DDE3
        for <linux-xfs@vger.kernel.org>; Tue, 10 Apr 2018 17:46:33 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 846EA82C66
        for <linux-xfs@vger.kernel.org>; Tue, 10 Apr 2018 17:46:33 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 5/7] xfs: defer agfl frees from inode inactivation
Date: Tue, 10 Apr 2018 13:46:29 -0400
Message-Id: <20180410174631.4915-6-bfoster@redhat.com>
In-Reply-To: <20180410174631.4915-1-bfoster@redhat.com>
References: <20180410174631.4915-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

XFS inode chunks are already freed via deferred operations (which
now also defer AGFL block frees), but inode btree blocks are freed
directly in the associated context. This has been known to lead to
log reservation overruns in particular workloads where an inobt
block free may require several AGFL block frees (and thus several
allocation btree modifications) before the inobt block itself is
actually freed.

To avoid this problem, we want to defer the frees of any AGFL blocks
that must be dropped before the inobt block free can take place.
This requires passing the dfops from xfs_inactive_ifree() down
through the inobt ->[alloc|free]_block() callouts, which essentially
only requires to attach the dfops to the transaction since it is
already carried all the way through to the inobt update and
allocation.

Since dfops is attached to the transaction, we no longer have to
pass it down explicitly through xfs_difree() and friends to defer
the physical inode chunk free. Kill two stones with one bird and
clean up the entire codepath to reference ->t_dfops.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c |  6 ++----
 fs/xfs/libxfs/xfs_ialloc.h |  1 -
 fs/xfs/xfs_inode.c         | 16 ++++++++++------
 fs/xfs/xfs_inode.h         |  3 +--
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index de627fa19168..c7d8295f3ec1 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1897,7 +1897,6 @@ xfs_difree_inobt(
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
 	xfs_agino_t			agino,
-	struct xfs_defer_ops		*dfops,
 	struct xfs_icluster		*xic,
 	struct xfs_inobt_rec_incore	*orec)
 {
@@ -1984,7 +1983,7 @@ xfs_difree_inobt(
 			goto error0;
 		}
 
-		xfs_difree_inode_chunk(mp, agno, &rec, dfops);
+		xfs_difree_inode_chunk(mp, agno, &rec, tp->t_dfops);
 	} else {
 		xic->deleted = false;
 
@@ -2129,7 +2128,6 @@ int
 xfs_difree(
 	struct xfs_trans	*tp,		/* transaction pointer */
 	xfs_ino_t		inode,		/* inode to be freed */
-	struct xfs_defer_ops	*dfops,		/* extents to free */
 	struct xfs_icluster	*xic)	/* cluster info if deleted */
 {
 	/* REFERENCED */
@@ -2181,7 +2179,7 @@ xfs_difree(
 	/*
 	 * Fix up the inode allocation btree.
 	 */
-	error = xfs_difree_inobt(mp, tp, agbp, agino, dfops, xic, &rec);
+	error = xfs_difree_inobt(mp, tp, agbp, agino, xic, &rec);
 	if (error)
 		goto error0;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index c5402bb4ce0c..884562efd708 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -94,7 +94,6 @@ int					/* error */
 xfs_difree(
 	struct xfs_trans *tp,		/* transaction pointer */
 	xfs_ino_t	inode,		/* inode to be freed */
-	struct xfs_defer_ops *dfops,	/* extents to free */
 	struct xfs_icluster *ifree);	/* cluster info if deleted */
 
 /*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0c2e53fbc0f0..117dced8bf66 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1808,8 +1808,13 @@ xfs_inactive_ifree(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	xfs_defer_init(NULL, &dfops, &first_block);
-	error = xfs_ifree(tp, ip, &dfops);
+	/*
+	 * Attach dfops to tp to defer any physical inode chunk frees and/or
+	 * AGFL block frees that occur as a result of inobt block allocation
+	 * operations.
+	 */
+	xfs_defer_init(tp, &dfops, &first_block);
+	error = xfs_ifree(tp, ip);
 	if (error) {
 		/*
 		 * If we fail to free the inode, shut down.  The cancel
@@ -2431,9 +2436,8 @@ xfs_ifree_local_data(
  */
 int
 xfs_ifree(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip,
-	struct xfs_defer_ops	*dfops)
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
 {
 	int			error;
 	struct xfs_icluster	xic = { 0 };
@@ -2452,7 +2456,7 @@ xfs_ifree(
 	if (error)
 		return error;
 
-	error = xfs_difree(tp, ip->i_ino, dfops, &xic);
+	error = xfs_difree(tp, ip->i_ino, &xic);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 1eebc53df7d7..9e1ec46f31a2 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -413,8 +413,7 @@ uint		xfs_ilock_data_map_shared(struct xfs_inode *);
 uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
 
 uint		xfs_ip2xflags(struct xfs_inode *);
-int		xfs_ifree(struct xfs_trans *, xfs_inode_t *,
-			   struct xfs_defer_ops *);
+int		xfs_ifree(struct xfs_trans *, struct xfs_inode *);
 int		xfs_itruncate_extents(struct xfs_trans **, struct xfs_inode *,
 				      int, xfs_fsize_t);
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
-- 
2.13.6

