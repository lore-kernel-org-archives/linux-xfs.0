Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54526C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Oct 2021 18:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D0BD60EFE
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Oct 2021 18:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbhJSSyh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Oct 2021 14:54:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234715AbhJSSyh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Oct 2021 14:54:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0050E60E90;
        Tue, 19 Oct 2021 18:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634669544;
        bh=zAgZAYVZqkmO4ZJJmRWjjiOYBtpsnRsAI6wp5+l38cg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oWF3Srx4KPLw6bjGc5Wr9uDct9xytNbWEVGz5N9R/Its3wNOOiAHxZXo/695JGWsf
         /WdlQe/RTNUaYmoDnwIw4eyUwxboX40POrgl8efOw3qplvyeZQILjAca+9BZO0yUhF
         2hTaOdidmOb2KPR55s4JkUzGxwwcVgJql40t7tKGRlXed6FXPu7fhAxSa6hp69/+NF
         GcJ2eDizi4spVGmt+fLKSHOp2pI666uBv7zUOsGV9KW+s7vSJvQ0AGP7qW3wNydX7Z
         84s4VqvaCOfzB5UQU7uMVRdCQsICeoV0BVehHuo2xtOzhQLLuT9+0IP9cJyClYvUrU
         u+zoN1NFVYpxw==
Subject: [PATCH 3/5] xfs: rename xfs_bmap_add_free to xfs_free_extent_later
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 19 Oct 2021 11:52:23 -0700
Message-ID: <163466954368.2235671.8432324789208917382.stgit@magnolia>
In-Reply-To: <163466952709.2235671.6966476326124447013.stgit@magnolia>
References: <163466952709.2235671.6966476326124447013.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

