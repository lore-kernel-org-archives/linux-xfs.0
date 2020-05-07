Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD7F7C28CBC
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAC9320747
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:06:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iWV5LhlH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgEGBGh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 21:06:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55170 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbgEGBGg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 21:06:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04710AZI123975;
        Thu, 7 May 2020 01:04:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Auk2Q2LgYxnu64o9Fesp9BjAuDfIJY3f7TQlbB58yXI=;
 b=iWV5LhlHC3FFhaP0AhgOpX6tF6e/qRKe8R7yIcq6JAm+o+k6kh6XlPl/kFEd3WlcQ0DZ
 8iRPABHFzSNi4rSSThVObMp0BIFqO2tdmUyWVev/f1hb4pgX8SHavQDiaNFvz130BqNs
 /10AIAeF4D+mnCYbk7I1Cp+bnoWPKZIfY3ZK7PJPNKIRZ+bJl2iOFGujotHRWekxQaf6
 DhyTo5rP6n/h0hN7Wvh6q3folQoM1355ECi2ebGNX+W2kBO8xT9PBTtMNz+uC7zgoBLM
 DmkoY4MniuXqmrhVxl+1ZchUsmUM45Ir3QHAB2MpZgGMRiVSUPR5Bd4NkJwFF0bKahFT 0Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30usgq4jhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:04:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470vnq9010094;
        Thu, 7 May 2020 01:02:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30t1r96e70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:02:31 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04712VIO031555;
        Thu, 7 May 2020 01:02:31 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 18:02:29 -0700
Subject: [PATCH 07/25] xfs: refactor log recovery dquot item dispatch for
 pass2 commit functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 06 May 2020 18:02:24 -0700
Message-ID: <158881334430.189971.950841035123911645.stgit@magnolia>
In-Reply-To: <158881329912.189971.14392758631836955942.stgit@magnolia>
References: <158881329912.189971.14392758631836955942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=3
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the log dquot item pass2 commit code into the per-item source code
files and use the dispatch function to call it.  We do these one at a
time because there's a lot of code to move.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot_item_recover.c |  109 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_recover.c        |  112 ---------------------------------------
 2 files changed, 109 insertions(+), 112 deletions(-)


diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index ebc44c1bc2b1..07ff943972a3 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -53,9 +53,118 @@ xlog_recover_dquot_ra_pass2(
 			&xfs_dquot_buf_ra_ops);
 }
 
+/*
+ * Recover a dquot record
+ */
+STATIC int
+xlog_recover_dquot_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			current_lsn)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_buf			*bp;
+	struct xfs_disk_dquot		*ddq, *recddq;
+	struct xfs_dq_logformat		*dq_f;
+	xfs_failaddr_t			fa;
+	int				error;
+	uint				type;
+
+	/*
+	 * Filesystems are required to send in quota flags at mount time.
+	 */
+	if (mp->m_qflags == 0)
+		return 0;
+
+	recddq = item->ri_buf[1].i_addr;
+	if (recddq == NULL) {
+		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
+		return -EFSCORRUPTED;
+	}
+	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot)) {
+		xfs_alert(log->l_mp, "dquot too small (%d) in %s.",
+			item->ri_buf[1].i_len, __func__);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * This type of quotas was turned off, so ignore this record.
+	 */
+	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
+	ASSERT(type);
+	if (log->l_quotaoffs_flag & type)
+		return 0;
+
+	/*
+	 * At this point we know that quota was _not_ turned off.
+	 * Since the mount flags are not indicating to us otherwise, this
+	 * must mean that quota is on, and the dquot needs to be replayed.
+	 * Remember that we may not have fully recovered the superblock yet,
+	 * so we can't do the usual trick of looking at the SB quota bits.
+	 *
+	 * The other possibility, of course, is that the quota subsystem was
+	 * removed since the last mount - ENOSYS.
+	 */
+	dq_f = item->ri_buf[0].i_addr;
+	ASSERT(dq_f);
+	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, 0);
+	if (fa) {
+		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
+				dq_f->qlf_id, fa);
+		return -EFSCORRUPTED;
+	}
+	ASSERT(dq_f->qlf_len == 1);
+
+	/*
+	 * At this point we are assuming that the dquots have been allocated
+	 * and hence the buffer has valid dquots stamped in it. It should,
+	 * therefore, pass verifier validation. If the dquot is bad, then the
+	 * we'll return an error here, so we don't need to specifically check
+	 * the dquot in the buffer after the verifier has run.
+	 */
+	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dq_f->qlf_blkno,
+				   XFS_FSB_TO_BB(mp, dq_f->qlf_len), 0, &bp,
+				   &xfs_dquot_buf_ops);
+	if (error)
+		return error;
+
+	ASSERT(bp);
+	ddq = xfs_buf_offset(bp, dq_f->qlf_boffset);
+
+	/*
+	 * If the dquot has an LSN in it, recover the dquot only if it's less
+	 * than the lsn of the transaction we are replaying.
+	 */
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dqblk *dqb = (struct xfs_dqblk *)ddq;
+		xfs_lsn_t	lsn = be64_to_cpu(dqb->dd_lsn);
+
+		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
+			goto out_release;
+		}
+	}
+
+	memcpy(ddq, recddq, item->ri_buf[1].i_len);
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		xfs_update_cksum((char *)ddq, sizeof(struct xfs_dqblk),
+				 XFS_DQUOT_CRC_OFF);
+	}
+
+	ASSERT(dq_f->qlf_size == 2);
+	ASSERT(bp->b_mount == mp);
+	bp->b_iodone = xlog_recover_iodone;
+	xfs_buf_delwri_queue(bp, buffer_list);
+
+out_release:
+	xfs_buf_relse(bp);
+	return 0;
+}
+
 const struct xlog_recover_item_ops xlog_dquot_item_ops = {
 	.item_type		= XFS_LI_DQUOT,
 	.ra_pass2		= xlog_recover_dquot_ra_pass2,
+	.commit_pass2		= xlog_recover_dquot_commit_pass2,
 };
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 8bf8d4dec0d7..1b96df783756 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2034,115 +2034,6 @@ xlog_buf_readahead(
 		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
 }
 
