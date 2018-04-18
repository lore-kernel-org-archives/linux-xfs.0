Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45666 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCoY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:44:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2fQQ5045595
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:24 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2hdrxp0k62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:23 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2iMiY021203
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:22 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2iM9m026805
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:22 GMT
Subject: [PATCH 24/24] xfs: implement live quotacheck as part of quota repair
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:44:20 -0700
Message-ID: <152401946093.12079.13973237734321905988.stgit@magnolia>
In-Reply-To: <152401930978.12079.2000682561964128780.stgit@magnolia>
References: <152401930978.12079.2000682561964128780.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the fs freezing mechanism we developed for the rmapbt repair to
freeze the fs, this time to scan the fs for a live quotacheck.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/quota.c        |   20 ++
 fs/xfs/scrub/quota_repair.c |  378 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dquot.c          |   18 +-
 fs/xfs/xfs_dquot.h          |    2 
 4 files changed, 407 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index e1ee44c..ceabdc6 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -41,6 +41,7 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
+#include "scrub/repair.h"
 
 /* Convert a scrub type code to a DQ flag, or return 0 if error. */
 uint
@@ -78,12 +79,29 @@ xfs_scrub_setup_quota(
 	mutex_lock(&sc->mp->m_quotainfo->qi_quotaofflock);
 	if (!xfs_this_quota_on(sc->mp, dqtype))
 		return -ENOENT;
+	/*
+	 * Freeze out anything that can alter an inode because we reconstruct
+	 * the quota counts by iterating all the inodes in the system.
+	 */
+	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
+	    (sc->try_harder || XFS_QM_NEED_QUOTACHECK(sc->mp))) {
+		error = xfs_repair_fs_freeze(sc);
+		if (error)
+			return error;
+	}
 	error = xfs_scrub_setup_fs(sc, ip);
 	if (error)
 		return error;
 	sc->ip = xfs_quota_inode(sc->mp, dqtype);
-	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
 	sc->ilock_flags = XFS_ILOCK_EXCL;
+	/*
+	 * Pretend to be an ILOCK parent to shut up lockdep if we're going to
+	 * do a full inode scan of the fs.  Quota inodes do not count towards
+	 * quota accounting, so we shouldn't deadlock on ourselves.
+	 */
+	if (sc->fs_frozen)
+		sc->ilock_flags |= XFS_ILOCK_PARENT;
+	xfs_ilock(sc->ip, sc->ilock_flags);
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 15ec707..0f75768 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -30,13 +30,21 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_inode.h"
+#include "xfs_icache.h"
 #include "xfs_inode_fork.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
+#include "xfs_ialloc.h"
+#include "xfs_ialloc_btree.h"
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_dquot.h"
 #include "xfs_dquot_item.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_error.h"
+#include "xfs_errortag.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -350,6 +358,360 @@ xfs_repair_quota_data_fork(
 	return error;
 }
 
