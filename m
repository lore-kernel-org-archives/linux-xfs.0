Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4085DC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:39:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39046206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:39:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EuX+eB4R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392155AbfIFDjt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:39:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52888 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbfIFDjt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:39:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863dU4Y113288;
        Fri, 6 Sep 2019 03:39:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=wzEqYcM9uFZaX8olf5yaSwN0FKy3KOJJZG54g/+fHfA=;
 b=EuX+eB4Rh0Aa1vCo/F/SAQnkYKzh78aElZBPUXdTR04Mplo01ulC3pdWqKPeL2GBD9gY
 Unh0YGOnHHSnKeIGYz/qPs4Ka3+3csiBaABg7hYB+xgtyCoHrfstnx6W4hwmJOqjPwJ5
 bM63dTc/FwoH6/dtDxo2N/yK6s1QwiL287jzUpui5AmSvxQUuSbk1fDnSWYFkJDDyHAq
 6jfkPDc0WLaDoQcwvTtDbTbFP0VYEfFKuzgx1DZUStBLz/1aF0XxuLFnUFPecNHsA8Su
 SRms/czsh3Hx4cnAWitLCqzu5RvF0ZILY2svdqQdzyW58to40ma8TCl9tcUx3lb4vk1A qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2uufr08015-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:39:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863dHmY112817;
        Fri, 6 Sep 2019 03:39:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2uud7p2sw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:39:46 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863djVO022611;
        Fri, 6 Sep 2019 03:39:45 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:39:45 -0700
Subject: [PATCH 08/11] xfs_scrub: fix media verification thread pool size
 calculations
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:39:45 -0700
Message-ID: <156774118527.2645432.8208786952640433174.stgit@magnolia>
In-Reply-To: <156774113533.2645432.14942831726168941966.stgit@magnolia>
References: <156774113533.2645432.14942831726168941966.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060040
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The read verifier pool deals with two different thread counts -- there's
the submitter thread count that enables us to perform per-thread verify
request aggregation, and then there's the io thread pool count which is
the maximum number of IO requests we want to send to the disk at any
given time.

The io thread pool count should be derived from disk_heads() but instead
we bungle it by measuring and modifying(!) the nproc global variable.
Fix the derivation to use global variables correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/read_verify.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)


diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 3dac10ce..834571a7 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -75,6 +75,7 @@ read_verify_pool_alloc(
 	struct read_verify_pool		**prvp)
 {
 	struct read_verify_pool		*rvp;
+	unsigned int			verifier_threads = disk_heads(disk);
 	int				ret;
 
 	/*
@@ -94,7 +95,7 @@ read_verify_pool_alloc(
 			RVP_IO_MAX_SIZE);
 	if (ret)
 		goto out_free;
-	ret = ptcounter_alloc(nproc, &rvp->verified_bytes);
+	ret = ptcounter_alloc(verifier_threads, &rvp->verified_bytes);
 	if (ret)
 		goto out_buf;
 	rvp->miniosz = miniosz;
@@ -106,11 +107,8 @@ read_verify_pool_alloc(
 			&rvp->rvstate);
 	if (ret)
 		goto out_counter;
-	/* Run in the main thread if we only want one thread. */
-	if (nproc == 1)
-		nproc = 0;
 	ret = workqueue_create(&rvp->wq, (struct xfs_mount *)rvp,
-			disk_heads(disk));
+			verifier_threads == 1 ? 0 : verifier_threads);
 	if (ret)
 		goto out_rvstate;
 	*prvp = rvp;

