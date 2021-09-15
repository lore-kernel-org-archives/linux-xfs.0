Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD4EC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:08:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5194610A6
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhIOXKA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:10:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232828AbhIOXKA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:10:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B263600D4;
        Wed, 15 Sep 2021 23:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747320;
        bh=xthaQ2K+keOn9AR3wBaKddF4jVXa/L6I8qqKJ/06JUI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K1El6Vdzf8Cv9ZkSdpDekVrZ0KUz2qb65BBJGo7kO9WL3/55AoQg392MbWRAwaGfe
         32ckttBkchDicxlYcHmZd/skHks0EJRuAw5pqHLmMv5gtqENvqiKQ5Kg5OOFqNJG9O
         iMO6YiqQwv7hyAAzi5/1Z94DhLPtuzwWwJdw2oAmz+5zVoBX+um22JA2JC3dXQxr3W
         bmhKX1rDAW/bmwi6juFKdm6iscfluTOeJqYJ63BafPMaX+jla8DTarVaUbvJ45vHqw
         97J6/lJDLkQsw1gtfpg+kjV3f8fqRGCLiXsXYs5lWL1uNcrL41uYlIg0MKXiAI3tvK
         0UJZFzotCe+Nw==
Subject: [PATCH 23/61] xfs: move perag structure and setup to
 libxfs/xfs_ag.[ch]
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:08:40 -0700
Message-ID: <163174732027.350433.10928374313947019480.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 07b6403a6873045344b0c18cbb4a4360854f6d76

