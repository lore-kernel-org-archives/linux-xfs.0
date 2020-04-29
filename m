Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C581DC83006
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2B3221973
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Omu+uzmP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgD2PFl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 11:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgD2PFl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 11:05:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0171FC03C1AD
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 08:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=15v85DBTs483wlflfXphOWwTiHdnMerq29r8OWdbkvk=; b=Omu+uzmPE4zLXToAHxzl/H+M1d
        wQdKV9x4TVmd1qzPrp2cUiuwxMKZgNPpYct0HGH2uD5BALudP4bZTC57PF4pBdqlENH/IPMYYeaEE
        0tH8dTPE4KNCLvOWvEosqQ2oOM4Lef1Np1NttRw0nxl0KucooipgV2C7LAq792PGsBP+Ghu6fae+N
        LPi/5/vyf2hMySPFhfZFiQk+lIE0V8B2Gj49cwaCfd2Sniw8y/+RG4jUbs4ezdDcQNlyWuwpPPnzZ
        xa+xn4Dg5FPGMDa+CGj3pP9SJU9l1wGdgN06YWlhwNad6FCFqmU+wV18baySG2ZK1Xd3LJPfNPXxx
        1ETCY23w==;
Received: from [2001:4bb8:184:1b25:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jToHM-0000E0-HC
        for linux-xfs@vger.kernel.org; Wed, 29 Apr 2020 15:05:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/11] xfs: use a xfs_btree_cur for the ->finish_cleanup state
