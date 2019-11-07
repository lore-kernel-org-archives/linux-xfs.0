Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A35BC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DB89206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:24:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jZVuLG+X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbfKGSYh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:24:37 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43972 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbfKGSYg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:24:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tpTPZSMmDXnuPpS7OSx7QvfhF0bwKtlM8nISLnfdYKI=; b=jZVuLG+Xrg25mw4cF10Vhxlu36
        Sp6gCwHGgDv0/s6PgLPY+PAxg1gc4M4hJDqPaw9uwNSbA7dYesJvKSc7IkSgpueM+Dqde+DSnE7sG
        O8oNqyysIm5qrzaxhd+UDQbwGnVzKSjRKwKUqJCOs3WMJdBFmTX8kZ8OwsKDLn8KLbPL3ccrH1e/s
        u0xToLv23vpyW8QwKhTElkwCoex+QGX8typEkKKODl1vyhX+4ZBT75dOpiFk6stDyB4JhTHR1w5jT
        hKLyfwwtaCjNlJkT5wBjTxImejyqhqXEpMi6tp4niaHvVgJvCLXlfeFHzH6w6UsE/o2Ul75G1h2H2
        U9Ew+CkQ==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmSR-000318-I8; Thu, 07 Nov 2019 18:24:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/46] xfs: devirtualize ->leaf_hdr_from_disk
Date:   Thu,  7 Nov 2019 19:23:32 +0100
Message-Id: <20191107182410.12660-9-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191107182410.12660-1-hch@lst.de>
References: <20191107182410.12660-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace the ->leaf_hdr_from_disk dir ops method with a directly called
xfs_dir2_leaf_hdr_from_disk helper that takes care of the differences
between the v4 and v5 on-disk format.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c   |  5 ++--
 fs/xfs/libxfs/xfs_da_format.c  | 35 --------------------------
 fs/xfs/libxfs/xfs_dir2.h       |  2 --
 fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 45 ++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_dir2_node.c  | 28 ++++++++++-----------
 fs/xfs/libxfs/xfs_dir2_priv.h  |  2 ++
 fs/xfs/scrub/dir.c             |  2 +-
 8 files changed, 58 insertions(+), 63 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 34928c96ea5f..1742e8293574 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -643,7 +643,7 @@ xfs_da3_root_split(
 		struct xfs_dir2_leaf_entry *ents;
 
 		leaf = (xfs_dir2_leaf_t *)oldroot;
-		dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+		xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 		ents = dp->d_ops->leaf_ents_p(leaf);
 
 		ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
@@ -2295,7 +2295,8 @@ xfs_da3_swap_lastblock(
 		struct xfs_dir2_leaf_entry *ents;
 
 		dead_leaf2 = (xfs_dir2_leaf_t *)dead_info;
-		dp->d_ops->leaf_hdr_from_disk(&leafhdr, dead_leaf2);
+		xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr,
+					    dead_leaf2);
 		ents = dp->d_ops->leaf_ents_p(dead_leaf2);
 		dead_level = 0;
 		dead_hash = be32_to_cpu(ents[leafhdr.count - 1].hashval);
diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 68dff1de61e9..c848cab41be5 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -430,21 +430,6 @@ xfs_dir3_leaf_ents_p(struct xfs_dir2_leaf *lp)
 	return ((struct xfs_dir3_leaf *)lp)->__ents;
 }
 
