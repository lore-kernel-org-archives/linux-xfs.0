Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 137E9C5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE0DD214D8
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:24:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="J5c1E46D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbfKGSYw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:24:52 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44066 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbfKGSYw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:24:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=k5q6HcELY+l/dx6cZfsIF3Np96tZA7wK3PqHLbejmCY=; b=J5c1E46D10fcTM/QK3y8eIywF9
        SaOtVk4vhd0bjEAMQwto9oJyUM+XwbuO1w3Kfr1CKL7XSPdSncZ4EQzQFCfRxzLfX3MT01Q/dw2CW
        PAVd80d5q7enw+OKcvRD6Ct5OhuB5EZIX6XATc09VYoRtkPZpkBNLm8j/GiEI5wdeW68yGN56N4C7
        51Xd8BAti0HsZV3ci9yDxNpBwZdU/YFrYFgsKl4dOn38VYoQpxlazAGQmrgFrd2XRztLAhkEKwCYJ
        9MKBcaHMfrZByOzbfs4/EwrmGYPhi37+K8kWZGmErBYgJUV+yWxLQNhy7TLDiaJ5OF9JyeJv84b5c
        cXHtJQpw==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmSh-00035I-Me; Thu, 07 Nov 2019 18:24:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 14/46] xfs: devirtualize ->free_hdr_to_disk
Date:   Thu,  7 Nov 2019 19:23:38 +0100
Message-Id: <20191107182410.12660-15-hch@lst.de>
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

Replace the ->free_hdr_to_disk dir ops method with a directly called
xfs_dir2_free_hdr_to_disk helper that takes care of the differences
between the v4 and v5 on-disk format.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_format.c | 31 -------------------------------
 fs/xfs/libxfs/xfs_dir2.h      |  2 --
 fs/xfs/libxfs/xfs_dir2_node.c | 33 +++++++++++++++++++++++++++++----
 3 files changed, 29 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index d0e541d9d335..b943d9443d55 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -468,34 +468,6 @@ xfs_dir3_db_to_fdindex(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
 	return db % xfs_dir3_free_max_bests(geo);
 }
 
