Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D5BC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:30:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2960A21872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:30:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MamS7JeL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbfHZVaC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:30:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33536 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728649AbfHZVaC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:30:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDmsf000886;
        Mon, 26 Aug 2019 21:30:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ZyAsPqSRv2iqxiL5+3N3+IWCjON64tVFNYNj2JNfG1E=;
 b=MamS7JeLF7PF2T6dL4igU+Qlce3TEcMD+S4CDU9oXIGwoXU1yLFqFkKsHPuPSOzpUi4Y
 HS3Mlxt9BjaecJC7WlOMN7GeyJXK8vmGPrS6pBgEEL8qSo9cNkvYLHWxQWe2uRStW2KF
 LvxT979ZPljfOh5xoPqx5kvp2MnIrVD9eC3KlXY+T14EmDcQzlQIyA0/U0DLoPhJeFz1
 AKwYQ5SIm4Iq3FVj5vZVQswW2WbAUDjsRQCvWowjVSHutk4jtgGipngnRfm8jHdrVAJ0
 7iuY/IJX+4YwyixC6MtnxvR9ZMplktvL2hM/bUkQXoZlSIF8W8ui/avQe3iTWRWbVPaV fw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2umpxx05df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:30:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIRPT024992;
        Mon, 26 Aug 2019 21:29:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2umj1tk6ru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:29:59 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLTw5A006492;
        Mon, 26 Aug 2019 21:29:58 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:29:58 -0700
Subject: [PATCH 01/11] xfs_scrub: fix handling of read-verify pool runtime
 errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:29:57 -0700
Message-ID: <156685499722.2841898.17281881491093468208.stgit@magnolia>
In-Reply-To: <156685499099.2841898.18430382226915450537.stgit@magnolia>
References: <156685499099.2841898.18430382226915450537.stgit@magnolia>
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

Fix some bogosity with how we handle runtime errors in the read verify
pool functions.  First of all, memory allocation failures shouldn't be
recorded as disk IO errors, they should just complain and abort the
phase.  Second, we need to collect any other runtime errors in the IO
thread and abort the phase instead of silently ignoring them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/read_verify.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)


diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 425342b4..573bc4e0 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -53,6 +53,7 @@ struct read_verify_pool {
 	struct disk		*disk;		/* which disk? */
 	read_verify_ioerr_fn_t	ioerr_fn;	/* io error callback */
 	size_t			miniosz;	/* minimum io size, bytes */
+	int			errors_seen;
 };
 
 /*
@@ -91,6 +92,7 @@ read_verify_pool_init(
 	rvp->ctx = ctx;
 	rvp->disk = disk;
 	rvp->ioerr_fn = ioerr_fn;
+	rvp->errors_seen = false;
 	error = ptvar_alloc(submitter_threads, sizeof(struct read_verify),
 			&rvp->rvstate);
 	if (error)
@@ -149,6 +151,7 @@ read_verify(
 	unsigned long long		verified = 0;
 	ssize_t				sz;
 	ssize_t				len;
+	int				ret;
 
 	rvp = (struct read_verify_pool *)wq->wq_ctx;
 	while (rv->io_length > 0) {
@@ -173,7 +176,12 @@ read_verify(
 	}
 
 	free(rv);
-	ptcounter_add(rvp->verified_bytes, verified);
+	ret = ptcounter_add(rvp->verified_bytes, verified);
+	if (ret) {
+		str_liberror(rvp->ctx, ret,
+				_("updating bytes verified counter"));
+		rvp->errors_seen = true;
+	}
 }
 
 /* Queue a read verify request. */
@@ -188,18 +196,25 @@ read_verify_queue(
 	dbg_printf("verify fd %d start %"PRIu64" len %"PRIu64"\n",
 			rvp->disk->d_fd, rv->io_start, rv->io_length);
 
+	/* Worker thread saw a runtime error, don't queue more. */
+	if (rvp->errors_seen)
+		return false;
+
+	/* Otherwise clone the request and queue the copy. */
 	tmp = malloc(sizeof(struct read_verify));
 	if (!tmp) {
-		rvp->ioerr_fn(rvp->ctx, rvp->disk, rv->io_start,
-				rv->io_length, errno, rv->io_end_arg);
-		return true;
+		str_errno(rvp->ctx, _("allocating read-verify request"));
+		rvp->errors_seen = true;
+		return false;
 	}
+
 	memcpy(tmp, rv, sizeof(*tmp));
 
 	ret = workqueue_add(&rvp->wq, read_verify, 0, tmp);
 	if (ret) {
 		str_liberror(rvp->ctx, ret, _("queueing read-verify work"));
 		free(tmp);
+		rvp->errors_seen = true;
 		return false;
 	}
 	rv->io_length = 0;

