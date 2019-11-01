Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4309CA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B38342085B
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:08:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GspNlzFy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfKAWI7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:08:59 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53732 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfKAWI7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:08:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZaHqdQjlUXYLRNgtoMX53TrO0o0gxdPL6/qb+ZvUIT0=; b=GspNlzFyMh138WkkStcHEJ2XG
        q3PJWGdJneLzan8j0BXjLD0jpTbK5PSQyZ0PeAootDhaMvzO9TGZfcyoAqCsYKdgoaEqAzmLWybqy
        BgB45MtfMwkC4SkLefM2lGJM22JNx7Y6psQ3IcNaYpRi7u218kLr97nFXeSewyWcCtjtdRpVZEXYr
        x4raSBGY7ZfsXaOCmx28Z+mk33ffrfmu4HMKzomYzohlZNmChztL+k+Fq/7vH/QXpmKcSlcbCBZyL
        JZPBYfL7do/bSQ4uFFiwHYYnOWy/+QVhtAylMzBql1SfV5fB482+TcdBvXyyJhSJMG17b/mIDF4cw
        7edsz+YQw==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf6I-0005zw-Uz
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:08:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 17/34] xfs: move the max dir2 free bests count to struct xfs_da_geometry
Date:   Fri,  1 Nov 2019 15:07:02 -0700
Message-Id: <20191101220719.29100-18-hch@lst.de>
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

Move the max free bests count towards our structure for dir/attr
geometry parameters.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_btree.h  |  1 +
 fs/xfs/libxfs/xfs_da_format.c | 29 ++++-------------------------
 fs/xfs/libxfs/xfs_dir2.c      |  2 ++
 fs/xfs/libxfs/xfs_dir2.h      |  1 -
 fs/xfs/libxfs/xfs_dir2_node.c | 12 +++++-------
 5 files changed, 12 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 3d0b1e97bf43..e3f4329ab882 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -30,6 +30,7 @@ struct xfs_da_geometry {
 	unsigned int	leaf_max_ents;	/* # of entries in dir2 leaf */
 	xfs_dablk_t	leafblk;	/* blockno of leaf data v2 */
 	int		free_hdr_size;	/* dir2 free header size */
+	unsigned int	free_max_bests;	/* # of bests entries in dir2 free */
 	xfs_dablk_t	freeblk;	/* blockno of free data v2 */
 };
 
diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 1fc8982c830f..d2d3144c1598 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -400,17 +400,6 @@ xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
 		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
 }
 
-
-/*
- * Directory free space block operations
- */
-static int
-xfs_dir2_free_max_bests(struct xfs_da_geometry *geo)
-{
-	return (geo->blksize - sizeof(struct xfs_dir2_free_hdr)) /
-		sizeof(xfs_dir2_data_off_t);
-}
-
 /*
  * Convert data space db to the corresponding free db.
  */
