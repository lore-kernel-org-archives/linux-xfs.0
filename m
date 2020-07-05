Return-Path: <SRS0=iu4H=AQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD0FC433E0
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C54E02075B
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:14:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0cVGamir"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgGEWOf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jul 2020 18:14:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57130 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgGEWOf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jul 2020 18:14:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MD2EJ080767;
        Sun, 5 Jul 2020 22:14:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=XCdgYIbXEIcYoBxzAPbI8da57OmluHM2lfnVDAWMxRY=;
 b=0cVGamirgbxa3faiofbQz93aBKVRvzYEmQObE4i/SgirAQfzLd4h1HkMnHXBulNDuBLI
 2Q7mp5wsKq1FYf42GZ1XVKS3EmL3Gkn0OMx2QEVqaEI9nFfTn2SRi3VW1Jc2rQY5G5Pk
 gedTp2C3AopmRrLwrOt0pXWWna4cl65z+YH+Re6KyReF7V45GPp4c789lR++1k/Nrbzu
 W67aOjWP6wV8g5X+HOexA79XA5hVFHCYd77wx48h0KXQZAli592jAEh/RBCSlXrAu2Qs
 2FHPhANdUpE6EmkmjfKCKh4bF2yFLCKvyCuvnIZev87oR5gNJlZHOd2XnnS3E8C4+z5D jA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 322kv63b0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 05 Jul 2020 22:14:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065ME5Hf101097;
        Sun, 5 Jul 2020 22:14:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3233pubkcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 05 Jul 2020 22:14:32 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 065MEVvi026655;
        Sun, 5 Jul 2020 22:14:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 05 Jul 2020 15:14:31 -0700
Subject: [PATCH 18/22] xfs: refactor xfs_trans_dqresv
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Sun, 05 Jul 2020 15:14:30 -0700
Message-ID: <159398727041.425236.2306790843137673592.stgit@magnolia>
In-Reply-To: <159398715269.425236.15910213189856396341.stgit@magnolia>
References: <159398715269.425236.15910213189856396341.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007050172
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

Now that we've refactored the resource usage and limits into
per-resource structures, we can refactor some of the open-coded
reservation limit checking in xfs_trans_dqresv.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/xfs_trans_dquot.c |  153 +++++++++++++++++++++++-----------------------
 1 file changed, 78 insertions(+), 75 deletions(-)


diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 130d97871a3d..7f847cfba885 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -554,6 +554,58 @@ xfs_quota_warn(
 			   mp->m_super->s_dev, type);
 }
 
