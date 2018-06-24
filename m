Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46926 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751619AbeFXTZv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jun 2018 15:25:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5OJPJcl096651
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:25:51 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2jt7vm0h63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:25:51 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJPnuO016658
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:25:50 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5OJPn8j020988
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:25:49 GMT
Subject: [PATCH 21/21] xfs: add online scrub/repair for superblock counters
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 24 Jun 2018 12:25:48 -0700
Message-ID: <152986834807.3155.15774786451677881122.stgit@magnolia>
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

Teach online scrub and repair how to check and reset the superblock
inode and block counters.  The AG rebuilding functions will need these
to adjust the counts if they need to change as a part of recovering from
corruption.  We must use the repair freeze mechanism to prevent any
other changes while we do this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                  |    2 
 fs/xfs/libxfs/xfs_fs.h           |    3 
 fs/xfs/libxfs/xfs_types.c        |   34 +++++
 fs/xfs/libxfs/xfs_types.h        |    1 
 fs/xfs/scrub/common.c            |  146 ++++++++++++++++++++
 fs/xfs/scrub/common.h            |    4 +
 fs/xfs/scrub/fscounters.c        |  276 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/fscounters_repair.c |  100 ++++++++++++++
 fs/xfs/scrub/repair.h            |    2 
 fs/xfs/scrub/scrub.c             |    6 +
 fs/xfs/scrub/scrub.h             |    7 +
 fs/xfs/scrub/trace.h             |   63 ++++++++-
 12 files changed, 639 insertions(+), 5 deletions(-)
 create mode 100644 fs/xfs/scrub/fscounters.c
 create mode 100644 fs/xfs/scrub/fscounters_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 0392bca6f5fe..50876f164b73 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -148,6 +148,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   common.o \
 				   dabtree.o \
 				   dir.o \
+				   fscounters.o \
 				   ialloc.o \
 				   inode.o \
 				   parent.o \
@@ -167,6 +168,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   attr_repair.o \
 				   alloc_repair.o \
 				   bmap_repair.o \
+				   fscounters_repair.o \
 				   ialloc_repair.o \
 				   inode_repair.o \
 				   refcount_repair.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index e93f9432d2a6..0f0e2948866c 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -502,9 +502,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_UQUOTA	21	/* user quotas */
 #define XFS_SCRUB_TYPE_GQUOTA	22	/* group quotas */
 #define XFS_SCRUB_TYPE_PQUOTA	23	/* project quotas */
