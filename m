Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A10BE29DF8
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 03:41:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3DF18AC001
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 01:41:11 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	t7UXl7OgUHfyGShj for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 01:41:09 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vr2lR-00015s-97
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 20:41:01 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vr2lR-0005tJ-8O
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 20:41:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfs: xfs_trans_dqresv() can be made lockless
Date: Thu, 12 Dec 2013 20:40:58 +1100
Message-Id: <1386841258-22183-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1386841258-22183-1-git-send-email-david@fromorbit.com>
References: <1386841258-22183-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

xfs_trans_dqresv() serialises dquot modifications by taking the
dquot lock while it is doing reservations. The thing is, nothing it
does really requires exclusive access to the dquot except for the
reservation accounting. We can do that locklessly with cmpxchg.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_dquot.c | 372 +++++++++++++++++++++++++++--------------------
 1 file changed, 213 insertions(+), 159 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 4117286..fa89d21 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -33,6 +33,97 @@
 
 STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
 
+STATIC void
+xfs_quota_warn(
+	struct xfs_mount	*mp,
+	struct xfs_dquot	*dqp,
+	int			type)
+{
+	/* no warnings for project quotas - we just return ENOSPC later */
+	if (dqp->dq_flags & XFS_DQ_PROJ)
+		return;
+	quota_send_warning(make_kqid(&init_user_ns,
+				     (dqp->dq_flags & XFS_DQ_USER) ?
+				     USRQUOTA : GRPQUOTA,
+				     be32_to_cpu(dqp->q_core.d_id)),
+			   mp->m_super->s_dev, type);
+}
+
+/*
+ * See if we'd go over the hardlimit or exceed the timelimit if we allocate
+ * nblks.
+ */
+static bool
+xfs_dqlimits_exceeded(
+	struct xfs_mount	*mp,
+	struct xfs_dquot	*dqp,
+	bool			blklimit,
+	xfs_qcnt_t		total_count,
+	xfs_qcnt_t		hardlimit,
+	xfs_qcnt_t		softlimit,
+	time_t			timer,
+	xfs_qwarncnt_t		warns,
+	xfs_qwarncnt_t		warnlimit)
+{
+	if (hardlimit && total_count > hardlimit) {
+		xfs_quota_warn(mp, dqp, blklimit ? QUOTA_NL_BHARDWARN
+						 : QUOTA_NL_IHARDWARN);
+		return true;
+	}
+
+	if (softlimit && total_count > softlimit) {
+		if ((timer && get_seconds() > timer) ||
+		    (warns && warns >= warnlimit)) {
+			xfs_quota_warn(mp, dqp, blklimit
+						 ? QUOTA_NL_BSOFTLONGWARN
+						 : QUOTA_NL_ISOFTLONGWARN);
+			return true;
+		}
+		xfs_quota_warn(mp, dqp, blklimit ? QUOTA_NL_BSOFTWARN
+						 : QUOTA_NL_ISOFTWARN);
+	}
+	return false;
+}
+
+/*
+ * Make the required reservation, first checking the limits provided (if
+ * required) to see if we'd exceed the quota limits.
+ */
+static xfs_qcnt_t
+xfs_dqresv_cmpxchg(
+	struct xfs_mount	*mp,
+	struct xfs_dquot	*dqp,
+	xfs_qcnt_t		*cntp,
+	xfs_qcnt_t		diff,
+	bool			blklimit,
+	bool			enforce,
+	xfs_qcnt_t		hardlimit,
+	xfs_qcnt_t		softlimit,
+	time_t			timer,
+	xfs_qwarncnt_t		warns,
+	xfs_qwarncnt_t		warnlimit)
+{
+	xfs_qcnt_t	count;
+	xfs_qcnt_t	old;
+
+	do {
+		xfs_qcnt_t	total_count;
+
+		count = ACCESS_ONCE(*cntp);
+		total_count = count + diff;
+		if (enforce &&
+		    xfs_dqlimits_exceeded(mp, dqp, blklimit, total_count,
+					  hardlimit, softlimit, timer, warns,
+					  warnlimit))
+			return -1ULL;
+
+		old = count;
+		count = cmpxchg64(cntp, old, total_count);
+	} while (count != old);
+
+	return old;
+}
+
 /*
  * Add the locked dquot to the transaction.
  * The dquot must be locked, and it cannot be associated with any
@@ -315,6 +406,18 @@ xfs_trans_dqlockedjoin(
 	}
 }
 
+static int64_t
+xfs_dqresv_return(
+	xfs_qcnt_t	resv,
+	xfs_qcnt_t	resv_used,
+	xfs_qcnt_t	delta)
+{
+	if (!resv)
+		return delta;
+	if (resv > resv_used)
+		return resv_used - resv;
+	return resv - resv_used;
+}
 
 /*
  * Called by xfs_trans_commit() and similar in spirit to
@@ -334,6 +437,7 @@ xfs_trans_apply_dquot_deltas(
 	struct xfs_disk_dquot	*d;
 	long			totalbdelta;
 	long			totalrtbdelta;
+	struct xfs_mount	*mp = tp->t_mountp;
 
 	if (!(tp->t_flags & XFS_TRANS_DQ_DIRTY))
 		return;
@@ -350,6 +454,7 @@ xfs_trans_apply_dquot_deltas(
 		xfs_trans_dqlockedjoin(tp, qa);
 
 		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
+			int64_t		diff;
 			qtrx = &qa[i];
 			/*
 			 * The array of dquots is filled
@@ -419,73 +524,46 @@ xfs_trans_apply_dquot_deltas(
 			 * add this to the list of items to get logged
 			 */
 			xfs_trans_log_dquot(tp, dqp);
+
 			/*
 			 * Take off what's left of the original reservation.
 			 * In case of delayed allocations, there's no
 			 * reservation that a transaction structure knows of.
 			 */
-			if (qtrx->qt_blk_res != 0) {
-				if (qtrx->qt_blk_res != qtrx->qt_blk_res_used) {
-					if (qtrx->qt_blk_res >
-					    qtrx->qt_blk_res_used)
-						dqp->q_res_bcount -= (xfs_qcnt_t)
-							(qtrx->qt_blk_res -
-							 qtrx->qt_blk_res_used);
-					else
-						dqp->q_res_bcount -= (xfs_qcnt_t)
-							(qtrx->qt_blk_res_used -
-							 qtrx->qt_blk_res);
-				}
-			} else {
-				/*
-				 * These blks were never reserved, either inside
-				 * a transaction or outside one (in a delayed
-				 * allocation). Also, this isn't always a
-				 * negative number since we sometimes
-				 * deliberately skip quota reservations.
-				 */
-				if (qtrx->qt_bcount_delta) {
-					dqp->q_res_bcount +=
-					      (xfs_qcnt_t)qtrx->qt_bcount_delta;
-				}
-			}
+			diff = xfs_dqresv_return(qtrx->qt_blk_res,
+						 qtrx->qt_blk_res_used,
+						 qtrx->qt_bcount_delta);
+			if (diff)
+				xfs_dqresv_cmpxchg(mp, dqp, &dqp->q_res_bcount,
+						   diff, true, false, 0, 0, 0,
+						   0, 0);
 			/*
 			 * Adjust the RT reservation.
 			 */
-			if (qtrx->qt_rtblk_res != 0) {
-				if (qtrx->qt_rtblk_res != qtrx->qt_rtblk_res_used) {
-					if (qtrx->qt_rtblk_res >
-					    qtrx->qt_rtblk_res_used)
-					       dqp->q_res_rtbcount -= (xfs_qcnt_t)
-						       (qtrx->qt_rtblk_res -
-							qtrx->qt_rtblk_res_used);
-					else
-					       dqp->q_res_rtbcount -= (xfs_qcnt_t)
-						       (qtrx->qt_rtblk_res_used -
-							qtrx->qt_rtblk_res);
-				}
-			} else {
-				if (qtrx->qt_rtbcount_delta)
-					dqp->q_res_rtbcount +=
-					    (xfs_qcnt_t)qtrx->qt_rtbcount_delta;
-			}
+			diff = xfs_dqresv_return(qtrx->qt_rtblk_res,
+						 qtrx->qt_rtblk_res_used,
+						 qtrx->qt_rtbcount_delta);
+			if (diff)
+				xfs_dqresv_cmpxchg(mp, dqp, &dqp->q_res_rtbcount,
+						   diff, true, false, 0, 0, 0,
+						   0, 0);
 
 			/*
 			 * Adjust the inode reservation.
 			 */
