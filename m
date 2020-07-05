Return-Path: <SRS0=iu4H=AQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CEBCC433DF
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71D6E2075B
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:13:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jqKAkLzV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgGEWNR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jul 2020 18:13:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56492 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbgGEWNQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jul 2020 18:13:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MDFUe080813
        for <linux-xfs@vger.kernel.org>; Sun, 5 Jul 2020 22:13:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=eMwX7DLsjpOje8akUO9Nx1F9HFD2ukWpPuckNYlckWQ=;
 b=jqKAkLzVT5g4AenYHeZ5b7btis7NwZzXUpFZUTIUqW6rwFsovW0CR0RTjsWnX8KIoXgJ
 BgWMHE46JUXcSF1Txv2NLghIXyezmx39j8wpcHQ+EQRf6bIr5WKpqHTIsvTNcsEhg2s2
 yze8r8jA1h8Yg6DAVYXntOw+U5cizuRTzZavG49yCpk614csxdxXl+7qk6w+YIAipfWL
 OtwY6QufIybxbWs79kncHYdWr6XwSgcsJmwSixgaljTyU/OjTCGk2UlqCq+3rKFmLfha
 JAN+4AbF/RjTab7HcAnF+4AzLgKdBFixcLBTWbA+yURYNzs2JvX702o0qn9bUrRdoRWW nQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 322kv63ay9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sun, 05 Jul 2020 22:13:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MD59O159035
        for <linux-xfs@vger.kernel.org>; Sun, 5 Jul 2020 22:13:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3233bkj0tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 05 Jul 2020 22:13:14 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 065MDDLv026079
        for <linux-xfs@vger.kernel.org>; Sun, 5 Jul 2020 22:13:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 05 Jul 2020 15:13:13 -0700
Subject: [PATCH 06/22] xfs: stop using q_core.d_flags in the quota code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 05 Jul 2020 15:13:12 -0700
Message-ID: <159398719254.425236.7610380962448139811.stgit@magnolia>
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

Use the incore dq_flags to figure out the dquot type.  This is the first
step towards removing xfs_disk_dquot from the incore dquot.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/quota.c     |    4 ----
 fs/xfs/xfs_dquot.c       |   35 +++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_dquot.h       |    2 ++
 fs/xfs/xfs_dquot_item.c  |    6 ++++--
 fs/xfs/xfs_qm.c          |    4 ++--
 fs/xfs/xfs_qm.h          |    2 +-
 fs/xfs/xfs_qm_syscalls.c |    9 +++------
 7 files changed, 45 insertions(+), 17 deletions(-)


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
index 883573927416..8c1a6ab9b2e0 100644
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
+	ddqp->d_flags = dqp->dq_flags & XFS_DDQFEAT_TYPE_MASK;
+}
+
 /* Allocate and initialize the dquot buffer for this in-core dquot. */
 static int
 xfs_qm_dqread_alloc(
@@ -1108,6 +1118,19 @@ xfs_qm_dqflush_done(
 	xfs_dqfunlock(dqp);
 }
 
+/* Check incore dquot for errors before we flush. */
+static xfs_failaddr_t
+xfs_qm_dqflush_check(
+	struct xfs_dquot	*dqp)
+{
+	unsigned int		type = dqp->dq_flags & XFS_DQ_ALLTYPES;
+
+	if (type != XFS_DQ_USER && type != XFS_DQ_GROUP && type != XFS_DQ_PROJ)
+		return __this_address;
+
+	return NULL;
+}
+
 /*
  * Write a modified dquot to disk.
  * The dquot must be locked and the flush lock too taken by caller.
@@ -1166,8 +1189,16 @@ xfs_qm_dqflush(
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
index bd807f740eb9..16399413fbc9 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -161,7 +161,7 @@ xfs_qm_dqpurge(
 	xfs_dqfunlock(dqp);
 	xfs_dqunlock(dqp);
 
-	radix_tree_delete(xfs_dquot_tree(qi, dqp->q_core.d_flags),
+	radix_tree_delete(xfs_dquot_tree(qi, dqp->dq_flags),
 			  be32_to_cpu(dqp->q_core.d_id));
 	qi->qi_dquots--;
 
@@ -1601,7 +1601,7 @@ xfs_qm_dqfree_one(
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 
 	mutex_lock(&qi->qi_tree_lock);
-	radix_tree_delete(xfs_dquot_tree(qi, dqp->q_core.d_flags),
+	radix_tree_delete(xfs_dquot_tree(qi, dqp->dq_flags),
 			  be32_to_cpu(dqp->q_core.d_id));
 
 	qi->qi_dquots--;
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 2c8ca9df23af..43cc01fa4b4d 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -74,7 +74,7 @@ xfs_dquot_tree(
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

