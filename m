Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 089E8C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5DCD2063A
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:59:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hFqswaFq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgHQW7Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 18:59:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52180 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727874AbgHQW7X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 18:59:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMvetj050132;
        Mon, 17 Aug 2020 22:59:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=UBfUoAELtb46bUNUuLIK4DmaGHrmeZIjSKU4svr1uvI=;
 b=hFqswaFqA6y30VfolUfT0auL3esnhvRO8aUaBFcVa81WzACw+LNzwSM4aps78FqXS5VM
 JDfbqmuTa96fiiI731OyFNhcp9b8B91sC+4mCFDTud8bJBmIuQyQ2f/3ZxJWHuCSDZlp
 86d4UJWTaWdf0JAbwb/2NcMWJCpZdmhxSOEV8LTPSJc4Ec4Ai/v2UaqpB25vdSd54Flz
 JOHw0V+ASzkPUgVVi9Hz7x+Pv5D3JFxAyrSRwEoiUjhztSmvnIPAZLD6FK1vLl2TtVz+
 DmT6RUNV1ANU79GJfuNe4N15gYFmNOaqf9rUeSqyhG1WXbORRuiV3QeXhpQ2x4bNGIYo Mw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32x7nm9jrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 22:59:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMvjXg113897;
        Mon, 17 Aug 2020 22:59:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32xsm18qtw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:59:20 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HMxKv1014548;
        Mon, 17 Aug 2020 22:59:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:59:20 -0700
Subject: [PATCH 04/18] xfs: refactor default quota grace period setting code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 15:59:19 -0700
Message-ID: <159770515944.3958786.9980493388979059788.stgit@magnolia>
In-Reply-To: <159770513155.3958786.16108819726679724438.stgit@magnolia>
References: <159770513155.3958786.16108819726679724438.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the code that sets the default quota grace period into a helper
function so that we can override the ondisk behavior later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_format.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 829eb1e035a5..a60d4ed40946 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1206,6 +1206,11 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  * time zero is the Unix epoch, Jan  1 00:00:01 UTC 1970.  An expiration value
  * of zero means that the quota limit has not been reached, and therefore no
  * expiration has been set.
+ *
+ * The grace period for each quota type is stored in the root dquot (id = 0)
+ * and is applied to a non-root dquot when it exceeds the soft or hard limits.
+ * The length of quota grace periods are unsigned 32-bit quantities measured in
+ * units of seconds.  A value of zero means to use the default period.
  */
 
 /*
@@ -1220,6 +1225,14 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  */
 #define XFS_DQ_TIMEOUT_MAX	((int64_t)U32_MAX)
 
+/*
+ * Default quota grace periods, ranging from zero (use the compiled defaults)
+ * to ~136 years.  These are applied to a non-root dquot that has exceeded
+ * either limit.
+ */
+#define XFS_DQ_GRACE_MIN	((int64_t)0)
+#define XFS_DQ_GRACE_MAX	((int64_t)U32_MAX)
+
 /*
  * This is the main portion of the on-disk representation of quota information
  * for a user.  We pad this with some more expansion room to construct the on

