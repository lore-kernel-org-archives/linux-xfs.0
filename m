Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FA1BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JoAytKkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89708C433C8;
	Sun, 31 Dec 2023 21:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058135;
	bh=HKELYGGdPd+iGpL+Ag3R/g9cPLk5AGg3Wie9O9VhNgQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JoAytKkUD4UPGVszqN6gjOsCKOywnaka1KBQlcm3lzAIBbLmtmTshiFzccKU4n9y9
	 4P59966mi6mj7v92wB0/bweSMHGq6b/zzGew6CpW0r+OAp9vHFMeCWMvIgQqJNjTMq
	 6AmRkq9xsLX5gLCpqqM9jouFdwQNimf3ITwJbUuL9DHFzGPjso2QKq4AGto7C94PeX
	 D1nfmaPXaUVUH2EWv9exlUn6f/Bwihkq+qPwrTPqz2HvFFvm0K24XLeaZmVybOoGF0
	 LuRYZ5F37uNe2GRroaYgWP1IqVmhJ+ytB0ASN14kmGgTTISk7ZhBBCtn6wH1rvfAcS
	 Hclr5BVJgvnCA==
Date: Sun, 31 Dec 2023 13:28:54 -0800
Subject: [PATCH 1/2] xfs: support logging EFIs for realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170404848843.1764600.61079810055637922.stgit@frogsfrogsfrogs>
In-Reply-To: <170404848822.1764600.16492021865539804027.stgit@frogsfrogsfrogs>
References: <170404848822.1764600.16492021865539804027.stgit@frogsfrogsfrogs>
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

Teach the EFI mechanism how to free realtime extents.  We're going to
need this to enforce proper ordering of operations when we enable
realtime rmap.

Declare a new log intent item type (XFS_LI_EFI_RT) and a separate defer
ops for rt extents.  This keeps the ondisk artifacts and processing code
completely separate between the rt and non-rt cases.  Hopefully this
will make it easier to debug filesystem problems.

Previous versions of this patch accomplished this by setting the high
bit in each rt EFI extent.  This was found to be less transparent by
reviewers.