-static void
-xfs_dir2_leaf_hdr_from_disk(
-	struct xfs_dir3_icleaf_hdr	*to,
-	struct xfs_dir2_leaf		*from)
-{
-	to->forw = be32_to_cpu(from->hdr.info.forw);
-	to->back = be32_to_cpu(from->hdr.info.back);
-	to->magic = be16_to_cpu(from->hdr.info.magic);
-	to->count = be16_to_cpu(from->hdr.count);
-	to->stale = be16_to_cpu(from->hdr.stale);
-
-	ASSERT(to->magic == XFS_DIR2_LEAF1_MAGIC ||
-	       to->magic == XFS_DIR2_LEAFN_MAGIC);
-}
-
 static void
 xfs_dir2_leaf_hdr_to_disk(
 	struct xfs_dir2_leaf		*to,
@@ -460,23 +445,6 @@ xfs_dir2_leaf_hdr_to_disk(
 	to->hdr.stale = cpu_to_be16(from->stale);
 }
 
-static void
-xfs_dir3_leaf_hdr_from_disk(
-	struct xfs_dir3_icleaf_hdr	*to,
-	struct xfs_dir2_leaf		*from)
-{
-	struct xfs_dir3_leaf_hdr *hdr3 = (struct xfs_dir3_leaf_hdr *)from;
-
-	to->forw = be32_to_cpu(hdr3->info.hdr.forw);
-	to->back = be32_to_cpu(hdr3->info.hdr.back);
-	to->magic = be16_to_cpu(hdr3->info.hdr.magic);
-	to->count = be16_to_cpu(hdr3->count);
-	to->stale = be16_to_cpu(hdr3->stale);
-
-	ASSERT(to->magic == XFS_DIR3_LEAF1_MAGIC ||
-	       to->magic == XFS_DIR3_LEAFN_MAGIC);
-}
-
 static void
 xfs_dir3_leaf_hdr_to_disk(
 	struct xfs_dir2_leaf		*to,
@@ -648,7 +616,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 
 	.leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr),
 	.leaf_hdr_to_disk = xfs_dir2_leaf_hdr_to_disk,
-	.leaf_hdr_from_disk = xfs_dir2_leaf_hdr_from_disk,
 	.leaf_max_ents = xfs_dir2_max_leaf_ents,
 	.leaf_ents_p = xfs_dir2_leaf_ents_p,
 
@@ -693,7 +660,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 
 	.leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr),
 	.leaf_hdr_to_disk = xfs_dir2_leaf_hdr_to_disk,
-	.leaf_hdr_from_disk = xfs_dir2_leaf_hdr_from_disk,
 	.leaf_max_ents = xfs_dir2_max_leaf_ents,
 	.leaf_ents_p = xfs_dir2_leaf_ents_p,
 
@@ -738,7 +704,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 
 	.leaf_hdr_size = sizeof(struct xfs_dir3_leaf_hdr),
 	.leaf_hdr_to_disk = xfs_dir3_leaf_hdr_to_disk,
