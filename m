Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA14C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ABCE60F3A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbhJLXf7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:35:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235840AbhJLXf6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 19:35:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A334060ED4;
        Tue, 12 Oct 2021 23:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634081636;
        bh=dGuD/x1oXCIeVu9Rf401sWLdANsdMfnnp3dVlPP3nzo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YM4HfJHbYYzRZOReFOXwKR+0okbUWMA72CfGojc0+YxutLqk2c94Oo51hWp+yHfE7
         S4ruwJyS1ZuWpsokPHrJETm4cFVpSGAwQ5sdlWYsvOIy3QEUR+GuuQPyNEe6pELreJ
         TLzeyaMSQf7mlusY7I7YYLi41TYzMnrG7Pb36r7qWh3ckhmUJS0zdEQWdoQtVAy48y
         sKzN1XJM/r3OmraS90J63jHfvXSoGMx1mOt39AKW4U1gcOf+jrO0U3kQPRq9jBIu/p
         2Ifl+t+xdE0DRGNfB2vnOGl4dCkD2RFtt9aKfSTnk/83Ue6VroFIEyAYEXkuyxEAup
         l5SVJYKowzRXA==
Subject: [PATCH 15/15] xfs: use separate btree cursor cache for each btree
 type
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Date:   Tue, 12 Oct 2021 16:33:56 -0700
Message-ID: <163408163634.4151249.5333674876821248862.stgit@magnolia>
In-Reply-To: <163408155346.4151249.8364703447365270670.stgit@magnolia>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we have the infrastructure to track the max possible height of
each btree type, we can create a separate slab cache for cursors of each
type of btree.  For smaller indices like the free space btrees, this
means that we can pack more cursors into a slab page, improving slab
utilization.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |   21 ++++++++++++++
 fs/xfs/libxfs/xfs_alloc_btree.h    |    3 ++
 fs/xfs/libxfs/xfs_bmap_btree.c     |   21 ++++++++++++++
 fs/xfs/libxfs/xfs_bmap_btree.h     |    3 ++
 fs/xfs/libxfs/xfs_btree.c          |    7 +----
 fs/xfs/libxfs/xfs_btree.h          |   17 +++---------
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   21 ++++++++++++++
 fs/xfs/libxfs/xfs_ialloc_btree.h   |    3 ++
 fs/xfs/libxfs/xfs_refcount_btree.c |   21 ++++++++++++++
 fs/xfs/libxfs/xfs_refcount_btree.h |    3 ++
 fs/xfs/libxfs/xfs_rmap_btree.c     |   21 ++++++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.h     |    3 ++
 fs/xfs/xfs_super.c                 |   53 ++++++++++++++++++++++++++++++++----
 13 files changed, 168 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 61f6d266b822..4c5942146b05 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -20,6 +20,7 @@
 #include "xfs_trans.h"
 #include "xfs_ag.h"
 
