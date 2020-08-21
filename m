Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E12C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 02:12:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9A212076E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 02:12:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z11SLGAc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgHUCMe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 22:12:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35034 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbgHUCMe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 22:12:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L274Kq043422;
        Fri, 21 Aug 2020 02:12:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=TFDGAHLyE+yo8vBTQrrfnNYuB+17IDntmPWtH4u21DQ=;
 b=Z11SLGAcKtUt9RQzB5siKghYptnuUaW+D03zJW+Oifq7i77b+pvw/loFWKdzaGA3pBsj
 P4UcJJLxoOfoJpMC+3K7i0TiLD0s4RdOEUV8fTeZ5wy22WId5Avb1LoR7XEVC28MuNN6
 a2QY79+J/eY2/+pQgutIsWFdCDRCUxkDjAsMU5Dzv6h19G5s9zVoJ2gYHQJJS6LsCVEX
 lJ8ZEqmL2MBZQ1Lh6gX6k1PGxX/Vm7hiuj3AE3i+VxKtSpXzlVyfpQO8hmMv3PBTqRfY
 EWOhrYAgM4fvokPzGdlR8LWr1qNSoz+0zjry/WUGO81A/5c8ntcGOPlS0rUYGqfLjGDw 8Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32x8bnkr94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Aug 2020 02:12:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L292RM012051;
        Fri, 21 Aug 2020 02:12:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32xsn230d0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 02:12:30 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07L2CTYT011276;
        Fri, 21 Aug 2020 02:12:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Aug 2020 19:12:29 -0700
Subject: [PATCH 09/11] xfs: refactor quota timestamp coding
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Date:   Thu, 20 Aug 2020 19:12:28 -0700
Message-ID: <159797594823.965217.2346364691307432620.stgit@magnolia>
In-Reply-To: <159797588727.965217.7260803484540460144.stgit@magnolia>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210018
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
 fs/xfs/libxfs/xfs_dquot_buf.c  |   20 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_quota_defs.h |    6 ++++++
 fs/xfs/xfs_dquot.c             |   12 ++++++------
 3 files changed, 32 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 5a2db00b9d5f..7f5291022b11 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -288,3 +288,23 @@ const struct xfs_buf_ops xfs_dquot_buf_ra_ops = {
 	.verify_read = xfs_dquot_buf_readahead_verify,
 	.verify_write = xfs_dquot_buf_write_verify,
 };
+
+/* Convert an on-disk timer value into an incore timer value. */
+void
+xfs_dquot_from_disk_timestamp(
+	struct xfs_disk_dquot	*ddq,
+	time64_t		*timer,
+	__be32			dtimer)
+{
+	*timer = be32_to_cpu(dtimer);
+}
+
+/* Convert an incore timer value into an on-disk timer value. */
+void
+xfs_dquot_to_disk_timestamp(
+	struct xfs_dquot	*dqp,
+	__be32			*dtimer,
+	time64_t		timer)
+{
+	*dtimer = cpu_to_be32(timer);
+}
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 076bdc7037ee..b524059faab5 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -143,4 +143,10 @@ extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
 extern void xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
 		xfs_dqid_t id, xfs_dqtype_t type);
 
+struct xfs_dquot;
+void xfs_dquot_from_disk_timestamp(struct xfs_disk_dquot *ddq,
+		time64_t *timer, __be32 dtimer);
+void xfs_dquot_to_disk_timestamp(struct xfs_dquot *ddq,
+		__be32 *dtimer, time64_t timer);
+
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index ed3fa6ada0d3..08d497d413b9 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -534,9 +534,9 @@ xfs_dquot_from_disk(
 	dqp->q_ino.warnings = be16_to_cpu(ddqp->d_iwarns);
 	dqp->q_rtb.warnings = be16_to_cpu(ddqp->d_rtbwarns);
 
-	dqp->q_blk.timer = be32_to_cpu(ddqp->d_btimer);
-	dqp->q_ino.timer = be32_to_cpu(ddqp->d_itimer);
-	dqp->q_rtb.timer = be32_to_cpu(ddqp->d_rtbtimer);
+	xfs_dquot_from_disk_timestamp(ddqp, &dqp->q_blk.timer, ddqp->d_btimer);
+	xfs_dquot_from_disk_timestamp(ddqp, &dqp->q_ino.timer, ddqp->d_itimer);
+	xfs_dquot_from_disk_timestamp(ddqp, &dqp->q_rtb.timer, ddqp->d_rtbtimer);
 
 	/*
 	 * Reservation counters are defined as reservation plus current usage
@@ -579,9 +579,9 @@ xfs_dquot_to_disk(
 	ddqp->d_iwarns = cpu_to_be16(dqp->q_ino.warnings);
 	ddqp->d_rtbwarns = cpu_to_be16(dqp->q_rtb.warnings);
 
-	ddqp->d_btimer = cpu_to_be32(dqp->q_blk.timer);
-	ddqp->d_itimer = cpu_to_be32(dqp->q_ino.timer);
-	ddqp->d_rtbtimer = cpu_to_be32(dqp->q_rtb.timer);
+	xfs_dquot_to_disk_timestamp(dqp, &ddqp->d_btimer, dqp->q_blk.timer);
+	xfs_dquot_to_disk_timestamp(dqp, &ddqp->d_itimer, dqp->q_ino.timer);
+	xfs_dquot_to_disk_timestamp(dqp, &ddqp->d_rtbtimer, dqp->q_rtb.timer);
 }
 
 /* Allocate and initialize the dquot buffer for this in-core dquot. */

