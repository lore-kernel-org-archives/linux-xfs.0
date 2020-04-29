Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 735DCC83000
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A22021D7E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Km3csjXu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgD2PFd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 11:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgD2PFd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 11:05:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B0CC03C1AD
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 08:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=35AZ+isOqq/PxygRROspNmBq3EZMYOGRTBgHCtsCfN8=; b=Km3csjXuETu/6XrJTRCW2CfcJz
        IT643JM9PSVajm+i8jZeGAeESPgO0cfbFeux+sx5RLMdzrD4qk4i2fPI8EzfZ4gy52ZDRy1xVu1Ws
        B9+cG21SiCGhfQjj2m92M0S2eGfEo2zn4qhZjyHZ1uCpyJ1q72vUudUtLbxarqCRz3avyOUtn7K8l
        ewtCi5SqfVkzL/xEt/ZOXQaQoEWua7HQbhRsUMHMR5LjqJPxZf27yAX6xyDPSP9lJzxp7DRrgP8xb
        9Q5JhuvVVH3sK+0eDRnOsjngU+FcVfU881int2uFXKcB+jqgJqMbcCzYgwkLK9Fgi+htGA9qiEwPd
        HFlKjb7g==;
Received: from [2001:4bb8:184:1b25:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jToHF-0000CA-2h
        for linux-xfs@vger.kernel.org; Wed, 29 Apr 2020 15:05:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/11] xfs: turn dfp_intent into a xfs_log_item
