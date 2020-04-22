Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56997C2BA19
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A82520724
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:06:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sPQVXPQt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgDVCGc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 22:06:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43752 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgDVCGc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 22:06:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M252ik168288
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=UloAvMV62cnZnTV0yfjFmIh3mkTjLAhIeTEwtv3fI1M=;
 b=sPQVXPQtnBQPcZ9FOtTOpmw8oUxkQPYZ4D7qbOVjPG8Ml/3reMKKa9Zb3o9FHyhwOquq
 cEzVsCPwzgL2I3O60a8nPZ4wxPqmDaofLfbxyEqbRGdx9qwP3S/wqx3fG6OoD5KmDymF
 3XhbP+kNfNPubeZR8gIq+5644YnXXLjIJ/RyKQNULrBJEctCzdOOvUPR6C1tJXmuZoKG
 ElK7Lj4r5HHbq2Lw7wOWw0PFOISG1yyiTUV1k/I2JwHDkcSu824zN14ucr+tJ8UBoGZI
 CnQO3nvl/lDt9AEulaL3bdyi+WLdOGIZ+1DGE5j1INaxY75WKr/I8MIr/PM0ZhWyssYn Jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30grpgmhk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M23So3179024
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30gb91fnsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:30 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03M26TTA014752
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 19:06:29 -0700
Subject: [PATCH 04/19] xfs: refactor log recovery item dispatch for pass1
 commit functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 21 Apr 2020 19:06:28 -0700
Message-ID: <158752118861.2140829.15933917079805307080.stgit@magnolia>
In-Reply-To: <158752116283.2140829.12265815455525398097.stgit@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=1 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=1 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the pass1 commit code into the per-item source code files and use
the dispatch function to call them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |    5 ++
 fs/xfs/xfs_buf_item.c           |   62 ++++++++++++++++++++++
 fs/xfs/xfs_buf_item.h           |    1 
 fs/xfs/xfs_dquot_item.c         |   28 ++++++++++
 fs/xfs/xfs_log_recover.c        |  109 +--------------------------------------
 5 files changed, 98 insertions(+), 107 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 010fc22e5fdf..dca12058bb98 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -25,6 +25,8 @@ typedef enum xlog_recover_reorder (*xlog_recover_reorder_fn)(
 		struct xlog_recover_item *item);
 typedef void (*xlog_recover_ra_pass2_fn)(struct xlog *log,
 		struct xlog_recover_item *item);
+typedef int (*xlog_recover_commit_pass1_fn)(struct xlog *log,
+		struct xlog_recover_item *item);
 
 struct xlog_recover_item_type {
 	/*
@@ -39,6 +41,9 @@ struct xlog_recover_item_type {
 
 	/* Start readahead for pass2, if provided. */
 	xlog_recover_ra_pass2_fn	ra_pass2_fn;
+
+	/* Do whatever work we need to do for pass1, if provided. */
+	xlog_recover_commit_pass1_fn	commit_pass1_fn;
 };
 
 extern const struct xlog_recover_item_type xlog_icreate_item_type;
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 1ad514cc501c..351c42f354e3 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -29,7 +29,7 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 STATIC void	xfs_buf_do_callbacks(struct xfs_buf *bp);
 
 /* Is this log iovec plausibly large enough to contain the buffer log format? */
-bool
+STATIC bool
 xfs_buf_log_check_iovec(
 	struct xfs_log_iovec		*iovec)
 {
@@ -1319,7 +1319,67 @@ xlog_recover_buffer_ra_pass2(
 				buf_f->blf_len, NULL);
 }
 
