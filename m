Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A557CCA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C9DA2085B
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:08:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SCkBMonk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfKAWId (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:08:33 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53700 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAWIc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:08:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RFSKvq9HwQop/nnrDDTIjAVZJetp6J45ijV8pmgOE4U=; b=SCkBMonkHvXqLG8lTcR4rPK3j
        BBPkhT8cubdnXupnG0XwwE/lSa6ItdIfdA2FxB4aGDjTM5beYbkUbCDrHvFKClFH+SRD9+tFb90Zi
        vtVg1noKyKhXpB0MGrR9+3/eZRi9ZofeDGVn+Ph/+E/NaJ/rt8QkMru2RVPnvTptUYOW6CUcQ03+a
        5HgCX1bvqB/iMXsNSaismXoI3xeIjX+GfeiDvBhk8RL5Q3uy09McrEMIk8DxY9xn/yhOpN/msMUb7
        F/NGBrzk1svxvFIuDphduzoXrgC+dTPlIpWRwXCZ0M/Tp7wGe8IOHc12HTsKl/v9zD4nC3kSY8K6R
        6Q9/ls4aQ==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf5s-0005wk-Fm
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:08:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/34] xfs: devirtualize ->free_hdr_from_disk
Date:   Fri,  1 Nov 2019 15:06:57 -0700
Message-Id: <20191101220719.29100-13-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191101220719.29100-1-hch@lst.de>
References: <20191101220719.29100-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace the ->free_hdr_from_disk dir ops method with a directly called
xfs_dir_free_hdr_from_disk helper that takes care of the differences
between the v4 and v5 on-disk format.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.c | 30 -----------------------
 fs/xfs/libxfs/xfs_dir2.h      |  2 --
 fs/xfs/libxfs/xfs_dir2_leaf.c | 14 +++--------
 fs/xfs/libxfs/xfs_dir2_node.c | 46 +++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_dir2_priv.h |  5 ++--
 fs/xfs/scrub/dir.c            |  2 +-
 6 files changed, 43 insertions(+), 56 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index fe9e20698719..d0e541d9d335 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -468,18 +468,6 @@ xfs_dir3_db_to_fdindex(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
 	return db % xfs_dir3_free_max_bests(geo);
 }
 
