Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66CC4C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357710AbiATATD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345061AbiATATD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:19:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DC4C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:19:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D07D161514
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA07C004E1;
        Thu, 20 Jan 2022 00:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637942;
        bh=mYGCy3bXaV6eVDRMzyoIpqVsYtrrqk3RBBQjhWfyfXw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=prl7gSlsy97Coo0MaeZOdLZph+wY5n/MRWyD/V6RWFjh5lXGAt8vzd9V4upJNJ4nD
         yJmpRXl/y+1+7LIqIkRrUr2QUvHFQbrUYQH0JZ0CNqhdH9iwKTIGknNmcku5zD7xPA
         9jFq4MtaJlnRn7ry+u+SWujWkCJ4ncSg1q/0g8irIc60ngruAgZXSZDd1d+EtuK5eH
         /kzqVGyZG39XTQUjpM/D0SkncPeGo2birnOGzjeWereVyTwV+mu3aIutkHJ7jFgYzV
         wiI1fzWurmA3FInrS2I/FqmTnid0yskYfr9AlrsePAvIYGRi3t6x45pp6OpEH3Bnuf
         GYMo1jIYeYrDA==
Subject: [PATCH 18/45] xfs: make the start pointer passed to btree
 update_lastrec functions const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:19:01 -0800
Message-ID: <164263794193.860211.13724000490826682569.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 60e265f7f85a3d91c368f9284dc6501fa1f41e50

This btree function is called when updating a record in the rightmost
block of a btree so that we can update the AGF's longest free extent
length field.  Neither parameter is supposed to be updated, so mark them
both const.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc_btree.c |   10 +++++-----
 libxfs/xfs_btree.h       |    8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 33b43c7c..34a514c6 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -101,11 +101,11 @@ xfs_allocbt_free_block(
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
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 8a36012a..830702bd 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
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

