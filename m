Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDACBC433E4
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8E7920674
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:01:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FfRaOAoN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgHQXBT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 19:01:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36622 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728018AbgHQXBS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 19:01:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMxESG164988;
        Mon, 17 Aug 2020 23:01:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=b4vwkEuaV4D3zkuYzvKAvj7hDUnCsH3w7+JlKo2FZEE=;
 b=FfRaOAoNFB7mLU7HzhYuqiGtbL8RJClsZmDZ/cLuthpme8nO+mjKyUIwZx6DIz1RZoso
 Yu1WxNjZZFEeNyNCD+MWSr5436ZW8cP6JxOXHP10QRegV63DGGs3CoUWtuoUbuoAnrfN
 sjmVSg3UlmYkZhZvk7z8dkpSh7GQxs4xwWQdzOmySFM+8yJUcwPw1G57pyCdf/JjkR6k
 dL7gLRLtyoRNkOhuYAFzTncItn9JfQ+1gP03mC3B91tzG9f6z+BjXSkzIIsAqaObsD9L
 CfH3OBm3tN28yHIbRsY3P/YiBq8SsYPzoZJcn8yOxdjq2qRuQcfpbDyaeNi2THMyvpiZ Jw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32x74r1n2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 23:01:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMw81b139087;
        Mon, 17 Aug 2020 22:59:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32xs9m9ywb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:59:15 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HMxEMq017896;
        Mon, 17 Aug 2020 22:59:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:59:14 -0700
Subject: [PATCH 03/18] xfs: refactor quota expiration timer modification
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 15:59:12 -0700
Message-ID: <159770515211.3958786.7094290347539609121.stgit@magnolia>
In-Reply-To: <159770513155.3958786.16108819726679724438.stgit@magnolia>
References: <159770513155.3958786.16108819726679724438.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Define explicit limits on the range of quota grace period expiration
timeouts and refactor the code that modifies the timeouts into helpers
that clamp the values appropriately.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_format.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index f2a851e49ec3..829eb1e035a5 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1198,6 +1198,28 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 
 #define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK)
 
+/*
+ * XFS Quota Timers
+ * ================
+ *
+ * Quota grace period expiration timers are an unsigned 32-bit seconds counter;
+ * time zero is the Unix epoch, Jan  1 00:00:01 UTC 1970.  An expiration value
+ * of zero means that the quota limit has not been reached, and therefore no
+ * expiration has been set.
+ */
+
+/*
+ * Smallest possible quota expiration with traditional timestamps, which is
+ * Jan  1 00:00:01 UTC 1970.
+ */
+#define XFS_DQ_TIMEOUT_MIN	((int64_t)1)
+
+/*
+ * Largest possible quota expiration with traditional timestamps, which is
+ * Feb  7 06:28:15 UTC 2106.
+ */
+#define XFS_DQ_TIMEOUT_MAX	((int64_t)U32_MAX)
+
 /*
  * This is the main portion of the on-disk representation of quota information
  * for a user.  We pad this with some more expansion room to construct the on

