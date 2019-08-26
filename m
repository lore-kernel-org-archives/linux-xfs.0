Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88CDBC3A5A4
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CB6422CED
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:32:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bYkDOkkI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbfHZVcD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:32:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35734 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728755AbfHZVcC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:32:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDl54000839;
        Mon, 26 Aug 2019 21:32:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=uENuGiK6yIjN6IgoAFydLMlWOLWxGhb8Tz6PhDekyrM=;
 b=bYkDOkkIWnpKmMF2SpTFzjKMQXHUxox/9vLI93vn2458HTbe3E8vda2cSVBIGJzfJiCP
 speRKmiPVL0RzLrUkAjNaGGMBitI4m6gblSk9lIv/Wbj6+VfbN5k75X8xyz6Iz8Oy2EQ
 5UtQNLEKUuCj/G0vqyhQMmvxhrQejmuRuPCBzC6Aqo6pSHVQTZsUH7xslzKFu3YzQxra
 lH5zLjagnF7K7YuHGqPRb1l99XXDHzcJUTLolkdLkbRUaTLddi5OeEIdrNVNZHEPn9tV
 LRMboyfcHBkOg3cdV563D/Uxo2a73Bj+1S9kpPdedWqbCULpBd1TuMMlCmhEpLVuUc+p rA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2umpxx05pb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:32:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLItsJ185068;
        Mon, 26 Aug 2019 21:32:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2umj2xw06u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:32:00 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLVxli009126;
        Mon, 26 Aug 2019 21:31:59 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:31:59 -0700
Subject: [PATCH 08/11] xfs_scrub: fix media verification thread pool size
 calculations
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:31:58 -0700
Message-ID: <156685511873.2843133.18068987858962966160.stgit@magnolia>
In-Reply-To: <156685506615.2843133.16536353613627426823.stgit@magnolia>
References: <156685506615.2843133.16536353613627426823.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
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
index bab8411a..c8e0f562 100644
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

