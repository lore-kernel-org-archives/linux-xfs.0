Return-Path: <SRS0=iu4H=AQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B0A0C433DF
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B1042075B
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:13:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hWg1IlUn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgGEWNo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jul 2020 18:13:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45320 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbgGEWNn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jul 2020 18:13:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MDbKJ002815;
        Sun, 5 Jul 2020 22:13:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hLgU8flgTNFZYWWB137OOTpvj/OCQen6wE/2wCkVCJI=;
 b=hWg1IlUnV9MqsxUKdP9eUmx6Y+DNwRHWCpbz+sEtYFZ8GDQ9aMohmf35rJAvMiwczLwi
 yD/9boq7+XL/DcKFKa56hHhZHq/zSYuprpEENO/A6SvIxaKKbrvQ4MQwoCkjByI2GmcS
 h9BkN2+AHiwxJ2mORJDaXskn6klSyZppp+E3vlUVhMPpxTD0wE98/56WdX0Gg2AmRjfT
 JpoErkt4DyftanrpzAB8+Nw+hADENSJzD+rVPPPkQn/D9NS10Uov2SNWqMNHg3fx6IE7
 CrtZYedDNf7NFlVpI/KTknjtOxca3Cl4e1V+agZj67IFn38lc0X00y0xYzHZnbgl5fJ8 2g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 322h6r3j3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 05 Jul 2020 22:13:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MD5fK159020;
        Sun, 5 Jul 2020 22:13:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3233bkj124-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 05 Jul 2020 22:13:36 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 065MDXVM003113;
        Sun, 5 Jul 2020 22:13:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 05 Jul 2020 15:13:33 -0700
Subject: [PATCH 09/22] xfs: stop using q_core limits in the quota code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Sun, 05 Jul 2020 15:13:32 -0700
Message-ID: <159398721232.425236.2469418143797423371.stgit@magnolia>
In-Reply-To: <159398715269.425236.15910213189856396341.stgit@magnolia>
References: <159398715269.425236.15910213189856396341.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007050172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=1 adultscore=0 mlxscore=0 spamscore=0 impostorscore=0
 cotscore=-2147483648 malwarescore=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007050172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add limits fields in the incore dquot, and use that instead of the ones