-static void
-xfs_dir2_free_hdr_from_disk(
-	struct xfs_dir3_icfree_hdr	*to,
-	struct xfs_dir2_free		*from)
-{
-	to->magic = be32_to_cpu(from->hdr.magic);
-	to->firstdb = be32_to_cpu(from->hdr.firstdb);
-	to->nvalid = be32_to_cpu(from->hdr.nvalid);
-	to->nused = be32_to_cpu(from->hdr.nused);
-	ASSERT(to->magic == XFS_DIR2_FREE_MAGIC);
-}
-
 static void
 xfs_dir2_free_hdr_to_disk(
 	struct xfs_dir2_free		*to,
@@ -493,21 +481,6 @@ xfs_dir2_free_hdr_to_disk(
 	to->hdr.nused = cpu_to_be32(from->nused);
 }
 
-static void
-xfs_dir3_free_hdr_from_disk(
-	struct xfs_dir3_icfree_hdr	*to,
-	struct xfs_dir2_free		*from)
-{
-	struct xfs_dir3_free_hdr *hdr3 = (struct xfs_dir3_free_hdr *)from;
-
-	to->magic = be32_to_cpu(hdr3->hdr.magic);
-	to->firstdb = be32_to_cpu(hdr3->firstdb);
-	to->nvalid = be32_to_cpu(hdr3->nvalid);
-	to->nused = be32_to_cpu(hdr3->nused);
-
-	ASSERT(to->magic == XFS_DIR3_FREE_MAGIC);
-}
-
 static void
 xfs_dir3_free_hdr_to_disk(
 	struct xfs_dir2_free		*to,
@@ -555,7 +528,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 
 	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
 	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
-	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,
 	.free_max_bests = xfs_dir2_free_max_bests,
 	.free_bests_p = xfs_dir2_free_bests_p,
 	.db_to_fdb = xfs_dir2_db_to_fdb,
@@ -594,7 +566,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 
 	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
 	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
-	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,
 	.free_max_bests = xfs_dir2_free_max_bests,
 	.free_bests_p = xfs_dir2_free_bests_p,
 	.db_to_fdb = xfs_dir2_db_to_fdb,
@@ -633,7 +604,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 
 	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
 	.free_hdr_to_disk = xfs_dir3_free_hdr_to_disk,
-	.free_hdr_from_disk = xfs_dir3_free_hdr_from_disk,
 	.free_max_bests = xfs_dir3_free_max_bests,
 	.free_bests_p = xfs_dir3_free_bests_p,
 	.db_to_fdb = xfs_dir3_db_to_fdb,
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index ee18fc56a6a1..c3e6a6fb7e37 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -75,8 +75,6 @@ struct xfs_dir_ops {
 	int	free_hdr_size;
 	void	(*free_hdr_to_disk)(struct xfs_dir2_free *to,
 				    struct xfs_dir3_icfree_hdr *from);
-	void	(*free_hdr_from_disk)(struct xfs_dir3_icfree_hdr *to,
-				      struct xfs_dir2_free *from);
 	int	(*free_max_bests)(struct xfs_da_geometry *geo);
 	__be16 * (*free_bests_p)(struct xfs_dir2_free *free);
 	xfs_dir2_db_t (*db_to_fdb)(struct xfs_da_geometry *geo,
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 38d42fe1aa02..4b697dd85eab 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -113,7 +113,7 @@ xfs_dir3_leaf1_check(
 	} else if (leafhdr.magic != XFS_DIR2_LEAF1_MAGIC)
 		return __this_address;
 
-	return xfs_dir3_leaf_check_int(dp->i_mount, dp, &leafhdr, leaf);
+	return xfs_dir3_leaf_check_int(dp->i_mount, &leafhdr, leaf);
 }
 
 static inline void
@@ -138,23 +138,15 @@ xfs_dir3_leaf_check(
 xfs_failaddr_t
 xfs_dir3_leaf_check_int(
 	struct xfs_mount	*mp,
-	struct xfs_inode	*dp,
 	struct xfs_dir3_icleaf_hdr *hdr,
 	struct xfs_dir2_leaf	*leaf)
 {
 	xfs_dir2_leaf_tail_t	*ltp;
 	int			stale;
 	int			i;
-	const struct xfs_dir_ops *ops;
 	struct xfs_dir3_icleaf_hdr leafhdr;
 	struct xfs_da_geometry	*geo = mp->m_dir_geo;
 
-	/*
-	 * we can be passed a null dp here from a verifier, so we need to go the
-	 * hard way to get them.
-	 */
-	ops = xfs_dir_get_ops(mp, dp);
-
 	if (!hdr) {
 		xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
 		hdr = &leafhdr;
@@ -208,7 +200,7 @@ xfs_dir3_leaf_verify(
 	if (fa)
 		return fa;
 
-	return xfs_dir3_leaf_check_int(mp, NULL, NULL, leaf);
+	return xfs_dir3_leaf_check_int(mp, NULL, leaf);
 }
 
 static void
@@ -1756,7 +1748,7 @@ xfs_dir2_node_to_leaf(
 	if (error)
 		return error;
 	free = fbp->b_addr;
-	dp->d_ops->free_hdr_from_disk(&freehdr, free);
+	xfs_dir2_free_hdr_from_disk(mp, &freehdr, free);
 
 	ASSERT(!freehdr.firstdb);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 3b9ed6ac72b6..9e22710bb772 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -54,7 +54,7 @@ xfs_dir3_leafn_check(
 	} else if (leafhdr.magic != XFS_DIR2_LEAFN_MAGIC)
 		return __this_address;
 
-	return xfs_dir3_leaf_check_int(dp->i_mount, dp, &leafhdr, leaf);
+	return xfs_dir3_leaf_check_int(dp->i_mount, &leafhdr, leaf);
 }
 
 static inline void
@@ -220,6 +220,30 @@ __xfs_dir3_free_read(
 	return 0;
 }
 
+void
+xfs_dir2_free_hdr_from_disk(
+	struct xfs_mount		*mp,
+	struct xfs_dir3_icfree_hdr	*to,
+	struct xfs_dir2_free		*from)
+{
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dir3_free	*from3 = (struct xfs_dir3_free *)from;
+
+		to->magic = be32_to_cpu(from3->hdr.hdr.magic);
+		to->firstdb = be32_to_cpu(from3->hdr.firstdb);
+		to->nvalid = be32_to_cpu(from3->hdr.nvalid);
+		to->nused = be32_to_cpu(from3->hdr.nused);
+
+		ASSERT(to->magic == XFS_DIR3_FREE_MAGIC);
+	} else {
+		to->magic = be32_to_cpu(from->hdr.magic);
+		to->firstdb = be32_to_cpu(from->hdr.firstdb);
+		to->nvalid = be32_to_cpu(from->hdr.nvalid);
+		to->nused = be32_to_cpu(from->hdr.nused);
+		ASSERT(to->magic == XFS_DIR2_FREE_MAGIC);
+	}
+}
+
 int
 xfs_dir2_free_read(
 	struct xfs_trans	*tp,
@@ -369,7 +393,7 @@ xfs_dir2_leaf_to_node(
 		return error;
 
 	free = fbp->b_addr;
-	dp->d_ops->free_hdr_from_disk(&freehdr, free);
+	xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, free);
 	leaf = lbp->b_addr;
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	if (be32_to_cpu(ltp->bestcount) >
@@ -509,7 +533,7 @@ xfs_dir2_free_hdr_check(
 {
 	struct xfs_dir3_icfree_hdr hdr;
 
-	dp->d_ops->free_hdr_from_disk(&hdr, bp->b_addr);
+	xfs_dir2_free_hdr_from_disk(dp->i_mount, &hdr, bp->b_addr);
 
 	ASSERT((hdr.firstdb %
 		dp->d_ops->free_max_bests(dp->i_mount->m_dir_geo)) == 0);
@@ -1117,7 +1141,7 @@ xfs_dir3_data_block_free(
 	struct xfs_dir3_icfree_hdr freehdr;
 	struct xfs_inode	*dp = args->dp;
 
-	dp->d_ops->free_hdr_from_disk(&freehdr, free);
+	xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, free);
 	bests = dp->d_ops->free_bests_p(free);
 	if (hdr) {
 		/*
@@ -1286,7 +1310,8 @@ xfs_dir2_leafn_remove(
 #ifdef DEBUG
 	{
 		struct xfs_dir3_icfree_hdr freehdr;
-		dp->d_ops->free_hdr_from_disk(&freehdr, free);
+
+		xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, free);
 		ASSERT(freehdr.firstdb == dp->d_ops->free_max_bests(args->geo) *
 			(fdb - xfs_dir2_byte_to_db(args->geo,
 						   XFS_DIR2_FREE_OFFSET)));
@@ -1680,7 +1705,7 @@ xfs_dir2_node_add_datablk(
 			return error;
 		free = fbp->b_addr;
 		bests = dp->d_ops->free_bests_p(free);
-		dp->d_ops->free_hdr_from_disk(&freehdr, free);
+		xfs_dir2_free_hdr_from_disk(mp, &freehdr, free);
 
 		/* Remember the first slot as our empty slot. */
 		freehdr.firstdb = (fbno - xfs_dir2_byte_to_db(args->geo,
@@ -1689,7 +1714,7 @@ xfs_dir2_node_add_datablk(
 	} else {
 		free = fbp->b_addr;
 		bests = dp->d_ops->free_bests_p(free);
-		dp->d_ops->free_hdr_from_disk(&freehdr, free);
+		xfs_dir2_free_hdr_from_disk(mp, &freehdr, free);
 	}
 
 	/* Set the freespace block index from the data block number. */
@@ -1758,7 +1783,8 @@ xfs_dir2_node_find_freeblk(
 		if (findex >= 0) {
 			/* caller already found the freespace for us. */
 			bests = dp->d_ops->free_bests_p(free);
-			dp->d_ops->free_hdr_from_disk(&freehdr, free);
+			xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr,
+						    free);
 
 			ASSERT(findex < freehdr.nvalid);
 			ASSERT(be16_to_cpu(bests[findex]) != NULLDATAOFF);
@@ -1807,7 +1833,7 @@ xfs_dir2_node_find_freeblk(
 
 		free = fbp->b_addr;
 		bests = dp->d_ops->free_bests_p(free);
-		dp->d_ops->free_hdr_from_disk(&freehdr, free);
+		xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, free);
 
 		/* Scan the free entry array for a large enough free space. */
 		for (findex = freehdr.nvalid - 1; findex >= 0; findex--) {
@@ -2260,7 +2286,7 @@ xfs_dir2_node_trim_free(
 	if (!bp)
 		return 0;
 	free = bp->b_addr;
-	dp->d_ops->free_hdr_from_disk(&freehdr, free);
+	xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, free);
 
 	/*
 	 * If there are used entries, there's nothing to do.
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 07cea5751783..ef4a2b402e25 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -104,10 +104,11 @@ xfs_dir3_leaf_find_entry(struct xfs_dir3_icleaf_hdr *leafhdr,
 extern int xfs_dir2_node_to_leaf(struct xfs_da_state *state);
 
 extern xfs_failaddr_t xfs_dir3_leaf_check_int(struct xfs_mount *mp,
-		struct xfs_inode *dp, struct xfs_dir3_icleaf_hdr *hdr,
-		struct xfs_dir2_leaf *leaf);
+		struct xfs_dir3_icleaf_hdr *hdr, struct xfs_dir2_leaf *leaf);
 
 /* xfs_dir2_node.c */
+void xfs_dir2_free_hdr_from_disk(struct xfs_mount *mp,
+		struct xfs_dir3_icfree_hdr *to, struct xfs_dir2_free *from);
 extern int xfs_dir2_leaf_to_node(struct xfs_da_args *args,
 		struct xfs_buf *lbp);
 extern xfs_dahash_t xfs_dir2_leaf_lasthash(struct xfs_inode *dp,
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index e4e189d3c1c0..6b8d9a774ddf 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -601,7 +601,7 @@ xchk_directory_free_bestfree(
 	}
 
 	/* Check all the entries. */
-	sc->ip->d_ops->free_hdr_from_disk(&freehdr, bp->b_addr);
+	xfs_dir2_free_hdr_from_disk(sc->ip->i_mount, &freehdr, bp->b_addr);
 	bestp = sc->ip->d_ops->free_bests_p(bp->b_addr);
 	for (i = 0; i < freehdr.nvalid; i++, bestp++) {
 		best = be16_to_cpu(*bestp);
-- 
2.20.1

