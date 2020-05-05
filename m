Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE647C3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 926CD206C0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:11:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jc8tM3qN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgEEBLC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:11:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46452 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgEEBLC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:11:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04513eQ9055535
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:11:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=vzCSqDRIQOtOBfHAbLIbYmrhV7idFofel1nbVggxWr4=;
 b=jc8tM3qNm+6AtG1ELu6fPxbpGpsr1QT/NraIxiCichp2B1wQUQg3nGGF+U6iH7rZ7cZK
 V9jHHU/iOg+UPVuHnKvCz0iyGUGakUI3HwQhpS9sDRDvz2nCjgU/9/RNPPRky89sF1hL
 pT7AFz/LoJCuEGABqJ/8P3GPJ5R6n0bubJ6H5rdp58VjQtHmfwb0aBCInUUXxhXj2iOv
 DfWZF6wrk2ui/YyeUPUOeogEx6mw1+cYe7m8JDyhlZKZKTQxh7+fvKJIZ0/B98WqHC6F
 w2LvP+vZdRDjDVGWzuQssZ+Vucpsw6oEFXcLmpQou2mFTNRpn2hXiTyoPmFDY8uvWnsO sQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30s1gn1vh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:11:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04516rc9004686
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:11:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30sjdrttpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:10:59 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0451AweL015962
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:10:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:10:58 -0700
Subject: [PATCH 04/28] xfs: refactor log recovery item dispatch for pass1
 commit functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:10:57 -0700
Message-ID: <158864105772.182683.2888229701435255975.stgit@magnolia>
In-Reply-To: <158864103195.182683.2056162574447133617.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the pass1 commit code into the per-item source code files and use
the dispatch function to call them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |    4 ++
 fs/xfs/xfs_buf_item_recover.c   |   27 ++++++++++
 fs/xfs/xfs_dquot_item_recover.c |   28 +++++++++++
 fs/xfs/xfs_log_recover.c        |  101 +++++----------------------------------
 4 files changed, 71 insertions(+), 89 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index ff80871138bb..384b70d58993 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -34,6 +34,9 @@ struct xlog_recover_item_ops {
 
 	/* Start readahead for pass2, if provided. */
 	void (*ra_pass2)(struct xlog *log, struct xlog_recover_item *item);
+
+	/* Do whatever work we need to do for pass1, if provided. */
+	int (*commit_pass1)(struct xlog *log, struct xlog_recover_item *item);
 };
 
 extern const struct xlog_recover_item_ops xlog_icreate_item_ops;
@@ -97,5 +100,6 @@ struct xlog_recover {
 
 void xlog_buf_readahead(struct xlog *log, xfs_daddr_t blkno, uint len,
 		const struct xfs_buf_ops *ops);
+bool xlog_add_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index a1327196b690..802f2206516d 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -42,8 +42,35 @@ xlog_recover_buf_ra_pass2(
 	xlog_buf_readahead(log, buf_f->blf_blkno, buf_f->blf_len, NULL);
 }
 
+/*
+ * Build up the table of buf cancel records so that we don't replay cancelled
+ * data in the second pass.
+ */
+static int
+xlog_recover_buf_commit_pass1(
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
 const struct xlog_recover_item_ops xlog_buf_item_ops = {
 	.item_type		= XFS_LI_BUF,
 	.reorder		= xlog_recover_buf_reorder,
 	.ra_pass2		= xlog_recover_buf_ra_pass2,
+	.commit_pass1		= xlog_recover_buf_commit_pass1,
 };
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index 215274173b70..ebc44c1bc2b1 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -58,6 +58,34 @@ const struct xlog_recover_item_ops xlog_dquot_item_ops = {
 	.ra_pass2		= xlog_recover_dquot_ra_pass2,
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
 const struct xlog_recover_item_ops xlog_quotaoff_item_ops = {
 	.item_type		= XFS_LI_QUOTAOFF,
+	.commit_pass1		= xlog_recover_quotaoff_commit_pass1,
 };
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ea566747d8e1..b3627ebf870e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1953,7 +1953,7 @@ xlog_find_buffer_cancelled(
 	return NULL;
 }
 
-static bool
+bool
 xlog_add_buffer_cancelled(
 	struct xlog		*log,
 	xfs_daddr_t		blkno,
@@ -2034,32 +2034,6 @@ xlog_buf_readahead(
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
@@ -3197,33 +3171,6 @@ xlog_recover_inode_pass2(
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
@@ -3890,40 +3837,6 @@ xlog_recover_do_icreate_pass2(
 				     length, be32_to_cpu(icl->icl_gen));
 }
 
-STATIC int
-xlog_recover_commit_pass1(
-	struct xlog			*log,
-	struct xlog_recover		*trans,
-	struct xlog_recover_item	*item)
-{
-	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS1);
-
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
-		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
-			__func__, ITEM_TYPE(item));
-		ASSERT(0);
-		return -EFSCORRUPTED;
-	}
-}
-
 STATIC int
 xlog_recover_commit_pass2(
 	struct xlog			*log,
@@ -4021,9 +3934,19 @@ xlog_recover_commit_trans(
 		return error;
 
 	list_for_each_entry_safe(item, next, &trans->r_itemq, ri_list) {
+		trace_xfs_log_recover_item_recover(log, trans, item, pass);
+
+		if (!item->ri_ops) {
+			xfs_warn(log->l_mp, "%s: invalid item type (%d)",
+				__func__, ITEM_TYPE(item));
+			ASSERT(0);
+			return -EFSCORRUPTED;
+		}
+
 		switch (pass) {
 		case XLOG_RECOVER_PASS1:
-			error = xlog_recover_commit_pass1(log, trans, item);
+			if (item->ri_ops->commit_pass1)
+				error = item->ri_ops->commit_pass1(log, item);
 			break;
 		case XLOG_RECOVER_PASS2:
 			if (item->ri_ops->ra_pass2)

