Return-Path: <SRS0=iu4H=AQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A818C433E0
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33F062075B
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:13:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qAiS5YDy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbgGEWNw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jul 2020 18:13:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40160 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbgGEWNw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jul 2020 18:13:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MDYYL147622;
        Sun, 5 Jul 2020 22:13:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/9Y48mPu6t0DTa10X02ki1+C/v5BPVyuW5qQRXA0fmU=;
 b=qAiS5YDy46Orh/Ihsr4vqQJINJ+1vf3MT9nPjuPAQwWIAoyDAf6S8x/3FQ4kRw0PxBwp
 aVZ+xMxWXxgknCmHRVecIMxVgK+6a+QL2HNLCwc5jspw5bHNEOLeOzbP6sbmqaOV3d7j
 srsAGJnsSmuJ0eUUSFUtkW3Vcytt+K94eZgb52M+xJG+sBXdMIIpkucJX914RPvpKYX+
 OwDqi/ARD8IKkiemLOfV2PGGajS0k3CdyB/b8lI4exMXxP8nda4PxgNGvQR4jRgYtM1G
 loZXn+wQ+RmNz25bSmS+D6X/EISljanVRTyR6SX81svOq3IqCPUIecg4+/1HIC4BWeW3 rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 322jdn3f61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 05 Jul 2020 22:13:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MCrB3102718;
        Sun, 5 Jul 2020 22:13:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3233hqbrn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 05 Jul 2020 22:13:47 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 065MDk1D026317;
        Sun, 5 Jul 2020 22:13:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 05 Jul 2020 15:13:46 -0700
Subject: [PATCH 11/22] xfs: stop using q_core warning counters in the quota
 code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Sun, 05 Jul 2020 15:13:45 -0700
Message-ID: <159398722544.425236.5431066403501792793.stgit@magnolia>
In-Reply-To: <159398715269.425236.15910213189856396341.stgit@magnolia>
References: <159398715269.425236.15910213189856396341.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=1 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007050172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=1 impostorscore=0 spamscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007050172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add warning counter fields to the incore dquot, and use that instead of
the ones in qcore.  This eliminates a bunch of endian conversions and
will eventually allow us to remove qcore entirely.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/xfs_dquot.c       |   14 +++++++++++---
 fs/xfs/xfs_dquot.h       |    8 ++++++++
 fs/xfs/xfs_qm.c          |   12 ++++++------
 fs/xfs/xfs_qm_syscalls.c |   12 ++++++------
 fs/xfs/xfs_trans_dquot.c |    6 +++---
 5 files changed, 34 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index c75ac3188fa4..3942ef6f1e94 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -140,7 +140,7 @@ xfs_qm_adjust_dqtimers(
 			d->d_btimer = cpu_to_be32(ktime_get_real_seconds() +
 					defq->btimelimit);
 		} else {
-			d->d_bwarns = 0;
+			dq->q_blk.warnings = 0;
 		}
 	} else {
 		if ((!dq->q_blk.softlimit ||
@@ -159,7 +159,7 @@ xfs_qm_adjust_dqtimers(
 			d->d_itimer = cpu_to_be32(ktime_get_real_seconds() +
 					defq->itimelimit);
 		} else {
-			d->d_iwarns = 0;
+			dq->q_ino.warnings = 0;
 		}
 	} else {
 		if ((!dq->q_ino.softlimit ||
@@ -178,7 +178,7 @@ xfs_qm_adjust_dqtimers(
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
index 3ff66c347811..fabc0e6062f2 100644
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