-	.leaf_hdr_from_disk = xfs_dir3_leaf_hdr_from_disk,
 	.leaf_max_ents = xfs_dir3_max_leaf_ents,
 	.leaf_ents_p = xfs_dir3_leaf_ents_p,
 
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 87fe876e90ed..74c592496bf0 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -75,8 +75,6 @@ struct xfs_dir_ops {
 	int	leaf_hdr_size;
 	void	(*leaf_hdr_to_disk)(struct xfs_dir2_leaf *to,
 				    struct xfs_dir3_icleaf_hdr *from);
-	void	(*leaf_hdr_from_disk)(struct xfs_dir3_icleaf_hdr *to,
-				      struct xfs_dir2_leaf *from);
 	int	(*leaf_max_ents)(struct xfs_da_geometry *geo);
 	struct xfs_dir2_leaf_entry *
 		(*leaf_ents_p)(struct xfs_dir2_leaf *lp);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index e1afa35141c5..d9ad89f6fd79 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -923,7 +923,7 @@ xfs_dir2_leaf_to_block(
 	tp = args->trans;
 	mp = dp->i_mount;
 	leaf = lbp->b_addr;
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 388b5da12228..b27609c852c5 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -30,6 +30,35 @@ static void xfs_dir3_leaf_log_bests(struct xfs_da_args *args,
 static void xfs_dir3_leaf_log_tail(struct xfs_da_args *args,
 				   struct xfs_buf *bp);
 
+void
+xfs_dir2_leaf_hdr_from_disk(
+	struct xfs_mount		*mp,
+	struct xfs_dir3_icleaf_hdr	*to,
+	struct xfs_dir2_leaf		*from)
+{
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dir3_leaf *from3 = (struct xfs_dir3_leaf *)from;
+
+		to->forw = be32_to_cpu(from3->hdr.info.hdr.forw);
+		to->back = be32_to_cpu(from3->hdr.info.hdr.back);
+		to->magic = be16_to_cpu(from3->hdr.info.hdr.magic);
+		to->count = be16_to_cpu(from3->hdr.count);
+		to->stale = be16_to_cpu(from3->hdr.stale);
+
+		ASSERT(to->magic == XFS_DIR3_LEAF1_MAGIC ||
+		       to->magic == XFS_DIR3_LEAFN_MAGIC);
+	} else {
+		to->forw = be32_to_cpu(from->hdr.info.forw);
+		to->back = be32_to_cpu(from->hdr.info.back);
+		to->magic = be16_to_cpu(from->hdr.info.magic);
+		to->count = be16_to_cpu(from->hdr.count);
+		to->stale = be16_to_cpu(from->hdr.stale);
+
+		ASSERT(to->magic == XFS_DIR2_LEAF1_MAGIC ||
+		       to->magic == XFS_DIR2_LEAFN_MAGIC);
+	}
+}
+
 /*
  * Check the internal consistency of a leaf1 block.
  * Pop an assert if something is wrong.
@@ -43,7 +72,7 @@ xfs_dir3_leaf1_check(
 	struct xfs_dir2_leaf	*leaf = bp->b_addr;
 	struct xfs_dir3_icleaf_hdr leafhdr;
 
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 
 	if (leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
@@ -96,7 +125,7 @@ xfs_dir3_leaf_check_int(
 	ops = xfs_dir_get_ops(mp, dp);
 
 	if (!hdr) {
-		ops->leaf_hdr_from_disk(&leafhdr, leaf);
+		xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
 		hdr = &leafhdr;
 	}
 
@@ -381,7 +410,7 @@ xfs_dir2_block_to_leaf(
 	/*
 	 * Set the counts in the leaf header.
 	 */
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 	leafhdr.count = be32_to_cpu(btp->count);
 	leafhdr.stale = be32_to_cpu(btp->stale);
 	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
@@ -608,7 +637,7 @@ xfs_dir2_leaf_addname(
 	leaf = lbp->b_addr;
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	length = dp->d_ops->data_entsize(args->namelen);
 
@@ -1197,7 +1226,7 @@ xfs_dir2_leaf_lookup_int(
 	leaf = lbp->b_addr;
 	xfs_dir3_leaf_check(dp, lbp);
 	ents = dp->d_ops->leaf_ents_p(leaf);
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
 
 	/*
 	 * Look for the first leaf entry with our hash value.
@@ -1330,7 +1359,7 @@ xfs_dir2_leaf_removename(
 	hdr = dbp->b_addr;
 	xfs_dir3_data_check(dp, dbp);
 	bf = dp->d_ops->data_bestfree_p(hdr);
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 	/*
 	 * Point to the leaf entry, use that to point to the data entry.
@@ -1511,7 +1540,7 @@ xfs_dir2_leaf_search_hash(
 
 	leaf = lbp->b_addr;
 	ents = args->dp->d_ops->leaf_ents_p(leaf);
-	args->dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(args->dp->i_mount, &leafhdr, leaf);
 
 	/*
 	 * Note, the table cannot be empty, so we have to go through the loop.
@@ -1699,7 +1728,7 @@ xfs_dir2_node_to_leaf(
 		return 0;
 	lbp = state->path.blk[0].bp;
 	leaf = lbp->b_addr;
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
 
 	ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
 	       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 72d7ed17eef5..d4402b491a41 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -45,7 +45,7 @@ xfs_dir3_leafn_check(
 	struct xfs_dir2_leaf	*leaf = bp->b_addr;
 	struct xfs_dir3_icleaf_hdr leafhdr;
 
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 
 	if (leafhdr.magic == XFS_DIR3_LEAFN_MAGIC) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
@@ -440,7 +440,7 @@ xfs_dir2_leafn_add(
 
 	trace_xfs_dir2_leafn_add(args, index);
 
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	/*
@@ -538,7 +538,7 @@ xfs_dir2_leaf_lasthash(
 	struct xfs_dir2_leaf_entry *ents;
 	struct xfs_dir3_icleaf_hdr leafhdr;
 
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 
 	ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
 	       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC ||
@@ -587,7 +587,7 @@ xfs_dir2_leafn_lookup_for_addname(
 	tp = args->trans;
 	mp = dp->i_mount;
 	leaf = bp->b_addr;
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	xfs_dir3_leaf_check(dp, bp);
@@ -739,7 +739,7 @@ xfs_dir2_leafn_lookup_for_entry(
 	tp = args->trans;
 	mp = dp->i_mount;
 	leaf = bp->b_addr;
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	xfs_dir3_leaf_check(dp, bp);
@@ -977,8 +977,8 @@ xfs_dir2_leafn_order(
 	struct xfs_dir3_icleaf_hdr hdr1;
 	struct xfs_dir3_icleaf_hdr hdr2;
 
-	dp->d_ops->leaf_hdr_from_disk(&hdr1, leaf1);
-	dp->d_ops->leaf_hdr_from_disk(&hdr2, leaf2);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &hdr1, leaf1);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &hdr2, leaf2);
 	ents1 = dp->d_ops->leaf_ents_p(leaf1);
 	ents2 = dp->d_ops->leaf_ents_p(leaf2);
 
@@ -1030,8 +1030,8 @@ xfs_dir2_leafn_rebalance(
 
 	leaf1 = blk1->bp->b_addr;
 	leaf2 = blk2->bp->b_addr;
-	dp->d_ops->leaf_hdr_from_disk(&hdr1, leaf1);
-	dp->d_ops->leaf_hdr_from_disk(&hdr2, leaf2);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &hdr1, leaf1);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &hdr2, leaf2);
 	ents1 = dp->d_ops->leaf_ents_p(leaf1);
 	ents2 = dp->d_ops->leaf_ents_p(leaf2);
 
@@ -1228,7 +1228,7 @@ xfs_dir2_leafn_remove(
 	dp = args->dp;
 	tp = args->trans;
 	leaf = bp->b_addr;
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	/*
@@ -1450,7 +1450,7 @@ xfs_dir2_leafn_toosmall(
 	 */
 	blk = &state->path.blk[state->path.active - 1];
 	leaf = blk->bp->b_addr;
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 	xfs_dir3_leaf_check(dp, blk->bp);
 
@@ -1513,7 +1513,7 @@ xfs_dir2_leafn_toosmall(
 			(state->args->geo->blksize >> 2);
 
 		leaf = bp->b_addr;
-		dp->d_ops->leaf_hdr_from_disk(&hdr2, leaf);
+		xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &hdr2, leaf);
 		ents = dp->d_ops->leaf_ents_p(leaf);
 		count += hdr2.count - hdr2.stale;
 		bytes -= count * sizeof(ents[0]);
@@ -1576,8 +1576,8 @@ xfs_dir2_leafn_unbalance(
 	drop_leaf = drop_blk->bp->b_addr;
 	save_leaf = save_blk->bp->b_addr;
 
-	dp->d_ops->leaf_hdr_from_disk(&savehdr, save_leaf);
-	dp->d_ops->leaf_hdr_from_disk(&drophdr, drop_leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &savehdr, save_leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &drophdr, drop_leaf);
 	sents = dp->d_ops->leaf_ents_p(save_leaf);
 	dents = dp->d_ops->leaf_ents_p(drop_leaf);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index d2eaea663e7f..5f42f2c81869 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -66,6 +66,8 @@ extern int xfs_dir3_data_init(struct xfs_da_args *args, xfs_dir2_db_t blkno,
 		struct xfs_buf **bpp);
 
 /* xfs_dir2_leaf.c */
+void xfs_dir2_leaf_hdr_from_disk(struct xfs_mount *mp,
+		struct xfs_dir3_icleaf_hdr *to, struct xfs_dir2_leaf *from);
 extern int xfs_dir3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t fbno, xfs_daddr_t mappedbno, struct xfs_buf **bpp);
 extern int xfs_dir3_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 97f274f7cd38..5b004d1f6bef 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -504,7 +504,7 @@ xchk_directory_leaf1_bestfree(
 	xchk_buffer_recheck(sc, bp);
 
 	leaf = bp->b_addr;
-	d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(sc->ip->i_mount, &leafhdr, leaf);
 	ents = d_ops->leaf_ents_p(leaf);
 	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
 	bestcount = be32_to_cpu(ltp->bestcount);
-- 
2.20.1