+/* Make sure there's a dquot buffer backing this ID. */
+STATIC int
+xfs_repair_quotacheck_ensure_dquot(
+	struct xfs_scrub_context	*sc,
+	uint				dqtype,
+	xfs_dqid_t			id)
+{
+	struct xfs_bmbt_irec		map;
+	struct xfs_defer_ops		dfops;
+	struct xfs_buf			*bp;
+	xfs_fileoff_t			offset_fsb;
+	xfs_fsblock_t			firstblock;
+	int				nmaps;
+	int				error;
+
+	ASSERT(sc->tp == NULL);
+
+	/* Do we already have a block mapped? */
+	nmaps = 1;
+	offset_fsb = (xfs_fileoff_t)id / sc->mp->m_quotainfo->qi_dqperchunk;
+	error = xfs_bmapi_read(sc->ip, offset_fsb, XFS_DQUOT_CLUSTER_SIZE_FSB,
+			&map, &nmaps, 0);
+	if (error)
+		return error;
+	if (nmaps == 1 && map.br_blockcount >= XFS_DQUOT_CLUSTER_SIZE_FSB) {
+		if (map.br_startblock == DELAYSTARTBLOCK)
+			return -EFSCORRUPTED;
+		if (map.br_startblock != HOLESTARTBLOCK)
+			return 0;
+	}
+
+	/* We have a hole, so map something in. */
+	xfs_iunlock(sc->ip, sc->ilock_flags);
+	sc->ilock_flags = 0;
+	error = xfs_trans_alloc(sc->mp, &M_RES(sc->mp)->tr_qm_dqalloc,
+			XFS_QM_DQALLOC_SPACE_RES(sc->mp), 0,
+			XFS_TRANS_NO_WRITECOUNT | XFS_TRANS_RESERVE, &sc->tp);
+	if (error)
+		return error;
+
+	xfs_defer_init(&dfops, &firstblock);
+	sc->ilock_flags = XFS_ILOCK_EXCL | XFS_ILOCK_PARENT;
+	xfs_ilock(sc->ip, sc->ilock_flags);
+
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+	nmaps = 1;
+	error = xfs_bmapi_write(sc->tp, sc->ip, offset_fsb,
+			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA,
+			&firstblock, XFS_QM_DQALLOC_SPACE_RES(sc->mp),
+			&map, &nmaps, &dfops);
+	if (error)
+		goto out_defer;
+	ASSERT(nmaps == 1);
+	ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
+	       (map.br_startblock != HOLESTARTBLOCK));
+
+	/* Initialize the dquot buffer. */
+	bp = xfs_trans_get_buf(sc->tp, sc->mp->m_ddev_targp,
+			XFS_FSB_TO_DADDR(sc->mp, map.br_startblock),
+			sc->mp->m_quotainfo->qi_dqchunklen, 0);
+	if (!bp) {
+		error = -ENOMEM;
+		goto out_defer;
+	}
+	xfs_qm_init_dquot_blk(sc->tp, sc->mp, id, dqtype, bp);
+
+	/* Commit everything. */
+	error = xfs_defer_finish(&sc->tp, &dfops);
+	if (error)
+		goto out_defer;
+	error = xfs_trans_commit(sc->tp);
+	sc->tp = NULL;
+	return error;
+
+out_defer:
+	xfs_defer_cancel(&dfops);
+	return error;
+}
+
+/*
+ * Called by dqusage_adjust in doing a quotacheck.
+ *
+ * Given the inode, and a dquot id this updates both the incore dqout as well
+ * as the buffer copy. This is so that once the quotacheck is done, we can
+ * just log all the buffers, as opposed to logging numerous updates to
+ * individual dquots.
+ */
+STATIC int
+xfs_repair_quotacheck_dqadjust(
+	struct xfs_inode	*ip,
+	xfs_dqid_t		id,
+	uint			type,
+	xfs_qcnt_t		nblks,
+	xfs_qcnt_t		rtblks)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_dquot	*dqp;
+	int			error;
+
+	error = xfs_qm_dqget(mp, ip, id, type, XFS_QMOPT_QUOTIP_LOCKED, &dqp);
+	if (error) {
+		/*
+		 * Shouldn't be able to turn off quotas here.
+		 */
+		ASSERT(error != -ESRCH);
+		ASSERT(error != -ENOENT);
+		return error;
+	}
+
+	/*
+	 * Adjust the inode count and the block count to reflect this inode's
+	 * resource usage.
+	 */
+	be64_add_cpu(&dqp->q_core.d_icount, 1);
+	dqp->q_res_icount++;
+	if (nblks) {
+		be64_add_cpu(&dqp->q_core.d_bcount, nblks);
+		dqp->q_res_bcount += nblks;
+	}
+	if (rtblks) {
+		be64_add_cpu(&dqp->q_core.d_rtbcount, rtblks);
+		dqp->q_res_rtbcount += rtblks;
+	}
+
+	/*
+	 * Set default limits, adjust timers (since we changed usages)
+	 *
+	 * There are no timers for the default values set in the root dquot.
+	 */
+	if (dqp->q_core.d_id) {
+		xfs_qm_adjust_dqlimits(mp, dqp);
+		xfs_qm_adjust_dqtimers(mp, &dqp->q_core);
+	}
+
+	dqp->dq_flags |= XFS_DQ_DIRTY;
+	xfs_qm_dqput(dqp);
+	return 0;
+}
+
+/* Record this inode's quota use. */
+STATIC int
+xfs_repair_quotacheck_inode(
+	struct xfs_scrub_context	*sc,
+	uint				dqtype,
+	struct xfs_inode		*ip)
+{
+	struct xfs_ifork		*ifp;
+	xfs_filblks_t			rtblks = 0;	/* total rt blks */
+	xfs_qcnt_t			nblks;
+	xfs_dqid_t			id = 0;
+	int				error;
+
+	/* Count the realtime blocks. */
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+
+		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+			error = xfs_iread_extents(sc->tp, ip, XFS_DATA_FORK);
+			if (error)
+				return error;
+		}
+
+		xfs_bmap_count_leaves(ifp, &rtblks);
+	}
+
+	nblks = (xfs_qcnt_t)ip->i_d.di_nblocks - rtblks;
+
+	switch (dqtype) {
+	case XFS_DQ_USER:
+		id = ip->i_d.di_uid;
+		break;
+	case XFS_DQ_GROUP:
+		id = ip->i_d.di_gid;
+		break;
+	case XFS_DQ_PROJ:
+		id = xfs_get_projid(ip);
+		break;
+	}
+
+	/*
+	 * Make sure there's a dquot waiting for us.  This should be safe
+	 * because we're frozen so the inode cannot be chown'd on us.
+	 */
+	error = xfs_repair_quotacheck_ensure_dquot(sc, dqtype, id);
+	if (error)
+		return error;
+
+	/* Adjust the dquot. */
+	return xfs_repair_quotacheck_dqadjust(ip, id, dqtype, nblks, rtblks);
+}
+
+struct xfs_repair_quotacheck {
+	struct xfs_scrub_context	*sc;
+	uint				dqtype;
+};
+
+/* Iterate all the inodes in an AG group. */
+STATIC int
+xfs_repair_quotacheck_inobt(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_rec		*rec,
+	void				*priv)
+{
+	struct xfs_inobt_rec_incore	irec;
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_inode		*ip = NULL;
+	struct xfs_repair_quotacheck	*rq = priv;
+	xfs_ino_t			ino;
+	xfs_agino_t			agino;
+	int				chunkidx;
+	int				error = 0;
+
+	xfs_inobt_btrec_to_irec(mp, rec, &irec);
+
+	for (chunkidx = 0, agino = irec.ir_startino;
+	     chunkidx < XFS_INODES_PER_CHUNK;
+	     chunkidx++, agino++) {
+		bool	inuse;
+
+		/* Skip if this inode is free */
+		if (XFS_INOBT_MASK(chunkidx) & irec.ir_free)
+			continue;
+		ino = XFS_AGINO_TO_INO(mp, cur->bc_private.a.agno, agino);
+		if (xfs_is_quota_inode(&mp->m_sb, ino))
+			continue;
+
+		/* Back off and try again if an inode is being reclaimed */
+		error = xfs_icache_inode_is_allocated(mp, NULL, ino, &inuse);
+		if (error == -EAGAIN)
+			return -EDEADLOCK;
+
+		/*
+		 * Grab inode for scanning.  We cannot use DONTCACHE here
+		 * because we already have a transaction so the iput must not
+		 * trigger inode reclaim (which might allocate a transaction
+		 * to clean up posteof blocks).
+		 */
+		error = xfs_iget(mp, NULL, ino, 0, XFS_ILOCK_EXCL, &ip);
+		if (error)
+			return error;
+
+		error = xfs_repair_quotacheck_inode(rq->sc, rq->dqtype, ip);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		xfs_repair_frozen_iput(rq->sc, ip);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/* Zero a dquot prior to regenerating the counts. */
+static int
+xfs_repair_quotacheck_zero_dquot(
+	struct xfs_dquot		*dq,
+	uint				dqtype,
+	xfs_dqid_t			id,
+	void				*priv)
+{
+	dq->q_res_bcount -= be64_to_cpu(dq->q_core.d_bcount);
+	dq->q_core.d_bcount = 0;
+	dq->q_res_icount -= be64_to_cpu(dq->q_core.d_icount);
+	dq->q_core.d_icount = 0;
+	dq->q_res_rtbcount -= be64_to_cpu(dq->q_core.d_rtbcount);
+	dq->q_core.d_rtbcount = 0;
+	dq->dq_flags |= XFS_DQ_DIRTY;
+	return 0;
+}
+
+/* Log a dirty dquot after we regenerated the counters. */
+static int
+xfs_repair_quotacheck_log_dquot(
+	struct xfs_dquot		*dq,
+	uint				dqtype,
+	xfs_dqid_t			id,
+	void				*priv)
+{
+	struct xfs_scrub_context	*sc = priv;
+	int				error;
+
+	xfs_trans_dqjoin(sc->tp, dq);
+	xfs_trans_log_dquot(sc->tp, dq);
+	error = xfs_trans_roll(&sc->tp);
+	xfs_dqlock(dq);
+	return error;
+}
+
+/* Execute an online quotacheck. */
+STATIC int
+xfs_repair_quotacheck(
+	struct xfs_scrub_context	*sc,
+	uint				dqtype)
+{
+	struct xfs_repair_quotacheck	rq;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_buf			*bp;
+	struct xfs_btree_cur		*cur;
+	xfs_agnumber_t			ag;
+	uint				flag;
+	int				error;
+
+	/*
+	 * Commit the transaction so that we can allocate new quota ip
+	 * mappings if we have to.
+	 */
+	error = xfs_trans_commit(sc->tp);
+	sc->tp = NULL;
+	if (error)
+		return error;
+
+	/* Zero all the quota items. */
+	error = xfs_dquot_iterate(mp, dqtype, XFS_QMOPT_QUOTIP_LOCKED,
+			xfs_repair_quotacheck_zero_dquot, sc);
+	if (error)
+		goto out;
+
+	rq.sc = sc;
+	rq.dqtype = dqtype;
+
+	/* Iterate all AGs for inodes. */
+	for (ag = 0; ag < mp->m_sb.sb_agcount; ag++) {
+		error = xfs_ialloc_read_agi(mp, NULL, ag, &bp);
+		if (error)
+			goto out;
+		cur = xfs_inobt_init_cursor(mp, NULL, bp, ag, XFS_BTNUM_INO);
+		error = xfs_btree_query_all(cur, xfs_repair_quotacheck_inobt,
+				&rq);
+		xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR :
+						  XFS_BTREE_NOERROR);
+		xfs_buf_relse(bp);
+		if (error)
+			goto out;
+	}
+
+	/* Log dquots. */
+	error = xfs_scrub_trans_alloc(sc, 0);
+	if (error)
+		goto out;
+	error = xfs_dquot_iterate(mp, dqtype, XFS_QMOPT_QUOTIP_LOCKED,
+			xfs_repair_quotacheck_log_dquot, sc);
+	if (error)
+		goto out;
+
+	/* Set quotachecked flag. */
+	flag = xfs_quota_chkd_flag(dqtype);
+	sc->mp->m_qflags |= flag;
+	spin_lock(&sc->mp->m_sb_lock);
+	sc->mp->m_sb.sb_qflags |= flag;
+	spin_unlock(&sc->mp->m_sb_lock);
+	xfs_log_sb(sc->tp);
+out:
+	return error;
+}
+
 /* Repair all of a quota type's items. */
 int
 xfs_repair_quota(
@@ -358,6 +720,7 @@ xfs_repair_quota(
 	struct xfs_repair_quota_info	rqi;
 	struct xfs_mount		*mp = sc->mp;
 	uint				dqtype;
+	uint				flag;
 	int				error = 0;
 
 	dqtype = xfs_scrub_quota_to_dqtype(sc);
@@ -375,9 +738,22 @@ xfs_repair_quota(
 		goto out;
 
 	/* Make a quotacheck happen. */
-	if (rqi.need_quotacheck)
+	if (rqi.need_quotacheck ||
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
 		xfs_repair_force_quotacheck(sc, dqtype);
 
+	/* Do we need a quotacheck?  Did we need one? */
+	flag = xfs_quota_chkd_flag(dqtype);
+	if (!(flag & sc->mp->m_qflags)) {
+		/* We need to freeze the fs before we can scan inodes. */
+		if (!sc->fs_frozen) {
+			error = -EDEADLOCK;
+			goto out;
+		}
+
+		error = xfs_repair_quotacheck(sc, dqtype);
+	}
+
 out:
 	return error;
 }
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index ec00402..8767965 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -219,18 +219,18 @@ xfs_qm_adjust_dqtimers(
 /*
  * initialize a buffer full of dquots and log the whole thing
  */
-STATIC void
+void
 xfs_qm_init_dquot_blk(
-	xfs_trans_t	*tp,
-	xfs_mount_t	*mp,
-	xfs_dqid_t	id,
-	uint		type,
-	xfs_buf_t	*bp)
+	struct xfs_trans	*tp,
+	struct xfs_mount	*mp,
+	xfs_dqid_t		id,
+	uint			type,
+	struct xfs_buf		*bp)
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	xfs_dqblk_t	*d;
-	xfs_dqid_t	curid;
-	int		i;
+	xfs_dqblk_t		*d;
+	xfs_dqid_t		curid;
+	int			i;
 
 	ASSERT(tp);
 	ASSERT(xfs_buf_islocked(bp));
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index db0511e..8115972 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -189,5 +189,7 @@ typedef int (*xfs_dquot_iterate_fn)(struct xfs_dquot *dq, uint dqtype,
 		xfs_dqid_t id, void *priv);
 int xfs_dquot_iterate(struct xfs_mount *mp, uint dqtype, uint iter_flags,
 		xfs_dquot_iterate_fn iter_fn, void *priv);
+void xfs_qm_init_dquot_blk(struct xfs_trans *tp, struct xfs_mount *mp,
+		xfs_dqid_t id, uint type, struct xfs_buf *bp);
 
 #endif /* __XFS_DQUOT_H__ */

