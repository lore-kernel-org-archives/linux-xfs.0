Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D60B4C5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 926B521D79
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:24:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AbA1np2R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbfKGSYb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:24:31 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43856 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbfKGSYb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:24:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=AmCevglp69UP194SwkBOtBL3DntkoRP685cwXMzKjPE=; b=AbA1np2RE3NzE/q40HZ1uKMHS
        S1ZeafRxovLOCTUgi2Fp8Ynq661OJy4LgrDuUu2zwOK6vShLmOz0ENTJFYf08Q7FugJhV2Bwe/ltX
        Qx2K5O5/6nM1w1samXkmLn3dAlqxEjEoxdfMGx1XCgvqq/8IB8PInpnFhZRv81H9eVKxJldK9gNvo
        lA8dA/6UKAzwE0sMmk5Z6yf9lPH4g5b5EEYzEezSEw/jOOLigjG6uLWXUouqp2onxWOKhFwdVL5bH
        PbJL6QmW4Y+KlfIMxIcdRpPpdPotlsU75wAGWausc0k6tsF8A/6fos3J7tG1DwRjezkghseWEFkqI
        U81MXccfQ==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmSM-0002xZ-95
        for linux-xfs@vger.kernel.org; Thu, 07 Nov 2019 18:24:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/46] xfs: add a btree entries pointer to struct xfs_da3_icnode_hdr
Date:   Thu,  7 Nov 2019 19:23:30 +0100
Message-Id: <20191107182410.12660-7-hch@lst.de>
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

