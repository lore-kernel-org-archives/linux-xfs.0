Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFC818052
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990063; cv=none; b=iH/HRMWpIqeDWMWuC77zGUNzFlTA7zSrSMB4OTWePOotjQxgF+7tUblupPlf/+Qd6xgDTrOHMpKkgoblPO6uHLO9hMKprFbNXKNne4b6hmFsmUOVdyWRbYe25VOt/u5bqqbrFL773+az2HIYw/oVtDkCojN74D+qhtGEkMUEHlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990063; c=relaxed/simple;
	bh=Lu3BKNybDVA2kT8zPDexSdMav9bOHWTrHfAWHVQUyu4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OhJlgusYQHPq2nR9rDbxLH/bqLstonPa3K2gdfsCFBx8vW0yjXFvBXNnYm7HtwfvrGhbYj8yslb8d6qOvmrSUKf+zgAY3rFXUd3129tJxvFDh/NINOkYGa6jl3Iv/5vc8tbC9SYDtOThj4Mzner+23QFDHDI+D8CDdBNA5CRFSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pShHUNBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pShHUNBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F2DC4CED3;
	Mon, 23 Dec 2024 21:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990062;
	bh=Lu3BKNybDVA2kT8zPDexSdMav9bOHWTrHfAWHVQUyu4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pShHUNByZYoAVhydUOsV4jpSkGBPLGcq8dPO39gipnFh95KDr/pAe9LwmjHNkyk00
	 QC9Hubwd5rbmeetOYf7S+iOVFsstQcZcbsz5v6qqQ2WMsKwDpt3/hkwAR9x9VWjxwv
	 /BtKQ7IePs7rMqA9bByKyJTPTmTOSNtXjwTXvOdbNZGUQa3Iudzvm0kZuuk6exOtOW
	 Jn1tvZu1BVifNHKQeF9ZUE1yBVeH3MjDu35g0/pSEs7x0aetPuriwslCFEuLZ+3zAL
	 3p1hTzwHJL0/7LLZzW4nmCucQ+Ph59SA/65qeUYUEKmAuWArZAEnlJ4SC4G0M7Kpgn
	 BI0Pyo935O7WQ==
Date: Mon, 23 Dec 2024 13:41:01 -0800
Subject: [PATCH 15/36] xfs: factor out a generic xfs_group structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940172.2293042.4440535755487265477.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: e9c4d8bfb26c13c41b73fdf4183d3df2d392101e

Split the lookup and refcount handling of struct xfs_perag into an
embedded xfs_group structure that can be reused for the upcoming
realtime groups.

It will be extended with more features later.

Note that he xg_type field will only need a single bit even with
realtime group support.  For now it fills a hole, but it might be
worth to fold it into another field if we can use this space better.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/fsmap.c                  |    6 +-
 db/info.c                   |    2 -
 db/iunlink.c                |    2 -
 include/xfs_mount.h         |    6 +-
 include/xfs_trace.h         |    7 ++
 libfrog/radix-tree.h        |    9 ++
 libxfs/Makefile             |    2 +
 libxfs/defer_item.c         |    6 +-
 libxfs/init.c               |    8 +-
 libxfs/iunlink.c            |   11 ++-
 libxfs/xfs_ag.c             |  139 +++++++-----------------------------
 libxfs/xfs_ag.h             |   81 +++++++++++++++++----
 libxfs/xfs_ag_resv.c        |   19 +++--
 libxfs/xfs_alloc.c          |   39 +++++-----
 libxfs/xfs_alloc_btree.c    |    2 -
 libxfs/xfs_bmap.c           |    2 -
 libxfs/xfs_btree.c          |    6 +-
 libxfs/xfs_group.c          |  168 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_group.h          |   41 ++++++++++
 libxfs/xfs_ialloc.c         |   40 +++++-----
 libxfs/xfs_ialloc_btree.c   |   16 ++--
 libxfs/xfs_refcount.c       |    4 +
 libxfs/xfs_refcount_btree.c |    8 +-
 libxfs/xfs_rmap.c           |    4 +
 libxfs/xfs_rmap_btree.c     |    7 +-
 libxfs/xfs_sb.c             |    6 +-
 libxfs/xfs_types.h          |    8 ++
 repair/agbtree.c            |   27 +++----
 repair/bmap_repair.c        |    4 -
 repair/bulkload.c           |    9 +-
 repair/phase2.c             |   10 +--
 repair/phase5.c             |    2 -
 repair/rmap.c               |   10 +--
 33 files changed, 455 insertions(+), 256 deletions(-)
 create mode 100644 libxfs/xfs_group.c
 create mode 100644 libxfs/xfs_group.h


