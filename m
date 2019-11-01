Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD2B0CA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 824EB2085B
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:08:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y1kj9bmL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfKAWIR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:08:17 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53678 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAWIQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:08:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kWRd2pSs9Y/FNsfoYN/e2/7uXepOQhOMKC3znIG+Cts=; b=Y1kj9bmL9d1HKYNwC6Eijq40D
        drYX+vChKa5r4Wnhonh+IevNC6T6I88lWdmaBRcu78RqtONLs99WBh3+ntRwK+/MoXcIyRwGPZghw
        +GgQNVtWPghCmgmsir37Zg9u3aD/v+4Y1GcemhNZUYAcuf5N9Qs9TN1Aeo26itRwhzmHb4XgtcpVB
        omHcmT43w+/nOsAfolPwH2VZuf6EY1H3bNdq6lTmlbbVYCx8AQoXoQrfFympr+RR154MEt+QUb1EA
        yzS2pqJfZHVFIemx5kL5pl+P/Q7tUgB9LnvclFS+IUskYJlKxkkLYsG/p7petVm4DmGSWZIAGOFRg
        SEuiButww==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf5c-0005vP-Ki
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:08:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/34] xfs: add a entries pointer to struct xfs_dir3_icleaf_hdr
Date:   Fri,  1 Nov 2019 15:06:54 -0700
Message-Id: <20191101220719.29100-10-hch@lst.de>
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

All callers of the ->node_tree_p dir operation already have a struct
xfs_dir3_icleaf_hdr from a previous call to xfs_da_leaf_hdr_from_disk at
hand, or just need slight changes to the calling conventions to do so.
Add a pointer to the entries to struct xfs_dir3_icleaf_hdr to clean up
this pattern.  To make this possible the xfs_dir3_leaf_log_ents function
grow a new argument to pass the xfs_dir3_icleaf_hdr that call callers
already have, and xfs_dir2_leaf_lookup_int returns the
xfs_dir3_icleaf_hdr to the callers so that they can later use it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_btree.c   |   7 +--
 fs/xfs/libxfs/xfs_da_format.c  |  15 -----
 fs/xfs/libxfs/xfs_dir2.h       |   2 -
 fs/xfs/libxfs/xfs_dir2_block.c |   7 +--
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 101 +++++++++++++++------------------
 fs/xfs/libxfs/xfs_dir2_node.c  |  64 +++++++++------------
 fs/xfs/libxfs/xfs_dir2_priv.h  |   5 +-
 fs/xfs/scrub/dir.c             |  13 +++--
 8 files changed, 88 insertions(+), 126 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index aeb1884fd8c7..af825983c054 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -638,15 +638,14 @@ xfs_da3_root_split(
 		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DA_NODE_BUF);
 	} else {
 		struct xfs_dir3_icleaf_hdr leafhdr;
-		struct xfs_dir2_leaf_entry *ents;
 
 		leaf = (xfs_dir2_leaf_t *)oldroot;
 		xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
-		ents = dp->d_ops->leaf_ents_p(leaf);
 
 		ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
 		       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC);
-		size = (int)((char *)&ents[leafhdr.count] - (char *)leaf);
+		size = (int)((char *)&leafhdr.ents[leafhdr.count] -
+			(char *)leaf);
 		level = 0;
 
 		/*
@@ -2285,7 +2284,7 @@ xfs_da3_swap_lastblock(
 		dead_leaf2 = (xfs_dir2_leaf_t *)dead_info;
 		xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr,
 					    dead_leaf2);
-		ents = dp->d_ops->leaf_ents_p(dead_leaf2);
+		ents = leafhdr.ents;
 		dead_level = 0;
 		dead_hash = be32_to_cpu(ents[leafhdr.count - 1].hashval);
 	} else {
diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 193708d12459..ed21ce01502f 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -411,12 +411,6 @@ xfs_dir2_max_leaf_ents(struct xfs_da_geometry *geo)
 		(uint)sizeof(struct xfs_dir2_leaf_entry);
 }
 
-static struct xfs_dir2_leaf_entry *
-xfs_dir2_leaf_ents_p(struct xfs_dir2_leaf *lp)
-{
-	return lp->__ents;
-}
-
 static int
 xfs_dir3_max_leaf_ents(struct xfs_da_geometry *geo)
 {
@@ -424,12 +418,6 @@ xfs_dir3_max_leaf_ents(struct xfs_da_geometry *geo)
 		(uint)sizeof(struct xfs_dir2_leaf_entry);
 }
 
-static struct xfs_dir2_leaf_entry *
-xfs_dir3_leaf_ents_p(struct xfs_dir2_leaf *lp)
-{
-	return ((struct xfs_dir3_leaf *)lp)->__ents;
-}
-
 /*
  * Directory free space block operations
  */
