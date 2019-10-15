Return-Path: <SRS0=TKSY=YI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E42C8ECE588
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 17:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8B4E20650
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 17:21:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kKyhYNQp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfJORVd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 13:21:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51246 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfJORVd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 13:21:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9FHIiup051008;
        Tue, 15 Oct 2019 17:21:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=OOCEQHgOj8lJMlQIqETEMupbshHfwsicNoRtTRTIAzQ=;
 b=kKyhYNQp9Kbd6AEt0l3Eqx/MrG3yVK1ohc8s2yB5qNuxzxEcweHu2jl7AGGPCgmXbqns
 KOV1RkSpM3fDXoInSVfGD2kKXa0B4/2kON2lw1BViJ2uVBrMZAzg37ETAEy0K3Seyv37
 paVrRa+RzDOxbUyLsUqdBUlV+7qb07efHDsFhU+uBs8NqS7tJIku+y52jHqeBxFUPoFJ
 /sqswaAFE2UOT2Ce9U+NYeyimPVhDRcb+UcTsIWlMxodvoWCYyc0PGSaL04rchUe0ocB
 oWjSNAylIcJp05JIrY2x1ws6WvFbJS4PXWZup+CutaXutxnjHoeXNA5bWyuK8ZY8blNC 3A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vk6sqhkej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 17:21:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9FHJ9vp030387;
        Tue, 15 Oct 2019 17:21:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vn718pxgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 17:21:29 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9FHLSlt011902;
        Tue, 15 Oct 2019 17:21:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Oct 2019 17:21:28 +0000
Date:   Tue, 15 Oct 2019 10:21:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 01/11] xfs_scrub: fix handling of read-verify pool runtime
 errors
Message-ID: <20191015172127.GI13108@magnolia>
References: <156944728875.298887.8311229116097714980.stgit@magnolia>
 <156944729476.298887.15638727982082805193.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156944729476.298887.15638727982082805193.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910150148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910150148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix some bogosity with how we handle runtime errors in the read verify
pool functions.  First of all, memory allocation failures shouldn't be
recorded as disk IO errors, they should just complain and abort the
phase.  Second, we need to collect any other runtime errors in the IO
thread and abort the phase instead of silently ignoring them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: fix errors_seen bogosity
---
 scrub/read_verify.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index b890c92f..d020ce2f 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -53,6 +53,12 @@ struct read_verify_pool {
 	struct disk		*disk;		/* which disk? */
 	read_verify_ioerr_fn_t	ioerr_fn;	/* io error callback */
 	size_t			miniosz;	/* minimum io size, bytes */
+
+	/*
+	 * Store a runtime error code here so that we can stop the pool and
+	 * return it to the caller.
+	 */
+	int			runtime_error;
 };
 
 /*
@@ -149,6 +155,7 @@ read_verify(
 	unsigned long long		verified = 0;
 	ssize_t				sz;
 	ssize_t				len;
+	int				ret;
 
 	rvp = (struct read_verify_pool *)wq->wq_ctx;
 	while (rv->io_length > 0) {
@@ -173,7 +180,12 @@ read_verify(
 	}
 
 	free(rv);
-	ptcounter_add(rvp->verified_bytes, verified);
+	ret = ptcounter_add(rvp->verified_bytes, verified);
+	if (ret) {
+		str_liberror(rvp->ctx, ret,
+				_("updating bytes verified counter"));
+		rvp->runtime_error = ret;
+	}
 }
 
 /* Queue a read verify request. */
@@ -188,18 +200,25 @@ read_verify_queue(
 	dbg_printf("verify fd %d start %"PRIu64" len %"PRIu64"\n",
 			rvp->disk->d_fd, rv->io_start, rv->io_length);
 
+	/* Worker thread saw a runtime error, don't queue more. */
+	if (rvp->runtime_error)
+		return false;
+
+	/* Otherwise clone the request and queue the copy. */
 	tmp = malloc(sizeof(struct read_verify));
 	if (!tmp) {
-		rvp->ioerr_fn(rvp->ctx, rvp->disk, rv->io_start,
-				rv->io_length, errno, rv->io_end_arg);
-		return true;
+		rvp->runtime_error = errno;
+		str_errno(rvp->ctx, _("allocating read-verify request"));
+		return false;
 	}
+
 	memcpy(tmp, rv, sizeof(*tmp));
 
 	ret = workqueue_add(&rvp->wq, read_verify, 0, tmp);
 	if (ret) {
 		str_liberror(rvp->ctx, ret, _("queueing read-verify work"));
 		free(tmp);
+		rvp->runtime_error = ret;
 		return false;
 	}
 	rv->io_length = 0;
