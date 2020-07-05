Return-Path: <SRS0=iu4H=AQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F9CC433DF
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D289F2075B
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:14:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zvaF7pTU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgGEWOr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jul 2020 18:14:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45840 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgGEWOr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jul 2020 18:14:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MCcoq002358
        for <linux-xfs@vger.kernel.org>; Sun, 5 Jul 2020 22:14:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ohe/ra8XF7FxXd04y30ZDCcwTHkgb8qB5fsE15t4yqw=;
 b=zvaF7pTUMCrlZ6xyqCeeADUI2bzgLMqtaWHDgjTBe1BVPjhvvgpXi69/5Sxs+CRsgkmL
 kXxL8zd0is8HkFM7bgBkBtDjPVn7gImOQo7nwnsOYKLIZJ6f4RpZlquitbBHrC1StM9B
 ud9u6Xtcj41c/W45bUwzxbfgfIXUCC30avTAC7ympuEYXcyoiRWYahPhZuWqwoRoPPn9
 yXMFhmTa3FWcq4SdqsEyY13NEEJ++17GH7lkgJE6pVjaTzQolmabYuRuPQiRJO3SkLq9
 p2NLa3L3ZJSC/8F6VPZT3ZUL8BRcRlpGZTS1bAXDY8wdmCynHAffl6dNTkjQNTuHq6+Y AQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 322h6r3j4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sun, 05 Jul 2020 22:14:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MD4sr158966
        for <linux-xfs@vger.kernel.org>; Sun, 5 Jul 2020 22:14:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3233bkj1s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 05 Jul 2020 22:14:45 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 065MEiCv027127
        for <linux-xfs@vger.kernel.org>; Sun, 5 Jul 2020 22:14:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 05 Jul 2020 15:14:44 -0700
Subject: [PATCH 20/22] xfs: assume the default quota limits are always set in
 xfs_qm_adjust_dqlimits
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 05 Jul 2020 15:14:43 -0700
Message-ID: <159398728304.425236.3397718848155708532.stgit@magnolia>
In-Reply-To: <159398715269.425236.15910213189856396341.stgit@magnolia>
References: <159398715269.425236.15910213189856396341.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=832 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007050172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=1 adultscore=0 mlxscore=0 spamscore=0 impostorscore=0
 cotscore=-2147483648 malwarescore=0 mlxlogscore=841 clxscore=1015
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007050172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We always initialize the default quota limits to something nowadays, so
we don't need to check that the defaults are set to something before
using them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 44734584f8fb..710119538a6a 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -77,21 +77,21 @@ xfs_qm_adjust_dqlimits(
 	ASSERT(dq->q_id);
 	defq = xfs_get_defquota(q, xfs_dquot_type(dq));
 
-	if (defq->blk.soft && !dq->q_blk.softlimit) {
+	if (!dq->q_blk.softlimit) {
 		dq->q_blk.softlimit = defq->blk.soft;
 		prealloc = 1;
 	}
-	if (defq->blk.hard && !dq->q_blk.hardlimit) {
+	if (!dq->q_blk.hardlimit) {
 		dq->q_blk.hardlimit = defq->blk.hard;
 		prealloc = 1;
 	}
-	if (defq->ino.soft && !dq->q_ino.softlimit)
+	if (!dq->q_ino.softlimit)
 		dq->q_ino.softlimit = defq->ino.soft;
-	if (defq->ino.hard && !dq->q_ino.hardlimit)
+	if (!dq->q_ino.hardlimit)
 		dq->q_ino.hardlimit = defq->ino.hard;
-	if (defq->rtb.soft && !dq->q_rtb.softlimit)
+	if (!dq->q_rtb.softlimit)
 		dq->q_rtb.softlimit = defq->rtb.soft;
-	if (defq->rtb.hard && !dq->q_rtb.hardlimit)
+	if (!dq->q_rtb.hardlimit)
 		dq->q_rtb.hardlimit = defq->rtb.hard;
 
 	if (prealloc)

