Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9DBC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Oct 2021 18:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DE3460E90
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Oct 2021 18:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhJSSyR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Oct 2021 14:54:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231355AbhJSSyQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Oct 2021 14:54:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5A3F61038;
        Tue, 19 Oct 2021 18:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634669523;
        bh=frw7XUgCOaaRnBoyohsrGVJZzLqCkJ0b7ojXI94+bo0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SKDDbj1RxeFZ1+dN5jugQueOJciKmPgUgnNnJBUYLauVc/KooxtFy1QsTLywGAIQX
         5qX41yxRB1MUm1czen1ySF5CpR5F3Xk1DP/0x+5AMlmffDfbBYeKS5hFJLAnAEadjT
         1zUmhrJIDVIo5vhuRUSD/UCWeTu+kOb52Bf3mnRTA6E7c6TgkDIybsNyqxxPXk0jam
         MEIcLvtOqrLxENn8OGTrMANvRTNZlysPTP3xnqvpq9byyAgdO6etma+8G9UmoNRN4e
         5ZAKpesIqexjPsAVZhKDhpfGZeBn9A6Tb597JoUMnkZopyhiSR+O1J9wFf1s2tcogh
         88lBfFd5kxX3A==
Subject: [PATCH 2/2] xfs: rename _zone variables to _cache
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 19 Oct 2021 11:52:03 -0700
Message-ID: <163466952339.2234337.1859766681882869136.stgit@magnolia>
In-Reply-To: <163466951226.2234337.10978241003370731405.stgit@magnolia>
References: <163466951226.2234337.10978241003370731405.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've gotten rid of the kmem_zone_t typedef, rename the
variables to _cache since that's what they are.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c      |    6 +
 fs/xfs/libxfs/xfs_attr_leaf.c  |    2 
 fs/xfs/libxfs/xfs_bmap.c       |    6 +
 fs/xfs/libxfs/xfs_bmap.h       |    2 
 fs/xfs/libxfs/xfs_da_btree.c   |    6 +
 fs/xfs/libxfs/xfs_da_btree.h   |    3 -
 fs/xfs/libxfs/xfs_inode_fork.c |    8 +
 fs/xfs/libxfs/xfs_inode_fork.h |    2 
 fs/xfs/xfs_attr_inactive.c     |    2 
 fs/xfs/xfs_bmap_item.c         |   12 +-
 fs/xfs/xfs_bmap_item.h         |    4 -
 fs/xfs/xfs_buf.c               |   14 +--
 fs/xfs/xfs_buf_item.c          |    8 +
 fs/xfs/xfs_buf_item.h          |    2 
 fs/xfs/xfs_dquot.c             |   26 ++---
 fs/xfs/xfs_extfree_item.c      |   18 ++-
 fs/xfs/xfs_extfree_item.h      |    4 -
 fs/xfs/xfs_icache.c            |   10 +-
 fs/xfs/xfs_icreate_item.c      |    6 +
 fs/xfs/xfs_icreate_item.h      |    2 
 fs/xfs/xfs_inode.c             |    2 
 fs/xfs/xfs_inode.h             |    2 
 fs/xfs/xfs_inode_item.c        |    6 +
 fs/xfs/xfs_inode_item.h        |    2 
 fs/xfs/xfs_log.c               |    6 +
 fs/xfs/xfs_log_priv.h          |    2 
 fs/xfs/xfs_mru_cache.c         |    2 
 fs/xfs/xfs_qm.h                |    2 
 fs/xfs/xfs_refcount_item.c     |   12 +-
 fs/xfs/xfs_refcount_item.h     |    4 -
 fs/xfs/xfs_rmap_item.c         |   12 +-
 fs/xfs/xfs_rmap_item.h         |    4 -
 fs/xfs/xfs_super.c             |  218 ++++++++++++++++++++--------------------
 fs/xfs/xfs_trans.c             |    8 +
 fs/xfs/xfs_trans.h             |    2 
 fs/xfs/xfs_trans_dquot.c       |    4 -
 36 files changed, 215 insertions(+), 216 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 9bce5b258cd0..ccfe66df3e62 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -27,7 +27,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
 
-extern struct kmem_cache	*xfs_bmap_free_item_zone;
+extern struct kmem_cache	*xfs_bmap_free_item_cache;
 
 struct workqueue_struct *xfs_alloc_wq;
 
