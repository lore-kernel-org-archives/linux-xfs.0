Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C69CFC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A06AD206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QtYgxp8j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfKGSZF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:05 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44112 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfKGSZF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qac/8JujoF6eeD+hqoXVU1xlMRbtR7sEJ7SPdPNBpxU=; b=QtYgxp8jfE2Ln5CY9jcKang583
        ttQG6VHVL1fN6+eaGmyk9RtZq/4BdKkLWtnCXt9SsDZqLz8pRkXh7Z9mapK6zYatICyB89keQn6tm
        MW5z/w9wnWu+i89Pqf70sMp5WHLAaWSvJKDDEgXxAojxBT6bfZFoqqVMUnT5bZGmdvWno2FpsKBop
        61gM3TzhhpwV6jpzGI5dJ+F0HqPYPK+o8gQspAv6eRpIdHQsxQzmBeqhX1XEgDWzH+sLg/2eW3OIr
        CcRdCc+b0y9A/B5Wduud70gIMxq09518EtJdxZ5BLMzxpRtFNVjxs6Atst5yYlG2JUJe299JqTNSL
        bQXFz6Bw==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmSu-0003DF-Dd; Thu, 07 Nov 2019 18:25:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 19/46] xfs: devirtualize ->db_to_fdb and ->db_to_fdindex
Date:   Thu,  7 Nov 2019 19:23:43 +0100
Message-Id: <20191107182410.12660-20-hch@lst.de>
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

Now that the max bests value is in struct xfs_da_geometry both instances
of ->db_to_fdb and ->db_to_fdindex are identical.  Replace them with
local xfs_dir2_db_to_fdb and xfs_dir2_db_to_fdindex functions in
xfs_dir2_node.c.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_format.c | 47 -----------------------------------
 fs/xfs/libxfs/xfs_dir2.h      |  5 ----
 fs/xfs/libxfs/xfs_dir2_node.c | 35 ++++++++++++++++++++------
 3 files changed, 27 insertions(+), 60 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index d2d3144c1598..2b708b9fae1a 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -400,44 +400,6 @@ xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
 		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
 }
 
