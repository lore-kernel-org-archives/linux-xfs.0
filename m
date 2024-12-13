Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D409317BA1
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051760; cv=none; b=Ll8gn0HSS5qiuru/vhEwkRwWEg5m1yDRE9Ob52aXLqax70F1ax3mz1zUF6lzPXjp52pop2K4w6185i3XnNxnO5+2uUffBBGKCa60Hz+1FzEBsNOsilf1sLkKRAYKAFa9DemiL8ILC1XIJWpTe75lZokY2XpqKe7VClVh9zAarHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051760; c=relaxed/simple;
	bh=aB/V927Wy9Q/K38oAIIEzG+x5GLZK8pKirIgZwQ20Yg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DXmDBeHSP9f9mMPxmKkbulphUphR6fjvWXDtY1raSJvsifK/S08TeKfu1Y5SwV78DRwjsk9e25rG2roifxmf6mEPj9AWdDMjjapfQX7w5GkTCJuF8+SiCuWo4iHv0fJ7N9CsXduslAS5Ezn2aBY3vwb8386pRXT3eZlfV8Wy6VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LGASlexP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LGASlexP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D65C4CECE;
	Fri, 13 Dec 2024 01:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051760;
	bh=aB/V927Wy9Q/K38oAIIEzG+x5GLZK8pKirIgZwQ20Yg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LGASlexPysQKPTsz9vf67coieNN5n2x9qvHPwLDLPNSyxjWLj3VJ1V6PocY7fdwV+
	 9GClrtYddBd/XsbNNSIQL9t49xb10WP7x7hGMMbzuVdJpJ9mg06hPkQdV7MFqfIn5/
	 x6Y9sIF4jNFJC5g5pH5Vrjuzvuqg6XFRx1dif37DyY7FDZQ4TyQV8gdl8kPEQJglxk
	 Dw74rEfLzaPu1wxX1zvdxVfpJjt7fQPBemyzWc3wLG5J44AMaKa7pxtyBiTn2ysI3J
	 czJ+H/0dWv+8toEi6H9lHjfDc4NKmdlpoJlbV3U/iH5s2MbYWnBzB68rpQFXSb2quB
	 AseosvStvCRDQ==
Date: Thu, 12 Dec 2024 17:02:40 -0800
Subject: [PATCH 08/37] xfs: add a realtime flag to the rmap update log redo
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123451.1181370.1057797621602382553.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Extend the rmap update (RUI) log items to handle realtime volumes by
adding a new log intent item type.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.h       |    1 
 fs/xfs/libxfs/xfs_log_format.h  |    6 +
 fs/xfs/libxfs/xfs_log_recover.h |    2 
 fs/xfs/libxfs/xfs_refcount.c    |    4 -
 fs/xfs/libxfs/xfs_rmap.c        |   17 ++-
 fs/xfs/libxfs/xfs_rmap.h        |    5 +
 fs/xfs/scrub/alloc_repair.c     |    2 
 fs/xfs/xfs_log_recover.c        |    2 
 fs/xfs/xfs_rmap_item.c          |  197 +++++++++++++++++++++++++++++++++++++--
 9 files changed, 213 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index ec51b8465e61cb..1e2477eaa5a844 100644
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
index 15dec19b6c32ad..a7e0e479454d3d 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -250,6 +250,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_XMD		0x1249  /* mapping exchange done */
 #define	XFS_LI_EFI_RT		0x124a	/* realtime extent free intent */
 #define	XFS_LI_EFD_RT		0x124b	/* realtime extent free done */
+#define	XFS_LI_RUI_RT		0x124c	/* realtime rmap update intent */
+#define	XFS_LI_RUD_RT		0x124d	/* realtime rmap update done */
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -271,7 +273,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_XMI,		"XFS_LI_XMI" }, \
 	{ XFS_LI_XMD,		"XFS_LI_XMD" }, \
 	{ XFS_LI_EFI_RT,	"XFS_LI_EFI_RT" }, \