Date:   Wed, 29 Apr 2020 17:05:10 +0200
Message-Id: <20200429150511.2191150-11-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429150511.2191150-1-hch@lst.de>
References: <20200429150511.2191150-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Given how XFS is all based around btrees it doesn't make much sense
to offer a totally generic state when we can just use the btree cursor.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_defer.c  |  2 +-
 fs/xfs/libxfs/xfs_defer.h  |  6 ++++--
 fs/xfs/xfs_bmap_item.c     |  2 +-
 fs/xfs/xfs_extfree_item.c  |  4 ++--
 fs/xfs/xfs_refcount_item.c | 24 +++++-------------------
 fs/xfs/xfs_rmap_item.c     | 27 ++++++---------------------
 6 files changed, 19 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 5f37f42cda67b..1172fbf072d84 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -361,7 +361,7 @@ xfs_defer_finish_one(
 	struct xfs_defer_pending	*dfp)
 {
 	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
-	void				*state = NULL;
+	struct xfs_btree_cur		*state = NULL;
 	struct list_head		*li, *n;
 	int				error;
 
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index a86c890e63d20..f2b65981bace4 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -6,6 +6,7 @@
 #ifndef __XFS_DEFER_H__
 #define	__XFS_DEFER_H__
 
+struct xfs_btree_cur;
 struct xfs_defer_op_type;
 
 /*
@@ -49,8 +50,9 @@ struct xfs_defer_op_type {
 	struct xfs_log_item *(*create_done)(struct xfs_trans *tp,
 			struct xfs_log_item *intent, unsigned int count);
 	int (*finish_item)(struct xfs_trans *tp, struct xfs_log_item *done,
-			struct list_head *item, void **state);
-	void (*finish_cleanup)(struct xfs_trans *, void *, int);
+			struct list_head *item, struct xfs_btree_cur **state);
+	void (*finish_cleanup)(struct xfs_trans *tp,
+			struct xfs_btree_cur *state, int error);
 	void (*cancel_item)(struct list_head *);
 	unsigned int		max_items;
 };
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index feadd44a67e4b..7768fb2b71357 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -367,7 +367,7 @@ xfs_bmap_update_finish_item(
 	struct xfs_trans		*tp,
 	struct xfs_log_item		*done,
 	struct list_head		*item,
-	void				**state)
+	struct xfs_btree_cur		**state)
 {
 	struct xfs_bmap_intent		*bmap;
 	xfs_filblks_t			count;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 633628f70e128..c8cde4122a0fe 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -474,7 +474,7 @@ xfs_extent_free_finish_item(
 	struct xfs_trans		*tp,
 	struct xfs_log_item		*done,
 	struct list_head		*item,
-	void				**state)
+	struct xfs_btree_cur		**state)
 {
 	struct xfs_extent_free_item	*free;
 	int				error;
@@ -525,7 +525,7 @@ xfs_agfl_free_finish_item(
 	struct xfs_trans		*tp,
 	struct xfs_log_item		*done,
 	struct list_head		*item,
-	void				**state)
+	struct xfs_btree_cur		**state)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_efd_log_item		*efdp = EFD_ITEM(done);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index f1c2e559a7ae7..0316eab2fc351 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -366,7 +366,7 @@ xfs_refcount_update_finish_item(
 	struct xfs_trans		*tp,
 	struct xfs_log_item		*done,
 	struct list_head		*item,
-	void				**state)
+	struct xfs_btree_cur		**state)
 {
 	struct xfs_refcount_intent	*refc;
 	xfs_fsblock_t			new_fsb;
@@ -375,11 +375,9 @@ xfs_refcount_update_finish_item(
 
 	refc = container_of(item, struct xfs_refcount_intent, ri_list);
 	error = xfs_trans_log_finish_refcount_update(tp, CUD_ITEM(done),
-			refc->ri_type,
-			refc->ri_startblock,
-			refc->ri_blockcount,
-			&new_fsb, &new_aglen,
-			(struct xfs_btree_cur **)state);
+			refc->ri_type, refc->ri_startblock, refc->ri_blockcount,
+			&new_fsb, &new_aglen, state);
+
 	/* Did we run out of reservation?  Requeue what we didn't finish. */
 	if (!error && new_aglen > 0) {
 		ASSERT(refc->ri_type == XFS_REFCOUNT_INCREASE ||
@@ -392,18 +390,6 @@ xfs_refcount_update_finish_item(
 	return error;
 }
 
-/* Clean up after processing deferred refcounts. */
-STATIC void
-xfs_refcount_update_finish_cleanup(
-	struct xfs_trans	*tp,
-	void			*state,
-	int			error)
-{
-	struct xfs_btree_cur	*rcur = state;
-
-	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-}
-
 /* Abort all pending CUIs. */
 STATIC void
 xfs_refcount_update_abort_intent(
@@ -429,7 +415,7 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.abort_intent	= xfs_refcount_update_abort_intent,
 	.create_done	= xfs_refcount_update_create_done,
 	.finish_item	= xfs_refcount_update_finish_item,
-	.finish_cleanup = xfs_refcount_update_finish_cleanup,
+	.finish_cleanup = xfs_refcount_finish_one_cleanup,
 	.cancel_item	= xfs_refcount_update_cancel_item,
 };
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index f6a2a388e5ac9..e3bba2aec8682 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -418,36 +418,21 @@ xfs_rmap_update_finish_item(
 	struct xfs_trans		*tp,
 	struct xfs_log_item		*done,
 	struct list_head		*item,
-	void				**state)
+	struct xfs_btree_cur		**state)
 {
 	struct xfs_rmap_intent		*rmap;
 	int				error;
 
 	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
 	error = xfs_trans_log_finish_rmap_update(tp, RUD_ITEM(done),
-			rmap->ri_type,
-			rmap->ri_owner, rmap->ri_whichfork,
-			rmap->ri_bmap.br_startoff,
-			rmap->ri_bmap.br_startblock,
-			rmap->ri_bmap.br_blockcount,
-			rmap->ri_bmap.br_state,
-			(struct xfs_btree_cur **)state);
+			rmap->ri_type, rmap->ri_owner, rmap->ri_whichfork,
+			rmap->ri_bmap.br_startoff, rmap->ri_bmap.br_startblock,
+			rmap->ri_bmap.br_blockcount, rmap->ri_bmap.br_state,
+			state);
 	kmem_free(rmap);
 	return error;
 }
 
-/* Clean up after processing deferred rmaps. */
-STATIC void
-xfs_rmap_update_finish_cleanup(
-	struct xfs_trans	*tp,
-	void			*state,
-	int			error)
-{
-	struct xfs_btree_cur	*rcur = state;
-
-	xfs_rmap_finish_one_cleanup(tp, rcur, error);
-}
-
 /* Abort all pending RUIs. */
 STATIC void
 xfs_rmap_update_abort_intent(
@@ -473,7 +458,7 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.abort_intent	= xfs_rmap_update_abort_intent,
 	.create_done	= xfs_rmap_update_create_done,
 	.finish_item	= xfs_rmap_update_finish_item,
-	.finish_cleanup = xfs_rmap_update_finish_cleanup,
+	.finish_cleanup = xfs_rmap_finish_one_cleanup,
 	.cancel_item	= xfs_rmap_update_cancel_item,
 };
 
-- 
2.26.2

