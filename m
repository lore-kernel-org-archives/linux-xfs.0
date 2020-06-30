Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D79C3C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B92E720768
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nOO+abVp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389628AbgF3PmY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 11:42:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44394 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389635AbgF3PmY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 11:42:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFgMXF007099
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:42:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=rHm19oV70Ls38daaNwjAcYQ4D09rkH0YFbo/xaVRANM=;
 b=nOO+abVpWWf6PL6DVSgKRf52J3eWIm81rQymZJdMAwUK0JP+aoW5TbTQ0SvHweWjjkoG
 Y8+U+97d4zy05IyJy84/S287Hbf7vuIlYttBkQ9bsc0iJNrpw10znPewWZ/kx2uQ0Bas
 tV3jzun397Qv2o9BPbWw66n3rysniJWZKkWRzvM7UHyhL2aeu+/0tARG6fl1hyVX44XP
 abVogQv8jvOs30UpxH1UkfMUYK8cgOXaSM/AwU98IyzvrE3JLPleQl/HbArrf81NwZfj
 4H+wCHmswd+tAEQ0CbLl6m9VpAUC+6kAohSXMfhxPrRGUBzzbvxJrSH7ZxUwViPkvCIO CA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31wxrn59sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:42:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFNlJI051144
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:42:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31xg1wy5sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:42:18 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05UFgIZu000760
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:42:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 15:42:17 +0000
Subject: [PATCH 04/18] xfs: stop using q_core.d_flags in the quota code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 30 Jun 2020 08:42:16 -0700
Message-ID: <159353173676.2864738.5361850443664572160.stgit@magnolia>
In-Reply-To: <159353170983.2864738.16885438169173786208.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300112
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

Use the incore dq_flags to figure out the dquot type.  This is the first
step towards removing xfs_disk_dquot from the incore dquot.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_quota_defs.h |    2 ++
 fs/xfs/scrub/quota.c           |    4 ----
 fs/xfs/xfs_dquot.c             |   33 +++++++++++++++++++++++++++++++--
 fs/xfs/xfs_dquot.h             |    2 ++
 fs/xfs/xfs_dquot_item.c        |    6 ++++--
 fs/xfs/xfs_qm.c                |    4 ++--
 fs/xfs/xfs_qm.h                |    2 +-
 fs/xfs/xfs_qm_syscalls.c       |    9 +++------
 8 files changed, 45 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 56d9dd787e7b..459023b0a304 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -29,6 +29,8 @@ typedef uint16_t	xfs_qwarncnt_t;
 
 #define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
 
