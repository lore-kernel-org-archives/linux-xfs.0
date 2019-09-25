Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BD3C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 991BB21D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:35:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HXgwmTMT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfIYVfB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:35:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37806 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfIYVfB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:35:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYNGZ057955;
        Wed, 25 Sep 2019 21:34:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=/CQvP8cCXPALyR4gyixySjSg2/xGE8gDzfxcSCmlA28=;
 b=HXgwmTMT1B8UTHzI6mtY7bdNqmCjPey4Aw6Io3qjYmO4HyT/BM+sNPDF9EX58OAS2VRh
 Nrb+kPr853tj6IIElywM1UmNywkmVWoR3tBurQkm/5dWCg8M48TFl0Qq/3LOax0ptiws
 ykQ5Li7F2f1SqAkCGJGQCJjstzeSSYJGxJWcCY+ZIEbnyHc5GeklTf/d+wIKnh81b5tp
 NboVBEC9jvSvfdniDmHqBR1KuHzjiyzyZA3RpeURA3XUs0jxCxV0ndg9dTT29LFWRbpE
 uK5sYg7n+ql1IMgwVhYa7hPVwgADyQauTCAPmSQ6Qcvx6JCYTW9JxMPrLe9luhQk7MYd 3A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v5b9tyh2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYOtR023704;
        Wed, 25 Sep 2019 21:34:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2v7vnyup90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:57 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLYu5T014585;
        Wed, 25 Sep 2019 21:34:56 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:34:56 -0700
Subject: [PATCH 01/11] xfs_scrub: fix handling of read-verify pool runtime
 errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:34:54 -0700
Message-ID: <156944729476.298887.15638727982082805193.stgit@magnolia>
In-Reply-To: <156944728875.298887.8311229116097714980.stgit@magnolia>
References: <156944728875.298887.8311229116097714980.stgit@magnolia>
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
index b890c92f..00627307 100644
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

