Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF432C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E6E520718
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:12:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jVQ4vAxZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgAABMc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:12:32 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50524 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABMc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:12:32 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00119egF091654
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Ip48OOXndwthn4TFrMhP9arr1pcq4s3RQ2MjxZo77FA=;
 b=jVQ4vAxZUcmvsVuD+7LpvzfrSYdFROetgN9uiX06eQW+bCUVnSBgTI4ExQUF5RCMnRij
 fIaQCO+uiwqaWPgsYd7juyNYp45LAfzO2AQvJlokoKVOOpJF3AoB/EHUpXiKCPnnOZjx
 vtoNlH8QEeFXO2qzxWjQ0eD0YDgrvh7u8gU7Ne7UmFOrhKPUcxuvRldaZlXzbJ1KdCOs
 CczsiN7+FsxSnpeWhGj3HEbWlrwUqgsUJiBGekvBiSJaH28xjkRc93CfRv/Mru7aMRfE
 JcGGhH1kuM9nKDNPuVaAPAHvVJ5TQtggzM4+Da3xqlYAXEl0EceAlTYMETY+LME9LHnW cQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:12:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xG9012465
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2x8guef2hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:12:29 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011CSOP000304
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:28 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:12:27 -0800
Subject: [PATCH 13/14] xfs: enable bigtime for quota timers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:12:25 -0800
Message-ID: <157784114490.1364230.7521571821422773694.stgit@magnolia>
In-Reply-To: <157784106066.1364230.569420432829402226.stgit@magnolia>
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Enable the bigtime feature for quota timers.  We decrease the accuracy
of the timers to ~4s in exchange for being able to set timers up to the
bigtime maximum.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c  |   72 ++++++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_format.h     |   22 ++++++++++++
 fs/xfs/libxfs/xfs_quota_defs.h |   11 ++++--
 fs/xfs/scrub/quota.c           |    5 +++
 fs/xfs/xfs_dquot.c             |   71 +++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_ondisk.h            |    6 +++
 fs/xfs/xfs_qm.c                |   13 ++++---
 fs/xfs/xfs_qm.h                |    8 ++--
 fs/xfs/xfs_qm_syscalls.c       |   19 ++++++-----
 9 files changed, 186 insertions(+), 41 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 72e0fcfef580..2b5d51a6d64b 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -40,6 +40,8 @@ xfs_dquot_verify(
 	xfs_dqid_t		id,
 	uint			type)	/* used only during quotacheck */
 {
+	uint8_t			dtype;
+
 	/*
 	 * We can encounter an uninitialized dquot buffer for 2 reasons:
 	 * 1. If we crash while deleting the quotainode(s), and those blks got
@@ -60,11 +62,22 @@ xfs_dquot_verify(
 	if (ddq->d_version != XFS_DQUOT_VERSION)
 		return __this_address;
 
-	if (type && ddq->d_flags != type)
+	dtype = ddq->d_flags & XFS_DQ_ALLTYPES;
+	if (type && dtype != type)
+		return __this_address;
+	if (dtype != XFS_DQ_USER &&
+	    dtype != XFS_DQ_PROJ &&
+	    dtype != XFS_DQ_GROUP)
+		return __this_address;
+
+	if (ddq->d_flags & ~(XFS_DQ_ALLTYPES | XFS_DQ_BIGTIME))
 		return __this_address;
-	if (ddq->d_flags != XFS_DQ_USER &&
-	    ddq->d_flags != XFS_DQ_PROJ &&
-	    ddq->d_flags != XFS_DQ_GROUP)
+
+	if ((ddq->d_flags & XFS_DQ_BIGTIME) &&
+	    !xfs_sb_version_hasbigtime(&mp->m_sb))
+		return __this_address;
+
+	if ((ddq->d_flags & XFS_DQ_BIGTIME) && !ddq->d_id)
 		return __this_address;
 
 	if (id != -1 && id != be32_to_cpu(ddq->d_id))
@@ -290,17 +303,68 @@ const struct xfs_buf_ops xfs_dquot_buf_ra_ops = {
 
 void
 xfs_dquot_from_disk_timestamp(
+	struct xfs_disk_dquot	*ddq,
 	struct timespec64	*tv,
 	__be32			dtimer)
 {
 	tv->tv_nsec = 0;
+
+	/* Zero always means zero, regardless of encoding. */
+	if (!dtimer) {
+		tv->tv_sec = 0;
+		return;
+	}
+
+	if (ddq->d_flags & XFS_DQ_BIGTIME) {
+		uint64_t	t;
+
+		t = be32_to_cpu(dtimer);
+		tv->tv_sec = t << XFS_DQ_BIGTIME_SHIFT;
+		return;
+	}
+
 	tv->tv_sec = be32_to_cpu(dtimer);
 }
 
 void
 xfs_dquot_to_disk_timestamp(
+	struct xfs_disk_dquot	*ddq,
 	__be32			*dtimer,
 	const struct timespec64	*tv)
 {
+	/* Zero always means zero, regardless of encoding. */
+	if ((ddq->d_flags & XFS_DQ_BIGTIME) && tv->tv_sec != 0) {
+		uint64_t	t = tv->tv_sec;
+
+		/*
+		 * Round the end of the grace period up to the nearest bigtime
+		 * interval that we support, to give users the most time to fix
+		 * the problems.
+		 */
+		t = roundup_64(t, 1U << XFS_DQ_BIGTIME_SHIFT);
+		*dtimer = cpu_to_be32(t >> XFS_DQ_BIGTIME_SHIFT);
+		return;
+	}
+
 	*dtimer = cpu_to_be32(tv->tv_sec);
 }
