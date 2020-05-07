Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF675C28CBC
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:04:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2E9920735
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:04:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KgRtFnYl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgEGBEI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 21:04:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53258 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbgEGBEI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 21:04:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470xDZw123052;
        Thu, 7 May 2020 01:04:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EyEaH8KaLm9qO/Un4c7XsuCTW30W7ObC1fxhu4qPt5E=;
 b=KgRtFnYl+SaNzNYOrfDioFRxobjokZXpXlMIB1Hcuw1e31Zvy+70g3Lsr+m5Gj02RJdt
 hH688a/LVpZU/DqW/h3KzruUFy+FPKm89LA1N0KqF7OVmYChDL8ciQYyB0NHv4FNTw2r
 uPt/cwEzO1VzOznb7BsWjvoj/kR0zTIt2GvK+zfJjijUOJ/vk/pko+kQdEHapMLDtITN
 WCt3h4s2o5ejYZV5lyssFZtzFmaxSi3gIyO/gr+Khzd1N0wkPYBjmrSy+Su5Tde8L5rB
 sSXEQq/HtukRSwBObiRVwm8htpNsRqx13VXtw7ZZ5OvPo6PxZX62p4tXnj6UV5IzgDr4 cQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30usgq4jh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:04:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470vWSH150916;
        Thu, 7 May 2020 01:02:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30sjnmbh39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:02:03 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 047122Kd031400;
        Thu, 7 May 2020 01:02:02 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 18:02:02 -0700
Subject: [PATCH 03/25] xfs: refactor log recovery item dispatch for pass2
 readhead functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 06 May 2020 18:01:58 -0700
Message-ID: <158881331857.189971.2554662484351362640.stgit@magnolia>
In-Reply-To: <158881329912.189971.14392758631836955942.stgit@magnolia>
References: <158881329912.189971.14392758631836955942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the pass2 readhead code into the per-item source code files and use
the dispatch function to call them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_recover.h |    6 ++
 fs/xfs/xfs_buf_item_recover.c   |   11 +++++
 fs/xfs/xfs_dquot_item_recover.c |   34 ++++++++++++++
 fs/xfs/xfs_inode_item_recover.c |   19 ++++++++
 fs/xfs/xfs_log_recover.c        |   95 +--------------------------------------
 5 files changed, 73 insertions(+), 92 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index c9c27e6367bb..ceb1e1e9d1d1 100644
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
index 5dea6323ff1f..e35892534aaa 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -46,7 +46,18 @@ xlog_recover_buf_reorder(
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
index e44c64fca65f..7fd0126a80bf 100644
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

