Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5660C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345514AbiATA0p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiATA0o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:26:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9D6C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:26:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5B99B81A7C
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2E6C004E1;
        Thu, 20 Jan 2022 00:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638401;
        bh=HuPeDHf3POVAQfKUcIGEgYDntQZy6e7lw//stzd8okM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SQIjZlsl3zV+2312Rgt7s3hCT2JbcqiZR1T2KIzYmxBuk/5+ie1LUGO+eO466vuIY
         1nZ+ZniC2z1G6eYKKSjw4AFhS6dgQr/Wu4d+buk0UyRbv8hOfG120BihAhC/BobSNK
         vHdUf1lMrshqlNxwH+7nfCzWveB9tm3vzn3SMRsrOFN9B9aY0VEF3T5IOQbZkMzSdy
         BwwTjdLIV6hlISrfIHHmvs8UJvcjXfJ7PGfJZ8y6sAr4rB4tloUyzEE2qPbmyoS6di
         d7RCiabIL5I3yCGO06DGBOnU7rUPE2IuMwnc0Z2qjr+tnmmEJFpuKM+glev9X2vISi
         RUo5tMbG8cemg==
Subject: [PATCH 38/48] xfs: rename _zone variables to _cache
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:26:41 -0800
Message-ID: <164263840138.865554.3713835353478500099.stgit@magnolia>
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

Source kernel commit: 182696fb021fc196e5cbe641565ca40fcf0f885a

Now that we've gotten rid of the kmem_zone_t typedef, rename the
variables to _cache since that's what they are.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c           |   12 ++++++------
 libxfs/rdwr.c           |    4 ++--
 libxfs/xfs_alloc.c      |    6 +++---
 libxfs/xfs_attr_leaf.c  |    2 +-
 libxfs/xfs_bmap.c       |    6 +++---
 libxfs/xfs_bmap.h       |    2 +-
 libxfs/xfs_da_btree.c   |    6 +++---
 libxfs/xfs_da_btree.h   |    3 +--
 libxfs/xfs_inode_fork.c |    8 ++++----
 libxfs/xfs_inode_fork.h |    2 +-
 10 files changed, 25 insertions(+), 26 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 155b12fa..4a5b0d2e 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -238,13 +238,13 @@ init_zones(void)
 			sizeof(struct xfs_buf), 0, 0, NULL);
 	xfs_inode_zone = kmem_cache_create("xfs_inode",
 			sizeof(struct xfs_inode), 0, 0, NULL);
-	xfs_ifork_zone = kmem_cache_create("xfs_ifork",
+	xfs_ifork_cache = kmem_cache_create("xfs_ifork",
 			sizeof(struct xfs_ifork), 0, 0, NULL);
 	xfs_ili_zone = kmem_cache_create("xfs_inode_log_item",
 			sizeof(struct xfs_inode_log_item), 0, 0, NULL);
 	xfs_buf_item_zone = kmem_cache_create("xfs_buf_log_item",
 			sizeof(struct xfs_buf_log_item), 0, 0, NULL);
-	xfs_da_state_zone = kmem_cache_create("xfs_da_state",
+	xfs_da_state_cache = kmem_cache_create("xfs_da_state",
 			sizeof(struct xfs_da_state), 0, 0, NULL);
 
 	error = xfs_btree_init_cur_caches();
@@ -253,7 +253,7 @@ init_zones(void)
 		abort();
 	}
 
-	xfs_bmap_free_item_zone = kmem_cache_create("xfs_bmap_free_item",
+	xfs_bmap_free_item_cache = kmem_cache_create("xfs_bmap_free_item",
 			sizeof(struct xfs_extent_free_item), 0, 0, NULL);
 	xfs_trans_zone = kmem_cache_create("xfs_trans",
 			sizeof(struct xfs_trans), 0, 0, NULL);
@@ -265,11 +265,11 @@ destroy_kmem_caches(void)
 	kmem_cache_destroy(xfs_buf_zone);
 	kmem_cache_destroy(xfs_ili_zone);
 	kmem_cache_destroy(xfs_inode_zone);
-	kmem_cache_destroy(xfs_ifork_zone);
+	kmem_cache_destroy(xfs_ifork_cache);
 	kmem_cache_destroy(xfs_buf_item_zone);
-	kmem_cache_destroy(xfs_da_state_zone);
+	kmem_cache_destroy(xfs_da_state_cache);
 	xfs_btree_destroy_cur_caches();
-	kmem_cache_destroy(xfs_bmap_free_item_zone);
+	kmem_cache_destroy(xfs_bmap_free_item_cache);
 	kmem_cache_destroy(xfs_trans_zone);
 }
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 315e6d1f..c6a2c607 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1115,11 +1115,11 @@ libxfs_idestroy(xfs_inode_t *ip)
 	}
 	if (ip->i_afp) {
 		libxfs_idestroy_fork(ip->i_afp);
-		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
+		kmem_cache_free(xfs_ifork_cache, ip->i_afp);
 	}
 	if (ip->i_cowfp) {
 		libxfs_idestroy_fork(ip->i_cowfp);
-		kmem_cache_free(xfs_ifork_zone, ip->i_cowfp);
+		kmem_cache_free(xfs_ifork_cache, ip->i_cowfp);
 	}
 }
 
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index c99497fd..06e870a8 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -23,7 +23,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
 
