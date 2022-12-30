Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16815C53210
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbiL3Xnt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235749AbiL3Xnb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:43:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A701DF3A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:43:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AA7CB81DCB
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB753C433EF;
        Fri, 30 Dec 2022 23:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443804;
        bh=1r/M9R1x+gDYrFeL8ji8jnsumpT4IZVsz/gqRnE2myI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=o3Itqp8ioRaTMFUFsp5vxs1rMaUK2uowwu6XKFwygUgU1n26sYsW7yP0ApAEnzDBE
         2l/eOGsrhabgieF9mMjYDqx58Ai1v/UXx674naoXiBL088RacdiBwPO/IJIYuQz4wZ
         clUzFoD1XpU/daLxV7r7Mx3KSmzAqhBPiSTy9hkpi3H0qGZV4LQiL5BJzwy15zxZkU
         qqz2i/8lAEvxM33/Y1q+beswltuyR14R+uqU2HW7eMndJ6AdHMwjnxLbkxIbAtSgCe
         YXqS8NzE4kXMr9KIGJ58EbGl5ggdTMRyHf4EFX0AMUrs3iYFmfo4Vzne2/C00PyZx9
         Qi9Y07w2uNHaQ==
Subject: [PATCH 2/4] xfs: repair the rmapbt
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:30 -0800
Message-ID: <167243841031.696748.2811249846332411168.stgit@magnolia>
In-Reply-To: <167243840997.696748.11741067698987523110.stgit@magnolia>
References: <167243840997.696748.11741067698987523110.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Rebuild the reverse mapping btree from all primary metadata.  This first
patch establishes the bare mechanics of finding records and putting
together a new ondisk tree; more complex pieces are needed to make it
work properly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_bmap.c       |   43 +
 fs/xfs/libxfs/xfs_bmap.h       |    8 
 fs/xfs/libxfs/xfs_rmap.c       |   22 -
 fs/xfs/libxfs/xfs_rmap.h       |    2 
 fs/xfs/libxfs/xfs_rmap_btree.c |   13 
 fs/xfs/scrub/bitmap.c          |   14 
 fs/xfs/scrub/bitmap.h          |    5 
 fs/xfs/scrub/common.c          |    4 
 fs/xfs/scrub/common.h          |    1 
 fs/xfs/scrub/newbt.c           |    5 
 fs/xfs/scrub/newbt.h           |    6 
 fs/xfs/scrub/reap.c            |    6 
 fs/xfs/scrub/repair.c          |    5 
 fs/xfs/scrub/repair.h          |    6 
 fs/xfs/scrub/rmap.c            |    9 
 fs/xfs/scrub/rmap_repair.c     | 1405 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c           |    2 
 fs/xfs/scrub/trace.h           |   33 +
 19 files changed, 1572 insertions(+), 18 deletions(-)
 create mode 100644 fs/xfs/scrub/rmap_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 7e1495465cec..78ea3a6a0f5b 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -195,6 +195,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   reap.o \
 				   refcount_repair.o \
 				   repair.o \
+				   rmap_repair.o \
 				   xfbtree.o \
 				   )
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 89cbd9b563ff..89fd34fbae7a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6406,3 +6406,46 @@ xfs_bunmapi_range(
 out:
 	return error;
 }
+
+struct xfs_bmap_query_range {
+	xfs_bmap_query_range_fn	fn;
+	void			*priv;
+};
+
+/* Format btree record and pass to our callback. */
+STATIC int
+xfs_bmap_query_range_helper(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_rec	*rec,
+	void				*priv)
+{
+	struct xfs_bmap_query_range	*query = priv;
+	struct xfs_bmbt_irec		irec;
+	xfs_failaddr_t			fa;
+
+	xfs_bmbt_disk_get_all(&rec->bmbt, &irec);
+	fa = xfs_bmap_validate_extent(cur->bc_ino.ip, cur->bc_ino.whichfork,
+			&irec);
+	if (fa) {
+		xfs_btree_mark_sick(cur);
+		return xfs_bmap_complain_bad_rec(cur->bc_ino.ip,
+				cur->bc_ino.whichfork, fa, &irec);
+	}
+
+	return query->fn(cur, &irec, query->priv);
+}
+
+/* Find all bmaps. */
+int
+xfs_bmap_query_all(
+	struct xfs_btree_cur		*cur,
+	xfs_bmap_query_range_fn		fn,
+	void				*priv)
+{
+	struct xfs_bmap_query_range	query = {
+		.priv			= priv,
+		.fn			= fn,
+	};
+
+	return xfs_btree_query_all(cur, xfs_bmap_query_range_helper, &query);
+}
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 1201ee024c1f..bbda4a77cb69 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -274,4 +274,12 @@ extern struct kmem_cache	*xfs_bmap_intent_cache;
 int __init xfs_bmap_intent_init_cache(void);
 void xfs_bmap_intent_destroy_cache(void);
 
+typedef int (*xfs_bmap_query_range_fn)(
+	struct xfs_btree_cur	*cur,
+	struct xfs_bmbt_irec	*rec,
+	void			*priv);
+
+int xfs_bmap_query_all(struct xfs_btree_cur *cur, xfs_bmap_query_range_fn fn,
+		void *priv);
+
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index a30602660669..16233bb5be7e 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -212,13 +212,12 @@ xfs_rmap_btrec_to_irec(
 			irec);
 }
 
