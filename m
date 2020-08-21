Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D71C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 02:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49C692076E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 02:14:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Uz8oaf71"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgHUCOn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 22:14:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45112 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbgHUCOn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 22:14:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L26stu111245;
        Fri, 21 Aug 2020 02:14:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=XOpBSH+h8R5xzNiGeeESg6mih/hBM8QnmcukLBshMmM=;
 b=Uz8oaf717sKjKmHmqHuXSf/NWStSUtXL2FZdREBTUciUJEco7CCtU1mCkToILu/AApEx
 rg2E2zqXH4LlV0+4hXJJPwHjBcxFingHRrHlJBqZMpuMliXJZ3stzjl7B8lLgrfLCX6J
 saHqbie++1n6hReDlphZ4T1OxLTs1JQYmW70si2i3UjXi2pBTf26BMFFV2aoJywZNgF1
 kiRU5lHMn/u3hNIwuw+cU9NWUr7IdMt8w9U+dx6VGPNoZcmphxfEiAirN0RiAmvga4j8
 V869pz7iE/GAza2fysnzTZ5OuX8Y8I30Jb6J5+7yrfHjyQ4U5FvM45Rn3IlcTi1ekUtY 4g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32x74rkwg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Aug 2020 02:14:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L27sPu034663;
        Fri, 21 Aug 2020 02:12:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 330pvqm3yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 02:12:37 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07L2Cajw019865;
        Fri, 21 Aug 2020 02:12:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Aug 2020 19:12:35 -0700
Subject: [PATCH 10/11] xfs: enable bigtime for quota timers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Date:   Thu, 20 Aug 2020 19:12:34 -0700
Message-ID: <159797595474.965217.7111215541487615114.stgit@magnolia>
In-Reply-To: <159797588727.965217.7260803484540460144.stgit@magnolia>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=1 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210018
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Enable the bigtime feature for quota timers.  We decrease the accuracy
of the timers to ~4s in exchange for being able to set timers up to the
bigtime maximum.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c  |   32 ++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_format.h     |   27 ++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_quota_defs.h |    3 ++-
 fs/xfs/xfs_dquot.c             |   25 +++++++++++++++++++++----
 fs/xfs/xfs_dquot.h             |    3 ++-
 fs/xfs/xfs_ondisk.h            |    7 +++++++
 fs/xfs/xfs_qm.c                |    2 ++
 fs/xfs/xfs_qm_syscalls.c       |    9 +++++----
 fs/xfs/xfs_trans_dquot.c       |    6 ++++++
 9 files changed, 101 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 7f5291022b11..f5997fbdd308 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -69,6 +69,13 @@ xfs_dquot_verify(
 	    ddq_type != XFS_DQTYPE_GROUP)
 		return __this_address;
 
+	if ((ddq->d_type & XFS_DQTYPE_BIGTIME) &&
+	    !xfs_sb_version_hasbigtime(&mp->m_sb))
+		return __this_address;
+
+	if ((ddq->d_type & XFS_DQTYPE_BIGTIME) && !ddq->d_id)
+		return __this_address;
+
 	if (id != -1 && id != be32_to_cpu(ddq->d_id))
 		return __this_address;
 
@@ -296,7 +303,15 @@ xfs_dquot_from_disk_timestamp(
 	time64_t		*timer,
 	__be32			dtimer)
 {
-	*timer = be32_to_cpu(dtimer);
+	uint64_t		t;
+
+	if (!timer || !(ddq->d_type & XFS_DQTYPE_BIGTIME)) {
+		*timer = be32_to_cpu(dtimer);
+		return;
+	}
+
+	t = be32_to_cpu(dtimer);
+	*timer = t << XFS_DQ_BIGTIME_SHIFT;
 }
 
 /* Convert an incore timer value into an on-disk timer value. */
