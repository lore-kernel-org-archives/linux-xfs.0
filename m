Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 430CDC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:24:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 063CD206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:24:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U2956nCO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbfKGSY3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:24:29 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43766 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbfKGSY2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:24:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=107QYRzCD0WiJaqFyjmpvFhJ4yuQaHLONEfU0pNgFRY=; b=U2956nCOQOtWfw5V0+VJ5FgyGO
        j76Zdp7sGWewGssvgrm/+g5b+tdGkFI5WVuiatsyvoU0ZENR/se2uL1Q3KFwZiw8gyH+z+SPc8Nlq
        wMn+/EvGHx0vrr73oZMLT4/5yC9d45+kxX0Qs1dqbxDrzOV9fau4fHY0BAKIzrKhsBceo2hJU9gZ6
        ATdzJgfCpcCgn+XIE5OsdZkDPxnIeJCddmI3w5hBdEXpeUy5P5XQDTbj12av4IbDGLGkQlPAZg4xE
        DNIdz854ffuTVaadySjzX1Psgun6zyH0rVj9QWxzPUlyaaCuWMTrZoGvD320Zk8ed9oFFXKQaYF1J
        xsL1sXxw==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmSJ-0002wE-NI; Thu, 07 Nov 2019 18:24:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/46] xfs: devirtualize ->node_hdr_to_disk
Date:   Thu,  7 Nov 2019 19:23:29 +0100
Message-Id: <20191107182410.12660-6-hch@lst.de>
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

Replace the ->node_hdr_to_disk dir ops method with a directly called
xfs_da_node_hdr_to_disk helper that takes care of the v4 vs v5
difference.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
 fs/xfs/libxfs/xfs_da_btree.c  | 39 ++++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_da_btree.h  |  2 ++
 fs/xfs/libxfs/xfs_da_format.c | 34 ------------------------------
 fs/xfs/libxfs/xfs_dir2.h      |  2 --
 5 files changed, 35 insertions(+), 44 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 08176cf261fb..ba1c3486fe54 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1196,7 +1196,7 @@ xfs_attr3_leaf_to_node(
 	btree[0].hashval = entries[icleafhdr.count - 1].hashval;
 	btree[0].before = cpu_to_be32(blkno);
 	icnodehdr.count = 1;
-	dp->d_ops->node_hdr_to_disk(node, &icnodehdr);
+	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &icnodehdr);
 	xfs_trans_log_buf(args->trans, bp1, 0, args->geo->blksize - 1);
 	error = 0;
 out:
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 434f1e7191e4..2a0221fcad82 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -135,6 +135,31 @@ xfs_da3_node_hdr_from_disk(
 	}
 }
 
+void
+xfs_da3_node_hdr_to_disk(
+	struct xfs_mount		*mp,
+	struct xfs_da_intnode		*to,
+	struct xfs_da3_icnode_hdr	*from)
+{
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_da3_intnode	*to3 = (struct xfs_da3_intnode *)to;
+
+		ASSERT(from->magic == XFS_DA3_NODE_MAGIC);
+		to3->hdr.info.hdr.forw = cpu_to_be32(from->forw);
+		to3->hdr.info.hdr.back = cpu_to_be32(from->back);
+		to3->hdr.info.hdr.magic = cpu_to_be16(from->magic);
+		to3->hdr.__count = cpu_to_be16(from->count);
+		to3->hdr.__level = cpu_to_be16(from->level);
+	} else {
+		ASSERT(from->magic == XFS_DA_NODE_MAGIC);
+		to->hdr.info.forw = cpu_to_be32(from->forw);
+		to->hdr.info.back = cpu_to_be32(from->back);
+		to->hdr.info.magic = cpu_to_be16(from->magic);
+		to->hdr.__count = cpu_to_be16(from->count);
+		to->hdr.__level = cpu_to_be16(from->level);
+	}
+}
+
 /*
  * Verify an xfs_da3_blkinfo structure. Note that the da3 fields are only
  * accessible on v5 filesystems. This header format is common across da node,
@@ -385,7 +410,7 @@ xfs_da3_node_create(
 	}
 	ichdr.level = level;
 
-	dp->d_ops->node_hdr_to_disk(node, &ichdr);
+	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &ichdr);
 	xfs_trans_log_buf(tp, bp,
 		XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size));
 
@@ -668,7 +693,7 @@ xfs_da3_root_split(
 	btree[1].hashval = cpu_to_be32(blk2->hashval);
 	btree[1].before = cpu_to_be32(blk2->blkno);
 	nodehdr.count = 2;
-	dp->d_ops->node_hdr_to_disk(node, &nodehdr);
+	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &nodehdr);
 
 #ifdef DEBUG
 	if (oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
@@ -893,11 +918,11 @@ xfs_da3_node_rebalance(
 	/*
 	 * Log header of node 1 and all current bits of node 2.
 	 */
-	dp->d_ops->node_hdr_to_disk(node1, &nodehdr1);
+	xfs_da3_node_hdr_to_disk(dp->i_mount, node1, &nodehdr1);
 	xfs_trans_log_buf(tp, blk1->bp,
 		XFS_DA_LOGRANGE(node1, &node1->hdr, dp->d_ops->node_hdr_size));
 
