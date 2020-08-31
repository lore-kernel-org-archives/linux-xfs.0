Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 859D7C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 06:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6304520707
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 06:07:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R2QVOdS7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgHaGHW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 02:07:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48064 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgHaGHV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 02:07:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07V5rVWo018870;
        Mon, 31 Aug 2020 06:07:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=P8CKoPCr4rU/h017dn0dug4HgtwklolROHM4Fc2NGrU=;
 b=R2QVOdS7aeb05kjFGJROZfQq7cappHP6G8FM0kF+hrRY07hDcN78pGGrZJ1RQ2QTdLuz
 Go7dw6Nqkd2mhVq+mnXOFtiDQ8F8xuDXTq2G7G3OJR1927TMTPw2BCk8hKDvH9gbZ1ki
 lsqjqzGeMMQLBiuey7Fxket2VI7SOyVWPO7B1jw1PIeUHSRiMACkGmc3ZUU31VXTiyWf
 V/a5ghde/ogekJtOZMVlcmzSUyFvnBJPh1Oc1PKlNHA3HJGv+vcxf2fxxlLzHbJlxH11
 LFrvz+gAYOIzcOItV5YSYjNCP413WOAUuN627HpbhljZI25hPe4vXIH+WqBdUOIeZP0P tQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 337qrhbd8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 06:07:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07V5uWq3096789;
        Mon, 31 Aug 2020 06:07:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3380wybgbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 06:07:11 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07V679aT002609;
        Mon, 31 Aug 2020 06:07:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 30 Aug 2020 23:07:09 -0700
Subject: [PATCH 04/11] xfs: refactor quota timestamp coding
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Date:   Sun, 30 Aug 2020 23:07:12 -0700
Message-ID: <159885403263.3608006.17163145829817053656.stgit@magnolia>
In-Reply-To: <159885400575.3608006.17716724192510967135.stgit@magnolia>
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9729 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9729 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor quota timestamp encoding and decoding into helper functions so
that we can add extra behavior in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
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

