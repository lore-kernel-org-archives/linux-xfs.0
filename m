Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF78C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0838C20674
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:56:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EQ5bLDLg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgGOB41 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 21:56:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51058 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgGOB41 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 21:56:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1lgAw167855;
        Wed, 15 Jul 2020 01:54:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ksk8V6qaq8it+oTodcYBaoiPicNE120kKzdCpVo2TUE=;
 b=EQ5bLDLgIHKgeTyEmsUKmNxxPqeZUPraim/TDsGOxxvMMExhjffP0qVBYROcA0JAAbBL
 oXR5OOdrkF7hHmvOoYbGRyHPSzn/p5FBd1R56y5hnBWRt5ZJhXS9I4PgkEnYAu8ADaGt
 LnZBxKQM+RzMY7XxD1+6Eeidgrn/UfyW7PrjnpzOGMcAA2FNk0euaAFSdik5urnfYC5X
 yx+J9ngFllkeESSYxkjCZKPQnCTROoE+7l+RuJxVmRlq0wzVoFj5nykE1E5DcqRiwAZd
 jHxqIlRe6OfhguVr+Bsg2m1bA0lCsNfb+gVUvKmn5YmeQwVHzktIaHikhphwMVjbIW/+ aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3275cm8muw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 01:54:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1lbN3125388;
        Wed, 15 Jul 2020 01:52:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 327q6tegj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 01:52:22 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06F1qLbl018919;
        Wed, 15 Jul 2020 01:52:21 GMT