+#define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	24
+#define XFS_SCRUB_TYPE_NR	25
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 2e2a243cef2e..2e9c0c25ccb6 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -171,3 +171,37 @@ xfs_verify_rtbno(
 {
 	return rtbno < mp->m_sb.sb_rblocks;
 }
+
+/* Calculate the range of valid icount values. */
+static void
+xfs_icount_range(
+	struct xfs_mount	*mp,
+	unsigned long long	*min,
+	unsigned long long	*max)
+{
+	unsigned long long	nr_inos = 0;
+	xfs_agnumber_t		agno;
+
+	/* root, rtbitmap, rtsum all live in the first chunk */
+	*min = XFS_INODES_PER_CHUNK;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		xfs_agino_t	first, last;
+
+		xfs_agino_range(mp, agno, &first, &last);
+		nr_inos += first - last + 1;
+	}
+	*max = nr_inos;
+}
+
+/* Sanity-checking of inode counts. */
+bool
+xfs_verify_icount(
+	struct xfs_mount	*mp,
+	unsigned long long	icount)
+{
+	unsigned long long	min, max;
+
+	xfs_icount_range(mp, &min, &max);
+	return icount >= min && icount < max;
+}
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 4055d62f690c..b9e6c89284c3 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -165,5 +165,6 @@ bool xfs_verify_ino(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_verify_dir_ino(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
+bool xfs_verify_icount(struct xfs_mount *mp, unsigned long long icount);
 
 #endif	/* __XFS_TYPES_H__ */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 257cb13d36e3..4c4a6a2d5480 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1029,3 +1029,149 @@ xfs_scrub_fs_thaw(
 	mutex_unlock(&sc->mp->m_scrub_freeze);
 	return error;
 }
+
+/* Decide if we're going to grab this inode for iteration. */
+STATIC int
+xfs_scrub_foreach_live_inode_ag_grab(
+	struct xfs_inode	*ip)
+{
+	struct inode		*inode = VFS_I(ip);
+
+	ASSERT(rcu_read_lock_held());
+
+	/*
+	 * check for stale RCU freed inode
+	 *
+	 * If the inode has been reallocated, it doesn't matter if it's not in
+	 * the AG we are walking - we are walking for writeback, so if it
+	 * passes all the "valid inode" checks and is dirty, then we'll write
+	 * it back anyway.  If it has been reallocated and still being
+	 * initialised, the XFS_INEW check below will catch it.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	if (!ip->i_ino)
+		goto out_unlock_noent;
+
+	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
+	if (__xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM))
+		goto out_unlock_noent;
+	spin_unlock(&ip->i_flags_lock);
+
+	/* nothing to sync during shutdown */
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		return -EFSCORRUPTED;
+
+	/* If we can't grab the inode, it must on it's way to reclaim. */
+	if (!igrab(inode))
+		return -ENOENT;
+	trace_xfs_scrub_iget(ip, __this_address);
+
+	/* inode is valid */
+	return 0;
+
+out_unlock_noent:
+	spin_unlock(&ip->i_flags_lock);
+	return -ENOENT;
+}
+
+#define XFS_LOOKUP_BATCH 32
+/*
+ * Iterate all in-core inodes of an AG.  We will not wait for inodes that are
+ * new or reclaimable, and the filesystem should be frozen by the caller.
+ */
+STATIC int
+xfs_scrub_foreach_live_inode_ag(
+	struct xfs_scrub_context *sc,
+	struct xfs_perag	*pag,
+	int			(*execute)(struct xfs_inode *ip, void *priv),
+	void			*priv)
+{
+	struct xfs_mount	*mp = sc->mp;
+	uint32_t		first_index = 0;
+	int			done = 0;
+	int			nr_found = 0;
+	int			error = 0;
+
+	do {
+		struct xfs_inode *batch[XFS_LOOKUP_BATCH];
+		int		i;
+
+		rcu_read_lock();
+
+		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
+				(void **)batch, first_index, XFS_LOOKUP_BATCH);
+		if (!nr_found) {
+			rcu_read_unlock();
+			break;
+		}
+
+		/*
+		 * Grab the inodes before we drop the lock. if we found
+		 * nothing, nr == 0 and the loop will be skipped.
+		 */
+		for (i = 0; i < nr_found; i++) {
+			struct xfs_inode *ip = batch[i];
+
+			if (done || xfs_scrub_foreach_live_inode_ag_grab(ip))
+				batch[i] = NULL;
+
+			/*
+			 * Update the index for the next lookup. Catch
+			 * overflows into the next AG range which can occur if
+			 * we have inodes in the last block of the AG and we
+			 * are currently pointing to the last inode.
+			 *
+			 * Because we may see inodes that are from the wrong AG
+			 * due to RCU freeing and reallocation, only update the
+			 * index if it lies in this AG. It was a race that lead
+			 * us to see this inode, so another lookup from the
+			 * same index will not find it again.
+			 */
+			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
+				continue;
+			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
+				done = 1;
+		}
+
+		/* unlock now we've grabbed the inodes. */
+		rcu_read_unlock();
+
+		for (i = 0; i < nr_found; i++) {
+			if (!batch[i])
+				continue;
+			if (!error)
+				error = execute(batch[i], priv);
+			xfs_scrub_iput(sc, batch[i]);
+		}
+
+		if (error)
+			break;
+	} while (nr_found && !done);
+
+	return error;
+}
+
+/*
+ * Iterate all in-core inodes.  We will not wait for inodes that are
+ * new or reclaimable, and the filesystem should be frozen by the caller.
+ */
+int
+xfs_scrub_foreach_live_inode(
+	struct xfs_scrub_context *sc,
+	int			(*execute)(struct xfs_inode *ip, void *priv),
+	void			*priv)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	int			error = 0;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount && !error; agno++) {
+		pag = xfs_perag_get(mp, agno);
+		error = xfs_scrub_foreach_live_inode_ag(sc, pag, execute, priv);
+		xfs_perag_put(pag);
+	}
+
+	return error;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index b0cca36de2de..aed12c4fb2f5 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -105,6 +105,8 @@ xfs_scrub_setup_quota(struct xfs_scrub_context *sc, struct xfs_inode *ip)
 	return -ENOENT;
 }
 #endif