+#define XFS_DQ_ONDISK		(XFS_DQ_ALLTYPES)
+
 #define XFS_DQ_FLAGS \
 	{ XFS_DQ_USER,		"USER" }, \
 	{ XFS_DQ_PROJ,		"PROJ" }, \
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 905a34558361..710659d3fa28 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -108,10 +108,6 @@ xchk_quota_item(
 
 	sqi->last_id = id;
 
-	/* Did we get the dquot type we wanted? */
-	if (dqtype != (d->d_flags & XFS_DQ_ALLTYPES))
-		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
-
 	if (d->d_pad0 != cpu_to_be32(0) || d->d_pad != cpu_to_be16(0))
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 46c8ca83c04d..59d1bce34a98 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -561,6 +561,16 @@ xfs_dquot_from_disk(
 	return 0;
 }
 
+/* Copy the in-core quota fields into the on-disk buffer. */
+void
+xfs_dquot_to_disk(
+	struct xfs_disk_dquot	*ddqp,
+	struct xfs_dquot	*dqp)
+{
+	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
+	ddqp->d_flags = dqp->dq_flags & XFS_DQ_ONDISK;
+}
+
 /* Allocate and initialize the dquot buffer for this in-core dquot. */
 static int
 xfs_qm_dqread_alloc(
@@ -1108,6 +1118,17 @@ xfs_qm_dqflush_done(
 	xfs_dqfunlock(dqp);
 }
 
+/* Check incore dquot for errors before we flush. */
+static xfs_failaddr_t
+xfs_qm_dqflush_check(
+	struct xfs_dquot	*dqp)
+{
+	if (hweight8(dqp->dq_flags & XFS_DQ_ALLTYPES) != 1)
+		return __this_address;
+
+	return NULL;
+}
+
 /*
  * Write a modified dquot to disk.
  * The dquot must be locked and the flush lock too taken by caller.
@@ -1166,8 +1187,16 @@ xfs_qm_dqflush(
 		goto out_abort;
 	}
 
-	/* This is the only portion of data that needs to persist */
-	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
+	fa = xfs_qm_dqflush_check(dqp);
+	if (fa) {
+		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
+				be32_to_cpu(dqp->q_core.d_id), fa);
+		xfs_buf_relse(bp);
+		error = -EFSCORRUPTED;
+		goto out_abort;
+	}
+
+	xfs_dquot_to_disk(ddqp, dqp);
 
 	/*
 	 * Clear the dirty field and remember the flush lsn for later use.
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 71e36c85e20b..1b1a4261a580 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -144,6 +144,8 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
 	return false;
 }
 
+void xfs_dquot_to_disk(struct xfs_disk_dquot *ddqp, struct xfs_dquot *dqp);
+
 #define XFS_DQ_IS_LOCKED(dqp)	(mutex_is_locked(&((dqp)->q_qlock)))
 #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->dq_flags & XFS_DQ_DIRTY)
 #define XFS_QM_ISUDQ(dqp)	((dqp)->dq_flags & XFS_DQ_USER)
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 349c92d26570..ff0ab65cf413 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -45,6 +45,7 @@ xfs_qm_dquot_logitem_format(
 	struct xfs_log_item	*lip,
 	struct xfs_log_vec	*lv)
 {
+	struct xfs_disk_dquot	ddq;
 	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
 	struct xfs_log_iovec	*vecp = NULL;
 	struct xfs_dq_logformat	*qlf;
@@ -58,8 +59,9 @@ xfs_qm_dquot_logitem_format(
 	qlf->qlf_boffset = qlip->qli_dquot->q_bufoffset;
 	xlog_finish_iovec(lv, vecp, sizeof(struct xfs_dq_logformat));
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_DQUOT,
-			&qlip->qli_dquot->q_core,
+	xfs_dquot_to_disk(&ddq, qlip->qli_dquot);
+
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_DQUOT, &ddq,
 			sizeof(struct xfs_disk_dquot));
 }
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 938023dd8ce5..632025c2f00b 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -161,7 +161,7 @@ xfs_qm_dqpurge(
 	xfs_dqfunlock(dqp);
 	xfs_dqunlock(dqp);
 
-	radix_tree_delete(xfs_dquot_tree(qi, dqp->q_core.d_flags),
+	radix_tree_delete(xfs_dquot_tree(qi, dqp->dq_flags),
 			  be32_to_cpu(dqp->q_core.d_id));
 	qi->qi_dquots--;
 
@@ -1598,7 +1598,7 @@ xfs_qm_dqfree_one(
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 
 	mutex_lock(&qi->qi_tree_lock);
-	radix_tree_delete(xfs_dquot_tree(qi, dqp->q_core.d_flags),
+	radix_tree_delete(xfs_dquot_tree(qi, dqp->dq_flags),
 			  be32_to_cpu(dqp->q_core.d_id));
 
 	qi->qi_dquots--;
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 7b0e771fcbce..43b4650cdcdf 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -85,7 +85,7 @@ xfs_dquot_tree(
 	struct xfs_quotainfo	*qi,
 	int			type)
 {
-	switch (type) {
+	switch (type & XFS_DQ_ALLTYPES) {
 	case XFS_DQ_USER:
 		return &qi->qi_uquota_tree;
 	case XFS_DQ_GROUP:
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 7effd7a28136..8cbb65f01bf1 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -644,12 +644,9 @@ xfs_qm_scall_getquota_fill_qc(
 	 * gets turned off. No need to confuse the user level code,
 	 * so return zeroes in that case.
 	 */
-	if ((!XFS_IS_UQUOTA_ENFORCED(mp) &&
-	     dqp->q_core.d_flags == XFS_DQ_USER) ||
-	    (!XFS_IS_GQUOTA_ENFORCED(mp) &&
-	     dqp->q_core.d_flags == XFS_DQ_GROUP) ||
-	    (!XFS_IS_PQUOTA_ENFORCED(mp) &&
-	     dqp->q_core.d_flags == XFS_DQ_PROJ)) {
+	if ((!XFS_IS_UQUOTA_ENFORCED(mp) && (dqp->dq_flags & XFS_DQ_USER)) ||
+	    (!XFS_IS_GQUOTA_ENFORCED(mp) && (dqp->dq_flags & XFS_DQ_GROUP)) ||
+	    (!XFS_IS_PQUOTA_ENFORCED(mp) && (dqp->dq_flags & XFS_DQ_PROJ))) {
 		dst->d_spc_timer = 0;
 		dst->d_ino_timer = 0;
 		dst->d_rt_spc_timer = 0;