Received: from localhost (/10.159.237.234)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 18:52:21 -0700
Subject: [PATCH 16/26] xfs: stop using q_core timers in the quota code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 18:52:20 -0700
Message-ID: <159477794006.3263162.13868334199685757765.stgit@magnolia>
In-Reply-To: <159477783164.3263162.2564345443708779029.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150013
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add timers fields to the incore dquot, and use that instead of the ones
in qcore.  This eliminates a bunch of endian conversions and will
eventually allow us to remove qcore entirely.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/xfs_dquot.c       |   41 +++++++++++++++++++++++------------------
 fs/xfs/xfs_dquot.h       |    7 +++++++
 fs/xfs/xfs_qm.c          |   15 ++++++---------
 fs/xfs/xfs_qm_syscalls.c |   18 ++++++++----------
 fs/xfs/xfs_trans_dquot.c |    6 +++---
 5 files changed, 47 insertions(+), 40 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index db9473b49cc0..ad17ce622805 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -117,7 +117,6 @@ xfs_qm_adjust_dqtimers(
 	struct xfs_dquot	*dq)
 {
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
-	struct xfs_disk_dquot	*d = &dq->q_core;
 	struct xfs_def_quota	*defq;
 
 	ASSERT(dq->q_id);
@@ -132,13 +131,13 @@ xfs_qm_adjust_dqtimers(
 		ASSERT(dq->q_rtb.softlimit <= dq->q_rtb.hardlimit);
 #endif
 
-	if (!d->d_btimer) {
+	if (!dq->q_blk.timer) {
 		if ((dq->q_blk.softlimit &&
 		     (dq->q_blk.count > dq->q_blk.softlimit)) ||
 		    (dq->q_blk.hardlimit &&
 		     (dq->q_blk.count > dq->q_blk.hardlimit))) {
-			d->d_btimer = cpu_to_be32(ktime_get_real_seconds() +
-					defq->btimelimit);
+			dq->q_blk.timer = ktime_get_real_seconds() +
+					defq->btimelimit;
 		} else {
 			dq->q_blk.warnings = 0;
 		}
@@ -147,17 +146,17 @@ xfs_qm_adjust_dqtimers(
 		     (dq->q_blk.count <= dq->q_blk.softlimit)) &&
 		    (!dq->q_blk.hardlimit ||
 		    (dq->q_blk.count <= dq->q_blk.hardlimit))) {
-			d->d_btimer = 0;
+			dq->q_blk.timer = 0;
 		}
 	}
 
-	if (!d->d_itimer) {
+	if (!dq->q_ino.timer) {
 		if ((dq->q_ino.softlimit &&
 		     (dq->q_ino.count > dq->q_ino.softlimit)) ||
 		    (dq->q_ino.hardlimit &&
 		     (dq->q_ino.count > dq->q_ino.hardlimit))) {
-			d->d_itimer = cpu_to_be32(ktime_get_real_seconds() +
-					defq->itimelimit);
+			dq->q_ino.timer = ktime_get_real_seconds() +
+					defq->itimelimit;
 		} else {
 			dq->q_ino.warnings = 0;
 		}
@@ -166,17 +165,17 @@ xfs_qm_adjust_dqtimers(
 		     (dq->q_ino.count <= dq->q_ino.softlimit))  &&
 		    (!dq->q_ino.hardlimit ||
 		     (dq->q_ino.count <= dq->q_ino.hardlimit))) {
-			d->d_itimer = 0;
+			dq->q_ino.timer = 0;
 		}
 	}
 
-	if (!d->d_rtbtimer) {
+	if (!dq->q_rtb.timer) {
 		if ((dq->q_rtb.softlimit &&
 		     (dq->q_rtb.count > dq->q_rtb.softlimit)) ||
 		    (dq->q_rtb.hardlimit &&
 		     (dq->q_rtb.count > dq->q_rtb.hardlimit))) {
-			d->d_rtbtimer = cpu_to_be32(ktime_get_real_seconds() +
-					defq->rtbtimelimit);
+			dq->q_rtb.timer = ktime_get_real_seconds() +
+					defq->rtbtimelimit;
 		} else {
 			dq->q_rtb.warnings = 0;
 		}
@@ -185,7 +184,7 @@ xfs_qm_adjust_dqtimers(
 		     (dq->q_rtb.count <= dq->q_rtb.softlimit)) &&
 		    (!dq->q_rtb.hardlimit ||
 		     (dq->q_rtb.count <= dq->q_rtb.hardlimit))) {
-			d->d_rtbtimer = 0;
+			dq->q_rtb.timer = 0;
 		}
 	}
 }
@@ -552,6 +551,10 @@ xfs_dquot_from_disk(
 	dqp->q_ino.warnings = be16_to_cpu(ddqp->d_iwarns);
 	dqp->q_rtb.warnings = be16_to_cpu(ddqp->d_rtbwarns);
 
+	dqp->q_blk.timer = be32_to_cpu(ddqp->d_btimer);
+	dqp->q_ino.timer = be32_to_cpu(ddqp->d_itimer);
+	dqp->q_rtb.timer = be32_to_cpu(ddqp->d_rtbtimer);
+
 	/*
 	 * Reservation counters are defined as reservation plus current usage
 	 * to avoid having to add every time.
@@ -586,6 +589,10 @@ xfs_dquot_to_disk(
 	ddqp->d_bwarns = cpu_to_be16(dqp->q_blk.warnings);
 	ddqp->d_iwarns = cpu_to_be16(dqp->q_ino.warnings);
 	ddqp->d_rtbwarns = cpu_to_be16(dqp->q_rtb.warnings);
+
+	ddqp->d_btimer = cpu_to_be32(dqp->q_blk.timer);
+	ddqp->d_itimer = cpu_to_be32(dqp->q_ino.timer);
+	ddqp->d_rtbtimer = cpu_to_be32(dqp->q_rtb.timer);
 }
 
 /* Allocate and initialize the dquot buffer for this in-core dquot. */
@@ -1147,8 +1154,6 @@ static xfs_failaddr_t
 xfs_qm_dqflush_check(
 	struct xfs_dquot	*dqp)
 {
-	struct xfs_disk_dquot	*ddq = &dqp->q_core;
-
 	if (dqp->q_type != XFS_DQTYPE_USER &&
 	    dqp->q_type != XFS_DQTYPE_GROUP &&
 	    dqp->q_type != XFS_DQTYPE_PROJ)
@@ -1158,15 +1163,15 @@ xfs_qm_dqflush_check(
 		return NULL;
 
 	if (dqp->q_blk.softlimit && dqp->q_blk.count > dqp->q_blk.softlimit &&
-	    !ddq->d_btimer)
+	    !dqp->q_blk.timer)
 		return __this_address;
 
 	if (dqp->q_ino.softlimit && dqp->q_ino.count > dqp->q_ino.softlimit &&
-	    !ddq->d_itimer)
+	    !dqp->q_ino.timer)
 		return __this_address;
 
 	if (dqp->q_rtb.softlimit && dqp->q_rtb.count > dqp->q_rtb.softlimit &&
-	    !ddq->d_rtbtimer)
+	    !dqp->q_rtb.timer)
 		return __this_address;
 
 	return NULL;
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 4c6460637e55..6ad89ccb80c0 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -38,6 +38,13 @@ struct xfs_dquot_res {
 	xfs_qcnt_t		hardlimit;
 	xfs_qcnt_t		softlimit;
 
+	/*
+	 * For root dquots, this is the default grace period, in seconds.
+	 * Otherwise, this is when the quota grace period expires,
+	 * in seconds since the Unix epoch.
+	 */
+	time64_t		timer;
+
 	/*
 	 * For root dquots, this is the maximum number of warnings that will
 	 * be issued for this quota type.  Otherwise, this is the number of
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index bc3182ef9564..4305bbcdb97d 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -577,7 +577,6 @@ xfs_qm_init_timelimits(
 {
 	struct xfs_quotainfo	*qinf = mp->m_quotainfo;
 	struct xfs_def_quota	*defq;
-	struct xfs_disk_dquot	*ddqp;
 	struct xfs_dquot	*dqp;
 	int			error;
 
@@ -601,19 +600,17 @@ xfs_qm_init_timelimits(
 	if (error)
 		return;
 
-	ddqp = &dqp->q_core;
-
 	/*
 	 * The warnings and timers set the grace period given to
 	 * a user or group before he or she can not perform any
 	 * more writing. If it is zero, a default is used.
 	 */
-	if (ddqp->d_btimer)
-		defq->btimelimit = be32_to_cpu(ddqp->d_btimer);
-	if (ddqp->d_itimer)
-		defq->itimelimit = be32_to_cpu(ddqp->d_itimer);
-	if (ddqp->d_rtbtimer)
-		defq->rtbtimelimit = be32_to_cpu(ddqp->d_rtbtimer);
+	if (dqp->q_blk.timer)
+		defq->btimelimit = dqp->q_blk.timer;
+	if (dqp->q_ino.timer)
+		defq->itimelimit = dqp->q_ino.timer;
+	if (dqp->q_rtb.timer)
+		defq->rtbtimelimit = dqp->q_rtb.timer;
 	if (dqp->q_blk.warnings)
 		defq->bwarnlimit = dqp->q_blk.warnings;
 	if (dqp->q_ino.warnings)
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 4352169b644c..3bb844317d02 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -447,7 +447,6 @@ xfs_qm_scall_setqlim(
 	struct qc_dqblk		*newlim)
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	struct xfs_disk_dquot	*ddq;
 	struct xfs_dquot	*dqp;
 	struct xfs_trans	*tp;
 	struct xfs_def_quota	*defq;
@@ -488,7 +487,6 @@ xfs_qm_scall_setqlim(
 
 	xfs_dqlock(dqp);
 	xfs_trans_dqjoin(tp, dqp);
-	ddq = &dqp->q_core;
 
 	/*
 	 * Make sure that hardlimits are >= soft limits before changing.
@@ -573,11 +571,11 @@ xfs_qm_scall_setqlim(
 	 * the soft limit.
 	 */
 	if (newlim->d_fieldmask & QC_SPC_TIMER)
-		ddq->d_btimer = cpu_to_be32(newlim->d_spc_timer);
+		dqp->q_blk.timer = newlim->d_spc_timer;
 	if (newlim->d_fieldmask & QC_INO_TIMER)
-		ddq->d_itimer = cpu_to_be32(newlim->d_ino_timer);
+		dqp->q_ino.timer = newlim->d_ino_timer;
 	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
-		ddq->d_rtbtimer = cpu_to_be32(newlim->d_rt_spc_timer);
+		dqp->q_rtb.timer = newlim->d_rt_spc_timer;
 
 	if (id == 0) {
 		if (newlim->d_fieldmask & QC_SPC_TIMER)
@@ -621,18 +619,18 @@ xfs_qm_scall_getquota_fill_qc(
 	memset(dst, 0, sizeof(*dst));
 	dst->d_spc_hardlimit = XFS_FSB_TO_B(mp, dqp->q_blk.hardlimit);
 	dst->d_spc_softlimit = XFS_FSB_TO_B(mp, dqp->q_blk.softlimit);
-	dst->d_ino_hardlimit = be64_to_cpu(dqp->q_core.d_ino_hardlimit);
-	dst->d_ino_softlimit = be64_to_cpu(dqp->q_core.d_ino_softlimit);
+	dst->d_ino_hardlimit = dqp->q_ino.hardlimit;
+	dst->d_ino_softlimit = dqp->q_ino.softlimit;
 	dst->d_space = XFS_FSB_TO_B(mp, dqp->q_blk.reserved);
 	dst->d_ino_count = dqp->q_ino.reserved;
-	dst->d_spc_timer = be32_to_cpu(dqp->q_core.d_btimer);
-	dst->d_ino_timer = be32_to_cpu(dqp->q_core.d_itimer);
+	dst->d_spc_timer = dqp->q_blk.timer;
+	dst->d_ino_timer = dqp->q_ino.timer;
 	dst->d_ino_warns = dqp->q_ino.warnings;
 	dst->d_spc_warns = dqp->q_blk.warnings;
 	dst->d_rt_spc_hardlimit = XFS_FSB_TO_B(mp, dqp->q_rtb.hardlimit);
 	dst->d_rt_spc_softlimit = XFS_FSB_TO_B(mp, dqp->q_rtb.softlimit);
 	dst->d_rt_space = XFS_FSB_TO_B(mp, dqp->q_rtb.reserved);
-	dst->d_rt_spc_timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
+	dst->d_rt_spc_timer = dqp->q_rtb.timer;
 	dst->d_rt_spc_warns = dqp->q_rtb.warnings;
 
 	/*
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 995636a63685..71f771c2fb34 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -598,7 +598,7 @@ xfs_trans_dqresv(
 		softlimit = dqp->q_blk.softlimit;
 		if (!softlimit)
 			softlimit = defq->bsoftlimit;
-		timer = be32_to_cpu(dqp->q_core.d_btimer);
+		timer = dqp->q_blk.timer;
 		warns = dqp->q_blk.warnings;
 		warnlimit = defq->bwarnlimit;
 		resbcountp = &dqp->q_blk.reserved;
@@ -610,7 +610,7 @@ xfs_trans_dqresv(
 		softlimit = dqp->q_rtb.softlimit;
 		if (!softlimit)
 			softlimit = defq->rtbsoftlimit;
-		timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
+		timer = dqp->q_rtb.timer;
 		warns = dqp->q_rtb.warnings;
 		warnlimit = defq->rtbwarnlimit;
 		resbcountp = &dqp->q_rtb.reserved;
@@ -645,7 +645,7 @@ xfs_trans_dqresv(
 		}
 		if (ninos > 0) {
 			total_count = dqp->q_ino.reserved + ninos;
-			timer = be32_to_cpu(dqp->q_core.d_itimer);
+			timer = dqp->q_ino.timer;
 			warns = dqp->q_ino.warnings;
 			warnlimit = defq->iwarnlimit;
 			hardlimit = dqp->q_ino.hardlimit;

