Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE49148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529457; cv=none; b=DeZYIeHxQcPAenJ2kQSfR+B+PEw2nsMj0GoHjw5lL0t0XpxCcZnRo04EnZzj4kisFy211DivngRHM/h7Qm5PWMkiq/sIRAasIXeWOmIMDV5hTqGZCtemNtLi/b8Fdo5TIEZ/D3ZOQ2MzTWvRjWvQi7MSAn9fOH0Y5MWFQfmuG5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529457; c=relaxed/simple;
	bh=7JJZjkUFlv1Mg4HU/iSd35p74Qz1Fl1lgGBX130nagc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qiJv7VjgEzdSDii5tFGqtgLinabdYCmIIFd5UhapDeXH4EKzgLaMsI5xIAF3EvQgruCCHLFq+ufMxwzIOFdcbrMXlMB/y8zEdOPCOxoNcRTtJIffJKOK5lxoAI19ML9D5/1kRvnnb7QZcaiJ8T+NGtu1Tew3Xi+A4GICsRX4CnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nt/W+Cny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nt/W+Cny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38811C4CED1;
	Fri,  6 Dec 2024 23:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529457;
	bh=7JJZjkUFlv1Mg4HU/iSd35p74Qz1Fl1lgGBX130nagc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nt/W+CnyO7beOgTiIZufGLOYVyGPt+PuvVPNRs7J3PnyPQ5Jx9Qj2Zfyxe1PwCHGF
	 4etFjzJwakNFEEtF6siMHtKcP4guonawDbeuICl3QNZ7t5L6wfEoZNk1TfpVeCqfL1
	 7mwZz7edj5cTRrYUxlrcLBWxHDrHSjU0FITYFTsFg+ESJ4xrT2PiQJOzGdXucoXNow
	 EVgqc7sfrPSd1DfdOcL1h64HK3QyXiLZuT9O4Jl3DaSD9IWWHJMMHOIL88tmyqgmAO
	 WOSTZCgj5fjrMScotj2Fc7urqpRauFf/gw7i4wRuCepqxQ8Hi1kt80s/rl1c1dtrin
	 /3JFvhCzOo1uw==
Date: Fri, 06 Dec 2024 15:57:36 -0800
Subject: [PATCH 24/46] xfs: support logging EFIs for realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750362.124560.3218466090193361094.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 4c8900bbf106592ce647285e308abd2a7f080d88

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
 libxfs/xfs_alloc.c      |   15 +++++++++++++--
 libxfs/xfs_alloc.h      |   12 +++++++++++-
 libxfs/xfs_defer.c      |    6 ++++++
 libxfs/xfs_defer.h      |    1 +
 libxfs/xfs_log_format.h |    6 +++++-
 5 files changed, 36 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index c449285743534d..9aebe7227a6148 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2644,8 +2644,17 @@ xfs_defer_extent_free(
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
@@ -2654,6 +2663,8 @@ xfs_defer_extent_free(
 	xefi->xefi_agresv = type;
 	if (free_flags & XFS_FREE_EXTENT_SKIP_DISCARD)
 		xefi->xefi_flags |= XFS_EFI_SKIP_DISCARD;
+	if (free_flags & XFS_FREE_EXTENT_REALTIME)
+		xefi->xefi_flags |= XFS_EFI_REALTIME;
 	if (oinfo) {
 		ASSERT(oinfo->oi_offset == 0);
 
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index efbde04fbbb15f..50ef79a1ed41a1 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
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
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index e3a608f64536ec..8f6708c0f3bfcd 100644
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
 		dfp = xfs_defer_alloc(&tp->t_dfops, ops);
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 8b338031e487c4..ec51b8465e61cb 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -71,6 +71,7 @@ extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
 extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
+extern const struct xfs_defer_op_type xfs_rtextent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_attr_defer_type;
 extern const struct xfs_defer_op_type xfs_exchmaps_defer_type;
 
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index ace7384a275bfb..15dec19b6c32ad 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
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

