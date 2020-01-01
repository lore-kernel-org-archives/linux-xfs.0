Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B79A2C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B985206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:12:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a2i8ZqPc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgAABM0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:12:26 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54766 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABM0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:12:26 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011Aw6q110406
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=gYDTV4z6bjsQetu4Zm8KgaGrrOkLTZWNQlvGHMEIDAk=;
 b=a2i8ZqPc5RH3b77zQz4QWiVPr0tT2URCvoY4hHRrLo7mfafr+iR3EBvba9fEEYPkwWsY
 60giXbeALcfqmkkcKyTQNNEB4AoPgqzl+64gdzVa0hYpqDfIvxxJwODCkttpbecBS3Sb
 Ck4I8rhMyTJRBsOtqEGjIYiG+Tgnk/9LUsMNbpfLb+xP0cwOf5bMBTQ6J61GHblh5ZXv
 TMn/cYudwtily3jGLSg5hPdkgcjOsM5l/wQL5ZXyGNvMQyeqoXhQU4t2pSU9k049M+WN
 X1CI2Yaq3Yi9u6JWnrN6ILiqiDmJ6P9icrsNTtmsr4VghPo6FIPzPh4SNfMulzVFd2A2 9w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x5xftk2gd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:12:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 001190lC012634
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2x8guef1pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:12:22 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011CLe4012231
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:21 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:12:20 -0800
Subject: [PATCH 12/14] xfs: cache quota grace period expiration times incore
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:12:18 -0800
Message-ID: <157784113869.1364230.10740359430858443674.stgit@magnolia>
In-Reply-To: <157784106066.1364230.569420432829402226.stgit@magnolia>
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create an in-core timestamp that will tell us when a quota's grace
period expires.  In the subsequent bigtime patchset we will sacrifice
precision in the on-disk grace period timestamp to enable larger
timestamps across the filesystem, but we'll maintain an incore copy so
that we can maintain precision so long as the filesystem isn't
unmounted.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c  |   17 +++++++++++++++++
 fs/xfs/libxfs/xfs_quota_defs.h |    2 ++
 fs/xfs/xfs_dquot.c             |   40 +++++++++++++++++++++++++++-------------
 fs/xfs/xfs_dquot.h             |    8 ++++++++
 fs/xfs/xfs_qm.c                |   38 ++++++++++++++++++++++++++------------
 fs/xfs/xfs_qm_syscalls.c       |   26 +++++++++++++++-----------
 fs/xfs/xfs_trans_dquot.c       |    8 ++++----
 7 files changed, 99 insertions(+), 40 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index bedc1e752b60..72e0fcfef580 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -287,3 +287,20 @@ const struct xfs_buf_ops xfs_dquot_buf_ra_ops = {
 	.verify_read = xfs_dquot_buf_readahead_verify,
 	.verify_write = xfs_dquot_buf_write_verify,
 };
+
+void
+xfs_dquot_from_disk_timestamp(
+	struct timespec64	*tv,
+	__be32			dtimer)
+{
+	tv->tv_nsec = 0;
+	tv->tv_sec = be32_to_cpu(dtimer);
+}
+
+void
+xfs_dquot_to_disk_timestamp(
+	__be32			*dtimer,
+	const struct timespec64	*tv)
+{
+	*dtimer = cpu_to_be32(tv->tv_sec);
+}
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index b2113b17e53c..c453611ade3b 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -144,5 +144,7 @@ extern xfs_failaddr_t xfs_dqblk_verify(struct xfs_mount *mp,
 extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
 extern void xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
 		xfs_dqid_t id, uint type);