[Contains a bug fix and cleanups from hch]

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c       |   16 ++
 fs/xfs/libxfs/xfs_alloc.h       |   17 ++
 fs/xfs/libxfs/xfs_defer.c       |    6 +
 fs/xfs/libxfs/xfs_defer.h       |    1 
 fs/xfs/libxfs/xfs_log_format.h  |    6 +
 fs/xfs/libxfs/xfs_log_recover.h |    2 
 fs/xfs/xfs_extfree_item.c       |  282 ++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_log_recover.c        |    2 
 8 files changed, 306 insertions(+), 26 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 5d63711ad1aac..cf56784aabbbc 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2559,10 +2559,18 @@ xfs_defer_extent_free(
 	ASSERT(len <= XFS_MAX_BMBT_EXTLEN);
 	ASSERT(!isnullstartblock(bno));
 	ASSERT(!(free_flags & ~XFS_FREE_EXTENT_ALL_FLAGS));
-	ASSERT(type != XFS_AG_RESV_AGFL);
 
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
@@ -2571,6 +2579,8 @@ xfs_defer_extent_free(
 	xefi->xefi_agresv = type;
 	if (free_flags & XFS_FREE_EXTENT_SKIP_DISCARD)
 		xefi->xefi_flags |= XFS_EFI_SKIP_DISCARD;
+	if (free_flags & XFS_FREE_EXTENT_REALTIME)
+		xefi->xefi_flags |= XFS_EFI_REALTIME;
 	if (oinfo) {
 		ASSERT(oinfo->oi_offset == 0);
 
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 0ed71a31fe7ce..130026e981ea2 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -238,7 +238,11 @@ int xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
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
@@ -249,7 +253,10 @@ struct xfs_extent_free_item {
 	uint64_t		xefi_owner;
 	xfs_fsblock_t		xefi_startblock;/* starting fs block number */
 	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
-	struct xfs_perag	*xefi_pag;
+	union {
+		struct xfs_perag	*xefi_pag;
+		struct xfs_rtgroup	*xefi_rtg;
+	};
 	unsigned int		xefi_flags;
 	enum xfs_ag_resv_type	xefi_agresv;
 };
@@ -258,6 +265,12 @@ struct xfs_extent_free_item {
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
index 8788f9f3f19ec..cd28b96b49ea9 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -845,6 +845,12 @@ xfs_defer_add(
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 
+	if (!ops->finish_item) {
+		ASSERT(ops->finish_item != NULL);
+		xfs_force_shutdown(tp->t_mountp, SHUTDOWN_CORRUPT_INCORE);
+		return NULL;
+	}
+
 	dfp = xfs_defer_find_last(tp, ops);
 	if (!dfp || !xfs_defer_can_append(dfp, ops))
 		dfp = xfs_defer_alloc(tp, ops);
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index c9a1fe3fe363e..b4e1c386768c9 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -71,6 +71,7 @@ extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
 extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
+extern const struct xfs_defer_op_type xfs_rtextent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_attr_defer_type;
 extern const struct xfs_defer_op_type xfs_swapext_defer_type;
 
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index bded03634e53d..1f5fe4a588eca 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -248,6 +248,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_ATTRD		0x1247  /* attr set/remove done */
 #define	XFS_LI_SXI		0x1248  /* extent swap intent */
 #define	XFS_LI_SXD		0x1249  /* extent swap done */
+#define	XFS_LI_EFI_RT		0x124a	/* realtime extent free intent */
+#define	XFS_LI_EFD_RT		0x124b	/* realtime extent free done */
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -267,7 +269,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
 	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }, \
 	{ XFS_LI_SXI,		"XFS_LI_SXI" }, \
-	{ XFS_LI_SXD,		"XFS_LI_SXD" }
+	{ XFS_LI_SXD,		"XFS_LI_SXD" }, \
+	{ XFS_LI_EFI_RT,	"XFS_LI_EFI_RT" }, \
+	{ XFS_LI_EFD_RT,	"XFS_LI_EFD_RT" }
 
 /*
  * Inode Log Item Format definitions.
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 891221b0b83aa..811c37026d251 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -77,6 +77,8 @@ extern const struct xlog_recover_item_ops xlog_attri_item_ops;
 extern const struct xlog_recover_item_ops xlog_attrd_item_ops;
 extern const struct xlog_recover_item_ops xlog_sxi_item_ops;
 extern const struct xlog_recover_item_ops xlog_sxd_item_ops;
+extern const struct xlog_recover_item_ops xlog_rtefi_item_ops;
+extern const struct xlog_recover_item_ops xlog_rtefd_item_ops;
 
 /*
  * Macros, structures, prototypes for internal log manager use.
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index e8569bf26819c..51a363d85978f 100644
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
@@ -395,11 +408,12 @@ xfs_extent_free_create_intent(
 	bool				sort)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_efi_log_item		*efip = xfs_efi_init(mp, count);
+	struct xfs_efi_log_item		*efip;
 	struct xfs_extent_free_item	*xefi;
 
 	ASSERT(count > 0);
 
+	efip = xfs_efi_init(mp, XFS_LI_EFI, count);
 	if (sort)
 		list_sort(mp, items, xfs_extent_free_diff_items);
 	list_for_each_entry(xefi, items, xefi_list)
@@ -407,6 +421,12 @@ xfs_extent_free_create_intent(
 	return &efip->efi_item;
 }
 
+static inline unsigned short
+xfs_efd_type_from_efi(const struct xfs_efi_log_item *efip)
+{
+	return xfs_efi_item_isrt(&efip->efi_item) ?  XFS_LI_EFD_RT : XFS_LI_EFD;
+}
+
 /* Get an EFD so we can process all the free extents. */
 static struct xfs_log_item *
 xfs_extent_free_create_done(
@@ -427,8 +447,8 @@ xfs_extent_free_create_done(
 					GFP_KERNEL | __GFP_NOFAIL);
 	}
 
-	xfs_log_item_init(tp->t_mountp, &efdp->efd_item, XFS_LI_EFD,
-			  &xfs_efd_item_ops);
+	xfs_log_item_init(tp->t_mountp, &efdp->efd_item,
+			xfs_efd_type_from_efi(efip), &xfs_efd_item_ops);
 	efdp->efd_efip = efip;
 	efdp->efd_format.efd_nextents = count;
 	efdp->efd_format.efd_efi_id = efip->efi_format.efi_id;
@@ -447,6 +467,17 @@ xfs_extent_free_defer_add(
 
 	trace_xfs_extent_free_defer(mp, xefi);
 
+	if (xfs_efi_is_realtime(xefi)) {
+		xfs_rgnumber_t		rgno;
+
+		rgno = xfs_rtb_to_rgno(mp, xefi->xefi_startblock);
+		xefi->xefi_rtg = xfs_rtgroup_get(mp, rgno);
+
+		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
+				&xfs_rtextent_free_defer_type);
+		return;
+	}
+
 	xefi->xefi_pag = xfs_perag_intent_get(mp, xefi->xefi_startblock);
 	if (xefi->xefi_agresv == XFS_AG_RESV_AGFL)
 		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
@@ -559,8 +590,12 @@ xfs_agfl_free_finish_item(
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
 
@@ -568,6 +603,7 @@ static inline void
 xfs_efi_recover_work(
 	struct xfs_mount		*mp,
 	struct xfs_defer_pending	*dfp,
+	bool				isrt,
 	struct xfs_extent		*extp)
 {
 	struct xfs_extent_free_item	*xefi;
@@ -578,7 +614,15 @@ xfs_efi_recover_work(
 	xefi->xefi_blockcount = extp->ext_len;
 	xefi->xefi_agresv = XFS_AG_RESV_NONE;
 	xefi->xefi_owner = XFS_RMAP_OWN_UNKNOWN;
-	xefi->xefi_pag = xfs_perag_intent_get(mp, extp->ext_start);
+	if (isrt) {
+		xfs_rgnumber_t		rgno;
+
+		xefi->xefi_flags |= XFS_EFI_REALTIME;
+		rgno = xfs_rtb_to_rgno(mp, extp->ext_start);
+		xefi->xefi_rtg = xfs_rtgroup_get(mp, rgno);
+	} else {
+		xefi->xefi_pag = xfs_perag_intent_get(mp, extp->ext_start);
+	}
 
 	xfs_defer_add_item(dfp, &xefi->xefi_list);
 }
@@ -599,14 +643,15 @@ xfs_extent_free_recover_work(
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
@@ -614,7 +659,8 @@ xfs_extent_free_recover_work(
 			return -EFSCORRUPTED;
 		}
 
-		xfs_efi_recover_work(mp, dfp, &efip->efi_format.efi_extents[i]);
+		xfs_efi_recover_work(mp, dfp, isrt,
+				&efip->efi_format.efi_extents[i]);
 	}
 
 	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
@@ -652,10 +698,12 @@ xfs_extent_free_relog_intent(
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
 
@@ -687,6 +735,107 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
 	.relog_intent	= xfs_extent_free_relog_intent,
 };
 
+#ifdef CONFIG_XFS_RT
+/* Sort realtime efi items by rtgroup. */
+static int
+xfs_rtextent_free_diff_items(
+	void				*priv,
+	const struct list_head		*a,
+	const struct list_head		*b)
+{
+	struct xfs_extent_free_item	*ra = xefi_entry(a);
+	struct xfs_extent_free_item	*rb = xefi_entry(b);
+
+	return ra->xefi_rtg->rtg_rgno - rb->xefi_rtg->rtg_rgno;
+}
+
+/* Create a realtime extent freeing */
+static struct xfs_log_item *
+xfs_rtextent_free_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_efi_log_item		*efip;
+	struct xfs_extent_free_item	*xefi;
+
+	ASSERT(count > 0);
+
+	efip = xfs_efi_init(mp, XFS_LI_EFI_RT, count);
+	if (sort)
+		list_sort(mp, items, xfs_rtextent_free_diff_items);
+	list_for_each_entry(xefi, items, xefi_list)
+		xfs_extent_free_log_item(tp, efip, xefi);
+	return &efip->efi_item;
+}
+
+/* Cancel a realtime extent freeing. */
+STATIC void
+xfs_rtextent_free_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_extent_free_item	*xefi = xefi_entry(item);
+
+	xfs_rtgroup_put(xefi->xefi_rtg);
+	kmem_cache_free(xfs_extfree_item_cache, xefi);
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
+	int				error = 0;
+
+	/*
+	 * Lock the rt bitmap if we've any realtime extents to free and we
+	 * haven't locked the rt inodes yet.
+	 */
+	if (*state == NULL) {
+		xfs_rtbitmap_lock(tp, mp);
+		*state = (struct xfs_btree_cur *)1;
+	}
+
+	trace_xfs_extent_free_deferred(mp, xefi);
+
+	if (!(xefi->xefi_flags & XFS_EFI_CANCELLED))
+		error = xfs_rtfree_blocks(tp, xefi->xefi_startblock,
+					xefi->xefi_blockcount);
+	if (error == -EAGAIN) {
+		xfs_efd_from_efi(efdp);
+		return error;
+	}
+
+	xfs_efd_add_extent(efdp, xefi);
+	xfs_rtextent_free_cancel_item(item);
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
+	.cancel_item	= xfs_rtextent_free_cancel_item,
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
@@ -731,7 +880,7 @@ xlog_recover_efi_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
-	efip = xfs_efi_init(mp, efi_formatp->efi_nextents);
+	efip = xfs_efi_init(mp, ITEM_TYPE(item), efi_formatp->efi_nextents);
 	error = xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
 	if (error) {
 		xfs_efi_item_free(efip);
@@ -749,6 +898,58 @@ const struct xlog_recover_item_ops xlog_efi_item_ops = {
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
@@ -791,3 +992,44 @@ const struct xlog_recover_item_ops xlog_efd_item_ops = {
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
index 5e9562f37dc89..0aeca77d511d0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1793,6 +1793,8 @@ static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
 	&xlog_attrd_item_ops,
 	&xlog_sxi_item_ops,
 	&xlog_sxd_item_ops,
+	&xlog_rtefi_item_ops,
+	&xlog_rtefd_item_ops,
 };
 
 static const struct xlog_recover_item_ops *