+int xfs_scrub_setup_fscounters(struct xfs_scrub_context *sc,
+			       struct xfs_inode *ip);
 
 void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
 int xfs_scrub_ag_init(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
@@ -151,5 +153,7 @@ int xfs_scrub_ilock_inverted(struct xfs_inode *ip, uint lock_mode);
 void xfs_scrub_iput(struct xfs_scrub_context *sc, struct xfs_inode *ip);
 int xfs_scrub_fs_freeze(struct xfs_scrub_context *sc);
 int xfs_scrub_fs_thaw(struct xfs_scrub_context *sc);
+int xfs_scrub_foreach_live_inode(struct xfs_scrub_context *sc,
+		int (*execute)(struct xfs_inode *ip, void *priv), void *priv);
 
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
new file mode 100644
index 000000000000..32661e1951ba
--- /dev/null
+++ b/fs/xfs/scrub/fscounters.c
@@ -0,0 +1,276 @@
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
+#include "xfs_alloc.h"
+#include "xfs_ialloc.h"
+#include "xfs_rmap.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+
+/*
+ * FS Summary Counters
+ * ===================
+ *
+ * Filesystem summary counters are a tricky beast to check.  We cannot have
+ * anyone changing the superblock fields, the percpu counters, or the AG
+ * headers while we do the global check.  This means that we must freeze the
+ * filesystem for the entire duration.   Once that's done, we compute what the
+ * incore counters /should/ be based on the counters in the AG headers
+ * (presumably we checked those in an earlier part of scrub) and the in-core
+ * free space reservations (both the user-changeable one and the per-AG ones).
+ *
+ * From there we compare the computed incore counts to the actual ones and
+ * complain if they're off.  For repair we compute the deltas needed to
+ * correct the counters and then update the incore and ondisk counters
+ * accordingly.
+ */
+
+/* Summary counter checks require a frozen fs. */
+int
+xfs_scrub_setup_fscounters(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	int				error;
+
+	/* Save counters across runs. */
+	sc->buf = kmem_zalloc(sizeof(struct xfs_scrub_fscounters), KM_SLEEP);
+	if (!sc->buf)
+		return -ENOMEM;
+
+	/*
+	 * We need to prevent any other thread from changing the global fs
+	 * summary counters while we're scrubbing or repairing them.  This
+	 * requires the fs to be frozen.
+	 *
+	 * Scrub can do some basic sanity checks if userspace does not permit
+	 * us to freeze the filesystem.
+	 */
+	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
+	    !(sc->sm->sm_flags & XFS_SCRUB_IFLAG_FREEZE_OK))
+		return -EUSERS;
+
+	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_FREEZE_OK) {
+		error = xfs_scrub_fs_freeze(sc);
+		if (error)
+			return error;
+	}
+
+	/* Set up the scrub context. */
+	return xfs_scrub_trans_alloc(sc, 0);
+}
+
+/*
+ * Record the number of blocks reserved for this inode for future writes but
+ * not yet allocated to real space.  In other words, we're looking for all
+ * subtractions from fdblocks that aren't backed by actual space allocations
+ * while we recalculate fdlbocks.
+ */
+STATIC int
+xfs_scrub_fscounters_count_del(
+	struct xfs_inode	*ip,
+	void			*priv)
+{
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	rec;
+	struct xfs_ifork	*ifp;
+	uint64_t		*d = priv;
+	int64_t			delblks = ip->i_delayed_blks;
+
+	if (delblks == 0)
+		return 0;
+
+	/* Add the indlen blocks for each data fork reservation. */
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	for_each_xfs_iext(ifp, &icur, &rec) {
+		if (!isnullstartblock(rec.br_startblock))
+			continue;
+		delblks += startblockval(rec.br_startblock);
+	}
+
+	/*
+	 * Add the indlen blocks for each CoW fork reservation.  Remember
+	 * that we count real/unwritten extents in the CoW fork towards
+	 * i_delayed_blks, so we have to subtract those.
+	 */
+	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	if (ifp) {
+		for_each_xfs_iext(ifp, &icur, &rec) {
+			if (!isnullstartblock(rec.br_startblock)) {
+				/* real/unwritten extent */
+				delblks -= rec.br_blockcount;
+				continue;
+			}
+			delblks += startblockval(rec.br_startblock);
+		}
+	}
+
+	/* No, we can't have negative reservations. */
+	if (delblks < 0)
+		return -EFSCORRUPTED;
+
+	*d += delblks;
+	return 0;
+}
+
+/*
+ * Calculate what the global in-core counters ought to be from the AG header
+ * contents.  Callers can compare this to the actual in-core counters to
+ * calculate by how much both in-core and on-disk counters need to be
+ * adjusted.
+ */
+STATIC int
+xfs_scrub_fscounters_calc(
+	struct xfs_scrub_context	*sc,
+	struct xfs_scrub_fscounters	*fsc)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_buf			*agi_bp;
+	struct xfs_buf			*agf_bp;
+	struct xfs_agi			*agi;
+	struct xfs_agf			*agf;
+	struct xfs_perag		*pag;
+	uint64_t			delayed = 0;
+	xfs_agnumber_t			agno;
+	int				error;
+
+	ASSERT(sc->fs_frozen);
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		/* Count all the inodes */
+		error = xfs_ialloc_read_agi(mp, sc->tp, agno, &agi_bp);
+		if (error)
+			return error;
+		agi = XFS_BUF_TO_AGI(agi_bp);
+		fsc->icount += be32_to_cpu(agi->agi_count);
+		fsc->ifree += be32_to_cpu(agi->agi_freecount);
+
+		/* Add up the free/freelist/bnobt/cntbt blocks */
+		error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, &agf_bp);
+		if (error)
+			return error;
+		if (!agf_bp)
+			return -ENOMEM;
+		agf = XFS_BUF_TO_AGF(agf_bp);
+		fsc->fdblocks += be32_to_cpu(agf->agf_freeblks);
+		fsc->fdblocks += be32_to_cpu(agf->agf_flcount);
+		fsc->fdblocks += be32_to_cpu(agf->agf_btreeblks);
+
+		/*
+		 * Per-AG reservations are taken out of the incore counters,
+		 * so count them out.
+		 */
+		pag = xfs_perag_get(mp, agno);
+		fsc->fdblocks -= pag->pag_meta_resv.ar_reserved;
+		fsc->fdblocks -= pag->pag_rmapbt_resv.ar_orig_reserved;
+		xfs_perag_put(pag);
+	}
+
+	/*
+	 * The global space reservation is taken out of the incore counters,
+	 * so count that out too.
+	 */
+	fsc->fdblocks -= mp->m_resblks_avail;
+
+	/*
+	 * Delayed allocation reservations are taken out of the incore counters
+	 * but not recorded on disk, so count them out too.
+	 */
+	error = xfs_scrub_foreach_live_inode(sc, xfs_scrub_fscounters_count_del,
+			&delayed);
+	if (error)
+		return error;
+	fsc->fdblocks -= delayed;
+
+	trace_xfs_scrub_fscounters_calc(mp, fsc->icount, fsc->ifree,
+			fsc->fdblocks, delayed);
+
+	/* Bail out if the values we compute are totally nonsense. */
+	if (!xfs_verify_icount(mp, fsc->icount) ||
+	    fsc->fdblocks > mp->m_sb.sb_dblocks ||
+	    fsc->ifree > fsc->icount)
+		return -EFSCORRUPTED;
+
+	return 0;
+}
+
+/*
+ * Check the superblock counters.
+ *
+ * The filesystem must be frozen so that the counters do not change while
+ * we're computing the summary counters.
+ */
+int
+xfs_scrub_fscounters(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_scrub_fscounters	*fsc = sc->buf;
+	int				error;
+
+	/* See if icount is obviously wrong. */
+	if (!xfs_verify_icount(mp, mp->m_sb.sb_icount))
+		xfs_scrub_block_set_corrupt(sc, mp->m_sb_bp);
+
+	/* See if fdblocks / ifree are obviously wrong. */
+	if (mp->m_sb.sb_fdblocks > mp->m_sb.sb_dblocks)
+		xfs_scrub_block_set_corrupt(sc, mp->m_sb_bp);
+	if (mp->m_sb.sb_ifree > mp->m_sb.sb_icount)
+		xfs_scrub_block_set_corrupt(sc, mp->m_sb_bp);
+
+	/*
+	 * If we're only checking for corruption and we found it, exit now.
+	 *
+	 * Repair depends on the counter values we collect here, so if the
+	 * IFLAG_REPAIR flag is set we must continue to calculate the correct
+	 * counter values.
+	 */
+	if (!(sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
+	    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+		return 0;
+
+	/* Bail out if we need to be frozen to do the hard checks. */
+	if (!sc->fs_frozen) {
+		xfs_scrub_set_incomplete(sc);
+		return -EUSERS;
+	}
+
+	/* Counters seem ok, but let's count them. */
+	error = xfs_scrub_fscounters_calc(sc, fsc);
+	if (!xfs_scrub_process_error(sc, 0, XFS_SB_BLOCK(sc->mp), &error))
+		return error;
+
+	/*
+	 * Compare the in-core counters.  In theory we sync'd the superblock
+	 * when we did the repair freeze, so they should be the same as the
+	 * percpu counters.
+	 */
+	spin_lock(&mp->m_sb_lock);
+	if (mp->m_sb.sb_icount != fsc->icount)
+		xfs_scrub_block_set_corrupt(sc, mp->m_sb_bp);
+	if (mp->m_sb.sb_ifree != fsc->ifree)
+		xfs_scrub_block_set_corrupt(sc, mp->m_sb_bp);
+	if (mp->m_sb.sb_fdblocks != fsc->fdblocks)
+		xfs_scrub_block_set_corrupt(sc, mp->m_sb_bp);
+	spin_unlock(&mp->m_sb_lock);
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/fscounters_repair.c b/fs/xfs/scrub/fscounters_repair.c
new file mode 100644
index 000000000000..8893fb9d4813
--- /dev/null
+++ b/fs/xfs/scrub/fscounters_repair.c
@@ -0,0 +1,100 @@
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
+#include "xfs_alloc.h"
+#include "xfs_ialloc.h"
+#include "xfs_rmap.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+
+/*
+ * FS Summary Counters
+ * ===================
+ *
+ * To repair the filesystem summary counters we compute the correct values,
+ * take the difference between those values and the ones in m_sb, and modify
+ * both the percpu and the m_sb counters by the corresponding amounts.  The
+ * filesystem must be frozen to do anything.
+ */
+
+/*
+ * Reset the superblock counters.
+ *
+ * The filesystem must be frozen so that the counters do not change while
+ * we're computing the summary counters.
+ */
+int
+xfs_repair_fscounters(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_scrub_fscounters	*fsc = sc->buf;
+	int64_t				delta_icount;
+	int64_t				delta_ifree;
+	int64_t				delta_fdblocks;
+	int				error;
+
+	/*
+	 * Reinitialize the counters.  We know that the counters in mp->m_sb
+	 * are supposed to match the counters we calculated, so we therefore
+	 * need to calculate the deltas...
+	 */
+	spin_lock(&mp->m_sb_lock);
+	delta_icount = (int64_t)fsc->icount - mp->m_sb.sb_icount;
+	delta_ifree = (int64_t)fsc->ifree - mp->m_sb.sb_ifree;
+	delta_fdblocks = (int64_t)fsc->fdblocks - mp->m_sb.sb_fdblocks;
+	spin_unlock(&mp->m_sb_lock);
+
+	trace_xfs_repair_reset_counters(mp, delta_icount, delta_ifree,
+			delta_fdblocks);
+
+	/* ...and then update the per-cpu counters... */
+	if (delta_icount) {
+		error = xfs_mod_icount(mp, delta_icount);
+		if (error)
+			return error;
+	}
+	if (delta_ifree) {
+		error = xfs_mod_ifree(mp, delta_ifree);
+		if (error)
+			goto err_icount;
+	}
+	if (delta_fdblocks) {
+		error = xfs_mod_fdblocks(mp, delta_fdblocks, false);
+		if (error)
+			goto err_ifree;
+	}
+
+	/* ...and finally log the superblock changes. */
+	spin_lock(&mp->m_sb_lock);
+	mp->m_sb.sb_icount = fsc->icount;
+	mp->m_sb.sb_ifree = fsc->ifree;
+	mp->m_sb.sb_fdblocks = fsc->fdblocks;
+	spin_unlock(&mp->m_sb_lock);
+	xfs_log_sb(sc->tp);
+
+	return 0;
+err_icount:
+	xfs_mod_icount(mp, -delta_icount);
+err_ifree:
+	xfs_mod_ifree(mp, -delta_ifree);
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 083ab63624eb..7e3fee59b517 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -121,6 +121,7 @@ int xfs_repair_quota(struct xfs_scrub_context *sc);
 #else
 # define xfs_repair_quota		xfs_repair_notsupported
 #endif /* CONFIG_XFS_QUOTA */
+int xfs_repair_fscounters(struct xfs_scrub_context *sc);
 
 #else
 
@@ -165,6 +166,7 @@ static inline int xfs_repair_rmapbt_setup(
 #define xfs_repair_symlink		xfs_repair_notsupported
 #define xfs_repair_xattr		xfs_repair_notsupported
 #define xfs_repair_quota		xfs_repair_notsupported
+#define xfs_repair_fscounters		xfs_repair_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index f57ec412a617..42b23d831c9e 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -369,6 +369,12 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.scrub	= xfs_scrub_quota,
 		.repair	= xfs_repair_quota,
 	},
+	[XFS_SCRUB_TYPE_FSCOUNTERS] = {	/* fs summary counters */
+		.type	= ST_FS,
+		.setup	= xfs_scrub_setup_fscounters,
+		.scrub	= xfs_scrub_fscounters,
+		.repair	= xfs_repair_fscounters,
+	},
 };
 
 /* This isn't a stable feature, warn once per day. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 43c4189ea549..1a1b0cad64a8 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -128,6 +128,7 @@ xfs_scrub_quota(struct xfs_scrub_context *sc)
 	return -ENOENT;
 }
 #endif
+int xfs_scrub_fscounters(struct xfs_scrub_context *sc);
 
 /* cross-referencing helpers */
 void xfs_scrub_xref_is_used_space(struct xfs_scrub_context *sc,
@@ -159,4 +160,10 @@ bool xfs_scrub_xattr_set_map(struct xfs_scrub_context *sc, unsigned long *map,
 		unsigned int start, unsigned int len);
 uint xfs_scrub_quota_to_dqtype(struct xfs_scrub_context *sc);
 
+struct xfs_scrub_fscounters {
+	uint64_t		icount;
+	uint64_t		ifree;
+	uint64_t		fdblocks;
+};
+
 #endif	/* __XFS_SCRUB_SCRUB_H__ */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 0212d273ca8b..a1608a27cb29 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -514,6 +514,50 @@ DEFINE_SCRUB_IREF_EVENT(xfs_scrub_iget);
 DEFINE_SCRUB_IREF_EVENT(xfs_scrub_iget_target);
 DEFINE_SCRUB_IREF_EVENT(xfs_scrub_iput_target);
 
+TRACE_EVENT(xfs_scrub_fscounters_calc,
+	TP_PROTO(struct xfs_mount *mp, uint64_t icount, uint64_t ifree,
+		 uint64_t fdblocks, uint64_t delalloc),
+	TP_ARGS(mp, icount, ifree, fdblocks, delalloc),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int64_t, icount_sb)
+		__field(int64_t, icount_percpu)
+		__field(uint64_t, icount_calculated)
+		__field(int64_t, ifree_sb)
+		__field(int64_t, ifree_percpu)
+		__field(uint64_t, ifree_calculated)
+		__field(int64_t, fdblocks_sb)
+		__field(int64_t, fdblocks_percpu)
+		__field(uint64_t, fdblocks_calculated)
+		__field(uint64_t, delalloc)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->icount_sb = mp->m_sb.sb_icount;
+		__entry->icount_percpu = percpu_counter_sum(&mp->m_icount);
+		__entry->icount_calculated = icount;
+		__entry->ifree_sb = mp->m_sb.sb_ifree;
+		__entry->ifree_percpu = percpu_counter_sum(&mp->m_ifree);
+		__entry->ifree_calculated = ifree;
+		__entry->fdblocks_sb = mp->m_sb.sb_fdblocks;
+		__entry->fdblocks_percpu = percpu_counter_sum(&mp->m_fdblocks);
+		__entry->fdblocks_calculated = fdblocks;
+		__entry->delalloc = delalloc;
+	),
+	TP_printk("dev %d:%d icount %lld:%lld:%llu ifree %lld:%lld:%llu fdblocks %lld:%lld:%llu delalloc %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->icount_sb,
+		  __entry->icount_percpu,
+		  __entry->icount_calculated,
+		  __entry->ifree_sb,
+		  __entry->ifree_percpu,
+		  __entry->ifree_calculated,
+		  __entry->fdblocks_sb,
+		  __entry->fdblocks_percpu,
+		  __entry->fdblocks_calculated,
+		  __entry->delalloc)
+)
+
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 
@@ -722,17 +766,28 @@ TRACE_EVENT(xfs_repair_calc_ag_resblks_btsize,
 		  __entry->rmapbt_sz,
 		  __entry->refcbt_sz)
 )
+
 TRACE_EVENT(xfs_repair_reset_counters,
-	TP_PROTO(struct xfs_mount *mp),
-	TP_ARGS(mp),
+	TP_PROTO(struct xfs_mount *mp, int64_t icount_adj, int64_t ifree_adj,
+		 int64_t fdblocks_adj),
+	TP_ARGS(mp, icount_adj, ifree_adj, fdblocks_adj),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(int64_t, icount_adj)
+		__field(int64_t, ifree_adj)
+		__field(int64_t, fdblocks_adj)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
+		__entry->icount_adj = icount_adj;
+		__entry->ifree_adj = ifree_adj;
+		__entry->fdblocks_adj = fdblocks_adj;
 	),
-	TP_printk("dev %d:%d",
-		  MAJOR(__entry->dev), MINOR(__entry->dev))
+	TP_printk("dev %d:%d icount %lld ifree %lld fdblocks %lld",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->icount_adj,
+		  __entry->ifree_adj,
+		  __entry->fdblocks_adj)
 )
 
 TRACE_EVENT(xfs_repair_ialloc_insert,

