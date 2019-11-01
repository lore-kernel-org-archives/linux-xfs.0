Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E17DCA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:08:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F274B2085B
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:08:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RQLNJZ6D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfKAWI1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:08:27 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53692 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAWI1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:08:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nQDA43wKKd7225KoqOUi9Et1Mpv56oBvmz3QOE7ds1I=; b=RQLNJZ6DvX1SM1Rtnwnl8v4OT
        NclpWyy1PxCZxyukGdVrFyqeQX8eYaAw1lOY+eVZCF30VtB3k8A+Xs/AdtIT8JUYo7fSnqO6yWJWh
        AfcuCnPGS0/XAk2j2su+2R7pXctckzqENfCWpMFldnJBrXbMIqOXeUqFuVZrLOqH5BYd3I24msXnw
        lYenGP5ORZCIt/xDkUMVHhEbTOu/JeVTsJZKqZNhj1Evs5ShkiHXrMz6ZZhw7KEHD16vlpxQUmuU/
        B5ghJ9P4p9+6WvPB12kG4GwE3poJXBv9+RPQlh6i97XMlXAAaO2cJv5L44FwfRfV2CC5bC9ZdgqyG
        RQOvrxUxA==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf5n-0005wB-7u
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:08:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/34] xfs: move the max dir2 leaf entries count to struct xfs_da_geometry
Date:   Fri,  1 Nov 2019 15:06:56 -0700
Message-Id: <20191101220719.29100-12-hch@lst.de>
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

Move the max leaf entries count towards our structure for dir/attr
geometry parameters.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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
index 5e3e954fee77..c8b137685ca7 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -27,6 +27,7 @@ struct xfs_da_geometry {
 	int		magicpct;	/* 37% of block size in bytes */
 	xfs_dablk_t	datablk;	/* blockno of dir data v2 */
 	int		leaf_hdr_size;	/* dir2 leaf header size */
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
index 94badb28fd1a..9f88b9885747 100644
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
index f72fd8182223..38d42fe1aa02 100644
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
index 76f31909376e..3b9ed6ac72b6 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -455,7 +455,7 @@ xfs_dir2_leafn_add(
 	 * a compact.
 	 */
 
-	if (leafhdr.count == dp->d_ops->leaf_max_ents(args->geo)) {
+	if (leafhdr.count == args->geo->leaf_max_ents) {
 		if (!leafhdr.stale)
 			return -ENOSPC;
 		compact = leafhdr.stale > 1;
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 27fdf8978467..e4e189d3c1c0 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -487,7 +487,6 @@ xchk_directory_leaf1_bestfree(
 	struct xfs_dir2_leaf		*leaf;
 	struct xfs_buf			*dbp;
 	struct xfs_buf			*bp;
-	const struct xfs_dir_ops	*d_ops = sc->ip->d_ops;
 	struct xfs_da_geometry		*geo = sc->mp->m_dir_geo;
 	__be16				*bestp;
 	__u16				best;
@@ -527,7 +526,7 @@ xchk_directory_leaf1_bestfree(
 	}
 
 	/* Is the leaf count even remotely sane? */
-	if (leafhdr.count > d_ops->leaf_max_ents(geo)) {
+	if (leafhdr.count > geo->leaf_max_ents) {
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 		goto out;
 	}
-- 
2.20.1

