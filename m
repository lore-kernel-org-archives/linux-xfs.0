Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00032C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C47FD20872
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:37:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gP9Fvdm+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbfIYVhB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:37:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:32988 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbfIYVhB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:37:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYc3h055018;
        Wed, 25 Sep 2019 21:36:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=wzEqYcM9uFZaX8olf5yaSwN0FKy3KOJJZG54g/+fHfA=;
 b=gP9Fvdm+nCQx8anOcKK5QwmlkFBbetsavBotV9tLMj9yauWrKzT7ylkntsn+I591G33n
 HKdLe5psuIROmkHWaknnUHZDVNm061lSs9sY49OXHh+zaBYo7c1GNCBzCp4knkUiWdpt
 ehkcBS8wnNlkcrd9HIJkE1RQkXPhYD3wBrClmQLbPBoWy2EsheE+WQQ3CuIvfK9p/c6d
 /fEdoIqV9+qQC12N9DfXqLDawVLGiGosINXPq2d89GxIv3Xiz36J0ByVLxkmX+j5wAtI
 SeH4WHgbShiXQ0WREpeYPH+uNtEwAszVgMY4ghzqxGqlj75mNLtLWeddNEHdlRS3qYuG pA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2v5cgr7f4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:36:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYRsr011398;
        Wed, 25 Sep 2019 21:36:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2v829w52nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:36:58 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLavnT016460;
        Wed, 25 Sep 2019 21:36:57 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:36:57 -0700
Subject: [PATCH 08/11] xfs_scrub: fix media verification thread pool size
 calculations
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:36:56 -0700
Message-ID: <156944741622.300131.15141442959494340981.stgit@magnolia>
In-Reply-To: <156944736739.300131.5717633994765951730.stgit@magnolia>
References: <156944736739.300131.5717633994765951730.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
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

