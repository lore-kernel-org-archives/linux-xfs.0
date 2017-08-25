Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27573 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934108AbdHYWSy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 18:18:54 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7PMIqIq023086
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7PMIqlc019344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:52 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7PMIqXv023703
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:52 GMT
Subject: [PATCH 18/19] xfs: repair inode block maps
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 25 Aug 2017 15:18:51 -0700
Message-ID: <150369953143.9957.4759158321119437209.stgit@magnolia>
In-Reply-To: <150369940879.9957.6303798184036268321.stgit@magnolia>
References: <150369940879.9957.6303798184036268321.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the reverse-mapping btree information to rebuild an inode fork.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/bmap.c   |  395 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h |    2 
 fs/xfs/scrub/scrub.c  |    2 
 3 files changed, 398 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 8377521..7858a5e 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -35,15 +35,18 @@
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_refcount.h"
 #include "xfs_rtalloc.h"
+#include "xfs_quota.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
 #include "scrub/trace.h"
+#include "scrub/repair.h"
 
 /* Set us up with an inode's bmap. */
 STATIC int
@@ -53,12 +56,34 @@ __xfs_scrub_setup_inode_bmap(
 	bool				flush_data)
 {
 	struct xfs_mount		*mp = sc->mp;
+	unsigned int			resblks;
 	int				error;
 
 	error = xfs_scrub_get_inode(sc, ip);
 	if (error)
 		return error;
 
+	/*
+	 * Guess how many blocks we're going to need to rebuild an
+	 * entire bmap.  Since we're reloading the btree sequentially
+	 * there should be fewer splits.
+	 */
+	switch (sc->sm->sm_type) {
+	case XFS_SCRUB_TYPE_BMBTD:
+		resblks = xfs_bmbt_calc_size(mp, sc->ip->i_d.di_nextents);
+		break;
+	case XFS_SCRUB_TYPE_BMBTA:
+		resblks = xfs_bmbt_calc_size(mp, sc->ip->i_d.di_anextents);
+		break;
+	case XFS_SCRUB_TYPE_BMBTC:
+		resblks = 0;
+		break;
+	default:
+		ASSERT(0);
+		error = -EFSCORRUPTED;
+		goto out_rele;
+	}
+
 	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	xfs_ilock(sc->ip, sc->ilock_flags);
 
@@ -79,7 +104,7 @@ __xfs_scrub_setup_inode_bmap(
 
 	/* Got the inode, lock it and we're ready to go. */
 	error = xfs_scrub_trans_alloc(sc->sm, mp, &M_RES(mp)->tr_itruncate,
-			0, 0, 0, &sc->tp);
+			resblks, 0, 0, &sc->tp);
 	if (error)
 		goto out_unlock;
 	sc->ilock_flags |= XFS_ILOCK_EXCL;
@@ -88,6 +113,7 @@ __xfs_scrub_setup_inode_bmap(
 	return 0;
 out_unlock:
 	xfs_iunlock(sc->ip, sc->ilock_flags);
+out_rele:
 	if (sc->ip != ip)
 		iput(VFS_I(sc->ip));
 	sc->ip = NULL;
@@ -565,3 +591,370 @@ xfs_scrub_bmap_cow(
 
 	return xfs_scrub_bmap(sc, XFS_COW_FORK);
 }
+
+/* Inode fork block mapping (BMBT) repair. */
+
+struct xfs_repair_bmap_extent {
+	struct list_head		list;
+	struct xfs_rmap_irec		rmap;
+	xfs_agnumber_t			agno;
+};
+
+struct xfs_repair_bmap {
+	struct list_head		extlist;
+	struct list_head		btlist;
+	struct xfs_repair_bmap_extent	ext;	/* most files have 1 extent */
+	struct xfs_scrub_context	*sc;
+	xfs_ino_t			ino;
+	xfs_fileoff_t			wantblks;
+	xfs_fileoff_t			blocks;
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
+	struct xfs_mount		*mp = cur->bc_mp;
+	xfs_fsblock_t			fsbno;
+	int				error = 0;
+
+	if (xfs_scrub_should_terminate(&error))
+		return error;
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
+	/* Delete the old bmbt blocks later. */
+	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK) {
+		fsbno = XFS_AGB_TO_FSB(mp, cur->bc_private.a.agno,
+				rec->rm_startblock);
+		rb->bmbt_blocks += rec->rm_blockcount;
+		return xfs_repair_collect_btree_extent(rb->sc, &rb->btlist,
+				fsbno, rec->rm_blockcount);
+	}
+
+	/* Remember this rmap. */
+	trace_xfs_repair_bmap_extent_fn(mp, cur->bc_private.a.agno,
+			rec->rm_startblock, rec->rm_blockcount, rec->rm_owner,
+			rec->rm_offset, rec->rm_flags);
+
+	if (list_empty(&rb->extlist)) {
+		rbe = &rb->ext;
+	} else {
+		rbe = kmem_alloc(sizeof(struct xfs_repair_bmap_extent),
+				KM_MAYFAIL | KM_NOFS);
+		if (!rbe)
+			return -ENOMEM;
+	}
+
+	INIT_LIST_HEAD(&rbe->list);
+	rbe->rmap = *rec;
+	rbe->agno = cur->bc_private.a.agno;
+	list_add_tail(&rbe->list, &rb->extlist);
+
+	rb->blocks += rec->rm_blockcount;
+	if (rb->blocks >= rb->wantblks)
+		return XFS_BTREE_QUERY_RANGE_ABORT;
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
+/* Scan one AG for reverse mappings that we can turn into extent maps. */
+STATIC int
+xfs_repair_bmap_scan_ag(
+	struct xfs_repair_bmap		*rb,
+	xfs_agnumber_t			agno)
+{
+	struct xfs_scrub_context	*sc = rb->sc;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_buf			*agf_bp = NULL;
+	struct xfs_btree_cur		*cur;
+	int				error;
+
+	error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, &agf_bp);
+	if (error)
+		return error;
+	if (!agf_bp)
+		return -ENOMEM;
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, agno);
+	error = xfs_rmap_query_all(cur, xfs_repair_bmap_extent_fn, rb);
+	if (error == XFS_BTREE_QUERY_RANGE_ABORT)
+		error = 0;
+	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR :
+			XFS_BTREE_NOERROR);
+	xfs_trans_brelse(sc->tp, agf_bp);
+	return error;
+}
+
+/*
+ * Estimate how many blocks we ought to find for the fork we're rebuilding.
+ * This ought to be di_nblocks - blocks_in_other_fork, but watch for
+ * obviously bad values.
+ */
+STATIC xfs_filblks_t
+xfs_repair_bmap_estimate_blocks(
+	struct xfs_scrub_context	*sc,
+	int				whichfork)
+{
+	xfs_filblks_t			blks;
+	xfs_extnum_t			nex;
+	int				otherfork;
+	int				error;
+
+	if (sc->ip->i_d.di_nblocks >= sc->mp->m_sb.sb_dblocks)
+		return ULLONG_MAX;
+
+	otherfork = whichfork == XFS_DATA_FORK ? XFS_ATTR_FORK : XFS_DATA_FORK;
+	error = xfs_bmap_count_blocks(sc->tp, sc->ip, otherfork, &nex, &blks);
+	if (error)
+		return ULLONG_MAX;
+
+	if ((otherfork == XFS_ATTR_FORK && nex > USHRT_MAX) ||
+	    blks > sc->mp->m_sb.sb_dblocks ||
+	    blks > sc->ip->i_d.di_nblocks)
+		return ULLONG_MAX;
+
+	return sc->ip->i_d.di_nblocks - blks;
+}
+
+/* Repair an inode fork. */
+STATIC int
+xfs_repair_bmap(
+	struct xfs_scrub_context	*sc,
+	int				whichfork)
+{
+	struct xfs_repair_bmap		rb;
+	struct xfs_bmbt_irec		bmap;
+	struct xfs_defer_ops		dfops;
+	struct xfs_owner_info		oinfo;
+	struct xfs_inode		*ip = sc->ip;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_repair_bmap_extent	*rbe;
+	struct xfs_repair_bmap_extent	*n;
+	xfs_fsblock_t			firstfsb;
+	xfs_agnumber_t			agno;
+	xfs_agnumber_t			iagno;
+	xfs_extlen_t			extlen;
+	int				baseflags;
+	int				flags;
+	int				error = 0;
+
+	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
+
+	/* Don't know how to repair the other fork formats. */
+	if (XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
+	    XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_BTREE)
+		return -EOPNOTSUPP;
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
+	/*
+	 * If there's no attr fork area in the inode, there's
+	 * no attr fork to rebuild.
+	 */
+	if (whichfork == XFS_ATTR_FORK && !XFS_IFORK_Q(ip))
+		return -ENOENT;
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
+	memset(&rb, 0, sizeof(rb));
+	INIT_LIST_HEAD(&rb.extlist);
+	INIT_LIST_HEAD(&rb.btlist);
+	rb.ino = ip->i_ino;
+	rb.whichfork = whichfork;
+	rb.sc = sc;
+	rb.wantblks = xfs_repair_bmap_estimate_blocks(sc, whichfork);
+
+	/* Iterate the home AG for extents... */
+	if (rb.wantblks != ULLONG_MAX) {
+		iagno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+		error = xfs_repair_bmap_scan_ag(&rb, iagno);
+		if (error)
+			goto out;
+	} else {
+		iagno = NULLAGNUMBER;
+	}
+
+	/* ...then do the rest if we don't find all the blocks. */
+	for (agno = 0;
+	     agno < mp->m_sb.sb_agcount && rb.blocks < rb.wantblks;
+	     agno++) {
+		if (agno == iagno)
+			continue;
+		error = xfs_repair_bmap_scan_ag(&rb, agno);
+		if (error)
+			goto out;
+	}
+
+	/* Blow out the in-core fork and zero the on-disk fork. */
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+	if (XFS_IFORK_PTR(ip, whichfork) != NULL)
+		xfs_idestroy_fork(sc->ip, whichfork);
+	XFS_IFORK_FMT_SET(sc->ip, whichfork, XFS_DINODE_FMT_EXTENTS);
+	XFS_IFORK_NEXT_SET(sc->ip, whichfork, 0);
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
+	baseflags = XFS_BMAPI_NORMAP;
+	if (whichfork == XFS_ATTR_FORK)
+		baseflags |= XFS_BMAPI_ATTRFORK;
+
+	/* Decrease nblocks to reflect the freed bmbt blocks. */
+	if (rb.bmbt_blocks) {
+		sc->ip->i_d.di_nblocks -= rb.bmbt_blocks;
+		xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+		xfs_trans_mod_dquot_byino(sc->tp, sc->ip, XFS_TRANS_DQ_BCOUNT,
+				-rb.bmbt_blocks);
+		error = xfs_trans_roll(&sc->tp, sc->ip);
+		if (error)
+			goto out;
+	}
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
+
+			/* Re-add the extent to the fork. */
+			error = xfs_bmapi_remap(sc->tp, sc->ip,
+					bmap.br_startoff, extlen,
+					bmap.br_startblock, &dfops,
+					baseflags | flags);
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
+		if (rbe != &rb.ext)
+			kmem_free(rbe);
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
+		if (rbe != &rb.ext)
+			kmem_free(rbe);
+	}
+	return error;
+}
+
+/* Repair an inode's data fork. */
+int
+xfs_repair_bmap_data(
+	struct xfs_scrub_context	*sc)
+{
+	return xfs_repair_bmap(sc, XFS_DATA_FORK);
+}
+
+/* Repair an inode's attr fork. */
+int
+xfs_repair_bmap_attr(
+	struct xfs_scrub_context	*sc)
+{
+	return xfs_repair_bmap(sc, XFS_ATTR_FORK);
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 62d0002..a56f2bc 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -82,5 +82,7 @@ int xfs_repair_iallocbt(struct xfs_scrub_context *sc);
 int xfs_repair_rmapbt(struct xfs_scrub_context *sc);
 int xfs_repair_refcountbt(struct xfs_scrub_context *sc);
 int xfs_repair_inode(struct xfs_scrub_context *sc);
+int xfs_repair_bmap_data(struct xfs_scrub_context *sc);
+int xfs_repair_bmap_attr(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_REPAIR_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 47394a3..79dc9f9 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -282,10 +282,12 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 	{ /* inode data fork */
 		.setup	= xfs_scrub_setup_inode_bmap_data,
 		.scrub	= xfs_scrub_bmap_data,
+		.repair	= xfs_repair_bmap_data,
 	},
 	{ /* inode attr fork */
 		.setup	= xfs_scrub_setup_inode_bmap,
 		.scrub	= xfs_scrub_bmap_attr,
+		.repair	= xfs_repair_bmap_attr,
 	},
 	{ /* inode CoW fork */
 		.setup	= xfs_scrub_setup_inode_bmap,

