Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDEC9C83000
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D08421974
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AFbJCdhD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgD2PF3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 11:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgD2PF2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 11:05:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97E6C03C1AD
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 08:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=eZRenu4d/JAyuW+LUYIV1/9NSnCYoaR6zRHV5fRRNh4=; b=AFbJCdhDMPUJeuGneTDQFMmWHq
        QqGsZa2o6FtNKi3up6lQto7ZPQcwpBIf9cZssHLmzUurr9VMLRIfrIIZ/3kelL+cUpAv2L4qCtBFM
        8RkLyK/wvuu98QgGL2nFILlnVfmyjuWqB6lBpvnQb/rT+02BOoZBf3ReykD80CS/U7rS8t4FaqbCJ
        ilLXgxkyGInAjAZNct7Eqjz/zb8vXNKXZl2f8CugJlIHDa7YOuoAVEdAZLs0x9nUSicra+MIEn0RJ
        7x0Um3uYBa6BjFfqpMcYLo7oEMFk38zhi62gNc05elKgQWTuC+7VLZA6ZQrbnMOmZoYiBkDXKYNRw
        x3pDF1CA==;
Received: from [2001:4bb8:184:1b25:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jToHA-0000Ar-8W
        for linux-xfs@vger.kernel.org; Wed, 29 Apr 2020 15:05:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/11] xfs: merge the ->log_item defer op into ->create_intent
Date:   Wed, 29 Apr 2020 17:05:05 +0200
Message-Id: <20200429150511.2191150-6-hch@lst.de>
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

These are aways called together, and my merging them we reduce the amount
of indirect calls, improve type safety and in general clean up the code
a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_defer.c  |  6 ++---
 fs/xfs/libxfs/xfs_defer.h  |  4 ++--
 fs/xfs/xfs_bmap_item.c     | 47 +++++++++++++++---------------------
 fs/xfs/xfs_extfree_item.c  | 49 ++++++++++++++++----------------------
 fs/xfs/xfs_refcount_item.c | 48 ++++++++++++++++---------------------
 fs/xfs/xfs_rmap_item.c     | 48 ++++++++++++++++---------------------
 6 files changed, 83 insertions(+), 119 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 8a38da602b7d9..56d1357f9d137 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -185,14 +185,12 @@ xfs_defer_create_intent(
 	bool				sort)
 {
 	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
-	struct list_head		*li;
 
 	if (sort)
 		list_sort(tp->t_mountp, &dfp->dfp_work, ops->diff_items);
 
-	dfp->dfp_intent = ops->create_intent(tp, dfp->dfp_count);
-	list_for_each(li, &dfp->dfp_work)
-		ops->log_item(tp, dfp->dfp_intent, li);
+	dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
+			dfp->dfp_count);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 7c28d7608ac62..d6a4577c25b05 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -50,8 +50,8 @@ struct xfs_defer_op_type {
 	void (*finish_cleanup)(struct xfs_trans *, void *, int);
 	void (*cancel_item)(struct list_head *);
 	int (*diff_items)(void *, struct list_head *, struct list_head *);
-	void *(*create_intent)(struct xfs_trans *, uint);
-	void (*log_item)(struct xfs_trans *, void *, struct list_head *);
+	void *(*create_intent)(struct xfs_trans *tp, struct list_head *items,
+			unsigned int count);
 	unsigned int		max_items;
 };
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index ee6f4229cebc4..dea97956d78d6 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -278,27 +278,6 @@ xfs_bmap_update_diff_items(
 	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
 }
 
-/* Get an BUI. */
-STATIC void *
-xfs_bmap_update_create_intent(
-	struct xfs_trans		*tp,
-	unsigned int			count)
-{
-	struct xfs_bui_log_item		*buip;
-
-	ASSERT(count == XFS_BUI_MAX_FAST_EXTENTS);
-	ASSERT(tp != NULL);
-
-	buip = xfs_bui_init(tp->t_mountp);
-	ASSERT(buip != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &buip->bui_item);
-	return buip;
-}
-
 /* Set the map extent flags for this mapping. */
 static void
 xfs_trans_set_bmap_flags(
@@ -326,16 +305,12 @@ xfs_trans_set_bmap_flags(
 STATIC void
 xfs_bmap_update_log_item(
 	struct xfs_trans		*tp,
-	void				*intent,
-	struct list_head		*item)
+	struct xfs_bui_log_item		*buip,
+	struct xfs_bmap_intent		*bmap)
 {
-	struct xfs_bui_log_item		*buip = intent;
-	struct xfs_bmap_intent		*bmap;
 	uint				next_extent;
 	struct xfs_map_extent		*map;
 
-	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);
 
@@ -355,6 +330,23 @@ xfs_bmap_update_log_item(
 			bmap->bi_bmap.br_state);
 }
 
