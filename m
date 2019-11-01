Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E358CA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BF492085B
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:08:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gghUWGpy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbfKAWIs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:08:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53720 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbfKAWIs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:08:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6p+8qyAgOkyY/gOVLT/yabxdUZ5U2tGv5pMMQ31MTTU=; b=gghUWGpyr8WrNjGoNuhaN56nQ
        wlzqRe97KW4R9nmtzszMfmEb3gPkx5cIKL3mHu2bJltLi/p46Vj4FUGDeeQd4n9s2bQ8sE73m9qxv
        uwcTbGcT/9l81Fxc5jBQewCg2IiCdsQTuhluAqETyncjeV5RFlEgQUA3rMqPhwA42zcIWYFw6Icyc
        krsXsSPC+QYH5h00y3kQKs0eOoPO7lUhiEVPS45c1QSun8BDULgnhvIq2+cjS3gabCoU2Qn9MXSQw
        1C9H88sWpPXjrE90Z27xBRAllbh3nCjMu4aB0IwLJjZhVTNPYgDCjiPPPRpMErmpWDZi55QxeKzL3
        DegQ//N4Q==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf68-0005yQ-96
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:08:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 15/34] xfs: add a bests pointer to struct xfs_dir3_icfree_hdr
Date:   Fri,  1 Nov 2019 15:07:00 -0700
Message-Id: <20191101220719.29100-16-hch@lst.de>
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

All but two callers of the ->free_bests_p dir operation already have a
struct xfs_dir3_icfree_hdr from a previous call to
xfs_dir2_free_hdr_from_disk at hand.  Add a pointer to the bests to
struct xfs_dir3_icfree_hdr to clean up this pattern.  To optimize this
pattern, pass the struct xfs_dir3_icfree_hdr to xfs_dir2_free_log_bests
instead of recalculating the pointer there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.c | 15 ------
 fs/xfs/libxfs/xfs_dir2.h      |  1 -
 fs/xfs/libxfs/xfs_dir2_leaf.c |  6 +--
 fs/xfs/libxfs/xfs_dir2_node.c | 97 ++++++++++++++---------------------
 fs/xfs/libxfs/xfs_dir2_priv.h |  1 +
 fs/xfs/scrub/dir.c            |  6 +--
 6 files changed, 43 insertions(+), 83 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index b943d9443d55..7263b6d6a135 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -411,12 +411,6 @@ xfs_dir2_free_max_bests(struct xfs_da_geometry *geo)
 		sizeof(xfs_dir2_data_off_t);
 }
 
-static __be16 *
-xfs_dir2_free_bests_p(struct xfs_dir2_free *free)
-{
-	return (__be16 *)((char *)free + sizeof(struct xfs_dir2_free_hdr));
-}
-
 /*
  * Convert data space db to the corresponding free db.
  */
@@ -443,12 +437,6 @@ xfs_dir3_free_max_bests(struct xfs_da_geometry *geo)
 		sizeof(xfs_dir2_data_off_t);
 }
 
-static __be16 *
-xfs_dir3_free_bests_p(struct xfs_dir2_free *free)
-{
-	return (__be16 *)((char *)free + sizeof(struct xfs_dir3_free_hdr));
-}
-
 /*
  * Convert data space db to the corresponding free db.
  */
@@ -500,7 +488,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 
 	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
 	.free_max_bests = xfs_dir2_free_max_bests,
-	.free_bests_p = xfs_dir2_free_bests_p,
 	.db_to_fdb = xfs_dir2_db_to_fdb,
 	.db_to_fdindex = xfs_dir2_db_to_fdindex,
 };
@@ -537,7 +524,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 
 	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
 	.free_max_bests = xfs_dir2_free_max_bests,
-	.free_bests_p = xfs_dir2_free_bests_p,
 	.db_to_fdb = xfs_dir2_db_to_fdb,
 	.db_to_fdindex = xfs_dir2_db_to_fdindex,
 };
@@ -574,7 +560,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 
 	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
 	.free_max_bests = xfs_dir3_free_max_bests,
