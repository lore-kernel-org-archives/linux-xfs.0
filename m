Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53823C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 507BD206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:39:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cY2L5HBe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404426AbfIFDjX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:39:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38372 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732014AbfIFDjX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:39:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863dAUb108568;
        Fri, 6 Sep 2019 03:39:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=LdmAp4vvHI/BKFIy2XI79DB9cFAsXq+OkI7afpctqVg=;
 b=cY2L5HBeXnFRPK3O0v7PKIXjDNPpqeVMSTQ6yoZw8zGshaAa7moL7PxK0AOyGR6Vxejw
 qlRxR9p705zzKk1F07rBd+qRr03mny19f//iDqnbmnEgFt8F4RRzVEFuAUMFQnrzn9Qh
 5OrInnqezkFHUAKEoPV/fBJ8rQ2erX6raGgAVd2VPNLU9mARSojhdtIW1UVL7T/Z4/s/
 lGlN90iY0ekdE2RNbMc+uW05Fv3q1Z1GxMRbz2hi3Sarv8Dkf2+bq+kf7ZX8uwUHUuBg
 NPZoTmzaN+toinf1HlALL3dl8YnhIUoa79sq1LsWpPWhqDqQsh5L2XcdpCu82WJa39W3 jQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uuf5f839u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:39:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863dHKK112785;
        Fri, 6 Sep 2019 03:39:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2uud7p2s5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:39:18 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863c7Yp005509;
        Fri, 6 Sep 2019 03:38:07 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:38:07 -0700
Subject: [PATCH 04/11] xfs_scrub: fix queue-and-stash of non-contiguous
 verify requests
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:38:05 -0700
Message-ID: <156774108546.2645135.14576287125742125024.stgit@magnolia>
In-Reply-To: <156774106064.2645135.2756383874064764589.stgit@magnolia>
References: <156774106064.2645135.2756383874064764589.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060040
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

