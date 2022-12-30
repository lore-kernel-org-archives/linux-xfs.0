Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C7DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236125AbiLaBi7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:38:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236119AbiLaBi6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:38:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF15813DD9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:38:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ADD361CC7
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91596C433EF;
        Sat, 31 Dec 2022 01:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450735;
        bh=VTXIGQAiKa/UNGO/hJWsOPT2n0HbvFpo+gPva93Hhyw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=J+HOu6RjwY0f+Ymyq01Yn8zC5V5QJ6KSfIjp1XO1gvVwSfx+2C5/RCCSftbsPcnqR
         GEaRK7vJVvn7+2+g78JJxC2J2XYBZ8ZccJ5e1Jgqg4/0padXgXosi5+VmmD5BAnsd8
         RTpxclLdH6FVVyLbIQerhh8vvM+zBINK0iJlMZJYpKgJ+FiJqebf4776cZ84PY25Xi
         dIGEG9bDjKNlBAO++tqZX5z8eBAJ+wMFvoq5RSLjfplv3fJ9C+Zz+puS0dr/dAfDaT
         j07PuKBCJLXftaOQGQSOsItlEdfAWjl+g7//1OFtmjlCJgGI0jvg52OK5NgDXHlT2l
         xeXS/TOG/1jPw==
Subject: [PATCH 08/38] xfs: add a realtime flag to the rmap update log redo
 items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:17 -0800
Message-ID: <167243869714.715303.6763477970340479268.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Extend the rmap update (RUI) log items with a new realtime flag that
indicates that the updates apply against the realtime rmapbt.  We'll
wire up the actual rmap code later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c      |    1 +
 fs/xfs/libxfs/xfs_defer.h      |    1 +
 fs/xfs/libxfs/xfs_log_format.h |    4 +++-
 fs/xfs/libxfs/xfs_refcount.c   |    4 ++--
 fs/xfs/libxfs/xfs_rmap.c       |   38 ++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_rmap.h       |   10 +++++++---
 fs/xfs/scrub/alloc_repair.c    |    2 +-
 fs/xfs/xfs_rmap_item.c         |   22 ++++++++++++++++++++++
 fs/xfs/xfs_trace.h             |   23 +++++++++++++++++------
 9 files changed, 86 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index c0416bae880a..ce3bc5fe2bdc 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -187,6 +187,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_BMAP]	= &xfs_bmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_REFCOUNT]	= &xfs_refcount_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
+	[XFS_DEFER_OPS_TYPE_RMAP_RT]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE_RT]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 52198c7124c6..89c279185ce6 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -17,6 +17,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_BMAP,
 	XFS_DEFER_OPS_TYPE_REFCOUNT,
 	XFS_DEFER_OPS_TYPE_RMAP,
+	XFS_DEFER_OPS_TYPE_RMAP_RT,
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_AGFL_FREE,
 	XFS_DEFER_OPS_TYPE_FREE_RT,
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index f3c8257a7545..3a23282d6e6f 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -746,11 +746,13 @@ struct xfs_map_extent {
 #define XFS_RMAP_EXTENT_ATTR_FORK	(1U << 31)
 #define XFS_RMAP_EXTENT_BMBT_BLOCK	(1U << 30)
 #define XFS_RMAP_EXTENT_UNWRITTEN	(1U << 29)
+#define XFS_RMAP_EXTENT_REALTIME	(1U << 28)
 
 #define XFS_RMAP_EXTENT_FLAGS		(XFS_RMAP_EXTENT_TYPE_MASK | \
 					 XFS_RMAP_EXTENT_ATTR_FORK | \
 					 XFS_RMAP_EXTENT_BMBT_BLOCK | \
-					 XFS_RMAP_EXTENT_UNWRITTEN)
+					 XFS_RMAP_EXTENT_UNWRITTEN | \
+					 XFS_RMAP_EXTENT_REALTIME)
 
 /*
  * This is the structure used to lay out an rui log item in the
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 20c12cb7b7de..83f681fb49fb 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1889,7 +1889,7 @@ xfs_refcount_alloc_cow_extent(
 	__xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
 
 	/* Add rmap entry */
-	xfs_rmap_alloc_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
+	xfs_rmap_alloc_extent(tp, false, fsb, len, XFS_RMAP_OWN_COW);
 }
 
 /* Forget a CoW staging event in the refcount btree. */
