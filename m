Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B8A8BEC
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052325; cv=none; b=KSMpt3i8NL+Z0LhY4KRLwaxc5OnLZDFNz7S6+srxBeWlOxgOLiO2sNhbxmRL3fFcbOZ71S5/69N21wFVHBHiofXf9BLuHRxzXRBq+Ms8PEUlItWao3xUUcQKNCc9nJUkhpSf5EJ5uZJKZ6VVW9HQS1bCMGa8KBWFMnDVLXYJXCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052325; c=relaxed/simple;
	bh=CTU1Unf2PoYMcqLriZnzLrfSK5Z/1+nWhSVoLZfu9IE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lpQjh1zuWYrLz17ybrZOUQlmNY9lnAeuheZFK/j0qLSCDkZx/jh68234whimzegYqtyGiAHMhnHUYTRt6kG+3u7yUgFtFZbpZJaTiGyfEfAlg3jtfmycd46JC+pNpCG6IDwOgVdyVERu0+hz3twJbdd4rWReV232zln9rYwfdmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I6IGOzF8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I6IGOzF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD9DC4CECE;
	Fri, 13 Dec 2024 01:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052324;
	bh=CTU1Unf2PoYMcqLriZnzLrfSK5Z/1+nWhSVoLZfu9IE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=I6IGOzF87HzE0xJ4tWz7wM3MDKdOmX+NPHe+FMU/vF87XoIDwFY4VZ4sJlcegPfUE
	 0RBuJ91TTjIzBp5Tfdu2e5c93na7QRkkgsrWiXvJRUtRhsJno1PA9Pd2OIW9rti7z7
	 xBhOLV4YxtIiwV2XI0wgSbwm6SE7+qRfw+o94Um05VeO4NsgNpYKxm1KtemD/ummUf
	 P6nn41JmK0hoZhfPWXU+RtOdE2fCkUO13zO1+OTAMEG7ZpJowD/VGg+AX7qTMaop/e
	 YYYBoTPdu60YfwYe4y57XFtNr//IhYdjro8mLlBfzb93VudOdH6HyplOmnWsS89SHe
	 Chg5M6wytP6kA==