-/* Simple checks for rmap records. */
-xfs_failaddr_t
-xfs_rmap_check_irec(
-	struct xfs_btree_cur		*cur,
+inline xfs_failaddr_t
+xfs_rmap_check_perag_irec(
+	struct xfs_perag		*pag,
 	const struct xfs_rmap_irec	*irec)
 {
-	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_mount		*mp = pag->pag_mount;
 	bool				is_inode;
 	bool				is_unwritten;
 	bool				is_bmbt;
@@ -233,8 +232,8 @@ xfs_rmap_check_irec(
 			return __this_address;
 	} else {
 		/* check for valid extent range, including overflow */
-		if (!xfs_verify_agbext(cur->bc_ag.pag, irec->rm_startblock,
-						       irec->rm_blockcount))
+		if (!xfs_verify_agbext(pag, irec->rm_startblock,
+					    irec->rm_blockcount))
 			return __this_address;
 	}
 
@@ -269,6 +268,15 @@ xfs_rmap_check_irec(
 	return NULL;
 }
 
+/* Simple checks for rmap records. */
+xfs_failaddr_t
+xfs_rmap_check_irec(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*irec)
+{
+	return xfs_rmap_check_perag_irec(cur->bc_ag.pag, irec);
+}
+
 static inline int
 xfs_rmap_complain_bad_rec(
 	struct xfs_btree_cur		*cur,
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index ced605d69324..b7ad51055e13 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -195,6 +195,8 @@ int xfs_rmap_compare(const struct xfs_rmap_irec *a,
 union xfs_btree_rec;
 xfs_failaddr_t xfs_rmap_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
+xfs_failaddr_t xfs_rmap_check_perag_irec(struct xfs_perag *pag,
+		const struct xfs_rmap_irec *irec);
 xfs_failaddr_t xfs_rmap_check_irec(struct xfs_btree_cur *cur,
 		const struct xfs_rmap_irec *irec);
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 5583dbe43bb5..103e4c97badc 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -342,7 +342,18 @@ xfs_rmapbt_verify(
 
 	level = be16_to_cpu(block->bb_level);
 	if (pag && pag->pagf_init) {
-		if (level >= pag->pagf_levels[XFS_BTNUM_RMAPi])
+		unsigned int	maxlevel = pag->pagf_levels[XFS_BTNUM_RMAPi];
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+		/*
+		 * Online repair could be rewriting the free space btrees, so
+		 * we'll validate against the larger of either tree while this
+		 * is going on.
+		 */
+		maxlevel = max_t(unsigned int, maxlevel,
+				pag->pagf_alt_levels[XFS_BTNUM_RMAPi]);
+#endif
+		if (level >= maxlevel)
 			return __this_address;
 	} else if (level >= mp->m_rmap_maxlevels)
 		return __this_address;
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index c98f4c45414a..7aeeb42a809f 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -407,3 +407,17 @@ xbitmap_take_first_set(
 	*valp = val;
 	return 0;
 }
+
+/* Count the number of set regions in this bitmap. */
+uint64_t
+xbitmap_count_set_regions(
+	struct xbitmap		*bitmap)
+{
+	struct xbitmap_node	*bn;
+	uint64_t		nr = 0;
+
+	for_each_xbitmap_extent(bn, bitmap)
+		nr++;
+
+	return nr;
+}
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 1ebe1918bdb2..d59d5e76782c 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -31,6 +31,7 @@ int xbitmap_walk(struct xbitmap *bitmap, xbitmap_walk_fn fn,
 
 bool xbitmap_empty(struct xbitmap *bitmap);
 bool xbitmap_test(struct xbitmap *bitmap, uint64_t start, uint64_t *len);
+uint64_t xbitmap_count_set_regions(struct xbitmap *bitmap);
 
 int xbitmap_take_first_set(struct xbitmap *bitmap, uint64_t start,
 		uint64_t last, uint64_t *valp);
@@ -86,6 +87,10 @@ static inline int xagb_bitmap_disunion(struct xagb_bitmap *bitmap,
 	return xbitmap_disunion(&bitmap->agbitmap, &sub->agbitmap);
 }
 
+static inline uint32_t xagb_bitmap_count_set_regions(struct xagb_bitmap *bitmap)
+{
+	return xbitmap_count_set_regions(&bitmap->agbitmap);
+}
 static inline uint32_t xagb_bitmap_hweight(struct xagb_bitmap *bitmap)
 {
 	return xbitmap_hweight(&bitmap->agbitmap);
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index d96355ca4175..c436d613521c 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -461,7 +461,7 @@ xchk_perag_read_headers(
  * Grab the AG headers for the attached perag structure and wait for pending
  * intents to drain.
  */
-static int
+int
 xchk_perag_lock(
 	struct xfs_scrub	*sc)
 {
@@ -705,7 +705,7 @@ xchk_trans_alloc(
 		return xfs_trans_alloc(sc->mp, &M_RES(sc->mp)->tr_itruncate,
 				resblks, 0, 0, &sc->tp);
 
-	return xfs_trans_alloc_empty(sc->mp, &sc->tp);
+	return xchk_trans_alloc_empty(sc);
 }
 
 /* Set us up with a transaction and an empty context. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 6992e3db5f11..9bdacce17d82 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -134,6 +134,7 @@ int xchk_setup_nlinks(struct xfs_scrub *sc);
 void xchk_ag_free(struct xfs_scrub *sc, struct xchk_ag *sa);
 int xchk_ag_init(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		struct xchk_ag *sa);
+int xchk_perag_lock(struct xfs_scrub *sc);
 
 /*
  * Grab all AG resources, treating the inability to grab the perag structure as
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index efa73f676ad4..ebdfdf631be3 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -342,7 +342,10 @@ xrep_newbt_alloc_blocks(
 			.resv		= xnr->resv,
 		};
 
-		error = xfs_alloc_vextent(&args);
+		if (xnr->alloc_vextent)
+			error = xnr->alloc_vextent(sc, &args);
+		else
+			error = xfs_alloc_vextent(&args);
 		if (error)
 			return error;
 		if (args.fsbno == NULLFSBLOCK)
diff --git a/fs/xfs/scrub/newbt.h b/fs/xfs/scrub/newbt.h
index 96ae0dc3bc41..95fea3dd5211 100644
--- a/fs/xfs/scrub/newbt.h
+++ b/fs/xfs/scrub/newbt.h
@@ -6,6 +6,8 @@
 #ifndef __XFS_SCRUB_NEWBT_H__
 #define __XFS_SCRUB_NEWBT_H__
 
+struct xfs_alloc_arg;
+
 struct xrep_newbt_resv {
 	/* Link to list of extents that we've reserved. */
 	struct list_head	list;
@@ -28,6 +30,10 @@ struct xrep_newbt_resv {
 struct xrep_newbt {
 	struct xfs_scrub	*sc;
 
+	/* Custom allocation function, or NULL for xfs_alloc_vextent */
+	int			(*alloc_vextent)(struct xfs_scrub *sc,
+						 struct xfs_alloc_arg *args);
+
 	/* List of extents that we've reserved. */
 	struct list_head	resv_list;
 
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 79d43b9448a3..ea7a274aa778 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -111,7 +111,7 @@ xreap_put_freelist(
 	int			error;
 
 	/* Make sure there's space on the freelist. */
-	error = xrep_fix_freelist(sc, true);
+	error = xrep_fix_freelist(sc, 0);
 	if (error)
 		return error;
 
@@ -363,10 +363,14 @@ xreap_agextent(
 		rs->force_roll = true;
 		break;
 	case XFS_AG_RESV_IGNORE:
+	case XFS_AG_RESV_RMAPBT:
 		/*
 		 * bnobt/cntbt blocks are counted as free space, so we pass
 		 * XFS_AG_RESV_IGNORE when reaping the old free space btree
 		 * blocks to avoid changing fdblocks.
+		 *
+		 * rmapbt blocks are also counted as free space, but they have
+		 * their own per-AG reservation type.
 		 */
 		error = __xfs_free_extent(sc->tp, sc->sa.pag, agbno, *aglenp,
 				rs->oinfo, rs->resv, true);
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 1862e05e398f..7c242fddac8a 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -392,7 +392,7 @@ xrep_calc_ag_resblks(
 int
 xrep_fix_freelist(
 	struct xfs_scrub	*sc,
-	bool			can_shrink)
+	int			alloc_flags)
 {
 	struct xfs_alloc_arg	args = {0};
 
@@ -402,8 +402,7 @@ xrep_fix_freelist(
 	args.alignment = 1;
 	args.pag = sc->sa.pag;
 
-	return xfs_alloc_fix_freelist(&args,
-			can_shrink ? 0 : XFS_ALLOC_FLAG_NOSHRINK);
+	return xfs_alloc_fix_freelist(&args, alloc_flags);
 }
 
 /*
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 5e3e6cfe3332..22e8e1ed2de2 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -41,7 +41,7 @@ struct xbitmap;
 struct xagb_bitmap;
 struct xfsb_bitmap;
 
-int xrep_fix_freelist(struct xfs_scrub *sc, bool can_shrink);
+int xrep_fix_freelist(struct xfs_scrub *sc, int alloc_flags);
 
 struct xrep_find_ag_btree {
 	/* in: rmap owner of the btree we're looking for */
@@ -76,6 +76,7 @@ int xrep_ino_ensure_extent_count(struct xfs_scrub *sc, int whichfork,
 int xrep_reset_perag_resv(struct xfs_scrub *sc);
 int xrep_bmap(struct xfs_scrub *sc, int whichfork, bool allow_unwritten);
 int xrep_metadata_inode_forks(struct xfs_scrub *sc);
+int xrep_setup_ag_rmapbt(struct xfs_scrub *sc);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
@@ -102,6 +103,7 @@ int xrep_agfl(struct xfs_scrub *sc);
 int xrep_agi(struct xfs_scrub *sc);
 int xrep_allocbt(struct xfs_scrub *sc);
 int xrep_iallocbt(struct xfs_scrub *sc);
+int xrep_rmapbt(struct xfs_scrub *sc);
 int xrep_refcountbt(struct xfs_scrub *sc);
 int xrep_inode(struct xfs_scrub *sc);
 int xrep_bmap_data(struct xfs_scrub *sc);
@@ -167,6 +169,7 @@ xrep_setup_nothing(
 	return 0;
 }
 #define xrep_setup_ag_allocbt		xrep_setup_nothing
+#define xrep_setup_ag_rmapbt		xrep_setup_nothing
 
 #define xrep_setup_inode(sc, imap)	((void)0)
 
@@ -185,6 +188,7 @@ static inline int xrep_setup_rtbitmap(struct xfs_scrub *sc, unsigned int *x)
 #define xrep_agi			xrep_notsupported
 #define xrep_allocbt			xrep_notsupported
 #define xrep_iallocbt			xrep_notsupported
+#define xrep_rmapbt			xrep_notsupported
 #define xrep_refcountbt			xrep_notsupported
 #define xrep_inode			xrep_notsupported
 #define xrep_bmap_data			xrep_notsupported
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 8f1fdae71766..2ed0b877056a 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -24,6 +24,7 @@
 #include "scrub/common.h"
 #include "scrub/btree.h"
 #include "scrub/bitmap.h"
+#include "scrub/repair.h"
 
 /*
  * Set us up to scrub reverse mapping btrees.
@@ -35,6 +36,14 @@ xchk_setup_ag_rmapbt(
 	if (xchk_need_fshook_drain(sc))
 		xchk_fshooks_enable(sc, XCHK_FSHOOKS_DRAIN);
 
+	if (xchk_could_repair(sc)) {
+		int		error;
+
+		error = xrep_setup_ag_rmapbt(sc);
+		if (error)
+			return error;
+	}
+
 	return xchk_setup_ag_btree(sc, false);
 }
 
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
new file mode 100644
index 000000000000..952dae473d4d
--- /dev/null
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -0,0 +1,1405 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_btree_staging.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_alloc.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_refcount.h"
+#include "xfs_refcount_btree.h"
+#include "xfs_ag.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/bitmap.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/iscan.h"
+#include "scrub/newbt.h"
+#include "scrub/reap.h"
+
+/*
+ * Reverse Mapping Btree Repair
+ * ============================
+ *
+ * This is the most involved of all the AG space btree rebuilds.  Everywhere
+ * else in XFS we lock inodes and then AG data structures, but generating the
+ * list of rmap records requires that we be able to scan both block mapping
+ * btrees of every inode in the filesystem to see if it owns any extents in
+ * this AG.  We can't tolerate any inode updates while we do this, so we
+ * freeze the filesystem to lock everyone else out, and grant ourselves
+ * special privileges to run transactions with regular background reclamation
+ * turned off.
+ *
+ * We also have to be very careful not to allow inode reclaim to start a
+ * transaction because all transactions (other than our own) will block.
+ * Deferred inode inactivation helps us out there.
+ *
+ * I) Reverse mappings for all non-space metadata and file data are collected
+ * according to the following algorithm:
+ *
+ * 1. For each fork of each inode:
+ * 1.1. Create a bitmap BMBIT to track bmbt blocks if necessary.
+ * 1.2. If the incore extent map isn't loaded, walk the bmbt to accumulate
+ *      bmaps into rmap records (see 1.1.4).  Set bits in BMBIT for each btree
+ *      block.
+ * 1.3. If the incore extent map is loaded but the fork is in btree format,
+ *      just visit the bmbt blocks to set the corresponding BMBIT areas.
+ * 1.4. From the incore extent map, accumulate each bmap that falls into our
+ *      target AG.  Remember, multiple bmap records can map to a single rmap
+ *      record, so we cannot simply emit rmap records 1:1.
+ * 1.5. Emit rmap records for each extent in BMBIT and free it.
+ * 2. Create bitmaps INOBIT and ICHUNKBIT.
+ * 3. For each record in the inobt, set the corresponding areas in ICHUNKBIT,
+ *    and set bits in INOBIT for each btree block.  If the inobt has no records
+ *    at all, we must be careful to record its root in INOBIT.
+ * 4. For each block in the finobt, set the corresponding INOBIT area.
+ * 5. Emit rmap records for each extent in INOBIT and ICHUNKBIT and free them.
+ * 6. Create bitmaps REFCBIT and COWBIT.
+ * 7. For each CoW staging extent in the refcountbt, set the corresponding
+ *    areas in COWBIT.
+ * 8. For each block in the refcountbt, set the corresponding REFCBIT area.
+ * 9. Emit rmap records for each extent in REFCBIT and COWBIT and free them.
+ * A. Emit rmap for the AG headers.
+ * B. Emit rmap for the log, if there is one.
+ *
+ * II) The rmapbt shape and space metadata rmaps are computed as follows:
+ *
+ * 1. Count the rmaps collected in the previous step. (= NR)
+ * 2. Estimate the number of rmapbt blocks needed to store NR records. (= RMB)
+ * 3. Reserve RMB blocks through the newbt using the allocator in normap mode.
+ * 4. Create bitmap AGBIT.
+ * 5. For each reservation in the newbt, set the corresponding areas in AGBIT.
+ * 6. For each block in the AGFL, bnobt, and cntbt, set the bits in AGBIT.
+ * 7. Count the extents in AGBIT. (= AGNR)
+ * 8. Estimate the number of rmapbt blocks needed for NR + AGNR rmaps. (= RMB')
+ * 9. If RMB' >= RMB, reserve RMB' - RMB more newbt blocks, set RMB = RMB',
+ *    and clear AGBIT.  Go to step 5.
+ * A. Emit rmaps for each extent in AGBIT.
+ *
+ * III) The rmapbt is constructed and set in place as follows:
+ *
+ * 1. Sort the rmap records.
+ * 2. Bulk load the rmaps.
+ *
+ * IV) Reap the old btree blocks.
+ *
+ * 1. Create a bitmap OLDRMBIT.
+ * 2. For each gap in the new rmapbt, set the corresponding areas of OLDRMBIT.
+ * 3. For each extent in the bnobt, clear the corresponding parts of OLDRMBIT.
+ * 4. Reap the extents corresponding to the set areas in OLDRMBIT.  These are
+ *    the parts of the AG that the rmap didn't find during its scan of the
+ *    primary metadata and aren't known to be in the free space, which implies
+ *    that they were the old rmapbt blocks.
+ * 5. Commit.
+ *
+ * We use the 'xrep_rmap' prefix for all the rmap functions.
+ */
+
+/* Set us up to repair reverse mapping btrees. */
+int
+xrep_setup_ag_rmapbt(
+	struct xfs_scrub	*sc)
+{
+	/* For now this is a placeholder until we land other pieces. */
+	return 0;
+}
+
+/*
+ * Packed rmap record.  The ATTR/BMBT/UNWRITTEN flags are hidden in the upper
+ * bits of offset, just like the on-disk record.
+ */
+struct xrep_rmap_extent {
+	xfs_agblock_t	startblock;
+	xfs_extlen_t	blockcount;
+	uint64_t	owner;
+	uint64_t	offset;
+} __packed;
+
+/* Context for collecting rmaps */
+struct xrep_rmap {
+	/* new rmapbt information */
+	struct xrep_newbt	new_btree;
+
+	/* rmap records generated from primary metadata */
+	struct xfarray		*rmap_records;
+
+	struct xfs_scrub	*sc;
+
+	/* get_records()'s position in the rmap record array. */
+	xfarray_idx_t		array_cur;
+
+	/* inode scan cursor */
+	struct xchk_iscan	iscan;
+
+	/* bnobt/cntbt contribution to btreeblks */
+	xfs_agblock_t		freesp_btblocks;
+
+	/* old agf_rmap_blocks counter */
+	unsigned int		old_rmapbt_fsbcount;
+};
+
+/* Make sure there's nothing funny about this mapping. */
+STATIC int
+xrep_rmap_check_mapping(
+	struct xfs_scrub	*sc,
+	const struct xfs_rmap_irec *rec)
+{
+	enum xbtree_recpacking	outcome;
+	int			error;
+
+	if (xfs_rmap_check_perag_irec(sc->sa.pag, rec) != NULL)
+		return -EFSCORRUPTED;
+
+	/* Make sure this isn't free space. */
+	error = xfs_alloc_has_records(sc->sa.bno_cur, rec->rm_startblock,
+			rec->rm_blockcount, &outcome);
+	if (error)
+		return error;
+	if (outcome != XBTREE_RECPACKING_EMPTY)
+		return -EFSCORRUPTED;
+
+	return 0;
+}
+
+/* Store a reverse-mapping record. */
+static inline int
+xrep_rmap_stash(
+	struct xrep_rmap	*rr,
+	xfs_agblock_t		startblock,
+	xfs_extlen_t		blockcount,
+	uint64_t		owner,
+	uint64_t		offset,
+	unsigned int		flags)
+{
+	struct xrep_rmap_extent	rre = {
+		.startblock	= startblock,
+		.blockcount	= blockcount,
+		.owner		= owner,
+	};
+	struct xfs_rmap_irec	rmap = {
+		.rm_startblock	= startblock,
+		.rm_blockcount	= blockcount,
+		.rm_owner	= owner,
+		.rm_offset	= offset,
+		.rm_flags	= flags,
+	};
+	struct xfs_scrub	*sc = rr->sc;
+	int			error = 0;
+
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
+	trace_xrep_rmap_found(sc->mp, sc->sa.pag->pag_agno, &rmap);
+
+	rre.offset = xfs_rmap_irec_offset_pack(&rmap);
+	return xfarray_append(rr->rmap_records, &rre);
+}
+
+struct xrep_rmap_stash_run {
+	struct xrep_rmap	*rr;
+	uint64_t		owner;
+	unsigned int		rmap_flags;
+};
+
+static int
+xrep_rmap_stash_run(
+	uint64_t			start,
+	uint64_t			len,
+	void				*priv)
+{
+	struct xrep_rmap_stash_run	*rsr = priv;
+	struct xrep_rmap		*rr = rsr->rr;
+
+	return xrep_rmap_stash(rr, start, len, rsr->owner, 0, rsr->rmap_flags);
+}
+
+/*
+ * Emit rmaps for every extent of bits set in the bitmap.  Caller must ensure
+ * that the ranges are in units of FS blocks.
+ */
+STATIC int
+xrep_rmap_stash_bitmap(
+	struct xrep_rmap		*rr,
+	struct xagb_bitmap		*bitmap,
+	const struct xfs_owner_info	*oinfo)
+{
+	struct xrep_rmap_stash_run	rsr = {
+		.rr			= rr,
+		.owner			= oinfo->oi_owner,
+		.rmap_flags		= 0,
+	};
+
+	if (oinfo->oi_flags & XFS_OWNER_INFO_ATTR_FORK)
+		rsr.rmap_flags |= XFS_RMAP_ATTR_FORK;
+	if (oinfo->oi_flags & XFS_OWNER_INFO_BMBT_BLOCK)
+		rsr.rmap_flags |= XFS_RMAP_BMBT_BLOCK;
+
+	return xagb_bitmap_walk(bitmap, xrep_rmap_stash_run, &rsr);
+}
+
+/* Section (I): Finding all file and bmbt extents. */
+
+/* Context for accumulating rmaps for an inode fork. */
+struct xrep_rmap_ifork {
+	/*
+	 * Accumulate rmap data here to turn multiple adjacent bmaps into a
+	 * single rmap.
+	 */
+	struct xfs_rmap_irec	accum;
+
+	/* Bitmap of bmbt blocks in this AG. */
+	struct xagb_bitmap	bmbt_blocks;
+
+	struct xrep_rmap	*rr;
+
+	/* Which inode fork? */
+	int			whichfork;
+};
+
+/* Stash an rmap that we accumulated while walking an inode fork. */
+STATIC int
+xrep_rmap_stash_accumulated(
+	struct xrep_rmap_ifork	*rf)
+{
+	if (rf->accum.rm_blockcount == 0)
+		return 0;
+
+	return xrep_rmap_stash(rf->rr, rf->accum.rm_startblock,
+			rf->accum.rm_blockcount, rf->accum.rm_owner,
+			rf->accum.rm_offset, rf->accum.rm_flags);
+}
+
+/* Accumulate a bmbt record. */
+STATIC int
+xrep_rmap_visit_bmbt(
+	struct xfs_btree_cur	*cur,
+	struct xfs_bmbt_irec	*rec,
+	void			*priv)
+{
+	struct xrep_rmap_ifork	*rf = priv;
+	struct xfs_mount	*mp = rf->rr->sc->mp;
+	struct xfs_rmap_irec	*accum = &rf->accum;
+	xfs_agblock_t		agbno;
+	unsigned int		rmap_flags = 0;
+	int			error;
+
+	if (XFS_FSB_TO_AGNO(mp, rec->br_startblock) !=
+			rf->rr->sc->sa.pag->pag_agno)
+		return 0;
+
+	agbno = XFS_FSB_TO_AGBNO(mp, rec->br_startblock);
+	if (rf->whichfork == XFS_ATTR_FORK)
+		rmap_flags |= XFS_RMAP_ATTR_FORK;
+	if (rec->br_state == XFS_EXT_UNWRITTEN)
+		rmap_flags |= XFS_RMAP_UNWRITTEN;
+
+	/* If this bmap is adjacent to the previous one, just add it. */
+	if (accum->rm_blockcount > 0 &&
+	    rec->br_startoff == accum->rm_offset + accum->rm_blockcount &&
+	    agbno == accum->rm_startblock + accum->rm_blockcount &&
+	    rmap_flags == accum->rm_flags) {
+		accum->rm_blockcount += rec->br_blockcount;
+		return 0;
+	}
+
+	/* Otherwise stash the old rmap and start accumulating a new one. */
+	error = xrep_rmap_stash_accumulated(rf);
+	if (error)
+		return error;
+
+	accum->rm_startblock = agbno;
+	accum->rm_blockcount = rec->br_blockcount;
+	accum->rm_offset = rec->br_startoff;
+	accum->rm_flags = rmap_flags;
+	return 0;
+}
+
+/* Add a btree block to the bitmap. */
+STATIC int
+xrep_rmap_visit_iroot_btree_block(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	void			*priv)
+{
+	struct xrep_rmap_ifork	*rf = priv;
+	struct xfs_buf		*bp;
+	xfs_fsblock_t		fsbno;
+	xfs_agblock_t		agbno;
+
+	xfs_btree_get_block(cur, level, &bp);
+	if (!bp)
+		return 0;
+
+	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
+	if (XFS_FSB_TO_AGNO(cur->bc_mp, fsbno) != rf->rr->sc->sa.pag->pag_agno)
+		return 0;
+
+	agbno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
+	return xagb_bitmap_set(&rf->bmbt_blocks, agbno, 1);
+}
+
+/*
+ * Iterate a metadata btree rooted in an inode to collect rmap records for
+ * anything in this fork that matches the AG.
+ */
+STATIC int
+xrep_rmap_scan_iroot_btree(
+	struct xrep_rmap_ifork	*rf,
+	struct xfs_btree_cur	*cur)
+{
+	struct xfs_owner_info	oinfo;
+	struct xrep_rmap	*rr = rf->rr;
+	int			error;
+
+	xagb_bitmap_init(&rf->bmbt_blocks);
+
+	/* Record all the blocks in the btree itself. */
+	error = xfs_btree_visit_blocks(cur, xrep_rmap_visit_iroot_btree_block,
+			XFS_BTREE_VISIT_ALL, rf);
+	if (error)
+		goto out;
+
+	/* Emit rmaps for the btree blocks. */
+	xfs_rmap_ino_bmbt_owner(&oinfo, rf->accum.rm_owner, rf->whichfork);
+	error = xrep_rmap_stash_bitmap(rr, &rf->bmbt_blocks, &oinfo);
+	if (error)
+		goto out;
+
+	/* Stash any remaining accumulated rmaps. */
+	error = xrep_rmap_stash_accumulated(rf);
+out:
+	xagb_bitmap_destroy(&rf->bmbt_blocks);
+	return error;
+}
+
+static inline bool
+is_rt_data_fork(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	return XFS_IS_REALTIME_INODE(ip) && whichfork == XFS_DATA_FORK;
+}
+
+/*
+ * Iterate the block mapping btree to collect rmap records for anything in this
+ * fork that matches the AG.  Sets @mappings_done to true if we've scanned the
+ * block mappings in this fork.
+ */
+STATIC int
+xrep_rmap_scan_bmbt(
+	struct xrep_rmap_ifork	*rf,
+	struct xfs_inode	*ip,
+	bool			*mappings_done)
+{
+	struct xrep_rmap	*rr = rf->rr;
+	struct xfs_btree_cur	*cur;
+	struct xfs_ifork	*ifp;
+	int			error;
+
+	*mappings_done = false;
+	ifp = xfs_ifork_ptr(ip, rf->whichfork);
+	cur = xfs_bmbt_init_cursor(rr->sc->mp, rr->sc->tp, ip, rf->whichfork);
+
+	if (!xfs_ifork_is_realtime(ip, rf->whichfork) &&
+	    xfs_need_iread_extents(ifp)) {
+		/*
+		 * If the incore extent cache isn't loaded, scan the bmbt for
+		 * mapping records.  This avoids loading the incore extent
+		 * tree, which will increase memory pressure at a time when
+		 * we're trying to run as quickly as we possibly can.  Ignore
+		 * realtime extents.
+		 */
+		error = xfs_bmap_query_all(cur, xrep_rmap_visit_bmbt, rf);
+		if (error)
+			goto out_cur;
+
+		*mappings_done = true;
+	}
+
+	/* Scan for the bmbt blocks, which always live on the data device. */
+	error = xrep_rmap_scan_iroot_btree(rf, cur);
+out_cur:
+	xfs_btree_del_cursor(cur, error);
+	return error;
+}
+
+/*
+ * Iterate the in-core extent cache to collect rmap records for anything in
+ * this fork that matches the AG.
+ */
+STATIC int
+xrep_rmap_scan_iext(
+	struct xrep_rmap_ifork	*rf,
+	struct xfs_ifork	*ifp)
+{
+	struct xfs_bmbt_irec	rec;
+	struct xfs_iext_cursor	icur;
+	int			error;
+
+	for_each_xfs_iext(ifp, &icur, &rec) {
+		if (isnullstartblock(rec.br_startblock))
+			continue;
+		error = xrep_rmap_visit_bmbt(NULL, &rec, rf);
+		if (error)
+			return error;
+	}
+
+	return xrep_rmap_stash_accumulated(rf);
+}
+
+/* Find all the extents from a given AG in an inode fork. */
+STATIC int
+xrep_rmap_scan_ifork(
+	struct xrep_rmap	*rr,
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	struct xrep_rmap_ifork	rf = {
+		.accum		= { .rm_owner = ip->i_ino, },
+		.rr		= rr,
+		.whichfork	= whichfork,
+	};
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
+	int			error = 0;
+
+	if (!ifp)
+		return 0;
+
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
+		bool		mappings_done;
+
+		/*
+		 * Scan the bmap btree for data device mappings.  This includes
+		 * the btree blocks themselves, even if this is a realtime
+		 * file.
+		 */
+		error = xrep_rmap_scan_bmbt(&rf, ip, &mappings_done);
+		if (error || mappings_done)
+			return error;
+	} else if (ifp->if_format != XFS_DINODE_FMT_EXTENTS) {
+		return 0;
+	}
+
+	/* Scan incore extent cache if this isn't a realtime file. */
+	if (xfs_ifork_is_realtime(ip, whichfork))
+		return 0;
+
+	return xrep_rmap_scan_iext(&rf, ifp);
+}
+
+/* Record reverse mappings for a file. */
+STATIC int
+xrep_rmap_scan_inode(
+	struct xrep_rmap	*rr,
+	struct xfs_inode	*ip)
+{
+	unsigned int		lock_mode;
+	int			error;
+
+	xfs_ilock(ip, XFS_IOLOCK_SHARED | XFS_MMAPLOCK_SHARED);
+	lock_mode = xfs_ilock_data_map_shared(ip);
+
+	/* Check the data fork. */
+	error = xrep_rmap_scan_ifork(rr, ip, XFS_DATA_FORK);
+	if (error)
+		goto out_unlock;
+
+	/* Check the attr fork. */
+	error = xrep_rmap_scan_ifork(rr, ip, XFS_ATTR_FORK);
+	if (error)
+		goto out_unlock;
+
+	/* COW fork extents are "owned" by the refcount btree. */
+
+	xchk_iscan_mark_visited(&rr->iscan, ip);
+out_unlock:
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED | XFS_MMAPLOCK_SHARED | lock_mode);
+	return error;
+}
+
+/* Section (I): Find all AG metadata extents except for free space metadata. */
+
+struct xrep_rmap_inodes {
+	struct xrep_rmap	*rr;
+	struct xagb_bitmap	inobt_blocks;	/* INOBIT */
+	struct xagb_bitmap	ichunk_blocks;	/* ICHUNKBIT */
+};
+
+/* Record inode btree rmaps. */
+STATIC int
+xrep_rmap_walk_inobt(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_rec	*rec,
+	void				*priv)
+{
+	struct xfs_inobt_rec_incore	irec;
+	struct xrep_rmap_inodes		*ri = priv;
+	struct xfs_mount		*mp = cur->bc_mp;
+	xfs_agblock_t			agbno;
+	xfs_agino_t			agino;
+	xfs_agino_t			iperhole;
+	unsigned int			i;
+	int				error;
+
+	/* Record the inobt blocks. */
+	error = xagb_bitmap_set_btcur_path(&ri->inobt_blocks, cur);
+	if (error)
+		return error;
+
+	xfs_inobt_btrec_to_irec(mp, rec, &irec);
+	if (xfs_inobt_check_irec(cur, &irec) != NULL)
+		return -EFSCORRUPTED;
+
+	agino = irec.ir_startino;
+
+	/* Record a non-sparse inode chunk. */
+	if (!xfs_inobt_issparse(irec.ir_holemask)) {
+		agbno = XFS_AGINO_TO_AGBNO(mp, agino);
+
+		return xagb_bitmap_set(&ri->ichunk_blocks, agbno,
+				XFS_INODES_PER_CHUNK / mp->m_sb.sb_inopblock);
+	}
+
+	/* Iterate each chunk. */
+	iperhole = max_t(xfs_agino_t, mp->m_sb.sb_inopblock,
+			XFS_INODES_PER_HOLEMASK_BIT);
+	for (i = 0, agino = irec.ir_startino;
+	     i < XFS_INOBT_HOLEMASK_BITS;
+	     i += iperhole / XFS_INODES_PER_HOLEMASK_BIT, agino += iperhole) {
+		/* Skip holes. */
+		if (irec.ir_holemask & (1 << i))
+			continue;
+
+		/* Record the inode chunk otherwise. */
+		agbno = XFS_AGINO_TO_AGBNO(mp, agino);
+		error = xagb_bitmap_set(&ri->ichunk_blocks, agbno,
+				iperhole / mp->m_sb.sb_inopblock);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/* Collect rmaps for the blocks containing inode btrees and the inode chunks. */
+STATIC int
+xrep_rmap_find_inode_rmaps(
+	struct xrep_rmap	*rr)
+{
+	struct xrep_rmap_inodes	ri = {
+		.rr		= rr,
+	};
+	struct xfs_scrub	*sc = rr->sc;
+	int			error;
+
+	xagb_bitmap_init(&ri.inobt_blocks);
+	xagb_bitmap_init(&ri.ichunk_blocks);
+
+	/*
+	 * Iterate every record in the inobt so we can capture all the inode
+	 * chunks and the blocks in the inobt itself.
+	 */
+	error = xfs_btree_query_all(sc->sa.ino_cur, xrep_rmap_walk_inobt, &ri);
+	if (error)
+		goto out_bitmap;
+
+	/*
+	 * Note that if there are zero records in the inobt then query_all does
+	 * nothing and we have to account the empty inobt root manually.
+	 */
+	if (xagb_bitmap_empty(&ri.ichunk_blocks)) {
+		struct xfs_agi	*agi = sc->sa.agi_bp->b_addr;
+
+		error = xagb_bitmap_set(&ri.inobt_blocks,
+				be32_to_cpu(agi->agi_root), 1);
+		if (error)
+			goto out_bitmap;
+	}
+
+	/* Scan the finobt too. */
+	if (xfs_has_finobt(sc->mp)) {
+		error = xagb_bitmap_set_btblocks(&ri.inobt_blocks,
+				sc->sa.fino_cur);
+		if (error)
+			goto out_bitmap;
+	}
+
+	/* Generate rmaps for everything. */
+	error = xrep_rmap_stash_bitmap(rr, &ri.inobt_blocks,
+			&XFS_RMAP_OINFO_INOBT);
+	if (error)
+		goto out_bitmap;
+	error = xrep_rmap_stash_bitmap(rr, &ri.ichunk_blocks,
+			&XFS_RMAP_OINFO_INODES);
+
+out_bitmap:
+	xagb_bitmap_destroy(&ri.inobt_blocks);
+	xagb_bitmap_destroy(&ri.ichunk_blocks);
+	return error;
+}
+
+/* Record a CoW staging extent. */
+STATIC int
+xrep_rmap_walk_cowblocks(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_refcount_irec	*irec,
+	void				*priv)
+{
+	struct xagb_bitmap		*bitmap = priv;
+
+	if (!xfs_refcount_check_domain(irec) ||
+	    irec->rc_domain != XFS_REFC_DOMAIN_COW)
+		return -EFSCORRUPTED;
+
+	return xagb_bitmap_set(bitmap, irec->rc_startblock, irec->rc_blockcount);
+}
+
+/*
+ * Collect rmaps for the blocks containing the refcount btree, and all CoW
+ * staging extents.
+ */
+STATIC int
+xrep_rmap_find_refcount_rmaps(
+	struct xrep_rmap	*rr)
+{
+	struct xagb_bitmap	refcountbt_blocks;	/* REFCBIT */
+	struct xagb_bitmap	cow_blocks;		/* COWBIT */
+	struct xfs_refcount_irec low = {
+		.rc_startblock	= 0,
+		.rc_domain	= XFS_REFC_DOMAIN_COW,
+	};
+	struct xfs_refcount_irec high = {
+		.rc_startblock	= -1U,
+		.rc_domain	= XFS_REFC_DOMAIN_COW,
+	};
+	struct xfs_scrub	*sc = rr->sc;
+	int			error;
+
+	if (!xfs_has_reflink(sc->mp))
+		return 0;
+
+	xagb_bitmap_init(&refcountbt_blocks);
+	xagb_bitmap_init(&cow_blocks);
+
+	/* refcountbt */
+	error = xagb_bitmap_set_btblocks(&refcountbt_blocks, sc->sa.refc_cur);
+	if (error)
+		goto out_bitmap;
+
+	/* Collect rmaps for CoW staging extents. */
+	error = xfs_refcount_query_range(sc->sa.refc_cur, &low, &high,
+			xrep_rmap_walk_cowblocks, &cow_blocks);
+	if (error)
+		goto out_bitmap;
+
+	/* Generate rmaps for everything. */
+	error = xrep_rmap_stash_bitmap(rr, &cow_blocks, &XFS_RMAP_OINFO_COW);
+	if (error)
+		goto out_bitmap;
+	error = xrep_rmap_stash_bitmap(rr, &refcountbt_blocks,
+			&XFS_RMAP_OINFO_REFC);
+
+out_bitmap:
+	xagb_bitmap_destroy(&cow_blocks);
+	xagb_bitmap_destroy(&refcountbt_blocks);
+	return error;
+}
+
+/* Generate rmaps for the AG headers (AGI/AGF/AGFL) */
+STATIC int
+xrep_rmap_find_agheader_rmaps(
+	struct xrep_rmap	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+
+	/* Create a record for the AG sb->agfl. */
+	return xrep_rmap_stash(rr, XFS_SB_BLOCK(sc->mp),
+			XFS_AGFL_BLOCK(sc->mp) - XFS_SB_BLOCK(sc->mp) + 1,
+			XFS_RMAP_OWN_FS, 0, 0);
+}
+
+/* Generate rmaps for the log, if it's in this AG. */
+STATIC int
+xrep_rmap_find_log_rmaps(
+	struct xrep_rmap	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+
+	if (!xfs_ag_contains_log(sc->mp, sc->sa.pag->pag_agno))
+		return 0;
+
+	return xrep_rmap_stash(rr,
+			XFS_FSB_TO_AGBNO(sc->mp, sc->mp->m_sb.sb_logstart),
+			sc->mp->m_sb.sb_logblocks, XFS_RMAP_OWN_LOG, 0, 0);
+}
+
+/*
+ * Generate all the reverse-mappings for this AG, a list of the old rmapbt
+ * blocks, and the new btreeblks count.  Figure out if we have enough free
+ * space to reconstruct the inode btrees.  The caller must clean up the lists
+ * if anything goes wrong.  This implements section (I) above.
+ */
+STATIC int
+xrep_rmap_find_rmaps(
+	struct xrep_rmap	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	struct xchk_ag		*sa = &sc->sa;
+	struct xfs_inode	*ip;
+	int			error;
+
+	/* Find all the per-AG metadata. */
+	xrep_ag_btcur_init(sc, &sc->sa);
+
+	error = xrep_rmap_find_inode_rmaps(rr);
+	if (error)
+		goto end_agscan;
+
+	error = xrep_rmap_find_refcount_rmaps(rr);
+	if (error)
+		goto end_agscan;
+
+	error = xrep_rmap_find_agheader_rmaps(rr);
+	if (error)
+		goto end_agscan;
+
+	error = xrep_rmap_find_log_rmaps(rr);
+end_agscan:
+	xchk_ag_btcur_free(&sc->sa);
+	if (error)
+		return error;
+
+	/*
+	 * Set up for a potentially lengthy filesystem scan by reducing our
+	 * transaction resource usage for the duration.  Specifically:
+	 *
+	 * Unlock the AG header buffers and cancel the transaction to release
+	 * the log grant space while we scan the filesystem.
+	 *
+	 * Create a new empty transaction to eliminate the possibility of the
+	 * inode scan deadlocking on cyclical metadata.
+	 *
+	 * We pass the empty transaction to the file scanning function to avoid
+	 * repeatedly cycling empty transactions.  This can be done even though
+	 * we take the IOLOCK to quiesce the file because empty transactions
+	 * do not take sb_internal.
+	 */
+	sa->agf_bp = NULL;
+	sa->agi_bp = NULL;
+	xchk_trans_cancel(sc);
+	error = xchk_trans_alloc_empty(sc);
+	if (error)
+		return error;
+
+	/* Iterate all AGs for inodes rmaps. */
+	while ((error = xchk_iscan_iter(sc, &rr->iscan, &ip)) == 1) {
+		error = xrep_rmap_scan_inode(rr, ip);
+		xchk_irele(sc, ip);
+		if (error)
+			break;
+
+		if (xchk_should_terminate(sc, &error))
+			break;
+	}
+	if (error)
+		return error;
+
+	/*
+	 * Switch out for a real transaction and lock the AG headers in
+	 * preparation for building a new tree.
+	 */
+	xchk_trans_cancel(sc);
+	error = xchk_setup_fs(sc);
+	if (error)
+		return error;
+	return xchk_perag_lock(sc);
+}
+
+/* Section (II): Reserving space for new rmapbt and setting free space bitmap */
+
+struct xrep_rmap_agfl {
+	struct xagb_bitmap	*bitmap;
+	xfs_agnumber_t		agno;
+};
+
+/* Add an AGFL block to the rmap list. */
+STATIC int
+xrep_rmap_walk_agfl(
+	struct xfs_mount	*mp,
+	xfs_agblock_t		agbno,
+	void			*priv)
+{
+	struct xrep_rmap_agfl	*ra = priv;
+
+	return xagb_bitmap_set(ra->bitmap, agbno, 1);
+}
+
+/*
+ * Run one round of reserving space for the new rmapbt and recomputing the
+ * number of blocks needed to store the previously observed rmapbt records and
+ * the ones we'll create for the free space metadata.  When we don't need more
+ * blocks, return a bitmap of OWN_AG extents in @freesp_blocks and set @done to
+ * true.
+ */
+STATIC int
+xrep_rmap_try_reserve(
+	struct xrep_rmap	*rr,
+	struct xfs_btree_cur	*rmap_cur,
+	uint64_t		nr_records,
+	struct xagb_bitmap	*freesp_blocks,
+	uint64_t		*blocks_reserved,
+	bool			*done)
+{
+	struct xrep_rmap_agfl	ra = {
+		.bitmap		= freesp_blocks,
+		.agno		= rr->sc->sa.pag->pag_agno,
+	};
+	struct xfs_scrub	*sc = rr->sc;
+	struct xrep_newbt_resv	*resv, *n;
+	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
+	struct xfs_buf		*agfl_bp;
+	uint64_t		nr_blocks;	/* RMB */
+	uint64_t		freesp_records;
+	int			error;
+
+	/*
+	 * We're going to recompute new_btree.bload.nr_blocks at the end of
+	 * this function to reflect however many btree blocks we need to store
+	 * all the rmap records (including the ones that reflect the changes we
+	 * made to support the new rmapbt blocks), so we save the old value
+	 * here so we can decide if we've reserved enough blocks.
+	 */
+	nr_blocks = rr->new_btree.bload.nr_blocks;
+
+	/*
+	 * Make sure we've reserved enough space for the new btree.  This can
+	 * change the shape of the free space btrees, which can cause secondary
+	 * interactions with the rmap records because all three space btrees
+	 * have the same rmap owner.  We'll account for all that below.
+	 */
+	error = xrep_newbt_alloc_blocks(&rr->new_btree,
+			nr_blocks - *blocks_reserved);
+	if (error)
+		return error;
+
+	*blocks_reserved = rr->new_btree.bload.nr_blocks;
+
+	/* Clear everything in the bitmap. */
+	xagb_bitmap_destroy(freesp_blocks);
+
+	/* Set all the bnobt blocks in the bitmap. */
+	sc->sa.bno_cur = xfs_allocbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+			sc->sa.pag, XFS_BTNUM_BNO);
+	error = xagb_bitmap_set_btblocks(freesp_blocks, sc->sa.bno_cur);
+	xfs_btree_del_cursor(sc->sa.bno_cur, error);
+	sc->sa.bno_cur = NULL;
+	if (error)
+		return error;
+
+	/* Set all the cntbt blocks in the bitmap. */
+	sc->sa.cnt_cur = xfs_allocbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+			sc->sa.pag, XFS_BTNUM_CNT);
+	error = xagb_bitmap_set_btblocks(freesp_blocks, sc->sa.cnt_cur);
+	xfs_btree_del_cursor(sc->sa.cnt_cur, error);
+	sc->sa.cnt_cur = NULL;
+	if (error)
+		return error;
+
+	/* Record our new btreeblks value. */
+	rr->freesp_btblocks = xagb_bitmap_hweight(freesp_blocks) - 2;
+
+	/* Set all the new rmapbt blocks in the bitmap. */
+	for_each_xrep_newbt_reservation(&rr->new_btree, resv, n) {
+		error = xagb_bitmap_set(freesp_blocks, resv->agbno, resv->len);
+		if (error)
+			return error;
+	}
+
+	/* Set all the AGFL blocks in the bitmap. */
+	error = xfs_alloc_read_agfl(sc->sa.pag, sc->tp, &agfl_bp);
+	if (error)
+		return error;
+
+	error = xfs_agfl_walk(sc->mp, agf, agfl_bp, xrep_rmap_walk_agfl, &ra);
+	if (error)
+		return error;
+
+	/* Count the extents in the bitmap. */
+	freesp_records = xagb_bitmap_count_set_regions(freesp_blocks);
+
+	/* Compute how many blocks we'll need for all the rmaps. */
+	error = xfs_btree_bload_compute_geometry(rmap_cur,
+			&rr->new_btree.bload, nr_records + freesp_records);
+	if (error)
+		return error;
+
+	/* We're done when we don't need more blocks. */
+	*done = nr_blocks >= rr->new_btree.bload.nr_blocks;
+	return 0;
+}
+
+/*
+ * Iteratively reserve space for rmap btree while recording OWN_AG rmaps for
+ * the free space metadata.  This implements section (II) above.
+ */
+STATIC int
+xrep_rmap_reserve_space(
+	struct xrep_rmap	*rr,
+	struct xfs_btree_cur	*rmap_cur)
+{
+	struct xagb_bitmap	freesp_blocks;	/* AGBIT */
+	uint64_t		nr_records;	/* NR */
+	uint64_t		blocks_reserved = 0;
+	bool			done = false;
+	int			error;
+
+	nr_records = xfarray_length(rr->rmap_records);
+
+	/* Compute how many blocks we'll need for the rmaps collected so far. */
+	error = xfs_btree_bload_compute_geometry(rmap_cur,
+			&rr->new_btree.bload, nr_records);
+	if (error)
+		return error;
+
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(rr->sc, &error))
+		return error;
+
+	xagb_bitmap_init(&freesp_blocks);
+
+	/*
+	 * Iteratively reserve space for the new rmapbt and recompute the
+	 * number of blocks needed to store the previously observed rmapbt
+	 * records and the ones we'll create for the free space metadata.
+	 * Finish when we don't need more blocks.
+	 */
+	do {
+		error = xrep_rmap_try_reserve(rr, rmap_cur, nr_records,
+				&freesp_blocks, &blocks_reserved, &done);
+		if (error)
+			goto out_bitmap;
+	} while (!done);
+
+	/* Emit rmaps for everything in the free space bitmap. */
+	xrep_ag_btcur_init(rr->sc, &rr->sc->sa);
+	error = xrep_rmap_stash_bitmap(rr, &freesp_blocks, &XFS_RMAP_OINFO_AG);
+	xchk_ag_btcur_free(&rr->sc->sa);
+
+out_bitmap:
+	xagb_bitmap_destroy(&freesp_blocks);
+	return error;
+}
+
+/* Section (III): Building the new rmap btree. */
+
+/* Update the AGF counters. */
+STATIC int
+xrep_rmap_reset_counters(
+	struct xrep_rmap	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_perag	*pag = sc->sa.pag;
+	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
+	xfs_agblock_t		rmap_btblocks;
+
+	/*
+	 * The AGF header contains extra information related to the reverse
+	 * mapping btree, so we must update those fields here.
+	 */
+	rmap_btblocks = rr->new_btree.afake.af_blocks - 1;
+	agf->agf_btreeblks = cpu_to_be32(rr->freesp_btblocks + rmap_btblocks);
+	xfs_alloc_log_agf(sc->tp, sc->sa.agf_bp, XFS_AGF_BTREEBLKS);
+
+	/*
+	 * After we commit the new btree to disk, it is possible that the
+	 * process to reap the old btree blocks will race with the AIL trying
+	 * to checkpoint the old btree blocks into the filesystem.  If the new
+	 * tree is shorter than the old one, the rmapbt write verifier will
+	 * fail and the AIL will shut down the filesystem.
+	 *
+	 * To avoid this, save the old incore btree height values as the alt
+	 * height values before re-initializing the perag info from the updated
+	 * AGF to capture all the new values.
+	 */
+	pag->pagf_alt_levels[XFS_BTNUM_RMAPi] =
+					pag->pagf_levels[XFS_BTNUM_RMAPi];
+
+	/* Reinitialize with the values we just logged. */
+	return xrep_reinit_pagf(sc);
+}
+
+/* Retrieve rmapbt data for bulk load. */
+STATIC int
+xrep_rmap_get_records(
+	struct xfs_btree_cur	*cur,
+	unsigned int		idx,
+	struct xfs_btree_block	*block,
+	unsigned int		nr_wanted,
+	void			*priv)
+{
+	struct xrep_rmap_extent	rec;
+	struct xfs_rmap_irec	*irec = &cur->bc_rec.r;
+	struct xrep_rmap	*rr = priv;
+	union xfs_btree_rec	*block_rec;
+	unsigned int		loaded;
+	int			error;
+
+	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
+		error = xfarray_load_next(rr->rmap_records, &rr->array_cur,
+				&rec);
+		if (error)
+			return error;
+
+		irec->rm_startblock = rec.startblock;
+		irec->rm_blockcount = rec.blockcount;
+		irec->rm_owner = rec.owner;
+		if (xfs_rmap_irec_offset_unpack(rec.offset, irec) != NULL)
+			return -EFSCORRUPTED;
+
+		error = xrep_rmap_check_mapping(rr->sc, irec);
+		if (error)
+			return error;
+
+		block_rec = xfs_btree_rec_addr(cur, idx, block);
+		cur->bc_ops->init_rec_from_cur(cur, block_rec);
+	}
+
+	return loaded;
+}
+
+/* Feed one of the new btree blocks to the bulk loader. */
+STATIC int
+xrep_rmap_claim_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct xrep_rmap        *rr = priv;
+	int			error;
+
+	error = xrep_newbt_relog_autoreap(&rr->new_btree);
+	if (error)
+		return error;
+
+	return xrep_newbt_claim_block(cur, &rr->new_btree, ptr);
+}
+
+/* Custom allocation function for new rmap btrees. */
+STATIC int
+xrep_rmap_alloc_vextent(
+	struct xfs_scrub	*sc,
+	struct xfs_alloc_arg	*args)
+{
+	int			error;
+
+	/*
+	 * We don't want an rmap update on the allocation, since we iteratively
+	 * compute the OWN_AG records /after/ allocating blocks for the records
+	 * that we already know we need to store.  Therefore, fix the freelist
+	 * with the NORMAP flag set so that we don't also try to create an rmap
+	 * for new AGFL blocks.
+	 */
+	error = xrep_fix_freelist(sc, XFS_ALLOC_FLAG_NORMAP);
+	if (error)
+		return error;
+
+	/*
+	 * If xrep_fix_freelist fixed the freelist by moving blocks from the
+	 * free space btrees or by removing blocks from the AGFL and queueing
+	 * an EFI to free the block, the transaction will be dirty.  This
+	 * second case is of interest to us.
+	 *
+	 * Later on, we will need to compare gaps in the new recordset against
+	 * the block usage of all OWN_AG owners in order to free the old
+	 * btree's blocks, which means that we can't have EFIs for former AGFL
+	 * blocks attached to the repair transaction when we commit the new
+	 * btree.
+	 *
+	 * xrep_newbt_alloc_blocks guarantees this for us by calling
+	 * xrep_defer_finish to commit anything that fix_freelist may have
+	 * added to the transaction.
+	 */
+	return xfs_alloc_vextent(args);
+}
+
+/*
+ * Use the collected rmap information to stage a new rmap btree.  If this is
+ * successful we'll return with the new btree root information logged to the
+ * repair transaction but not yet committed.  This implements section (III)
+ * above.
+ */
+STATIC int
+xrep_rmap_build_new_tree(
+	struct xrep_rmap	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_perag	*pag = sc->sa.pag;
+	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
+	struct xfs_btree_cur	*rmap_cur;
+	xfs_fsblock_t		fsbno;
+	int			error;
+
+	/*
+	 * Preserve the old rmapbt block count so that we can adjust the
+	 * per-AG rmapbt reservation after we commit the new btree root and
+	 * want to dispose of the old btree blocks.
+	 */
+	rr->old_rmapbt_fsbcount = be32_to_cpu(agf->agf_rmap_blocks);
+
+	/*
+	 * Prepare to construct the new btree by reserving disk space for the
+	 * new btree and setting up all the accounting information we'll need
+	 * to root the new btree while it's under construction and before we
+	 * attach it to the AG header.  The new blocks are accounted to the
+	 * rmapbt per-AG reservation, which we will adjust further after
+	 * committing the new btree.
+	 */
+	fsbno = XFS_AGB_TO_FSB(sc->mp, pag->pag_agno, XFS_RMAP_BLOCK(sc->mp));
+	xrep_newbt_init_ag(&rr->new_btree, sc, &XFS_RMAP_OINFO_SKIP_UPDATE,
+			fsbno, XFS_AG_RESV_RMAPBT);
+	rr->new_btree.bload.get_records = xrep_rmap_get_records;
+	rr->new_btree.bload.claim_block = xrep_rmap_claim_block;
+	rr->new_btree.alloc_vextent = xrep_rmap_alloc_vextent;
+	rmap_cur = xfs_rmapbt_stage_cursor(sc->mp, &rr->new_btree.afake, pag);
+
+	/*
+	 * Initialize @rr->new_btree, reserve space for the new rmapbt,
+	 * and compute OWN_AG rmaps.
+	 */
+	error = xrep_rmap_reserve_space(rr, rmap_cur);
+	if (error)
+		goto err_cur;
+
+	/*
+	 * Due to btree slack factors, it's possible for a new btree to be one
+	 * level taller than the old btree.  Update the incore btree height so
+	 * that we don't trip the verifiers when writing the new btree blocks
+	 * to disk.
+	 */
+	pag->pagf_alt_levels[XFS_BTNUM_RMAPi] =
+					rr->new_btree.bload.btree_height;
+
+	/* Add all observed rmap records. */
+	rr->array_cur = XFARRAY_CURSOR_INIT;
+	sc->sa.bno_cur = xfs_allocbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+			sc->sa.pag, XFS_BTNUM_BNO);
+	error = xfs_btree_bload(rmap_cur, &rr->new_btree.bload, rr);
+	xfs_btree_del_cursor(sc->sa.bno_cur, error);
+	sc->sa.bno_cur = NULL;
+	if (error)
+		goto err_level;
+
+	/*
+	 * Install the new btree in the AG header.  After this point the old
+	 * btree is no longer accessible and the new tree is live.
+	 */
+	xfs_rmapbt_commit_staged_btree(rmap_cur, sc->tp, sc->sa.agf_bp);
+	xfs_btree_del_cursor(rmap_cur, 0);
+
+	/*
+	 * The newly committed rmap recordset includes mappings for the blocks
+	 * that we reserved to build the new btree.  If there is excess space
+	 * reservation to be freed, the corresponding rmap records must also be
+	 * removed.
+	 */
+	rr->new_btree.oinfo = XFS_RMAP_OINFO_AG;
+
+	/* Reset the AGF counters now that we've changed the btree shape. */
+	error = xrep_rmap_reset_counters(rr);
+	if (error)
+		goto err_newbt;
+
+	/* Dispose of any unused blocks and the accounting information. */
+	error = xrep_newbt_commit(&rr->new_btree);
+	if (error)
+		return error;
+
+	return xrep_roll_ag_trans(sc);
+
+err_level:
+	pag->pagf_alt_levels[XFS_BTNUM_RMAPi] = 0;
+err_cur:
+	xfs_btree_del_cursor(rmap_cur, error);
+err_newbt:
+	xrep_newbt_cancel(&rr->new_btree);
+	return error;
+}
+
+/* Section (IV): Reaping the old btree. */
+
+struct xrep_rmap_find_gaps {
+	struct xagb_bitmap	rmap_gaps;
+	xfs_agblock_t		next_agbno;
+};
+
+/* Subtract each free extent in the bnobt from the rmap gaps. */
+STATIC int
+xrep_rmap_find_freesp(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_alloc_rec_incore *rec,
+	void				*priv)
+{
+	struct xrep_rmap_find_gaps	*rfg = priv;
+
+	return xagb_bitmap_clear(&rfg->rmap_gaps, rec->ar_startblock,
+			rec->ar_blockcount);
+}
+
+/*
+ * Reap the old rmapbt blocks.  Now that the rmapbt is fully rebuilt, we make
+ * a list of gaps in the rmap records and a list of the extents mentioned in
+ * the bnobt.  Any block that's in the new rmapbt gap list but not mentioned
+ * in the bnobt is a block from the old rmapbt and can be removed.
+ */
+STATIC int
+xrep_rmap_remove_old_tree(
+	struct xrep_rmap	*rr)
+{
+	struct xrep_rmap_find_gaps rfg = {
+		.next_agbno	= 0,
+	};
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
+	struct xfs_perag	*pag = sc->sa.pag;
+	xfs_agblock_t		agend;
+	xfarray_idx_t		array_cur;
+	int			error;
+
+	xagb_bitmap_init(&rfg.rmap_gaps);
+
+	/* Compute free space from the new rmapbt. */
+	foreach_xfarray_idx(rr->rmap_records, array_cur) {
+		struct xrep_rmap_extent	rec;
+
+		error = xfarray_load(rr->rmap_records, array_cur, &rec);
+		if (error)
+			goto out_bitmap;
+
+		/* Record the free space we find. */
+		if (rec.startblock > rfg.next_agbno) {
+			error = xagb_bitmap_set(&rfg.rmap_gaps, rfg.next_agbno,
+					rec.startblock - rfg.next_agbno);
+			if (error)
+				goto out_bitmap;
+		}
+		rfg.next_agbno = max_t(xfs_agblock_t, rfg.next_agbno,
+					rec.startblock + rec.blockcount);
+	}
+
+	/* Insert a record for space between the last rmap and EOAG. */
+	agend = be32_to_cpu(agf->agf_length);
+	if (rfg.next_agbno < agend) {
+		error = xagb_bitmap_set(&rfg.rmap_gaps, rfg.next_agbno,
+				agend - rfg.next_agbno);
+		if (error)
+			goto out_bitmap;
+	}
+
+	/* Compute free space from the existing bnobt. */
+	sc->sa.bno_cur = xfs_allocbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+			sc->sa.pag, XFS_BTNUM_BNO);
+	error = xfs_alloc_query_all(sc->sa.bno_cur, xrep_rmap_find_freesp,
+			&rfg);
+	xfs_btree_del_cursor(sc->sa.bno_cur, error);
+	sc->sa.bno_cur = NULL;
+	if (error)
+		goto out_bitmap;
+
+	/*
+	 * Free the "free" blocks that the new rmapbt knows about but the bnobt
+	 * doesn't--these are the old rmapbt blocks.  Credit the old rmapbt
+	 * block usage count back to the per-AG rmapbt reservation (and not
+	 * fdblocks, since the rmap btree lives in free space) to keep the
+	 * reservation and free space accounting correct.
+	 */
+	error = xrep_reap_agblocks(sc, &rfg.rmap_gaps,
+			&XFS_RMAP_OINFO_ANY_OWNER, XFS_AG_RESV_IGNORE);
+	if (error)
+		goto out_bitmap;
+	sc->sa.pag->pag_rmapbt_resv.ar_reserved += rr->old_rmapbt_fsbcount;
+
+	/*
+	 * Now that we've zapped all the old rmapbt blocks we can turn off
+	 * the alternate height mechanism and reset the per-AG space
+	 * reservation.
+	 */
+	pag->pagf_alt_levels[XFS_BTNUM_RMAPi] = 0;
+	sc->flags |= XREP_RESET_PERAG_RESV;
+out_bitmap:
+	xagb_bitmap_destroy(&rfg.rmap_gaps);
+	return error;
+}
+
+/* Repair the rmap btree for some AG. */
+int
+xrep_rmapbt(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_rmap	*rr;
+	int			error;
+
+	/* Functionality is not yet complete. */
+	return xrep_notsupported(sc);
+
+	rr = kzalloc(sizeof(struct xrep_rmap), XCHK_GFP_FLAGS);
+	if (!rr)
+		return -ENOMEM;
+	rr->sc = sc;
+
+	/* Set up some storage */
+	error = xfarray_create(sc->mp, "rmap records", 0,
+			sizeof(struct xrep_rmap_extent), &rr->rmap_records);
+	if (error)
+		goto out_rr;
+
+	/* Retry iget every tenth of a second for up to 30 seconds. */
+	xchk_iscan_start(&rr->iscan, 30000, 100);
+
+	/*
+	 * Collect rmaps for everything in this AG that isn't space metadata.
+	 * These rmaps won't change even as we try to allocate blocks.
+	 */
+	error = xrep_rmap_find_rmaps(rr);
+	if (error)
+		goto out_records;
+
+	/* Rebuild the rmap information. */
+	error = xrep_rmap_build_new_tree(rr);
+	if (error)
+		goto out_records;
+
+	/* Kill the old tree. */
+	error = xrep_rmap_remove_old_tree(rr);
+
+out_records:
+	xchk_iscan_finish(&rr->iscan);
+	xfarray_destroy(rr->rmap_records);
+out_rr:
+	kfree(rr);
+	return error;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 5bbc12649277..f030311fae2b 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -278,7 +278,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.setup	= xchk_setup_ag_rmapbt,
 		.scrub	= xchk_rmapbt,
 		.has	= xfs_has_rmapbt,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_rmapbt,
 	},
 	[XFS_SCRUB_TYPE_REFCNTBT] = {	/* refcountbt */
 		.type	= ST_PERAG,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 05b6a6e3d0ab..53aafc70878b 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1426,7 +1426,6 @@ DEFINE_EVENT(xrep_rmap_class, name, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
 	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
 DEFINE_REPAIR_RMAP_EVENT(xrep_ibt_walk_rmap);
-DEFINE_REPAIR_RMAP_EVENT(xrep_rmap_extent_fn);
 DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_walk_rmap);
 
 TRACE_EVENT(xrep_abt_found,
@@ -1544,6 +1543,38 @@ TRACE_EVENT(xrep_bmap_found,
 		  __entry->state)
 );
 
+TRACE_EVENT(xrep_rmap_found,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 const struct xfs_rmap_irec *rec),
+	TP_ARGS(mp, agno, rec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+		__field(uint64_t, owner)
+		__field(uint64_t, offset)
+		__field(unsigned int, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = rec->rm_startblock;
+		__entry->len = rec->rm_blockcount;
+		__entry->owner = rec->rm_owner;
+		__entry->offset = rec->rm_offset;
+		__entry->flags = rec->rm_flags;
+	),
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len,
+		  __entry->owner,
+		  __entry->offset,
+		  __entry->flags)
+);
+
 TRACE_EVENT(xrep_findroot_block,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
 		 uint32_t magic, uint16_t level),