@@ -1905,7 +1905,7 @@ xfs_refcount_free_cow_extent(
 		return;
 
 	/* Remove rmap entry */
-	xfs_rmap_free_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
+	xfs_rmap_free_extent(tp, false, fsb, len, XFS_RMAP_OWN_COW);
 	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
 }
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 31194cc14c0b..1a3607082d12 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2654,6 +2654,12 @@ xfs_rmap_finish_one(
 	xfs_agblock_t			bno;
 	bool				unwritten;
 
+	if (ri->ri_realtime) {
+		/* coming in a subsequent patch */
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
 	bno = XFS_FSB_TO_AGBNO(mp, ri->ri_bmap.br_startblock);
 
 	trace_xfs_rmap_deferred(mp, ri);
@@ -2726,10 +2732,12 @@ __xfs_rmap_add(
 	struct xfs_trans		*tp,
 	enum xfs_rmap_intent_type	type,
 	uint64_t			owner,
+	bool				isrt,
 	int				whichfork,
 	struct xfs_bmbt_irec		*bmap)
 {
 	struct xfs_rmap_intent		*ri;
+	enum xfs_defer_ops_type		optype;
 
 	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&ri->ri_list);
@@ -2737,11 +2745,24 @@ __xfs_rmap_add(
 	ri->ri_owner = owner;
 	ri->ri_whichfork = whichfork;
 	ri->ri_bmap = *bmap;
+	ri->ri_realtime = isrt;
+
+	/*
+	 * Deferred rmap updates for the realtime and data sections must use
+	 * separate transactions to finish deferred work because updates to
+	 * realtime metadata files can lock AGFs to allocate btree blocks and
+	 * we don't want that mixing with the AGF locks taken to finish data
+	 * section updates.
+	 */
+	if (isrt)
+		optype = XFS_DEFER_OPS_TYPE_RMAP_RT;
+	else
+		optype = XFS_DEFER_OPS_TYPE_RMAP;
 
 	trace_xfs_rmap_defer(tp->t_mountp, ri);
 
 	xfs_rmap_update_get_group(tp->t_mountp, ri);
-	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_RMAP, &ri->ri_list);
+	xfs_defer_add(tp, optype, &ri->ri_list);
 }
 
 /* Map an extent into a file. */
@@ -2753,6 +2774,7 @@ xfs_rmap_map_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	enum xfs_rmap_intent_type type = XFS_RMAP_MAP;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
 
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, whichfork))
 		return;
@@ -2760,7 +2782,7 @@ xfs_rmap_map_extent(
 	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
 		type = XFS_RMAP_MAP_SHARED;
 
-	__xfs_rmap_add(tp, type, ip->i_ino, whichfork, PREV);
+	__xfs_rmap_add(tp, type, ip->i_ino, isrt, whichfork, PREV);
 }
 
 /* Unmap an extent out of a file. */
@@ -2772,6 +2794,7 @@ xfs_rmap_unmap_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	enum xfs_rmap_intent_type type = XFS_RMAP_UNMAP;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
 
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, whichfork))
 		return;
