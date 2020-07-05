Return-Path: <SRS0=iu4H=AQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 795D9C433DF
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 530562075B
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:16:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xmIWrgEh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbgGEWQF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jul 2020 18:16:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41154 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgGEWQF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jul 2020 18:16:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065ME180147698;
        Sun, 5 Jul 2020 22:14:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=oSJ2Srz6PwsLZE7MEJzeB4XeFJ93Tr+VaNi7Ohfd22A=;
 b=xmIWrgEh2raAX7STqFZa4xIZf6Vl5IVSmaiTxObx+C4jXYAslJcAiwuhBuABoNa/eV3n
 0CrXtA0HjKd5D0X1+b+hoHqyqXJ0R6bXlZ5MCPAZc8RJo0vYUjq3u29tb+yuS7ec6LWV
 fNuNnio3A7CYhERMzX/X8tokes0pspcDpKsisxqO/tJjGDOdsnbEepyKAGiKnJsxuDgv
 bJMzJTUL9Nvs4tsg3nph+BVUfgkKwq4fgckYPfc8DpuElZJBRhqZNFCUO9iTCnqU9G20
 eKuJmPavMCK7eI0e+vlm9qE6xkAtdBEDOhxlfytA2wZtGdL/5UuZweghX31kB2jMv8IH tA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 322jdn3f6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 05 Jul 2020 22:14:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MD2Sh111539;
        Sun, 5 Jul 2020 22:14:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3233nx9anh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 05 Jul 2020 22:14:00 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 065MDxAt009123;
        Sun, 5 Jul 2020 22:13:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 05 Jul 2020 15:13:59 -0700
Subject: [PATCH 13/22] xfs: remove qcore from incore dquots
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Sun, 05 Jul 2020 15:13:58 -0700
Message-ID: <159398723836.425236.16683896014000523196.stgit@magnolia>
In-Reply-To: <159398715269.425236.15910213189856396341.stgit@magnolia>
References: <159398715269.425236.15910213189856396341.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007050172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=1 impostorscore=0 spamscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007050172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we've stopped using qcore entirely, drop it from the incore
dquot.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quota.c |    4 ----
 fs/xfs/xfs_dquot.c   |   35 ++++++++++++-----------------------
 fs/xfs/xfs_dquot.h   |    1 -
 3 files changed, 12 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 2fc2625feca0..f4aad5b00188 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -79,7 +79,6 @@ xchk_quota_item(
 	struct xchk_quota_info	*sqi = priv;
 	struct xfs_scrub	*sc = sqi->sc;
 	struct xfs_mount	*mp = sc->mp;
-	struct xfs_disk_dquot	*d = &dq->q_core;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 	xfs_fileoff_t		offset;
 	xfs_ino_t		fs_icount;
@@ -98,9 +97,6 @@ xchk_quota_item(
 
 	sqi->last_id = dq->q_id;
 
-	if (d->d_pad0 != cpu_to_be32(0) || d->d_pad != cpu_to_be16(0))
-		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
-
 	/*
 	 * Warn if the hard limits are larger than the fs.
 	 * Administrators can do this, though in production this seems
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 6738e33102a2..1d96b254539b 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -529,7 +529,6 @@ xfs_dquot_from_disk(
 	}
 
 	/* copy everything from disk dquot to the incore dquot */
-	memcpy(&dqp->q_core, ddqp, sizeof(struct xfs_disk_dquot));
 	dqp->q_blk.hardlimit = be64_to_cpu(ddqp->d_blk_hardlimit);
 	dqp->q_blk.softlimit = be64_to_cpu(ddqp->d_blk_softlimit);
 	dqp->q_ino.hardlimit = be64_to_cpu(ddqp->d_ino_hardlimit);
@@ -568,8 +567,13 @@ xfs_dquot_to_disk(
 	struct xfs_disk_dquot	*ddqp,
 	struct xfs_dquot	*dqp)
 {
-	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
+	ddqp->d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
+	ddqp->d_version = XFS_DQUOT_VERSION;
 	ddqp->d_flags = dqp->dq_flags & XFS_DDQFEAT_TYPE_MASK;
+	ddqp->d_id = cpu_to_be32(dqp->q_id);
+	ddqp->d_pad0 = 0;
+	ddqp->d_pad = 0;
+
 	ddqp->d_blk_hardlimit = cpu_to_be64(dqp->q_blk.hardlimit);
 	ddqp->d_blk_softlimit = cpu_to_be64(dqp->q_blk.softlimit);
 	ddqp->d_ino_hardlimit = cpu_to_be64(dqp->q_ino.hardlimit);
@@ -1181,8 +1185,7 @@ xfs_qm_dqflush(
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_log_item	*lip = &dqp->q_logitem.qli_item;
 	struct xfs_buf		*bp;
-	struct xfs_dqblk	*dqb;
-	struct xfs_disk_dquot	*ddqp;
+	struct xfs_dqblk	*dqblk;
 	xfs_failaddr_t		fa;
 	int			error;
 
@@ -1206,22 +1209,6 @@ xfs_qm_dqflush(
 	if (error)
 		goto out_abort;
 
-	/*
-	 * Calculate the location of the dquot inside the buffer.
-	 */
-	dqb = bp->b_addr + dqp->q_bufoffset;
-	ddqp = &dqb->dd_diskdq;
-
-	/* sanity check the in-core structure before we flush */
-	fa = xfs_dquot_verify(mp, &dqp->q_core, dqp->q_id, 0);
-	if (fa) {
-		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
-				dqp->q_id, fa);
-		xfs_buf_relse(bp);
-		error = -EFSCORRUPTED;
-		goto out_abort;
-	}
-
 	fa = xfs_qm_dqflush_check(dqp);
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
@@ -1231,7 +1218,9 @@ xfs_qm_dqflush(
 		goto out_abort;
 	}
 
-	xfs_dquot_to_disk(ddqp, dqp);
+	/* Flush the incore dquot to the ondisk buffer. */
+	dqblk = bp->b_addr + dqp->q_bufoffset;
+	xfs_dquot_to_disk(&dqblk->dd_diskdq, dqp);
 
 	/*
 	 * Clear the dirty field and remember the flush lsn for later use.
@@ -1251,8 +1240,8 @@ xfs_qm_dqflush(
 	 * of a dquot without an up-to-date CRC getting to disk.
 	 */
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
-		dqb->dd_lsn = cpu_to_be64(dqp->q_logitem.qli_item.li_lsn);
-		xfs_update_cksum((char *)dqb, sizeof(struct xfs_dqblk),
+		dqblk->dd_lsn = cpu_to_be64(dqp->q_logitem.qli_item.li_lsn);
+		xfs_update_cksum((char *)dqblk, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
 	}
 
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 414bae537b1d..62b0fc6e0133 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -71,7 +71,6 @@ struct xfs_dquot {
 	struct xfs_dquot_res	q_ino;	/* inodes */
 	struct xfs_dquot_res	q_rtb;	/* realtime blocks */
 
-	struct xfs_disk_dquot	q_core;
 	struct xfs_dq_logitem	q_logitem;
 
 	xfs_qcnt_t		q_prealloc_lo_wmark;

