Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC39C38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC7D42083B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Wpa4yab/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgEGMUP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726618AbgEGMUP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101ADC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=14iiSxhYrKjck6GSN931H1JSAsg4pb5SPvPS/lgg2CI=; b=Wpa4yab/wfyDpUBCStkPG7J3jh
        gWuyyvIaWs3LRhFsuGSRDEd9pyT+lCBzPq0VRM7sA6t85auUT6j06F23QK4OD2Iyy+C6Uqx8qQ8vB
        rjzhaXa7VU95bDHMuXrHCpdqCf0/8gEItoGj0H9lHQIdxiiQD9n3nDSJC4+o2FpKFgjtVddvJoSRl
        7jjOMnZVbrFQ/8Vv6VnlolbEzkbG/TTPul7C6rEer09M1ojmFeMGdeJxkUC1Z0z/3qT6QcLTgm67U
        /+nySf1Dg3yhlA4HlWwuR+I36yeugYnUOfNeFLN0w1AioqKVj2PgBThY6xjZVrCK1RuAsg9d7NInu
        zZDjLLpw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfVe-0007dg-HZ; Thu, 07 May 2020 12:20:14 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 33/58] xfs: add a function to deal with corrupt buffers post-verifiers
Date:   Thu,  7 May 2020 14:18:26 +0200
Message-Id: <20200507121851.304002-34-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Source kernel commit: 8d57c21600a514d7a9237327c2496ae159bab5bb

Add a helper function to get rid of buffers that we have decided are
corrupt after the verifiers have run.  This function is intended to
handle metadata checks that can't happen in the verifiers, such as
inter-block relationship checking.  Note that we now mark the buffer
stale so that it will not end up on any LRU and will be purged on
release.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_priv.h   |  3 +++
 libxfs/util.c          | 22 ++++++++++++++++++++++
 libxfs/xfs_alloc.c     |  2 +-
 libxfs/xfs_attr_leaf.c |  6 +++---
 libxfs/xfs_btree.c     |  2 +-
 libxfs/xfs_da_btree.c  | 10 +++++-----
 libxfs/xfs_dir2_leaf.c |  2 +-
 libxfs/xfs_dir2_node.c |  6 +++---
 8 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 68b6c0f0..8dc12e1e 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -528,6 +528,9 @@ void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
 void
 xfs_buf_corruption_error(struct xfs_buf *bp);
 
+void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
+#define xfs_buf_mark_corrupt(bp) __xfs_buf_mark_corrupt((bp), __this_address)
+
 /* XXX: this is clearly a bug - a shared header needs to export this */
 /* xfs_rtalloc.c */
 int libxfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
diff --git a/libxfs/util.c b/libxfs/util.c
index d3cbc038..88ed67f7 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -650,6 +650,28 @@ xfs_buf_corruption_error(
 		  __return_address, bp->b_ops->name, bp->b_bn);
 }
 
