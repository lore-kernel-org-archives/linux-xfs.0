Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF760C54FD0
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:08:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC17A206D5
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:08:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r36GQT41"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgDVCI2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 22:08:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39114 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgDVCI1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 22:08:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M2366j074525
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:08:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=quTTPhC6z4rEGG6A4tcI0q+WL4F5pbERhOPZiiUFwO0=;
 b=r36GQT41ZVYTtcekNCwuYjuFh7yYJryU+ND1yShygecP6Da3oCwWqj7zwQRBnDSjI8kj
 XPh/p2ixj6hHJoeYJbt35d8coBQyiHa9BPJlifyuy/Sa75w8K5mKkaqsKm/R/2W/ffGS
 FzbajI52hzC9cLmtezRF48GEaqDOeG8bZZwYIVhZtVZmsyvhppLJIWlNfWuISAzpJiHj
 GQG0Vye7AKXDUFFB/Kxp1TLvd/bNts3hSSiw4w34CJFGM7eEn1ZhsYQV8lyyhv6RmnzR
 VENrcXEucWOtJfmbMgcRBET7nJCNQKmJf/ld9JGdq7HooSd30suZnj+Yf1OI2ocTpptn SA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30ft6n81n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:08:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M22ZKR054077
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30gbbfgegu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:24 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03M26NQK013969
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 19:06:23 -0700
Subject: [PATCH 03/19] xfs: refactor log recovery item dispatch for pass2
 readhead functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 21 Apr 2020 19:06:21 -0700
