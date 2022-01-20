Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED21C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345472AbiATA0c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiATA0b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:26:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75A4C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:26:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 541FB6150C
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76E3C004E1;
        Thu, 20 Jan 2022 00:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638390;
        bh=mQcLPvAhosN3AyQdUhe6J7tSnWO7rd7AvTMlyQvfEb0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LLmnZjX/IS21ta46PoGQwS4FnQXvL4nwd6gKZmWkWarwMoe3Ip6onDQR8k5vUT00G
         CCiTwUqD3iiOz+umbzxcPW536mIkHA+myLtqBiQp/sxH1tXaOKgpRJfeHOS2g7P+e2
         gYeHtSQN/dANMe+QjBVXGZPSAscM3muBZzN4C4ZdET6lO9rtTOT9OD0OCwD0YrK8D3
         vgPSJinzWffZCnslabp++xI1XdUE+fXUb6VhEi4T30oTefdFwtz1FYHLALxxO3BFVi
         UglRWsrKzVp+f03DeKZDcyuk+QZWljXNf718HzACl75P/ExjaesMM5Apx5EC7JwWxZ
         7tXuXUerqGaPg==
Subject: [PATCH 36/48] libxfs: remove kmem_zone_init
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:26:30 -0800
Message-ID: <164263839036.865554.118213994124696686.stgit@magnolia>
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

Port all callers to kmem_cache_create, to sync with kernel API.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/kmem.h |    7 -------
 libxfs/init.c  |   32 ++++++++++++++++++--------------
 2 files changed, 18 insertions(+), 21 deletions(-)


diff --git a/include/kmem.h b/include/kmem.h
index 53a2b37a..36acd20d 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -34,13 +34,6 @@ typedef unsigned int __bitwise gfp_t;
 kmem_zone_t * kmem_cache_create(const char *name, unsigned int size,
 		unsigned int align, unsigned int slab_flags,
 		void (*ctor)(void *));
-
-static inline kmem_zone_t *
-kmem_zone_init(unsigned int size, const char *name)
-{
-	return kmem_cache_create(name, size, 0, 0, NULL);
-}
-
 void kmem_cache_destroy(kmem_zone_t *);
 
 extern void	*kmem_cache_alloc(kmem_zone_t *, gfp_t);
diff --git a/libxfs/init.c b/libxfs/init.c
index 0d693848..155b12fa 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -234,25 +234,29 @@ init_zones(void)
 	int		error;
 
 	/* initialise zone allocation */
-	xfs_buf_zone = kmem_zone_init(sizeof(struct xfs_buf), "xfs_buffer");
-	xfs_inode_zone = kmem_zone_init(sizeof(struct xfs_inode), "xfs_inode");
-	xfs_ifork_zone = kmem_zone_init(sizeof(struct xfs_ifork), "xfs_ifork");
-	xfs_ili_zone = kmem_zone_init(
-			sizeof(struct xfs_inode_log_item),"xfs_inode_log_item");
-	xfs_buf_item_zone = kmem_zone_init(
-			sizeof(struct xfs_buf_log_item), "xfs_buf_log_item");
-	xfs_da_state_zone = kmem_zone_init(
-			sizeof(struct xfs_da_state), "xfs_da_state");
+	xfs_buf_zone = kmem_cache_create("xfs_buffer",
+			sizeof(struct xfs_buf), 0, 0, NULL);
+	xfs_inode_zone = kmem_cache_create("xfs_inode",
+			sizeof(struct xfs_inode), 0, 0, NULL);
+	xfs_ifork_zone = kmem_cache_create("xfs_ifork",
+			sizeof(struct xfs_ifork), 0, 0, NULL);
+	xfs_ili_zone = kmem_cache_create("xfs_inode_log_item",
+			sizeof(struct xfs_inode_log_item), 0, 0, NULL);
+	xfs_buf_item_zone = kmem_cache_create("xfs_buf_log_item",
+			sizeof(struct xfs_buf_log_item), 0, 0, NULL);
+	xfs_da_state_zone = kmem_cache_create("xfs_da_state",
+			sizeof(struct xfs_da_state), 0, 0, NULL);
+
 	error = xfs_btree_init_cur_caches();
 	if (error) {
 		fprintf(stderr, "Could not allocate btree cursor caches.\n");
 		abort();
 	}
-	xfs_bmap_free_item_zone = kmem_zone_init(
-			sizeof(struct xfs_extent_free_item),
-			"xfs_bmap_free_item");
-	xfs_trans_zone = kmem_zone_init(
-			sizeof(struct xfs_trans), "xfs_trans");
+
+	xfs_bmap_free_item_zone = kmem_cache_create("xfs_bmap_free_item",
+			sizeof(struct xfs_extent_free_item), 0, 0, NULL);
+	xfs_trans_zone = kmem_cache_create("xfs_trans",
+			sizeof(struct xfs_trans), 0, 0, NULL);
 }
 
 static void

