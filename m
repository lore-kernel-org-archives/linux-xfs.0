Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46AECC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 03:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiEPDdD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 May 2022 23:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239689AbiEPDcv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 May 2022 23:32:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890991FCC6
        for <linux-xfs@vger.kernel.org>; Sun, 15 May 2022 20:32:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40AC4B80E16
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 03:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE30BC385B8;
        Mon, 16 May 2022 03:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652671967;
        bh=SrdftOrKEdTxRBJzR7Ai723Z3YVKb8CTMDMqTQb+xQ4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Edqf1v8ZKnRd+ccBk1zpR/KI/e7nYNeowqsF36qwEAR5m2HhDaYhXXzbh8Vcyvsf8
         2kpyiom4PHm6nm2sWMAMdQ8QZluXxXjSHZOBcJPAS3M6PE55BPXNKx5hEQa9FpaP1e
         g/ZJxnqBNNaenp8F0TNT2WdP1cYleNjtrhVp00Y6w24/LBvq7w/8CsK22dLRTrQUO0
         PUrIDMjvJreb+WQgP/G85CKEsZyDpu7BwyBs2JEMId5Y7S57dS4FlXD0dX4EiGIwfv
         OFvaFOdhGZt5OoszzUCGBcbsFxrvfIgOd9cwVzJvPnuJYeL2MbHoLawjEXUcW1WiL0
         KKaENrVpGF3Sg==
Subject: [PATCH 5/6] xfs: put attr[id] log item cache init with the others
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 15 May 2022 20:32:46 -0700
Message-ID: <165267196653.626272.13274217857897145109.stgit@magnolia>
In-Reply-To: <165267193834.626272.10112290406449975166.stgit@magnolia>
References: <165267193834.626272.10112290406449975166.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Initialize and destroy the xattr log item caches in the same places that
we do all the other log item caches.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c  |   36 ------------------------------------
 fs/xfs/libxfs/xfs_attr.h  |    8 --------
 fs/xfs/libxfs/xfs_defer.c |    8 --------
 fs/xfs/xfs_attr_item.c    |    3 +++
 fs/xfs/xfs_attr_item.h    |    3 +++
 fs/xfs/xfs_super.c        |   19 +++++++++++++++++++
 6 files changed, 25 insertions(+), 52 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 687e1b0c49f9..4056edf9f06e 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -27,8 +27,6 @@
 #include "xfs_attr_item.h"
 #include "xfs_log.h"
 
