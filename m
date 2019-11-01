Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A0CFCA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DB2B2085B
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:07:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NdJqgN9Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfKAWHk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:07:40 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53618 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAWHj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:07:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9ucYOVpX8gQ9ynW99vZAS1lsNf3FSSBq9pDPZadFYPg=; b=NdJqgN9Zkf/egPSXap/Z2Z+Pv
        cbydV52DhPrnZs4MObJmll8XnGSR7i1Yp12EOOXqhSD5tfdqMvLjlxD/yrlAViwLen0Vv+t+u0gdq
        f+Ln8bG6GKvgk10YxXUMllT3wf/rpSzfverMDzLov58YGjJ/+VNJlCW8ZeUjnzcmQkSbquVWGZFWv
        AjLr2lb4cHlteJteY05A48NdtyjuHP4Qp/7j0PvNf8tSQ0rd7xWgWMhPZT4IdujI/mmgKw8H6WiAu
        UoSOl7xvwQ0PoqEB0Y30JNMcU/s/AaYMHCPu1hBY7q/xolwFlfisECqKz+cBQCodHnhzeoGHxUHze
        qnuwjqmsA==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf51-0005rW-Ml
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:07:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/34] xfs: refactor btree node scrubbing
Date:   Fri,  1 Nov 2019 15:06:47 -0700
Message-Id: <20191101220719.29100-3-hch@lst.de>
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

