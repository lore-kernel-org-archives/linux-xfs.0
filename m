Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C896C433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 416552071B
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:54:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WdvG7ot3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgGOByl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 21:54:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50032 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbgGOByl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 21:54:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1kvV0167692;
        Wed, 15 Jul 2020 01:52:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=RMIXIY4x3Gn/yrXCzbtFqTEqepSqpJPUEy/JNfuyP5w=;
 b=WdvG7ot3pfqT4aJu+VEWJZpyPbVGyddD9kPlh9b5oa6uxiGMGTu/A2ywMsZFC+34CL4L
 nFw9euPodGNMrUQzJjUTvZ1ai+ZYdmljTFgz1j5ZaKa52M3QxCmpdYVjdjZEWLrZra+N
 Uvu+DylepThYVRqWKZovj9RiNb4MV1/zWBeVYrvnzHCbpKgk8Htu997fS0hMu7jSw1Mb
 +4+7cWR4us9ECflDTqn9+OvCrfkd337wPJ6MZ4ZfSyy8T80s6JtSJGagqqmtiFROXpYk
 woKcOlwM1xoqM2ROrEeWVFsG8CsvSyZdFQVm+BwTzR8Svt2uVFEmFQqpPSEVTECHy6IU CA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3275cm8mqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 01:52:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1lbKe080770;
        Wed, 15 Jul 2020 01:52:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 327q0qa7c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 01:52:35 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06F1qYV5023907;
        Wed, 15 Jul 2020 01:52:34 GMT
Received: from localhost (/10.159.237.234)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 18:52:34 -0700
Subject: [PATCH 18/26] xfs: refactor default quota limits by resource
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 18:52:33 -0700
Message-ID: <159477795301.3263162.13200435441547133734.stgit@magnolia>
In-Reply-To: <159477783164.3263162.2564345443708779029.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150013
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

