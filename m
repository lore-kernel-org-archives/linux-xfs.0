Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A4EBC5DF61
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44166214D8
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:24:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GTU9KIQQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbfKGSYo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:24:44 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44014 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbfKGSYo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:24:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LqQk18sGAfprVE0j7dgUqoToh+O7lw6qFx1UYwL7/8Q=; b=GTU9KIQQNcGgCznEFI/K1Anab9
        Md4RlbAL2tXkASe+zeEoXypchuw3r/U3PHdnqg7JVOyEMKUBVOFbXa0/fz2dqiHGTmnKcFXCuUDEp
        3Z7ufPUCu59/ZVR2plXbaSB/pOjKuUclRNotyzGXzkfg0t9P46xJMHyY/N10ogzjcp0MEv0CLbs/t
        IopswRcwU/jAEDrppCD2EgaPgfdUHSC6A+iDSfTDSf86O/FXEm28My0wm/bj5qpBoubqa2bGg1u4h
        OTrTG31hIDZp5pGSWCj+3HkWRX2z6jgtTlJMzTkbRASmp2onBnPxlCgODjvFvYO5Xhbn2w0+GwBlY
        2XgYrCpQ==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmSa-00033h-3b; Thu, 07 Nov 2019 18:24:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/46] xfs: move the dir2 leaf header size to struct xfs_da_geometry
Date:   Thu,  7 Nov 2019 19:23:35 +0100
Message-Id: <20191107182410.12660-12-hch@lst.de>
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

Move the leaf header size towards our structure for dir/attr geometry
parameters.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.h  | 1 +
 fs/xfs/libxfs/xfs_da_format.c | 3 ---
 fs/xfs/libxfs/xfs_dir2.c      | 7 +++++--
 fs/xfs/libxfs/xfs_dir2.h      | 1 -
 fs/xfs/libxfs/xfs_dir2_leaf.c | 2 +-
 fs/xfs/libxfs/xfs_dir2_node.c | 4 ++--
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 396b76ac02d6..b262ec403bba 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -26,6 +26,7 @@ struct xfs_da_geometry {
 	unsigned int	node_ents;	/* # of entries in a danode */
 	unsigned int	magicpct;	/* 37% of block size in bytes */
 	xfs_dablk_t	datablk;	/* blockno of dir data v2 */
+	unsigned int	leaf_hdr_size;	/* dir2 leaf header size */
 	xfs_dablk_t	leafblk;	/* blockno of leaf data v2 */
 	xfs_dablk_t	freeblk;	/* blockno of free data v2 */
 };
diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index ed21ce01502f..a3e87f4788e0 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -570,7 +570,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
 
-	.leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr),
 	.leaf_max_ents = xfs_dir2_max_leaf_ents,
 
 	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
@@ -612,7 +611,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
 
-	.leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr),
 	.leaf_max_ents = xfs_dir2_max_leaf_ents,
 
 	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
@@ -654,7 +652,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 	.data_entry_p = xfs_dir3_data_entry_p,
 	.data_unused_p = xfs_dir3_data_unused_p,
 
-	.leaf_hdr_size = sizeof(struct xfs_dir3_leaf_hdr),
 	.leaf_max_ents = xfs_dir3_max_leaf_ents,
 
 	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 98cc0631e7d5..6e7a4e9ced5e 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -122,10 +122,13 @@ xfs_da_mount(
 	dageo->fsblog = mp->m_sb.sb_blocklog;
 	dageo->blksize = xfs_dir2_dirblock_bytes(&mp->m_sb);
 	dageo->fsbcount = 1 << mp->m_sb.sb_dirblklog;
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		dageo->node_hdr_size = sizeof(struct xfs_da3_node_hdr);
-	else
+		dageo->leaf_hdr_size = sizeof(struct xfs_dir3_leaf_hdr);
+	} else {
 		dageo->node_hdr_size = sizeof(struct xfs_da_node_hdr);
+		dageo->leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr);
+	}
 
 	/*
 	 * Now we've set up the block conversion variables, we can calculate the
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index b46657974134..544adee5dd12 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -72,7 +72,6 @@ struct xfs_dir_ops {
 	struct xfs_dir2_data_unused *
 		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
 
-	int	leaf_hdr_size;
 	int	(*leaf_max_ents)(struct xfs_da_geometry *geo);
 
 	int	free_hdr_size;
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 5e3e96efdaca..888d4b0acab8 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1132,7 +1132,7 @@ xfs_dir3_leaf_log_header(
 
 	xfs_trans_log_buf(args->trans, bp,
 			  (uint)((char *)&leaf->hdr - (char *)leaf),
-			  args->dp->d_ops->leaf_hdr_size - 1);
+			  args->geo->leaf_hdr_size - 1);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 721dd2dcba8d..f7ba4d22165c 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1340,7 +1340,7 @@ xfs_dir2_leafn_remove(
 	 * Return indication of whether this leaf block is empty enough
 	 * to justify trying to join it with a neighbor.
 	 */
-	*rval = (dp->d_ops->leaf_hdr_size +
+	*rval = (args->geo->leaf_hdr_size +
 		 (uint)sizeof(leafhdr.ents) * (leafhdr.count - leafhdr.stale)) <
 		args->geo->magicpct;
 	return 0;
@@ -1446,7 +1446,7 @@ xfs_dir2_leafn_toosmall(
 	xfs_dir3_leaf_check(dp, blk->bp);
 
 	count = leafhdr.count - leafhdr.stale;
-	bytes = dp->d_ops->leaf_hdr_size + count * sizeof(ents[0]);
+	bytes = state->args->geo->leaf_hdr_size + count * sizeof(ents[0]);
 	if (bytes > (state->args->geo->blksize >> 1)) {
 		/*
 		 * Blk over 50%, don't try to join.
-- 
2.20.1