-	{ XFS_LI_EFD_RT,	"XFS_LI_EFD_RT" }
+	{ XFS_LI_EFD_RT,	"XFS_LI_EFD_RT" }, \
+	{ XFS_LI_RUI_RT,	"XFS_LI_RUI_RT" }, \
+	{ XFS_LI_RUD_RT,	"XFS_LI_RUD_RT" }
 
 /*
  * Inode Log Item Format definitions.
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 5397a8ff004df8..abc705aff26dfe 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -79,6 +79,8 @@ extern const struct xlog_recover_item_ops xlog_xmi_item_ops;
 extern const struct xlog_recover_item_ops xlog_xmd_item_ops;
 extern const struct xlog_recover_item_ops xlog_rtefi_item_ops;
 extern const struct xlog_recover_item_ops xlog_rtefd_item_ops;
+extern const struct xlog_recover_item_ops xlog_rtrui_item_ops;
+extern const struct xlog_recover_item_ops xlog_rtrud_item_ops;
 
 /*
  * Macros, structures, prototypes for internal log manager use.
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 26d3d7956e069d..bbb86dc9a25c7f 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1831,7 +1831,7 @@ xfs_refcount_alloc_cow_extent(
 	__xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
 
 	/* Add rmap entry */
-	xfs_rmap_alloc_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
+	xfs_rmap_alloc_extent(tp, false, fsb, len, XFS_RMAP_OWN_COW);
 }
 
 /* Forget a CoW staging event in the refcount btree. */
@@ -1847,7 +1847,7 @@ xfs_refcount_free_cow_extent(
 		return;
 
 	/* Remove rmap entry */
-	xfs_rmap_free_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
+	xfs_rmap_free_extent(tp, false, fsb, len, XFS_RMAP_OWN_COW);
 	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
 }
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index da1b004837d3ad..8d3cea90c7cd04 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2710,6 +2710,7 @@ __xfs_rmap_add(
 	struct xfs_trans		*tp,
 	enum xfs_rmap_intent_type	type,
 	uint64_t			owner,
+	bool				isrt,
 	int				whichfork,
 	struct xfs_bmbt_irec		*bmap)
 {
@@ -2721,6 +2722,7 @@ __xfs_rmap_add(
 	ri->ri_owner = owner;
 	ri->ri_whichfork = whichfork;
 	ri->ri_bmap = *bmap;
+	ri->ri_realtime = isrt;
 
 	xfs_rmap_defer_add(tp, ri);
 }
@@ -2734,6 +2736,7 @@ xfs_rmap_map_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	enum xfs_rmap_intent_type type = XFS_RMAP_MAP;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
 
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, whichfork))
 		return;
@@ -2741,7 +2744,7 @@ xfs_rmap_map_extent(
 	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
 		type = XFS_RMAP_MAP_SHARED;
 
-	__xfs_rmap_add(tp, type, ip->i_ino, whichfork, PREV);
+	__xfs_rmap_add(tp, type, ip->i_ino, isrt, whichfork, PREV);
 }
 
 /* Unmap an extent out of a file. */
@@ -2753,6 +2756,7 @@ xfs_rmap_unmap_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	enum xfs_rmap_intent_type type = XFS_RMAP_UNMAP;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
 
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, whichfork))
 		return;
@@ -2760,7 +2764,7 @@ xfs_rmap_unmap_extent(
 	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
 		type = XFS_RMAP_UNMAP_SHARED;
 
-	__xfs_rmap_add(tp, type, ip->i_ino, whichfork, PREV);
+	__xfs_rmap_add(tp, type, ip->i_ino, isrt, whichfork, PREV);
 }
 
 /*
@@ -2778,6 +2782,7 @@ xfs_rmap_convert_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	enum xfs_rmap_intent_type type = XFS_RMAP_CONVERT;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
 
 	if (!xfs_rmap_update_is_needed(mp, whichfork))
 		return;
@@ -2785,13 +2790,14 @@ xfs_rmap_convert_extent(
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
@@ -2806,13 +2812,14 @@ xfs_rmap_alloc_extent(
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
@@ -2827,7 +2834,7 @@ xfs_rmap_free_extent(
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
 
-	__xfs_rmap_add(tp, XFS_RMAP_FREE, owner, XFS_DATA_FORK, &bmap);
+	__xfs_rmap_add(tp, XFS_RMAP_FREE, owner, isrt, XFS_DATA_FORK, &bmap);
 }
 
 /* Compare rmap records.  Returns -1 if a < b, 1 if a > b, and 0 if equal. */
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 1b19f54b65047f..5f39f6e53cd19a 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -175,6 +175,7 @@ struct xfs_rmap_intent {
 	uint64_t				ri_owner;
 	struct xfs_bmbt_irec			ri_bmap;
 	struct xfs_group			*ri_group;
+	bool					ri_realtime;
 };
 
 /* functions for updating the rmapbt based on bmbt map/unmap operations */
