Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBBD5C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C71E1206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:24:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W6apxZ4b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbfKGSYr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:24:47 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44032 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbfKGSYr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:24:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=S5tJi7OOP1PpeBM7X+BM3s8mQYwyuU4xNKGmK2wLQvI=; b=W6apxZ4baHKTRWGwCDFwqCf6nL
        4Q9nlI9oJ14kkSbkvJMhmSZGEYHZ6Yqr2YVW6whl7mKBRV/7wOnNA+QR1O1/l6fc67kQeDqEgZjhc
        42ttQL4wT5m7KxF3np+L0WJ2p2HjhOkTFy7i/hPNtdWFO3hWtCRzK/rBzQFW6jZnfOlBuJBVwzO9H
        LpMf/dRAw3gp1vCnpZjLghzEM9K0lmyWYo7gYifCF/pe1o0enfz1bNCp3dvQohMgqm9VB72dTbnSH
        cEDEvR3nm1HgwTsJaPbdnxOOvekIPwj08dMg0M59tdm6OpYhu/2mdDVw1n9+awhrryd4C1bE0ho/S
        +IQ+Du5Q==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmSc-00034E-KO; Thu, 07 Nov 2019 18:24:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 12/46] xfs: move the max dir2 leaf entries count to struct xfs_da_geometry
Date:   Thu,  7 Nov 2019 19:23:36 +0100
Message-Id: <20191107182410.12660-13-hch@lst.de>
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

Move the max leaf entries count towards our structure for dir/attr
geometry parameters.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.h  |  1 +
 fs/xfs/libxfs/xfs_da_format.c | 23 -----------------------
 fs/xfs/libxfs/xfs_dir2.c      |  2 ++
 fs/xfs/libxfs/xfs_dir2.h      |  2 --
 fs/xfs/libxfs/xfs_dir2_leaf.c |  2 +-
 fs/xfs/libxfs/xfs_dir2_node.c |  2 +-
 fs/xfs/scrub/dir.c            |  3 +--
 7 files changed, 6 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index b262ec403bba..c6ff5329e92b 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -27,6 +27,7 @@ struct xfs_da_geometry {
 	unsigned int	magicpct;	/* 37% of block size in bytes */
 	xfs_dablk_t	datablk;	/* blockno of dir data v2 */
 	unsigned int	leaf_hdr_size;	/* dir2 leaf header size */
+	unsigned int	leaf_max_ents;	/* # of entries in dir2 leaf */
 	xfs_dablk_t	leafblk;	/* blockno of leaf data v2 */
 	xfs_dablk_t	freeblk;	/* blockno of free data v2 */
 };
diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index a3e87f4788e0..fe9e20698719 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -401,23 +401,6 @@ xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
 }
 
 
-/*
- * Directory Leaf block operations
- */
-static int
-xfs_dir2_max_leaf_ents(struct xfs_da_geometry *geo)
-{
-	return (geo->blksize - sizeof(struct xfs_dir2_leaf_hdr)) /
-		(uint)sizeof(struct xfs_dir2_leaf_entry);
-}
-
-static int
-xfs_dir3_max_leaf_ents(struct xfs_da_geometry *geo)
-{
-	return (geo->blksize - sizeof(struct xfs_dir3_leaf_hdr)) /
-		(uint)sizeof(struct xfs_dir2_leaf_entry);
-}
-
 /*
  * Directory free space block operations
  */
@@ -570,8 +553,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
 
-	.leaf_max_ents = xfs_dir2_max_leaf_ents,
-
 	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
 	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
 	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,
@@ -611,8 +592,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
 
-	.leaf_max_ents = xfs_dir2_max_leaf_ents,
-
 	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
 	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
 	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,
@@ -652,8 +631,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 	.data_entry_p = xfs_dir3_data_entry_p,
 	.data_unused_p = xfs_dir3_data_unused_p,
 
-	.leaf_max_ents = xfs_dir3_max_leaf_ents,
-
 	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
 	.free_hdr_to_disk = xfs_dir3_free_hdr_to_disk,
 	.free_hdr_from_disk = xfs_dir3_free_hdr_from_disk,
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 6e7a4e9ced5e..8093afb389a1 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -129,6 +129,8 @@ xfs_da_mount(
 		dageo->node_hdr_size = sizeof(struct xfs_da_node_hdr);
 		dageo->leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr);
 	}
+	dageo->leaf_max_ents = (dageo->blksize - dageo->leaf_hdr_size) /
+			sizeof(struct xfs_dir2_leaf_entry);
 
 	/*
 	 * Now we've set up the block conversion variables, we can calculate the
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 544adee5dd12..ee18fc56a6a1 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -72,8 +72,6 @@ struct xfs_dir_ops {
 	struct xfs_dir2_data_unused *
 		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
 
-	int	(*leaf_max_ents)(struct xfs_da_geometry *geo);
-
 	int	free_hdr_size;
 	void	(*free_hdr_to_disk)(struct xfs_dir2_free *to,
 				    struct xfs_dir3_icfree_hdr *from);
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 888d4b0acab8..7e4e77f2f5b5 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -167,7 +167,7 @@ xfs_dir3_leaf_check_int(
 	 * Should factor in the size of the bests table as well.
 	 * We can deduce a value for that from di_size.
 	 */
-	if (hdr->count > ops->leaf_max_ents(geo))
+	if (hdr->count > geo->leaf_max_ents)
 		return __this_address;
 
 	/* Leaves and bests don't overlap in leaf format. */
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index f7ba4d22165c..2c44248b7b4a 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -459,7 +459,7 @@ xfs_dir2_leafn_add(
 	 * a compact.
 	 */
 
-	if (leafhdr.count == dp->d_ops->leaf_max_ents(args->geo)) {
+	if (leafhdr.count == args->geo->leaf_max_ents) {
 		if (!leafhdr.stale)
 			return -ENOSPC;
 		compact = leafhdr.stale > 1;
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 6754e1477661..5ca9b5bde60a 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -486,7 +486,6 @@ xchk_directory_leaf1_bestfree(
 	struct xfs_dir2_leaf		*leaf;
 	struct xfs_buf			*dbp;
 	struct xfs_buf			*bp;
-	const struct xfs_dir_ops	*d_ops = sc->ip->d_ops;
 	struct xfs_da_geometry		*geo = sc->mp->m_dir_geo;
 	__be16				*bestp;
 	__u16				best;
@@ -526,7 +525,7 @@ xchk_directory_leaf1_bestfree(
 	}
 
 	/* Is the leaf count even remotely sane? */
-	if (leafhdr.count > d_ops->leaf_max_ents(geo)) {
+	if (leafhdr.count > geo->leaf_max_ents) {
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 		goto out;
 	}
-- 
2.20.1

