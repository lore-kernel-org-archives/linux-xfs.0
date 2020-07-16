Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3559C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B9CD2070E
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:46:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aOLlJtgZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgGPGqP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 02:46:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54256 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbgGPGqP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 02:46:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6gBDH079761
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Z5X4XM63FkUyrk8T4xqpcfI3yO1w64k36P9frbbSSU0=;
 b=aOLlJtgZUPnVrFZXVhHgerQNtibUv+QHM1Av+NvWYJxZkYvP3cADR+T2DwRs3watI9km
 Tnyv8XBLRx49dvILPL4PaLE+m13n0DRpte7jldSLoWGqQq7W9G2H+5cJ2cG8ENYPGHRZ
 zlJOuR/dkCA8E6E8DkCmGinjH+eIKKmOxHZfZUYNknQZmW01rjEJR0Yw3BWyyhwus4YQ
 ofsr4IsVc7XyvcSd7uLFO3mq0dW3X0Yy8B+1KquZra6M+rBGT3EpYomusYxK/r+C58ay
 o3a4NbnOsOeKNHZcQa6llGY5lWAdN0jAMhn7wWi5JeCJfciFURWp/zFj7VcdGEhDyIZP sQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3274urfhdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6hegv142900
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 327qba7523-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:12 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06G6kBr1014882
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 23:46:11 -0700
Subject: [PATCH 08/11] xfs: replace a few open-coded XFS_DQTYPE_REC_MASK uses
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Jul 2020 23:46:10 -0700
Message-ID: <159488197022.3813063.2727213433560259185.stgit@magnolia>
In-Reply-To: <159488191927.3813063.6443979621452250872.stgit@magnolia>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=1 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160050
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix a few places where we open-coded this mask constant.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot_item_recover.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index d7eb85c7d394..93178341569a 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -39,7 +39,7 @@ xlog_recover_dquot_ra_pass2(
 	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot))
 		return;
 
-	type = recddq->d_flags & (XFS_DQTYPE_USER | XFS_DQTYPE_PROJ | XFS_DQTYPE_GROUP);
+	type = recddq->d_flags & XFS_DQTYPE_REC_MASK;
 	ASSERT(type);
 	if (log->l_quotaoffs_flag & type)
 		return;
@@ -91,7 +91,7 @@ xlog_recover_dquot_commit_pass2(
 	/*
 	 * This type of quotas was turned off, so ignore this record.
 	 */
-	type = recddq->d_flags & (XFS_DQTYPE_USER | XFS_DQTYPE_PROJ | XFS_DQTYPE_GROUP);
+	type = recddq->d_flags & XFS_DQTYPE_REC_MASK;
 	ASSERT(type);
 	if (log->l_quotaoffs_flag & type)
 		return 0;

