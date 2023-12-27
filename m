Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9567EE
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qt38J1VR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3746C433C7;
	Mon,  1 Jan 2024 00:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068878;
	bh=zWcDwHoxabq/9b/Vr1ag4Lh+y+TPix4wOfG8ToNY4Uw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qt38J1VRIbY/n7trjvibBsiec3SiMdd9lVSiLMxEXJB6Q4TmRQB6ksN6wyuXq9Qae
	 1za7JRwQWTl+rZw2iiMbX0I2aTooVxkmOKAJICODE594zonHBI5OjoKV9Qu1R0xZFB
	 whnIhcUa6/WOFb3iKQnB7BIEnmcUG5TT1qxF7x9gzeAcHc6d8anh4xuzwsB1Uh8wZO
	 qzKv/Z3wp0y6atfdNXqNLEYF200tBrBxVwc07ex2a7VOmF1qme5bkWITfpvF+gHJr8
	 8dZxK/ixXPGurpQzOCn7Gevf8PaJlvDdtHXg6LFChdGI1+uAK+KgLZjVD91wivqoPy
	 MlV4Aqvy1sQkA==
Date: Sun, 31 Dec 2023 16:27:58 +9900
Subject: [PATCH 07/42] xfs: add a realtime flag to the refcount update log
 redo items
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017219.1817107.14187908448709516964.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Extend the refcount update (CUI) log items with a new realtime flag that
indicates that the updates apply against the realtime refcountbt.  We'll
wire up the actual refcount code later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c     |  101 ++++++++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_bmap.c       |   10 +++--
 libxfs/xfs_defer.h      |    1 
 libxfs/xfs_log_format.h |    6 ++-
 libxfs/xfs_refcount.c   |   71 ++++++++++++++++++++++++---------
 libxfs/xfs_refcount.h   |   22 +++++++---
 6 files changed, 176 insertions(+), 35 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 3956a38b414..d553b42d77e 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -538,8 +538,22 @@ xfs_refcount_defer_add(
 
 	trace_xfs_refcount_defer(mp, ri);
 
-	ri->ri_pag = xfs_perag_intent_get(mp, ri->ri_startblock);
-	xfs_defer_add(tp, &ri->ri_list, &xfs_refcount_update_defer_type);
+	/*
+	 * Deferred refcount updates for the realtime and data sections must
+	 * use separate transactions to finish deferred work because updates to
+	 * realtime metadata files can lock AGFs to allocate btree blocks and
+	 * we don't want that mixing with the AGF locks taken to finish data
+	 * section updates.
+	 */
+	if (ri->ri_realtime) {
+		ri->ri_rtg = xfs_rtgroup_intent_get(mp, ri->ri_startblock);
+		xfs_defer_add(tp, &ri->ri_list,
+				&xfs_rtrefcount_update_defer_type);
+	} else {
+		ri->ri_pag = xfs_perag_intent_get(mp, ri->ri_startblock);
+		xfs_defer_add(tp, &ri->ri_list,
+				&xfs_refcount_update_defer_type);
+	}
 }
 
 /* Cancel a deferred refcount update. */
@@ -611,6 +625,89 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.cancel_item	= xfs_refcount_update_cancel_item,
 };
 
