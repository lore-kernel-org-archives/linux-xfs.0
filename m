Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58845C28CBC
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DDF020708
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:02:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Zf3hh7XP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgEGBCO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 21:02:14 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33976 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgEGBCO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 21:02:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470wf6j101456;
        Thu, 7 May 2020 01:02:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=DifUCvy2zKYNTZ5bhprgPmIdlUGwDsQP6tVJCO+qQXY=;
 b=Zf3hh7XP2Y1LIB5pVEX23nnhslyn0eKaLXeXO02yleZcj1I4J0GVSG0Lm7AMn5ISpeqU
 HvjUK5iBZ6FHP+OKGvktX2bQX7fI+SaaJZIqvqb8I4l1ZvGL5VjQHEfCZOvtIc6oL9J4
 f7lOGnoWD43zqgOLK+ZjRD+dFoZ8uHU3cUFVDKoBDe05QRT9xoWx+zujuF4owA//qOHk
 ShvpvqB+DHIAPLRLsFw9qyOJtcYqSxCsup12SGrztmc/H3DppKOpbuoSEaUWSKayhdc/
 WwM+VzNWuhA2XFU5HfFpwR4AlXafNfLpvOIGgd4kMvZBy/IeEizbM8E0kyQ2nFf8vqHr Zg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30s09rdgqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:02:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470vngJ009992;
        Thu, 7 May 2020 01:02:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30t1r96dgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:02:09 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 047128hZ028097;
        Thu, 7 May 2020 01:02:09 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 18:02:08 -0700
Subject: [PATCH 04/25] xfs: refactor log recovery item dispatch for pass1
 commit functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 06 May 2020 18:02:05 -0700
Message-ID: <158881332499.189971.1301676793059395387.stgit@magnolia>
In-Reply-To: <158881329912.189971.14392758631836955942.stgit@magnolia>
References: <158881329912.189971.14392758631836955942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=1
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=1
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the pass1 commit code into the per-item source code files and use
the dispatch function to call them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_recover.h |    4 ++
 fs/xfs/xfs_buf_item_recover.c   |   27 +++++++++++
 fs/xfs/xfs_dquot_item_recover.c |   28 ++++++++++++
 fs/xfs/xfs_log_recover.c        |   94 ++-------------------------------------
 4 files changed, 64 insertions(+), 89 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index ceb1e1e9d1d1..19e24b8877c9 100644
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
index e35892534aaa..e2d9599f67df 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -56,8 +56,35 @@ xlog_recover_buf_ra_pass2(
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
index 7fd0126a80bf..2511f2874464 100644
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
@@ -4021,9 +3934,12 @@ xlog_recover_commit_trans(
 		return error;
 
 	list_for_each_entry_safe(item, next, &trans->r_itemq, ri_list) {
+		trace_xfs_log_recover_item_recover(log, trans, item, pass);
+
 		switch (pass) {
 		case XLOG_RECOVER_PASS1:
-			error = xlog_recover_commit_pass1(log, trans, item);
+			if (item->ri_ops->commit_pass1)
+				error = item->ri_ops->commit_pass1(log, item);
 			break;
 		case XLOG_RECOVER_PASS2:
 			if (item->ri_ops->ra_pass2)

