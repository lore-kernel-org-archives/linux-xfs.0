Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A107BC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344725AbiATA0K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:26:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33390 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345413AbiATA0J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:26:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48C8E61514
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C4EC004E1;
        Thu, 20 Jan 2022 00:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638368;
        bh=rRglsgntePMG00Y6LsNAHsVpRausg4nOtwWiCnCAFYc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=G86CiwoecepoUyaxI9nbnqwRvcc7tcotwTRDFwc6hy+XhFBYuOuLmm25IJdFynJR/
         kEH48VBizSwmAg/TBGBaYh9bUq8k/20PfPI02J9HmuVjaTk/zQviUiI01YkGXsq7un
         YtbtVB1zk2N6vh8JoGbzVknJt+evYQza7RwCT5h+liEfOzVFWDOkcZC9jD6ZaNwei8
         NkLNT1lSQ9GeeXIDtm9gRQjW3Qi5rTnITXM0NYIQ7fCrS+emZowkaonkGyfqbislAD
         mV/HhA+8qs6pzqiuP9Q163641J1svPqqcLV7SjZlydDsKY6pH4FfWo66PDTWU9gY9b
         HiWUa8x0mV2PA==
Subject: [PATCH 32/48] xfs: use separate btree cursor cache for each btree
 type
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:26:08 -0800
Message-ID: <164263836830.865554.11598846562233200947.stgit@magnolia>
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

Source kernel commit: 9fa47bdcd33b117599e9ee3f2e315cb47939ac2d

Now that we have the infrastructure to track the max possible height of
each btree type, we can create a separate slab cache for cursors of each
type of btree.  For smaller indices like the free space btrees, this
means that we can pack more cursors into a slab page, improving slab
utilization.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/kmem.h              |   27 +++++++++++++++++++----
 include/platform_defs.h.in  |    3 +++
 libxfs/init.c               |   11 +++++++--
 libxfs/kmem.c               |   22 ++++++++++++++++---
 libxfs/xfs_alloc_btree.c    |   23 +++++++++++++++++++
 libxfs/xfs_alloc_btree.h    |    3 +++
 libxfs/xfs_bmap_btree.c     |   23 +++++++++++++++++++
 libxfs/xfs_bmap_btree.h     |    3 +++
 libxfs/xfs_btree.c          |   51 ++++++++++++++++++++++++++++++++++++++-----
 libxfs/xfs_btree.h          |   20 +++++++----------
 libxfs/xfs_ialloc_btree.c   |   23 +++++++++++++++++++
 libxfs/xfs_ialloc_btree.h   |    3 +++
 libxfs/xfs_refcount_btree.c |   23 +++++++++++++++++++
 libxfs/xfs_refcount_btree.h |    3 +++
 libxfs/xfs_rmap_btree.c     |   23 +++++++++++++++++++
 libxfs/xfs_rmap_btree.h     |    3 +++
 16 files changed, 231 insertions(+), 33 deletions(-)


diff --git a/include/kmem.h b/include/kmem.h
index 6d317256..c710635d 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -12,9 +12,11 @@
 #define KM_NOLOCKDEP	0x0020u
 
 typedef struct kmem_zone {
-	int	zone_unitsize;	/* Size in bytes of zone unit           */
-	char	*zone_name;	/* tag name                             */
-	int	allocated;	/* debug: How many currently allocated  */
+	int		zone_unitsize;	/* Size in bytes of zone unit */
+	int		allocated;	/* debug: How many allocated? */
+	unsigned int	align;
+	const char	*zone_name;	/* tag name */
+	void		(*ctor)(void *);
 } kmem_zone_t;
 
 typedef unsigned int __bitwise gfp_t;
@@ -26,11 +28,28 @@ typedef unsigned int __bitwise gfp_t;
 
 #define __GFP_ZERO	(__force gfp_t)1
 
-extern kmem_zone_t *kmem_zone_init(int, char *);
+kmem_zone_t * kmem_cache_create(const char *name, unsigned int size,
+		unsigned int align, unsigned int slab_flags,
+		void (*ctor)(void *));
+
+static inline kmem_zone_t *
+kmem_zone_init(unsigned int size, const char *name)
+{
+	return kmem_cache_create(name, size, 0, 0, NULL);
+}
+
 extern void	*kmem_cache_alloc(kmem_zone_t *, gfp_t);
 extern void	*kmem_cache_zalloc(kmem_zone_t *, gfp_t);
 extern int	kmem_zone_destroy(kmem_zone_t *);
 
