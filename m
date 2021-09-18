Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E05AC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:30:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65BD561241
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234834AbhIRBbe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 21:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234515AbhIRBbd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Sep 2021 21:31:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7090860FBF;
        Sat, 18 Sep 2021 01:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631928610;
        bh=tEjUh9ULbjJdmr7bMXbCxBIC8pwaFKG1ZFjtgK7B12s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dRCZCTZOe12ApZQ7FRWG6gVtvFmVOSSIHb1efVU8BExmq1VQ7gP1vSCQV6kpM2s8O
         3J/u6S9ukYyMyYLI4bMnUwLY1NTthiDgCv1uEdxTGLeV1y16dYO4FvUd92x4xUri+j
         OnIRqbweiTD2UW6mfU1fJacXoKc1YKWSPtjjAz3zfZNJrklStjwjmE2bEzGKHvYPcd
         2ppv8dJfifYuBlThsyAv7+CMygQhtnTqceX2OfWAf7tlJjqadEnSY2ATYYuyjw/pHR
         RqDwt3/wDQfeE48vh8GSa7epOdE6oiDWLLZI1kh/x4HBc0gzXBzAUumenTTPh50tFD
         yllk66TODC6yA==
Subject: [PATCH 11/14] xfs: dynamically allocate cursors based on maxlevels
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Sep 2021 18:30:10 -0700
Message-ID: <163192861018.416199.11733078081556457241.stgit@magnolia>
In-Reply-To: <163192854958.416199.3396890438240296942.stgit@magnolia>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Replace the statically-sized btree cursor zone with dynamically sized
allocations so that we can reduce the memory overhead for per-AG bt
cursors while handling very tall btrees for rt metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   40 ++++++++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_btree.h |    2 --
 fs/xfs/xfs_super.c        |   11 +----------
 3 files changed, 33 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2486ba22c01d..f9516828a847 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -23,11 +23,6 @@
 #include "xfs_btree_staging.h"
 #include "xfs_ag.h"
 
-/*
- * Cursor allocation zone.
- */
-kmem_zone_t	*xfs_btree_cur_zone;
-
 /*
  * Btree magic numbers.
  */
@@ -379,7 +374,7 @@ xfs_btree_del_cursor(
 		kmem_free(cur->bc_ops);
 	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
 		xfs_perag_put(cur->bc_ag.pag);
-	kmem_cache_free(xfs_btree_cur_zone, cur);
+	kmem_free(cur);
 }
 
 /*
@@ -4927,6 +4922,32 @@ xfs_btree_has_more_records(
 		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
 }
 
+/* Compute the maximum allowed height for a given btree type. */
+static unsigned int
+xfs_btree_maxlevels(
+	struct xfs_mount	*mp,
+	xfs_btnum_t		btnum)
+{
+	switch (btnum) {
+	case XFS_BTNUM_BNO:
+	case XFS_BTNUM_CNT:
+		return mp->m_ag_maxlevels;
+	case XFS_BTNUM_BMAP:
+		return max(mp->m_bm_maxlevels[XFS_DATA_FORK],
+			   mp->m_bm_maxlevels[XFS_ATTR_FORK]);
+	case XFS_BTNUM_INO:
+	case XFS_BTNUM_FINO:
+		return M_IGEO(mp)->inobt_maxlevels;
+	case XFS_BTNUM_RMAP:
+		return mp->m_rmap_maxlevels;
+	case XFS_BTNUM_REFC:
+		return mp->m_refc_maxlevels;
+	default:
+		ASSERT(0);
+		return XFS_BTREE_MAXLEVELS;
+	}
+}
+
 /* Allocate a new btree cursor of the appropriate size. */
 struct xfs_btree_cur *
 xfs_btree_alloc_cursor(
@@ -4935,13 +4956,16 @@ xfs_btree_alloc_cursor(
 	xfs_btnum_t		btnum)
 {
 	struct xfs_btree_cur	*cur;
+	unsigned int		maxlevels = xfs_btree_maxlevels(mp, btnum);
 
-	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
+	ASSERT(maxlevels <= XFS_BTREE_MAXLEVELS);
+
+	cur = kmem_zalloc(xfs_btree_cur_sizeof(maxlevels), KM_NOFS);
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
-	cur->bc_maxlevels = XFS_BTREE_MAXLEVELS;
+	cur->bc_maxlevels = maxlevels;
 
 	return cur;
 }
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 6075918efa0c..ae83fbf58c18 100644
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
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 30bae0657343..25a548bbb0b2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1965,17 +1965,11 @@ xfs_init_zones(void)
 	if (!xfs_bmap_free_item_zone)
 		goto out_destroy_log_ticket_zone;
 
-	xfs_btree_cur_zone = kmem_cache_create("xfs_btree_cur",
-				xfs_btree_cur_sizeof(XFS_BTREE_MAXLEVELS),
-					       0, 0, NULL);
-	if (!xfs_btree_cur_zone)
-		goto out_destroy_bmap_free_item_zone;
-
 	xfs_da_state_zone = kmem_cache_create("xfs_da_state",
 					      sizeof(struct xfs_da_state),
 					      0, 0, NULL);
 	if (!xfs_da_state_zone)
-		goto out_destroy_btree_cur_zone;
+		goto out_destroy_bmap_free_item_zone;
 
 	xfs_ifork_zone = kmem_cache_create("xfs_ifork",
 					   sizeof(struct xfs_ifork),
@@ -2105,8 +2099,6 @@ xfs_init_zones(void)
 	kmem_cache_destroy(xfs_ifork_zone);
  out_destroy_da_state_zone:
 	kmem_cache_destroy(xfs_da_state_zone);
- out_destroy_btree_cur_zone:
-	kmem_cache_destroy(xfs_btree_cur_zone);
  out_destroy_bmap_free_item_zone:
 	kmem_cache_destroy(xfs_bmap_free_item_zone);
  out_destroy_log_ticket_zone:
@@ -2138,7 +2130,6 @@ xfs_destroy_zones(void)
 	kmem_cache_destroy(xfs_trans_zone);
 	kmem_cache_destroy(xfs_ifork_zone);
 	kmem_cache_destroy(xfs_da_state_zone);
-	kmem_cache_destroy(xfs_btree_cur_zone);
 	kmem_cache_destroy(xfs_bmap_free_item_zone);
 	kmem_cache_destroy(xfs_log_ticket_zone);
 }