-	dp->d_ops->node_hdr_to_disk(node2, &nodehdr2);
+	xfs_da3_node_hdr_to_disk(dp->i_mount, node2, &nodehdr2);
 	xfs_trans_log_buf(tp, blk2->bp,
 		XFS_DA_LOGRANGE(node2, &node2->hdr,
 				dp->d_ops->node_hdr_size +
@@ -969,7 +994,7 @@ xfs_da3_node_add(
 				tmp + sizeof(*btree)));
 
 	nodehdr.count += 1;
-	dp->d_ops->node_hdr_to_disk(node, &nodehdr);
+	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &nodehdr);
 	xfs_trans_log_buf(state->args->trans, oldblk->bp,
 		XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size));
 
@@ -1405,7 +1430,7 @@ xfs_da3_node_remove(
 	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
 	    XFS_DA_LOGRANGE(node, &btree[index], sizeof(btree[index])));
 	nodehdr.count -= 1;
-	dp->d_ops->node_hdr_to_disk(node, &nodehdr);
+	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &nodehdr);
 	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
 	    XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size));
 
@@ -1477,7 +1502,7 @@ xfs_da3_node_unbalance(
 	memcpy(&save_btree[sindex], &drop_btree[0], tmp);
 	save_hdr.count += drop_hdr.count;
 
-	dp->d_ops->node_hdr_to_disk(save_node, &save_hdr);
+	xfs_da3_node_hdr_to_disk(dp->i_mount, save_node, &save_hdr);
 	xfs_trans_log_buf(tp, save_blk->bp,
 		XFS_DA_LOGRANGE(save_node, &save_node->hdr,
 				dp->d_ops->node_hdr_size));
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 21dc03c818e9..932f3ba6a813 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -217,6 +217,8 @@ void xfs_da_state_free(xfs_da_state_t *state);
 
 void	xfs_da3_node_hdr_from_disk(struct xfs_mount *mp,
 		struct xfs_da3_icnode_hdr *to, struct xfs_da_intnode *from);
+void	xfs_da3_node_hdr_to_disk(struct xfs_mount *mp,
+		struct xfs_da_intnode *to, struct xfs_da3_icnode_hdr *from);
 
 extern struct kmem_zone *xfs_da_state_zone;
 extern const struct xfs_nameops xfs_default_nameops;
diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 267aca857126..912096416a86 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -510,35 +510,6 @@ xfs_da3_node_tree_p(struct xfs_da_intnode *dap)
 	return ((struct xfs_da3_intnode *)dap)->__btree;
 }
 
-static void
-xfs_da2_node_hdr_to_disk(
-	struct xfs_da_intnode		*to,
-	struct xfs_da3_icnode_hdr	*from)
-{
-	ASSERT(from->magic == XFS_DA_NODE_MAGIC);
-	to->hdr.info.forw = cpu_to_be32(from->forw);
-	to->hdr.info.back = cpu_to_be32(from->back);
-	to->hdr.info.magic = cpu_to_be16(from->magic);
-	to->hdr.__count = cpu_to_be16(from->count);
-	to->hdr.__level = cpu_to_be16(from->level);
-}
-
-static void
-xfs_da3_node_hdr_to_disk(
-	struct xfs_da_intnode		*to,
-	struct xfs_da3_icnode_hdr	*from)
-{
-	struct xfs_da3_node_hdr *hdr3 = (struct xfs_da3_node_hdr *)to;
-
-	ASSERT(from->magic == XFS_DA3_NODE_MAGIC);
-	hdr3->info.hdr.forw = cpu_to_be32(from->forw);
-	hdr3->info.hdr.back = cpu_to_be32(from->back);
-	hdr3->info.hdr.magic = cpu_to_be16(from->magic);
-	hdr3->__count = cpu_to_be16(from->count);
-	hdr3->__level = cpu_to_be16(from->level);
-}
-
-
 /*
  * Directory free space block operations
  */
@@ -698,7 +669,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 	.leaf_ents_p = xfs_dir2_leaf_ents_p,
 
 	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
-	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
 	.node_tree_p = xfs_da2_node_tree_p,
 
 	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
@@ -747,7 +717,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.leaf_ents_p = xfs_dir2_leaf_ents_p,
 
 	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
-	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
 	.node_tree_p = xfs_da2_node_tree_p,
 
 	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
@@ -796,7 +765,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 	.leaf_ents_p = xfs_dir3_leaf_ents_p,
 
 	.node_hdr_size = sizeof(struct xfs_da3_node_hdr),
-	.node_hdr_to_disk = xfs_da3_node_hdr_to_disk,
 	.node_tree_p = xfs_da3_node_tree_p,
 
 	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
@@ -810,13 +778,11 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 
 static const struct xfs_dir_ops xfs_dir2_nondir_ops = {
 	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
-	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
 	.node_tree_p = xfs_da2_node_tree_p,
 };
 
 static const struct xfs_dir_ops xfs_dir3_nondir_ops = {
 	.node_hdr_size = sizeof(struct xfs_da3_node_hdr),
-	.node_hdr_to_disk = xfs_da3_node_hdr_to_disk,
 	.node_tree_p = xfs_da3_node_tree_p,
 };
 
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 573043f59c85..c16efeae0f2b 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -82,8 +82,6 @@ struct xfs_dir_ops {
 		(*leaf_ents_p)(struct xfs_dir2_leaf *lp);
 
 	int	node_hdr_size;
-	void	(*node_hdr_to_disk)(struct xfs_da_intnode *to,
-				    struct xfs_da3_icnode_hdr *from);
 	struct xfs_da_node_entry *
 		(*node_tree_p)(struct xfs_da_intnode *dap);
 
-- 
2.20.1