Date: Thu, 12 Dec 2024 17:12:04 -0800
Subject: [PATCH 07/43] xfs: add a realtime flag to the refcount update log
 redo items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405124687.1182620.16319663799309491735.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c        |   10 +-
 fs/xfs/libxfs/xfs_defer.h       |    1 
 fs/xfs/libxfs/xfs_log_format.h  |    6 +
 fs/xfs/libxfs/xfs_log_recover.h |    2 
 fs/xfs/libxfs/xfs_refcount.c    |   64 ++++++++---
 fs/xfs/libxfs/xfs_refcount.h    |   17 ++-
 fs/xfs/scrub/cow_repair.c       |    2 
 fs/xfs/scrub/reap.c             |    5 +
 fs/xfs/xfs_log_recover.c        |    2 
 fs/xfs/xfs_refcount_item.c      |  224 +++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_reflink.c            |   19 ++-
 11 files changed, 298 insertions(+), 54 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 02323936cc9b20..d63713630236e7 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4564,8 +4564,9 @@ xfs_bmapi_write(
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
@@ -4740,7 +4741,8 @@ xfs_bmapi_convert_one_delalloc(
 		*seq = READ_ONCE(ifp->if_seq);
 
 	if (whichfork == XFS_COW_FORK)
-		xfs_refcount_alloc_cow_extent(tp, bma.blkno, bma.length);
+		xfs_refcount_alloc_cow_extent(tp, XFS_IS_REALTIME_INODE(ip),
+				bma.blkno, bma.length);
 
 	error = xfs_bmap_btree_to_extents(tp, ip, bma.cur, &bma.logflags,
 			whichfork);
@@ -5388,7 +5390,7 @@ xfs_bmap_del_extent_real(
 		bool	isrt = xfs_ifork_is_realtime(ip, whichfork);
 
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
-			xfs_refcount_decrease_extent(tp, del);
+			xfs_refcount_decrease_extent(tp, isrt, del);
 		} else if (isrt && !xfs_has_rtgroups(mp)) {
 			error = xfs_bmap_free_rtblocks(tp, del);
 		} else {
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 1e2477eaa5a844..9effd95ddcd4ee 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -68,6 +68,7 @@ struct xfs_defer_op_type {
 
 extern const struct xfs_defer_op_type xfs_bmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
+extern const struct xfs_defer_op_type xfs_rtrefcount_update_defer_type;
 extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_rtrmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index a7e0e479454d3d..ec7157eaba5f68 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
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
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index abc705aff26dfe..66c7916fb5cd5e 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -81,6 +81,8 @@ extern const struct xlog_recover_item_ops xlog_rtefi_item_ops;
 extern const struct xlog_recover_item_ops xlog_rtefd_item_ops;
 extern const struct xlog_recover_item_ops xlog_rtrui_item_ops;
 extern const struct xlog_recover_item_ops xlog_rtrud_item_ops;
+extern const struct xlog_recover_item_ops xlog_rtcui_item_ops;
+extern const struct xlog_recover_item_ops xlog_rtcud_item_ops;
 
 /*
  * Macros, structures, prototypes for internal log manager use.
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 9be40ac16c7d56..8007d15856252b 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -26,6 +26,7 @@
 #include "xfs_health.h"
 #include "xfs_refcount_item.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtalloc.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
 
@@ -1123,6 +1124,22 @@ xfs_refcount_still_have_space(
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
@@ -1139,7 +1156,6 @@ xfs_refcount_adjust_extents(
 	struct xfs_refcount_irec	ext, tmp;
 	int				error;
 	int				found_rec, found_tmp;
-	xfs_fsblock_t			fsbno;
 
 	/* Merging did all the work already. */
 	if (*aglen == 0)
@@ -1192,11 +1208,7 @@ xfs_refcount_adjust_extents(
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
@@ -1254,11 +1266,7 @@ xfs_refcount_adjust_extents(
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
@@ -1454,6 +1462,20 @@ xfs_refcount_finish_one(
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
@@ -1461,6 +1483,7 @@ static void
 __xfs_refcount_add(
 	struct xfs_trans		*tp,
 	enum xfs_refcount_intent_type	type,
+	bool				isrt,
 	xfs_fsblock_t			startblock,
 	xfs_extlen_t			blockcount)
 {
@@ -1472,6 +1495,7 @@ __xfs_refcount_add(
 	ri->ri_type = type;
 	ri->ri_startblock = startblock;
 	ri->ri_blockcount = blockcount;
+	ri->ri_realtime = isrt;
 
 	xfs_refcount_defer_add(tp, ri);
 }
@@ -1482,12 +1506,13 @@ __xfs_refcount_add(
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
 
@@ -1497,12 +1522,13 @@ xfs_refcount_increase_extent(
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
 
@@ -1858,6 +1884,7 @@ __xfs_refcount_cow_free(
 void
 xfs_refcount_alloc_cow_extent(
 	struct xfs_trans		*tp,
+	bool				isrt,
 	xfs_fsblock_t			fsb,
 	xfs_extlen_t			len)
 {
@@ -1866,16 +1893,17 @@ xfs_refcount_alloc_cow_extent(
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
@@ -1885,8 +1913,8 @@ xfs_refcount_free_cow_extent(
 		return;
 
 	/* Remove rmap entry */
-	xfs_rmap_free_extent(tp, false, fsb, len, XFS_RMAP_OWN_COW);
-	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
+	xfs_rmap_free_extent(tp, isrt, fsb, len, XFS_RMAP_OWN_COW);
+	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, isrt, fsb, len);
 }
 
 struct xfs_refcount_recovery {
@@ -1992,7 +2020,7 @@ xfs_refcount_recover_cow_leftovers(
 
 		/* Free the orphan record */
 		fsb = xfs_agbno_to_fsb(pag, rr->rr_rrec.rc_startblock);
-		xfs_refcount_free_cow_extent(tp, fsb,
+		xfs_refcount_free_cow_extent(tp, false, fsb,
 				rr->rr_rrec.rc_blockcount);
 
 		/* Free the block. */
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 9cd58d48716f83..be11df25abcc5b 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
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
 
diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index 5b6194cef3e5e3..ba695dd21f8b96 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -343,7 +343,7 @@ xrep_cow_alloc(
 	if (args.fsbno == NULLFSBLOCK)
 		return -ENOSPC;
 
-	xfs_refcount_alloc_cow_extent(sc->tp, args.fsbno, args.len);
+	xfs_refcount_alloc_cow_extent(sc->tp, false, args.fsbno, args.len);
 
 	repl->fsbno = args.fsbno;
 	repl->len = args.len;
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 4d7f1b82dc559d..534c7696e9a1a7 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -419,7 +419,8 @@ xreap_agextent_iter(
 			 * records from the refcountbt, which will remove the
 			 * rmap record as well.
 			 */
-			xfs_refcount_free_cow_extent(sc->tp, fsbno, *aglenp);
+			xfs_refcount_free_cow_extent(sc->tp, false, fsbno,
+					*aglenp);
 			return 0;
 		}
 
@@ -451,7 +452,7 @@ xreap_agextent_iter(
 	if (rs->oinfo == &XFS_RMAP_OINFO_COW) {
 		ASSERT(rs->resv == XFS_AG_RESV_NONE);
 
-		xfs_refcount_free_cow_extent(sc->tp, fsbno, *aglenp);
+		xfs_refcount_free_cow_extent(sc->tp, false, fsbno, *aglenp);
 		error = xfs_free_extent_later(sc->tp, fsbno, *aglenp, NULL,
 				rs->resv, XFS_FREE_EXTENT_SKIP_DISCARD);
 		if (error)
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5c95c97519c767..b3c27dbccce861 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1822,6 +1822,8 @@ static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
 	&xlog_rtefd_item_ops,
 	&xlog_rtrui_item_ops,
 	&xlog_rtrud_item_ops,
+	&xlog_rtcui_item_ops,
+	&xlog_rtcud_item_ops,
 };
 
 static const struct xlog_recover_item_ops *
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index c807c4b90c44e3..2086d40514d086 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -23,6 +23,7 @@
 #include "xfs_ag.h"
 #include "xfs_btree.h"
 #include "xfs_trace.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_cui_cache;
 struct kmem_cache	*xfs_cud_cache;
@@ -94,8 +95,9 @@ xfs_cui_item_format(
 
 	ASSERT(atomic_read(&cuip->cui_next_extent) ==
 			cuip->cui_format.cui_nextents);
+	ASSERT(lip->li_type == XFS_LI_CUI || lip->li_type == XFS_LI_CUI_RT);
 
-	cuip->cui_format.cui_type = XFS_LI_CUI;
+	cuip->cui_format.cui_type = lip->li_type;
 	cuip->cui_format.cui_size = 1;
 
 	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_CUI_FORMAT, &cuip->cui_format,
@@ -138,12 +140,14 @@ xfs_cui_item_release(
 STATIC struct xfs_cui_log_item *
 xfs_cui_init(
 	struct xfs_mount		*mp,
+	unsigned short			item_type,
 	uint				nextents)
-
 {
 	struct xfs_cui_log_item		*cuip;
 
 	ASSERT(nextents > 0);
+	ASSERT(item_type == XFS_LI_CUI || item_type == XFS_LI_CUI_RT);
+
 	if (nextents > XFS_CUI_MAX_FAST_EXTENTS)
 		cuip = kzalloc(xfs_cui_log_item_sizeof(nextents),
 				GFP_KERNEL | __GFP_NOFAIL);
@@ -151,7 +155,7 @@ xfs_cui_init(
 		cuip = kmem_cache_zalloc(xfs_cui_cache,
 					 GFP_KERNEL | __GFP_NOFAIL);
 
-	xfs_log_item_init(mp, &cuip->cui_item, XFS_LI_CUI, &xfs_cui_item_ops);
+	xfs_log_item_init(mp, &cuip->cui_item, item_type, &xfs_cui_item_ops);
 	cuip->cui_format.cui_nextents = nextents;
 	cuip->cui_format.cui_id = (uintptr_t)(void *)cuip;
 	atomic_set(&cuip->cui_next_extent, 0);
@@ -190,7 +194,9 @@ xfs_cud_item_format(
 	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
 	struct xfs_log_iovec	*vecp = NULL;
 
-	cudp->cud_format.cud_type = XFS_LI_CUD;
+	ASSERT(lip->li_type == XFS_LI_CUD || lip->li_type == XFS_LI_CUD_RT);
+
+	cudp->cud_format.cud_type = lip->li_type;
 	cudp->cud_format.cud_size = 1;
 
 	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_CUD_FORMAT, &cudp->cud_format,
@@ -234,6 +240,14 @@ static inline struct xfs_refcount_intent *ci_entry(const struct list_head *e)
 	return list_entry(e, struct xfs_refcount_intent, ri_list);
 }
 
+static inline bool
+xfs_cui_item_isrt(const struct xfs_log_item *lip)
+{
+	ASSERT(lip->li_type == XFS_LI_CUI || lip->li_type == XFS_LI_CUI_RT);
+
+	return lip->li_type == XFS_LI_CUI_RT;
+}
+
 /* Sort refcount intents by AG. */
 static int
 xfs_refcount_update_diff_items(
@@ -282,18 +296,20 @@ xfs_refcount_update_log_item(
 }
 
 static struct xfs_log_item *
-xfs_refcount_update_create_intent(
+__xfs_refcount_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
 	unsigned int			count,
-	bool				sort)
+	bool				sort,
+	unsigned short			item_type)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_cui_log_item		*cuip = xfs_cui_init(mp, count);
+	struct xfs_cui_log_item		*cuip;
 	struct xfs_refcount_intent	*ri;
 
 	ASSERT(count > 0);
 
+	cuip = xfs_cui_init(mp, item_type, count);
 	if (sort)
 		list_sort(mp, items, xfs_refcount_update_diff_items);
 	list_for_each_entry(ri, items, ri_list)
@@ -301,6 +317,23 @@ xfs_refcount_update_create_intent(
 	return &cuip->cui_item;
 }
 
+static struct xfs_log_item *
+xfs_refcount_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	return __xfs_refcount_update_create_intent(tp, items, count, sort,
+			XFS_LI_CUI);
+}
+
+static inline unsigned short
+xfs_cud_type_from_cui(const struct xfs_cui_log_item *cuip)
+{
+	return xfs_cui_item_isrt(&cuip->cui_item) ? XFS_LI_CUD_RT : XFS_LI_CUD;
+}
+
 /* Get an CUD so we can process all the deferred refcount updates. */
 static struct xfs_log_item *
 xfs_refcount_update_create_done(
@@ -312,8 +345,8 @@ xfs_refcount_update_create_done(
 	struct xfs_cud_log_item		*cudp;
 
 	cudp = kmem_cache_zalloc(xfs_cud_cache, GFP_KERNEL | __GFP_NOFAIL);
-	xfs_log_item_init(tp->t_mountp, &cudp->cud_item, XFS_LI_CUD,
-			  &xfs_cud_item_ops);
+	xfs_log_item_init(tp->t_mountp, &cudp->cud_item,
+			xfs_cud_type_from_cui(cuip), &xfs_cud_item_ops);
 	cudp->cud_cuip = cuip;
 	cudp->cud_format.cud_cui_id = cuip->cui_format.cui_id;
 
@@ -328,10 +361,20 @@ xfs_refcount_defer_add(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 
-	ri->ri_group = xfs_group_intent_get(mp, ri->ri_startblock, XG_TYPE_AG);
+	/*
+	 * Deferred refcount updates for the realtime and data sections must
+	 * use separate transactions to finish deferred work because updates to
+	 * realtime metadata files can lock AGFs to allocate btree blocks and
+	 * we don't want that mixing with the AGF locks taken to finish data
+	 * section updates.
+	 */
+	ri->ri_group = xfs_group_intent_get(mp, ri->ri_startblock,
+			ri->ri_realtime ? XG_TYPE_RTG : XG_TYPE_AG);
 
 	trace_xfs_refcount_defer(mp, ri);
-	xfs_defer_add(tp, &ri->ri_list, &xfs_refcount_update_defer_type);
+	xfs_defer_add(tp, &ri->ri_list, ri->ri_realtime ?
+			&xfs_rtrefcount_update_defer_type :
+			&xfs_refcount_update_defer_type);
 }
 
 /* Cancel a deferred refcount update. */
@@ -381,7 +424,7 @@ xfs_refcount_finish_one_cleanup(
 		return;
 	agbp = rcur->bc_ag.agbp;
 	xfs_btree_del_cursor(rcur, error);
-	if (error)
+	if (error && agbp)
 		xfs_trans_brelse(tp, agbp);
 }
 
@@ -515,10 +558,13 @@ xfs_refcount_relog_intent(
 	struct xfs_phys_extent		*pmap;
 	unsigned int			count;
 
+	ASSERT(intent->li_type == XFS_LI_CUI ||
+	       intent->li_type == XFS_LI_CUI_RT);
+
 	count = CUI_ITEM(intent)->cui_format.cui_nextents;
 	pmap = CUI_ITEM(intent)->cui_format.cui_extents;
 
-	cuip = xfs_cui_init(tp->t_mountp, count);
+	cuip = xfs_cui_init(tp->t_mountp, intent->li_type, count);
 	memcpy(cuip->cui_format.cui_extents, pmap, count * sizeof(*pmap));
 	atomic_set(&cuip->cui_next_extent, count);
 
@@ -538,6 +584,71 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.relog_intent	= xfs_refcount_relog_intent,
 };
 
+#ifdef CONFIG_XFS_RT
+static struct xfs_log_item *
+xfs_rtrefcount_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	return __xfs_refcount_update_create_intent(tp, items, count, sort,
+			XFS_LI_CUI_RT);
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
+	xfs_refcount_update_cancel_item(item);
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
+	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_rtrefcount_update_create_intent,
+	.abort_intent	= xfs_refcount_update_abort_intent,
+	.create_done	= xfs_refcount_update_create_done,
+	.finish_item	= xfs_rtrefcount_update_finish_item,
+	.finish_cleanup = xfs_rtrefcount_finish_one_cleanup,
+	.cancel_item	= xfs_refcount_update_cancel_item,
+	.recover_work	= xfs_refcount_recover_work,
+	.relog_intent	= xfs_refcount_relog_intent,
+};
+#else
+const struct xfs_defer_op_type xfs_rtrefcount_update_defer_type = {
+	.name		= "rtrefcount",
+};
+#endif /* CONFIG_XFS_RT */
+
 STATIC bool
 xfs_cui_item_match(
 	struct xfs_log_item	*lip,
@@ -603,7 +714,7 @@ xlog_recover_cui_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
-	cuip = xfs_cui_init(mp, cui_formatp->cui_nextents);
+	cuip = xfs_cui_init(mp, ITEM_TYPE(item), cui_formatp->cui_nextents);
 	xfs_cui_copy_format(&cuip->cui_format, cui_formatp);
 	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
 
@@ -617,6 +728,61 @@ const struct xlog_recover_item_ops xlog_cui_item_ops = {
 	.commit_pass2		= xlog_recover_cui_commit_pass2,
 };
 
+#ifdef CONFIG_XFS_RT
+STATIC int
+xlog_recover_rtcui_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_cui_log_item		*cuip;
+	struct xfs_cui_log_format	*cui_formatp;
+	size_t				len;
+
+	cui_formatp = item->ri_buf[0].i_addr;
+
+	if (item->ri_buf[0].i_len < xfs_cui_log_format_sizeof(0)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+		return -EFSCORRUPTED;
+	}
+
+	len = xfs_cui_log_format_sizeof(cui_formatp->cui_nextents);
+	if (item->ri_buf[0].i_len != len) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+		return -EFSCORRUPTED;
+	}
+
+	cuip = xfs_cui_init(mp, ITEM_TYPE(item), cui_formatp->cui_nextents);
+	xfs_cui_copy_format(&cuip->cui_format, cui_formatp);
+	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
+
+	xlog_recover_intent_item(log, &cuip->cui_item, lsn,
+			&xfs_rtrefcount_update_defer_type);
+	return 0;
+}
+#else
+STATIC int
+xlog_recover_rtcui_commit_pass2(
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
+const struct xlog_recover_item_ops xlog_rtcui_item_ops = {
+	.item_type		= XFS_LI_CUI_RT,
+	.commit_pass2		= xlog_recover_rtcui_commit_pass2,
+};
+
 /*
  * This routine is called when an CUD format structure is found in a committed
  * transaction in the log. Its purpose is to cancel the corresponding CUI if it
@@ -648,3 +814,33 @@ const struct xlog_recover_item_ops xlog_cud_item_ops = {
 	.item_type		= XFS_LI_CUD,
 	.commit_pass2		= xlog_recover_cud_commit_pass2,
 };
+
+#ifdef CONFIG_XFS_RT
+STATIC int
+xlog_recover_rtcud_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_cud_log_format	*cud_formatp;
+
+	cud_formatp = item->ri_buf[0].i_addr;
+	if (item->ri_buf[0].i_len != sizeof(struct xfs_cud_log_format)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+		return -EFSCORRUPTED;
+	}
+
+	xlog_recover_release_intent(log, XFS_LI_CUI_RT,
+			cud_formatp->cud_cui_id);
+	return 0;
+}
+#else
+# define xlog_recover_rtcud_commit_pass2	xlog_recover_rtcui_commit_pass2
+#endif
+
+const struct xlog_recover_item_ops xlog_rtcud_item_ops = {
+	.item_type		= XFS_LI_CUD_RT,
+	.commit_pass2		= xlog_recover_rtcud_commit_pass2,
+};
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index b11769c009effc..02457e176c4252 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -571,6 +571,7 @@ xfs_reflink_cancel_cow_blocks(
 	struct xfs_ifork		*ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
 	struct xfs_bmbt_irec		got, del;
 	struct xfs_iext_cursor		icur;
+	bool				isrt = XFS_IS_REALTIME_INODE(ip);
 	int				error = 0;
 
 	if (!xfs_inode_has_cow_data(ip))
@@ -598,12 +599,13 @@ xfs_reflink_cancel_cow_blocks(
 			ASSERT((*tpp)->t_highest_agno == NULLAGNUMBER);
 
 			/* Free the CoW orphan record. */
-			xfs_refcount_free_cow_extent(*tpp, del.br_startblock,
-					del.br_blockcount);
+			xfs_refcount_free_cow_extent(*tpp, isrt,
+					del.br_startblock, del.br_blockcount);
 
 			error = xfs_free_extent_later(*tpp, del.br_startblock,
 					del.br_blockcount, NULL,
-					XFS_AG_RESV_NONE, 0);
+					XFS_AG_RESV_NONE,
+					isrt ? XFS_FREE_EXTENT_REALTIME : 0);
 			if (error)
 				break;
 
@@ -710,6 +712,7 @@ xfs_reflink_end_cow_extent(
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
 	unsigned int		resblks;
 	int			nmaps;
+	bool			isrt = XFS_IS_REALTIME_INODE(ip);
 	int			error;
 
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
@@ -779,7 +782,7 @@ xfs_reflink_end_cow_extent(
 		 * or not), unmap the extent and drop its refcount.
 		 */
 		xfs_bmap_unmap_extent(tp, ip, XFS_DATA_FORK, &data);
-		xfs_refcount_decrease_extent(tp, &data);
+		xfs_refcount_decrease_extent(tp, isrt, &data);
 		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
 				-data.br_blockcount);
 	} else if (data.br_startblock == DELAYSTARTBLOCK) {
@@ -799,7 +802,8 @@ xfs_reflink_end_cow_extent(
 	}
 
 	/* Free the CoW orphan record. */
-	xfs_refcount_free_cow_extent(tp, del.br_startblock, del.br_blockcount);
+	xfs_refcount_free_cow_extent(tp, isrt, del.br_startblock,
+			del.br_blockcount);
 
 	/* Map the new blocks into the data fork. */
 	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, &del);
@@ -1135,6 +1139,7 @@ xfs_reflink_remap_extent(
 	bool			quota_reserved = true;
 	bool			smap_real;
 	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
+	bool			isrt = XFS_IS_REALTIME_INODE(ip);
 	int			iext_delta = 0;
 	int			nimaps;
 	int			error;
@@ -1264,7 +1269,7 @@ xfs_reflink_remap_extent(
 		 * or not), unmap the extent and drop its refcount.
 		 */
 		xfs_bmap_unmap_extent(tp, ip, XFS_DATA_FORK, &smap);
-		xfs_refcount_decrease_extent(tp, &smap);
+		xfs_refcount_decrease_extent(tp, isrt, &smap);
 		qdelta -= smap.br_blockcount;
 	} else if (smap.br_startblock == DELAYSTARTBLOCK) {
 		int		done;
@@ -1287,7 +1292,7 @@ xfs_reflink_remap_extent(
 	 * its refcount and map it into the file.
 	 */
 	if (dmap_written) {
-		xfs_refcount_increase_extent(tp, dmap);
+		xfs_refcount_increase_extent(tp, isrt, dmap);
 		xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, dmap);
 		qdelta += dmap->br_blockcount;
 	}

