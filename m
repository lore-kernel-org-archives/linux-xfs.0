Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C787FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235815AbiLaBfU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235856AbiLaBfT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:35:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FFFDEB7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:35:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2C98B81E0A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D675C433EF;
        Sat, 31 Dec 2022 01:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450515;
        bh=QALpx0Lt1zGtv0VyG7ytw3Fyxt3muHUgETcHZ5HG5P8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cfND+io3rQWyJK+TTZhD9/SkS4iycJUZNkW7hMa/Y/evN1dxxNM4J01pEu/DcJUiM
         mbgP2GKKEXH+T6fWvvMfKJ/jbX8eSdZ77d1O+7/CD/kCbRPj6slnXdCotASqmqIPNM
         kgP9EO9Mrx2W1CkPOwmu2ZOOQw5cMyNwItLS3aJxVAZiCMdos0xxQqroAETOjTlmZf
         58FkF+AVeiwwaDy9sZj+hQDMxUB3/hJ/+EcIh0CLYG3gBt4KmCJ0SoS8YIWv/aIOAb
         bauVVfnBCIb76XaFEbSvWHLkx8SmygUN6i/fc/NG9debm3w8fbY0nBFNohyeWrx4gt
         itRbW4hrqP5JQ==
Subject: [PATCH 1/2] xfs: support logging EFIs for realtime extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:08 -0800
Message-ID: <167243868852.714671.1472196695555239524.stgit@magnolia>
In-Reply-To: <167243868836.714671.1578924317888085757.stgit@magnolia>
References: <167243868836.714671.1578924317888085757.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_alloc.c      |   35 ++++++++++++++++----
 fs/xfs/libxfs/xfs_alloc.h      |   17 ++++++++--
 fs/xfs/libxfs/xfs_defer.c      |    1 +
 fs/xfs/libxfs/xfs_defer.h      |    1 +
 fs/xfs/libxfs/xfs_log_format.h |    7 ++++
 fs/xfs/xfs_extfree_item.c      |   71 ++++++++++++++++++++++++++++++++++++++--
 6 files changed, 119 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d4943c197a76..5d091789ff74 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2607,6 +2607,7 @@ xfs_free_extent_later(
 {
 	struct xfs_extent_free_item	*xefi;
 	struct xfs_mount		*mp = tp->t_mountp;
+	enum xfs_defer_ops_type		optype;
 #ifdef DEBUG
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
@@ -2615,12 +2616,19 @@ xfs_free_extent_later(
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
@@ -2631,6 +2639,19 @@ xfs_free_extent_later(
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
 
@@ -2646,7 +2667,7 @@ xfs_free_extent_later(
 	trace_xfs_extent_free_defer(mp, xefi);
 
 	xfs_extent_free_get_group(mp, xefi);
-	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &xefi->xefi_list);
+	xfs_defer_add(tp, optype, &xefi->xefi_list);
 }
 
 #ifdef DEBUG
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 19c5f046c3c4..cd7b26568a33 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
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
 
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 1619b9b928db..c0416bae880a 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -188,6 +188,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_REFCOUNT]	= &xfs_refcount_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
+	[XFS_DEFER_OPS_TYPE_FREE_RT]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
 	[XFS_DEFER_OPS_TYPE_SWAPEXT]	= &xfs_swapext_defer_type,
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index bcc48b0c75c9..52198c7124c6 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_AGFL_FREE,
+	XFS_DEFER_OPS_TYPE_FREE_RT,
 	XFS_DEFER_OPS_TYPE_ATTR,
 	XFS_DEFER_OPS_TYPE_SWAPEXT,
 	XFS_DEFER_OPS_TYPE_MAX,
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 378201a70028..f3c8257a7545 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
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
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index e23af5ee16b1..42b89c9e996b 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -25,6 +25,10 @@
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include "xfs_rtalloc.h"
+#include "xfs_inode.h"
+#include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_efi_cache;
 struct kmem_cache	*xfs_efd_cache;
@@ -363,9 +367,17 @@ xfs_trans_free_extent(
 
 	trace_xfs_extent_free_deferred(mp, xefi);
 
-	error = __xfs_free_extent(tp, xefi->xefi_pag, agbno,
-			xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
-			xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
+	if (xfs_efi_is_realtime(xefi)) {
+		ASSERT(xefi->xefi_owner == XFS_RMAP_OWN_NULL ||
+		       xefi->xefi_owner == XFS_RMAP_OWN_UNKNOWN);
+
+		error = xfs_rtfree_blocks(tp, xefi->xefi_startblock,
+				xefi->xefi_blockcount);
+	} else {
+		error = __xfs_free_extent(tp, xefi->xefi_pag, agbno,
+				xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
+				xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
+	}
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
@@ -400,6 +412,11 @@ xfs_extent_free_diff_items(
 	ra = container_of(a, struct xfs_extent_free_item, xefi_list);
 	rb = container_of(b, struct xfs_extent_free_item, xefi_list);
 
+	ASSERT(xfs_efi_is_realtime(ra) == xfs_efi_is_realtime(rb));
+
+	if (xfs_efi_is_realtime(ra))
+		return ra->xefi_rtg->rtg_rgno - rb->xefi_rtg->rtg_rgno;
+
 	return ra->xefi_pag->pag_agno - rb->xefi_pag->pag_agno;
 }
 
@@ -426,6 +443,8 @@ xfs_extent_free_log_item(
 	extp = &efip->efi_format.efi_extents[next_extent];
 	extp->ext_start = xefi->xefi_startblock;
 	extp->ext_len = xefi->xefi_blockcount;
+	if (xfs_efi_is_realtime(xefi))
+		extp->ext_len |= XFS_EFI_EXTLEN_REALTIME_EXT;
 }
 
 static struct xfs_log_item *
@@ -467,6 +486,14 @@ xfs_extent_free_get_group(
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
@@ -477,6 +504,11 @@ static inline void
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
@@ -494,6 +526,15 @@ xfs_extent_free_finish_item(
 
 	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
 
+	/*
+	 * Lock the rt bitmap if we've any realtime extents to free and we
+	 * haven't locked the rt inodes yet.
+	 */
+	if (*state == NULL && xfs_efi_is_realtime(xefi)) {
+		xfs_rtbitmap_lock(tp, tp->t_mountp);
+		*state = (struct xfs_btree_cur *)1;
+	}
+
 	error = xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);
 
 	xfs_extent_free_put_group(xefi);
@@ -554,6 +595,7 @@ xfs_agfl_free_finish_item(
 
 	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
 	ASSERT(xefi->xefi_blockcount == 1);
+	ASSERT(!xfs_efi_is_realtime(xefi));
 	agbno = XFS_FSB_TO_AGBNO(mp, xefi->xefi_startblock);
 	oinfo.oi_owner = xefi->xefi_owner;
 
@@ -602,6 +644,10 @@ xfs_efi_validate_ext(
 	struct xfs_mount		*mp,
 	struct xfs_extent		*extp)
 {
+	if (extp->ext_len & XFS_EFI_EXTLEN_REALTIME_EXT)
+		return xfs_verify_rtbext(mp, extp->ext_start,
+				extp->ext_len & ~XFS_EFI_EXTLEN_REALTIME_EXT);
+
 	return xfs_verify_fsbext(mp, extp->ext_start, extp->ext_len);
 }
 
@@ -641,16 +687,33 @@ xfs_efi_item_recover(
 		return error;
 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
 
+	/* Lock the rt bitmap if we've any realtime extents to free. */
+	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
+		struct xfs_extent		*extp;
+
+		extp = &efip->efi_format.efi_extents[i];
+		if (extp->ext_len & XFS_EFI_EXTLEN_REALTIME_EXT) {
+			xfs_rtbitmap_lock(tp, mp);
+			break;
+		}
+	}
+
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
 		struct xfs_extent_free_item	fake = {
 			.xefi_owner		= XFS_RMAP_OWN_UNKNOWN,
 		};
 		struct xfs_extent		*extp;
+		unsigned int			len;
 
 		extp = &efip->efi_format.efi_extents[i];
 
 		fake.xefi_startblock = extp->ext_start;
-		fake.xefi_blockcount = extp->ext_len;
+		len = extp->ext_len;
+		if (len & XFS_EFI_EXTLEN_REALTIME_EXT) {
+			len &= ~XFS_EFI_EXTLEN_REALTIME_EXT;
+			fake.xefi_flags |= XFS_EFI_REALTIME;
+		}
+		fake.xefi_blockcount = len;
 
 		xfs_extent_free_get_group(mp, &fake);
 		error = xfs_trans_free_extent(tp, efdp, &fake);

