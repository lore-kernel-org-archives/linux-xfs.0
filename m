Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43168 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750794AbeEKXoo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 May 2018 19:44:44 -0400
Date: Fri, 11 May 2018 16:44:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 1/8] xfs: refactor quota limits initialization
Message-ID: <20180511234424.GK11261@magnolia>
References: <152597988038.25215.9276761144353662866.stgit@magnolia>
 <152597988679.25215.8852024160735275694.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152597988679.25215.8852024160735275694.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, bfoster@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace all the if (!error) weirdness with helper functions that follow
our regular coding practices, and factor out the ternary expression soup.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: refactor out ternary expressions
---
 fs/xfs/xfs_qm.c |  142 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 78 insertions(+), 64 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index f927b7d72db1..913d46d01bfc 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -561,26 +561,88 @@ xfs_qm_set_defquota(
 {
 	xfs_dquot_t		*dqp;
 	struct xfs_def_quota    *defq;
+	struct xfs_disk_dquot	*ddqp;
 	int			error;
 
 	error = xfs_qm_dqget_uncached(mp, 0, type, &dqp);
-	if (!error) {
-		xfs_disk_dquot_t        *ddqp = &dqp->q_core;
+	if (error)
+		return;
 
-		defq = xfs_get_defquota(dqp, qinf);
+	ddqp = &dqp->q_core;
+	defq = xfs_get_defquota(dqp, qinf);
 
-		/*
-		 * Timers and warnings have been already set, let's just set the
-		 * default limits for this quota type
-		 */
-		defq->bhardlimit = be64_to_cpu(ddqp->d_blk_hardlimit);
-		defq->bsoftlimit = be64_to_cpu(ddqp->d_blk_softlimit);
-		defq->ihardlimit = be64_to_cpu(ddqp->d_ino_hardlimit);
-		defq->isoftlimit = be64_to_cpu(ddqp->d_ino_softlimit);
-		defq->rtbhardlimit = be64_to_cpu(ddqp->d_rtb_hardlimit);
-		defq->rtbsoftlimit = be64_to_cpu(ddqp->d_rtb_softlimit);
-		xfs_qm_dqdestroy(dqp);
-	}
+	/*
+	 * Timers and warnings have been already set, let's just set the
+	 * default limits for this quota type
+	 */
+	defq->bhardlimit = be64_to_cpu(ddqp->d_blk_hardlimit);
+	defq->bsoftlimit = be64_to_cpu(ddqp->d_blk_softlimit);
+	defq->ihardlimit = be64_to_cpu(ddqp->d_ino_hardlimit);
+	defq->isoftlimit = be64_to_cpu(ddqp->d_ino_softlimit);
+	defq->rtbhardlimit = be64_to_cpu(ddqp->d_rtb_hardlimit);
+	defq->rtbsoftlimit = be64_to_cpu(ddqp->d_rtb_softlimit);
+	xfs_qm_dqdestroy(dqp);
+}
+
+/* Initialize quota time limits from the root dquot. */
+static void
+xfs_qm_init_timelimits(
+	struct xfs_mount	*mp,
+	struct xfs_quotainfo	*qinf)
+{
+	struct xfs_disk_dquot	*ddqp;
+	struct xfs_dquot	*dqp;
+	uint			type;
+	int			error;
+
+	qinf->qi_btimelimit = XFS_QM_BTIMELIMIT;
+	qinf->qi_itimelimit = XFS_QM_ITIMELIMIT;
+	qinf->qi_rtbtimelimit = XFS_QM_RTBTIMELIMIT;
+	qinf->qi_bwarnlimit = XFS_QM_BWARNLIMIT;
+	qinf->qi_iwarnlimit = XFS_QM_IWARNLIMIT;
+	qinf->qi_rtbwarnlimit = XFS_QM_RTBWARNLIMIT;
+
+	/*
+	 * We try to get the limits from the superuser's limits fields.
+	 * This is quite hacky, but it is standard quota practice.
+	 *
+	 * Since we may not have done a quotacheck by this point, just read
+	 * the dquot without attaching it to any hashtables or lists.
+	 *
+	 * Timers and warnings are globally set by the first timer found in
+	 * user/group/proj quota types, otherwise a default value is used.
+	 * This should be split into different fields per quota type.
+	 */
+	if (XFS_IS_UQUOTA_RUNNING(mp))
+		type = XFS_DQ_USER;
+	else if (XFS_IS_GQUOTA_RUNNING(mp))
+		type = XFS_DQ_GROUP;
+	else
+		type = XFS_DQ_PROJ;
+	error = xfs_qm_dqget_uncached(mp, 0, type, &dqp);
+	if (error)
+		return;
+
+	ddqp = &dqp->q_core;
+	/*
+	 * The warnings and timers set the grace period given to
+	 * a user or group before he or she can not perform any
+	 * more writing. If it is zero, a default is used.
+	 */
+	if (ddqp->d_btimer)
+		qinf->qi_btimelimit = be32_to_cpu(ddqp->d_btimer);
+	if (ddqp->d_itimer)
+		qinf->qi_itimelimit = be32_to_cpu(ddqp->d_itimer);
+	if (ddqp->d_rtbtimer)
+		qinf->qi_rtbtimelimit = be32_to_cpu(ddqp->d_rtbtimer);
+	if (ddqp->d_bwarns)
+		qinf->qi_bwarnlimit = be32_to_cpu(ddqp->d_bwarns);
+	if (ddqp->d_iwarns)
+		qinf->qi_iwarnlimit = be32_to_cpu(ddqp->d_iwarns);
+	if (ddqp->d_rtbwarns)
+		qinf->qi_rtbwarnlimit = be32_to_cpu(ddqp->d_rtbwarns);
+
+	xfs_qm_dqdestroy(dqp);
 }
 
 /*
@@ -592,8 +654,6 @@ xfs_qm_init_quotainfo(
 	struct xfs_mount	*mp)
 {
 	struct xfs_quotainfo	*qinf;
-	struct xfs_dquot	*dqp;
-	uint			type;
 	int			error;
 
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
@@ -626,53 +686,7 @@ xfs_qm_init_quotainfo(
 
 	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
 
-	/*
-	 * We try to get the limits from the superuser's limits fields.
-	 * This is quite hacky, but it is standard quota practice.
-	 *
-	 * Since we may not have done a quotacheck by this point, just read
-	 * the dquot without attaching it to any hashtables or lists.
-	 *
-	 * Timers and warnings are globally set by the first timer found in
-	 * user/group/proj quota types, otherwise a default value is used.
-	 * This should be split into different fields per quota type.
-	 */
-	if (XFS_IS_UQUOTA_RUNNING(mp))
-		type = XFS_DQ_USER;
-	else if (XFS_IS_GQUOTA_RUNNING(mp))
-		type = XFS_DQ_GROUP;
-	else
-		type = XFS_DQ_PROJ;
-	error = xfs_qm_dqget_uncached(mp, 0, type, &dqp);
-	if (!error) {
-		xfs_disk_dquot_t	*ddqp = &dqp->q_core;
-
-		/*
-		 * The warnings and timers set the grace period given to
-		 * a user or group before he or she can not perform any
-		 * more writing. If it is zero, a default is used.
-		 */
-		qinf->qi_btimelimit = ddqp->d_btimer ?
-			be32_to_cpu(ddqp->d_btimer) : XFS_QM_BTIMELIMIT;
-		qinf->qi_itimelimit = ddqp->d_itimer ?
-			be32_to_cpu(ddqp->d_itimer) : XFS_QM_ITIMELIMIT;
-		qinf->qi_rtbtimelimit = ddqp->d_rtbtimer ?
-			be32_to_cpu(ddqp->d_rtbtimer) : XFS_QM_RTBTIMELIMIT;
-		qinf->qi_bwarnlimit = ddqp->d_bwarns ?
-			be16_to_cpu(ddqp->d_bwarns) : XFS_QM_BWARNLIMIT;
-		qinf->qi_iwarnlimit = ddqp->d_iwarns ?
-			be16_to_cpu(ddqp->d_iwarns) : XFS_QM_IWARNLIMIT;
-		qinf->qi_rtbwarnlimit = ddqp->d_rtbwarns ?
-			be16_to_cpu(ddqp->d_rtbwarns) : XFS_QM_RTBWARNLIMIT;
-		xfs_qm_dqdestroy(dqp);
-	} else {
-		qinf->qi_btimelimit = XFS_QM_BTIMELIMIT;
-		qinf->qi_itimelimit = XFS_QM_ITIMELIMIT;
-		qinf->qi_rtbtimelimit = XFS_QM_RTBTIMELIMIT;
-		qinf->qi_bwarnlimit = XFS_QM_BWARNLIMIT;
-		qinf->qi_iwarnlimit = XFS_QM_IWARNLIMIT;
-		qinf->qi_rtbwarnlimit = XFS_QM_RTBWARNLIMIT;
-	}
+	xfs_qm_init_timelimits(mp, qinf);
 
 	if (XFS_IS_UQUOTA_RUNNING(mp))
 		xfs_qm_set_defquota(mp, XFS_DQ_USER, qinf);