xfs_bmap_add_free isn't a block mapping function; it schedules deferred
freeing operations for a later point in a compound transaction chain.
While it's primarily used by bunmapi, its use has expanded beyond that.
Move it to xfs_alloc.c and rename the function since it's now general
freeing functionality.  Bring the slab cache bits in line with the
way we handle the other intent items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c         |    2 +
 fs/xfs/libxfs/xfs_alloc.c      |   71 ++++++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_alloc.h      |   32 ++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.c       |   55 +------------------------------
 fs/xfs/libxfs/xfs_bmap.h       |   28 ----------------
 fs/xfs/libxfs/xfs_bmap_btree.c |    2 +
 fs/xfs/libxfs/xfs_defer.c      |    5 +++
 fs/xfs/libxfs/xfs_ialloc.c     |    4 +-
 fs/xfs/libxfs/xfs_refcount.c   |    6 ++-
 fs/xfs/xfs_extfree_item.c      |    6 ++-
 fs/xfs/xfs_reflink.c           |    2 +
 fs/xfs/xfs_super.c             |   11 +-----
 12 files changed, 118 insertions(+), 106 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 005abfd9fd34..d7d875cef07a 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -850,7 +850,7 @@ xfs_ag_shrink_space(
 		if (err2 != -ENOSPC)
 			goto resv_err;
 
-		__xfs_bmap_add_free(*tpp, args.fsbno, delta, NULL, true);
+		__xfs_free_extent_later(*tpp, args.fsbno, delta, NULL, true);
 
 		/*
 		 * Roll the transaction before trying to re-init the per-ag
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ccfe66df3e62..9bc1a03a8167 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -27,7 +27,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
 
-extern struct kmem_cache	*xfs_bmap_free_item_cache;
+struct kmem_cache	*xfs_extfree_item_cache;
 
 struct workqueue_struct *xfs_alloc_wq;
 
@@ -2440,7 +2440,7 @@ xfs_agfl_reset(
 
 /*
  * Defer an AGFL block free. This is effectively equivalent to
- * xfs_bmap_add_free() with some special handling particular to AGFL blocks.
+ * xfs_free_extent_later() with some special handling particular to AGFL blocks.
  *
  * Deferring AGFL frees helps prevent log reservation overruns due to too many
  * allocation operations in a transaction. AGFL frees are prone to this problem
@@ -2459,10 +2459,10 @@ xfs_defer_agfl_block(
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
@@ -2474,6 +2474,52 @@ xfs_defer_agfl_block(
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
@@ -3499,3 +3545,20 @@ xfs_agfl_walk(
 
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
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 2f3f8c2e0860..b61aeb6fbe32 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
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
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ef2ac0ecaed9..4dccd4d90622 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -38,7 +38,6 @@
 #include "xfs_iomap.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
-struct kmem_cache		*xfs_bmap_free_item_cache;
 
 /*
  * Miscellaneous helper functions
@@ -522,56 +521,6 @@ xfs_bmap_validate_ret(
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
@@ -626,7 +575,7 @@ xfs_bmap_btree_to_extents(
 	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
 		return error;
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
-	xfs_bmap_add_free(cur->bc_tp, cbno, 1, &oinfo);
+	xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo);
 	ip->i_nblocks--;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
@@ -5297,7 +5246,7 @@ xfs_bmap_del_extent_real(
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
 			xfs_refcount_decrease_extent(tp, del);
 		} else {
-			__xfs_bmap_add_free(tp, del->br_startblock,
+			__xfs_free_extent_later(tp, del->br_startblock,
 					del->br_blockcount, NULL,
 					(bflags & XFS_BMAPI_NODISCARD) ||
 					del->br_state == XFS_EXT_UNWRITTEN);
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index fa73a56827b1..03d9aaf87413 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
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
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 3c9a45233e60..453309fc85f2 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -288,7 +288,7 @@ xfs_bmbt_free_block(
 	struct xfs_owner_info	oinfo;
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
-	xfs_bmap_add_free(cur->bc_tp, fsbno, 1, &oinfo);
+	xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo);
 	ip->i_nblocks--;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 641a5dee4ffc..3c43e5c93e7b 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -21,6 +21,7 @@
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
 #include "xfs_bmap.h"
+#include "xfs_alloc.h"
 
 static struct kmem_cache	*xfs_defer_pending_cache;
 
@@ -848,6 +849,9 @@ xfs_defer_init_item_caches(void)
 	if (error)
 		return error;
 	error = xfs_bmap_intent_init_cache();
+	if (error)
+		return error;
+	error = xfs_extfree_intent_init_cache();
 	if (error)
 		return error;
 
@@ -858,6 +862,7 @@ xfs_defer_init_item_caches(void)
 void
 xfs_defer_destroy_item_caches(void)
 {
+	xfs_extfree_intent_destroy_cache();
 	xfs_bmap_intent_destroy_cache();
 	xfs_refcount_intent_destroy_cache();
 	xfs_rmap_intent_destroy_cache();
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index f78a600ca73f..b418fe0c0679 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1827,7 +1827,7 @@ xfs_difree_inode_chunk(
 
 	if (!xfs_inobt_issparse(rec->ir_holemask)) {
 		/* not sparse, calculate extent info directly */
-		xfs_bmap_add_free(tp, XFS_AGB_TO_FSB(mp, agno, sagbno),
+		xfs_free_extent_later(tp, XFS_AGB_TO_FSB(mp, agno, sagbno),
 				  M_IGEO(mp)->ialloc_blks,
 				  &XFS_RMAP_OINFO_INODES);
 		return;
@@ -1872,7 +1872,7 @@ xfs_difree_inode_chunk(
 
 		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
-		xfs_bmap_add_free(tp, XFS_AGB_TO_FSB(mp, agno, agbno),
+		xfs_free_extent_later(tp, XFS_AGB_TO_FSB(mp, agno, agbno),
 				  contigblk, &XFS_RMAP_OINFO_INODES);
 
 		/* reset range to current bit and carry on... */
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 2c03df715d4f..bb9e256f4970 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -976,7 +976,7 @@ xfs_refcount_adjust_extents(
 				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
 						cur->bc_ag.pag->pag_agno,
 						tmp.rc_startblock);
-				xfs_bmap_add_free(cur->bc_tp, fsbno,
+				xfs_free_extent_later(cur->bc_tp, fsbno,
 						  tmp.rc_blockcount, oinfo);
 			}
 
@@ -1021,7 +1021,7 @@ xfs_refcount_adjust_extents(
 			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
 					cur->bc_ag.pag->pag_agno,
 					ext.rc_startblock);
-			xfs_bmap_add_free(cur->bc_tp, fsbno, ext.rc_blockcount,
+			xfs_free_extent_later(cur->bc_tp, fsbno, ext.rc_blockcount,
 					  oinfo);
 		}
 
@@ -1744,7 +1744,7 @@ xfs_refcount_recover_cow_leftovers(
 				rr->rr_rrec.rc_blockcount);
 
 		/* Free the block. */
-		xfs_bmap_add_free(tp, fsb, rr->rr_rrec.rc_blockcount, NULL);
+		xfs_free_extent_later(tp, fsb, rr->rr_rrec.rc_blockcount, NULL);
 
 		error = xfs_trans_commit(tp);
 		if (error)
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 26ac5048ce76..eb378e345f13 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -482,7 +482,7 @@ xfs_extent_free_finish_item(
 			free->xefi_startblock,
 			free->xefi_blockcount,
 			&free->xefi_oinfo, free->xefi_skip_discard);
-	kmem_cache_free(xfs_bmap_free_item_cache, free);
+	kmem_cache_free(xfs_extfree_item_cache, free);
 	return error;
 }
 
@@ -502,7 +502,7 @@ xfs_extent_free_cancel_item(
 	struct xfs_extent_free_item	*free;
 
 	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	kmem_cache_free(xfs_bmap_free_item_cache, free);
+	kmem_cache_free(xfs_extfree_item_cache, free);
 }
 
 const struct xfs_defer_op_type xfs_extent_free_defer_type = {
@@ -564,7 +564,7 @@ xfs_agfl_free_finish_item(
 	extp->ext_len = free->xefi_blockcount;
 	efdp->efd_next_extent++;
 
-	kmem_cache_free(xfs_bmap_free_item_cache, free);
+	kmem_cache_free(xfs_extfree_item_cache, free);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 76355f293488..cb0edb1d68ef 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -484,7 +484,7 @@ xfs_reflink_cancel_cow_blocks(
 			xfs_refcount_free_cow_extent(*tpp, del.br_startblock,
 					del.br_blockcount);
 
-			xfs_bmap_add_free(*tpp, del.br_startblock,
+			xfs_free_extent_later(*tpp, del.br_startblock,
 					  del.br_blockcount, NULL);
 
 			/* Roll the transaction */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8909e08cbf77..daa6d76b8dd0 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1963,15 +1963,9 @@ xfs_init_caches(void)
 	if (!xfs_log_ticket_cache)
 		goto out;
 
-	xfs_bmap_free_item_cache = kmem_cache_create("xfs_bmap_free_item",
-					sizeof(struct xfs_extent_free_item),
-					0, 0, NULL);
-	if (!xfs_bmap_free_item_cache)
-		goto out_destroy_log_ticket_cache;
-
 	error = xfs_btree_init_cur_caches();
 	if (error)
-		goto out_destroy_bmap_free_item_cache;
+		goto out_destroy_log_ticket_cache;
 
 	error = xfs_defer_init_item_caches();
 	if (error)
@@ -2115,8 +2109,6 @@ xfs_init_caches(void)
 	xfs_defer_destroy_item_caches();
  out_destroy_btree_cur_cache:
 	xfs_btree_destroy_cur_caches();
- out_destroy_bmap_free_item_cache:
-	kmem_cache_destroy(xfs_bmap_free_item_cache);
  out_destroy_log_ticket_cache:
 	kmem_cache_destroy(xfs_log_ticket_cache);
  out:
@@ -2148,7 +2140,6 @@ xfs_destroy_caches(void)
 	kmem_cache_destroy(xfs_da_state_cache);
 	xfs_btree_destroy_cur_caches();
 	xfs_defer_destroy_item_caches();
-	kmem_cache_destroy(xfs_bmap_free_item_cache);
 	kmem_cache_destroy(xfs_log_ticket_cache);
 }
 

