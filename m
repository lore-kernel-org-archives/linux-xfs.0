Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B47C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:43:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B85EC2074F
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:43:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OdzwIUA3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389650AbgF3PnY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 11:43:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45306 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389647AbgF3PnY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 11:43:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFgMTg006986
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=yCs6nH8kRiwXFwAhja/daAX/XBfibIppc4ZpEKFzpDE=;
 b=OdzwIUA3RsxP3X2ViJEM0MnLKSyqnPxzAuahDsc/1GmMmml4g150YVyPeSc6RWiW1FoY
 w9uJGxRxOMXuKmi3bzm9VI3wyee3PFifRC74TI+28UMqwXAQ8ZiPWVce4KK60Le194Jy
 CK0YS1iwUMHFc4xFcOcPkNPz+MoXglyvvuQmXjh0lr9e1bay+kcPkpuLLVU2KWZXhA7W
 6O4+IRk8Y7s6pIiVAgbDJsZym8U9360BEQYEJq2u+Cps1Z2ggQ7ko2zw/hEPP+9QC7iV
 V1H+VbgeU04VjPhawNjb3yG3qnhwWTntT6LQViyDBn7CH2cm+yEZh19cHUqFmtwWtaGZ ow== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31wxrn5a07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFNkXv051124
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 31xg1wy7b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:21 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05UFhLXG017486
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 15:43:21 +0000
Subject: [PATCH 14/18] xfs: refactor quota exceeded test
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 30 Jun 2020 08:43:20 -0700
Message-ID: <159353180004.2864738.3571543752803090361.stgit@magnolia>
In-Reply-To: <159353170983.2864738.16885438169173786208.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=1 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300113
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the open-coded test for whether or not we're over quota.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c |   95 ++++++++++++++++------------------------------------
 1 file changed, 30 insertions(+), 65 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 35a113d1b42b..ef34c82c28a0 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -97,6 +97,33 @@ xfs_qm_adjust_dqlimits(
 		xfs_dquot_set_prealloc_limits(dq);
 }
 
+/*
+ * Determine if this quota counter is over either limit and set the quota
+ * timers as appropriate.
+ */
+static inline void
+xfs_qm_adjust_res_timer(
+	struct xfs_dquot_res	*res,
+	struct xfs_def_qres	*dres)
+{
+	bool			over;
+
+#ifdef DEBUG
+	if (res->hardlimit)
+		ASSERT(res->softlimit <= res->hardlimit);
+#endif
+
+	over = (res->softlimit && res->count > res->softlimit) ||
+	       (res->hardlimit && res->count > res->hardlimit);
+
+	if (over && res->timer == 0)
+		res->timer = ktime_get_real_seconds() + dres->timelimit;
+	else if (!over && res->timer != 0)
+		res->timer = 0;
+	else if (!over && res->timer == 0)
+		res->warnings = 0;
+}
+
 /*
  * Check the limits and timers of a dquot and start or reset timers
  * if necessary.
@@ -121,71 +148,9 @@ xfs_qm_adjust_dqtimers(
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
-					defq->dfq_blk.timelimit;
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
-					defq->dfq_ino.timelimit;
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
-					defq->dfq_rtb.timelimit;
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
+	xfs_qm_adjust_res_timer(&dq->q_blk, &defq->dfq_blk);
+	xfs_qm_adjust_res_timer(&dq->q_ino, &defq->dfq_ino);
+	xfs_qm_adjust_res_timer(&dq->q_rtb, &defq->dfq_rtb);
 }
 
 /*