+/* Sort refcount intents by rtgroup. */
+static int
+xfs_rtrefcount_update_diff_items(
+	void					*priv,
+	const struct list_head			*a,
+	const struct list_head			*b)
+{
+	struct xfs_refcount_intent		*ra = ci_entry(a);
+	struct xfs_refcount_intent		*rb = ci_entry(b);
+
+	return ra->ri_rtg->rtg_rgno - rb->ri_rtg->rtg_rgno;
+}
+
+static struct xfs_log_item *
+xfs_rtrefcount_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+
+	if (sort)
+		list_sort(mp, items, xfs_rtrefcount_update_diff_items);
+	return NULL;
+}
+
+/* Cancel a deferred realtime refcount update. */
+STATIC void
+xfs_rtrefcount_update_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_refcount_intent	*ri = ci_entry(item);
+
+	xfs_rtgroup_intent_put(ri->ri_rtg);
+	kmem_cache_free(xfs_refcount_intent_cache, ri);
+}
+
+/* Process a deferred realtime refcount update. */
+STATIC int
+xfs_rtrefcount_update_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_refcount_intent	*ri = ci_entry(item);
+	int				error;
+
+	error = xfs_rtrefcount_finish_one(tp, ri, state);
+
+	/* Did we run out of reservation?  Requeue what we didn't finish. */
+	if (!error && ri->ri_blockcount > 0) {
+		ASSERT(ri->ri_type == XFS_REFCOUNT_INCREASE ||
+		       ri->ri_type == XFS_REFCOUNT_DECREASE);
+		return -EAGAIN;
+	}
+
+	xfs_rtrefcount_update_cancel_item(item);
+	return error;
+}
+
+/* Clean up after calling xfs_rtrefcount_finish_one. */
+STATIC void
+xfs_rtrefcount_finish_one_cleanup(
+	struct xfs_trans	*tp,
+	struct xfs_btree_cur	*rcur,
+	int			error)
+{
+	if (rcur)
+		xfs_btree_del_cursor(rcur, error);
+}
+
+const struct xfs_defer_op_type xfs_rtrefcount_update_defer_type = {
+	.name		= "rtrefcount",
+	.create_intent	= xfs_rtrefcount_update_create_intent,
+	.abort_intent	= xfs_refcount_update_abort_intent,
+	.create_done	= xfs_refcount_update_create_done,
+	.finish_item	= xfs_rtrefcount_update_finish_item,
+	.finish_cleanup = xfs_rtrefcount_finish_one_cleanup,
+	.cancel_item	= xfs_rtrefcount_update_cancel_item,
+};
+
 /* Inode Block Mapping */
 
 static inline struct xfs_bmap_intent *bi_entry(const struct list_head *e)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index b84d1ad57f1..31129fb4884 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4486,8 +4486,9 @@ xfs_bmapi_write(
 			 * the refcount btree for orphan recovery.
 			 */
 			if (whichfork == XFS_COW_FORK)
-				xfs_refcount_alloc_cow_extent(tp, bma.blkno,
-						bma.length);
+				xfs_refcount_alloc_cow_extent(tp,
+						XFS_IS_REALTIME_INODE(ip),
+						bma.blkno, bma.length);
 		}
 
 		/* Deal with the allocated space we found.  */
@@ -4653,7 +4654,8 @@ xfs_bmapi_convert_delalloc(
 	*seq = READ_ONCE(ifp->if_seq);
 
 	if (whichfork == XFS_COW_FORK)
-		xfs_refcount_alloc_cow_extent(tp, bma.blkno, bma.length);
+		xfs_refcount_alloc_cow_extent(tp, XFS_IS_REALTIME_INODE(ip),
+				bma.blkno, bma.length);
 
 	error = xfs_bmap_btree_to_extents(tp, ip, bma.cur, &bma.logflags,
 			whichfork);
@@ -5265,7 +5267,7 @@ xfs_bmap_del_extent_real(
 	 */
 	if (want_free) {
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
-			xfs_refcount_decrease_extent(tp, del);
+			xfs_refcount_decrease_extent(tp, isrt, del);
 		} else {
 			unsigned int	efi_flags = 0;
 
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index fddcb4cccbc..a351f00e6d7 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -68,6 +68,7 @@ struct xfs_defer_op_type {
 
 extern const struct xfs_defer_op_type xfs_bmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
+extern const struct xfs_defer_op_type xfs_rtrefcount_update_defer_type;
 extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_rtrmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index ea4e88d6657..a888e3d98a3 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -252,6 +252,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_EFD_RT		0x124b	/* realtime extent free done */
 #define	XFS_LI_RUI_RT		0x124c	/* realtime rmap update intent */
 #define	XFS_LI_RUD_RT		0x124d	/* realtime rmap update done */
+#define	XFS_LI_CUI_RT		0x124e	/* realtime refcount update intent */
+#define	XFS_LI_CUD_RT		0x124f	/* realtime refcount update done */
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -275,7 +277,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_EFI_RT,	"XFS_LI_EFI_RT" }, \
 	{ XFS_LI_EFD_RT,	"XFS_LI_EFD_RT" }, \
 	{ XFS_LI_RUI_RT,	"XFS_LI_RUI_RT" }, \
-	{ XFS_LI_RUD_RT,	"XFS_LI_RUD_RT" }
+	{ XFS_LI_RUD_RT,	"XFS_LI_RUD_RT" }, \
+	{ XFS_LI_CUI_RT,	"XFS_LI_CUI_RT" }, \
+	{ XFS_LI_CUD_RT,	"XFS_LI_CUD_RT" }
 
 /*
  * Inode Log Item Format definitions.
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 2202d9cfb37..d4ed0f44fa1 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1141,6 +1141,28 @@ xfs_refcount_still_have_space(
 		xrefc_btree_state(cur)->nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
 }
 
+/* Schedule an extent free. */
+static int
+xrefc_free_extent(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*rec)
+{
+	xfs_fsblock_t			fsbno;
+	unsigned int			flags = 0;
+
+	if (cur->bc_btnum == XFS_BTNUM_RTREFC) {
+		flags |= XFS_FREE_EXTENT_REALTIME;
+		fsbno = xfs_rgbno_to_rtb(cur->bc_mp, cur->bc_ino.rtg->rtg_rgno,
+				rec->rc_startblock);
+	} else {
+		fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno,
+				rec->rc_startblock);
+	}
+
+	return xfs_free_extent_later(cur->bc_tp, fsbno, rec->rc_blockcount,
+			NULL, XFS_AG_RESV_NONE, flags);
+}
+
 /*
  * Adjust the refcounts of middle extents.  At this point we should have
  * split extents that crossed the adjustment range; merged with adjacent
@@ -1157,7 +1179,6 @@ xfs_refcount_adjust_extents(
 	struct xfs_refcount_irec	ext, tmp;
 	int				error;
 	int				found_rec, found_tmp;
-	xfs_fsblock_t			fsbno;
 
 	/* Merging did all the work already. */
 	if (*aglen == 0)
@@ -1210,12 +1231,7 @@ xfs_refcount_adjust_extents(
 					goto out_error;
 				}
 			} else {
-				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
-						cur->bc_ag.pag->pag_agno,
-						tmp.rc_startblock);
-				error = xfs_free_extent_later(cur->bc_tp, fsbno,
-						  tmp.rc_blockcount, NULL,
-						  XFS_AG_RESV_NONE, 0);
+				error = xrefc_free_extent(cur, &tmp);
 				if (error)
 					goto out_error;
 			}