All but two callers of the ->node_tree_p dir operation already have a
xfs_da3_icnode_hdr from a previous call to xfs_da3_node_hdr_from_disk at
hand.  Add a pointer to the btree entries to struct xfs_da3_icnode_hdr
to clean up this pattern.  The two remaining callers now expand the
whole header as well, but that isn't very expensive and not in a super
hot path anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |  6 ++--
 fs/xfs/libxfs/xfs_da_btree.c  | 68 ++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_da_btree.h  |  6 ++++
 fs/xfs/libxfs/xfs_da_format.c | 21 -----------
 fs/xfs/libxfs/xfs_dir2.h      |  2 --
 fs/xfs/scrub/dabtree.c        |  7 ++--
 fs/xfs/xfs_attr_inactive.c    | 34 +++++++++---------
 fs/xfs/xfs_attr_list.c        |  2 +-
 8 files changed, 60 insertions(+), 86 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index ba1c3486fe54..13d034e8f076 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1145,7 +1145,6 @@ xfs_attr3_leaf_to_node(
 	struct xfs_attr_leafblock *leaf;
 	struct xfs_attr3_icleaf_hdr icleafhdr;
 	struct xfs_attr_leaf_entry *entries;
-	struct xfs_da_node_entry *btree;
 	struct xfs_da3_icnode_hdr icnodehdr;
 	struct xfs_da_intnode	*node;
 	struct xfs_inode	*dp = args->dp;
@@ -1186,15 +1185,14 @@ xfs_attr3_leaf_to_node(
 		goto out;
 	node = bp1->b_addr;
 	xfs_da3_node_hdr_from_disk(mp, &icnodehdr, node);
-	btree = dp->d_ops->node_tree_p(node);
 
 	leaf = bp2->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(args->geo, &icleafhdr, leaf);
 	entries = xfs_attr3_leaf_entryp(leaf);
 
 	/* both on-disk, don't endian-flip twice */
-	btree[0].hashval = entries[icleafhdr.count - 1].hashval;
-	btree[0].before = cpu_to_be32(blkno);
+	icnodehdr.btree[0].hashval = entries[icleafhdr.count - 1].hashval;
+	icnodehdr.btree[0].before = cpu_to_be32(blkno);
 	icnodehdr.count = 1;
 	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &icnodehdr);
 	xfs_trans_log_buf(args->trans, bp1, 0, args->geo->blksize - 1);
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 2a0221fcad82..6ffecab08d9e 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -124,6 +124,7 @@ xfs_da3_node_hdr_from_disk(
 		to->magic = be16_to_cpu(from3->hdr.info.hdr.magic);
 		to->count = be16_to_cpu(from3->hdr.__count);
 		to->level = be16_to_cpu(from3->hdr.__level);
+		to->btree = from3->__btree;
 		ASSERT(to->magic == XFS_DA3_NODE_MAGIC);
 	} else {
 		to->forw = be32_to_cpu(from->hdr.info.forw);
@@ -131,6 +132,7 @@ xfs_da3_node_hdr_from_disk(
 		to->magic = be16_to_cpu(from->hdr.info.magic);
 		to->count = be16_to_cpu(from->hdr.__count);
 		to->level = be16_to_cpu(from->hdr.__level);
+		to->btree = from->__btree;
 		ASSERT(to->magic == XFS_DA_NODE_MAGIC);
 	}
 }
@@ -627,7 +629,7 @@ xfs_da3_root_split(
 		struct xfs_da3_icnode_hdr icnodehdr;
 
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &icnodehdr, oldroot);
-		btree = dp->d_ops->node_tree_p(oldroot);
+		btree = icnodehdr.btree;
 		size = (int)((char *)&btree[icnodehdr.count] - (char *)oldroot);
 		level = icnodehdr.level;
 
@@ -687,7 +689,7 @@ xfs_da3_root_split(
 
 	node = bp->b_addr;
 	xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
-	btree = dp->d_ops->node_tree_p(node);
+	btree = nodehdr.btree;
 	btree[0].hashval = cpu_to_be32(blk1->hashval);
 	btree[0].before = cpu_to_be32(blk1->blkno);
 	btree[1].hashval = cpu_to_be32(blk2->hashval);
@@ -839,8 +841,8 @@ xfs_da3_node_rebalance(
 	node2 = blk2->bp->b_addr;
 	xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr1, node1);
 	xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr2, node2);
-	btree1 = dp->d_ops->node_tree_p(node1);
-	btree2 = dp->d_ops->node_tree_p(node2);
+	btree1 = nodehdr1.btree;
+	btree2 = nodehdr2.btree;
 
 	/*
 	 * Figure out how many entries need to move, and in which direction.
@@ -855,8 +857,8 @@ xfs_da3_node_rebalance(
 		node2 = tmpnode;
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr1, node1);
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr2, node2);
-		btree1 = dp->d_ops->node_tree_p(node1);
-		btree2 = dp->d_ops->node_tree_p(node2);
+		btree1 = nodehdr1.btree;
+		btree2 = nodehdr2.btree;
 		swap = 1;
 	}
 
@@ -937,8 +939,8 @@ xfs_da3_node_rebalance(
 		node2 = blk2->bp->b_addr;
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr1, node1);
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr2, node2);
-		btree1 = dp->d_ops->node_tree_p(node1);
-		btree2 = dp->d_ops->node_tree_p(node2);
+		btree1 = nodehdr1.btree;
+		btree2 = nodehdr2.btree;
 	}
 	blk1->hashval = be32_to_cpu(btree1[nodehdr1.count - 1].hashval);
 	blk2->hashval = be32_to_cpu(btree2[nodehdr2.count - 1].hashval);
@@ -971,7 +973,7 @@ xfs_da3_node_add(
 
 	node = oldblk->bp->b_addr;
 	xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
-	btree = dp->d_ops->node_tree_p(node);
+	btree = nodehdr.btree;
 
 	ASSERT(oldblk->index >= 0 && oldblk->index <= nodehdr.count);
 	ASSERT(newblk->blkno != 0);
@@ -1131,7 +1133,6 @@ xfs_da3_root_join(
 	xfs_dablk_t		child;
 	struct xfs_buf		*bp;
 	struct xfs_da3_icnode_hdr oldroothdr;
-	struct xfs_da_node_entry *btree;
 	int			error;
 	struct xfs_inode	*dp = state->args->dp;
 
@@ -1155,8 +1156,7 @@ xfs_da3_root_join(
 	 * Read in the (only) child block, then copy those bytes into
 	 * the root block's buffer and free the original child block.
 	 */
-	btree = dp->d_ops->node_tree_p(oldroot);
-	child = be32_to_cpu(btree[0].before);
+	child = be32_to_cpu(oldroothdr.btree[0].before);
 	ASSERT(child != 0);
 	error = xfs_da3_node_read(args->trans, dp, child, -1, &bp,
 					     args->whichfork);
@@ -1321,18 +1321,14 @@ xfs_da3_node_lasthash(
 	struct xfs_buf		*bp,
 	int			*count)
 {
-	struct xfs_da_intnode	 *node;
-	struct xfs_da_node_entry *btree;
 	struct xfs_da3_icnode_hdr nodehdr;
 
-	node = bp->b_addr;
-	xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
+	xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, bp->b_addr);
 	if (count)
 		*count = nodehdr.count;
 	if (!nodehdr.count)
 		return 0;
-	btree = dp->d_ops->node_tree_p(node);
-	return be32_to_cpu(btree[nodehdr.count - 1].hashval);
+	return be32_to_cpu(nodehdr.btree[nodehdr.count - 1].hashval);
 }
 
 /*
@@ -1378,7 +1374,7 @@ xfs_da3_fixhashpath(
 
 		node = blk->bp->b_addr;
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
-		btree = dp->d_ops->node_tree_p(node);
+		btree = nodehdr.btree;
 		if (be32_to_cpu(btree[blk->index].hashval) == lasthash)
 			break;
 		blk->hashval = lasthash;
@@ -1417,7 +1413,7 @@ xfs_da3_node_remove(
 	 * Copy over the offending entry, or just zero it out.
 	 */
 	index = drop_blk->index;
