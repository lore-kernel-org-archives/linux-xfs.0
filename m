Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48396 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbfHEAfv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 20:35:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750Obvp023953
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:35:47 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2u51ptmbaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:35:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750MxbG125660
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:35:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2u5232sbja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:35:46 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x750Zk5u002561
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:35:46 GMT
Subject: [PATCH 09/18] xfs: repair inode block maps
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 04 Aug 2019 17:35:44 -0700
Message-ID: <156496534475.804304.13015459162451804355.stgit@magnolia>
In-Reply-To: <156496528310.804304.8105015456378794397.stgit@magnolia>
References: <156496528310.804304.8105015456378794397.stgit@magnolia>
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
 fs/xfs/Makefile            |    1 
 fs/xfs/scrub/bmap.c        |   22 ++
 fs/xfs/scrub/bmap_repair.c |  501 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h      |    4 
 fs/xfs/scrub/scrub.c       |    4 
 fs/xfs/scrub/trace.h       |    2 
 fs/xfs/xfs_trans.c         |   54 +++++
 fs/xfs/xfs_trans.h         |    2 
 8 files changed, 587 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/bmap_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a4b0e79ce988..1aa26be0f82e 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -163,6 +163,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   alloc_repair.o \
 				   array.o \
 				   bitmap.o \
+				   bmap_repair.o \
 				   ialloc_repair.o \
 				   inode_repair.o \
 				   refcount_repair.o \
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 1bd29fdc2ab5..fdf7035925d1 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -29,6 +29,7 @@ xchk_setup_inode_bmap(
 	struct xfs_scrub	*sc,
 	struct xfs_inode	*ip)
 {
+	bool			is_repair = false;
 	int			error;
 
 	error = xchk_get_inode(sc, ip);
@@ -38,6 +39,10 @@ xchk_setup_inode_bmap(
 	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	xfs_ilock(sc->ip, sc->ilock_flags);
 
+#ifdef CONFIG_XFS_REPAIR
+	is_repair = (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR);
+#endif
+
 	/*
 	 * We don't want any ephemeral data fork updates sitting around
 	 * while we inspect block mappings, so wait for directio to finish
@@ -45,10 +50,27 @@ xchk_setup_inode_bmap(
 	 */
 	if (S_ISREG(VFS_I(sc->ip)->i_mode) &&
 	    sc->sm->sm_type == XFS_SCRUB_TYPE_BMBTD) {
+		/* Break all our leases, we're going to mess with things. */
+		if (is_repair) {
+			error = xfs_break_layouts(VFS_I(sc->ip),
+					&sc->ilock_flags, BREAK_UNMAP);
+			if (error)
+				goto out;
+		}
+
 		inode_dio_wait(VFS_I(sc->ip));
 		error = filemap_write_and_wait(VFS_I(sc->ip)->i_mapping);
 		if (error)
 			goto out;
+
+		/* Drop the page cache if we're repairing block mappings. */
+		if (is_repair) {
+			error = invalidate_inode_pages2(
+					VFS_I(sc->ip)->i_mapping);
+			if (error)
+				goto out;
+		}
+
 	}
 
 	/* Got the inode, lock it and we're ready to go. */
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
new file mode 100644
index 000000000000..198bce36163c
--- /dev/null
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -0,0 +1,501 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_inode_fork.h"
+#include "xfs_alloc.h"
+#include "xfs_rtalloc.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_refcount.h"
+#include "xfs_quota.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/bitmap.h"
+#include "scrub/array.h"
+
+/*
+ * Inode fork block mapping (BMBT) repair.
+ *
+ * Basically, we gather all the rmap records for the inode and fork we're
+ * fixing, reset the incore fork, then re-add all the records.
+ */
+
+/* Smallest possible record to represent a single contiguous physical map. */
+#define XREP_BMAP_UNWRITTEN	((uint64_t)1ULL << 63)
+struct xrep_bmap_extent {
+	/* starting offset; upper bit means unwritten */
+	xfs_fileoff_t	startoff;
+	xfs_fsblock_t	startblock;
+	xfs_filblks_t	blockcount;
+} __packed;
+
+static inline xfs_fileoff_t
+xrep_bmap_startoff(
+	const struct xrep_bmap_extent	*ext)
+{
+	return ext->startoff & ~XREP_BMAP_UNWRITTEN;
+}
+
+struct xrep_bmap {
+	/* List of new bmap records. */
+	struct xfbma		*bmap_records;
+
+	/* Old bmbt blocks */
+	struct xfs_bitmap	*btlist;
+
+	struct xfs_scrub	*sc;
+
+	/* Inode we're fixing. */
+	xfs_ino_t		ino;
+
+	/* How many blocks did we find in the other fork? */
+	xfs_rfsblock_t		otherfork_blocks;
+
+	/* How many bmbt blocks did we find for this fork? */
+	xfs_rfsblock_t		bmbt_blocks;
+
+	/* Which fork are we fixing? */
+	int			whichfork;
+};
+
+/* Record extents that belong to this inode's fork. */
+STATIC int
+xrep_bmap_walk_rmap(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*rec,
+	void			*priv)
+{
+	struct xrep_bmap	*rb = priv;
+	struct xrep_bmap_extent	rbe;
+	struct xfs_mount	*mp = cur->bc_mp;
+	xfs_fsblock_t		fsbno;
+	int			error = 0;
+
+	if (xchk_should_terminate(rb->sc, &error))
+		return error;
+
+	/* Skip extents which are not owned by this inode and fork. */
+	if (rec->rm_owner != rb->ino) {
+		return 0;
+	} else if (rb->whichfork == XFS_DATA_FORK &&
+		 (rec->rm_flags & XFS_RMAP_ATTR_FORK)) {
+		rb->otherfork_blocks += rec->rm_blockcount;
+		return 0;
+	} else if (rb->whichfork == XFS_ATTR_FORK &&
+		 !(rec->rm_flags & XFS_RMAP_ATTR_FORK)) {
+		rb->otherfork_blocks += rec->rm_blockcount;
+		return 0;
+	}
+
+	/* Delete the old bmbt blocks later. */
+	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK) {
+		fsbno = XFS_AGB_TO_FSB(mp, cur->bc_private.a.agno,
+				rec->rm_startblock);
+		rb->bmbt_blocks += rec->rm_blockcount;
+		return xfs_bitmap_set(rb->btlist, fsbno, rec->rm_blockcount);
+	}
+
+	/* Remember this rmap. */
+	rbe.startoff = rec->rm_offset;
+	rbe.startblock = XFS_AGB_TO_FSB(mp, cur->bc_private.a.agno,
+			rec->rm_startblock);
+	rbe.blockcount = rec->rm_blockcount;
+	if (rec->rm_flags & XFS_RMAP_UNWRITTEN)
+		rbe.startoff |= XREP_BMAP_UNWRITTEN;
+	return xfbma_append(rb->bmap_records, &rbe);
+}
+
+/* Compare two bmap extents. */
+static int
+xrep_bmap_extent_cmp(
+	const void			*a,
+	const void			*b)
+{
+	xfs_fileoff_t			ao = xrep_bmap_startoff(a);
+	xfs_fileoff_t			bo = xrep_bmap_startoff(b);
+
+	if (ao > bo)
+		return 1;
+	else if (ao < bo)
+		return -1;
+	return 0;
+}
+
+/* Scan one AG for reverse mappings that we can turn into extent maps. */
+STATIC int
+xrep_bmap_scan_ag(
+	struct xrep_bmap	*rb,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_scrub	*sc = rb->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_buf		*agf_bp = NULL;
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, &agf_bp);
+	if (error)
+		return error;
+	if (!agf_bp)
+		return -ENOMEM;
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, agno);
+	error = xfs_rmap_query_all(cur, xrep_bmap_walk_rmap, rb);
+	if (error == XFS_BTREE_QUERY_RANGE_ABORT)
+		error = 0;
+	xfs_btree_del_cursor(cur, error);
+	xfs_trans_brelse(sc->tp, agf_bp);
+	return error;
+}
+
+struct xrep_add_bmap {
+	struct xfs_scrub	*sc;
+	int			baseflags;
+};
+
+/* Insert bmap records into an inode fork, given an rmap. */
+STATIC int
+xrep_bmap_insert_rec(
+	const void			*item,
+	void				*priv)
+{
+	const struct xrep_bmap_extent	*rbe = item;
+	struct xfs_bmbt_irec		bmap = {
+		.br_startblock	= rbe->startblock,
+		.br_startoff	= xrep_bmap_startoff(rbe),
+		.br_blockcount	= rbe->blockcount,
+	};
+	struct xrep_add_bmap		*x = priv;
+	xfs_extlen_t			extlen;
+	int				flags = x->baseflags;
+	int				error = 0;
+
+	if (rbe->startoff & XREP_BMAP_UNWRITTEN)
+		flags |= XFS_BMAPI_PREALLOC;
+	while (bmap.br_blockcount > 0) {
+		extlen = min_t(xfs_filblks_t, bmap.br_blockcount, MAXEXTLEN);
+
+		/* Re-add the extent to the fork. */
+		error = xfs_bmapi_remap(x->sc->tp, x->sc->ip, bmap.br_startoff,
+				extlen, bmap.br_startblock, flags);
+		if (error)
+			goto out;
+
+		bmap.br_startblock += extlen;
+		bmap.br_startoff += extlen;
+		bmap.br_blockcount -= extlen;
+
+		error = xfs_defer_finish(&x->sc->tp);
+		if (error)
+			goto out;
+		/* Make sure we roll the transaction. */
+		error = xfs_trans_roll_inode(&x->sc->tp, x->sc->ip);
+		if (error)
+			goto out;
+	}
+
+out:
+	return error;
+}
+
+/* Check for garbage inputs. */
+STATIC int
+xrep_bmap_check_inputs(
+	struct xfs_scrub	*sc,
+	int			whichfork)
+{
+	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
+
+	/* Don't know how to repair the other fork formats. */
+	if (XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
+	    XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_BTREE)
+		return -EOPNOTSUPP;
+
+	/*
+	 * If there's no attr fork area in the inode, there's no attr fork to
+	 * rebuild.
+	 */
+	if (whichfork == XFS_ATTR_FORK) {
+		if (!XFS_IFORK_Q(sc->ip))
+			return -ENOENT;
+		return 0;
+	}
+
+	/* Only files, symlinks, and directories get to have data forks. */
+	switch (VFS_I(sc->ip)->i_mode & S_IFMT) {
+	case S_IFREG:
+	case S_IFDIR:
+	case S_IFLNK:
+		/* ok */
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* If we somehow have delalloc extents, forget it. */
+	if (sc->ip->i_delayed_blks)
+		return -EBUSY;
+
+	/* Don't know how to rebuild realtime data forks. */
+	if (XFS_IS_REALTIME_INODE(sc->ip))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+/*
+ * Collect block mappings for this fork of this inode and decide if we have
+ * enough space to rebuild.  Caller is responsible for cleaning up the list if
+ * anything goes wrong.
+ */
+STATIC int
+xrep_bmap_find_mappings(
+	struct xfs_scrub	*sc,
+	int			whichfork,
+	struct xfbma		*bmap_records,
+	struct xfs_bitmap	*old_bmbt_blocks,
+	xfs_rfsblock_t		*old_bmbt_block_count,
+	xfs_rfsblock_t		*otherfork_blocks)
+{
+	struct xrep_bmap	rb = {
+		.sc		= sc,
+		.bmap_records	= bmap_records,
+		.btlist		= old_bmbt_blocks,
+		.ino		= sc->ip->i_ino,
+		.whichfork	= whichfork,
+	};
+	xfs_agnumber_t		agno;
+	unsigned int		resblks;
+	int			error;
+
+	/* Iterate the rmaps for extents. */
+	for (agno = 0; agno < sc->mp->m_sb.sb_agcount; agno++) {
+		error = xrep_bmap_scan_ag(&rb, agno);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Guess how many blocks we're going to need to rebuild an entire bmap
+	 * from the number of extents we found, and pump up our transaction to
+	 * have sufficient block reservation.
+	 */
+	resblks = xfs_bmbt_calc_size(sc->mp, xfbma_length(bmap_records));
+	error = xfs_trans_reserve_more(sc->tp, resblks, 0);
+	if (error)
+		return error;
+
+	*otherfork_blocks = rb.otherfork_blocks;
+	*old_bmbt_block_count = rb.bmbt_blocks;
+	return 0;
+}
+
+/* Update the inode counters. */
+STATIC int
+xrep_bmap_reset_counters(
+	struct xfs_scrub	*sc,
+	xfs_rfsblock_t		old_bmbt_block_count,
+	xfs_rfsblock_t		otherfork_blocks,
+	int			*log_flags)
+{
+	int			error;
+
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	/*
+	 * We're going to use the bmap routines to reconstruct a fork from rmap
+	 * records.  Those functions increment di_nblocks for us, so we need to
+	 * subtract out all the data and bmbt blocks from the fork we're about
+	 * to rebuild.  otherfork_blocks reflects all the data and bmbt blocks
+	 * for the other fork, so this assignment effectively performs the
+	 * subtraction for us.
+	 */
+	sc->ip->i_d.di_nblocks = otherfork_blocks;
+	*log_flags |= XFS_ILOG_CORE;
+
+	if (!old_bmbt_block_count)
+		return 0;
+
+	/* Release quota counts for the old bmbt blocks. */
+	error = xrep_ino_dqattach(sc);
+	if (error)
+		return error;
+	xfs_trans_mod_dquot_byino(sc->tp, sc->ip, XFS_TRANS_DQ_BCOUNT,
+			-(int64_t)old_bmbt_block_count);
+	return 0;
+}
+
+/* Initialize a new fork and implant it in the inode. */
+STATIC void
+xrep_bmap_reset_fork(
+	struct xfs_scrub	*sc,
+	int			whichfork,
+	bool			has_mappings,
+	int			*log_flags)
+{
+	/* Set us back to extents format with zero records. */
+	XFS_IFORK_FMT_SET(sc->ip, whichfork, XFS_DINODE_FMT_EXTENTS);
+	XFS_IFORK_NEXT_SET(sc->ip, whichfork, 0);
+
+	/* Reinitialize the in-core fork. */
+	if (XFS_IFORK_PTR(sc->ip, whichfork) != NULL)
+		xfs_idestroy_fork(sc->ip, whichfork);
+	if (whichfork == XFS_DATA_FORK) {
+		memset(&sc->ip->i_df, 0, sizeof(struct xfs_ifork));
+		sc->ip->i_df.if_flags |= XFS_IFEXTENTS;
+	} else if (whichfork == XFS_ATTR_FORK) {
+		if (has_mappings) {
+			sc->ip->i_afp = NULL;
+		} else {
+			sc->ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone,
+					KM_SLEEP);
+			sc->ip->i_afp->if_flags |= XFS_IFEXTENTS;
+		}
+	}
+
+	/*
+	 * Now that we've reinitialized the in-memory fork and set the inode
+	 * back to extents format with zero extents, any extents that we
+	 * subsequently map into the file will reinitialize the on-disk fork
+	 * area for us.  All we have to do is log the inode core to preserve
+	 * the format and extent count fields.
+	 */
+	*log_flags |= XFS_ILOG_CORE;
+}
+
+/* Make our changes permanent so that we can start rebuilding the fork. */
+STATIC int
+xrep_bmap_commit_new(
+	struct xfs_scrub	*sc,
+	int			log_flags)
+{
+	xfs_trans_log_inode(sc->tp, sc->ip, log_flags);
+	return xfs_trans_roll_inode(&sc->tp, sc->ip);
+}
+
+/* Build new fork mappings and dispose of the old bmbt blocks. */
+STATIC int
+xrep_bmap_rebuild_tree(
+	struct xfs_scrub	*sc,
+	int			whichfork,
+	struct xfbma		*bmap_records,
+	struct xfs_bitmap	*old_bmbt_blocks)
+{
+	struct xfs_owner_info	oinfo;
+	struct xrep_add_bmap	x = {
+		.sc		= sc,
+		.baseflags	= XFS_BMAPI_NORMAP,
+	};
+	int			error;
+
+	if (whichfork == XFS_ATTR_FORK)
+		x.baseflags |= XFS_BMAPI_ATTRFORK;
+
+	/*
+	 * Sort the bmap extents by startblock to avoid btree splits when we
+	 * rebuild the bmbt btree.
+	 */
+	error = xfbma_sort(bmap_records, xrep_bmap_extent_cmp);
+	if (error)
+		return error;
+
+	/* Dispose of all the old bmbt blocks. */
+	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, whichfork);
+	error = xrep_reap_extents(sc, old_bmbt_blocks, &oinfo,
+			XFS_AG_RESV_NONE);
+	if (error)
+		return error;
+
+	/* "Remap" the extents into the fork. */
+	return xfbma_iter_del(bmap_records, xrep_bmap_insert_rec, &x);
+}
+
+/* Repair an inode fork. */
+STATIC int
+xrep_bmap(
+	struct xfs_scrub	*sc,
+	int			whichfork)
+{
+	struct xfs_bitmap	old_bmbt_blocks;
+	struct xfbma		*bmap_records;
+	xfs_rfsblock_t		old_bmbt_block_count;
+	xfs_rfsblock_t		otherfork_blocks;
+	int			log_flags = 0;
+	int			error = 0;
+
+	error = xrep_bmap_check_inputs(sc, whichfork);
+	if (error)
+		return error;
+
+	/* Set up some storage */
+	bmap_records = xfbma_init(sizeof(struct xrep_bmap_extent));
+	if (IS_ERR(bmap_records))
+		return PTR_ERR(bmap_records);
+
+	/* Collect all reverse mappings for this fork's extents. */
+	xfs_bitmap_init(&old_bmbt_blocks);
+	error = xrep_bmap_find_mappings(sc, whichfork, bmap_records,
+			&old_bmbt_blocks, &old_bmbt_block_count,
+			&otherfork_blocks);
+	if (error)
+		goto out;
+
+	/*
+	 * Blow out the in-core fork and zero the on-disk fork.  This is the
+	 * point at which we are no longer able to bail out gracefully.
+	 */
+	error = xrep_bmap_reset_counters(sc, old_bmbt_block_count,
+			otherfork_blocks, &log_flags);
+	if (error)
+		goto out;
+	xrep_bmap_reset_fork(sc, whichfork, xfbma_length(bmap_records) == 0,
+			&log_flags);
+	error = xrep_bmap_commit_new(sc, log_flags);
+	if (error)
+		goto out;
+
+	/* Now rebuild the fork extent map information. */
+	error = xrep_bmap_rebuild_tree(sc, whichfork, bmap_records,
+			&old_bmbt_blocks);
+out:
+	xfs_bitmap_destroy(&old_bmbt_blocks);
+	xfbma_destroy(bmap_records);
+	return error;
+}
+
+/* Repair an inode's data fork. */
+int
+xrep_bmap_data(
+	struct xfs_scrub	*sc)
+{
+	return xrep_bmap(sc, XFS_DATA_FORK);
+}
+
+/* Repair an inode's attr fork. */
+int
+xrep_bmap_attr(
+	struct xfs_scrub	*sc)
+{
+	return xrep_bmap(sc, XFS_ATTR_FORK);
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index dc8e27cf6c1c..79db78d69c7d 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -69,6 +69,8 @@ int xrep_allocbt(struct xfs_scrub *sc);
 int xrep_iallocbt(struct xfs_scrub *sc);
 int xrep_refcountbt(struct xfs_scrub *sc);
 int xrep_inode(struct xfs_scrub *sc);
+int xrep_bmap_data(struct xfs_scrub *sc);
+int xrep_bmap_attr(struct xfs_scrub *sc);
 
 #else
 
@@ -112,6 +114,8 @@ xrep_reset_perag_resv(
 #define xrep_iallocbt			xrep_notsupported
 #define xrep_refcountbt			xrep_notsupported
 #define xrep_inode			xrep_notsupported
+#define xrep_bmap_data			xrep_notsupported
+#define xrep_bmap_attr			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 6de28006290c..66a59c70d743 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -266,13 +266,13 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_inode_bmap,
 		.scrub	= xchk_bmap_data,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_bmap_data,
 	},
 	[XFS_SCRUB_TYPE_BMBTA] = {	/* inode attr fork */
 		.type	= ST_INODE,
 		.setup	= xchk_setup_inode_bmap,
 		.scrub	= xchk_bmap_attr,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_bmap_attr,
 	},
 	[XFS_SCRUB_TYPE_BMBTC] = {	/* inode CoW fork */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index f7e64a5cc751..1124c86b980f 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -725,7 +725,7 @@ DEFINE_EVENT(xrep_rmap_class, name, \
 DEFINE_REPAIR_RMAP_EVENT(xrep_abt_walk_rmap);
 DEFINE_REPAIR_RMAP_EVENT(xrep_ibt_walk_rmap);
 DEFINE_REPAIR_RMAP_EVENT(xrep_rmap_extent_fn);
-DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_extent_fn);
+DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_walk_rmap);
 
 TRACE_EVENT(xrep_refcount_extent_fn,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index d42a68d8313b..d25fa31cd475 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -129,6 +129,60 @@ xfs_trans_dup(
 	return ntp;
 }
 
+/*
+ * Try to reserve more blocks for a transaction.  The single use case we
+ * support is for online repair -- use a transaction to gather data without
+ * fear of btree cycle deadlocks; calculate how many blocks we really need
+ * from that data; and only then start modifying data.  This can fail due to
+ * ENOSPC, so we have to be able to cancel the transaction.
+ */
+int
+xfs_trans_reserve_more(
+	struct xfs_trans	*tp,
+	uint			blocks,
+	uint			rtextents)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
+	int			error = 0;
+
+	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
+
+	/*
+	 * Attempt to reserve the needed disk blocks by decrementing
+	 * the number needed from the number available.  This will
+	 * fail if the count would go below zero.
+	 */
+	if (blocks > 0) {
+		error = xfs_mod_fdblocks(mp, -((int64_t)blocks), rsvd);
+		if (error)
+			return -ENOSPC;
+		tp->t_blk_res += blocks;
+	}
+
+	/*
+	 * Attempt to reserve the needed realtime extents by decrementing
+	 * the number needed from the number available.  This will
+	 * fail if the count would go below zero.
+	 */
+	if (rtextents > 0) {
+		error = xfs_mod_frextents(mp, -((int64_t)rtextents));
+		if (error) {
+			error = -ENOSPC;
+			goto out_blocks;
+		}
+		tp->t_rtx_res += rtextents;
+	}
+
+	return 0;
+out_blocks:
+	if (blocks > 0) {
+		xfs_mod_fdblocks(mp, (int64_t)blocks, rsvd);
+		tp->t_blk_res -= blocks;
+	}
+	return error;
+}
+
 /*
  * This is called to reserve free disk blocks and log space for the
  * given transaction.  This must be done before allocating any resources
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 64d7f171ebd3..982d53eb2853 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -165,6 +165,8 @@ typedef struct xfs_trans {
 int		xfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
 			uint blocks, uint rtextents, uint flags,
 			struct xfs_trans **tpp);
+int		xfs_trans_reserve_more(struct xfs_trans *tp, uint blocks,
+			uint rtextents);
 int		xfs_trans_alloc_empty(struct xfs_mount *mp,
 			struct xfs_trans **tpp);
 void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