Break up xchk_da_btree_entry and handle looking up leaf node entries
in the attr / dir callbacks, so that only the generic node handling
is left in the common core code.  Note that the checks for the crc
enabled blocks are removed, as the scrubbing code already remaps the
magic numbers earlier.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/attr.c    | 12 ++++++-----
 fs/xfs/scrub/dabtree.c | 48 ++++++++++--------------------------------
 fs/xfs/scrub/dabtree.h |  3 +--
 fs/xfs/scrub/dir.c     | 12 ++++++++---
 4 files changed, 28 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 0edc7f8eb96e..035d5734e0af 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -398,15 +398,14 @@ xchk_xattr_block(
 STATIC int
 xchk_xattr_rec(
 	struct xchk_da_btree		*ds,
-	int				level,
-	void				*rec)
+	int				level)
 {
 	struct xfs_mount		*mp = ds->state->mp;
-	struct xfs_attr_leaf_entry	*ent = rec;
-	struct xfs_da_state_blk		*blk;
+	struct xfs_da_state_blk		*blk = &ds->state->path.blk[level];
 	struct xfs_attr_leaf_name_local	*lentry;
 	struct xfs_attr_leaf_name_remote	*rentry;
 	struct xfs_buf			*bp;
+	struct xfs_attr_leaf_entry	*ent;
 	xfs_dahash_t			calc_hash;
 	xfs_dahash_t			hash;
 	int				nameidx;
@@ -414,7 +413,10 @@ xchk_xattr_rec(
 	unsigned int			badflags;
 	int				error;
 
-	blk = &ds->state->path.blk[level];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+
+	ent = (void *)xfs_attr3_leaf_entryp(blk->bp->b_addr) +
+		(blk->index * sizeof(struct xfs_attr_leaf_entry));
 
 	/* Check the whole block, if necessary. */
 	error = xchk_xattr_block(ds, level);
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 77ff9f97bcda..d1248c223c7f 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -77,40 +77,17 @@ xchk_da_set_corrupt(
 			__return_address);
 }
 
-/* Find an entry at a certain level in a da btree. */
-STATIC void *
-xchk_da_btree_entry(
-	struct xchk_da_btree	*ds,
-	int			level,
-	int			rec)
+static struct xfs_da_node_entry *
+xchk_da_btree_node_entry(
+	struct xchk_da_btree		*ds,
+	int				level)
 {
-	char			*ents;
-	struct xfs_da_state_blk	*blk;
-	void			*baddr;
+	struct xfs_da_state_blk		*blk = &ds->state->path.blk[level];
 
-	/* Dispatch the entry finding function. */
-	blk = &ds->state->path.blk[level];
-	baddr = blk->bp->b_addr;
-	switch (blk->magic) {
-	case XFS_ATTR_LEAF_MAGIC:
-	case XFS_ATTR3_LEAF_MAGIC:
-		ents = (char *)xfs_attr3_leaf_entryp(baddr);
-		return ents + (rec * sizeof(struct xfs_attr_leaf_entry));
-	case XFS_DIR2_LEAFN_MAGIC:
-	case XFS_DIR3_LEAFN_MAGIC:
-		ents = (char *)ds->dargs.dp->d_ops->leaf_ents_p(baddr);
-		return ents + (rec * sizeof(struct xfs_dir2_leaf_entry));
-	case XFS_DIR2_LEAF1_MAGIC:
-	case XFS_DIR3_LEAF1_MAGIC:
-		ents = (char *)ds->dargs.dp->d_ops->leaf_ents_p(baddr);
-		return ents + (rec * sizeof(struct xfs_dir2_leaf_entry));
-	case XFS_DA_NODE_MAGIC:
-	case XFS_DA3_NODE_MAGIC:
-		ents = (char *)ds->dargs.dp->d_ops->node_tree_p(baddr);
-		return ents + (rec * sizeof(struct xfs_da_node_entry));
-	}
+	ASSERT(blk->magic == XFS_DA_NODE_MAGIC);
 
-	return NULL;
+	return (void *)ds->dargs.dp->d_ops->node_tree_p(blk->bp->b_addr) +
+		(blk->index * sizeof(struct xfs_da_node_entry));
 }
 
 /* Scrub a da btree hash (key). */
@@ -136,7 +113,7 @@ xchk_da_btree_hash(
 
 	/* Is this hash no larger than the parent hash? */
 	blks = ds->state->path.blk;
-	entry = xchk_da_btree_entry(ds, level - 1, blks[level - 1].index);
+	entry = xchk_da_btree_node_entry(ds, level - 1);
 	parent_hash = be32_to_cpu(entry->hashval);
 	if (parent_hash < hash)
 		xchk_da_set_corrupt(ds, level);
@@ -479,7 +456,6 @@ xchk_da_btree(
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_da_state_blk		*blks;
 	struct xfs_da_node_entry	*key;
-	void				*rec;
 	xfs_dablk_t			blkno;
 	int				level;
 	int				error;
@@ -538,9 +514,7 @@ xchk_da_btree(
 			}
 
 			/* Dispatch record scrubbing. */
-			rec = xchk_da_btree_entry(&ds, level,
-					blks[level].index);
-			error = scrub_fn(&ds, level, rec);
+			error = scrub_fn(&ds, level);
 			if (error)
 				break;
 			if (xchk_should_terminate(sc, &error) ||
@@ -562,7 +536,7 @@ xchk_da_btree(
 		}
 
 		/* Hashes in order for scrub? */
-		key = xchk_da_btree_entry(&ds, level, blks[level].index);
+		key = xchk_da_btree_node_entry(&ds, level);
 		error = xchk_da_btree_hash(&ds, level, &key->hashval);
 		if (error)
 			goto out;
diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
index cb3f0003245b..1f3515c6d5a8 100644
--- a/fs/xfs/scrub/dabtree.h
+++ b/fs/xfs/scrub/dabtree.h
@@ -28,8 +28,7 @@ struct xchk_da_btree {
 	int			tree_level;
 };
 
-typedef int (*xchk_da_btree_rec_fn)(struct xchk_da_btree *ds,
-		int level, void *rec);
+typedef int (*xchk_da_btree_rec_fn)(struct xchk_da_btree *ds, int level);
 
 /* Check for da btree operation errors. */
 bool xchk_da_process_error(struct xchk_da_btree *ds, int level, int *error);
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 1e2e11721eb9..97f274f7cd38 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -179,14 +179,14 @@ xchk_dir_actor(
 STATIC int
 xchk_dir_rec(
 	struct xchk_da_btree		*ds,
-	int				level,
-	void				*rec)
+	int				level)
 {
+	struct xfs_da_state_blk		*blk = &ds->state->path.blk[level];
 	struct xfs_mount		*mp = ds->state->mp;
-	struct xfs_dir2_leaf_entry	*ent = rec;
 	struct xfs_inode		*dp = ds->dargs.dp;
 	struct xfs_dir2_data_entry	*dent;
 	struct xfs_buf			*bp;
+	struct xfs_dir2_leaf_entry	*ent;
 	char				*p, *endp;
 	xfs_ino_t			ino;
 	xfs_dablk_t			rec_bno;
@@ -198,6 +198,12 @@ xchk_dir_rec(
 	unsigned int			tag;
 	int				error;
 
+	ASSERT(blk->magic == XFS_DIR2_LEAF1_MAGIC ||
+	       blk->magic == XFS_DIR2_LEAFN_MAGIC);
+
+	ent = (void *)ds->dargs.dp->d_ops->leaf_ents_p(blk->bp->b_addr) +
+		(blk->index * sizeof(struct xfs_dir2_leaf_entry));
+
 	/* Check the hash of the entry. */
 	error = xchk_da_btree_hash(ds, level, &ent->hashval);
 	if (error)
-- 
2.20.1

