Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E3DAC5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09431206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h6hpLcPl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfKGSZC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:02 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44100 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfKGSZC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=e8J9xm7lB08m6G43zA/M5eJ7edNdxYUmHxVdKepZu2w=; b=h6hpLcPlFHOXBiIxQ8o1w1Kew4
        XHDbMxfMoQ/UicU6vtYofYyxxgUHxseVBDMlb0x5h9JTGMwAkdIsiltxo6RJZfCmbJMsICpqIqpVo
        NzYCpxTaSLUe0nuYaFr8FCQXPuy+GnJt88RAViZPXvjXEod0iZE+mVQfB5FOydmg0wvofk9VCuwEx
        iuELtl3hMwSF8Dd82gWtOWyIiG4+lxictWIXVRajMTMTXMuZRc2nB67oz96XXnfF7iZlJfkzbjfOz
        ik7nknoWfiGzKpupWDbKJoKpUUzxamx8/RLwqizm9GBKRcKZkokI/yk+Ro3xG546eWTIlqUFcabK6
        AHqoIfXQ==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmSr-00037B-T7; Thu, 07 Nov 2019 18:25:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 18/46] xfs: move the max dir2 free bests count to struct xfs_da_geometry
Date:   Thu,  7 Nov 2019 19:23:42 +0100
Message-Id: <20191107182410.12660-19-hch@lst.de>
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

Move the max free bests count towards our structure for dir/attr
geometry parameters.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.h  |  1 +
 fs/xfs/libxfs/xfs_da_format.c | 29 ++++-------------------------
 fs/xfs/libxfs/xfs_dir2.c      |  2 ++
 fs/xfs/libxfs/xfs_dir2.h      |  1 -
 fs/xfs/libxfs/xfs_dir2_node.c | 12 +++++-------
 5 files changed, 12 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index e8f0b7ac051c..40110acf9f8a 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -30,6 +30,7 @@ struct xfs_da_geometry {
 	unsigned int	leaf_max_ents;	/* # of entries in dir2 leaf */
 	xfs_dablk_t	leafblk;	/* blockno of leaf data v2 */
 	unsigned int	free_hdr_size;	/* dir2 free header size */
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
index eee75ec9707f..77a297e7d91c 100644
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
index c9a52e4e515d..826651f72527 100644
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
@@ -562,8 +561,7 @@ xfs_dir2_free_hdr_check(
 
 	xfs_dir2_free_hdr_from_disk(dp->i_mount, &hdr, bp->b_addr);
 
-	ASSERT((hdr.firstdb %
-		dp->d_ops->free_max_bests(dp->i_mount->m_dir_geo)) == 0);
+	ASSERT((hdr.firstdb % dp->i_mount->m_dir_geo->free_max_bests) == 0);
 	ASSERT(hdr.firstdb <= db);
 	ASSERT(db < hdr.firstdb + hdr.nvalid);
 }
@@ -1340,7 +1338,7 @@ xfs_dir2_leafn_remove(
 		struct xfs_dir3_icfree_hdr freehdr;
 
 		xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, free);
-		ASSERT(freehdr.firstdb == dp->d_ops->free_max_bests(args->geo) *
+		ASSERT(freehdr.firstdb == args->geo->free_max_bests *
 			(fdb - xfs_dir2_byte_to_db(args->geo,
 						   XFS_DIR2_FREE_OFFSET)));
 	}
@@ -1733,7 +1731,7 @@ xfs_dir2_node_add_datablk(
 		/* Remember the first slot as our empty slot. */
 		hdr->firstdb = (fbno - xfs_dir2_byte_to_db(args->geo,
 							XFS_DIR2_FREE_OFFSET)) *
-				dp->d_ops->free_max_bests(args->geo);
+				args->geo->free_max_bests;
 	} else {
 		xfs_dir2_free_hdr_from_disk(mp, hdr, fbp->b_addr);
 	}
@@ -1743,7 +1741,7 @@ xfs_dir2_node_add_datablk(
 
 	/* Extend the freespace table if the new data block is off the end. */
 	if (*findex >= hdr->nvalid) {
-		ASSERT(*findex < dp->d_ops->free_max_bests(args->geo));
+		ASSERT(*findex < args->geo->free_max_bests);
 		hdr->nvalid = *findex + 1;
 		hdr->bests[*findex] = cpu_to_be16(NULLDATAOFF);
 	}
-- 
2.20.1

