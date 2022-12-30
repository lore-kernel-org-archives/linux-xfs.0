Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B716BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbiLaCmK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiLaCmC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:42:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718162DED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:42:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE099B81E0E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB229C433EF;
        Sat, 31 Dec 2022 02:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454518;
        bh=ffKIKdGyZDJVZi1OhiSbo5Du1wcQEznlEqOQ8uGanhE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hpL3bgmFVV2vzJNBTIp0Isa54Mh+9rE1ZE5jj6Rbj/PEZXwGO/VTta61MLxmsKDHD
         6B2RDReQxeOwv/diZDd2IIQaBHOMv1dEW/a1REAMKdk38BYAMNdDVKiSIdRp8nKg+u
         DkHoL9+zySDeicNkZjscJO95bY9ygq1jdJ3+izs5/SuvgQ2qyoWiFsCueY8aU7diKN
         boUabS18r7LbHl9F3gXcDYAahkk02CEpT0D6w+QsHC5z5ZLql0P0yCKbYEPN5/3sN2
         jloye8bgU0Pt/VhiR5i4j5wQ2Wp+1ryFCd4GRTEfW78jiAo7wHE04/tiGYmyeDxW+6
         p32EFmL1grlJQ==
Subject: [PATCH 1/3] xfs: support logging EFIs for realtime extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:52 -0800
Message-ID: <167243879244.732626.614120343355027575.stgit@magnolia>
In-Reply-To: <167243879231.732626.2849871285052288588.stgit@magnolia>
References: <167243879231.732626.2849871285052288588.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the EFI mechanism how to free realtime extents.  We do this very
sneakily, by using the upper bit of the length field in the log format
(and a boolean flag incore) to convey the realtime status.  We're going
to need this to enforce proper ordering of operations when we enable
realtime rmap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c     |   18 ++++++++++++++++++
 libxfs/xfs_alloc.c      |   35 ++++++++++++++++++++++++++++-------
 libxfs/xfs_alloc.h      |   17 +++++++++++++++--
 libxfs/xfs_defer.c      |    1 +
 libxfs/xfs_defer.h      |    1 +
 libxfs/xfs_log_format.h |    7 +++++++
 6 files changed, 70 insertions(+), 9 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index be6ecbc348f..99899e6b617 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -44,6 +44,11 @@ xfs_extent_free_diff_items(
 	ra = container_of(a, struct xfs_extent_free_item, xefi_list);
 	rb = container_of(b, struct xfs_extent_free_item, xefi_list);
 
+	ASSERT(xfs_efi_is_realtime(ra) == xfs_efi_is_realtime(rb));
+
+	if (xfs_efi_is_realtime(ra))
+		return ra->xefi_rtg->rtg_rgno - rb->xefi_rtg->rtg_rgno;
+
 	return ra->xefi_pag->pag_agno - rb->xefi_pag->pag_agno;
 }
 
