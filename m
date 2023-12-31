Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07CCBA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h3m0pGgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BEFDC433C7;
	Sun, 31 Dec 2023 21:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058433;
	bh=PI1WlxA7XD3kit4u2A+en4NnxQBdh3mXCTmK48MN01I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=h3m0pGgN7FTNJdlcoAlK2QGh2+9SUi6u/VgPUyoT+JJGMD1ELLGmCAwPGEW/OMhGj
	 T76KMygTiUN21MAmM+XbrtSDfygJjPFw5g41a91oFIQqJtB9wL1jYqk7ZxT4rZlmpu
	 9VKQKb3IKw3GSvVsSUv0vWw00Eytd7pJAEn/3ztNkGVGfv4xG4nt4OPkhvmDs46OS+
	 Lofx1sW1Cy+ydxHzVp3cbw07210O8DSn1uklIavX26sY/s8/fePpq196hdZH1S/d+6
	 +OqLN6j8pBXiu1ukcPEi+qaJSHI0mxbCyCGk04czxn9R9bVmYjWEM+34uY2RFUGDsc
	 BPeXv3R6cSwTg==
Date: Sun, 31 Dec 2023 13:33:52 -0800
Subject: [PATCH 08/39] xfs: add a realtime flag to the rmap update log redo
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850030.1764998.6821619909784140893.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

Extend the rmap update (RUI) log items with a new realtime flag that
indicates that the updates apply against the realtime rmapbt.  We'll
wire up the actual rmap code later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.h       |    1 
 fs/xfs/libxfs/xfs_log_format.h  |    6 +
 fs/xfs/libxfs/xfs_log_recover.h |    2 
 fs/xfs/libxfs/xfs_refcount.c    |    4 -
 fs/xfs/libxfs/xfs_rmap.c        |   32 ++++-
 fs/xfs/libxfs/xfs_rmap.h        |   12 +-
 fs/xfs/scrub/alloc_repair.c     |    2 
 fs/xfs/xfs_log_recover.c        |    2 
 fs/xfs/xfs_rmap_item.c          |  237 +++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_trace.h              |   23 +++-
 10 files changed, 293 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index b4e1c386768c9..fddcb4cccbcc2 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -69,6 +69,7 @@ struct xfs_defer_op_type {
 extern const struct xfs_defer_op_type xfs_bmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
 extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
+extern const struct xfs_defer_op_type xfs_rtrmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
 extern const struct xfs_defer_op_type xfs_rtextent_free_defer_type;
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 1f5fe4a588eca..ea4e88d665707 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -250,6 +250,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_SXD		0x1249  /* extent swap done */
 #define	XFS_LI_EFI_RT		0x124a	/* realtime extent free intent */
 #define	XFS_LI_EFD_RT		0x124b	/* realtime extent free done */
+#define	XFS_LI_RUI_RT		0x124c	/* realtime rmap update intent */
+#define	XFS_LI_RUD_RT		0x124d	/* realtime rmap update done */
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -271,7 +273,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_SXI,		"XFS_LI_SXI" }, \
 	{ XFS_LI_SXD,		"XFS_LI_SXD" }, \
 	{ XFS_LI_EFI_RT,	"XFS_LI_EFI_RT" }, \
-	{ XFS_LI_EFD_RT,	"XFS_LI_EFD_RT" }
+	{ XFS_LI_EFD_RT,	"XFS_LI_EFD_RT" }, \
+	{ XFS_LI_RUI_RT,	"XFS_LI_RUI_RT" }, \
+	{ XFS_LI_RUD_RT,	"XFS_LI_RUD_RT" }
 
 /*
  * Inode Log Item Format definitions.
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 811c37026d251..433974693d10b 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -79,6 +79,8 @@ extern const struct xlog_recover_item_ops xlog_sxi_item_ops;
 extern const struct xlog_recover_item_ops xlog_sxd_item_ops;
 extern const struct xlog_recover_item_ops xlog_rtefi_item_ops;
 extern const struct xlog_recover_item_ops xlog_rtefd_item_ops;
+extern const struct xlog_recover_item_ops xlog_rtrui_item_ops;
+extern const struct xlog_recover_item_ops xlog_rtrud_item_ops;
 
 /*
  * Macros, structures, prototypes for internal log manager use.
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 6f7ec83281656..7f4433b2a5dd3 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1887,7 +1887,7 @@ xfs_refcount_alloc_cow_extent(
 	__xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
 
 	/* Add rmap entry */