-static void
-xfs_dir2_free_hdr_to_disk(
-	struct xfs_dir2_free		*to,
-	struct xfs_dir3_icfree_hdr	*from)
-{
-	ASSERT(from->magic == XFS_DIR2_FREE_MAGIC);
-
-	to->hdr.magic = cpu_to_be32(from->magic);
-	to->hdr.firstdb = cpu_to_be32(from->firstdb);
-	to->hdr.nvalid = cpu_to_be32(from->nvalid);
-	to->hdr.nused = cpu_to_be32(from->nused);
-}
-
-static void
-xfs_dir3_free_hdr_to_disk(
-	struct xfs_dir2_free		*to,
-	struct xfs_dir3_icfree_hdr	*from)
-{
-	struct xfs_dir3_free_hdr *hdr3 = (struct xfs_dir3_free_hdr *)to;
-
-	ASSERT(from->magic == XFS_DIR3_FREE_MAGIC);
-
-	hdr3->hdr.magic = cpu_to_be32(from->magic);
-	hdr3->firstdb = cpu_to_be32(from->firstdb);
-	hdr3->nvalid = cpu_to_be32(from->nvalid);
-	hdr3->nused = cpu_to_be32(from->nused);
-}
-
 static const struct xfs_dir_ops xfs_dir2_ops = {
 	.sf_entsize = xfs_dir2_sf_entsize,
 	.sf_nextentry = xfs_dir2_sf_nextentry,
@@ -527,7 +499,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_unused_p = xfs_dir2_data_unused_p,
 
 	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
-	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
 	.free_max_bests = xfs_dir2_free_max_bests,
 	.free_bests_p = xfs_dir2_free_bests_p,
 	.db_to_fdb = xfs_dir2_db_to_fdb,
@@ -565,7 +536,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.data_unused_p = xfs_dir2_data_unused_p,
 
 	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
-	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
 	.free_max_bests = xfs_dir2_free_max_bests,
 	.free_bests_p = xfs_dir2_free_bests_p,
 	.db_to_fdb = xfs_dir2_db_to_fdb,
@@ -603,7 +573,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 	.data_unused_p = xfs_dir3_data_unused_p,
 
 	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
-	.free_hdr_to_disk = xfs_dir3_free_hdr_to_disk,
 	.free_max_bests = xfs_dir3_free_max_bests,
 	.free_bests_p = xfs_dir3_free_bests_p,
 	.db_to_fdb = xfs_dir3_db_to_fdb,
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index c3e6a6fb7e37..613a78281d03 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -73,8 +73,6 @@ struct xfs_dir_ops {
 		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
 
 	int	free_hdr_size;
-	void	(*free_hdr_to_disk)(struct xfs_dir2_free *to,
-				    struct xfs_dir3_icfree_hdr *from);
 	int	(*free_max_bests)(struct xfs_da_geometry *geo);
 	__be16 * (*free_bests_p)(struct xfs_dir2_free *free);
 	xfs_dir2_db_t (*db_to_fdb)(struct xfs_da_geometry *geo,
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index d337ecd4e3be..4e49ac64a2ff 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -244,6 +244,31 @@ xfs_dir2_free_hdr_from_disk(
 	}
 }
 
+static void
+xfs_dir2_free_hdr_to_disk(
+	struct xfs_mount		*mp,
+	struct xfs_dir2_free		*to,
+	struct xfs_dir3_icfree_hdr	*from)
+{
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dir3_free	*to3 = (struct xfs_dir3_free *)to;
+
+		ASSERT(from->magic == XFS_DIR3_FREE_MAGIC);
+
+		to3->hdr.hdr.magic = cpu_to_be32(from->magic);
+		to3->hdr.firstdb = cpu_to_be32(from->firstdb);
+		to3->hdr.nvalid = cpu_to_be32(from->nvalid);
+		to3->hdr.nused = cpu_to_be32(from->nused);
+	} else {
+		ASSERT(from->magic == XFS_DIR2_FREE_MAGIC);
+
+		to->hdr.magic = cpu_to_be32(from->magic);
+		to->hdr.firstdb = cpu_to_be32(from->firstdb);
+		to->hdr.nvalid = cpu_to_be32(from->nvalid);
+		to->hdr.nused = cpu_to_be32(from->nused);
+	}
+}
+
 int
 xfs_dir2_free_read(
 	struct xfs_trans	*tp,
@@ -302,7 +327,7 @@ xfs_dir3_free_get_buf(
 		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_meta_uuid);
 	} else
 		hdr.magic = XFS_DIR2_FREE_MAGIC;
-	dp->d_ops->free_hdr_to_disk(bp->b_addr, &hdr);
+	xfs_dir2_free_hdr_to_disk(mp, bp->b_addr, &hdr);
 	*bpp = bp;
 	return 0;
 }
@@ -420,7 +445,7 @@ xfs_dir2_leaf_to_node(
 	freehdr.nused = n;
 	freehdr.nvalid = be32_to_cpu(ltp->bestcount);
 
-	dp->d_ops->free_hdr_to_disk(fbp->b_addr, &freehdr);
+	xfs_dir2_free_hdr_to_disk(dp->i_mount, fbp->b_addr, &freehdr);
 	xfs_dir2_free_log_bests(args, fbp, 0, freehdr.nvalid - 1);
 	xfs_dir2_free_log_header(args, fbp);
 
@@ -1182,7 +1207,7 @@ xfs_dir3_data_block_free(
 		logfree = 1;
 	}
 
-	dp->d_ops->free_hdr_to_disk(free, &freehdr);
+	xfs_dir2_free_hdr_to_disk(dp->i_mount, free, &freehdr);
 	xfs_dir2_free_log_header(args, fbp);
 
 	/*
@@ -1739,7 +1764,7 @@ xfs_dir2_node_add_datablk(
 	 */
 	if (bests[*findex] == cpu_to_be16(NULLDATAOFF)) {
 		freehdr.nused++;
-		dp->d_ops->free_hdr_to_disk(fbp->b_addr, &freehdr);
+		xfs_dir2_free_hdr_to_disk(mp, fbp->b_addr, &freehdr);
 		xfs_dir2_free_log_header(args, fbp);
 	}
 
-- 
2.20.1