-extern struct kmem_cache	*xfs_bmap_free_item_zone;
+extern struct kmem_cache	*xfs_bmap_free_item_cache;
 
 struct workqueue_struct *xfs_alloc_wq;
 
@@ -2455,10 +2455,10 @@ xfs_defer_agfl_block(
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_extent_free_item	*new;		/* new element */
 
-	ASSERT(xfs_bmap_free_item_zone != NULL);
+	ASSERT(xfs_bmap_free_item_cache != NULL);
 	ASSERT(oinfo != NULL);
 
-	new = kmem_cache_alloc(xfs_bmap_free_item_zone,
+	new = kmem_cache_alloc(xfs_bmap_free_item_cache,
 			       GFP_KERNEL | __GFP_NOFAIL);
 	new->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
 	new->xefi_blockcount = 1;
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 76a52573..31eddb54 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -767,7 +767,7 @@ xfs_attr_fork_remove(
 	ASSERT(ip->i_afp->if_nextents == 0);
 
 	xfs_idestroy_fork(ip->i_afp);
-	kmem_cache_free(xfs_ifork_zone, ip->i_afp);
+	kmem_cache_free(xfs_ifork_cache, ip->i_afp);
 	ip->i_afp = NULL;
 	ip->i_forkoff = 0;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index ecf79e24..0514d6e5 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -31,7 +31,7 @@
 #include "xfs_refcount.h"
 
 
-struct kmem_cache		*xfs_bmap_free_item_zone;
+struct kmem_cache		*xfs_bmap_free_item_cache;
 
 /*
  * Miscellaneous helper functions
@@ -548,9 +548,9 @@ __xfs_bmap_add_free(
 	ASSERT(len < mp->m_sb.sb_agblocks);
 	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
 #endif
-	ASSERT(xfs_bmap_free_item_zone != NULL);
+	ASSERT(xfs_bmap_free_item_cache != NULL);
 
-	new = kmem_cache_alloc(xfs_bmap_free_item_zone,
+	new = kmem_cache_alloc(xfs_bmap_free_item_cache,
 			       GFP_KERNEL | __GFP_NOFAIL);
 	new->xefi_startblock = bno;
 	new->xefi_blockcount = (xfs_extlen_t)len;
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 171a72ee..2cd7717c 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -13,7 +13,7 @@ struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
 
-extern struct kmem_cache	*xfs_bmap_free_item_zone;
+extern struct kmem_cache	*xfs_bmap_free_item_cache;
 
 /*
  * Argument structure for xfs_bmap_alloc.
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index f1ae5d4d..50f3ec66 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -69,7 +69,7 @@ STATIC int	xfs_da3_blk_unlink(xfs_da_state_t *state,
 				  xfs_da_state_blk_t *save_blk);
 
 
-struct kmem_cache *xfs_da_state_zone;	/* anchor for state struct zone */
+struct kmem_cache	*xfs_da_state_cache;	/* anchor for dir/attr state */
 
 /*
  * Allocate a dir-state structure.
@@ -81,7 +81,7 @@ xfs_da_state_alloc(
 {
 	struct xfs_da_state	*state;
 
-	state = kmem_cache_zalloc(xfs_da_state_zone, GFP_NOFS | __GFP_NOFAIL);
+	state = kmem_cache_zalloc(xfs_da_state_cache, GFP_NOFS | __GFP_NOFAIL);
 	state->args = args;
 	state->mp = args->dp->i_mount;
 	return state;
@@ -110,7 +110,7 @@ xfs_da_state_free(xfs_da_state_t *state)
 #ifdef DEBUG
 	memset((char *)state, 0, sizeof(*state));
 #endif /* DEBUG */
-	kmem_cache_free(xfs_da_state_zone, state);
+	kmem_cache_free(xfs_da_state_cache, state);
 }
 
 static inline int xfs_dabuf_nfsb(struct xfs_mount *mp, int whichfork)
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index da845e32..0faf7d9a 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -9,7 +9,6 @@
 
 struct xfs_inode;
 struct xfs_trans;
-struct zone;
 
 /*
  * Directory/attribute geometry information. There will be one of these for each
@@ -227,6 +226,6 @@ void	xfs_da3_node_hdr_from_disk(struct xfs_mount *mp,
 void	xfs_da3_node_hdr_to_disk(struct xfs_mount *mp,
 		struct xfs_da_intnode *to, struct xfs_da3_icnode_hdr *from);
 
-extern struct kmem_cache *xfs_da_state_zone;
+extern struct kmem_cache	*xfs_da_state_cache;
 
 #endif	/* __XFS_DA_BTREE_H__ */
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index c80b4066..d6ac13ee 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -24,7 +24,7 @@
 #include "xfs_types.h"
 #include "xfs_errortag.h"
 
-struct kmem_cache *xfs_ifork_zone;
+struct kmem_cache *xfs_ifork_cache;
 
 void
 xfs_init_local_fork(
@@ -282,7 +282,7 @@ xfs_ifork_alloc(
 {
 	struct xfs_ifork	*ifp;
 
-	ifp = kmem_cache_zalloc(xfs_ifork_zone, GFP_NOFS | __GFP_NOFAIL);
+	ifp = kmem_cache_zalloc(xfs_ifork_cache, GFP_NOFS | __GFP_NOFAIL);
 	ifp->if_format = format;
 	ifp->if_nextents = nextents;
 	return ifp;
@@ -323,7 +323,7 @@ xfs_iformat_attr_fork(
 	}
 
 	if (error) {
-		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
+		kmem_cache_free(xfs_ifork_cache, ip->i_afp);
 		ip->i_afp = NULL;
 	}
 	return error;
@@ -674,7 +674,7 @@ xfs_ifork_init_cow(
 	if (ip->i_cowfp)
 		return;
 
-	ip->i_cowfp = kmem_cache_zalloc(xfs_ifork_zone,
+	ip->i_cowfp = kmem_cache_zalloc(xfs_ifork_cache,
 				       GFP_NOFS | __GFP_NOFAIL);
 	ip->i_cowfp->if_format = XFS_DINODE_FMT_EXTENTS;
 }
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index cb296bd5..3d64a3ac 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -221,7 +221,7 @@ static inline bool xfs_iext_peek_prev_extent(struct xfs_ifork *ifp,
 	     xfs_iext_get_extent((ifp), (ext), (got));	\
 	     xfs_iext_next((ifp), (ext)))
 
-extern struct kmem_cache	*xfs_ifork_zone;
+extern struct kmem_cache	*xfs_ifork_cache;
 
 extern void xfs_ifork_init_cow(struct xfs_inode *ip);
 