-	xfs_rmap_alloc_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
+	xfs_rmap_alloc_extent(tp, false, fsb, len, XFS_RMAP_OWN_COW);
 }
 
 /* Forget a CoW staging event in the refcount btree. */
@@ -1903,7 +1903,7 @@ xfs_refcount_free_cow_extent(
 		return;
 
 	/* Remove rmap entry */
-	xfs_rmap_free_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
+	xfs_rmap_free_extent(tp, false, fsb, len, XFS_RMAP_OWN_COW);
 	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
 }
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 35df4e832996e..daef2d67eb7a0 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2682,6 +2682,21 @@ xfs_rmap_finish_one(
 	return 0;
 }
 
+/*
+ * Process one of the deferred realtime rmap operations.  We pass back the
+ * btree cursor to reduce overhead.
+ */
+int
+xfs_rtrmap_finish_one(
+	struct xfs_trans		*tp,
+	struct xfs_rmap_intent		*ri,
+	struct xfs_btree_cur		**pcur)
+{
+	/* coming in a subsequent patch */
+	ASSERT(0);
+	return -EFSCORRUPTED;
+}
+
 /*
  * Don't defer an rmap if we aren't an rmap filesystem.
  */
@@ -2702,6 +2717,7 @@ __xfs_rmap_add(
 	struct xfs_trans		*tp,
 	enum xfs_rmap_intent_type	type,
 	uint64_t			owner,
+	bool				isrt,
 	int				whichfork,
 	struct xfs_bmbt_irec		*bmap)
 {
@@ -2713,6 +2729,7 @@ __xfs_rmap_add(
 	ri->ri_owner = owner;
 	ri->ri_whichfork = whichfork;
 	ri->ri_bmap = *bmap;
+	ri->ri_realtime = isrt;
 
 	xfs_rmap_defer_add(tp, ri);
 }
@@ -2726,6 +2743,7 @@ xfs_rmap_map_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	enum xfs_rmap_intent_type type = XFS_RMAP_MAP;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
 
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, whichfork))
 		return;
@@ -2733,7 +2751,7 @@ xfs_rmap_map_extent(
 	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
 		type = XFS_RMAP_MAP_SHARED;
 
-	__xfs_rmap_add(tp, type, ip->i_ino, whichfork, PREV);
+	__xfs_rmap_add(tp, type, ip->i_ino, isrt, whichfork, PREV);
 }
 
 /* Unmap an extent out of a file. */
@@ -2745,6 +2763,7 @@ xfs_rmap_unmap_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	enum xfs_rmap_intent_type type = XFS_RMAP_UNMAP;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
 
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, whichfork))
 		return;
@@ -2752,7 +2771,7 @@ xfs_rmap_unmap_extent(
 	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
 		type = XFS_RMAP_UNMAP_SHARED;
 
-	__xfs_rmap_add(tp, type, ip->i_ino, whichfork, PREV);
+	__xfs_rmap_add(tp, type, ip->i_ino, isrt, whichfork, PREV);
 }
 
 /*
@@ -2770,6 +2789,7 @@ xfs_rmap_convert_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	enum xfs_rmap_intent_type type = XFS_RMAP_CONVERT;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
 
 	if (!xfs_rmap_update_is_needed(mp, whichfork))
 		return;
@@ -2777,13 +2797,14 @@ xfs_rmap_convert_extent(
 	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
 		type = XFS_RMAP_CONVERT_SHARED;
 
-	__xfs_rmap_add(tp, type, ip->i_ino, whichfork, PREV);
+	__xfs_rmap_add(tp, type, ip->i_ino, isrt, whichfork, PREV);
 }
 
 /* Schedule the creation of an rmap for non-file data. */
 void
 xfs_rmap_alloc_extent(
 	struct xfs_trans	*tp,
+	bool			isrt,
 	xfs_fsblock_t		fsbno,
 	xfs_extlen_t		len,
 	uint64_t		owner)