Message-ID: <158752118180.2140829.13805128567366066982.stgit@magnolia>
In-Reply-To: <158752116283.2140829.12265815455525398097.stgit@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=1 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the pass2 readhead code into the per-item source code files and use
the dispatch function to call them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |   19 ++++++
 fs/xfs/xfs_buf_item.c           |   18 +++++
 fs/xfs/xfs_dquot_item.c         |   39 ++++++++++++
 fs/xfs/xfs_inode_item.c         |   28 ++++++++
 fs/xfs/xfs_log_recover.c        |  129 +--------------------------------------
 5 files changed, 108 insertions(+), 125 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 60a6afb93049..010fc22e5fdf 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -23,6 +23,8 @@ enum xlog_recover_reorder {
 
 typedef enum xlog_recover_reorder (*xlog_recover_reorder_fn)(
 		struct xlog_recover_item *item);
+typedef void (*xlog_recover_ra_pass2_fn)(struct xlog *log,
+		struct xlog_recover_item *item);
 
 struct xlog_recover_item_type {
 	/*
@@ -34,6 +36,9 @@ struct xlog_recover_item_type {
 	 */
 	enum xlog_recover_reorder	reorder;
 	xlog_recover_reorder_fn		reorder_fn;
+
+	/* Start readahead for pass2, if provided. */
+	xlog_recover_ra_pass2_fn	ra_pass2_fn;
 };
 
 extern const struct xlog_recover_item_type xlog_icreate_item_type;
@@ -88,4 +93,18 @@ struct xlog_recover {
 #define	XLOG_RECOVER_PASS1	1
 #define	XLOG_RECOVER_PASS2	2
 
+/*
+ * This structure is used during recovery to record the buf log items which
+ * have been canceled and should not be replayed.
+ */
+struct xfs_buf_cancel {
+	xfs_daddr_t		bc_blkno;
+	uint			bc_len;
+	int			bc_refcount;
+	struct list_head	bc_list;
+};
+
+struct xfs_buf_cancel *xlog_peek_buffer_cancelled(struct xlog *log,
+		xfs_daddr_t blkno, uint len, unsigned short flags);
+
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index bf7480e18889..1ad514cc501c 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1302,6 +1302,24 @@ xlog_buf_reorder_fn(
 	return XLOG_REORDER_BUFFER_LIST;
 }
 
+STATIC void
+xlog_recover_buffer_ra_pass2(
+	struct xlog                     *log,
+	struct xlog_recover_item        *item)
+{
+	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
+	struct xfs_mount		*mp = log->l_mp;
+
+	if (xlog_peek_buffer_cancelled(log, buf_f->blf_blkno,
+			buf_f->blf_len, buf_f->blf_flags)) {
+		return;
+	}
+
+	xfs_buf_readahead(mp->m_ddev_targp, buf_f->blf_blkno,
+				buf_f->blf_len, NULL);
+}
+
 const struct xlog_recover_item_type xlog_buf_item_type = {
 	.reorder_fn		= xlog_buf_reorder_fn,
+	.ra_pass2_fn		= xlog_recover_buffer_ra_pass2,
 };
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 2558586b4d45..d4c794abf900 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -386,8 +386,47 @@ xfs_qm_qoff_logitem_init(
 	return qf;
 }
 
+STATIC void
+xlog_recover_dquot_ra_pass2(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_mount	*mp = log->l_mp;
+	struct xfs_disk_dquot	*recddq;
+	struct xfs_dq_logformat	*dq_f;
+	uint			type;
+	int			len;
+
+
+	if (mp->m_qflags == 0)
+		return;
+
+	recddq = item->ri_buf[1].i_addr;
+	if (recddq == NULL)
+		return;
+	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot))
+		return;
+
+	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
+	ASSERT(type);
+	if (log->l_quotaoffs_flag & type)
+		return;
+
+	dq_f = item->ri_buf[0].i_addr;
+	ASSERT(dq_f);
+	ASSERT(dq_f->qlf_len == 1);
+
+	len = XFS_FSB_TO_BB(mp, dq_f->qlf_len);
+	if (xlog_peek_buffer_cancelled(log, dq_f->qlf_blkno, len, 0))
+		return;
+
+	xfs_buf_readahead(mp->m_ddev_targp, dq_f->qlf_blkno, len,
+			  &xfs_dquot_buf_ra_ops);
+}
+
 const struct xlog_recover_item_type xlog_dquot_item_type = {
 	.reorder		= XLOG_REORDER_INODE_LIST,
+	.ra_pass2_fn		= xlog_recover_dquot_ra_pass2,
 };
 
 const struct xlog_recover_item_type xlog_quotaoff_item_type = {
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index b04e9c5330b7..bb0fe064aa1b 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -846,6 +846,34 @@ xfs_inode_item_format_convert(
 	return 0;
 }
 
+STATIC void
+xlog_recover_inode_ra_pass2(
+	struct xlog                     *log,
+	struct xlog_recover_item        *item)
+{
+	struct xfs_inode_log_format	ilf_buf;
+	struct xfs_inode_log_format	*ilfp;
+	struct xfs_mount		*mp = log->l_mp;
+	int			error;
+
+	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
+		ilfp = item->ri_buf[0].i_addr;
+	} else {
+		ilfp = &ilf_buf;
+		memset(ilfp, 0, sizeof(*ilfp));
+		error = xfs_inode_item_format_convert(&item->ri_buf[0], ilfp);
+		if (error)
+			return;
+	}
+
+	if (xlog_peek_buffer_cancelled(log, ilfp->ilf_blkno, ilfp->ilf_len, 0))
+		return;
+
+	xfs_buf_readahead(mp->m_ddev_targp, ilfp->ilf_blkno,
+				ilfp->ilf_len, &xfs_inode_buf_ra_ops);
+}
+
 const struct xlog_recover_item_type xlog_inode_item_type = {
 	.reorder		= XLOG_REORDER_INODE_LIST,
+	.ra_pass2_fn		= xlog_recover_inode_ra_pass2,
 };
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e7a9f899f657..9ee8eb9b93a2 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -55,17 +55,6 @@ STATIC int
 xlog_do_recovery_pass(
         struct xlog *, xfs_daddr_t, xfs_daddr_t, int, xfs_daddr_t *);
 
-/*
- * This structure is used during recovery to record the buf log items which
- * have been canceled and should not be replayed.
- */
-struct xfs_buf_cancel {
-	xfs_daddr_t		bc_blkno;
-	uint			bc_len;
-	int			bc_refcount;
-	struct list_head	bc_list;
-};
-
 /*
  * Sector aligned buffer routines for buffer create/read/write/access
  */
@@ -2009,12 +1998,12 @@ xlog_recover_buffer_pass1(
  * entry in the buffer cancel record table. If it is, return the cancel
  * buffer structure to the caller.
  */
-STATIC struct xfs_buf_cancel *
+struct xfs_buf_cancel *
 xlog_peek_buffer_cancelled(
 	struct xlog		*log,
 	xfs_daddr_t		blkno,
 	uint			len,
-	unsigned short			flags)
+	unsigned short		flags)
 {
 	struct list_head	*bucket;
 	struct xfs_buf_cancel	*bcp;
@@ -3900,117 +3889,6 @@ xlog_recover_do_icreate_pass2(
 				     length, be32_to_cpu(icl->icl_gen));
 }
 
