Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23FB4C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0390320768
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:42:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hujxAIyC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389643AbgF3Pmy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 11:42:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44832 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389644AbgF3Pmy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 11:42:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFgMBY007011
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:42:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=RIKm+pT7dJ0ILDhiaZ5fPkanMOQS0xdDHZn7ohRVj1s=;
 b=hujxAIyCkkEHh+ETt398yZrGSsv0nKXIJELRBVZ97TxYLdvrUtWwrjc31pM6h4CXFMXq
 famOz+OjoNbB1FHsbdM09bTzlJQWljtsODj4WLS2mlDOVKZJ3oO9Uh6BlilUZ/5521U0
 mS8zqDiBEmOoim46wpeKKNtR4t5uN739W8AGcOAqevfO/wVG5424uOEW9IoFvd1qpk11
 LFDCQUe6PRNbl7BkWHehdmWq1fz63MZ4rdChJ9jdBsAP5aMj888VAQTO6RXeD+o1Mpet
 Roiz/SJRe7hoixBkqiFVx4PzMNkyMfdUHtbafOyu4OIeK1H2V1YGG6JCD7lvRF/E5Dpy oQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31wxrn59v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:42:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFgn9i057930
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:42:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 31xfvsm501-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:42:52 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05UFgnFB017234
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:42:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 15:42:49 +0000
Subject: [PATCH 09/18] xfs: stop using q_core warning counters in the quota
 code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 30 Jun 2020 08:42:48 -0700