Move the xfs_perag infrastructure to the libxfs files that contain
all the per AG infrastructure. This helps set up for passing perags
around all the code instead of bare agnos with minimal extra
includes for existing files.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h      |   65 ----------------------
 libfrog/mockups.h        |   24 ++++++++
 libfrog/radix-tree.h     |    3 +
 libxfs/init.c            |   61 ---------------------
 libxfs/libxfs_api_defs.h |    2 +
 libxfs/libxfs_priv.h     |   10 +++
 libxfs/xfs_ag.c          |  134 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_ag.h          |   98 +++++++++++++++++++++++++++++++++-
 libxfs/xfs_ag_resv.h     |   15 +++++
 libxfs/xfs_btree.c       |    1 
 10 files changed, 285 insertions(+), 128 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 12019c4b..763122e0 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -117,71 +117,6 @@ typedef struct xfs_mount {
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
 
-struct xfs_ag_resv {
-	/* number of blocks originally reserved here */
-	xfs_extlen_t	ar_orig_reserved;
-	/* number of blocks reserved here */
-	xfs_extlen_t	ar_reserved;
-	/* number of blocks originally asked for */
-	xfs_extlen_t	ar_asked;
-};
-
-/*
- * Per-ag incore structure, copies of information in agf and agi,
- * to improve the performance of allocation group selection.
- */
-typedef struct xfs_perag {
-	struct xfs_mount *pag_mount;	/* owner filesystem */
-	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
-	atomic_t	pag_ref;	/* perag reference count */
-	char		pagf_init;	/* this agf's entry is initialized */
-	char		pagi_init;	/* this agi's entry is initialized */
-	char		pagf_metadata;	/* the agf is preferred to be metadata */
-	char		pagi_inodeok;	/* The agi is ok for inodes */
-	uint8_t		pagf_levels[XFS_BTNUM_AGF];
-					/* # of levels in bno & cnt btree */
-	bool		pagf_agflreset;	/* agfl requires reset before use */
-	uint32_t	pagf_flcount;	/* count of blocks in freelist */
-	xfs_extlen_t	pagf_freeblks;	/* total free blocks */
-	xfs_extlen_t	pagf_longest;	/* longest free space */
-	uint32_t	pagf_btreeblks;	/* # of blocks held in AGF btrees */
-	xfs_agino_t	pagi_freecount;	/* number of free inodes */
-	xfs_agino_t	pagi_count;	/* number of allocated inodes */
-
-	/*
-	 * Inode allocation search lookup optimisation.
-	 * If the pagino matches, the search for new inodes
-	 * doesn't need to search the near ones again straight away
-	 */
-	xfs_agino_t	pagl_pagino;
-	xfs_agino_t	pagl_leftrec;
-	xfs_agino_t	pagl_rightrec;
-	int		pagb_count;	/* pagb slots in use */
-
-	/* Blocks reserved for all kinds of metadata. */
-	struct xfs_ag_resv	pag_meta_resv;
-	/* Blocks reserved for just AGFL-based metadata. */
-	struct xfs_ag_resv	pag_rmapbt_resv;
-
-	/* reference count */
-	uint8_t		pagf_refcount_level;
-} xfs_perag_t;
-
-static inline struct xfs_ag_resv *
-xfs_perag_resv(
-	struct xfs_perag	*pag,
-	enum xfs_ag_resv_type	type)
-{
-	switch (type) {
-	case XFS_AG_RESV_METADATA:
-		return &pag->pag_meta_resv;
-	case XFS_AG_RESV_RMAPBT:
-		return &pag->pag_rmapbt_resv;
-	default:
-		return NULL;
-	}
-}
-
 #define LIBXFS_MOUNT_DEBUGGER		0x0001
 #define LIBXFS_MOUNT_32BITINODES	0x0002
 #define LIBXFS_MOUNT_32BITINOOPT	0x0004
diff --git a/libfrog/mockups.h b/libfrog/mockups.h
index f00a9e41..d27f141e 100644
--- a/libfrog/mockups.h
+++ b/libfrog/mockups.h
@@ -16,4 +16,28 @@ typedef struct spinlock {
 #define spin_lock(a)		((void) 0)
 #define spin_unlock(a)		((void) 0)
 
+struct rb_root {
+};
+
+#define RB_ROOT 		(struct rb_root) { }
+
+typedef struct wait_queue_head {
+} wait_queue_head_t;
+
+#define init_waitqueue_head(wqh)	do { } while(0)
+
+struct rhashtable {
+};
+
+struct rcu_head {
+};
+
+#define call_rcu(arg, func)		(func(arg))
+
+struct delayed_work {
+};
+
+#define INIT_DELAYED_WORK(work, func)	do { } while(0)
+#define cancel_delayed_work_sync(work)	do { } while(0)
+
 #endif /* __LIBFROG_MOCKUPS_H__ */
diff --git a/libfrog/radix-tree.h b/libfrog/radix-tree.h
index f08156b9..dad5f5b7 100644
--- a/libfrog/radix-tree.h
+++ b/libfrog/radix-tree.h
@@ -60,4 +60,7 @@ radix_tree_gang_lookup_tag(struct radix_tree_root *root, void **results,
 int radix_tree_tagged(struct radix_tree_root *root, unsigned int tag);
 #endif
 
+static inline int radix_tree_preload(int gfp_mask) { return 0; }
+static inline void radix_tree_preload_end(void) { }
+
 #endif /* __LIBFROG_RADIX_TREE_H__ */
diff --git a/libxfs/init.c b/libxfs/init.c
index 6223181f..c3e6a899 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -569,60 +569,6 @@ xfs_set_inode_alloc(
 	return (mp->m_flags & XFS_MOUNT_32BITINODES) ? maxagi : agcount;
 }
 
-static int
-libxfs_initialize_perag(
-	xfs_mount_t	*mp,
-	xfs_agnumber_t	agcount,
-	xfs_agnumber_t	*maxagi)
-{
-	xfs_agnumber_t	index;
-	xfs_agnumber_t	first_initialised = 0;
-	xfs_perag_t	*pag;
-	int		error = -ENOMEM;
-
-	/*
-	 * Walk the current per-ag tree so we don't try to initialise AGs
-	 * that already exist (growfs case). Allocate and insert all the
-	 * AGs we don't find ready for initialisation.
-	 */
-	for (index = 0; index < agcount; index++) {
-		pag = xfs_perag_get(mp, index);
-		if (pag) {
-			xfs_perag_put(pag);
-			continue;
-		}
-		if (!first_initialised)
-			first_initialised = index;
-
-		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
-		if (!pag)
-			goto out_unwind;
-		pag->pag_agno = index;
-		pag->pag_mount = mp;
-
-		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
-			error = -EEXIST;
-			goto out_unwind;
-		}
-	}
-
-	index = xfs_set_inode_alloc(mp, agcount);
-
-	if (maxagi)
-		*maxagi = index;
-
-	mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);
-	return 0;
-
-out_unwind:
-	kmem_free(pag);
-	for (; index > first_initialised; index--) {
-		pag = radix_tree_delete(&mp->m_perag_tree, index);
-		kmem_free(pag);
-	}
-	return error;
-}
-
 static struct xfs_buftarg *
 libxfs_buftarg_alloc(
 	struct xfs_mount	*mp,
@@ -1013,8 +959,6 @@ int
 libxfs_umount(
 	struct xfs_mount	*mp)
 {
-	struct xfs_perag	*pag;
-	int			agno;
 	int			error;
 
 	libxfs_rtmount_destroy(mp);
@@ -1027,10 +971,7 @@ libxfs_umount(
 	libxfs_bcache_purge();
 	error = libxfs_flush_mount(mp);
 
-	for (agno = 0; agno < mp->m_maxagi; agno++) {
-		pag = radix_tree_delete(&mp->m_perag_tree, agno);
-		kmem_free(pag);
-	}
+	libxfs_free_perag(mp);
 
 	kmem_free(mp->m_attr_geo);
 	kmem_free(mp->m_dir_geo);
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index d759ff65..b76e6380 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -104,6 +104,7 @@
 
 #define xfs_finobt_calc_reserves	libxfs_finobt_calc_reserves
 #define xfs_free_extent			libxfs_free_extent
+#define xfs_free_perag			libxfs_free_perag
 #define xfs_fs_geometry			libxfs_fs_geometry
 #define xfs_highbit32			libxfs_highbit32
 #define xfs_highbit64			libxfs_highbit64
@@ -111,6 +112,7 @@
 #define xfs_idata_realloc		libxfs_idata_realloc
 #define xfs_idestroy_fork		libxfs_idestroy_fork
 #define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
+#define xfs_initialize_perag		libxfs_initialize_perag
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
 #define xfs_init_local_fork		libxfs_init_local_fork
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 727f6be8..110a88a9 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -547,7 +547,6 @@ int xfs_attr_rmtval_get(struct xfs_da_args *);
 void xfs_bmap_del_free(struct xfs_bmap_free *, struct xfs_bmap_free_item *);
 
 /* xfs_mount.c */
-int xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
 void xfs_mount_common(struct xfs_mount *, struct xfs_sb *);
 
 /*
@@ -666,6 +665,15 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
 	return 0;
 }
 
+static inline int xfs_buf_hash_init(struct xfs_perag *pag) { return 0; }
+static inline void xfs_buf_hash_destroy(struct xfs_perag *pag) { }
+
+static inline int xfs_iunlink_init(struct xfs_perag *pag) { return 0; }
+static inline void xfs_iunlink_destroy(struct xfs_perag *pag) { }
+
+xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *mp,
+		xfs_agnumber_t agcount);
+
 /* Keep static checkers quiet about nonstatic functions by exporting */
 int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
 		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 46e78b0e..1027bc7b 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -27,6 +27,8 @@
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
 #include "xfs_trace.h"
+#include "xfs_inode.h"
+
 
 /*
  * Passive reference counting access wrappers to the perag structures.  If the
@@ -162,6 +164,138 @@ xfs_initialize_perag_data(
 	return error;
 }
 
+STATIC void
+__xfs_free_perag(
+	struct rcu_head	*head)
+{
+	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
+
+	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
+	ASSERT(atomic_read(&pag->pag_ref) == 0);
+	kmem_free(pag);
+}
+
+/*
+ * Free up the per-ag resources associated with the mount structure.
+ */
+void
+xfs_free_perag(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		spin_lock(&mp->m_perag_lock);
+		pag = radix_tree_delete(&mp->m_perag_tree, agno);
+		spin_unlock(&mp->m_perag_lock);
+		ASSERT(pag);
+		ASSERT(atomic_read(&pag->pag_ref) == 0);
+
+		cancel_delayed_work_sync(&pag->pag_blockgc_work);
+		xfs_iunlink_destroy(pag);
+		xfs_buf_hash_destroy(pag);
+
+		call_rcu(&pag->rcu_head, __xfs_free_perag);
+	}
+}
+
+int
+xfs_initialize_perag(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agcount,
+	xfs_agnumber_t		*maxagi)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		index;
+	xfs_agnumber_t		first_initialised = NULLAGNUMBER;
+	int			error;
+
+	/*
+	 * Walk the current per-ag tree so we don't try to initialise AGs
+	 * that already exist (growfs case). Allocate and insert all the
+	 * AGs we don't find ready for initialisation.
+	 */
+	for (index = 0; index < agcount; index++) {
+		pag = xfs_perag_get(mp, index);
+		if (pag) {
+			xfs_perag_put(pag);
+			continue;
+		}
+
+		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
+		if (!pag) {
+			error = -ENOMEM;
+			goto out_unwind_new_pags;
+		}
+		pag->pag_agno = index;
+		pag->pag_mount = mp;
+
+		error = radix_tree_preload(GFP_NOFS);
+		if (error)
+			goto out_free_pag;
+
+		spin_lock(&mp->m_perag_lock);
+		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
+			WARN_ON_ONCE(1);
+			spin_unlock(&mp->m_perag_lock);
+			radix_tree_preload_end();
+			error = -EEXIST;
+			goto out_free_pag;
+		}
+		spin_unlock(&mp->m_perag_lock);
+		radix_tree_preload_end();
+
+		/* Place kernel structure only init below this point. */
+		spin_lock_init(&pag->pag_ici_lock);
+		spin_lock_init(&pag->pagb_lock);
+		spin_lock_init(&pag->pag_state_lock);
+		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
+		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
+		init_waitqueue_head(&pag->pagb_wait);
+		pag->pagb_count = 0;
+		pag->pagb_tree = RB_ROOT;
+
+		error = xfs_buf_hash_init(pag);
+		if (error)
+			goto out_remove_pag;
+
+		error = xfs_iunlink_init(pag);
+		if (error)
+			goto out_hash_destroy;
+
+		/* first new pag is fully initialized */
+		if (first_initialised == NULLAGNUMBER)
+			first_initialised = index;
+	}
+
+	index = xfs_set_inode_alloc(mp, agcount);
+
+	if (maxagi)
+		*maxagi = index;
+
+	mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);
+	return 0;
+
+out_hash_destroy:
+	xfs_buf_hash_destroy(pag);
+out_remove_pag:
+	radix_tree_delete(&mp->m_perag_tree, index);
+out_free_pag:
+	kmem_free(pag);
+out_unwind_new_pags:
+	/* unwind any prior newly initialized pags */
+	for (index = first_initialised; index < agcount; index++) {
+		pag = radix_tree_delete(&mp->m_perag_tree, index);
+		if (!pag)
+			break;
+		xfs_buf_hash_destroy(pag);
+		xfs_iunlink_destroy(pag);
+		kmem_free(pag);
+	}
+	return error;
+}
+
 static int
 xfs_get_aghdr_buf(
 	struct xfs_mount	*mp,
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index cb1bd1c0..f26f72e4 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -12,9 +12,103 @@ struct xfs_trans;
 struct xfs_perag;
 
 /*
- * perag get/put wrappers for ref counting
+ * Per-ag infrastructure
  */
-int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
+
+/* per-AG block reservation data structures*/
+struct xfs_ag_resv {
+	/* number of blocks originally reserved here */
+	xfs_extlen_t			ar_orig_reserved;
+	/* number of blocks reserved here */
+	xfs_extlen_t			ar_reserved;
+	/* number of blocks originally asked for */
+	xfs_extlen_t			ar_asked;
+};
+
+/*
+ * Per-ag incore structure, copies of information in agf and agi, to improve the
+ * performance of allocation group selection.
+ */
+typedef struct xfs_perag {
+	struct xfs_mount *pag_mount;	/* owner filesystem */
+	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
+	atomic_t	pag_ref;	/* perag reference count */
+	char		pagf_init;	/* this agf's entry is initialized */
+	char		pagi_init;	/* this agi's entry is initialized */
+	char		pagf_metadata;	/* the agf is preferred to be metadata */
+	char		pagi_inodeok;	/* The agi is ok for inodes */
+	uint8_t		pagf_levels[XFS_BTNUM_AGF];
+					/* # of levels in bno & cnt btree */
+	bool		pagf_agflreset; /* agfl requires reset before use */
+	uint32_t	pagf_flcount;	/* count of blocks in freelist */
+	xfs_extlen_t	pagf_freeblks;	/* total free blocks */
+	xfs_extlen_t	pagf_longest;	/* longest free space */
+	uint32_t	pagf_btreeblks;	/* # of blocks held in AGF btrees */
+	xfs_agino_t	pagi_freecount;	/* number of free inodes */
+	xfs_agino_t	pagi_count;	/* number of allocated inodes */
+
+	/*
+	 * Inode allocation search lookup optimisation.
+	 * If the pagino matches, the search for new inodes
+	 * doesn't need to search the near ones again straight away
+	 */
+	xfs_agino_t	pagl_pagino;
+	xfs_agino_t	pagl_leftrec;
+	xfs_agino_t	pagl_rightrec;
+
+	int		pagb_count;	/* pagb slots in use */
+	uint8_t		pagf_refcount_level; /* recount btree height */
+
+	/* Blocks reserved for all kinds of metadata. */
+	struct xfs_ag_resv	pag_meta_resv;
+	/* Blocks reserved for the reverse mapping btree. */
+	struct xfs_ag_resv	pag_rmapbt_resv;
+
+	/* -- kernel only structures below this line -- */
+
+	/*
+	 * Bitsets of per-ag metadata that have been checked and/or are sick.
+	 * Callers should hold pag_state_lock before accessing this field.
+	 */
+	uint16_t	pag_checked;
+	uint16_t	pag_sick;
+	spinlock_t	pag_state_lock;
+
+	spinlock_t	pagb_lock;	/* lock for pagb_tree */
+	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
+	unsigned int	pagb_gen;	/* generation count for pagb_tree */
+	wait_queue_head_t pagb_wait;	/* woken when pagb_gen changes */
+
+	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
+
+	spinlock_t	pag_ici_lock;	/* incore inode cache lock */
+	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
+	int		pag_ici_reclaimable;	/* reclaimable inodes */
+	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
+
+	/* buffer cache index */
+	spinlock_t	pag_buf_lock;	/* lock for pag_buf_hash */
+	struct rhashtable pag_buf_hash;
+
+	/* for rcu-safe freeing */
+	struct rcu_head	rcu_head;
+
+	/* background prealloc block trimming */
+	struct delayed_work	pag_blockgc_work;
+
+	/*
+	 * Unlinked inode information.  This incore information reflects
+	 * data stored in the AGI, so callers must hold the AGI buffer lock
+	 * or have some other means to control concurrency.
+	 */
+	struct rhashtable	pagi_unlinked_hash;
+} xfs_perag_t;
+
+int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
+			xfs_agnumber_t *maxagi);
+int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
+void xfs_free_perag(struct xfs_mount *mp);
+
 struct xfs_perag *xfs_perag_get(struct xfs_mount *, xfs_agnumber_t);
 struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
 				   int tag);
