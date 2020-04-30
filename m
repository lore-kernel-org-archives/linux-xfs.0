Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0826EC83000
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D46EB20787
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:50:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZAtEhsUu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgD3AuU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 20:50:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50168 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgD3AuU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 20:50:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0nlRs165815
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:50:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HwUh6gMIWU8Y2heO/DAcMGyi4cOx3SApEV+YtaKB9Us=;
 b=ZAtEhsUu4tFWW7PRI3QDR+jFf5orIdQ2J4ddVxqKx3PMJJEmaldJxnF4m0B0lwRU+8Uh
 IsBtiDiIYAWTKbBcj8uCBukkK6mgro+F7ja+rn46GasgCGH97hogVFaE8R0T953dzeC9
 ppOhYregLB/6fPZmRAPJ26BlQLal2BeA3nB52zRGJNdIep67iAjIMQ1V586ebidJ8+QR
 Xq9dkrpf1OUcywBbca81bS8ast48AVJWWVbRyaY6MTJlRiNaaxgCPuHw1w5QUwrajWpK
 eYqi9BG1CAnYtXXpVNDCAwRbiOYv6uHGCguBd5FiwdT/1+jCakHZxhCFTWx3KOGQjvRk HA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30p01ny8ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:50:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0l738120070
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30my0jr16b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:16 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03U0mFO6013102
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 17:48:15 -0700
Subject: [PATCH 06/21] xfs: refactor log recovery dquot item dispatch for
 pass2 commit functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Apr 2020 17:48:14 -0700
Message-ID: <158820769396.467894.17116807791456540006.stgit@magnolia>
In-Reply-To: <158820765488.467894.15408191148091671053.stgit@magnolia>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=3 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=3 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the log dquot item pass2 commit code into the per-item source code
files and use the dispatch function to call it.  We do these one at a
time because there's a lot of code to move.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot_item.c  |  109 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_recover.c |  112 ----------------------------------------------
 2 files changed, 109 insertions(+), 112 deletions(-)


diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 4d18af49adfe..83bd7ded9185 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -419,8 +419,117 @@ xlog_recover_dquot_ra_pass2(
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
 const struct xlog_recover_item_type xlog_dquot_item_type = {
 	.ra_pass2_fn		= xlog_recover_dquot_ra_pass2,
+	.commit_pass2_fn	= xlog_recover_dquot_commit_pass2,
 };
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 57e5dac0f510..58a54d9e6847 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2056,115 +2056,6 @@ xlog_buf_readahead(
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
@@ -2771,9 +2662,6 @@ xlog_recover_commit_pass2(
 		return xlog_recover_bui_pass2(log, item, trans->r_lsn);
 	case XFS_LI_BUD:
 		return xlog_recover_bud_pass2(log, item);
-	case XFS_LI_DQUOT:
-		return xlog_recover_dquot_pass2(log, buffer_list, item,
-						trans->r_lsn);
 	case XFS_LI_ICREATE:
 		return xlog_recover_do_icreate_pass2(log, buffer_list, item);
 	case XFS_LI_QUOTAOFF:

