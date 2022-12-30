Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94858C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236183AbiLaCOQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236179AbiLaCOP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:14:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43891C906
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:14:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70C0F61D1B
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AD7C433D2;
        Sat, 31 Dec 2022 02:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452853;
        bh=5FEkEqIKza8Qo414UjcTTWfHZ4v7U8rOtbKJ70U46+s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rfgytvyKh1OOhVfZhS4yxDNw7It1uFm1VtQSSY3mEjVRAQUxLX1bTqgkFMiMdep0m
         N16s/vLius6qHGrTErMB8boz2KxLkavHi46dJvJUv46dHIqnDSdQlQrWzWIye8qvEW
         XKmFMYvuSfkCbzLv1/OChh3+vy8R2PQl4u7WBpw6IhrlKcbItQt2sfuvw7Vh/mMAiz
         5+fpfWrS/mdAUCdhe5VXtosVAZG390re55nwESI13LiSYljjX6zp959SQJbpoNjQ3s
         HYqtafCckQgw/taB456zADs43nUSiJ3CRY1KWTrSNU2qswyNSEBY2Z7na/3905gchp
         Hy40GFh2J12Rw==
Subject: [PATCH 17/46] xfs: enable creation of dynamically allocated metadir
 path structures
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:21 -0800
Message-ID: <167243876160.725900.17006857893622277734.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a few helper functions so that it's possible to allocate
xfs_imeta_path objects dynamically, along with dynamically allocated
path components.  Eventually we're going to want to support paths of the
form "/realtime/$rtgroup.rmap", and this is necessary for that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/kmem.h     |    4 +++-
 libxfs/xfs_imeta.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_imeta.h |    8 ++++++++
 3 files changed, 54 insertions(+), 1 deletion(-)


diff --git a/include/kmem.h b/include/kmem.h
index 8ae919c7066..014983173a2 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -26,7 +26,7 @@ typedef unsigned int __bitwise gfp_t;
 #define __GFP_NOFAIL	((__force gfp_t)0)
 #define __GFP_NOLOCKDEP	((__force gfp_t)0)
 
-#define __GFP_ZERO	(__force gfp_t)1
+#define __GFP_ZERO	((__force gfp_t)1)
 
 struct kmem_cache * kmem_cache_create(const char *name, unsigned int size,
 		unsigned int align, unsigned int slab_flags,
@@ -65,6 +65,8 @@ static inline void *kmalloc(size_t size, gfp_t flags)
 	return kvmalloc(size, flags);
 }
 
+#define kvcalloc(nr, size, gfp) kvmalloc((nr) * (size), (gfp) | __GFP_ZERO)
+
 static inline void kfree(const void *ptr)
 {
 	return kmem_free(ptr);
diff --git a/libxfs/xfs_imeta.c b/libxfs/xfs_imeta.c
index 1502d4eb2e3..eaf63275c08 100644
--- a/libxfs/xfs_imeta.c
+++ b/libxfs/xfs_imeta.c
@@ -1148,3 +1148,46 @@ xfs_imeta_lookup_update(
 
 	return error;
 }
+
+/* Create a path to a file within the metadata directory tree. */
+int
+xfs_imeta_create_file_path(
+	struct xfs_mount	*mp,
+	unsigned int		nr_components,
+	struct xfs_imeta_path	**pathp)
+{
+	struct xfs_imeta_path	*p;
+	char			**components;
+
+	p = kmalloc(sizeof(struct xfs_imeta_path), GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	components = kvcalloc(nr_components, sizeof(char *), GFP_KERNEL);
+	if (!components) {
+		kfree(p);
+		return -ENOMEM;
+	}
+
+	p->im_depth = nr_components;
+	p->im_path = (const char **)components;
+	p->im_ftype = XFS_DIR3_FT_REG_FILE;
+	p->im_dynamicmask = 0;
+	*pathp = p;
+	return 0;
+}
+
+/* Free a metadata directory tree path. */
+void
+xfs_imeta_free_path(
+	struct xfs_imeta_path	*path)
+{
+	unsigned int		i;
+
+	for (i = 0; i < path->im_depth; i++) {
+		if ((path->im_dynamicmask & (1ULL << i)) && path->im_path[i])
+			kfree(path->im_path[i]);
+	}
+	kfree(path->im_path);
+	kfree(path);
+}
diff --git a/libxfs/xfs_imeta.h b/libxfs/xfs_imeta.h
index 741f426c6a4..7840087b71d 100644
--- a/libxfs/xfs_imeta.h
+++ b/libxfs/xfs_imeta.h
@@ -15,6 +15,7 @@ const struct xfs_imeta_path name = { \
 	.im_path = (path), \
 	.im_ftype = XFS_DIR3_FT_REG_FILE, \
 	.im_depth = ARRAY_SIZE(path), \
+	.im_dynamicmask = 0, \
 }
 
 /* Key for looking up metadata inodes. */
@@ -27,6 +28,9 @@ struct xfs_imeta_path {
 
 	/* Expected file type. */
 	unsigned int	im_ftype;
+
+	/* Each bit corresponds to an element of im_path needing to be freed */
+	unsigned long long im_dynamicmask;
 };
 
 /* Cleanup widget for metadata inode creation and deletion. */
@@ -52,6 +56,10 @@ int xfs_imeta_lookup_update(struct xfs_mount *mp,
 			    const struct xfs_imeta_path *path,
 			    struct xfs_imeta_update *upd, xfs_ino_t *inop);
 
+int xfs_imeta_create_file_path(struct xfs_mount *mp,
+		unsigned int nr_components, struct xfs_imeta_path **pathp);
+void xfs_imeta_free_path(struct xfs_imeta_path *path);
+
 void xfs_imeta_set_metaflag(struct xfs_trans *tp, struct xfs_inode *ip);
 
 /* Don't allocate quota for this file. */