-	.free_bests_p = xfs_dir3_free_bests_p,
 	.db_to_fdb = xfs_dir3_db_to_fdb,
 	.db_to_fdindex = xfs_dir3_db_to_fdindex,
 };
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 613a78281d03..402f00326b64 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -74,7 +74,6 @@ struct xfs_dir_ops {
 
 	int	free_hdr_size;
 	int	(*free_max_bests)(struct xfs_da_geometry *geo);
-	__be16 * (*free_bests_p)(struct xfs_dir2_free *free);
 	xfs_dir2_db_t (*db_to_fdb)(struct xfs_da_geometry *geo,
 				   xfs_dir2_db_t db);
 	int	(*db_to_fdindex)(struct xfs_da_geometry *geo,
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 4b697dd85eab..3770107c0695 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1678,7 +1678,6 @@ xfs_dir2_node_to_leaf(
 	int			error;		/* error return code */
 	struct xfs_buf		*fbp;		/* buffer for freespace block */
 	xfs_fileoff_t		fo;		/* freespace file offset */
-	xfs_dir2_free_t		*free;		/* freespace structure */
 	struct xfs_buf		*lbp;		/* buffer for leaf block */
 	xfs_dir2_leaf_tail_t	*ltp;		/* tail of leaf structure */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
@@ -1747,8 +1746,7 @@ xfs_dir2_node_to_leaf(
 	error = xfs_dir2_free_read(tp, dp,  args->geo->freeblk, &fbp);
 	if (error)
 		return error;
-	free = fbp->b_addr;
-	xfs_dir2_free_hdr_from_disk(mp, &freehdr, free);
+	xfs_dir2_free_hdr_from_disk(mp, &freehdr, fbp->b_addr);
 
 	ASSERT(!freehdr.firstdb);
 
@@ -1782,7 +1780,7 @@ xfs_dir2_node_to_leaf(
 	/*
 	 * Set up the leaf bests table.
 	 */
-	memcpy(xfs_dir2_leaf_bests_p(ltp), dp->d_ops->free_bests_p(free),
+	memcpy(xfs_dir2_leaf_bests_p(ltp), freehdr.bests,
 		freehdr.nvalid * sizeof(xfs_dir2_data_off_t));
 
 	xfs_dir2_leaf_hdr_to_disk(mp, leaf, &leafhdr);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index d400243c9556..eff7cfeb19b9 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -233,6 +233,7 @@ xfs_dir2_free_hdr_from_disk(
 		to->firstdb = be32_to_cpu(from3->hdr.firstdb);
 		to->nvalid = be32_to_cpu(from3->hdr.nvalid);
 		to->nused = be32_to_cpu(from3->hdr.nused);
+		to->bests = (void *)from3 + sizeof(struct xfs_dir3_free_hdr);
 
 		ASSERT(to->magic == XFS_DIR3_FREE_MAGIC);
 	} else {
@@ -240,6 +241,8 @@ xfs_dir2_free_hdr_from_disk(
 		to->firstdb = be32_to_cpu(from->hdr.firstdb);
 		to->nvalid = be32_to_cpu(from->hdr.nvalid);
 		to->nused = be32_to_cpu(from->hdr.nused);
+		to->bests = (void *)from + sizeof(struct xfs_dir2_free_hdr);
+
 		ASSERT(to->magic == XFS_DIR2_FREE_MAGIC);
 	}
 }
@@ -338,21 +341,19 @@ xfs_dir3_free_get_buf(
 STATIC void
 xfs_dir2_free_log_bests(
 	struct xfs_da_args	*args,
+	struct xfs_dir3_icfree_hdr *hdr,
 	struct xfs_buf		*bp,
 	int			first,		/* first entry to log */
 	int			last)		/* last entry to log */
 {
-	xfs_dir2_free_t		*free;		/* freespace structure */
-	__be16			*bests;
+	struct xfs_dir2_free	*free = bp->b_addr;
 
-	free = bp->b_addr;
-	bests = args->dp->d_ops->free_bests_p(free);
 	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
 	       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
 	xfs_trans_log_buf(args->trans, bp,
-		(uint)((char *)&bests[first] - (char *)free),
-		(uint)((char *)&bests[last] - (char *)free +
-		       sizeof(bests[0]) - 1));
+			  (char *)&hdr->bests[first] - (char *)free,
+			  (char *)&hdr->bests[last] - (char *)free +
+			   sizeof(hdr->bests[0]) - 1);
 }
 
 /*
@@ -388,14 +389,12 @@ xfs_dir2_leaf_to_node(
 	int			error;		/* error return value */
 	struct xfs_buf		*fbp;		/* freespace buffer */
 	xfs_dir2_db_t		fdb;		/* freespace block number */
-	xfs_dir2_free_t		*free;		/* freespace structure */
 	__be16			*from;		/* pointer to freespace entry */
 	int			i;		/* leaf freespace index */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_tail_t	*ltp;		/* leaf tail structure */
 	int			n;		/* count of live freespc ents */
 	xfs_dir2_data_off_t	off;		/* freespace entry value */
-	__be16			*to;		/* pointer to freespace entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
 	struct xfs_dir3_icfree_hdr freehdr;
 
@@ -417,8 +416,7 @@ xfs_dir2_leaf_to_node(
 	if (error)
 		return error;
 
-	free = fbp->b_addr;
-	xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, free);
+	xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, fbp->b_addr);
 	leaf = lbp->b_addr;
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	if (be32_to_cpu(ltp->bestcount) >
@@ -430,11 +428,11 @@ xfs_dir2_leaf_to_node(
 	 * Count active entries.
 	 */
 	from = xfs_dir2_leaf_bests_p(ltp);
-	to = dp->d_ops->free_bests_p(free);
-	for (i = n = 0; i < be32_to_cpu(ltp->bestcount); i++, from++, to++) {
-		if ((off = be16_to_cpu(*from)) != NULLDATAOFF)
+	for (i = n = 0; i < be32_to_cpu(ltp->bestcount); i++, from++) {
+		off = be16_to_cpu(*from);
+		if (off != NULLDATAOFF)
 			n++;
-		*to = cpu_to_be16(off);
+		freehdr.bests[i] = cpu_to_be16(off);
 	}
 
 	/*
@@ -444,7 +442,7 @@ xfs_dir2_leaf_to_node(
 	freehdr.nvalid = be32_to_cpu(ltp->bestcount);
 
 	xfs_dir2_free_hdr_to_disk(dp->i_mount, fbp->b_addr, &freehdr);
-	xfs_dir2_free_log_bests(args, fbp, 0, freehdr.nvalid - 1);
+	xfs_dir2_free_log_bests(args, &freehdr, fbp, 0, freehdr.nvalid - 1);
 	xfs_dir2_free_log_header(args, fbp);
 
 	/*
@@ -673,7 +671,7 @@ xfs_dir2_leafn_lookup_for_addname(
 		 * in hand, take a look at it.
 		 */
 		if (newdb != curdb) {
-			__be16 *bests;
+			struct xfs_dir3_icfree_hdr freehdr;
 
 			curdb = newdb;
 			/*
@@ -708,8 +706,9 @@ xfs_dir2_leafn_lookup_for_addname(
 			/*
 			 * If it has room, return it.
 			 */
-			bests = dp->d_ops->free_bests_p(free);
-			if (unlikely(bests[fi] == cpu_to_be16(NULLDATAOFF))) {
+			xfs_dir2_free_hdr_from_disk(mp, &freehdr, free);
+			if (unlikely(freehdr.bests[fi] ==
+				     cpu_to_be16(NULLDATAOFF))) {
 				XFS_ERROR_REPORT("xfs_dir2_leafn_lookup_int",
 							XFS_ERRLEVEL_LOW, mp);
 				if (curfdb != newfdb)
@@ -717,7 +716,7 @@ xfs_dir2_leafn_lookup_for_addname(
 				return -EFSCORRUPTED;
 			}
 			curfdb = newfdb;
-			if (be16_to_cpu(bests[fi]) >= length)
+			if (be16_to_cpu(freehdr.bests[fi]) >= length)
 				goto out;
 		}
 	}
@@ -1162,19 +1161,17 @@ xfs_dir3_data_block_free(
 	int			longest)
 {
 	int			logfree = 0;
-	__be16			*bests;
 	struct xfs_dir3_icfree_hdr freehdr;
 	struct xfs_inode	*dp = args->dp;
 
 	xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, free);
-	bests = dp->d_ops->free_bests_p(free);
 	if (hdr) {
 		/*
 		 * Data block is not empty, just set the free entry to the new
 		 * value.
 		 */
-		bests[findex] = cpu_to_be16(longest);
-		xfs_dir2_free_log_bests(args, fbp, findex, findex);
+		freehdr.bests[findex] = cpu_to_be16(longest);
+		xfs_dir2_free_log_bests(args, &freehdr, fbp, findex, findex);
 		return 0;
 	}
 
@@ -1190,14 +1187,14 @@ xfs_dir3_data_block_free(
 		int	i;		/* free entry index */
 
 		for (i = findex - 1; i >= 0; i--) {
-			if (bests[i] != cpu_to_be16(NULLDATAOFF))
+			if (freehdr.bests[i] != cpu_to_be16(NULLDATAOFF))
 				break;
 		}
 		freehdr.nvalid = i + 1;
 		logfree = 0;
 	} else {
 		/* Not the last entry, just punch it out.  */
-		bests[findex] = cpu_to_be16(NULLDATAOFF);
+		freehdr.bests[findex] = cpu_to_be16(NULLDATAOFF);
 		logfree = 1;
 	}
 
@@ -1226,7 +1223,7 @@ xfs_dir3_data_block_free(
 
 	/* Log the free entry that changed, unless we got rid of it.  */
 	if (logfree)
-		xfs_dir2_free_log_bests(args, fbp, findex, findex);
+		xfs_dir2_free_log_bests(args, &freehdr, fbp, findex, findex);
 	return 0;
 }
 
@@ -1667,11 +1664,9 @@ xfs_dir2_node_add_datablk(
 	struct xfs_trans	*tp = args->trans;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_dir2_data_free *bf;
-	struct xfs_dir2_free	*free = NULL;
 	xfs_dir2_db_t		fbno;
 	struct xfs_buf		*fbp;
 	struct xfs_buf		*dbp;
-	__be16			*bests = NULL;
 	int			error;
 
 	/* Not allowed to allocate, return failure. */
@@ -1727,18 +1722,14 @@ xfs_dir2_node_add_datablk(
 		error = xfs_dir3_free_get_buf(args, fbno, &fbp);
 		if (error)
 			return error;
-		free = fbp->b_addr;
-		bests = dp->d_ops->free_bests_p(free);
-		xfs_dir2_free_hdr_from_disk(mp, hdr, free);
+		xfs_dir2_free_hdr_from_disk(mp, hdr, fbp->b_addr);
 
 		/* Remember the first slot as our empty slot. */
 		hdr->firstdb = (fbno - xfs_dir2_byte_to_db(args->geo,
 							XFS_DIR2_FREE_OFFSET)) *
 				dp->d_ops->free_max_bests(args->geo);
 	} else {
-		free = fbp->b_addr;
-		bests = dp->d_ops->free_bests_p(free);
-		xfs_dir2_free_hdr_from_disk(mp, hdr, free);
+		xfs_dir2_free_hdr_from_disk(mp, hdr, fbp->b_addr);
 	}
 
 	/* Set the freespace block index from the data block number. */
@@ -1748,14 +1739,14 @@ xfs_dir2_node_add_datablk(
 	if (*findex >= hdr->nvalid) {
 		ASSERT(*findex < dp->d_ops->free_max_bests(args->geo));
 		hdr->nvalid = *findex + 1;
-		bests[*findex] = cpu_to_be16(NULLDATAOFF);
+		hdr->bests[*findex] = cpu_to_be16(NULLDATAOFF);
 	}
 
 	/*
 	 * If this entry was for an empty data block (this should always be
 	 * true) then update the header.
 	 */
-	if (bests[*findex] == cpu_to_be16(NULLDATAOFF)) {
+	if (hdr->bests[*findex] == cpu_to_be16(NULLDATAOFF)) {
 		hdr->nused++;
 		xfs_dir2_free_hdr_to_disk(mp, fbp->b_addr, hdr);
 		xfs_dir2_free_log_header(args, fbp);
@@ -1763,7 +1754,7 @@ xfs_dir2_node_add_datablk(
 
 	/* Update the freespace value for the new block in the table. */
 	bf = dp->d_ops->data_bestfree_p(dbp->b_addr);
-	bests[*findex] = bf[0].length;
+	hdr->bests[*findex] = bf[0].length;
 
 	*dbpp = dbp;
 	*fbpp = fbp;
@@ -1780,7 +1771,6 @@ xfs_dir2_node_find_freeblk(
 	int			*findexp,
 	int			length)
 {
-	struct xfs_dir2_free	*free = NULL;
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_trans	*tp = args->trans;
 	struct xfs_buf		*fbp = NULL;
@@ -1790,7 +1780,6 @@ xfs_dir2_node_find_freeblk(
 	xfs_dir2_db_t		dbno = -1;
 	xfs_dir2_db_t		fbno;
 	xfs_fileoff_t		fo;
-	__be16			*bests = NULL;
 	int			findex = 0;
 	int			error;
 
@@ -1801,16 +1790,13 @@ xfs_dir2_node_find_freeblk(
 	 */
 	if (fblk) {
 		fbp = fblk->bp;
-		free = fbp->b_addr;
 		findex = fblk->index;
+		xfs_dir2_free_hdr_from_disk(dp->i_mount, hdr, fbp->b_addr);
 		if (findex >= 0) {
 			/* caller already found the freespace for us. */
-			bests = dp->d_ops->free_bests_p(free);
-			xfs_dir2_free_hdr_from_disk(dp->i_mount, hdr, free);
-
 			ASSERT(findex < hdr->nvalid);
-			ASSERT(be16_to_cpu(bests[findex]) != NULLDATAOFF);
-			ASSERT(be16_to_cpu(bests[findex]) >= length);
+			ASSERT(be16_to_cpu(hdr->bests[findex]) != NULLDATAOFF);
+			ASSERT(be16_to_cpu(hdr->bests[findex]) >= length);
 			dbno = hdr->firstdb + findex;
 			goto found_block;
 		}
@@ -1853,14 +1839,12 @@ xfs_dir2_node_find_freeblk(
 		if (!fbp)
 			continue;
 
-		free = fbp->b_addr;
-		bests = dp->d_ops->free_bests_p(free);
-		xfs_dir2_free_hdr_from_disk(dp->i_mount, hdr, free);
+		xfs_dir2_free_hdr_from_disk(dp->i_mount, hdr, fbp->b_addr);
 
 		/* Scan the free entry array for a large enough free space. */
 		for (findex = hdr->nvalid - 1; findex >= 0; findex--) {
-			if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
-			    be16_to_cpu(bests[findex]) >= length) {
+			if (be16_to_cpu(hdr->bests[findex]) != NULLDATAOFF &&
+			    be16_to_cpu(hdr->bests[findex]) >= length) {
 				dbno = hdr->firstdb + findex;
 				goto found_block;
 			}
@@ -1877,7 +1861,6 @@ xfs_dir2_node_find_freeblk(
 	return 0;
 }
 
-
 /*
  * Add the data entry for a node-format directory name addition.
  * The leaf entry is added in xfs_dir2_leafn_add.
@@ -1892,7 +1875,6 @@ xfs_dir2_node_addname_int(
 	struct xfs_dir2_data_entry *dep;	/* data entry pointer */
 	struct xfs_dir2_data_hdr *hdr;		/* data block header */
 	struct xfs_dir2_data_free *bf;
-	struct xfs_dir2_free	*free = NULL;	/* freespace block structure */
 	struct xfs_trans	*tp = args->trans;
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_dir3_icfree_hdr freehdr;
@@ -1907,7 +1889,6 @@ xfs_dir2_node_addname_int(
 	int			needlog = 0;	/* need to log data header */
 	int			needscan = 0;	/* need to rescan data frees */
 	__be16			*tagp;		/* data entry tag pointer */
-	__be16			*bests;
 
 	length = dp->d_ops->data_entsize(args->namelen);
 	error = xfs_dir2_node_find_freeblk(args, fblk, &dbno, &fbp, &freehdr,
@@ -1978,16 +1959,14 @@ xfs_dir2_node_addname_int(
 		xfs_dir2_data_log_header(args, dbp);
 
 	/* If the freespace block entry is now wrong, update it. */
-	free = fbp->b_addr;
-	bests = dp->d_ops->free_bests_p(free);
-	if (bests[findex] != bf[0].length) {
-		bests[findex] = bf[0].length;
+	if (freehdr.bests[findex] != bf[0].length) {
+		freehdr.bests[findex] = bf[0].length;
 		logfree = 1;
 	}
 
 	/* Log the freespace entry if needed. */
 	if (logfree)
-		xfs_dir2_free_log_bests(args, fbp, findex, findex);
+		xfs_dir2_free_log_bests(args, &freehdr, fbp, findex, findex);
 
 	/* Return the data block and offset in args. */
 	args->blkno = (xfs_dablk_t)dbno;
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index ef4a2b402e25..b73cf38c6969 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -26,6 +26,7 @@ struct xfs_dir3_icfree_hdr {
 	uint32_t		firstdb;
 	uint32_t		nvalid;
 	uint32_t		nused;
+	__be16			*bests;
 };
 
 /* xfs_dir2.c */
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 6b8d9a774ddf..dfaa0fca617e 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -581,7 +581,6 @@ xchk_directory_free_bestfree(
 	struct xfs_dir3_icfree_hdr	freehdr;
 	struct xfs_buf			*dbp;
 	struct xfs_buf			*bp;
-	__be16				*bestp;
 	__u16				best;
 	unsigned int			stale = 0;
 	int				i;
@@ -602,9 +601,8 @@ xchk_directory_free_bestfree(
 
 	/* Check all the entries. */
 	xfs_dir2_free_hdr_from_disk(sc->ip->i_mount, &freehdr, bp->b_addr);
-	bestp = sc->ip->d_ops->free_bests_p(bp->b_addr);
-	for (i = 0; i < freehdr.nvalid; i++, bestp++) {
-		best = be16_to_cpu(*bestp);
+	for (i = 0; i < freehdr.nvalid; i++) {
+		best = be16_to_cpu(freehdr.bests[i]);
 		if (best == NULLDATAOFF) {
 			stale++;
 			continue;
-- 
2.20.1

