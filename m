Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7273C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357764AbiATA1H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiATA1G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:27:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D591C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:27:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 276CDB81A7C
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0503C004E1;
        Thu, 20 Jan 2022 00:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638424;
        bh=2972u8eyUJ4MrGJSzD8vf0lrWsXF4QGj4gwB/vtwo60=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WpVHtGTUmUrBKBqGcbLnI0Z/x09jNT0rb/gYu4NR/BcZGZMyamfzS+IbBAq8RzE0W
         G+EJ+z9onG1HizG/yfeW29FiJNSvQz8kuz1HZmgLSOCvLtPZJ8Fz7fv1ND9uC5hcyV
         pA2x0H6ItEgS8rWo+DqzousKulIVENM81Y+9xbQzJ8yRF1oNXyXXfYPoLbBraTSSBL
         UkGRE269oF9tDKgr+ppJaeyIxp9gjnqVNtvc4vRHJXzuZLoGPoN6/1QHoMsFspRre7
         88ssx7NYLVB5EtQV17JHlMY4FejVAfB/GOizkDRQmddzrqH/W7bQmStMqIf49wMtMe
         qJpHKaiWvkvJA==
Subject: [PATCH 42/48] xfs: create slab caches for frequently-used deferred
 items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:27:03 -0800
Message-ID: <164263842354.865554.17714418783812332419.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: f3c799c22c661e181c71a0d9914fc923023f65fb

Create slab caches for the high-level structures that coordinate
deferred intent items, since they're used fairly heavily.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c   |   18 +++++++-------
 libxfs/init.c         |    7 +++++
 libxfs/xfs_bmap.c     |   21 ++++++++++++++--
 libxfs/xfs_bmap.h     |    5 ++++
 libxfs/xfs_defer.c    |   65 ++++++++++++++++++++++++++++++++++++++++++++++---
 libxfs/xfs_defer.h    |    3 ++
 libxfs/xfs_refcount.c |   23 ++++++++++++++++-
 libxfs/xfs_refcount.h |    5 ++++
 libxfs/xfs_rmap.c     |   21 +++++++++++++++-
 libxfs/xfs_rmap.h     |    5 ++++
 10 files changed, 155 insertions(+), 18 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index b18182e9..1277469f 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -82,7 +82,7 @@ xfs_extent_free_finish_item(
 	error = xfs_free_extent(tp, free->xefi_startblock,
 			free->xefi_blockcount, &free->xefi_oinfo,
 			XFS_AG_RESV_NONE);
-	kmem_free(free);
+	kmem_cache_free(xfs_bmap_free_item_cache, free);
 	return error;
 }
 
@@ -101,7 +101,7 @@ xfs_extent_free_cancel_item(
 	struct xfs_extent_free_item	*free;
 
 	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	kmem_free(free);
+	kmem_cache_free(xfs_bmap_free_item_cache, free);
 }
 
 const struct xfs_defer_op_type xfs_extent_free_defer_type = {
@@ -139,7 +139,7 @@ xfs_agfl_free_finish_item(
 	if (!error)
 		error = xfs_free_agfl_block(tp, agno, agbno, agbp,
 					    &free->xefi_oinfo);
-	kmem_free(free);
+	kmem_cache_free(xfs_bmap_free_item_cache, free);
 	return error;
 }
 
@@ -216,7 +216,7 @@ xfs_rmap_update_finish_item(
 			rmap->ri_bmap.br_blockcount,
 			rmap->ri_bmap.br_state,
 			state);
-	kmem_free(rmap);
+	kmem_cache_free(xfs_rmap_intent_cache, rmap);
 	return error;
 }
 
@@ -235,7 +235,7 @@ xfs_rmap_update_cancel_item(
 	struct xfs_rmap_intent		*rmap;
 
 	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
-	kmem_free(rmap);
+	kmem_cache_free(xfs_rmap_intent_cache, rmap);
 }
 
 const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
