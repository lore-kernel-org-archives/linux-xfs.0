Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA333C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345036AbiATA0h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:26:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33702 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiATA0h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:26:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C74F361511
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311D4C004E1;
        Thu, 20 Jan 2022 00:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638396;
        bh=/T0n0tF0XDg5UTpWkbW/sNTm3NNBNpRjZ9wBZUR8RO0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TmTRVV6V98qkKeGSw/gP3l9slIOJDQehPmEAtzf9jmt5+DhjawT7ElrO6QtobQMii
         WTvT5CIXAMnzTNyIRd60/5Cc2/ORZwaNvP+fooLqBclxqLvFxy/IZUx14lKcAEeFa2
         T0fonug3bpDg++yXxgcuDkPO5CMEFbXtzPIufbJ+cYZcvlsdzuZuNBl4juV8bDkc0Y
         Vp2fljSDcx/QIAiw+2Ww+zs+cdX6KkdBB3XdANjgQBgKrzRMtqVxd6A5XtToW0lKyE
         C7Hh5SbpHkUA3beOqnL8u1Nx/iTlBBA4GC9Koyre3C7MBmtD5Ynuugmc2vPP/Oe2JC
         sgMWGm2BLaUvQ==
Subject: [PATCH 37/48] xfs: remove kmem_zone typedef
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:26:35 -0800
Message-ID: <164263839587.865554.17835087857585889463.stgit@magnolia>
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

Source kernel commit: e7720afad068a6729d9cd3aaa08212f2f5a7ceff

Remove these typedefs by referencing kmem_cache directly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/kmem.h              |   14 +++++++-------
 libxfs/kmem.c               |   12 ++++++------
 libxfs/libxfs_priv.h        |   10 +++++-----
 libxfs/logitem.c            |    4 ++--
 libxfs/rdwr.c               |    6 +++---
 libxfs/trans.c              |    4 ++--
 libxfs/xfs_alloc.c          |    2 +-
 libxfs/xfs_alloc_btree.c    |    2 +-
 libxfs/xfs_bmap.c           |    2 +-
 libxfs/xfs_bmap.h           |    2 +-
 libxfs/xfs_bmap_btree.c     |    2 +-
 libxfs/xfs_btree.h          |    4 ++--
 libxfs/xfs_da_btree.c       |    2 +-
 libxfs/xfs_da_btree.h       |    2 +-
 libxfs/xfs_ialloc_btree.c   |    2 +-
 libxfs/xfs_inode_fork.c     |    2 +-
 libxfs/xfs_inode_fork.h     |    2 +-
 libxfs/xfs_refcount_btree.c |    2 +-
 libxfs/xfs_rmap_btree.c     |    2 +-
 19 files changed, 39 insertions(+), 39 deletions(-)


diff --git a/include/kmem.h b/include/kmem.h
index 36acd20d..7aba4914 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -14,13 +14,13 @@ bool kmem_found_leaks(void);
 #define KM_LARGE	0x0010u
 #define KM_NOLOCKDEP	0x0020u
 
-typedef struct kmem_zone {
+struct kmem_cache {
 	int		zone_unitsize;	/* Size in bytes of zone unit */
 	int		allocated;	/* debug: How many allocated? */
 	unsigned int	align;
 	const char	*zone_name;	/* tag name */
 	void		(*ctor)(void *);
-} kmem_zone_t;
+};
 
 typedef unsigned int __bitwise gfp_t;
 
@@ -31,16 +31,16 @@ typedef unsigned int __bitwise gfp_t;
 
 #define __GFP_ZERO	(__force gfp_t)1
 
