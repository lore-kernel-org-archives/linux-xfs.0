Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5093C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 23:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236479AbiGRX7f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 19:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236564AbiGRX7S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 19:59:18 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5CEAC1209D
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 16:58:54 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C057410EA8E8
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 09:58:52 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oDadX-002YfM-3S
        for linux-xfs@vger.kernel.org; Tue, 19 Jul 2022 09:58:51 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1oDadX-0088u2-2V
        for linux-xfs@vger.kernel.org;
        Tue, 19 Jul 2022 09:58:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: xfs_buf cache destroy isn't RCU safe
Date:   Tue, 19 Jul 2022 09:58:51 +1000
Message-Id: <20220718235851.1940837-1-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62d5f3bc
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=RgO8CyIxsXoA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8
        a=hqNnIgPMQvjjshHo5EoA:9 a=+jEqtf1s3R9VXZ0wqowq2kgwd+I=:19
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Darrick and Sachin Sant reported that xfs/435 and xfs/436 would
report an non-empty xfs_buf slab on module remove. This isn't easily
to reproduce, but is clearly a side effect of converting the buffer
caceh to RUC freeing and lockless lookups. Sachin bisected and
Darrick hit it when testing the patchset directly.

Turns out that the xfs_buf slab is not destroyed when all the other
XFS slab caches are destroyed. Instead, it's got it's own little
wrapper function that gets called separately, and so it doesn't have
an rcu_barrier() call in it that is needed to drain all the rcu
callbacks before the slab is destroyed.

Fix it by removing the xfs_buf_init/terminate wrappers that just
allocate and destroy the xfs_buf slab, and move them to the same
place that all the other slab caches are set up and destroyed.

Reported-and-tested-by: Sachin Sant <sachinp@linux.ibm.com>
Fixes: 298f34224506 ("xfs: lockless buffer lookup")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c   | 25 +------------------------
 fs/xfs/xfs_buf.h   |  6 ++----
 fs/xfs/xfs_super.c | 22 +++++++++++++---------
 3 files changed, 16 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ccc09dc27e46..8878b0069854 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -21,7 +21,7 @@
 #include "xfs_error.h"
 #include "xfs_ag.h"
 
-static struct kmem_cache *xfs_buf_cache;
+struct kmem_cache *xfs_buf_cache;
 
 /*
  * Locking orders
@@ -2302,29 +2302,6 @@ xfs_buf_delwri_pushbuf(
 	return error;
 }
 
-int __init
-xfs_buf_init(void)
-{
-	xfs_buf_cache = kmem_cache_create("xfs_buf", sizeof(struct xfs_buf), 0,
-					 SLAB_HWCACHE_ALIGN |
-					 SLAB_RECLAIM_ACCOUNT |
-					 SLAB_MEM_SPREAD,
-					 NULL);
-	if (!xfs_buf_cache)
-		goto out;
-
-	return 0;
-
- out:
-	return -ENOMEM;
-}
-
-void
-xfs_buf_terminate(void)
-{
-	kmem_cache_destroy(xfs_buf_cache);
-}
-
 void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
 {
 	/*
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index d5a9c5ce763d..a561f6ee4c1d 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -15,6 +15,8 @@
 #include <linux/uio.h>
 #include <linux/list_lru.h>
 
+extern struct kmem_cache *xfs_buf_cache;
+
 /*
  *	Base types
  */
@@ -306,10 +308,6 @@ extern int xfs_buf_delwri_submit(struct list_head *);
 extern int xfs_buf_delwri_submit_nowait(struct list_head *);
 extern int xfs_buf_delwri_pushbuf(struct xfs_buf *, struct list_head *);
 
-/* Buffer Daemon Setup Routines */
-extern int xfs_buf_init(void);
-extern void xfs_buf_terminate(void);
-
 static inline xfs_daddr_t xfs_buf_daddr(struct xfs_buf *bp)
 {
 	return bp->b_maps[0].bm_bn;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4edee1d3784a..3d27ba1295c9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1967,11 +1967,19 @@ xfs_init_caches(void)
 {
 	int		error;
 
+	xfs_buf_cache = kmem_cache_create("xfs_buf", sizeof(struct xfs_buf), 0,
+					 SLAB_HWCACHE_ALIGN |
+					 SLAB_RECLAIM_ACCOUNT |
+					 SLAB_MEM_SPREAD,
+					 NULL);
+	if (!xfs_buf_cache)
+		goto out;
+
 	xfs_log_ticket_cache = kmem_cache_create("xfs_log_ticket",
 						sizeof(struct xlog_ticket),
 						0, 0, NULL);
 	if (!xfs_log_ticket_cache)
-		goto out;
+		goto out_destroy_buf_cache;
 
 	error = xfs_btree_init_cur_caches();
 	if (error)
@@ -2145,6 +2153,8 @@ xfs_init_caches(void)
 	xfs_btree_destroy_cur_caches();
  out_destroy_log_ticket_cache:
 	kmem_cache_destroy(xfs_log_ticket_cache);
+ out_destroy_buf_cache:
+	kmem_cache_destroy(xfs_buf_cache);
  out:
 	return -ENOMEM;
 }
@@ -2178,6 +2188,7 @@ xfs_destroy_caches(void)
 	xfs_defer_destroy_item_caches();
 	xfs_btree_destroy_cur_caches();
 	kmem_cache_destroy(xfs_log_ticket_cache);
+	kmem_cache_destroy(xfs_buf_cache);
 }
 
 STATIC int __init
@@ -2283,13 +2294,9 @@ init_xfs_fs(void)
 	if (error)
 		goto out_destroy_wq;
 
-	error = xfs_buf_init();
-	if (error)
-		goto out_mru_cache_uninit;
-
 	error = xfs_init_procfs();
 	if (error)
-		goto out_buf_terminate;
+		goto out_mru_cache_uninit;
 
 	error = xfs_sysctl_register();
 	if (error)
@@ -2346,8 +2353,6 @@ init_xfs_fs(void)
 	xfs_sysctl_unregister();
  out_cleanup_procfs:
 	xfs_cleanup_procfs();
- out_buf_terminate:
-	xfs_buf_terminate();
  out_mru_cache_uninit:
 	xfs_mru_cache_uninit();
  out_destroy_wq:
@@ -2373,7 +2378,6 @@ exit_xfs_fs(void)
 	kset_unregister(xfs_kset);
 	xfs_sysctl_unregister();
 	xfs_cleanup_procfs();
-	xfs_buf_terminate();
 	xfs_mru_cache_uninit();
 	xfs_destroy_workqueues();
 	xfs_destroy_caches();
-- 
2.36.1