Date:   Wed, 29 Apr 2020 17:05:07 +0200
Message-Id: <20200429150511.2191150-8-hch@lst.de>
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
the dfp_intent field.  Replace that with a xfs_log_item to improve type
safety and make the code easier to follow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_defer.h  | 11 ++++++-----
 fs/xfs/xfs_bmap_item.c     | 12 ++++++------
 fs/xfs/xfs_extfree_item.c  | 12 ++++++------
 fs/xfs/xfs_refcount_item.c | 12 ++++++------
 fs/xfs/xfs_rmap_item.c     | 12 ++++++------
 5 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 660f5c3821d6b..7b6cc3808a91b 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -28,7 +28,7 @@ enum xfs_defer_ops_type {
 struct xfs_defer_pending {
 	struct list_head		dfp_list;	/* pending items */
 	struct list_head		dfp_work;	/* work items */
-	void				*dfp_intent;	/* log intent item */
+	struct xfs_log_item		*dfp_intent;	/* log intent item */
 	void				*dfp_done;	/* log done item */
 	unsigned int			dfp_count;	/* # extent items */
 	enum xfs_defer_ops_type		dfp_type;
@@ -43,14 +43,15 @@ void xfs_defer_move(struct xfs_trans *dtp, struct xfs_trans *stp);
 
 /* Description of a deferred type. */
 struct xfs_defer_op_type {
-	void (*abort_intent)(void *);
-	void *(*create_done)(struct xfs_trans *, void *, unsigned int);
+	struct xfs_log_item *(*create_intent)(struct xfs_trans *tp,
+			struct list_head *items, unsigned int count, bool sort);
+	void (*abort_intent)(struct xfs_log_item *intent);
+	void *(*create_done)(struct xfs_trans *tp, struct xfs_log_item *intent,
+			unsigned int count);
 	int (*finish_item)(struct xfs_trans *, struct list_head *, void *,
 			void **);
 	void (*finish_cleanup)(struct xfs_trans *, void *, int);
 	void (*cancel_item)(struct list_head *);
-	void *(*create_intent)(struct xfs_trans *tp, struct list_head *items,
-			unsigned int count, bool sort);
 	unsigned int		max_items;
 };
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index f9505c5873bd2..7b2153fca2d9e 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -330,7 +330,7 @@ xfs_bmap_update_log_item(
 			bmap->bi_bmap.br_state);
 }
 
-STATIC void *
+static struct xfs_log_item *
 xfs_bmap_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
@@ -348,17 +348,17 @@ xfs_bmap_update_create_intent(
 		list_sort(mp, items, xfs_bmap_update_diff_items);
 	list_for_each_entry(bmap, items, bi_list)
 		xfs_bmap_update_log_item(tp, buip, bmap);
-	return buip;
+	return &buip->bui_item;
 }
 
 /* Get an BUD so we can process all the deferred rmap updates. */
 STATIC void *
 xfs_bmap_update_create_done(
 	struct xfs_trans		*tp,
-	void				*intent,
+	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return xfs_trans_get_bud(tp, intent);
+	return xfs_trans_get_bud(tp, BUI_ITEM(intent));
 }
 
 /* Process a deferred rmap update. */
@@ -394,9 +394,9 @@ xfs_bmap_update_finish_item(
 /* Abort all pending BUIs. */
 STATIC void
 xfs_bmap_update_abort_intent(
-	void				*intent)
+	struct xfs_log_item		*intent)
 {
-	xfs_bui_release(intent);
+	xfs_bui_release(BUI_ITEM(intent));
 }
 
 /* Cancel a deferred rmap update. */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 3e10eba9d22bd..0453b6f2b1d69 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -437,7 +437,7 @@ xfs_extent_free_log_item(
 	extp->ext_len = free->xefi_blockcount;
 }
 
-STATIC void *
+static struct xfs_log_item *
 xfs_extent_free_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
@@ -455,17 +455,17 @@ xfs_extent_free_create_intent(
 		list_sort(mp, items, xfs_extent_free_diff_items);
 	list_for_each_entry(free, items, xefi_list)
 		xfs_extent_free_log_item(tp, efip, free);
-	return efip;
+	return &efip->efi_item;
 }
 
 /* Get an EFD so we can process all the free extents. */
 STATIC void *
 xfs_extent_free_create_done(
 	struct xfs_trans		*tp,
-	void				*intent,
+	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return xfs_trans_get_efd(tp, intent, count);
+	return xfs_trans_get_efd(tp, EFI_ITEM(intent), count);
 }
 
 /* Process a free extent. */
@@ -491,9 +491,9 @@ xfs_extent_free_finish_item(
 /* Abort all pending EFIs. */
 STATIC void
 xfs_extent_free_abort_intent(
-	void				*intent)
+	struct xfs_log_item		*intent)
 {
-	xfs_efi_release(intent);
+	xfs_efi_release(EFI_ITEM(intent));
 }
 
 /* Cancel a free extent. */
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index efc32ec55afdf..e8d3278e066e3 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -329,7 +329,7 @@ xfs_refcount_update_log_item(
 	xfs_trans_set_refcount_flags(ext, refc->ri_type);
 }
 
-STATIC void *
+static struct xfs_log_item *
 xfs_refcount_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
@@ -347,17 +347,17 @@ xfs_refcount_update_create_intent(
 		list_sort(mp, items, xfs_refcount_update_diff_items);
 	list_for_each_entry(refc, items, ri_list)
 		xfs_refcount_update_log_item(tp, cuip, refc);
-	return cuip;
+	return &cuip->cui_item;
 }
 
 /* Get an CUD so we can process all the deferred refcount updates. */
 STATIC void *
 xfs_refcount_update_create_done(
 	struct xfs_trans		*tp,
-	void				*intent,
+	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return xfs_trans_get_cud(tp, intent);
+	return xfs_trans_get_cud(tp, CUI_ITEM(intent));
 }
 
 /* Process a deferred refcount update. */
@@ -407,9 +407,9 @@ xfs_refcount_update_finish_cleanup(
 /* Abort all pending CUIs. */
 STATIC void
 xfs_refcount_update_abort_intent(
-	void				*intent)
+	struct xfs_log_item		*intent)
 {
-	xfs_cui_release(intent);
+	xfs_cui_release(CUI_ITEM(intent));
 }
 
 /* Cancel a deferred refcount update. */
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 40567cf0c216e..a417e15fd0ce4 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -381,7 +381,7 @@ xfs_rmap_update_log_item(
 			rmap->ri_bmap.br_state);
 }
 
-STATIC void *
+static struct xfs_log_item *
 xfs_rmap_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
@@ -399,17 +399,17 @@ xfs_rmap_update_create_intent(
 		list_sort(mp, items, xfs_rmap_update_diff_items);
 	list_for_each_entry(rmap, items, ri_list)
 		xfs_rmap_update_log_item(tp, ruip, rmap);
-	return ruip;
+	return &ruip->rui_item;
 }
 
 /* Get an RUD so we can process all the deferred rmap updates. */
 STATIC void *
 xfs_rmap_update_create_done(
 	struct xfs_trans		*tp,
-	void				*intent,
+	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return xfs_trans_get_rud(tp, intent);
+	return xfs_trans_get_rud(tp, RUI_ITEM(intent));
 }
 
 /* Process a deferred rmap update. */
@@ -451,9 +451,9 @@ xfs_rmap_update_finish_cleanup(
 /* Abort all pending RUIs. */
 STATIC void
 xfs_rmap_update_abort_intent(
-	void				*intent)
+	struct xfs_log_item	*intent)
 {
-	xfs_rui_release(intent);
+	xfs_rui_release(RUI_ITEM(intent));
 }
 
 /* Cancel a deferred rmap update. */
-- 
2.26.2

