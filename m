Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA28CA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22974217D9
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:09:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Pl0Nx9kp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfKAWJE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:09:04 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53738 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfKAWJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:09:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1h5lvIAm0jufVJUg2YhiYmGT08bM8dhthMqVt0086qQ=; b=Pl0Nx9kpMdbpHisNrCvhXE9uF
        lDpFkB8tMPXoMMqjQ7QDRRDbsqaQ0fIzzkLJNXwMqQaeBq3Zxr6cXziVw/7MdSLJmwtoLevfzokUS
        otIcTmbPFUa76KArS56RiPQ7ZlsJ4/CwNgmK4i2PLJSsZ3er3DwYLc2w8uhC6cP2Lh8jgq7m7hhlD
        oZBU8XqY8hujGj2YsK9OFfawqGLU1eTBI5ue6/VmFXx4cSWlMk75w8/ntyt+lAe2co5/ff5u3HuAI
        ssg1oMHO+4qKgbmW1hpHmKqx305eobzcJOCWYXhrRfwr0m092K5ifZfyG59xMwv09GyWiwfugVzyr
        NS/eODmFg==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf6O-00060S-8H
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:09:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 18/34] xfs: devirtualize ->db_to_fdb and ->db_to_fdindex
Date:   Fri,  1 Nov 2019 15:07:03 -0700
Message-Id: <20191101220719.29100-19-hch@lst.de>
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

Now that the max bests value is in struct xfs_da_geometry both instances
of ->db_to_fdb and ->db_to_fdindex are identical.  Replace them with
local xfs_dir2_db_to_fdb and xfs_dir2_db_to_fdindex functions in
xfs_dir2_node.c.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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
index 0fcd7351038e..ceb5936b58dd 100644
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
@@ -676,7 +695,7 @@ xfs_dir2_leafn_lookup_for_addname(
 			 * Convert the data block to the free block
 			 * holding its freespace information.
 			 */
-			newfdb = dp->d_ops->db_to_fdb(args->geo, newdb);
+			newfdb = xfs_dir2_db_to_fdb(args->geo, newdb);
 			/*
 			 * If it's not the one we have in hand, read it in.
 			 */
@@ -700,7 +719,7 @@ xfs_dir2_leafn_lookup_for_addname(
 			/*
 			 * Get the index for our entry.
 			 */
-			fi = dp->d_ops->db_to_fdindex(args->geo, curdb);
+			fi = xfs_dir2_db_to_fdindex(args->geo, curdb);
 			/*
 			 * If it has room, return it.
 			 */
@@ -1320,7 +1339,7 @@ xfs_dir2_leafn_remove(
 		 * Convert the data block number to a free block,
 		 * read in the free block.
 		 */
-		fdb = dp->d_ops->db_to_fdb(args->geo, db);
+		fdb = xfs_dir2_db_to_fdb(args->geo, db);
 		error = xfs_dir2_free_read(tp, dp,
 					   xfs_dir2_db_to_da(args->geo, fdb),
 					   &fbp);
@@ -1340,7 +1359,7 @@ xfs_dir2_leafn_remove(
 		/*
 		 * Calculate which entry we need to fix.
 		 */
-		findex = dp->d_ops->db_to_fdindex(args->geo, db);
+		findex = xfs_dir2_db_to_fdindex(args->geo, db);
 		longest = be16_to_cpu(bf[0].length);
 		/*
 		 * If the data block is now empty we can get rid of it
@@ -1683,7 +1702,7 @@ xfs_dir2_node_add_datablk(
 	 * Get the freespace block corresponding to the data block
 	 * that was just allocated.
 	 */
-	fbno = dp->d_ops->db_to_fdb(args->geo, *dbno);
+	fbno = xfs_dir2_db_to_fdb(args->geo, *dbno);
 	error = xfs_dir2_free_try_read(tp, dp,
 			       xfs_dir2_db_to_da(args->geo, fbno), &fbp);
 	if (error)
@@ -1698,11 +1717,11 @@ xfs_dir2_node_add_datablk(
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
@@ -1731,7 +1750,7 @@ xfs_dir2_node_add_datablk(
 	}
 
 	/* Set the freespace block index from the data block number. */
-	*findex = dp->d_ops->db_to_fdindex(args->geo, *dbno);
+	*findex = xfs_dir2_db_to_fdindex(args->geo, *dbno);
 
 	/* Extend the freespace table if the new data block is off the end. */
 	if (*findex >= hdr->nvalid) {
-- 
2.20.1

