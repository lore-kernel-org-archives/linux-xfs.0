Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6765BC433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4346A20674
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:55:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FYPiKvXX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgGOBzR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 21:55:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46612 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727837AbgGOBzR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 21:55:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1mwiS076377;
        Wed, 15 Jul 2020 01:55:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=aF+V7i5aq4iL21ASx/b3+fdzDQqtc+CMULBwTKkWoGw=;
 b=FYPiKvXX4NITfNBOUVHJJubwG/29cpyinUyP+X0Yb6g5n2m4Vm5TY4Nofsn1bdYaXuOi
 4lpNzVeU/u9dEfKHRpUoLr0tcRM63EyGLPlQezN6oQ3ETrElSyqsIQK9/Y4UkBbswlnz
 XS4sXf4DwhZLOsKotTCkediqhmVPrx0BgQ4WXmYwhPqNuits+CQVAI1EZxJ+47nJW0cX
 v+kTJMh00g8D18ZRXvxVshw0P4mKstdB1rTfTPL+MoXQP0AUrIOms/UexdIQdCNLjTuf
 0Ap/niOc7+pOUO1S7xoyKMpAbkg30dKgxfacskl6ANJxbZP03+WJP+cx2fKbOO/QiRf+ aw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3274ur8q8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 01:55:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1la6V184491;
        Wed, 15 Jul 2020 01:53:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 327qb5wucf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 01:53:13 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06F1rDrJ019121;
        Wed, 15 Jul 2020 01:53:13 GMT
Received: from localhost (/10.159.237.234)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 18:53:12 -0700
Subject: [PATCH 24/26] xfs: assume the default quota limits are always set in
 xfs_qm_adjust_dqlimits
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 18:53:11 -0700
Message-ID: <159477799136.3263162.16638446868281519003.stgit@magnolia>
In-Reply-To: <159477783164.3263162.2564345443708779029.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=919 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=1 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=925 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150013
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We always initialize the default quota limits to something nowadays, so
we don't need to check that the defaults are set to something before
using them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index e44f80700005..2b52913073b3 100644
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