@@ -306,5 +321,18 @@ xfs_dquot_to_disk_timestamp(
 	__be32			*dtimer,
 	time64_t		timer)
 {
-	*dtimer = cpu_to_be32(timer);
+	uint64_t		t;
+
+	if (!timer || !(dqp->q_type & XFS_DQTYPE_BIGTIME)) {
+		*dtimer = cpu_to_be32(timer);
+		return;
+	}
+
+	/*
+	 * Round the end of the grace period up to the nearest bigtime
+	 * interval that we support, to give users the most time to fix
+	 * the problems.
+	 */
+	t = timer + XFS_DQ_BIGTIME_SLACK;
+	*dtimer = cpu_to_be32(t >> XFS_DQ_BIGTIME_SHIFT);
 }
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 57343973e5e5..7ce0fb3bd4d1 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1227,13 +1227,15 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DQTYPE_USER		0x01		/* user dquot record */
 #define XFS_DQTYPE_PROJ		0x02		/* project dquot record */
 #define XFS_DQTYPE_GROUP	0x04		/* group dquot record */
+#define XFS_DQTYPE_BIGTIME	0x08		/* large expiry timestamps */
 
 /* bitmask to determine if this is a user/group/project dquot */
 #define XFS_DQTYPE_REC_MASK	(XFS_DQTYPE_USER | \
 				 XFS_DQTYPE_PROJ | \
 				 XFS_DQTYPE_GROUP)
 
-#define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK)
+#define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK | \
+				 XFS_DQTYPE_BIGTIME)
 
 /*
  * XFS Quota Timers
@@ -1270,6 +1272,29 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DQ_GRACE_MIN	((int64_t)0)
 #define XFS_DQ_GRACE_MAX	((int64_t)U32_MAX)
 
+/*
+ * When bigtime is enabled, we trade a few bits of precision to expand the
+ * expiration timeout range to match that of big inode timestamps.  The grace
+ * periods stored in dquot 0 are not shifted, since they record an interval,
+ * not a timestamp.
+ */
+#define XFS_DQ_BIGTIME_SHIFT	(2)
+#define XFS_DQ_BIGTIME_SLACK	((int64_t)(1ULL << XFS_DQ_BIGTIME_SHIFT) - 1)
+
+/*
+ * Smallest possible quota expiration with big timestamps, which is
+ * Jan  1 00:00:01 UTC 1970.
+ */
+#define XFS_DQ_BIGTIMEOUT_MIN		(XFS_DQ_TIMEOUT_MIN)
+
+/*
+ * Largest supported quota expiration with traditional timestamps, which is
+ * the largest bigtime inode timestamp, or Jul  2 20:20:25 UTC 2486.  The field
+ * is large enough that it's possible to fit expirations up to 2514, but we
+ * want to keep the maximum timestamp in sync.
+ */
+#define XFS_DQ_BIGTIMEOUT_MAX		(XFS_INO_BIGTIME_MAX)
+
 /*
  * This is the main portion of the on-disk representation of quota information
  * for a user.  We pad this with some more expansion room to construct the on
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index b524059faab5..b9a47eae684b 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -23,7 +23,8 @@ typedef uint8_t		xfs_dqtype_t;
 #define XFS_DQTYPE_STRINGS \
 	{ XFS_DQTYPE_USER,	"USER" }, \
 	{ XFS_DQTYPE_PROJ,	"PROJ" }, \
-	{ XFS_DQTYPE_GROUP,	"GROUP" }
+	{ XFS_DQTYPE_GROUP,	"GROUP" }, \
+	{ XFS_DQTYPE_BIGTIME,	"BIGTIME" }
 
 /*
  * flags for q_flags field in the dquot.
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 08d497d413b9..6bc1f6e90c3e 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -110,9 +110,15 @@ xfs_dquot_set_grace_period(
 /* Set the expiration time of a quota's grace period. */
 void
 xfs_dquot_set_timeout(
+	struct xfs_mount	*mp,
 	time64_t		*timer,
 	time64_t		value)
 {
+	if (xfs_sb_version_hasbigtime(&mp->m_sb)) {
+		*timer = clamp_t(time64_t, value, XFS_DQ_BIGTIMEOUT_MIN,
+						  XFS_DQ_BIGTIMEOUT_MAX);
+		return;
+	}
 	*timer = clamp_t(time64_t, value, XFS_DQ_TIMEOUT_MIN,
 					  XFS_DQ_TIMEOUT_MAX);
 }