+
+static inline void
+kmem_cache_destroy(kmem_zone_t *zone)
+{
+	kmem_zone_destroy(zone);
+}
+
+
 static inline void
 kmem_cache_free(kmem_zone_t *zone, void *ptr)
 {
diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 6e6f26ef..315ad77c 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -134,4 +134,7 @@ static inline size_t __ab_c_size(size_t a, size_t b, size_t c)
 #    define fallthrough                    do {} while (0)  /* fallthrough */
 #endif
 
+/* Only needed for the kernel. */
+#define __init
+
 #endif	/* __XFS_PLATFORM_DEFS_H__ */
diff --git a/libxfs/init.c b/libxfs/init.c
index 12e25379..3c1639db 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -231,6 +231,8 @@ check_open(char *path, int flags, char **rawfile, char **blockfile)
 static void
 init_zones(void)
 {
+	int		error;
+
 	/* initialise zone allocation */
 	xfs_buf_zone = kmem_zone_init(sizeof(struct xfs_buf), "xfs_buffer");
 	xfs_inode_zone = kmem_zone_init(sizeof(struct xfs_inode), "xfs_inode");
@@ -241,8 +243,11 @@ init_zones(void)
 			sizeof(struct xfs_buf_log_item), "xfs_buf_log_item");
 	xfs_da_state_zone = kmem_zone_init(
 			sizeof(struct xfs_da_state), "xfs_da_state");
-	xfs_btree_cur_zone = kmem_zone_init(
-			sizeof(struct xfs_btree_cur), "xfs_btree_cur");
+	error = xfs_btree_init_cur_caches();
+	if (error) {
+		fprintf(stderr, "Could not allocate btree cursor caches.\n");
+		abort();
+	}
 	xfs_bmap_free_item_zone = kmem_zone_init(
 			sizeof(struct xfs_extent_free_item),
 			"xfs_bmap_free_item");
@@ -261,7 +266,7 @@ destroy_zones(void)
 	leaked += kmem_zone_destroy(xfs_ifork_zone);
 	leaked += kmem_zone_destroy(xfs_buf_item_zone);
 	leaked += kmem_zone_destroy(xfs_da_state_zone);
-	leaked += kmem_zone_destroy(xfs_btree_cur_zone);
+	xfs_btree_destroy_cur_caches();
 	leaked += kmem_zone_destroy(xfs_bmap_free_item_zone);
 	leaked += kmem_zone_destroy(xfs_trans_zone);
 
diff --git a/libxfs/kmem.c b/libxfs/kmem.c
index 3d72ac94..221b3480 100644
--- a/libxfs/kmem.c
+++ b/libxfs/kmem.c
@@ -6,9 +6,9 @@
 /*
  * Simple memory interface
  */
-
 kmem_zone_t *
-kmem_zone_init(int size, char *name)
+kmem_cache_create(const char *name, unsigned int size, unsigned int align,
+		  unsigned int slab_flags, void (*ctor)(void *))
 {
 	kmem_zone_t	*ptr = malloc(sizeof(kmem_zone_t));
 
@@ -21,6 +21,9 @@ kmem_zone_init(int size, char *name)
 	ptr->zone_unitsize = size;
 	ptr->zone_name = name;
 	ptr->allocated = 0;
+	ptr->align = align;
+	ptr->ctor = ctor;
+
 	return ptr;
 }
 
@@ -41,7 +44,17 @@ kmem_zone_destroy(kmem_zone_t *zone)
 void *
 kmem_cache_alloc(kmem_zone_t *zone, gfp_t flags)
 {
-	void	*ptr = malloc(zone->zone_unitsize);
+	void	*ptr = NULL;
+
+	if (zone->align) {
+		int ret;
+
+		ret = posix_memalign(&ptr, zone->align, zone->zone_unitsize);
+		if (ret)
+			errno = ret;
+	} else {
+		ptr = malloc(zone->zone_unitsize);
+	}
 
 	if (ptr == NULL) {
 		fprintf(stderr, _("%s: zone alloc failed (%s, %d bytes): %s\n"),
@@ -49,6 +62,9 @@ kmem_cache_alloc(kmem_zone_t *zone, gfp_t flags)
 			strerror(errno));
 		exit(1);
 	}
+
+	if (zone->ctor)
+		zone->ctor(ptr);
 	zone->allocated++;
 	return ptr;
 }
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 6de3af37..2176a923 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -18,6 +18,7 @@
 #include "xfs_trans.h"
 #include "xfs_ag.h"
 
+static kmem_zone_t	*xfs_allocbt_cur_cache;
 
 STATIC struct xfs_btree_cur *
 xfs_allocbt_dup_cursor(
@@ -475,7 +476,8 @@ xfs_allocbt_init_common(
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
-	cur = xfs_btree_alloc_cursor(mp, tp, btnum, mp->m_alloc_maxlevels);
+	cur = xfs_btree_alloc_cursor(mp, tp, btnum, mp->m_alloc_maxlevels,
+			xfs_allocbt_cur_cache);
 	cur->bc_ag.abt.active = false;
 
 	if (btnum == XFS_BTNUM_CNT) {
@@ -615,3 +617,22 @@ xfs_allocbt_calc_size(
 {
 	return xfs_btree_calc_size(mp->m_alloc_mnr, len);
 }
+
+int __init
+xfs_allocbt_init_cur_cache(void)
+{
+	xfs_allocbt_cur_cache = kmem_cache_create("xfs_bnobt_cur",
+			xfs_btree_cur_sizeof(xfs_allocbt_maxlevels_ondisk()),
+			0, 0, NULL);
+
+	if (!xfs_allocbt_cur_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void
+xfs_allocbt_destroy_cur_cache(void)
+{
+	kmem_cache_destroy(xfs_allocbt_cur_cache);
+	xfs_allocbt_cur_cache = NULL;
+}
diff --git a/libxfs/xfs_alloc_btree.h b/libxfs/xfs_alloc_btree.h
index c715bee5..45df893e 100644
--- a/libxfs/xfs_alloc_btree.h
+++ b/libxfs/xfs_alloc_btree.h
@@ -62,4 +62,7 @@ void xfs_allocbt_commit_staged_btree(struct xfs_btree_cur *cur,
 
 unsigned int xfs_allocbt_maxlevels_ondisk(void);
 
+int __init xfs_allocbt_init_cur_cache(void);
+void xfs_allocbt_destroy_cur_cache(void);
+
 #endif	/* __XFS_ALLOC_BTREE_H__ */
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 85faea1d..cde313d7 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -20,6 +20,8 @@
 #include "xfs_trace.h"
 #include "xfs_rmap.h"
 
+static kmem_zone_t	*xfs_bmbt_cur_cache;
+
 /*
  * Convert on-disk form of btree root to in-memory form.
  */
@@ -551,7 +553,7 @@ xfs_bmbt_init_cursor(
 	ASSERT(whichfork != XFS_COW_FORK);
 
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP,
-			mp->m_bm_maxlevels[whichfork]);
+			mp->m_bm_maxlevels[whichfork], xfs_bmbt_cur_cache);
 	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
@@ -673,3 +675,22 @@ xfs_bmbt_calc_size(
 {
 	return xfs_btree_calc_size(mp->m_bmap_dmnr, len);
 }
+
+int __init
+xfs_bmbt_init_cur_cache(void)
+{
+	xfs_bmbt_cur_cache = kmem_cache_create("xfs_bmbt_cur",
+			xfs_btree_cur_sizeof(xfs_bmbt_maxlevels_ondisk()),
+			0, 0, NULL);
+
+	if (!xfs_bmbt_cur_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void
+xfs_bmbt_destroy_cur_cache(void)
+{
+	kmem_cache_destroy(xfs_bmbt_cur_cache);
+	xfs_bmbt_cur_cache = NULL;
+}
diff --git a/libxfs/xfs_bmap_btree.h b/libxfs/xfs_bmap_btree.h
index 2a1c9e60..3e7a40a8 100644
--- a/libxfs/xfs_bmap_btree.h
+++ b/libxfs/xfs_bmap_btree.h
@@ -112,4 +112,7 @@ extern unsigned long long xfs_bmbt_calc_size(struct xfs_mount *mp,
 
 unsigned int xfs_bmbt_maxlevels_ondisk(void);
 
+int __init xfs_bmbt_init_cur_cache(void);
+void xfs_bmbt_destroy_cur_cache(void);
+
 #endif	/* __XFS_BMAP_BTREE_H__ */
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index e541b061..4fe2378e 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -19,11 +19,11 @@
 #include "xfs_alloc.h"
 #include "xfs_btree_staging.h"
 #include "xfs_ag.h"
-
-/*
- * Cursor allocation zone.
- */
-kmem_zone_t	*xfs_btree_cur_zone;
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_refcount_btree.h"
 
 /*
  * Btree magic numbers.
@@ -376,7 +376,7 @@ xfs_btree_del_cursor(
 		kmem_free(cur->bc_ops);
 	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
 		xfs_perag_put(cur->bc_ag.pag);
-	kmem_cache_free(xfs_btree_cur_zone, cur);
+	kmem_cache_free(cur->bc_cache, cur);
 }
 
 /*
@@ -4963,3 +4963,42 @@ xfs_btree_has_more_records(
 	else
 		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
 }
+
+/* Set up all the btree cursor caches. */
+int __init
+xfs_btree_init_cur_caches(void)
+{
+	int		error;
+
+	error = xfs_allocbt_init_cur_cache();
+	if (error)
+		return error;
+	error = xfs_inobt_init_cur_cache();
+	if (error)
+		goto err;
+	error = xfs_bmbt_init_cur_cache();
+	if (error)
+		goto err;
+	error = xfs_rmapbt_init_cur_cache();
+	if (error)
+		goto err;
+	error = xfs_refcountbt_init_cur_cache();
+	if (error)
+		goto err;
+
+	return 0;
+err:
+	xfs_btree_destroy_cur_caches();
+	return error;
+}
+
+/* Destroy all the btree cursor caches, if they've been allocated. */
+void
+xfs_btree_destroy_cur_caches(void)
+{
+	xfs_allocbt_destroy_cur_cache();
+	xfs_inobt_destroy_cur_cache();
+	xfs_bmbt_destroy_cur_cache();
+	xfs_rmapbt_destroy_cur_cache();
+	xfs_refcountbt_destroy_cur_cache();
+}
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index fdf7090c..7bc5a379 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
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
-#define XFS_BTREE_CUR_CACHE_MAXLEVELS	(9)
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
@@ -592,19 +585,22 @@ xfs_btree_alloc_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	xfs_btnum_t		btnum,
-	uint8_t			maxlevels)
+	uint8_t			maxlevels,
+	kmem_zone_t		*cache)
 {
 	struct xfs_btree_cur	*cur;
 
-	ASSERT(maxlevels <= XFS_BTREE_CUR_CACHE_MAXLEVELS);
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
 
+int __init xfs_btree_init_cur_caches(void);
+void xfs_btree_destroy_cur_caches(void);
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 30b1abe9..539e7c03 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -21,6 +21,8 @@
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 
+static kmem_zone_t	*xfs_inobt_cur_cache;
+
 STATIC int
 xfs_inobt_get_minrecs(
 	struct xfs_btree_cur	*cur,
@@ -432,7 +434,7 @@ xfs_inobt_init_common(
 	struct xfs_btree_cur	*cur;
 
 	cur = xfs_btree_alloc_cursor(mp, tp, btnum,
-			M_IGEO(mp)->inobt_maxlevels);
+			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
 	if (btnum == XFS_BTNUM_INO) {
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_ibt_2);
 		cur->bc_ops = &xfs_inobt_ops;
@@ -811,3 +813,22 @@ xfs_iallocbt_calc_size(
 {
 	return xfs_btree_calc_size(M_IGEO(mp)->inobt_mnr, len);
 }
+
+int __init
+xfs_inobt_init_cur_cache(void)
+{
+	xfs_inobt_cur_cache = kmem_cache_create("xfs_inobt_cur",
+			xfs_btree_cur_sizeof(xfs_inobt_maxlevels_ondisk()),
+			0, 0, NULL);
+
+	if (!xfs_inobt_cur_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void
+xfs_inobt_destroy_cur_cache(void)
+{
+	kmem_cache_destroy(xfs_inobt_cur_cache);
+	xfs_inobt_cur_cache = NULL;
+}
diff --git a/libxfs/xfs_ialloc_btree.h b/libxfs/xfs_ialloc_btree.h
index 6d3e4a33..26451cb7 100644
--- a/libxfs/xfs_ialloc_btree.h
+++ b/libxfs/xfs_ialloc_btree.h
@@ -77,4 +77,7 @@ void xfs_inobt_commit_staged_btree(struct xfs_btree_cur *cur,
 
 unsigned int xfs_iallocbt_maxlevels_ondisk(void);
 
+int __init xfs_inobt_init_cur_cache(void);
+void xfs_inobt_destroy_cur_cache(void);
+
 #endif	/* __XFS_IALLOC_BTREE_H__ */
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 1d7b2d7c..2c02e33e 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -20,6 +20,8 @@
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 
+static kmem_zone_t	*xfs_refcountbt_cur_cache;
+
 static struct xfs_btree_cur *
 xfs_refcountbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
@@ -322,7 +324,7 @@ xfs_refcountbt_init_common(
 	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
 
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_REFC,
-			mp->m_refc_maxlevels);
+			mp->m_refc_maxlevels, xfs_refcountbt_cur_cache);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
@@ -513,3 +515,22 @@ xfs_refcountbt_calc_reserves(
 
 	return error;
 }
+
+int __init
+xfs_refcountbt_init_cur_cache(void)
+{
+	xfs_refcountbt_cur_cache = kmem_cache_create("xfs_refcbt_cur",
+			xfs_btree_cur_sizeof(xfs_refcountbt_maxlevels_ondisk()),
+			0, 0, NULL);
+
+	if (!xfs_refcountbt_cur_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void
+xfs_refcountbt_destroy_cur_cache(void)
+{
+	kmem_cache_destroy(xfs_refcountbt_cur_cache);
+	xfs_refcountbt_cur_cache = NULL;
+}
diff --git a/libxfs/xfs_refcount_btree.h b/libxfs/xfs_refcount_btree.h
index d7f7c89c..d66b3725 100644
--- a/libxfs/xfs_refcount_btree.h
+++ b/libxfs/xfs_refcount_btree.h
@@ -67,4 +67,7 @@ void xfs_refcountbt_commit_staged_btree(struct xfs_btree_cur *cur,
 
 unsigned int xfs_refcountbt_maxlevels_ondisk(void);
 
+int __init xfs_refcountbt_init_cur_cache(void);
+void xfs_refcountbt_destroy_cur_cache(void);
+
 #endif	/* __XFS_REFCOUNT_BTREE_H__ */
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index eb3ef409..ae3329b5 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -20,6 +20,8 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 
+static kmem_zone_t	*xfs_rmapbt_cur_cache;
+
 /*
  * Reverse map btree.
  *
@@ -451,7 +453,7 @@ xfs_rmapbt_init_common(
 
 	/* Overlapping btree; 2 keys per pointer. */
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP,
-			mp->m_rmap_maxlevels);
+			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
 	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 	cur->bc_ops = &xfs_rmapbt_ops;
@@ -672,3 +674,22 @@ xfs_rmapbt_calc_reserves(
 
 	return error;
 }
+
+int __init
+xfs_rmapbt_init_cur_cache(void)
+{
+	xfs_rmapbt_cur_cache = kmem_cache_create("xfs_rmapbt_cur",
+			xfs_btree_cur_sizeof(xfs_rmapbt_maxlevels_ondisk()),
+			0, 0, NULL);
+
+	if (!xfs_rmapbt_cur_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void
+xfs_rmapbt_destroy_cur_cache(void)
+{
+	kmem_cache_destroy(xfs_rmapbt_cur_cache);
+	xfs_rmapbt_cur_cache = NULL;
+}
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
index e9778b62..3244715d 100644
--- a/libxfs/xfs_rmap_btree.h
+++ b/libxfs/xfs_rmap_btree.h
@@ -61,4 +61,7 @@ extern int xfs_rmapbt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
 
 unsigned int xfs_rmapbt_maxlevels_ondisk(void);
 
+int __init xfs_rmapbt_init_cur_cache(void);
+void xfs_rmapbt_destroy_cur_cache(void);
+
 #endif /* __XFS_RMAP_BTREE_H__ */