+static kmem_zone_t	*xfs_allocbt_cur_cache;
 
 STATIC struct xfs_btree_cur *
 xfs_allocbt_dup_cursor(
@@ -477,7 +478,8 @@ xfs_allocbt_init_common(
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
-	cur = xfs_btree_alloc_cursor(mp, tp, btnum, mp->m_ag_maxlevels);
+	cur = xfs_btree_alloc_cursor(mp, tp, btnum, mp->m_ag_maxlevels,
+			xfs_allocbt_cur_cache);
 	cur->bc_ag.abt.active = false;
 
 	if (btnum == XFS_BTNUM_CNT) {
@@ -603,3 +605,20 @@ xfs_allocbt_calc_size(
 {
 	return xfs_btree_calc_size(mp->m_alloc_mnr, len);
 }
+
+int __init
+xfs_allocbt_init_cur_cache(void)
+{
+	xfs_allocbt_cur_cache = kmem_cache_create("xfs_bnobt_cur",
+			xfs_btree_cur_sizeof(xfs_allocbt_absolute_maxlevels()),
+			0, 0, NULL);
+
+	return xfs_allocbt_cur_cache != NULL ? 0 : -ENOMEM;
+}
+
+void
+xfs_allocbt_destroy_cur_cache(void)
+{
+	kmem_cache_destroy(xfs_allocbt_cur_cache);
+	xfs_allocbt_cur_cache = NULL;
+}
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
index c47d0e285435..82a9b3201f91 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.h
+++ b/fs/xfs/libxfs/xfs_alloc_btree.h
@@ -62,4 +62,7 @@ void xfs_allocbt_commit_staged_btree(struct xfs_btree_cur *cur,
 
 unsigned int xfs_allocbt_absolute_maxlevels(void);
 
+int __init xfs_allocbt_init_cur_cache(void);
+void xfs_allocbt_destroy_cur_cache(void);
+
 #endif	/* __XFS_ALLOC_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 7001aff639d2..99261d51d2c3 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -22,6 +22,8 @@
 #include "xfs_trace.h"
 #include "xfs_rmap.h"
 
+static kmem_zone_t	*xfs_bmbt_cur_cache;
+
 /*
  * Convert on-disk form of btree root to in-memory form.
  */
@@ -553,7 +555,7 @@ xfs_bmbt_init_cursor(
 	ASSERT(whichfork != XFS_COW_FORK);
 
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP,
-			mp->m_bm_maxlevels[whichfork]);
+			mp->m_bm_maxlevels[whichfork], xfs_bmbt_cur_cache);
 	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
@@ -664,3 +666,20 @@ xfs_bmbt_calc_size(
 {
 	return xfs_btree_calc_size(mp->m_bmap_dmnr, len);
 }
+
+int __init
+xfs_bmbt_init_cur_cache(void)
+{
+	xfs_bmbt_cur_cache = kmem_cache_create("xfs_bmbt_cur",
+			xfs_btree_cur_sizeof(xfs_bmbt_absolute_maxlevels()),
+			0, 0, NULL);
+
+	return xfs_bmbt_cur_cache != NULL ? 0 : -ENOMEM;
+}
+
+void
+xfs_bmbt_destroy_cur_cache(void)
+{
+	kmem_cache_destroy(xfs_bmbt_cur_cache);
+	xfs_bmbt_cur_cache = NULL;
+}
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index e9218e92526b..4c752f7341df 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -112,4 +112,7 @@ extern unsigned long long xfs_bmbt_calc_size(struct xfs_mount *mp,
 
 unsigned int xfs_bmbt_absolute_maxlevels(void);
 
+int __init xfs_bmbt_init_cur_cache(void);
+void xfs_bmbt_destroy_cur_cache(void);
+
 #endif	/* __XFS_BMAP_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index bea1bdf9b8b9..11ff814996a1 100644
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
+	kmem_cache_free(cur->bc_cache, cur);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index acb202839afd..6d61ce1559e2 100644
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
@@ -238,6 +230,7 @@ struct xfs_btree_cur
 	struct xfs_trans	*bc_tp;	/* transaction we're in, if any */
 	struct xfs_mount	*bc_mp;	/* file system mount struct */
 	const struct xfs_btree_ops *bc_ops;
+	kmem_zone_t		*bc_cache; /* cursor cache */
 	unsigned int		bc_flags; /* btree features - below */
 	xfs_btnum_t		bc_btnum; /* identifies which btree type */
 	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
@@ -586,17 +579,17 @@ xfs_btree_alloc_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	xfs_btnum_t		btnum,
-	uint8_t			maxlevels)
+	uint8_t			maxlevels,
+	kmem_zone_t		*cache)
 {
 	struct xfs_btree_cur	*cur;
 
-	ASSERT(maxlevels <= XFS_BTREE_CUR_ZONE_MAXLEVELS);
-
-	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
+	cur = kmem_cache_zalloc(cache, GFP_NOFS | __GFP_NOFAIL);
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
 	cur->bc_maxlevels = maxlevels;
+	cur->bc_cache = cache;
 
 	return cur;
 }
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 2e3dd1d798bd..2502085d476c 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -22,6 +22,8 @@
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 
+static kmem_zone_t	*xfs_inobt_cur_cache;
+
 STATIC int
 xfs_inobt_get_minrecs(
 	struct xfs_btree_cur	*cur,
@@ -433,7 +435,7 @@ xfs_inobt_init_common(
 	struct xfs_btree_cur	*cur;
 
 	cur = xfs_btree_alloc_cursor(mp, tp, btnum,
-			M_IGEO(mp)->inobt_maxlevels);
+			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
 	if (btnum == XFS_BTNUM_INO) {
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_ibt_2);
 		cur->bc_ops = &xfs_inobt_ops;
@@ -776,3 +778,20 @@ xfs_iallocbt_calc_size(
 {
 	return xfs_btree_calc_size(M_IGEO(mp)->inobt_mnr, len);
 }
+
+int __init
+xfs_inobt_init_cur_cache(void)
+{
+	xfs_inobt_cur_cache = kmem_cache_create("xfs_inobt_cur",
+			xfs_btree_cur_sizeof(xfs_inobt_absolute_maxlevels()),
+			0, 0, NULL);
+
+	return xfs_inobt_cur_cache != NULL ? 0 : -ENOMEM;
+}
+
+void
+xfs_inobt_destroy_cur_cache(void)
+{
+	kmem_cache_destroy(xfs_inobt_cur_cache);
+	xfs_inobt_cur_cache = NULL;
+}
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index 1f09530bf856..b384733d5e0f 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -77,4 +77,7 @@ void xfs_inobt_commit_staged_btree(struct xfs_btree_cur *cur,
 
 unsigned int xfs_inobt_absolute_maxlevels(void);
 
+int __init xfs_inobt_init_cur_cache(void);
+void xfs_inobt_destroy_cur_cache(void);
+
 #endif	/* __XFS_IALLOC_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index bacd1b442b09..ba27a3ea2ce2 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -21,6 +21,8 @@
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 
+static kmem_zone_t	*xfs_refcountbt_cur_cache;
+
 static struct xfs_btree_cur *
 xfs_refcountbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
@@ -323,7 +325,7 @@ xfs_refcountbt_init_common(
 	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
 
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_REFC,
-			mp->m_refc_maxlevels);
+			mp->m_refc_maxlevels, xfs_refcountbt_cur_cache);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
@@ -505,3 +507,20 @@ xfs_refcountbt_calc_reserves(
 
 	return error;
 }
+
+int __init
+xfs_refcountbt_init_cur_cache(void)
+{
+	xfs_refcountbt_cur_cache = kmem_cache_create("xfs_refcbt_cur",
+			xfs_btree_cur_sizeof(xfs_refcountbt_absolute_maxlevels()),
+			0, 0, NULL);
+
+	return xfs_refcountbt_cur_cache != NULL ? 0 : -ENOMEM;
+}
+
+void
+xfs_refcountbt_destroy_cur_cache(void)
+{
+	kmem_cache_destroy(xfs_refcountbt_cur_cache);
+	xfs_refcountbt_cur_cache = NULL;
+}
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
index 2625b08f50a8..a1437d0a5717 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.h
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -67,4 +67,7 @@ void xfs_refcountbt_commit_staged_btree(struct xfs_btree_cur *cur,
 
 unsigned int xfs_refcountbt_absolute_maxlevels(void);
 
+int __init xfs_refcountbt_init_cur_cache(void);
+void xfs_refcountbt_destroy_cur_cache(void);
+
 #endif	/* __XFS_REFCOUNT_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 860627b5ec08..0a9bc37c01d0 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -22,6 +22,8 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 
+static kmem_zone_t	*xfs_rmapbt_cur_cache;
+
 /*
  * Reverse map btree.
  *
@@ -453,7 +455,7 @@ xfs_rmapbt_init_common(
 
 	/* Overlapping btree; 2 keys per pointer. */
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP,
-			mp->m_rmap_maxlevels);
+			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
 	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 	cur->bc_ops = &xfs_rmapbt_ops;
@@ -670,3 +672,20 @@ xfs_rmapbt_calc_reserves(
 
 	return error;
 }
+
+int __init
+xfs_rmapbt_init_cur_cache(void)
+{
+	xfs_rmapbt_cur_cache = kmem_cache_create("xfs_rmapbt_cur",
+			xfs_btree_cur_sizeof(xfs_rmapbt_absolute_maxlevels()),
+			0, 0, NULL);
+
+	return xfs_rmapbt_cur_cache != NULL ? 0 : -ENOMEM;
+}
+
+void
+xfs_rmapbt_destroy_cur_cache(void)
+{
+	kmem_cache_destroy(xfs_rmapbt_cur_cache);
+	xfs_rmapbt_cur_cache = NULL;
+}
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index 84fe74de923f..dd5422850656 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -61,4 +61,7 @@ extern int xfs_rmapbt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
 
 unsigned int xfs_rmapbt_absolute_maxlevels(void);
 
+int __init xfs_rmapbt_init_cur_cache(void);
+void xfs_rmapbt_destroy_cur_cache(void);
+
 #endif /* __XFS_RMAP_BTREE_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 90c92a6a49e0..399d7cfc7d4b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -37,6 +37,13 @@
 #include "xfs_reflink.h"
 #include "xfs_pwork.h"
 #include "xfs_ag.h"
+#include "xfs_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_refcount_btree.h"
+
 
 #include <linux/magic.h>
 #include <linux/fs_context.h>
@@ -1950,9 +1957,45 @@ static struct file_system_type xfs_fs_type = {
 };
 MODULE_ALIAS_FS("xfs");
 
+STATIC int __init
+xfs_init_btree_cur_caches(void)
+{
+	int				error;
+
+	error = xfs_allocbt_init_cur_cache();
+	if (error)
+		return error;
+	error = xfs_inobt_init_cur_cache();
+	if (error)
+		return error;
+	error = xfs_bmbt_init_cur_cache();
+	if (error)
+		return error;
+	error = xfs_rmapbt_init_cur_cache();
+	if (error)
+		return error;
+	error = xfs_refcountbt_init_cur_cache();
+	if (error)
+		return error;
+
+	return 0;
+}
+
+STATIC void
+xfs_destroy_btree_cur_caches(void)
+{
+	xfs_allocbt_destroy_cur_cache();
+	xfs_inobt_destroy_cur_cache();
+	xfs_bmbt_destroy_cur_cache();
+	xfs_rmapbt_destroy_cur_cache();
+	xfs_refcountbt_destroy_cur_cache();
+}
+
 STATIC int __init
 xfs_init_zones(void)
 {
+	int		error;
+
 	xfs_log_ticket_zone = kmem_cache_create("xfs_log_ticket",
 						sizeof(struct xlog_ticket),
 						0, 0, NULL);
@@ -1965,10 +2008,8 @@ xfs_init_zones(void)
 	if (!xfs_bmap_free_item_zone)
 		goto out_destroy_log_ticket_zone;
 
-	xfs_btree_cur_zone = kmem_cache_create("xfs_btree_cur",
-			xfs_btree_cur_sizeof(XFS_BTREE_CUR_ZONE_MAXLEVELS),
-			0, 0, NULL);
-	if (!xfs_btree_cur_zone)
+	error = xfs_init_btree_cur_caches();
+	if (error)
 		goto out_destroy_bmap_free_item_zone;
 
 	xfs_da_state_zone = kmem_cache_create("xfs_da_state",
@@ -2106,7 +2147,7 @@ xfs_init_zones(void)
  out_destroy_da_state_zone:
 	kmem_cache_destroy(xfs_da_state_zone);
  out_destroy_btree_cur_zone:
-	kmem_cache_destroy(xfs_btree_cur_zone);
+	xfs_destroy_btree_cur_caches();
  out_destroy_bmap_free_item_zone:
 	kmem_cache_destroy(xfs_bmap_free_item_zone);
  out_destroy_log_ticket_zone:
@@ -2138,7 +2179,7 @@ xfs_destroy_zones(void)
 	kmem_cache_destroy(xfs_trans_zone);
 	kmem_cache_destroy(xfs_ifork_zone);
 	kmem_cache_destroy(xfs_da_state_zone);
-	kmem_cache_destroy(xfs_btree_cur_zone);
+	xfs_destroy_btree_cur_caches();
 	kmem_cache_destroy(xfs_bmap_free_item_zone);
 	kmem_cache_destroy(xfs_log_ticket_zone);
 }