+
+/*
+ * Convert the dquot to bigtime format incore so that we'll write out the new
+ * values the next time we flush the dquot to disk.  Skip this for d_id == 0
+ * because that dquot stores the grace period intervals.  Returns true if we
+ * upgraded the format, false otherwise.
+ */
+bool
+xfs_dquot_add_bigtime(
+	struct xfs_mount	*mp,
+	struct xfs_disk_dquot	*ddq)
+{
+	if (xfs_sb_version_hasbigtime(&mp->m_sb) && ddq->d_id &&
+	    !(ddq->d_flags & XFS_DQ_BIGTIME)) {
+		ddq->d_flags |= XFS_DQ_BIGTIME;
+		return true;
+	}
+
+	return false;
+}
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 9b127e4f4077..bab0b23720bb 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1248,6 +1248,28 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DQ_GRACE_MIN	((int64_t)0)
 #define XFS_DQ_GRACE_MAX	((int64_t)U32_MAX)
 
+/*
+ * When bigtime is enabled, we trade a few bits of precision to expand the
+ * expiration timeout range to match that of big inode timestamps.  The grace
+ * periods stored in dquot 0 are not shifted, since they record an interval,
+ * not a timestamp.
+ */
+#define XFS_DQ_BIGTIME_SHIFT		(2)
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
  * This is the main portion of the on-disk representation of quota
  * information for a user. This is the q_core of the struct xfs_dquot that
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index c453611ade3b..4ac486fd20a8 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -26,6 +26,7 @@ typedef uint16_t	xfs_qwarncnt_t;
 #define XFS_DQ_GROUP		0x0004		/* a group quota */
 #define XFS_DQ_DIRTY		0x0008		/* dquot is dirty */
 #define XFS_DQ_FREEING		0x0010		/* dquot is being torn down */
+#define XFS_DQ_BIGTIME		0x0020		/* big timestamp format */
 
 #define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
 
@@ -34,7 +35,8 @@ typedef uint16_t	xfs_qwarncnt_t;
 	{ XFS_DQ_PROJ,		"PROJ" }, \
 	{ XFS_DQ_GROUP,		"GROUP" }, \
 	{ XFS_DQ_DIRTY,		"DIRTY" }, \