+/*
+ * Decide if we can make an additional reservation against a quota resource.
+ * Returns an inode QUOTA_NL_ warning code and whether or not it's fatal.
+ *
+ * Note that we assume that the numeric difference between the inode and block
+ * warning codes will always be 3 since it's userspace ABI now, and will never
+ * decrease the quota reservation, so the *BELOW messages are irrelevant.
+ */
+static inline int
+xfs_dqresv_check(
+	struct xfs_dquot_res	*res,
+	struct xfs_quota_limits	*qlim,
+	int64_t			delta,
+	bool			*fatal)
+{
+	xfs_qcnt_t		hardlimit = res->hardlimit;
+	xfs_qcnt_t		softlimit = res->softlimit;
+	xfs_qcnt_t		total_count = res->reserved + delta;
+
+	BUILD_BUG_ON(QUOTA_NL_BHARDWARN     != QUOTA_NL_IHARDWARN + 3);
+	BUILD_BUG_ON(QUOTA_NL_BSOFTLONGWARN != QUOTA_NL_ISOFTLONGWARN + 3);
+	BUILD_BUG_ON(QUOTA_NL_BSOFTWARN     != QUOTA_NL_ISOFTWARN + 3);
+
+	*fatal = false;
+	if (delta <= 0)
+		return QUOTA_NL_NOWARN;
+
+	if (!hardlimit)
+		hardlimit = qlim->hard;
+	if (!softlimit)
+		softlimit = qlim->soft;
+
+	if (hardlimit && total_count > hardlimit) {
+		*fatal = true;
+		return QUOTA_NL_IHARDWARN;
+	}
+
+	if (softlimit && total_count > softlimit) {
+		time64_t	now = ktime_get_real_seconds();
+
+		if ((res->timer != 0 && now > res->timer) ||
+		    (res->warnings != 0 && res->warnings >= qlim->warn)) {
+			*fatal = true;
+			return QUOTA_NL_ISOFTLONGWARN;
+		}
+
+		return QUOTA_NL_ISOFTWARN;
+	}
+
+	return QUOTA_NL_NOWARN;
+}
+
 /*
  * This reserves disk blocks and inodes against a dquot.
  * Flags indicate if the dquot is to be locked here and also
@@ -569,99 +621,51 @@ xfs_trans_dqresv(
 	long			ninos,
 	uint			flags)
 {
-	xfs_qcnt_t		hardlimit;
-	xfs_qcnt_t		softlimit;
-	time64_t		timer;
-	xfs_qwarncnt_t		warns;
-	xfs_qwarncnt_t		warnlimit;
-	xfs_qcnt_t		total_count;
-	xfs_qcnt_t		*resbcountp;
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	struct xfs_def_quota	*defq;
-
+	struct xfs_dquot_res	*blkres;
+	struct xfs_quota_limits	*qlim;
 
 	xfs_dqlock(dqp);
 
 	defq = xfs_get_defquota(q, xfs_dquot_type(dqp));
 
 	if (flags & XFS_TRANS_DQ_RES_BLKS) {
-		hardlimit = dqp->q_blk.hardlimit;
-		if (!hardlimit)
-			hardlimit = defq->blk.hard;
-		softlimit = dqp->q_blk.softlimit;
-		if (!softlimit)
-			softlimit = defq->blk.soft;
-		timer = dqp->q_blk.timer;
-		warns = dqp->q_blk.warnings;
-		warnlimit = defq->blk.warn;
-		resbcountp = &dqp->q_blk.reserved;
+		blkres = &dqp->q_blk;
+		qlim = &defq->blk;
 	} else {
-		ASSERT(flags & XFS_TRANS_DQ_RES_RTBLKS);
-		hardlimit = dqp->q_rtb.hardlimit;
-		if (!hardlimit)
-			hardlimit = defq->rtb.hard;
-		softlimit = dqp->q_rtb.softlimit;
-		if (!softlimit)
-			softlimit = defq->rtb.soft;
-		timer = dqp->q_rtb.timer;
-		warns = dqp->q_rtb.warnings;
-		warnlimit = defq->rtb.warn;
-		resbcountp = &dqp->q_rtb.reserved;
+		blkres = &dqp->q_rtb;
+		qlim = &defq->rtb;
 	}
 
 	if ((flags & XFS_QMOPT_FORCE_RES) == 0 && dqp->q_id &&
 	    ((XFS_IS_UQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISUDQ(dqp)) ||
 	     (XFS_IS_GQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISGDQ(dqp)) ||
 	     (XFS_IS_PQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISPDQ(dqp)))) {
-		if (nblks > 0) {
+		int		quota_nl;
+		bool		fatal;
+
+		/*
+		 * dquot is locked already. See if we'd go over the hardlimit
+		 * or exceed the timelimit if we'd reserve resources.
+		 */
+		quota_nl = xfs_dqresv_check(blkres, qlim, nblks, &fatal);
+		if (quota_nl != QUOTA_NL_NOWARN) {
 			/*
-			 * dquot is locked already. See if we'd go over the
-			 * hardlimit or exceed the timelimit if we allocate
-			 * nblks.
+			 * Quota block warning codes are 3 more than the inode
+			 * codes, which we check above.
 			 */
-			total_count = *resbcountp + nblks;
-			if (hardlimit && total_count > hardlimit) {
-				xfs_quota_warn(mp, dqp, QUOTA_NL_BHARDWARN);
+			xfs_quota_warn(mp, dqp, quota_nl + 3);
+			if (fatal)
 				goto error_return;
-			}
-			if (softlimit && total_count > softlimit) {
-				if ((timer != 0 &&
-				     ktime_get_real_seconds() > timer) ||
-				    (warns != 0 && warns >= warnlimit)) {
-					xfs_quota_warn(mp, dqp,
-						       QUOTA_NL_BSOFTLONGWARN);
-					goto error_return;
-				}
-
-				xfs_quota_warn(mp, dqp, QUOTA_NL_BSOFTWARN);
-			}
 		}
-		if (ninos > 0) {
-			total_count = dqp->q_ino.reserved + ninos;
-			timer = dqp->q_ino.timer;
-			warns = dqp->q_ino.warnings;
-			warnlimit = defq->ino.warn;
-			hardlimit = dqp->q_ino.hardlimit;
-			if (!hardlimit)
-				hardlimit = defq->ino.hard;
-			softlimit = dqp->q_ino.softlimit;
-			if (!softlimit)
-				softlimit = defq->ino.soft;
 
-			if (hardlimit && total_count > hardlimit) {
-				xfs_quota_warn(mp, dqp, QUOTA_NL_IHARDWARN);
+		quota_nl = xfs_dqresv_check(&dqp->q_ino, &defq->ino, ninos,
+				&fatal);
+		if (quota_nl != QUOTA_NL_NOWARN) {
+			xfs_quota_warn(mp, dqp, quota_nl);
+			if (fatal)
 				goto error_return;
-			}
-			if (softlimit && total_count > softlimit) {
-				if  ((timer != 0 &&
-				      ktime_get_real_seconds() > timer) ||
-				     (warns != 0 && warns >= warnlimit)) {
-					xfs_quota_warn(mp, dqp,
-						       QUOTA_NL_ISOFTLONGWARN);
-					goto error_return;
-				}
-				xfs_quota_warn(mp, dqp, QUOTA_NL_ISOFTWARN);
-			}
 		}
 	}
 
@@ -669,9 +673,8 @@ xfs_trans_dqresv(
 	 * Change the reservation, but not the actual usage.
 	 * Note that q_blk.reserved = q_blk.count + resv
 	 */
-	(*resbcountp) += (xfs_qcnt_t)nblks;
-	if (ninos != 0)
-		dqp->q_ino.reserved += (xfs_qcnt_t)ninos;
+	blkres->reserved += (xfs_qcnt_t)nblks;
+	dqp->q_ino.reserved += (xfs_qcnt_t)ninos;
 
 	/*
 	 * note the reservation amt in the trans struct too,

