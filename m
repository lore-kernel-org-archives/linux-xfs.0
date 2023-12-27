Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C966E7F9
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OHLFxg8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A03CC433C8;
	Mon,  1 Jan 2024 00:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067659;
	bh=7v69Dgo6EtEH+1eO7+U72faK74grKhOgdu/qf2eX09E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OHLFxg8JQXdDArt29pubq0XwXglxkawQjDBJzfq4XFLDaPfn/UG21/RJUCBDLa9hH
	 UzyhrzSjMeI3JKYdtjkxPiIBIFJGbb5zmpJY+Wc2q3JYECcFaKFbxvxexROhzSRAJA
	 U5fcJM3b2pnyRa0I0vkMHo+nO5PRvhztQDdCwFwCpbUzXAFTqJjmqXvD8hCguHXhLY
	 yEs5NBFboIRO5tm1gUL9fnKA0xgCdS4vvIpEiVf5gQyRHRoA76kllRRBGIyo3vzsHN
	 G1T9DLFfdW46eYXs1uyHiFaYySIoXhW7U8NCf3/J6VjUT5HuS70WD587Gsq4eUuBEA
	 u8UIpBtl8gqYQ==
Date: Sun, 31 Dec 2023 16:07:38 +9900
Subject: [PATCH 1/3] xfs: support logging EFIs for realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405014474.1815106.18004443753823306931.stgit@frogsfrogsfrogs>
In-Reply-To: <170405014459.1815106.2840285507026368491.stgit@frogsfrogsfrogs>
References: <170405014459.1815106.2840285507026368491.stgit@frogsfrogsfrogs>
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
 libxfs/defer_item.c     |   75 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_alloc.c      |   16 ++++++++--
 libxfs/xfs_alloc.h      |   17 +++++++++--
 libxfs/xfs_defer.c      |    6 ++++
 libxfs/xfs_defer.h      |    1 +
 libxfs/xfs_log_format.h |    6 +++-
 6 files changed, 115 insertions(+), 6 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 9b9bce17f4e..82b70575bc5 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -85,6 +85,17 @@ xfs_extent_free_defer_add(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 
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
@@ -157,6 +168,70 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 	.cancel_item	= xfs_extent_free_cancel_item,
 };
 
+/* Sort bmap items by rtgroup. */
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
+static struct xfs_log_item *
+xfs_rtextent_free_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+
+	if (sort)
+		list_sort(mp, items, xfs_rtextent_free_diff_items);
+	return NULL;
+}
+
+/* Cancel a free extent. */
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
+STATIC int
+xfs_rtextent_free_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_extent_free_item	*xefi = xefi_entry(item);
+	int				error;
+
+	error = xfs_rtfree_blocks(tp, xefi->xefi_startblock,
+			xefi->xefi_blockcount);
+	if (error != -EAGAIN)
+		xfs_rtextent_free_cancel_item(item);
+	return error;
+}
+
+const struct xfs_defer_op_type xfs_rtextent_free_defer_type = {
+	.name		= "rtextent_free",
+	.create_intent	= xfs_rtextent_free_create_intent,
+	.abort_intent	= xfs_extent_free_abort_intent,
+	.create_done	= xfs_extent_free_create_done,
+	.finish_item	= xfs_rtextent_free_finish_item,
+	.cancel_item	= xfs_rtextent_free_cancel_item,
+};
+
 /*
  * AGFL blocks are accounted differently in the reserve pools and are not
  * inserted into the busy extent list.
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 36af2c087b0..589e9ef3003 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2555,10 +2555,18 @@ xfs_defer_extent_free(
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
@@ -2567,6 +2575,8 @@ xfs_defer_extent_free(
 	xefi->xefi_agresv = type;
 	if (free_flags & XFS_FREE_EXTENT_SKIP_DISCARD)
 		xefi->xefi_flags |= XFS_EFI_SKIP_DISCARD;
+	if (free_flags & XFS_FREE_EXTENT_REALTIME)
+		xefi->xefi_flags |= XFS_EFI_REALTIME;
 	if (oinfo) {
 		ASSERT(oinfo->oi_offset == 0);
 
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 0ed71a31fe7..130026e981e 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
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
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 41e607d55f0..4a1139913b9 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -839,6 +839,12 @@ xfs_defer_add(
 
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
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index c9a1fe3fe36..b4e1c386768 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -71,6 +71,7 @@ extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
 extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
+extern const struct xfs_defer_op_type xfs_rtextent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_attr_defer_type;
 extern const struct xfs_defer_op_type xfs_swapext_defer_type;
 
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index bded03634e5..1f5fe4a588e 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
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

