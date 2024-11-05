Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F09618E023
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846060; cv=none; b=GQ2EtO1zVeO+OfEmEdBJYtOUQQ0IK5puruhCS5Si3eyCz5GunTsn3qyC/PM11QDMgn951kJoXkgSTSSHTq78zITH5+Z46SQJfDk4pC0AtYPVmyqh2UbXMLPn4w8fkVGR4VeeQnpr9V8PVeMmz/Y2ZwH58h5LrJ2CeS/uRhtAv/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846060; c=relaxed/simple;
	bh=bDyYF/12zkOv3V1h2IjsUsfwU4zVo2m/GwRsFVtAs8A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=egtM47brLVE8hFShsolJZ9OVav/Cl+TV1SK3Svv989vDUDAFPa+qZ0GoEvxRRmt/NTyGgQc37GBW4T+wa//9c/cM7kKlLKO7yuL93HvLb+RGE681cSMfWN9gZno57FOky1IkkruOf3Jsl6z8lNYj2WILNcok/SCA9nVahviDMw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NmwR3e5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NmwR3e5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F4DC4CECF;
	Tue,  5 Nov 2024 22:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846060;
	bh=bDyYF/12zkOv3V1h2IjsUsfwU4zVo2m/GwRsFVtAs8A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NmwR3e5GcsmUiuJOqpmcrTPP922Ef+gaFH/QFhTIlNasJW0FUTqsyS6RRKJEFQ6K/
	 4/mUWtZJ70Z4GbfpmdW9rqedeBLvehR0Sr2CjEN3KUXgE1/CtRxpV7GFdYnlIsh8LO
	 tTd01OrFJMWX1Wc7NctPMcBkgDzXNFQ53T7ttjvIXWsrlpE4WPaRfcEh1MNaQ4XWjx
	 2H0d3EJYbX4ESp7SftOk8/vfwDv0LCN7MEhizJ9lnbEVjrVYNKp6KAkPYos0QEgXst
	 MVIEkPvBsHDapth9iem1BHAlt8h35IGJxwwTG8DvrbB8gEnkO6i+pj1XsfxAHMb7y9
	 p8rlltKUlqDQg==
Date: Tue, 05 Nov 2024 14:34:19 -0800
Subject: [PATCH 17/34] xfs: support logging EFIs for realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398474.1871887.1554146181486559317.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Teach the EFI mechanism how to free realtime extents.  We're going to
need this to enforce proper ordering of operations when we enable
realtime rmap.

Declare a new log intent item type (XFS_LI_EFI_RT) and a separate defer
ops for rt extents.  This keeps the ondisk artifacts and processing code
completely separate between the rt and non-rt cases.  Hopefully this
will make it easier to debug filesystem problems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c       |   15 ++
 fs/xfs/libxfs/xfs_alloc.h       |   12 ++
 fs/xfs/libxfs/xfs_defer.c       |    6 +
 fs/xfs/libxfs/xfs_defer.h       |    1 
 fs/xfs/libxfs/xfs_log_format.h  |    6 +
 fs/xfs/libxfs/xfs_log_recover.h |    2 
 fs/xfs/xfs_extfree_item.c       |  270 +++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_log_recover.c        |    2 
 fs/xfs/xfs_trace.h              |   11 +-
 9 files changed, 286 insertions(+), 39 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d33c2fdaf4f2c9..ff4a1dc9f6beb9 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2648,8 +2648,17 @@ xfs_defer_extent_free(
 	ASSERT(!isnullstartblock(bno));
 	ASSERT(!(free_flags & ~XFS_FREE_EXTENT_ALL_FLAGS));
 
-	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))
-		return -EFSCORRUPTED;
+	if (free_flags & XFS_FREE_EXTENT_REALTIME) {
+		if (type != XFS_AG_RESV_NONE) {
+			ASSERT(type == XFS_AG_RESV_NONE);
+			return -EFSCORRUPTED;
+		}
+		if (XFS_IS_CORRUPT(mp, !xfs_verify_rtbext(mp, bno, len)))
+			return -EFSCORRUPTED;
+	} else {
+		if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))
+			return -EFSCORRUPTED;
+	}
 
 	xefi = kmem_cache_zalloc(xfs_extfree_item_cache,
 			       GFP_KERNEL | __GFP_NOFAIL);
