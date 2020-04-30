Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F25A1C83004
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDAAF2083B
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:50:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="u7bKMBP2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgD3AuD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 20:50:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46618 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgD3AuD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 20:50:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0nl2l193578
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:50:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ikmuHle/hST7wi3jrgt/hzApwLO5KSGq2i/TCBG3+v8=;
 b=u7bKMBP2Zx2tAr6ub1EhUlSLT1efuq0dl52Ur6jzSVJM0k+fDopp7PAHHWdSi/TayShR
 5Heya9q4roTw9ffCCJonk7B7s9ddfbu00bNVUq/+krSZiYKDrlIUg/uDs4SA8YBt568C
 Z8NKfXpVGN6cjN+A0atmypLHOH1BIS2FzzGgVw2Ab+iE/g0UrFRtdVC5ySbliyWpL2be
 pRejH8Ldh+hxeFJzwCtKVn3jICQ8c9DYwd3tHONRj0gJqehD6C/XcBuO3/8rI4LWr6fO
 cfhXRlfBCMNEBVrbwRMKgfZVNuNTpATvYL96P4xwCRoKf3MHg4JmaXhmhSdrjlR3+GZ/ 7A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30nucg8qaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:50:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0m09W100045
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30pvd28grw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:00 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03U0luxn024442
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:47:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 17:47:55 -0700
Subject: [PATCH 03/21] xfs: refactor log recovery item dispatch for pass1
 commit functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Apr 2020 17:47:54 -0700
Message-ID: <158820767484.467894.899539967886494078.stgit@magnolia>
In-Reply-To: <158820765488.467894.15408191148091671053.stgit@magnolia>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=1 malwarescore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=1 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the pass1 commit code into the per-item source code files and use
the dispatch function to call them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |    5 +++
 fs/xfs/xfs_buf_item_recover.c   |   27 ++++++++++++++
 fs/xfs/xfs_dquot_item.c         |   28 ++++++++++++++
 fs/xfs/xfs_log_recover.c        |   78 +++------------------------------------
 4 files changed, 65 insertions(+), 73 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 1463eba47254..b933dc8bb8a3 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -32,6 +32,10 @@ struct xlog_recover_item_type {
 
 	/* Start readahead for pass2, if provided. */
 	void (*ra_pass2_fn)(struct xlog *log, struct xlog_recover_item *item);
+
+	/* Do whatever work we need to do for pass1, if provided. */
+	int (*commit_pass1_fn)(struct xlog *log,
+			       struct xlog_recover_item *item);
 };
 
 extern const struct xlog_recover_item_type xlog_icreate_item_type;
