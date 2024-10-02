Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D7A2107
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831895; cv=none; b=cjDFvElVx3E+ZkXHK1jvxW5FbJznkEkVw25gWhf3t+YXkIZA4e52SAu5VeQgDwwisx20HceyPw8RjCAYeKTDPnwU1olkYyQcyQGK4ZmcrS6yfHOzdG/8BmIaQ5JpILdo9PXb9ixmmv8P5tL85SiK63QTBja8B6GBZSUQdLNLsrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831895; c=relaxed/simple;
	bh=w4WptIEbNoWpAGAUMFpShkoG1MCh+JbW78YYmG1NEI0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UbaWcAUdYI4rYnRuGIWh4e4VgstUN7CglvMXx+FSxFklERdJ1vr0LScyl/bpVoPVoOsbUIi8tk9afZ7sfA/Ue/KWZsgLhBbS11sEK+LXmB5Jswq5dEvT1uhkORkAedZQ1HJxHNE40jt9NXZTcCoHuyz9eKB6A+fG+q4TUq7XVuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IXBulAsx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IXBulAsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561E4C4CEC6;
	Wed,  2 Oct 2024 01:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831895;
	bh=w4WptIEbNoWpAGAUMFpShkoG1MCh+JbW78YYmG1NEI0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IXBulAsxZ82XljkLoBbr3m3UjNQ9Z6Pg1r/DvEMm/RLGkvwUKeiofi5FueFhrJkLo
	 tmSW5uXIA5xL6XsJxZn1HIIdF5WDWgHarnHgMJDSdECzUm3GuNFjHD40vB65oDkEYx
	 dS9DdaH7I22D7Aj7CXQWvsuKCIiatFBGbz+pNd9SzGEUUDjPu5CNZCvZLg/UkQIkh3
	 NGv60nORJYZTtwa+1pQEND0kv6NHqSMzodS/2N/j+rhSq96SRsttrtoU/MOK+cSyYd
	 607LXV4dlRR/uMPoK2QLIWxUCzcuyc5CVbdtP0WkKC+pNSVN9IBpBdPCLBKBFkTYzl
	 Ow6XJI7pUMvqQ==
Date: Tue, 01 Oct 2024 18:18:14 -0700
Subject: [PATCH 40/64] xfs: move xfs_extent_free_defer_add to
 xfs_extfree_item.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102384.4036371.5477123847558382056.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: 84a3c1576c5aade32170fae6c61d51bd2d16010f

Move the code that adds the incore xfs_extent_free_item deferred work
data to a transaction to live with the EFI log item code.  This means
that the allocator code no longer has to know about the inner workings
of the EFI log items.

As a consequence, we can get rid of the _{get,put}_group helpers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/defer_item.c |   28 +++++++++++++++-------------
 libxfs/defer_item.h |    7 +++++++
 libxfs/xfs_alloc.c  |   12 ++----------
 libxfs/xfs_alloc.h  |    3 ---
 4 files changed, 24 insertions(+), 26 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index dd88e75e9..2df0ce4e8 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -27,6 +27,7 @@
 #include "defer_item.h"
 #include "xfs_ag.h"
 #include "xfs_exchmaps.h"
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
index df2b8d68b..03f3f1505 100644
--- a/libxfs/defer_item.h
+++ b/libxfs/defer_item.h
@@ -23,4 +23,11 @@ struct xfs_exchmaps_intent;
 void xfs_exchmaps_defer_add(struct xfs_trans *tp,
 		struct xfs_exchmaps_intent *xmi);
 
+struct xfs_extent_free_item;
+struct xfs_defer_pending;
+
+void xfs_extent_free_defer_add(struct xfs_trans *tp,
+		struct xfs_extent_free_item *xefi,
+		struct xfs_defer_pending **dfpp);
+
 #endif /* __LIBXFS_DEFER_ITEM_H_ */
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 60ac73828..063ac1973 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -23,6 +23,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
 #include "xfs_health.h"
+#include "defer_item.h"
 
 struct kmem_cache	*xfs_extfree_item_cache;
 
@@ -2548,16 +2549,7 @@ xfs_defer_extent_free(
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
index 7f51b3cb0..fae170825 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -256,9 +256,6 @@ struct xfs_extent_free_item {
 	enum xfs_ag_resv_type	xefi_agresv;
 };
 
-void xfs_extent_free_get_group(struct xfs_mount *mp,
-		struct xfs_extent_free_item *xefi);
-
 #define XFS_EFI_SKIP_DISCARD	(1U << 0) /* don't issue discard */
 #define XFS_EFI_ATTR_FORK	(1U << 1) /* freeing attr fork block */
 #define XFS_EFI_BMBT_BLOCK	(1U << 2) /* freeing bmap btree block */