+/*
+ * Build up the table of buf cancel records so that we don't replay
+ * cancelled data in the second pass.  For buffer records that are
+ * not cancel records, there is nothing to do here so we just return.
+ *
+ * If we get a cancel record which is already in the table, this indicates
+ * that the buffer was cancelled multiple times.  In order to ensure
+ * that during pass 2 we keep the record in the table until we reach its
+ * last occurrence in the log, we keep a reference count in the cancel
+ * record in the table to tell us how many times we expect to see this
+ * record during the second pass.
+ */
+STATIC int
+xlog_recover_buffer_pass1(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
+	struct list_head	*bucket;
+	struct xfs_buf_cancel	*bcp;
+
+	if (!xfs_buf_log_check_iovec(&item->ri_buf[0])) {
+		xfs_err(log->l_mp, "bad buffer log item size (%d)",
+				item->ri_buf[0].i_len);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * If this isn't a cancel buffer item, then just return.
+	 */
+	if (!(buf_f->blf_flags & XFS_BLF_CANCEL)) {
+		trace_xfs_log_recover_buf_not_cancel(log, buf_f);
+		return 0;
+	}
+
+	/*
+	 * Insert an xfs_buf_cancel record into the hash table of them.
+	 * If there is already an identical record, bump its reference count.
+	 */
+	bucket = XLOG_BUF_CANCEL_BUCKET(log, buf_f->blf_blkno);
+	list_for_each_entry(bcp, bucket, bc_list) {
+		if (bcp->bc_blkno == buf_f->blf_blkno &&
+		    bcp->bc_len == buf_f->blf_len) {
+			bcp->bc_refcount++;
+			trace_xfs_log_recover_buf_cancel_ref_inc(log, buf_f);
+			return 0;
+		}
+	}
+
+	bcp = kmem_alloc(sizeof(struct xfs_buf_cancel), 0);
+	bcp->bc_blkno = buf_f->blf_blkno;
+	bcp->bc_len = buf_f->blf_len;
+	bcp->bc_refcount = 1;
+	list_add_tail(&bcp->bc_list, bucket);
+
+	trace_xfs_log_recover_buf_cancel_add(log, buf_f);
+	return 0;
+}
+
 const struct xlog_recover_item_type xlog_buf_item_type = {
 	.reorder_fn		= xlog_buf_reorder_fn,
 	.ra_pass2_fn		= xlog_recover_buffer_ra_pass2,
+	.commit_pass1_fn	= xlog_recover_buffer_pass1,
 };
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 30114b510332..4a054b11011a 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -61,7 +61,6 @@ void	xfs_buf_iodone_callbacks(struct xfs_buf *);
 void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
 bool	xfs_buf_resubmit_failed_buffers(struct xfs_buf *,
 					struct list_head *);
-bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
 
 extern kmem_zone_t	*xfs_buf_item_zone;
 
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index d4c794abf900..e3a54b1fb20a 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -429,6 +429,34 @@ const struct xlog_recover_item_type xlog_dquot_item_type = {
 	.ra_pass2_fn		= xlog_recover_dquot_ra_pass2,
 };
 
+/*
+ * Recover QUOTAOFF records. We simply make a note of it in the xlog
+ * structure, so that we know not to do any dquot item or dquot buffer recovery,
+ * of that type.
+ */
+STATIC int
+xlog_recover_quotaoff_pass1(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	xfs_qoff_logformat_t	*qoff_f = item->ri_buf[0].i_addr;
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
 	.reorder		= XLOG_REORDER_INODE_LIST,
+	.commit_pass1_fn	= xlog_recover_quotaoff_pass1,
 };
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 9ee8eb9b93a2..12e864ef6d43 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1934,65 +1934,6 @@ xlog_recover_reorder_trans(
 	return error;
 }
 
-/*
- * Build up the table of buf cancel records so that we don't replay
- * cancelled data in the second pass.  For buffer records that are
- * not cancel records, there is nothing to do here so we just return.
- *
- * If we get a cancel record which is already in the table, this indicates
- * that the buffer was cancelled multiple times.  In order to ensure
- * that during pass 2 we keep the record in the table until we reach its
- * last occurrence in the log, we keep a reference count in the cancel
- * record in the table to tell us how many times we expect to see this
- * record during the second pass.
- */
-STATIC int
-xlog_recover_buffer_pass1(
-	struct xlog			*log,
-	struct xlog_recover_item	*item)
-{
-	xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
-	struct list_head	*bucket;
-	struct xfs_buf_cancel	*bcp;
-
-	if (!xfs_buf_log_check_iovec(&item->ri_buf[0])) {
-		xfs_err(log->l_mp, "bad buffer log item size (%d)",
-				item->ri_buf[0].i_len);
-		return -EFSCORRUPTED;
-	}
-
-	/*
-	 * If this isn't a cancel buffer item, then just return.
-	 */
-	if (!(buf_f->blf_flags & XFS_BLF_CANCEL)) {
-		trace_xfs_log_recover_buf_not_cancel(log, buf_f);
-		return 0;
-	}
-
-	/*
-	 * Insert an xfs_buf_cancel record into the hash table of them.
-	 * If there is already an identical record, bump its reference count.
-	 */
-	bucket = XLOG_BUF_CANCEL_BUCKET(log, buf_f->blf_blkno);
-	list_for_each_entry(bcp, bucket, bc_list) {
-		if (bcp->bc_blkno == buf_f->blf_blkno &&
-		    bcp->bc_len == buf_f->blf_len) {
-			bcp->bc_refcount++;
-			trace_xfs_log_recover_buf_cancel_ref_inc(log, buf_f);
-			return 0;
-		}
-	}
-
-	bcp = kmem_alloc(sizeof(struct xfs_buf_cancel), 0);
-	bcp->bc_blkno = buf_f->blf_blkno;
-	bcp->bc_len = buf_f->blf_len;
-	bcp->bc_refcount = 1;
-	list_add_tail(&bcp->bc_list, bucket);
-
-	trace_xfs_log_recover_buf_cancel_add(log, buf_f);
-	return 0;
-}
-
 /*
  * Check to see whether the buffer being recovered has a corresponding
  * entry in the buffer cancel record table. If it is, return the cancel
@@ -3196,33 +3137,6 @@ xlog_recover_inode_pass2(
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
@@ -3897,30 +3811,15 @@ xlog_recover_commit_pass1(
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

