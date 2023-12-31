Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2379BE48
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JzBkMIR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B588BC433C7;
	Sun, 31 Dec 2023 21:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059074;
	bh=0NvWL3VCPI/+sBqUQWl2zmG1+1TV8kxDoGaP5fARpaQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JzBkMIR4CjEXKwLT2HaoySI5bNwvNpvjof0fiXJZlyZf6eGqfckrZylv1ywxxZEW8
	 IUjVZYH/LLokv/vhGewFlP0Johr23V7SAulElwrYk81uXwRSYN/GOLYotPnEMtlZNu
	 sl8Ru2gqCVR2ZqHmr7aGl7ln2JE9bgIyzNgtc66o7mIlfjKh/K0WK7CS1PIzrdyDQq
	 WbAORCvVeXXts75967EFJQa0rv19bV4hwRkbKHXl2guBKFu76Xx+Vzr7JOM08iVDwV
	 jjeFFyN6RCVaXDAsEx3l2qhRVsPzRCzaqdt3DXIW2w6yDaiXZbLQxmG0HOfEhki9Jn
	 I59TZcwAcscIQ==
Date: Sun, 31 Dec 2023 13:44:34 -0800
Subject: [PATCH 10/10] xfs: move xfs_refcount_update_defer_add to
 xfs_refcount_item.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851053.1765989.3281178019422983331.stgit@frogsfrogsfrogs>
In-Reply-To: <170404850874.1765989.3728283509894891914.stgit@frogsfrogsfrogs>
References: <170404850874.1765989.3728283509894891914.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_refcount.c |    6 ++----
 fs/xfs/libxfs/xfs_refcount.h |    3 ---
 fs/xfs/xfs_refcount_item.c   |   24 +++++++++++-------------
 fs/xfs/xfs_refcount_item.h   |    5 +++++
 4 files changed, 18 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index ccb2a1fa5f589..edabdf1a97d4b 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -24,6 +24,7 @@
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
+#include "xfs_refcount_item.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
 
@@ -1435,10 +1436,7 @@ __xfs_refcount_add(
 	ri->ri_startblock = startblock;
 	ri->ri_blockcount = blockcount;
 
-	trace_xfs_refcount_defer(tp->t_mountp, ri);
-
-	xfs_refcount_update_get_group(tp->t_mountp, ri);
-	xfs_defer_add(tp, &ri->ri_list, &xfs_refcount_update_defer_type);
+	xfs_refcount_defer_add(tp, ri);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index c94b8f71d407b..68acb0b1b4a87 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -74,9 +74,6 @@ xfs_refcount_check_domain(
 	return true;
 }
 
-void xfs_refcount_update_get_group(struct xfs_mount *mp,
-		struct xfs_refcount_intent *ri);
-
 void xfs_refcount_increase_extent(struct xfs_trans *tp,
 		struct xfs_bmbt_irec *irec);
 void xfs_refcount_decrease_extent(struct xfs_trans *tp,
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index b36d8433098c8..bec3b91e826a4 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -22,6 +22,7 @@
 #include "xfs_log_recover.h"
 #include "xfs_ag.h"
 #include "xfs_btree.h"
+#include "xfs_trace.h"
 
 struct kmem_cache	*xfs_cui_cache;
 struct kmem_cache	*xfs_cud_cache;
@@ -319,21 +320,18 @@ xfs_refcount_update_create_done(
 	return &cudp->cud_item;
 }
 
-/* Take a passive ref to the AG containing the space we're refcounting. */
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
-/* Release a passive AG ref after finishing refcounting work. */
-static inline void
-xfs_refcount_update_put_group(
-	struct xfs_refcount_intent	*ri)
-{
-	xfs_perag_intent_put(ri->ri_pag);
+	xfs_defer_add(tp, &ri->ri_list, &xfs_refcount_update_defer_type);
 }
 
 /* Cancel a deferred refcount update. */
@@ -343,7 +341,7 @@ xfs_refcount_update_cancel_item(
 {
 	struct xfs_refcount_intent	*ri = ci_entry(item);
 
-	xfs_refcount_update_put_group(ri);
+	xfs_perag_intent_put(ri->ri_pag);
 	kmem_cache_free(xfs_refcount_intent_cache, ri);
 }
 
@@ -433,7 +431,7 @@ xfs_cui_recover_work(
 	ri->ri_type = pmap->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK;
 	ri->ri_startblock = pmap->pe_startblock;
 	ri->ri_blockcount = pmap->pe_len;
-	xfs_refcount_update_get_group(mp, ri);
+	ri->ri_pag = xfs_perag_intent_get(mp, pmap->pe_startblock);
 
 	xfs_defer_add_item(dfp, &ri->ri_list);
 }
diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
index eb0ab13682d0b..bfee8f30c63ce 100644
--- a/fs/xfs/xfs_refcount_item.h
+++ b/fs/xfs/xfs_refcount_item.h
@@ -71,4 +71,9 @@ struct xfs_cud_log_item {
 extern struct kmem_cache	*xfs_cui_cache;
 extern struct kmem_cache	*xfs_cud_cache;
 
+struct xfs_refcount_intent;
+
+void xfs_refcount_defer_add(struct xfs_trans *tp,
+		struct xfs_refcount_intent *ri);
+
 #endif	/* __XFS_REFCOUNT_ITEM_H__ */