Now that we've split up the dquot resource fields into separate structs,
do the same for the default limits to enable further refactoring.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c       |   30 +++++++++++++++---------------
 fs/xfs/xfs_qm.c          |   36 ++++++++++++++++++------------------
 fs/xfs/xfs_qm.h          |   22 ++++++++++------------
 fs/xfs/xfs_qm_syscalls.c |   24 ++++++++++++------------
 fs/xfs/xfs_quotaops.c    |   12 ++++++------
 fs/xfs/xfs_trans_dquot.c |   18 +++++++++---------
 6 files changed, 70 insertions(+), 72 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 75b22560244e..8107bb094641 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -77,22 +77,22 @@ xfs_qm_adjust_dqlimits(
 	ASSERT(dq->q_id);
 	defq = xfs_get_defquota(q, dq->q_type);
 
-	if (defq->bsoftlimit && !dq->q_blk.softlimit) {
-		dq->q_blk.softlimit = defq->bsoftlimit;
+	if (defq->blk.soft && !dq->q_blk.softlimit) {
+		dq->q_blk.softlimit = defq->blk.soft;
 		prealloc = 1;
 	}
-	if (defq->bhardlimit && !dq->q_blk.hardlimit) {
-		dq->q_blk.hardlimit = defq->bhardlimit;
+	if (defq->blk.hard && !dq->q_blk.hardlimit) {
+		dq->q_blk.hardlimit = defq->blk.hard;
 		prealloc = 1;
 	}
-	if (defq->isoftlimit && !dq->q_ino.softlimit)
-		dq->q_ino.softlimit = defq->isoftlimit;
-	if (defq->ihardlimit && !dq->q_ino.hardlimit)
-		dq->q_ino.hardlimit = defq->ihardlimit;
-	if (defq->rtbsoftlimit && !dq->q_rtb.softlimit)
-		dq->q_rtb.softlimit = defq->rtbsoftlimit;
-	if (defq->rtbhardlimit && !dq->q_rtb.hardlimit)
-		dq->q_rtb.hardlimit = defq->rtbhardlimit;
+	if (defq->ino.soft && !dq->q_ino.softlimit)
+		dq->q_ino.softlimit = defq->ino.soft;
+	if (defq->ino.hard && !dq->q_ino.hardlimit)
+		dq->q_ino.hardlimit = defq->ino.hard;
+	if (defq->rtb.soft && !dq->q_rtb.softlimit)
+		dq->q_rtb.softlimit = defq->rtb.soft;
+	if (defq->rtb.hard && !dq->q_rtb.hardlimit)
+		dq->q_rtb.hardlimit = defq->rtb.hard;
 
 	if (prealloc)
 		xfs_dquot_set_prealloc_limits(dq);
@@ -137,7 +137,7 @@ xfs_qm_adjust_dqtimers(
 		    (dq->q_blk.hardlimit &&
 		     (dq->q_blk.count > dq->q_blk.hardlimit))) {
 			dq->q_blk.timer = ktime_get_real_seconds() +
-					defq->btimelimit;
+					defq->blk.time;
 		} else {
 			dq->q_blk.warnings = 0;
 		}
@@ -156,7 +156,7 @@ xfs_qm_adjust_dqtimers(
 		    (dq->q_ino.hardlimit &&
 		     (dq->q_ino.count > dq->q_ino.hardlimit))) {
 			dq->q_ino.timer = ktime_get_real_seconds() +
-					defq->itimelimit;
+					defq->ino.time;
 		} else {
 			dq->q_ino.warnings = 0;
 		}
@@ -175,7 +175,7 @@ xfs_qm_adjust_dqtimers(
 		    (dq->q_rtb.hardlimit &&
 		     (dq->q_rtb.count > dq->q_rtb.hardlimit))) {
 			dq->q_rtb.timer = ktime_get_real_seconds() +
-					defq->rtbtimelimit;
+					defq->rtb.time;
 		} else {
 			dq->q_rtb.warnings = 0;
 		}
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 4305bbcdb97d..6ebf5bed65a7 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -560,12 +560,12 @@ xfs_qm_set_defquota(
 	 * Timers and warnings have been already set, let's just set the
 	 * default limits for this quota type
 	 */
-	defq->bhardlimit = dqp->q_blk.hardlimit;
-	defq->bsoftlimit = dqp->q_blk.softlimit;
-	defq->ihardlimit = dqp->q_ino.hardlimit;
-	defq->isoftlimit = dqp->q_ino.softlimit;
-	defq->rtbhardlimit = dqp->q_rtb.hardlimit;
-	defq->rtbsoftlimit = dqp->q_rtb.softlimit;
+	defq->blk.hard = dqp->q_blk.hardlimit;
+	defq->blk.soft = dqp->q_blk.softlimit;
+	defq->ino.hard = dqp->q_ino.hardlimit;
+	defq->ino.soft = dqp->q_ino.softlimit;
+	defq->rtb.hard = dqp->q_rtb.hardlimit;
+	defq->rtb.soft = dqp->q_rtb.softlimit;
 	xfs_qm_dqdestroy(dqp);
 }
 
@@ -582,12 +582,12 @@ xfs_qm_init_timelimits(
 
 	defq = xfs_get_defquota(qinf, type);
 
-	defq->btimelimit = XFS_QM_BTIMELIMIT;
-	defq->itimelimit = XFS_QM_ITIMELIMIT;
-	defq->rtbtimelimit = XFS_QM_RTBTIMELIMIT;
-	defq->bwarnlimit = XFS_QM_BWARNLIMIT;
-	defq->iwarnlimit = XFS_QM_IWARNLIMIT;
-	defq->rtbwarnlimit = XFS_QM_RTBWARNLIMIT;
+	defq->blk.time = XFS_QM_BTIMELIMIT;
+	defq->ino.time = XFS_QM_ITIMELIMIT;
+	defq->rtb.time = XFS_QM_RTBTIMELIMIT;
+	defq->blk.warn = XFS_QM_BWARNLIMIT;
+	defq->ino.warn = XFS_QM_IWARNLIMIT;
+	defq->rtb.warn = XFS_QM_RTBWARNLIMIT;
 
 	/*
 	 * We try to get the limits from the superuser's limits fields.
@@ -606,17 +606,17 @@ xfs_qm_init_timelimits(
 	 * more writing. If it is zero, a default is used.
 	 */
 	if (dqp->q_blk.timer)
-		defq->btimelimit = dqp->q_blk.timer;
+		defq->blk.time = dqp->q_blk.timer;
 	if (dqp->q_ino.timer)
-		defq->itimelimit = dqp->q_ino.timer;
+		defq->ino.time = dqp->q_ino.timer;
 	if (dqp->q_rtb.timer)
-		defq->rtbtimelimit = dqp->q_rtb.timer;
+		defq->rtb.time = dqp->q_rtb.timer;
 	if (dqp->q_blk.warnings)
-		defq->bwarnlimit = dqp->q_blk.warnings;
+		defq->blk.warn = dqp->q_blk.warnings;
 	if (dqp->q_ino.warnings)
-		defq->iwarnlimit = dqp->q_ino.warnings;
+		defq->ino.warn = dqp->q_ino.warnings;
 	if (dqp->q_rtb.warnings)
-		defq->rtbwarnlimit = dqp->q_rtb.warnings;
+		defq->rtb.warn = dqp->q_rtb.warnings;
 
 	xfs_qm_dqdestroy(dqp);
 }
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 0e4ceb0dcfbc..9c078c35d924 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -30,20 +30,18 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
 	!dqp->q_rtb.count && \
 	!dqp->q_ino.count)
 
+struct xfs_quota_limits {
+	xfs_qcnt_t		hard;	/* default hard limit */
+	xfs_qcnt_t		soft;	/* default soft limit */
+	time64_t		time;	/* limit for timers */
+	xfs_qwarncnt_t		warn;	/* limit for warnings */
+};
+
 /* Defaults for each quota type: time limits, warn limits, usage limits */
 struct xfs_def_quota {
-	time64_t	btimelimit;	/* limit for blks timer */
-	time64_t	itimelimit;	/* limit for inodes timer */
-	time64_t	rtbtimelimit;	/* limit for rt blks timer */
-	xfs_qwarncnt_t	bwarnlimit;	/* limit for blks warnings */
-	xfs_qwarncnt_t	iwarnlimit;	/* limit for inodes warnings */
-	xfs_qwarncnt_t	rtbwarnlimit;	/* limit for rt blks warnings */
-	xfs_qcnt_t	bhardlimit;	/* default data blk hard limit */
-	xfs_qcnt_t	bsoftlimit;	/* default data blk soft limit */
-	xfs_qcnt_t	ihardlimit;	/* default inode count hard limit */
-	xfs_qcnt_t	isoftlimit;	/* default inode count soft limit */
-	xfs_qcnt_t	rtbhardlimit;	/* default realtime blk hard limit */
-	xfs_qcnt_t	rtbsoftlimit;	/* default realtime blk soft limit */
+	struct xfs_quota_limits	blk;
+	struct xfs_quota_limits	ino;
+	struct xfs_quota_limits	rtb;
 };
 
 /*
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 3bb844317d02..b0c932086d59 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -502,8 +502,8 @@ xfs_qm_scall_setqlim(
 		dqp->q_blk.softlimit = soft;
 		xfs_dquot_set_prealloc_limits(dqp);
 		if (id == 0) {
-			defq->bhardlimit = hard;
-			defq->bsoftlimit = soft;
+			defq->blk.hard = hard;
+			defq->blk.soft = soft;
 		}
 	} else {
 		xfs_debug(mp, "blkhard %Ld < blksoft %Ld", hard, soft);
@@ -518,8 +518,8 @@ xfs_qm_scall_setqlim(
 		dqp->q_rtb.hardlimit = hard;
 		dqp->q_rtb.softlimit = soft;
 		if (id == 0) {
-			defq->rtbhardlimit = hard;
-			defq->rtbsoftlimit = soft;
+			defq->rtb.hard = hard;
+			defq->rtb.soft = soft;
 		}
 	} else {
 		xfs_debug(mp, "rtbhard %Ld < rtbsoft %Ld", hard, soft);
@@ -535,8 +535,8 @@ xfs_qm_scall_setqlim(
 		dqp->q_ino.hardlimit = hard;
 		dqp->q_ino.softlimit = soft;
 		if (id == 0) {
-			defq->ihardlimit = hard;
-			defq->isoftlimit = soft;
+			defq->ino.hard = hard;
+			defq->ino.soft = soft;
 		}
 	} else {
 		xfs_debug(mp, "ihard %Ld < isoft %Ld", hard, soft);
@@ -554,11 +554,11 @@ xfs_qm_scall_setqlim(
 
 	if (id == 0) {
 		if (newlim->d_fieldmask & QC_SPC_WARNS)
-			defq->bwarnlimit = newlim->d_spc_warns;
+			defq->blk.warn = newlim->d_spc_warns;
 		if (newlim->d_fieldmask & QC_INO_WARNS)
-			defq->iwarnlimit = newlim->d_ino_warns;
+			defq->ino.warn = newlim->d_ino_warns;
 		if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
-			defq->rtbwarnlimit = newlim->d_rt_spc_warns;
+			defq->rtb.warn = newlim->d_rt_spc_warns;
 	}
 
 	/*
@@ -579,11 +579,11 @@ xfs_qm_scall_setqlim(
 
 	if (id == 0) {
 		if (newlim->d_fieldmask & QC_SPC_TIMER)
-			defq->btimelimit = newlim->d_spc_timer;
+			defq->blk.time = newlim->d_spc_timer;
 		if (newlim->d_fieldmask & QC_INO_TIMER)
-			defq->itimelimit = newlim->d_ino_timer;
+			defq->ino.time = newlim->d_ino_timer;
 		if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
-			defq->rtbtimelimit = newlim->d_rt_spc_timer;
+			defq->rtb.time = newlim->d_rt_spc_timer;
 	}
 
 	if (id != 0) {
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 963c253558b3..d27c0e852c0b 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -37,12 +37,12 @@ xfs_qm_fill_state(
 	tstate->flags |= QCI_SYSFILE;
 	tstate->blocks = ip->i_d.di_nblocks;
 	tstate->nextents = ip->i_df.if_nextents;
-	tstate->spc_timelimit = (u32)defq->btimelimit;
-	tstate->ino_timelimit = (u32)defq->itimelimit;
-	tstate->rt_spc_timelimit = (u32)defq->rtbtimelimit;
-	tstate->spc_warnlimit = defq->bwarnlimit;
-	tstate->ino_warnlimit = defq->iwarnlimit;
-	tstate->rt_spc_warnlimit = defq->rtbwarnlimit;
+	tstate->spc_timelimit = (u32)defq->blk.time;
+	tstate->ino_timelimit = (u32)defq->ino.time;
+	tstate->rt_spc_timelimit = (u32)defq->rtb.time;
+	tstate->spc_warnlimit = defq->blk.warn;
+	tstate->ino_warnlimit = defq->ino.warn;
+	tstate->rt_spc_warnlimit = defq->rtb.warn;
 	if (tempqip)
 		xfs_irele(ip);
 }
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 71f771c2fb34..f08d37747e7e 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -594,25 +594,25 @@ xfs_trans_dqresv(
 	if (flags & XFS_TRANS_DQ_RES_BLKS) {
 		hardlimit = dqp->q_blk.hardlimit;
 		if (!hardlimit)
-			hardlimit = defq->bhardlimit;
+			hardlimit = defq->blk.hard;
 		softlimit = dqp->q_blk.softlimit;
 		if (!softlimit)
-			softlimit = defq->bsoftlimit;
+			softlimit = defq->blk.soft;
 		timer = dqp->q_blk.timer;
 		warns = dqp->q_blk.warnings;
-		warnlimit = defq->bwarnlimit;
+		warnlimit = defq->blk.warn;
 		resbcountp = &dqp->q_blk.reserved;
 	} else {
 		ASSERT(flags & XFS_TRANS_DQ_RES_RTBLKS);
 		hardlimit = dqp->q_rtb.hardlimit;
 		if (!hardlimit)
-			hardlimit = defq->rtbhardlimit;
+			hardlimit = defq->rtb.hard;
 		softlimit = dqp->q_rtb.softlimit;
 		if (!softlimit)
-			softlimit = defq->rtbsoftlimit;
+			softlimit = defq->rtb.soft;
 		timer = dqp->q_rtb.timer;
 		warns = dqp->q_rtb.warnings;
-		warnlimit = defq->rtbwarnlimit;
+		warnlimit = defq->rtb.warn;
 		resbcountp = &dqp->q_rtb.reserved;
 	}
 
@@ -647,13 +647,13 @@ xfs_trans_dqresv(
 			total_count = dqp->q_ino.reserved + ninos;
 			timer = dqp->q_ino.timer;
 			warns = dqp->q_ino.warnings;
-			warnlimit = defq->iwarnlimit;
+			warnlimit = defq->ino.warn;
 			hardlimit = dqp->q_ino.hardlimit;
 			if (!hardlimit)
-				hardlimit = defq->ihardlimit;
+				hardlimit = defq->ino.hard;
 			softlimit = dqp->q_ino.softlimit;
 			if (!softlimit)
-				softlimit = defq->isoftlimit;
+				softlimit = defq->ino.soft;
 
 			if (hardlimit && total_count > hardlimit) {
 				xfs_quota_warn(mp, dqp, QUOTA_NL_IHARDWARN);

