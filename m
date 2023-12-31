Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EC3BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZAhV904i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECB7C433C8;
	Sun, 31 Dec 2023 21:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058119;
	bh=kg65gkM8tyxRFg6kAqK/7MHvY8mXvj0QGtmq38JHu78=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZAhV904ioPR22kftF6OAHfIlcgWwlrTAi3gf9myA3sgRQddtsj3mHQa3VLm9YJFDq
	 IcM0CeVlPgpeFGVN2YgleqNXGc5ijEgMFyFBUVZkab7ywpZZgMbmFdKVRsKemcL+AU
	 uVM3iBladXMgWcPqApVan7fkqyYGWYqhSFGvh5K6e24kvn2+jKjHdsyGHQ4cWqs6g8
	 vwUljnCvrdHFh35MHw5P5vyalT9lAMGdjJ7N/jo+3hk+Xitzzy8J+0zb60PJ2OrUWZ
	 DOvL6QC2Qo4y2DYuAtb6h/jIyIsxfscLCsPXwhwyrtClVW6eJwk1DpLbXg1ucBIXc0
	 N/QToLBhEc4rg==
Date: Sun, 31 Dec 2023 13:28:39 -0800
Subject: [PATCH 9/9] xfs: move xfs_extent_free_defer_add to xfs_extfree_item.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404848480.1764329.1566640489700733204.stgit@frogsfrogsfrogs>
In-Reply-To: <170404848314.1764329.10362480227353094080.stgit@frogsfrogsfrogs>
References: <170404848314.1764329.10362480227353094080.stgit@frogsfrogsfrogs>
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

Move the code that adds the incore xfs_extent_free_item deferred work
data to a transaction live with the EFI log item code.  This means that
the allocator code no longer has to know about the inner workings of the
EFI log items.

As a consequence, we can get rid of the _{get,put}_group helpers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |   12 ++----------
 fs/xfs/libxfs/xfs_alloc.h |    3 ---
 fs/xfs/xfs_extfree_item.c |   31 +++++++++++++++++--------------
 fs/xfs/xfs_extfree_item.h |    6 ++++++
 4 files changed, 25 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 0227985676042..5d63711ad1aac 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -27,6 +27,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
 #include "xfs_health.h"
+#include "xfs_extfree_item.h"
 
 struct kmem_cache	*xfs_extfree_item_cache;
 
@@ -2582,16 +2583,7 @@ xfs_defer_extent_free(
 		xefi->xefi_owner = XFS_RMAP_OWN_NULL;
 	}
 
-	trace_xfs_extent_free_defer(mp, xefi);
-
-	xfs_extent_free_get_group(mp, xefi);
-
-	if (xefi->xefi_agresv == XFS_AG_RESV_AGFL)
-		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
-				&xfs_agfl_free_defer_type);
-	else
-		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
-				&xfs_extent_free_defer_type);
+	xfs_extent_free_defer_add(tp, xefi, dfpp);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 2da543fb90ecd..0ed71a31fe7ce 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -254,9 +254,6 @@ struct xfs_extent_free_item {
 	enum xfs_ag_resv_type	xefi_agresv;
 };
 
-void xfs_extent_free_get_group(struct xfs_mount *mp,
-		struct xfs_extent_free_item *xefi);
-
 #define XFS_EFI_SKIP_DISCARD	(1U << 0) /* don't issue discard */
 #define XFS_EFI_ATTR_FORK	(1U << 1) /* freeing attr fork block */
 #define XFS_EFI_BMBT_BLOCK	(1U << 2) /* freeing bmap btree block */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index be932390bd1f7..e8569bf26819c 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -436,21 +436,24 @@ xfs_extent_free_create_done(
 	return &efdp->efd_item;
 }
 
-/* Take a passive ref to the AG containing the space we're freeing. */
+/* Add this deferred EFI to the transaction. */
 void
-xfs_extent_free_get_group(
-	struct xfs_mount		*mp,
-	struct xfs_extent_free_item	*xefi)
+xfs_extent_free_defer_add(
+	struct xfs_trans		*tp,
+	struct xfs_extent_free_item	*xefi,
+	struct xfs_defer_pending	**dfpp)
 {
+	struct xfs_mount		*mp = tp->t_mountp;
+
+	trace_xfs_extent_free_defer(mp, xefi);
+
 	xefi->xefi_pag = xfs_perag_intent_get(mp, xefi->xefi_startblock);
-}
-
-/* Release a passive AG ref after some freeing work. */
-static inline void
-xfs_extent_free_put_group(
-	struct xfs_extent_free_item	*xefi)
-{
-	xfs_perag_intent_put(xefi->xefi_pag);
+	if (xefi->xefi_agresv == XFS_AG_RESV_AGFL)
+		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
+				&xfs_agfl_free_defer_type);
+	else
+		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
+				&xfs_extent_free_defer_type);
 }
 
 /* Cancel a free extent. */
@@ -460,7 +463,7 @@ xfs_extent_free_cancel_item(
 {
 	struct xfs_extent_free_item	*xefi = xefi_entry(item);
 
-	xfs_extent_free_put_group(xefi);
+	xfs_perag_intent_put(xefi->xefi_pag);
 	kmem_cache_free(xfs_extfree_item_cache, xefi);
 }
 
@@ -575,7 +578,7 @@ xfs_efi_recover_work(
 	xefi->xefi_blockcount = extp->ext_len;
 	xefi->xefi_agresv = XFS_AG_RESV_NONE;
 	xefi->xefi_owner = XFS_RMAP_OWN_UNKNOWN;
-	xfs_extent_free_get_group(mp, xefi);
+	xefi->xefi_pag = xfs_perag_intent_get(mp, extp->ext_start);
 
 	xfs_defer_add_item(dfp, &xefi->xefi_list);
 }
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index da6a5afa607cf..41b7c43060799 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -88,4 +88,10 @@ xfs_efd_log_item_sizeof(
 extern struct kmem_cache	*xfs_efi_cache;
 extern struct kmem_cache	*xfs_efd_cache;
 
+struct xfs_extent_free_item;
+
+void xfs_extent_free_defer_add(struct xfs_trans *tp,
+		struct xfs_extent_free_item *xefi,
+		struct xfs_defer_pending **dfpp);
+
 #endif	/* __XFS_EXTFREE_ITEM_H__ */