-STATIC void
-xlog_recover_buffer_ra_pass2(
-	struct xlog                     *log,
-	struct xlog_recover_item        *item)
-{
-	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
-	struct xfs_mount		*mp = log->l_mp;
-
-	if (xlog_peek_buffer_cancelled(log, buf_f->blf_blkno,
-			buf_f->blf_len, buf_f->blf_flags)) {
-		return;
-	}
-
-	xfs_buf_readahead(mp->m_ddev_targp, buf_f->blf_blkno,
-				buf_f->blf_len, NULL);
-}
-
-STATIC void
-xlog_recover_inode_ra_pass2(
-	struct xlog                     *log,
-	struct xlog_recover_item        *item)
-{
-	struct xfs_inode_log_format	ilf_buf;
-	struct xfs_inode_log_format	*ilfp;
-	struct xfs_mount		*mp = log->l_mp;
-	int			error;
-
-	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
-		ilfp = item->ri_buf[0].i_addr;
-	} else {
-		ilfp = &ilf_buf;
-		memset(ilfp, 0, sizeof(*ilfp));
-		error = xfs_inode_item_format_convert(&item->ri_buf[0], ilfp);
-		if (error)
-			return;
-	}
-
-	if (xlog_peek_buffer_cancelled(log, ilfp->ilf_blkno, ilfp->ilf_len, 0))
-		return;
-
-	xfs_buf_readahead(mp->m_ddev_targp, ilfp->ilf_blkno,
-				ilfp->ilf_len, &xfs_inode_buf_ra_ops);
-}
-
-STATIC void
-xlog_recover_dquot_ra_pass2(
-	struct xlog			*log,
-	struct xlog_recover_item	*item)
-{
-	struct xfs_mount	*mp = log->l_mp;
-	struct xfs_disk_dquot	*recddq;
-	struct xfs_dq_logformat	*dq_f;
-	uint			type;
-	int			len;
-
-
-	if (mp->m_qflags == 0)
-		return;
-
-	recddq = item->ri_buf[1].i_addr;
-	if (recddq == NULL)
-		return;
-	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot))
-		return;
-
-	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
-	ASSERT(type);
-	if (log->l_quotaoffs_flag & type)
-		return;
-
-	dq_f = item->ri_buf[0].i_addr;
-	ASSERT(dq_f);
-	ASSERT(dq_f->qlf_len == 1);
-
-	len = XFS_FSB_TO_BB(mp, dq_f->qlf_len);
-	if (xlog_peek_buffer_cancelled(log, dq_f->qlf_blkno, len, 0))
-		return;
-
-	xfs_buf_readahead(mp->m_ddev_targp, dq_f->qlf_blkno, len,
-			  &xfs_dquot_buf_ra_ops);
-}
-
-STATIC void
-xlog_recover_ra_pass2(
-	struct xlog			*log,
-	struct xlog_recover_item	*item)
-{
-	switch (ITEM_TYPE(item)) {
-	case XFS_LI_BUF:
-		xlog_recover_buffer_ra_pass2(log, item);
-		break;
-	case XFS_LI_INODE:
-		xlog_recover_inode_ra_pass2(log, item);
-		break;
-	case XFS_LI_DQUOT:
-		xlog_recover_dquot_ra_pass2(log, item);
-		break;
-	case XFS_LI_EFI:
-	case XFS_LI_EFD:
-	case XFS_LI_QUOTAOFF:
-	case XFS_LI_RUI:
-	case XFS_LI_RUD:
-	case XFS_LI_CUI:
-	case XFS_LI_CUD:
-	case XFS_LI_BUI:
-	case XFS_LI_BUD:
-	default:
-		break;
-	}
-}
-
 STATIC int
 xlog_recover_commit_pass1(
 	struct xlog			*log,
@@ -4147,7 +4025,8 @@ xlog_recover_commit_trans(
 			error = xlog_recover_commit_pass1(log, trans, item);
 			break;
 		case XLOG_RECOVER_PASS2:
-			xlog_recover_ra_pass2(log, item);
+			if (item->ri_type && item->ri_type->ra_pass2_fn)
+				item->ri_type->ra_pass2_fn(log, item);
 			list_move_tail(&item->ri_list, &ra_list);
 			items_queued++;
 			if (items_queued >= XLOG_RECOVER_COMMIT_QUEUE_MAX) {

