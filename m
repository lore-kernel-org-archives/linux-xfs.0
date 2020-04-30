Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68ED1C83000
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DAA820787
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:47:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DQYDOffg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgD3Arx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 20:47:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46614 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgD3Arx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 20:47:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0lqx0159805
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:47:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=mFez/hImz0xHvwRKf2Bh6NOqVM7WHhwM4E9fU9yEbgg=;
 b=DQYDOffgbovx27h3uXM9bq+rWcMQ+I2QFAq2KQLw7XqfCfMVSiQ+Rtgh8UQfhJ0v5qfz
 gUL/6ep3HdbHBXW8ST1X2BfCmzAM71iZRkABE3PQPJhdMGUA8TRj6c2850flmWbnsLvi
 6oayMralEoKYs3q35qrNDgAuxWZg0GhzSRGEbIoj6IR9l8SnG8ndngizu+Zd+KKqP83j
 ISMd5e7PvmDaPDdWsifz+KcR2mrtkWBSNJtE9tlyfzzM3n3Fm6tFZp1Elp/eGxHaUo6V
 Tuc1RtSon9owqUemu71tYdSks282J4xHJbN7mKfnMZe8/GxAeRm2hiKVKknVdEMcTADy ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30p2p0e4y9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:47:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0l6B7119972
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:47:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30my0jr06n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:47:51 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03U0lnfT012375
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:47:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 17:47:49 -0700
Subject: [PATCH 02/21] xfs: refactor log recovery item dispatch for pass2
 readhead functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Apr 2020 17:47:48 -0700
Message-ID: <158820766792.467894.3995732139270270438.stgit@magnolia>
In-Reply-To: <158820765488.467894.15408191148091671053.stgit@magnolia>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=1 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=1 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the pass2 readhead code into the per-item source code files and use
the dispatch function to call them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |    6 ++
 fs/xfs/xfs_buf_item_recover.c   |   11 +++++
 fs/xfs/xfs_dquot_item.c         |   34 ++++++++++++++
 fs/xfs/xfs_inode_item_recover.c |   19 ++++++++
 fs/xfs/xfs_log_recover.c        |   95 +--------------------------------------
 5 files changed, 73 insertions(+), 92 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 38ae9c371edb..1463eba47254 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -29,6 +29,9 @@ struct xlog_recover_item_type {
 	 * values mean.
 	 */
 	enum xlog_recover_reorder (*reorder_fn)(struct xlog_recover_item *item);
+
+	/* Start readahead for pass2, if provided. */
+	void (*ra_pass2_fn)(struct xlog *log, struct xlog_recover_item *item);
 };
 
 extern const struct xlog_recover_item_type xlog_icreate_item_type;
@@ -90,4 +93,7 @@ struct xlog_recover {
 #define	XLOG_RECOVER_PASS1	1
 #define	XLOG_RECOVER_PASS2	2
 
+void xlog_buf_readahead(struct xlog *log, xfs_daddr_t blkno, uint len,
+		const struct xfs_buf_ops *ops);
+
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 07ddf58209c3..c756b8e55fde 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -32,6 +32,17 @@ xlog_buf_reorder_fn(
 	return XLOG_REORDER_BUFFER_LIST;
 }
 
+STATIC void
+xlog_recover_buffer_ra_pass2(
+	struct xlog                     *log,
+	struct xlog_recover_item        *item)
+{
+	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
+
+	xlog_buf_readahead(log, buf_f->blf_blkno, buf_f->blf_len, NULL);
+}
+
 const struct xlog_recover_item_type xlog_buf_item_type = {
 	.reorder_fn		= xlog_buf_reorder_fn,
+	.ra_pass2_fn		= xlog_recover_buffer_ra_pass2,
 };
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 3bd5b6c7e235..2a05d1239423 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -386,7 +386,41 @@ xfs_qm_qoff_logitem_init(
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
+	xlog_buf_readahead(log, dq_f->qlf_blkno,
+			XFS_FSB_TO_BB(mp, dq_f->qlf_len),
+			&xfs_dquot_buf_ra_ops);
+}
+
 const struct xlog_recover_item_type xlog_dquot_item_type = {
+	.ra_pass2_fn		= xlog_recover_dquot_ra_pass2,
 };
 
 const struct xlog_recover_item_type xlog_quotaoff_item_type = {
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 478f0a5c08ab..d97d8caa4652 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -21,5 +21,24 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 
+STATIC void
+xlog_recover_inode_ra_pass2(
+	struct xlog                     *log,
+	struct xlog_recover_item        *item)
+{
+	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
+		struct xfs_inode_log_format	*ilfp = item->ri_buf[0].i_addr;
+
+		xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
+				   &xfs_inode_buf_ra_ops);
+	} else {
+		struct xfs_inode_log_format_32	*ilfp = item->ri_buf[0].i_addr;
+
+		xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
+				   &xfs_inode_buf_ra_ops);
+	}
+}
+
 const struct xlog_recover_item_type xlog_inode_item_type = {
+	.ra_pass2_fn		= xlog_recover_inode_ra_pass2,
 };
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 8ab107680883..b61323cc5a11 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2045,7 +2045,7 @@ xlog_put_buffer_cancelled(
 	return true;
 }
 
-static void
+void
 xlog_buf_readahead(
 	struct xlog		*log,
 	xfs_daddr_t		blkno,
@@ -3912,96 +3912,6 @@ xlog_recover_do_icreate_pass2(
 				     length, be32_to_cpu(icl->icl_gen));
 }
 
-STATIC void
-xlog_recover_buffer_ra_pass2(
-	struct xlog                     *log,
-	struct xlog_recover_item        *item)
-{
-	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
-
-	xlog_buf_readahead(log, buf_f->blf_blkno, buf_f->blf_len, NULL);
-}
-
-STATIC void
-xlog_recover_inode_ra_pass2(
-	struct xlog                     *log,
-	struct xlog_recover_item        *item)
-{
-	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
-		struct xfs_inode_log_format	*ilfp = item->ri_buf[0].i_addr;
-
-		xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
-				   &xfs_inode_buf_ra_ops);
-	} else {
-		struct xfs_inode_log_format_32	*ilfp = item->ri_buf[0].i_addr;
-
-		xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
-				   &xfs_inode_buf_ra_ops);
-	}
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
-	xlog_buf_readahead(log, dq_f->qlf_blkno,
-			XFS_FSB_TO_BB(mp, dq_f->qlf_len),
-			&xfs_dquot_buf_ra_ops);
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
@@ -4138,7 +4048,8 @@ xlog_recover_commit_trans(
 			error = xlog_recover_commit_pass1(log, trans, item);
 			break;
 		case XLOG_RECOVER_PASS2:
-			xlog_recover_ra_pass2(log, item);
+			if (item->ri_type && item->ri_type->ra_pass2_fn)
+				item->ri_type->ra_pass2_fn(log, item);
 			list_move_tail(&item->ri_list, &ra_list);
 			items_queued++;
 			if (items_queued >= XLOG_RECOVER_COMMIT_QUEUE_MAX) {