@@ -2798,13 +2819,14 @@ xfs_rmap_alloc_extent(
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
 
-	__xfs_rmap_add(tp, XFS_RMAP_ALLOC, owner, XFS_DATA_FORK, &bmap);
+	__xfs_rmap_add(tp, XFS_RMAP_ALLOC, owner, isrt, XFS_DATA_FORK, &bmap);
 }
 
 /* Schedule the deletion of an rmap for non-file data. */
 void
 xfs_rmap_free_extent(
 	struct xfs_trans	*tp,
+	bool			isrt,
 	xfs_fsblock_t		fsbno,
 	xfs_extlen_t		len,
 	uint64_t		owner)
@@ -2819,7 +2841,7 @@ xfs_rmap_free_extent(
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
 
-	__xfs_rmap_add(tp, XFS_RMAP_FREE, owner, XFS_DATA_FORK, &bmap);
+	__xfs_rmap_add(tp, XFS_RMAP_FREE, owner, isrt, XFS_DATA_FORK, &bmap);
 }
 
 /* Compare rmap records.  Returns -1 if a < b, 1 if a > b, and 0 if equal. */
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 762f2f40b6e47..3719fc4cbc26b 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -174,7 +174,11 @@ struct xfs_rmap_intent {
 	int					ri_whichfork;
 	uint64_t				ri_owner;
 	struct xfs_bmbt_irec			ri_bmap;
-	struct xfs_perag			*ri_pag;
+	union {
+		struct xfs_perag		*ri_pag;
+		struct xfs_rtgroup		*ri_rtg;
+	};
+	bool					ri_realtime;
 };
 
 /* functions for updating the rmapbt based on bmbt map/unmap operations */
