Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A09C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357765AbiATA1M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:27:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48742 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiATA1M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:27:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF80BB8180B
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EF2C004E1;
        Thu, 20 Jan 2022 00:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638429;
        bh=Y0+TJRca3sH+TWp5Hof+CCmua+3LVo8pvbRNkCu2f/s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=U6zrQDW7+4UFJaAsuLy3aTKctOx+7T+V6BkC+S8pZmP0+eT1twRJtKd13GyoeIr1e
         BVPw0jnEPjSh5QAIwfSOuMd2KusZXrQPWEhQkrIOcS/JSQQbE13BPoEkeC33SK9oOV
         RC2UMsfgyDh668gpi2+nS/vP4rar9ykVZZ9SzpSlmu1D+yoJy7XPIrTVDT7OYhquiv
         9rPG+CIq+1p/RD8SQwjnt/IS3Z5E4KVYMDWoeYz5jX7wXxU+ARTpEht6LM5swGQeBJ
         M+VLgoVgqIKHtBSyeuz6JnWKjiNLZETmidT+fSxQuxYTkyb6Byfee8p4yaSXrbqN4x
         uiRzyDwV4sqnw==
Subject: [PATCH 43/48] xfs: rename xfs_bmap_add_free to xfs_free_extent_later
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:27:09 -0800
Message-ID: <164263842911.865554.6161469106705967318.stgit@magnolia>
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

Source kernel commit: c201d9ca5392b20f04882848a071025b0e194c17

xfs_bmap_add_free isn't a block mapping function; it schedules deferred
freeing operations for a later point in a compound transaction chain.
While it's primarily used by bunmapi, its use has expanded beyond that.
Move it to xfs_alloc.c and rename the function since it's now general
freeing functionality.  Bring the slab cache bits in line with the
way we handle the other intent items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c      |    6 ++--
 libxfs/init.c            |    3 --
 libxfs/libxfs_api_defs.h |    1 -
 libxfs/xfs_ag.c          |    2 +
 libxfs/xfs_alloc.c       |   71 +++++++++++++++++++++++++++++++++++++++++++---
 libxfs/xfs_alloc.h       |   32 +++++++++++++++++++++
 libxfs/xfs_bmap.c        |   55 +-----------------------------------
 libxfs/xfs_bmap.h        |   28 ------------------
 libxfs/xfs_bmap_btree.c  |    2 +
 libxfs/xfs_defer.c       |    5 +++
 libxfs/xfs_ialloc.c      |    4 +--
 libxfs/xfs_refcount.c    |    6 ++--
 12 files changed, 116 insertions(+), 99 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 1277469f..e7cba838 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -82,7 +82,7 @@ xfs_extent_free_finish_item(
 	error = xfs_free_extent(tp, free->xefi_startblock,
 			free->xefi_blockcount, &free->xefi_oinfo,
 			XFS_AG_RESV_NONE);
-	kmem_cache_free(xfs_bmap_free_item_cache, free);
+	kmem_cache_free(xfs_extfree_item_cache, free);
 	return error;
 }
 
@@ -101,7 +101,7 @@ xfs_extent_free_cancel_item(
 	struct xfs_extent_free_item	*free;
 
 	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	kmem_cache_free(xfs_bmap_free_item_cache, free);
+	kmem_cache_free(xfs_extfree_item_cache, free);
 }
 
 const struct xfs_defer_op_type xfs_extent_free_defer_type = {
@@ -139,7 +139,7 @@ xfs_agfl_free_finish_item(
 	if (!error)
 		error = xfs_free_agfl_block(tp, agno, agbno, agbp,
 					    &free->xefi_oinfo);
-	kmem_cache_free(xfs_bmap_free_item_cache, free);
+	kmem_cache_free(xfs_extfree_item_cache, free);
 	return error;
 }
 
diff --git a/libxfs/init.c b/libxfs/init.c
index f6863f4c..94a80234 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -259,8 +259,6 @@ init_caches(void)
 		abort();
 	}
 
-	xfs_bmap_free_item_cache = kmem_cache_create("xfs_bmap_free_item",
-			sizeof(struct xfs_extent_free_item), 0, 0, NULL);
 	xfs_trans_cache = kmem_cache_create("xfs_trans",
 			sizeof(struct xfs_trans), 0, 0, NULL);
 }
@@ -276,7 +274,6 @@ destroy_kmem_caches(void)
 	kmem_cache_destroy(xfs_da_state_cache);
 	xfs_defer_destroy_item_caches();
 	xfs_btree_destroy_cur_caches();
-	kmem_cache_destroy(xfs_bmap_free_item_cache);
 	kmem_cache_destroy(xfs_trans_cache);
 }
 
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 8abbd231..064fb48c 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -36,7 +36,6 @@
 #define xfs_attr_namecheck		libxfs_attr_namecheck
 #define xfs_attr_set			libxfs_attr_set
 