diff --git a/db/fsmap.c b/db/fsmap.c
index 7fd42df2a1c854..923d7568b9d977 100644
--- a/db/fsmap.c
+++ b/db/fsmap.c
@@ -64,7 +64,7 @@ fsmap(
 
 	info.nr = 0;
 	for_each_perag_range(mp, start_ag, end_ag, pag) {
-		if (pag->pag_agno == end_ag)
+		if (pag_agno(pag) == end_ag)
 			high.rm_startblock = XFS_FSB_TO_AGBNO(mp, end_fsb);
 
 		error = -libxfs_alloc_read_agf(pag, NULL, 0, &agbp);
@@ -82,7 +82,7 @@ fsmap(
 			return;
 		}
 
-		info.agno = pag->pag_agno;
+		info.agno = pag_agno(pag);
 		error = -libxfs_rmap_query_range(bt_cur, &low, &high,
 				fsmap_fn, &info);
 		if (error) {
@@ -97,7 +97,7 @@ fsmap(
 		libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
 		libxfs_buf_relse(agbp);
 
-		if (pag->pag_agno == start_ag)
+		if (pag_agno(pag) == start_ag)
 			low.rm_startblock = 0;
 	}
 }
diff --git a/db/info.c b/db/info.c
index 9c6203f029d41c..6a8765ec761a49 100644
--- a/db/info.c
+++ b/db/info.c
@@ -66,7 +66,7 @@ print_agresv_info(
 {
 	struct xfs_buf	*bp;
 	struct xfs_agf	*agf;
-	xfs_agnumber_t	agno = pag->pag_agno;
+	xfs_agnumber_t	agno = pag_agno(pag);
 	xfs_extlen_t	ask = 0;
 	xfs_extlen_t	used = 0;
 	xfs_extlen_t	free = 0;
diff --git a/db/iunlink.c b/db/iunlink.c
index 55ba5af5a3c563..c9977a859e2842 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -117,7 +117,7 @@ dump_unlinked(
 	bool			verbose)
 {
 	struct xfs_buf		*agi_bp;
-	xfs_agnumber_t		agno = pag->pag_agno;
+	xfs_agnumber_t		agno = pag_agno(pag);
 	int			error;
 
 	error = -libxfs_ialloc_read_agi(pag, NULL, 0, &agi_bp);
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index e2add8a648f887..2102009aa8df73 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -24,6 +24,10 @@ enum {
 	XFS_LOWSP_MAX,
 };
 
+struct xfs_groups {
+	struct xarray		xa;
+};
+
 /*
  * Define a user-level mount structure with all we need
  * in order to make use of the numerous XFS_* macros.
@@ -91,7 +95,7 @@ typedef struct xfs_mount {
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
 	uint			m_alloc_set_aside; /* space we can't use */
 	uint			m_ag_max_usable; /* max space per AG */
-	struct xarray		m_perags;
+	struct xfs_groups	m_groups[XG_TYPE_MAX];
 	uint64_t		m_features;	/* active filesystem features */
 	uint64_t		m_low_space[XFS_LOWSP_MAX];
 	uint64_t		m_rtxblkmask;	/* rt extent block mask */
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 012e0018cb8367..de435a9d1a2a64 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -366,4 +366,11 @@
 #define trace_xfs_iunlink_reload_next(...)	((void) 0)
 #define trace_xfs_iunlink_remove(...)		((void) 0)
 
+#define trace_xfs_group_get(...)		((void) 0)
+#define trace_xfs_group_grab_next_tag(...)	((void) 0)
+#define trace_xfs_group_grab(...)		((void) 0)
+#define trace_xfs_group_hold(...)		((void) 0)
+#define trace_xfs_group_put(...)		((void) 0)
+#define trace_xfs_group_rele(...)		((void) 0)
+
 #endif /* __TRACE_H__ */
diff --git a/libfrog/radix-tree.h b/libfrog/radix-tree.h
index fe896134eeb283..0a4e3bb4f9defc 100644
--- a/libfrog/radix-tree.h
+++ b/libfrog/radix-tree.h
@@ -72,6 +72,8 @@ struct xarray {
 	struct radix_tree_root	r;
 };
 
+typedef unsigned xa_mark_t;
+
 static inline void xa_init(struct xarray *xa)
 {
 	INIT_RADIX_TREE(&xa->r, GFP_KERNEL);
@@ -98,4 +100,11 @@ static inline int xa_insert(struct xarray *xa, unsigned long index, void *entry,
 	return error;
 }
 
+static inline void *xa_find(struct xarray *xa, unsigned long *indexp,
+			unsigned long max, xa_mark_t filter)
+{
+	/* not implemented */
+	return NULL;
+}
+
 #endif /* __LIBFROG_RADIX_TREE_H__ */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index aca28440adac08..470583006de69a 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -49,6 +49,7 @@ HFILES = \
 	xfs_dir2.h \
 	xfs_errortag.h \
 	xfs_exchmaps.h \
+	xfs_group.h \
 	xfs_ialloc.h \
 	xfs_ialloc_btree.h \
 	xfs_inode_buf.h \
@@ -105,6 +106,7 @@ CFILES = buf_mem.c \
 	xfs_dir2_sf.c \
 	xfs_dquot_buf.c \
 	xfs_exchmaps.c \
+	xfs_group.c \
 	xfs_ialloc.c \
 	xfs_iext_tree.c \
 	xfs_inode_buf.c \
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index d5e075362ababe..f0f35361a0ff97 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -48,7 +48,7 @@ xfs_extent_free_diff_items(
 	struct xfs_extent_free_item	*ra = xefi_entry(a);
 	struct xfs_extent_free_item	*rb = xefi_entry(b);
 
-	return ra->xefi_pag->pag_agno - rb->xefi_pag->pag_agno;
+	return pag_agno(ra->xefi_pag) - pag_agno(rb->xefi_pag);
 }
 
 /* Get an EFI. */
@@ -215,7 +215,7 @@ xfs_rmap_update_diff_items(
 	struct xfs_rmap_intent		*ra = ri_entry(a);
 	struct xfs_rmap_intent		*rb = ri_entry(b);
 
-	return ra->ri_pag->pag_agno - rb->ri_pag->pag_agno;
+	return pag_agno(ra->ri_pag) - pag_agno(rb->ri_pag);
 }
 
 /* Get an RUI. */
@@ -336,7 +336,7 @@ xfs_refcount_update_diff_items(
 	struct xfs_refcount_intent	*ra = ci_entry(a);
 	struct xfs_refcount_intent	*rb = ci_entry(b);
 
-	return ra->ri_pag->pag_agno - rb->ri_pag->pag_agno;
+	return pag_agno(ra->ri_pag) - pag_agno(rb->ri_pag);
 }
 
 /* Get an CUI. */
diff --git a/libxfs/init.c b/libxfs/init.c
index 483cd99546052f..beb58706629d23 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -360,7 +360,7 @@ xfs_set_inode_alloc_perag(
 	xfs_ino_t		ino,
 	xfs_agnumber_t		max_metadata)
 {
-	if (!xfs_is_inode32(pag->pag_mount)) {
+	if (!xfs_is_inode32(pag_mount(pag))) {
 		set_bit(XFS_AGSTATE_ALLOWS_INODES, &pag->pag_opstate);
 		clear_bit(XFS_AGSTATE_PREFERS_METADATA, &pag->pag_opstate);
 		return false;
@@ -373,7 +373,7 @@ xfs_set_inode_alloc_perag(
 	}
 
 	set_bit(XFS_AGSTATE_ALLOWS_INODES, &pag->pag_opstate);
-	if (pag->pag_agno < max_metadata)
+	if (pag_agno(pag) < max_metadata)
 		set_bit(XFS_AGSTATE_PREFERS_METADATA, &pag->pag_opstate);
 	else
 		clear_bit(XFS_AGSTATE_PREFERS_METADATA, &pag->pag_opstate);
@@ -650,6 +650,7 @@ libxfs_mount(
 	struct xfs_buf		*bp;
 	struct xfs_sb		*sbp;
 	xfs_daddr_t		d;
+	int			i;
 	int			error;
 
 	mp->m_features = xfs_sb_version_to_features(sb);
@@ -667,7 +668,8 @@ libxfs_mount(
 	mp->m_finobt_nores = true;
 	xfs_set_inode32(mp);
 	mp->m_sb = *sb;
-	xa_init(&mp->m_perags);
+	for (i = 0; i < XG_TYPE_MAX; i++)
+		xa_init(&mp->m_groups[i].xa);
 	sbp = &mp->m_sb;
 	spin_lock_init(&mp->m_sb_lock);
 	spin_lock_init(&mp->m_agirotor_lock);
diff --git a/libxfs/iunlink.c b/libxfs/iunlink.c
index 6d0554535994c9..53e36cdc3439b2 100644
--- a/libxfs/iunlink.c
+++ b/libxfs/iunlink.c
@@ -65,9 +65,10 @@ xfs_iunlink_log_dinode(
 		goto out;
 	}
 
-	trace_xfs_iunlink_update_dinode(mp, iup->pag->pag_agno,
-			XFS_INO_TO_AGINO(mp, ip->i_ino),
-			be32_to_cpu(dip->di_next_unlinked), iup->next_agino);
+	trace_xfs_iunlink_update_dinode(mp, pag_agno(iup->pag),
+					XFS_INO_TO_AGINO(mp, ip->i_ino),
+					be32_to_cpu(dip->di_next_unlinked),
+					iup->next_agino);
 
 	dip->di_next_unlinked = cpu_to_be32(iup->next_agino);
 	offset = ip->i_imap.im_boffset +
@@ -137,14 +138,14 @@ xfs_iunlink_reload_next(
 	xfs_agino_t		next_agino)
 {
 	struct xfs_perag	*pag = agibp->b_pag;
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_inode	*next_ip = NULL;
 	xfs_ino_t		ino;
 	int			error;
 
 	ASSERT(next_agino != NULLAGINO);
 
-	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
+	ino = XFS_AGINO_TO_INO(mp, pag_agno(pag), next_agino);
 	error = libxfs_iget(mp, tp, ino, XFS_IGET_UNTRUSTED, &next_ip);
 	if (error)
 		return error;
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index e22ce4e83f4a62..15d4ac5a99f0e7 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -28,85 +28,7 @@
 #include "xfs_trans.h"
 #include "xfs_trace.h"
 #include "xfs_inode.h"
-
-
-/*
- * Passive reference counting access wrappers to the perag structures.  If the
- * per-ag structure is to be freed, the freeing code is responsible for cleaning
- * up objects with passive references before freeing the structure. This is
- * things like cached buffers.
- */
-struct xfs_perag *
-xfs_perag_get(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
-{
-	struct xfs_perag	*pag;
-
-	rcu_read_lock();
-	pag = xa_load(&mp->m_perags, agno);
-	if (pag) {
-		trace_xfs_perag_get(pag, _RET_IP_);
-		ASSERT(atomic_read(&pag->pag_ref) >= 0);
-		atomic_inc(&pag->pag_ref);
-	}
-	rcu_read_unlock();
-	return pag;
-}
-
-/* Get a passive reference to the given perag. */
-struct xfs_perag *
-xfs_perag_hold(
-	struct xfs_perag	*pag)
-{
-	ASSERT(atomic_read(&pag->pag_ref) > 0 ||
-	       atomic_read(&pag->pag_active_ref) > 0);
-
-	trace_xfs_perag_hold(pag, _RET_IP_);
-	atomic_inc(&pag->pag_ref);
-	return pag;
-}
-
-void
-xfs_perag_put(
-	struct xfs_perag	*pag)
-{
-	trace_xfs_perag_put(pag, _RET_IP_);
-	ASSERT(atomic_read(&pag->pag_ref) > 0);
-	atomic_dec(&pag->pag_ref);
-}
-
-/*
- * Active references for perag structures. This is for short term access to the
- * per ag structures for walking trees or accessing state. If an AG is being
- * shrunk or is offline, then this will fail to find that AG and return NULL
- * instead.
- */
-struct xfs_perag *
-xfs_perag_grab(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
-{
-	struct xfs_perag	*pag;
-
-	rcu_read_lock();
-	pag = xa_load(&mp->m_perags, agno);
-	if (pag) {
-		trace_xfs_perag_grab(pag, _RET_IP_);
-		if (!atomic_inc_not_zero(&pag->pag_active_ref))
-			pag = NULL;
-	}
-	rcu_read_unlock();
-	return pag;
-}
-
-void
-xfs_perag_rele(
-	struct xfs_perag	*pag)
-{
-	trace_xfs_perag_rele(pag, _RET_IP_);
-	atomic_dec(&pag->pag_active_ref);
-}
+#include "xfs_group.h"
 
 /*
  * xfs_initialize_perag_data
@@ -181,6 +103,19 @@ xfs_initialize_perag_data(
 	return error;
 }
 
+static void
+xfs_perag_uninit(
+	struct xfs_group	*xg)
+{
+#ifdef __KERNEL__
+	struct xfs_perag	*pag = to_perag(xg);
+
+	xfs_defer_drain_free(&pag->pag_intents_drain);
+	cancel_delayed_work_sync(&pag->pag_blockgc_work);
+	xfs_buf_cache_destroy(&pag->pag_bcache);
+#endif
+}
+
 /*
  * Free up the per-ag resources  within the specified AG range.
  */
@@ -193,22 +128,8 @@ xfs_free_perag_range(
 {
 	xfs_agnumber_t		agno;
 
-	for (agno = first_agno; agno < end_agno; agno++) {
-		struct xfs_perag	*pag = xa_erase(&mp->m_perags, agno);
-
-		ASSERT(pag);
-		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
-		xfs_defer_drain_free(&pag->pag_intents_drain);
-
-		cancel_delayed_work_sync(&pag->pag_blockgc_work);
-		xfs_buf_cache_destroy(&pag->pag_bcache);
-
-		/* drop the mount's active reference */
-		xfs_perag_rele(pag);
-		XFS_IS_CORRUPT(pag->pag_mount,
-				atomic_read(&pag->pag_active_ref) != 0);
-		kfree_rcu_mightsleep(pag);
-	}
+	for (agno = first_agno; agno < end_agno; agno++)
+		xfs_group_free(mp, agno, XG_TYPE_AG, xfs_perag_uninit);
 }
 
 /* Find the size of the AG, in blocks. */
@@ -330,16 +251,9 @@ xfs_perag_alloc(
 	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
 			&pag->agino_max);
 
-	pag->pag_agno = index;
-	pag->pag_mount = mp;
-	/* Active ref owned by mount indicates AG is online. */
-	atomic_set(&pag->pag_active_ref, 1);
-
-	error = xa_insert(&mp->m_perags, index, pag, GFP_KERNEL);
-	if (error) {
-		WARN_ON_ONCE(error == -EBUSY);
+	error = xfs_group_insert(mp, pag_group(pag), index, XG_TYPE_AG);
+	if (error)
 		goto out_buf_cache_destroy;
-	}
 
 	return 0;
 
@@ -831,7 +745,7 @@ xfs_ag_shrink_space(
 	struct xfs_trans	**tpp,
 	xfs_extlen_t		delta)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_alloc_arg	args = {
 		.tp	= *tpp,
 		.mp	= mp,
@@ -848,7 +762,7 @@ xfs_ag_shrink_space(
 	xfs_agblock_t		aglen;
 	int			error, err2;
 
-	ASSERT(pag->pag_agno == mp->m_sb.sb_agcount - 1);
+	ASSERT(pag_agno(pag) == mp->m_sb.sb_agcount - 1);
 	error = xfs_ialloc_read_agi(pag, *tpp, 0, &agibp);
 	if (error)
 		return error;
@@ -945,8 +859,8 @@ xfs_ag_shrink_space(
 
 	/* Update perag geometry */
 	pag->block_count -= delta;
-	__xfs_agino_range(pag->pag_mount, pag->block_count, &pag->agino_min,
-				&pag->agino_max);
+	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
+			&pag->agino_max);
 
 	xfs_ialloc_log_agi(*tpp, agibp, XFS_AGI_LENGTH);
 	xfs_alloc_log_agf(*tpp, agfbp, XFS_AGF_LENGTH);
@@ -971,12 +885,13 @@ xfs_ag_extend_space(
 	struct xfs_trans	*tp,
 	xfs_extlen_t		len)
 {
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_buf		*bp;
 	struct xfs_agi		*agi;
 	struct xfs_agf		*agf;
 	int			error;
 
-	ASSERT(pag->pag_agno == pag->pag_mount->m_sb.sb_agcount - 1);
+	ASSERT(pag_agno(pag) == mp->m_sb.sb_agcount - 1);
 
 	error = xfs_ialloc_read_agi(pag, tp, 0, &bp);
 	if (error)
@@ -1016,8 +931,8 @@ xfs_ag_extend_space(
 
 	/* Update perag geometry */
 	pag->block_count = be32_to_cpu(agf->agf_length);
-	__xfs_agino_range(pag->pag_mount, pag->block_count, &pag->agino_min,
-				&pag->agino_max);
+	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
+			&pag->agino_max);
 	return 0;
 }
 
@@ -1044,7 +959,7 @@ xfs_ag_get_geometry(
 
 	/* Fill out form. */
 	memset(ageo, 0, sizeof(*ageo));
-	ageo->ag_number = pag->pag_agno;
+	ageo->ag_number = pag_agno(pag);
 
 	agi = agi_bp->b_addr;
 	ageo->ag_icount = be32_to_cpu(agi->agi_count);
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 8787823ae37f9f..69b934ad2c4aad 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -7,6 +7,8 @@
 #ifndef __LIBXFS_AG_H
 #define __LIBXFS_AG_H 1
 
+#include "xfs_group.h"
+
 struct xfs_mount;
 struct xfs_trans;
 struct xfs_perag;
@@ -30,10 +32,7 @@ struct xfs_ag_resv {
  * performance of allocation group selection.
  */
 struct xfs_perag {
-	struct xfs_mount *pag_mount;	/* owner filesystem */
-	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
-	atomic_t	pag_ref;	/* passive reference count */
-	atomic_t	pag_active_ref;	/* active reference count */
+	struct xfs_group pag_group;
 	unsigned long	pag_opstate;
 	uint8_t		pagf_bno_level;	/* # of levels in bno btree */
 	uint8_t		pagf_cnt_level;	/* # of levels in cnt btree */
@@ -121,6 +120,26 @@ struct xfs_perag {
 #endif /* __KERNEL__ */
 };
 
+static inline struct xfs_perag *to_perag(struct xfs_group *xg)
+{
+	return container_of(xg, struct xfs_perag, pag_group);
+}
+
+static inline struct xfs_group *pag_group(struct xfs_perag *pag)
+{
+	return &pag->pag_group;
+}
+
+static inline struct xfs_mount *pag_mount(const struct xfs_perag *pag)
+{
+	return pag->pag_group.xg_mount;
+}
+
+static inline xfs_agnumber_t pag_agno(const struct xfs_perag *pag)
+{
+	return pag->pag_group.xg_gno;
+}
+
 /*
  * Per-AG operational state. These are atomic flag bits.
  */
@@ -151,13 +170,43 @@ int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
 int xfs_update_last_ag_size(struct xfs_mount *mp, xfs_agnumber_t prev_agcount);
 
 /* Passive AG references */
-struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
-struct xfs_perag *xfs_perag_hold(struct xfs_perag *pag);
-void xfs_perag_put(struct xfs_perag *pag);
+static inline struct xfs_perag *
+xfs_perag_get(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	return to_perag(xfs_group_get(mp, agno, XG_TYPE_AG));
+}
+
+static inline struct xfs_perag *
+xfs_perag_hold(
+	struct xfs_perag	*pag)
+{
+	return to_perag(xfs_group_hold(pag_group(pag)));
+}
+
+static inline void
+xfs_perag_put(
+	struct xfs_perag	*pag)
+{
+	xfs_group_put(pag_group(pag));
+}
 
 /* Active AG references */
-struct xfs_perag *xfs_perag_grab(struct xfs_mount *, xfs_agnumber_t);
-void xfs_perag_rele(struct xfs_perag *pag);
+static inline struct xfs_perag *
+xfs_perag_grab(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	return to_perag(xfs_group_grab(mp, agno, XG_TYPE_AG));
+}
+
+static inline void
+xfs_perag_rele(
+	struct xfs_perag	*pag)
+{
+	xfs_group_rele(pag_group(pag));
+}
 
 /*
  * Per-ag geometry infomation and validation
@@ -233,9 +282,9 @@ xfs_perag_next(
 	xfs_agnumber_t		*agno,
 	xfs_agnumber_t		end_agno)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 
-	*agno = pag->pag_agno + 1;
+	*agno = pag_agno(pag) + 1;
 	xfs_perag_rele(pag);
 	while (*agno <= end_agno) {
 		pag = xfs_perag_grab(mp, *agno);
@@ -266,9 +315,9 @@ xfs_perag_next_wrap(
 	xfs_agnumber_t		restart_agno,
 	xfs_agnumber_t		wrap_agno)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 
-	*agno = pag->pag_agno + 1;
+	*agno = pag_agno(pag) + 1;
 	xfs_perag_rele(pag);
 	while (*agno != stop_agno) {
 		if (*agno >= wrap_agno) {
@@ -335,7 +384,7 @@ xfs_agbno_to_fsb(
 	struct xfs_perag	*pag,
 	xfs_agblock_t		agbno)
 {
-	return XFS_AGB_TO_FSB(pag->pag_mount, pag->pag_agno, agbno);
+	return XFS_AGB_TO_FSB(pag_mount(pag), pag_agno(pag), agbno);
 }
 
 static inline xfs_daddr_t
@@ -343,7 +392,7 @@ xfs_agbno_to_daddr(
 	struct xfs_perag	*pag,
 	xfs_agblock_t		agbno)
 {
-	return XFS_AGB_TO_DADDR(pag->pag_mount, pag->pag_agno, agbno);
+	return XFS_AGB_TO_DADDR(pag_mount(pag), pag_agno(pag), agbno);
 }
 
 static inline xfs_ino_t
@@ -351,7 +400,7 @@ xfs_agino_to_ino(
 	struct xfs_perag	*pag,
 	xfs_agino_t		agino)
 {
-	return XFS_AGINO_TO_INO(pag->pag_mount, pag->pag_agno, agino);
+	return XFS_AGINO_TO_INO(pag_mount(pag), pag_agno(pag), agino);
 }
 
 #endif /* __LIBXFS_AG_H */
diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index d1657d6c636546..f5cbaa94664f22 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -69,6 +69,7 @@ xfs_ag_resv_critical(
 	struct xfs_perag		*pag,
 	enum xfs_ag_resv_type		type)
 {
+	struct xfs_mount		*mp = pag_mount(pag);
 	xfs_extlen_t			avail;
 	xfs_extlen_t			orig;
 
@@ -91,8 +92,8 @@ xfs_ag_resv_critical(
 
 	/* Critically low if less than 10% or max btree height remains. */
 	return XFS_TEST_ERROR(avail < orig / 10 ||
-			      avail < pag->pag_mount->m_agbtree_maxlevels,
-			pag->pag_mount, XFS_ERRTAG_AG_RESV_CRITICAL);
+			      avail < mp->m_agbtree_maxlevels,
+			mp, XFS_ERRTAG_AG_RESV_CRITICAL);
 }
 
 /*
@@ -136,8 +137,8 @@ __xfs_ag_resv_free(
 	trace_xfs_ag_resv_free(pag, type, 0);
 
 	resv = xfs_perag_resv(pag, type);
-	if (pag->pag_agno == 0)
-		pag->pag_mount->m_ag_max_usable += resv->ar_asked;
+	if (pag_agno(pag) == 0)
+		pag_mount(pag)->m_ag_max_usable += resv->ar_asked;
 	/*
 	 * RMAPBT blocks come from the AGFL and AGFL blocks are always
 	 * considered "free", so whatever was reserved at mount time must be
@@ -147,7 +148,7 @@ __xfs_ag_resv_free(
 		oldresv = resv->ar_orig_reserved;
 	else
 		oldresv = resv->ar_reserved;
-	xfs_add_fdblocks(pag->pag_mount, oldresv);
+	xfs_add_fdblocks(pag_mount(pag), oldresv);
 	resv->ar_reserved = 0;
 	resv->ar_asked = 0;
 	resv->ar_orig_reserved = 0;
@@ -169,7 +170,7 @@ __xfs_ag_resv_init(
 	xfs_extlen_t			ask,
 	xfs_extlen_t			used)
 {
-	struct xfs_mount		*mp = pag->pag_mount;
+	struct xfs_mount		*mp = pag_mount(pag);
 	struct xfs_ag_resv		*resv;
 	int				error;
 	xfs_extlen_t			hidden_space;
@@ -208,7 +209,7 @@ __xfs_ag_resv_init(
 		trace_xfs_ag_resv_init_error(pag, error, _RET_IP_);
 		xfs_warn(mp,
 "Per-AG reservation for AG %u failed.  Filesystem may run out of space.",
-				pag->pag_agno);
+				pag_agno(pag));
 		return error;
 	}
 
@@ -218,7 +219,7 @@ __xfs_ag_resv_init(
 	 * counter, we only make the adjustment for AG 0.  This assumes that
 	 * there aren't any AGs hungrier for per-AG reservation than AG 0.
 	 */
-	if (pag->pag_agno == 0)
+	if (pag_agno(pag) == 0)
 		mp->m_ag_max_usable -= ask;
 
 	resv = xfs_perag_resv(pag, type);
@@ -236,7 +237,7 @@ xfs_ag_resv_init(
 	struct xfs_perag		*pag,
 	struct xfs_trans		*tp)
 {
-	struct xfs_mount		*mp = pag->pag_mount;
+	struct xfs_mount		*mp = pag_mount(pag);
 	xfs_extlen_t			ask;
 	xfs_extlen_t			used;
 	int				error = 0, error2;
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index bd39bcde0ea224..39e1961078ae3a 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -271,7 +271,7 @@ xfs_alloc_complain_bad_rec(
 
 	xfs_warn(mp,
 		"%sbt record corruption in AG %d detected at %pS!",
-		cur->bc_ops->name, cur->bc_ag.pag->pag_agno, fa);
+		cur->bc_ops->name, pag_agno(cur->bc_ag.pag), fa);
 	xfs_warn(mp,
 		"start block 0x%x block count 0x%x", irec->ar_startblock,
 		irec->ar_blockcount);
@@ -795,7 +795,7 @@ xfs_agfl_verify(
 	 * use it by using uncached buffers that don't have the perag attached
 	 * so we can detect and avoid this problem.
 	 */
-	if (bp->b_pag && be32_to_cpu(agfl->agfl_seqno) != bp->b_pag->pag_agno)
+	if (bp->b_pag && be32_to_cpu(agfl->agfl_seqno) != pag_agno((bp->b_pag)))
 		return __this_address;
 
 	for (i = 0; i < xfs_agfl_size(mp); i++) {
@@ -875,13 +875,12 @@ xfs_alloc_read_agfl(
 	struct xfs_trans	*tp,
 	struct xfs_buf		**bpp)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_buf		*bp;
 	int			error;
 
-	error = xfs_trans_read_buf(
-			mp, tp, mp->m_ddev_targp,
-			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGFL_DADDR(mp)),
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
+			XFS_AG_DADDR(mp, pag_agno(pag), XFS_AGFL_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_agfl_buf_ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGFL);
@@ -2424,7 +2423,7 @@ xfs_alloc_longest_free_extent(
 	 * reservations and AGFL rules in place, we can return this extent.
 	 */
 	if (pag->pagf_longest > delta)
-		return min_t(xfs_extlen_t, pag->pag_mount->m_ag_max_usable,
+		return min_t(xfs_extlen_t, pag_mount(pag)->m_ag_max_usable,
 				pag->pagf_longest - delta);
 
 	/* Otherwise, let the caller try for 1 block if there's space. */
@@ -2607,7 +2606,7 @@ xfs_agfl_reset(
 	xfs_warn(mp,
 	       "WARNING: Reset corrupted AGFL on AG %u. %d blocks leaked. "
 	       "Please unmount and run xfs_repair.",
-	         pag->pag_agno, pag->pagf_flcount);
+		pag_agno(pag), pag->pagf_flcount);
 
 	agf->agf_flfirst = 0;
 	agf->agf_fllast = cpu_to_be32(xfs_agfl_size(mp) - 1);
@@ -3182,7 +3181,7 @@ xfs_validate_ag_length(
 	 * use it by using uncached buffers that don't have the perag attached
 	 * so we can detect and avoid this problem.
 	 */
-	if (bp->b_pag && seqno != bp->b_pag->pag_agno)
+	if (bp->b_pag && seqno != pag_agno(bp->b_pag))
 		return __this_address;
 
 	/*
@@ -3351,13 +3350,13 @@ xfs_read_agf(
 	int			flags,
 	struct xfs_buf		**agfbpp)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	int			error;
 
 	trace_xfs_read_agf(pag);
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
-			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGF_DADDR(mp)),
+			XFS_AG_DADDR(mp, pag_agno(pag), XFS_AGF_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), flags, agfbpp, &xfs_agf_buf_ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
@@ -3380,6 +3379,7 @@ xfs_alloc_read_agf(
 	int			flags,
 	struct xfs_buf		**agfbpp)
 {
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_buf		*agfbp;
 	struct xfs_agf		*agf;
 	int			error;
@@ -3406,7 +3406,7 @@ xfs_alloc_read_agf(
 		pag->pagf_cnt_level = be32_to_cpu(agf->agf_cnt_level);
 		pag->pagf_rmap_level = be32_to_cpu(agf->agf_rmap_level);
 		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
-		if (xfs_agfl_needs_reset(pag->pag_mount, agf))
+		if (xfs_agfl_needs_reset(mp, agf))
 			set_bit(XFS_AGSTATE_AGFL_NEEDS_RESET, &pag->pag_opstate);
 		else
 			clear_bit(XFS_AGSTATE_AGFL_NEEDS_RESET, &pag->pag_opstate);
@@ -3419,16 +3419,15 @@ xfs_alloc_read_agf(
 		 * counter only tracks non-root blocks.
 		 */
 		allocbt_blks = pag->pagf_btreeblks;
-		if (xfs_has_rmapbt(pag->pag_mount))
+		if (xfs_has_rmapbt(mp))
 			allocbt_blks -= be32_to_cpu(agf->agf_rmap_blocks) - 1;
 		if (allocbt_blks > 0)
-			atomic64_add(allocbt_blks,
-					&pag->pag_mount->m_allocbt_blks);
+			atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
 
 		set_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
 	}
 #ifdef DEBUG
-	else if (!xfs_is_shutdown(pag->pag_mount)) {
+	else if (!xfs_is_shutdown(mp)) {
 		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
 		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
 		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
@@ -3646,7 +3645,7 @@ xfs_alloc_vextent_this_ag(
 	int			error;
 
 	ASSERT(args->pag != NULL);
-	ASSERT(args->pag->pag_agno == agno);
+	ASSERT(pag_agno(args->pag) == agno);
 
 	args->agno = agno;
 	args->agbno = 0;
@@ -3859,7 +3858,7 @@ xfs_alloc_vextent_exact_bno(
 	int			error;
 
 	ASSERT(args->pag != NULL);
-	ASSERT(args->pag->pag_agno == XFS_FSB_TO_AGNO(mp, target));
+	ASSERT(pag_agno(args->pag) == XFS_FSB_TO_AGNO(mp, target));
 
 	args->agno = XFS_FSB_TO_AGNO(mp, target);
 	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
@@ -3898,7 +3897,7 @@ xfs_alloc_vextent_near_bno(
 	int			error;
 
 	if (!needs_perag)
-		ASSERT(args->pag->pag_agno == XFS_FSB_TO_AGNO(mp, target));
+		ASSERT(pag_agno(args->pag) == XFS_FSB_TO_AGNO(mp, target));
 
 	args->agno = XFS_FSB_TO_AGNO(mp, target);
 	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
@@ -3935,7 +3934,7 @@ xfs_free_extent_fix_freelist(
 	memset(&args, 0, sizeof(struct xfs_alloc_arg));
 	args.tp = tp;
 	args.mp = tp->t_mountp;
-	args.agno = pag->pag_agno;
+	args.agno = pag_agno(pag);
 	args.pag = pag;
 
 	/*
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 949cd18ab16a99..667655a639fef1 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -176,7 +176,7 @@ xfs_allocbt_init_ptr_from_cur(
 {
 	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agf->agf_seqno));
 
 	if (xfs_btree_is_bno(cur->bc_ops))
 		ptr->s = agf->agf_bno_root;
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index aec378ff4a9193..13cd4faa492838 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3274,7 +3274,7 @@ xfs_bmap_longest_free_extent(
 	}
 
 	longest = xfs_alloc_longest_free_extent(pag,
-				xfs_alloc_min_freelist(pag->pag_mount, pag),
+				xfs_alloc_min_freelist(pag_mount(pag), pag),
 				xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE));
 	if (*blen < longest)
 		*blen = longest;
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 4f04a92f6513bf..2b63c18114763c 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -370,7 +370,7 @@ xfs_btree_check_ptr(
 		case XFS_BTREE_TYPE_AG:
 			xfs_err(cur->bc_mp,
 "AG %u: Corrupt %sbt pointer at level %d index %d.",
-				cur->bc_ag.pag->pag_agno, cur->bc_ops->name,
+				pag_agno(cur->bc_ag.pag), cur->bc_ops->name,
 				level, index);
 			break;
 		}
@@ -1310,7 +1310,7 @@ xfs_btree_owner(
 	case XFS_BTREE_TYPE_INODE:
 		return cur->bc_ino.ip->i_ino;
 	case XFS_BTREE_TYPE_AG:
-		return cur->bc_ag.pag->pag_agno;
+		return pag_agno(cur->bc_ag.pag);
 	default:
 		ASSERT(0);
 		return 0;
@@ -4742,7 +4742,7 @@ xfs_btree_agblock_v5hdr_verify(
 		return __this_address;
 	if (block->bb_u.s.bb_blkno != cpu_to_be64(xfs_buf_daddr(bp)))
 		return __this_address;
-	if (pag && be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
+	if (pag && be32_to_cpu(block->bb_u.s.bb_owner) != pag_agno(pag))
 		return __this_address;
 	return NULL;
 }
diff --git a/libxfs/xfs_group.c b/libxfs/xfs_group.c
new file mode 100644
index 00000000000000..8a67148362b0d7
--- /dev/null
+++ b/libxfs/xfs_group.c
@@ -0,0 +1,168 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2018 Red Hat, Inc.
+ */
+
+#include "libxfs_priv.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_trace.h"
+#include "xfs_group.h"
+
+/*
+ * Groups can have passive and active references.
+ *
+ * For passive references the code freeing a group is responsible for cleaning
+ * up objects that hold the passive references (e.g. cached buffers).
+ * Routines manipulating passive references are xfs_group_get, xfs_group_hold
+ * and xfs_group_put.
+ *
+ * Active references are for short term access to the group for walking trees or
+ * accessing state. If a group is being shrunk or offlined, the lookup will fail
+ * to find that group and return NULL instead.
+ * Routines manipulating active references are xfs_group_grab and
+ * xfs_group_rele.
+ */
+
+struct xfs_group *
+xfs_group_get(
+	struct xfs_mount	*mp,
+	uint32_t		index,
+	enum xfs_group_type	type)
+{
+	struct xfs_group	*xg;
+
+	rcu_read_lock();
+	xg = xa_load(&mp->m_groups[type].xa, index);
+	if (xg) {
+		trace_xfs_group_get(xg, _RET_IP_);
+		ASSERT(atomic_read(&xg->xg_ref) >= 0);
+		atomic_inc(&xg->xg_ref);
+	}
+	rcu_read_unlock();
+	return xg;
+}
+
+struct xfs_group *
+xfs_group_hold(
+	struct xfs_group	*xg)
+{
+	ASSERT(atomic_read(&xg->xg_ref) > 0 ||
+	       atomic_read(&xg->xg_active_ref) > 0);
+
+	trace_xfs_group_hold(xg, _RET_IP_);
+	atomic_inc(&xg->xg_ref);
+	return xg;
+}
+
+void
+xfs_group_put(
+	struct xfs_group	*xg)
+{
+	trace_xfs_group_put(xg, _RET_IP_);
+
+	ASSERT(atomic_read(&xg->xg_ref) > 0);
+	atomic_dec(&xg->xg_ref);
+}
+
+struct xfs_group *
+xfs_group_grab(
+	struct xfs_mount	*mp,
+	uint32_t		index,
+	enum xfs_group_type	type)
+{
+	struct xfs_group	*xg;
+
+	rcu_read_lock();
+	xg = xa_load(&mp->m_groups[type].xa, index);
+	if (xg) {
+		trace_xfs_group_grab(xg, _RET_IP_);
+		if (!atomic_inc_not_zero(&xg->xg_active_ref))
+			xg = NULL;
+	}
+	rcu_read_unlock();
+	return xg;
+}
+
+/*
+ * Find the next group after @xg, or the first group if @xg is NULL.
+ */
+struct xfs_group *
+xfs_group_grab_next_mark(
+	struct xfs_mount	*mp,
+	struct xfs_group	*xg,
+	xa_mark_t		mark,
+	enum xfs_group_type	type)
+{
+	unsigned long		index = 0;
+
+	if (xg) {
+		index = xg->xg_gno + 1;
+		xfs_group_rele(xg);
+	}
+
+	rcu_read_lock();
+	xg = xa_find(&mp->m_groups[type].xa, &index, ULONG_MAX, mark);
+	if (xg) {
+		trace_xfs_group_grab_next_tag(xg, _RET_IP_);
+		if (!atomic_inc_not_zero(&xg->xg_active_ref))
+			xg = NULL;
+	}
+	rcu_read_unlock();
+	return xg;
+}
+
+void
+xfs_group_rele(
+	struct xfs_group	*xg)
+{
+	trace_xfs_group_rele(xg, _RET_IP_);
+	atomic_dec(&xg->xg_active_ref);
+}
+
+void
+xfs_group_free(
+	struct xfs_mount	*mp,
+	uint32_t		index,
+	enum xfs_group_type	type,
+	void			(*uninit)(struct xfs_group *xg))
+{
+	struct xfs_group	*xg = xa_erase(&mp->m_groups[type].xa, index);
+
+	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_ref) != 0);
+
+	if (uninit)
+		uninit(xg);
+
+	/* drop the mount's active reference */
+	xfs_group_rele(xg);
+	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_active_ref) != 0);
+	kfree_rcu_mightsleep(xg);
+}
+
+int
+xfs_group_insert(
+	struct xfs_mount	*mp,
+	struct xfs_group	*xg,
+	uint32_t		index,
+	enum xfs_group_type	type)
+{
+	int			error;
+
+	xg->xg_mount = mp;
+	xg->xg_gno = index;
+	xg->xg_type = type;
+
+	/* Active ref owned by mount indicates group is online. */
+	atomic_set(&xg->xg_active_ref, 1);
+
+	error = xa_insert(&mp->m_groups[type].xa, index, xg, GFP_KERNEL);
+	if (error) {
+		WARN_ON_ONCE(error == -EBUSY);
+		return error;
+	}
+
+	return 0;
+}
diff --git a/libxfs/xfs_group.h b/libxfs/xfs_group.h
new file mode 100644
index 00000000000000..e3b6be7ff9e802
--- /dev/null
+++ b/libxfs/xfs_group.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2018 Red Hat, Inc.
+ */
+#ifndef __LIBXFS_GROUP_H
+#define __LIBXFS_GROUP_H 1
+
+struct xfs_group {
+	struct xfs_mount	*xg_mount;
+	uint32_t		xg_gno;
+	enum xfs_group_type	xg_type;
+	atomic_t		xg_ref;		/* passive reference count */
+	atomic_t		xg_active_ref;	/* active reference count */
+};
+
+struct xfs_group *xfs_group_get(struct xfs_mount *mp, uint32_t index,
+		enum xfs_group_type type);
+struct xfs_group *xfs_group_hold(struct xfs_group *xg);
+void xfs_group_put(struct xfs_group *xg);
+
+struct xfs_group *xfs_group_grab(struct xfs_mount *mp, uint32_t index,
+		enum xfs_group_type type);
+struct xfs_group *xfs_group_grab_next_mark(struct xfs_mount *mp,
+		struct xfs_group *xg, xa_mark_t mark, enum xfs_group_type type);
+void xfs_group_rele(struct xfs_group *xg);
+
+void xfs_group_free(struct xfs_mount *mp, uint32_t index,
+		enum xfs_group_type type, void (*uninit)(struct xfs_group *xg));
+int xfs_group_insert(struct xfs_mount *mp, struct xfs_group *xg,
+		uint32_t index, enum xfs_group_type);
+
+#define xfs_group_set_mark(_xg, _mark) \
+	xa_set_mark(&(_xg)->xg_mount->m_groups[(_xg)->xg_type].xa, \
+			(_xg)->xg_gno, (_mark))
+#define xfs_group_clear_mark(_xg, _mark) \
+	xa_clear_mark(&(_xg)->xg_mount->m_groups[(_xg)->xg_type].xa, \
+			(_xg)->xg_gno, (_mark))
+#define xfs_group_marked(_mp, _type, _mark) \
+	xa_marked(&(_mp)->m_groups[(_type)].xa, (_mark))
+
+#endif /* __LIBXFS_GROUP_H */
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 4f087e6b074081..e4b9d3e2fbb5ce 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -137,7 +137,7 @@ xfs_inobt_complain_bad_rec(
 
 	xfs_warn(mp,
 		"%sbt record corruption in AG %d detected at %pS!",
-		cur->bc_ops->name, cur->bc_ag.pag->pag_agno, fa);
+		cur->bc_ops->name, pag_agno(cur->bc_ag.pag), fa);
 	xfs_warn(mp,
 "start inode 0x%x, count 0x%x, free 0x%x freemask 0x%llx, holemask 0x%x",
 		irec->ir_startino, irec->ir_count, irec->ir_freecount,
@@ -546,7 +546,7 @@ xfs_inobt_insert_sprec(
 	struct xfs_buf			*agbp,
 	struct xfs_inobt_rec_incore	*nrec)	/* in/out: new/merged rec. */
 {
-	struct xfs_mount		*mp = pag->pag_mount;
+	struct xfs_mount		*mp = pag_mount(pag);
 	struct xfs_btree_cur		*cur;
 	int				error;
 	int				i;
@@ -640,7 +640,7 @@ xfs_finobt_insert_sprec(
 	struct xfs_buf			*agbp,
 	struct xfs_inobt_rec_incore	*nrec)	/* in/out: new rec. */
 {
-	struct xfs_mount		*mp = pag->pag_mount;
+	struct xfs_mount		*mp = pag_mount(pag);
 	struct xfs_btree_cur		*cur;
 	int				error;
 	int				i;
@@ -875,7 +875,7 @@ xfs_ialloc_ag_alloc(
 	 * rather than a linear progression to prevent the next generation
 	 * number from being easily guessable.
 	 */
-	error = xfs_ialloc_inode_init(args.mp, tp, NULL, newlen, pag->pag_agno,
+	error = xfs_ialloc_inode_init(args.mp, tp, NULL, newlen, pag_agno(pag),
 			args.agbno, args.len, get_random_u32());
 
 	if (error)
@@ -1066,7 +1066,7 @@ xfs_dialloc_check_ino(
 	if (error)
 		return -EAGAIN;
 
-	error = xfs_imap_to_bp(pag->pag_mount, tp, &imap, &bp);
+	error = xfs_imap_to_bp(pag_mount(pag), tp, &imap, &bp);
 	if (error)
 		return -EAGAIN;
 
@@ -1117,7 +1117,7 @@ xfs_dialloc_ag_inobt(
 	/*
 	 * If in the same AG as the parent, try to get near the parent.
 	 */
-	if (pagno == pag->pag_agno) {
+	if (pagno == pag_agno(pag)) {
 		int		doneleft;	/* done, to the left */
 		int		doneright;	/* done, to the right */
 
@@ -1594,7 +1594,7 @@ xfs_dialloc_ag(
 	 * parent. If so, find the closest available inode to the parent. If
 	 * not, consider the agi hint or find the first free inode in the AG.
 	 */
-	if (pag->pag_agno == pagno)
+	if (pag_agno(pag) == pagno)
 		error = xfs_dialloc_ag_finobt_near(pagino, &cur, &rec);
 	else
 		error = xfs_dialloc_ag_finobt_newino(agi, cur, &rec);
@@ -2048,7 +2048,7 @@ xfs_difree_inobt(
 	struct xfs_icluster		*xic,
 	struct xfs_inobt_rec_incore	*orec)
 {
-	struct xfs_mount		*mp = pag->pag_mount;
+	struct xfs_mount		*mp = pag_mount(pag);
 	struct xfs_agi			*agi = agbp->b_addr;
 	struct xfs_btree_cur		*cur;
 	struct xfs_inobt_rec_incore	rec;
@@ -2182,7 +2182,7 @@ xfs_difree_finobt(
 	xfs_agino_t			agino,
 	struct xfs_inobt_rec_incore	*ibtrec) /* inobt record */
 {
-	struct xfs_mount		*mp = pag->pag_mount;
+	struct xfs_mount		*mp = pag_mount(pag);
 	struct xfs_btree_cur		*cur;
 	struct xfs_inobt_rec_incore	rec;
 	int				offset = agino - ibtrec->ir_startino;
@@ -2305,9 +2305,9 @@ xfs_difree(
 	/*
 	 * Break up inode number into its components.
 	 */
-	if (pag->pag_agno != XFS_INO_TO_AGNO(mp, inode)) {
-		xfs_warn(mp, "%s: agno != pag->pag_agno (%d != %d).",
-			__func__, XFS_INO_TO_AGNO(mp, inode), pag->pag_agno);
+	if (pag_agno(pag) != XFS_INO_TO_AGNO(mp, inode)) {
+		xfs_warn(mp, "%s: agno != pag_agno(pag) (%d != %d).",
+			__func__, XFS_INO_TO_AGNO(mp, inode), pag_agno(pag));
 		ASSERT(0);
 		return -EINVAL;
 	}
@@ -2368,7 +2368,7 @@ xfs_imap_lookup(
 	xfs_agblock_t		*offset_agbno,
 	int			flags)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_inobt_rec_incore rec;
 	struct xfs_btree_cur	*cur;
 	struct xfs_buf		*agbp;
@@ -2379,7 +2379,7 @@ xfs_imap_lookup(
 	if (error) {
 		xfs_alert(mp,
 			"%s: xfs_ialloc_read_agi() returned error %d, agno %d",
-			__func__, error, pag->pag_agno);
+			__func__, error, pag_agno(pag));
 		return error;
 	}
 
@@ -2429,7 +2429,7 @@ xfs_imap(
 	struct xfs_imap		*imap,	/* location map structure */
 	uint			flags)	/* flags for inode btree lookup */
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	xfs_agblock_t		agbno;	/* block number of inode in the alloc group */
 	xfs_agino_t		agino;	/* inode number within alloc group */
 	xfs_agblock_t		chunk_agbno;	/* first block in inode chunk */
@@ -2721,13 +2721,13 @@ xfs_read_agi(
 	xfs_buf_flags_t		flags,
 	struct xfs_buf		**agibpp)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	int			error;
 
 	trace_xfs_read_agi(pag);
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
-			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGI_DADDR(mp)),
+			XFS_AG_DADDR(mp, pag_agno(pag), XFS_AGI_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), flags, agibpp, &xfs_agi_buf_ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
@@ -2775,7 +2775,7 @@ xfs_ialloc_read_agi(
 	 * we are in the middle of a forced shutdown.
 	 */
 	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
-		xfs_is_shutdown(pag->pag_mount));
+		xfs_is_shutdown(pag_mount(pag)));
 	if (agibpp)
 		*agibpp = agibp;
 	else
@@ -3114,13 +3114,13 @@ xfs_ialloc_check_shrink(
 	int			has;
 	int			error;
 
-	if (!xfs_has_sparseinodes(pag->pag_mount))
+	if (!xfs_has_sparseinodes(pag_mount(pag)))
 		return 0;
 
 	cur = xfs_inobt_init_cursor(pag, tp, agibp);
 
 	/* Look up the inobt record that would correspond to the new EOFS. */
-	agino = XFS_AGB_TO_AGINO(pag->pag_mount, new_length);
+	agino = XFS_AGB_TO_AGINO(pag_mount(pag), new_length);
 	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &has);
 	if (error || !has)
 		goto out;
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index f80368b4d5fa5f..45908cce464dff 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -247,7 +247,7 @@ xfs_inobt_init_ptr_from_cur(
 {
 	struct xfs_agi		*agi = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agi->agi_seqno));
+	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agi->agi_seqno));
 
 	ptr->s = agi->agi_root;
 }
@@ -259,7 +259,7 @@ xfs_finobt_init_ptr_from_cur(
 {
 	struct xfs_agi		*agi = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agi->agi_seqno));
+	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agi->agi_seqno));
 	ptr->s = agi->agi_free_root;
 }
 
@@ -477,7 +477,7 @@ xfs_inobt_init_cursor(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_btree_cur	*cur;
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_inobt_ops,
@@ -503,7 +503,7 @@ xfs_finobt_init_cursor(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_btree_cur	*cur;
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_finobt_ops,
@@ -714,7 +714,7 @@ static xfs_extlen_t
 xfs_inobt_max_size(
 	struct xfs_perag	*pag)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	xfs_agblock_t		agblocks = pag->block_count;
 
 	/* Bail out if we're uninitialized, which can happen in mkfs. */
@@ -726,7 +726,7 @@ xfs_inobt_max_size(
 	 * never be available for the kinds of things that would require btree
 	 * expansion.  We therefore can pretend the space isn't there.
 	 */
-	if (xfs_ag_contains_log(mp, pag->pag_agno))
+	if (xfs_ag_contains_log(mp, pag_agno(pag)))
 		agblocks -= mp->m_sb.sb_logblocks;
 
 	return xfs_btree_calc_size(M_IGEO(mp)->inobt_mnr,
@@ -790,10 +790,10 @@ xfs_finobt_calc_reserves(
 	xfs_extlen_t		tree_len = 0;
 	int			error;
 
-	if (!xfs_has_finobt(pag->pag_mount))
+	if (!xfs_has_finobt(pag_mount(pag)))
 		return 0;
 
-	if (xfs_has_inobtcounts(pag->pag_mount))
+	if (xfs_has_inobtcounts(pag_mount(pag)))
 		error = xfs_finobt_read_blocks(pag, tp, &tree_len);
 	else
 		error = xfs_finobt_count_blocks(pag, tp, &tree_len);
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index eeddec68a08539..9507cf74578d4f 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -153,7 +153,7 @@ xfs_refcount_complain_bad_rec(
 
 	xfs_warn(mp,
  "Refcount BTree record corruption in AG %d detected at %pS!",
-				cur->bc_ag.pag->pag_agno, fa);
+				pag_agno(cur->bc_ag.pag), fa);
 	xfs_warn(mp,
 		"Start block 0x%x, block count 0x%x, references 0x%x",
 		irec->rc_startblock, irec->rc_blockcount, irec->rc_refcount);
@@ -1320,7 +1320,7 @@ xfs_refcount_continue_op(
 	ri->ri_startblock = xfs_agbno_to_fsb(pag, new_agbno);
 
 	ASSERT(xfs_verify_fsbext(mp, ri->ri_startblock, ri->ri_blockcount));
-	ASSERT(pag->pag_agno == XFS_FSB_TO_AGNO(mp, ri->ri_startblock));
+	ASSERT(pag_agno(pag) == XFS_FSB_TO_AGNO(mp, ri->ri_startblock));
 
 	return 0;
 }
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 5913f4176889ea..e9c4fc419a6114 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -80,7 +80,7 @@ xfs_refcountbt_alloc_block(
 		*stat = 0;
 		return 0;
 	}
-	ASSERT(args.agno == cur->bc_ag.pag->pag_agno);
+	ASSERT(args.agno == pag_agno(cur->bc_ag.pag));
 	ASSERT(args.len == 1);
 
 	new->s = cpu_to_be32(args.agbno);
@@ -168,7 +168,7 @@ xfs_refcountbt_init_ptr_from_cur(
 {
 	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agf->agf_seqno));
 
 	ptr->s = agf->agf_refcount_root;
 }
@@ -360,7 +360,7 @@ xfs_refcountbt_init_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
+	ASSERT(pag_agno(pag) < mp->m_sb.sb_agcount);
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_refcountbt_ops,
 			mp->m_refc_maxlevels, xfs_refcountbt_cur_cache);
@@ -513,7 +513,7 @@ xfs_refcountbt_calc_reserves(
 	 * never be available for the kinds of things that would require btree
 	 * expansion.  We therefore can pretend the space isn't there.
 	 */
-	if (xfs_ag_contains_log(mp, pag->pag_agno))
+	if (xfs_ag_contains_log(mp, pag_agno(pag)))
 		agblocks -= mp->m_sb.sb_logblocks;
 
 	*ask += xfs_refcountbt_max_size(mp, agblocks);
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 22947e3c9ae310..0f7dee40bda87a 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -212,7 +212,7 @@ xfs_rmap_check_irec(
 	struct xfs_perag		*pag,
 	const struct xfs_rmap_irec	*irec)
 {
-	struct xfs_mount		*mp = pag->pag_mount;
+	struct xfs_mount		*mp = pag_mount(pag);
 	bool				is_inode;
 	bool				is_unwritten;
 	bool				is_bmbt;
@@ -287,7 +287,7 @@ xfs_rmap_complain_bad_rec(
 	else
 		xfs_warn(mp,
  "Reverse Mapping BTree record corruption in AG %d detected at %pS!",
-			cur->bc_ag.pag->pag_agno, fa);
+			pag_agno(cur->bc_ag.pag), fa);
 	xfs_warn(mp,
 		"Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x",
 		irec->rm_owner, irec->rm_flags, irec->rm_startblock,
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index c261d6eae3bc3b..ebb2519cf8baf3 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -226,7 +226,7 @@ xfs_rmapbt_init_ptr_from_cur(
 {
 	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agf->agf_seqno));
 
 	ptr->s = agf->agf_rmap_root;
 }
@@ -646,9 +646,8 @@ xfs_rmapbt_mem_cursor(
 	struct xfbtree		*xfbt)
 {
 	struct xfs_btree_cur	*cur;
-	struct xfs_mount	*mp = pag->pag_mount;
 
-	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_rmapbt_mem_ops,
+	cur = xfs_btree_alloc_cursor(pag_mount(pag), tp, &xfs_rmapbt_mem_ops,
 			xfs_rmapbt_maxlevels_ondisk(), xfs_rmapbt_cur_cache);
 	cur->bc_mem.xfbtree = xfbt;
 	cur->bc_nlevels = xfbt->nlevels;
@@ -862,7 +861,7 @@ xfs_rmapbt_calc_reserves(
 	 * never be available for the kinds of things that would require btree
 	 * expansion.  We therefore can pretend the space isn't there.
 	 */
-	if (xfs_ag_contains_log(mp, pag->pag_agno))
+	if (xfs_ag_contains_log(mp, pag_agno(pag)))
 		agblocks -= mp->m_sb.sb_logblocks;
 
 	/* Reserve 1% of the AG or enough for 1 block per record. */
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 0d98b8a344209e..f534ae5d4c4db2 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1131,7 +1131,7 @@ xfs_update_secondary_sbs(
 		struct xfs_buf		*bp;
 
 		error = xfs_buf_get(mp->m_ddev_targp,
-				 XFS_AG_DADDR(mp, pag->pag_agno, XFS_SB_DADDR),
+				 XFS_AG_DADDR(mp, pag_agno(pag), XFS_SB_DADDR),
 				 XFS_FSS_TO_BB(mp, 1), &bp);
 		/*
 		 * If we get an error reading or writing alternate superblocks,
@@ -1143,7 +1143,7 @@ xfs_update_secondary_sbs(
 		if (error) {
 			xfs_warn(mp,
 		"error allocating secondary superblock for ag %d",
-				pag->pag_agno);
+				pag_agno(pag));
 			if (!saved_error)
 				saved_error = error;
 			continue;
@@ -1164,7 +1164,7 @@ xfs_update_secondary_sbs(
 		if (error) {
 			xfs_warn(mp,
 		"write error %d updating a secondary superblock near ag %d",
-				error, pag->pag_agno);
+				error, pag_agno(pag));
 			if (!saved_error)
 				saved_error = error;
 			continue;
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index a8cd44d03ef648..d3cb6ff3b91301 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -212,6 +212,14 @@ enum xbtree_recpacking {
 	XBTREE_RECPACKING_FULL,
 };
 
+enum xfs_group_type {
+	XG_TYPE_AG,
+	XG_TYPE_MAX,
+} __packed;
+
+#define XG_TYPE_STRINGS \
+	{ XG_TYPE_AG,	"ag" }
+
 /*
  * Type verifier functions
  */
diff --git a/repair/agbtree.c b/repair/agbtree.c
index c8f75f49e6b363..67baa1acba9907 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -166,8 +166,7 @@ finish_rebuild(
 		if (resv->used == resv->len)
 			continue;
 
-		fsbno = XFS_AGB_TO_FSB(mp, resv->pag->pag_agno,
-				resv->agbno + resv->used);
+		fsbno = xfs_agbno_to_fsb(resv->pag, resv->agbno + resv->used);
 		error = bitmap_set(lost_blocks, fsbno, resv->len - resv->used);
 		if (error)
 			do_error(
@@ -203,7 +202,7 @@ get_bno_rec(
 	struct xfs_btree_cur	*cur,
 	struct extent_tree_node	*prev_value)
 {
-	xfs_agnumber_t		agno = cur->bc_ag.pag->pag_agno;
+	xfs_agnumber_t		agno = pag_agno(cur->bc_ag.pag);
 
 	if (xfs_btree_is_bno(cur->bc_ops)) {
 		if (!prev_value)
@@ -254,7 +253,7 @@ init_freespace_cursors(
 	struct bt_rebuild	*btr_bno,
 	struct bt_rebuild	*btr_cnt)
 {
-	xfs_agnumber_t		agno = pag->pag_agno;
+	xfs_agnumber_t		agno = pag_agno(pag);
 	unsigned int		agfl_goal;
 	int			error;
 
@@ -377,7 +376,7 @@ get_ino_rec(
 	struct xfs_btree_cur	*cur,
 	struct ino_tree_node	*prev_value)
 {
-	xfs_agnumber_t		agno = cur->bc_ag.pag->pag_agno;
+	xfs_agnumber_t		agno = pag_agno(cur->bc_ag.pag);
 
 	if (xfs_btree_is_ino(cur->bc_ops)) {
 		if (!prev_value)
@@ -482,7 +481,7 @@ init_ino_cursors(
 	struct bt_rebuild	*btr_fino)
 {
 	struct ino_tree_node	*ino_rec;
-	xfs_agnumber_t		agno = pag->pag_agno;
+	xfs_agnumber_t		agno = pag_agno(pag);
 	unsigned int		ino_recs = 0;
 	unsigned int		fino_recs = 0;
 	bool			finobt;
@@ -615,7 +614,7 @@ get_rmapbt_records(
 		if (ret == 0)
 			do_error(
  _("ran out of records while rebuilding AG %u rmap btree\n"),
-					cur->bc_ag.pag->pag_agno);
+					pag_agno(cur->bc_ag.pag));
 
 		block_rec = libxfs_btree_rec_addr(cur, idx, block);
 		cur->bc_ops->init_rec_from_cur(cur, block_rec);
@@ -632,7 +631,7 @@ init_rmapbt_cursor(
 	unsigned int		est_agfreeblocks,
 	struct bt_rebuild	*btr)
 {
-	xfs_agnumber_t		agno = pag->pag_agno;
+	xfs_agnumber_t		agno = pag_agno(pag);
 	int			error;
 
 	if (!xfs_has_rmapbt(sc->mp))
@@ -715,7 +714,7 @@ init_refc_cursor(
 	unsigned int		est_agfreeblocks,
 	struct bt_rebuild	*btr)
 {
-	xfs_agnumber_t		agno = pag->pag_agno;
+	xfs_agnumber_t		agno = pag_agno(pag);
 	int			error;
 
 	if (!xfs_has_reflink(sc->mp))
@@ -769,7 +768,7 @@ estimate_allocbt_blocks(
 	unsigned int		nr_extents)
 {
 	/* Account for space consumed by both free space btrees */
-	return libxfs_allocbt_calc_size(pag->pag_mount, nr_extents) * 2;
+	return libxfs_allocbt_calc_size(pag_mount(pag), nr_extents) * 2;
 }
 
 static xfs_extlen_t
@@ -777,7 +776,7 @@ estimate_inobt_blocks(
 	struct xfs_perag	*pag)
 {
 	struct ino_tree_node	*ino_rec;
-	xfs_agnumber_t		agno = pag->pag_agno;
+	xfs_agnumber_t		agno = pag_agno(pag);
 	unsigned int		ino_recs = 0;
 	unsigned int		fino_recs = 0;
 	xfs_extlen_t		ret;
@@ -807,9 +806,9 @@ estimate_inobt_blocks(
 			fino_recs++;
 	}
 
-	ret = libxfs_iallocbt_calc_size(pag->pag_mount, ino_recs);
-	if (xfs_has_finobt(pag->pag_mount))
-		ret += libxfs_iallocbt_calc_size(pag->pag_mount, fino_recs);
+	ret = libxfs_iallocbt_calc_size(pag_mount(pag), ino_recs);
+	if (xfs_has_finobt(pag_mount(pag)))
+		ret += libxfs_iallocbt_calc_size(pag_mount(pag), fino_recs);
 	return ret;
 
 }
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index b341caf627d5fd..7ccbb96fa8dc5e 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -129,7 +129,6 @@ xrep_bmap_walk_rmap(
 	void				*priv)
 {
 	struct xrep_bmap		*rb = priv;
-	struct xfs_mount		*mp = cur->bc_mp;
 	xfs_fsblock_t			fsbno;
 	int				error;
 
@@ -155,8 +154,7 @@ xrep_bmap_walk_rmap(
 	    !(rec->rm_flags & XFS_RMAP_ATTR_FORK))
 		return 0;
 
-	fsbno = XFS_AGB_TO_FSB(mp, cur->bc_ag.pag->pag_agno,
-			rec->rm_startblock);
+	fsbno = xfs_agbno_to_fsb(cur->bc_ag.pag, rec->rm_startblock);
 
 	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK) {
 		rb->old_bmbt_block_count += rec->rm_blockcount;
diff --git a/repair/bulkload.c b/repair/bulkload.c
index c96e569ef2979e..aada5bbae579f8 100644
--- a/repair/bulkload.c
+++ b/repair/bulkload.c
@@ -74,11 +74,10 @@ bulkload_add_extent(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		len)
 {
-	struct xfs_mount	*mp = bkl->sc->mp;
 	struct xfs_alloc_arg	args = {
 		.tp		= NULL, /* no autoreap */
 		.oinfo		= bkl->oinfo,
-		.fsbno		= XFS_AGB_TO_FSB(mp, pag->pag_agno, agbno),
+		.fsbno		= xfs_agbno_to_fsb(pag, agbno),
 		.len		= len,
 		.resv		= XFS_AG_RESV_NONE,
 	};
@@ -194,7 +193,7 @@ bulkload_free_extent(
 	 * Use EFIs to free the reservations.  We don't need to use EFIs here
 	 * like the kernel, but we'll do it to keep the code matched.
 	 */
-	fsbno = XFS_AGB_TO_FSB(sc->mp, resv->pag->pag_agno, free_agbno);
+	fsbno = xfs_agbno_to_fsb(resv->pag, free_agbno);
 	error = -libxfs_free_extent_later(sc->tp, fsbno, free_aglen,
 			&bkl->oinfo, XFS_AG_RESV_NONE,
 			XFS_FREE_EXTENT_SKIP_DISCARD);
@@ -290,7 +289,6 @@ bulkload_claim_block(
 	union xfs_btree_ptr	*ptr)
 {
 	struct bulkload_resv	*resv;
-	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_agblock_t		agbno;
 
 	/*
@@ -316,8 +314,7 @@ bulkload_claim_block(
 		list_move_tail(&resv->list, &bkl->resv_list);
 
 	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
-		ptr->l = cpu_to_be64(XFS_AGB_TO_FSB(mp, resv->pag->pag_agno,
-								agbno));
+		ptr->l = cpu_to_be64(xfs_agbno_to_fsb(resv->pag, agbno));
 	else
 		ptr->s = cpu_to_be32(agbno);
 	return 0;
diff --git a/repair/phase2.c b/repair/phase2.c
index e50cd3f8c2759d..42a2861dcc3714 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -304,13 +304,13 @@ check_fs_free_space(
 		if (error)
 			do_error(
 	_("Cannot read AGI %u for upgrade check, err=%d.\n"),
-					pag->pag_agno, error);
+					pag_agno(pag), error);
 
 		error = -libxfs_alloc_read_agf(pag, tp, 0, &agf_bp);
 		if (error)
 			do_error(
 	_("Cannot read AGF %u for upgrade check, err=%d.\n"),
-					pag->pag_agno, error);
+					pag_agno(pag), error);
 		agf = agf_bp->b_addr;
 		agblocks = be32_to_cpu(agf->agf_length);
 
@@ -326,13 +326,13 @@ check_fs_free_space(
 		if (error == ENOSPC) {
 			printf(
 	_("Not enough free space would remain in AG %u for metadata.\n"),
-					pag->pag_agno);
+					pag_agno(pag));
 			exit(1);
 		}
 		if (error)
 			do_error(
 	_("Error %d while checking AG %u space reservation.\n"),
-					error, pag->pag_agno);
+					error, pag_agno(pag));
 
 		/*
 		 * Would the post-upgrade filesystem have enough free space in
@@ -345,7 +345,7 @@ check_fs_free_space(
 		if (!check_free_space(mp, avail, agblocks)) {
 			printf(
 	_("AG %u will be low on space after upgrade.\n"),
-					pag->pag_agno);
+					pag_agno(pag));
 			exit(1);
 		}
 		libxfs_trans_cancel(tp);
diff --git a/repair/phase5.c b/repair/phase5.c
index 9207da7172c05b..fdbd9f56998fb4 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -441,7 +441,7 @@ phase5_func(
 	struct bt_rebuild	btr_fino;
 	struct bt_rebuild	btr_rmap;
 	struct bt_rebuild	btr_refc;
-	xfs_agnumber_t		agno = pag->pag_agno;
+	xfs_agnumber_t		agno = pag_agno(pag);
 	int			extra_blocks = 0;
 	uint			num_freeblocks;
 	xfs_agblock_t		num_extents;
diff --git a/repair/rmap.c b/repair/rmap.c
index 553c7a6c3658a0..29af74eee11831 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1694,7 +1694,7 @@ xfs_extlen_t
 estimate_rmapbt_blocks(
 	struct xfs_perag	*pag)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_ag_rmap	*x;
 	unsigned long long	nr_recs = 0;
 
@@ -1707,12 +1707,12 @@ estimate_rmapbt_blocks(
 	 * means we can use SEEK_DATA/HOLE on the xfile, which is faster than
 	 * walking the entire btree to count records.
 	 */
-	x = &ag_rmaps[pag->pag_agno];
+	x = &ag_rmaps[pag_agno(pag)];
 	if (!rmaps_has_observations(x))
 		return 0;
 
 	nr_recs = xmbuf_bytes(x->ar_xmbtp) / sizeof(struct xfs_rmap_rec);
-	return libxfs_rmapbt_calc_size(pag->pag_mount, nr_recs);
+	return libxfs_rmapbt_calc_size(pag_mount(pag), nr_recs);
 }
 
 /* Estimate the size of the ondisk refcountbt from the incore data. */
@@ -1720,13 +1720,13 @@ xfs_extlen_t
 estimate_refcountbt_blocks(
 	struct xfs_perag	*pag)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_ag_rmap	*x;
 
 	if (!rmap_needs_work(mp) || !xfs_has_reflink(mp))
 		return 0;
 
-	x = &ag_rmaps[pag->pag_agno];
+	x = &ag_rmaps[pag_agno(pag)];
 	if (!x->ar_refcount_items)
 		return 0;
 

