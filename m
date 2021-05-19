Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CEC9C43611
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 01:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2281261369
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 01:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbhESBW2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 May 2021 21:22:28 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:38856 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231881AbhESBWZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 May 2021 21:22:25 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CD3801042FBE
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 11:21:03 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljAtT-002bNz-A8
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 11:21:03 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljAtT-001tJt-23
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 11:21:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/23] xfs: move perag structure and setup to libxfs/xfs_ag.[ch]
Date:   Wed, 19 May 2021 11:20:42 +1000
Message-Id: <20210519012102.450926-4-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519012102.450926-1-david@fromorbit.com>
References: <20210519012102.450926-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=apZTpagO01xlDpMJhpoA:9
        a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19 a=lae5bAXXjuRVUAY1:21
        a=P7Zq29dYQ9ObpPVA:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Move the xfs_perag infrastructure to the libxfs files that contain
all the per AG infrastructure. This helps set up for passing perags
around all the code instead of bare agnos with minimal extra
includes for existing files.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c      | 135 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h      |  98 +++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_ag_resv.h |  15 ++++
 fs/xfs/libxfs/xfs_btree.c   |   1 +
 fs/xfs/xfs_mount.c          | 133 -----------------------------------
 fs/xfs/xfs_mount.h          | 111 +----------------------------
 fs/xfs/xfs_trace.c          |   2 +
 7 files changed, 252 insertions(+), 243 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 2ca31dc46fe8..97fb160e01de 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -28,6 +28,9 @@
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
 #include "xfs_trace.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+
 
 /*
  * Passive reference counting access wrappers to the perag structures.  If the
@@ -163,6 +166,138 @@ xfs_initialize_perag_data(
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
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index cb1bd1c03cd7..ec37f9d9f310 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
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
+int xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
+void xfs_free_perag(struct xfs_mount *mp);
+
 struct xfs_perag *xfs_perag_get(struct xfs_mount *, xfs_agnumber_t);
 struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
 				   int tag);
diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
index 8a8eb4bc48bb..b74b210008ea 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.h
+++ b/fs/xfs/libxfs/xfs_ag_resv.h
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
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 5b6fcb9b44e2..0f12b885600d 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -21,6 +21,7 @@
 #include "xfs_alloc.h"
 #include "xfs_log.h"
 #include "xfs_btree_staging.h"
+#include "xfs_ag.h"
 
 /*
  * Cursor allocation zone.
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 6966d7b12a13..c3a96fb3ad80 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -120,43 +120,6 @@ xfs_uuid_unmount(
 	mutex_unlock(&xfs_uuid_table_mutex);
 }
 
-
-STATIC void
-__xfs_free_perag(
-	struct rcu_head	*head)
-{
-	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
-
-	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
-	ASSERT(atomic_read(&pag->pag_ref) == 0);
-	kmem_free(pag);
-}
-
-/*
- * Free up the per-ag resources associated with the mount structure.
- */
-STATIC void
-xfs_free_perag(
-	xfs_mount_t	*mp)
-{
-	xfs_agnumber_t	agno;
-	struct xfs_perag *pag;
-
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		spin_lock(&mp->m_perag_lock);
-		pag = radix_tree_delete(&mp->m_perag_tree, agno);
-		spin_unlock(&mp->m_perag_lock);
-		ASSERT(pag);
-		ASSERT(atomic_read(&pag->pag_ref) == 0);
-
-		cancel_delayed_work_sync(&pag->pag_blockgc_work);
-		xfs_iunlink_destroy(pag);
-		xfs_buf_hash_destroy(pag);
-
-		call_rcu(&pag->rcu_head, __xfs_free_perag);
-	}
-}
-
 /*
  * Check size of device based on the (data/realtime) block count.
  * Note: this check is used by the growfs code as well as mount.
@@ -175,102 +138,6 @@ xfs_sb_validate_fsb_count(
 	return 0;
 }
 
-int
-xfs_initialize_perag(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agcount,
-	xfs_agnumber_t		*maxagi)
-{
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		index;
-	xfs_agnumber_t		first_initialised = NULLAGNUMBER;
-	int			error;
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
-
-		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
-		if (!pag) {
-			error = -ENOMEM;
-			goto out_unwind_new_pags;
-		}
-		pag->pag_agno = index;
-		pag->pag_mount = mp;
-
-		error = radix_tree_preload(GFP_NOFS);
-		if (error)
-			goto out_free_pag;
-
-		spin_lock(&mp->m_perag_lock);
-		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
-			WARN_ON_ONCE(1);
-			spin_unlock(&mp->m_perag_lock);
-			radix_tree_preload_end();
-			error = -EEXIST;
-			goto out_free_pag;
-		}
-		spin_unlock(&mp->m_perag_lock);
-		radix_tree_preload_end();
-
-		/* Place kernel structure only init below this point. */
-		spin_lock_init(&pag->pag_ici_lock);
-		spin_lock_init(&pag->pagb_lock);
-		spin_lock_init(&pag->pag_state_lock);
-		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
-		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
-		init_waitqueue_head(&pag->pagb_wait);
-		pag->pagb_count = 0;
-		pag->pagb_tree = RB_ROOT;
-
-		error = xfs_buf_hash_init(pag);
-		if (error)
-			goto out_remove_pag;
-
-		error = xfs_iunlink_init(pag);
-		if (error)
-			goto out_hash_destroy;
-
-		/* first new pag is fully initialized */
-		if (first_initialised == NULLAGNUMBER)
-			first_initialised = index;
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
-out_hash_destroy:
-	xfs_buf_hash_destroy(pag);
-out_remove_pag:
-	radix_tree_delete(&mp->m_perag_tree, index);
-out_free_pag:
-	kmem_free(pag);
-out_unwind_new_pags:
-	/* unwind any prior newly initialized pags */
-	for (index = first_initialised; index < agcount; index++) {
-		pag = radix_tree_delete(&mp->m_perag_tree, index);
-		if (!pag)
-			break;
-		xfs_buf_hash_destroy(pag);
-		xfs_iunlink_destroy(pag);
-		kmem_free(pag);
-	}
-	return error;
-}
-
 /*
  * xfs_readsb
  *
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 6e534be5eea8..c78b63fe779a 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -12,6 +12,7 @@ struct xfs_mru_cache;
 struct xfs_ail;
 struct xfs_quotainfo;
 struct xfs_da_geometry;
+struct xfs_perag;
 
 /* dynamic preallocation free space thresholds, 5% down to 1% */
 enum {
@@ -297,118 +298,12 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 	return (xfs_agblock_t) do_div(ld, mp->m_sb.sb_agblocks);
 }
 