-/*
- * Recover a dquot record
- */
-STATIC int
-xlog_recover_dquot_pass2(
-	struct xlog			*log,
-	struct list_head		*buffer_list,
-	struct xlog_recover_item	*item,
-	xfs_lsn_t			current_lsn)
-{
-	xfs_mount_t		*mp = log->l_mp;
-	xfs_buf_t		*bp;
-	struct xfs_disk_dquot	*ddq, *recddq;
-	xfs_failaddr_t		fa;
-	int			error;
-	xfs_dq_logformat_t	*dq_f;
-	uint			type;
-
-
-	/*
-	 * Filesystems are required to send in quota flags at mount time.
-	 */
-	if (mp->m_qflags == 0)
-		return 0;
-
-	recddq = item->ri_buf[1].i_addr;
-	if (recddq == NULL) {
-		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
-		return -EFSCORRUPTED;
-	}
-	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot)) {
-		xfs_alert(log->l_mp, "dquot too small (%d) in %s.",
-			item->ri_buf[1].i_len, __func__);
-		return -EFSCORRUPTED;
-	}
-
-	/*
-	 * This type of quotas was turned off, so ignore this record.
-	 */
-	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
-	ASSERT(type);
-	if (log->l_quotaoffs_flag & type)
-		return 0;
-
-	/*
-	 * At this point we know that quota was _not_ turned off.
-	 * Since the mount flags are not indicating to us otherwise, this
-	 * must mean that quota is on, and the dquot needs to be replayed.
-	 * Remember that we may not have fully recovered the superblock yet,
-	 * so we can't do the usual trick of looking at the SB quota bits.
-	 *
-	 * The other possibility, of course, is that the quota subsystem was
-	 * removed since the last mount - ENOSYS.
-	 */
-	dq_f = item->ri_buf[0].i_addr;
-	ASSERT(dq_f);
-	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, 0);
-	if (fa) {
-		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
-				dq_f->qlf_id, fa);
-		return -EFSCORRUPTED;
-	}
-	ASSERT(dq_f->qlf_len == 1);
-
-	/*
-	 * At this point we are assuming that the dquots have been allocated
-	 * and hence the buffer has valid dquots stamped in it. It should,
-	 * therefore, pass verifier validation. If the dquot is bad, then the
-	 * we'll return an error here, so we don't need to specifically check
-	 * the dquot in the buffer after the verifier has run.
-	 */
-	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dq_f->qlf_blkno,
-				   XFS_FSB_TO_BB(mp, dq_f->qlf_len), 0, &bp,
-				   &xfs_dquot_buf_ops);
-	if (error)
-		return error;
-
-	ASSERT(bp);
-	ddq = xfs_buf_offset(bp, dq_f->qlf_boffset);
-
-	/*
-	 * If the dquot has an LSN in it, recover the dquot only if it's less
-	 * than the lsn of the transaction we are replaying.
-	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
-		struct xfs_dqblk *dqb = (struct xfs_dqblk *)ddq;
-		xfs_lsn_t	lsn = be64_to_cpu(dqb->dd_lsn);
-
-		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
-			goto out_release;
-		}
-	}
-
-	memcpy(ddq, recddq, item->ri_buf[1].i_len);
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
-		xfs_update_cksum((char *)ddq, sizeof(struct xfs_dqblk),
-				 XFS_DQUOT_CRC_OFF);
-	}
-
-	ASSERT(dq_f->qlf_size == 2);
-	ASSERT(bp->b_mount == mp);
-	bp->b_iodone = xlog_recover_iodone;
-	xfs_buf_delwri_queue(bp, buffer_list);
-
-out_release:
-	xfs_buf_relse(bp);
-	return 0;
-}
-
 /*
  * This routine is called to create an in-core extent free intent
  * item from the efi format structure which was logged on disk.
@@ -2730,9 +2621,6 @@ xlog_recover_commit_pass2(
 		return xlog_recover_bui_pass2(log, item, trans->r_lsn);
 	case XFS_LI_BUD:
 		return xlog_recover_bud_pass2(log, item);
-	case XFS_LI_DQUOT:
-		return xlog_recover_dquot_pass2(log, buffer_list, item,
-						trans->r_lsn);
 	case XFS_LI_ICREATE:
 		return xlog_recover_do_icreate_pass2(log, buffer_list, item);
 	case XFS_LI_QUOTAOFF:

