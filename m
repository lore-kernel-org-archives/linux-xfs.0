Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B30C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F3042071B
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:54:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rJZdF9bF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgGOBye (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 21:54:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49956 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727856AbgGOByd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 21:54:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1lhRw167862;
        Wed, 15 Jul 2020 01:52:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=3OaWFh0rJYPVcVNK7hYhu9MJirRKQ/LUMQJeLcKwsCU=;
 b=rJZdF9bFwMj0YX+l6qhvqOyL7vHmbqOtCSLzCeDj5ppF92gds3MRadNKSQmayQ3V5O1R
 PhBrAXkcb6dQ/+0yJsSchM6w8239A/yDIgbM44sBwcy12uBFctnwlwByWmInZLEsD1jv
 hA1kWyokHmvmIf8S6W9rCFLbQkCKS3L7ZwLEDfWYkhR7xyZfycjz6lksdZ2NiOSRn0bb
 GngONB6PVHwUzTQyVQ8n6yFnkImfmfhKULPOHKz/Iy8zex+Vzp8u6ogoc5B59kKEwFON
 br38lSX2+7QdKUZ8QphklRJ9adtW39xR8x8pvwLNFvZq/ZL8jmEvq39s07NvwOP6Meu3 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3275cm8mqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 01:52:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1lcRp125474;
        Wed, 15 Jul 2020 01:52:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 327q6tegky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 01:52:28 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06F1qSxk023895;
        Wed, 15 Jul 2020 01:52:28 GMT
Received: from localhost (/10.159.237.234)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 18:52:27 -0700
Subject: [PATCH 17/26] xfs: remove qcore from incore dquots
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 18:52:26 -0700
Message-ID: <159477794664.3263162.9906343767130491157.stgit@magnolia>
In-Reply-To: <159477783164.3263162.2564345443708779029.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150013
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
 fs/xfs/libxfs/xfs_format.h |    7 +++----
 fs/xfs/scrub/quota.c       |    4 ----
 fs/xfs/xfs_dquot.c         |   36 +++++++++++++-----------------------
 fs/xfs/xfs_dquot.h         |    1 -
 4 files changed, 16 insertions(+), 32 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 76d34b77031a..adc3ca11c012 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1161,10 +1161,9 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DDQTYPE_ANY		(XFS_DDQTYPE_REC_MASK)
 
 /*
- * This is the main portion of the on-disk representation of quota
- * information for a user. This is the q_core of the struct xfs_dquot that
- * is kept in kernel memory. We pad this with some more expansion room
- * to construct the on disk structure.
+ * This is the main portion of the on-disk representation of quota information
+ * for a user.  We pad this with some more expansion room to construct the on
+ * disk structure.
  */
 struct xfs_disk_dquot {
 	__be16		d_magic;	/* dquot magic = XFS_DQUOT_MAGIC */
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index d002af3ab164..f045895f28ff 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -80,7 +80,6 @@ xchk_quota_item(
 	struct xchk_quota_info	*sqi = priv;
 	struct xfs_scrub	*sc = sqi->sc;
 	struct xfs_mount	*mp = sc->mp;
-	struct xfs_disk_dquot	*d = &dq->q_core;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 	xfs_fileoff_t		offset;
 	xfs_ino_t		fs_icount;
@@ -99,9 +98,6 @@ xchk_quota_item(
 
 	sqi->last_id = dq->q_id;
 
-	if (d->d_pad0 != cpu_to_be32(0) || d->d_pad != cpu_to_be16(0))
-		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
-
 	/*
 	 * Warn if the hard limits are larger than the fs.
 	 * Administrators can do this, though in production this seems
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index ad17ce622805..75b22560244e 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -535,7 +535,6 @@ xfs_dquot_from_disk(
 	}
 
 	/* copy everything from disk dquot to the incore dquot */
-	memcpy(&dqp->q_core, ddqp, sizeof(struct xfs_disk_dquot));
 	dqp->q_blk.hardlimit = be64_to_cpu(ddqp->d_blk_hardlimit);
 	dqp->q_blk.softlimit = be64_to_cpu(ddqp->d_blk_softlimit);
 	dqp->q_ino.hardlimit = be64_to_cpu(ddqp->d_ino_hardlimit);
@@ -574,7 +573,13 @@ xfs_dquot_to_disk(
 	struct xfs_disk_dquot	*ddqp,
 	struct xfs_dquot	*dqp)
 {
-	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
+	ddqp->d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
+	ddqp->d_version = XFS_DQUOT_VERSION;
+	ddqp->d_type = dqp->q_type;
+	ddqp->d_id = cpu_to_be32(dqp->q_id);
+	ddqp->d_pad0 = 0;
+	ddqp->d_pad = 0;
+
 	ddqp->d_blk_hardlimit = cpu_to_be64(dqp->q_blk.hardlimit);
 	ddqp->d_blk_softlimit = cpu_to_be64(dqp->q_blk.softlimit);
 	ddqp->d_ino_hardlimit = cpu_to_be64(dqp->q_ino.hardlimit);
@@ -1193,8 +1198,7 @@ xfs_qm_dqflush(
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_log_item	*lip = &dqp->q_logitem.qli_item;
 	struct xfs_buf		*bp;
-	struct xfs_dqblk	*dqb;
-	struct xfs_disk_dquot	*ddqp;
+	struct xfs_dqblk	*dqblk;
 	xfs_failaddr_t		fa;
 	int			error;
 
@@ -1218,22 +1222,6 @@ xfs_qm_dqflush(
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
@@ -1243,7 +1231,9 @@ xfs_qm_dqflush(
 		goto out_abort;
 	}
 
-	xfs_dquot_to_disk(ddqp, dqp);
+	/* Flush the incore dquot to the ondisk buffer. */
+	dqblk = bp->b_addr + dqp->q_bufoffset;
+	xfs_dquot_to_disk(&dqblk->dd_diskdq, dqp);
 
 	/*
 	 * Clear the dirty field and remember the flush lsn for later use.
@@ -1263,8 +1253,8 @@ xfs_qm_dqflush(
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
index 6ad89ccb80c0..9bcfa3330f25 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -72,7 +72,6 @@ struct xfs_dquot {
 	struct xfs_dquot_res	q_ino;	/* inodes */
 	struct xfs_dquot_res	q_rtb;	/* realtime blocks */
 
-	struct xfs_disk_dquot	q_core;
 	struct xfs_dq_logitem	q_logitem;
 
 	xfs_qcnt_t		q_prealloc_lo_wmark;

