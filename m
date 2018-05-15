Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36298 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751402AbeEOWgE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 18:36:04 -0400
Subject: [PATCH 22/22] xfs: implement live quotacheck as part of quota repair
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 15 May 2018 15:36:01 -0700
Message-ID: <152642376103.1556.5472150335241911371.stgit@magnolia>
In-Reply-To: <152642361893.1556.9335169821674946249.stgit@magnolia>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the fs freezing mechanism we developed for the rmapbt repair to
freeze the fs, this time to scan the fs for a live quotacheck.  We add a
new dqget variant to use the existing scrub transaction to allocate an
on-disk dquot block if it is missing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/quota.c        |   20 +++
 fs/xfs/scrub/quota_repair.c |  286 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dquot.c          |   59 ++++++++-
 fs/xfs/xfs_dquot.h          |    3 
 4 files changed, 360 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 64776257fd88..596c660ca155 100644
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
index 68b7082af30a..5865025fe04d 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -30,13 +30,20 @@
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
+#include "xfs_trans_space.h"
+#include "xfs_error.h"
+#include "xfs_errortag.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -314,6 +321,269 @@ xfs_repair_quota_data_fork(
 	return error;
 }
 
+/*
+ * Add this inode's resource usage to the dquot.  We adjust the in-core and
+ * the (cached) on-disk copies of the counters and leave the dquot dirty.  A
+ * subsequent pass through the dquots logs them all to disk.  Fortunately we
+ * froze the filesystem before starting so at least we don't have to deal
+ * with chown/chproj races.
+ */
+STATIC int
+xfs_repair_quotacheck_dqadjust(
+	struct xfs_scrub_context	*sc,
+	uint				type,
+	xfs_qcnt_t			nblks,
+	xfs_qcnt_t			rtblks)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_inode		*ip = sc->ip;
+	struct xfs_dquot		*dqp;
+	xfs_dqid_t			id;
+	int				error;
+
+	/* Try to read in the dquot. */
+	id = xfs_qm_id_for_quotatype(ip, type);
+	error = xfs_qm_dqget(mp, id, type, false, &dqp);
+	if (error == -ENOENT) {
+		/* Allocate a dquot using our special transaction. */
+		error = xfs_qm_dqget_alloc(&sc->tp, id, type, &dqp);
+		if (error)
+			return error;
+		error = xfs_trans_roll_inode(&sc->tp, sc->ip);
+	}
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
+	/* Adjust the dquot. */
+	return xfs_repair_quotacheck_dqadjust(sc, dqtype, nblks, rtblks);
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
+	 * mappings if we have to.  If we crash after this point, the sb
+	 * still has the CHKD flags cleared, so mount quotacheck will fix
+	 * all of this up.
+	 */
+	error = xfs_trans_commit(sc->tp);
+	sc->tp = NULL;
+	if (error)
+		return error;
+
+	/* Zero all the quota items. */
+	error = xfs_qm_dqiterate(mp, dqtype, xfs_repair_quotacheck_zero_dquot,
+			sc);
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
+	error = xfs_qm_dqiterate(mp, dqtype, xfs_repair_quotacheck_log_dquot,
+			sc);
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
@@ -322,6 +592,7 @@ xfs_repair_quota(
 	struct xfs_repair_quota_info	rqi;
 	struct xfs_mount		*mp = sc->mp;
 	uint				dqtype;
+	uint				flag;
 	int				error = 0;
 
 	dqtype = xfs_scrub_quota_to_dqtype(sc);
@@ -344,9 +615,22 @@ xfs_repair_quota(
 		goto out_relock;
 
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
+			goto out_relock;
+		}
+
+		error = xfs_repair_quotacheck(sc, dqtype);
+	}
+
 out_relock:
 	sc->ilock_flags = XFS_ILOCK_EXCL;
 	xfs_ilock(sc->ip, sc->ilock_flags);
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 2567391489bd..be0e07f42b17 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -546,6 +546,7 @@ xfs_dquot_from_disk(
 static int
 xfs_qm_dqread_alloc(
 	struct xfs_mount	*mp,
+	struct xfs_trans	**tpp,
 	struct xfs_dquot	*dqp,
 	struct xfs_buf		**bpp)
 {
@@ -553,6 +554,18 @@ xfs_qm_dqread_alloc(
 	struct xfs_buf		*bp;
 	int			error;
 
+	/*
+	 * The caller passed in a transaction which we don't control, so
+	 * release the hold before passing back the buffer.
+	 */
+	if (tpp) {
+		error = xfs_dquot_disk_alloc(tpp, dqp, &bp);
+		if (error)
+			return error;
+		xfs_trans_bhold_release(*tpp, bp);
+		return 0;
+	}
+
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_dqalloc,
 			XFS_QM_DQALLOC_SPACE_RES(mp), 0, 0, &tp);
 	if (error)
@@ -588,6 +601,7 @@ xfs_qm_dqread_alloc(
 static int
 xfs_qm_dqread(
 	struct xfs_mount	*mp,
+	struct xfs_trans	**tpp,
 	xfs_dqid_t		id,
 	uint			type,
 	bool			can_alloc,
@@ -603,7 +617,7 @@ xfs_qm_dqread(
 	/* Try to read the buffer, allocating if necessary. */
 	error = xfs_dquot_disk_read(mp, dqp, &bp);
 	if (error == -ENOENT && can_alloc)
-		error = xfs_qm_dqread_alloc(mp, dqp, &bp);
+		error = xfs_qm_dqread_alloc(mp, tpp, dqp, &bp);
 	if (error)
 		goto err;
 
@@ -787,9 +801,10 @@ xfs_qm_dqget_checks(
  * Given the file system, id, and type (UDQUOT/GDQUOT), return a a locked
  * dquot, doing an allocation (if requested) as needed.
  */
-int
-xfs_qm_dqget(
+static int
+__xfs_qm_dqget(
 	struct xfs_mount	*mp,
+	struct xfs_trans	**tpp,
 	xfs_dqid_t		id,
 	uint			type,
 	bool			can_alloc,
@@ -811,7 +826,7 @@ xfs_qm_dqget(
 		return 0;
 	}
 
-	error = xfs_qm_dqread(mp, id, type, can_alloc, &dqp);
+	error = xfs_qm_dqread(mp, NULL, id, type, can_alloc, &dqp);
 	if (error)
 		return error;
 
@@ -850,7 +865,39 @@ xfs_qm_dqget_uncached(
 	if (error)
 		return error;
 
-	return xfs_qm_dqread(mp, id, type, 0, dqpp);
+	return xfs_qm_dqread(mp, NULL, id, type, 0, dqpp);
+}
+
+/*
+ * Given the file system, id, and type (UDQUOT/GDQUOT), return a a locked
+ * dquot, doing an allocation (if requested) as needed.
+ */
+int
+xfs_qm_dqget(
+	struct xfs_mount	*mp,
+	xfs_dqid_t		id,
+	uint			type,
+	bool			can_alloc,
+	struct xfs_dquot	**O_dqpp)
+{
+	return __xfs_qm_dqget(mp, NULL, id, type, can_alloc, O_dqpp);
+}
+
+/*
+ * Given the file system, id, and type (UDQUOT/GDQUOT) and a hole in the quota
+ * data where the on-disk dquot is supposed to live, return a locked dquot
+ * having allocated blocks with the transaction.  This is a corner case
+ * required by online repair, which already has a transaction and has to pass
+ * that into dquot_setup.
+ */
+int
+xfs_qm_dqget_alloc(
+	struct xfs_trans	**tpp,
+	xfs_dqid_t		id,
+	uint			type,
+	struct xfs_dquot	**dqpp)
+{
+	return __xfs_qm_dqget((*tpp)->t_mountp, tpp, id, type, true, dqpp);
 }
 
 /* Return the quota id for a given inode and type. */
@@ -914,7 +961,7 @@ xfs_qm_dqget_inode(
 	 * we re-acquire the lock.
 	 */
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	error = xfs_qm_dqread(mp, id, type, can_alloc, &dqp);
+	error = xfs_qm_dqread(mp, NULL, id, type, can_alloc, &dqp);
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index bdd6bd921528..27e6df439493 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -180,6 +180,9 @@ extern int		xfs_qm_dqget_next(struct xfs_mount *mp, xfs_dqid_t id,
 extern int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
 					xfs_dqid_t id, uint type,
 					struct xfs_dquot **dqpp);
+extern int		xfs_qm_dqget_alloc(struct xfs_trans **tpp,
+					xfs_dqid_t id, uint type,
+					struct xfs_dquot **dqpp);
 extern void		xfs_qm_dqput(xfs_dquot_t *);
 
 extern void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);

