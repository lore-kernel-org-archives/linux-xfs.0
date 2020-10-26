Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFCA2C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93554207F7
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tBVwG5wH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406901AbgJZXf2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:35:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55312 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406870AbgJZXf2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:35:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNOXtF164622;
        Mon, 26 Oct 2020 23:35:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0ZzealUtYQiVOROjVcsz7hy0ZBAX50vjuvZAszJfsLA=;
 b=tBVwG5wH6NBMgnJWqO4qupq3wUmto/wkI4A5t3+asIxsbaaQlYgy32SM9STiNm1eoCTW
 nCZzrV0yqjOramh/RYpErN3iFd6LqQrUt2ZRfsn++uOEeB4l2kBp83wRxcjxrr19pUo6
 DuL2Zrr97IurUVlNwf6VHZ++qj3FgFtNBGZHyRsNnEKX4ebfcMki9N3/Nm9d7YVH8hDn
 BPJfYCPQAoXkuyM0WZxBBsAouy61AwHWtK3iLvKPuvpEjXxLtM0eUaW6r8ozPKcxeTah
 zkBeX4zgkoBsdPnGTAGNENe6jCFCQTBsS4zMCNSN0GQxDxgommWjUoUDVGC8TGv/Prfw Xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34dgm3vus5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:35:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQNih058377;
        Mon, 26 Oct 2020 23:35:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34cwukr8xr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:35:20 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNZIS3029190;
        Mon, 26 Oct 2020 23:35:18 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:35:18 -0700
Subject: [PATCH 11/26] xfs: refactor default quota grace period setting code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:35:17 -0700
Message-ID: <160375531739.881414.2197619973398254898.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: ccc8e771aa7a80eb047fc263780816ca76dd02a6

Refactor the code that sets the default quota grace period into a helper
function so that we can override the ondisk behavior later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_format.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index afc068944be9..a5bf27afdd44 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1209,6 +1209,11 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  * been reached, and therefore no expiration has been set.  Therefore, the
  * ondisk min and max defined here can be used directly to constrain the incore
  * quota expiration timestamps on a Unix system.
+ *
+ * The grace period for each quota type is stored in the root dquot (id = 0)
+ * and is applied to a non-root dquot when it exceeds the soft or hard limits.
+ * The length of quota grace periods are unsigned 32-bit quantities measured in
+ * units of seconds.  A value of zero means to use the default period.
  */
 
 /*
@@ -1223,6 +1228,14 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  */
 #define XFS_DQ_LEGACY_EXPIRY_MAX	((int64_t)U32_MAX)
 
+/*
+ * Default quota grace periods, ranging from zero (use the compiled defaults)
+ * to ~136 years.  These are applied to a non-root dquot that has exceeded
+ * either limit.
+ */
+#define XFS_DQ_GRACE_MIN		((int64_t)0)
+#define XFS_DQ_GRACE_MAX		((int64_t)U32_MAX)
+
 /*
  * This is the main portion of the on-disk representation of quota information
  * for a user.  We pad this with some more expansion room to construct the on

