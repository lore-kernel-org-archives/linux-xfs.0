Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CA7CA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E17292085B
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:07:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UwpnU+r8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfKAWHu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:07:50 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53642 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAWHu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:07:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=akG8Y2aBohjwRlMYjtyRCSKE3LCQ6xX8EVYPjnJLwt4=; b=UwpnU+r8J1yaiIBh+fk9UL7+2
        CH68c8RYVO14B2SrHygJQHLxQKnw12H44D36+3gE5Te7yy+qZtJoyXLdlOwPp7+1nV2HmL5HTuS+1
        H42ezUNM9oZrKflIhhhek5eMO6XHvtm8ELsLo5Xch9xWo9K11Kohg4Pivth3j5j4qp30uNDM/S6ub
        6ych24xMMql4NflqjVM8vcF8mEjTl9VhrUYRKeOnctRNXCuqwTppjZuOtULqhO1FfqiF+c4qjyZwa
        NHcz+FoeDKozinkDs28Oxj9if/yeSH1VD8j1wwklKncQlN3zNj+xv+gIaPCfAZOy0BiGPU0U8DExk
        msX0viRZg==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf5C-0005se-7s
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:07:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/34] xfs: devirtualize ->node_hdr_to_disk
Date:   Fri,  1 Nov 2019 15:06:49 -0700
Message-Id: <20191101220719.29100-5-hch@lst.de>
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

Replace the ->node_hdr_to_disk dir ops method with a directly called
xfs_da_node_hdr_to_disk helper that takes care of the v4 vs v5
difference.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
 fs/xfs/libxfs/xfs_da_btree.c  | 39 ++++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_da_btree.h  |  2 ++
 fs/xfs/libxfs/xfs_da_format.c | 34 ------------------------------
 fs/xfs/libxfs/xfs_dir2.h      |  2 --
 5 files changed, 35 insertions(+), 44 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 131fef677896..1b0fbee21e14 100644
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
index f7ddc91ed099..462a245fdad7 100644
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
 
@@ -666,7 +691,7 @@ xfs_da3_root_split(
 	btree[1].hashval = cpu_to_be32(blk2->hashval);
 	btree[1].before = cpu_to_be32(blk2->blkno);
 	nodehdr.count = 2;
-	dp->d_ops->node_hdr_to_disk(node, &nodehdr);
+	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &nodehdr);
 
 #ifdef DEBUG
 	if (oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
@@ -891,11 +916,11 @@ xfs_da3_node_rebalance(
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
@@ -967,7 +992,7 @@ xfs_da3_node_add(
 				tmp + sizeof(*btree)));
 
 	nodehdr.count += 1;
-	dp->d_ops->node_hdr_to_disk(node, &nodehdr);
+	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &nodehdr);
 	xfs_trans_log_buf(state->args->trans, oldblk->bp,
 		XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size));
 
@@ -1403,7 +1428,7 @@ xfs_da3_node_remove(
 	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
 	    XFS_DA_LOGRANGE(node, &btree[index], sizeof(btree[index])));
 	nodehdr.count -= 1;
-	dp->d_ops->node_hdr_to_disk(node, &nodehdr);
+	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &nodehdr);
 	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
 	    XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size));
 
@@ -1475,7 +1500,7 @@ xfs_da3_node_unbalance(
 	memcpy(&save_btree[sindex], &drop_btree[0], tmp);
 	save_hdr.count += drop_hdr.count;
 
-	dp->d_ops->node_hdr_to_disk(save_node, &save_hdr);
+	xfs_da3_node_hdr_to_disk(dp->i_mount, save_node, &save_hdr);
 	xfs_trans_log_buf(tp, save_blk->bp,
 		XFS_DA_LOGRANGE(save_node, &save_node->hdr,
 				dp->d_ops->node_hdr_size));
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index eb15b9e76bc8..69ebf6a50d85 100644
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