@@ -80,6 +85,14 @@ xfs_extent_free_get_group(
 {
 	xfs_agnumber_t			agno;
 
+	if (xfs_efi_is_realtime(xefi)) {
+		xfs_rgnumber_t		rgno;
+
+		rgno = xfs_rtb_to_rgno(mp, xefi->xefi_startblock);
+		xefi->xefi_rtg = xfs_rtgroup_get(mp, rgno);
+		return;
+	}
+
 	agno = XFS_FSB_TO_AGNO(mp, xefi->xefi_startblock);
 	xefi->xefi_pag = xfs_perag_get(mp, agno);
 	xfs_perag_bump_intents(xefi->xefi_pag);
@@ -90,6 +103,11 @@ static inline void
 xfs_extent_free_put_group(
 	struct xfs_extent_free_item	*xefi)
 {
+	if (xfs_efi_is_realtime(xefi)) {
+		xfs_rtgroup_put(xefi->xefi_rtg);
+		return;
+	}
+
 	xfs_perag_drop_intents(xefi->xefi_pag);
 	xfs_perag_put(xefi->xefi_pag);
 }
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 461178716b6..43b63462374 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2603,6 +2603,7 @@ xfs_free_extent_later(
 {
 	struct xfs_extent_free_item	*xefi;
 	struct xfs_mount		*mp = tp->t_mountp;
+	enum xfs_defer_ops_type		optype;
 #ifdef DEBUG
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
@@ -2611,12 +2612,19 @@ xfs_free_extent_later(
 	ASSERT(len > 0);
 	ASSERT(len <= XFS_MAX_BMBT_EXTLEN);
 	ASSERT(!isnullstartblock(bno));
-	agno = XFS_FSB_TO_AGNO(mp, bno);
-	agbno = XFS_FSB_TO_AGBNO(mp, bno);
-	ASSERT(agno < mp->m_sb.sb_agcount);
-	ASSERT(agbno < mp->m_sb.sb_agblocks);
-	ASSERT(len < mp->m_sb.sb_agblocks);
-	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
+	if (flags & XFS_FREE_EXTENT_REALTIME) {
+		ASSERT(bno < mp->m_sb.sb_rblocks);
+		ASSERT(len <= mp->m_sb.sb_rblocks);
+		ASSERT(bno + len <= mp->m_sb.sb_rblocks);
+	} else {
+		agno = XFS_FSB_TO_AGNO(mp, bno);
+		agbno = XFS_FSB_TO_AGBNO(mp, bno);
+
+		ASSERT(agno < mp->m_sb.sb_agcount);
+		ASSERT(agbno < mp->m_sb.sb_agblocks);
+		ASSERT(len < mp->m_sb.sb_agblocks);
+		ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
+	}
 #endif
 	ASSERT(!(flags & ~XFS_FREE_EXTENT_ALL_FLAGS));
 	ASSERT(xfs_extfree_item_cache != NULL);
@@ -2627,6 +2635,19 @@ xfs_free_extent_later(
 	xefi->xefi_blockcount = (xfs_extlen_t)len;
 	if (flags & XFS_FREE_EXTENT_SKIP_DISCARD)
 		xefi->xefi_flags |= XFS_EFI_SKIP_DISCARD;
+	if (flags & XFS_FREE_EXTENT_REALTIME) {
+		/*
+		 * Realtime and data section EFIs must use separate
+		 * transactions to finish deferred work because updates to
+		 * realtime metadata files can lock AGFs to allocate btree
+		 * blocks and we don't want that mixing with the AGF locks
+		 * taken to finish data section EFIs.
+		 */
+		optype = XFS_DEFER_OPS_TYPE_FREE_RT;
+		xefi->xefi_flags |= XFS_EFI_REALTIME;
+	} else {
+		optype = XFS_DEFER_OPS_TYPE_FREE;
+	}
 	if (oinfo) {
 		ASSERT(oinfo->oi_offset == 0);
 
@@ -2642,7 +2663,7 @@ xfs_free_extent_later(
 	trace_xfs_extent_free_defer(mp, xefi);
 
 	xfs_extent_free_get_group(mp, xefi);
-	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &xefi->xefi_list);
+	xfs_defer_add(tp, optype, &xefi->xefi_list);
 }
 
 #ifdef DEBUG
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 19c5f046c3c..cd7b26568a3 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -228,7 +228,11 @@ void xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
 /* Don't issue a discard for the blocks freed. */
 #define XFS_FREE_EXTENT_SKIP_DISCARD	(1U << 0)
 
-#define XFS_FREE_EXTENT_ALL_FLAGS	(XFS_FREE_EXTENT_SKIP_DISCARD)
+/* Free blocks on the realtime device. */
+#define XFS_FREE_EXTENT_REALTIME	(1U << 1)
+
+#define XFS_FREE_EXTENT_ALL_FLAGS	(XFS_FREE_EXTENT_SKIP_DISCARD | \
+					 XFS_FREE_EXTENT_REALTIME)
 
 /*
  * List of extents to be free "later".
@@ -239,7 +243,10 @@ struct xfs_extent_free_item {
 	uint64_t		xefi_owner;
 	xfs_fsblock_t		xefi_startblock;/* starting fs block number */
 	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
-	struct xfs_perag	*xefi_pag;
+	union {
+		struct xfs_perag	*xefi_pag;
+		struct xfs_rtgroup	*xefi_rtg;
+	};
 	unsigned int		xefi_flags;
 };
 
@@ -249,6 +256,12 @@ void xfs_extent_free_get_group(struct xfs_mount *mp,
 #define XFS_EFI_SKIP_DISCARD	(1U << 0) /* don't issue discard */
 #define XFS_EFI_ATTR_FORK	(1U << 1) /* freeing attr fork block */
 #define XFS_EFI_BMBT_BLOCK	(1U << 2) /* freeing bmap btree block */
+#define XFS_EFI_REALTIME	(1U << 3) /* freeing realtime extent */
+
+static inline bool xfs_efi_is_realtime(const struct xfs_extent_free_item *xefi)
+{
+	return xefi->xefi_flags & XFS_EFI_REALTIME;
+}
 
 extern struct kmem_cache	*xfs_extfree_item_cache;
 
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 47a7c5ed1f5..c148ed38eb0 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -183,6 +183,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_REFCOUNT]	= &xfs_refcount_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
+	[XFS_DEFER_OPS_TYPE_FREE_RT]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
 	[XFS_DEFER_OPS_TYPE_SWAPEXT]	= &xfs_swapext_defer_type,
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index bcc48b0c75c..52198c7124c 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_AGFL_FREE,
+	XFS_DEFER_OPS_TYPE_FREE_RT,
 	XFS_DEFER_OPS_TYPE_ATTR,
 	XFS_DEFER_OPS_TYPE_SWAPEXT,
 	XFS_DEFER_OPS_TYPE_MAX,
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 378201a7002..f3c8257a754 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -591,6 +591,13 @@ typedef struct xfs_extent {
 	xfs_extlen_t	ext_len;
 } xfs_extent_t;
 
+/*
+ * This EFI extent describes a realtime extent.  We can never free more than
+ * XFS_MAX_BMBT_EXTLEN (2^21) blocks at a time, so we know that the upper bits
+ * of ext_len cannot be used.
+ */
+#define XFS_EFI_EXTLEN_REALTIME_EXT	(1U << 31)
+
 /*
  * Since an xfs_extent_t has types (start:64, len: 32)
  * there are different alignments on 32 bit and 64 bit kernels.