@@ -2459,10 +2459,10 @@ xfs_defer_agfl_block(
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
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index e1d11e314228..014daa8c542d 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -770,7 +770,7 @@ xfs_attr_fork_remove(
 	ASSERT(ip->i_afp->if_nextents == 0);
 
 	xfs_idestroy_fork(ip->i_afp);
-	kmem_cache_free(xfs_ifork_zone, ip->i_afp);
+	kmem_cache_free(xfs_ifork_cache, ip->i_afp);
 	ip->i_afp = NULL;
 	ip->i_forkoff = 0;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index de106afb1bd7..8a993ef6b7f4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -38,7 +38,7 @@
 #include "xfs_iomap.h"
 
 
-struct kmem_cache		*xfs_bmap_free_item_zone;
+struct kmem_cache		*xfs_bmap_free_item_cache;
 
 /*
  * Miscellaneous helper functions
@@ -555,9 +555,9 @@ __xfs_bmap_add_free(
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
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 171a72ee9f31..2cd7717cf753 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -13,7 +13,7 @@ struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
 
-extern struct kmem_cache	*xfs_bmap_free_item_zone;
+extern struct kmem_cache	*xfs_bmap_free_item_cache;
 
 /*
  * Argument structure for xfs_bmap_alloc.
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 106776927b04..dd7a2dbce1d1 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -72,7 +72,7 @@ STATIC int	xfs_da3_blk_unlink(xfs_da_state_t *state,
 				  xfs_da_state_blk_t *save_blk);
 
 
-struct kmem_cache *xfs_da_state_zone;	/* anchor for state struct zone */
+struct kmem_cache	*xfs_da_state_cache;	/* anchor for dir/attr state */
 
 /*
  * Allocate a dir-state structure.
@@ -84,7 +84,7 @@ xfs_da_state_alloc(
 {
 	struct xfs_da_state	*state;
 
-	state = kmem_cache_zalloc(xfs_da_state_zone, GFP_NOFS | __GFP_NOFAIL);
+	state = kmem_cache_zalloc(xfs_da_state_cache, GFP_NOFS | __GFP_NOFAIL);
 	state->args = args;
 	state->mp = args->dp->i_mount;
 	return state;
@@ -113,7 +113,7 @@ xfs_da_state_free(xfs_da_state_t *state)
 #ifdef DEBUG
 	memset((char *)state, 0, sizeof(*state));
 #endif /* DEBUG */
-	kmem_cache_free(xfs_da_state_zone, state);
+	kmem_cache_free(xfs_da_state_cache, state);
 }
 
 static inline int xfs_dabuf_nfsb(struct xfs_mount *mp, int whichfork)
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index da845e32a678..0faf7d9ac241 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
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
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index c60ed01a4cad..9149f4f796fc 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -26,7 +26,7 @@
 #include "xfs_types.h"
 #include "xfs_errortag.h"
 
-struct kmem_cache *xfs_ifork_zone;
+struct kmem_cache *xfs_ifork_cache;
 
 void
 xfs_init_local_fork(
@@ -284,7 +284,7 @@ xfs_ifork_alloc(
 {
 	struct xfs_ifork	*ifp;
 
-	ifp = kmem_cache_zalloc(xfs_ifork_zone, GFP_NOFS | __GFP_NOFAIL);
+	ifp = kmem_cache_zalloc(xfs_ifork_cache, GFP_NOFS | __GFP_NOFAIL);
 	ifp->if_format = format;
 	ifp->if_nextents = nextents;
 	return ifp;
@@ -325,7 +325,7 @@ xfs_iformat_attr_fork(
 	}
 
 	if (error) {
-		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
+		kmem_cache_free(xfs_ifork_cache, ip->i_afp);
 		ip->i_afp = NULL;
 	}
 	return error;
@@ -676,7 +676,7 @@ xfs_ifork_init_cow(
 	if (ip->i_cowfp)
 		return;
 
-	ip->i_cowfp = kmem_cache_zalloc(xfs_ifork_zone,
+	ip->i_cowfp = kmem_cache_zalloc(xfs_ifork_cache,
 				       GFP_NOFS | __GFP_NOFAIL);
 	ip->i_cowfp->if_format = XFS_DINODE_FMT_EXTENTS;
 }
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index cb296bd5baae..3d64a3acb0ed 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -221,7 +221,7 @@ static inline bool xfs_iext_peek_prev_extent(struct xfs_ifork *ifp,
 	     xfs_iext_get_extent((ifp), (ext), (got));	\
 	     xfs_iext_next((ifp), (ext)))
 
-extern struct kmem_cache	*xfs_ifork_zone;
+extern struct kmem_cache	*xfs_ifork_cache;
 
 extern void xfs_ifork_init_cow(struct xfs_inode *ip);
 
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 2b5da6218977..27265771f247 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -390,7 +390,7 @@ xfs_attr_inactive(
 	/* kill the in-core attr fork before we drop the inode lock */
 	if (dp->i_afp) {
 		xfs_idestroy_fork(dp->i_afp);
-		kmem_cache_free(xfs_ifork_zone, dp->i_afp);
+		kmem_cache_free(xfs_ifork_cache, dp->i_afp);
 		dp->i_afp = NULL;
 	}
 	if (lock_mode)
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 3d2725178eeb..6049f0722181 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -25,8 +25,8 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 
-struct kmem_cache	*xfs_bui_zone;
-struct kmem_cache	*xfs_bud_zone;
+struct kmem_cache	*xfs_bui_cache;
+struct kmem_cache	*xfs_bud_cache;
 
 static const struct xfs_item_ops xfs_bui_item_ops;
 
@@ -39,7 +39,7 @@ STATIC void
 xfs_bui_item_free(
 	struct xfs_bui_log_item	*buip)
 {
-	kmem_cache_free(xfs_bui_zone, buip);
+	kmem_cache_free(xfs_bui_cache, buip);
 }
 
 /*
@@ -138,7 +138,7 @@ xfs_bui_init(
 {
 	struct xfs_bui_log_item		*buip;
 
-	buip = kmem_cache_zalloc(xfs_bui_zone, GFP_KERNEL | __GFP_NOFAIL);
+	buip = kmem_cache_zalloc(xfs_bui_cache, GFP_KERNEL | __GFP_NOFAIL);
 
 	xfs_log_item_init(mp, &buip->bui_item, XFS_LI_BUI, &xfs_bui_item_ops);
 	buip->bui_format.bui_nextents = XFS_BUI_MAX_FAST_EXTENTS;
@@ -198,7 +198,7 @@ xfs_bud_item_release(
 	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
 
 	xfs_bui_release(budp->bud_buip);
-	kmem_cache_free(xfs_bud_zone, budp);
+	kmem_cache_free(xfs_bud_cache, budp);
 }
 
 static const struct xfs_item_ops xfs_bud_item_ops = {
@@ -215,7 +215,7 @@ xfs_trans_get_bud(
 {
 	struct xfs_bud_log_item		*budp;
 
-	budp = kmem_cache_zalloc(xfs_bud_zone, GFP_KERNEL | __GFP_NOFAIL);
+	budp = kmem_cache_zalloc(xfs_bud_cache, GFP_KERNEL | __GFP_NOFAIL);
 	xfs_log_item_init(tp->t_mountp, &budp->bud_item, XFS_LI_BUD,
 			  &xfs_bud_item_ops);
 	budp->bud_buip = buip;
diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
index 6af6b02d4b66..3fafd3881a0b 100644
--- a/fs/xfs/xfs_bmap_item.h
+++ b/fs/xfs/xfs_bmap_item.h
@@ -65,7 +65,7 @@ struct xfs_bud_log_item {
 	struct xfs_bud_log_format	bud_format;
 };
 
-extern struct kmem_cache	*xfs_bui_zone;
-extern struct kmem_cache	*xfs_bud_zone;
+extern struct kmem_cache	*xfs_bui_cache;
+extern struct kmem_cache	*xfs_bud_cache;
 
 #endif	/* __XFS_BMAP_ITEM_H__ */
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1f4a1d63cb4a..631c5a61d89b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -20,7 +20,7 @@
 #include "xfs_error.h"
 #include "xfs_ag.h"
 
-static struct kmem_cache *xfs_buf_zone;
+static struct kmem_cache *xfs_buf_cache;
 
 /*
  * Locking orders
@@ -220,7 +220,7 @@ _xfs_buf_alloc(
 	int			i;
 
 	*bpp = NULL;
-	bp = kmem_cache_zalloc(xfs_buf_zone, GFP_NOFS | __GFP_NOFAIL);
+	bp = kmem_cache_zalloc(xfs_buf_cache, GFP_NOFS | __GFP_NOFAIL);
 
 	/*
 	 * We don't want certain flags to appear in b_flags unless they are
@@ -247,7 +247,7 @@ _xfs_buf_alloc(
 	 */
 	error = xfs_buf_get_maps(bp, nmaps);
 	if (error)  {
-		kmem_cache_free(xfs_buf_zone, bp);
+		kmem_cache_free(xfs_buf_cache, bp);
 		return error;
 	}
 
@@ -307,7 +307,7 @@ xfs_buf_free(
 		kmem_free(bp->b_addr);
 
 	xfs_buf_free_maps(bp);
-	kmem_cache_free(xfs_buf_zone, bp);
+	kmem_cache_free(xfs_buf_cache, bp);
 }
 
 static int
@@ -2258,12 +2258,12 @@ xfs_buf_delwri_pushbuf(
 int __init
 xfs_buf_init(void)
 {
-	xfs_buf_zone = kmem_cache_create("xfs_buf", sizeof(struct xfs_buf), 0,
+	xfs_buf_cache = kmem_cache_create("xfs_buf", sizeof(struct xfs_buf), 0,
 					 SLAB_HWCACHE_ALIGN |
 					 SLAB_RECLAIM_ACCOUNT |
 					 SLAB_MEM_SPREAD,
 					 NULL);
-	if (!xfs_buf_zone)
+	if (!xfs_buf_cache)
 		goto out;
 
 	return 0;
@@ -2275,7 +2275,7 @@ xfs_buf_init(void)
 void
 xfs_buf_terminate(void)
 {
-	kmem_cache_destroy(xfs_buf_zone);
+	kmem_cache_destroy(xfs_buf_cache);
 }
 
 void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 19f571b1a442..a7a8e4528881 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -23,7 +23,7 @@
 #include "xfs_log.h"
 
 
-struct kmem_cache	*xfs_buf_item_zone;
+struct kmem_cache	*xfs_buf_item_cache;
 
 static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 {
@@ -804,7 +804,7 @@ xfs_buf_item_init(
 		return 0;
 	}
 
-	bip = kmem_cache_zalloc(xfs_buf_item_zone, GFP_KERNEL | __GFP_NOFAIL);
+	bip = kmem_cache_zalloc(xfs_buf_item_cache, GFP_KERNEL | __GFP_NOFAIL);
 	xfs_log_item_init(mp, &bip->bli_item, XFS_LI_BUF, &xfs_buf_item_ops);
 	bip->bli_buf = bp;
 
@@ -825,7 +825,7 @@ xfs_buf_item_init(
 		map_size = DIV_ROUND_UP(chunks, NBWORD);
 
 		if (map_size > XFS_BLF_DATAMAP_SIZE) {
-			kmem_cache_free(xfs_buf_item_zone, bip);
+			kmem_cache_free(xfs_buf_item_cache, bip);
 			xfs_err(mp,
 	"buffer item dirty bitmap (%u uints) too small to reflect %u bytes!",
 					map_size,
@@ -1002,7 +1002,7 @@ xfs_buf_item_free(
 {
 	xfs_buf_item_free_format(bip);
 	kmem_free(bip->bli_item.li_lv_shadow);
-	kmem_cache_free(xfs_buf_item_zone, bip);
+	kmem_cache_free(xfs_buf_item_cache, bip);
 }
 
 /*
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index e70400dd7d16..e11e9ef2338f 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -71,6 +71,6 @@ static inline void xfs_buf_dquot_io_fail(struct xfs_buf *bp)
 void	xfs_buf_iodone(struct xfs_buf *);
 bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
 
-extern struct kmem_cache	*xfs_buf_item_zone;
+extern struct kmem_cache	*xfs_buf_item_cache;
 
 #endif	/* __XFS_BUF_ITEM_H__ */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 283b6740afea..e48ae227bb11 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -38,8 +38,8 @@
  * otherwise by the lowest id first, see xfs_dqlock2.
  */
 
-struct kmem_cache		*xfs_qm_dqtrxzone;
-static struct kmem_cache		*xfs_qm_dqzone;
+struct kmem_cache		*xfs_dqtrx_cache;
+static struct kmem_cache	*xfs_dquot_cache;
 
 static struct lock_class_key xfs_dquot_group_class;
 static struct lock_class_key xfs_dquot_project_class;
@@ -57,7 +57,7 @@ xfs_qm_dqdestroy(
 	mutex_destroy(&dqp->q_qlock);
 
 	XFS_STATS_DEC(dqp->q_mount, xs_qm_dquot);
-	kmem_cache_free(xfs_qm_dqzone, dqp);
+	kmem_cache_free(xfs_dquot_cache, dqp);
 }
 
 /*
@@ -458,7 +458,7 @@ xfs_dquot_alloc(
 {
 	struct xfs_dquot	*dqp;
 
-	dqp = kmem_cache_zalloc(xfs_qm_dqzone, GFP_KERNEL | __GFP_NOFAIL);
+	dqp = kmem_cache_zalloc(xfs_dquot_cache, GFP_KERNEL | __GFP_NOFAIL);
 
 	dqp->q_type = type;
 	dqp->q_id = id;
@@ -1363,22 +1363,22 @@ xfs_dqlock2(
 int __init
 xfs_qm_init(void)
 {
-	xfs_qm_dqzone = kmem_cache_create("xfs_dquot",
+	xfs_dquot_cache = kmem_cache_create("xfs_dquot",
 					  sizeof(struct xfs_dquot),
 					  0, 0, NULL);
-	if (!xfs_qm_dqzone)
+	if (!xfs_dquot_cache)
 		goto out;
 
-	xfs_qm_dqtrxzone = kmem_cache_create("xfs_dqtrx",
+	xfs_dqtrx_cache = kmem_cache_create("xfs_dqtrx",
 					     sizeof(struct xfs_dquot_acct),
 					     0, 0, NULL);
-	if (!xfs_qm_dqtrxzone)
-		goto out_free_dqzone;
+	if (!xfs_dqtrx_cache)
+		goto out_free_dquot_cache;
 
 	return 0;
 
-out_free_dqzone:
-	kmem_cache_destroy(xfs_qm_dqzone);
+out_free_dquot_cache:
+	kmem_cache_destroy(xfs_dquot_cache);
 out:
 	return -ENOMEM;
 }
@@ -1386,8 +1386,8 @@ xfs_qm_init(void)
 void
 xfs_qm_exit(void)
 {
-	kmem_cache_destroy(xfs_qm_dqtrxzone);
-	kmem_cache_destroy(xfs_qm_dqzone);
+	kmem_cache_destroy(xfs_dqtrx_cache);
+	kmem_cache_destroy(xfs_dquot_cache);
 }
 
 /*
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a5bef52cc6b3..26ac5048ce76 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -25,8 +25,8 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 
-struct kmem_cache	*xfs_efi_zone;
-struct kmem_cache	*xfs_efd_zone;
+struct kmem_cache	*xfs_efi_cache;
+struct kmem_cache	*xfs_efd_cache;
 
 static const struct xfs_item_ops xfs_efi_item_ops;
 
@@ -43,7 +43,7 @@ xfs_efi_item_free(
 	if (efip->efi_format.efi_nextents > XFS_EFI_MAX_FAST_EXTENTS)
 		kmem_free(efip);
 	else
-		kmem_cache_free(xfs_efi_zone, efip);
+		kmem_cache_free(xfs_efi_cache, efip);
 }
 
 /*
@@ -161,7 +161,7 @@ xfs_efi_init(
 			((nextents - 1) * sizeof(xfs_extent_t)));
 		efip = kmem_zalloc(size, 0);
 	} else {
-		efip = kmem_cache_zalloc(xfs_efi_zone,
+		efip = kmem_cache_zalloc(xfs_efi_cache,
 					 GFP_KERNEL | __GFP_NOFAIL);
 	}
 
@@ -241,7 +241,7 @@ xfs_efd_item_free(struct xfs_efd_log_item *efdp)
 	if (efdp->efd_format.efd_nextents > XFS_EFD_MAX_FAST_EXTENTS)
 		kmem_free(efdp);
 	else
-		kmem_cache_free(xfs_efd_zone, efdp);
+		kmem_cache_free(xfs_efd_cache, efdp);
 }
 
 /*
@@ -333,7 +333,7 @@ xfs_trans_get_efd(
 				(nextents - 1) * sizeof(struct xfs_extent),
 				0);
 	} else {
-		efdp = kmem_cache_zalloc(xfs_efd_zone,
+		efdp = kmem_cache_zalloc(xfs_efd_cache,
 					GFP_KERNEL | __GFP_NOFAIL);
 	}
 
@@ -482,7 +482,7 @@ xfs_extent_free_finish_item(
 			free->xefi_startblock,
 			free->xefi_blockcount,
 			&free->xefi_oinfo, free->xefi_skip_discard);
-	kmem_cache_free(xfs_bmap_free_item_zone, free);
+	kmem_cache_free(xfs_bmap_free_item_cache, free);
 	return error;
 }
 
@@ -502,7 +502,7 @@ xfs_extent_free_cancel_item(
 	struct xfs_extent_free_item	*free;
 
 	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	kmem_cache_free(xfs_bmap_free_item_zone, free);
+	kmem_cache_free(xfs_bmap_free_item_cache, free);
 }
 
 const struct xfs_defer_op_type xfs_extent_free_defer_type = {
@@ -564,7 +564,7 @@ xfs_agfl_free_finish_item(
 	extp->ext_len = free->xefi_blockcount;
 	efdp->efd_next_extent++;
 
-	kmem_cache_free(xfs_bmap_free_item_zone, free);
+	kmem_cache_free(xfs_bmap_free_item_cache, free);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index e8644945290e..186d0f2137f1 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -69,7 +69,7 @@ struct xfs_efd_log_item {
  */
 #define	XFS_EFD_MAX_FAST_EXTENTS	16
 
-extern struct kmem_cache	*xfs_efi_zone;
-extern struct kmem_cache	*xfs_efd_zone;
+extern struct kmem_cache	*xfs_efi_cache;
+extern struct kmem_cache	*xfs_efd_cache;
 
 #endif	/* __XFS_EXTFREE_ITEM_H__ */
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f2210d927481..e1472004170e 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -77,10 +77,10 @@ xfs_inode_alloc(
 	 * XXX: If this didn't occur in transactions, we could drop GFP_NOFAIL
 	 * and return NULL here on ENOMEM.
 	 */
-	ip = kmem_cache_alloc(xfs_inode_zone, GFP_KERNEL | __GFP_NOFAIL);
+	ip = kmem_cache_alloc(xfs_inode_cache, GFP_KERNEL | __GFP_NOFAIL);
 
 	if (inode_init_always(mp->m_super, VFS_I(ip))) {
-		kmem_cache_free(xfs_inode_zone, ip);
+		kmem_cache_free(xfs_inode_cache, ip);
 		return NULL;
 	}
 
@@ -130,11 +130,11 @@ xfs_inode_free_callback(
 
 	if (ip->i_afp) {
 		xfs_idestroy_fork(ip->i_afp);
-		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
+		kmem_cache_free(xfs_ifork_cache, ip->i_afp);
 	}
 	if (ip->i_cowfp) {
 		xfs_idestroy_fork(ip->i_cowfp);
-		kmem_cache_free(xfs_ifork_zone, ip->i_cowfp);
+		kmem_cache_free(xfs_ifork_cache, ip->i_cowfp);
 	}
 	if (ip->i_itemp) {
 		ASSERT(!test_bit(XFS_LI_IN_AIL,
@@ -143,7 +143,7 @@ xfs_inode_free_callback(
 		ip->i_itemp = NULL;
 	}
 
-	kmem_cache_free(xfs_inode_zone, ip);
+	kmem_cache_free(xfs_inode_cache, ip);
 }
 
 static void
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 7905518c4356..508e184e3b8f 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -20,7 +20,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_trace.h"
 
-struct kmem_cache	*xfs_icreate_zone;		/* inode create item zone */
+struct kmem_cache	*xfs_icreate_cache;		/* inode create item */
 
 static inline struct xfs_icreate_item *ICR_ITEM(struct xfs_log_item *lip)
 {
@@ -63,7 +63,7 @@ STATIC void
 xfs_icreate_item_release(
 	struct xfs_log_item	*lip)
 {
-	kmem_cache_free(xfs_icreate_zone, ICR_ITEM(lip));
+	kmem_cache_free(xfs_icreate_cache, ICR_ITEM(lip));
 }
 
 static const struct xfs_item_ops xfs_icreate_item_ops = {
@@ -97,7 +97,7 @@ xfs_icreate_log(
 {
 	struct xfs_icreate_item	*icp;
 
-	icp = kmem_cache_zalloc(xfs_icreate_zone, GFP_KERNEL | __GFP_NOFAIL);
+	icp = kmem_cache_zalloc(xfs_icreate_cache, GFP_KERNEL | __GFP_NOFAIL);
 
 	xfs_log_item_init(tp->t_mountp, &icp->ic_item, XFS_LI_ICREATE,
 			  &xfs_icreate_item_ops);
diff --git a/fs/xfs/xfs_icreate_item.h b/fs/xfs/xfs_icreate_item.h
index 944427b33645..64992823108a 100644
--- a/fs/xfs/xfs_icreate_item.h
+++ b/fs/xfs/xfs_icreate_item.h
@@ -12,7 +12,7 @@ struct xfs_icreate_item {
 	struct xfs_icreate_log	ic_format;
 };
 
-extern struct kmem_cache *xfs_icreate_zone;	/* inode create item zone */
+extern struct kmem_cache *xfs_icreate_cache;	/* inode create item */
 
 void xfs_icreate_log(struct xfs_trans *tp, xfs_agnumber_t agno,
 			xfs_agblock_t agbno, unsigned int count,
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 91cc52b906cb..36df768828e6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -36,7 +36,7 @@
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
 
-struct kmem_cache *xfs_inode_zone;
+struct kmem_cache *xfs_inode_cache;
 
 /*
  * Used in xfs_itruncate_extents().  This is the maximum number of extents
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 5cb495a16c34..e635a3d64cba 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -504,7 +504,7 @@ static inline void xfs_setup_existing_inode(struct xfs_inode *ip)
 
 void xfs_irele(struct xfs_inode *ip);
 
-extern struct kmem_cache	*xfs_inode_zone;
+extern struct kmem_cache	*xfs_inode_cache;
 
 /* The default CoW extent size hint. */
 #define XFS_DEFAULT_COWEXTSZ_HINT 32
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index e2af36e93966..90d8e591baf8 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -21,7 +21,7 @@
 
 #include <linux/iversion.h>
 
-struct kmem_cache	*xfs_ili_zone;		/* inode log item zone */
+struct kmem_cache	*xfs_ili_cache;		/* inode log item */
 
 static inline struct xfs_inode_log_item *INODE_ITEM(struct xfs_log_item *lip)
 {
@@ -672,7 +672,7 @@ xfs_inode_item_init(
 	struct xfs_inode_log_item *iip;
 
 	ASSERT(ip->i_itemp == NULL);
-	iip = ip->i_itemp = kmem_cache_zalloc(xfs_ili_zone,
+	iip = ip->i_itemp = kmem_cache_zalloc(xfs_ili_cache,
 					      GFP_KERNEL | __GFP_NOFAIL);
 
 	iip->ili_inode = ip;
@@ -694,7 +694,7 @@ xfs_inode_item_destroy(
 
 	ip->i_itemp = NULL;
 	kmem_free(iip->ili_item.li_lv_shadow);
-	kmem_cache_free(xfs_ili_zone, iip);
+	kmem_cache_free(xfs_ili_cache, iip);
 }
 
 
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index f9de34d3954a..1a302000d604 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -47,6 +47,6 @@ extern void xfs_iflush_abort(struct xfs_inode *);
 extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
 					 struct xfs_inode_log_format *);
 
-extern struct kmem_cache	*xfs_ili_zone;
+extern struct kmem_cache	*xfs_ili_cache;
 
 #endif	/* __XFS_INODE_ITEM_H__ */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 011055375709..89fec9a18c34 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -21,7 +21,7 @@
 #include "xfs_sb.h"
 #include "xfs_health.h"
 
-struct kmem_cache	*xfs_log_ticket_zone;
+struct kmem_cache	*xfs_log_ticket_cache;
 
 /* Local miscellaneous function prototypes */
 STATIC struct xlog *
@@ -3487,7 +3487,7 @@ xfs_log_ticket_put(
 {
 	ASSERT(atomic_read(&ticket->t_ref) > 0);
 	if (atomic_dec_and_test(&ticket->t_ref))
-		kmem_cache_free(xfs_log_ticket_zone, ticket);
+		kmem_cache_free(xfs_log_ticket_cache, ticket);
 }
 
 xlog_ticket_t *
@@ -3611,7 +3611,7 @@ xlog_ticket_alloc(
 	struct xlog_ticket	*tic;
 	int			unit_res;
 
-	tic = kmem_cache_zalloc(xfs_log_ticket_zone, GFP_NOFS | __GFP_NOFAIL);
+	tic = kmem_cache_zalloc(xfs_log_ticket_cache, GFP_NOFS | __GFP_NOFAIL);
 
 	unit_res = xlog_calc_unit_res(log, unit_bytes);
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 1b03277029c1..23103d68423c 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -497,7 +497,7 @@ xlog_recover_cancel(struct xlog *);
 extern __le32	 xlog_cksum(struct xlog *log, struct xlog_rec_header *rhead,
 			    char *dp, int size);
 
-extern struct kmem_cache *xfs_log_ticket_zone;
+extern struct kmem_cache *xfs_log_ticket_cache;
 struct xlog_ticket *
 xlog_ticket_alloc(
 	struct xlog	*log,
diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index 34c3b16f834f..f85e3b07ab44 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -219,7 +219,7 @@ _xfs_mru_cache_list_insert(
  * When destroying or reaping, all the elements that were migrated to the reap
  * list need to be deleted.  For each element this involves removing it from the
  * data store, removing it from the reap list, calling the client's free
- * function and deleting the element from the element zone.
+ * function and deleting the element from the element cache.
  *
  * We get called holding the mru->lock, which we drop and then reacquire.
  * Sparse need special help with this to tell it we know what we are doing.
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 5e8b70526538..5bb12717ea28 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -11,7 +11,7 @@
 
 struct xfs_inode;
 
-extern struct kmem_cache	*xfs_qm_dqtrxzone;
+extern struct kmem_cache	*xfs_dqtrx_cache;
 
 /*
  * Number of bmaps that we ask from bmapi when doing a quotacheck.
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 0ca8da55053d..f23e86e06bfb 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -21,8 +21,8 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 
-struct kmem_cache	*xfs_cui_zone;
-struct kmem_cache	*xfs_cud_zone;
+struct kmem_cache	*xfs_cui_cache;
+struct kmem_cache	*xfs_cud_cache;
 
 static const struct xfs_item_ops xfs_cui_item_ops;
 
@@ -38,7 +38,7 @@ xfs_cui_item_free(
 	if (cuip->cui_format.cui_nextents > XFS_CUI_MAX_FAST_EXTENTS)
 		kmem_free(cuip);
 	else
-		kmem_cache_free(xfs_cui_zone, cuip);
+		kmem_cache_free(xfs_cui_cache, cuip);
 }
 
 /*
@@ -143,7 +143,7 @@ xfs_cui_init(
 		cuip = kmem_zalloc(xfs_cui_log_item_sizeof(nextents),
 				0);
 	else
-		cuip = kmem_cache_zalloc(xfs_cui_zone,
+		cuip = kmem_cache_zalloc(xfs_cui_cache,
 					 GFP_KERNEL | __GFP_NOFAIL);
 
 	xfs_log_item_init(mp, &cuip->cui_item, XFS_LI_CUI, &xfs_cui_item_ops);
@@ -204,7 +204,7 @@ xfs_cud_item_release(
 	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
 
 	xfs_cui_release(cudp->cud_cuip);
-	kmem_cache_free(xfs_cud_zone, cudp);
+	kmem_cache_free(xfs_cud_cache, cudp);
 }
 
 static const struct xfs_item_ops xfs_cud_item_ops = {
@@ -221,7 +221,7 @@ xfs_trans_get_cud(
 {
 	struct xfs_cud_log_item		*cudp;
 
-	cudp = kmem_cache_zalloc(xfs_cud_zone, GFP_KERNEL | __GFP_NOFAIL);
+	cudp = kmem_cache_zalloc(xfs_cud_cache, GFP_KERNEL | __GFP_NOFAIL);
 	xfs_log_item_init(tp->t_mountp, &cudp->cud_item, XFS_LI_CUD,
 			  &xfs_cud_item_ops);
 	cudp->cud_cuip = cuip;
diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
index 22c69c5a8394..eb0ab13682d0 100644
--- a/fs/xfs/xfs_refcount_item.h
+++ b/fs/xfs/xfs_refcount_item.h
@@ -68,7 +68,7 @@ struct xfs_cud_log_item {
 	struct xfs_cud_log_format	cud_format;
 };
 
-extern struct kmem_cache	*xfs_cui_zone;
-extern struct kmem_cache	*xfs_cud_zone;
+extern struct kmem_cache	*xfs_cui_cache;
+extern struct kmem_cache	*xfs_cud_cache;
 
 #endif	/* __XFS_REFCOUNT_ITEM_H__ */
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index b65987f97b89..b5cdeb10927e 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -21,8 +21,8 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 
-struct kmem_cache	*xfs_rui_zone;
-struct kmem_cache	*xfs_rud_zone;
+struct kmem_cache	*xfs_rui_cache;
+struct kmem_cache	*xfs_rud_cache;
 
 static const struct xfs_item_ops xfs_rui_item_ops;
 
@@ -38,7 +38,7 @@ xfs_rui_item_free(
 	if (ruip->rui_format.rui_nextents > XFS_RUI_MAX_FAST_EXTENTS)
 		kmem_free(ruip);
 	else
-		kmem_cache_free(xfs_rui_zone, ruip);
+		kmem_cache_free(xfs_rui_cache, ruip);
 }
 
 /*
@@ -141,7 +141,7 @@ xfs_rui_init(
 	if (nextents > XFS_RUI_MAX_FAST_EXTENTS)
 		ruip = kmem_zalloc(xfs_rui_log_item_sizeof(nextents), 0);
 	else
-		ruip = kmem_cache_zalloc(xfs_rui_zone,
+		ruip = kmem_cache_zalloc(xfs_rui_cache,
 					 GFP_KERNEL | __GFP_NOFAIL);
 
 	xfs_log_item_init(mp, &ruip->rui_item, XFS_LI_RUI, &xfs_rui_item_ops);
@@ -227,7 +227,7 @@ xfs_rud_item_release(
 	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
 
 	xfs_rui_release(rudp->rud_ruip);
-	kmem_cache_free(xfs_rud_zone, rudp);
+	kmem_cache_free(xfs_rud_cache, rudp);
 }
 
 static const struct xfs_item_ops xfs_rud_item_ops = {
@@ -244,7 +244,7 @@ xfs_trans_get_rud(
 {
 	struct xfs_rud_log_item		*rudp;
 
-	rudp = kmem_cache_zalloc(xfs_rud_zone, GFP_KERNEL | __GFP_NOFAIL);
+	rudp = kmem_cache_zalloc(xfs_rud_cache, GFP_KERNEL | __GFP_NOFAIL);
 	xfs_log_item_init(tp->t_mountp, &rudp->rud_item, XFS_LI_RUD,
 			  &xfs_rud_item_ops);
 	rudp->rud_ruip = ruip;
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index b062b983a82f..802e5119eaca 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -68,7 +68,7 @@ struct xfs_rud_log_item {
 	struct xfs_rud_log_format	rud_format;
 };
 
-extern struct kmem_cache	*xfs_rui_zone;
-extern struct kmem_cache	*xfs_rud_zone;
+extern struct kmem_cache	*xfs_rui_cache;
+extern struct kmem_cache	*xfs_rud_cache;
 
 #endif	/* __XFS_RMAP_ITEM_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6fcafc43b823..0afa47378211 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1952,196 +1952,196 @@ static struct file_system_type xfs_fs_type = {
 MODULE_ALIAS_FS("xfs");
 
 STATIC int __init
-xfs_init_zones(void)
+xfs_init_caches(void)
 {
 	int		error;
 
-	xfs_log_ticket_zone = kmem_cache_create("xfs_log_ticket",
+	xfs_log_ticket_cache = kmem_cache_create("xfs_log_ticket",
 						sizeof(struct xlog_ticket),
 						0, 0, NULL);
-	if (!xfs_log_ticket_zone)
+	if (!xfs_log_ticket_cache)
 		goto out;
 
-	xfs_bmap_free_item_zone = kmem_cache_create("xfs_bmap_free_item",
+	xfs_bmap_free_item_cache = kmem_cache_create("xfs_bmap_free_item",
 					sizeof(struct xfs_extent_free_item),
 					0, 0, NULL);
-	if (!xfs_bmap_free_item_zone)
-		goto out_destroy_log_ticket_zone;
+	if (!xfs_bmap_free_item_cache)
+		goto out_destroy_log_ticket_cache;
 
 	error = xfs_btree_init_cur_caches();
 	if (error)
-		goto out_destroy_bmap_free_item_zone;
+		goto out_destroy_bmap_free_item_cache;
 
-	xfs_da_state_zone = kmem_cache_create("xfs_da_state",
+	xfs_da_state_cache = kmem_cache_create("xfs_da_state",
 					      sizeof(struct xfs_da_state),
 					      0, 0, NULL);
-	if (!xfs_da_state_zone)
-		goto out_destroy_btree_cur_zone;
+	if (!xfs_da_state_cache)
+		goto out_destroy_btree_cur_cache;
 
-	xfs_ifork_zone = kmem_cache_create("xfs_ifork",
+	xfs_ifork_cache = kmem_cache_create("xfs_ifork",
 					   sizeof(struct xfs_ifork),
 					   0, 0, NULL);
-	if (!xfs_ifork_zone)
-		goto out_destroy_da_state_zone;
+	if (!xfs_ifork_cache)
+		goto out_destroy_da_state_cache;
 
-	xfs_trans_zone = kmem_cache_create("xfs_trans",
+	xfs_trans_cache = kmem_cache_create("xfs_trans",
 					   sizeof(struct xfs_trans),
 					   0, 0, NULL);
-	if (!xfs_trans_zone)
-		goto out_destroy_ifork_zone;
+	if (!xfs_trans_cache)
+		goto out_destroy_ifork_cache;
 
 
 	/*
-	 * The size of the zone allocated buf log item is the maximum
+	 * The size of the cache-allocated buf log item is the maximum
 	 * size possible under XFS.  This wastes a little bit of memory,
 	 * but it is much faster.
 	 */
-	xfs_buf_item_zone = kmem_cache_create("xfs_buf_item",
+	xfs_buf_item_cache = kmem_cache_create("xfs_buf_item",
 					      sizeof(struct xfs_buf_log_item),
 					      0, 0, NULL);
-	if (!xfs_buf_item_zone)
-		goto out_destroy_trans_zone;
+	if (!xfs_buf_item_cache)
+		goto out_destroy_trans_cache;
 
-	xfs_efd_zone = kmem_cache_create("xfs_efd_item",
+	xfs_efd_cache = kmem_cache_create("xfs_efd_item",
 					(sizeof(struct xfs_efd_log_item) +
 					(XFS_EFD_MAX_FAST_EXTENTS - 1) *
 					sizeof(struct xfs_extent)),
 					0, 0, NULL);
-	if (!xfs_efd_zone)
-		goto out_destroy_buf_item_zone;
+	if (!xfs_efd_cache)
+		goto out_destroy_buf_item_cache;
 
-	xfs_efi_zone = kmem_cache_create("xfs_efi_item",
+	xfs_efi_cache = kmem_cache_create("xfs_efi_item",
 					 (sizeof(struct xfs_efi_log_item) +
 					 (XFS_EFI_MAX_FAST_EXTENTS - 1) *
 					 sizeof(struct xfs_extent)),
 					 0, 0, NULL);
-	if (!xfs_efi_zone)
-		goto out_destroy_efd_zone;
+	if (!xfs_efi_cache)
+		goto out_destroy_efd_cache;
 
-	xfs_inode_zone = kmem_cache_create("xfs_inode",
+	xfs_inode_cache = kmem_cache_create("xfs_inode",
 					   sizeof(struct xfs_inode), 0,
 					   (SLAB_HWCACHE_ALIGN |
 					    SLAB_RECLAIM_ACCOUNT |
 					    SLAB_MEM_SPREAD | SLAB_ACCOUNT),
 					   xfs_fs_inode_init_once);
-	if (!xfs_inode_zone)
-		goto out_destroy_efi_zone;
+	if (!xfs_inode_cache)
+		goto out_destroy_efi_cache;
 
-	xfs_ili_zone = kmem_cache_create("xfs_ili",
+	xfs_ili_cache = kmem_cache_create("xfs_ili",
 					 sizeof(struct xfs_inode_log_item), 0,
 					 SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
 					 NULL);
-	if (!xfs_ili_zone)
-		goto out_destroy_inode_zone;
+	if (!xfs_ili_cache)
+		goto out_destroy_inode_cache;
 
-	xfs_icreate_zone = kmem_cache_create("xfs_icr",
+	xfs_icreate_cache = kmem_cache_create("xfs_icr",
 					     sizeof(struct xfs_icreate_item),
 					     0, 0, NULL);
-	if (!xfs_icreate_zone)
-		goto out_destroy_ili_zone;
+	if (!xfs_icreate_cache)
+		goto out_destroy_ili_cache;
 
-	xfs_rud_zone = kmem_cache_create("xfs_rud_item",
+	xfs_rud_cache = kmem_cache_create("xfs_rud_item",
 					 sizeof(struct xfs_rud_log_item),
 					 0, 0, NULL);
-	if (!xfs_rud_zone)
-		goto out_destroy_icreate_zone;
+	if (!xfs_rud_cache)
+		goto out_destroy_icreate_cache;
 
-	xfs_rui_zone = kmem_cache_create("xfs_rui_item",
+	xfs_rui_cache = kmem_cache_create("xfs_rui_item",
 			xfs_rui_log_item_sizeof(XFS_RUI_MAX_FAST_EXTENTS),
 			0, 0, NULL);
-	if (!xfs_rui_zone)
-		goto out_destroy_rud_zone;
+	if (!xfs_rui_cache)
+		goto out_destroy_rud_cache;
 
-	xfs_cud_zone = kmem_cache_create("xfs_cud_item",
+	xfs_cud_cache = kmem_cache_create("xfs_cud_item",
 					 sizeof(struct xfs_cud_log_item),
 					 0, 0, NULL);
-	if (!xfs_cud_zone)
-		goto out_destroy_rui_zone;
+	if (!xfs_cud_cache)
+		goto out_destroy_rui_cache;
 
-	xfs_cui_zone = kmem_cache_create("xfs_cui_item",
+	xfs_cui_cache = kmem_cache_create("xfs_cui_item",
 			xfs_cui_log_item_sizeof(XFS_CUI_MAX_FAST_EXTENTS),
 			0, 0, NULL);
-	if (!xfs_cui_zone)
-		goto out_destroy_cud_zone;
+	if (!xfs_cui_cache)
+		goto out_destroy_cud_cache;
 
-	xfs_bud_zone = kmem_cache_create("xfs_bud_item",
+	xfs_bud_cache = kmem_cache_create("xfs_bud_item",
 					 sizeof(struct xfs_bud_log_item),
 					 0, 0, NULL);
-	if (!xfs_bud_zone)
-		goto out_destroy_cui_zone;
+	if (!xfs_bud_cache)
+		goto out_destroy_cui_cache;
 
-	xfs_bui_zone = kmem_cache_create("xfs_bui_item",
+	xfs_bui_cache = kmem_cache_create("xfs_bui_item",
 			xfs_bui_log_item_sizeof(XFS_BUI_MAX_FAST_EXTENTS),
 			0, 0, NULL);
-	if (!xfs_bui_zone)
-		goto out_destroy_bud_zone;
+	if (!xfs_bui_cache)
+		goto out_destroy_bud_cache;
 
 	return 0;
 
- out_destroy_bud_zone:
-	kmem_cache_destroy(xfs_bud_zone);
- out_destroy_cui_zone:
-	kmem_cache_destroy(xfs_cui_zone);
- out_destroy_cud_zone:
-	kmem_cache_destroy(xfs_cud_zone);
- out_destroy_rui_zone:
-	kmem_cache_destroy(xfs_rui_zone);
- out_destroy_rud_zone:
-	kmem_cache_destroy(xfs_rud_zone);
- out_destroy_icreate_zone:
-	kmem_cache_destroy(xfs_icreate_zone);
- out_destroy_ili_zone:
-	kmem_cache_destroy(xfs_ili_zone);
- out_destroy_inode_zone:
-	kmem_cache_destroy(xfs_inode_zone);
- out_destroy_efi_zone:
-	kmem_cache_destroy(xfs_efi_zone);
- out_destroy_efd_zone:
-	kmem_cache_destroy(xfs_efd_zone);
- out_destroy_buf_item_zone:
-	kmem_cache_destroy(xfs_buf_item_zone);
- out_destroy_trans_zone:
-	kmem_cache_destroy(xfs_trans_zone);
- out_destroy_ifork_zone:
-	kmem_cache_destroy(xfs_ifork_zone);
- out_destroy_da_state_zone:
-	kmem_cache_destroy(xfs_da_state_zone);
- out_destroy_btree_cur_zone:
+ out_destroy_bud_cache:
+	kmem_cache_destroy(xfs_bud_cache);
+ out_destroy_cui_cache:
+	kmem_cache_destroy(xfs_cui_cache);
+ out_destroy_cud_cache:
+	kmem_cache_destroy(xfs_cud_cache);
+ out_destroy_rui_cache:
+	kmem_cache_destroy(xfs_rui_cache);
+ out_destroy_rud_cache:
+	kmem_cache_destroy(xfs_rud_cache);
+ out_destroy_icreate_cache:
+	kmem_cache_destroy(xfs_icreate_cache);
+ out_destroy_ili_cache:
+	kmem_cache_destroy(xfs_ili_cache);
+ out_destroy_inode_cache:
+	kmem_cache_destroy(xfs_inode_cache);
+ out_destroy_efi_cache:
+	kmem_cache_destroy(xfs_efi_cache);
+ out_destroy_efd_cache:
+	kmem_cache_destroy(xfs_efd_cache);
+ out_destroy_buf_item_cache:
+	kmem_cache_destroy(xfs_buf_item_cache);
+ out_destroy_trans_cache:
+	kmem_cache_destroy(xfs_trans_cache);
+ out_destroy_ifork_cache:
+	kmem_cache_destroy(xfs_ifork_cache);
+ out_destroy_da_state_cache:
+	kmem_cache_destroy(xfs_da_state_cache);
+ out_destroy_btree_cur_cache:
 	xfs_btree_destroy_cur_caches();
- out_destroy_bmap_free_item_zone:
-	kmem_cache_destroy(xfs_bmap_free_item_zone);
- out_destroy_log_ticket_zone:
-	kmem_cache_destroy(xfs_log_ticket_zone);
+ out_destroy_bmap_free_item_cache:
+	kmem_cache_destroy(xfs_bmap_free_item_cache);
+ out_destroy_log_ticket_cache:
+	kmem_cache_destroy(xfs_log_ticket_cache);
  out:
 	return -ENOMEM;
 }
 
 STATIC void
-xfs_destroy_zones(void)
+xfs_destroy_caches(void)
 {
 	/*
 	 * Make sure all delayed rcu free are flushed before we
 	 * destroy caches.
 	 */
 	rcu_barrier();
-	kmem_cache_destroy(xfs_bui_zone);
-	kmem_cache_destroy(xfs_bud_zone);
-	kmem_cache_destroy(xfs_cui_zone);
-	kmem_cache_destroy(xfs_cud_zone);
-	kmem_cache_destroy(xfs_rui_zone);
-	kmem_cache_destroy(xfs_rud_zone);
-	kmem_cache_destroy(xfs_icreate_zone);
-	kmem_cache_destroy(xfs_ili_zone);
-	kmem_cache_destroy(xfs_inode_zone);
-	kmem_cache_destroy(xfs_efi_zone);
-	kmem_cache_destroy(xfs_efd_zone);
-	kmem_cache_destroy(xfs_buf_item_zone);
-	kmem_cache_destroy(xfs_trans_zone);
-	kmem_cache_destroy(xfs_ifork_zone);
-	kmem_cache_destroy(xfs_da_state_zone);
+	kmem_cache_destroy(xfs_bui_cache);
+	kmem_cache_destroy(xfs_bud_cache);
+	kmem_cache_destroy(xfs_cui_cache);
+	kmem_cache_destroy(xfs_cud_cache);
+	kmem_cache_destroy(xfs_rui_cache);
+	kmem_cache_destroy(xfs_rud_cache);
+	kmem_cache_destroy(xfs_icreate_cache);
+	kmem_cache_destroy(xfs_ili_cache);
+	kmem_cache_destroy(xfs_inode_cache);
+	kmem_cache_destroy(xfs_efi_cache);
+	kmem_cache_destroy(xfs_efd_cache);
+	kmem_cache_destroy(xfs_buf_item_cache);
+	kmem_cache_destroy(xfs_trans_cache);
+	kmem_cache_destroy(xfs_ifork_cache);
+	kmem_cache_destroy(xfs_da_state_cache);
 	xfs_btree_destroy_cur_caches();
-	kmem_cache_destroy(xfs_bmap_free_item_zone);
-	kmem_cache_destroy(xfs_log_ticket_zone);
+	kmem_cache_destroy(xfs_bmap_free_item_cache);
+	kmem_cache_destroy(xfs_log_ticket_cache);
 }
 
 STATIC int __init
@@ -2234,13 +2234,13 @@ init_xfs_fs(void)
 	if (error)
 		goto out;
 
-	error = xfs_init_zones();
+	error = xfs_init_caches();
 	if (error)
 		goto out_destroy_hp;
 
 	error = xfs_init_workqueues();
 	if (error)
-		goto out_destroy_zones;
+		goto out_destroy_caches;
 
 	error = xfs_mru_cache_init();
 	if (error)
@@ -2315,8 +2315,8 @@ init_xfs_fs(void)
 	xfs_mru_cache_uninit();
  out_destroy_wq:
 	xfs_destroy_workqueues();
- out_destroy_zones:
-	xfs_destroy_zones();
+ out_destroy_caches:
+	xfs_destroy_caches();
  out_destroy_hp:
 	xfs_cpu_hotplug_destroy();
  out:
@@ -2339,7 +2339,7 @@ exit_xfs_fs(void)
 	xfs_buf_terminate();
 	xfs_mru_cache_uninit();
 	xfs_destroy_workqueues();
-	xfs_destroy_zones();
+	xfs_destroy_caches();
 	xfs_uuid_table_free();
 	xfs_cpu_hotplug_destroy();
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3faa1baa5a89..234a9d9c2f43 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -25,7 +25,7 @@
 #include "xfs_dquot.h"
 #include "xfs_icache.h"
 
-struct kmem_cache	*xfs_trans_zone;
+struct kmem_cache	*xfs_trans_cache;
 
 #if defined(CONFIG_TRACEPOINTS)
 static void
@@ -76,7 +76,7 @@ xfs_trans_free(
 	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_end_intwrite(tp->t_mountp->m_super);
 	xfs_trans_free_dqinfo(tp);
-	kmem_cache_free(xfs_trans_zone, tp);
+	kmem_cache_free(xfs_trans_cache, tp);
 }
 
 /*
@@ -95,7 +95,7 @@ xfs_trans_dup(
 
 	trace_xfs_trans_dup(tp, _RET_IP_);
 
-	ntp = kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
+	ntp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
 
 	/*
 	 * Initialize the new transaction structure.
@@ -263,7 +263,7 @@ xfs_trans_alloc(
 	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
 	 */
 retry:
-	tp = kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
+	tp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
 	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_start_intwrite(mp->m_super);
 	xfs_trans_set_context(tp);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 88750576dd89..a487b264a9eb 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -237,7 +237,7 @@ void		xfs_trans_buf_set_type(struct xfs_trans *, struct xfs_buf *,
 void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
 					struct xfs_buf *src_bp);
 
-extern struct kmem_cache	*xfs_trans_zone;
+extern struct kmem_cache	*xfs_trans_cache;
 
 static inline struct xfs_log_item *
 xfs_trans_item_relog(
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 3872ce671411..9ba7e6b9bed3 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -846,7 +846,7 @@ STATIC void
 xfs_trans_alloc_dqinfo(
 	xfs_trans_t	*tp)
 {
-	tp->t_dqinfo = kmem_cache_zalloc(xfs_qm_dqtrxzone,
+	tp->t_dqinfo = kmem_cache_zalloc(xfs_dqtrx_cache,
 					 GFP_KERNEL | __GFP_NOFAIL);
 }
 
@@ -856,6 +856,6 @@ xfs_trans_free_dqinfo(
 {
 	if (!tp->t_dqinfo)
 		return;
-	kmem_cache_free(xfs_qm_dqtrxzone, tp->t_dqinfo);
+	kmem_cache_free(xfs_dqtrx_cache, tp->t_dqinfo);
 	tp->t_dqinfo = NULL;
 }

