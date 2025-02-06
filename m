Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5EB23C364
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881873; cv=none; b=TtXRMVISoj00HlXbcmE8Mq8xUoe+kOJi78ggeeielZRO/7LbckjOrWB2LAr4FHpul4N5+iPqeWZLyLxl0r+F4R6zVQo9QRG4FHIhRtIqU201WiPPtS0T08LpoBWzjNf2GKirtY5zcf+ieOebcYj8o6NYbbr037g9i5qT9NLO5H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881873; c=relaxed/simple;
	bh=3Dgi2sThXVCVe0gSXAq7DbWps2IlSjtwlZ85v8VwhUc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oXy3sbZ7bbNE68UbhNC1I/titrN5ANDIRFz7rwrQOGFBl9WmmIUrRdZCrO10mtg+PD9lJFdMfsFnXIu2UBt0xmXbVBDSmUmXNdESfr3x2BaQhGEQzh4HmY3OMs9Ue3XKUMTTlk4HveiHbcIQ0SLNugTS0z6sfZv9Q9TZk6r4laM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F54ztNLK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F54ztNLK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7319C4CEDD;
	Thu,  6 Feb 2025 22:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881871;
	bh=3Dgi2sThXVCVe0gSXAq7DbWps2IlSjtwlZ85v8VwhUc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F54ztNLKR4wgQvPTFAsBl//uQfeNEH4Ty/bTJEKtewtRTTVd2kcbB47peoi7gxPGP
	 FTJivZyejbhm2uCKGGDthcSEWfd80DqjzuAXyrA5koOr8dR2xhOPOPBJ2NCispVTaM
	 wPzLN07AQaK02TbT4byU6Pa82kHsHWNicQO4BIDq0fNcOb6M0tG9RrRORzVvh0J+16
	 chMNasInb4C6jKM5wUVDAcDYJky08QbU2xSG6w+QQ6zrqD6LzzWcXNd/ZjC3C+KoU5
	 yRgvtcdPeQ/XfrMJxSxi9f/HcMKRGJnfM/ITDGreqdexXM1hSJ4pwESxUKMwaK1iiI
	 yro2k706sXqhw==
Date: Thu, 06 Feb 2025 14:44:31 -0800
Subject: [PATCH 36/56] xfs: add a realtime flag to the refcount update log
 redo items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087343.2739176.11074130000913899276.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: fd9300679ccec20c6ee1b95458ab0bcf0db628d5

