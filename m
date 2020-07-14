Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBC5C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27D2721924
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:33:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sRuQUq43"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgGNBdk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:33:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54132 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgGNBdk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 21:33:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1XZDk162734;
        Tue, 14 Jul 2020 01:33:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=kIEeTj8L8qc0v1a4tjWDImf7612GG1ek9eWE8AyBGBM=;
 b=sRuQUq43vGxOSWUWKJpVN2+/hoJlOAD/Rtx+M1VwF4mppbm4oZhkYotAf8p1H9Hpib86
 lFM/meODougpoC2yKWKUkszTA3qkpbBE6U+RC/TuOUstpSEjGs8Uy1/bbM+lsyakQRrM
 l9GwmyALFZzgXm49WXRCVq1U0FM4gE74l1g3gbB7n6MtV7HrQUdchEI34GRbmD5dX8A3
 JPFt0uKbVDVBad60SyKUM5J8SY0vClwNnvfmr4FbY3UxxclzR42mj0sFiIcjCVUOMgqL
 KCvxiiDM7QohfWXTAQEgKnoSRS+eIzRNxWA3cRK8TifXimYw4HOzk6g4Unhsp5uIh30U cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3275cm2dcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 01:33:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1Wapf063345;
        Tue, 14 Jul 2020 01:33:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 327qbwgyex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 01:33:38 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06E1XbxD012820;
        Tue, 14 Jul 2020 01:33:37 GMT
Received: from localhost (/10.159.128.100)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 18:33:36 -0700
Subject: [PATCH 20/26] xfs: refactor quota exceeded test
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Jul 2020 18:33:36 -0700
Message-ID: <159469041620.2914673.13835099039036173215.stgit@magnolia>
In-Reply-To: <159469028734.2914673.17856142063205791176.stgit@magnolia>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140009
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
index 4e19aac586f4..aeefe82e0e5e 100644
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
 	defq = xfs_get_defquota(qi, dq->q_type);
 
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