+/*
+ * Log a message about and stale a buffer that a caller has decided is corrupt.
+ *
+ * This function should be called for the kinds of metadata corruption that
+ * cannot be detect from a verifier, such as incorrect inter-block relationship
+ * data.  Do /not/ call this function from a verifier function.
+ *
+ * The buffer must be XBF_DONE prior to the call.  Afterwards, the buffer will
+ * be marked stale, but b_error will not be set.  The caller is responsible for
+ * releasing the buffer or fixing it.
+ */
+void
+__xfs_buf_mark_corrupt(
+	struct xfs_buf		*bp,
+	xfs_failaddr_t		fa)
+{
+	ASSERT(bp->b_flags & XBF_DONE);
+
+	xfs_buf_corruption_error(bp);
+	xfs_buf_stale(bp);
+}
+
 /*
  * This is called from I/O verifiers on v5 superblock filesystems. In the
  * kernel, it validates the metadata LSN parameter against the current LSN of
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index b3abab49..fdd92da3 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -718,7 +718,7 @@ xfs_alloc_update_counters(
 	xfs_trans_agblocks_delta(tp, len);
 	if (unlikely(be32_to_cpu(agf->agf_freeblks) >
 		     be32_to_cpu(agf->agf_length))) {
-		xfs_buf_corruption_error(agbp);
+		xfs_buf_mark_corrupt(agbp);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index edd01eef..832979c9 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -2336,7 +2336,7 @@ xfs_attr3_leaf_lookup_int(
 	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 	entries = xfs_attr3_leaf_entryp(leaf);
 	if (ichdr.count >= args->geo->blksize / 8) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 
@@ -2355,11 +2355,11 @@ xfs_attr3_leaf_lookup_int(
 			break;
 	}
 	if (!(probe >= 0 && (!ichdr.count || probe < ichdr.count))) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 	if (!(span <= 4 || be32_to_cpu(entry->hashval) == hashval)) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 57862dfa..51be86e4 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1759,7 +1759,7 @@ xfs_btree_lookup_get_block(
 
 out_bad:
 	*blkp = NULL;
-	xfs_buf_corruption_error(bp);
+	xfs_buf_mark_corrupt(bp);
 	xfs_trans_brelse(cur->bc_tp, bp);
 	return -EFSCORRUPTED;
 }
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 7f26d124..d785312f 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -587,7 +587,7 @@ xfs_da3_split(
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.forw) {
 		if (be32_to_cpu(node->hdr.info.forw) != addblk->blkno) {
-			xfs_buf_corruption_error(oldblk->bp);
+			xfs_buf_mark_corrupt(oldblk->bp);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -600,7 +600,7 @@ xfs_da3_split(
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.back) {
 		if (be32_to_cpu(node->hdr.info.back) != addblk->blkno) {
-			xfs_buf_corruption_error(oldblk->bp);
+			xfs_buf_mark_corrupt(oldblk->bp);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -1621,7 +1621,7 @@ xfs_da3_node_lookup_int(
 		}
 
 		if (magic != XFS_DA_NODE_MAGIC && magic != XFS_DA3_NODE_MAGIC) {
-			xfs_buf_corruption_error(blk->bp);
+			xfs_buf_mark_corrupt(blk->bp);
 			return -EFSCORRUPTED;
 		}
 
@@ -1636,7 +1636,7 @@ xfs_da3_node_lookup_int(
 
 		/* Tree taller than we can handle; bail out! */
 		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH) {
-			xfs_buf_corruption_error(blk->bp);
+			xfs_buf_mark_corrupt(blk->bp);
 			return -EFSCORRUPTED;
 		}
 
@@ -1644,7 +1644,7 @@ xfs_da3_node_lookup_int(
 		if (blkno == args->geo->leafblk)
 			expected_level = nodehdr.level - 1;
 		else if (expected_level != nodehdr.level) {
-			xfs_buf_corruption_error(blk->bp);
+			xfs_buf_mark_corrupt(blk->bp);
 			return -EFSCORRUPTED;
 		} else
 			expected_level--;
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index d73e54eb..0cecd698 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -1381,7 +1381,7 @@ xfs_dir2_leaf_removename(
 	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	if (be16_to_cpu(bestsp[db]) != oldbest) {
-		xfs_buf_corruption_error(lbp);
+		xfs_buf_mark_corrupt(lbp);
 		return -EFSCORRUPTED;
 	}
 	/*
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index ffa136b9..3dd999c3 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -436,7 +436,7 @@ xfs_dir2_leaf_to_node(
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	if (be32_to_cpu(ltp->bestcount) >
 				(uint)dp->i_d.di_size / args->geo->blksize) {
-		xfs_buf_corruption_error(lbp);
+		xfs_buf_mark_corrupt(lbp);
 		return -EFSCORRUPTED;
 	}
 
@@ -510,7 +510,7 @@ xfs_dir2_leafn_add(
 	 * into other peoples memory
 	 */
 	if (index < 0) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 
@@ -797,7 +797,7 @@ xfs_dir2_leafn_lookup_for_entry(
 
 	xfs_dir3_leaf_check(dp, bp);
 	if (leafhdr.count <= 0) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 
-- 
2.26.2

