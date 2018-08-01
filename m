Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:59474 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389397AbeHAPFj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Aug 2018 11:05:39 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 752A48185924
        for <linux-xfs@vger.kernel.org>; Wed,  1 Aug 2018 13:19:53 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61D982026D68
        for <linux-xfs@vger.kernel.org>; Wed,  1 Aug 2018 13:19:53 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 09/15] xfs: drop dop param from xfs_defer_op_type ->finish_item() callback
Date: Wed,  1 Aug 2018 09:19:46 -0400
Message-Id: <20180801131952.60250-10-bfoster@redhat.com>
In-Reply-To: <20180801131952.60250-1-bfoster@redhat.com>
References: <20180801131952.60250-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The dfops infrastructure ->finish_item() callback passes the
transaction and dfops as separate parameters. Since dfops is always
part of a transaction, the latter parameter is no longer necessary.
Remove it from the various callbacks.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c     |  2 --
 fs/xfs/libxfs/xfs_bmap.h     |  6 +++---
 fs/xfs/libxfs/xfs_defer.c    |  2 +-
 fs/xfs/libxfs/xfs_defer.h    |  4 ++--
 fs/xfs/libxfs/xfs_refcount.c |  2 +-
 fs/xfs/libxfs/xfs_refcount.h |  7 +++----
 fs/xfs/xfs_bmap_item.c       |  5 ++---
 fs/xfs/xfs_refcount_item.c   |  4 ++--
 fs/xfs/xfs_trans.h           | 10 +++++-----
 fs/xfs/xfs_trans_bmap.c      |  6 ++----
 fs/xfs/xfs_trans_extfree.c   |  2 --
 fs/xfs/xfs_trans_refcount.c  |  6 ++----
 fs/xfs/xfs_trans_rmap.c      |  1 -
 13 files changed, 23 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5cd490dc891a..d20f541b7061 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6045,7 +6045,6 @@ xfs_bmap_unmap_extent(
 int
 xfs_bmap_finish_one(
 	struct xfs_trans		*tp,
-	struct xfs_defer_ops		*dfops,
 	struct xfs_inode		*ip,
 	enum xfs_bmap_intent_type	type,
 	int				whichfork,
@@ -6072,7 +6071,6 @@ xfs_bmap_finish_one(
 
 	switch (type) {
 	case XFS_BMAP_MAP:
-		ASSERT(dfops == tp->t_dfops);
 		error = xfs_bmapi_remap(tp, ip, startoff, *blockcount,
 				startblock, 0);
 		*blockcount = 0;
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 2e8555c1229a..9165a878edcd 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -252,9 +252,9 @@ struct xfs_bmap_intent {
 	struct xfs_bmbt_irec			bi_bmap;
 };
 
-int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_defer_ops *dfops,
-		struct xfs_inode *ip, enum xfs_bmap_intent_type type,
-		int whichfork, xfs_fileoff_t startoff, xfs_fsblock_t startblock,
+int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_inode *ip,
+		enum xfs_bmap_intent_type type, int whichfork,
+		xfs_fileoff_t startoff, xfs_fsblock_t startblock,
 		xfs_filblks_t *blockcount, xfs_exntst_t state);
 int	xfs_bmap_map_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
 		struct xfs_inode *ip, struct xfs_bmbt_irec *imap);
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 1e7073252a5e..66ef9341813b 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -371,7 +371,7 @@ xfs_defer_finish_noroll(
 		list_for_each_safe(li, n, &dfp->dfp_work) {
 			list_del(li);
 			dfp->dfp_count--;
-			error = dfp->dfp_type->finish_item(*tp, dop, li,
+			error = dfp->dfp_type->finish_item(*tp, li,
 					dfp->dfp_done, &state);
 			if (error == -EAGAIN) {
 				/*
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index bf1e9f78561e..0de7504e5651 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -50,8 +50,8 @@ struct xfs_defer_op_type {
 	unsigned int		max_items;
 	void (*abort_intent)(void *);
 	void *(*create_done)(struct xfs_trans *, void *, unsigned int);
-	int (*finish_item)(struct xfs_trans *, struct xfs_defer_ops *,
-			struct list_head *, void *, void **);
+	int (*finish_item)(struct xfs_trans *, struct list_head *, void *,
+			void **);
 	void (*finish_cleanup)(struct xfs_trans *, void *, int);
 	void (*cancel_item)(struct list_head *);
 	int (*diff_items)(void *, struct list_head *, struct list_head *);
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 4cbc2efb099e..86f297ca90cd 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1082,7 +1082,6 @@ xfs_refcount_finish_one_cleanup(
 int
 xfs_refcount_finish_one(
 	struct xfs_trans		*tp,
-	struct xfs_defer_ops		*dfops,
 	enum xfs_refcount_intent_type	type,
 	xfs_fsblock_t			startblock,
 	xfs_extlen_t			blockcount,
@@ -1091,6 +1090,7 @@ xfs_refcount_finish_one(
 	struct xfs_btree_cur		**pcur)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_defer_ops		*dfops = tp->t_dfops;
 	struct xfs_btree_cur		*rcur;
 	struct xfs_buf			*agbp = NULL;
 	int				error = 0;
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 5fef74412727..3b72c6dbf6ad 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -37,10 +37,9 @@ extern int xfs_refcount_decrease_extent(struct xfs_mount *mp,
 extern void xfs_refcount_finish_one_cleanup(struct xfs_trans *tp,
 		struct xfs_btree_cur *rcur, int error);
 extern int xfs_refcount_finish_one(struct xfs_trans *tp,
-		struct xfs_defer_ops *dfops, enum xfs_refcount_intent_type type,
-		xfs_fsblock_t startblock, xfs_extlen_t blockcount,
-		xfs_fsblock_t *new_fsb, xfs_extlen_t *new_len,
-		struct xfs_btree_cur **pcur);
+		enum xfs_refcount_intent_type type, xfs_fsblock_t startblock,
+		xfs_extlen_t blockcount, xfs_fsblock_t *new_fsb,
+		xfs_extlen_t *new_len, struct xfs_btree_cur **pcur);
 
 extern int xfs_refcount_find_shared(struct xfs_btree_cur *cur,
 		xfs_agblock_t agbno, xfs_extlen_t aglen, xfs_agblock_t *fbno,
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index b8a6be036cd7..e828e0b51814 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -475,9 +475,8 @@ xfs_bui_recover(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	count = bmap->me_len;
-	error = xfs_trans_log_finish_bmap_update(tp, budp, tp->t_dfops, type,
-			ip, whichfork, bmap->me_startoff,
-			bmap->me_startblock, &count, state);
+	error = xfs_trans_log_finish_bmap_update(tp, budp, type, ip, whichfork,
+			bmap->me_startoff, bmap->me_startblock, &count, state);
 	if (error)
 		goto err_inode;
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 4a417daae781..43c4ac374cba 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -479,8 +479,8 @@ xfs_cui_recover(
 			new_len = refc->pe_len;
 		} else
 			error = xfs_trans_log_finish_refcount_update(tp, cudp,
-				tp->t_dfops, type, refc->pe_startblock,
-				refc->pe_len, &new_fsb, &new_len, &rcur);
+				type, refc->pe_startblock, refc->pe_len,
+				&new_fsb, &new_len, &rcur);
 		if (error)
 			goto abort_error;
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 8665d45b82c6..299656dbf324 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -268,7 +268,7 @@ void xfs_refcount_update_init_defer_op(void);
 struct xfs_cud_log_item *xfs_trans_get_cud(struct xfs_trans *tp,
 		struct xfs_cui_log_item *cuip);
 int xfs_trans_log_finish_refcount_update(struct xfs_trans *tp,
-		struct xfs_cud_log_item *cudp, struct xfs_defer_ops *dfops,
+		struct xfs_cud_log_item *cudp,
 		enum xfs_refcount_intent_type type, xfs_fsblock_t startblock,
 		xfs_extlen_t blockcount, xfs_fsblock_t *new_fsb,
 		xfs_extlen_t *new_len, struct xfs_btree_cur **pcur);
@@ -280,9 +280,9 @@ void xfs_bmap_update_init_defer_op(void);
 struct xfs_bud_log_item *xfs_trans_get_bud(struct xfs_trans *tp,
 		struct xfs_bui_log_item *buip);
 int xfs_trans_log_finish_bmap_update(struct xfs_trans *tp,
-		struct xfs_bud_log_item *rudp, struct xfs_defer_ops *dfops,
-		enum xfs_bmap_intent_type type, struct xfs_inode *ip,
-		int whichfork, xfs_fileoff_t startoff, xfs_fsblock_t startblock,
-		xfs_filblks_t *blockcount, xfs_exntst_t state);
+		struct xfs_bud_log_item *rudp, enum xfs_bmap_intent_type type,
+		struct xfs_inode *ip, int whichfork, xfs_fileoff_t startoff,
+		xfs_fsblock_t startblock, xfs_filblks_t *blockcount,
+		xfs_exntst_t state);
 
 #endif	/* __XFS_TRANS_H__ */
diff --git a/fs/xfs/xfs_trans_bmap.c b/fs/xfs/xfs_trans_bmap.c
index a15a5cd867f9..741c558b2179 100644
--- a/fs/xfs/xfs_trans_bmap.c
+++ b/fs/xfs/xfs_trans_bmap.c
@@ -43,7 +43,6 @@ int
 xfs_trans_log_finish_bmap_update(
 	struct xfs_trans		*tp,
 	struct xfs_bud_log_item		*budp,
-	struct xfs_defer_ops		*dop,
 	enum xfs_bmap_intent_type	type,
 	struct xfs_inode		*ip,
 	int				whichfork,
@@ -54,7 +53,7 @@ xfs_trans_log_finish_bmap_update(
 {
 	int				error;
 
-	error = xfs_bmap_finish_one(tp, dop, ip, type, whichfork, startoff,
+	error = xfs_bmap_finish_one(tp, ip, type, whichfork, startoff,
 			startblock, blockcount, state);
 
 	/*
@@ -176,7 +175,6 @@ xfs_bmap_update_create_done(
 STATIC int
 xfs_bmap_update_finish_item(
 	struct xfs_trans		*tp,
-	struct xfs_defer_ops		*dop,
 	struct list_head		*item,
 	void				*done_item,
 	void				**state)
@@ -187,7 +185,7 @@ xfs_bmap_update_finish_item(
 
 	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
 	count = bmap->bi_bmap.br_blockcount;
-	error = xfs_trans_log_finish_bmap_update(tp, done_item, dop,
+	error = xfs_trans_log_finish_bmap_update(tp, done_item,
 			bmap->bi_type,
 			bmap->bi_owner, bmap->bi_whichfork,
 			bmap->bi_bmap.br_startoff,
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index bd66c76f55e6..855c0b651fd4 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -171,7 +171,6 @@ xfs_extent_free_create_done(
 STATIC int
 xfs_extent_free_finish_item(
 	struct xfs_trans		*tp,
-	struct xfs_defer_ops		*dop,
 	struct list_head		*item,
 	void				*done_item,
 	void				**state)
@@ -226,7 +225,6 @@ static const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 STATIC int
 xfs_agfl_free_finish_item(
 	struct xfs_trans		*tp,
-	struct xfs_defer_ops		*dop,
 	struct list_head		*item,
 	void				*done_item,
 	void				**state)
diff --git a/fs/xfs/xfs_trans_refcount.c b/fs/xfs/xfs_trans_refcount.c
index 46dd4fca8aa7..523c55663954 100644
--- a/fs/xfs/xfs_trans_refcount.c
+++ b/fs/xfs/xfs_trans_refcount.c
@@ -42,7 +42,6 @@ int
 xfs_trans_log_finish_refcount_update(
 	struct xfs_trans		*tp,
 	struct xfs_cud_log_item		*cudp,
-	struct xfs_defer_ops		*dop,
 	enum xfs_refcount_intent_type	type,
 	xfs_fsblock_t			startblock,
 	xfs_extlen_t			blockcount,
@@ -52,7 +51,7 @@ xfs_trans_log_finish_refcount_update(
 {
 	int				error;
 
-	error = xfs_refcount_finish_one(tp, dop, type, startblock,
+	error = xfs_refcount_finish_one(tp, type, startblock,
 			blockcount, new_fsb, new_len, pcur);
 
 	/*
@@ -169,7 +168,6 @@ xfs_refcount_update_create_done(
 STATIC int
 xfs_refcount_update_finish_item(
 	struct xfs_trans		*tp,
-	struct xfs_defer_ops		*dop,
 	struct list_head		*item,
 	void				*done_item,
 	void				**state)
@@ -180,7 +178,7 @@ xfs_refcount_update_finish_item(
 	int				error;
 
 	refc = container_of(item, struct xfs_refcount_intent, ri_list);
-	error = xfs_trans_log_finish_refcount_update(tp, done_item, dop,
+	error = xfs_trans_log_finish_refcount_update(tp, done_item,
 			refc->ri_type,
 			refc->ri_startblock,
 			refc->ri_blockcount,
diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
index 726d8e2c0558..05b00e40251f 100644
--- a/fs/xfs/xfs_trans_rmap.c
+++ b/fs/xfs/xfs_trans_rmap.c
@@ -193,7 +193,6 @@ xfs_rmap_update_create_done(
 STATIC int
 xfs_rmap_update_finish_item(
 	struct xfs_trans		*tp,
-	struct xfs_defer_ops		*dop,
 	struct list_head		*item,
 	void				*done_item,
 	void				**state)
-- 
2.17.1

