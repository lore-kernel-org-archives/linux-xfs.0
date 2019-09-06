Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F79C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:37:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C04DA206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:37:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jWeV0qso"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392143AbfIFDhv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:37:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43770 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732799AbfIFDhv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:37:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YZUZ074752;
        Fri, 6 Sep 2019 03:37:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=/CQvP8cCXPALyR4gyixySjSg2/xGE8gDzfxcSCmlA28=;
 b=jWeV0qsodXUHIit6k1g7OJwzf8ZkG7CrupoRJbxVUzYKN7f4EoYEEdVHfclHmy58hNDp
 B+vfXfRLtpvFmqsHljwAai3eXRT03qs3jY9ru4M0xV1tVZ/Ytv9gtqKIztNlCe8JYPtm
 Y0w3aQu8AdOI2JytlIs9emGpgowrSqzsYRS946lOp0DDBr1SFlxH5XamW/klLVKm/3yb
 jtoOy8efWJZyx7yU4EbuU++7cnf2otm3tccHmofW/0FdFDe+pP44zgPugWDlYxZ3i5/7
 e/0aEEZ0BQkdEljoYgiudPoAL3GaD9Z7jluluO8ZE3oioqFz53D6DTC0pmMYl6Mm87X8 9g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2uuf51g393-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:37:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863XT2i188642;
        Fri, 6 Sep 2019 03:37:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2utpmc764m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:37:48 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863blaF005296;
        Fri, 6 Sep 2019 03:37:47 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:37:47 -0700
Subject: [PATCH 01/11] xfs_scrub: fix handling of read-verify pool runtime
 errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:37:46 -0700
Message-ID: <156774106682.2645135.16924307846920048736.stgit@magnolia>
In-Reply-To: <156774106064.2645135.2756383874064764589.stgit@magnolia>
References: <156774106064.2645135.2756383874064764589.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
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

