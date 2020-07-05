Return-Path: <SRS0=iu4H=AQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7226C433DF
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC97F2075B
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:16:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZYAKXtlp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgGEWQb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jul 2020 18:16:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58044 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgGEWQb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jul 2020 18:16:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MCTC6080647;
        Sun, 5 Jul 2020 22:16:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Zh3H6zq9iwUw47LvVWoPFgcBodgbLWSdX7+gbmm4Vak=;
 b=ZYAKXtlpmzRi2S03A5hmiUsSG/cicGtp2IOgF8TNHUOLXOTclBj29x5Qq76BAlFFKKDv
 Y6yMJ3em2qWM0/vFb9Jmw2a0dQ1dvcfR7Jn+ZMNrmHqIp9pxa4YgUSZiCpomPCygT8QK
 GVHmaFNNEfo2A22X6OgtZsIQYz5am4R/gNtlcdW0tsdsAq4LEHHpwWu9qM+C480TSTCY
 Yq+eCKFYXeAajhEz1v5x/RWPo+5RnxRuKmajC0EBOJcykjHhEBIEUkOmcaMaNlrK1W7a
 u4snN1Sd+uIKKmPtUEmYbWLbMb4Z3A0z2ZQ//fO6JdfXnGqw+PBHz8QbQc6M6ZvcI82N 1g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 322kv63b30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 05 Jul 2020 22:16:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MD1WK111439;
        Sun, 5 Jul 2020 22:14:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3233nx9bbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 05 Jul 2020 22:14:26 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 065MEPim003472;
        Sun, 5 Jul 2020 22:14:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 05 Jul 2020 15:14:25 -0700
Subject: [PATCH 17/22] xfs: refactor xfs_qm_scall_setqlim
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Date:   Sun, 05 Jul 2020 15:14:24 -0700
Message-ID: <159398726399.425236.13574105173650620585.stgit@magnolia>
In-Reply-To: <159398715269.425236.15910213189856396341.stgit@magnolia>
References: <159398715269.425236.15910213189856396341.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007050172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 suspectscore=1 mlxlogscore=999 phishscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 mlxscore=0 adultscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007050172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we can pass around quota resource and limit structures, clean
up the open-coded field setting in xfs_qm_scall_setqlim.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/xfs_qm_syscalls.c |  164 ++++++++++++++++++++++++++--------------------
 1 file changed, 93 insertions(+), 71 deletions(-)


diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 580546f3ab40..2e3e36b5eaad 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -436,6 +436,58 @@ xfs_qm_scall_quotaon(
 #define XFS_QC_MASK \
 	(QC_LIMIT_MASK | QC_TIMER_MASK | QC_WARNS_MASK)
 
+/*
+ * Adjust limits of this quota, and the defaults if passed in.  Returns true
+ * if the new limits made sense and were applied, false otherwise.
+ */
+static inline bool
+xfs_setqlim_limits(
+	struct xfs_mount	*mp,
+	struct xfs_dquot_res	*res,
+	struct xfs_quota_limits	*qlim,
+	xfs_qcnt_t		hard,
+	xfs_qcnt_t		soft,
+	const char		*tag)
+{
+	/* The hard limit can't be less than the soft limit. */
+	if (hard != 0 && hard < soft) {
+		xfs_debug(mp, "%shard %lld < %ssoft %lld", tag, hard, tag,
+				soft);
+		return false;
+	}
+
+	res->hardlimit = hard;
+	res->softlimit = soft;
+	if (qlim) {
+		qlim->hard = hard;
+		qlim->soft = soft;
+	}
+
+	return true;
+}
+
+static inline void
+xfs_setqlim_warns(
+	struct xfs_dquot_res	*res,
+	struct xfs_quota_limits	*qlim,
+	int			warns)
+{
+	res->warnings = warns;
+	if (qlim)
+		qlim->warn = warns;
+}
+
+static inline void
+xfs_setqlim_timer(
+	struct xfs_dquot_res	*res,
+	struct xfs_quota_limits	*qlim,
+	s64			timer)
+{
+	res->timer = timer;
+	if (qlim)
+		qlim->time = timer;
+}
+
 /*
  * Adjust quota limits, and start/stop timers accordingly.
  */
@@ -450,6 +502,8 @@ xfs_qm_scall_setqlim(
 	struct xfs_dquot	*dqp;
 	struct xfs_trans	*tp;
 	struct xfs_def_quota	*defq;
+	struct xfs_dquot_res	*res;
+	struct xfs_quota_limits	*qlim;
 	int			error;
 	xfs_qcnt_t		hard, soft;
 
@@ -489,102 +543,70 @@ xfs_qm_scall_setqlim(
 	xfs_trans_dqjoin(tp, dqp);
 
 	/*
+	 * Update quota limits, warnings, and timers, and the defaults
+	 * if we're touching id == 0.
+	 *
 	 * Make sure that hardlimits are >= soft limits before changing.
+	 *
+	 * Update warnings counter(s) if requested.
+	 *
+	 * Timelimits for the super user set the relative time the other users
+	 * can be over quota for this file system. If it is zero a default is
+	 * used.  Ditto for the default soft and hard limit values (already
+	 * done, above), and for warnings.
+	 *
+	 * For other IDs, userspace can bump out the grace period if over
+	 * the soft limit.
 	 */
+
+	/* Blocks on the data device. */
 	hard = (newlim->d_fieldmask & QC_SPC_HARD) ?
 		(xfs_qcnt_t) XFS_B_TO_FSB(mp, newlim->d_spc_hardlimit) :
 			dqp->q_blk.hardlimit;
 	soft = (newlim->d_fieldmask & QC_SPC_SOFT) ?
 		(xfs_qcnt_t) XFS_B_TO_FSB(mp, newlim->d_spc_softlimit) :
 			dqp->q_blk.softlimit;
-	if (hard == 0 || hard >= soft) {
-		dqp->q_blk.hardlimit = hard;
-		dqp->q_blk.softlimit = soft;
+	res = &dqp->q_blk;
+	qlim = id == 0 ? &defq->blk : NULL;
+
+	if (xfs_setqlim_limits(mp, res, qlim, hard, soft, "blk"))
 		xfs_dquot_set_prealloc_limits(dqp);
-		if (id == 0) {
-			defq->blk.hard = hard;
-			defq->blk.soft = soft;
-		}
-	} else {
-		xfs_debug(mp, "blkhard %Ld < blksoft %Ld", hard, soft);
-	}
+	if (newlim->d_fieldmask & QC_SPC_WARNS)
+		xfs_setqlim_warns(res, qlim, newlim->d_spc_warns);
+	if (newlim->d_fieldmask & QC_SPC_TIMER)
+		xfs_setqlim_timer(res, qlim, newlim->d_spc_timer);
+
+	/* Blocks on the realtime device. */
 	hard = (newlim->d_fieldmask & QC_RT_SPC_HARD) ?
 		(xfs_qcnt_t) XFS_B_TO_FSB(mp, newlim->d_rt_spc_hardlimit) :
 			dqp->q_rtb.hardlimit;
 	soft = (newlim->d_fieldmask & QC_RT_SPC_SOFT) ?
 		(xfs_qcnt_t) XFS_B_TO_FSB(mp, newlim->d_rt_spc_softlimit) :
 			dqp->q_rtb.softlimit;
-	if (hard == 0 || hard >= soft) {
-		dqp->q_rtb.hardlimit = hard;
-		dqp->q_rtb.softlimit = soft;
-		if (id == 0) {
-			defq->rtb.hard = hard;
-			defq->rtb.soft = soft;
-		}
-	} else {
-		xfs_debug(mp, "rtbhard %Ld < rtbsoft %Ld", hard, soft);
-	}
+	res = &dqp->q_rtb;
+	qlim = id == 0 ? &defq->rtb : NULL;
 
+	xfs_setqlim_limits(mp, res, qlim, hard, soft, "rtb");
+	if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
+		xfs_setqlim_warns(res, qlim, newlim->d_rt_spc_warns);
+	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
+		xfs_setqlim_timer(res, qlim, newlim->d_rt_spc_timer);
+
+	/* Inodes */
 	hard = (newlim->d_fieldmask & QC_INO_HARD) ?
 		(xfs_qcnt_t) newlim->d_ino_hardlimit :
 			dqp->q_ino.hardlimit;
 	soft = (newlim->d_fieldmask & QC_INO_SOFT) ?
 		(xfs_qcnt_t) newlim->d_ino_softlimit :
 			dqp->q_ino.softlimit;
-	if (hard == 0 || hard >= soft) {
-		dqp->q_ino.hardlimit = hard;
-		dqp->q_ino.softlimit = soft;
-		if (id == 0) {
-			defq->ino.hard = hard;
-			defq->ino.soft = soft;
-		}
-	} else {
-		xfs_debug(mp, "ihard %Ld < isoft %Ld", hard, soft);
-	}
+	res = &dqp->q_ino;
+	qlim = id == 0 ? &defq->ino : NULL;
 
-	/*
-	 * Update warnings counter(s) if requested
-	 */
-	if (newlim->d_fieldmask & QC_SPC_WARNS)
-		dqp->q_blk.warnings = newlim->d_spc_warns;
+	xfs_setqlim_limits(mp, res, qlim, hard, soft, "ino");
 	if (newlim->d_fieldmask & QC_INO_WARNS)
-		dqp->q_ino.warnings = newlim->d_ino_warns;
-	if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
-		dqp->q_rtb.warnings = newlim->d_rt_spc_warns;
-
-	if (id == 0) {
-		if (newlim->d_fieldmask & QC_SPC_WARNS)
-			defq->blk.warn = newlim->d_spc_warns;
-		if (newlim->d_fieldmask & QC_INO_WARNS)
-			defq->ino.warn = newlim->d_ino_warns;
-		if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
-			defq->rtb.warn = newlim->d_rt_spc_warns;
-	}
-
-	/*
-	 * Timelimits for the super user set the relative time the other users
-	 * can be over quota for this file system. If it is zero a default is
-	 * used.  Ditto for the default soft and hard limit values (already
-	 * done, above), and for warnings.
-	 *
-	 * For other IDs, userspace can bump out the grace period if over
-	 * the soft limit.
-	 */
-	if (newlim->d_fieldmask & QC_SPC_TIMER)
-		dqp->q_blk.timer = newlim->d_spc_timer;
+		xfs_setqlim_warns(res, qlim, newlim->d_ino_warns);
 	if (newlim->d_fieldmask & QC_INO_TIMER)
-		dqp->q_ino.timer = newlim->d_ino_timer;
-	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
-		dqp->q_rtb.timer = newlim->d_rt_spc_timer;
-
-	if (id == 0) {
-		if (newlim->d_fieldmask & QC_SPC_TIMER)
-			defq->blk.time = newlim->d_spc_timer;
-		if (newlim->d_fieldmask & QC_INO_TIMER)
-			defq->ino.time = newlim->d_ino_timer;
-		if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
-			defq->rtb.time = newlim->d_rt_spc_timer;
-	}
+		xfs_setqlim_timer(res, qlim, newlim->d_ino_timer);
 
 	if (id != 0) {
 		/*

