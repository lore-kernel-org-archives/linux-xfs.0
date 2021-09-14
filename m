Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E466C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74DD1610F9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:40:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236953AbhINClj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236074AbhINCli (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:41:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 261AB610D1;
        Tue, 14 Sep 2021 02:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587222;
        bh=TC0+bI10sRzI7q/WJAxRZEUzqUbRPCLWai4qeq1S6gE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DOAC6rgEuwtDLbyHiGUIc5daUv8JdZThwBLBIxDS+Q3VpNs7J0efUdUzrGuSst4IV
         XQfUc0Ldcntb42jVc678SX8xtxnUlZLbdSPSoOUmzfMbQ9eDm/yfWU7YJG1sbc8sa+
         9/LWGNiIlBVxlLmK3C2U8gcuwW0NZgMWWvIJAsM5NC0CEojZhqsiF2F15NQye5kOiB
         ySvIXkdRmeAiAeElJZATmsk/654U43E5dtjsfBiqtEqWiTx7yXDK7NGbv4QmORDgsF
         uMxpUm+o8Vgel0sZe2+iFEjrcCyixjXHwodjRBfuf/JC7aIj/tlSurqX6iO3urLC/p
         FdftM9xV9vkmA==
Subject: [PATCH 04/43] xfs: replace kmem_alloc_large() with kvmalloc()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:40:21 -0700
Message-ID: <163158722190.1604118.5769611604065307959.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
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

