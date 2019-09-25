Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21EB1C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E792821D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:35:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S9IeDk0j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbfIYVf1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:35:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38202 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727683AbfIYVf1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:35:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYPx8057960;
        Wed, 25 Sep 2019 21:35:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=LdmAp4vvHI/BKFIy2XI79DB9cFAsXq+OkI7afpctqVg=;
 b=S9IeDk0j3LYSn3fcz4Zh5bZGEIMF96QIfOaqpL/xAm7/Nmjd5mQ6bhFMbUgVh7wrDx9X
 +ng2iIo/R3Vx1m8wA3jDtcAS/HHfCbCxfkmFxq7d+ozBT108a6WzZAvHLzae/kocew/1
 4X1fX1PQG58ZVBc1m45I6Mbi9ToRC1yPI8up8YiHFPs/fsreqp45CWl43BruIo4LA9q+
 /bXYrBPArxtMqq3aYOtluUg4uOq48+vH/kVUy/bHHwhVMNyExEYOOinF2C9eUEaIMK29
 qG9dzVWauYGMDnT5Hg7CGR+X4jVQn0F5/gJD+jEu4rHc/besCP1HsasUruR2fu+MU+n/ ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2v5b9tyh48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:35:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYUMx097902;
        Wed, 25 Sep 2019 21:35:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v82qakt7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:35:24 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLZNXS015371;
        Wed, 25 Sep 2019 21:35:23 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:35:23 -0700
Subject: [PATCH 04/11] xfs_scrub: fix queue-and-stash of non-contiguous
 verify requests
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:35:21 -0700
Message-ID: <156944732174.298887.12947727388057082476.stgit@magnolia>
In-Reply-To: <156944728875.298887.8311229116097714980.stgit@magnolia>
References: <156944728875.298887.8311229116097714980.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

read_verify_schedule_io is supposed to have the ability to decide that a
retained aggregate extent verification request is not sufficiently
contiguous with the request that is being scheduled, and therefore it
needs to queue the retained request and use the new request to start
building a new aggregate request.

Unfortunately, it stupidly returns after queueing the IO, so we lose the
incoming request.  Fix the code so we only do that if there's a run time
error.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/read_verify.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 8f80dcaf..980b92b8 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -265,8 +265,13 @@ read_verify_schedule_io(
 		rv->io_length = max(req_end, rv_end) - rv->io_start;
 	} else  {
 		/* Otherwise, issue the stashed IO (if there is one) */
-		if (rv->io_length > 0)
-			return read_verify_queue(rvp, rv);
+		if (rv->io_length > 0) {
+			int	res;
+
+			res = read_verify_queue(rvp, rv);
+			if (res)
+				return res;
+		}
 
 		/* Stash the new IO. */
 		rv->io_start = start;