-	{ XFS_DQ_FREEING,	"FREEING" }
+	{ XFS_DQ_FREEING,	"FREEING" }, \
+	{ XFS_DQ_BIGTIME,	"BIGTIME" }
 
 /*
  * We have the possibility of all three quota types being active at once, and
@@ -144,7 +146,10 @@ extern xfs_failaddr_t xfs_dqblk_verify(struct xfs_mount *mp,
 extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
 extern void xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
 		xfs_dqid_t id, uint type);
-void xfs_dquot_from_disk_timestamp(struct timespec64 *tv, __be32 dtimer);
-void xfs_dquot_to_disk_timestamp(__be32 *dtimer, const struct timespec64 *tv);
+void xfs_dquot_from_disk_timestamp(struct xfs_disk_dquot *ddq,
+		struct timespec64 *tv, __be32 dtimer);
+void xfs_dquot_to_disk_timestamp(struct xfs_disk_dquot *ddq,
+		__be32 *dtimer, const struct timespec64 *tv);
+bool xfs_dquot_add_bigtime(struct xfs_mount *mp, struct xfs_disk_dquot *ddq);
 
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 64e24fe5dcb2..6ff402bc0a3e 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -135,6 +135,11 @@ xchk_quota_item(
 	if (d->d_pad0 != cpu_to_be32(0) || d->d_pad != cpu_to_be16(0))
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
+	/* incore should always have bigtime iflag set except for root */
+	if (xfs_sb_version_hasbigtime(&mp->m_sb) && d->d_id &&
+	    !(d->d_flags & XFS_DQ_BIGTIME))
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+
 	/* Check the limits. */
 	bhard = be64_to_cpu(d->d_blk_hardlimit);
 	ihard = be64_to_cpu(d->d_ino_hardlimit);
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 763e974f7aad..88b37098c6f4 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -118,35 +118,42 @@ xfs_quota_exceeded(
  */
 static inline time64_t
 xfs_dquot_clamp_timer(
-	time64_t			timer)
+	struct xfs_disk_dquot	*ddq,
+	time64_t		timer)
 {
+	if (ddq->d_flags & XFS_DQ_BIGTIME)
+		return clamp_t(time64_t, timer, XFS_DQ_BIGTIMEOUT_MIN,
+						XFS_DQ_BIGTIMEOUT_MAX);
 	return clamp_t(time64_t, timer, XFS_DQ_TIMEOUT_MIN, XFS_DQ_TIMEOUT_MAX);
 }
 
 /* Set a quota grace period expiration timer. */
 static inline void
 xfs_quota_set_timer(
+	struct xfs_disk_dquot	*ddq,
 	time64_t		*itimer,
 	__be32			*dtimer,
-	time_t			limit)
+	time64_t		limit)
 {
 	struct timespec64	tv = { 0 };
 
-	tv.tv_sec = xfs_dquot_clamp_timer(ktime_get_real_seconds() + limit);
+	tv.tv_sec = xfs_dquot_clamp_timer(ddq,
+			ktime_get_real_seconds() + limit);
 	*itimer = tv.tv_sec;
-	xfs_dquot_to_disk_timestamp(dtimer, &tv);
+	xfs_dquot_to_disk_timestamp(ddq, dtimer, &tv);
 }
 
 /* Clear a quota grace period expiration timer. */
 static inline void
 xfs_quota_clear_timer(
+	struct xfs_disk_dquot	*ddq,
 	time64_t		*itimer,
 	__be32			*dtimer)
 {
 	struct timespec64	tv = { 0 };
 
 	*itimer = tv.tv_sec;
-	xfs_dquot_to_disk_timestamp(dtimer, &tv);
+	xfs_dquot_to_disk_timestamp(ddq, dtimer, &tv);
 }
 
 /*
@@ -188,14 +195,14 @@ xfs_qm_adjust_dqtimers(
 			&d->d_blk_softlimit, &d->d_blk_hardlimit);
 	if (!dqp->q_btimer) {
 		if (over) {
-			xfs_quota_set_timer(&dqp->q_btimer, &d->d_btimer,
+			xfs_quota_set_timer(d, &dqp->q_btimer, &d->d_btimer,
 					mp->m_quotainfo->qi_btimelimit);
 		} else {
 			d->d_bwarns = 0;
 		}
 	} else {
 		if (!over) {
-			xfs_quota_clear_timer(&dqp->q_btimer, &d->d_btimer);
+			xfs_quota_clear_timer(d, &dqp->q_btimer, &d->d_btimer);
 		}
 	}
 
@@ -203,14 +210,14 @@ xfs_qm_adjust_dqtimers(
 			&d->d_ino_softlimit, &d->d_ino_hardlimit);
 	if (!dqp->q_itimer) {
 		if (over) {
-			xfs_quota_set_timer(&dqp->q_itimer, &d->d_itimer,
+			xfs_quota_set_timer(d, &dqp->q_itimer, &d->d_itimer,
 					mp->m_quotainfo->qi_itimelimit);
 		} else {
 			d->d_iwarns = 0;
 		}
 	} else {
 		if (!over) {
-			xfs_quota_clear_timer(&dqp->q_itimer, &d->d_itimer);
+			xfs_quota_clear_timer(d, &dqp->q_itimer, &d->d_itimer);
 		}
 	}
 
@@ -218,14 +225,16 @@ xfs_qm_adjust_dqtimers(
 			&d->d_rtb_softlimit, &d->d_rtb_hardlimit);
 	if (!dqp->q_rtbtimer) {
 		if (over) {
-			xfs_quota_set_timer(&dqp->q_rtbtimer, &d->d_rtbtimer,
+			xfs_quota_set_timer(d, &dqp->q_rtbtimer,
+					&d->d_rtbtimer,
 					mp->m_quotainfo->qi_rtbtimelimit);
 		} else {
 			d->d_rtbwarns = 0;
 		}
 	} else {
 		if (!over) {
-			xfs_quota_clear_timer(&dqp->q_rtbtimer, &d->d_rtbtimer);
+			xfs_quota_clear_timer(d, &dqp->q_rtbtimer,
+					&d->d_rtbtimer);
 		}
 	}
 }
@@ -261,6 +270,7 @@ xfs_qm_init_dquot_blk(
 		d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
 		d->dd_diskdq.d_id = cpu_to_be32(curid);
 		d->dd_diskdq.d_flags = type;
+		xfs_dquot_add_bigtime(mp, &d->dd_diskdq);
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			uuid_copy(&d->dd_uuid, &mp->m_sb.sb_meta_uuid);
 			xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
@@ -528,9 +538,10 @@ xfs_dquot_from_disk(
 {
 	struct timespec64	tv;
 	struct xfs_disk_dquot	*ddqp = bp->b_addr + dqp->q_bufoffset;
+	struct xfs_disk_dquot	*iddq = &dqp->q_core;
 
 	/* copy everything from disk dquot to the incore dquot */