@@ -2658,6 +2667,8 @@ xfs_defer_extent_free(
 	xefi->xefi_agresv = type;
 	if (free_flags & XFS_FREE_EXTENT_SKIP_DISCARD)
 		xefi->xefi_flags |= XFS_EFI_SKIP_DISCARD;
+	if (free_flags & XFS_FREE_EXTENT_REALTIME)
+		xefi->xefi_flags |= XFS_EFI_REALTIME;
 	if (oinfo) {
 		ASSERT(oinfo->oi_offset == 0);
 
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index efbde04fbbb15f..50ef79a1ed41a1 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -237,7 +237,11 @@ int xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
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
@@ -257,6 +261,12 @@ struct xfs_extent_free_item {
 #define XFS_EFI_ATTR_FORK	(1U << 1) /* freeing attr fork block */
 #define XFS_EFI_BMBT_BLOCK	(1U << 2) /* freeing bmap btree block */
 #define XFS_EFI_CANCELLED	(1U << 3) /* dont actually free the space */
+#define XFS_EFI_REALTIME	(1U << 4) /* freeing realtime extent */
+
+static inline bool xfs_efi_is_realtime(const struct xfs_extent_free_item *xefi)
+{
+	return xefi->xefi_flags & XFS_EFI_REALTIME;
+}
 
 struct xfs_alloc_autoreap {
 	struct xfs_defer_pending	*dfp;
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 2cd212ad2c1d98..5b377cbbb1f7e0 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -846,6 +846,12 @@ xfs_defer_add(
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 
+	if (!ops->finish_item) {
+		ASSERT(ops->finish_item != NULL);
+		xfs_force_shutdown(tp->t_mountp, SHUTDOWN_CORRUPT_INCORE);
+		return NULL;
+	}
+
 	dfp = xfs_defer_find_last(tp, ops);
 	if (!dfp || !xfs_defer_can_append(dfp, ops))
 		dfp = xfs_defer_alloc(&tp->t_dfops, ops);
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 8b338031e487c4..ec51b8465e61cb 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -71,6 +71,7 @@ extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
 extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
+extern const struct xfs_defer_op_type xfs_rtextent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_attr_defer_type;
 extern const struct xfs_defer_op_type xfs_exchmaps_defer_type;
 
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index ace7384a275bfb..15dec19b6c32ad 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -248,6 +248,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_ATTRD		0x1247  /* attr set/remove done */
 #define	XFS_LI_XMI		0x1248  /* mapping exchange intent */
 #define	XFS_LI_XMD		0x1249  /* mapping exchange done */
+#define	XFS_LI_EFI_RT		0x124a	/* realtime extent free intent */
+#define	XFS_LI_EFD_RT		0x124b	/* realtime extent free done */
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -267,7 +269,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
 	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }, \
 	{ XFS_LI_XMI,		"XFS_LI_XMI" }, \
-	{ XFS_LI_XMD,		"XFS_LI_XMD" }
+	{ XFS_LI_XMD,		"XFS_LI_XMD" }, \
+	{ XFS_LI_EFI_RT,	"XFS_LI_EFI_RT" }, \
+	{ XFS_LI_EFD_RT,	"XFS_LI_EFD_RT" }
 
 /*
  * Inode Log Item Format definitions.
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 521d327e4c89ed..5397a8ff004df8 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -77,6 +77,8 @@ extern const struct xlog_recover_item_ops xlog_attri_item_ops;
 extern const struct xlog_recover_item_ops xlog_attrd_item_ops;
 extern const struct xlog_recover_item_ops xlog_xmi_item_ops;
 extern const struct xlog_recover_item_ops xlog_xmd_item_ops;
+extern const struct xlog_recover_item_ops xlog_rtefi_item_ops;
+extern const struct xlog_recover_item_ops xlog_rtefd_item_ops;
 
 /*
  * Macros, structures, prototypes for internal log manager use.
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index e469510986e8d0..a25c713ff888c7 100644
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
@@ -95,16 +99,15 @@ xfs_efi_item_format(
 
 	ASSERT(atomic_read(&efip->efi_next_extent) ==
 				efip->efi_format.efi_nextents);
+	ASSERT(lip->li_type == XFS_LI_EFI || lip->li_type == XFS_LI_EFI_RT);
 
-	efip->efi_format.efi_type = XFS_LI_EFI;
+	efip->efi_format.efi_type = lip->li_type;
 	efip->efi_format.efi_size = 1;
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_EFI_FORMAT,
-			&efip->efi_format,
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_EFI_FORMAT, &efip->efi_format,
 			xfs_efi_log_format_sizeof(efip->efi_format.efi_nextents));
 }
 
-
 /*
  * The unpin operation is the last place an EFI is manipulated in the log. It is
  * either inserted in the AIL or aborted in the event of a log I/O error. In
@@ -140,12 +143,14 @@ xfs_efi_item_release(
 STATIC struct xfs_efi_log_item *
 xfs_efi_init(
 	struct xfs_mount	*mp,
+	unsigned short		item_type,
 	uint			nextents)
-
 {
 	struct xfs_efi_log_item	*efip;
 
+	ASSERT(item_type == XFS_LI_EFI || item_type == XFS_LI_EFI_RT);
 	ASSERT(nextents > 0);
+
 	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
 		efip = kzalloc(xfs_efi_log_item_sizeof(nextents),
 				GFP_KERNEL | __GFP_NOFAIL);
@@ -154,7 +159,7 @@ xfs_efi_init(
 					 GFP_KERNEL | __GFP_NOFAIL);
 	}
 
-	xfs_log_item_init(mp, &efip->efi_item, XFS_LI_EFI, &xfs_efi_item_ops);
+	xfs_log_item_init(mp, &efip->efi_item, item_type, &xfs_efi_item_ops);
 	efip->efi_format.efi_nextents = nextents;
 	efip->efi_format.efi_id = (uintptr_t)(void *)efip;
 	atomic_set(&efip->efi_next_extent, 0);
@@ -264,12 +269,12 @@ xfs_efd_item_format(
 	struct xfs_log_iovec	*vecp = NULL;
 
 	ASSERT(efdp->efd_next_extent == efdp->efd_format.efd_nextents);
+	ASSERT(lip->li_type == XFS_LI_EFD || lip->li_type == XFS_LI_EFD_RT);
 
-	efdp->efd_format.efd_type = XFS_LI_EFD;
+	efdp->efd_format.efd_type = lip->li_type;
 	efdp->efd_format.efd_size = 1;
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_EFD_FORMAT,
-			&efdp->efd_format,
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_EFD_FORMAT, &efdp->efd_format,
 			xfs_efd_log_format_sizeof(efdp->efd_format.efd_nextents));
 }
 
@@ -308,6 +313,14 @@ static inline struct xfs_extent_free_item *xefi_entry(const struct list_head *e)
 	return list_entry(e, struct xfs_extent_free_item, xefi_list);
 }
 
+static inline bool
+xfs_efi_item_isrt(const struct xfs_log_item *lip)
+{
+	ASSERT(lip->li_type == XFS_LI_EFI || lip->li_type == XFS_LI_EFI_RT);
+
+	return lip->li_type == XFS_LI_EFI_RT;
+}
+
 /*
  * Fill the EFD with all extents from the EFI when we need to roll the
  * transaction and continue with a new EFI.
@@ -388,18 +401,20 @@ xfs_extent_free_log_item(
 }
 
 static struct xfs_log_item *
-xfs_extent_free_create_intent(
+__xfs_extent_free_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
 	unsigned int			count,
-	bool				sort)
+	bool				sort,
+	unsigned short			item_type)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_efi_log_item		*efip = xfs_efi_init(mp, count);
+	struct xfs_efi_log_item		*efip;
 	struct xfs_extent_free_item	*xefi;
 
 	ASSERT(count > 0);
 
+	efip = xfs_efi_init(mp, item_type, count);
 	if (sort)
 		list_sort(mp, items, xfs_extent_free_diff_items);
 	list_for_each_entry(xefi, items, xefi_list)
@@ -407,6 +422,23 @@ xfs_extent_free_create_intent(
 	return &efip->efi_item;
 }
 
+static struct xfs_log_item *
+xfs_extent_free_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	return __xfs_extent_free_create_intent(tp, items, count, sort,
+			XFS_LI_EFI);
+}
+
+static inline unsigned short
+xfs_efd_type_from_efi(const struct xfs_efi_log_item *efip)
+{
+	return xfs_efi_item_isrt(&efip->efi_item) ?  XFS_LI_EFD_RT : XFS_LI_EFD;
+}
+
 /* Get an EFD so we can process all the free extents. */
 static struct xfs_log_item *
 xfs_extent_free_create_done(
@@ -427,8 +459,8 @@ xfs_extent_free_create_done(
 					GFP_KERNEL | __GFP_NOFAIL);
 	}
 
-	xfs_log_item_init(tp->t_mountp, &efdp->efd_item, XFS_LI_EFD,
-			  &xfs_efd_item_ops);
+	xfs_log_item_init(tp->t_mountp, &efdp->efd_item,
+			xfs_efd_type_from_efi(efip), &xfs_efd_item_ops);
 	efdp->efd_efip = efip;
 	efdp->efd_format.efd_nextents = count;
 	efdp->efd_format.efd_efi_id = efip->efi_format.efi_id;
@@ -436,6 +468,17 @@ xfs_extent_free_create_done(
 	return &efdp->efd_item;
 }
 
+static inline const struct xfs_defer_op_type *
+xefi_ops(
+	struct xfs_extent_free_item	*xefi)
+{
+	if (xfs_efi_is_realtime(xefi))
+		return &xfs_rtextent_free_defer_type;
+	if (xefi->xefi_agresv == XFS_AG_RESV_AGFL)
+		return &xfs_agfl_free_defer_type;
+	return &xfs_extent_free_defer_type;
+}
+
 /* Add this deferred EFI to the transaction. */
 void
 xfs_extent_free_defer_add(
@@ -445,16 +488,11 @@ xfs_extent_free_defer_add(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 
-	trace_xfs_extent_free_defer(mp, xefi);
-
 	xefi->xefi_group = xfs_group_intent_get(mp, xefi->xefi_startblock,
-			XG_TYPE_AG);
-	if (xefi->xefi_agresv == XFS_AG_RESV_AGFL)
-		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
-				&xfs_agfl_free_defer_type);
-	else
-		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
-				&xfs_extent_free_defer_type);
+			xfs_efi_is_realtime(xefi) ? XG_TYPE_RTG : XG_TYPE_AG);
+
+	trace_xfs_extent_free_defer(mp, xefi);
+	*dfpp = xfs_defer_add(tp, &xefi->xefi_list, xefi_ops(xefi));
 }
 
 /* Cancel a free extent. */
@@ -560,8 +598,12 @@ xfs_agfl_free_finish_item(
 static inline bool
 xfs_efi_validate_ext(
 	struct xfs_mount		*mp,
+	bool				isrt,
 	struct xfs_extent		*extp)
 {
+	if (isrt)
+		return xfs_verify_rtbext(mp, extp->ext_start, extp->ext_len);
+
 	return xfs_verify_fsbext(mp, extp->ext_start, extp->ext_len);
 }
 
@@ -569,6 +611,7 @@ static inline void
 xfs_efi_recover_work(
 	struct xfs_mount		*mp,
 	struct xfs_defer_pending	*dfp,
+	bool				isrt,
 	struct xfs_extent		*extp)
 {
 	struct xfs_extent_free_item	*xefi;
@@ -580,7 +623,9 @@ xfs_efi_recover_work(
 	xefi->xefi_agresv = XFS_AG_RESV_NONE;
 	xefi->xefi_owner = XFS_RMAP_OWN_UNKNOWN;
 	xefi->xefi_group = xfs_group_intent_get(mp, extp->ext_start,
-			XG_TYPE_AG);
+			isrt ? XG_TYPE_RTG : XG_TYPE_AG);
+	if (isrt)
+		xefi->xefi_flags |= XFS_EFI_REALTIME;
 
 	xfs_defer_add_item(dfp, &xefi->xefi_list);
 }
@@ -601,14 +646,15 @@ xfs_extent_free_recover_work(
 	struct xfs_trans		*tp;
 	int				i;
 	int				error = 0;
+	bool				isrt = xfs_efi_item_isrt(lip);
 
 	/*
-	 * First check the validity of the extents described by the
-	 * EFI.  If any are bad, then assume that all are bad and
-	 * just toss the EFI.
+	 * First check the validity of the extents described by the EFI.  If
+	 * any are bad, then assume that all are bad and just toss the EFI.
+	 * Mixing RT and non-RT extents in the same EFI item is not allowed.
 	 */
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
-		if (!xfs_efi_validate_ext(mp,
+		if (!xfs_efi_validate_ext(mp, isrt,
 					&efip->efi_format.efi_extents[i])) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					&efip->efi_format,
@@ -616,7 +662,8 @@ xfs_extent_free_recover_work(
 			return -EFSCORRUPTED;
 		}
 
-		xfs_efi_recover_work(mp, dfp, &efip->efi_format.efi_extents[i]);
+		xfs_efi_recover_work(mp, dfp, isrt,
+				&efip->efi_format.efi_extents[i]);
 	}
 
 	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
@@ -654,10 +701,12 @@ xfs_extent_free_relog_intent(
 	count = EFI_ITEM(intent)->efi_format.efi_nextents;
 	extp = EFI_ITEM(intent)->efi_format.efi_extents;
 
+	ASSERT(intent->li_type == XFS_LI_EFI || intent->li_type == XFS_LI_EFI_RT);
+
 	efdp->efd_next_extent = count;
 	memcpy(efdp->efd_format.efd_extents, extp, count * sizeof(*extp));
 
-	efip = xfs_efi_init(tp->t_mountp, count);
+	efip = xfs_efi_init(tp->t_mountp, intent->li_type, count);
 	memcpy(efip->efi_format.efi_extents, extp, count * sizeof(*extp));
 	atomic_set(&efip->efi_next_extent, count);
 
@@ -689,6 +738,72 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
 	.relog_intent	= xfs_extent_free_relog_intent,
 };
 
+#ifdef CONFIG_XFS_RT
+/* Create a realtime extent freeing */
+static struct xfs_log_item *
+xfs_rtextent_free_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	return __xfs_extent_free_create_intent(tp, items, count, sort,
+			XFS_LI_EFI_RT);
+}
+
+/* Process a free realtime extent. */
+STATIC int
+xfs_rtextent_free_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_extent_free_item	*xefi = xefi_entry(item);
+	struct xfs_efd_log_item		*efdp = EFD_ITEM(done);
+	struct xfs_rtgroup		**rtgp = (struct xfs_rtgroup **)state;
+	int				error = 0;
+
+	trace_xfs_extent_free_deferred(mp, xefi);
+
+	if (!(xefi->xefi_flags & XFS_EFI_CANCELLED)) {
+		if (*rtgp != to_rtg(xefi->xefi_group)) {
+			*rtgp = to_rtg(xefi->xefi_group);
+			xfs_rtgroup_lock(*rtgp, XFS_RTGLOCK_BITMAP);
+			xfs_rtgroup_trans_join(tp, *rtgp,
+					XFS_RTGLOCK_BITMAP);
+		}
+		error = xfs_rtfree_blocks(tp, *rtgp,
+				xefi->xefi_startblock, xefi->xefi_blockcount);
+	}
+	if (error == -EAGAIN) {
+		xfs_efd_from_efi(efdp);
+		return error;
+	}
+
+	xfs_efd_add_extent(efdp, xefi);
+	xfs_extent_free_cancel_item(item);
+	return error;
+}
+
+const struct xfs_defer_op_type xfs_rtextent_free_defer_type = {
+	.name		= "rtextent_free",
+	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_rtextent_free_create_intent,
+	.abort_intent	= xfs_extent_free_abort_intent,
+	.create_done	= xfs_extent_free_create_done,
+	.finish_item	= xfs_rtextent_free_finish_item,
+	.cancel_item	= xfs_extent_free_cancel_item,
+	.recover_work	= xfs_extent_free_recover_work,
+	.relog_intent	= xfs_extent_free_relog_intent,
+};
+#else
+const struct xfs_defer_op_type xfs_rtextent_free_defer_type = {
+	.name		= "rtextent_free",
+};
+#endif /* CONFIG_XFS_RT */
+
 STATIC bool
 xfs_efi_item_match(
 	struct xfs_log_item	*lip,
@@ -733,7 +848,7 @@ xlog_recover_efi_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
-	efip = xfs_efi_init(mp, efi_formatp->efi_nextents);
+	efip = xfs_efi_init(mp, ITEM_TYPE(item), efi_formatp->efi_nextents);
 	error = xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
 	if (error) {
 		xfs_efi_item_free(efip);
@@ -751,6 +866,58 @@ const struct xlog_recover_item_ops xlog_efi_item_ops = {
 	.commit_pass2		= xlog_recover_efi_commit_pass2,
 };
 
+#ifdef CONFIG_XFS_RT
+STATIC int
+xlog_recover_rtefi_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_efi_log_item		*efip;
+	struct xfs_efi_log_format	*efi_formatp;
+	int				error;
+
+	efi_formatp = item->ri_buf[0].i_addr;
+
+	if (item->ri_buf[0].i_len < xfs_efi_log_format_sizeof(0)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+		return -EFSCORRUPTED;
+	}
+
+	efip = xfs_efi_init(mp, ITEM_TYPE(item), efi_formatp->efi_nextents);
+	error = xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
+	if (error) {
+		xfs_efi_item_free(efip);
+		return error;
+	}
+	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
+
+	xlog_recover_intent_item(log, &efip->efi_item, lsn,
+			&xfs_rtextent_free_defer_type);
+	return 0;
+}
+#else
+STATIC int
+xlog_recover_rtefi_commit_pass2(
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
+const struct xlog_recover_item_ops xlog_rtefi_item_ops = {
+	.item_type		= XFS_LI_EFI_RT,
+	.commit_pass2		= xlog_recover_rtefi_commit_pass2,
+};
+
 /*
  * This routine is called when an EFD format structure is found in a committed
  * transaction in the log. Its purpose is to cancel the corresponding EFI if it
@@ -793,3 +960,44 @@ const struct xlog_recover_item_ops xlog_efd_item_ops = {
 	.item_type		= XFS_LI_EFD,
 	.commit_pass2		= xlog_recover_efd_commit_pass2,
 };
+
+#ifdef CONFIG_XFS_RT
+STATIC int
+xlog_recover_rtefd_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_efd_log_format	*efd_formatp;
+	int				buflen = item->ri_buf[0].i_len;
+
+	efd_formatp = item->ri_buf[0].i_addr;
+
+	if (buflen < sizeof(struct xfs_efd_log_format)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				efd_formatp, buflen);
+		return -EFSCORRUPTED;
+	}
+
+	if (item->ri_buf[0].i_len != xfs_efd_log_format32_sizeof(
+						efd_formatp->efd_nextents) &&
+	    item->ri_buf[0].i_len != xfs_efd_log_format64_sizeof(
+						efd_formatp->efd_nextents)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				efd_formatp, buflen);
+		return -EFSCORRUPTED;
+	}
+
+	xlog_recover_release_intent(log, XFS_LI_EFI_RT,
+			efd_formatp->efd_efi_id);
+	return 0;
+}
+#else
+# define xlog_recover_rtefd_commit_pass2	xlog_recover_rtefi_commit_pass2
+#endif
+
+const struct xlog_recover_item_ops xlog_rtefd_item_ops = {
+	.item_type		= XFS_LI_EFD_RT,
+	.commit_pass2		= xlog_recover_rtefd_commit_pass2,
+};
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 55e412a821483e..0af3d477197b24 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1818,6 +1818,8 @@ static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
 	&xlog_attrd_item_ops,
 	&xlog_xmi_item_ops,
 	&xlog_xmd_item_ops,
+	&xlog_rtefi_item_ops,
+	&xlog_rtefd_item_ops,
 };
 
 static const struct xlog_recover_item_ops *
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a9392eaaf6f581..b07790d74d351f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2761,6 +2761,7 @@ DECLARE_EVENT_CLASS(xfs_free_extent_deferred_class,
 	TP_ARGS(mp, free),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(enum xfs_group_type, type)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_agblock_t, agbno)
 		__field(xfs_extlen_t, len)
@@ -2768,13 +2769,16 @@ DECLARE_EVENT_CLASS(xfs_free_extent_deferred_class,
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = XFS_FSB_TO_AGNO(mp, free->xefi_startblock);
-		__entry->agbno = XFS_FSB_TO_AGBNO(mp, free->xefi_startblock);
+		__entry->type = free->xefi_group->xg_type;
+		__entry->agno = free->xefi_group->xg_gno;
+		__entry->agbno = xfs_fsb_to_gbno(mp, free->xefi_startblock,
+						free->xefi_group->xg_type);
 		__entry->len = free->xefi_blockcount;
 		__entry->flags = free->xefi_flags;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x flags 0x%x",
+	TP_printk("dev %d:%d %sno 0x%x gbno 0x%x fsbcount 0x%x flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agno,
 		  __entry->agbno,
 		  __entry->len,
@@ -2784,7 +2788,6 @@ DECLARE_EVENT_CLASS(xfs_free_extent_deferred_class,
 DEFINE_EVENT(xfs_free_extent_deferred_class, name, \
 	TP_PROTO(struct xfs_mount *mp, struct xfs_extent_free_item *free), \
 	TP_ARGS(mp, free))
-DEFINE_FREE_EXTENT_DEFERRED_EVENT(xfs_agfl_free_defer);
 DEFINE_FREE_EXTENT_DEFERRED_EVENT(xfs_agfl_free_deferred);
 DEFINE_FREE_EXTENT_DEFERRED_EVENT(xfs_extent_free_defer);
 DEFINE_FREE_EXTENT_DEFERRED_EVENT(xfs_extent_free_deferred);