@@ -185,9 +186,9 @@ void xfs_rmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 void xfs_rmap_convert_extent(struct xfs_mount *mp, struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *imap);
-void xfs_rmap_alloc_extent(struct xfs_trans *tp, xfs_fsblock_t fsbno,
+void xfs_rmap_alloc_extent(struct xfs_trans *tp, bool isrt, xfs_fsblock_t fsbno,
 		xfs_extlen_t len, uint64_t owner);
-void xfs_rmap_free_extent(struct xfs_trans *tp, xfs_fsblock_t fsbno,
+void xfs_rmap_free_extent(struct xfs_trans *tp, bool isrt, xfs_fsblock_t fsbno,
 		xfs_extlen_t len, uint64_t owner);
 
 int xfs_rmap_finish_one(struct xfs_trans *tp, struct xfs_rmap_intent *ri,
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index 11e1e5404fc6dc..bed6a09aa79112 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -542,7 +542,7 @@ xrep_abt_dispose_one(
 
 	/* Add a deferred rmap for each extent we used. */
 	if (resv->used > 0)
-		xfs_rmap_alloc_extent(sc->tp,
+		xfs_rmap_alloc_extent(sc->tp, false,
 				xfs_agbno_to_fsb(pag, resv->agbno), resv->used,
 				XFS_RMAP_OWN_AG);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0af3d477197b24..5c95c97519c767 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1820,6 +1820,8 @@ static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
 	&xlog_xmd_item_ops,
 	&xlog_rtefi_item_ops,
 	&xlog_rtefd_item_ops,
+	&xlog_rtrui_item_ops,
+	&xlog_rtrud_item_ops,
 };
 
 static const struct xlog_recover_item_ops *
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index ac2913a7335871..e8caa600a95cae 100644
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
@@ -137,12 +140,15 @@ xfs_rui_item_release(
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
 		ruip = kzalloc(xfs_rui_log_item_sizeof(nextents),
 				GFP_KERNEL | __GFP_NOFAIL);
@@ -150,7 +156,7 @@ xfs_rui_init(
 		ruip = kmem_cache_zalloc(xfs_rui_cache,
 					 GFP_KERNEL | __GFP_NOFAIL);
 
-	xfs_log_item_init(mp, &ruip->rui_item, XFS_LI_RUI, &xfs_rui_item_ops);
+	xfs_log_item_init(mp, &ruip->rui_item, item_type, &xfs_rui_item_ops);
 	ruip->rui_format.rui_nextents = nextents;
 	ruip->rui_format.rui_id = (uintptr_t)(void *)ruip;
 	atomic_set(&ruip->rui_next_extent, 0);
@@ -189,7 +195,9 @@ xfs_rud_item_format(
 	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
 	struct xfs_log_iovec	*vecp = NULL;
 
-	rudp->rud_format.rud_type = XFS_LI_RUD;
+	ASSERT(lip->li_type == XFS_LI_RUD || lip->li_type == XFS_LI_RUD_RT);
+
+	rudp->rud_format.rud_type = lip->li_type;
 	rudp->rud_format.rud_size = 1;
 
 	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_RUD_FORMAT, &rudp->rud_format,
@@ -233,6 +241,14 @@ static inline struct xfs_rmap_intent *ri_entry(const struct list_head *e)
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
@@ -305,18 +321,20 @@ xfs_rmap_update_log_item(
 }
 
 static struct xfs_log_item *
-xfs_rmap_update_create_intent(
+__xfs_rmap_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
 	unsigned int			count,
-	bool				sort)
+	bool				sort,
+	unsigned short			item_type)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_rui_log_item		*ruip = xfs_rui_init(mp, count);
+	struct xfs_rui_log_item		*ruip;
 	struct xfs_rmap_intent		*ri;
 
 	ASSERT(count > 0);
 
+	ruip = xfs_rui_init(mp, item_type, count);
 	if (sort)
 		list_sort(mp, items, xfs_rmap_update_diff_items);
 	list_for_each_entry(ri, items, ri_list)
@@ -324,6 +342,23 @@ xfs_rmap_update_create_intent(
 	return &ruip->rui_item;
 }
 
+static struct xfs_log_item *
+xfs_rmap_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	return __xfs_rmap_update_create_intent(tp, items, count, sort,
+			XFS_LI_RUI);
+}
+
+static inline unsigned short
+xfs_rud_type_from_rui(const struct xfs_rui_log_item *ruip)
+{
+	return xfs_rui_item_isrt(&ruip->rui_item) ? XFS_LI_RUD_RT : XFS_LI_RUD;
+}
+
 /* Get an RUD so we can process all the deferred rmap updates. */
 static struct xfs_log_item *
 xfs_rmap_update_create_done(
@@ -335,8 +370,8 @@ xfs_rmap_update_create_done(
 	struct xfs_rud_log_item		*rudp;
 
 	rudp = kmem_cache_zalloc(xfs_rud_cache, GFP_KERNEL | __GFP_NOFAIL);
-	xfs_log_item_init(tp->t_mountp, &rudp->rud_item, XFS_LI_RUD,
-			  &xfs_rud_item_ops);
+	xfs_log_item_init(tp->t_mountp, &rudp->rud_item,
+			xfs_rud_type_from_rui(ruip), &xfs_rud_item_ops);
 	rudp->rud_ruip = ruip;
 	rudp->rud_format.rud_rui_id = ruip->rui_format.rui_id;
 
@@ -351,11 +386,20 @@ xfs_rmap_defer_add(
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 
+	/*
+	 * Deferred rmap updates for the realtime and data sections must use
+	 * separate transactions to finish deferred work because updates to
+	 * realtime metadata files can lock AGFs to allocate btree blocks and
+	 * we don't want that mixing with the AGF locks taken to finish data
+	 * section updates.
+	 */
 	ri->ri_group = xfs_group_intent_get(mp, ri->ri_bmap.br_startblock,
-			XG_TYPE_AG);
+			ri->ri_realtime ? XG_TYPE_RTG : XG_TYPE_AG);
 
 	trace_xfs_rmap_defer(mp, ri);
-	xfs_defer_add(tp, &ri->ri_list, &xfs_rmap_update_defer_type);
+	xfs_defer_add(tp, &ri->ri_list, ri->ri_realtime ?
+			&xfs_rtrmap_update_defer_type :
+			&xfs_rmap_update_defer_type);
 }
 
 /* Cancel a deferred rmap update. */
@@ -566,10 +610,13 @@ xfs_rmap_relog_intent(
 	struct xfs_map_extent		*map;
 	unsigned int			count;
 
+	ASSERT(intent->li_type == XFS_LI_RUI ||
+	       intent->li_type == XFS_LI_RUI_RT);
+
 	count = RUI_ITEM(intent)->rui_format.rui_nextents;
 	map = RUI_ITEM(intent)->rui_format.rui_extents;
 
-	ruip = xfs_rui_init(tp->t_mountp, count);
+	ruip = xfs_rui_init(tp->t_mountp, intent->li_type, count);
 	memcpy(ruip->rui_format.rui_extents, map, count * sizeof(*map));
 	atomic_set(&ruip->rui_next_extent, count);
 
@@ -589,6 +636,47 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.relog_intent	= xfs_rmap_relog_intent,
 };
 
+#ifdef CONFIG_XFS_RT
+static struct xfs_log_item *
+xfs_rtrmap_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	return __xfs_rmap_update_create_intent(tp, items, count, sort,
+			XFS_LI_RUI_RT);
+}
+
+/* Clean up after calling xfs_rmap_finish_one. */
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
+	.finish_item	= xfs_rmap_update_finish_item,
+	.finish_cleanup = xfs_rtrmap_finish_one_cleanup,
+	.cancel_item	= xfs_rmap_update_cancel_item,
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
@@ -654,7 +742,7 @@ xlog_recover_rui_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
-	ruip = xfs_rui_init(mp, rui_formatp->rui_nextents);
+	ruip = xfs_rui_init(mp, ITEM_TYPE(item), rui_formatp->rui_nextents);
 	xfs_rui_copy_format(&ruip->rui_format, rui_formatp);
 	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
 
@@ -668,6 +756,61 @@ const struct xlog_recover_item_ops xlog_rui_item_ops = {
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
@@ -699,3 +842,33 @@ const struct xlog_recover_item_ops xlog_rud_item_ops = {
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