-	memcpy(&dqp->q_core, ddqp, sizeof(struct xfs_disk_dquot));
+	memcpy(iddq, ddqp, sizeof(struct xfs_disk_dquot));
 
 	/*
 	 * Reservation counters are defined as reservation plus current usage
@@ -540,13 +551,28 @@ xfs_dquot_from_disk(
 	dqp->q_res_icount = be64_to_cpu(ddqp->d_icount);
 	dqp->q_res_rtbcount = be64_to_cpu(ddqp->d_rtbcount);
 
-	xfs_dquot_from_disk_timestamp(&tv, ddqp->d_btimer);
+	xfs_dquot_from_disk_timestamp(ddqp, &tv, ddqp->d_btimer);
 	dqp->q_btimer = tv.tv_sec;
-	xfs_dquot_from_disk_timestamp(&tv, ddqp->d_itimer);
+	xfs_dquot_from_disk_timestamp(ddqp, &tv, ddqp->d_itimer);
 	dqp->q_itimer = tv.tv_sec;
-	xfs_dquot_from_disk_timestamp(&tv, ddqp->d_rtbtimer);
+	xfs_dquot_from_disk_timestamp(ddqp, &tv, ddqp->d_rtbtimer);
 	dqp->q_rtbtimer = tv.tv_sec;
 
+	/* Upgrade to bigtime if possible. */
+	if (xfs_dquot_add_bigtime(dqp->q_mount, iddq)) {
+		tv.tv_sec = xfs_dquot_clamp_timer(iddq, dqp->q_btimer);
+		xfs_dquot_to_disk_timestamp(iddq, &iddq->d_btimer, &tv);
+		dqp->q_btimer = tv.tv_sec;
+
+		tv.tv_sec = xfs_dquot_clamp_timer(iddq, dqp->q_itimer);
+		xfs_dquot_to_disk_timestamp(iddq, &iddq->d_itimer, &tv);
+		dqp->q_itimer = tv.tv_sec;
+
+		tv.tv_sec = xfs_dquot_clamp_timer(iddq, dqp->q_rtbtimer);
+		xfs_dquot_to_disk_timestamp(iddq, &iddq->d_rtbtimer, &tv);
+		dqp->q_rtbtimer = tv.tv_sec;
+	}
+
 	/* initialize the dquot speculative prealloc thresholds */
 	xfs_dquot_set_prealloc_limits(dqp);
 }