Message-ID: <159353176856.2864738.18281608729457160086.stgit@magnolia>
In-Reply-To: <159353170983.2864738.16885438169173786208.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=1 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300113
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add warning counter fields to the incore dquot, and use that instead of
the ones in qcore.  This eliminates a bunch of endian conversions and
will eventually allow us to remove qcore entirely.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c       |   14 +++++++++++---
 fs/xfs/xfs_dquot.h       |    8 ++++++++
 fs/xfs/xfs_qm.c          |   12 ++++++------
 fs/xfs/xfs_qm_syscalls.c |   12 ++++++------
 fs/xfs/xfs_trans_dquot.c |    6 +++---
 5 files changed, 34 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 02eae8c2ba1b..a1edb49ceda5 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -139,7 +139,7 @@ xfs_qm_adjust_dqtimers(
 			d->d_btimer = cpu_to_be32(ktime_get_real_seconds() +
 					defq->btimelimit);
 		} else {
-			d->d_bwarns = 0;
+			dq->q_blk.warnings = 0;
 		}
 	} else {
 		if ((!dq->q_blk.softlimit ||
@@ -158,7 +158,7 @@ xfs_qm_adjust_dqtimers(
 			d->d_itimer = cpu_to_be32(ktime_get_real_seconds() +
 					defq->itimelimit);
 		} else {
-			d->d_iwarns = 0;
+			dq->q_ino.warnings = 0;
 		}
 	} else {
 		if ((!dq->q_ino.softlimit ||
@@ -177,7 +177,7 @@ xfs_qm_adjust_dqtimers(
 			d->d_rtbtimer = cpu_to_be32(ktime_get_real_seconds() +
 					defq->rtbtimelimit);
 		} else {
-			d->d_rtbwarns = 0;
+			dq->q_rtb.warnings = 0;
 		}
 	} else {
 		if ((!dq->q_rtb.softlimit ||
@@ -542,6 +542,10 @@ xfs_dquot_from_disk(
 	dqp->q_ino.count = be64_to_cpu(ddqp->d_icount);
 	dqp->q_rtb.count = be64_to_cpu(ddqp->d_rtbcount);
 
+	dqp->q_blk.warnings = be16_to_cpu(ddqp->d_bwarns);
+	dqp->q_ino.warnings = be16_to_cpu(ddqp->d_iwarns);
+	dqp->q_rtb.warnings = be16_to_cpu(ddqp->d_rtbwarns);
+
 	/*
 	 * Reservation counters are defined as reservation plus current usage
 	 * to avoid having to add every time.
@@ -573,6 +577,10 @@ xfs_dquot_to_disk(
 	ddqp->d_bcount = cpu_to_be64(dqp->q_blk.count);
 	ddqp->d_icount = cpu_to_be64(dqp->q_ino.count);
 	ddqp->d_rtbcount = cpu_to_be64(dqp->q_rtb.count);
+
+	ddqp->d_bwarns = cpu_to_be16(dqp->q_blk.warnings);
+	ddqp->d_iwarns = cpu_to_be16(dqp->q_ino.warnings);
+	ddqp->d_rtbwarns = cpu_to_be16(dqp->q_rtb.warnings);
 }
 
 /* Allocate and initialize the dquot buffer for this in-core dquot. */
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 23e05b0d7567..5840bc54b772 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -37,6 +37,14 @@ struct xfs_dquot_res {
 	/* Absolute and preferred limits. */
 	xfs_qcnt_t		hardlimit;
 	xfs_qcnt_t		softlimit;
+
+	/*
+	 * For root dquots, this is the maximum number of warnings that will
+	 * be issued for this quota type.  Otherwise, this is the number of
+	 * warnings issued against this quota.  Note that none of this is
+	 * implemented.
+	 */
+	xfs_qwarncnt_t		warnings;
 };
 
 /*
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b47bba204240..4e233cfef46d 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -616,12 +616,12 @@ xfs_qm_init_timelimits(
 		defq->itimelimit = be32_to_cpu(ddqp->d_itimer);
 	if (ddqp->d_rtbtimer)
 		defq->rtbtimelimit = be32_to_cpu(ddqp->d_rtbtimer);
-	if (ddqp->d_bwarns)
-		defq->bwarnlimit = be16_to_cpu(ddqp->d_bwarns);
-	if (ddqp->d_iwarns)
-		defq->iwarnlimit = be16_to_cpu(ddqp->d_iwarns);
-	if (ddqp->d_rtbwarns)
-		defq->rtbwarnlimit = be16_to_cpu(ddqp->d_rtbwarns);
+	if (dqp->q_blk.warnings)
+		defq->bwarnlimit = dqp->q_blk.warnings;
+	if (dqp->q_ino.warnings)
+		defq->iwarnlimit = dqp->q_ino.warnings;
+	if (dqp->q_rtb.warnings)
+		defq->rtbwarnlimit = dqp->q_rtb.warnings;
 
 	xfs_qm_dqdestroy(dqp);
 }
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index ab596d389e3e..5d3bccdbd3bf 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -548,11 +548,11 @@ xfs_qm_scall_setqlim(
 	 * Update warnings counter(s) if requested
 	 */
 	if (newlim->d_fieldmask & QC_SPC_WARNS)
-		ddq->d_bwarns = cpu_to_be16(newlim->d_spc_warns);
+		dqp->q_blk.warnings = newlim->d_spc_warns;
 	if (newlim->d_fieldmask & QC_INO_WARNS)
-		ddq->d_iwarns = cpu_to_be16(newlim->d_ino_warns);
+		dqp->q_ino.warnings = newlim->d_ino_warns;
 	if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
-		ddq->d_rtbwarns = cpu_to_be16(newlim->d_rt_spc_warns);
+		dqp->q_rtb.warnings = newlim->d_rt_spc_warns;
 
 	if (id == 0) {
 		if (newlim->d_fieldmask & QC_SPC_WARNS)
@@ -627,13 +627,13 @@ xfs_qm_scall_getquota_fill_qc(
 	dst->d_ino_count = dqp->q_ino.reserved;
 	dst->d_spc_timer = be32_to_cpu(dqp->q_core.d_btimer);
 	dst->d_ino_timer = be32_to_cpu(dqp->q_core.d_itimer);
-	dst->d_ino_warns = be16_to_cpu(dqp->q_core.d_iwarns);
-	dst->d_spc_warns = be16_to_cpu(dqp->q_core.d_bwarns);
+	dst->d_ino_warns = dqp->q_ino.warnings;
+	dst->d_spc_warns = dqp->q_blk.warnings;
 	dst->d_rt_spc_hardlimit = XFS_FSB_TO_B(mp, dqp->q_rtb.hardlimit);
 	dst->d_rt_spc_softlimit = XFS_FSB_TO_B(mp, dqp->q_rtb.softlimit);
 	dst->d_rt_space = XFS_FSB_TO_B(mp, dqp->q_rtb.reserved);
 	dst->d_rt_spc_timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
-	dst->d_rt_spc_warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
+	dst->d_rt_spc_warns = dqp->q_rtb.warnings;
 
 	/*
 	 * Internally, we don't reset all the timers when quota enforcement
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index b36d747989a7..21ed8eda3c80 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -592,7 +592,7 @@ xfs_trans_dqresv(
 		if (!softlimit)
 			softlimit = defq->bsoftlimit;
 		timer = be32_to_cpu(dqp->q_core.d_btimer);
-		warns = be16_to_cpu(dqp->q_core.d_bwarns);
+		warns = dqp->q_blk.warnings;
 		warnlimit = defq->bwarnlimit;
 		resbcountp = &dqp->q_blk.reserved;
 	} else {
@@ -604,7 +604,7 @@ xfs_trans_dqresv(
 		if (!softlimit)
 			softlimit = defq->rtbsoftlimit;
 		timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
-		warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
+		warns = dqp->q_rtb.warnings;
 		warnlimit = defq->rtbwarnlimit;
 		resbcountp = &dqp->q_rtb.reserved;
 	}
@@ -639,7 +639,7 @@ xfs_trans_dqresv(
 		if (ninos > 0) {
 			total_count = dqp->q_ino.reserved + ninos;
 			timer = be32_to_cpu(dqp->q_core.d_itimer);
-			warns = be16_to_cpu(dqp->q_core.d_iwarns);
+			warns = dqp->q_ino.warnings;
 			warnlimit = defq->iwarnlimit;
 			hardlimit = dqp->q_ino.hardlimit;
 			if (!hardlimit)

