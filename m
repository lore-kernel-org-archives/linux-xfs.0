Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D6AFC83004
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0384621974
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U5VVrd0o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgD2PFi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 11:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgD2PFi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 11:05:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71866C03C1AD
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 08:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=jiBLVFvz8Qi4EOu50Jb3Meu0YEBZv/RK6G/o8RLb//U=; b=U5VVrd0o1XWwOF9/MRTsA7aTm9
        TTKZMIpxK7vf9vseW5Kl91bCfQt7SZn3g5OXGpWHE72+Jq0Hr1RKDHq8EIpW+GqILWcRdz+8WyKWX
        PJzORMX+UCde8UEatpv3m83fsuNgCtARj+arJ3YrjcCZ9CnfLPiLGQ0a4zr/K4BF04hu9XpU/80Z1
        95y9QsBqgG4fm7jpzZ0xGZsWuYRdhBhSVRlyN9+3rmlrrthjh4y9wazNtouvjqzsbXnCP0WuhlBhq
        Q5Tu12CgELMBU5XL2AsJYXrAWnRFsVW09PtWUEaBhlRzveiJiKCrrcqNzACocBYnP58WPFgrfem/3
        gx1mGZJQ==;
Received: from [2001:4bb8:184:1b25:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jToHJ-0000DC-Vf
        for linux-xfs@vger.kernel.org; Wed, 29 Apr 2020 15:05:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/11] xfs: turn dfp_done into a xfs_log_item
Date:   Wed, 29 Apr 2020 17:05:09 +0200
Message-Id: <20200429150511.2191150-10-hch@lst.de>
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

All defer op instance place their own extension of the log item into
the dfp_done field.  Replace that with a xfs_log_item to improve type
safety and make the code easier to follow.