+STATIC void *
+xfs_bmap_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count)
+{
+	struct xfs_bui_log_item		*buip = xfs_bui_init(tp->t_mountp);
+	struct xfs_bmap_intent		*bmap;
+
+	ASSERT(count == XFS_BUI_MAX_FAST_EXTENTS);
+
+	xfs_trans_add_item(tp, &buip->bui_item);
+	list_for_each_entry(bmap, items, bi_list)
+		xfs_bmap_update_log_item(tp, buip, bmap);
+	return buip;
+}
+
 /* Get an BUD so we can process all the deferred rmap updates. */
 STATIC void *
 xfs_bmap_update_create_done(
@@ -419,7 +411,6 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.diff_items	= xfs_bmap_update_diff_items,
 	.create_intent	= xfs_bmap_update_create_intent,
 	.abort_intent	= xfs_bmap_update_abort_intent,
-	.log_item	= xfs_bmap_update_log_item,
 	.create_done	= xfs_bmap_update_create_done,
 	.finish_item	= xfs_bmap_update_finish_item,
 	.cancel_item	= xfs_bmap_update_cancel_item,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 00309b81607cd..cb22c7ad31817 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -412,41 +412,16 @@ xfs_extent_free_diff_items(
 		XFS_FSB_TO_AGNO(mp, rb->xefi_startblock);
 }
 
-/* Get an EFI. */
-STATIC void *
-xfs_extent_free_create_intent(
-	struct xfs_trans		*tp,
-	unsigned int			count)
-{
-	struct xfs_efi_log_item		*efip;
-
-	ASSERT(tp != NULL);
-	ASSERT(count > 0);
-
-	efip = xfs_efi_init(tp->t_mountp, count);
-	ASSERT(efip != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &efip->efi_item);
-	return efip;
-}
-
 /* Log a free extent to the intent item. */
 STATIC void
 xfs_extent_free_log_item(
 	struct xfs_trans		*tp,
-	void				*intent,
-	struct list_head		*item)
+	struct xfs_efi_log_item		*efip,
+	struct xfs_extent_free_item	*free)
 {
-	struct xfs_efi_log_item		*efip = intent;
-	struct xfs_extent_free_item	*free;
 	uint				next_extent;
 	struct xfs_extent		*extp;
 
-	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &efip->efi_item.li_flags);
 
@@ -462,6 +437,24 @@ xfs_extent_free_log_item(
 	extp->ext_len = free->xefi_blockcount;
 }
 
