Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5440438E
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="efJTtGZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B4EC433C7;
	Mon,  1 Jan 2024 00:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067941;
	bh=6J6DqmW0fqw8Pppfo90zwucnq5NuyJ8slmbi5Htrxsc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=efJTtGZW7GClkMl0yH1pz9olqfMGJYjErpi7c6AAw5nPGUvkVZrEEPgEvi5mI7xgm
	 HdRxyC9LcmOjDJZpwWcLTut/svbwMeX7JS2H/QG9KKRkxQyOuXMKxj+2/whRqjBAuT
	 9fOs7H8um5Xc5yZw2JcfNiz3RIe7dz5wTpm4SkaN2ntS8L2YQCfcNVZ+Wf3y8RMcqw
	 sE6GnreVBpMdI6R7N3I2Ioldsjia1ya8CGTIALNneXfe2mIdFIAj3JGXGqb/r/pexU
	 7Bs5VT6c6URKTDNkfbWDzAQ3ybWnLufMEkQ6+BzXv/mk0Kva8tfb1sZIXJark/i7RQ
	 SnXemhGDHxI8A==
Date: Sun, 31 Dec 2023 16:12:20 +9900
Subject: [PATCH 07/47] xfs: add a realtime flag to the rmap update log redo
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015406.1815505.15806508939281366124.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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
 libxfs/defer_item.c     |   96 ++++++++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_defer.h      |    1 
 libxfs/xfs_log_format.h |    6 ++-
 libxfs/xfs_refcount.c   |    4 +-
 libxfs/xfs_rmap.c       |   32 +++++++++++++---
 libxfs/xfs_rmap.h       |   12 ++++--
 6 files changed, 138 insertions(+), 13 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 5399a20f186..a82d23c17cf 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -29,6 +29,7 @@
 #include "xfs_swapext.h"
 #include "defer_item.h"
 #include "xfs_btree.h"
+#include "xfs_rtgroup.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
@@ -329,8 +330,23 @@ xfs_rmap_defer_add(
 
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
@@ -395,6 +411,82 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.cancel_item	= xfs_rmap_update_cancel_item,
 };
 
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
+
+	if (sort)
+		list_sort(mp, items, xfs_rtrmap_update_diff_items);
+	return NULL;
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
+	.create_intent	= xfs_rtrmap_update_create_intent,
+	.abort_intent	= xfs_rmap_update_abort_intent,
+	.create_done	= xfs_rmap_update_create_done,
+	.finish_item	= xfs_rtrmap_update_finish_item,
+	.finish_cleanup = xfs_rtrmap_finish_one_cleanup,
+	.cancel_item	= xfs_rtrmap_update_cancel_item,
+};
+
 /* Reference Counting */
 
 /* Sort refcount intents by AG. */
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index b4e1c386768..fddcb4cccbc 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -69,6 +69,7 @@ struct xfs_defer_op_type {
 extern const struct xfs_defer_op_type xfs_bmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
 extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
+extern const struct xfs_defer_op_type xfs_rtrmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
 extern const struct xfs_defer_op_type xfs_rtextent_free_defer_type;
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 1f5fe4a588e..ea4e88d6657 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
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
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 9f933d953b9..0e8daab9986 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1886,7 +1886,7 @@ xfs_refcount_alloc_cow_extent(
 	__xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
 
 	/* Add rmap entry */
-	xfs_rmap_alloc_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
+	xfs_rmap_alloc_extent(tp, false, fsb, len, XFS_RMAP_OWN_COW);
 }
 
 /* Forget a CoW staging event in the refcount btree. */
@@ -1902,7 +1902,7 @@ xfs_refcount_free_cow_extent(
 		return;
 
 	/* Remove rmap entry */
-	xfs_rmap_free_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
+	xfs_rmap_free_extent(tp, false, fsb, len, XFS_RMAP_OWN_COW);
 	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
 }
 
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 007f17cc644..00544d6a20f 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2681,6 +2681,21 @@ xfs_rmap_finish_one(
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
@@ -2701,6 +2716,7 @@ __xfs_rmap_add(
 	struct xfs_trans		*tp,
 	enum xfs_rmap_intent_type	type,
 	uint64_t			owner,
+	bool				isrt,
 	int				whichfork,
 	struct xfs_bmbt_irec		*bmap)
 {
@@ -2712,6 +2728,7 @@ __xfs_rmap_add(
 	ri->ri_owner = owner;
 	ri->ri_whichfork = whichfork;
 	ri->ri_bmap = *bmap;
+	ri->ri_realtime = isrt;
 
 	xfs_rmap_defer_add(tp, ri);
 }
@@ -2725,6 +2742,7 @@ xfs_rmap_map_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	enum xfs_rmap_intent_type type = XFS_RMAP_MAP;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
 
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, whichfork))
 		return;
@@ -2732,7 +2750,7 @@ xfs_rmap_map_extent(
 	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
 		type = XFS_RMAP_MAP_SHARED;
 
-	__xfs_rmap_add(tp, type, ip->i_ino, whichfork, PREV);
+	__xfs_rmap_add(tp, type, ip->i_ino, isrt, whichfork, PREV);
 }
 
 /* Unmap an extent out of a file. */
@@ -2744,6 +2762,7 @@ xfs_rmap_unmap_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	enum xfs_rmap_intent_type type = XFS_RMAP_UNMAP;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
 
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, whichfork))
 		return;
@@ -2751,7 +2770,7 @@ xfs_rmap_unmap_extent(
 	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
 		type = XFS_RMAP_UNMAP_SHARED;
 
-	__xfs_rmap_add(tp, type, ip->i_ino, whichfork, PREV);
+	__xfs_rmap_add(tp, type, ip->i_ino, isrt, whichfork, PREV);
 }
 
 /*
@@ -2769,6 +2788,7 @@ xfs_rmap_convert_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	enum xfs_rmap_intent_type type = XFS_RMAP_CONVERT;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
 
 	if (!xfs_rmap_update_is_needed(mp, whichfork))
 		return;
@@ -2776,13 +2796,14 @@ xfs_rmap_convert_extent(
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
@@ -2797,13 +2818,14 @@ xfs_rmap_alloc_extent(
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
@@ -2818,7 +2840,7 @@ xfs_rmap_free_extent(
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
 
-	__xfs_rmap_add(tp, XFS_RMAP_FREE, owner, XFS_DATA_FORK, &bmap);
+	__xfs_rmap_add(tp, XFS_RMAP_FREE, owner, isrt, XFS_DATA_FORK, &bmap);
 }
 
 /* Compare rmap records.  Returns -1 if a < b, 1 if a > b, and 0 if equal. */
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 762f2f40b6e..3719fc4cbc2 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
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