@@ -418,7 +407,7 @@ static xfs_dir2_db_t
 xfs_dir2_db_to_fdb(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
 {
 	return xfs_dir2_byte_to_db(geo, XFS_DIR2_FREE_OFFSET) +
-			(db / xfs_dir2_free_max_bests(geo));
+			(db / geo->free_max_bests);
 }
 
 /*
@@ -427,14 +416,7 @@ xfs_dir2_db_to_fdb(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
 static int
 xfs_dir2_db_to_fdindex(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
 {
-	return db % xfs_dir2_free_max_bests(geo);
-}
-
-static int
-xfs_dir3_free_max_bests(struct xfs_da_geometry *geo)
-{
-	return (geo->blksize - sizeof(struct xfs_dir3_free_hdr)) /
-		sizeof(xfs_dir2_data_off_t);
+	return db % geo->free_max_bests;
 }
 
 /*
@@ -444,7 +426,7 @@ static xfs_dir2_db_t
 xfs_dir3_db_to_fdb(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
 {
 	return xfs_dir2_byte_to_db(geo, XFS_DIR2_FREE_OFFSET) +
-			(db / xfs_dir3_free_max_bests(geo));
+			(db / geo->free_max_bests);
 }
 
 /*
@@ -453,7 +435,7 @@ xfs_dir3_db_to_fdb(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
 static int
 xfs_dir3_db_to_fdindex(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
 {
-	return db % xfs_dir3_free_max_bests(geo);
+	return db % geo->free_max_bests;
 }
 
 static const struct xfs_dir_ops xfs_dir2_ops = {
@@ -486,7 +468,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
 
-	.free_max_bests = xfs_dir2_free_max_bests,
 	.db_to_fdb = xfs_dir2_db_to_fdb,
 	.db_to_fdindex = xfs_dir2_db_to_fdindex,
 };
@@ -521,7 +502,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
 
-	.free_max_bests = xfs_dir2_free_max_bests,
 	.db_to_fdb = xfs_dir2_db_to_fdb,
 	.db_to_fdindex = xfs_dir2_db_to_fdindex,
 };
@@ -556,7 +536,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 	.data_entry_p = xfs_dir3_data_entry_p,
 	.data_unused_p = xfs_dir3_data_unused_p,
 
-	.free_max_bests = xfs_dir3_free_max_bests,
 	.db_to_fdb = xfs_dir3_db_to_fdb,
 	.db_to_fdindex = xfs_dir3_db_to_fdindex,
 };
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 13ac228bfc86..6c46893af17e 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -133,6 +133,8 @@ xfs_da_mount(
 	}
 	dageo->leaf_max_ents = (dageo->blksize - dageo->leaf_hdr_size) /
 			sizeof(struct xfs_dir2_leaf_entry);
+	dageo->free_max_bests = (dageo->blksize - dageo->free_hdr_size) /
+			sizeof(xfs_dir2_data_off_t);
 
 	/*
 	 * Now we've set up the block conversion variables, we can calculate the
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index d87cd71e3cf1..e3c1385d1522 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -72,7 +72,6 @@ struct xfs_dir_ops {
 	struct xfs_dir2_data_unused *
 		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
 
-	int	(*free_max_bests)(struct xfs_da_geometry *geo);
 	xfs_dir2_db_t (*db_to_fdb)(struct xfs_da_geometry *geo,
 				   xfs_dir2_db_t db);
 	int	(*db_to_fdindex)(struct xfs_da_geometry *geo,
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 7047d1e066f9..0fcd7351038e 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -160,10 +160,9 @@ xfs_dir3_free_header_check(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
+	int			maxbests = mp->m_dir_geo->free_max_bests;
 	unsigned int		firstdb;
-	int			maxbests;
 
-	maxbests = dp->d_ops->free_max_bests(mp->m_dir_geo);
 	firstdb = (xfs_dir2_da_to_db(mp->m_dir_geo, fbno) -
 		   xfs_dir2_byte_to_db(mp->m_dir_geo, XFS_DIR2_FREE_OFFSET)) *
 			maxbests;
@@ -558,8 +557,7 @@ xfs_dir2_free_hdr_check(
 
 	xfs_dir2_free_hdr_from_disk(dp->i_mount, &hdr, bp->b_addr);
 
-	ASSERT((hdr.firstdb %
-		dp->d_ops->free_max_bests(dp->i_mount->m_dir_geo)) == 0);
+	ASSERT((hdr.firstdb % dp->i_mount->m_dir_geo->free_max_bests) == 0);
 	ASSERT(hdr.firstdb <= db);
 	ASSERT(db < hdr.firstdb + hdr.nvalid);
 }
@@ -1334,7 +1332,7 @@ xfs_dir2_leafn_remove(
 		struct xfs_dir3_icfree_hdr freehdr;
 
 		xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, free);
-		ASSERT(freehdr.firstdb == dp->d_ops->free_max_bests(args->geo) *
+		ASSERT(freehdr.firstdb == args->geo->free_max_bests *
 			(fdb - xfs_dir2_byte_to_db(args->geo,
 						   XFS_DIR2_FREE_OFFSET)));
 	}
@@ -1727,7 +1725,7 @@ xfs_dir2_node_add_datablk(
 		/* Remember the first slot as our empty slot. */
 		hdr->firstdb = (fbno - xfs_dir2_byte_to_db(args->geo,
 							XFS_DIR2_FREE_OFFSET)) *
-				dp->d_ops->free_max_bests(args->geo);
+				args->geo->free_max_bests;
 	} else {
 		xfs_dir2_free_hdr_from_disk(mp, hdr, fbp->b_addr);
 	}
@@ -1737,7 +1735,7 @@ xfs_dir2_node_add_datablk(
 
 	/* Extend the freespace table if the new data block is off the end. */
 	if (*findex >= hdr->nvalid) {
-		ASSERT(*findex < dp->d_ops->free_max_bests(args->geo));
+		ASSERT(*findex < args->geo->free_max_bests);
 		hdr->nvalid = *findex + 1;
 		hdr->bests[*findex] = cpu_to_be16(NULLDATAOFF);
 	}
-- 
2.20.1

