Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4414D8F40
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832020; cv=none; b=PO96CGCYVhP0hEphR7fsE5nY89Bd1Xv5WvP0a4NGHSgAJCUSDByGXf1btOKvQ3sk68XbGYF61wMrb5rpw8IplMVK/pztjsdhOiY+nQVqlEmrI8M3nlcV/Ht/RlPMuU9Y5zrzAS/FI1UBIRVr2POscnu+heTtZvz8meVjKQdA7hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832020; c=relaxed/simple;
	bh=MlEgE07U0J+XLrn/C8I9aH/7ike1CT1H8VKcxBrzxUE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AJBLpSv6m/+FFwBV995C51QSJMx6GPvxAL9XSGfsGuNADfwdw61dm3lgUJVbfFMmYQTVTKQP1R5e6m8kCaj9vGSvUD4wlaqIaci6l6fW9SAsxVeFFcJfEXwZdrtF2YFL1XR0YtgjO4XbkDqy1ZAwXXPnRg6ssJ/jyxDuA3I8XGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sTnlnVKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sTnlnVKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16658C4CEC6;
	Wed,  2 Oct 2024 01:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832020;
	bh=MlEgE07U0J+XLrn/C8I9aH/7ike1CT1H8VKcxBrzxUE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sTnlnVKWCntJcShYpvbEJoqxA9z5h5jQqe6diHDAhG8h7Xp6WRZh2DpV8S6cf9r0O
	 ZwnFMbzGZ4LqE5xWPGT8m5NBKZ/PuNPnBB7a0tzIdB//QhsT2vrf8GxzybcOAhWRIN
	 0KjaaHqCd8yKBo4LEH1MgP7S+ne2EghBXFf1Oc6zm4td21iklylWDpXuhEyRulrA3Y
	 rcZcIpUX6yEhOa0se2Ksyvqo24JhsuMAcrOn09n6q65o3qeSFnPjWy/gVnFM+ljEcG
	 rshkE5BZZIw9kIPFfpttjCle4PAaydQsU6ZXzECPsMpiFQi5dQZ5pLZ0OechzyRKT1
	 G2rQ9Gmt4K66w==
Date: Tue, 01 Oct 2024 18:20:19 -0700
Subject: [PATCH 48/64] xfs: move xfs_rmap_update_defer_add to xfs_rmap_item.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102505.4036371.11209477625800698380.stgit@frogsfrogsfrogs>
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

Source kernel commit: ea7b0820d960d5a3ee72bc67cbd8b5d47c67aa4c

Move the code that adds the incore xfs_rmap_update_item deferred work
data to a transaction to live with the RUI log item code.  This means
that the rmap code no longer has to know about the inner workings of the
RUI log items.

As a consequence, we can get rid of the _{get,put}_group helpers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/defer_item.c |   21 +++++++++------------
 libxfs/defer_item.h |    4 ++++
 libxfs/xfs_rmap.c   |    6 ++----
 libxfs/xfs_rmap.h   |    3 ---
 4 files changed, 15 insertions(+), 19 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 7721267e4..1c106b844 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -243,21 +243,18 @@ xfs_rmap_update_create_done(
 	return NULL;
 }
 
-/* Take an active ref to the AG containing the space we're rmapping. */
+/* Add this deferred RUI to the transaction. */
 void
-xfs_rmap_update_get_group(
-	struct xfs_mount	*mp,
+xfs_rmap_defer_add(
+	struct xfs_trans	*tp,
 	struct xfs_rmap_intent	*ri)
 {
+	struct xfs_mount	*mp = tp->t_mountp;
+
+	trace_xfs_rmap_defer(mp, ri);
+
 	ri->ri_pag = xfs_perag_intent_get(mp, ri->ri_bmap.br_startblock);
-}
-
-/* Release an active AG ref after finishing rmapping work. */
-static inline void
-xfs_rmap_update_put_group(
-	struct xfs_rmap_intent	*ri)
-{
-	xfs_perag_intent_put(ri->ri_pag);
+	xfs_defer_add(tp, &ri->ri_list, &xfs_rmap_update_defer_type);
 }
 
 /* Cancel a deferred rmap update. */
@@ -267,7 +264,7 @@ xfs_rmap_update_cancel_item(
 {
 	struct xfs_rmap_intent		*ri = ri_entry(item);
 
-	xfs_rmap_update_put_group(ri);
+	xfs_perag_intent_put(ri->ri_pag);
 	kmem_cache_free(xfs_rmap_intent_cache, ri);
 }
 
diff --git a/libxfs/defer_item.h b/libxfs/defer_item.h
index 03f3f1505..be354785b 100644
--- a/libxfs/defer_item.h
+++ b/libxfs/defer_item.h
@@ -30,4 +30,8 @@ void xfs_extent_free_defer_add(struct xfs_trans *tp,
 		struct xfs_extent_free_item *xefi,
 		struct xfs_defer_pending **dfpp);
 
+struct xfs_rmap_intent;
+
+void xfs_rmap_defer_add(struct xfs_trans *tp, struct xfs_rmap_intent *ri);
+
 #endif /* __LIBXFS_DEFER_ITEM_H_ */
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index d60edaa23..22947e3c9 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -23,6 +23,7 @@
 #include "xfs_inode.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
+#include "defer_item.h"
 
 struct kmem_cache	*xfs_rmap_intent_cache;
 
@@ -2655,10 +2656,7 @@ __xfs_rmap_add(
 	ri->ri_whichfork = whichfork;
 	ri->ri_bmap = *bmap;
 
-	trace_xfs_rmap_defer(tp->t_mountp, ri);
-
-	xfs_rmap_update_get_group(tp->t_mountp, ri);
-	xfs_defer_add(tp, &ri->ri_list, &xfs_rmap_update_defer_type);
+	xfs_rmap_defer_add(tp, ri);
 }
 
 /* Map an extent into a file. */
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 9d85dd2a6..b783dd4dd 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -176,9 +176,6 @@ struct xfs_rmap_intent {
 	struct xfs_perag			*ri_pag;
 };
 
-void xfs_rmap_update_get_group(struct xfs_mount *mp,
-		struct xfs_rmap_intent *ri);
-
 /* functions for updating the rmapbt based on bmbt map/unmap operations */
 void xfs_rmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 		int whichfork, struct xfs_bmbt_irec *imap);