Also use the opportunity to improve the ->finish_item calling conventions
to place the done log item as the higher level structure before the
list_entry used for the individual items.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_defer.c  |  2 +-
 fs/xfs/libxfs/xfs_defer.h  | 10 +++++-----
 fs/xfs/xfs_bmap_item.c     |  8 ++++----
 fs/xfs/xfs_extfree_item.c  | 12 ++++++------
 fs/xfs/xfs_refcount_item.c |  8 ++++----
 fs/xfs/xfs_rmap_item.c     |  8 ++++----
 6 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 20950b56cdd07..5f37f42cda67b 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -371,7 +371,7 @@ xfs_defer_finish_one(
 	list_for_each_safe(li, n, &dfp->dfp_work) {
 		list_del(li);
 		dfp->dfp_count--;
-		error = ops->finish_item(tp, li, dfp->dfp_done, &state);
+		error = ops->finish_item(tp, dfp->dfp_done, li, &state);
 		if (error == -EAGAIN) {
 			/*
 			 * Caller wants a fresh transaction; put the work item
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 7b6cc3808a91b..a86c890e63d20 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -29,7 +29,7 @@ struct xfs_defer_pending {
 	struct list_head		dfp_list;	/* pending items */
 	struct list_head		dfp_work;	/* work items */
 	struct xfs_log_item		*dfp_intent;	/* log intent item */
-	void				*dfp_done;	/* log done item */
+	struct xfs_log_item		*dfp_done;	/* log done item */
 	unsigned int			dfp_count;	/* # extent items */
 	enum xfs_defer_ops_type		dfp_type;
 };
@@ -46,10 +46,10 @@ struct xfs_defer_op_type {
 	struct xfs_log_item *(*create_intent)(struct xfs_trans *tp,
 			struct list_head *items, unsigned int count, bool sort);
 	void (*abort_intent)(struct xfs_log_item *intent);
-	void *(*create_done)(struct xfs_trans *tp, struct xfs_log_item *intent,
-			unsigned int count);
-	int (*finish_item)(struct xfs_trans *, struct list_head *, void *,
-			void **);
+	struct xfs_log_item *(*create_done)(struct xfs_trans *tp,
+			struct xfs_log_item *intent, unsigned int count);
+	int (*finish_item)(struct xfs_trans *tp, struct xfs_log_item *done,
+			struct list_head *item, void **state);
 	void (*finish_cleanup)(struct xfs_trans *, void *, int);
 	void (*cancel_item)(struct list_head *);
 	unsigned int		max_items;
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 7b2153fca2d9e..feadd44a67e4b 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -352,21 +352,21 @@ xfs_bmap_update_create_intent(
 }
 
 /* Get an BUD so we can process all the deferred rmap updates. */
-STATIC void *
+static struct xfs_log_item *
 xfs_bmap_update_create_done(
 	struct xfs_trans		*tp,
 	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return xfs_trans_get_bud(tp, BUI_ITEM(intent));
+	return &xfs_trans_get_bud(tp, BUI_ITEM(intent))->bud_item;
 }
 
 /* Process a deferred rmap update. */
 STATIC int
 xfs_bmap_update_finish_item(
 	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
 	struct list_head		*item,
-	void				*done_item,
 	void				**state)
 {
 	struct xfs_bmap_intent		*bmap;
@@ -375,7 +375,7 @@ xfs_bmap_update_finish_item(
 
 	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
 	count = bmap->bi_bmap.br_blockcount;
-	error = xfs_trans_log_finish_bmap_update(tp, done_item,
+	error = xfs_trans_log_finish_bmap_update(tp, BUD_ITEM(done),
 			bmap->bi_type,
 			bmap->bi_owner, bmap->bi_whichfork,
 			bmap->bi_bmap.br_startoff,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 0453b6f2b1d69..633628f70e128 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -459,28 +459,28 @@ xfs_extent_free_create_intent(
 }
 
 /* Get an EFD so we can process all the free extents. */
-STATIC void *
+static struct xfs_log_item *
 xfs_extent_free_create_done(
 	struct xfs_trans		*tp,
 	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return xfs_trans_get_efd(tp, EFI_ITEM(intent), count);
+	return &xfs_trans_get_efd(tp, EFI_ITEM(intent), count)->efd_item;
 }
 
 /* Process a free extent. */
 STATIC int
 xfs_extent_free_finish_item(
 	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
 	struct list_head		*item,
-	void				*done_item,
 	void				**state)
 {
 	struct xfs_extent_free_item	*free;
 	int				error;
 
 	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	error = xfs_trans_free_extent(tp, done_item,
+	error = xfs_trans_free_extent(tp, EFD_ITEM(done),
 			free->xefi_startblock,
 			free->xefi_blockcount,
 			&free->xefi_oinfo, free->xefi_skip_discard);
@@ -523,12 +523,12 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 STATIC int
 xfs_agfl_free_finish_item(
 	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
 	struct list_head		*item,
-	void				*done_item,
 	void				**state)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_efd_log_item		*efdp = done_item;
+	struct xfs_efd_log_item		*efdp = EFD_ITEM(done);
 	struct xfs_extent_free_item	*free;
 	struct xfs_extent		*extp;
 	struct xfs_buf			*agbp;
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index e8d3278e066e3..f1c2e559a7ae7 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -351,21 +351,21 @@ xfs_refcount_update_create_intent(
 }
 
 /* Get an CUD so we can process all the deferred refcount updates. */
-STATIC void *
+static struct xfs_log_item *
 xfs_refcount_update_create_done(
 	struct xfs_trans		*tp,
 	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return xfs_trans_get_cud(tp, CUI_ITEM(intent));
+	return &xfs_trans_get_cud(tp, CUI_ITEM(intent))->cud_item;
 }
 
 /* Process a deferred refcount update. */
 STATIC int
 xfs_refcount_update_finish_item(
 	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
 	struct list_head		*item,
-	void				*done_item,
 	void				**state)
 {
 	struct xfs_refcount_intent	*refc;
@@ -374,7 +374,7 @@ xfs_refcount_update_finish_item(
 	int				error;
 
 	refc = container_of(item, struct xfs_refcount_intent, ri_list);
-	error = xfs_trans_log_finish_refcount_update(tp, done_item,
+	error = xfs_trans_log_finish_refcount_update(tp, CUD_ITEM(done),
 			refc->ri_type,
 			refc->ri_startblock,
 			refc->ri_blockcount,
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index a417e15fd0ce4..f6a2a388e5ac9 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -403,28 +403,28 @@ xfs_rmap_update_create_intent(
 }
 
 /* Get an RUD so we can process all the deferred rmap updates. */
-STATIC void *
+static struct xfs_log_item *
 xfs_rmap_update_create_done(
 	struct xfs_trans		*tp,
 	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return xfs_trans_get_rud(tp, RUI_ITEM(intent));
+	return &xfs_trans_get_rud(tp, RUI_ITEM(intent))->rud_item;
 }
 
 /* Process a deferred rmap update. */
 STATIC int
 xfs_rmap_update_finish_item(
 	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
 	struct list_head		*item,
-	void				*done_item,
 	void				**state)
 {
 	struct xfs_rmap_intent		*rmap;
 	int				error;
 
 	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
-	error = xfs_trans_log_finish_rmap_update(tp, done_item,
+	error = xfs_trans_log_finish_rmap_update(tp, RUD_ITEM(done),
 			rmap->ri_type,
 			rmap->ri_owner, rmap->ri_whichfork,
 			rmap->ri_bmap.br_startoff,
-- 
2.26.2