+STATIC void *
+xfs_extent_free_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_efi_log_item		*efip = xfs_efi_init(mp, count);
+	struct xfs_extent_free_item	*free;
+
+	ASSERT(count > 0);
+
+	xfs_trans_add_item(tp, &efip->efi_item);
+	list_for_each_entry(free, items, xefi_list)
+		xfs_extent_free_log_item(tp, efip, free);
+	return efip;
+}
+
 /* Get an EFD so we can process all the free extents. */
 STATIC void *
 xfs_extent_free_create_done(
@@ -516,7 +509,6 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 	.diff_items	= xfs_extent_free_diff_items,
 	.create_intent	= xfs_extent_free_create_intent,
 	.abort_intent	= xfs_extent_free_abort_intent,
-	.log_item	= xfs_extent_free_log_item,
 	.create_done	= xfs_extent_free_create_done,
 	.finish_item	= xfs_extent_free_finish_item,
 	.cancel_item	= xfs_extent_free_cancel_item,
@@ -582,7 +574,6 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
 	.diff_items	= xfs_extent_free_diff_items,
 	.create_intent	= xfs_extent_free_create_intent,
 	.abort_intent	= xfs_extent_free_abort_intent,
-	.log_item	= xfs_extent_free_log_item,
 	.create_done	= xfs_extent_free_create_done,
 	.finish_item	= xfs_agfl_free_finish_item,
 	.cancel_item	= xfs_extent_free_cancel_item,
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 8eeed73928cdf..325d49fc0406c 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -284,27 +284,6 @@ xfs_refcount_update_diff_items(
 		XFS_FSB_TO_AGNO(mp, rb->ri_startblock);
 }
 
-/* Get an CUI. */
-STATIC void *
-xfs_refcount_update_create_intent(
-	struct xfs_trans		*tp,
-	unsigned int			count)
-{
-	struct xfs_cui_log_item		*cuip;
-
-	ASSERT(tp != NULL);
-	ASSERT(count > 0);
-
-	cuip = xfs_cui_init(tp->t_mountp, count);
-	ASSERT(cuip != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &cuip->cui_item);
-	return cuip;
-}
-
 /* Set the phys extent flags for this reverse mapping. */
 static void
 xfs_trans_set_refcount_flags(
@@ -328,16 +307,12 @@ xfs_trans_set_refcount_flags(
 STATIC void
 xfs_refcount_update_log_item(
 	struct xfs_trans		*tp,
-	void				*intent,
-	struct list_head		*item)
+	struct xfs_cui_log_item		*cuip,
+	struct xfs_refcount_intent	*refc)
 {
-	struct xfs_cui_log_item		*cuip = intent;
-	struct xfs_refcount_intent	*refc;
 	uint				next_extent;
 	struct xfs_phys_extent		*ext;
 
-	refc = container_of(item, struct xfs_refcount_intent, ri_list);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
 
@@ -354,6 +329,24 @@ xfs_refcount_update_log_item(
 	xfs_trans_set_refcount_flags(ext, refc->ri_type);
 }
 
+STATIC void *
+xfs_refcount_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_cui_log_item		*cuip = xfs_cui_init(mp, count);
+	struct xfs_refcount_intent	*refc;
+
+	ASSERT(count > 0);
+
+	xfs_trans_add_item(tp, &cuip->cui_item);
+	list_for_each_entry(refc, items, ri_list)
+		xfs_refcount_update_log_item(tp, cuip, refc);
+	return cuip;
+}
+
 /* Get an CUD so we can process all the deferred refcount updates. */
 STATIC void *
 xfs_refcount_update_create_done(
@@ -432,7 +425,6 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.diff_items	= xfs_refcount_update_diff_items,
 	.create_intent	= xfs_refcount_update_create_intent,
 	.abort_intent	= xfs_refcount_update_abort_intent,
-	.log_item	= xfs_refcount_update_log_item,
 	.create_done	= xfs_refcount_update_create_done,
 	.finish_item	= xfs_refcount_update_finish_item,
 	.finish_cleanup = xfs_refcount_update_finish_cleanup,
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 4911b68f95dda..842d817f5168c 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -352,41 +352,16 @@ xfs_rmap_update_diff_items(
 		XFS_FSB_TO_AGNO(mp, rb->ri_bmap.br_startblock);
 }
 
-/* Get an RUI. */
-STATIC void *
-xfs_rmap_update_create_intent(
-	struct xfs_trans		*tp,
-	unsigned int			count)
-{
-	struct xfs_rui_log_item		*ruip;
-
-	ASSERT(tp != NULL);
-	ASSERT(count > 0);
-
-	ruip = xfs_rui_init(tp->t_mountp, count);
-	ASSERT(ruip != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &ruip->rui_item);
-	return ruip;
-}
-
 /* Log rmap updates in the intent item. */
 STATIC void
 xfs_rmap_update_log_item(
 	struct xfs_trans		*tp,
-	void				*intent,
-	struct list_head		*item)
+	struct xfs_rui_log_item		*ruip,
+	struct xfs_rmap_intent		*rmap)
 {
-	struct xfs_rui_log_item		*ruip = intent;
-	struct xfs_rmap_intent		*rmap;
 	uint				next_extent;
 	struct xfs_map_extent		*map;
 
-	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &ruip->rui_item.li_flags);
 
@@ -406,6 +381,24 @@ xfs_rmap_update_log_item(
 			rmap->ri_bmap.br_state);
 }
 
+STATIC void *
+xfs_rmap_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_rui_log_item		*ruip = xfs_rui_init(mp, count);
+	struct xfs_rmap_intent		*rmap;
+
+	ASSERT(count > 0);
+
+	xfs_trans_add_item(tp, &ruip->rui_item);
+	list_for_each_entry(rmap, items, ri_list)
+		xfs_rmap_update_log_item(tp, ruip, rmap);
+	return ruip;
+}
+
 /* Get an RUD so we can process all the deferred rmap updates. */
 STATIC void *
 xfs_rmap_update_create_done(
@@ -476,7 +469,6 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.diff_items	= xfs_rmap_update_diff_items,
 	.create_intent	= xfs_rmap_update_create_intent,
 	.abort_intent	= xfs_rmap_update_abort_intent,
-	.log_item	= xfs_rmap_update_log_item,
 	.create_done	= xfs_rmap_update_create_done,
 	.finish_item	= xfs_rmap_update_finish_item,
 	.finish_cleanup = xfs_rmap_update_finish_cleanup,
-- 
2.26.2

