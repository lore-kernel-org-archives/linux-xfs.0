Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA12BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sMh34Lr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A37C433C8;
	Sun, 31 Dec 2023 21:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058307;
	bh=P2sISHwwhkPfG+TjhlQUuXst+wIDSj+MIS+tLrDZr6c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sMh34Lr3XnaUTPC3m+Eq4GyAl+vONT71SrhcfY6qHE4ZthsjQrpxNtLnKi5CB87xL
	 EO8+vcgoDA11z0QJITMwjFq6aR/xl51Cuv5R9Ffi64nqKnvHJjRQUMQGCuR5jvPrBL
	 op85/QqCOXGk5yL8/Jn77JioonvLjvOA23Y4z8igBp+WFObUjg5Vm42AswvcRcudss
	 UmxIAKCv6xlEPKpJ71iOSv3UPU3bw0FINp3acNPRIbcOIEx0F49po4OcgdrrV+9UhX
	 kcQlgFG9PO6f/1RHo5pYxEdaTFS8SZ2aSch6/p/g4d1hPNrPaNEaF2cYFyPDIG80IL
	 BCUoT2yEyskXA==
Date: Sun, 31 Dec 2023 13:31:47 -0800
Subject: [PATCH 10/10] xfs: move xfs_rmap_update_defer_add to xfs_rmap_item.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404849394.1764703.1033338756658358059.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
References: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_rmap.c |    6 ++----
 fs/xfs/libxfs/xfs_rmap.h |    3 ---
 fs/xfs/xfs_rmap_item.c   |   24 +++++++++++-------------
 fs/xfs/xfs_rmap_item.h   |    4 ++++
 4 files changed, 17 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 3830f73607f32..0f552cb737c8b 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -24,6 +24,7 @@
 #include "xfs_inode.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
+#include "xfs_rmap_item.h"
 
 struct kmem_cache	*xfs_rmap_intent_cache;
 
@@ -2647,10 +2648,7 @@ __xfs_rmap_add(
 	ri->ri_whichfork = whichfork;
 	ri->ri_bmap = *bmap;
 
-	trace_xfs_rmap_defer(tp->t_mountp, ri);
-
-	xfs_rmap_update_get_group(tp->t_mountp, ri);
-	xfs_defer_add(tp, &ri->ri_list, &xfs_rmap_update_defer_type);
+	xfs_rmap_defer_add(tp, ri);
 }
 
 /* Map an extent into a file. */
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 2513ee36aa29d..e6240efd6fe75 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -176,9 +176,6 @@ struct xfs_rmap_intent {
 	struct xfs_perag			*ri_pag;
 };
 
-void xfs_rmap_update_get_group(struct xfs_mount *mp,
-		struct xfs_rmap_intent *ri);
-
 /* functions for updating the rmapbt based on bmbt map/unmap operations */
 void xfs_rmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 		int whichfork, struct xfs_bmbt_irec *imap);
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index d13fe835f0313..e2ee1b6719202 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -22,6 +22,7 @@
 #include "xfs_log_recover.h"
 #include "xfs_ag.h"
 #include "xfs_btree.h"
+#include "xfs_trace.h"
 
 struct kmem_cache	*xfs_rui_cache;
 struct kmem_cache	*xfs_rud_cache;
@@ -341,21 +342,18 @@ xfs_rmap_update_create_done(
 	return &rudp->rud_item;
 }
 
-/* Take a passive ref to the AG containing the space we're rmapping. */
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
-/* Release a passive AG ref after finishing rmapping work. */
-static inline void
-xfs_rmap_update_put_group(
-	struct xfs_rmap_intent	*ri)
-{
-	xfs_perag_intent_put(ri->ri_pag);
+	xfs_defer_add(tp, &ri->ri_list, &xfs_rmap_update_defer_type);
 }
 
 /* Cancel a deferred rmap update. */
@@ -365,7 +363,7 @@ xfs_rmap_update_cancel_item(
 {
 	struct xfs_rmap_intent		*ri = ri_entry(item);
 
-	xfs_rmap_update_put_group(ri);
+	xfs_perag_intent_put(ri->ri_pag);
 	kmem_cache_free(xfs_rmap_intent_cache, ri);
 }
 
@@ -495,7 +493,7 @@ xfs_rui_recover_work(
 	ri->ri_bmap.br_blockcount = map->me_len;
 	ri->ri_bmap.br_state = (map->me_flags & XFS_RMAP_EXTENT_UNWRITTEN) ?
 			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
-	xfs_rmap_update_get_group(mp, ri);
+	ri->ri_pag = xfs_perag_intent_get(mp, map->me_startblock);
 
 	xfs_defer_add_item(dfp, &ri->ri_list);
 }
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index 802e5119eacaa..40d331555675b 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -71,4 +71,8 @@ struct xfs_rud_log_item {
 extern struct kmem_cache	*xfs_rui_cache;
 extern struct kmem_cache	*xfs_rud_cache;
 
+struct xfs_rmap_intent;
+
+void xfs_rmap_defer_add(struct xfs_trans *tp, struct xfs_rmap_intent *ri);
+
 #endif	/* __XFS_RMAP_ITEM_H__ */

