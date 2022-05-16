Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9871CC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 03:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239671AbiEPDcu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 May 2022 23:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239676AbiEPDcj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 May 2022 23:32:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B7C1FCD1
        for <linux-xfs@vger.kernel.org>; Sun, 15 May 2022 20:32:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D1AEB80E16
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 03:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D90C385AA;
        Mon, 16 May 2022 03:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652671955;
        bh=mOvLm7u1Tf/t9t+Lrg3Ie45jhFPRwleVLLUDRBSflvs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Y3ldNrLz2mglX5YvoGSpnOyP58gWuvUXHiSFxn82X0YynXcvI7MZLEANh8gBMgl1O
         H5eSS7bIPvfdBQxVVtVd0IEoc8vPdhL0D6258RqibQgmgIyeD8u9clFPLSQZccJxXn
         XGLGhbPOsPr13nc9jTZXufU1ymhKue901fSnXosnL6wWoC7tYTRJTvrpIgMjOcEITF
         JoQB0h+RUpdNLGT1FpcHCG2LliewjNQV/UEN+B1T7F8ivOQpZCS1JCMo1ijwAHHOj+
         b/vqUMBkjO4mohghV9dPwwHznE4imvvZ8TVRZpPsqJyvuuKMQqB9bythnFaabcvxRC
         TAzbNRKy5+LBg==
Subject: [PATCH 3/6] xfs: use a separate slab cache for deferred xattr work
 state
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 15 May 2022 20:32:35 -0700
Message-ID: <165267195530.626272.4057756502482755002.stgit@magnolia>
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

Create a separate slab cache for struct xfs_attr_item objects, since we
can pack the (96-byte) intent items more tightly than we can with the
general slab cache objects.  On x86, this means 42 intents per memory
page instead of 32.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c  |   20 +++++++++++++++++++-
 fs/xfs/libxfs/xfs_attr.h  |    4 ++++
 fs/xfs/libxfs/xfs_defer.c |    4 ++++
 fs/xfs/xfs_attr_item.c    |    5 ++++-
 4 files changed, 31 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 0f88f6e17101..687e1b0c49f9 100644
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
index c739caa11a4b..cb3b3d270569 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -634,4 +634,8 @@ xfs_attr_init_replace_state(struct xfs_da_args *args)
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
index 930366055013..89cabd792b7d 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -404,7 +404,10 @@ xfs_attr_free_item(
 {
 	if (attr->xattri_da_state)
 		xfs_da_state_free(attr->xattri_da_state);
-	kmem_free(attr);
+	if (attr->xattri_da_args->op_flags & XFS_DA_OP_RECOVERY)
+		kmem_free(attr);
+	else
+		kmem_cache_free(xfs_attr_intent_cache, attr);
 }
 
 /* Process an attr. */