@@ -1175,6 +1201,21 @@ xfs_qm_dqflush(
 	/* This is the only portion of data that needs to persist */
 	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
 
+	/*
+	 * We should never write non-bigtime dquots to a bigtime fs, except for
+	 * the root dquot.
+	 */
+	if (!(dqp->q_core.d_flags & XFS_DQ_BIGTIME) && dqp->q_core.d_id &&
+	    xfs_sb_version_hasbigtime(&mp->m_sb)) {
+		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
+				be32_to_cpu(ddqp->d_id), __this_address);
+		xfs_buf_relse(bp);
+		xfs_dqfunlock(dqp);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		xfs_quota_mark_sick(mp, dqp->dq_flags);
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * Clear the dirty field and remember the flush lsn for later use.
 	 */
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 86b9e0e07f84..940522f78a37 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -32,6 +32,12 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_VALUE(XFS_DQ_TIMEOUT_MAX,			4294967295LL);
 	XFS_CHECK_VALUE(XFS_DQ_GRACE_MIN,			0LL);
 	XFS_CHECK_VALUE(XFS_DQ_GRACE_MAX,			4294967295LL);
+	XFS_CHECK_VALUE(XFS_DQ_BIGTIMEOUT_MIN,			1LL);
+	XFS_CHECK_VALUE(XFS_DQ_BIGTIMEOUT_MAX,			16299260425LL);
+	BUILD_BUG_ON_MSG((XFS_DQ_TIMEOUT_MAX << XFS_DQ_BIGTIME_SHIFT) <
+			 XFS_DQ_BIGTIMEOUT_MAX,
+			 "XFS: quota timeout field is not large enough to fit "
+			 "XFS_DQ_BIGTIMEOUT_MAX");
 
 	/* ag/file structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_acl,			4);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 9be123a0902e..fb671be5ca25 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -630,15 +630,15 @@ xfs_qm_init_timelimits(
 	 * more writing. If it is zero, a default is used.
 	 */
 	if (ddqp->d_btimer) {
-		xfs_dquot_from_disk_timestamp(&tv, ddqp->d_btimer);
+		xfs_dquot_from_disk_timestamp(ddqp, &tv, ddqp->d_btimer);
 		qinf->qi_btimelimit = tv.tv_sec;
 	}
 	if (ddqp->d_itimer) {
-		xfs_dquot_from_disk_timestamp(&tv, ddqp->d_itimer);
+		xfs_dquot_from_disk_timestamp(ddqp, &tv, ddqp->d_itimer);
 		qinf->qi_itimelimit = tv.tv_sec;
 	}
 	if (ddqp->d_rtbtimer) {
-		xfs_dquot_from_disk_timestamp(&tv, ddqp->d_rtbtimer);
+		xfs_dquot_from_disk_timestamp(ddqp, &tv, ddqp->d_rtbtimer);
 		qinf->qi_rtbtimelimit = tv.tv_sec;
 	}
 	if (ddqp->d_bwarns)
@@ -860,17 +860,17 @@ xfs_qm_reset_dqintervals(
 
 	if (qinf->qi_btimelimit != XFS_QM_BTIMELIMIT) {
 		tv.tv_sec = qinf->qi_btimelimit;
-		xfs_dquot_to_disk_timestamp(&ddq->d_btimer, &tv);
+		xfs_dquot_to_disk_timestamp(ddq, &ddq->d_btimer, &tv);
 	}
 
 	if (qinf->qi_itimelimit != XFS_QM_ITIMELIMIT) {
 		tv.tv_sec = qinf->qi_itimelimit;
-		xfs_dquot_to_disk_timestamp(&ddq->d_itimer, &tv);
+		xfs_dquot_to_disk_timestamp(ddq, &ddq->d_itimer, &tv);
 	}
 
 	if (qinf->qi_rtbtimelimit != XFS_QM_RTBTIMELIMIT) {
 		tv.tv_sec = qinf->qi_rtbtimelimit;
-		xfs_dquot_to_disk_timestamp(&ddq->d_rtbtimer, &tv);
+		xfs_dquot_to_disk_timestamp(ddq, &ddq->d_rtbtimer, &tv);
 	}
 }
 
@@ -928,6 +928,7 @@ xfs_qm_reset_dqcounts(
 		ddq->d_rtbwarns = 0;
 		if (!ddq->d_id)
 			xfs_qm_reset_dqintervals(mp, ddq);
+		xfs_dquot_add_bigtime(mp, ddq);
 
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			xfs_update_cksum((char *)&dqb[j],
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index a3d9932f2e65..d3b69524ca18 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -64,9 +64,9 @@ struct xfs_quotainfo {
 	struct xfs_inode	*qi_pquotaip;	/* project quota inode */
 	struct list_lru	 qi_lru;
 	int		 qi_dquots;
-	time_t		 qi_btimelimit;	 /* limit for blks timer */
-	time_t		 qi_itimelimit;	 /* limit for inodes timer */
-	time_t		 qi_rtbtimelimit;/* limit for rt blks timer */
+	time64_t	 qi_btimelimit;	 /* limit for blks timer */
+	time64_t	 qi_itimelimit;	 /* limit for inodes timer */
+	time64_t	 qi_rtbtimelimit;/* limit for rt blks timer */
 	xfs_qwarncnt_t	 qi_bwarnlimit;	 /* limit for blks warnings */
 	xfs_qwarncnt_t	 qi_iwarnlimit;	 /* limit for inodes warnings */
 	xfs_qwarncnt_t	 qi_rtbwarnlimit;/* limit for rt blks warnings */
@@ -84,7 +84,7 @@ xfs_dquot_tree(
 	struct xfs_quotainfo	*qi,
 	int			type)
 {
-	switch (type) {
+	switch (type & XFS_DQ_ALLTYPES) {
 	case XFS_DQ_USER:
 		return &qi->qi_uquota_tree;
 	case XFS_DQ_GROUP:
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index bd9db42b89b9..47b63f820f50 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -441,7 +441,8 @@ xfs_qm_scall_quotaon(
 /* Set a new quota grace period. */
 static inline void
 xfs_qm_set_grace(
-	time_t			*qi_limit,
+	struct xfs_disk_dquot	*ddq,
+	time64_t		*qi_limit,
 	time64_t		*itimer,
 	__be32			*dtimer,
 	const s64		grace)
@@ -452,7 +453,7 @@ xfs_qm_set_grace(
 					     XFS_DQ_GRACE_MAX);
 	*qi_limit = tv.tv_sec;
 	*itimer = tv.tv_sec;
-	xfs_dquot_to_disk_timestamp(dtimer, &tv);
+	xfs_dquot_to_disk_timestamp(ddq, dtimer, &tv);
 }
 
 #define XFS_QC_MASK \
@@ -585,14 +586,14 @@ xfs_qm_scall_setqlim(
 		 * for warnings.
 		 */
 		if (newlim->d_fieldmask & QC_SPC_TIMER)
-			xfs_qm_set_grace(&q->qi_btimelimit, &dqp->q_btimer,
+			xfs_qm_set_grace(ddq, &q->qi_btimelimit, &dqp->q_btimer,
 					&ddq->d_btimer, newlim->d_spc_timer);
 		if (newlim->d_fieldmask & QC_INO_TIMER)
-			xfs_qm_set_grace(&q->qi_itimelimit, &dqp->q_itimer,
+			xfs_qm_set_grace(ddq, &q->qi_itimelimit, &dqp->q_itimer,
 					&ddq->d_itimer, newlim->d_ino_timer);
 		if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
-			xfs_qm_set_grace(&q->qi_rtbtimelimit, &dqp->q_rtbtimer,
-					&ddq->d_rtbtimer,
+			xfs_qm_set_grace(ddq, &q->qi_rtbtimelimit,
+					&dqp->q_rtbtimer, &ddq->d_rtbtimer,
 					newlim->d_rt_spc_timer);
 		if (newlim->d_fieldmask & QC_SPC_WARNS)
 			q->qi_bwarnlimit = newlim->d_spc_warns;
@@ -658,11 +659,11 @@ xfs_qm_scall_getquota_fill_qc(
 	 * so return zeroes in that case.
 	 */
 	if ((!XFS_IS_UQUOTA_ENFORCED(mp) &&
-	     dqp->q_core.d_flags == XFS_DQ_USER) ||
+	     (dqp->q_core.d_flags & XFS_DQ_ALLTYPES) == XFS_DQ_USER) ||
 	    (!XFS_IS_GQUOTA_ENFORCED(mp) &&
-	     dqp->q_core.d_flags == XFS_DQ_GROUP) ||
+	     (dqp->q_core.d_flags & XFS_DQ_ALLTYPES) == XFS_DQ_GROUP) ||
 	    (!XFS_IS_PQUOTA_ENFORCED(mp) &&
-	     dqp->q_core.d_flags == XFS_DQ_PROJ)) {
+	     (dqp->q_core.d_flags & XFS_DQ_ALLTYPES) == XFS_DQ_PROJ)) {
 		dst->d_spc_timer = 0;
 		dst->d_ino_timer = 0;
 		dst->d_rt_spc_timer = 0;

