Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D80C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 20:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236590AbiLMUym (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 15:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237071AbiLMUyl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 15:54:41 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EEE14021
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 12:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=QfNAkqy3tCOgA68Qs5L7rztqjJ7InkQwEx/waIz0zpk=; b=htvjQ9EUKZWCt8ddTWBE36ZRPX
        rmqDLQSwHS8i1DWJh3VQdb2kGyZM/+PJLQxaJtbW7zcpclhbecwXmqL80YOqTdLlfjQIYcimOgzHD
        XNbV3O+EGT3RInU/6Gkr/+23tc3Yl/tJFMZPmXUcTTuGmjrjjrhCfK7SP01MZ6MZ/Y0K41HUlMn/L
        vP010iL1N0y/GX8A5FLcV+iM42l/R86uI0s+lGMDjo4peSkNL6PNg52Z3kYNf4XKSggrQeKXc0hoi
        KFQ+K36V7WWZpBsPbi0edu9bPK0NvXTXmUl3odh9Tk86HwRX2kEcS5G5ngDT3ImxTHs2mQ77cbamG
        eo4olxIQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p5CIZ-00CZvY-5P; Tue, 13 Dec 2022 20:54:47 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: Add const qualifiers
Date:   Tue, 13 Dec 2022 20:54:45 +0000
Message-Id: <20221213205446.2998033-1-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

With a container_of() that preserves const, the compiler warns about
all these places which are currently casting away the const.  For
the IUL_ITEM() helper, we want to also make it const-preserving,
and in every other case, we want to just add a const qualifier.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/xfs/scrub/bitmap.c      | 4 ++--
 fs/xfs/xfs_bmap_item.c     | 4 ++--
 fs/xfs/xfs_buf.c           | 4 ++--
 fs/xfs/xfs_extent_busy.c   | 4 ++--
 fs/xfs/xfs_extfree_item.c  | 4 ++--
 fs/xfs/xfs_iunlink_item.c  | 7 ++-----
 fs/xfs/xfs_log_cil.c       | 6 ++++--
 fs/xfs/xfs_refcount_item.c | 4 ++--
 fs/xfs/xfs_rmap_item.c     | 4 ++--
 fs/xfs/xfs_trans.c         | 8 ++++----
 fs/xfs/xfs_trans.h         | 2 +-
 11 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index a255f09e9f0a..21bfccaccd85 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -67,8 +67,8 @@ xbitmap_range_cmp(
 	const struct list_head	*a,
 	const struct list_head	*b)
 {
-	struct xbitmap_range	*ap;
-	struct xbitmap_range	*bp;
+	const struct xbitmap_range	*ap;
+	const struct xbitmap_range	*bp;
 
 	ap = container_of(a, struct xbitmap_range, list);
 	bp = container_of(b, struct xbitmap_range, list);
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 41323da523d1..00725e87ce9b 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -279,8 +279,8 @@ xfs_bmap_update_diff_items(
 	const struct list_head		*a,
 	const struct list_head		*b)
 {
-	struct xfs_bmap_intent		*ba;
-	struct xfs_bmap_intent		*bb;
+	const struct xfs_bmap_intent	*ba;
+	const struct xfs_bmap_intent	*bb;
 
 	ba = container_of(a, struct xfs_bmap_intent, bi_list);
 	bb = container_of(b, struct xfs_bmap_intent, bi_list);
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 54c774af6e1c..46712df2b02d 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2121,8 +2121,8 @@ xfs_buf_cmp(
 	const struct list_head	*a,
 	const struct list_head	*b)
 {
-	struct xfs_buf	*ap = container_of(a, struct xfs_buf, b_list);
-	struct xfs_buf	*bp = container_of(b, struct xfs_buf, b_list);
+	const struct xfs_buf	*ap = container_of(a, struct xfs_buf, b_list);
+	const struct xfs_buf	*bp = container_of(b, struct xfs_buf, b_list);
 	xfs_daddr_t		diff;
 
 	diff = ap->b_maps[0].bm_bn - bp->b_maps[0].bm_bn;
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index ad22a003f959..e99658892eda 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -617,9 +617,9 @@ xfs_extent_busy_ag_cmp(
 	const struct list_head	*l1,
 	const struct list_head	*l2)
 {
-	struct xfs_extent_busy	*b1 =
+	const struct xfs_extent_busy	*b1 =
 		container_of(l1, struct xfs_extent_busy, list);
-	struct xfs_extent_busy	*b2 =
+	const struct xfs_extent_busy	*b2 =
 		container_of(l2, struct xfs_extent_busy, list);
 	s32 diff;
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index d5130d1fcfae..6cd55d5e123a 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -390,8 +390,8 @@ xfs_extent_free_diff_items(
 	const struct list_head		*b)
 {
 	struct xfs_mount		*mp = priv;
-	struct xfs_extent_free_item	*ra;
-	struct xfs_extent_free_item	*rb;
+	const struct xfs_extent_free_item	*ra;
+	const struct xfs_extent_free_item	*rb;
 
 	ra = container_of(a, struct xfs_extent_free_item, xefi_list);
 	rb = container_of(b, struct xfs_extent_free_item, xefi_list);
diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
index 43005ce8bd48..ff82a93f8a24 100644
--- a/fs/xfs/xfs_iunlink_item.c
+++ b/fs/xfs/xfs_iunlink_item.c
@@ -20,10 +20,7 @@
 
 struct kmem_cache	*xfs_iunlink_cache;
 
-static inline struct xfs_iunlink_item *IUL_ITEM(struct xfs_log_item *lip)
-{
-	return container_of(lip, struct xfs_iunlink_item, item);
-}
+#define IUL_ITEM(lip) container_of(lip, struct xfs_iunlink_item, item)
 
 static void
 xfs_iunlink_item_release(
@@ -38,7 +35,7 @@ xfs_iunlink_item_release(
 
 static uint64_t
 xfs_iunlink_item_sort(
-	struct xfs_log_item	*lip)
+	const struct xfs_log_item	*lip)
 {
 	return IUL_ITEM(lip)->ip->i_ino;
 }
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index eccbfb99e894..bdab056b8820 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1095,8 +1095,10 @@ xlog_cil_order_cmp(
 	const struct list_head	*a,
 	const struct list_head	*b)
 {
-	struct xfs_log_vec	*l1 = container_of(a, struct xfs_log_vec, lv_list);
-	struct xfs_log_vec	*l2 = container_of(b, struct xfs_log_vec, lv_list);
+	const struct xfs_log_vec *l1, *l2;
+
+	l1 = container_of(a, struct xfs_log_vec, lv_list);
+	l2 = container_of(b, struct xfs_log_vec, lv_list);
 
 	return l1->lv_order_id > l2->lv_order_id;
 }
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 858e3e9eb4a8..ab82eb720815 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -285,8 +285,8 @@ xfs_refcount_update_diff_items(
 	const struct list_head		*b)
 {
 	struct xfs_mount		*mp = priv;
-	struct xfs_refcount_intent	*ra;
-	struct xfs_refcount_intent	*rb;
+	const struct xfs_refcount_intent *ra;
+	const struct xfs_refcount_intent *rb;
 
 	ra = container_of(a, struct xfs_refcount_intent, ri_list);
 	rb = container_of(b, struct xfs_refcount_intent, ri_list);
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 534504ede1a3..f1fce77245e6 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -328,8 +328,8 @@ xfs_rmap_update_diff_items(
 	const struct list_head		*b)
 {
 	struct xfs_mount		*mp = priv;
-	struct xfs_rmap_intent		*ra;
-	struct xfs_rmap_intent		*rb;
+	const struct xfs_rmap_intent	*ra;
+	const struct xfs_rmap_intent	*rb;
 
 	ra = container_of(a, struct xfs_rmap_intent, ri_list);
 	rb = container_of(b, struct xfs_rmap_intent, ri_list);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7bd16fbff534..f5cb8c8095c5 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -861,12 +861,12 @@ xfs_trans_precommit_sort(
 	const struct list_head	*a,
 	const struct list_head	*b)
 {
-	struct xfs_log_item	*lia = container_of(a,
-					struct xfs_log_item, li_trans);
-	struct xfs_log_item	*lib = container_of(b,
-					struct xfs_log_item, li_trans);
+	const struct xfs_log_item	*lia, *lib;
 	int64_t			diff;
 
+	lia = container_of(a, struct xfs_log_item, li_trans);
+	lib = container_of(b, struct xfs_log_item, li_trans);
+
 	/*
 	 * If both items are non-sortable, leave them alone. If only one is
 	 * sortable, move the non-sortable item towards the end of the list.
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 55819785941c..1d9d6095e5ce 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -72,7 +72,7 @@ struct xfs_item_ops {
 	void (*iop_format)(struct xfs_log_item *, struct xfs_log_vec *);
 	void (*iop_pin)(struct xfs_log_item *);
 	void (*iop_unpin)(struct xfs_log_item *, int remove);
-	uint64_t (*iop_sort)(struct xfs_log_item *lip);
+	uint64_t (*iop_sort)(const struct xfs_log_item *lip);
 	int (*iop_precommit)(struct xfs_trans *tp, struct xfs_log_item *lip);
 	void (*iop_committing)(struct xfs_log_item *lip, xfs_csn_t seq);
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
-- 
2.35.1