-/*
- * Convert data space db to the corresponding free db.
- */
-static xfs_dir2_db_t
-xfs_dir2_db_to_fdb(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
-{
-	return xfs_dir2_byte_to_db(geo, XFS_DIR2_FREE_OFFSET) +
-			(db / geo->free_max_bests);
-}
-
-/*
- * Convert data space db to the corresponding index in a free db.
- */
-static int
-xfs_dir2_db_to_fdindex(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
-{
-	return db % geo->free_max_bests;
-}
-
-/*
- * Convert data space db to the corresponding free db.
- */
-static xfs_dir2_db_t
-xfs_dir3_db_to_fdb(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
-{
-	return xfs_dir2_byte_to_db(geo, XFS_DIR2_FREE_OFFSET) +
-			(db / geo->free_max_bests);
-}
-
-/*
- * Convert data space db to the corresponding index in a free db.
- */
-static int
-xfs_dir3_db_to_fdindex(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
-{
-	return db % geo->free_max_bests;
-}
-
 static const struct xfs_dir_ops xfs_dir2_ops = {
 	.sf_entsize = xfs_dir2_sf_entsize,
 	.sf_nextentry = xfs_dir2_sf_nextentry,
@@ -467,9 +429,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_first_entry_p = xfs_dir2_data_first_entry_p,
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
-
-	.db_to_fdb = xfs_dir2_db_to_fdb,
-	.db_to_fdindex = xfs_dir2_db_to_fdindex,
 };
 
 static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
@@ -501,9 +460,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.data_first_entry_p = xfs_dir2_ftype_data_first_entry_p,
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
-
-	.db_to_fdb = xfs_dir2_db_to_fdb,
-	.db_to_fdindex = xfs_dir2_db_to_fdindex,
 };
 
 static const struct xfs_dir_ops xfs_dir3_ops = {
@@ -535,9 +491,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 	.data_first_entry_p = xfs_dir3_data_first_entry_p,
 	.data_entry_p = xfs_dir3_data_entry_p,
 	.data_unused_p = xfs_dir3_data_unused_p,
-
-	.db_to_fdb = xfs_dir3_db_to_fdb,
-	.db_to_fdindex = xfs_dir3_db_to_fdindex,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index e3c1385d1522..e302679d8c80 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -71,11 +71,6 @@ struct xfs_dir_ops {
 		(*data_entry_p)(struct xfs_dir2_data_hdr *hdr);
 	struct xfs_dir2_data_unused *
 		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
-
-	xfs_dir2_db_t (*db_to_fdb)(struct xfs_da_geometry *geo,
-				   xfs_dir2_db_t db);
-	int	(*db_to_fdindex)(struct xfs_da_geometry *geo,
-				 xfs_dir2_db_t db);
 };
 
 extern const struct xfs_dir_ops *
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 826651f72527..7b0de42c2c77 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -33,6 +33,25 @@ static int xfs_dir2_leafn_remove(xfs_da_args_t *args, struct xfs_buf *bp,
 				 int index, xfs_da_state_blk_t *dblk,
 				 int *rval);
 
+/*
+ * Convert data space db to the corresponding free db.
+ */
+static xfs_dir2_db_t
+xfs_dir2_db_to_fdb(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
+{
+	return xfs_dir2_byte_to_db(geo, XFS_DIR2_FREE_OFFSET) +
+			(db / geo->free_max_bests);
+}
+
+/*
+ * Convert data space db to the corresponding index in a free db.
+ */
+static int
+xfs_dir2_db_to_fdindex(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
+{
+	return db % geo->free_max_bests;
+}
+
 /*
  * Check internal consistency of a leafn block.
  */
@@ -680,7 +699,7 @@ xfs_dir2_leafn_lookup_for_addname(
 			 * Convert the data block to the free block
 			 * holding its freespace information.
 			 */
-			newfdb = dp->d_ops->db_to_fdb(args->geo, newdb);
+			newfdb = xfs_dir2_db_to_fdb(args->geo, newdb);
 			/*
 			 * If it's not the one we have in hand, read it in.
 			 */
@@ -704,7 +723,7 @@ xfs_dir2_leafn_lookup_for_addname(
 			/*
 			 * Get the index for our entry.
 			 */
-			fi = dp->d_ops->db_to_fdindex(args->geo, curdb);
+			fi = xfs_dir2_db_to_fdindex(args->geo, curdb);
 			/*
 			 * If it has room, return it.
 			 */
@@ -1326,7 +1345,7 @@ xfs_dir2_leafn_remove(
 		 * Convert the data block number to a free block,
 		 * read in the free block.
 		 */
-		fdb = dp->d_ops->db_to_fdb(args->geo, db);
+		fdb = xfs_dir2_db_to_fdb(args->geo, db);
 		error = xfs_dir2_free_read(tp, dp,
 					   xfs_dir2_db_to_da(args->geo, fdb),
 					   &fbp);
@@ -1346,7 +1365,7 @@ xfs_dir2_leafn_remove(
 		/*
 		 * Calculate which entry we need to fix.
 		 */
-		findex = dp->d_ops->db_to_fdindex(args->geo, db);
+		findex = xfs_dir2_db_to_fdindex(args->geo, db);
 		longest = be16_to_cpu(bf[0].length);
 		/*
 		 * If the data block is now empty we can get rid of it
@@ -1689,7 +1708,7 @@ xfs_dir2_node_add_datablk(
 	 * Get the freespace block corresponding to the data block
 	 * that was just allocated.
 	 */
-	fbno = dp->d_ops->db_to_fdb(args->geo, *dbno);
+	fbno = xfs_dir2_db_to_fdb(args->geo, *dbno);
 	error = xfs_dir2_free_try_read(tp, dp,
 			       xfs_dir2_db_to_da(args->geo, fbno), &fbp);
 	if (error)
@@ -1704,11 +1723,11 @@ xfs_dir2_node_add_datablk(
 		if (error)
 			return error;
 
-		if (dp->d_ops->db_to_fdb(args->geo, *dbno) != fbno) {
+		if (xfs_dir2_db_to_fdb(args->geo, *dbno) != fbno) {
 			xfs_alert(mp,
 "%s: dir ino %llu needed freesp block %lld for data block %lld, got %lld",
 				__func__, (unsigned long long)dp->i_ino,
-				(long long)dp->d_ops->db_to_fdb(args->geo, *dbno),
+				(long long)xfs_dir2_db_to_fdb(args->geo, *dbno),
 				(long long)*dbno, (long long)fbno);
 			if (fblk) {
 				xfs_alert(mp,
@@ -1737,7 +1756,7 @@ xfs_dir2_node_add_datablk(
 	}
 
 	/* Set the freespace block index from the data block number. */
-	*findex = dp->d_ops->db_to_fdindex(args->geo, *dbno);
+	*findex = xfs_dir2_db_to_fdindex(args->geo, *dbno);
 
 	/* Extend the freespace table if the new data block is off the end. */
 	if (*findex >= hdr->nvalid) {
-- 
2.20.1