@@ -319,7 +319,7 @@ xfs_refcount_update_finish_item(
 		refc->ri_blockcount = new_aglen;
 		return -EAGAIN;
 	}
-	kmem_free(refc);
+	kmem_cache_free(xfs_refcount_intent_cache, refc);
 	return error;
 }
 
@@ -338,7 +338,7 @@ xfs_refcount_update_cancel_item(
 	struct xfs_refcount_intent	*refc;
 
 	refc = container_of(item, struct xfs_refcount_intent, ri_list);
-	kmem_free(refc);
+	kmem_cache_free(xfs_refcount_intent_cache, refc);
 }
 
 const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
@@ -418,7 +418,7 @@ xfs_bmap_update_finish_item(
 		bmap->bi_bmap.br_blockcount = count;
 		return -EAGAIN;
 	}
-	kmem_free(bmap);
+	kmem_cache_free(xfs_bmap_intent_cache, bmap);
 	return error;
 }
 
@@ -437,7 +437,7 @@ xfs_bmap_update_cancel_item(
 	struct xfs_bmap_intent		*bmap;
 
 	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
-	kmem_free(bmap);
+	kmem_cache_free(xfs_bmap_intent_cache, bmap);
 }
 
 const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
diff --git a/libxfs/init.c b/libxfs/init.c
index b0be28e3..f6863f4c 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -253,6 +253,12 @@ init_caches(void)
 		abort();
 	}
 
