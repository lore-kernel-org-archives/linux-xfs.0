Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18278 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753593AbcKEAX0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:23:26 -0400
Subject: [PATCH 40/41] xfs: repair inode block maps
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:23:23 -0700
Message-ID: <147830540339.2155.2425670228404139137.stgit@birch.djwong.org>
In-Reply-To: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
References: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Use the reverse-mapping btree information to rebuild an inode fork.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   20 ++-
 fs/xfs/libxfs/xfs_bmap.h |    6 +
 fs/xfs/xfs_scrub.c       |  349 +++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 356 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 71dd6d7..e656cc8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2224,9 +2224,12 @@ xfs_bmap_add_extent_delay_real(
 	}
 
 	/* add reverse mapping */
-	error = xfs_rmap_map_extent(mp, bma->dfops, bma->ip, whichfork, new);
-	if (error)
-		goto done;
+	if (!(bma->flags & XFS_BMAPI_NORMAP)) {
+		error = xfs_rmap_map_extent(mp, bma->dfops, bma->ip,
+				whichfork, new);
+		if (error)
+			goto done;
+	}
 
 	/* convert to a btree if necessary */
 	if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
@@ -3167,9 +3170,12 @@ xfs_bmap_add_extent_hole_real(
 	}
 
 	/* add reverse mapping */
-	error = xfs_rmap_map_extent(mp, bma->dfops, bma->ip, whichfork, new);
-	if (error)
-		goto done;
+	if (!(bma->flags & XFS_BMAPI_NORMAP)) {
+		error = xfs_rmap_map_extent(mp, bma->dfops, bma->ip,
+				whichfork, new);
+		if (error)
+			goto done;
+	}
 
 	/* convert to a btree if necessary */
 	if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