-struct kmem_cache		*xfs_attri_cache;
-struct kmem_cache		*xfs_attrd_cache;
 struct kmem_cache		*xfs_attr_intent_cache;
 
 /*
@@ -1113,40 +1111,6 @@ xfs_attr_set(
 	goto out_unlock;
 }
 
-int __init
-xfs_attri_init_cache(void)
-{
-	xfs_attri_cache = kmem_cache_create("xfs_attri",
-					    sizeof(struct xfs_attri_log_item),
-					    0, 0, NULL);
-
-	return xfs_attri_cache != NULL ? 0 : -ENOMEM;
-}
-
-void
-xfs_attri_destroy_cache(void)
-{
-	kmem_cache_destroy(xfs_attri_cache);
-	xfs_attri_cache = NULL;
-}
-
-int __init
-xfs_attrd_init_cache(void)
-{
-	xfs_attrd_cache = kmem_cache_create("xfs_attrd",
-					    sizeof(struct xfs_attrd_log_item),
-					    0, 0, NULL);
-
-	return xfs_attrd_cache != NULL ? 0 : -ENOMEM;
-}
-
-void
-xfs_attrd_destroy_cache(void)
-{
-	kmem_cache_destroy(xfs_attrd_cache);
-	xfs_attrd_cache = NULL;
-}
-
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index f0b93515c1e8..22a2f288c1c0 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -558,14 +558,6 @@ int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
 
-extern struct kmem_cache	*xfs_attri_cache;
-extern struct kmem_cache	*xfs_attrd_cache;
-
-int __init xfs_attri_init_cache(void);
-void xfs_attri_destroy_cache(void);
-int __init xfs_attrd_init_cache(void);
-void xfs_attrd_destroy_cache(void);
-
 /*
  * Check to see if the attr should be upgraded from non-existent or shortform to
  * single-leaf-block attribute list.
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index ed65f7e5a9c7..ace229c1d251 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -871,12 +871,6 @@ xfs_defer_init_item_caches(void)
 	if (error)
 		goto err;
 	error = xfs_extfree_intent_init_cache();
-	if (error)
-		goto err;
-	error = xfs_attri_init_cache();
-	if (error)
-		goto err;
-	error = xfs_attrd_init_cache();
 	if (error)
 		goto err;
 	error = xfs_attr_intent_init_cache();
@@ -893,8 +887,6 @@ void
 xfs_defer_destroy_item_caches(void)
 {
 	xfs_attr_intent_destroy_cache();
-	xfs_attri_destroy_cache();
-	xfs_attrd_destroy_cache();
 	xfs_extfree_intent_destroy_cache();
 	xfs_bmap_intent_destroy_cache();
 	xfs_refcount_intent_destroy_cache();
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 89cabd792b7d..1747127434b8 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -29,6 +29,9 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 
+struct kmem_cache		*xfs_attri_cache;
+struct kmem_cache		*xfs_attrd_cache;
+
 static const struct xfs_item_ops xfs_attri_item_ops;
 static const struct xfs_item_ops xfs_attrd_item_ops;
 static struct xfs_attrd_log_item *xfs_trans_get_attrd(struct xfs_trans *tp,
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index c3b779f82adb..cc2fbc9d58a7 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -43,4 +43,7 @@ struct xfs_attrd_log_item {
 	struct xfs_attrd_log_format	attrd_format;
 };
 
+extern struct kmem_cache	*xfs_attri_cache;
+extern struct kmem_cache	*xfs_attrd_cache;
+
 #endif	/* __XFS_ATTR_ITEM_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 93e43e1a2863..51ce127a0cc6 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -38,6 +38,7 @@
 #include "xfs_pwork.h"
 #include "xfs_ag.h"
 #include "xfs_defer.h"
+#include "xfs_attr_item.h"
 
 #include <linux/magic.h>
 #include <linux/fs_context.h>
@@ -2083,8 +2084,24 @@ xfs_init_caches(void)
 	if (!xfs_bui_cache)
 		goto out_destroy_bud_cache;
 
+	xfs_attrd_cache = kmem_cache_create("xfs_attrd_item",
+					    sizeof(struct xfs_attrd_log_item),
+					    0, 0, NULL);
+	if (!xfs_attrd_cache)
+		goto out_destroy_bui_cache;
+
+	xfs_attri_cache = kmem_cache_create("xfs_attri_item",
+					    sizeof(struct xfs_attri_log_item),
+					    0, 0, NULL);
+	if (!xfs_attri_cache)
+		goto out_destroy_attrd_cache;
+
 	return 0;
 
+ out_destroy_attrd_cache:
+	kmem_cache_destroy(xfs_attrd_cache);
+ out_destroy_bui_cache:
+	kmem_cache_destroy(xfs_bui_cache);
  out_destroy_bud_cache:
 	kmem_cache_destroy(xfs_bud_cache);
  out_destroy_cui_cache:
@@ -2131,6 +2148,8 @@ xfs_destroy_caches(void)
 	 * destroy caches.
 	 */
 	rcu_barrier();
+	kmem_cache_destroy(xfs_attri_cache);
+	kmem_cache_destroy(xfs_attrd_cache);
 	kmem_cache_destroy(xfs_bui_cache);
 	kmem_cache_destroy(xfs_bud_cache);
 	kmem_cache_destroy(xfs_cui_cache);

