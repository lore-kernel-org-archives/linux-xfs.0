Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E65C6C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 18:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241722AbiERS4Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 14:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241761AbiERS4E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 14:56:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401F265D29
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 11:56:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F5EA6189A
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9576EC385A9;
        Wed, 18 May 2022 18:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900161;
        bh=dSDxTSuzoGDaY7JN9Tk5a80Xg/+4jxwDUrs+RAl9/Xk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LtIYgFw6bZcRPII6vvz1DC23of50OlyVdzX37NdDXoMqXS5kQp7LNYd38X/YdEtVL
         PGEQDX/af3lYZseJSRV/uZkvgMxzBhv6UGVWX1HoqnI7xHvKL2aHp6Nub7FAW6O0Ls
         gmi7UWDmixmiaTtM3e/rXWT+Y9kaWVha0uCul3nUfplKNXTZVtXykdFHR21SRAUb7g
         PiDd1L2+NwSOvNL3ocYJjVfQldfuguSr7JHRa0y2+ooI3PCfpbj1ZwQDizhUHvQ13x
         PVHyvdBE4DH74b+0+etM9fyrhjpYUDgflOIMjGChH3M+np9t1Np8tLFKQ72Gy9BYzh
         4USuU3XVUDqPw==
Subject: [PATCH 3/7] xfs: use a separate slab cache for deferred xattr work
 state
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Wed, 18 May 2022 11:56:01 -0700
Message-ID: <165290016116.1647637.7261522980413646490.stgit@magnolia>
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

Create a separate slab cache for struct xfs_attr_item objects, since we
can pack the (104-byte) intent items more tightly than we can with the
general slab cache objects.  On x86, this means 39 intents per memory
page instead of 32.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c  |   20 +++++++++++++++++++-
 fs/xfs/libxfs/xfs_attr.h  |    4 ++++
 fs/xfs/libxfs/xfs_defer.c |    4 ++++
 fs/xfs/xfs_attr_item.c    |    5 ++++-
 4 files changed, 31 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 56e56df9f9f0..350b7a997321 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -29,6 +29,7 @@
 
 struct kmem_cache		*xfs_attri_cache;
 struct kmem_cache		*xfs_attrd_cache;
+struct kmem_cache		*xfs_attr_intent_cache;
 
 /*
  * xfs_attr.c
@@ -902,7 +903,7 @@ xfs_attr_item_init(
 
 	struct xfs_attr_item	*new;
 
-	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
+	new = kmem_cache_zalloc(xfs_attr_intent_cache, GFP_NOFS | __GFP_NOFAIL);
 	new->xattri_op_flags = op_flags;
 	new->xattri_da_args = args;
 
@@ -1650,3 +1651,20 @@ xfs_attr_namecheck(
 	/* There shouldn't be any nulls here */
 	return !memchr(name, 0, length);
 }
+
+int __init
+xfs_attr_intent_init_cache(void)
+{
+	xfs_attr_intent_cache = kmem_cache_create("xfs_attr_item",
+			sizeof(struct xfs_attr_item),
+			0, 0, NULL);
+
+	return xfs_attr_intent_cache != NULL ? 0 : -ENOMEM;
+}
+
+void
+xfs_attr_intent_destroy_cache(void)
+{
+	kmem_cache_destroy(xfs_attr_intent_cache);
+	xfs_attr_intent_cache = NULL;
+}
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index ccb4f45f474a..0a3b010eb797 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -642,4 +642,8 @@ xfs_attr_init_replace_state(struct xfs_da_args *args)
 	return xfs_attr_init_add_state(args);
 }
 
+extern struct kmem_cache *xfs_attr_intent_cache;
+int __init xfs_attr_intent_init_cache(void);
+void xfs_attr_intent_destroy_cache(void);
+
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index ceb222b4f261..ed65f7e5a9c7 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -877,6 +877,9 @@ xfs_defer_init_item_caches(void)
 	if (error)
 		goto err;
 	error = xfs_attrd_init_cache();
+	if (error)
+		goto err;
+	error = xfs_attr_intent_init_cache();
 	if (error)
 		goto err;
 	return 0;
@@ -889,6 +892,7 @@ xfs_defer_init_item_caches(void)
 void
 xfs_defer_destroy_item_caches(void)
 {
+	xfs_attr_intent_destroy_cache();
 	xfs_attri_destroy_cache();
 	xfs_attrd_destroy_cache();
 	xfs_extfree_intent_destroy_cache();
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 27b6bdc8a3aa..07f1208cf18c 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -473,7 +473,10 @@ xfs_attr_free_item(
 		xfs_da_state_free(attr->xattri_da_state);
 	if (attr->xattri_nameval)
 		xfs_attri_log_nameval_put(attr->xattri_nameval);
-	kmem_free(attr);
+	if (attr->xattri_da_args->op_flags & XFS_DA_OP_RECOVERY)
+		kmem_free(attr);
+	else
+		kmem_cache_free(xfs_attr_intent_cache, attr);
 }
 
 /* Process an attr. */