-/* per-AG block reservation data structures*/
-struct xfs_ag_resv {
-	/* number of blocks originally reserved here */
-	xfs_extlen_t			ar_orig_reserved;
-	/* number of blocks reserved here */
-	xfs_extlen_t			ar_reserved;
-	/* number of blocks originally asked for */
-	xfs_extlen_t			ar_asked;
-};
-
-/*
- * Per-ag incore structure, copies of information in agf and agi, to improve the
- * performance of allocation group selection.
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
-	bool		pagf_agflreset; /* agfl requires reset before use */
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
-
-	int		pagb_count;	/* pagb slots in use */
-	uint8_t		pagf_refcount_level; /* recount btree height */
-
-	/* Blocks reserved for all kinds of metadata. */
-	struct xfs_ag_resv	pag_meta_resv;
-	/* Blocks reserved for the reverse mapping btree. */
-	struct xfs_ag_resv	pag_rmapbt_resv;
-
-	/* -- kernel only structures below this line -- */
-
-	/*
-	 * Bitsets of per-ag metadata that have been checked and/or are sick.
-	 * Callers should hold pag_state_lock before accessing this field.
-	 */
-	uint16_t	pag_checked;
-	uint16_t	pag_sick;
-	spinlock_t	pag_state_lock;
-
-	spinlock_t	pagb_lock;	/* lock for pagb_tree */
-	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
-	unsigned int	pagb_gen;	/* generation count for pagb_tree */
-	wait_queue_head_t pagb_wait;	/* woken when pagb_gen changes */
-
-	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
-
-	spinlock_t	pag_ici_lock;	/* incore inode cache lock */
-	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
-	int		pag_ici_reclaimable;	/* reclaimable inodes */
-	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
-
-	/* buffer cache index */
-	spinlock_t	pag_buf_lock;	/* lock for pag_buf_hash */
-	struct rhashtable pag_buf_hash;
-
-	/* for rcu-safe freeing */
-	struct rcu_head	rcu_head;
-
-	/* background prealloc block trimming */
-	struct delayed_work	pag_blockgc_work;
-
-	/*
-	 * Unlinked inode information.  This incore information reflects
-	 * data stored in the AGI, so callers must hold the AGI buffer lock
-	 * or have some other means to control concurrency.
-	 */
-	struct rhashtable	pagi_unlinked_hash;
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
-int xfs_buf_hash_init(xfs_perag_t *pag);
-void xfs_buf_hash_destroy(xfs_perag_t *pag);
+int xfs_buf_hash_init(struct xfs_perag *pag);
+void xfs_buf_hash_destroy(struct xfs_perag *pag);
 
 extern void	xfs_uuid_table_free(void);
 extern uint64_t xfs_default_resblks(xfs_mount_t *mp);
 extern int	xfs_mountfs(xfs_mount_t *mp);
-extern int	xfs_initialize_perag(xfs_mount_t *mp, xfs_agnumber_t agcount,
-				     xfs_agnumber_t *maxagi);
 extern void	xfs_unmountfs(xfs_mount_t *);
 
 extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 9b8d703dc9fd..7e01e00550ac 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -30,6 +30,8 @@
 #include "xfs_fsmap.h"
 #include "xfs_btree_staging.h"
 #include "xfs_icache.h"
+#include "xfs_ag.h"
+#include "xfs_ag_resv.h"
 
 /*
  * We include this last to have the helpers above available for the trace
-- 
2.31.1

