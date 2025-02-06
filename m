Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E4C23C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881573; cv=none; b=BwUeiQ2mEkS7gll2dFXittgOrxOrNd8wBgc83/r5/V/364vz0To4XuVR1DLxmbSlAZj6ChOOTI9BUdn5hiKjce8sTDv14j17ZclsXyYizdN7Dxhd6tsl9EMIjFu2VPrDnQYWB8ZNxNMkCq5EfyDPRW0gfBf8F/upuN03gRPwz0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881573; c=relaxed/simple;
	bh=IVtNu9Cczxbz2eR8rVdmhbhQClt0ZX6JJESYlweBuHw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OyGUcmRLLK+jcZJXWBO8XlKKIy9CfO1TGAP2wYYBYEsyZ0EWVY+d7zKkBB1Gozk1TvcLKBMsovbXMDzY+/l2tfjO8l7nZ74XtgjTY30URmyOqx85lGmmBzmJ/QW/hjcWxu/YHXvycSHNnkofX1KEYIpJNlyRi0mFADJWXFJN6ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PccEKJU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PccEKJU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E403CC4CEDD;
	Thu,  6 Feb 2025 22:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881573;
	bh=IVtNu9Cczxbz2eR8rVdmhbhQClt0ZX6JJESYlweBuHw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PccEKJU+wtLohDiI+IJ1YZ26eJo+wh5zAwrhyyxBUuntNaspRfs6ZM35HqFnCW1go
	 Zqgy1d2wjGwv+9MSY+OAg6kroJrtHIzwgIbjDt6QTcLdAGV7WCYFG42NPJDpbowj4d
	 DsSMEPm48kftYiCuiwPoL+25Hz/I1O8rzjexF97yHlj9dBXDab9MVa+k5VOnlRAZRZ
	 FLJ7JNleN2e8Tu2te98f8pa9Faw2W8EBZijnFU6UT+ZUffxOUx+Svje/wM8Kyn+pRN
	 3cBwQEnEMoG7AgRHXA2gzmtRCxnToBP6AN+t4VZB4ywGdNP76w2V41SVVCaJ9Uvh8u
	 9fZO2fvY8Cb4w==
Date: Thu, 06 Feb 2025 14:39:32 -0800
Subject: [PATCH 17/56] xfs: add a realtime flag to the rmap update log redo
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087052.2739176.6925177030519204643.stgit@frogsfrogsfrogs>
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

Source kernel commit: 9e823fc27419b09718fff74ae2297b25ae6fb317

Extend the rmap update (RUI) log items to handle realtime volumes by
adding a new log intent item type.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_defer.h      |    1 +
 libxfs/xfs_log_format.h |    6 +++++-
 libxfs/xfs_refcount.c   |    4 ++--
 libxfs/xfs_rmap.c       |   17 ++++++++++++-----
 libxfs/xfs_rmap.h       |    5 +++--
 5 files changed, 23 insertions(+), 10 deletions(-)


diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index ec51b8465e61cb..1e2477eaa5a844 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -69,6 +69,7 @@ struct xfs_defer_op_type {
 extern const struct xfs_defer_op_type xfs_bmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
 extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
+extern const struct xfs_defer_op_type xfs_rtrmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
 extern const struct xfs_defer_op_type xfs_rtextent_free_defer_type;
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 15dec19b6c32ad..a7e0e479454d3d 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
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
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 11c0ca5ecdb3e4..fb7c56a5a32921 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1830,7 +1830,7 @@ xfs_refcount_alloc_cow_extent(
 	__xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
 
 	/* Add rmap entry */
-	xfs_rmap_alloc_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
+	xfs_rmap_alloc_extent(tp, false, fsb, len, XFS_RMAP_OWN_COW);
 }
 
 /* Forget a CoW staging event in the refcount btree. */
@@ -1846,7 +1846,7 @@ xfs_refcount_free_cow_extent(
 		return;
 
 	/* Remove rmap entry */
-	xfs_rmap_free_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
+	xfs_rmap_free_extent(tp, false, fsb, len, XFS_RMAP_OWN_COW);
 	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
 }
 
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index f1bc677c56e8d9..a1a57cd0c62c10 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2709,6 +2709,7 @@ __xfs_rmap_add(
 	struct xfs_trans		*tp,
 	enum xfs_rmap_intent_type	type,
 	uint64_t			owner,
+	bool				isrt,
 	int				whichfork,
 	struct xfs_bmbt_irec		*bmap)
 {
@@ -2720,6 +2721,7 @@ __xfs_rmap_add(
 	ri->ri_owner = owner;
 	ri->ri_whichfork = whichfork;
 	ri->ri_bmap = *bmap;
+	ri->ri_realtime = isrt;
 
 	xfs_rmap_defer_add(tp, ri);
 }
@@ -2733,6 +2735,7 @@ xfs_rmap_map_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	enum xfs_rmap_intent_type type = XFS_RMAP_MAP;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
 
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, whichfork))
 		return;
@@ -2740,7 +2743,7 @@ xfs_rmap_map_extent(
 	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
 		type = XFS_RMAP_MAP_SHARED;
 
-	__xfs_rmap_add(tp, type, ip->i_ino, whichfork, PREV);
+	__xfs_rmap_add(tp, type, ip->i_ino, isrt, whichfork, PREV);
 }
 
 /* Unmap an extent out of a file. */
@@ -2752,6 +2755,7 @@ xfs_rmap_unmap_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	enum xfs_rmap_intent_type type = XFS_RMAP_UNMAP;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
 
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, whichfork))
 		return;
@@ -2759,7 +2763,7 @@ xfs_rmap_unmap_extent(
 	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
 		type = XFS_RMAP_UNMAP_SHARED;
 
-	__xfs_rmap_add(tp, type, ip->i_ino, whichfork, PREV);
+	__xfs_rmap_add(tp, type, ip->i_ino, isrt, whichfork, PREV);
 }
 
 /*
@@ -2777,6 +2781,7 @@ xfs_rmap_convert_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	enum xfs_rmap_intent_type type = XFS_RMAP_CONVERT;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
 
 	if (!xfs_rmap_update_is_needed(mp, whichfork))
 		return;
@@ -2784,13 +2789,14 @@ xfs_rmap_convert_extent(
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
@@ -2805,13 +2811,14 @@ xfs_rmap_alloc_extent(
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
@@ -2826,7 +2833,7 @@ xfs_rmap_free_extent(
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
 
-	__xfs_rmap_add(tp, XFS_RMAP_FREE, owner, XFS_DATA_FORK, &bmap);
+	__xfs_rmap_add(tp, XFS_RMAP_FREE, owner, isrt, XFS_DATA_FORK, &bmap);
 }
 
 /* Compare rmap records.  Returns -1 if a < b, 1 if a > b, and 0 if equal. */
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 1b19f54b65047f..5f39f6e53cd19a 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
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