+	error = xfs_defer_init_item_caches();
+	if (error) {
+		fprintf(stderr, "Could not allocate defer work item caches.\n");
+		abort();
+	}
+
 	xfs_bmap_free_item_cache = kmem_cache_create("xfs_bmap_free_item",
 			sizeof(struct xfs_extent_free_item), 0, 0, NULL);
 	xfs_trans_cache = kmem_cache_create("xfs_trans",
@@ -268,6 +274,7 @@ destroy_kmem_caches(void)
 	kmem_cache_destroy(xfs_ifork_cache);
 	kmem_cache_destroy(xfs_buf_item_cache);
 	kmem_cache_destroy(xfs_da_state_cache);
+	xfs_defer_destroy_item_caches();
 	xfs_btree_destroy_cur_caches();
 	kmem_cache_destroy(xfs_bmap_free_item_cache);
 	kmem_cache_destroy(xfs_trans_cache);
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 0514d6e5..c261d119 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -30,7 +30,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_refcount.h"
 
-
+struct kmem_cache		*xfs_bmap_intent_cache;
 struct kmem_cache		*xfs_bmap_free_item_cache;
 
 /*
@@ -6183,7 +6183,7 @@ __xfs_bmap_add(
 			bmap->br_blockcount,
 			bmap->br_state);
 
-	bi = kmem_alloc(sizeof(struct xfs_bmap_intent), KM_NOFS);
+	bi = kmem_cache_alloc(xfs_bmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&bi->bi_list);
 	bi->bi_type = type;
 	bi->bi_owner = ip;
@@ -6294,3 +6294,20 @@ xfs_bmap_validate_extent(
 		return __this_address;
 	return NULL;
 }
+
+int __init
+xfs_bmap_intent_init_cache(void)
+{
+	xfs_bmap_intent_cache = kmem_cache_create("xfs_bmap_intent",
+			sizeof(struct xfs_bmap_intent),
+			0, 0, NULL);
+
+	return xfs_bmap_intent_cache != NULL ? 0 : -ENOMEM;
+}
+
+void
+xfs_bmap_intent_destroy_cache(void)
+{
+	kmem_cache_destroy(xfs_bmap_intent_cache);
+	xfs_bmap_intent_cache = NULL;
+}
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index db01fe83..fa73a568 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -290,4 +290,9 @@ int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, xfs_fsblock_t startblock,
 		int flags);
 
+extern struct kmem_cache	*xfs_bmap_intent_cache;
+
+int __init xfs_bmap_intent_init_cache(void);
+void xfs_bmap_intent_destroy_cache(void);
+
 #endif	/* __XFS_BMAP_H__ */
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 40d49abc..f71bb055 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -14,6 +14,11 @@
 #include "xfs_trans.h"
 #include "xfs_inode.h"
 #include "xfs_trace.h"
+#include "xfs_rmap.h"
+#include "xfs_refcount.h"
+#include "xfs_bmap.h"
+
+static struct kmem_cache	*xfs_defer_pending_cache;
 
 /*
  * Deferred Operations in XFS
@@ -361,7 +366,7 @@ xfs_defer_cancel_list(
 			ops->cancel_item(pwi);
 		}
 		ASSERT(dfp->dfp_count == 0);
-		kmem_free(dfp);
+		kmem_cache_free(xfs_defer_pending_cache, dfp);
 	}
 }
 
@@ -458,7 +463,7 @@ xfs_defer_finish_one(
 
 	/* Done with the dfp, free it. */
 	list_del(&dfp->dfp_list);
-	kmem_free(dfp);
+	kmem_cache_free(xfs_defer_pending_cache, dfp);
 out:
 	if (ops->finish_cleanup)
 		ops->finish_cleanup(tp, state, error);
@@ -592,8 +597,8 @@ xfs_defer_add(
 			dfp = NULL;
 	}
 	if (!dfp) {
-		dfp = kmem_alloc(sizeof(struct xfs_defer_pending),
-				KM_NOFS);
+		dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
+				GFP_NOFS | __GFP_NOFAIL);
 		dfp->dfp_type = type;
 		dfp->dfp_intent = NULL;
 		dfp->dfp_done = NULL;
@@ -805,3 +810,55 @@ xfs_defer_resources_rele(
 	dres->dr_bufs = 0;
 	dres->dr_ordered = 0;
 }
+
+static inline int __init
+xfs_defer_init_cache(void)
+{
+	xfs_defer_pending_cache = kmem_cache_create("xfs_defer_pending",
+			sizeof(struct xfs_defer_pending),
+			0, 0, NULL);
+
+	return xfs_defer_pending_cache != NULL ? 0 : -ENOMEM;
+}
+
+static inline void
+xfs_defer_destroy_cache(void)
+{
+	kmem_cache_destroy(xfs_defer_pending_cache);
+	xfs_defer_pending_cache = NULL;
+}
+
+/* Set up caches for deferred work items. */
+int __init
+xfs_defer_init_item_caches(void)
+{
+	int				error;
+
+	error = xfs_defer_init_cache();
+	if (error)
+		return error;
+	error = xfs_rmap_intent_init_cache();
+	if (error)
+		goto err;
+	error = xfs_refcount_intent_init_cache();
+	if (error)
+		goto err;
+	error = xfs_bmap_intent_init_cache();
+	if (error)
+		goto err;
+
+	return 0;
+err:
+	xfs_defer_destroy_item_caches();
+	return error;
+}
+
+/* Destroy all the deferred work item caches, if they've been allocated. */
+void
+xfs_defer_destroy_item_caches(void)
+{
+	xfs_bmap_intent_destroy_cache();
+	xfs_refcount_intent_destroy_cache();
+	xfs_rmap_intent_destroy_cache();
+	xfs_defer_destroy_cache();
+}
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 7952695c..7bb8a31a 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -122,4 +122,7 @@ void xfs_defer_ops_capture_free(struct xfs_mount *mp,
 		struct xfs_defer_capture *d);
 void xfs_defer_resources_rele(struct xfs_defer_resources *dres);
 
+int __init xfs_defer_init_item_caches(void);
+void xfs_defer_destroy_item_caches(void);
+
 #endif /* __XFS_DEFER_H__ */
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 2aa64d3e..da3cd7d5 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -23,6 +23,8 @@
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 
+struct kmem_cache	*xfs_refcount_intent_cache;
+
 /* Allowable refcount adjustment amounts. */
 enum xfs_refc_adjust_op {
 	XFS_REFCOUNT_ADJUST_INCREASE	= 1,
@@ -1234,8 +1236,8 @@ __xfs_refcount_add(
 			type, XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
 			blockcount);
 
-	ri = kmem_alloc(sizeof(struct xfs_refcount_intent),
-			KM_NOFS);
+	ri = kmem_cache_alloc(xfs_refcount_intent_cache,
+			GFP_NOFS | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&ri->ri_list);
 	ri->ri_type = type;
 	ri->ri_startblock = startblock;
@@ -1781,3 +1783,20 @@ xfs_refcount_has_record(
 
 	return xfs_btree_has_record(cur, &low, &high, exists);
 }
+
+int __init
+xfs_refcount_intent_init_cache(void)
+{
+	xfs_refcount_intent_cache = kmem_cache_create("xfs_refc_intent",
+			sizeof(struct xfs_refcount_intent),
+			0, 0, NULL);
+
+	return xfs_refcount_intent_cache != NULL ? 0 : -ENOMEM;
+}
+
+void
+xfs_refcount_intent_destroy_cache(void)
+{
+	kmem_cache_destroy(xfs_refcount_intent_cache);
+	xfs_refcount_intent_cache = NULL;
+}
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 89404596..9eb01edb 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -83,4 +83,9 @@ extern void xfs_refcount_btrec_to_irec(const union xfs_btree_rec *rec,
 extern int xfs_refcount_insert(struct xfs_btree_cur *cur,
 		struct xfs_refcount_irec *irec, int *stat);
 
+extern struct kmem_cache	*xfs_refcount_intent_cache;
+
+int __init xfs_refcount_intent_init_cache(void);
+void xfs_refcount_intent_destroy_cache(void);
+
 #endif	/* __XFS_REFCOUNT_H__ */
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index e93010ff..d6601a65 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -23,6 +23,8 @@
 #include "xfs_inode.h"
 #include "xfs_ag.h"
 
+struct kmem_cache	*xfs_rmap_intent_cache;
+
 /*
  * Lookup the first record less than or equal to [bno, len, owner, offset]
  * in the btree given by cur.
@@ -2484,7 +2486,7 @@ __xfs_rmap_add(
 			bmap->br_blockcount,
 			bmap->br_state);
 
-	ri = kmem_alloc(sizeof(struct xfs_rmap_intent), KM_NOFS);
+	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&ri->ri_list);
 	ri->ri_type = type;
 	ri->ri_owner = owner;
@@ -2778,3 +2780,20 @@ const struct xfs_owner_info XFS_RMAP_OINFO_REFC = {
 const struct xfs_owner_info XFS_RMAP_OINFO_COW = {
 	.oi_owner = XFS_RMAP_OWN_COW,
 };
+
+int __init
+xfs_rmap_intent_init_cache(void)
+{
+	xfs_rmap_intent_cache = kmem_cache_create("xfs_rmap_intent",
+			sizeof(struct xfs_rmap_intent),
+			0, 0, NULL);
+
+	return xfs_rmap_intent_cache != NULL ? 0 : -ENOMEM;
+}
+
+void
+xfs_rmap_intent_destroy_cache(void)
+{
+	kmem_cache_destroy(xfs_rmap_intent_cache);
+	xfs_rmap_intent_cache = NULL;
+}
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 85dd98ac..b718ebed 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -215,4 +215,9 @@ extern const struct xfs_owner_info XFS_RMAP_OINFO_INODES;
 extern const struct xfs_owner_info XFS_RMAP_OINFO_REFC;
 extern const struct xfs_owner_info XFS_RMAP_OINFO_COW;
 
+extern struct kmem_cache	*xfs_rmap_intent_cache;
+
+int __init xfs_rmap_intent_init_cache(void);
+void xfs_rmap_intent_destroy_cache(void);
+
 #endif	/* __XFS_RMAP_H__ */

