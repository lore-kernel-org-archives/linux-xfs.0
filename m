Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 347E8C433E2
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 02:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 047BD20707
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 02:56:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jJtm9PBx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgIBC46 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 22:56:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33534 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgIBC44 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 22:56:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822t7o6090261;
        Wed, 2 Sep 2020 02:56:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=k1zi3z0iHgVIyENMoVpmHWGElnWLUPCXnyVCPOaArHQ=;
 b=jJtm9PBxOnjFgpWW4toyk8AeeWqwAy4bQLqcuz4LHxZrC1dfPpZza2wrIAUPPGJ5/gMO
 a7C20uSzY5YPDxjUHRih0lL0t2IMsQP6ASQDe6OvEfUN5yK0OQ6MU/F0LzE6QgPoSM+V
 htsMhf8vsNaXtse2+K8/HSOdfZZ14hjKwGIC1ScMUCR0Gn7y784ScjGRoiHnHwWUJkAn
 V1fRqmJENdSdxR50r/uLbaQsKXi6mv/aClZtnz0fEyQKmSaP3DJNyyCZ9BnTee/bKmo4
 ExyQtD6vPvvGggOLpjrWr1Xk+5KYNCPKwItBFQSTNntFN4PFVwak8hGIokAyXW3YJtdW Bw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 337eym7st6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 02:56:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822t2h0186177;
        Wed, 2 Sep 2020 02:56:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3380st0wh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 02:56:46 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0822uhBj004853;
        Wed, 2 Sep 2020 02:56:44 GMT