@@ -123,6 +129,7 @@ xfs_dquot_set_timeout(
  */
 static inline void
 xfs_qm_adjust_res_timer(
+	struct xfs_dquot	*dqp,
 	struct xfs_dquot_res	*res,
 	struct xfs_quota_limits	*qlim)
 {
@@ -131,7 +138,7 @@ xfs_qm_adjust_res_timer(
 	if ((res->softlimit && res->count > res->softlimit) ||
 	    (res->hardlimit && res->count > res->hardlimit)) {
 		if (res->timer == 0)
-			xfs_dquot_set_timeout(&res->timer,
+			xfs_dquot_set_timeout(dqp->q_mount, &res->timer,
 					ktime_get_real_seconds() + qlim->time);
 	} else {
 		if (res->timer == 0)
@@ -165,9 +172,9 @@ xfs_qm_adjust_dqtimers(
 	ASSERT(dq->q_id);
 	defq = xfs_get_defquota(qi, xfs_dquot_type(dq));
 
-	xfs_qm_adjust_res_timer(&dq->q_blk, &defq->blk);
-	xfs_qm_adjust_res_timer(&dq->q_ino, &defq->ino);
-	xfs_qm_adjust_res_timer(&dq->q_rtb, &defq->rtb);
+	xfs_qm_adjust_res_timer(dq, &dq->q_blk, &defq->blk);
+	xfs_qm_adjust_res_timer(dq, &dq->q_ino, &defq->ino);
+	xfs_qm_adjust_res_timer(dq, &dq->q_rtb, &defq->rtb);
 }
 
 /*
@@ -221,6 +228,8 @@ xfs_qm_init_dquot_blk(
 		d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
 		d->dd_diskdq.d_id = cpu_to_be32(curid);
 		d->dd_diskdq.d_type = type;
+		if (curid > 0 && xfs_sb_version_hasbigtime(&mp->m_sb))
+			d->dd_diskdq.d_type |= XFS_DQTYPE_BIGTIME;
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			uuid_copy(&d->dd_uuid, &mp->m_sb.sb_meta_uuid);
 			xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
@@ -1165,6 +1174,14 @@ xfs_qm_dqflush_check(
 	    !dqp->q_rtb.timer)
 		return __this_address;
 
+	/* bigtime flag should never be set on root dquots */
+	if (dqp->q_type & XFS_DQTYPE_BIGTIME) {
+		if (!xfs_sb_version_hasbigtime(&dqp->q_mount->m_sb))
+			return __this_address;
+		if (dqp->q_id == 0)
+			return __this_address;
+	}
+
 	return NULL;
 }
 
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 0ba4d91c3a11..74ca87e02a14 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -238,6 +238,7 @@ int xfs_qm_dqiterate(struct xfs_mount *mp, xfs_dqtype_t type,
 		xfs_qm_dqiterate_fn iter_fn, void *priv);
 
 void xfs_dquot_set_grace_period(time64_t *timer, time64_t limit);
-void xfs_dquot_set_timeout(time64_t *timer, time64_t limit);
+void xfs_dquot_set_timeout(struct xfs_mount *mp, time64_t *timer,
+		time64_t limit);
 
 #endif /* __XFS_DQUOT_H__ */
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 3e0c677cff15..cc12d6e1c89a 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -32,6 +32,13 @@ xfs_check_limits(void)
 	XFS_CHECK_VALUE(XFS_DQ_TIMEOUT_MAX,			4294967295LL);
 	XFS_CHECK_VALUE(XFS_DQ_GRACE_MIN,			0LL);
 	XFS_CHECK_VALUE(XFS_DQ_GRACE_MAX,			4294967295LL);
+	XFS_CHECK_VALUE(XFS_DQ_BIGTIMEOUT_MIN,			1LL);
+	XFS_CHECK_VALUE(XFS_DQ_BIGTIMEOUT_MAX,			16299260425LL);
+
+	BUILD_BUG_ON_MSG((XFS_DQ_TIMEOUT_MAX << XFS_DQ_BIGTIME_SHIFT) <
+			 XFS_DQ_BIGTIMEOUT_MAX,
+			 "XFS: quota timeout field is not large enough to fit "
+			 "XFS_DQ_BIGTIMEOUT_MAX");
 }
 
 static inline void __init
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index be67570badf8..a5136e40e118 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -879,6 +879,8 @@ xfs_qm_reset_dqcounts(
 			ddq->d_bwarns = 0;
 			ddq->d_iwarns = 0;
 			ddq->d_rtbwarns = 0;
+			if (xfs_sb_version_hasbigtime(&mp->m_sb))
+				ddq->d_type |= XFS_DQTYPE_BIGTIME;
 		}
 
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 95b0c25b9969..4d9c245d65c2 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -479,6 +479,7 @@ xfs_setqlim_warns(
 
 static inline void
 xfs_setqlim_timer(
+	struct xfs_dquot	*dqp,
 	struct xfs_dquot_res	*res,
 	struct xfs_quota_limits	*qlim,
 	s64			timer)
@@ -489,7 +490,7 @@ xfs_setqlim_timer(
 		qlim->time = res->timer;
 	} else {
 		/* Set the grace period expiration on a quota. */
-		xfs_dquot_set_timeout(&res->timer, timer);
+		xfs_dquot_set_timeout(dqp->q_mount, &res->timer, timer);
 	}
 }
 
@@ -579,7 +580,7 @@ xfs_qm_scall_setqlim(
 	if (newlim->d_fieldmask & QC_SPC_WARNS)
 		xfs_setqlim_warns(res, qlim, newlim->d_spc_warns);
 	if (newlim->d_fieldmask & QC_SPC_TIMER)
-		xfs_setqlim_timer(res, qlim, newlim->d_spc_timer);
+		xfs_setqlim_timer(dqp, res, qlim, newlim->d_spc_timer);
 
 	/* Blocks on the realtime device. */
 	hard = (newlim->d_fieldmask & QC_RT_SPC_HARD) ?
@@ -595,7 +596,7 @@ xfs_qm_scall_setqlim(
 	if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
 		xfs_setqlim_warns(res, qlim, newlim->d_rt_spc_warns);
 	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
-		xfs_setqlim_timer(res, qlim, newlim->d_rt_spc_timer);
+		xfs_setqlim_timer(dqp, res, qlim, newlim->d_rt_spc_timer);
 
 	/* Inodes */
 	hard = (newlim->d_fieldmask & QC_INO_HARD) ?
@@ -611,7 +612,7 @@ xfs_qm_scall_setqlim(
 	if (newlim->d_fieldmask & QC_INO_WARNS)
 		xfs_setqlim_warns(res, qlim, newlim->d_ino_warns);
 	if (newlim->d_fieldmask & QC_INO_TIMER)
-		xfs_setqlim_timer(res, qlim, newlim->d_ino_timer);
+		xfs_setqlim_timer(dqp, res, qlim, newlim->d_ino_timer);
 
 	if (id != 0) {
 		/*
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index c6ba7ef18e06..133fc6fc3edd 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -55,6 +55,12 @@ xfs_trans_log_dquot(
 {
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 
+	/* Upgrade the dquot to bigtime format if possible. */
+	if (dqp->q_id != 0 &&
+	    xfs_sb_version_hasbigtime(&tp->t_mountp->m_sb) &&
+	    !(dqp->q_type & XFS_DQTYPE_BIGTIME))
+		dqp->q_type |= XFS_DQTYPE_BIGTIME;
+
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &dqp->q_logitem.qli_item.li_flags);
 }