+void xfs_dquot_from_disk_timestamp(struct timespec64 *tv, __be32 dtimer);
+void xfs_dquot_to_disk_timestamp(__be32 *dtimer, const struct timespec64 *tv);
 
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 44bae5f16b55..763e974f7aad 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -126,21 +126,27 @@ xfs_dquot_clamp_timer(
 /* Set a quota grace period expiration timer. */
 static inline void
 xfs_quota_set_timer(
+	time64_t		*itimer,
 	__be32			*dtimer,
 	time_t			limit)
 {
-	time64_t		new_timeout;
+	struct timespec64	tv = { 0 };
 
-	new_timeout = xfs_dquot_clamp_timer(get_seconds() + limit);
-	*dtimer = cpu_to_be32(new_timeout);
+	tv.tv_sec = xfs_dquot_clamp_timer(ktime_get_real_seconds() + limit);
+	*itimer = tv.tv_sec;
+	xfs_dquot_to_disk_timestamp(dtimer, &tv);
 }
 
 /* Clear a quota grace period expiration timer. */
 static inline void
 xfs_quota_clear_timer(
+	time64_t		*itimer,
 	__be32			*dtimer)
 {
-	*dtimer = cpu_to_be32(0);
+	struct timespec64	tv = { 0 };
+
+	*itimer = tv.tv_sec;
+	xfs_dquot_to_disk_timestamp(dtimer, &tv);
 }
 
 /*
@@ -180,46 +186,46 @@ xfs_qm_adjust_dqtimers(
 
 	over = xfs_quota_exceeded(&d->d_bcount, dqp->q_ina_bcount,
 			&d->d_blk_softlimit, &d->d_blk_hardlimit);
-	if (!d->d_btimer) {
+	if (!dqp->q_btimer) {
 		if (over) {
-			xfs_quota_set_timer(&d->d_btimer,
+			xfs_quota_set_timer(&dqp->q_btimer, &d->d_btimer,
 					mp->m_quotainfo->qi_btimelimit);
 		} else {
 			d->d_bwarns = 0;
 		}
 	} else {
 		if (!over) {
-			xfs_quota_clear_timer(&d->d_btimer);
+			xfs_quota_clear_timer(&dqp->q_btimer, &d->d_btimer);
 		}
 	}
 
 	over = xfs_quota_exceeded(&d->d_icount, dqp->q_ina_icount,
 			&d->d_ino_softlimit, &d->d_ino_hardlimit);
-	if (!d->d_itimer) {
+	if (!dqp->q_itimer) {
 		if (over) {
-			xfs_quota_set_timer(&d->d_itimer,
+			xfs_quota_set_timer(&dqp->q_itimer, &d->d_itimer,
 					mp->m_quotainfo->qi_itimelimit);
 		} else {
 			d->d_iwarns = 0;
 		}
 	} else {
 		if (!over) {
-			xfs_quota_clear_timer(&d->d_itimer);
+			xfs_quota_clear_timer(&dqp->q_itimer, &d->d_itimer);
 		}
 	}
 
 	over = xfs_quota_exceeded(&d->d_rtbcount, dqp->q_ina_rtbcount,
 			&d->d_rtb_softlimit, &d->d_rtb_hardlimit);
-	if (!d->d_rtbtimer) {
+	if (!dqp->q_rtbtimer) {
 		if (over) {
-			xfs_quota_set_timer(&d->d_rtbtimer,
+			xfs_quota_set_timer(&dqp->q_rtbtimer, &d->d_rtbtimer,
 					mp->m_quotainfo->qi_rtbtimelimit);
 		} else {
 			d->d_rtbwarns = 0;
 		}
 	} else {
 		if (!over) {
-			xfs_quota_clear_timer(&d->d_rtbtimer);
+			xfs_quota_clear_timer(&dqp->q_rtbtimer, &d->d_rtbtimer);
 		}
 	}
 }
@@ -520,6 +526,7 @@ xfs_dquot_from_disk(
 	struct xfs_dquot	*dqp,
 	struct xfs_buf		*bp)
 {
+	struct timespec64	tv;
 	struct xfs_disk_dquot	*ddqp = bp->b_addr + dqp->q_bufoffset;
 
 	/* copy everything from disk dquot to the incore dquot */
@@ -533,6 +540,13 @@ xfs_dquot_from_disk(
 	dqp->q_res_icount = be64_to_cpu(ddqp->d_icount);
 	dqp->q_res_rtbcount = be64_to_cpu(ddqp->d_rtbcount);
 
+	xfs_dquot_from_disk_timestamp(&tv, ddqp->d_btimer);
+	dqp->q_btimer = tv.tv_sec;
+	xfs_dquot_from_disk_timestamp(&tv, ddqp->d_itimer);
+	dqp->q_itimer = tv.tv_sec;
+	xfs_dquot_from_disk_timestamp(&tv, ddqp->d_rtbtimer);
+	dqp->q_rtbtimer = tv.tv_sec;
+
 	/* initialize the dquot speculative prealloc thresholds */
 	xfs_dquot_set_prealloc_limits(dqp);
 }
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index d924da98f66a..99c0d6266fd8 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -60,6 +60,14 @@ struct xfs_dquot {
 	xfs_qcnt_t		q_prealloc_lo_wmark;
 	xfs_qcnt_t		q_prealloc_hi_wmark;
 	int64_t			q_low_space[XFS_QLOWSP_MAX];
+
+	/* incore block grace timeout */
+	time64_t		q_btimer;
+	/* incore inode grace timeout */
+	time64_t		q_itimer;
+	/* incore rt block grace timeout */
+	time64_t		q_rtbtimer;
+
 	struct mutex		q_qlock;
 	struct completion	q_flush;
 	atomic_t		q_pincount;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 268e028c9ec8..9be123a0902e 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -589,6 +589,7 @@ xfs_qm_init_timelimits(
 	struct xfs_mount	*mp,
 	struct xfs_quotainfo	*qinf)
 {
+	struct timespec64	tv;
 	struct xfs_disk_dquot	*ddqp;
 	struct xfs_dquot	*dqp;
 	uint			type;
@@ -628,12 +629,18 @@ xfs_qm_init_timelimits(
 	 * a user or group before he or she can not perform any
 	 * more writing. If it is zero, a default is used.
 	 */
-	if (ddqp->d_btimer)
-		qinf->qi_btimelimit = be32_to_cpu(ddqp->d_btimer);
-	if (ddqp->d_itimer)
-		qinf->qi_itimelimit = be32_to_cpu(ddqp->d_itimer);
-	if (ddqp->d_rtbtimer)
-		qinf->qi_rtbtimelimit = be32_to_cpu(ddqp->d_rtbtimer);
+	if (ddqp->d_btimer) {
+		xfs_dquot_from_disk_timestamp(&tv, ddqp->d_btimer);
+		qinf->qi_btimelimit = tv.tv_sec;
+	}
+	if (ddqp->d_itimer) {
+		xfs_dquot_from_disk_timestamp(&tv, ddqp->d_itimer);
+		qinf->qi_itimelimit = tv.tv_sec;
+	}
+	if (ddqp->d_rtbtimer) {
+		xfs_dquot_from_disk_timestamp(&tv, ddqp->d_rtbtimer);
+		qinf->qi_rtbtimelimit = tv.tv_sec;
+	}
 	if (ddqp->d_bwarns)
 		qinf->qi_bwarnlimit = be16_to_cpu(ddqp->d_bwarns);
 	if (ddqp->d_iwarns)
@@ -848,16 +855,23 @@ xfs_qm_reset_dqintervals(
 	struct xfs_mount	*mp,
 	struct xfs_disk_dquot	*ddq)
 {
+	struct timespec64	tv = { 0 };
 	struct xfs_quotainfo	*qinf = mp->m_quotainfo;
 
-	if (qinf->qi_btimelimit != XFS_QM_BTIMELIMIT)
-		ddq->d_btimer = cpu_to_be32(qinf->qi_btimelimit);
+	if (qinf->qi_btimelimit != XFS_QM_BTIMELIMIT) {
+		tv.tv_sec = qinf->qi_btimelimit;
+		xfs_dquot_to_disk_timestamp(&ddq->d_btimer, &tv);
+	}
 
-	if (qinf->qi_itimelimit != XFS_QM_ITIMELIMIT)
-		ddq->d_itimer = cpu_to_be32(qinf->qi_itimelimit);
+	if (qinf->qi_itimelimit != XFS_QM_ITIMELIMIT) {
+		tv.tv_sec = qinf->qi_itimelimit;
+		xfs_dquot_to_disk_timestamp(&ddq->d_itimer, &tv);
+	}
 
-	if (qinf->qi_rtbtimelimit != XFS_QM_RTBTIMELIMIT)
-		ddq->d_rtbtimer = cpu_to_be32(qinf->qi_rtbtimelimit);
+	if (qinf->qi_rtbtimelimit != XFS_QM_RTBTIMELIMIT) {
+		tv.tv_sec = qinf->qi_rtbtimelimit;
+		xfs_dquot_to_disk_timestamp(&ddq->d_rtbtimer, &tv);
+	}
 }
 
 STATIC void
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 20a6d304d1be..bd9db42b89b9 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -442,14 +442,17 @@ xfs_qm_scall_quotaon(
 static inline void
 xfs_qm_set_grace(
 	time_t			*qi_limit,
+	time64_t		*itimer,
 	__be32			*dtimer,
 	const s64		grace)
 {
-	time64_t		new_grace;
+	struct timespec64	tv = { 0 };
 
-	new_grace = clamp_t(time64_t, grace, XFS_DQ_GRACE_MIN,
+	tv.tv_sec = clamp_t(time64_t, grace, XFS_DQ_GRACE_MIN,
 					     XFS_DQ_GRACE_MAX);
-	*dtimer = cpu_to_be32(new_grace);
+	*qi_limit = tv.tv_sec;
+	*itimer = tv.tv_sec;
+	xfs_dquot_to_disk_timestamp(dtimer, &tv);
 }
 
 #define XFS_QC_MASK \
@@ -582,13 +585,14 @@ xfs_qm_scall_setqlim(
 		 * for warnings.
 		 */
 		if (newlim->d_fieldmask & QC_SPC_TIMER)
-			xfs_qm_set_grace(&q->qi_btimelimit, &ddq->d_btimer,
-					newlim->d_spc_timer);
+			xfs_qm_set_grace(&q->qi_btimelimit, &dqp->q_btimer,
+					&ddq->d_btimer, newlim->d_spc_timer);
 		if (newlim->d_fieldmask & QC_INO_TIMER)
-			xfs_qm_set_grace(&q->qi_itimelimit, &ddq->d_itimer,
-					newlim->d_ino_timer);
+			xfs_qm_set_grace(&q->qi_itimelimit, &dqp->q_itimer,
+					&ddq->d_itimer, newlim->d_ino_timer);
 		if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
-			xfs_qm_set_grace(&q->qi_rtbtimelimit, &ddq->d_rtbtimer,
+			xfs_qm_set_grace(&q->qi_rtbtimelimit, &dqp->q_rtbtimer,
+					&ddq->d_rtbtimer,
 					newlim->d_rt_spc_timer);
 		if (newlim->d_fieldmask & QC_SPC_WARNS)
 			q->qi_bwarnlimit = newlim->d_spc_warns;
@@ -635,8 +639,8 @@ xfs_qm_scall_getquota_fill_qc(
 	dst->d_ino_softlimit = be64_to_cpu(dqp->q_core.d_ino_softlimit);
 	dst->d_space = XFS_FSB_TO_B(mp, dqp->q_res_bcount - dqp->q_ina_bcount);
 	dst->d_ino_count = dqp->q_res_icount - dqp->q_ina_icount;
-	dst->d_spc_timer = be32_to_cpu(dqp->q_core.d_btimer);
-	dst->d_ino_timer = be32_to_cpu(dqp->q_core.d_itimer);
+	dst->d_spc_timer = dqp->q_btimer;
+	dst->d_ino_timer = dqp->q_itimer;
 	dst->d_ino_warns = be16_to_cpu(dqp->q_core.d_iwarns);
 	dst->d_spc_warns = be16_to_cpu(dqp->q_core.d_bwarns);
 	dst->d_rt_spc_hardlimit =
@@ -645,7 +649,7 @@ xfs_qm_scall_getquota_fill_qc(
 		XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_rtb_softlimit));
 	dst->d_rt_space =
 		XFS_FSB_TO_B(mp, dqp->q_res_rtbcount - dqp->q_ina_rtbcount);
-	dst->d_rt_spc_timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
+	dst->d_rt_spc_timer = dqp->q_rtbtimer;
 	dst->d_rt_spc_warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
 
 	/*
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 7a2a3bd11db9..62ef99f705df 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -568,7 +568,7 @@ static inline bool
 xfs_quota_timer_exceeded(
 	time64_t		timer)
 {
-	return timer != 0 && get_seconds() > timer;
+	return timer != 0 && ktime_get_real_seconds() > timer;
 }
 
 /*
@@ -608,7 +608,7 @@ xfs_trans_dqresv(
 		softlimit = be64_to_cpu(dqp->q_core.d_blk_softlimit);
 		if (!softlimit)
 			softlimit = defq->bsoftlimit;
-		timer = be32_to_cpu(dqp->q_core.d_btimer);
+		timer = dqp->q_btimer;
 		warns = be16_to_cpu(dqp->q_core.d_bwarns);
 		warnlimit = dqp->q_mount->m_quotainfo->qi_bwarnlimit;
 		resbcountp = &dqp->q_res_bcount;
@@ -620,7 +620,7 @@ xfs_trans_dqresv(
 		softlimit = be64_to_cpu(dqp->q_core.d_rtb_softlimit);
 		if (!softlimit)
 			softlimit = defq->rtbsoftlimit;
-		timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
+		timer = dqp->q_rtbtimer;
 		warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
 		warnlimit = dqp->q_mount->m_quotainfo->qi_rtbwarnlimit;
 		resbcountp = &dqp->q_res_rtbcount;
@@ -655,7 +655,7 @@ xfs_trans_dqresv(
 		}
 		if (ninos > 0) {
 			total_count = be64_to_cpu(dqp->q_core.d_icount) + ninos;
-			timer = be32_to_cpu(dqp->q_core.d_itimer);
+			timer = dqp->q_itimer;
 			warns = be16_to_cpu(dqp->q_core.d_iwarns);
 			warnlimit = dqp->q_mount->m_quotainfo->qi_iwarnlimit;
 			hardlimit = be64_to_cpu(dqp->q_core.d_ino_hardlimit);