diff --git a/libxfs/xfs_ag_resv.h b/libxfs/xfs_ag_resv.h
index 8a8eb4bc..b74b2100 100644
--- a/libxfs/xfs_ag_resv.h
+++ b/libxfs/xfs_ag_resv.h
@@ -18,6 +18,21 @@ void xfs_ag_resv_alloc_extent(struct xfs_perag *pag, enum xfs_ag_resv_type type,
 void xfs_ag_resv_free_extent(struct xfs_perag *pag, enum xfs_ag_resv_type type,
 		struct xfs_trans *tp, xfs_extlen_t len);
 
+static inline struct xfs_ag_resv *
+xfs_perag_resv(
+	struct xfs_perag	*pag,
+	enum xfs_ag_resv_type	type)
+{
+	switch (type) {
+	case XFS_AG_RESV_METADATA:
+		return &pag->pag_meta_resv;
+	case XFS_AG_RESV_RMAPBT:
+		return &pag->pag_rmapbt_resv;
+	default:
+		return NULL;
+	}
+}
+
 /*
  * RMAPBT reservation accounting wrappers. Since rmapbt blocks are sourced from
  * the AGFL, they are allocated one at a time and the reservation updates don't
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index d52fdc00..4faf4a67 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -18,6 +18,7 @@
 #include "xfs_trace.h"
 #include "xfs_alloc.h"
 #include "xfs_btree_staging.h"
+#include "xfs_ag.h"
 
 /*
  * Cursor allocation zone.

