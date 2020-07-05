Return-Path: <SRS0=iu4H=AQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708D3C433E0
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:14:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EE452075B
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:14:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T7xZoZVh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgGEWOV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jul 2020 18:14:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57050 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgGEWOV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jul 2020 18:14:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MCkKD080690;
        Sun, 5 Jul 2020 22:14:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=XmF937HLuZZrckjOLGGMmVk8hcqwAD4AVpv+uzobbjI=;
 b=T7xZoZVhdpYK8wafQBxDbQmWOnQR23LxGxAvzVIuBANvoTBQDsn6SPEk8pRdMFMwLzOA
 XaFba6pEOW32srf0m2r8/DNT6jf9uPdhfEWCvNYJXrlsgqWZFJmn6n6Kbf9jFU8b7ULt
 vWiXMtyHvBCO8hd91BxU4tHQ23DMd/HMPljwQrSH33REED7olEZhxDeu0DvvdBCb1JqJ
 lr85n5rfVeEUm6VzZ97F4X2/5YPPmY32Ivkckq03//TKKZ8Yu97y6wbiCYUtClj7oxcJ
 yHOlI1AzLUWILpf06kE452w+tJLrMZ+z2uBh4TFwxBonD0AzdwSQFFbFzp3uVkCiQGdK Ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 322kv63b0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 05 Jul 2020 22:14:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MD1So111392;
        Sun, 5 Jul 2020 22:14:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3233nx9b7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 05 Jul 2020 22:14:20 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 065MEJnU003450;
        Sun, 5 Jul 2020 22:14:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 05 Jul 2020 15:14:18 -0700
Subject: [PATCH 16/22] xfs: refactor quota exceeded test
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Date:   Sun, 05 Jul 2020 15:14:17 -0700
Message-ID: <159398725762.425236.8895821921631402043.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 suspectscore=1 mlxlogscore=999 phishscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 mlxscore=0 adultscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007050172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the open-coded test for whether or not we're over quota.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/xfs_dquot.c |   91 +++++++++++++++-------------------------------------
 1 file changed, 26 insertions(+), 65 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 3c3f2ab5ebd3..44734584f8fb 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -98,6 +98,29 @@ xfs_qm_adjust_dqlimits(
 		xfs_dquot_set_prealloc_limits(dq);
 }
 
+/*
+ * Determine if this quota counter is over either limit and set the quota
+ * timers as appropriate.
+ */
+static inline void
+xfs_qm_adjust_res_timer(
+	struct xfs_dquot_res	*res,
+	struct xfs_quota_limits	*qlim)
+{
+	ASSERT(res->hardlimit == 0 || res->softlimit <= res->hardlimit);
+
+	if ((res->softlimit && res->count > res->softlimit) ||
+	    (res->hardlimit && res->count > res->hardlimit)) {
+		if (res->timer == 0)
+			res->timer = ktime_get_real_seconds() + qlim->time;
+	} else {
+		if (res->timer == 0)
+			res->warnings = 0;
+		else
+			res->timer = 0;
+	}
+}
+
 /*
  * Check the limits and timers of a dquot and start or reset timers
  * if necessary.
@@ -122,71 +145,9 @@ xfs_qm_adjust_dqtimers(
 	ASSERT(dq->q_id);
 	defq = xfs_get_defquota(qi, xfs_dquot_type(dq));
 
-#ifdef DEBUG
-	if (dq->q_blk.hardlimit)
-		ASSERT(dq->q_blk.softlimit <= dq->q_blk.hardlimit);
-	if (dq->q_ino.hardlimit)
-		ASSERT(dq->q_ino.softlimit <= dq->q_ino.hardlimit);
-	if (dq->q_rtb.hardlimit)
-		ASSERT(dq->q_rtb.softlimit <= dq->q_rtb.hardlimit);
-#endif
-
-	if (!dq->q_blk.timer) {
-		if ((dq->q_blk.softlimit &&
-		     (dq->q_blk.count > dq->q_blk.softlimit)) ||
-		    (dq->q_blk.hardlimit &&
-		     (dq->q_blk.count > dq->q_blk.hardlimit))) {
-			dq->q_blk.timer = ktime_get_real_seconds() +
-					defq->blk.time;
-		} else {
-			dq->q_blk.warnings = 0;
-		}
-	} else {
-		if ((!dq->q_blk.softlimit ||
-		     (dq->q_blk.count <= dq->q_blk.softlimit)) &&
-		    (!dq->q_blk.hardlimit ||
-		    (dq->q_blk.count <= dq->q_blk.hardlimit))) {
-			dq->q_blk.timer = 0;
-		}
-	}
-
-	if (!dq->q_ino.timer) {
-		if ((dq->q_ino.softlimit &&
-		     (dq->q_ino.count > dq->q_ino.softlimit)) ||
-		    (dq->q_ino.hardlimit &&
-		     (dq->q_ino.count > dq->q_ino.hardlimit))) {
-			dq->q_ino.timer = ktime_get_real_seconds() +
-					defq->ino.time;
-		} else {
-			dq->q_ino.warnings = 0;
-		}
-	} else {
-		if ((!dq->q_ino.softlimit ||
-		     (dq->q_ino.count <= dq->q_ino.softlimit))  &&
-		    (!dq->q_ino.hardlimit ||
-		     (dq->q_ino.count <= dq->q_ino.hardlimit))) {
-			dq->q_ino.timer = 0;
-		}
-	}
-
-	if (!dq->q_rtb.timer) {
-		if ((dq->q_rtb.softlimit &&
-		     (dq->q_rtb.count > dq->q_rtb.softlimit)) ||
-		    (dq->q_rtb.hardlimit &&
-		     (dq->q_rtb.count > dq->q_rtb.hardlimit))) {
-			dq->q_rtb.timer = ktime_get_real_seconds() +
-					defq->rtb.time;
-		} else {
-			dq->q_rtb.warnings = 0;
-		}
-	} else {
-		if ((!dq->q_rtb.softlimit ||
-		     (dq->q_rtb.count <= dq->q_rtb.softlimit)) &&
-		    (!dq->q_rtb.hardlimit ||
-		     (dq->q_rtb.count <= dq->q_rtb.hardlimit))) {
-			dq->q_rtb.timer = 0;
-		}
-	}
+	xfs_qm_adjust_res_timer(&dq->q_blk, &defq->blk);
+	xfs_qm_adjust_res_timer(&dq->q_ino, &defq->ino);
+	xfs_qm_adjust_res_timer(&dq->q_rtb, &defq->rtb);
 }
 
 /*

