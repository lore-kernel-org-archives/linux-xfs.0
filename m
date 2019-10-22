Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 169B5CA9EB7
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAD63218AE
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:48:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZuMmPEHP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732784AbfJVSsM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:48:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48374 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729696AbfJVSsM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:48:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiBO6089151;
        Tue, 22 Oct 2019 18:48:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=MBNnabGKcxubYb6UrYfwqHXaBqreH6fYrbQSum7n+w0=;
 b=ZuMmPEHPOP3zCzA/3mLUmCUw9hNfyDSLmmDQw4ZtTcMuquMnW/eOOVtxeqSPnhDxb3nv
 54VKQqcYYitV0AdyFtmPRthcws3q9P/vMJM13RN5Jx1+9ECLRtuV3N/2kIIq88RVMsk1
 +tCIH3SSsUzzp1lYBIZKlhZLenF/UAvf70kAwKXyeZ86mBxUmFg0Je5Pzpx/UUHlT+xo
 z+cNQKSu1z0SiBG8yperqVY/ZpwttvWU6KKF9UM/ZMpMWd+0bAyOkzeTMbofRejjxeqN
 9vxXxJlevW3xUbNI672wMQcObgkYuzvdkLr/vNsvkmBVTDraJIz8lXAjrTjxCk7QOqde lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vqu4qrk35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:48:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhlLL148141;
        Tue, 22 Oct 2019 18:48:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2vsp400v4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:48:05 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MIm4PO029719;
        Tue, 22 Oct 2019 18:48:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:48:03 -0700
Subject: [PATCH 9/9] xfs_scrub: fix media verification thread pool size
 calculations
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Date:   Tue, 22 Oct 2019 11:48:02 -0700
Message-ID: <157177008290.1459098.12751612991033555541.stgit@magnolia>
In-Reply-To: <157177002473.1459098.11320398367215468164.stgit@magnolia>
References: <157177002473.1459098.11320398367215468164.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
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
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 scrub/read_verify.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)


diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index cba1b2d4..a963a3fd 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -80,6 +80,7 @@ read_verify_pool_alloc(
 	struct read_verify_pool		**prvp)
 {
 	struct read_verify_pool		*rvp;
+	unsigned int			verifier_threads = disk_heads(disk);
 	int				ret;
 
 	/*
@@ -99,7 +100,7 @@ read_verify_pool_alloc(
 			RVP_IO_MAX_SIZE);
 	if (ret)
 		goto out_free;
-	ret = ptcounter_alloc(nproc, &rvp->verified_bytes);
+	ret = ptcounter_alloc(verifier_threads, &rvp->verified_bytes);
 	if (ret)
 		goto out_buf;
 	rvp->miniosz = miniosz;
@@ -110,11 +111,8 @@ read_verify_pool_alloc(
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