@@ -1273,12 +1289,7 @@ xfs_refcount_adjust_extents(
 			}
 			goto advloop;
 		} else {
-			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
-					cur->bc_ag.pag->pag_agno,
-					ext.rc_startblock);
-			error = xfs_free_extent_later(cur->bc_tp, fsbno,
-					ext.rc_blockcount, NULL,
-					XFS_AG_RESV_NONE, 0);
+			error = xrefc_free_extent(cur, &ext);
 			if (error)
 				goto out_error;
 		}
@@ -1473,6 +1484,20 @@ xfs_refcount_finish_one(
 	return error;
 }
 
+/*
+ * Process one of the deferred realtime refcount operations.  We pass back the
+ * btree cursor to maintain our lock on the btree between calls.
+ */
+int
+xfs_rtrefcount_finish_one(
+	struct xfs_trans		*tp,
+	struct xfs_refcount_intent	*ri,
+	struct xfs_btree_cur		**pcur)
+{
+	ASSERT(0);
+	return -EFSCORRUPTED;
+}
+
 /*
  * Record a refcount intent for later processing.
  */
@@ -1480,6 +1505,7 @@ static void
 __xfs_refcount_add(
 	struct xfs_trans		*tp,
 	enum xfs_refcount_intent_type	type,
+	bool				isrt,
 	xfs_fsblock_t			startblock,
 	xfs_extlen_t			blockcount)
 {
@@ -1491,6 +1517,7 @@ __xfs_refcount_add(
 	ri->ri_type = type;
 	ri->ri_startblock = startblock;
 	ri->ri_blockcount = blockcount;
+	ri->ri_realtime = isrt;
 
 	xfs_refcount_defer_add(tp, ri);
 }
@@ -1501,12 +1528,13 @@ __xfs_refcount_add(
 void
 xfs_refcount_increase_extent(
 	struct xfs_trans		*tp,
+	bool				isrt,
 	struct xfs_bmbt_irec		*PREV)
 {
 	if (!xfs_has_reflink(tp->t_mountp))
 		return;
 
-	__xfs_refcount_add(tp, XFS_REFCOUNT_INCREASE, PREV->br_startblock,
+	__xfs_refcount_add(tp, XFS_REFCOUNT_INCREASE, isrt, PREV->br_startblock,
 			PREV->br_blockcount);
 }
 
@@ -1516,12 +1544,13 @@ xfs_refcount_increase_extent(
 void
 xfs_refcount_decrease_extent(
 	struct xfs_trans		*tp,
+	bool				isrt,
 	struct xfs_bmbt_irec		*PREV)
 {
 	if (!xfs_has_reflink(tp->t_mountp))
 		return;
 
-	__xfs_refcount_add(tp, XFS_REFCOUNT_DECREASE, PREV->br_startblock,
+	__xfs_refcount_add(tp, XFS_REFCOUNT_DECREASE, isrt, PREV->br_startblock,
 			PREV->br_blockcount);
 }
 
@@ -1877,6 +1906,7 @@ __xfs_refcount_cow_free(
 void
 xfs_refcount_alloc_cow_extent(
 	struct xfs_trans		*tp,
+	bool				isrt,
 	xfs_fsblock_t			fsb,
 	xfs_extlen_t			len)
 {
@@ -1885,16 +1915,17 @@ xfs_refcount_alloc_cow_extent(
 	if (!xfs_has_reflink(mp))
 		return;
 
-	__xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
+	__xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, isrt, fsb, len);
 
 	/* Add rmap entry */
-	xfs_rmap_alloc_extent(tp, false, fsb, len, XFS_RMAP_OWN_COW);
+	xfs_rmap_alloc_extent(tp, isrt, fsb, len, XFS_RMAP_OWN_COW);
 }
 
 /* Forget a CoW staging event in the refcount btree. */
 void
 xfs_refcount_free_cow_extent(
 	struct xfs_trans		*tp,
+	bool				isrt,
 	xfs_fsblock_t			fsb,
 	xfs_extlen_t			len)
 {
@@ -1904,8 +1935,8 @@ xfs_refcount_free_cow_extent(
 		return;
 
 	/* Remove rmap entry */
-	xfs_rmap_free_extent(tp, false, fsb, len, XFS_RMAP_OWN_COW);
-	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
+	xfs_rmap_free_extent(tp, isrt, fsb, len, XFS_RMAP_OWN_COW);
+	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, isrt, fsb, len);
 }
 
 struct xfs_refcount_recovery {
@@ -2012,7 +2043,7 @@ xfs_refcount_recover_cow_leftovers(
 		/* Free the orphan record */
 		fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno,
 				rr->rr_rrec.rc_startblock);
-		xfs_refcount_free_cow_extent(tp, fsb,
+		xfs_refcount_free_cow_extent(tp, false, fsb,
 				rr->rr_rrec.rc_blockcount);
 
 		/* Free the block. */
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 13344b402a7..56e5834feb6 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -57,10 +57,14 @@ enum xfs_refcount_intent_type {
 
 struct xfs_refcount_intent {
 	struct list_head			ri_list;
-	struct xfs_perag			*ri_pag;
+	union {
+		struct xfs_perag		*ri_pag;
+		struct xfs_rtgroup		*ri_rtg;
+	};
 	enum xfs_refcount_intent_type		ri_type;
 	xfs_extlen_t				ri_blockcount;
 	xfs_fsblock_t				ri_startblock;
+	bool					ri_realtime;
 };
 
 /* Check that the refcount is appropriate for the record domain. */
@@ -75,22 +79,24 @@ xfs_refcount_check_domain(
 	return true;
 }
 
-void xfs_refcount_increase_extent(struct xfs_trans *tp,
+void xfs_refcount_increase_extent(struct xfs_trans *tp, bool isrt,
 		struct xfs_bmbt_irec *irec);
-void xfs_refcount_decrease_extent(struct xfs_trans *tp,
+void xfs_refcount_decrease_extent(struct xfs_trans *tp, bool isrt,
 		struct xfs_bmbt_irec *irec);
 
-extern int xfs_refcount_finish_one(struct xfs_trans *tp,
+int xfs_refcount_finish_one(struct xfs_trans *tp,
+		struct xfs_refcount_intent *ri, struct xfs_btree_cur **pcur);
+int xfs_rtrefcount_finish_one(struct xfs_trans *tp,
 		struct xfs_refcount_intent *ri, struct xfs_btree_cur **pcur);
 
 extern int xfs_refcount_find_shared(struct xfs_btree_cur *cur,
 		xfs_agblock_t agbno, xfs_extlen_t aglen, xfs_agblock_t *fbno,
 		xfs_extlen_t *flen, bool find_end_of_shared);
 
-void xfs_refcount_alloc_cow_extent(struct xfs_trans *tp, xfs_fsblock_t fsb,
-		xfs_extlen_t len);
-void xfs_refcount_free_cow_extent(struct xfs_trans *tp, xfs_fsblock_t fsb,
-		xfs_extlen_t len);
+void xfs_refcount_alloc_cow_extent(struct xfs_trans *tp, bool isrt,
+		xfs_fsblock_t fsb, xfs_extlen_t len);
+void xfs_refcount_free_cow_extent(struct xfs_trans *tp, bool isrt,
+		xfs_fsblock_t fsb, xfs_extlen_t len);
 extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
 		struct xfs_perag *pag);
 