@@ -185,11 +189,13 @@ void xfs_rmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 void xfs_rmap_convert_extent(struct xfs_mount *mp, struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *imap);
-void xfs_rmap_alloc_extent(struct xfs_trans *tp, xfs_fsblock_t fsbno,
+void xfs_rmap_alloc_extent(struct xfs_trans *tp, bool isrt, xfs_fsblock_t fsbno,
 		xfs_extlen_t len, uint64_t owner);
-void xfs_rmap_free_extent(struct xfs_trans *tp, xfs_fsblock_t fsbno,
+void xfs_rmap_free_extent(struct xfs_trans *tp, bool isrt, xfs_fsblock_t fsbno,
 		xfs_extlen_t len, uint64_t owner);
 
+int xfs_rtrmap_finish_one(struct xfs_trans *tp, struct xfs_rmap_intent *ri,
+		struct xfs_btree_cur **pcur);
 int xfs_rmap_finish_one(struct xfs_trans *tp, struct xfs_rmap_intent *ri,
 		struct xfs_btree_cur **pcur);
 int __xfs_rmap_finish_intent(struct xfs_btree_cur *rcur,
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index 3805099cb578b..d4ea1afb238a0 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -546,7 +546,7 @@ xrep_abt_dispose_one(
 		xfs_fsblock_t	fsbno;
 
 		fsbno = XFS_AGB_TO_FSB(sc->mp, pag->pag_agno, resv->agbno);
-		xfs_rmap_alloc_extent(sc->tp, fsbno, resv->used,
+		xfs_rmap_alloc_extent(sc->tp, false, fsbno, resv->used,
 				XFS_RMAP_OWN_AG);
 	}
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0aeca77d511d0..1efb69fcadf10 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1795,6 +1795,8 @@ static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
 	&xlog_sxd_item_ops,
 	&xlog_rtefi_item_ops,
 	&xlog_rtefd_item_ops,
+	&xlog_rtrui_item_ops,
+	&xlog_rtrud_item_ops,
 };
 
 static const struct xlog_recover_item_ops *
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index e2ee1b6719202..229b5127d4716 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -23,6 +23,7 @@
 #include "xfs_ag.h"
 #include "xfs_btree.h"
 #include "xfs_trace.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_rui_cache;
 struct kmem_cache	*xfs_rud_cache;
@@ -94,7 +95,9 @@ xfs_rui_item_format(
 	ASSERT(atomic_read(&ruip->rui_next_extent) ==
 			ruip->rui_format.rui_nextents);
 
-	ruip->rui_format.rui_type = XFS_LI_RUI;
+	ASSERT(lip->li_type == XFS_LI_RUI || lip->li_type == XFS_LI_RUI_RT);
+
+	ruip->rui_format.rui_type = lip->li_type;
 	ruip->rui_format.rui_size = 1;
 
 	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_RUI_FORMAT, &ruip->rui_format,
@@ -137,19 +140,22 @@ xfs_rui_item_release(
 STATIC struct xfs_rui_log_item *
 xfs_rui_init(
 	struct xfs_mount		*mp,
+	unsigned short			item_type,
 	uint				nextents)
 
 {
 	struct xfs_rui_log_item		*ruip;
 
 	ASSERT(nextents > 0);
+	ASSERT(item_type == XFS_LI_RUI || item_type == XFS_LI_RUI_RT);
+
 	if (nextents > XFS_RUI_MAX_FAST_EXTENTS)
 		ruip = kmem_zalloc(xfs_rui_log_item_sizeof(nextents), 0);
 	else
 		ruip = kmem_cache_zalloc(xfs_rui_cache,
 					 GFP_KERNEL | __GFP_NOFAIL);
 
-	xfs_log_item_init(mp, &ruip->rui_item, XFS_LI_RUI, &xfs_rui_item_ops);
+	xfs_log_item_init(mp, &ruip->rui_item, item_type, &xfs_rui_item_ops);
 	ruip->rui_format.rui_nextents = nextents;
 	ruip->rui_format.rui_id = (uintptr_t)(void *)ruip;
 	atomic_set(&ruip->rui_next_extent, 0);
@@ -188,7 +194,9 @@ xfs_rud_item_format(
 	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
 	struct xfs_log_iovec	*vecp = NULL;
 
-	rudp->rud_format.rud_type = XFS_LI_RUD;
+	ASSERT(lip->li_type == XFS_LI_RUD || lip->li_type == XFS_LI_RUD_RT);
+
+	rudp->rud_format.rud_type = lip->li_type;
 	rudp->rud_format.rud_size = 1;
 
 	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_RUD_FORMAT, &rudp->rud_format,
@@ -232,6 +240,14 @@ static inline struct xfs_rmap_intent *ri_entry(const struct list_head *e)
 	return list_entry(e, struct xfs_rmap_intent, ri_list);
 }
 
+static inline bool
+xfs_rui_item_isrt(const struct xfs_log_item *lip)
+{
+	ASSERT(lip->li_type == XFS_LI_RUI || lip->li_type == XFS_LI_RUI_RT);
+
+	return lip->li_type == XFS_LI_RUI_RT;
+}
+
 /* Sort rmap intents by AG. */
 static int
 xfs_rmap_update_diff_items(
@@ -311,11 +327,12 @@ xfs_rmap_update_create_intent(
 	bool				sort)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_rui_log_item		*ruip = xfs_rui_init(mp, count);
+	struct xfs_rui_log_item		*ruip;
 	struct xfs_rmap_intent		*ri;
 
 	ASSERT(count > 0);
 
+	ruip = xfs_rui_init(mp, XFS_LI_RUI, count);
 	if (sort)
 		list_sort(mp, items, xfs_rmap_update_diff_items);
 	list_for_each_entry(ri, items, ri_list)
@@ -323,6 +340,12 @@ xfs_rmap_update_create_intent(
 	return &ruip->rui_item;
 }
 
+static inline unsigned short
+xfs_rud_type_from_rui(const struct xfs_rui_log_item *ruip)
+{
+	return xfs_rui_item_isrt(&ruip->rui_item) ? XFS_LI_RUD_RT : XFS_LI_RUD;
+}
+
 /* Get an RUD so we can process all the deferred rmap updates. */
 static struct xfs_log_item *
 xfs_rmap_update_create_done(
@@ -334,8 +357,8 @@ xfs_rmap_update_create_done(
 	struct xfs_rud_log_item		*rudp;
 
 	rudp = kmem_cache_zalloc(xfs_rud_cache, GFP_KERNEL | __GFP_NOFAIL);
-	xfs_log_item_init(tp->t_mountp, &rudp->rud_item, XFS_LI_RUD,
-			  &xfs_rud_item_ops);
+	xfs_log_item_init(tp->t_mountp, &rudp->rud_item,
+			xfs_rud_type_from_rui(ruip), &xfs_rud_item_ops);
 	rudp->rud_ruip = ruip;
 	rudp->rud_format.rud_rui_id = ruip->rui_format.rui_id;
 
@@ -352,8 +375,23 @@ xfs_rmap_defer_add(
 
 	trace_xfs_rmap_defer(mp, ri);
 
-	ri->ri_pag = xfs_perag_intent_get(mp, ri->ri_bmap.br_startblock);
-	xfs_defer_add(tp, &ri->ri_list, &xfs_rmap_update_defer_type);
+	/*
+	 * Deferred rmap updates for the realtime and data sections must use
+	 * separate transactions to finish deferred work because updates to
+	 * realtime metadata files can lock AGFs to allocate btree blocks and
+	 * we don't want that mixing with the AGF locks taken to finish data
+	 * section updates.
+	 */
+	if (ri->ri_realtime) {
+		xfs_rgnumber_t	rgno;
+
+		rgno = xfs_rtb_to_rgno(mp, ri->ri_bmap.br_startblock);
+		ri->ri_rtg = xfs_rtgroup_get(mp, rgno);
+		xfs_defer_add(tp, &ri->ri_list, &xfs_rtrmap_update_defer_type);
+	} else {
+		ri->ri_pag = xfs_perag_intent_get(mp, ri->ri_bmap.br_startblock);
+		xfs_defer_add(tp, &ri->ri_list, &xfs_rmap_update_defer_type);
+	}
 }
 
 /* Cancel a deferred rmap update. */
@@ -564,10 +602,12 @@ xfs_rmap_relog_intent(
 	struct xfs_map_extent		*map;
 	unsigned int			count;
 
+	ASSERT(intent->li_type == XFS_LI_RUI || intent->li_type == XFS_LI_RUI_RT);
+
 	count = RUI_ITEM(intent)->rui_format.rui_nextents;
 	map = RUI_ITEM(intent)->rui_format.rui_extents;
 
-	ruip = xfs_rui_init(tp->t_mountp, count);
+	ruip = xfs_rui_init(tp->t_mountp, intent->li_type, count);
 	memcpy(ruip->rui_format.rui_extents, map, count * sizeof(*map));
 	atomic_set(&ruip->rui_next_extent, count);
 
@@ -587,6 +627,98 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.relog_intent	= xfs_rmap_relog_intent,
 };
 
+#ifdef CONFIG_XFS_RT
+/* Sort rmap intents by rtgroup. */
+static int
+xfs_rtrmap_update_diff_items(
+	void				*priv,
+	const struct list_head		*a,
+	const struct list_head		*b)
+{
+	struct xfs_rmap_intent		*ra = ri_entry(a);
+	struct xfs_rmap_intent		*rb = ri_entry(b);
+
+	return ra->ri_rtg->rtg_rgno - rb->ri_rtg->rtg_rgno;
+}
+
+static struct xfs_log_item *
+xfs_rtrmap_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_rui_log_item		*ruip;
+	struct xfs_rmap_intent		*ri;
+
+	ASSERT(count > 0);
+
+	ruip = xfs_rui_init(mp, XFS_LI_RUI_RT, count);
+	if (sort)
+		list_sort(mp, items, xfs_rtrmap_update_diff_items);
+	list_for_each_entry(ri, items, ri_list)
+		xfs_rmap_update_log_item(tp, ruip, ri);
+	return &ruip->rui_item;
+}
+
+/* Cancel a deferred realtime rmap update. */
+STATIC void
+xfs_rtrmap_update_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_rmap_intent		*ri = ri_entry(item);
+
+	xfs_rtgroup_put(ri->ri_rtg);
+	kmem_cache_free(xfs_rmap_intent_cache, ri);
+}
+
+/* Process a deferred realtime rmap update. */
+STATIC int
+xfs_rtrmap_update_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_rmap_intent		*ri = ri_entry(item);
+	int				error;
+
+	error = xfs_rtrmap_finish_one(tp, ri, state);
+
+	xfs_rtrmap_update_cancel_item(item);
+	return error;
+}
+
+/* Clean up after calling xfs_rtrmap_finish_one. */
+STATIC void
+xfs_rtrmap_finish_one_cleanup(
+	struct xfs_trans	*tp,
+	struct xfs_btree_cur	*rcur,
+	int			error)
+{
+	if (rcur)
+		xfs_btree_del_cursor(rcur, error);
+}
+
+const struct xfs_defer_op_type xfs_rtrmap_update_defer_type = {
+	.name		= "rtrmap",
+	.max_items	= XFS_RUI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_rtrmap_update_create_intent,
+	.abort_intent	= xfs_rmap_update_abort_intent,
+	.create_done	= xfs_rmap_update_create_done,
+	.finish_item	= xfs_rtrmap_update_finish_item,
+	.finish_cleanup = xfs_rtrmap_finish_one_cleanup,
+	.cancel_item	= xfs_rtrmap_update_cancel_item,
+	.recover_work	= xfs_rmap_recover_work,
+	.relog_intent	= xfs_rmap_relog_intent,
+};
+#else
+const struct xfs_defer_op_type xfs_rtrmap_update_defer_type = {
+	.name		= "rtrmap",
+};
+#endif
+
 STATIC bool
 xfs_rui_item_match(
 	struct xfs_log_item	*lip,
@@ -652,7 +784,7 @@ xlog_recover_rui_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
-	ruip = xfs_rui_init(mp, rui_formatp->rui_nextents);
+	ruip = xfs_rui_init(mp, ITEM_TYPE(item), rui_formatp->rui_nextents);
 	xfs_rui_copy_format(&ruip->rui_format, rui_formatp);
 	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
 
@@ -666,6 +798,61 @@ const struct xlog_recover_item_ops xlog_rui_item_ops = {
 	.commit_pass2		= xlog_recover_rui_commit_pass2,
 };
 
+#ifdef CONFIG_XFS_RT
+STATIC int
+xlog_recover_rtrui_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_rui_log_item		*ruip;
+	struct xfs_rui_log_format	*rui_formatp;
+	size_t				len;
+
+	rui_formatp = item->ri_buf[0].i_addr;
+
+	if (item->ri_buf[0].i_len < xfs_rui_log_format_sizeof(0)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+		return -EFSCORRUPTED;
+	}
+
+	len = xfs_rui_log_format_sizeof(rui_formatp->rui_nextents);
+	if (item->ri_buf[0].i_len != len) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+		return -EFSCORRUPTED;
+	}
+
+	ruip = xfs_rui_init(mp, ITEM_TYPE(item), rui_formatp->rui_nextents);
+	xfs_rui_copy_format(&ruip->rui_format, rui_formatp);
+	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
+
+	xlog_recover_intent_item(log, &ruip->rui_item, lsn,
+			&xfs_rtrmap_update_defer_type);
+	return 0;
+}
+#else
+STATIC int
+xlog_recover_rtrui_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+			item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+	return -EFSCORRUPTED;
+}
+#endif
+
+const struct xlog_recover_item_ops xlog_rtrui_item_ops = {
+	.item_type		= XFS_LI_RUI_RT,
+	.commit_pass2		= xlog_recover_rtrui_commit_pass2,
+};
+
 /*
  * This routine is called when an RUD format structure is found in a committed
  * transaction in the log. Its purpose is to cancel the corresponding RUI if it
@@ -697,3 +884,33 @@ const struct xlog_recover_item_ops xlog_rud_item_ops = {
 	.item_type		= XFS_LI_RUD,
 	.commit_pass2		= xlog_recover_rud_commit_pass2,
 };
+
+#ifdef CONFIG_XFS_RT
+STATIC int
+xlog_recover_rtrud_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_rud_log_format	*rud_formatp;
+
+	rud_formatp = item->ri_buf[0].i_addr;
+	if (item->ri_buf[0].i_len != sizeof(struct xfs_rud_log_format)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				rud_formatp, item->ri_buf[0].i_len);
+		return -EFSCORRUPTED;
+	}
+
+	xlog_recover_release_intent(log, XFS_LI_RUI_RT,
+			rud_formatp->rud_rui_id);
+	return 0;
+}
+#else
+# define xlog_recover_rtrud_commit_pass2	xlog_recover_rtrui_commit_pass2
+#endif
+
+const struct xlog_recover_item_ops xlog_rtrud_item_ops = {
+	.item_type		= XFS_LI_RUD_RT,
+	.commit_pass2		= xlog_recover_rtrud_commit_pass2,
+};
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 1c89d38b85446..10eeceb8b9e7f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3017,9 +3017,10 @@ DECLARE_EVENT_CLASS(xfs_rmap_deferred_class,
 	TP_ARGS(mp, ri),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(dev_t, opdev)
 		__field(unsigned long long, owner)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
+		__field(xfs_agblock_t, rmapbno)
 		__field(int, whichfork)
 		__field(xfs_fileoff_t, l_loff)
 		__field(xfs_filblks_t, l_len)
@@ -3028,9 +3029,18 @@ DECLARE_EVENT_CLASS(xfs_rmap_deferred_class,
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = XFS_FSB_TO_AGNO(mp, ri->ri_bmap.br_startblock);
-		__entry->agbno = XFS_FSB_TO_AGBNO(mp,
-					ri->ri_bmap.br_startblock);
+		if (ri->ri_realtime) {
+			__entry->opdev = mp->m_rtdev_targp->bt_dev;
+			__entry->rmapbno = xfs_rtb_to_rgbno(mp,
+					ri->ri_bmap.br_startblock,
+					&__entry->agno);
+		} else {
+			__entry->agno = XFS_FSB_TO_AGNO(mp,
+						ri->ri_bmap.br_startblock);
+			__entry->opdev = __entry->dev;
+			__entry->rmapbno = XFS_FSB_TO_AGBNO(mp,
+						ri->ri_bmap.br_startblock);
+		}
 		__entry->owner = ri->ri_owner;
 		__entry->whichfork = ri->ri_whichfork;
 		__entry->l_loff = ri->ri_bmap.br_startoff;
@@ -3038,11 +3048,12 @@ DECLARE_EVENT_CLASS(xfs_rmap_deferred_class,
 		__entry->l_state = ri->ri_bmap.br_state;
 		__entry->op = ri->ri_type;
 	),
-	TP_printk("dev %d:%d op %s agno 0x%x agbno 0x%x owner 0x%llx %s fileoff 0x%llx fsbcount 0x%llx state %d",
+	TP_printk("dev %d:%d op %s opdev %d:%d agno 0x%x rmapbno 0x%x owner 0x%llx %s fileoff 0x%llx fsbcount 0x%llx state %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->op, XFS_RMAP_INTENT_STRINGS),
+		  MAJOR(__entry->opdev), MINOR(__entry->opdev),
 		  __entry->agno,
-		  __entry->agbno,
+		  __entry->rmapbno,
 		  __entry->owner,
 		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
 		  __entry->l_loff,