Received: from localhost (/10.159.133.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 19:56:43 -0700
Subject: [PATCH 02/11] xfs: refactor quota expiration timer modification
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Date:   Tue, 01 Sep 2020 19:56:41 -0700
Message-ID: <159901540158.548109.2674546040641619554.stgit@magnolia>
In-Reply-To: <159901538766.548109.8040337941204954344.stgit@magnolia>
References: <159901538766.548109.8040337941204954344.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020026
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Define explicit limits on the range of quota grace period expiration
timeouts and refactor the code that modifies the timeouts into helpers
that clamp the values appropriately.  Note that we'll refactor the
default grace period timer separately.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |   24 ++++++++++++++++++++++++
 fs/xfs/xfs_dquot.c         |   22 ++++++++++++++++++----
 fs/xfs/xfs_dquot.h         |    2 ++
 fs/xfs/xfs_qm.c            |    2 ++
 fs/xfs/xfs_qm.h            |    4 ++++
 fs/xfs/xfs_qm_syscalls.c   |   16 +++++++++++-----
 6 files changed, 61 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index e57360a8fd16..cb316053d3db 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1199,6 +1199,30 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 
 #define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK)
 
+/*
+ * XFS Quota Timers
+ * ================
+ *
+ * Traditional quota grace period expiration timers are an unsigned 32-bit
+ * seconds counter; time zero is the Unix epoch, Jan  1 00:00:01 UTC 1970.
+ * Note that an expiration value of zero means that the quota limit has not
+ * been reached, and therefore no expiration has been set.  Therefore, the
+ * ondisk min and max defined here can be used directly to constrain the incore
+ * quota expiration timestamps on a Unix system.
+ */
+
+/*
+ * Smallest possible ondisk quota expiration value with traditional timestamps.
+ * This corresponds exactly with the incore expiration Jan  1 00:00:01 UTC 1970.
+ */
+#define XFS_DQ_LEGACY_EXPIRY_MIN	((int64_t)1)
+
+/*
+ * Largest possible ondisk quota expiration value with traditional timestamps.
+ * This corresponds exactly with the incore expiration Feb  7 06:28:15 UTC 2106.
+ */
+#define XFS_DQ_LEGACY_EXPIRY_MAX	((int64_t)U32_MAX)
+
 /*
  * This is the main portion of the on-disk representation of quota information
  * for a user.  We pad this with some more expansion room to construct the on
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index bcd73b9c2994..f34841f98d44 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -98,12 +98,25 @@ xfs_qm_adjust_dqlimits(
 		xfs_dquot_set_prealloc_limits(dq);
 }
 
+/* Set the expiration time of a quota's grace period. */
+time64_t
+xfs_dquot_set_timeout(
+	struct xfs_mount	*mp,
+	time64_t		timeout)
+{
+	struct xfs_quotainfo	*qi = mp->m_quotainfo;
+
+	return clamp_t(time64_t, timeout, qi->qi_expiry_min,
+					  qi->qi_expiry_max);
+}
+
 /*
  * Determine if this quota counter is over either limit and set the quota
  * timers as appropriate.
  */
 static inline void
 xfs_qm_adjust_res_timer(
+	struct xfs_mount	*mp,
 	struct xfs_dquot_res	*res,
 	struct xfs_quota_limits	*qlim)
 {
@@ -112,7 +125,8 @@ xfs_qm_adjust_res_timer(
 	if ((res->softlimit && res->count > res->softlimit) ||
 	    (res->hardlimit && res->count > res->hardlimit)) {
 		if (res->timer == 0)
-			res->timer = ktime_get_real_seconds() + qlim->time;
+			res->timer = xfs_dquot_set_timeout(mp,
+					ktime_get_real_seconds() + qlim->time);
 	} else {
 		if (res->timer == 0)
 			res->warnings = 0;
@@ -145,9 +159,9 @@ xfs_qm_adjust_dqtimers(
 	ASSERT(dq->q_id);
 	defq = xfs_get_defquota(qi, xfs_dquot_type(dq));
 
-	xfs_qm_adjust_res_timer(&dq->q_blk, &defq->blk);
-	xfs_qm_adjust_res_timer(&dq->q_ino, &defq->ino);
-	xfs_qm_adjust_res_timer(&dq->q_rtb, &defq->rtb);
+	xfs_qm_adjust_res_timer(dq->q_mount, &dq->q_blk, &defq->blk);
+	xfs_qm_adjust_res_timer(dq->q_mount, &dq->q_ino, &defq->ino);
+	xfs_qm_adjust_res_timer(dq->q_mount, &dq->q_rtb, &defq->rtb);
 }
 
 /*
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 282a65da93c7..0e449101c861 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -237,4 +237,6 @@ typedef int (*xfs_qm_dqiterate_fn)(struct xfs_dquot *dq,
 int xfs_qm_dqiterate(struct xfs_mount *mp, xfs_dqtype_t type,
 		xfs_qm_dqiterate_fn iter_fn, void *priv);
 
+time64_t xfs_dquot_set_timeout(struct xfs_mount *mp, time64_t timeout);
+
 #endif /* __XFS_DQUOT_H__ */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index be67570badf8..b83a12ecfc35 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -661,6 +661,8 @@ xfs_qm_init_quotainfo(
 	/* Precalc some constants */
 	qinf->qi_dqchunklen = XFS_FSB_TO_BB(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
 	qinf->qi_dqperchunk = xfs_calc_dquots_per_chunk(qinf->qi_dqchunklen);
+	qinf->qi_expiry_min = XFS_DQ_LEGACY_EXPIRY_MIN;
+	qinf->qi_expiry_max = XFS_DQ_LEGACY_EXPIRY_MAX;
 
 	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
 
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 9c078c35d924..e3dabab44097 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -65,6 +65,10 @@ struct xfs_quotainfo {
 	struct xfs_def_quota	qi_grp_default;
 	struct xfs_def_quota	qi_prj_default;
 	struct shrinker		qi_shrinker;
+
+	/* Minimum and maximum quota expiration timestamp values. */
+	time64_t		qi_expiry_min;
+	time64_t		qi_expiry_max;
 };
 
 static inline struct radix_tree_root *
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 1c542b4a5220..750f775ae915 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -479,13 +479,19 @@ xfs_setqlim_warns(
 
 static inline void
 xfs_setqlim_timer(
+	struct xfs_mount	*mp,
 	struct xfs_dquot_res	*res,
 	struct xfs_quota_limits	*qlim,
 	s64			timer)
 {
-	res->timer = timer;
-	if (qlim)
+	if (qlim) {
+		/* Set the length of the default grace period. */
+		res->timer = timer;
 		qlim->time = timer;
+	} else {
+		/* Set the grace period expiration on a quota. */
+		res->timer = xfs_dquot_set_timeout(mp, timer);
+	}
 }
 
 /*
@@ -574,7 +580,7 @@ xfs_qm_scall_setqlim(
 	if (newlim->d_fieldmask & QC_SPC_WARNS)
 		xfs_setqlim_warns(res, qlim, newlim->d_spc_warns);
 	if (newlim->d_fieldmask & QC_SPC_TIMER)
-		xfs_setqlim_timer(res, qlim, newlim->d_spc_timer);
+		xfs_setqlim_timer(mp, res, qlim, newlim->d_spc_timer);
 
 	/* Blocks on the realtime device. */
 	hard = (newlim->d_fieldmask & QC_RT_SPC_HARD) ?
@@ -590,7 +596,7 @@ xfs_qm_scall_setqlim(
 	if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
 		xfs_setqlim_warns(res, qlim, newlim->d_rt_spc_warns);
 	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
-		xfs_setqlim_timer(res, qlim, newlim->d_rt_spc_timer);
+		xfs_setqlim_timer(mp, res, qlim, newlim->d_rt_spc_timer);
 
 	/* Inodes */
 	hard = (newlim->d_fieldmask & QC_INO_HARD) ?
@@ -606,7 +612,7 @@ xfs_qm_scall_setqlim(
 	if (newlim->d_fieldmask & QC_INO_WARNS)
 		xfs_setqlim_warns(res, qlim, newlim->d_ino_warns);
 	if (newlim->d_fieldmask & QC_INO_TIMER)
-		xfs_setqlim_timer(res, qlim, newlim->d_ino_timer);
+		xfs_setqlim_timer(mp, res, qlim, newlim->d_ino_timer);
 
 	if (id != 0) {
 		/*