in qcore.  This eliminates a bunch of endian conversions and will
eventually allow us to remove qcore entirely.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/scrub/quota.c     |   36 ++++--------
 fs/xfs/xfs_dquot.c       |  135 ++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_dquot.h       |    6 ++
 fs/xfs/xfs_qm.c          |   14 ++---
 fs/xfs/xfs_qm.h          |   12 ++--
 fs/xfs/xfs_qm_bhv.c      |   12 ++--
 fs/xfs/xfs_qm_syscalls.c |   40 ++++++--------
 fs/xfs/xfs_trace.h       |   12 +---
 fs/xfs/xfs_trans_dquot.c |   12 ++--
 9 files changed, 138 insertions(+), 141 deletions(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 9a271f115882..1a1c6996fc69 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -82,12 +82,6 @@ xchk_quota_item(
 	struct xfs_disk_dquot	*d = &dq->q_core;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 	xfs_fileoff_t		offset;
-	unsigned long long	bsoft;
-	unsigned long long	isoft;
-	unsigned long long	rsoft;
-	unsigned long long	bhard;
-	unsigned long long	ihard;
-	unsigned long long	rhard;
 	unsigned long long	bcount;
 	unsigned long long	icount;
 	unsigned long long	rcount;
@@ -110,15 +104,6 @@ xchk_quota_item(
 	if (d->d_pad0 != cpu_to_be32(0) || d->d_pad != cpu_to_be16(0))
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
-	/* Check the limits. */
-	bhard = be64_to_cpu(d->d_blk_hardlimit);
-	ihard = be64_to_cpu(d->d_ino_hardlimit);
-	rhard = be64_to_cpu(d->d_rtb_hardlimit);
-
-	bsoft = be64_to_cpu(d->d_blk_softlimit);
-	isoft = be64_to_cpu(d->d_ino_softlimit);
-	rsoft = be64_to_cpu(d->d_rtb_softlimit);
-
 	/*
 	 * Warn if the hard limits are larger than the fs.
 	 * Administrators can do this, though in production this seems
@@ -127,19 +112,19 @@ xchk_quota_item(
 	 * Complain about corruption if the soft limit is greater than
 	 * the hard limit.
 	 */
-	if (bhard > mp->m_sb.sb_dblocks)
+	if (dq->q_blk.hardlimit > mp->m_sb.sb_dblocks)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
-	if (bsoft > bhard)
+	if (dq->q_blk.softlimit > dq->q_blk.hardlimit)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
-	if (ihard > M_IGEO(mp)->maxicount)
+	if (dq->q_ino.hardlimit > M_IGEO(mp)->maxicount)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
-	if (isoft > ihard)
+	if (dq->q_ino.softlimit > dq->q_ino.hardlimit)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
-	if (rhard > mp->m_sb.sb_rblocks)
+	if (dq->q_rtb.hardlimit > mp->m_sb.sb_rblocks)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
-	if (rsoft > rhard)
+	if (dq->q_rtb.softlimit > dq->q_rtb.hardlimit)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	/* Check the resource counts. */
@@ -173,13 +158,16 @@ xchk_quota_item(
 	if (dq->q_id == 0)
 		goto out;
 
-	if (bhard != 0 && bcount > bhard)
+	if (dq->q_blk.hardlimit != 0 &&
+	    bcount > dq->q_blk.hardlimit)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
 
-	if (ihard != 0 && icount > ihard)
+	if (dq->q_ino.hardlimit != 0 &&
+	    icount > dq->q_ino.hardlimit)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
 
-	if (rhard != 0 && rcount > rhard)
+	if (dq->q_rtb.hardlimit != 0 &&
+	    rcount > dq->q_rtb.hardlimit)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
 
 out:
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 9d3afb4ba9e4..f763421b2212 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -71,29 +71,28 @@ xfs_qm_adjust_dqlimits(
 	struct xfs_dquot	*dq)
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	struct xfs_disk_dquot	*d = &dq->q_core;
 	struct xfs_def_quota	*defq;
 	int			prealloc = 0;
 
 	ASSERT(dq->q_id);
 	defq = xfs_get_defquota(q, xfs_dquot_type(dq));
 
-	if (defq->bsoftlimit && !d->d_blk_softlimit) {
-		d->d_blk_softlimit = cpu_to_be64(defq->bsoftlimit);
+	if (defq->bsoftlimit && !dq->q_blk.softlimit) {
+		dq->q_blk.softlimit = defq->bsoftlimit;
 		prealloc = 1;
 	}
-	if (defq->bhardlimit && !d->d_blk_hardlimit) {
-		d->d_blk_hardlimit = cpu_to_be64(defq->bhardlimit);
+	if (defq->bhardlimit && !dq->q_blk.hardlimit) {
+		dq->q_blk.hardlimit = defq->bhardlimit;
 		prealloc = 1;
 	}
-	if (defq->isoftlimit && !d->d_ino_softlimit)
-		d->d_ino_softlimit = cpu_to_be64(defq->isoftlimit);
-	if (defq->ihardlimit && !d->d_ino_hardlimit)
-		d->d_ino_hardlimit = cpu_to_be64(defq->ihardlimit);
-	if (defq->rtbsoftlimit && !d->d_rtb_softlimit)
-		d->d_rtb_softlimit = cpu_to_be64(defq->rtbsoftlimit);
-	if (defq->rtbhardlimit && !d->d_rtb_hardlimit)
-		d->d_rtb_hardlimit = cpu_to_be64(defq->rtbhardlimit);
+	if (defq->isoftlimit && !dq->q_ino.softlimit)
+		dq->q_ino.softlimit = defq->isoftlimit;
+	if (defq->ihardlimit && !dq->q_ino.hardlimit)
+		dq->q_ino.hardlimit = defq->ihardlimit;
+	if (defq->rtbsoftlimit && !dq->q_rtb.softlimit)
+		dq->q_rtb.softlimit = defq->rtbsoftlimit;
+	if (defq->rtbhardlimit && !dq->q_rtb.hardlimit)
+		dq->q_rtb.hardlimit = defq->rtbhardlimit;
 
 	if (prealloc)
 		xfs_dquot_set_prealloc_limits(dq);
@@ -125,82 +124,67 @@ xfs_qm_adjust_dqtimers(
 	defq = xfs_get_defquota(qi, xfs_dquot_type(dq));
 
 #ifdef DEBUG
-	if (d->d_blk_hardlimit)
-		ASSERT(be64_to_cpu(d->d_blk_softlimit) <=
-		       be64_to_cpu(d->d_blk_hardlimit));
-	if (d->d_ino_hardlimit)
-		ASSERT(be64_to_cpu(d->d_ino_softlimit) <=
-		       be64_to_cpu(d->d_ino_hardlimit));
-	if (d->d_rtb_hardlimit)
-		ASSERT(be64_to_cpu(d->d_rtb_softlimit) <=
-		       be64_to_cpu(d->d_rtb_hardlimit));
+	if (dq->q_blk.hardlimit)
+		ASSERT(dq->q_blk.softlimit <= dq->q_blk.hardlimit);
+	if (dq->q_ino.hardlimit)
+		ASSERT(dq->q_ino.softlimit <= dq->q_ino.hardlimit);
+	if (dq->q_rtb.hardlimit)
+		ASSERT(dq->q_rtb.softlimit <= dq->q_rtb.hardlimit);
 #endif
 
 	if (!d->d_btimer) {
-		if ((d->d_blk_softlimit &&
-		     (be64_to_cpu(d->d_bcount) >
-		      be64_to_cpu(d->d_blk_softlimit))) ||
-		    (d->d_blk_hardlimit &&
-		     (be64_to_cpu(d->d_bcount) >
-		      be64_to_cpu(d->d_blk_hardlimit)))) {
+		if ((dq->q_blk.softlimit &&
+		     (be64_to_cpu(d->d_bcount) > dq->q_blk.softlimit)) ||
+		    (dq->q_blk.hardlimit &&
+		     (be64_to_cpu(d->d_bcount) > dq->q_blk.hardlimit))) {
 			d->d_btimer = cpu_to_be32(ktime_get_real_seconds() +
 					defq->btimelimit);
 		} else {
 			d->d_bwarns = 0;
 		}
 	} else {
-		if ((!d->d_blk_softlimit ||
-		     (be64_to_cpu(d->d_bcount) <=
-		      be64_to_cpu(d->d_blk_softlimit))) &&
-		    (!d->d_blk_hardlimit ||
-		    (be64_to_cpu(d->d_bcount) <=
-		     be64_to_cpu(d->d_blk_hardlimit)))) {
+		if ((!dq->q_blk.softlimit ||
+		     (be64_to_cpu(d->d_bcount) <= dq->q_blk.softlimit)) &&
+		    (!dq->q_blk.hardlimit ||
+		    (be64_to_cpu(d->d_bcount) <= dq->q_blk.hardlimit))) {
 			d->d_btimer = 0;
 		}
 	}
 
 	if (!d->d_itimer) {
-		if ((d->d_ino_softlimit &&
-		     (be64_to_cpu(d->d_icount) >
-		      be64_to_cpu(d->d_ino_softlimit))) ||
-		    (d->d_ino_hardlimit &&
-		     (be64_to_cpu(d->d_icount) >
-		      be64_to_cpu(d->d_ino_hardlimit)))) {
+		if ((dq->q_ino.softlimit &&
+		     (be64_to_cpu(d->d_icount) > dq->q_ino.softlimit)) ||
+		    (dq->q_ino.hardlimit &&
+		     (be64_to_cpu(d->d_icount) > dq->q_ino.hardlimit))) {
 			d->d_itimer = cpu_to_be32(ktime_get_real_seconds() +
 					defq->itimelimit);
 		} else {
 			d->d_iwarns = 0;
 		}
 	} else {
-		if ((!d->d_ino_softlimit ||
-		     (be64_to_cpu(d->d_icount) <=
-		      be64_to_cpu(d->d_ino_softlimit)))  &&
-		    (!d->d_ino_hardlimit ||
-		     (be64_to_cpu(d->d_icount) <=
-		      be64_to_cpu(d->d_ino_hardlimit)))) {
+		if ((!dq->q_ino.softlimit ||
+		     (be64_to_cpu(d->d_icount) <= dq->q_ino.softlimit))  &&
+		    (!dq->q_ino.hardlimit ||
+		     (be64_to_cpu(d->d_icount) <= dq->q_ino.hardlimit))) {
 			d->d_itimer = 0;
 		}
 	}
 
 	if (!d->d_rtbtimer) {
-		if ((d->d_rtb_softlimit &&
-		     (be64_to_cpu(d->d_rtbcount) >
-		      be64_to_cpu(d->d_rtb_softlimit))) ||
-		    (d->d_rtb_hardlimit &&
-		     (be64_to_cpu(d->d_rtbcount) >
-		      be64_to_cpu(d->d_rtb_hardlimit)))) {
+		if ((dq->q_rtb.softlimit &&
+		     (be64_to_cpu(d->d_rtbcount) > dq->q_rtb.softlimit)) ||
+		    (dq->q_rtb.hardlimit &&
+		     (be64_to_cpu(d->d_rtbcount) > dq->q_rtb.hardlimit))) {
 			d->d_rtbtimer = cpu_to_be32(ktime_get_real_seconds() +
 					defq->rtbtimelimit);
 		} else {
 			d->d_rtbwarns = 0;
 		}
 	} else {
-		if ((!d->d_rtb_softlimit ||
-		     (be64_to_cpu(d->d_rtbcount) <=
-		      be64_to_cpu(d->d_rtb_softlimit))) &&
-		    (!d->d_rtb_hardlimit ||
-		     (be64_to_cpu(d->d_rtbcount) <=
-		      be64_to_cpu(d->d_rtb_hardlimit)))) {
+		if ((!dq->q_rtb.softlimit ||
+		     (be64_to_cpu(d->d_rtbcount) <= dq->q_rtb.softlimit)) &&
+		    (!dq->q_rtb.hardlimit ||
+		     (be64_to_cpu(d->d_rtbcount) <= dq->q_rtb.hardlimit))) {
 			d->d_rtbtimer = 0;
 		}
 	}
@@ -291,8 +275,8 @@ xfs_dquot_set_prealloc_limits(struct xfs_dquot *dqp)
 {
 	uint64_t space;
 
-	dqp->q_prealloc_hi_wmark = be64_to_cpu(dqp->q_core.d_blk_hardlimit);
-	dqp->q_prealloc_lo_wmark = be64_to_cpu(dqp->q_core.d_blk_softlimit);
+	dqp->q_prealloc_hi_wmark = dqp->q_blk.hardlimit;
+	dqp->q_prealloc_lo_wmark = dqp->q_blk.softlimit;
 	if (!dqp->q_prealloc_lo_wmark) {
 		dqp->q_prealloc_lo_wmark = dqp->q_prealloc_hi_wmark;
 		do_div(dqp->q_prealloc_lo_wmark, 100);
@@ -547,6 +531,12 @@ xfs_dquot_from_disk(
 
 	/* copy everything from disk dquot to the incore dquot */
 	memcpy(&dqp->q_core, ddqp, sizeof(struct xfs_disk_dquot));
+	dqp->q_blk.hardlimit = be64_to_cpu(ddqp->d_blk_hardlimit);
+	dqp->q_blk.softlimit = be64_to_cpu(ddqp->d_blk_softlimit);
+	dqp->q_ino.hardlimit = be64_to_cpu(ddqp->d_ino_hardlimit);
+	dqp->q_ino.softlimit = be64_to_cpu(ddqp->d_ino_softlimit);
+	dqp->q_rtb.hardlimit = be64_to_cpu(ddqp->d_rtb_hardlimit);
+	dqp->q_rtb.softlimit = be64_to_cpu(ddqp->d_rtb_softlimit);
 
 	/*
 	 * Reservation counters are defined as reservation plus current usage
@@ -569,6 +559,12 @@ xfs_dquot_to_disk(
 {
 	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
 	ddqp->d_flags = dqp->dq_flags & XFS_DDQFEAT_TYPE_MASK;
+	ddqp->d_blk_hardlimit = cpu_to_be64(dqp->q_blk.hardlimit);
+	ddqp->d_blk_softlimit = cpu_to_be64(dqp->q_blk.softlimit);
+	ddqp->d_ino_hardlimit = cpu_to_be64(dqp->q_ino.hardlimit);
+	ddqp->d_ino_softlimit = cpu_to_be64(dqp->q_ino.softlimit);
+	ddqp->d_rtb_hardlimit = cpu_to_be64(dqp->q_rtb.hardlimit);
+	ddqp->d_rtb_softlimit = cpu_to_be64(dqp->q_rtb.softlimit);
 }
 
 /* Allocate and initialize the dquot buffer for this in-core dquot. */
@@ -1123,11 +1119,30 @@ static xfs_failaddr_t
 xfs_qm_dqflush_check(
 	struct xfs_dquot	*dqp)
 {
+	struct xfs_disk_dquot	*ddq = &dqp->q_core;
 	unsigned int		type = dqp->dq_flags & XFS_DQ_ALLTYPES;
 
 	if (type != XFS_DQ_USER && type != XFS_DQ_GROUP && type != XFS_DQ_PROJ)
 		return __this_address;
 
+	if (dqp->q_id == 0)
+		return NULL;
+
+	if (dqp->q_blk.softlimit &&
+	    be64_to_cpu(ddq->d_bcount) > dqp->q_blk.softlimit &&
+	    !ddq->d_btimer)
+		return __this_address;
+
+	if (dqp->q_ino.softlimit &&
+	    be64_to_cpu(ddq->d_icount) > dqp->q_ino.softlimit &&
+	    !ddq->d_itimer)
+		return __this_address;
+
+	if (dqp->q_rtb.softlimit &&
+	    be64_to_cpu(ddq->d_rtbcount) > dqp->q_rtb.softlimit &&
+	    !ddq->d_rtbtimer)
+		return __this_address;
+
 	return NULL;
 }
 
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index cb20df1e774f..edb49788c476 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -30,6 +30,10 @@ enum {
 struct xfs_dquot_res {
 	/* Total resources allocated and reserved. */
 	xfs_qcnt_t		reserved;
+
+	/* Absolute and preferred limits. */
+	xfs_qcnt_t		hardlimit;
+	xfs_qcnt_t		softlimit;
 };
 
 /*
@@ -142,7 +146,7 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
 {
 	int64_t freesp;
 
-	freesp = be64_to_cpu(dqp->q_core.d_blk_hardlimit) - dqp->q_blk.reserved;
+	freesp = dqp->q_blk.hardlimit - dqp->q_blk.reserved;
 	if (freesp < dqp->q_low_space[XFS_QLOWSP_1_PCNT])
 		return true;
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index fe0a8240c7c6..6aa834da00fd 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -550,26 +550,24 @@ xfs_qm_set_defquota(
 {
 	struct xfs_dquot	*dqp;
 	struct xfs_def_quota	*defq;
-	struct xfs_disk_dquot	*ddqp;
 	int			error;
 
 	error = xfs_qm_dqget_uncached(mp, 0, type, &dqp);
 	if (error)
 		return;
 
-	ddqp = &dqp->q_core;
 	defq = xfs_get_defquota(qinf, xfs_dquot_type(dqp));
 
 	/*
 	 * Timers and warnings have been already set, let's just set the
 	 * default limits for this quota type
 	 */
-	defq->bhardlimit = be64_to_cpu(ddqp->d_blk_hardlimit);
-	defq->bsoftlimit = be64_to_cpu(ddqp->d_blk_softlimit);
-	defq->ihardlimit = be64_to_cpu(ddqp->d_ino_hardlimit);
-	defq->isoftlimit = be64_to_cpu(ddqp->d_ino_softlimit);
-	defq->rtbhardlimit = be64_to_cpu(ddqp->d_rtb_hardlimit);
-	defq->rtbsoftlimit = be64_to_cpu(ddqp->d_rtb_softlimit);
+	defq->bhardlimit = dqp->q_blk.hardlimit;
+	defq->bsoftlimit = dqp->q_blk.softlimit;
+	defq->ihardlimit = dqp->q_ino.hardlimit;
+	defq->isoftlimit = dqp->q_ino.softlimit;
+	defq->rtbhardlimit = dqp->q_rtb.hardlimit;
+	defq->rtbsoftlimit = dqp->q_rtb.softlimit;
 	xfs_qm_dqdestroy(dqp);
 }
 
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 43cc01fa4b4d..d972457a5491 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -20,12 +20,12 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
 #define XFS_DQITER_MAP_SIZE	10
 
 #define XFS_IS_DQUOT_UNINITIALIZED(dqp) ( \
-	!dqp->q_core.d_blk_hardlimit && \
-	!dqp->q_core.d_blk_softlimit && \
-	!dqp->q_core.d_rtb_hardlimit && \
-	!dqp->q_core.d_rtb_softlimit && \
-	!dqp->q_core.d_ino_hardlimit && \
-	!dqp->q_core.d_ino_softlimit && \
+	!dqp->q_blk.hardlimit && \
+	!dqp->q_blk.softlimit && \
+	!dqp->q_rtb.hardlimit && \
+	!dqp->q_rtb.softlimit && \
+	!dqp->q_ino.hardlimit && \
+	!dqp->q_ino.softlimit && \
 	!dqp->q_core.d_bcount && \
 	!dqp->q_core.d_rtbcount && \
 	!dqp->q_core.d_icount)
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 94b2b4b0fc17..0993217e5ac8 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -23,9 +23,9 @@ xfs_fill_statvfs_from_dquot(
 {
 	uint64_t		limit;
 
-	limit = dqp->q_core.d_blk_softlimit ?
-		be64_to_cpu(dqp->q_core.d_blk_softlimit) :
-		be64_to_cpu(dqp->q_core.d_blk_hardlimit);
+	limit = dqp->q_blk.softlimit ?
+		dqp->q_blk.softlimit :
+		dqp->q_blk.hardlimit;
 	if (limit && statp->f_blocks > limit) {
 		statp->f_blocks = limit;
 		statp->f_bfree = statp->f_bavail =
@@ -33,9 +33,9 @@ xfs_fill_statvfs_from_dquot(
 			 (statp->f_blocks - dqp->q_blk.reserved) : 0;
 	}
 
-	limit = dqp->q_core.d_ino_softlimit ?
-		be64_to_cpu(dqp->q_core.d_ino_softlimit) :
-		be64_to_cpu(dqp->q_core.d_ino_hardlimit);
+	limit = dqp->q_ino.softlimit ?
+		dqp->q_ino.softlimit :
+		dqp->q_ino.hardlimit;
 	if (limit && statp->f_files > limit) {
 		statp->f_files = limit;
 		statp->f_ffree =
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 56fe80395679..ab596d389e3e 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -495,13 +495,13 @@ xfs_qm_scall_setqlim(
 	 */
 	hard = (newlim->d_fieldmask & QC_SPC_HARD) ?
 		(xfs_qcnt_t) XFS_B_TO_FSB(mp, newlim->d_spc_hardlimit) :
-			be64_to_cpu(ddq->d_blk_hardlimit);
+			dqp->q_blk.hardlimit;
 	soft = (newlim->d_fieldmask & QC_SPC_SOFT) ?
 		(xfs_qcnt_t) XFS_B_TO_FSB(mp, newlim->d_spc_softlimit) :
-			be64_to_cpu(ddq->d_blk_softlimit);
+			dqp->q_blk.softlimit;
 	if (hard == 0 || hard >= soft) {
-		ddq->d_blk_hardlimit = cpu_to_be64(hard);
-		ddq->d_blk_softlimit = cpu_to_be64(soft);
+		dqp->q_blk.hardlimit = hard;
+		dqp->q_blk.softlimit = soft;
 		xfs_dquot_set_prealloc_limits(dqp);
 		if (id == 0) {
 			defq->bhardlimit = hard;
@@ -512,13 +512,13 @@ xfs_qm_scall_setqlim(
 	}
 	hard = (newlim->d_fieldmask & QC_RT_SPC_HARD) ?
 		(xfs_qcnt_t) XFS_B_TO_FSB(mp, newlim->d_rt_spc_hardlimit) :
-			be64_to_cpu(ddq->d_rtb_hardlimit);
+			dqp->q_rtb.hardlimit;
 	soft = (newlim->d_fieldmask & QC_RT_SPC_SOFT) ?
 		(xfs_qcnt_t) XFS_B_TO_FSB(mp, newlim->d_rt_spc_softlimit) :
-			be64_to_cpu(ddq->d_rtb_softlimit);
+			dqp->q_rtb.softlimit;
 	if (hard == 0 || hard >= soft) {
-		ddq->d_rtb_hardlimit = cpu_to_be64(hard);
-		ddq->d_rtb_softlimit = cpu_to_be64(soft);
+		dqp->q_rtb.hardlimit = hard;
+		dqp->q_rtb.softlimit = soft;
 		if (id == 0) {
 			defq->rtbhardlimit = hard;
 			defq->rtbsoftlimit = soft;
@@ -529,13 +529,13 @@ xfs_qm_scall_setqlim(
 
 	hard = (newlim->d_fieldmask & QC_INO_HARD) ?
 		(xfs_qcnt_t) newlim->d_ino_hardlimit :
-			be64_to_cpu(ddq->d_ino_hardlimit);
+			dqp->q_ino.hardlimit;
 	soft = (newlim->d_fieldmask & QC_INO_SOFT) ?
 		(xfs_qcnt_t) newlim->d_ino_softlimit :
-			be64_to_cpu(ddq->d_ino_softlimit);
+			dqp->q_ino.softlimit;
 	if (hard == 0 || hard >= soft) {
-		ddq->d_ino_hardlimit = cpu_to_be64(hard);
-		ddq->d_ino_softlimit = cpu_to_be64(soft);
+		dqp->q_ino.hardlimit = hard;
+		dqp->q_ino.softlimit = soft;
 		if (id == 0) {
 			defq->ihardlimit = hard;
 			defq->isoftlimit = soft;
@@ -619,10 +619,8 @@ xfs_qm_scall_getquota_fill_qc(
 	struct qc_dqblk		*dst)
 {
 	memset(dst, 0, sizeof(*dst));
-	dst->d_spc_hardlimit =
-		XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_blk_hardlimit));
-	dst->d_spc_softlimit =
-		XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_blk_softlimit));
+	dst->d_spc_hardlimit = XFS_FSB_TO_B(mp, dqp->q_blk.hardlimit);
+	dst->d_spc_softlimit = XFS_FSB_TO_B(mp, dqp->q_blk.softlimit);
 	dst->d_ino_hardlimit = be64_to_cpu(dqp->q_core.d_ino_hardlimit);
 	dst->d_ino_softlimit = be64_to_cpu(dqp->q_core.d_ino_softlimit);
 	dst->d_space = XFS_FSB_TO_B(mp, dqp->q_blk.reserved);
@@ -631,10 +629,8 @@ xfs_qm_scall_getquota_fill_qc(
 	dst->d_ino_timer = be32_to_cpu(dqp->q_core.d_itimer);
 	dst->d_ino_warns = be16_to_cpu(dqp->q_core.d_iwarns);
 	dst->d_spc_warns = be16_to_cpu(dqp->q_core.d_bwarns);
-	dst->d_rt_spc_hardlimit =
-		XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_rtb_hardlimit));
-	dst->d_rt_spc_softlimit =
-		XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_rtb_softlimit));
+	dst->d_rt_spc_hardlimit = XFS_FSB_TO_B(mp, dqp->q_rtb.hardlimit);
+	dst->d_rt_spc_softlimit = XFS_FSB_TO_B(mp, dqp->q_rtb.softlimit);
 	dst->d_rt_space = XFS_FSB_TO_B(mp, dqp->q_rtb.reserved);
 	dst->d_rt_spc_timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
 	dst->d_rt_spc_warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
@@ -661,8 +657,8 @@ xfs_qm_scall_getquota_fill_qc(
 		    (dst->d_spc_softlimit > 0)) {
 			ASSERT(dst->d_spc_timer != 0);
 		}
-		if ((dst->d_ino_count > dst->d_ino_softlimit) &&
-		    (dst->d_ino_softlimit > 0)) {
+		if ((dst->d_ino_count > dqp->q_ino.softlimit) &&
+		    (dqp->q_ino.softlimit > 0)) {
 			ASSERT(dst->d_ino_timer != 0);
 		}
 	}
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 71567ed367f2..7f744a37dc0e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -882,14 +882,10 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
 		__entry->res_bcount = dqp->q_blk.reserved;
 		__entry->bcount = be64_to_cpu(dqp->q_core.d_bcount);
 		__entry->icount = be64_to_cpu(dqp->q_core.d_icount);
-		__entry->blk_hardlimit =
-			be64_to_cpu(dqp->q_core.d_blk_hardlimit);
-		__entry->blk_softlimit =
-			be64_to_cpu(dqp->q_core.d_blk_softlimit);
-		__entry->ino_hardlimit =
-			be64_to_cpu(dqp->q_core.d_ino_hardlimit);
-		__entry->ino_softlimit =
-			be64_to_cpu(dqp->q_core.d_ino_softlimit);
+		__entry->blk_hardlimit = dqp->q_blk.hardlimit;
+		__entry->blk_softlimit = dqp->q_blk.softlimit;
+		__entry->ino_hardlimit = dqp->q_ino.hardlimit;
+		__entry->ino_softlimit = dqp->q_ino.softlimit;
 	),
 	TP_printk("dev %d:%d id 0x%x flags %s nrefs %u res_bc 0x%llx "
 		  "bcnt 0x%llx bhardlimit 0x%llx bsoftlimit 0x%llx "
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 8c02430ea165..6d7c0a0b7b1b 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -593,10 +593,10 @@ xfs_trans_dqresv(
 	defq = xfs_get_defquota(q, xfs_dquot_type(dqp));
 
 	if (flags & XFS_TRANS_DQ_RES_BLKS) {
-		hardlimit = be64_to_cpu(dqp->q_core.d_blk_hardlimit);
+		hardlimit = dqp->q_blk.hardlimit;
 		if (!hardlimit)
 			hardlimit = defq->bhardlimit;
-		softlimit = be64_to_cpu(dqp->q_core.d_blk_softlimit);
+		softlimit = dqp->q_blk.softlimit;
 		if (!softlimit)
 			softlimit = defq->bsoftlimit;
 		timer = be32_to_cpu(dqp->q_core.d_btimer);
@@ -605,10 +605,10 @@ xfs_trans_dqresv(
 		resbcountp = &dqp->q_blk.reserved;
 	} else {
 		ASSERT(flags & XFS_TRANS_DQ_RES_RTBLKS);
-		hardlimit = be64_to_cpu(dqp->q_core.d_rtb_hardlimit);
+		hardlimit = dqp->q_rtb.hardlimit;
 		if (!hardlimit)
 			hardlimit = defq->rtbhardlimit;
-		softlimit = be64_to_cpu(dqp->q_core.d_rtb_softlimit);
+		softlimit = dqp->q_rtb.softlimit;
 		if (!softlimit)
 			softlimit = defq->rtbsoftlimit;
 		timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
@@ -649,10 +649,10 @@ xfs_trans_dqresv(
 			timer = be32_to_cpu(dqp->q_core.d_itimer);
 			warns = be16_to_cpu(dqp->q_core.d_iwarns);
 			warnlimit = defq->iwarnlimit;
-			hardlimit = be64_to_cpu(dqp->q_core.d_ino_hardlimit);
+			hardlimit = dqp->q_ino.hardlimit;
 			if (!hardlimit)
 				hardlimit = defq->ihardlimit;
-			softlimit = be64_to_cpu(dqp->q_core.d_ino_softlimit);
+			softlimit = dqp->q_ino.softlimit;
 			if (!softlimit)
 				softlimit = defq->isoftlimit;
 

