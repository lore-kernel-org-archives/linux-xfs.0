Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58114 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752258AbeFXTZN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jun 2018 15:25:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5OJPCqn120298
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:25:12 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2jt7mp8hpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:25:12 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJPCMG015760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:25:12 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJPBp4032002
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:25:11 GMT
Subject: [PATCH 15/21] xfs: repair inode block maps
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 24 Jun 2018 12:25:04 -0700
Message-ID: <152986830398.3155.17588593858936667680.stgit@magnolia>
In-Reply-To: <152986820984.3155.16417868536016544528.stgit@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
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
 fs/xfs/scrub/bmap.c        |    8 +
 fs/xfs/scrub/bmap_repair.c |  488 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h      |    4 
 fs/xfs/scrub/scrub.c       |    4 
 5 files changed, 503 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/bmap_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index f47f0fe0e70a..928c7dd0a28d 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -165,6 +165,7 @@ ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
 				   alloc_repair.o \
+				   bmap_repair.o \
 				   ialloc_repair.o \
 				   inode_repair.o \
 				   refcount_repair.o \
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 3d08589f5c60..cf40d65398e6 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -57,6 +57,14 @@ xfs_scrub_setup_inode_bmap(
 		error = filemap_write_and_wait(VFS_I(sc->ip)->i_mapping);
 		if (error)
 			goto out;
+
+		/* Drop the page cache if we're repairing block mappings. */
+		if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) {
+			error = invalidate_inode_pages2(
+					VFS_I(sc->ip)->i_mapping);
+			if (error)
+				goto out;
+		}
 	}
 
 	/* Got the inode, lock it and we're ready to go. */
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
new file mode 100644
index 000000000000..def391a897b6
--- /dev/null
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -0,0 +1,488 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
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
+	struct list_head		*extlist;
+	struct xfs_repair_extent_list	*btlist;
+	struct xfs_scrub_context	*sc;
+	xfs_ino_t			ino;
+	xfs_rfsblock_t			otherfork_blocks;
+	xfs_rfsblock_t			bmbt_blocks;
+	xfs_extnum_t			extents;
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
+	if (xfs_scrub_should_terminate(rb->sc, &error))
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
+	rb->extents++;
+
+	/* Delete the old bmbt blocks later. */
+	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK) {
+		fsbno = XFS_AGB_TO_FSB(mp, cur->bc_private.a.agno,
+				rec->rm_startblock);
+		rb->bmbt_blocks += rec->rm_blockcount;
+		return xfs_repair_collect_btree_extent(rb->sc, rb->btlist,
+				fsbno, rec->rm_blockcount);
+	}
+
+	/* Remember this rmap. */
+	trace_xfs_repair_bmap_extent_fn(mp, cur->bc_private.a.agno,
+			rec->rm_startblock, rec->rm_blockcount, rec->rm_owner,
+			rec->rm_offset, rec->rm_flags);
+
+	rbe = kmem_alloc(sizeof(struct xfs_repair_bmap_extent), KM_MAYFAIL);
+	if (!rbe)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&rbe->list);
+	rbe->rmap = *rec;
+	rbe->agno = cur->bc_private.a.agno;
+	list_add_tail(&rbe->list, rb->extlist);
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
+/* Insert bmap records into an inode fork, given an rmap. */
+STATIC int
+xfs_repair_bmap_insert_rec(
+	struct xfs_scrub_context	*sc,
+	struct xfs_repair_bmap_extent	*rbe,
+	int				baseflags)
+{
+	struct xfs_bmbt_irec		bmap;
+	struct xfs_defer_ops		dfops;
+	xfs_fsblock_t			firstfsb;
+	xfs_extlen_t			extlen;
+	int				flags;
+	int				error = 0;
+
+	/* Form the "new" mapping... */
+	bmap.br_startblock = XFS_AGB_TO_FSB(sc->mp, rbe->agno,
+			rbe->rmap.rm_startblock);
+	bmap.br_startoff = rbe->rmap.rm_offset;
+
+	flags = 0;
+	if (rbe->rmap.rm_flags & XFS_RMAP_UNWRITTEN)
+		flags = XFS_BMAPI_PREALLOC;
+	while (rbe->rmap.rm_blockcount > 0) {
+		xfs_defer_init(&dfops, &firstfsb);
+		extlen = min_t(xfs_extlen_t, rbe->rmap.rm_blockcount,
+				MAXEXTLEN);
+		bmap.br_blockcount = extlen;
+
+		/* Re-add the extent to the fork. */
+		error = xfs_bmapi_remap(sc->tp, sc->ip,
+				bmap.br_startoff, extlen,
+				bmap.br_startblock, &dfops,
+				baseflags | flags);
+		if (error)
+			goto out_cancel;
+
+		bmap.br_startblock += extlen;
+		bmap.br_startoff += extlen;
+		rbe->rmap.rm_blockcount -= extlen;
+		error = xfs_defer_ijoin(&dfops, sc->ip);
+		if (error)
+			goto out_cancel;
+		error = xfs_defer_finish(&sc->tp, &dfops);
+		if (error)
+			goto out;
+		/* Make sure we roll the transaction. */
+		error = xfs_trans_roll_inode(&sc->tp, sc->ip);
+		if (error)
+			goto out;
+	}
+
+	return 0;
+out_cancel:
+	xfs_defer_cancel(&dfops);
+out:
+	return error;
+}
+
+/* Check for garbage inputs. */
+STATIC int
+xfs_repair_bmap_check_inputs(
+	struct xfs_scrub_context	*sc,
+	int				whichfork)
+{
+	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
+
+	/* Don't know how to repair the other fork formats. */
+	if (XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
+	    XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_BTREE)
+		return -EOPNOTSUPP;
+
+	/* Only files, symlinks, and directories get to have data forks. */
+	if (whichfork == XFS_DATA_FORK && !S_ISREG(VFS_I(sc->ip)->i_mode) &&
+	    !S_ISDIR(VFS_I(sc->ip)->i_mode) && !S_ISLNK(VFS_I(sc->ip)->i_mode))
+		return -EINVAL;
+
+	/* If we somehow have delalloc extents, forget it. */
+	if (whichfork == XFS_DATA_FORK && sc->ip->i_delayed_blks)
+		return -EBUSY;
+
+	/*
+	 * If there's no attr fork area in the inode, there's
+	 * no attr fork to rebuild.
+	 */
+	if (whichfork == XFS_ATTR_FORK && !XFS_IFORK_Q(sc->ip))
+		return -ENOENT;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&sc->mp->m_sb))
+		return -EOPNOTSUPP;
+
+	/* Don't know how to rebuild realtime data forks. */
+	if (XFS_IS_REALTIME_INODE(sc->ip) && whichfork == XFS_DATA_FORK)
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
+xfs_repair_bmap_find_mappings(
+	struct xfs_scrub_context	*sc,
+	int				whichfork,
+	struct list_head		*mapping_records,
+	struct xfs_repair_extent_list	*old_bmbt_blocks,
+	xfs_rfsblock_t			*old_bmbt_block_count,
+	xfs_rfsblock_t			*otherfork_blocks)
+{
+	struct xfs_repair_bmap		rb;
+	xfs_agnumber_t			agno;
+	unsigned int			resblks;
+	int				error;
+
+	memset(&rb, 0, sizeof(rb));
+	rb.extlist = mapping_records;
+	rb.btlist = old_bmbt_blocks;
+	rb.ino = sc->ip->i_ino;
+	rb.whichfork = whichfork;
+	rb.sc = sc;
+
+	/* Iterate the rmaps for extents. */
+	for (agno = 0; agno < sc->mp->m_sb.sb_agcount; agno++) {
+		error = xfs_repair_bmap_scan_ag(&rb, agno);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Guess how many blocks we're going to need to rebuild an entire bmap
+	 * from the number of extents we found, and pump up our transaction to
+	 * have sufficient block reservation.
+	 */
+	resblks = xfs_bmbt_calc_size(sc->mp, rb.extents);
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
+xfs_repair_bmap_reset_counters(
+	struct xfs_scrub_context	*sc,
+	xfs_rfsblock_t			old_bmbt_block_count,
+	xfs_rfsblock_t			otherfork_blocks,
+	int				*log_flags)
+{
+	int				error;
+
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	/*
+	 * Drop the block counts associated with this fork since we'll re-add
+	 * them with the bmap routines later.
+	 */
+	sc->ip->i_d.di_nblocks = otherfork_blocks;
+	*log_flags |= XFS_ILOG_CORE;
+
+	if (!old_bmbt_block_count)
+		return 0;
+
+	/* Release quota counts for the old bmbt blocks. */
+	error = xfs_repair_ino_dqattach(sc);
+	if (error)
+		return error;
+	xfs_trans_mod_dquot_byino(sc->tp, sc->ip, XFS_TRANS_DQ_BCOUNT,
+			-(int64_t)old_bmbt_block_count);
+	return 0;
+}
+
+/* Initialize a new fork and implant it in the inode. */
+STATIC void
+xfs_repair_bmap_reset_fork(
+	struct xfs_scrub_context	*sc,
+	int				whichfork,
+	bool				has_mappings,
+	int				*log_flags)
+{
+	/* Set us back to extents format with zero records. */
+	XFS_IFORK_FMT_SET(sc->ip, whichfork, XFS_DINODE_FMT_EXTENTS);
+	XFS_IFORK_NEXT_SET(sc->ip, whichfork, 0);
+
+	/* Reinitialize the on-disk fork. */
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
+	*log_flags |= XFS_ILOG_CORE;
+}
+
+/* Build new fork mappings and dispose of the old bmbt blocks. */
+STATIC int
+xfs_repair_bmap_rebuild_tree(
+	struct xfs_scrub_context	*sc,
+	int				whichfork,
+	struct list_head		*mapping_records,
+	struct xfs_repair_extent_list	*old_bmbt_blocks)
+{
+	struct xfs_owner_info		oinfo;
+	struct xfs_repair_bmap_extent	*rbe;
+	struct xfs_repair_bmap_extent	*n;
+	int				baseflags;
+	int				error;
+
+	baseflags = XFS_BMAPI_NORMAP;
+	if (whichfork == XFS_ATTR_FORK)
+		baseflags |= XFS_BMAPI_ATTRFORK;
+
+	/* "Remap" the extents into the fork. */
+	list_sort(NULL, mapping_records, xfs_repair_bmap_extent_cmp);
+	list_for_each_entry_safe(rbe, n, mapping_records, list) {
+		error = xfs_repair_bmap_insert_rec(sc, rbe, baseflags);
+		if (error)
+			return error;
+		list_del(&rbe->list);
+		kmem_free(rbe);
+	}
+
+	/* Dispose of all the old bmbt blocks. */
+	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, whichfork);
+	return xfs_repair_reap_btree_extents(sc, old_bmbt_blocks, &oinfo,
+			XFS_AG_RESV_NONE);
+}
+
+/* Free every record in the mapping list. */
+STATIC void
+xfs_repair_bmap_cancel_bmbtrecs(
+	struct list_head		*recs)
+{
+	struct xfs_repair_bmap_extent	*rbe;
+	struct xfs_repair_bmap_extent	*n;
+
+	list_for_each_entry_safe(rbe, n, recs, list) {
+		list_del(&rbe->list);
+		kmem_free(rbe);
+	}
+}
+
+/* Repair an inode fork. */
+STATIC int
+xfs_repair_bmap(
+	struct xfs_scrub_context	*sc,
+	int				whichfork)
+{
+	struct list_head		mapping_records;
+	struct xfs_repair_extent_list	old_bmbt_blocks;
+	struct xfs_inode		*ip = sc->ip;
+	xfs_rfsblock_t			old_bmbt_block_count;
+	xfs_rfsblock_t			otherfork_blocks;
+	int				log_flags = 0;
+	int				error = 0;
+
+	error = xfs_repair_bmap_check_inputs(sc, whichfork);
+	if (error)
+		return error;
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
+	INIT_LIST_HEAD(&mapping_records);
+	xfs_repair_init_extent_list(&old_bmbt_blocks);
+	error = xfs_repair_bmap_find_mappings(sc, whichfork, &mapping_records,
+			&old_bmbt_blocks, &old_bmbt_block_count,
+			&otherfork_blocks);
+	if (error)
+		goto out;
+
+	/*
+	 * Blow out the in-core fork and zero the on-disk fork.  This is the
+	 * point at which we are no longer able to bail out gracefully.
+	 */
+	error = xfs_repair_bmap_reset_counters(sc, old_bmbt_block_count,
+			otherfork_blocks, &log_flags);
+	if (error)
+		goto out;
+	xfs_repair_bmap_reset_fork(sc, whichfork, list_empty(&mapping_records),
+			&log_flags);
+	xfs_trans_log_inode(sc->tp, sc->ip, log_flags);
+	error = xfs_trans_roll_inode(&sc->tp, sc->ip);
+	if (error)
+		goto out;
+
+	/* Now rebuild the fork extent map information. */
+	error = xfs_repair_bmap_rebuild_tree(sc, whichfork, &mapping_records,
+			&old_bmbt_blocks);
+out:
+	xfs_repair_cancel_btree_extents(sc, &old_bmbt_blocks);
+	xfs_repair_bmap_cancel_bmbtrecs(&mapping_records);
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
index e3a763540780..a832ed485e4e 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -110,6 +110,8 @@ int xfs_repair_iallocbt(struct xfs_scrub_context *sc);
 int xfs_repair_rmapbt(struct xfs_scrub_context *sc);
 int xfs_repair_refcountbt(struct xfs_scrub_context *sc);
 int xfs_repair_inode(struct xfs_scrub_context *sc);
+int xfs_repair_bmap_data(struct xfs_scrub_context *sc);
+int xfs_repair_bmap_attr(struct xfs_scrub_context *sc);
 
 #else
 
@@ -149,6 +151,8 @@ static inline int xfs_repair_rmapbt_setup(
 #define xfs_repair_rmapbt		xfs_repair_notsupported
 #define xfs_repair_refcountbt		xfs_repair_notsupported
 #define xfs_repair_inode		xfs_repair_notsupported
+#define xfs_repair_bmap_data		xfs_repair_notsupported
+#define xfs_repair_bmap_attr		xfs_repair_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 77cbb955d8a8..eecb96fe2feb 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -299,13 +299,13 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xfs_scrub_setup_inode_bmap,
 		.scrub	= xfs_scrub_bmap_data,
-		.repair	= xfs_repair_notsupported,
+		.repair	= xfs_repair_bmap_data,
 	},
 	[XFS_SCRUB_TYPE_BMBTA] = {	/* inode attr fork */
 		.type	= ST_INODE,
 		.setup	= xfs_scrub_setup_inode_bmap,
 		.scrub	= xfs_scrub_bmap_attr,
-		.repair	= xfs_repair_notsupported,
+		.repair	= xfs_repair_bmap_attr,
 	},
 	[XFS_SCRUB_TYPE_BMBTC] = {	/* inode CoW fork */
 		.type	= ST_INODE,

