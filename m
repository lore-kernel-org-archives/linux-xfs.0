Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066EE38B
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SgAPIcf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7619FC433C8;
	Mon,  1 Jan 2024 00:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067831;
	bh=v369iSh5QgxhvS+WBHi4OeoGv7u5vNt48NNd5U45hss=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SgAPIcf4YBn/1+S63snoC8nCO4/dobyu67G5F0LoVEE57BNS/nDxb5XNyWZ7YFhWL
	 yhFSDRDf8TJoLvz17o6F1qAT5hLaPcUQGj0QdcH81V4ZlM0qA/zqiN3ocYgANaDyX0
	 a2RGJEj46iVn5V8/HsigPj3svvACpDJcqfQnhkzE2FrSsTHCwGxoIgr6YAWwyC0AaH
	 IgIptpD4NW2nzKfFtv8yRRis0iE15ViLCbghOeR44wEf4VIDwLcmnoG0HCZZ+0f1RQ
	 kf2ARqGfSrcSLYR3fc81ApCTgjg3NSBS1LWwglP4b0AUtHlWdzKht2ajSCuIaifS7U
	 kR4HfOaqEq7Iw==
Date: Sun, 31 Dec 2023 16:10:31 +9900
Subject: [PATCH 9/9] xfs: move xfs_rmap_update_defer_add to xfs_rmap_item.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405014935.1815232.9270614482521381464.stgit@frogsfrogsfrogs>
In-Reply-To: <170405014813.1815232.16195473149230327174.stgit@frogsfrogsfrogs>
References: <170405014813.1815232.16195473149230327174.stgit@frogsfrogsfrogs>
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

Move the code that adds the incore xfs_rmap_update_item deferred work
data to a transaction live with the RUI log item code.  This means that
the rmap code no longer has to know about the inner workings of the RUI
log items.

As a consequence, we can get rid of the _{get,put}_group helpers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   21 +++++++++------------
 libxfs/defer_item.h |    4 ++++
 libxfs/xfs_rmap.c   |    6 ++----
 libxfs/xfs_rmap.h   |    3 ---
 4 files changed, 15 insertions(+), 19 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index d3df56f0a2b..5399a20f186 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -319,21 +319,18 @@ xfs_rmap_update_create_done(
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
@@ -343,7 +340,7 @@ xfs_rmap_update_cancel_item(
 {
 	struct xfs_rmap_intent		*ri = ri_entry(item);
 
-	xfs_rmap_update_put_group(ri);
+	xfs_perag_intent_put(ri->ri_pag);
 	kmem_cache_free(xfs_rmap_intent_cache, ri);
 }
 
diff --git a/libxfs/defer_item.h b/libxfs/defer_item.h
index 79e957eb8ff..3ef31ad0aec 100644
--- a/libxfs/defer_item.h
+++ b/libxfs/defer_item.h
@@ -20,4 +20,8 @@ void xfs_extent_free_defer_add(struct xfs_trans *tp,
 		struct xfs_extent_free_item *xefi,
 		struct xfs_defer_pending **dfpp);
 
+struct xfs_rmap_intent;
+
+void xfs_rmap_defer_add(struct xfs_trans *tp, struct xfs_rmap_intent *ri);
+
 #endif /* __LIBXFS_DEFER_ITEM_H_ */
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 183e840b7f1..24daf0ffb66 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -23,6 +23,7 @@
 #include "xfs_inode.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
+#include "defer_item.h"
 
 struct kmem_cache	*xfs_rmap_intent_cache;
 
@@ -2646,10 +2647,7 @@ __xfs_rmap_add(
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
index 2513ee36aa2..e6240efd6fe 100644
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

