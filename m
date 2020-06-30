Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE697C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC1872074F
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:43:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MVwyKA+b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389646AbgF3PnF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 11:43:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45040 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389647AbgF3PnF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 11:43:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFgMkO006982
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=SJa2W6av3IERT+z4cdr6mtwS+4VbXFA8fx9B/uJRWh0=;
 b=MVwyKA+bEGclY94rFjeKmgRIrJgny+cxilZVNIPxa2L9dK6rZV77K8Vf9ytnEBeWL2Q1
 wbtbA2wxoQr2dLWf6xmECPehnPlgKtlVtpvTvyc7Jq1RXWoR+XBT14ziirQysvnRZ6tM
 9UoYXz3HiId5BpeXyhFB9Cu/hG+n+hAjGju2oLjDZk8+EZHDOYENBH9t5lkj8HGmB9RL
 XYuxsTjtVFDS6d3wGrGGTds0ZzWlCwH45Yxq5Fy4AzqMk79cPXdAxzsymb0FEaTFXKBi
 I4E8+EEyIrqaJrvcgGCh94KU88bfc5Y3EupENOONMlDIcVuikpV62JPKQLqJ1yrSgXp+ lQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31wxrn59x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFgpXp153805
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31y52j35nq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:02 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05UFh2QL013955
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 15:43:02 +0000
Subject: [PATCH 11/18] xfs: remove qcore from incore dquots
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 30 Jun 2020 08:43:01 -0700
Message-ID: <159353178119.2864738.14352743945962585449.stgit@magnolia>
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

Now that we've stopped using qcore entirely, drop it from the incore
dquot.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/quota.c |    4 ----
 fs/xfs/xfs_dquot.c   |   29 +++++++++--------------------
 fs/xfs/xfs_dquot.h   |    1 -
 3 files changed, 9 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 2fc2625feca0..f4aad5b00188 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -79,7 +79,6 @@ xchk_quota_item(
 	struct xchk_quota_info	*sqi = priv;
 	struct xfs_scrub	*sc = sqi->sc;
 	struct xfs_mount	*mp = sc->mp;
-	struct xfs_disk_dquot	*d = &dq->q_core;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 	xfs_fileoff_t		offset;
 	xfs_ino_t		fs_icount;
@@ -98,9 +97,6 @@ xchk_quota_item(
 
 	sqi->last_id = dq->q_id;
 
-	if (d->d_pad0 != cpu_to_be32(0) || d->d_pad != cpu_to_be16(0))
-		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
-
 	/*
 	 * Warn if the hard limits are larger than the fs.
 	 * Administrators can do this, though in production this seems
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 7434ee57ec43..2d6b50760962 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -529,7 +529,6 @@ xfs_dquot_from_disk(
 	}
 
 	/* copy everything from disk dquot to the incore dquot */
-	memcpy(&dqp->q_core, ddqp, sizeof(struct xfs_disk_dquot));
 	dqp->q_blk.hardlimit = be64_to_cpu(ddqp->d_blk_hardlimit);
 	dqp->q_blk.softlimit = be64_to_cpu(ddqp->d_blk_softlimit);
 	dqp->q_ino.hardlimit = be64_to_cpu(ddqp->d_ino_hardlimit);
@@ -568,8 +567,13 @@ xfs_dquot_to_disk(
 	struct xfs_disk_dquot	*ddqp,
 	struct xfs_dquot	*dqp)
 {
-	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
+	ddqp->d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
+	ddqp->d_version = XFS_DQUOT_VERSION;
 	ddqp->d_flags = dqp->dq_flags & XFS_DQ_ONDISK;
+	ddqp->d_id = cpu_to_be32(dqp->q_id);
+	ddqp->d_pad0 = 0;
+	ddqp->d_pad = 0;
+
 	ddqp->d_blk_hardlimit = cpu_to_be64(dqp->q_blk.hardlimit);
 	ddqp->d_blk_softlimit = cpu_to_be64(dqp->q_blk.softlimit);
 	ddqp->d_ino_hardlimit = cpu_to_be64(dqp->q_ino.hardlimit);
@@ -1180,7 +1184,6 @@ xfs_qm_dqflush(
 	struct xfs_log_item	*lip = &dqp->q_logitem.qli_item;
 	struct xfs_buf		*bp;
 	struct xfs_dqblk	*dqb;
-	struct xfs_disk_dquot	*ddqp;
 	xfs_failaddr_t		fa;
 	int			error;
 
@@ -1204,22 +1207,6 @@ xfs_qm_dqflush(
 	if (error)
 		goto out_abort;
 
-	/*
-	 * Calculate the location of the dquot inside the buffer.
-	 */
-	dqb = bp->b_addr + dqp->q_bufoffset;
-	ddqp = &dqb->dd_diskdq;
-
-	/* sanity check the in-core structure before we flush */
-	fa = xfs_dquot_verify(mp, &dqp->q_core, dqp->q_id, 0);
-	if (fa) {
-		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
-				dqp->q_id, fa);
-		xfs_buf_relse(bp);
-		error = -EFSCORRUPTED;
-		goto out_abort;
-	}
-
 	fa = xfs_qm_dqflush_check(dqp);
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
@@ -1229,7 +1216,9 @@ xfs_qm_dqflush(
 		goto out_abort;
 	}
 
-	xfs_dquot_to_disk(ddqp, dqp);
+	/* Flush the incore dquot to the ondisk buffer. */
+	dqb = bp->b_addr + dqp->q_bufoffset;
+	xfs_dquot_to_disk(&dqb->dd_diskdq, dqp);
 
 	/*
 	 * Clear the dirty field and remember the flush lsn for later use.
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 414bae537b1d..62b0fc6e0133 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -71,7 +71,6 @@ struct xfs_dquot {
 	struct xfs_dquot_res	q_ino;	/* inodes */
 	struct xfs_dquot_res	q_rtb;	/* realtime blocks */
 
-	struct xfs_disk_dquot	q_core;
 	struct xfs_dq_logitem	q_logitem;
 
 	xfs_qcnt_t		q_prealloc_lo_wmark;