@@ -584,7 +572,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 
 	.leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr),
 	.leaf_max_ents = xfs_dir2_max_leaf_ents,
-	.leaf_ents_p = xfs_dir2_leaf_ents_p,
 
 	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
 	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
@@ -627,7 +614,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 
 	.leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr),
 	.leaf_max_ents = xfs_dir2_max_leaf_ents,
-	.leaf_ents_p = xfs_dir2_leaf_ents_p,
 
 	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
 	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
@@ -670,7 +656,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 
 	.leaf_hdr_size = sizeof(struct xfs_dir3_leaf_hdr),
 	.leaf_max_ents = xfs_dir3_max_leaf_ents,
-	.leaf_ents_p = xfs_dir3_leaf_ents_p,
 
 	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
 	.free_hdr_to_disk = xfs_dir3_free_hdr_to_disk,
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 15a1a72dc126..b46657974134 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -74,8 +74,6 @@ struct xfs_dir_ops {
 
 	int	leaf_hdr_size;
 	int	(*leaf_max_ents)(struct xfs_da_geometry *geo);
-	struct xfs_dir2_leaf_entry *
-		(*leaf_ents_p)(struct xfs_dir2_leaf *lp);
 
 	int	free_hdr_size;
 	void	(*free_hdr_to_disk)(struct xfs_dir2_free *to,
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index e6ed90a6f19b..38886b9c7b48 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -914,7 +914,6 @@ xfs_dir2_leaf_to_block(
 	__be16			*tagp;		/* end of entry (tag) */
 	int			to;		/* block/leaf to index */
 	xfs_trans_t		*tp;		/* transaction pointer */
-	struct xfs_dir2_leaf_entry *ents;
 	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	trace_xfs_dir2_leaf_to_block(args);
@@ -924,7 +923,6 @@ xfs_dir2_leaf_to_block(
 	mp = dp->i_mount;
 	leaf = lbp->b_addr;
 	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
-	ents = dp->d_ops->leaf_ents_p(leaf);
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 
 	ASSERT(leafhdr.magic == XFS_DIR2_LEAF1_MAGIC ||
@@ -1004,9 +1002,10 @@ xfs_dir2_leaf_to_block(
 	 */
 	lep = xfs_dir2_block_leaf_p(btp);
 	for (from = to = 0; from < leafhdr.count; from++) {
-		if (ents[from].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
+		if (leafhdr.ents[from].address ==
+		    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 			continue;
-		lep[to++] = ents[from];
+		lep[to++] = leafhdr.ents[from];
 	}
 	ASSERT(to == be32_to_cpu(btp->count));
 	xfs_dir2_block_log_leaf(tp, dbp, 0, be32_to_cpu(btp->count) - 1);
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 56aae0b4cf89..d6581f40f0a4 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -24,7 +24,8 @@
  * Local function declarations.
  */
 static int xfs_dir2_leaf_lookup_int(xfs_da_args_t *args, struct xfs_buf **lbpp,
-				    int *indexp, struct xfs_buf **dbpp);
+				    int *indexp, struct xfs_buf **dbpp,
+				    struct xfs_dir3_icleaf_hdr *leafhdr);
 static void xfs_dir3_leaf_log_bests(struct xfs_da_args *args,
 				    struct xfs_buf *bp, int first, int last);
 static void xfs_dir3_leaf_log_tail(struct xfs_da_args *args,
@@ -44,6 +45,7 @@ xfs_dir2_leaf_hdr_from_disk(
 		to->magic = be16_to_cpu(from3->hdr.info.hdr.magic);
 		to->count = be16_to_cpu(from3->hdr.count);
 		to->stale = be16_to_cpu(from3->hdr.stale);
+		to->ents = from3->__ents;
 
 		ASSERT(to->magic == XFS_DIR3_LEAF1_MAGIC ||
 		       to->magic == XFS_DIR3_LEAFN_MAGIC);
@@ -53,6 +55,7 @@ xfs_dir2_leaf_hdr_from_disk(
 		to->magic = be16_to_cpu(from->hdr.info.magic);
 		to->count = be16_to_cpu(from->hdr.count);
 		to->stale = be16_to_cpu(from->hdr.stale);
+		to->ents = from->__ents;
 
 		ASSERT(to->magic == XFS_DIR2_LEAF1_MAGIC ||
 		       to->magic == XFS_DIR2_LEAFN_MAGIC);
@@ -139,7 +142,6 @@ xfs_dir3_leaf_check_int(
 	struct xfs_dir3_icleaf_hdr *hdr,
 	struct xfs_dir2_leaf	*leaf)
 {
-	struct xfs_dir2_leaf_entry *ents;
 	xfs_dir2_leaf_tail_t	*ltp;
 	int			stale;
 	int			i;
@@ -158,7 +160,6 @@ xfs_dir3_leaf_check_int(
 		hdr = &leafhdr;
 	}
 
-	ents = ops->leaf_ents_p(leaf);
 	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
 
 	/*
@@ -172,17 +173,17 @@ xfs_dir3_leaf_check_int(
 	/* Leaves and bests don't overlap in leaf format. */
 	if ((hdr->magic == XFS_DIR2_LEAF1_MAGIC ||
 	     hdr->magic == XFS_DIR3_LEAF1_MAGIC) &&
-	    (char *)&ents[hdr->count] > (char *)xfs_dir2_leaf_bests_p(ltp))
+	    (char *)&hdr->ents[hdr->count] > (char *)xfs_dir2_leaf_bests_p(ltp))
 		return __this_address;
 
 	/* Check hash value order, count stale entries.  */
 	for (i = stale = 0; i < hdr->count; i++) {
 		if (i + 1 < hdr->count) {
-			if (be32_to_cpu(ents[i].hashval) >
-					be32_to_cpu(ents[i + 1].hashval))
+			if (be32_to_cpu(hdr->ents[i].hashval) >
+					be32_to_cpu(hdr->ents[i + 1].hashval))
 				return __this_address;
 		}
-		if (ents[i].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
+		if (hdr->ents[i].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 			stale++;
 	}
 	if (hdr->stale != stale)
@@ -404,7 +405,6 @@ xfs_dir2_block_to_leaf(
 	int			needscan;	/* need to rescan bestfree */
 	xfs_trans_t		*tp;		/* transaction pointer */
 	struct xfs_dir2_data_free *bf;
-	struct xfs_dir2_leaf_entry *ents;
 	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	trace_xfs_dir2_block_to_leaf(args);
@@ -434,7 +434,6 @@ xfs_dir2_block_to_leaf(
 	btp = xfs_dir2_block_tail_p(args->geo, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	bf = dp->d_ops->data_bestfree_p(hdr);
-	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	/*
 	 * Set the counts in the leaf header.
@@ -449,8 +448,9 @@ xfs_dir2_block_to_leaf(
 	 * Could compact these but I think we always do the conversion
 	 * after squeezing out stale entries.
 	 */
-	memcpy(ents, blp, be32_to_cpu(btp->count) * sizeof(xfs_dir2_leaf_entry_t));
-	xfs_dir3_leaf_log_ents(args, lbp, 0, leafhdr.count - 1);
+	memcpy(leafhdr.ents, blp,
+		be32_to_cpu(btp->count) * sizeof(struct xfs_dir2_leaf_entry));
+	xfs_dir3_leaf_log_ents(args, &leafhdr, lbp, 0, leafhdr.count - 1);
 	needscan = 0;
 	needlog = 1;
 	/*
@@ -665,8 +665,8 @@ xfs_dir2_leaf_addname(
 	index = xfs_dir2_leaf_search_hash(args, lbp);
 	leaf = lbp->b_addr;
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
-	ents = dp->d_ops->leaf_ents_p(leaf);
 	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
+	ents = leafhdr.ents;
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	length = dp->d_ops->data_entsize(args->namelen);
 
@@ -912,7 +912,7 @@ xfs_dir2_leaf_addname(
 	 */
 	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf, &leafhdr);
 	xfs_dir3_leaf_log_header(args, lbp);
-	xfs_dir3_leaf_log_ents(args, lbp, lfloglow, lfloghigh);
+	xfs_dir3_leaf_log_ents(args, &leafhdr, lbp, lfloglow, lfloghigh);
 	xfs_dir3_leaf_check(dp, lbp);
 	xfs_dir3_data_check(dp, dbp);
 	return 0;
@@ -932,7 +932,6 @@ xfs_dir3_leaf_compact(
 	xfs_dir2_leaf_t	*leaf;		/* leaf structure */
 	int		loglow;		/* first leaf entry to log */
 	int		to;		/* target leaf index */
-	struct xfs_dir2_leaf_entry *ents;
 	struct xfs_inode *dp = args->dp;
 
 	leaf = bp->b_addr;
@@ -942,9 +941,9 @@ xfs_dir3_leaf_compact(
 	/*
 	 * Compress out the stale entries in place.
 	 */
-	ents = dp->d_ops->leaf_ents_p(leaf);
 	for (from = to = 0, loglow = -1; from < leafhdr->count; from++) {
-		if (ents[from].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
+		if (leafhdr->ents[from].address ==
+		    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 			continue;
 		/*
 		 * Only actually copy the entries that are different.
@@ -952,7 +951,7 @@ xfs_dir3_leaf_compact(
 		if (from > to) {
 			if (loglow == -1)
 				loglow = to;
-			ents[to] = ents[from];
+			leafhdr->ents[to] = leafhdr->ents[from];
 		}
 		to++;
 	}
@@ -966,7 +965,7 @@ xfs_dir3_leaf_compact(
 	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf, leafhdr);
 	xfs_dir3_leaf_log_header(args, bp);
 	if (loglow != -1)
-		xfs_dir3_leaf_log_ents(args, bp, loglow, to - 1);
+		xfs_dir3_leaf_log_ents(args, leafhdr, bp, loglow, to - 1);
 }
 
 /*
@@ -1095,6 +1094,7 @@ xfs_dir3_leaf_log_bests(
 void
 xfs_dir3_leaf_log_ents(
 	struct xfs_da_args	*args,
+	struct xfs_dir3_icleaf_hdr *hdr,
 	struct xfs_buf		*bp,
 	int			first,
 	int			last)
@@ -1102,16 +1102,14 @@ xfs_dir3_leaf_log_ents(
 	xfs_dir2_leaf_entry_t	*firstlep;	/* pointer to first entry */
 	xfs_dir2_leaf_entry_t	*lastlep;	/* pointer to last entry */
 	struct xfs_dir2_leaf	*leaf = bp->b_addr;
-	struct xfs_dir2_leaf_entry *ents;
 
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC) ||
 	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
 	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
 	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC));
 
-	ents = args->dp->d_ops->leaf_ents_p(leaf);
-	firstlep = &ents[first];
-	lastlep = &ents[last];
+	firstlep = &hdr->ents[first];
+	lastlep = &hdr->ents[last];
 	xfs_trans_log_buf(args->trans, bp,
 		(uint)((char *)firstlep - (char *)leaf),
 		(uint)((char *)lastlep - (char *)leaf + sizeof(*lastlep) - 1));
@@ -1173,28 +1171,27 @@ xfs_dir2_leaf_lookup(
 	int			error;		/* error return code */
 	int			index;		/* found entry index */
 	struct xfs_buf		*lbp;		/* leaf buffer */
-	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
-	struct xfs_dir2_leaf_entry *ents;
+	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	trace_xfs_dir2_leaf_lookup(args);
 
 	/*
 	 * Look up name in the leaf block, returning both buffers and index.
 	 */
-	if ((error = xfs_dir2_leaf_lookup_int(args, &lbp, &index, &dbp))) {
+	error = xfs_dir2_leaf_lookup_int(args, &lbp, &index, &dbp, &leafhdr);
+	if (error)
 		return error;
-	}
+
 	tp = args->trans;
 	dp = args->dp;
 	xfs_dir3_leaf_check(dp, lbp);
-	leaf = lbp->b_addr;
-	ents = dp->d_ops->leaf_ents_p(leaf);
+
 	/*
 	 * Get to the leaf entry and contained data entry address.
 	 */
-	lep = &ents[index];
+	lep = &leafhdr.ents[index];
 
 	/*
 	 * Point to the data entry.
@@ -1224,7 +1221,8 @@ xfs_dir2_leaf_lookup_int(
 	xfs_da_args_t		*args,		/* operation arguments */
 	struct xfs_buf		**lbpp,		/* out: leaf buffer */
 	int			*indexp,	/* out: index in leaf block */
-	struct xfs_buf		**dbpp)		/* out: data buffer */
+	struct xfs_buf		**dbpp,		/* out: data buffer */
+	struct xfs_dir3_icleaf_hdr *leafhdr)
 {
 	xfs_dir2_db_t		curdb = -1;	/* current data block number */
 	struct xfs_buf		*dbp = NULL;	/* data buffer */
@@ -1240,8 +1238,6 @@ xfs_dir2_leaf_lookup_int(
 	xfs_trans_t		*tp;		/* transaction pointer */
 	xfs_dir2_db_t		cidb = -1;	/* case match data block no. */
 	enum xfs_dacmp		cmp;		/* name compare result */
-	struct xfs_dir2_leaf_entry *ents;
-	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	dp = args->dp;
 	tp = args->trans;
@@ -1254,8 +1250,7 @@ xfs_dir2_leaf_lookup_int(
 	*lbpp = lbp;
 	leaf = lbp->b_addr;
 	xfs_dir3_leaf_check(dp, lbp);
-	ents = dp->d_ops->leaf_ents_p(leaf);
-	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(mp, leafhdr, leaf);
 
 	/*
 	 * Look for the first leaf entry with our hash value.
@@ -1265,8 +1260,9 @@ xfs_dir2_leaf_lookup_int(
 	 * Loop over all the entries with the right hash value
 	 * looking to match the name.
 	 */
-	for (lep = &ents[index];
-	     index < leafhdr.count && be32_to_cpu(lep->hashval) == args->hashval;
+	for (lep = &leafhdr->ents[index];
+	     index < leafhdr->count &&
+			be32_to_cpu(lep->hashval) == args->hashval;
 	     lep++, index++) {
 		/*
 		 * Skip over stale leaf entries.
@@ -1372,7 +1368,6 @@ xfs_dir2_leaf_removename(
 	int			needscan;	/* need to rescan data frees */
 	xfs_dir2_data_off_t	oldbest;	/* old value of best free */
 	struct xfs_dir2_data_free *bf;		/* bestfree table */
-	struct xfs_dir2_leaf_entry *ents;
 	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	trace_xfs_dir2_leaf_removename(args);
@@ -1380,20 +1375,20 @@ xfs_dir2_leaf_removename(
 	/*
 	 * Lookup the leaf entry, get the leaf and data blocks read in.
 	 */
-	if ((error = xfs_dir2_leaf_lookup_int(args, &lbp, &index, &dbp))) {
+	error = xfs_dir2_leaf_lookup_int(args, &lbp, &index, &dbp, &leafhdr);
+	if (error)
 		return error;
-	}
+
 	dp = args->dp;
 	leaf = lbp->b_addr;
 	hdr = dbp->b_addr;
 	xfs_dir3_data_check(dp, dbp);
 	bf = dp->d_ops->data_bestfree_p(hdr);
-	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
-	ents = dp->d_ops->leaf_ents_p(leaf);
+
 	/*
 	 * Point to the leaf entry, use that to point to the data entry.
 	 */
-	lep = &ents[index];
+	lep = &leafhdr.ents[index];
 	db = xfs_dir2_dataptr_to_db(args->geo, be32_to_cpu(lep->address));
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
 		xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
@@ -1417,7 +1412,7 @@ xfs_dir2_leaf_removename(
 	xfs_dir3_leaf_log_header(args, lbp);
 
 	lep->address = cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
-	xfs_dir3_leaf_log_ents(args, lbp, index, index);
+	xfs_dir3_leaf_log_ents(args, &leafhdr, lbp, index, index);
 
 	/*
 	 * Scan the freespace in the data block again if necessary,
@@ -1506,26 +1501,24 @@ xfs_dir2_leaf_replace(
 	int			error;		/* error return code */
 	int			index;		/* index of leaf entry */
 	struct xfs_buf		*lbp;		/* leaf buffer */
-	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
-	struct xfs_dir2_leaf_entry *ents;
+	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	trace_xfs_dir2_leaf_replace(args);
 
 	/*
 	 * Look up the entry.
 	 */
-	if ((error = xfs_dir2_leaf_lookup_int(args, &lbp, &index, &dbp))) {
+	error = xfs_dir2_leaf_lookup_int(args, &lbp, &index, &dbp, &leafhdr);
+	if (error)
 		return error;
-	}
+
 	dp = args->dp;
-	leaf = lbp->b_addr;
-	ents = dp->d_ops->leaf_ents_p(leaf);
 	/*
 	 * Point to the leaf entry, get data address from it.
 	 */
-	lep = &ents[index];
+	lep = &leafhdr.ents[index];
 	/*
 	 * Point to the data entry.
 	 */
@@ -1559,21 +1552,17 @@ xfs_dir2_leaf_search_hash(
 	xfs_dahash_t		hashwant;	/* hash value looking for */
 	int			high;		/* high leaf index */
 	int			low;		/* low leaf index */
-	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	int			mid=0;		/* current leaf index */
-	struct xfs_dir2_leaf_entry *ents;
 	struct xfs_dir3_icleaf_hdr leafhdr;
 
-	leaf = lbp->b_addr;
-	ents = args->dp->d_ops->leaf_ents_p(leaf);
-	xfs_dir2_leaf_hdr_from_disk(args->dp->i_mount, &leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(args->dp->i_mount, &leafhdr, lbp->b_addr);
 
 	/*
 	 * Note, the table cannot be empty, so we have to go through the loop.
 	 * Binary search the leaf entries looking for our hash value.
 	 */
-	for (lep = ents, low = 0, high = leafhdr.count - 1,
+	for (lep = leafhdr.ents, low = 0, high = leafhdr.count - 1,
 		hashwant = args->hashval;
 	     low <= high; ) {
 		mid = (low + high) >> 1;
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 207ef9b4fe50..76c896da8352 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -439,7 +439,7 @@ xfs_dir2_leafn_add(
 	trace_xfs_dir2_leafn_add(args, index);
 
 	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
-	ents = dp->d_ops->leaf_ents_p(leaf);
+	ents = leafhdr.ents;
 
 	/*
 	 * Quick check just to make sure we are not going to index
@@ -495,7 +495,7 @@ xfs_dir2_leafn_add(
 
 	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf, &leafhdr);
 	xfs_dir3_leaf_log_header(args, bp);
-	xfs_dir3_leaf_log_ents(args, bp, lfloglow, lfloghigh);
+	xfs_dir3_leaf_log_ents(args, &leafhdr, bp, lfloglow, lfloghigh);
 	xfs_dir3_leaf_check(dp, bp);
 	return 0;
 }
@@ -530,11 +530,9 @@ xfs_dir2_leaf_lasthash(
 	struct xfs_buf	*bp,			/* leaf buffer */
 	int		*count)			/* count of entries in leaf */
 {
-	struct xfs_dir2_leaf	*leaf = bp->b_addr;
-	struct xfs_dir2_leaf_entry *ents;
 	struct xfs_dir3_icleaf_hdr leafhdr;
 
-	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, bp->b_addr);
 
 	ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
 	       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC ||
@@ -545,9 +543,7 @@ xfs_dir2_leaf_lasthash(
 		*count = leafhdr.count;
 	if (!leafhdr.count)
 		return 0;
-
-	ents = dp->d_ops->leaf_ents_p(leaf);
-	return be32_to_cpu(ents[leafhdr.count - 1].hashval);
+	return be32_to_cpu(leafhdr.ents[leafhdr.count - 1].hashval);
 }
 
 /*
@@ -576,7 +572,6 @@ xfs_dir2_leafn_lookup_for_addname(
 	xfs_dir2_db_t		newdb;		/* new data block number */
 	xfs_dir2_db_t		newfdb;		/* new free block number */
 	xfs_trans_t		*tp;		/* transaction pointer */
-	struct xfs_dir2_leaf_entry *ents;
 	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	dp = args->dp;
@@ -584,7 +579,6 @@ xfs_dir2_leafn_lookup_for_addname(
 	mp = dp->i_mount;
 	leaf = bp->b_addr;
 	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
-	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	xfs_dir3_leaf_check(dp, bp);
 	ASSERT(leafhdr.count > 0);
@@ -608,7 +602,7 @@ xfs_dir2_leafn_lookup_for_addname(
 	/*
 	 * Loop over leaf entries with the right hash value.
 	 */
-	for (lep = &ents[index];
+	for (lep = &leafhdr.ents[index];
 	     index < leafhdr.count && be32_to_cpu(lep->hashval) == args->hashval;
 	     lep++, index++) {
 		/*
@@ -728,7 +722,6 @@ xfs_dir2_leafn_lookup_for_entry(
 	xfs_dir2_db_t		newdb;		/* new data block number */
 	xfs_trans_t		*tp;		/* transaction pointer */
 	enum xfs_dacmp		cmp;		/* comparison result */
-	struct xfs_dir2_leaf_entry *ents;
 	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	dp = args->dp;
@@ -736,7 +729,6 @@ xfs_dir2_leafn_lookup_for_entry(
 	mp = dp->i_mount;
 	leaf = bp->b_addr;
 	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
-	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	xfs_dir3_leaf_check(dp, bp);
 	if (leafhdr.count <= 0)
@@ -756,7 +748,7 @@ xfs_dir2_leafn_lookup_for_entry(
 	/*
 	 * Loop over leaf entries with the right hash value.
 	 */
-	for (lep = &ents[index];
+	for (lep = &leafhdr.ents[index];
 	     index < leafhdr.count && be32_to_cpu(lep->hashval) == args->hashval;
 	     lep++, index++) {
 		/*
@@ -911,7 +903,7 @@ xfs_dir3_leafn_moveents(
 	if (start_d < dhdr->count) {
 		memmove(&dents[start_d + count], &dents[start_d],
 			(dhdr->count - start_d) * sizeof(xfs_dir2_leaf_entry_t));
-		xfs_dir3_leaf_log_ents(args, bp_d, start_d + count,
+		xfs_dir3_leaf_log_ents(args, dhdr, bp_d, start_d + count,
 				       count + dhdr->count - 1);
 	}
 	/*
@@ -933,7 +925,7 @@ xfs_dir3_leafn_moveents(
 	 */
 	memcpy(&dents[start_d], &sents[start_s],
 		count * sizeof(xfs_dir2_leaf_entry_t));
-	xfs_dir3_leaf_log_ents(args, bp_d, start_d, start_d + count - 1);
+	xfs_dir3_leaf_log_ents(args, dhdr, bp_d, start_d, start_d + count - 1);
 
 	/*
 	 * If there are source entries after the ones we copied,
@@ -942,7 +934,8 @@ xfs_dir3_leafn_moveents(
 	if (start_s + count < shdr->count) {
 		memmove(&sents[start_s], &sents[start_s + count],
 			count * sizeof(xfs_dir2_leaf_entry_t));
-		xfs_dir3_leaf_log_ents(args, bp_s, start_s, start_s + count - 1);
+		xfs_dir3_leaf_log_ents(args, shdr, bp_s, start_s,
+				       start_s + count - 1);
 	}
 
 	/*
@@ -973,8 +966,8 @@ xfs_dir2_leafn_order(
 
 	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &hdr1, leaf1);
 	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &hdr2, leaf2);
-	ents1 = dp->d_ops->leaf_ents_p(leaf1);
-	ents2 = dp->d_ops->leaf_ents_p(leaf2);
+	ents1 = hdr1.ents;
+	ents2 = hdr2.ents;
 
 	if (hdr1.count > 0 && hdr2.count > 0 &&
 	    (be32_to_cpu(ents2[0].hashval) < be32_to_cpu(ents1[0].hashval) ||
@@ -1026,8 +1019,8 @@ xfs_dir2_leafn_rebalance(
 	leaf2 = blk2->bp->b_addr;
 	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &hdr1, leaf1);
 	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &hdr2, leaf2);
-	ents1 = dp->d_ops->leaf_ents_p(leaf1);
-	ents2 = dp->d_ops->leaf_ents_p(leaf2);
+	ents1 = hdr1.ents;
+	ents2 = hdr2.ents;
 
 	oldsum = hdr1.count + hdr2.count;
 #if defined(DEBUG) || defined(XFS_WARN)
@@ -1215,7 +1208,6 @@ xfs_dir2_leafn_remove(
 	xfs_trans_t		*tp;		/* transaction pointer */
 	struct xfs_dir2_data_free *bf;		/* bestfree table */
 	struct xfs_dir3_icleaf_hdr leafhdr;
-	struct xfs_dir2_leaf_entry *ents;
 
 	trace_xfs_dir2_leafn_remove(args, index);
 
@@ -1223,12 +1215,11 @@ xfs_dir2_leafn_remove(
 	tp = args->trans;
 	leaf = bp->b_addr;
 	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
-	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	/*
 	 * Point to the entry we're removing.
 	 */
-	lep = &ents[index];
+	lep = &leafhdr.ents[index];
 
 	/*
 	 * Extract the data block and offset from the entry.
@@ -1247,7 +1238,7 @@ xfs_dir2_leafn_remove(
 	xfs_dir3_leaf_log_header(args, bp);
 
 	lep->address = cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
-	xfs_dir3_leaf_log_ents(args, bp, index, index);
+	xfs_dir3_leaf_log_ents(args, &leafhdr, bp, index, index);
 
 	/*
 	 * Make the data entry free.  Keep track of the longest freespace
@@ -1344,7 +1335,7 @@ xfs_dir2_leafn_remove(
 	 * to justify trying to join it with a neighbor.
 	 */
 	*rval = (dp->d_ops->leaf_hdr_size +
-		 (uint)sizeof(ents[0]) * (leafhdr.count - leafhdr.stale)) <
+		 (uint)sizeof(leafhdr.ents) * (leafhdr.count - leafhdr.stale)) <
 		args->geo->magicpct;
 	return 0;
 }
@@ -1445,7 +1436,7 @@ xfs_dir2_leafn_toosmall(
 	blk = &state->path.blk[state->path.active - 1];
 	leaf = blk->bp->b_addr;
 	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
-	ents = dp->d_ops->leaf_ents_p(leaf);
+	ents = leafhdr.ents;
 	xfs_dir3_leaf_check(dp, blk->bp);
 
 	count = leafhdr.count - leafhdr.stale;
@@ -1508,7 +1499,7 @@ xfs_dir2_leafn_toosmall(
 
 		leaf = bp->b_addr;
 		xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &hdr2, leaf);
-		ents = dp->d_ops->leaf_ents_p(leaf);
+		ents = hdr2.ents;
 		count += hdr2.count - hdr2.stale;
 		bytes -= count * sizeof(ents[0]);
 
@@ -1572,8 +1563,8 @@ xfs_dir2_leafn_unbalance(
 
 	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &savehdr, save_leaf);
 	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &drophdr, drop_leaf);
-	sents = dp->d_ops->leaf_ents_p(save_leaf);
-	dents = dp->d_ops->leaf_ents_p(drop_leaf);
+	sents = savehdr.ents;
+	dents = drophdr.ents;
 
 	/*
 	 * If there are any stale leaf entries, take this opportunity
@@ -2155,8 +2146,6 @@ xfs_dir2_node_replace(
 	int			i;		/* btree level */
 	xfs_ino_t		inum;		/* new inode number */
 	int			ftype;		/* new file type */
-	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
-	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry being changed */
 	int			rval;		/* internal return value */
 	xfs_da_state_t		*state;		/* btree cursor */
 
@@ -2188,16 +2177,17 @@ xfs_dir2_node_replace(
 	 * and locked it.  But paranoia is good.
 	 */
 	if (rval == -EEXIST) {
-		struct xfs_dir2_leaf_entry *ents;
+		struct xfs_dir3_icleaf_hdr	leafhdr;
+
 		/*
 		 * Find the leaf entry.
 		 */
 		blk = &state->path.blk[state->path.active - 1];
 		ASSERT(blk->magic == XFS_DIR2_LEAFN_MAGIC);
-		leaf = blk->bp->b_addr;
-		ents = args->dp->d_ops->leaf_ents_p(leaf);
-		lep = &ents[blk->index];
 		ASSERT(state->extravalid);
+
+		xfs_dir2_leaf_hdr_from_disk(state->mp, &leafhdr,
+					    blk->bp->b_addr);
 		/*
 		 * Point to the data entry.
 		 */
@@ -2207,7 +2197,7 @@ xfs_dir2_node_replace(
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
 		       xfs_dir2_dataptr_to_off(args->geo,
-					       be32_to_cpu(lep->address)));
+				be32_to_cpu(leafhdr.ents[blk->index].address)));
 		ASSERT(inum != be64_to_cpu(dep->inumber));
 		/*
 		 * Fill in the new inode number and log the entry.
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index b402a2391f49..07cea5751783 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -18,6 +18,7 @@ struct xfs_dir3_icleaf_hdr {
 	uint16_t		magic;
 	uint16_t		count;
 	uint16_t		stale;
+	struct xfs_dir2_leaf_entry *ents;
 };
 
 struct xfs_dir3_icfree_hdr {
@@ -25,7 +26,6 @@ struct xfs_dir3_icfree_hdr {
 	uint32_t		firstdb;
 	uint32_t		nvalid;
 	uint32_t		nused;
-
 };
 
 /* xfs_dir2.c */
@@ -86,7 +86,8 @@ extern void xfs_dir3_leaf_compact_x1(struct xfs_dir3_icleaf_hdr *leafhdr,
 extern int xfs_dir3_leaf_get_buf(struct xfs_da_args *args, xfs_dir2_db_t bno,
 		struct xfs_buf **bpp, uint16_t magic);
 extern void xfs_dir3_leaf_log_ents(struct xfs_da_args *args,
-		struct xfs_buf *bp, int first, int last);
+		struct xfs_dir3_icleaf_hdr *hdr, struct xfs_buf *bp, int first,
+		int last);
 extern void xfs_dir3_leaf_log_header(struct xfs_da_args *args,
 		struct xfs_buf *bp);
 extern int xfs_dir2_leaf_lookup(struct xfs_da_args *args);
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 5b004d1f6bef..27fdf8978467 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -195,13 +195,15 @@ xchk_dir_rec(
 	xfs_dir2_dataptr_t		ptr;
 	xfs_dahash_t			calc_hash;
 	xfs_dahash_t			hash;
+	struct xfs_dir3_icleaf_hdr	hdr;
 	unsigned int			tag;
 	int				error;
 
 	ASSERT(blk->magic == XFS_DIR2_LEAF1_MAGIC ||
 	       blk->magic == XFS_DIR2_LEAFN_MAGIC);
 
-	ent = (void *)ds->dargs.dp->d_ops->leaf_ents_p(blk->bp->b_addr) +
+	xfs_dir2_leaf_hdr_from_disk(mp, &hdr, blk->bp->b_addr);
+	ent = (void *)hdr.ents +
 		(blk->index * sizeof(struct xfs_dir2_leaf_entry));
 
 	/* Check the hash of the entry. */
@@ -481,7 +483,6 @@ xchk_directory_leaf1_bestfree(
 	xfs_dablk_t			lblk)
 {
 	struct xfs_dir3_icleaf_hdr	leafhdr;
-	struct xfs_dir2_leaf_entry	*ents;
 	struct xfs_dir2_leaf_tail	*ltp;
 	struct xfs_dir2_leaf		*leaf;
 	struct xfs_buf			*dbp;
@@ -505,7 +506,6 @@ xchk_directory_leaf1_bestfree(
 
 	leaf = bp->b_addr;
 	xfs_dir2_leaf_hdr_from_disk(sc->ip->i_mount, &leafhdr, leaf);
-	ents = d_ops->leaf_ents_p(leaf);
 	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
 	bestcount = be32_to_cpu(ltp->bestcount);
 	bestp = xfs_dir2_leaf_bests_p(ltp);
@@ -533,18 +533,19 @@ xchk_directory_leaf1_bestfree(
 	}
 
 	/* Leaves and bests don't overlap in leaf format. */
-	if ((char *)&ents[leafhdr.count] > (char *)bestp) {
+	if ((char *)&leafhdr.ents[leafhdr.count] > (char *)bestp) {
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 		goto out;
 	}
 
 	/* Check hash value order, count stale entries.  */
 	for (i = 0; i < leafhdr.count; i++) {
-		hash = be32_to_cpu(ents[i].hashval);
+		hash = be32_to_cpu(leafhdr.ents[i].hashval);
 		if (i > 0 && lasthash > hash)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 		lasthash = hash;
-		if (ents[i].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
+		if (leafhdr.ents[i].address ==
+		    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 			stale++;
 	}
 	if (leafhdr.stale != stale)
-- 
2.20.1

