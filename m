Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D3A9C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 836CF60C3E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237936AbhHLXcj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 19:32:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237906AbhHLXcj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Aug 2021 19:32:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59C1D6103E;
        Thu, 12 Aug 2021 23:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628811133;
        bh=8jdkjRDAyzg24L+YRMtYVTEUgsToQ6eAiOv95Am0L7s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Wv+d8AocfIYvT8Q9pzV7iY6Z0PY3a54D/2Fjy8x9bvOLuDmY58R+VStPsuoi2jrDE
         Lfu8iE6/bPB69O43/E16YICaSgO47qU2WRJdfGTihfEm4i+N4drwpH/VzZXNVj0fMn
         SFjGBO1Wcx7nOo5pmmUI6hXqNNFFU3DdKpMbzlSYlWwtByIrickRsOJoIiA6t8+6e8
         /cIbdaHqIk17OxdtrloLzsUTww48jAup/ETs5XCMgE1WHX3zVIH69YdAskIXm9UiJQ
         Q8PQYwM13AnWQ3lsAVO5RKhoOa45futGMGW8VrMsWU6bqOY10PQUdOmYAXCpcbGqAJ
         zomNkdT1m+ckQ==
Subject: [PATCH 09/10] xfs: make the start pointer passed to btree
 update_lastrec functions const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 12 Aug 2021 16:32:13 -0700
Message-ID: <162881113307.1695493.9966859891966312704.stgit@magnolia>
In-Reply-To: <162881108307.1695493.3416792932772498160.stgit@magnolia>
References: <162881108307.1695493.3416792932772498160.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This btree function is called when updating a record in the rightmost
block of a btree so that we can update the AGF's longest free extent
length field.  Neither parameter is supposed to be updated, so mark them
both const.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c |   10 +++++-----
 fs/xfs/libxfs/xfs_btree.h       |    8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 0b9303caf41a..26480cafbb38 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -103,11 +103,11 @@ xfs_allocbt_free_block(
  */
 STATIC void
 xfs_allocbt_update_lastrec(
-	struct xfs_btree_cur	*cur,
-	struct xfs_btree_block	*block,
-	union xfs_btree_rec	*rec,
-	int			ptr,
-	int			reason)
+	struct xfs_btree_cur		*cur,
+	const struct xfs_btree_block	*block,
+	const union xfs_btree_rec	*rec,
+	int				ptr,
+	int				reason)
 {
 	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 	struct xfs_perag	*pag;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 8a36012a2e89..830702bdd6d6 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -117,8 +117,8 @@ struct xfs_btree_ops {
 
 	/* update last record information */
 	void	(*update_lastrec)(struct xfs_btree_cur *cur,
-				  struct xfs_btree_block *block,
-				  union xfs_btree_rec *rec,
+				  const struct xfs_btree_block *block,
+				  const union xfs_btree_rec *rec,
 				  int ptr, int reason);
 
 	/* records in block/level */
@@ -423,7 +423,7 @@ void xfs_btree_log_recs(struct xfs_btree_cur *, struct xfs_buf *, int, int);
 /*
  * Helpers.
  */
-static inline int xfs_btree_get_numrecs(struct xfs_btree_block *block)
+static inline int xfs_btree_get_numrecs(const struct xfs_btree_block *block)
 {
 	return be16_to_cpu(block->bb_numrecs);
 }
@@ -434,7 +434,7 @@ static inline void xfs_btree_set_numrecs(struct xfs_btree_block *block,
 	block->bb_numrecs = cpu_to_be16(numrecs);
 }
 
-static inline int xfs_btree_get_level(struct xfs_btree_block *block)
+static inline int xfs_btree_get_level(const struct xfs_btree_block *block)
 {
 	return be16_to_cpu(block->bb_level);
 }

