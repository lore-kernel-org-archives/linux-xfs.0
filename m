Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9463DC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DDB62074F
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:43:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FwDpl9pe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389649AbgF3PnN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 11:43:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56310 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389647AbgF3PnM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 11:43:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFRVdX109751
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=SQajqvOxRhO8NuMJG7U82NrUR3v+rzmTFj6LCN8kSJ0=;
 b=FwDpl9peCi20ARxf4MB63MShprtVtFUIl25qqTYajVZ0plCzKJV46Edtqd8aq1muMRt/
 bhQjLZodXIVBwmv/pGcunmb6/RHTey0X/4pxhlj37AtnIZBivrtKAjce8W4iCMDZyN6x
 iGruzMI754eiT3YrHSxmWIHp9De4cQrORUwhdxQv0jeGx4maZNXt+VmhGRDYNsbQUlMK
 MnJ7rcyiJdaA1la89aGuZMtiKmM6VJNL8HEZj/O04TnYFkNKUZP2iTO6CMGbYHWW/h/F
 /Y6y3HPTav6mp9YOIHclakrCKPbY14pjy30sLxFl09BzDjsZ5F4YGg96uhmWqZS0UNtH WA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31ywrbkjha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFgpeN153793
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31y52j35um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:09 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05UFh8jH018677
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 15:43:08 +0000
Subject: [PATCH 12/18] xfs: refactor default quota limits by resource
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 30 Jun 2020 08:43:07 -0700
Message-ID: <159353178739.2864738.11605071453935920102.stgit@magnolia>
In-Reply-To: <159353170983.2864738.16885438169173786208.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=1 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300112
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we've split up the dquot resource fields into separate structs,
do the same for the default limits to enable further refactoring.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c       |   30 +++++++++++++++---------------
 fs/xfs/xfs_qm.c          |   36 ++++++++++++++++++------------------
 fs/xfs/xfs_qm.h          |   22 ++++++++++------------
 fs/xfs/xfs_qm_syscalls.c |   24 ++++++++++++------------
 fs/xfs/xfs_quotaops.c    |   12 ++++++------
 fs/xfs/xfs_trans_dquot.c |   18 +++++++++---------
 6 files changed, 70 insertions(+), 72 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 2d6b50760962..6975c27145fc 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -76,22 +76,22 @@ xfs_qm_adjust_dqlimits(
 	ASSERT(dq->q_id);
 	defq = xfs_get_defquota(q, xfs_dquot_type(dq));
 
-	if (defq->bsoftlimit && !dq->q_blk.softlimit) {
-		dq->q_blk.softlimit = defq->bsoftlimit;
+	if (defq->dfq_blk.softlimit && !dq->q_blk.softlimit) {
+		dq->q_blk.softlimit = defq->dfq_blk.softlimit;
 		prealloc = 1;
 	}
-	if (defq->bhardlimit && !dq->q_blk.hardlimit) {
-		dq->q_blk.hardlimit = defq->bhardlimit;
+	if (defq->dfq_blk.hardlimit && !dq->q_blk.hardlimit) {
+		dq->q_blk.hardlimit = defq->dfq_blk.hardlimit;
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
+	if (defq->dfq_ino.softlimit && !dq->q_ino.softlimit)
+		dq->q_ino.softlimit = defq->dfq_ino.softlimit;
+	if (defq->dfq_ino.hardlimit && !dq->q_ino.hardlimit)
+		dq->q_ino.hardlimit = defq->dfq_ino.hardlimit;
+	if (defq->dfq_rtb.softlimit && !dq->q_rtb.softlimit)
+		dq->q_rtb.softlimit = defq->dfq_rtb.softlimit;
+	if (defq->dfq_rtb.hardlimit && !dq->q_rtb.hardlimit)
+		dq->q_rtb.hardlimit = defq->dfq_rtb.hardlimit;
 
 	if (prealloc)
 		xfs_dquot_set_prealloc_limits(dq);
@@ -136,7 +136,7 @@ xfs_qm_adjust_dqtimers(
 		    (dq->q_blk.hardlimit &&
 		     (dq->q_blk.count > dq->q_blk.hardlimit))) {
 			dq->q_blk.timer = ktime_get_real_seconds() +
-					defq->btimelimit;
+					defq->dfq_blk.timelimit;
 		} else {
 			dq->q_blk.warnings = 0;
 		}
@@ -155,7 +155,7 @@ xfs_qm_adjust_dqtimers(
 		    (dq->q_ino.hardlimit &&
 		     (dq->q_ino.count > dq->q_ino.hardlimit))) {
 			dq->q_ino.timer = ktime_get_real_seconds() +
-					defq->itimelimit;
+					defq->dfq_ino.timelimit;
 		} else {
 			dq->q_ino.warnings = 0;
 		}
@@ -174,7 +174,7 @@ xfs_qm_adjust_dqtimers(
 		    (dq->q_rtb.hardlimit &&
 		     (dq->q_rtb.count > dq->q_rtb.hardlimit))) {
 			dq->q_rtb.timer = ktime_get_real_seconds() +
-					defq->rtbtimelimit;
+					defq->dfq_rtb.timelimit;
 		} else {
 			dq->q_rtb.warnings = 0;
 		}
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index a56c6e4a5d99..28326a6264a8 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -562,12 +562,12 @@ xfs_qm_set_defquota(
 	 * Timers and warnings have been already set, let's just set the
 	 * default limits for this quota type
 	 */
-	defq->bhardlimit = dqp->q_blk.hardlimit;
-	defq->bsoftlimit = dqp->q_blk.softlimit;
-	defq->ihardlimit = dqp->q_ino.hardlimit;
-	defq->isoftlimit = dqp->q_ino.softlimit;
-	defq->rtbhardlimit = dqp->q_rtb.hardlimit;
-	defq->rtbsoftlimit = dqp->q_rtb.softlimit;
+	defq->dfq_blk.hardlimit = dqp->q_blk.hardlimit;
+	defq->dfq_blk.softlimit = dqp->q_blk.softlimit;
+	defq->dfq_ino.hardlimit = dqp->q_ino.hardlimit;
+	defq->dfq_ino.softlimit = dqp->q_ino.softlimit;
+	defq->dfq_rtb.hardlimit = dqp->q_rtb.hardlimit;
+	defq->dfq_rtb.softlimit = dqp->q_rtb.softlimit;
 	xfs_qm_dqdestroy(dqp);
 }
 
@@ -584,12 +584,12 @@ xfs_qm_init_timelimits(
 
 	defq = xfs_get_defquota(qinf, type);
 
-	defq->btimelimit = XFS_QM_BTIMELIMIT;
-	defq->itimelimit = XFS_QM_ITIMELIMIT;
-	defq->rtbtimelimit = XFS_QM_RTBTIMELIMIT;
-	defq->bwarnlimit = XFS_QM_BWARNLIMIT;
-	defq->iwarnlimit = XFS_QM_IWARNLIMIT;
-	defq->rtbwarnlimit = XFS_QM_RTBWARNLIMIT;
+	defq->dfq_blk.timelimit = XFS_QM_BTIMELIMIT;
+	defq->dfq_ino.timelimit = XFS_QM_ITIMELIMIT;
+	defq->dfq_rtb.timelimit = XFS_QM_RTBTIMELIMIT;
+	defq->dfq_blk.warnlimit = XFS_QM_BWARNLIMIT;
+	defq->dfq_ino.warnlimit = XFS_QM_IWARNLIMIT;
+	defq->dfq_rtb.warnlimit = XFS_QM_RTBWARNLIMIT;
 
 	/*
 	 * We try to get the limits from the superuser's limits fields.
@@ -608,17 +608,17 @@ xfs_qm_init_timelimits(
 	 * more writing. If it is zero, a default is used.
 	 */
 	if (dqp->q_blk.timer)
-		defq->btimelimit = dqp->q_blk.timer;
+		defq->dfq_blk.timelimit = dqp->q_blk.timer;
 	if (dqp->q_ino.timer)
-		defq->itimelimit = dqp->q_ino.timer;
+		defq->dfq_ino.timelimit = dqp->q_ino.timer;
 	if (dqp->q_rtb.timer)
-		defq->rtbtimelimit = dqp->q_rtb.timer;
+		defq->dfq_rtb.timelimit = dqp->q_rtb.timer;
 	if (dqp->q_blk.warnings)
-		defq->bwarnlimit = dqp->q_blk.warnings;
+		defq->dfq_blk.warnlimit = dqp->q_blk.warnings;
 	if (dqp->q_ino.warnings)
-		defq->iwarnlimit = dqp->q_ino.warnings;
+		defq->dfq_ino.warnlimit = dqp->q_ino.warnings;
 	if (dqp->q_rtb.warnings)
-		defq->rtbwarnlimit = dqp->q_rtb.warnings;
+		defq->dfq_rtb.warnlimit = dqp->q_rtb.warnings;
 
 	xfs_qm_dqdestroy(dqp);
 }
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 6ed4ae942603..e2f0027f0ac1 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -41,20 +41,18 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
  */
 #define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
 
+struct xfs_def_qres {
+	xfs_qcnt_t		hardlimit;	/* default hard limit */
+	xfs_qcnt_t		softlimit;	/* default soft limit */
+	time64_t		timelimit;	/* limit for timers */
+	xfs_qwarncnt_t		warnlimit;	/* limit for warnings */
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
+	struct xfs_def_qres	dfq_blk;
+	struct xfs_def_qres	dfq_ino;
+	struct xfs_def_qres	dfq_rtb;
 };
 
 /*
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 1b2b70b1660f..393b88612cc8 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -502,8 +502,8 @@ xfs_qm_scall_setqlim(
 		dqp->q_blk.softlimit = soft;
 		xfs_dquot_set_prealloc_limits(dqp);
 		if (id == 0) {
-			defq->bhardlimit = hard;
-			defq->bsoftlimit = soft;
+			defq->dfq_blk.hardlimit = hard;
+			defq->dfq_blk.softlimit = soft;
 		}
 	} else {
 		xfs_debug(mp, "blkhard %Ld < blksoft %Ld", hard, soft);
@@ -518,8 +518,8 @@ xfs_qm_scall_setqlim(
 		dqp->q_rtb.hardlimit = hard;
 		dqp->q_rtb.softlimit = soft;
 		if (id == 0) {
-			defq->rtbhardlimit = hard;
-			defq->rtbsoftlimit = soft;
+			defq->dfq_rtb.hardlimit = hard;
+			defq->dfq_rtb.softlimit = soft;
 		}
 	} else {
 		xfs_debug(mp, "rtbhard %Ld < rtbsoft %Ld", hard, soft);
@@ -535,8 +535,8 @@ xfs_qm_scall_setqlim(
 		dqp->q_ino.hardlimit = hard;
 		dqp->q_ino.softlimit = soft;
 		if (id == 0) {
-			defq->ihardlimit = hard;
-			defq->isoftlimit = soft;
+			defq->dfq_ino.hardlimit = hard;
+			defq->dfq_ino.softlimit = soft;
 		}
 	} else {
 		xfs_debug(mp, "ihard %Ld < isoft %Ld", hard, soft);
@@ -554,11 +554,11 @@ xfs_qm_scall_setqlim(
 
 	if (id == 0) {
 		if (newlim->d_fieldmask & QC_SPC_WARNS)
-			defq->bwarnlimit = newlim->d_spc_warns;
+			defq->dfq_blk.warnlimit = newlim->d_spc_warns;
 		if (newlim->d_fieldmask & QC_INO_WARNS)
-			defq->iwarnlimit = newlim->d_ino_warns;
+			defq->dfq_ino.warnlimit = newlim->d_ino_warns;
 		if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
-			defq->rtbwarnlimit = newlim->d_rt_spc_warns;
+			defq->dfq_rtb.warnlimit = newlim->d_rt_spc_warns;
 	}
 
 	/*
@@ -579,11 +579,11 @@ xfs_qm_scall_setqlim(
 
 	if (id == 0) {
 		if (newlim->d_fieldmask & QC_SPC_TIMER)
-			defq->btimelimit = newlim->d_spc_timer;
+			defq->dfq_blk.timelimit = newlim->d_spc_timer;
 		if (newlim->d_fieldmask & QC_INO_TIMER)
-			defq->itimelimit = newlim->d_ino_timer;
+			defq->dfq_ino.timelimit = newlim->d_ino_timer;
 		if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
-			defq->rtbtimelimit = newlim->d_rt_spc_timer;
+			defq->dfq_rtb.timelimit = newlim->d_rt_spc_timer;
 	}
 
 	if (id != 0) {
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index bf809b77a316..c86a6fe263da 100644
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
+	tstate->spc_timelimit = (u32)defq->dfq_blk.timelimit;
+	tstate->ino_timelimit = (u32)defq->dfq_ino.timelimit;
+	tstate->rt_spc_timelimit = (u32)defq->dfq_rtb.timelimit;
+	tstate->spc_warnlimit = defq->dfq_blk.warnlimit;
+	tstate->ino_warnlimit = defq->dfq_ino.warnlimit;
+	tstate->rt_spc_warnlimit = defq->dfq_rtb.warnlimit;
 	if (tempqip)
 		xfs_irele(ip);
 }
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 28b59a4069a3..392e51baad6f 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -587,25 +587,25 @@ xfs_trans_dqresv(
 	if (flags & XFS_TRANS_DQ_RES_BLKS) {
 		hardlimit = dqp->q_blk.hardlimit;
 		if (!hardlimit)
-			hardlimit = defq->bhardlimit;
+			hardlimit = defq->dfq_blk.hardlimit;
 		softlimit = dqp->q_blk.softlimit;
 		if (!softlimit)
-			softlimit = defq->bsoftlimit;
+			softlimit = defq->dfq_blk.softlimit;
 		timer = dqp->q_blk.timer;
 		warns = dqp->q_blk.warnings;
-		warnlimit = defq->bwarnlimit;
+		warnlimit = defq->dfq_blk.warnlimit;
 		resbcountp = &dqp->q_blk.reserved;
 	} else {
 		ASSERT(flags & XFS_TRANS_DQ_RES_RTBLKS);
 		hardlimit = dqp->q_rtb.hardlimit;
 		if (!hardlimit)
-			hardlimit = defq->rtbhardlimit;
+			hardlimit = defq->dfq_rtb.hardlimit;
 		softlimit = dqp->q_rtb.softlimit;
 		if (!softlimit)
-			softlimit = defq->rtbsoftlimit;
+			softlimit = defq->dfq_rtb.softlimit;
 		timer = dqp->q_rtb.timer;
 		warns = dqp->q_rtb.warnings;
-		warnlimit = defq->rtbwarnlimit;
+		warnlimit = defq->dfq_rtb.warnlimit;
 		resbcountp = &dqp->q_rtb.reserved;
 	}
 
@@ -640,13 +640,13 @@ xfs_trans_dqresv(
 			total_count = dqp->q_ino.reserved + ninos;
 			timer = dqp->q_ino.timer;
 			warns = dqp->q_ino.warnings;
-			warnlimit = defq->iwarnlimit;
+			warnlimit = defq->dfq_ino.warnlimit;
 			hardlimit = dqp->q_ino.hardlimit;
 			if (!hardlimit)
-				hardlimit = defq->ihardlimit;
+				hardlimit = defq->dfq_ino.hardlimit;
 			softlimit = dqp->q_ino.softlimit;
 			if (!softlimit)
-				softlimit = defq->isoftlimit;
+				softlimit = defq->dfq_ino.softlimit;
 
 			if (hardlimit && total_count > hardlimit) {
 				xfs_quota_warn(mp, dqp, QUOTA_NL_IHARDWARN);

