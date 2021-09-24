Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D8CAC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:28:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C10461214
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243769AbhIXB3c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:29:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243758AbhIXB3c (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Sep 2021 21:29:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EE84604E9;
        Fri, 24 Sep 2021 01:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632446880;
        bh=zRQZ9BznFAktbcxH5eRzj80RqZMb65kgcJ2Gc0cAjmY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q6JQJxIE40ZP/E3J4Dx08GrgHDlwoOXALBuWY+tZIO5j/i8T8zYHvm8G8QJxuUdEV
         /+gZoRDA8KZLR9WibAoSheyoIawRTryKsH1aen0ovcGkPXXduuV9lzErRKHlH6EpTR
         2dJg0j7LE3NthpSrkYip/4wmvEXqLUQ7b8iTBxcoqm0kIzGB5EYe6TrMBUWBwslno+
         NpeyvHitNu9yUwSC3W0axxV3qY7bKkOsv5Ub3pLuJO/rYvDRAJfUmuyWH4W265yAwS
         Z71wrSdKmA6WwlJBsrMDzY4Hekd5a2tPpEfKpJOxTZjyfRC6R6rFwNCZPp8tcbAIMo
         A2OODaCys3Tfg==
Subject: [PATCH 4/4] xfs: use separate btree cursor slab for each btree type
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com,
        chandanrlinux@gmail.com, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 23 Sep 2021 18:27:59 -0700
Message-ID: <163244687985.2701674.5510358661953545557.stgit@magnolia>
In-Reply-To: <163244685787.2701674.13029851795897591378.stgit@magnolia>
References: <163244685787.2701674.13029851795897591378.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we have the infrastructure to track the max possible height of
each btree type, we can create a separate slab zone for cursors of each
type of btree.  For smaller indices like the free space btrees, this
means that we can pack more cursors into a slab page, improving slab
utilization.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   12 ++++++------
 fs/xfs/libxfs/xfs_btree.h |    9 +--------
 fs/xfs/xfs_super.c        |   33 ++++++++++++++++++++++++---------
 3 files changed, 31 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 120280c998f8..3131de9ae631 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -26,7 +26,6 @@
 /*
  * Cursor allocation zone.
  */
-kmem_zone_t	*xfs_btree_cur_zone;
 struct xfs_btree_cur_zone xfs_btree_cur_zones[XFS_BTNUM_MAX] = {
 	[XFS_BTNUM_BNO]		= { .name = "xfs_alloc_btree_cur" },
 	[XFS_BTNUM_INO]		= { .name = "xfs_ialloc_btree_cur" },
@@ -364,6 +363,7 @@ xfs_btree_del_cursor(
 	struct xfs_btree_cur	*cur,		/* btree cursor */
 	int			error)		/* del because of error */
 {
+	struct xfs_btree_cur_zone *bczone = &xfs_btree_cur_zones[cur->bc_btnum];
 	int			i;		/* btree level */
 
 	/*
@@ -386,10 +386,10 @@ xfs_btree_del_cursor(
 		kmem_free(cur->bc_ops);
 	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
 		xfs_perag_put(cur->bc_ag.pag);
-	if (cur->bc_maxlevels > XFS_BTREE_CUR_ZONE_MAXLEVELS)
+	if (cur->bc_maxlevels > bczone->maxlevels)
 		kmem_free(cur);
 	else
-		kmem_cache_free(xfs_btree_cur_zone, cur);
+		kmem_cache_free(bczone->zone, cur);
 }
 
 /*
@@ -5021,12 +5021,12 @@ xfs_btree_alloc_cursor(
 {
 	struct xfs_btree_cur	*cur;
 	unsigned int		maxlevels = xfs_btree_maxlevels(mp, btnum);
+	struct xfs_btree_cur_zone *bczone = &xfs_btree_cur_zones[btnum];
 
-	if (maxlevels > XFS_BTREE_CUR_ZONE_MAXLEVELS)
+	if (maxlevels > bczone->maxlevels)
 		cur = kmem_zalloc(xfs_btree_cur_sizeof(maxlevels), KM_NOFS);
 	else
-		cur = kmem_cache_zalloc(xfs_btree_cur_zone,
-				GFP_NOFS | __GFP_NOFAIL);
+		cur = kmem_cache_zalloc(bczone->zone, GFP_NOFS | __GFP_NOFAIL);
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 5bebd26f8b2c..854235a8adac 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -13,8 +13,6 @@ struct xfs_trans;
 struct xfs_ifork;
 struct xfs_perag;
 
-extern kmem_zone_t	*xfs_btree_cur_zone;
-
 /*
  * Generic key, ptr and record wrapper structures.
  *
@@ -92,12 +90,6 @@ uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
 #define XFS_BTREE_STATS_ADD(cur, stat, val)	\
 	XFS_STATS_ADD_OFF((cur)->bc_mp, (cur)->bc_statoff + __XBTS_ ## stat, val)
 
-/*
- * The btree cursor zone hands out cursors that can handle up to this many
- * levels.  This is the known maximum for all btree types.
- */
-#define XFS_BTREE_CUR_ZONE_MAXLEVELS	(9)
-
 struct xfs_btree_ops {
 	/* size of the key and record structures */
 	size_t	key_len;
@@ -588,6 +580,7 @@ void xfs_btree_absolute_minrecs(unsigned int *minrecs, unsigned int bc_flags,
 
 struct xfs_btree_cur_zone {
 	const char		*name;
+	kmem_zone_t		*zone;
 	unsigned int		maxlevels;
 };
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 83abe9bfe3ef..426dcba213ac 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1969,7 +1969,14 @@ xfs_init_btree_zones(void)
 	z[XFS_BTNUM_REFC].maxlevels	= xfs_refcountbt_absolute_maxlevels();
 
 	for_each_xfs_btnum(btnum) {
-		ASSERT(z[btnum].maxlevels <= XFS_BTREE_CUR_ZONE_MAXLEVELS);
+		if (z[btnum].name == NULL)
+			continue;
+		ASSERT(z[btnum].maxlevels >= 1);
+		z[btnum].zone = kmem_cache_create(z[btnum].name,
+				xfs_btree_cur_sizeof(z[btnum].maxlevels),
+				0, 0, NULL);
+		if (!z[btnum].zone)
+			return -ENOMEM;
 	}
 
 	/* struct copies for btree types that share zones */
@@ -1979,6 +1986,20 @@ xfs_init_btree_zones(void)
 	return 0;
 }
 
+STATIC void
+xfs_destroy_btree_zones(void)
+{
+	struct xfs_btree_cur_zone	*z = xfs_btree_cur_zones;
+	xfs_btnum_t			btnum;
+
+	/* don't free shared zones */
+	z[XFS_BTNUM_CNT].zone = NULL;
+	z[XFS_BTNUM_FINO].zone = NULL;
+
+	for_each_xfs_btnum(btnum)
+		kmem_cache_destroy(z[btnum].zone);
+}
+
 STATIC int __init
 xfs_init_zones(void)
 {
@@ -2000,12 +2021,6 @@ xfs_init_zones(void)
 	if (error)
 		goto out_destroy_bmap_free_item_zone;
 
-	xfs_btree_cur_zone = kmem_cache_create("xfs_btree_cur",
-			xfs_btree_cur_sizeof(XFS_BTREE_CUR_ZONE_MAXLEVELS),
-			0, 0, NULL);
-	if (!xfs_btree_cur_zone)
-		goto out_destroy_bmap_free_item_zone;
-
 	xfs_da_state_zone = kmem_cache_create("xfs_da_state",
 					      sizeof(struct xfs_da_state),
 					      0, 0, NULL);
@@ -2141,7 +2156,7 @@ xfs_init_zones(void)
  out_destroy_da_state_zone:
 	kmem_cache_destroy(xfs_da_state_zone);
  out_destroy_btree_cur_zone:
-	kmem_cache_destroy(xfs_btree_cur_zone);
+	xfs_destroy_btree_zones();
  out_destroy_bmap_free_item_zone:
 	kmem_cache_destroy(xfs_bmap_free_item_zone);
  out_destroy_log_ticket_zone:
@@ -2173,7 +2188,7 @@ xfs_destroy_zones(void)
 	kmem_cache_destroy(xfs_trans_zone);
 	kmem_cache_destroy(xfs_ifork_zone);
 	kmem_cache_destroy(xfs_da_state_zone);
-	kmem_cache_destroy(xfs_btree_cur_zone);
+	xfs_destroy_btree_zones();
 	kmem_cache_destroy(xfs_bmap_free_item_zone);
 	kmem_cache_destroy(xfs_log_ticket_zone);
 }

