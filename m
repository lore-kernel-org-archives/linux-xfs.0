Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27267CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA21C20B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:48:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sLNbLj9f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732251AbfJVSsx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:48:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51294 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729696AbfJVSsx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:48:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiCmn091007;
        Tue, 22 Oct 2019 18:48:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Bs/R2ke44/I4culw/z6JXYPnUD/HbcD06JTORMYoydA=;
 b=sLNbLj9fjfYXkgckn7zWzNqNL8M+UHjU+74dsPgFeXvF1tJU9M9mjTJhHemK791M9wuF
 TPJaU2QUarZwIrVAXbQg+yvWvEscQyygL1+DCmIHaX3tbm48edEEDYdhwCAK5BSyGPln
 34ARodyCpSoXhnocjBHECxc+U5qgkkYQFxDU2SyJ0TeGt7UPoONeEE90utjQ6LJ8FG+4
 WkeZxM8wNsdmuNNkbCI5b59oJaz1FtMVfXBvuuiibOTtj1m9S4VCM2rWW6isoewr0dsc
 JB253q/9qZCmqSvnrbzOI49qRwqncqp99+4amK49VB8rMBmRM6G+EnDnuIJUNKWcJS8S 9g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vqteprr7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:48:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhOBG125229;
        Tue, 22 Oct 2019 18:48:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vsx239rex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:48:49 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MImmlL026312;
        Tue, 22 Oct 2019 18:48:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:48:47 -0700
Subject: [PATCH 2/2] xfs_scrub: refactor xfs_iterate_inodes_range_check
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:48:47 -0700
Message-ID: <157177012698.1460310.12927607736966109750.stgit@magnolia>
In-Reply-To: <157177011420.1460310.11140985141007340173.stgit@magnolia>
References: <157177011420.1460310.11140985141007340173.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move all the bulkstat action into a single helper function.  This gets
rid of the awkward name and increases cohesion.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/inodes.c |   40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 7aa61ebe..7c04d7f6 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -43,19 +43,37 @@
  */
 
 /*
- * Did we get exactly the inodes we expected?  If not, load them one at a
- * time (or fake it) into the bulkstat data.
+ * Run bulkstat on an entire inode allocation group, then check that we got
+ * exactly the inodes we expected.  If not, load them one at a time (or fake
+ * it) into the bulkstat data.
  */
 static void
-xfs_iterate_inodes_range_check(
+bulkstat_for_inumbers(
 	struct scrub_ctx	*ctx,
-	struct xfs_inumbers	*inumbers,
-	struct xfs_bulkstat	*bstat)
+	const char		*descr,
+	const struct xfs_inumbers *inumbers,
+	struct xfs_bulkstat_req	*breq)
 {
+	struct xfs_bulkstat	*bstat = breq->bulkstat;
 	struct xfs_bulkstat	*bs;
 	int			i;
 	int			error;
 
+	/* First we try regular bulkstat, for speed. */
+	breq->hdr.ino = inumbers->xi_startino;
+	breq->hdr.icount = inumbers->xi_alloccount;
+	error = xfrog_bulkstat(&ctx->mnt, breq);
+	if (error) {
+		char	errbuf[DESCR_BUFSZ];
+
+		str_info(ctx, descr, "%s",
+			 strerror_r(error, errbuf, DESCR_BUFSZ));
+	}
+
+	/*
+	 * Check each of the stats we got back to make sure we got the inodes
+	 * we asked for.
+	 */
 	for (i = 0, bs = bstat; i < XFS_INODES_PER_CHUNK; i++) {
 		if (!(inumbers->xi_allocmask & (1ULL << i)))
 			continue;
@@ -131,17 +149,7 @@ xfs_iterate_inodes_ag(
 		if (inumbers->xi_alloccount == 0)
 			goto igrp_retry;
 
-		breq->hdr.ino = inumbers->xi_startino;
-		breq->hdr.icount = inumbers->xi_alloccount;
-		error = xfrog_bulkstat(&ctx->mnt, breq);
-		if (error) {
-			char	errbuf[DESCR_BUFSZ];
-
-			str_info(ctx, descr, "%s", strerror_r(error,
-						errbuf, DESCR_BUFSZ));
-		}
-
-		xfs_iterate_inodes_range_check(ctx, inumbers, breq->bulkstat);
+		bulkstat_for_inumbers(ctx, descr, inumbers, breq);
 
 		/* Iterate all the inodes. */
 		for (i = 0, bs = breq->bulkstat;

