Return-Path: <SRS0=iu4H=AQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4851AC433E0
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AAF62075B
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:13:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nrRqN5fd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgGEWNE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jul 2020 18:13:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45010 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbgGEWNE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jul 2020 18:13:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MCs8A002397
        for <linux-xfs@vger.kernel.org>; Sun, 5 Jul 2020 22:13:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Et6ZvbJw5F4PYflwq1Fab6MaZBQynLE8w1c2IiJP7eA=;
 b=nrRqN5fdeZXFwyCZhE657wu+0ihITYGFL2qOyFkh8QuBwEFtOwdWw+HnMD2RzlUxtdIq
 pHgcT/YEumdeQuiPU+Hj/53pjTJTmnheb3M8Uj7gThKfGWNzIvDKkAqhLFEn3eeGt3wD
 TnaGYbHyH64rYMnakCv/3ruB6r1Nv7JlC96PVsEXrulzEST+mFr6gfv2N0y3PiuLe0Cx
 OpPLJFDCjUDl1qQ8HBOqTN4vwRUBdo8n2zvA9S0d7/DguIqfb+xpd7QVyfooqNusbP8N
 lLQVyyeUzxIzfP9WE5YPW9TRPta8i3Y6kw9DvvZK3XR5lSquJiFlqgFU3/gHK9itGiw9 +g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 322h6r3j2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sun, 05 Jul 2020 22:13:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065M86WS055678
        for <linux-xfs@vger.kernel.org>; Sun, 5 Jul 2020 22:13:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3233pubj80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 05 Jul 2020 22:13:02 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 065MD1DJ018132
        for <linux-xfs@vger.kernel.org>; Sun, 5 Jul 2020 22:13:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 05 Jul 2020 15:13:00 -0700
Subject: [PATCH 04/22] xfs: split dquot flags
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 05 Jul 2020 15:13:00 -0700
Message-ID: <159398718001.425236.11382626384865972595.stgit@magnolia>
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
 definitions=main-2007050171
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

Split the dquot flags space between incore dquots (XFS_DQ_*) and ondisk
dquots (XFS_DQFLAG_*).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c   |   15 ++++++++++-----
 fs/xfs/libxfs/xfs_format.h      |   12 +++++++++++-
 fs/xfs/libxfs/xfs_quota_defs.h  |    6 +++---
 fs/xfs/xfs_dquot.c              |    4 ++--
 fs/xfs/xfs_dquot_item_recover.c |    4 ++--
 fs/xfs/xfs_qm.c                 |   21 ++++++++++++---------
 6 files changed, 40 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index bedc1e752b60..3d8abfaf8bcf 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -40,6 +40,8 @@ xfs_dquot_verify(
 	xfs_dqid_t		id,
 	uint			type)	/* used only during quotacheck */
 {
+	unsigned int		dtype;
+
 	/*
 	 * We can encounter an uninitialized dquot buffer for 2 reasons:
 	 * 1. If we crash while deleting the quotainode(s), and those blks got
@@ -60,11 +62,14 @@ xfs_dquot_verify(
 	if (ddq->d_version != XFS_DQUOT_VERSION)
 		return __this_address;
 
-	if (type && ddq->d_flags != type)
+	if (ddq->d_flags & ~XFS_DDQFEAT_ANY)
 		return __this_address;
-	if (ddq->d_flags != XFS_DQ_USER &&
-	    ddq->d_flags != XFS_DQ_PROJ &&
-	    ddq->d_flags != XFS_DQ_GROUP)
+	dtype = ddq->d_flags & XFS_DDQFEAT_TYPE_MASK;
+	if (type && dtype != type)
+		return __this_address;
+	if (dtype != XFS_DDQFEAT_USER &&
+	    dtype != XFS_DDQFEAT_PROJ &&
+	    dtype != XFS_DDQFEAT_GROUP)
 		return __this_address;
 
 	if (id != -1 && id != be32_to_cpu(ddq->d_id))
@@ -123,7 +128,7 @@ xfs_dqblk_repair(
 
 	dqb->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
 	dqb->dd_diskdq.d_version = XFS_DQUOT_VERSION;
-	dqb->dd_diskdq.d_flags = type;
+	dqb->dd_diskdq.d_flags = type & XFS_DDQFEAT_TYPE_MASK;
 	dqb->dd_diskdq.d_id = cpu_to_be32(id);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index c74249063250..fcd270194e47 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1150,6 +1150,16 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DQUOT_MAGIC		0x4451		/* 'DQ' */
 #define XFS_DQUOT_VERSION	(uint8_t)0x01	/* latest version number */
 
+#define XFS_DDQFEAT_USER	0x01		/* user dquot record */
+#define XFS_DDQFEAT_PROJ	0x02		/* project dquot record */
+#define XFS_DDQFEAT_GROUP	0x04		/* group dquot record */
+
+#define XFS_DDQFEAT_TYPE_MASK	(XFS_DDQFEAT_USER | \
+				 XFS_DDQFEAT_PROJ | \
+				 XFS_DDQFEAT_GROUP)
+
+#define XFS_DDQFEAT_ANY		(XFS_DDQFEAT_TYPE_MASK)
+
 /*
  * This is the main portion of the on-disk representation of quota
  * information for a user. This is the q_core of the struct xfs_dquot that
@@ -1159,7 +1169,7 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 struct xfs_disk_dquot {
 	__be16		d_magic;	/* dquot magic = XFS_DQUOT_MAGIC */
 	__u8		d_version;	/* dquot version */