-#define __xfs_bmap_add_free		__libxfs_bmap_add_free
 #define xfs_bmapi_read			libxfs_bmapi_read
 #define xfs_bmapi_write			libxfs_bmapi_write
 #define xfs_bmap_last_offset		libxfs_bmap_last_offset
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index c95e8b26..c8181d7f 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -850,7 +850,7 @@ xfs_ag_shrink_space(
 		if (err2 != -ENOSPC)
 			goto resv_err;
 
-		__xfs_bmap_add_free(*tpp, args.fsbno, delta, NULL, true);
+		__xfs_free_extent_later(*tpp, args.fsbno, delta, NULL, true);
 
 		/*
 		 * Roll the transaction before trying to re-init the per-ag
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 06e870a8..f1da8292 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -23,7 +23,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
 
-extern struct kmem_cache	*xfs_bmap_free_item_cache;
+struct kmem_cache	*xfs_extfree_item_cache;
 
 struct workqueue_struct *xfs_alloc_wq;
 
@@ -2436,7 +2436,7 @@ xfs_agfl_reset(
 
 /*
  * Defer an AGFL block free. This is effectively equivalent to
- * xfs_bmap_add_free() with some special handling particular to AGFL blocks.
+ * xfs_free_extent_later() with some special handling particular to AGFL blocks.
  *
  * Deferring AGFL frees helps prevent log reservation overruns due to too many
  * allocation operations in a transaction. AGFL frees are prone to this problem
@@ -2455,10 +2455,10 @@ xfs_defer_agfl_block(
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_extent_free_item	*new;		/* new element */
 
-	ASSERT(xfs_bmap_free_item_cache != NULL);
+	ASSERT(xfs_extfree_item_cache != NULL);
 	ASSERT(oinfo != NULL);
 
-	new = kmem_cache_alloc(xfs_bmap_free_item_cache,
+	new = kmem_cache_alloc(xfs_extfree_item_cache,
 			       GFP_KERNEL | __GFP_NOFAIL);
 	new->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
 	new->xefi_blockcount = 1;
@@ -2470,6 +2470,52 @@ xfs_defer_agfl_block(
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
 }
 
+/*
+ * Add the extent to the list of extents to be free at transaction end.
+ * The list is maintained sorted (by block number).
+ */
+void
+__xfs_free_extent_later(
+	struct xfs_trans		*tp,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
+	const struct xfs_owner_info	*oinfo,
+	bool				skip_discard)
+{
+	struct xfs_extent_free_item	*new;		/* new element */
+#ifdef DEBUG
+	struct xfs_mount		*mp = tp->t_mountp;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+
+	ASSERT(bno != NULLFSBLOCK);
+	ASSERT(len > 0);
+	ASSERT(len <= MAXEXTLEN);
+	ASSERT(!isnullstartblock(bno));
+	agno = XFS_FSB_TO_AGNO(mp, bno);
+	agbno = XFS_FSB_TO_AGBNO(mp, bno);
+	ASSERT(agno < mp->m_sb.sb_agcount);
+	ASSERT(agbno < mp->m_sb.sb_agblocks);
+	ASSERT(len < mp->m_sb.sb_agblocks);
+	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
+#endif
+	ASSERT(xfs_extfree_item_cache != NULL);
+
+	new = kmem_cache_alloc(xfs_extfree_item_cache,
+			       GFP_KERNEL | __GFP_NOFAIL);
+	new->xefi_startblock = bno;
+	new->xefi_blockcount = (xfs_extlen_t)len;
+	if (oinfo)
+		new->xefi_oinfo = *oinfo;
+	else
+		new->xefi_oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
+	new->xefi_skip_discard = skip_discard;
+	trace_xfs_bmap_free_defer(tp->t_mountp,
+			XFS_FSB_TO_AGNO(tp->t_mountp, bno), 0,
+			XFS_FSB_TO_AGBNO(tp->t_mountp, bno), len);
+	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &new->xefi_list);
+}
+
 #ifdef DEBUG
 /*
  * Check if an AGF has a free extent record whose length is equal to
@@ -3495,3 +3541,20 @@ xfs_agfl_walk(
 
 	return 0;
 }
+
+int __init
+xfs_extfree_intent_init_cache(void)
+{
+	xfs_extfree_item_cache = kmem_cache_create("xfs_extfree_intent",
+			sizeof(struct xfs_extent_free_item),
+			0, 0, NULL);
+
+	return xfs_extfree_item_cache != NULL ? 0 : -ENOMEM;
+}
+
+void
+xfs_extfree_intent_destroy_cache(void)
+{
+	kmem_cache_destroy(xfs_extfree_item_cache);
+	xfs_extfree_item_cache = NULL;
+}
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 2f3f8c2e..b61aeb6f 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -248,4 +248,36 @@ xfs_buf_to_agfl_bno(
 	return bp->b_addr;
 }
 
+void __xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
+		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
+		bool skip_discard);
+
+/*
+ * List of extents to be free "later".
+ * The list is kept sorted on xbf_startblock.
+ */
+struct xfs_extent_free_item {
+	struct list_head	xefi_list;
+	xfs_fsblock_t		xefi_startblock;/* starting fs block number */
+	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
+	bool			xefi_skip_discard;
+	struct xfs_owner_info	xefi_oinfo;	/* extent owner */
+};
+
+static inline void
+xfs_free_extent_later(
+	struct xfs_trans		*tp,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
+	const struct xfs_owner_info	*oinfo)
+{
+	__xfs_free_extent_later(tp, bno, len, oinfo, false);
+}
+
+
+extern struct kmem_cache	*xfs_extfree_item_cache;
+
+int __init xfs_extfree_intent_init_cache(void);
+void xfs_extfree_intent_destroy_cache(void);
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index c261d119..8906265a 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -31,7 +31,6 @@
 #include "xfs_refcount.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
-struct kmem_cache		*xfs_bmap_free_item_cache;
 
 /*
  * Miscellaneous helper functions
@@ -515,56 +514,6 @@ xfs_bmap_validate_ret(
 #define	xfs_bmap_validate_ret(bno,len,flags,mval,onmap,nmap)	do { } while (0)
 #endif /* DEBUG */
 
-/*
- * bmap free list manipulation functions
- */
-
-/*
- * Add the extent to the list of extents to be free at transaction end.
- * The list is maintained sorted (by block number).
- */
-void
-__xfs_bmap_add_free(
-	struct xfs_trans		*tp,
-	xfs_fsblock_t			bno,
-	xfs_filblks_t			len,
-	const struct xfs_owner_info	*oinfo,
-	bool				skip_discard)
-{
-	struct xfs_extent_free_item	*new;		/* new element */
-#ifdef DEBUG
-	struct xfs_mount		*mp = tp->t_mountp;
-	xfs_agnumber_t			agno;
-	xfs_agblock_t			agbno;
-
-	ASSERT(bno != NULLFSBLOCK);
-	ASSERT(len > 0);
-	ASSERT(len <= MAXEXTLEN);
-	ASSERT(!isnullstartblock(bno));
-	agno = XFS_FSB_TO_AGNO(mp, bno);
-	agbno = XFS_FSB_TO_AGBNO(mp, bno);
-	ASSERT(agno < mp->m_sb.sb_agcount);
-	ASSERT(agbno < mp->m_sb.sb_agblocks);
-	ASSERT(len < mp->m_sb.sb_agblocks);
-	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
-#endif
-	ASSERT(xfs_bmap_free_item_cache != NULL);
-
-	new = kmem_cache_alloc(xfs_bmap_free_item_cache,
-			       GFP_KERNEL | __GFP_NOFAIL);
-	new->xefi_startblock = bno;
-	new->xefi_blockcount = (xfs_extlen_t)len;
-	if (oinfo)
-		new->xefi_oinfo = *oinfo;
-	else
-		new->xefi_oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
-	new->xefi_skip_discard = skip_discard;
-	trace_xfs_bmap_free_defer(tp->t_mountp,
-			XFS_FSB_TO_AGNO(tp->t_mountp, bno), 0,
-			XFS_FSB_TO_AGBNO(tp->t_mountp, bno), len);
-	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &new->xefi_list);
-}
-
 /*
  * Inode fork format manipulation functions
  */