Extend the refcount update (CUI) log items with a new realtime flag that
indicates that the updates apply against the realtime refcountbt.  We'll
wire up the actual refcount code later.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c       |   10 ++++---
 libxfs/xfs_defer.h      |    1 +
 libxfs/xfs_log_format.h |    6 ++++
 libxfs/xfs_refcount.c   |   63 ++++++++++++++++++++++++++++++++++-------------
 libxfs/xfs_refcount.h   |   17 +++++++------
 5 files changed, 67 insertions(+), 30 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 41cfadb51f4937..9cfbdb85c975a5 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4558,8 +4558,9 @@ xfs_bmapi_write(
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
@@ -4734,7 +4735,8 @@ xfs_bmapi_convert_one_delalloc(
 		*seq = READ_ONCE(ifp->if_seq);
 
 	if (whichfork == XFS_COW_FORK)
-		xfs_refcount_alloc_cow_extent(tp, bma.blkno, bma.length);
+		xfs_refcount_alloc_cow_extent(tp, XFS_IS_REALTIME_INODE(ip),
+				bma.blkno, bma.length);
 
 	error = xfs_bmap_btree_to_extents(tp, ip, bma.cur, &bma.logflags,
 			whichfork);
@@ -5382,7 +5384,7 @@ xfs_bmap_del_extent_real(
 		bool	isrt = xfs_ifork_is_realtime(ip, whichfork);
 
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
-			xfs_refcount_decrease_extent(tp, del);
+			xfs_refcount_decrease_extent(tp, isrt, del);
 		} else if (isrt && !xfs_has_rtgroups(mp)) {
 			error = xfs_bmap_free_rtblocks(tp, del);
 		} else {
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 1e2477eaa5a844..9effd95ddcd4ee 100644
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
index a7e0e479454d3d..ec7157eaba5f68 100644
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
index 83e039c3c3afa8..ef08c26c75b32c 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1122,6 +1122,22 @@ xfs_refcount_still_have_space(
 		cur->bc_refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
 }
 
+/* Schedule an extent free. */
+static int
+xrefc_free_extent(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*rec)
+{
+	unsigned int			flags = 0;
+
+	if (xfs_btree_is_rtrefcount(cur->bc_ops))
+		flags |= XFS_FREE_EXTENT_REALTIME;
+
+	return xfs_free_extent_later(cur->bc_tp,
+			xfs_gbno_to_fsb(cur->bc_group, rec->rc_startblock),
+			rec->rc_blockcount, NULL, XFS_AG_RESV_NONE, flags);
+}
+
 /*
  * Adjust the refcounts of middle extents.  At this point we should have
  * split extents that crossed the adjustment range; merged with adjacent
@@ -1138,7 +1154,6 @@ xfs_refcount_adjust_extents(
 	struct xfs_refcount_irec	ext, tmp;
 	int				error;
 	int				found_rec, found_tmp;
-	xfs_fsblock_t			fsbno;
 
 	/* Merging did all the work already. */
 	if (*aglen == 0)
@@ -1191,11 +1206,7 @@ xfs_refcount_adjust_extents(
 					goto out_error;
 				}
 			} else {
-				fsbno = xfs_agbno_to_fsb(to_perag(cur->bc_group),
-						tmp.rc_startblock);
-				error = xfs_free_extent_later(cur->bc_tp, fsbno,
-						  tmp.rc_blockcount, NULL,
-						  XFS_AG_RESV_NONE, 0);
+				error = xrefc_free_extent(cur, &tmp);
 				if (error)
 					goto out_error;
 			}
@@ -1253,11 +1264,7 @@ xfs_refcount_adjust_extents(
 			}
 			goto advloop;
 		} else {
-			fsbno = xfs_agbno_to_fsb(to_perag(cur->bc_group),
-					ext.rc_startblock);
-			error = xfs_free_extent_later(cur->bc_tp, fsbno,
-					ext.rc_blockcount, NULL,
-					XFS_AG_RESV_NONE, 0);
+			error = xrefc_free_extent(cur, &ext);
 			if (error)
 				goto out_error;
 		}
@@ -1453,6 +1460,20 @@ xfs_refcount_finish_one(
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
@@ -1460,6 +1481,7 @@ static void
 __xfs_refcount_add(
 	struct xfs_trans		*tp,
 	enum xfs_refcount_intent_type	type,
+	bool				isrt,
 	xfs_fsblock_t			startblock,
 	xfs_extlen_t			blockcount)
 {
@@ -1471,6 +1493,7 @@ __xfs_refcount_add(
 	ri->ri_type = type;
 	ri->ri_startblock = startblock;
 	ri->ri_blockcount = blockcount;
+	ri->ri_realtime = isrt;
 
 	xfs_refcount_defer_add(tp, ri);
 }
@@ -1481,12 +1504,13 @@ __xfs_refcount_add(
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
 
@@ -1496,12 +1520,13 @@ xfs_refcount_increase_extent(
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
 
@@ -1857,6 +1882,7 @@ __xfs_refcount_cow_free(
 void
 xfs_refcount_alloc_cow_extent(
 	struct xfs_trans		*tp,
+	bool				isrt,
 	xfs_fsblock_t			fsb,
 	xfs_extlen_t			len)
 {
@@ -1865,16 +1891,17 @@ xfs_refcount_alloc_cow_extent(
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
@@ -1884,8 +1911,8 @@ xfs_refcount_free_cow_extent(
 		return;
 
 	/* Remove rmap entry */
-	xfs_rmap_free_extent(tp, false, fsb, len, XFS_RMAP_OWN_COW);
-	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
+	xfs_rmap_free_extent(tp, isrt, fsb, len, XFS_RMAP_OWN_COW);
+	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, isrt, fsb, len);
 }
 
 struct xfs_refcount_recovery {
@@ -1991,7 +2018,7 @@ xfs_refcount_recover_cow_leftovers(
 
 		/* Free the orphan record */
 		fsb = xfs_agbno_to_fsb(pag, rr->rr_rrec.rc_startblock);
-		xfs_refcount_free_cow_extent(tp, fsb,
+		xfs_refcount_free_cow_extent(tp, false, fsb,
 				rr->rr_rrec.rc_blockcount);
 
 		/* Free the block. */
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 9cd58d48716f83..be11df25abcc5b 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -61,6 +61,7 @@ struct xfs_refcount_intent {
 	enum xfs_refcount_intent_type		ri_type;
 	xfs_extlen_t				ri_blockcount;
 	xfs_fsblock_t				ri_startblock;
+	bool					ri_realtime;
 };
 
 /* Check that the refcount is appropriate for the record domain. */
@@ -75,22 +76,24 @@ xfs_refcount_check_domain(
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
 

