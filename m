Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 904C4C3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B3BB206C0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:10:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aDmZ4XUE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgEEBK4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:10:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46390 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgEEBKz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:10:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045140oe055619
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:10:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=248wA73YMEKx5iC8bZO3Gf9kbjUm7j67hCXtEiDAiiA=;
 b=aDmZ4XUEI5vGmvq0kVopGVwZEULUMDu5jfHEgO/vHffOBDCF5ObHsNNwY8bvZMaZSwNj
 f6j8mq+rJib+9I40cV8A4jaD9RyexdL5zZBqVyZ5isJb8RHjmQ867tMbKtgcmlG+9CzD
 PcHp741mw5jOrib4AJ1kGWeRSgTJL7HrLeQY4BgkrErkJ+9FYFGX9CIjsufEGdJT3nwB
 awEllo9iVJgUGsZ+B+uf5OMiMe8pITbga1+fK5BZRC5LvX9nls/HFu0uo7HTmF+aGVNA
 qRJ/opLjHHIYrMa2v1v0f+i6Qn7y2fuYaVMeCQAoxF3DFOplaPiy50YTVo0XrPmvP8N0 qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30s1gn1vgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:10:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04515Wjw145636
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:10:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30sjnckqvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:10:53 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0451AqwD014425
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:10:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:10:52 -0700
Subject: [PATCH 03/28] xfs: refactor log recovery item dispatch for pass2
 readhead functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:10:51 -0700
Message-ID: <158864105149.182683.6318302965348913819.stgit@magnolia>
In-Reply-To: <158864103195.182683.2056162574447133617.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=1
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

Move the pass2 readhead code into the per-item source code files and use
the dispatch function to call them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |    6 ++
 fs/xfs/xfs_buf_item_recover.c   |   11 +++++
 fs/xfs/xfs_dquot_item_recover.c |   34 ++++++++++++++
 fs/xfs/xfs_inode_item_recover.c |   19 ++++++++
 fs/xfs/xfs_log_recover.c        |   95 +--------------------------------------
 5 files changed, 73 insertions(+), 92 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 271b0741f1e1..ff80871138bb 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -31,6 +31,9 @@ struct xlog_recover_item_ops {
 	 * values mean.
 	 */
 	enum xlog_recover_reorder (*reorder)(struct xlog_recover_item *item);
+
+	/* Start readahead for pass2, if provided. */
+	void (*ra_pass2)(struct xlog *log, struct xlog_recover_item *item);
 };
 
 extern const struct xlog_recover_item_ops xlog_icreate_item_ops;
@@ -92,4 +95,7 @@ struct xlog_recover {
 #define	XLOG_RECOVER_PASS1	1
 #define	XLOG_RECOVER_PASS2	2
 
+void xlog_buf_readahead(struct xlog *log, xfs_daddr_t blkno, uint len,
+		const struct xfs_buf_ops *ops);
+
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index def19025512e..a1327196b690 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -32,7 +32,18 @@ xlog_recover_buf_reorder(
 	return XLOG_REORDER_BUFFER_LIST;
 }
 
+STATIC void
+xlog_recover_buf_ra_pass2(
+	struct xlog                     *log,
+	struct xlog_recover_item        *item)
+{
+	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
+
+	xlog_buf_readahead(log, buf_f->blf_blkno, buf_f->blf_len, NULL);
+}
+
 const struct xlog_recover_item_ops xlog_buf_item_ops = {
 	.item_type		= XFS_LI_BUF,
 	.reorder		= xlog_recover_buf_reorder,
+	.ra_pass2		= xlog_recover_buf_ra_pass2,
 };
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index 78fe644e9907..215274173b70 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -20,8 +20,42 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 
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
 const struct xlog_recover_item_ops xlog_dquot_item_ops = {
 	.item_type		= XFS_LI_DQUOT,
+	.ra_pass2		= xlog_recover_dquot_ra_pass2,
 };
 
 const struct xlog_recover_item_ops xlog_quotaoff_item_ops = {
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index b19a151efb10..a132cacd8d48 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -21,6 +21,25 @@
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
 const struct xlog_recover_item_ops xlog_inode_item_ops = {
 	.item_type		= XFS_LI_INODE,
+	.ra_pass2		= xlog_recover_inode_ra_pass2,
 };
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0ef0d81fd190..ea566747d8e1 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2023,7 +2023,7 @@ xlog_put_buffer_cancelled(
 	return true;
 }
 
-static void
+void
 xlog_buf_readahead(
 	struct xlog		*log,
 	xfs_daddr_t		blkno,
@@ -3890,96 +3890,6 @@ xlog_recover_do_icreate_pass2(
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
@@ -4116,7 +4026,8 @@ xlog_recover_commit_trans(
 			error = xlog_recover_commit_pass1(log, trans, item);
 			break;
 		case XLOG_RECOVER_PASS2:
-			xlog_recover_ra_pass2(log, item);
+			if (item->ri_ops->ra_pass2)
+				item->ri_ops->ra_pass2(log, item);
 			list_move_tail(&item->ri_list, &ra_list);
 			items_queued++;
 			if (items_queued >= XLOG_RECOVER_COMMIT_QUEUE_MAX) {

