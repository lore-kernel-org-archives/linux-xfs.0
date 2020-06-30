Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98C01C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FDCB2074F
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:43:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cCSxVmO3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389670AbgF3Pnh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 11:43:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45464 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389647AbgF3Png (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 11:43:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFgM8x007005
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=dQS3DHfmU6uztZ74YAMZA0ttwv593xdxyTapEIdFSrE=;
 b=cCSxVmO3s59w2pXlhq+kx7NzlENzz7rJIsuZd4eSEGPHM08ggWCLc7OF3w8J9+9E7dqd
 mdI4myjxXIuDaaPEH52B5oqCeyOTKKDL8b6IxmZuVV7yk1GOJjUjwbW2lpDrgqqx18J1
 hN3tAWHv1hDl/hvCOSx5TyfLhl/R4so9Q8QSFyV36KijBp/CEujNtjIfuSx3C7zSr3/Q
 zQ5FrrUsPA9LbkozsSLLmYUJfd/Ow0ltZIfEhFJ6tk/fZY4JK0JD7dDaM82LfV7EDHS/
 uHKB0qsU2RT39IyHRbK31N9J8L1uHw70kxBphcOdc1pz4eLVhpl68ovKUeXnPhhWxZeE 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31wxrn5a1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFgoF3058276
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31xfvsm6ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:34 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05UFhXUV019541
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 15:43:33 +0000
Subject: [PATCH 16/18] xfs: refactor xfs_trans_dqresv
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 30 Jun 2020 08:43:32 -0700
Message-ID: <159353181258.2864738.8355431623063896449.stgit@magnolia>
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

Now that we've refactored the resource usage and limits into
per-resource structures, we can refactor some of the open-coded
reservation limit checking in xfs_trans_dqresv.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_trans_dquot.c |  153 +++++++++++++++++++++++-----------------------
 1 file changed, 78 insertions(+), 75 deletions(-)


diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 2712814d696d..30a011dc9828 100644
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
+	struct xfs_def_qres	*dres,
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
+		hardlimit = dres->hardlimit;
+	if (!softlimit)
+		softlimit = dres->softlimit;
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
+		    (res->warnings != 0 && res->warnings >= dres->warnlimit)) {
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
+	struct xfs_def_qres	*def_blkres;
 
 	xfs_dqlock(dqp);
 
 	defq = xfs_get_defquota(q, xfs_dquot_type(dqp));
 
 	if (flags & XFS_TRANS_DQ_RES_BLKS) {
-		hardlimit = dqp->q_blk.hardlimit;
-		if (!hardlimit)
-			hardlimit = defq->dfq_blk.hardlimit;
-		softlimit = dqp->q_blk.softlimit;
-		if (!softlimit)
-			softlimit = defq->dfq_blk.softlimit;
-		timer = dqp->q_blk.timer;
-		warns = dqp->q_blk.warnings;
-		warnlimit = defq->dfq_blk.warnlimit;
-		resbcountp = &dqp->q_blk.reserved;
+		blkres = &dqp->q_blk;
+		def_blkres = &defq->dfq_blk;
 	} else {
-		ASSERT(flags & XFS_TRANS_DQ_RES_RTBLKS);
-		hardlimit = dqp->q_rtb.hardlimit;
-		if (!hardlimit)
-			hardlimit = defq->dfq_rtb.hardlimit;
-		softlimit = dqp->q_rtb.softlimit;
-		if (!softlimit)
-			softlimit = defq->dfq_rtb.softlimit;
-		timer = dqp->q_rtb.timer;
-		warns = dqp->q_rtb.warnings;
-		warnlimit = defq->dfq_rtb.warnlimit;
-		resbcountp = &dqp->q_rtb.reserved;
+		blkres = &dqp->q_rtb;
+		def_blkres = &defq->dfq_rtb;
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
+		quota_nl = xfs_dqresv_check(blkres, def_blkres, nblks, &fatal);
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
-			warnlimit = defq->dfq_ino.warnlimit;
-			hardlimit = dqp->q_ino.hardlimit;
-			if (!hardlimit)
-				hardlimit = defq->dfq_ino.hardlimit;
-			softlimit = dqp->q_ino.softlimit;
-			if (!softlimit)
-				softlimit = defq->dfq_ino.softlimit;
 
-			if (hardlimit && total_count > hardlimit) {
-				xfs_quota_warn(mp, dqp, QUOTA_NL_IHARDWARN);
+		quota_nl = xfs_dqresv_check(&dqp->q_ino, &defq->dfq_ino, ninos,
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