-kmem_zone_t * kmem_cache_create(const char *name, unsigned int size,
+struct kmem_cache * kmem_cache_create(const char *name, unsigned int size,
 		unsigned int align, unsigned int slab_flags,
 		void (*ctor)(void *));
-void kmem_cache_destroy(kmem_zone_t *);
+void kmem_cache_destroy(struct kmem_cache *);
 
-extern void	*kmem_cache_alloc(kmem_zone_t *, gfp_t);
-extern void	*kmem_cache_zalloc(kmem_zone_t *, gfp_t);
+extern void	*kmem_cache_alloc(struct kmem_cache *, gfp_t);
+extern void	*kmem_cache_zalloc(struct kmem_cache *, gfp_t);
 
 static inline void
-kmem_cache_free(kmem_zone_t *zone, void *ptr)
+kmem_cache_free(struct kmem_cache *zone, void *ptr)
 {
 	zone->allocated--;
 	free(ptr);
diff --git a/libxfs/kmem.c b/libxfs/kmem.c
index 804d4b3c..a176a9d8 100644
--- a/libxfs/kmem.c
+++ b/libxfs/kmem.c
@@ -18,15 +18,15 @@ bool kmem_found_leaks(void)
 /*
  * Simple memory interface
  */
-kmem_zone_t *
+struct kmem_cache *
 kmem_cache_create(const char *name, unsigned int size, unsigned int align,
 		  unsigned int slab_flags, void (*ctor)(void *))
 {
-	kmem_zone_t	*ptr = malloc(sizeof(kmem_zone_t));
+	struct kmem_cache	*ptr = malloc(sizeof(struct kmem_cache));
 
 	if (ptr == NULL) {
 		fprintf(stderr, _("%s: zone init failed (%s, %d bytes): %s\n"),
-			progname, name, (int)sizeof(kmem_zone_t),
+			progname, name, (int)sizeof(struct kmem_cache),
 			strerror(errno));
 		exit(1);
 	}
@@ -40,7 +40,7 @@ kmem_cache_create(const char *name, unsigned int size, unsigned int align,
 }
 
 void
-kmem_cache_destroy(kmem_zone_t *zone)
+kmem_cache_destroy(struct kmem_cache *zone)
 {
 	if (getenv("LIBXFS_LEAK_CHECK") && zone->allocated) {
 		leaked = true;
@@ -51,7 +51,7 @@ kmem_cache_destroy(kmem_zone_t *zone)
 }
 
 void *
-kmem_cache_alloc(kmem_zone_t *zone, gfp_t flags)
+kmem_cache_alloc(struct kmem_cache *zone, gfp_t flags)
 {
 	void	*ptr = NULL;
 
@@ -79,7 +79,7 @@ kmem_cache_alloc(kmem_zone_t *zone, gfp_t flags)
 }
 
 void *
-kmem_cache_zalloc(kmem_zone_t *zone, gfp_t flags)
+kmem_cache_zalloc(struct kmem_cache *zone, gfp_t flags)
 {
 	void	*ptr = kmem_cache_alloc(zone, flags);
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 466865f7..5b04db84 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -59,11 +59,11 @@
 #include <sys/xattr.h>
 
 /* Zones used in libxfs allocations that aren't in shared header files */
-extern kmem_zone_t *xfs_buf_item_zone;
-extern kmem_zone_t *xfs_ili_zone;
-extern kmem_zone_t *xfs_buf_zone;
-extern kmem_zone_t *xfs_inode_zone;
-extern kmem_zone_t *xfs_trans_zone;
+extern struct kmem_cache *xfs_buf_item_zone;
+extern struct kmem_cache *xfs_ili_zone;
+extern struct kmem_cache *xfs_buf_zone;
+extern struct kmem_cache *xfs_inode_zone;
+extern struct kmem_cache *xfs_trans_zone;
 
 /* fake up iomap, (not) used in xfs_bmap.[ch] */
 #define IOMAP_F_SHARED			0x04
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index e6debb6d..dde90502 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -16,8 +16,8 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 
-kmem_zone_t	*xfs_buf_item_zone;
-kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
+struct kmem_cache	*xfs_buf_item_zone;
+struct kmem_cache	*xfs_ili_zone;		/* inode log item zone */
 
 /*
  * Following functions from fs/xfs/xfs_trans_buf.c
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index b43527e4..315e6d1f 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -161,7 +161,7 @@ libxfs_getsb(
 	return bp;
 }
 
-kmem_zone_t			*xfs_buf_zone;
+struct kmem_cache			*xfs_buf_zone;
 
 static struct cache_mru		xfs_buf_freelist =
 	{{&xfs_buf_freelist.cm_list, &xfs_buf_freelist.cm_list},
@@ -1053,8 +1053,8 @@ xfs_verify_magic16(
  * Inode cache stubs.
  */
 
-kmem_zone_t		*xfs_inode_zone;
-extern kmem_zone_t	*xfs_ili_zone;
+struct kmem_cache		*xfs_inode_zone;
+extern struct kmem_cache	*xfs_ili_zone;
 
 int
 libxfs_iget(
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 8c16cb8d..f87a65c5 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -30,7 +30,7 @@ static int __xfs_trans_commit(struct xfs_trans *tp, bool regrant);
  * Simple transaction interface
  */
 
-kmem_zone_t	*xfs_trans_zone;
+struct kmem_cache	*xfs_trans_zone;
 
 /*
  * Initialize the precomputed transaction reservation values
@@ -868,7 +868,7 @@ buf_item_done(
 {
 	struct xfs_buf		*bp;
 	int			hold;
-	extern kmem_zone_t	*xfs_buf_item_zone;
+	extern struct kmem_cache	*xfs_buf_item_zone;
 
 	bp = bip->bli_buf;
 	ASSERT(bp != NULL);
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 7d304160..c99497fd 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -23,7 +23,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
 
-extern kmem_zone_t	*xfs_bmap_free_item_zone;
+extern struct kmem_cache	*xfs_bmap_free_item_zone;
 
 struct workqueue_struct *xfs_alloc_wq;
 
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 2176a923..2ba6d44a 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -18,7 +18,7 @@
 #include "xfs_trans.h"
 #include "xfs_ag.h"
 
-static kmem_zone_t	*xfs_allocbt_cur_cache;
+static struct kmem_cache	*xfs_allocbt_cur_cache;
 
 STATIC struct xfs_btree_cur *
 xfs_allocbt_dup_cursor(
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index bc8a2033..ecf79e24 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -31,7 +31,7 @@
 #include "xfs_refcount.h"
 
 
-kmem_zone_t		*xfs_bmap_free_item_zone;
+struct kmem_cache		*xfs_bmap_free_item_zone;
 
 /*
  * Miscellaneous helper functions
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 67641f66..171a72ee 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -13,7 +13,7 @@ struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
 
-extern kmem_zone_t	*xfs_bmap_free_item_zone;
+extern struct kmem_cache	*xfs_bmap_free_item_zone;
 
 /*
  * Argument structure for xfs_bmap_alloc.
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index cde313d7..8e850751 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -20,7 +20,7 @@
 #include "xfs_trace.h"
 #include "xfs_rmap.h"
 
-static kmem_zone_t	*xfs_bmbt_cur_cache;
+static struct kmem_cache	*xfs_bmbt_cur_cache;
 
 /*
  * Convert on-disk form of btree root to in-memory form.
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 7bc5a379..22d9f411 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -230,7 +230,7 @@ struct xfs_btree_cur
 	struct xfs_trans	*bc_tp;	/* transaction we're in, if any */
 	struct xfs_mount	*bc_mp;	/* file system mount struct */
 	const struct xfs_btree_ops *bc_ops;
-	kmem_zone_t		*bc_cache; /* cursor cache */
+	struct kmem_cache	*bc_cache; /* cursor cache */
 	unsigned int		bc_flags; /* btree features - below */
 	xfs_btnum_t		bc_btnum; /* identifies which btree type */
 	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
@@ -586,7 +586,7 @@ xfs_btree_alloc_cursor(
 	struct xfs_trans	*tp,
 	xfs_btnum_t		btnum,
 	uint8_t			maxlevels,
-	kmem_zone_t		*cache)
+	struct kmem_cache	*cache)
 {
 	struct xfs_btree_cur	*cur;
 
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 0e504d2d..f1ae5d4d 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -69,7 +69,7 @@ STATIC int	xfs_da3_blk_unlink(xfs_da_state_t *state,
 				  xfs_da_state_blk_t *save_blk);
 
 
-kmem_zone_t *xfs_da_state_zone;	/* anchor for state struct zone */
+struct kmem_cache *xfs_da_state_zone;	/* anchor for state struct zone */
 
 /*
  * Allocate a dir-state structure.
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index ad5dd324..da845e32 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -227,6 +227,6 @@ void	xfs_da3_node_hdr_from_disk(struct xfs_mount *mp,
 void	xfs_da3_node_hdr_to_disk(struct xfs_mount *mp,
 		struct xfs_da_intnode *to, struct xfs_da3_icnode_hdr *from);
 
-extern struct kmem_zone *xfs_da_state_zone;
+extern struct kmem_cache *xfs_da_state_zone;
 
 #endif	/* __XFS_DA_BTREE_H__ */
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 539e7c03..1dbb5360 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -21,7 +21,7 @@
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 
-static kmem_zone_t	*xfs_inobt_cur_cache;
+static struct kmem_cache	*xfs_inobt_cur_cache;
 
 STATIC int
 xfs_inobt_get_minrecs(
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index bd581fe8..c80b4066 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -24,7 +24,7 @@
 #include "xfs_types.h"
 #include "xfs_errortag.h"
 
-kmem_zone_t *xfs_ifork_zone;
+struct kmem_cache *xfs_ifork_zone;
 
 void
 xfs_init_local_fork(
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index a6f7897b..cb296bd5 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -221,7 +221,7 @@ static inline bool xfs_iext_peek_prev_extent(struct xfs_ifork *ifp,
 	     xfs_iext_get_extent((ifp), (ext), (got));	\
 	     xfs_iext_next((ifp), (ext)))
 
-extern struct kmem_zone	*xfs_ifork_zone;
+extern struct kmem_cache	*xfs_ifork_zone;
 
 extern void xfs_ifork_init_cow(struct xfs_inode *ip);
 
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 2c02e33e..19ead6a2 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -20,7 +20,7 @@
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 
-static kmem_zone_t	*xfs_refcountbt_cur_cache;
+static struct kmem_cache	*xfs_refcountbt_cur_cache;
 
 static struct xfs_btree_cur *
 xfs_refcountbt_dup_cursor(
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index ae3329b5..f0fe78d3 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -20,7 +20,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 
-static kmem_zone_t	*xfs_rmapbt_cur_cache;
+static struct kmem_cache	*xfs_rmapbt_cur_cache;
 
 /*
  * Reverse map btree.

