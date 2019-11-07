Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE3B4C5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84776206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r0JPmiZH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfKGSZA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:00 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44088 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbfKGSY7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:24:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=v2ft86RE2UDMKaW/1e1dt9Hoo23iYMA3ePCrVeFnk6E=; b=r0JPmiZHZCXtnV2nJIo1W5SaR
        GHupcIyT/DViYZbnFM5jcaXfKcngSSudmPzF3Lo7Jtv70jkwLTRP06bPUhEIlals+tpW9VtRGCq9h
        bURaBe2zIlAjp4oyPYQ2qiQIyZDMUlEeFYi+0uj0lqvjQqsi/95IiPSywRjRAzBIg7j6s0O4++bz+
        fjouQnyTzBHGMy9DTRBb3RjQTeMaxhdHF2GkmrXQoSidgq+8FB3VXjUj/jNlGrcmwbkYoHZa5YY8m
        XhM/eI/cgee6qLMgp7li1NkuoPQAlatpj981QWjbT1cWN9MT22v/UbpZsyqHFMbpTW2kfje9FEEiY
        +i1lgOHcg==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmSp-00036r-C0
        for linux-xfs@vger.kernel.org; Thu, 07 Nov 2019 18:24:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 17/46] xfs: move the dir2 free header size to struct xfs_da_geometry
Date:   Thu,  7 Nov 2019 19:23:41 +0100
Message-Id: <20191107182410.12660-18-hch@lst.de>
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

Move the free header size towards our structure for dir/attr geometry
parameters.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_btree.h  | 1 +
 fs/xfs/libxfs/xfs_da_format.c | 3 ---
 fs/xfs/libxfs/xfs_dir2.c      | 2 ++
 fs/xfs/libxfs/xfs_dir2.h      | 1 -
 fs/xfs/libxfs/xfs_dir2_node.c | 2 +-
 5 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index c6ff5329e92b..e8f0b7ac051c 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -29,6 +29,7 @@ struct xfs_da_geometry {
 	unsigned int	leaf_hdr_size;	/* dir2 leaf header size */
 	unsigned int	leaf_max_ents;	/* # of entries in dir2 leaf */
 	xfs_dablk_t	leafblk;	/* blockno of leaf data v2 */
+	unsigned int	free_hdr_size;	/* dir2 free header size */
 	xfs_dablk_t	freeblk;	/* blockno of free data v2 */
 };
 
diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 7263b6d6a135..1fc8982c830f 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -486,7 +486,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
 
-	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
 	.free_max_bests = xfs_dir2_free_max_bests,
 	.db_to_fdb = xfs_dir2_db_to_fdb,
 	.db_to_fdindex = xfs_dir2_db_to_fdindex,
@@ -522,7 +521,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
 
-	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
 	.free_max_bests = xfs_dir2_free_max_bests,
 	.db_to_fdb = xfs_dir2_db_to_fdb,
 	.db_to_fdindex = xfs_dir2_db_to_fdindex,
@@ -558,7 +556,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 	.data_entry_p = xfs_dir3_data_entry_p,
 	.data_unused_p = xfs_dir3_data_unused_p,
 
-	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
 	.free_max_bests = xfs_dir3_free_max_bests,
 	.db_to_fdb = xfs_dir3_db_to_fdb,
 	.db_to_fdindex = xfs_dir3_db_to_fdindex,
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 8093afb389a1..eee75ec9707f 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -125,9 +125,11 @@ xfs_da_mount(
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		dageo->node_hdr_size = sizeof(struct xfs_da3_node_hdr);
 		dageo->leaf_hdr_size = sizeof(struct xfs_dir3_leaf_hdr);
+		dageo->free_hdr_size = sizeof(struct xfs_dir3_free_hdr);
 	} else {
 		dageo->node_hdr_size = sizeof(struct xfs_da_node_hdr);
 		dageo->leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr);
+		dageo->free_hdr_size = sizeof(struct xfs_dir2_free_hdr);
 	}
 	dageo->leaf_max_ents = (dageo->blksize - dageo->leaf_hdr_size) /
 			sizeof(struct xfs_dir2_leaf_entry);
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 402f00326b64..d87cd71e3cf1 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -72,7 +72,6 @@ struct xfs_dir_ops {
 	struct xfs_dir2_data_unused *
 		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
 
-	int	free_hdr_size;
 	int	(*free_max_bests)(struct xfs_da_geometry *geo);
 	xfs_dir2_db_t (*db_to_fdb)(struct xfs_da_geometry *geo,
 				   xfs_dir2_db_t db);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index e9b4667faeac..c9a52e4e515d 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -372,7 +372,7 @@ xfs_dir2_free_log_header(
 	       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
 #endif
 	xfs_trans_log_buf(args->trans, bp, 0,
-			  args->dp->d_ops->free_hdr_size - 1);
+			  args->geo->free_hdr_size - 1);
 }
 
 /*
-- 
2.20.1

