Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC7FC433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 22:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB459207BC
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 22:07:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V3mSx7s3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgHZWHc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 18:07:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44134 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgHZWHc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 18:07:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QLxmjN139829;
        Wed, 26 Aug 2020 22:07:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=cDiWO5fZAcipDfKDo/SgfKWJqNk6WxBNq5dK9c12J8o=;
 b=V3mSx7s3phwWmHLiqt/NztlfTRvQEcjWZXHRDhfXwIehOVoEQiXXvnzTJqvQDaM4ms1R
 qnaWl1kfG34C3iQr+8EdNxBUvWYhCSjBwORsE1e7eN7UDMSlnV5wM8Vl+ypRiJ3DR9tz
 +vvh5N6iW3jG0rowckM/AUL/Ej8QJmFEfxJJ0q4tal3YxHu5Y5SwZUt1AQX8U79EjOxd
 YzePHNgtspExO9je7HZlZmpjnNKACdKbK2DOolK7z7wjh25BUCfBxEXntXs799oe6Kep
 Siptlg3yZX3tCfpqVzHyH8DurGAiuJmyvMclqH+igacAGQ3zS7MTpplkASNjoOsoCzNr gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 333w6u1kqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Aug 2020 22:07:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QM4qts113693;
        Wed, 26 Aug 2020 22:05:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 333r9mpwhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Aug 2020 22:05:25 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07QM5Pq6026645;
        Wed, 26 Aug 2020 22:05:25 GMT
Received: from localhost (/10.159.146.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 15:05:25 -0700
Subject: [PATCH 04/11] xfs: refactor quota timestamp coding
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Date:   Wed, 26 Aug 2020 15:05:24 -0700
Message-ID: <159847952392.2601708.833795605203708912.stgit@magnolia>
In-Reply-To: <159847949739.2601708.16579235017313836378.stgit@magnolia>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008260170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008260169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor quota timestamp encoding and decoding into helper functions so
that we can add extra behavior in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c  |   18 ++++++++++++++++++
 fs/xfs/libxfs/xfs_quota_defs.h |    5 +++++
 fs/xfs/xfs_dquot.c             |   12 ++++++------
 3 files changed, 29 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 5a2db00b9d5f..cf85bad8a894 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -288,3 +288,21 @@ const struct xfs_buf_ops xfs_dquot_buf_ra_ops = {
 	.verify_read = xfs_dquot_buf_readahead_verify,
 	.verify_write = xfs_dquot_buf_write_verify,
 };
+
+/* Convert an on-disk timer value into an incore timer value. */
+time64_t
+xfs_dquot_from_disk_ts(
+	struct xfs_disk_dquot	*ddq,
+	__be32			dtimer)
+{
+	return be32_to_cpu(dtimer);
+}
+
+/* Convert an incore timer value into an on-disk timer value. */
+__be32
+xfs_dquot_to_disk_ts(
+	struct xfs_dquot	*dqp,
+	time64_t		timer)
+{
+	return cpu_to_be32(timer);
+}
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 076bdc7037ee..9a99910d857e 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -143,4 +143,9 @@ extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
 extern void xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
 		xfs_dqid_t id, xfs_dqtype_t type);
 
+struct xfs_dquot;
+time64_t xfs_dquot_from_disk_ts(struct xfs_disk_dquot *ddq,
+		__be32 dtimer);
+__be32 xfs_dquot_to_disk_ts(struct xfs_dquot *ddq, time64_t timer);
+
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index e63a933413a3..59c03e973741 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -536,9 +536,9 @@ xfs_dquot_from_disk(
 	dqp->q_ino.warnings = be16_to_cpu(ddqp->d_iwarns);
 	dqp->q_rtb.warnings = be16_to_cpu(ddqp->d_rtbwarns);
 
-	dqp->q_blk.timer = be32_to_cpu(ddqp->d_btimer);
-	dqp->q_ino.timer = be32_to_cpu(ddqp->d_itimer);
-	dqp->q_rtb.timer = be32_to_cpu(ddqp->d_rtbtimer);
+	dqp->q_blk.timer = xfs_dquot_from_disk_ts(ddqp, ddqp->d_btimer);
+	dqp->q_ino.timer = xfs_dquot_from_disk_ts(ddqp, ddqp->d_itimer);
+	dqp->q_rtb.timer = xfs_dquot_from_disk_ts(ddqp, ddqp->d_rtbtimer);
 
 	/*
 	 * Reservation counters are defined as reservation plus current usage
@@ -581,9 +581,9 @@ xfs_dquot_to_disk(
 	ddqp->d_iwarns = cpu_to_be16(dqp->q_ino.warnings);
 	ddqp->d_rtbwarns = cpu_to_be16(dqp->q_rtb.warnings);
 
-	ddqp->d_btimer = cpu_to_be32(dqp->q_blk.timer);
-	ddqp->d_itimer = cpu_to_be32(dqp->q_ino.timer);
-	ddqp->d_rtbtimer = cpu_to_be32(dqp->q_rtb.timer);
+	ddqp->d_btimer = xfs_dquot_to_disk_ts(dqp, dqp->q_blk.timer);
+	ddqp->d_itimer = xfs_dquot_to_disk_ts(dqp, dqp->q_ino.timer);
+	ddqp->d_rtbtimer = xfs_dquot_to_disk_ts(dqp, dqp->q_rtb.timer);
 }
 
 /* Allocate and initialize the dquot buffer for this in-core dquot. */

