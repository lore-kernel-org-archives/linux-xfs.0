Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 720E2C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344835AbiATARz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:17:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45658 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344962AbiATARw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:17:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0EC7B81AD5
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D955C004E1;
        Thu, 20 Jan 2022 00:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637870;
        bh=TC0+bI10sRzI7q/WJAxRZEUzqUbRPCLWai4qeq1S6gE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WqOfx+LI5QtAjjAQJBDymnzQlqWKlL7EZtpysrAxhFqV6hiQ659g7Yhne6lYZUQo1
         boAVj0gmFArocKLpR09uBWdGke+fZu6WFHe+g3JFeVYGE8gZ3EFOaYx8pPab56/nkZ
         LCuORO32EyrXZLqdVW4IUaaEtz6nAcTQ3ud79C9UiiO8tit0qujKa+AKyzpj6LFFci
         p35b/xbzQu1kk0pbuCXrcndBl/6988XMAaeQx3TGKszXzoTojo2d/IFEUzHa+9YInM
         I5GAIM5CyHaatEn1CEz0CRKt21bNx0FK5rN3DKz1WeMuj9umholt/LfBU2B5A63O5u
         dicyOj4GJz3Sw==
Subject: [PATCH 05/45] xfs: replace kmem_alloc_large() with kvmalloc()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:17:50 -0800
Message-ID: <164263787023.860211.1423482778506639589.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: d634525db63e9e946c3229fb93c8d9b763afbaf3

There is no reason for this wrapper existing anymore. All the places
that use KM_NOFS allocation are within transaction contexts and
hence covered by memalloc_nofs_save/restore contexts. Hence we don't
need any special handling of vmalloc for large IOs anymore and
so special casing this code isn't necessary.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/kmem.h         |    3 ++-
 libxfs/kmem.c          |    6 ++++--
 libxfs/xfs_attr_leaf.c |    2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)


diff --git a/include/kmem.h b/include/kmem.h
index 383284ea..6d317256 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -22,6 +22,7 @@ typedef unsigned int __bitwise gfp_t;
 #define GFP_KERNEL	((__force gfp_t)0)
 #define GFP_NOFS	((__force gfp_t)0)
 #define __GFP_NOFAIL	((__force gfp_t)0)
+#define __GFP_NOLOCKDEP	((__force gfp_t)0)
 
 #define __GFP_ZERO	(__force gfp_t)1
 
@@ -38,7 +39,7 @@ kmem_cache_free(kmem_zone_t *zone, void *ptr)
 }
 
 extern void	*kmem_alloc(size_t, int);
-extern void	*kmem_alloc_large(size_t, int);
+extern void	*kvmalloc(size_t, gfp_t);
 extern void	*kmem_zalloc(size_t, int);
 
 static inline void
diff --git a/libxfs/kmem.c b/libxfs/kmem.c
index ee50ab66..3d72ac94 100644
--- a/libxfs/kmem.c
+++ b/libxfs/kmem.c
@@ -76,9 +76,11 @@ kmem_alloc(size_t size, int flags)
 }
 
 void *
-kmem_alloc_large(size_t size, int flags)
+kvmalloc(size_t size, gfp_t flags)
 {
-	return kmem_alloc(size, flags);
+	if (flags & __GFP_ZERO)
+		return kmem_zalloc(size, 0);
+	return kmem_alloc(size, 0);
 }
 
 void *
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index cfb6bf17..6499f16f 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -486,7 +486,7 @@ xfs_attr_copy_value(
 	}
 
 	if (!args->value) {
-		args->value = kmem_alloc_large(valuelen, KM_NOLOCKDEP);
+		args->value = kvmalloc(valuelen, GFP_KERNEL | __GFP_NOLOCKDEP);
 		if (!args->value)
 			return -ENOMEM;
 	}