@@ -619,7 +568,7 @@ xfs_bmap_btree_to_extents(
 	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
 		return error;
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
-	xfs_bmap_add_free(cur->bc_tp, cbno, 1, &oinfo);
+	xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo);
 	ip->i_nblocks--;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
@@ -5290,7 +5239,7 @@ xfs_bmap_del_extent_real(
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
 			xfs_refcount_decrease_extent(tp, del);
 		} else {
-			__xfs_bmap_add_free(tp, del->br_startblock,
+			__xfs_free_extent_later(tp, del->br_startblock,
 					del->br_blockcount, NULL,
 					(bflags & XFS_BMAPI_NODISCARD) ||
 					del->br_state == XFS_EXT_UNWRITTEN);
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index fa73a568..03d9aaf8 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -13,8 +13,6 @@ struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
 
-extern struct kmem_cache	*xfs_bmap_free_item_cache;
-
 /*
  * Argument structure for xfs_bmap_alloc.
  */
@@ -44,19 +42,6 @@ struct xfs_bmalloca {
 	int			flags;
 };
 
-/*
- * List of extents to be free "later".
- * The list is kept sorted on xbf_startblock.
- */
-struct xfs_extent_free_item
-{
-	xfs_fsblock_t		xefi_startblock;/* starting fs block number */
-	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
-	bool			xefi_skip_discard;
-	struct list_head	xefi_list;
-	struct xfs_owner_info	xefi_oinfo;	/* extent owner */
-};
-
 #define	XFS_BMAP_MAX_NMAP	4
 
 /*
@@ -189,9 +174,6 @@ unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork);
-void	__xfs_bmap_add_free(struct xfs_trans *tp, xfs_fsblock_t bno,
-		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
-		bool skip_discard);
 void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
 int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
@@ -239,16 +221,6 @@ int	xfs_bmap_add_extent_unwritten_real(struct xfs_trans *tp,
 		struct xfs_iext_cursor *icur, struct xfs_btree_cur **curp,
 		struct xfs_bmbt_irec *new, int *logflagsp);
 
-static inline void
-xfs_bmap_add_free(
-	struct xfs_trans		*tp,
-	xfs_fsblock_t			bno,
-	xfs_filblks_t			len,
-	const struct xfs_owner_info	*oinfo)
-{
-	__xfs_bmap_add_free(tp, bno, len, oinfo, false);
-}
-
 enum xfs_bmap_intent_type {
 	XFS_BMAP_MAP = 1,
 	XFS_BMAP_UNMAP,
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 8e850751..ba239d6e 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -286,7 +286,7 @@ xfs_bmbt_free_block(
 	struct xfs_owner_info	oinfo;
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
-	xfs_bmap_add_free(cur->bc_tp, fsbno, 1, &oinfo);
+	xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo);
 	ip->i_nblocks--;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index f71bb055..ece44692 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -17,6 +17,7 @@
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
 #include "xfs_bmap.h"
+#include "xfs_alloc.h"
 
 static struct kmem_cache	*xfs_defer_pending_cache;
 
@@ -844,6 +845,9 @@ xfs_defer_init_item_caches(void)
 	if (error)
 		goto err;
 	error = xfs_bmap_intent_init_cache();
+	if (error)
+		goto err;
+	error = xfs_extfree_intent_init_cache();
 	if (error)
 		goto err;
 
@@ -857,6 +861,7 @@ xfs_defer_init_item_caches(void)
 void
 xfs_defer_destroy_item_caches(void)
 {
+	xfs_extfree_intent_destroy_cache();
 	xfs_bmap_intent_destroy_cache();
 	xfs_refcount_intent_destroy_cache();
 	xfs_rmap_intent_destroy_cache();
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index b18ddc4e..82d6a3e8 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1822,7 +1822,7 @@ xfs_difree_inode_chunk(
 
 	if (!xfs_inobt_issparse(rec->ir_holemask)) {
 		/* not sparse, calculate extent info directly */
-		xfs_bmap_add_free(tp, XFS_AGB_TO_FSB(mp, agno, sagbno),
+		xfs_free_extent_later(tp, XFS_AGB_TO_FSB(mp, agno, sagbno),
 				  M_IGEO(mp)->ialloc_blks,
 				  &XFS_RMAP_OINFO_INODES);
 		return;
@@ -1867,7 +1867,7 @@ xfs_difree_inode_chunk(
 
 		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
-		xfs_bmap_add_free(tp, XFS_AGB_TO_FSB(mp, agno, agbno),
+		xfs_free_extent_later(tp, XFS_AGB_TO_FSB(mp, agno, agbno),
 				  contigblk, &XFS_RMAP_OINFO_INODES);
 
 		/* reset range to current bit and carry on... */
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index da3cd7d5..6bc43f44 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -975,7 +975,7 @@ xfs_refcount_adjust_extents(
 				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
 						cur->bc_ag.pag->pag_agno,
 						tmp.rc_startblock);
-				xfs_bmap_add_free(cur->bc_tp, fsbno,
+				xfs_free_extent_later(cur->bc_tp, fsbno,
 						  tmp.rc_blockcount, oinfo);
 			}
 
@@ -1020,7 +1020,7 @@ xfs_refcount_adjust_extents(
 			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
 					cur->bc_ag.pag->pag_agno,
 					ext.rc_startblock);
-			xfs_bmap_add_free(cur->bc_tp, fsbno, ext.rc_blockcount,
+			xfs_free_extent_later(cur->bc_tp, fsbno, ext.rc_blockcount,
 					  oinfo);
 		}
 
@@ -1743,7 +1743,7 @@ xfs_refcount_recover_cow_leftovers(
 				rr->rr_rrec.rc_blockcount);
 
 		/* Free the block. */
-		xfs_bmap_add_free(tp, fsb, rr->rr_rrec.rc_blockcount, NULL);
+		xfs_free_extent_later(tp, fsb, rr->rr_rrec.rc_blockcount, NULL);
 
 		error = xfs_trans_commit(tp);
 		if (error)

