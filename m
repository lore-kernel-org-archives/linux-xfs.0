Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2826B7F9
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g7mdIYSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A792BC433C8;
	Mon,  1 Jan 2024 00:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067643;
	bh=DMpcZS4U/jprPyZkitwuadDbAlklbiNGJZ62OyqbIPM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g7mdIYSIUo40BNBUuqYxbb8wPZsbgkBWdxyGBXr2V0Qn/RE+A6FMOvAQFkH1lcVB4
	 dZDa7Yycu70V1eQb5ybLfBo/MQvFpfGXVKKJxhbFHFE8p16rHh5wEfQAnEO1moiebR
	 slJCNPh+wzRUNG0i45NviBIzCp3i1ZsSqA7wFw8bV3emZN5DhYJX9FNl0SLkKPBWTN
	 TPh3E1XxvFLbglfbEThcp8U4dQpCNY47JlajWTnYIems9nfaSU1Yjp27YsoYfD4j7y
	 v49oeJKNkrhQybU1wQHzwmSXy8htyk7LfsqW0EeK5FN8yx7rVgoo89rodi7g9PEy+g
	 gvs6J836fQOtg==
Date: Sun, 31 Dec 2023 16:07:23 +9900
Subject: [PATCH 8/8] xfs: move xfs_extent_free_defer_add to xfs_extfree_item.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405014147.1814860.1219013882852428238.stgit@frogsfrogsfrogs>
In-Reply-To: <170405014035.1814860.4299784888161945873.stgit@frogsfrogsfrogs>
References: <170405014035.1814860.4299784888161945873.stgit@frogsfrogsfrogs>
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
 libxfs/defer_item.c |   28 +++++++++++++++-------------
 libxfs/defer_item.h |    6 ++++++
 libxfs/xfs_alloc.c  |   12 ++----------
 libxfs/xfs_alloc.h  |    3 ---
 4 files changed, 23 insertions(+), 26 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index b159f22c1c0..9b9bce17f4e 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -27,6 +27,7 @@
 #include "defer_item.h"
 #include "xfs_ag.h"
 #include "xfs_swapext.h"
+#include "defer_item.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
@@ -75,21 +76,22 @@ xfs_extent_free_create_done(
 	return NULL;
 }
 
-/* Take an active ref to the AG containing the space we're freeing. */
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
 	xefi->xefi_pag = xfs_perag_intent_get(mp, xefi->xefi_startblock);
-}
-
-/* Release an active AG ref after some freeing work. */
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
@@ -99,7 +101,7 @@ xfs_extent_free_cancel_item(
 {
 	struct xfs_extent_free_item	*xefi = xefi_entry(item);
 
-	xfs_extent_free_put_group(xefi);
+	xfs_perag_intent_put(xefi->xefi_pag);
 	kmem_cache_free(xfs_extfree_item_cache, xefi);
 }
 
diff --git a/libxfs/defer_item.h b/libxfs/defer_item.h
index a3ef9e079d0..79e957eb8ff 100644
--- a/libxfs/defer_item.h
+++ b/libxfs/defer_item.h
@@ -14,4 +14,10 @@ struct xfs_swapext_intent;
 
 void xfs_swapext_defer_add(struct xfs_trans *tp, struct xfs_swapext_intent *sxi);
 
+struct xfs_extent_free_item;
+
+void xfs_extent_free_defer_add(struct xfs_trans *tp,
+		struct xfs_extent_free_item *xefi,
+		struct xfs_defer_pending **dfpp);
+
 #endif /* __LIBXFS_DEFER_ITEM_H_ */
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 2cbdbd4c416..36af2c087b0 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -23,6 +23,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
 #include "xfs_health.h"
+#include "defer_item.h"
 
 struct kmem_cache	*xfs_extfree_item_cache;
 
@@ -2578,16 +2579,7 @@ xfs_defer_extent_free(
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
 
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 2da543fb90e..0ed71a31fe7 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -254,9 +254,6 @@ struct xfs_extent_free_item {
 	enum xfs_ag_resv_type	xefi_agresv;
 };
 
-void xfs_extent_free_get_group(struct xfs_mount *mp,
-		struct xfs_extent_free_item *xefi);
-
 #define XFS_EFI_SKIP_DISCARD	(1U << 0) /* don't issue discard */
 #define XFS_EFI_ATTR_FORK	(1U << 1) /* freeing attr fork block */
 #define XFS_EFI_BMBT_BLOCK	(1U << 2) /* freeing bmap btree block */

