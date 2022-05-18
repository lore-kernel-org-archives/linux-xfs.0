Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4027C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 18:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241738AbiERS4R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 14:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241805AbiERS4P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 14:56:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE16915F6EE
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 11:56:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 793A26183D
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFDFC385A9;
        Wed, 18 May 2022 18:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900172;
        bh=KhThWLvpCOtCgjti211la3L3kE8kaHZs5sliKTNQ1v0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kNQ4liG3qeiPjYhD2KOXcAS9JXYSS8R8G+Oj2+JqEmmP06tcw2OUwGv6J3L6Rp7Of
         +2zggg9Ir4PVsz9weR/GG9N7V/13wN26a8h32z1as7ec4JWBFkgz8otyHtglz8GwDe
         ahe7eV+awxXYlyA/+tKCiX7+8KzPUIiO78x/4TMbpOA5najRCVeBtSqwFbTWq2v/Al
         J0CtHAjR97sj/xn899qybQUuKpNzdf7g+1FHoFaSdfTpRe3Ea5azKYwSCNeGV06MOX
         xnHqzeXneOn4n0LI7frpNWclbZLALAzho05spB/z3d0UHFc3buaBykCkm3B1hS8Vtx
         G9uSDF94szaAA==
Subject: [PATCH 5/7] xfs: put attr[id] log item cache init with the others
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Wed, 18 May 2022 11:56:12 -0700
Message-ID: <165290017235.1647637.9369712725209110531.stgit@magnolia>
In-Reply-To: <165290014409.1647637.4876706578208264219.stgit@magnolia>
References: <165290014409.1647637.4876706578208264219.stgit@magnolia>
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
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c  |   36 ------------------------------------
 fs/xfs/libxfs/xfs_attr.h  |    8 --------
 fs/xfs/libxfs/xfs_defer.c |    8 --------
 fs/xfs/xfs_attr_item.c    |    3 +++
 fs/xfs/xfs_attr_item.h    |    3 +++
 fs/xfs/xfs_super.c        |   19 +++++++++++++++++++
 6 files changed, 25 insertions(+), 52 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 350b7a997321..162fbac78524 100644
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
index 8053415666fa..e271462c4f04 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -566,14 +566,6 @@ int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
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
index 07f1208cf18c..4b7919ff0fc6 100644
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
index 2475e68712e1..5141dc809d65 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -48,4 +48,7 @@ struct xfs_attrd_log_item {
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

