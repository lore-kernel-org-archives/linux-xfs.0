Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB577ED
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OAJ5OKOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8B5C433C8;
	Mon,  1 Jan 2024 00:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068769;
	bh=QTXkFIV6YeknR7VVvK78oK0icqNo6XsZudBsO8I8ip0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OAJ5OKOOnKrSiBK753WFP2Q7fTKIqCcukW4NTkJKAWXTLtiXDlKRWOHLnq/axPOvy
	 geVTa+7sP2/oK4jlwKuP1GGEWB8ppOtLmHQK8qtxA1fM5PP4krbJSCghonm9VhRUc0
	 9kAtr6nGAB295Gse8MAgrkHGM3Z4YGbapA8fUmVeTKeXZbVrfEnIHIiintyBzTAA+g
	 7xwpdkGFE7FId/iHHri/00vpeITSf6zklL48g+Pw+CPyIBL8fQbxywVfoTPofXcaaN
	 jI/MxxgwGTjf6pH9TNg5LOVTuDcqK9f7YYTTygs7sk+CkMiMxnO1NrgC9yGA8cIuAQ
	 I0+LMGQ3NukkQ==
Date: Sun, 31 Dec 2023 16:26:08 +9900
Subject: [PATCH 9/9] xfs: move xfs_refcount_update_defer_add to
 xfs_refcount_item.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405016740.1816837.892103686003326408.stgit@frogsfrogsfrogs>
In-Reply-To: <170405016616.1816837.2298941345938137266.stgit@frogsfrogsfrogs>
References: <170405016616.1816837.2298941345938137266.stgit@frogsfrogsfrogs>
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

Move the code that adds the incore xfs_refcount_update_item deferred
work data to a transaction live with the CUI log item code.  This means
that the refcount code no longer has to know about the inner workings of
the CUI log items.

As a consequence, we can get rid of the _{get,put}_group helpers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c   |   21 +++++++++------------
 libxfs/defer_item.h   |    5 +++++
 libxfs/xfs_refcount.c |    6 ++----
 libxfs/xfs_refcount.h |    3 ---
 4 files changed, 16 insertions(+), 19 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 58a18c7876d..3956a38b414 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -528,21 +528,18 @@ xfs_refcount_update_create_done(
 	return NULL;
 }
 
-/* Take an active ref to the AG containing the space we're refcounting. */
+/* Add this deferred CUI to the transaction. */
 void
-xfs_refcount_update_get_group(
-	struct xfs_mount		*mp,
+xfs_refcount_defer_add(
+	struct xfs_trans		*tp,
 	struct xfs_refcount_intent	*ri)
 {
+	struct xfs_mount		*mp = tp->t_mountp;
+
+	trace_xfs_refcount_defer(mp, ri);
+
 	ri->ri_pag = xfs_perag_intent_get(mp, ri->ri_startblock);
-}
-
-/* Release an active AG ref after finishing refcounting work. */
-static inline void
-xfs_refcount_update_put_group(
-	struct xfs_refcount_intent	*ri)
-{
-	xfs_perag_intent_put(ri->ri_pag);
+	xfs_defer_add(tp, &ri->ri_list, &xfs_refcount_update_defer_type);
 }
 
 /* Cancel a deferred refcount update. */
@@ -552,7 +549,7 @@ xfs_refcount_update_cancel_item(
 {
 	struct xfs_refcount_intent	*ri = ci_entry(item);
 
-	xfs_refcount_update_put_group(ri);
+	xfs_perag_intent_put(ri->ri_pag);
 	kmem_cache_free(xfs_refcount_intent_cache, ri);
 }
 
diff --git a/libxfs/defer_item.h b/libxfs/defer_item.h
index 3ef31ad0aec..bbb4587b97f 100644
--- a/libxfs/defer_item.h
+++ b/libxfs/defer_item.h
@@ -24,4 +24,9 @@ struct xfs_rmap_intent;
 
 void xfs_rmap_defer_add(struct xfs_trans *tp, struct xfs_rmap_intent *ri);
 
+struct xfs_refcount_intent;
+
+void xfs_refcount_defer_add(struct xfs_trans *tp,
+		struct xfs_refcount_intent *ri);
+
 #endif /* __LIBXFS_DEFER_ITEM_H_ */
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 5cd279786ce..b094d9a41f6 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -23,6 +23,7 @@
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
+#include "defer_item.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
 
@@ -1434,10 +1435,7 @@ __xfs_refcount_add(
 	ri->ri_startblock = startblock;
 	ri->ri_blockcount = blockcount;
 
-	trace_xfs_refcount_defer(tp->t_mountp, ri);
-
-	xfs_refcount_update_get_group(tp->t_mountp, ri);
-	xfs_defer_add(tp, &ri->ri_list, &xfs_refcount_update_defer_type);
+	xfs_refcount_defer_add(tp, ri);
 }
 
 /*
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index c94b8f71d40..68acb0b1b4a 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -74,9 +74,6 @@ xfs_refcount_check_domain(
 	return true;
 }
 
-void xfs_refcount_update_get_group(struct xfs_mount *mp,
-		struct xfs_refcount_intent *ri);
-
 void xfs_refcount_increase_extent(struct xfs_trans *tp,
 		struct xfs_bmbt_irec *irec);
 void xfs_refcount_decrease_extent(struct xfs_trans *tp,

