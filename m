Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2462FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236196AbiLaCoY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236205AbiLaCoW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:44:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683DC2DED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:44:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 139B5B81E5C
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7833C433D2;
        Sat, 31 Dec 2022 02:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454658;
        bh=x7ZPId7NSJ/GbSBC9kYoT+MUwHLLwunq7Bn2qdNGuWs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cWVGzqizjTlDm83dDXrB4gNAyCJIS7bTjuthFFHWRmBTdJ5wyAfKVsg65xAZ3VfUp
         dNLuLXnKh0o0EgGvyOcpYkG+5S7ZfTZ1TMKSp9Z055fwE+uCa4efHl/ETe6FQIPon7
         U773R9ixnFbmiu4YDBMPsDbAOIekh+/S9EvGzIIMVJVgxpjZepiLoMpZvoyZoDltbO
         7uCygtWtRBXnVVxqMeef544yY/xmfriWneDOHFZ/hfwTxj8ecJGU1rxVtl3FixihP0
         pggzgc7dVppPJnYXgpFbaMknbDRDnUhPuikHmUno1cg7IQPCfUgQHalgoMTO9qbnMp
         jVFT39woeVCDQ==
Subject: [PATCH 07/41] xfs: add a realtime flag to the rmap update log redo
 items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:56 -0800
Message-ID: <167243879689.732820.2807762489821001874.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
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
 libxfs/defer_item.c     |   19 +++++++++++++++++++
 libxfs/xfs_defer.c      |    1 +
 libxfs/xfs_defer.h      |    1 +
 libxfs/xfs_log_format.h |    4 +++-
 libxfs/xfs_refcount.c   |    4 ++--
 libxfs/xfs_rmap.c       |   38 ++++++++++++++++++++++++++++++++------
 libxfs/xfs_rmap.h       |   10 +++++++---
 7 files changed, 65 insertions(+), 12 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 99899e6b617..9a4196f7cc0 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -26,6 +26,7 @@
 #include "libxfs.h"
 #include "xfs_ag.h"
 #include "xfs_swapext.h"
+#include "xfs_rtgroup.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
@@ -228,6 +229,11 @@ xfs_rmap_update_diff_items(
 	ra = container_of(a, struct xfs_rmap_intent, ri_list);
 	rb = container_of(b, struct xfs_rmap_intent, ri_list);
 
+	ASSERT(ra->ri_realtime == rb->ri_realtime);
+
+	if (ra->ri_realtime)
+		return ra->ri_rtg->rtg_rgno - rb->ri_rtg->rtg_rgno;
+
 	return ra->ri_pag->pag_agno - rb->ri_pag->pag_agno;
 }
 
@@ -264,6 +270,14 @@ xfs_rmap_update_get_group(
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
@@ -274,6 +288,11 @@ static inline void
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
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index c148ed38eb0..9dbab9ac955 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -182,6 +182,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_BMAP]	= &xfs_bmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_REFCOUNT]	= &xfs_refcount_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
+	[XFS_DEFER_OPS_TYPE_RMAP_RT]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE_RT]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 52198c7124c..89c279185ce 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -17,6 +17,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_BMAP,
 	XFS_DEFER_OPS_TYPE_REFCOUNT,
 	XFS_DEFER_OPS_TYPE_RMAP,
+	XFS_DEFER_OPS_TYPE_RMAP_RT,
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_AGFL_FREE,
 	XFS_DEFER_OPS_TYPE_FREE_RT,
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index f3c8257a754..3a23282d6e6 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
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
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 5cb2132d9ac..1590bb285ed 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1888,7 +1888,7 @@ xfs_refcount_alloc_cow_extent(
 	__xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
 
 	/* Add rmap entry */
-	xfs_rmap_alloc_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
+	xfs_rmap_alloc_extent(tp, false, fsb, len, XFS_RMAP_OWN_COW);
 }
 
 /* Forget a CoW staging event in the refcount btree. */
@@ -1904,7 +1904,7 @@ xfs_refcount_free_cow_extent(
 		return;
 
 	/* Remove rmap entry */
-	xfs_rmap_free_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
+	xfs_rmap_free_extent(tp, false, fsb, len, XFS_RMAP_OWN_COW);
 	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
 }
 
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index be611b54a6c..3700d702631 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2653,6 +2653,12 @@ xfs_rmap_finish_one(
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
@@ -2725,10 +2731,12 @@ __xfs_rmap_add(
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
@@ -2736,11 +2744,24 @@ __xfs_rmap_add(
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
@@ -2752,6 +2773,7 @@ xfs_rmap_map_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	enum xfs_rmap_intent_type type = XFS_RMAP_MAP;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
 
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, whichfork))
 		return;
@@ -2759,7 +2781,7 @@ xfs_rmap_map_extent(
 	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
 		type = XFS_RMAP_MAP_SHARED;
 
-	__xfs_rmap_add(tp, type, ip->i_ino, whichfork, PREV);
+	__xfs_rmap_add(tp, type, ip->i_ino, isrt, whichfork, PREV);
 }
 
 /* Unmap an extent out of a file. */
@@ -2771,6 +2793,7 @@ xfs_rmap_unmap_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	enum xfs_rmap_intent_type type = XFS_RMAP_UNMAP;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
 
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, whichfork))
 		return;
@@ -2778,7 +2801,7 @@ xfs_rmap_unmap_extent(
 	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
 		type = XFS_RMAP_UNMAP_SHARED;
 
-	__xfs_rmap_add(tp, type, ip->i_ino, whichfork, PREV);
+	__xfs_rmap_add(tp, type, ip->i_ino, isrt, whichfork, PREV);
 }
 
 /*
@@ -2796,6 +2819,7 @@ xfs_rmap_convert_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	enum xfs_rmap_intent_type type = XFS_RMAP_CONVERT;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
 
 	if (!xfs_rmap_update_is_needed(mp, whichfork))
 		return;
@@ -2803,13 +2827,14 @@ xfs_rmap_convert_extent(
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
@@ -2824,13 +2849,14 @@ xfs_rmap_alloc_extent(
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
@@ -2845,7 +2871,7 @@ xfs_rmap_free_extent(
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
 
-	__xfs_rmap_add(tp, XFS_RMAP_FREE, owner, XFS_DATA_FORK, &bmap);
+	__xfs_rmap_add(tp, XFS_RMAP_FREE, owner, isrt, XFS_DATA_FORK, &bmap);
 }
 
 /* Compare rmap records.  Returns -1 if a < b, 1 if a > b, and 0 if equal. */
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 54c969731cf..e98f37c39f2 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
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