@@ -95,5 +99,6 @@ struct xlog_recover {
 
 void xlog_buf_readahead(struct xlog *log, xfs_daddr_t blkno, uint len,
 		const struct xfs_buf_ops *ops);
+bool xlog_add_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index c756b8e55fde..deda3ad32d95 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -42,7 +42,34 @@ xlog_recover_buffer_ra_pass2(
 	xlog_buf_readahead(log, buf_f->blf_blkno, buf_f->blf_len, NULL);
 }
 
+/*
+ * Build up the table of buf cancel records so that we don't replay cancelled
+ * data in the second pass.
+ */
+static int
+xlog_recover_buffer_commit_pass1(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_buf_log_format	*bf = item->ri_buf[0].i_addr;
+
+	if (!xfs_buf_log_check_iovec(&item->ri_buf[0])) {
+		xfs_err(log->l_mp, "bad buffer log item size (%d)",
+				item->ri_buf[0].i_len);
+		return -EFSCORRUPTED;
+	}
+
+	if (!(bf->blf_flags & XFS_BLF_CANCEL))
+		trace_xfs_log_recover_buf_not_cancel(log, bf);
+	else if (xlog_add_buffer_cancelled(log, bf->blf_blkno, bf->blf_len))
+		trace_xfs_log_recover_buf_cancel_add(log, bf);
+	else
+		trace_xfs_log_recover_buf_cancel_ref_inc(log, bf);
+	return 0;
+}
+
 const struct xlog_recover_item_type xlog_buf_item_type = {
 	.reorder_fn		= xlog_buf_reorder_fn,
 	.ra_pass2_fn		= xlog_recover_buffer_ra_pass2,
+	.commit_pass1_fn	= xlog_recover_buffer_commit_pass1,
 };
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 2a05d1239423..4d18af49adfe 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -423,5 +423,33 @@ const struct xlog_recover_item_type xlog_dquot_item_type = {
 	.ra_pass2_fn		= xlog_recover_dquot_ra_pass2,
 };
 
+/*
+ * Recover QUOTAOFF records. We simply make a note of it in the xlog
+ * structure, so that we know not to do any dquot item or dquot buffer recovery,
+ * of that type.
+ */
+STATIC int
+xlog_recover_quotaoff_commit_pass1(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_qoff_logformat	*qoff_f = item->ri_buf[0].i_addr;
+	ASSERT(qoff_f);
+
+	/*
+	 * The logitem format's flag tells us if this was user quotaoff,
+	 * group/project quotaoff or both.
+	 */
+	if (qoff_f->qf_flags & XFS_UQUOTA_ACCT)
+		log->l_quotaoffs_flag |= XFS_DQ_USER;
+	if (qoff_f->qf_flags & XFS_PQUOTA_ACCT)
+		log->l_quotaoffs_flag |= XFS_DQ_PROJ;
+	if (qoff_f->qf_flags & XFS_GQUOTA_ACCT)
+		log->l_quotaoffs_flag |= XFS_DQ_GROUP;
+
+	return 0;
+}
+
 const struct xlog_recover_item_type xlog_quotaoff_item_type = {
+	.commit_pass1_fn	= xlog_recover_quotaoff_commit_pass1,
 };
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b61323cc5a11..fbd1f7d6f1c9 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1975,7 +1975,7 @@ xlog_find_buffer_cancelled(
 	return NULL;
 }
 
-static bool
+bool
 xlog_add_buffer_cancelled(
 	struct xlog		*log,
 	xfs_daddr_t		blkno,
@@ -2056,32 +2056,6 @@ xlog_buf_readahead(
 		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
 }
 
-/*
- * Build up the table of buf cancel records so that we don't replay cancelled
- * data in the second pass.
- */
-static int
-xlog_recover_buffer_pass1(
-	struct xlog			*log,
-	struct xlog_recover_item	*item)
-{
-	struct xfs_buf_log_format	*bf = item->ri_buf[0].i_addr;
-
-	if (!xfs_buf_log_check_iovec(&item->ri_buf[0])) {
-		xfs_err(log->l_mp, "bad buffer log item size (%d)",
-				item->ri_buf[0].i_len);
-		return -EFSCORRUPTED;
-	}
-
-	if (!(bf->blf_flags & XFS_BLF_CANCEL))
-		trace_xfs_log_recover_buf_not_cancel(log, bf);
-	else if (xlog_add_buffer_cancelled(log, bf->blf_blkno, bf->blf_len))
-		trace_xfs_log_recover_buf_cancel_add(log, bf);
-	else
-		trace_xfs_log_recover_buf_cancel_ref_inc(log, bf);
-	return 0;
-}
-
 /*
  * Perform recovery for a buffer full of inodes.  In these buffers, the only
  * data which should be recovered is that which corresponds to the
@@ -3219,33 +3193,6 @@ xlog_recover_inode_pass2(
 	return error;
 }
 
-/*
- * Recover QUOTAOFF records. We simply make a note of it in the xlog
- * structure, so that we know not to do any dquot item or dquot buffer recovery,
- * of that type.
- */
-STATIC int
-xlog_recover_quotaoff_pass1(
-	struct xlog			*log,
-	struct xlog_recover_item	*item)
-{
-	xfs_qoff_logformat_t	*qoff_f = item->ri_buf[0].i_addr;
-	ASSERT(qoff_f);
-
-	/*
-	 * The logitem format's flag tells us if this was user quotaoff,
-	 * group/project quotaoff or both.
-	 */
-	if (qoff_f->qf_flags & XFS_UQUOTA_ACCT)
-		log->l_quotaoffs_flag |= XFS_DQ_USER;
-	if (qoff_f->qf_flags & XFS_PQUOTA_ACCT)
-		log->l_quotaoffs_flag |= XFS_DQ_PROJ;
-	if (qoff_f->qf_flags & XFS_GQUOTA_ACCT)
-		log->l_quotaoffs_flag |= XFS_DQ_GROUP;
-
-	return 0;
-}
-
 /*
  * Recover a dquot record
  */
@@ -3920,30 +3867,15 @@ xlog_recover_commit_pass1(
 {
 	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS1);
 
-	switch (ITEM_TYPE(item)) {
-	case XFS_LI_BUF:
-		return xlog_recover_buffer_pass1(log, item);
-	case XFS_LI_QUOTAOFF:
-		return xlog_recover_quotaoff_pass1(log, item);
-	case XFS_LI_INODE:
-	case XFS_LI_EFI:
-	case XFS_LI_EFD:
-	case XFS_LI_DQUOT:
-	case XFS_LI_ICREATE:
-	case XFS_LI_RUI:
-	case XFS_LI_RUD:
-	case XFS_LI_CUI:
-	case XFS_LI_CUD:
-	case XFS_LI_BUI:
-	case XFS_LI_BUD:
-		/* nothing to do in pass 1 */
-		return 0;
-	default:
+	if (!item->ri_type) {
 		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
 			__func__, ITEM_TYPE(item));
 		ASSERT(0);
 		return -EFSCORRUPTED;
 	}
+	if (!item->ri_type->commit_pass1_fn)
+		return 0;
+	return item->ri_type->commit_pass1_fn(log, item);
 }
 
 STATIC int

