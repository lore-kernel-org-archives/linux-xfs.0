Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60096 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932793AbeF1Qgh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jun 2018 12:36:37 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1899EA2E56
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:37 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02E26111CA17
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:36 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 03/24] xfs: remove dfops parameter from ifree call stack
Date: Thu, 28 Jun 2018 12:36:15 -0400
Message-Id: <20180628163636.52564-4-bfoster@redhat.com>
In-Reply-To: <20180628163636.52564-1-bfoster@redhat.com>
References: <20180628163636.52564-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The inode free callchain starting in xfs_inactive_ifree() already
associates its dfops with the transaction. It still passes the dfops
on the stack down through xfs_difree_inobt(), however.

Clean up the call stack and reference dfops directly from the
transaction. This patch does not change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 6 ++----
 fs/xfs/libxfs/xfs_ialloc.h | 1 -
 fs/xfs/xfs_inode.c         | 9 ++++-----
 fs/xfs/xfs_inode.h         | 3 +--
 4 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 0d968e8143aa..c38d14106b53 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1915,7 +1915,6 @@ xfs_difree_inobt(
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
 	xfs_agino_t			agino,
-	struct xfs_defer_ops		*dfops,
 	struct xfs_icluster		*xic,
 	struct xfs_inobt_rec_incore	*orec)
 {
@@ -2003,7 +2002,7 @@ xfs_difree_inobt(
 			goto error0;
 		}
 
-		xfs_difree_inode_chunk(mp, agno, &rec, dfops);
+		xfs_difree_inode_chunk(mp, agno, &rec, tp->t_dfops);
 	} else {
 		xic->deleted = false;
 
@@ -2148,7 +2147,6 @@ int
 xfs_difree(
 	struct xfs_trans	*tp,		/* transaction pointer */
 	xfs_ino_t		inode,		/* inode to be freed */
-	struct xfs_defer_ops	*dfops,		/* extents to free */
 	struct xfs_icluster	*xic)	/* cluster info if deleted */
 {
 	/* REFERENCED */
@@ -2200,7 +2198,7 @@ xfs_difree(
 	/*
 	 * Fix up the inode allocation btree.
 	 */
-	error = xfs_difree_inobt(mp, tp, agbp, agino, dfops, xic, &rec);
+	error = xfs_difree_inobt(mp, tp, agbp, agino, xic, &rec);
 	if (error)
 		goto error0;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 90b09c5f163b..e936b7cc9389 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -82,7 +82,6 @@ int					/* error */
 xfs_difree(
 	struct xfs_trans *tp,		/* transaction pointer */
 	xfs_ino_t	inode,		/* inode to be freed */
-	struct xfs_defer_ops *dfops,	/* extents to free */
 	struct xfs_icluster *ifree);	/* cluster info if deleted */
 
 /*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9c5fbc94cf14..f5649a023d46 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1814,7 +1814,7 @@ xfs_inactive_ifree(
 
 	xfs_defer_init(&dfops, &first_block);
 	tp->t_dfops = &dfops;
-	error = xfs_ifree(tp, ip, &dfops);
+	error = xfs_ifree(tp, ip);
 	if (error) {
 		/*
 		 * If we fail to free the inode, shut down.  The cancel
@@ -2445,9 +2445,8 @@ xfs_ifree_local_data(
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
@@ -2466,7 +2465,7 @@ xfs_ifree(
 	if (error)
 		return error;
 
-	error = xfs_difree(tp, ip->i_ino, dfops, &xic);
+	error = xfs_difree(tp, ip->i_ino, &xic);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 2ed63a49e890..b1f0e8394f3b 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -415,8 +415,7 @@ uint		xfs_ilock_data_map_shared(struct xfs_inode *);
 uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
 
 uint		xfs_ip2xflags(struct xfs_inode *);
-int		xfs_ifree(struct xfs_trans *, xfs_inode_t *,
-			   struct xfs_defer_ops *);
+int		xfs_ifree(struct xfs_trans *, struct xfs_inode *);
 int		xfs_itruncate_extents_flags(struct xfs_trans **,
 				struct xfs_inode *, int, xfs_fsize_t, int);
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
-- 
2.17.1