@@ -4593,8 +4599,6 @@ xfs_bmapi_write(
 	ASSERT(len > 0);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(!(flags & XFS_BMAPI_REMAP) || whichfork == XFS_DATA_FORK);
-	ASSERT(!(flags & XFS_BMAPI_PREALLOC) || !(flags & XFS_BMAPI_REMAP));
 	ASSERT(!(flags & XFS_BMAPI_CONVERT) || !(flags & XFS_BMAPI_REMAP));
 	ASSERT(!(flags & XFS_BMAPI_PREALLOC) || whichfork != XFS_COW_FORK);
 	ASSERT(!(flags & XFS_BMAPI_CONVERT) || whichfork != XFS_COW_FORK);
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 7cae6ec..9d4754f 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -110,6 +110,9 @@ struct xfs_extent_free_item
 /* Map something in the CoW fork. */
 #define XFS_BMAPI_COWFORK	0x200
 
+/* Don't update the rmap btree. */
+#define XFS_BMAPI_NORMAP	0x400
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
@@ -120,7 +123,8 @@ struct xfs_extent_free_item
 	{ XFS_BMAPI_CONVERT,	"CONVERT" }, \
 	{ XFS_BMAPI_ZERO,	"ZERO" }, \
 	{ XFS_BMAPI_REMAP,	"REMAP" }, \
-	{ XFS_BMAPI_COWFORK,	"COWFORK" }
+	{ XFS_BMAPI_COWFORK,	"COWFORK" }, \
+	{ XFS_BMAPI_NORMAP,	"NORMAP" }
 
 
 static inline int xfs_bmapi_aflag(int w)
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 6d3df68..3a6e1cb8 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -2251,13 +2251,15 @@ xfs_scrub_get_inode(
 
 /* Set us up with an inode. */
 STATIC int
-xfs_scrub_setup_inode(
+__xfs_scrub_setup_inode(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip,
 	struct xfs_scrub_metadata	*sm,
-	bool				retry_deadlocked)
+	bool				retry_deadlocked,
+	bool				flush_data)
 {
 	struct xfs_mount		*mp = ip->i_mount;
+	unsigned long long		resblks;
 	int				error;
 
 	memset(sc, 0, sizeof(*sc));
@@ -2270,8 +2272,31 @@ xfs_scrub_setup_inode(
 
 	xfs_ilock(sc->ip, XFS_IOLOCK_EXCL);
 	xfs_ilock(sc->ip, XFS_MMAPLOCK_EXCL);
+
+	/*
+	 * We don't want any ephemeral data fork updates sitting around
+	 * while we inspect block mappings, so wait for directio to finish
+	 * and flush dirty data if we have delalloc reservations.
+	 */
+	if (flush_data) {
+		inode_dio_wait(VFS_I(sc->ip));
+		error = filemap_write_and_wait(VFS_I(sc->ip)->i_mapping);
+		if (error)
+			goto out_unlock;
+	}
+
+	/*
+	 * Guess how many blocks we're going to need to rebuild an
+	 * entire bmap.  We don't actually know which fork, so err
+	 * on the side of asking for more blocks than we might
+	 * actually need.  Since we're reloading the btree sequentially
+	 * there should be fewer splits.
+	 */
+	resblks = xfs_bmbt_calc_size(mp,
+			max_t(xfs_extnum_t, sc->ip->i_d.di_nextents,
+				sc->ip->i_d.di_anextents));
 	error = xfs_scrub_trans_alloc(sm, mp, &M_RES(mp)->tr_itruncate,
-			0, 0, 0, &sc->tp);
+			resblks, 0, 0, &sc->tp);
 	if (error)
 		goto out_unlock;
 	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
@@ -2286,24 +2311,61 @@ xfs_scrub_setup_inode(
 	return error;
 }
 
-/* Set us up with an inode and AG headers, if needed. */
+/* Set us up with an inode. */
 STATIC int
-xfs_scrub_setup_inode_bmap(
+xfs_scrub_setup_inode(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip,
 	struct xfs_scrub_metadata	*sm,
 	bool				retry_deadlocked)
 {
+	return __xfs_scrub_setup_inode(sc, ip, sm, retry_deadlocked, false);
+}
+
+/* Set us up with an inode and AG headers, if needed. */
+STATIC int
+__xfs_scrub_setup_inode_bmap(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm,
+	bool				retry_deadlocked,
+	bool				data)
+{
 	int				error;
 
-	error = xfs_scrub_setup_inode(sc, ip, sm, retry_deadlocked);
-	if (error || !retry_deadlocked)
+	error = __xfs_scrub_setup_inode(sc, ip, sm, retry_deadlocked, data);
+	if (error || (!retry_deadlocked &&
+		      !(sm->sm_flags & XFS_SCRUB_FLAG_REPAIR)))
 		return error;
 
 	error = xfs_scrub_ag_lock_all(sc);
 	if (error)
-		return xfs_scrub_teardown(sc, ip, error);
+		goto err;
 	return 0;
+err:
+	return xfs_scrub_teardown(sc, ip, error);
+}
+
+/* Set us up with an inode and AG headers, if needed. */
+STATIC int
+xfs_scrub_setup_inode_bmap(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm,
+	bool				deadlocked)
+{
+	return __xfs_scrub_setup_inode_bmap(sc, ip, sm, deadlocked, false);
+}
+
+/* Set us up with an inode and AG headers, if needed. */
+STATIC int
+xfs_scrub_setup_inode_bmap_data(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm,
+	bool				deadlocked)
+{
+	return __xfs_scrub_setup_inode_bmap(sc, ip, sm, deadlocked, true);
 }
 
 /* Set us up with an inode and a buffer for reading xattr values. */
@@ -6165,6 +6227,273 @@ xfs_scrub_bmap_cow(
 	return xfs_scrub_bmap(sc, XFS_COW_FORK);
 }
 
+struct xfs_repair_bmap_extent {
+	struct list_head		list;
+	struct xfs_rmap_irec		rmap;
+	xfs_agnumber_t			agno;
+};
+
+struct xfs_repair_bmap {
+	struct list_head		extlist;
+	struct list_head		btlist;
+	xfs_ino_t			ino;
+	xfs_rfsblock_t			bmbt_blocks;
+	int				whichfork;
+};
+
+/* Record extents that belong to this inode's fork. */
+STATIC int
+xfs_repair_bmap_extent_fn(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_repair_bmap		*rb = priv;
+	struct xfs_repair_bmap_extent	*rbe;
+	xfs_fsblock_t			fsbno;
+
+	/* Skip extents which are not owned by this inode and fork. */
+	if (rec->rm_owner != rb->ino)
+		return 0;
+	else if (rb->whichfork == XFS_DATA_FORK &&
+		 (rec->rm_flags & XFS_RMAP_ATTR_FORK))
+		return 0;
+	else if (rb->whichfork == XFS_ATTR_FORK &&
+		 !(rec->rm_flags & XFS_RMAP_ATTR_FORK))
+		return 0;
+
+	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK) {
+		fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
+				rec->rm_startblock);
+		rb->bmbt_blocks += rec->rm_blockcount;
+		return xfs_repair_collect_btree_extent(&rb->btlist,
+				fsbno, rec->rm_blockcount);
+	}
+
+	rbe = kmem_alloc(sizeof(*rbe), KM_NOFS);
+	if (!rbe)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&rbe->list);
+	rbe->rmap = *rec;
+	rbe->agno = cur->bc_private.a.agno;
+	list_add_tail(&rbe->list, &rb->extlist);
+
+	return 0;
+}
+
+/* Compare two bmap extents. */
+static int
+xfs_repair_bmap_extent_cmp(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	struct xfs_repair_bmap_extent	*ap;
+	struct xfs_repair_bmap_extent	*bp;
+
+	ap = container_of(a, struct xfs_repair_bmap_extent, list);
+	bp = container_of(b, struct xfs_repair_bmap_extent, list);
+
+	if (ap->rmap.rm_offset > bp->rmap.rm_offset)
+		return 1;
+	else if (ap->rmap.rm_offset < bp->rmap.rm_offset)
+		return -1;
+	return 0;
+}
+
+/* Repair an inode fork. */
+STATIC int
+xfs_repair_bmap(
+	struct xfs_scrub_context	*sc,
+	int				whichfork)
+{
+	struct xfs_repair_bmap		rb = {0};
+	struct xfs_bmbt_irec		bmap;
+	struct xfs_defer_ops		dfops;
+	struct xfs_owner_info		oinfo;
+	struct xfs_inode		*ip = sc->ip;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_buf			*agf_bp = NULL;
+	struct xfs_repair_bmap_extent	*rbe;
+	struct xfs_repair_bmap_extent	*n;
+	struct xfs_btree_cur		*cur;
+	xfs_fsblock_t			firstfsb;
+	xfs_agnumber_t			agno;
+	xfs_extlen_t			extlen;
+	int				baseflags;
+	int				flags;
+	int				nimaps;
+	int				error = 0;
+
+	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
+
+	/* Don't know how to repair the other fork formats. */
+	if (XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
+	    XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_BTREE)
+		return -ENOTTY;
+
+	/* Only files, symlinks, and directories get to have data forks. */
+	if (whichfork == XFS_DATA_FORK && !S_ISREG(VFS_I(ip)->i_mode) &&
+	    !S_ISDIR(VFS_I(ip)->i_mode) && !S_ISLNK(VFS_I(ip)->i_mode))
+		return -EINVAL;
+
+	/* If we somehow have delalloc extents, forget it. */
+	if (whichfork == XFS_DATA_FORK && ip->i_delayed_blks)
+		return -EBUSY;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	/* Don't know how to rebuild realtime data forks. */
+	if (XFS_IS_REALTIME_INODE(ip) && whichfork == XFS_DATA_FORK)
+		return -EOPNOTSUPP;
+
+	/*
+	 * If this is a file data fork, wait for all pending directio to
+	 * complete, then tear everything out of the page cache.
+	 */
+	if (S_ISREG(VFS_I(ip)->i_mode) && whichfork == XFS_DATA_FORK) {
+		inode_dio_wait(VFS_I(ip));
+		truncate_inode_pages(VFS_I(ip)->i_mapping, 0);
+	}
+
+	/* Collect all reverse mappings for this fork's extents. */
+	INIT_LIST_HEAD(&rb.extlist);
+	INIT_LIST_HEAD(&rb.btlist);
+	rb.ino = ip->i_ino;
+	rb.whichfork = whichfork;
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		ASSERT(xfs_scrub_ag_can_lock(sc, agno));
+		error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, &agf_bp);
+		if (error)
+			goto out;
+		cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, agno);
+		error = xfs_rmap_query_all(cur, xfs_repair_bmap_extent_fn, &rb);
+		xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR :
+				XFS_BTREE_NOERROR);
+		if (error)
+			goto out;
+	}
+
+	/* Blow out the in-core fork and zero the on-disk fork. */
+	if (XFS_IFORK_PTR(ip, whichfork) != NULL)
+		xfs_idestroy_fork(sc->ip, whichfork);
+	XFS_IFORK_FMT_SET(sc->ip, whichfork, XFS_DINODE_FMT_EXTENTS);
+	XFS_IFORK_NEXT_SET(sc->ip, whichfork, 0);
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	/* Reinitialize the on-disk fork. */
+	if (whichfork == XFS_DATA_FORK) {
+		memset(&ip->i_df, 0, sizeof(struct xfs_ifork));
+		ip->i_df.if_flags |= XFS_IFEXTENTS;
+	} else if (whichfork == XFS_ATTR_FORK) {
+		if (list_empty(&rb.extlist))
+			ip->i_afp = NULL;
+		else {
+			ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_NOFS);
+			ip->i_afp->if_flags |= XFS_IFEXTENTS;
+		}
+	}
+	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+	error = xfs_trans_roll(&sc->tp, sc->ip);
+	if (error)
+		goto out;
+
+	baseflags = XFS_BMAPI_REMAP | XFS_BMAPI_NORMAP;
+	if (whichfork == XFS_ATTR_FORK)
+		baseflags |= XFS_BMAPI_ATTRFORK;
+
+	/* "Remap" the extents into the fork. */
+	list_sort(NULL, &rb.extlist, xfs_repair_bmap_extent_cmp);
+	list_for_each_entry_safe(rbe, n, &rb.extlist, list) {
+		/* Form the "new" mapping... */
+		bmap.br_startblock = XFS_AGB_TO_FSB(mp, rbe->agno,
+				rbe->rmap.rm_startblock);
+		bmap.br_startoff = rbe->rmap.rm_offset;
+		flags = 0;
+		if (rbe->rmap.rm_flags & XFS_RMAP_UNWRITTEN)
+			flags = XFS_BMAPI_PREALLOC;
+		while (rbe->rmap.rm_blockcount > 0) {
+			xfs_defer_init(&dfops, &firstfsb);
+			extlen = min_t(xfs_extlen_t, rbe->rmap.rm_blockcount,
+					MAXEXTLEN);
+			bmap.br_blockcount = extlen;
+
+			/* Drop the block counter... */
+			sc->ip->i_d.di_nblocks -= extlen;
+			xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+			/* Re-add the extent to the fork. */
+			nimaps = 1;
+			firstfsb = bmap.br_startblock;
+			error = xfs_bmapi_write(sc->tp, sc->ip,
+					bmap.br_startoff,
+					extlen, baseflags | flags, &firstfsb,
+					extlen, &bmap, &nimaps,
+					&dfops);
+			if (error)
+				goto out;
+
+			bmap.br_startblock += extlen;
+			bmap.br_startoff += extlen;
+			rbe->rmap.rm_blockcount -= extlen;
+			error = xfs_defer_finish(&sc->tp, &dfops, sc->ip);
+			if (error)
+				goto out;
+			/* Make sure we roll the transaction. */
+			error = xfs_trans_roll(&sc->tp, sc->ip);
+			if (error)
+				goto out;
+		}
+		list_del(&rbe->list);
+		kmem_free(rbe);
+	}
+
+	/* Decrease nblocks to reflect the freed bmbt blocks. */
+	if (rb.bmbt_blocks) {
+		sc->ip->i_d.di_nblocks -= rb.bmbt_blocks;
+		xfs_trans_ijoin(sc->tp, sc->ip, 0);
+		xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+		error = xfs_trans_roll(&sc->tp, sc->ip);
+		if (error)
+			goto out;
+	}
+
+	/* Dispose of all the old bmbt blocks. */
+	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, whichfork);
+	error = xfs_repair_reap_btree_extents(sc, &rb.btlist, &oinfo,
+			XFS_AG_RESV_NONE);
+	if (error)
+		goto out;
+
+	return error;
+out:
+	xfs_repair_cancel_btree_extents(sc, &rb.btlist);
+	list_for_each_entry_safe(rbe, n, &rb.extlist, list) {
+		list_del(&rbe->list);
+		kmem_free(rbe);
+	}
+	return error;
+}
+
+/* Repair an inode's data fork. */
+STATIC int
+xfs_repair_bmap_data(
+	struct xfs_scrub_context	*sc)
+{
+	return xfs_repair_bmap(sc, XFS_DATA_FORK);
+}
+
+/* Repair an inode's attr fork. */
+STATIC int
+xfs_repair_bmap_attr(
+	struct xfs_scrub_context	*sc)
+{
+	return xfs_repair_bmap(sc, XFS_ATTR_FORK);
+}
+
 /* Directory/Attribute Btree */
 
 struct xfs_scrub_da_btree {
@@ -7117,8 +7446,8 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_ag_header_freeze, xfs_scrub_rmapbt, xfs_repair_rmapbt, xfs_sb_version_hasrmapbt},
 	{xfs_scrub_setup_ag_header, xfs_scrub_refcountbt, xfs_repair_refcountbt, xfs_sb_version_hasreflink},
 	{xfs_scrub_setup_inode, xfs_scrub_inode, xfs_repair_inode, NULL},
-	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_data, NULL, NULL},
-	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_attr, NULL, NULL},
+	{xfs_scrub_setup_inode_bmap_data, xfs_scrub_bmap_data, xfs_repair_bmap_data, NULL},
+	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_attr, xfs_repair_bmap_attr, NULL},
 	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_cow, NULL, NULL},
 	{xfs_scrub_setup_inode, xfs_scrub_directory, NULL, NULL},
 	{xfs_scrub_setup_inode_xattr, xfs_scrub_xattr, NULL, NULL},