-	__u8		d_flags;	/* XFS_DQ_USER/PROJ/GROUP */
+	__u8		d_flags;	/* XFS_DDQFEAT_* */
 	__be32		d_id;		/* user,project,group id */
 	__be64		d_blk_hardlimit;/* absolute limit on disk blks */
 	__be64		d_blk_softlimit;/* preferred limit on disk blks */
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 56d9dd787e7b..396c10369771 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -21,9 +21,9 @@ typedef uint16_t	xfs_qwarncnt_t;
 /*
  * flags for q_flags field in the dquot.
  */
-#define XFS_DQ_USER		0x0001		/* a user quota */
-#define XFS_DQ_PROJ		0x0002		/* project quota */
-#define XFS_DQ_GROUP		0x0004		/* a group quota */
+#define XFS_DQ_USER		XFS_DDQFEAT_USER	/* a user quota */
+#define XFS_DQ_PROJ		XFS_DDQFEAT_PROJ	/* a project quota */
+#define XFS_DQ_GROUP		XFS_DDQFEAT_GROUP /* a group quota */
 #define XFS_DQ_DIRTY		0x0008		/* dquot is dirty */
 #define XFS_DQ_FREEING		0x0010		/* dquot is being torn down */
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 5bd963c774f8..883573927416 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -238,7 +238,7 @@ xfs_qm_init_dquot_blk(
 		d->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
 		d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
 		d->dd_diskdq.d_id = cpu_to_be32(curid);
-		d->dd_diskdq.d_flags = type;
+		d->dd_diskdq.d_flags = type & XFS_DDQFEAT_TYPE_MASK;
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			uuid_copy(&d->dd_uuid, &mp->m_sb.sb_meta_uuid);
 			xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
@@ -536,7 +536,7 @@ xfs_dquot_from_disk(
 	 * Ensure that we got the type and ID we were looking for.
 	 * Everything else was checked by the dquot buffer verifier.
 	 */
-	if ((ddqp->d_flags & XFS_DQ_ALLTYPES) != dqp->dq_flags ||
+	if ((ddqp->d_flags & XFS_DDQFEAT_TYPE_MASK) != dqp->dq_flags ||
 	    ddqp->d_id != dqp->q_core.d_id) {
 		xfs_alert_tag(bp->b_mount, XFS_PTAG_VERIFIER_ERROR,
 			  "Metadata corruption detected at %pS, quota %u",
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index 3400be4c88f0..edb4bd88f1a3 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -39,7 +39,7 @@ xlog_recover_dquot_ra_pass2(
 	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot))
 		return;
 
-	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
+	type = recddq->d_flags & XFS_DDQFEAT_TYPE_MASK;
 	ASSERT(type);
 	if (log->l_quotaoffs_flag & type)
 		return;
@@ -91,7 +91,7 @@ xlog_recover_dquot_commit_pass2(
 	/*
 	 * This type of quotas was turned off, so ignore this record.
 	 */
-	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
+	type = recddq->d_flags & XFS_DDQFEAT_TYPE_MASK;
 	ASSERT(type);
 	if (log->l_quotaoffs_flag & type)
 		return 0;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 938023dd8ce5..bd807f740eb9 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -826,13 +826,16 @@ xfs_qm_qino_alloc(
 	return error;
 }
 
-
+/*
+ * Reset the dquot counters.  type should be one of the ondisk quota type flags
+ * (XFS_DQUOT_{USER,GROUP,PROJECT}.
+ */
 STATIC void
 xfs_qm_reset_dqcounts(
-	xfs_mount_t	*mp,
-	xfs_buf_t	*bp,
-	xfs_dqid_t	id,
-	uint		type)
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp,
+	xfs_dqid_t		id,
+	unsigned int		type)
 {
 	struct xfs_dqblk	*dqb;
 	int			j;
@@ -869,7 +872,7 @@ xfs_qm_reset_dqcounts(
 		 * Reset type in case we are reusing group quota file for
 		 * project quotas or vice versa
 		 */
-		ddq->d_flags = type;
+		ddq->d_flags = type & XFS_DDQFEAT_TYPE_MASK;
 		ddq->d_bcount = 0;
 		ddq->d_icount = 0;
 		ddq->d_rtbcount = 0;
@@ -907,11 +910,11 @@ xfs_qm_reset_dqcounts_all(
 {
 	struct xfs_buf		*bp;
 	int			error;
-	int			type;
+	unsigned int		type;
 
 	ASSERT(blkcnt > 0);
-	type = flags & XFS_QMOPT_UQUOTA ? XFS_DQ_USER :
-		(flags & XFS_QMOPT_PQUOTA ? XFS_DQ_PROJ : XFS_DQ_GROUP);
+	type = flags & XFS_QMOPT_UQUOTA ? XFS_DDQFEAT_USER :
+		(flags & XFS_QMOPT_PQUOTA ? XFS_DDQFEAT_PROJ : XFS_DDQFEAT_GROUP);
 	error = 0;
 
 	/*

