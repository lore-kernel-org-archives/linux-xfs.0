Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A42E8C433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81551217BA
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:36:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tLMOSOzB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgGNBgG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:36:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40516 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgGNBgF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 21:36:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1W1IX096060
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:36:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=FIQD0z0czXWIg8OL2RsW+VxK0TAQma0FGDPfGjpHjSw=;
 b=tLMOSOzBzsmhXcMe0KlK+eICozscFEW4hnbkG0c+KvuNSBDqT/tDDiY4zTfLVSrt1Ejs
 ukhTguoMv1SiylPB8V4nquYJw3JRZ1/0GYkFHD8h2n/XRkiSa6Iv6uIUZH7FAzZIvzoc
 pDf+xAQ300SrnjtU8u155PcpL++rKljI8ztJvf4kGYApM1qiOwa1s4JKeBXDTkX0fdEh
 2t/zXIsdKvIaQYZ7LI464LvopUclBT8OBgyGf2ZWJrpZBt3CnQrlUaSqbkUKWyVSAe1A
 dzDFCUnGu1uuK7PsCynqq3vyKfJ7FTFFprqX3zZCaI8f36fEt8qkte4ajghpRcNqGCiD Lg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3274ur2f7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:36:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1XYjV175681
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:34:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 327q0n6mkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:34:03 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06E1Y2YW012307
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:34:03 GMT
Received: from localhost (/10.159.128.100)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 18:34:02 -0700
Subject: [PATCH 24/26] xfs: assume the default quota limits are always set in
 xfs_qm_adjust_dqlimits
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 13 Jul 2020 18:34:02 -0700
Message-ID: <159469044233.2914673.9887253692124252095.stgit@magnolia>
In-Reply-To: <159469028734.2914673.17856142063205791176.stgit@magnolia>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=861 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=867 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140009
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
index aeefe82e0e5e..40b260361499 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -77,21 +77,21 @@ xfs_qm_adjust_dqlimits(
 	ASSERT(dq->q_id);
 	defq = xfs_get_defquota(q, dq->q_type);
 
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

