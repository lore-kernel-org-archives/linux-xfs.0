Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73072C433E3
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48F52206F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:48:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jtuTM1Ji"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgGPGsf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 02:48:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55824 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgGPGsf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 02:48:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6mYNi084387
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:48:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8qoRR3Anj6Q/qhTpR8D2Yqj3t/0JgA6yjoKVKQszEd0=;
 b=jtuTM1JisQJhlptNCi85V2Q7x7wqCEwmKj09G+zmDaGJy9bSAIuM2kLNwerOB7DQdwG5
 HOsHDMzPmLPvjeoxgQze9SXXTPKb3VIsdzLaPFDl/tWk1t6NaHqxWjoPNTTWj3LxrARi
 uVdzZgwS1MEJNaHrrN3I+6TC2+MHtTwjNvJhzMuaX7ad0M+t6tTAZC1y9tWGHb7jfYGV
 56tzflXh6/JfsNwsNguJ8vYwTrUO0F2DQiPdtbjdMFlA2IUUpQBWaccUrLl/dUWJGs/A
 mZZHezU30r0js+apltpkf7LJJONVXsVQptdyOzLtWgHrn9BRv3AQB/soCaxccJN49xFh lQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3274urfhmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:48:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6hgAF061439
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 327q0srgv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:33 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06G6kWxe007489
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 23:46:31 -0700
Subject: [PATCH 11/11] xfs: rename the ondisk dquot d_flags to d_type
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Jul 2020 23:46:30 -0700
Message-ID: <159488199070.3813063.17484927860165624202.stgit@magnolia>
In-Reply-To: <159488191927.3813063.6443979621452250872.stgit@magnolia>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160051
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The ondisk dquot stores the quota record type in the flags field.
Rename this field to d_type to make the _type relationship between the
ondisk and incore dquot more obvious.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c   |    6 +++---
 fs/xfs/libxfs/xfs_format.h      |    2 +-
 fs/xfs/xfs_dquot.c              |    8 ++++----
 fs/xfs/xfs_dquot_item_recover.c |    4 ++--
 fs/xfs/xfs_qm.c                 |    4 ++--
 5 files changed, 12 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 39d64fbc6b87..5a2db00b9d5f 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -61,9 +61,9 @@ xfs_dquot_verify(
 	if (ddq->d_version != XFS_DQUOT_VERSION)
 		return __this_address;
 
-	if (ddq->d_flags & ~XFS_DQTYPE_ANY)
+	if (ddq->d_type & ~XFS_DQTYPE_ANY)
 		return __this_address;
-	ddq_type = ddq->d_flags & XFS_DQTYPE_REC_MASK;
+	ddq_type = ddq->d_type & XFS_DQTYPE_REC_MASK;
 	if (ddq_type != XFS_DQTYPE_USER &&
 	    ddq_type != XFS_DQTYPE_PROJ &&
 	    ddq_type != XFS_DQTYPE_GROUP)
@@ -124,7 +124,7 @@ xfs_dqblk_repair(
 
 	dqb->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
 	dqb->dd_diskdq.d_version = XFS_DQUOT_VERSION;
-	dqb->dd_diskdq.d_flags = type;
+	dqb->dd_diskdq.d_type = type;
 	dqb->dd_diskdq.d_id = cpu_to_be32(id);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 29564bd32bef..31b7ece985bb 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1168,7 +1168,7 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 struct xfs_disk_dquot {
 	__be16		d_magic;	/* dquot magic = XFS_DQUOT_MAGIC */
 	__u8		d_version;	/* dquot version */
-	__u8		d_flags;	/* XFS_DQTYPE_USER/PROJ/GROUP */
+	__u8		d_type;		/* XFS_DQTYPE_USER/PROJ/GROUP */
 	__be32		d_id;		/* user,project,group id */
 	__be64		d_blk_hardlimit;/* absolute limit on disk blks */
 	__be64		d_blk_softlimit;/* preferred limit on disk blks */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index c37110c09423..131c0582c25a 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -200,7 +200,7 @@ xfs_qm_init_dquot_blk(
 		d->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
 		d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
 		d->dd_diskdq.d_id = cpu_to_be32(curid);
-		d->dd_diskdq.d_flags = type;
+		d->dd_diskdq.d_type = type;
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			uuid_copy(&d->dd_uuid, &mp->m_sb.sb_meta_uuid);
 			xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
@@ -488,7 +488,7 @@ xfs_dquot_from_disk(
 	 * Ensure that we got the type and ID we were looking for.
 	 * Everything else was checked by the dquot buffer verifier.
 	 */
-	if ((ddqp->d_flags & XFS_DQTYPE_REC_MASK) != xfs_dquot_type(dqp) ||
+	if ((ddqp->d_type & XFS_DQTYPE_REC_MASK) != xfs_dquot_type(dqp) ||
 	    be32_to_cpu(ddqp->d_id) != dqp->q_id) {
 		xfs_alert_tag(bp->b_mount, XFS_PTAG_VERIFIER_ERROR,
 			  "Metadata corruption detected at %pS, quota %u",
@@ -498,7 +498,7 @@ xfs_dquot_from_disk(
 	}
 
 	/* copy everything from disk dquot to the incore dquot */
-	dqp->q_type = ddqp->d_flags;
+	dqp->q_type = ddqp->d_type;
 	dqp->q_blk.hardlimit = be64_to_cpu(ddqp->d_blk_hardlimit);
 	dqp->q_blk.softlimit = be64_to_cpu(ddqp->d_blk_softlimit);
 	dqp->q_ino.hardlimit = be64_to_cpu(ddqp->d_ino_hardlimit);
@@ -539,7 +539,7 @@ xfs_dquot_to_disk(
 {
 	ddqp->d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
 	ddqp->d_version = XFS_DQUOT_VERSION;
-	ddqp->d_flags = dqp->q_type;
+	ddqp->d_type = dqp->q_type;
 	ddqp->d_id = cpu_to_be32(dqp->q_id);
 	ddqp->d_pad0 = 0;
 	ddqp->d_pad = 0;
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index 93178341569a..5875c7e1bd28 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -39,7 +39,7 @@ xlog_recover_dquot_ra_pass2(
 	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot))
 		return;
 
-	type = recddq->d_flags & XFS_DQTYPE_REC_MASK;
+	type = recddq->d_type & XFS_DQTYPE_REC_MASK;
 	ASSERT(type);
 	if (log->l_quotaoffs_flag & type)
 		return;
@@ -91,7 +91,7 @@ xlog_recover_dquot_commit_pass2(
 	/*
 	 * This type of quotas was turned off, so ignore this record.
 	 */
-	type = recddq->d_flags & XFS_DQTYPE_REC_MASK;
+	type = recddq->d_type & XFS_DQTYPE_REC_MASK;
 	ASSERT(type);
 	if (log->l_quotaoffs_flag & type)
 		return 0;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 123757717e21..be67570badf8 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -855,14 +855,14 @@ xfs_qm_reset_dqcounts(
 		 * xfs_dquot_verify.
 		 */
 		if (xfs_dqblk_verify(mp, &dqb[j], id + j) ||
-		    (dqb[j].dd_diskdq.d_flags & XFS_DQTYPE_REC_MASK) != type)
+		    (dqb[j].dd_diskdq.d_type & XFS_DQTYPE_REC_MASK) != type)
 			xfs_dqblk_repair(mp, &dqb[j], id + j, type);
 
 		/*
 		 * Reset type in case we are reusing group quota file for
 		 * project quotas or vice versa
 		 */
-		ddq->d_flags = type;
+		ddq->d_type = type;
 		ddq->d_bcount = 0;
 		ddq->d_icount = 0;
 		ddq->d_rtbcount = 0;

