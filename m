Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E2CC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CB1560C51
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237777AbhINCmv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:42:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237737AbhINCmu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:42:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25976606A5;
        Tue, 14 Sep 2021 02:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587293;
        bh=mYGCy3bXaV6eVDRMzyoIpqVsYtrrqk3RBBQjhWfyfXw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=p6Wysehfm7DNozy+xKiPjsBdxdlMKzK4tG/eFChdKGN5gfEqpGfWQeHX83pqpFRFP
         SZizViB91y1iCySBhNsreD5sIztwQ6ha46qMt8j7S5BChLROQoGd2H5s83AsQdbFrO
         hdY+8mG7u/kenFjQWMrLCnnvOu2Sd1ZzDQ9yu9QHsgtOwelZq3BHhFRg2GOFGEhbME
         MQOIxA10o1APJ8hiKhFy8sGyz61XzzwTVnoTCxkjeG7W68KLI8fzDriGe9+XIrhtAD
         s1Br27bTROjcpXUBEc/Uk//gc/IyA7RxbuFn1GjP9T8WPol3qTwU1fifWiksEnJYhg
         CRHy2FI8frAIQ==
Subject: [PATCH 17/43] xfs: make the start pointer passed to btree
 update_lastrec functions const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:41:32 -0700
Message-ID: <163158729289.1604118.1441354765552916486.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
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