-	btree = dp->d_ops->node_tree_p(node);
+	btree = nodehdr.btree;
 	if (index < nodehdr.count - 1) {
 		tmp  = nodehdr.count - index - 1;
 		tmp *= (uint)sizeof(xfs_da_node_entry_t);
@@ -1467,8 +1463,8 @@ xfs_da3_node_unbalance(
 	save_node = save_blk->bp->b_addr;
 	xfs_da3_node_hdr_from_disk(dp->i_mount, &drop_hdr, drop_node);
 	xfs_da3_node_hdr_from_disk(dp->i_mount, &save_hdr, save_node);
-	drop_btree = dp->d_ops->node_tree_p(drop_node);
-	save_btree = dp->d_ops->node_tree_p(save_node);
+	drop_btree = drop_hdr.btree;
+	save_btree = save_hdr.btree;
 	tp = state->args->trans;
 
 	/*
@@ -1602,7 +1598,7 @@ xfs_da3_node_lookup_int(
 		 */
 		node = blk->bp->b_addr;
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
-		btree = dp->d_ops->node_tree_p(node);
+		btree = nodehdr.btree;
 
 		/* Tree taller than we can handle; bail out! */
 		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH) {
@@ -1739,8 +1735,8 @@ xfs_da3_node_order(
 	node2 = node2_bp->b_addr;
 	xfs_da3_node_hdr_from_disk(dp->i_mount, &node1hdr, node1);
 	xfs_da3_node_hdr_from_disk(dp->i_mount, &node2hdr, node2);
-	btree1 = dp->d_ops->node_tree_p(node1);
-	btree2 = dp->d_ops->node_tree_p(node2);
+	btree1 = node1hdr.btree;
+	btree2 = node2hdr.btree;
 
 	if (node1hdr.count > 0 && node2hdr.count > 0 &&
 	    ((be32_to_cpu(btree2[0].hashval) < be32_to_cpu(btree1[0].hashval)) ||
@@ -1937,7 +1933,6 @@ xfs_da3_path_shift(
 {
 	struct xfs_da_state_blk	*blk;
 	struct xfs_da_blkinfo	*info;
-	struct xfs_da_intnode	*node;
 	struct xfs_da_args	*args;
 	struct xfs_da_node_entry *btree;
 	struct xfs_da3_icnode_hdr nodehdr;
@@ -1960,17 +1955,16 @@ xfs_da3_path_shift(
 	ASSERT((path->active > 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
 	level = (path->active-1) - 1;	/* skip bottom layer in path */
 	for (blk = &path->blk[level]; level >= 0; blk--, level--) {
-		node = blk->bp->b_addr;
-		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
-		btree = dp->d_ops->node_tree_p(node);
+		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr,
+					   blk->bp->b_addr);
 
 		if (forward && (blk->index < nodehdr.count - 1)) {
 			blk->index++;
-			blkno = be32_to_cpu(btree[blk->index].before);
+			blkno = be32_to_cpu(nodehdr.btree[blk->index].before);
 			break;
 		} else if (!forward && (blk->index > 0)) {
 			blk->index--;
-			blkno = be32_to_cpu(btree[blk->index].before);
+			blkno = be32_to_cpu(nodehdr.btree[blk->index].before);
 			break;
 		}
 	}
@@ -2021,9 +2015,9 @@ xfs_da3_path_shift(
 		case XFS_DA_NODE_MAGIC:
 		case XFS_DA3_NODE_MAGIC:
 			blk->magic = XFS_DA_NODE_MAGIC;
-			node = (xfs_da_intnode_t *)info;
-			xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
-			btree = dp->d_ops->node_tree_p(node);
+			xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr,
+						   bp->b_addr);
+			btree = nodehdr.btree;
 			blk->hashval = be32_to_cpu(btree[nodehdr.count - 1].hashval);
 			if (forward)
 				blk->index = 0;
@@ -2308,7 +2302,7 @@ xfs_da3_swap_lastblock(
 
 		dead_node = (xfs_da_intnode_t *)dead_info;
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &deadhdr, dead_node);
-		btree = dp->d_ops->node_tree_p(dead_node);
+		btree = deadhdr.btree;
 		dead_level = deadhdr.level;
 		dead_hash = be32_to_cpu(btree[deadhdr.count - 1].hashval);
 	}
@@ -2375,7 +2369,7 @@ xfs_da3_swap_lastblock(
 			goto done;
 		}
 		level = par_hdr.level;
-		btree = dp->d_ops->node_tree_p(par_node);
+		btree = par_hdr.btree;
 		for (entno = 0;
 		     entno < par_hdr.count &&
 		     be32_to_cpu(btree[entno].hashval) < dead_hash;
@@ -2425,7 +2419,7 @@ xfs_da3_swap_lastblock(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		btree = dp->d_ops->node_tree_p(par_node);
+		btree = par_hdr.btree;
 		entno = 0;
 	}
 	/*
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 932f3ba6a813..4955c1fb8b0d 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -135,6 +135,12 @@ struct xfs_da3_icnode_hdr {
 	uint16_t		magic;
 	uint16_t		count;
 	uint16_t		level;
+
+	/*
+	 * Pointer to the on-disk format entries, which are behind the
+	 * variable size (v4 vs v5) header in the on-disk block.
+	 */
+	struct xfs_da_node_entry *btree;
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 912096416a86..f896d37c845f 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -494,22 +494,6 @@ xfs_dir3_leaf_hdr_to_disk(
 	hdr3->stale = cpu_to_be16(from->stale);
 }
 
-
-/*
- * Directory/Attribute Node block operations
- */
-static struct xfs_da_node_entry *
-xfs_da2_node_tree_p(struct xfs_da_intnode *dap)
-{
-	return dap->__btree;
-}
-
-static struct xfs_da_node_entry *
-xfs_da3_node_tree_p(struct xfs_da_intnode *dap)
-{
-	return ((struct xfs_da3_intnode *)dap)->__btree;
-}
-
 /*
  * Directory free space block operations
  */
@@ -669,7 +653,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 	.leaf_ents_p = xfs_dir2_leaf_ents_p,
 
 	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
-	.node_tree_p = xfs_da2_node_tree_p,
 
 	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
 	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
@@ -717,7 +700,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.leaf_ents_p = xfs_dir2_leaf_ents_p,
 
 	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
-	.node_tree_p = xfs_da2_node_tree_p,
 
 	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
 	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
@@ -765,7 +747,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 	.leaf_ents_p = xfs_dir3_leaf_ents_p,
 
 	.node_hdr_size = sizeof(struct xfs_da3_node_hdr),
-	.node_tree_p = xfs_da3_node_tree_p,
 
 	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
 	.free_hdr_to_disk = xfs_dir3_free_hdr_to_disk,
@@ -778,12 +759,10 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 
 static const struct xfs_dir_ops xfs_dir2_nondir_ops = {
 	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
-	.node_tree_p = xfs_da2_node_tree_p,
 };
 
 static const struct xfs_dir_ops xfs_dir3_nondir_ops = {
 	.node_hdr_size = sizeof(struct xfs_da3_node_hdr),
-	.node_tree_p = xfs_da3_node_tree_p,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index c16efeae0f2b..6eee4c1b20da 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -82,8 +82,6 @@ struct xfs_dir_ops {
 		(*leaf_ents_p)(struct xfs_dir2_leaf *lp);
 
 	int	node_hdr_size;
-	struct xfs_da_node_entry *
-		(*node_tree_p)(struct xfs_da_intnode *dap);
 
 	int	free_hdr_size;
 	void	(*free_hdr_to_disk)(struct xfs_dir2_free *to,
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index be19a48716b7..dbcb9d932816 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -83,11 +83,12 @@ xchk_da_btree_node_entry(
 	int				level)
 {
 	struct xfs_da_state_blk		*blk = &ds->state->path.blk[level];
+	struct xfs_da3_icnode_hdr	hdr;
 
 	ASSERT(blk->magic == XFS_DA_NODE_MAGIC);
 
-	return (void *)ds->dargs.dp->d_ops->node_tree_p(blk->bp->b_addr) +
-		(blk->index * sizeof(struct xfs_da_node_entry));
+	xfs_da3_node_hdr_from_disk(ds->sc->mp, &hdr, blk->bp->b_addr);
+	return hdr.btree + blk->index;
 }
 
 /* Scrub a da btree hash (key). */
@@ -411,7 +412,7 @@ xchk_da_btree_block(
 		blk->magic = XFS_DA_NODE_MAGIC;
 		node = blk->bp->b_addr;
 		xfs_da3_node_hdr_from_disk(ip->i_mount, &nodehdr, node);
-		btree = ip->d_ops->node_tree_p(node);
+		btree = nodehdr.btree;
 		*pmaxrecs = nodehdr.count;
 		blk->hashval = be32_to_cpu(btree[*pmaxrecs - 1].hashval);
 		if (level == 0) {
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 88bc796c83f6..a78c501f6fb1 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -191,19 +191,17 @@ xfs_attr3_leaf_inactive(
  */
 STATIC int
 xfs_attr3_node_inactive(
-	struct xfs_trans **trans,
-	struct xfs_inode *dp,
-	struct xfs_buf	*bp,
-	int		level)
+	struct xfs_trans	**trans,
+	struct xfs_inode	*dp,
+	struct xfs_buf		*bp,
+	int			level)
 {
-	xfs_da_blkinfo_t *info;
-	xfs_da_intnode_t *node;
-	xfs_dablk_t child_fsb;
-	xfs_daddr_t parent_blkno, child_blkno;
-	int error, i;
-	struct xfs_buf *child_bp;
-	struct xfs_da_node_entry *btree;
+	struct xfs_da_blkinfo	*info;
+	xfs_dablk_t		child_fsb;
+	xfs_daddr_t		parent_blkno, child_blkno;
+	struct xfs_buf		*child_bp;
 	struct xfs_da3_icnode_hdr ichdr;
+	int			error, i;
 
 	/*
 	 * Since this code is recursive (gasp!) we must protect ourselves.
@@ -214,15 +212,13 @@ xfs_attr3_node_inactive(
 		return -EFSCORRUPTED;
 	}
 
-	node = bp->b_addr;
-	xfs_da3_node_hdr_from_disk(dp->i_mount, &ichdr, node);
+	xfs_da3_node_hdr_from_disk(dp->i_mount, &ichdr, bp->b_addr);
 	parent_blkno = bp->b_bn;
 	if (!ichdr.count) {
 		xfs_trans_brelse(*trans, bp);
 		return 0;
 	}
-	btree = dp->d_ops->node_tree_p(node);
-	child_fsb = be32_to_cpu(btree[0].before);
+	child_fsb = be32_to_cpu(ichdr.btree[0].before);
 	xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
 
 	/*
@@ -282,13 +278,15 @@ xfs_attr3_node_inactive(
 		 * child block number.
 		 */
 		if (i + 1 < ichdr.count) {
+			struct xfs_da3_icnode_hdr phdr;
+
 			error = xfs_da3_node_read(*trans, dp, 0, parent_blkno,
 						 &bp, XFS_ATTR_FORK);
 			if (error)
 				return error;
-			node = bp->b_addr;
-			btree = dp->d_ops->node_tree_p(node);
-			child_fsb = be32_to_cpu(btree[i + 1].before);
+			xfs_da3_node_hdr_from_disk(dp->i_mount, &phdr,
+						  bp->b_addr);
+			child_fsb = be32_to_cpu(phdr.btree[i + 1].before);
 			xfs_trans_brelse(*trans, bp);
 		}
 		/*
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index d89b83e89387..0ec6606149a2 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -254,7 +254,7 @@ xfs_attr_node_list_lookup(
 		else
 			expected_level--;
 
-		btree = dp->d_ops->node_tree_p(node);
+		btree = nodehdr.btree;
 		for (i = 0; i < nodehdr.count; btree++, i++) {
 			if (cursor->hashval <= be32_to_cpu(btree->hashval)) {
 				cursor->blkno = be32_to_cpu(btree->before);
-- 
2.20.1