@@ -2779,7 +2802,7 @@ xfs_rmap_unmap_extent(
 	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
 		type = XFS_RMAP_UNMAP_SHARED;
 
-	__xfs_rmap_add(tp, type, ip->i_ino, whichfork, PREV);
+	__xfs_rmap_add(tp, type, ip->i_ino, isrt, whichfork, PREV);
 }
 
 /*
@@ -2797,6 +2820,7 @@ xfs_rmap_convert_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	enum xfs_rmap_intent_type type = XFS_RMAP_CONVERT;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
 
 	if (!xfs_rmap_update_is_needed(mp, whichfork))
 		return;
@@ -2804,13 +2828,14 @@ xfs_rmap_convert_extent(
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
@@ -2825,13 +2850,14 @@ xfs_rmap_alloc_extent(
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
@@ -2846,7 +2872,7 @@ xfs_rmap_free_extent(
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
 
-	__xfs_rmap_add(tp, XFS_RMAP_FREE, owner, XFS_DATA_FORK, &bmap);
+	__xfs_rmap_add(tp, XFS_RMAP_FREE, owner, isrt, XFS_DATA_FORK, &bmap);
 }
 
 /* Compare rmap records.  Returns -1 if a < b, 1 if a > b, and 0 if equal. */
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 54c969731cf4..e98f37c39f2f 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -173,7 +173,11 @@ struct xfs_rmap_intent {
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
 
 void xfs_rmap_update_get_group(struct xfs_mount *mp,
@@ -187,9 +191,9 @@ void xfs_rmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 void xfs_rmap_convert_extent(struct xfs_mount *mp, struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *imap);
-void xfs_rmap_alloc_extent(struct xfs_trans *tp, xfs_fsblock_t fsbno,
+void xfs_rmap_alloc_extent(struct xfs_trans *tp, bool isrt, xfs_fsblock_t fsbno,
 		xfs_extlen_t len, uint64_t owner);
-void xfs_rmap_free_extent(struct xfs_trans *tp, xfs_fsblock_t fsbno,
+void xfs_rmap_free_extent(struct xfs_trans *tp, bool isrt, xfs_fsblock_t fsbno,
 		xfs_extlen_t len, uint64_t owner);
 
 void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index 6506fc202571..b695cd2b0a56 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -528,7 +528,7 @@ xrep_abt_dispose_one(
 		xfs_fsblock_t	fsbno;
 
 		fsbno = XFS_AGB_TO_FSB(sc->mp, pag->pag_agno, resv->agbno);
-		xfs_rmap_alloc_extent(sc->tp, fsbno, resv->used,
+		xfs_rmap_alloc_extent(sc->tp, false, fsbno, resv->used,
 				XFS_RMAP_OWN_AG);
 	}
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index a84f7e0e91a3..5f04f55f5caa 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -21,6 +21,7 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 #include "xfs_ag.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_rui_cache;
 struct kmem_cache	*xfs_rud_cache;
@@ -284,6 +285,11 @@ xfs_rmap_update_diff_items(
 	ra = container_of(a, struct xfs_rmap_intent, ri_list);
 	rb = container_of(b, struct xfs_rmap_intent, ri_list);
 
+	ASSERT(ra->ri_realtime == rb->ri_realtime);
+
+	if (ra->ri_realtime)
+		return ra->ri_rtg->rtg_rgno - rb->ri_rtg->rtg_rgno;
+
 	return ra->ri_pag->pag_agno - rb->ri_pag->pag_agno;
 }
 
@@ -318,6 +324,8 @@ xfs_rmap_update_log_item(
 		map->me_flags |= XFS_RMAP_EXTENT_UNWRITTEN;
 	if (ri->ri_whichfork == XFS_ATTR_FORK)
 		map->me_flags |= XFS_RMAP_EXTENT_ATTR_FORK;
+	if (ri->ri_realtime)
+		map->me_flags |= XFS_RMAP_EXTENT_REALTIME;
 	switch (ri->ri_type) {
 	case XFS_RMAP_MAP:
 		map->me_flags |= XFS_RMAP_EXTENT_MAP;
@@ -387,6 +395,14 @@ xfs_rmap_update_get_group(
 {
 	xfs_agnumber_t		agno;
 
+	if (ri->ri_realtime) {
+		xfs_rgnumber_t	rgno;
+
+		rgno = xfs_rtb_to_rgno(mp, ri->ri_bmap.br_startblock);
+		ri->ri_rtg = xfs_rtgroup_get(mp, rgno);
+		return;
+	}
+
 	agno = XFS_FSB_TO_AGNO(mp, ri->ri_bmap.br_startblock);
 	ri->ri_pag = xfs_perag_get(mp, agno);
 	xfs_perag_bump_intents(ri->ri_pag);
@@ -397,6 +413,11 @@ static inline void
 xfs_rmap_update_put_group(
 	struct xfs_rmap_intent	*ri)
 {
+	if (ri->ri_realtime) {
+		xfs_rtgroup_put(ri->ri_rtg);
+		return;
+	}
+
 	xfs_perag_drop_intents(ri->ri_pag);
 	xfs_perag_put(ri->ri_pag);
 }
@@ -565,6 +586,7 @@ xfs_rui_item_recover(
 			goto abort_error;
 		}
 
+		fake.ri_realtime = !!(map->me_flags & XFS_RMAP_EXTENT_REALTIME);
 		fake.ri_owner = map->me_owner;
 		fake.ri_whichfork = (map->me_flags & XFS_RMAP_EXTENT_ATTR_FORK) ?
 				XFS_ATTR_FORK : XFS_DATA_FORK;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 390aa7a4afae..c02a58cbf15b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3013,9 +3013,10 @@ DECLARE_EVENT_CLASS(xfs_rmap_deferred_class,
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
@@ -3024,9 +3025,18 @@ DECLARE_EVENT_CLASS(xfs_rmap_deferred_class,
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
@@ -3034,11 +3044,12 @@ DECLARE_EVENT_CLASS(xfs_rmap_deferred_class,
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