-			if (qtrx->qt_ino_res != 0) {
+			if (qtrx->qt_ino_res == 0)
+				diff = qtrx->qt_icount_delta;
+			else {
 				ASSERT(qtrx->qt_ino_res >=
 				       qtrx->qt_ino_res_used);
-				if (qtrx->qt_ino_res > qtrx->qt_ino_res_used)
-					dqp->q_res_icount -= (xfs_qcnt_t)
-						(qtrx->qt_ino_res -
-						 qtrx->qt_ino_res_used);
-			} else {
-				if (qtrx->qt_icount_delta)
-					dqp->q_res_icount +=
-					    (xfs_qcnt_t)qtrx->qt_icount_delta;
+				diff = qtrx->qt_ino_res - qtrx->qt_ino_res_used;
+				if (diff < 0)
+					diff = 0;
 			}
-
+			if (diff)
+				xfs_dqresv_cmpxchg(mp, dqp, &dqp->q_res_icount,
+						   diff, true, false, 0, 0, 0,
+						   0, 0);
 			ASSERT(dqp->q_res_bcount >=
 				be64_to_cpu(dqp->q_core.d_bcount));
 			ASSERT(dqp->q_res_icount >=
@@ -562,22 +640,6 @@ xfs_trans_unreserve_and_mod_dquots(
 	}
 }
 
-STATIC void
-xfs_quota_warn(
-	struct xfs_mount	*mp,
-	struct xfs_dquot	*dqp,
-	int			type)
-{
-	/* no warnings for project quotas - we just return ENOSPC later */
-	if (dqp->dq_flags & XFS_DQ_PROJ)
-		return;
-	quota_send_warning(make_kqid(&init_user_ns,
-				     (dqp->dq_flags & XFS_DQ_USER) ?
-				     USRQUOTA : GRPQUOTA,
-				     be32_to_cpu(dqp->q_core.d_id)),
-			   mp->m_super->s_dev, type);
-}
-
 /*
  * This reserves disk blocks and inodes against a dquot.
  * Flags indicate if the dquot is to be locked here and also
@@ -591,20 +653,35 @@ xfs_trans_dqresv(
 	xfs_dquot_t	*dqp,
 	long		nblks,
 	long		ninos,
-	uint		flags)
+	uint		flags,
+	bool		enforce)
 {
 	xfs_qcnt_t	hardlimit;
 	xfs_qcnt_t	softlimit;
 	time_t		timer;
 	xfs_qwarncnt_t	warns;
 	xfs_qwarncnt_t	warnlimit;
-	xfs_qcnt_t	total_count;
+	xfs_qcnt_t	oldcnt;
 	xfs_qcnt_t	*resbcountp;
 	xfs_quotainfo_t	*q = mp->m_quotainfo;
 
+	/*
+	 * Lockless reservation algorithm:
+	 *
+	 * sample block count, inode count, timers and limits
+	 * cmpxchg loop to modify block reservation
+	 *	check limits:
+	 *		if over, check limits have not changed
+	 *			no change, fail
+	 *	cmpxchg block reservation
+	 *
+	 * if transaction, modify transaction context w/ change deltas.
+	 *	no locks required for this as context is private to transaction.
+	 */
+	if (nblks == 0)
+		goto do_ninos;
 
-	xfs_dqlock(dqp);
-
+	smp_mb();
 	if (flags & XFS_TRANS_DQ_RES_BLKS) {
 		hardlimit = be64_to_cpu(dqp->q_core.d_blk_hardlimit);
 		if (!hardlimit)
@@ -630,69 +707,35 @@ xfs_trans_dqresv(
 		resbcountp = &dqp->q_res_rtbcount;
 	}
 
-	if ((flags & XFS_QMOPT_FORCE_RES) == 0 &&
-	    dqp->q_core.d_id &&
-	    ((XFS_IS_UQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISUDQ(dqp)) ||
-	     (XFS_IS_GQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISGDQ(dqp)) ||
-	     (XFS_IS_PQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISPDQ(dqp)))) {
-		if (nblks > 0) {
-			/*
-			 * dquot is locked already. See if we'd go over the
-			 * hardlimit or exceed the timelimit if we allocate
-			 * nblks.
-			 */
-			total_count = *resbcountp + nblks;
-			if (hardlimit && total_count > hardlimit) {
-				xfs_quota_warn(mp, dqp, QUOTA_NL_BHARDWARN);
-				goto error_return;
-			}
-			if (softlimit && total_count > softlimit) {
-				if ((timer != 0 && get_seconds() > timer) ||
-				    (warns != 0 && warns >= warnlimit)) {
-					xfs_quota_warn(mp, dqp,
-						       QUOTA_NL_BSOFTLONGWARN);
-					goto error_return;
-				}
-
-				xfs_quota_warn(mp, dqp, QUOTA_NL_BSOFTWARN);
-			}
-		}
-		if (ninos > 0) {
-			total_count = be64_to_cpu(dqp->q_core.d_icount) + ninos;
-			timer = be32_to_cpu(dqp->q_core.d_itimer);
-			warns = be16_to_cpu(dqp->q_core.d_iwarns);
-			warnlimit = dqp->q_mount->m_quotainfo->qi_iwarnlimit;
-			hardlimit = be64_to_cpu(dqp->q_core.d_ino_hardlimit);
-			if (!hardlimit)
-				hardlimit = q->qi_ihardlimit;
-			softlimit = be64_to_cpu(dqp->q_core.d_ino_softlimit);
-			if (!softlimit)
-				softlimit = q->qi_isoftlimit;
-
-			if (hardlimit && total_count > hardlimit) {
-				xfs_quota_warn(mp, dqp, QUOTA_NL_IHARDWARN);
-				goto error_return;
-			}
-			if (softlimit && total_count > softlimit) {
-				if  ((timer != 0 && get_seconds() > timer) ||
-				     (warns != 0 && warns >= warnlimit)) {
-					xfs_quota_warn(mp, dqp,
-						       QUOTA_NL_ISOFTLONGWARN);
-					goto error_return;
-				}
-				xfs_quota_warn(mp, dqp, QUOTA_NL_ISOFTWARN);
-			}
-		}
-	}
-
-	/*
-	 * Change the reservation, but not the actual usage.
-	 * Note that q_res_bcount = q_core.d_bcount + resv
-	 */
-	(*resbcountp) += (xfs_qcnt_t)nblks;
-	if (ninos != 0)
-		dqp->q_res_icount += (xfs_qcnt_t)ninos;
-
+	oldcnt = xfs_dqresv_cmpxchg(mp, dqp, resbcountp, nblks, true, enforce,
+				    hardlimit, softlimit, timer, warns,
+				    warnlimit);
+	if (oldcnt == (xfs_qcnt_t)-1ULL)
+		goto error_return;
+
+do_ninos:
+	if (ninos == 0)
+		goto do_trans;
+
+	smp_mb();
+	timer = be32_to_cpu(dqp->q_core.d_itimer);
+	warns = be16_to_cpu(dqp->q_core.d_iwarns);
+	warnlimit = dqp->q_mount->m_quotainfo->qi_iwarnlimit;
+	hardlimit = be64_to_cpu(dqp->q_core.d_ino_hardlimit);
+	if (!hardlimit)
+		hardlimit = q->qi_ihardlimit;
+	softlimit = be64_to_cpu(dqp->q_core.d_ino_softlimit);
+	if (!softlimit)
+		softlimit = q->qi_isoftlimit;
+	resbcountp = &dqp->q_res_icount;
+
+	oldcnt = xfs_dqresv_cmpxchg(mp, dqp, resbcountp, ninos, false, enforce,
+				    hardlimit, softlimit, timer, warns,
+				    warnlimit);
+	if (oldcnt == (xfs_qcnt_t)-1ULL)
+		goto error_undo_nblks;
+
+do_trans:
 	/*
 	 * note the reservation amt in the trans struct too,
 	 * so that the transaction knows how much was reserved by
@@ -700,27 +743,30 @@ xfs_trans_dqresv(
 	 * We don't do this when we are reserving for a delayed allocation,
 	 * because we don't have the luxury of a transaction envelope then.
 	 */
-	if (tp) {
-		ASSERT(tp->t_dqinfo);
-		ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
-		if (nblks != 0)
-			xfs_trans_mod_dquot(tp, dqp,
-					    flags & XFS_QMOPT_RESBLK_MASK,
-					    nblks);
-		if (ninos != 0)
-			xfs_trans_mod_dquot(tp, dqp,
-					    XFS_TRANS_DQ_RES_INOS,
-					    ninos);
-	}
-	ASSERT(dqp->q_res_bcount >= be64_to_cpu(dqp->q_core.d_bcount));
-	ASSERT(dqp->q_res_rtbcount >= be64_to_cpu(dqp->q_core.d_rtbcount));
-	ASSERT(dqp->q_res_icount >= be64_to_cpu(dqp->q_core.d_icount));
+	if (!tp)
+		return 0;
 
-	xfs_dqunlock(dqp);
+	ASSERT(tp->t_dqinfo);
+	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
+	if (nblks)
+		xfs_trans_mod_dquot(tp, dqp, flags & XFS_QMOPT_RESBLK_MASK,
+				    nblks);
+	if (ninos != 0)
+		xfs_trans_mod_dquot(tp, dqp, XFS_TRANS_DQ_RES_INOS, ninos);
 	return 0;
 
+error_undo_nblks:
+	/* ninos reservation failed, so if we changed nblks, undo that. */
+	if (nblks) {
+		if (flags & XFS_TRANS_DQ_RES_BLKS)
+			resbcountp = &dqp->q_res_bcount;
+		else
+			resbcountp = &dqp->q_res_rtbcount;
+		xfs_dqresv_cmpxchg(mp, dqp, resbcountp, -nblks, true, false,
+			           0, 0, 0, 0, 0);
+	}
+
 error_return:
-	xfs_dqunlock(dqp);
 	if (flags & XFS_QMOPT_ENOSPC)
 		return ENOSPC;
 	return EDQUOT;
@@ -751,6 +797,7 @@ xfs_trans_reserve_quota_bydquots(
 	uint			flags)
 {
 	int		error;
+	bool		enforce;
 
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return 0;
@@ -761,20 +808,28 @@ xfs_trans_reserve_quota_bydquots(
 	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
 
 	if (udqp) {
+		enforce = !(flags & XFS_QMOPT_FORCE_RES) &&
+			  udqp->q_core.d_id && XFS_IS_UQUOTA_ENFORCED(mp);
 		error = xfs_trans_dqresv(tp, mp, udqp, nblks, ninos,
-					(flags & ~XFS_QMOPT_ENOSPC));
+					(flags & ~XFS_QMOPT_ENOSPC), enforce);
 		if (error)
 			return error;
 	}
 
 	if (gdqp) {
-		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags);
+		enforce = !(flags & XFS_QMOPT_FORCE_RES) &&
+			  gdqp->q_core.d_id && XFS_IS_GQUOTA_ENFORCED(mp);
+		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags,
+					 enforce);
 		if (error)
 			goto unwind_usr;
 	}
 
 	if (pdqp) {
-		error = xfs_trans_dqresv(tp, mp, pdqp, nblks, ninos, flags);
+		enforce = !(flags & XFS_QMOPT_FORCE_RES) &&
+			  pdqp->q_core.d_id && XFS_IS_PQUOTA_ENFORCED(mp);
+		error = xfs_trans_dqresv(tp, mp, pdqp, nblks, ninos, flags,
+					 enforce);
 		if (error)
 			goto unwind_grp;
 	}
@@ -784,14 +839,13 @@ xfs_trans_reserve_quota_bydquots(
 	 */
 	return 0;
 
+	/* unwinding does not require limit enforcement. */
 unwind_grp:
-	flags |= XFS_QMOPT_FORCE_RES;
 	if (gdqp)
-		xfs_trans_dqresv(tp, mp, gdqp, -nblks, -ninos, flags);
+		xfs_trans_dqresv(tp, mp, gdqp, -nblks, -ninos, flags, false);
 unwind_usr:
-	flags |= XFS_QMOPT_FORCE_RES;
 	if (udqp)
-		xfs_trans_dqresv(tp, mp, udqp, -nblks, -ninos, flags);
+		xfs_trans_dqresv(tp, mp, udqp, -nblks, -ninos, flags, false);
 	return error;
 }
 
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
