Return-Path: <SRS0=iu4H=AQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C6F7C433DF
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F05F12075B
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:13:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ryyY3vOF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgGEWNt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jul 2020 18:13:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40106 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbgGEWNt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jul 2020 18:13:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MCs67147230;
        Sun, 5 Jul 2020 22:13:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xnOq7QewV5PEhRi166+j6g5v8YjD0YK3RIcIg6/Lrio=;
 b=ryyY3vOFR5ZYoJQxQGuP7O095b4GcHmTGhZ2lZrY8EXvcTBw/csD3Xg/YVYfLuxxfZKR
 bltdrVSe65ad5WfBIao8Iw3FgMzHoH+aQqEEDknh7RK+bTqoz8kW7/Ug3HE+zAZ6NS05
 c4hrjnaAa7ZVzg0cb8XZm302QA0vFAo8ikfymC+WLEAoo5QzLAMAhUWohE3B+yUM5ytz
 FgKyQftPWg1WogWSPBSWND3xfa65KXBC1SMFVpzJKgIUxvYyx/BVistdD3IGQ8XxHL3H
 vE9ChXWwlmY9TTBWt6G/bCOmumhPjMM/IqcFmxCdarB36SOICpfLvjfbiOFoEd6oBCrh SQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 322jdn3f5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 05 Jul 2020 22:13:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MD4m1158972;
        Sun, 5 Jul 2020 22:13:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3233bkj149-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 05 Jul 2020 22:13:41 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 065MDeFH003117;
        Sun, 5 Jul 2020 22:13:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 05 Jul 2020 15:13:40 -0700
Subject: [PATCH 10/22] xfs: stop using q_core counters in the quota code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Sun, 05 Jul 2020 15:13:38 -0700
Message-ID: <159398721883.425236.4260954506394096600.stgit@magnolia>
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

Add counter fields to the incore dquot, and use that instead of the ones
in qcore.  This eliminates a bunch of endian conversions and will
eventually allow us to remove qcore entirely.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/scrub/quota.c     |   18 ++++++------------
 fs/xfs/xfs_dquot.c       |   47 +++++++++++++++++++++++++---------------------
 fs/xfs/xfs_dquot.h       |    3 +++
 fs/xfs/xfs_qm.c          |    6 +++---
 fs/xfs/xfs_qm.h          |    6 +++---
 fs/xfs/xfs_trace.h       |    4 ++--
 fs/xfs/xfs_trans_dquot.c |   34 +++++++++++++--------------------
 7 files changed, 56 insertions(+), 62 deletions(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 1a1c6996fc69..2fc2625feca0 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -82,9 +82,6 @@ xchk_quota_item(
 	struct xfs_disk_dquot	*d = &dq->q_core;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 	xfs_fileoff_t		offset;
-	unsigned long long	bcount;
-	unsigned long long	icount;
-	unsigned long long	rcount;
 	xfs_ino_t		fs_icount;
 	int			error = 0;
 
@@ -128,9 +125,6 @@ xchk_quota_item(
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	/* Check the resource counts. */
-	bcount = be64_to_cpu(d->d_bcount);
-	icount = be64_to_cpu(d->d_icount);
-	rcount = be64_to_cpu(d->d_rtbcount);
 	fs_icount = percpu_counter_sum(&mp->m_icount);
 
 	/*
@@ -139,15 +133,15 @@ xchk_quota_item(
 	 * if there are no quota limits.
 	 */
 	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
-		if (mp->m_sb.sb_dblocks < bcount)
+		if (mp->m_sb.sb_dblocks < dq->q_blk.count)
 			xchk_fblock_set_warning(sc, XFS_DATA_FORK,
 					offset);
 	} else {
-		if (mp->m_sb.sb_dblocks < bcount)
+		if (mp->m_sb.sb_dblocks < dq->q_blk.count)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
 					offset);
 	}
-	if (icount > fs_icount || rcount > mp->m_sb.sb_rblocks)
+	if (dq->q_ino.count > fs_icount || dq->q_rtb.count > mp->m_sb.sb_rblocks)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	/*
@@ -159,15 +153,15 @@ xchk_quota_item(
 		goto out;
 
 	if (dq->q_blk.hardlimit != 0 &&
-	    bcount > dq->q_blk.hardlimit)
+	    dq->q_blk.count > dq->q_blk.hardlimit)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
 
 	if (dq->q_ino.hardlimit != 0 &&
-	    icount > dq->q_ino.hardlimit)
+	    dq->q_ino.count > dq->q_ino.hardlimit)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
 
 	if (dq->q_rtb.hardlimit != 0 &&
-	    rcount > dq->q_rtb.hardlimit)
+	    dq->q_rtb.count > dq->q_rtb.hardlimit)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
 
 out:
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index f763421b2212..c75ac3188fa4 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -134,9 +134,9 @@ xfs_qm_adjust_dqtimers(
 
 	if (!d->d_btimer) {
 		if ((dq->q_blk.softlimit &&
-		     (be64_to_cpu(d->d_bcount) > dq->q_blk.softlimit)) ||
+		     (dq->q_blk.count > dq->q_blk.softlimit)) ||
 		    (dq->q_blk.hardlimit &&
-		     (be64_to_cpu(d->d_bcount) > dq->q_blk.hardlimit))) {
+		     (dq->q_blk.count > dq->q_blk.hardlimit))) {
 			d->d_btimer = cpu_to_be32(ktime_get_real_seconds() +
 					defq->btimelimit);
 		} else {
@@ -144,18 +144,18 @@ xfs_qm_adjust_dqtimers(
 		}
 	} else {
 		if ((!dq->q_blk.softlimit ||
-		     (be64_to_cpu(d->d_bcount) <= dq->q_blk.softlimit)) &&
+		     (dq->q_blk.count <= dq->q_blk.softlimit)) &&
 		    (!dq->q_blk.hardlimit ||
-		    (be64_to_cpu(d->d_bcount) <= dq->q_blk.hardlimit))) {
+		    (dq->q_blk.count <= dq->q_blk.hardlimit))) {
 			d->d_btimer = 0;
 		}
 	}
 
 	if (!d->d_itimer) {
 		if ((dq->q_ino.softlimit &&
-		     (be64_to_cpu(d->d_icount) > dq->q_ino.softlimit)) ||
+		     (dq->q_ino.count > dq->q_ino.softlimit)) ||
 		    (dq->q_ino.hardlimit &&
-		     (be64_to_cpu(d->d_icount) > dq->q_ino.hardlimit))) {
+		     (dq->q_ino.count > dq->q_ino.hardlimit))) {
 			d->d_itimer = cpu_to_be32(ktime_get_real_seconds() +
 					defq->itimelimit);
 		} else {
@@ -163,18 +163,18 @@ xfs_qm_adjust_dqtimers(
 		}
 	} else {
 		if ((!dq->q_ino.softlimit ||
-		     (be64_to_cpu(d->d_icount) <= dq->q_ino.softlimit))  &&
+		     (dq->q_ino.count <= dq->q_ino.softlimit))  &&
 		    (!dq->q_ino.hardlimit ||
-		     (be64_to_cpu(d->d_icount) <= dq->q_ino.hardlimit))) {
+		     (dq->q_ino.count <= dq->q_ino.hardlimit))) {
 			d->d_itimer = 0;
 		}
 	}
 
 	if (!d->d_rtbtimer) {
 		if ((dq->q_rtb.softlimit &&
-		     (be64_to_cpu(d->d_rtbcount) > dq->q_rtb.softlimit)) ||
+		     (dq->q_rtb.count > dq->q_rtb.softlimit)) ||
 		    (dq->q_rtb.hardlimit &&
-		     (be64_to_cpu(d->d_rtbcount) > dq->q_rtb.hardlimit))) {
+		     (dq->q_rtb.count > dq->q_rtb.hardlimit))) {
 			d->d_rtbtimer = cpu_to_be32(ktime_get_real_seconds() +
 					defq->rtbtimelimit);
 		} else {
@@ -182,9 +182,9 @@ xfs_qm_adjust_dqtimers(
 		}
 	} else {
 		if ((!dq->q_rtb.softlimit ||
-		     (be64_to_cpu(d->d_rtbcount) <= dq->q_rtb.softlimit)) &&
+		     (dq->q_rtb.count <= dq->q_rtb.softlimit)) &&
 		    (!dq->q_rtb.hardlimit ||
-		     (be64_to_cpu(d->d_rtbcount) <= dq->q_rtb.hardlimit))) {
+		     (dq->q_rtb.count <= dq->q_rtb.hardlimit))) {
 			d->d_rtbtimer = 0;
 		}
 	}
@@ -538,13 +538,17 @@ xfs_dquot_from_disk(
 	dqp->q_rtb.hardlimit = be64_to_cpu(ddqp->d_rtb_hardlimit);
 	dqp->q_rtb.softlimit = be64_to_cpu(ddqp->d_rtb_softlimit);
 
+	dqp->q_blk.count = be64_to_cpu(ddqp->d_bcount);
+	dqp->q_ino.count = be64_to_cpu(ddqp->d_icount);
+	dqp->q_rtb.count = be64_to_cpu(ddqp->d_rtbcount);
+
 	/*
 	 * Reservation counters are defined as reservation plus current usage
 	 * to avoid having to add every time.
 	 */
-	dqp->q_blk.reserved = be64_to_cpu(ddqp->d_bcount);
-	dqp->q_ino.reserved = be64_to_cpu(ddqp->d_icount);
-	dqp->q_rtb.reserved = be64_to_cpu(ddqp->d_rtbcount);
+	dqp->q_blk.reserved = dqp->q_blk.count;
+	dqp->q_ino.reserved = dqp->q_ino.count;
+	dqp->q_rtb.reserved = dqp->q_rtb.count;
 
 	/* initialize the dquot speculative prealloc thresholds */
 	xfs_dquot_set_prealloc_limits(dqp);
@@ -565,6 +569,10 @@ xfs_dquot_to_disk(
 	ddqp->d_ino_softlimit = cpu_to_be64(dqp->q_ino.softlimit);
 	ddqp->d_rtb_hardlimit = cpu_to_be64(dqp->q_rtb.hardlimit);
 	ddqp->d_rtb_softlimit = cpu_to_be64(dqp->q_rtb.softlimit);
+
+	ddqp->d_bcount = cpu_to_be64(dqp->q_blk.count);
+	ddqp->d_icount = cpu_to_be64(dqp->q_ino.count);
+	ddqp->d_rtbcount = cpu_to_be64(dqp->q_rtb.count);
 }
 
 /* Allocate and initialize the dquot buffer for this in-core dquot. */
@@ -1128,18 +1136,15 @@ xfs_qm_dqflush_check(
 	if (dqp->q_id == 0)
 		return NULL;
 
-	if (dqp->q_blk.softlimit &&
-	    be64_to_cpu(ddq->d_bcount) > dqp->q_blk.softlimit &&
+	if (dqp->q_blk.softlimit && dqp->q_blk.count > dqp->q_blk.softlimit &&
 	    !ddq->d_btimer)
 		return __this_address;
 
-	if (dqp->q_ino.softlimit &&
-	    be64_to_cpu(ddq->d_icount) > dqp->q_ino.softlimit &&
+	if (dqp->q_ino.softlimit && dqp->q_ino.count > dqp->q_ino.softlimit &&
 	    !ddq->d_itimer)
 		return __this_address;
 
-	if (dqp->q_rtb.softlimit &&
-	    be64_to_cpu(ddq->d_rtbcount) > dqp->q_rtb.softlimit &&
+	if (dqp->q_rtb.softlimit && dqp->q_rtb.count > dqp->q_rtb.softlimit &&
 	    !ddq->d_rtbtimer)
 		return __this_address;
 
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index edb49788c476..23e05b0d7567 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -31,6 +31,9 @@ struct xfs_dquot_res {
 	/* Total resources allocated and reserved. */
 	xfs_qcnt_t		reserved;
 
+	/* Total resources allocated. */
+	xfs_qcnt_t		count;
+
 	/* Absolute and preferred limits. */
 	xfs_qcnt_t		hardlimit;
 	xfs_qcnt_t		softlimit;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 6aa834da00fd..3ff66c347811 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1096,14 +1096,14 @@ xfs_qm_quotacheck_dqadjust(
 	 * Adjust the inode count and the block count to reflect this inode's
 	 * resource usage.
 	 */
-	be64_add_cpu(&dqp->q_core.d_icount, 1);
+	dqp->q_ino.count++;
 	dqp->q_ino.reserved++;
 	if (nblks) {
-		be64_add_cpu(&dqp->q_core.d_bcount, nblks);
+		dqp->q_blk.count += nblks;
 		dqp->q_blk.reserved += nblks;
 	}
 	if (rtblks) {
-		be64_add_cpu(&dqp->q_core.d_rtbcount, rtblks);
+		dqp->q_rtb.count += rtblks;
 		dqp->q_rtb.reserved += rtblks;
 	}
 
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index d972457a5491..78d9b2e6d085 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -26,9 +26,9 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
 	!dqp->q_rtb.softlimit && \
 	!dqp->q_ino.hardlimit && \
 	!dqp->q_ino.softlimit && \
-	!dqp->q_core.d_bcount && \
-	!dqp->q_core.d_rtbcount && \
-	!dqp->q_core.d_icount)
+	!dqp->q_blk.count && \
+	!dqp->q_rtb.count && \
+	!dqp->q_ino.count)
 
 /* Defaults for each quota type: time limits, warn limits, usage limits */
 struct xfs_def_quota {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7f744a37dc0e..851f97dfe9e3 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -880,8 +880,8 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
 		__entry->flags = dqp->dq_flags;
 		__entry->nrefs = dqp->q_nrefs;
 		__entry->res_bcount = dqp->q_blk.reserved;
-		__entry->bcount = be64_to_cpu(dqp->q_core.d_bcount);
-		__entry->icount = be64_to_cpu(dqp->q_core.d_icount);
+		__entry->bcount = dqp->q_blk.count;
+		__entry->icount = dqp->q_ino.count;
 		__entry->blk_hardlimit = dqp->q_blk.hardlimit;
 		__entry->blk_softlimit = dqp->q_blk.softlimit;
 		__entry->ino_hardlimit = dqp->q_ino.hardlimit;
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 6d7c0a0b7b1b..b36d747989a7 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -309,7 +309,6 @@ xfs_trans_apply_dquot_deltas(
 	int			i, j;
 	struct xfs_dquot	*dqp;
 	struct xfs_dqtrx	*qtrx, *qa;
-	struct xfs_disk_dquot	*d;
 	int64_t			totalbdelta;
 	int64_t			totalrtbdelta;
 
@@ -341,7 +340,6 @@ xfs_trans_apply_dquot_deltas(
 			/*
 			 * adjust the actual number of blocks used
 			 */
-			d = &dqp->q_core;
 
 			/*
 			 * The issue here is - sometimes we don't make a blkquota
@@ -362,25 +360,22 @@ xfs_trans_apply_dquot_deltas(
 				qtrx->qt_delrtb_delta;
 #ifdef DEBUG
 			if (totalbdelta < 0)
-				ASSERT(be64_to_cpu(d->d_bcount) >=
-				       -totalbdelta);
+				ASSERT(dqp->q_blk.count >= -totalbdelta);
 
 			if (totalrtbdelta < 0)
-				ASSERT(be64_to_cpu(d->d_rtbcount) >=
-				       -totalrtbdelta);
+				ASSERT(dqp->q_rtb.count >= -totalrtbdelta);
 
 			if (qtrx->qt_icount_delta < 0)
-				ASSERT(be64_to_cpu(d->d_icount) >=
-				       -qtrx->qt_icount_delta);
+				ASSERT(dqp->q_ino.count >= -qtrx->qt_icount_delta);
 #endif
 			if (totalbdelta)
-				be64_add_cpu(&d->d_bcount, (xfs_qcnt_t)totalbdelta);
+				dqp->q_blk.count += totalbdelta;
 
 			if (qtrx->qt_icount_delta)
-				be64_add_cpu(&d->d_icount, (xfs_qcnt_t)qtrx->qt_icount_delta);
+				dqp->q_ino.count += qtrx->qt_icount_delta;
 
 			if (totalrtbdelta)
-				be64_add_cpu(&d->d_rtbcount, (xfs_qcnt_t)totalrtbdelta);
+				dqp->q_rtb.count += totalrtbdelta;
 
 			/*
 			 * Get any default limits in use.
@@ -467,12 +462,9 @@ xfs_trans_apply_dquot_deltas(
 					    (xfs_qcnt_t)qtrx->qt_icount_delta;
 			}
 
-			ASSERT(dqp->q_blk.reserved >=
-				be64_to_cpu(dqp->q_core.d_bcount));
-			ASSERT(dqp->q_ino.reserved >=
-				be64_to_cpu(dqp->q_core.d_icount));
-			ASSERT(dqp->q_rtb.reserved >=
-				be64_to_cpu(dqp->q_core.d_rtbcount));
+			ASSERT(dqp->q_blk.reserved >= dqp->q_blk.count);
+			ASSERT(dqp->q_ino.reserved >= dqp->q_ino.count);
+			ASSERT(dqp->q_rtb.reserved >= dqp->q_rtb.count);
 		}
 	}
 }
@@ -675,7 +667,7 @@ xfs_trans_dqresv(
 
 	/*
 	 * Change the reservation, but not the actual usage.
-	 * Note that q_blk.reserved = q_core.d_bcount + resv
+	 * Note that q_blk.reserved = q_blk.count + resv
 	 */
 	(*resbcountp) += (xfs_qcnt_t)nblks;
 	if (ninos != 0)
@@ -700,9 +692,9 @@ xfs_trans_dqresv(
 					    XFS_TRANS_DQ_RES_INOS,
 					    ninos);
 	}
-	ASSERT(dqp->q_blk.reserved >= be64_to_cpu(dqp->q_core.d_bcount));
-	ASSERT(dqp->q_rtb.reserved >= be64_to_cpu(dqp->q_core.d_rtbcount));
-	ASSERT(dqp->q_ino.reserved >= be64_to_cpu(dqp->q_core.d_icount));
+	ASSERT(dqp->q_blk.reserved >= dqp->q_blk.count);
+	ASSERT(dqp->q_rtb.reserved >= dqp->q_rtb.count);
+	ASSERT(dqp->q_ino.reserved >= dqp->q_ino.count);
 
 	xfs_dqunlock(dqp);
 	return 0;

