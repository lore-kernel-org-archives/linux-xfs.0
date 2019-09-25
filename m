Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0379FC432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4ECC21D81
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xmmhqtfb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbfIYVek (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:34:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43270 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727384AbfIYVek (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:34:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYTNO010156;
        Wed, 25 Sep 2019 21:34:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=SVp2PN3caCKe/5J96Iib/pQh49racb5ktOp253xv5oE=;
 b=Xmmhqtfb9GMNY71WwAeLXWlZM2DWJ50AKyeMzl6daWJEWL2pFUIKO2cq+2/pkPIUiIPi
 cq1SQs3IkRUKiMuuiCQwnZrS7vuP1qKbINk6R2Po6ZJ0cd6kuBiwIuf5H6Y0GZsxZnKP
 jHNnE1JKRZ+BuDgyJS5qyOQqZSlUh0OKOtvwZ3doZdNgNaB3urUiA5+mynKgQRSVqno9
 04i567bTlxVv78n0qibQgthfKXoLCHA5sTjeDGwDiUHWMIxoDEgymEnGtVK4lBAC2WJm
 qPfjpc7tI0J34RatW0P9b7AAmE5myZqIAgY/ImALXibf26NF1w1lSeBrBLd4bU/kUc/g yQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v5btq7hm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYRl0011426;
        Wed, 25 Sep 2019 21:34:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2v829w4wrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:27 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLXFah019400;
        Wed, 25 Sep 2019 21:33:15 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:33:15 -0700
Subject: [PATCH 3/4] xfs_scrub: convert to per-ag inode bulkstat operations
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Date:   Wed, 25 Sep 2019 14:33:14 -0700
Message-ID: <156944719446.297551.14261594420118373010.stgit@magnolia>
In-Reply-To: <156944717403.297551.9871784842549394192.stgit@magnolia>
References: <156944717403.297551.9871784842549394192.stgit@magnolia>
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

Now that we're done reworking the xfrog bulkstat wrapper functions, we
can adapt xfs_scrub to use the per-ag iteration functionality.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 scrub/fscounters.c |   22 ++++++----------------
 scrub/inodes.c     |   20 ++++++--------------
 2 files changed, 12 insertions(+), 30 deletions(-)


diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index 2fdf658a..a2cf8171 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -35,29 +35,25 @@ struct xfs_count_inodes {
  * exist in the filesystem, assuming we've already scrubbed that.
  */
 static bool
-xfs_count_inodes_range(
+xfs_count_inodes_ag(
 	struct scrub_ctx	*ctx,
 	const char		*descr,
-	uint64_t		first_ino,
-	uint64_t		last_ino,
+	uint32_t		agno,
 	uint64_t		*count)
 {
 	struct xfs_inumbers_req	*ireq;
 	uint64_t		nr = 0;
 	int			error;
 
-	ASSERT(!(first_ino & (XFS_INODES_PER_CHUNK - 1)));
-	ASSERT((last_ino & (XFS_INODES_PER_CHUNK - 1)));
-
-	ireq = xfrog_inumbers_alloc_req(1, first_ino);
+	ireq = xfrog_inumbers_alloc_req(1, 0);
 	if (!ireq) {
 		str_info(ctx, descr, _("Insufficient memory; giving up."));
 		return false;
 	}
+	xfrog_inumbers_set_ag(ireq, agno);
 
 	while (!(error = xfrog_inumbers(&ctx->mnt, ireq))) {
-		if (ireq->hdr.ocount == 0 ||
-		    ireq->inumbers[0].xi_startino >= last_ino)
+		if (ireq->hdr.ocount == 0)
 			break;
 		nr += ireq->inumbers[0].xi_alloccount;
 	}
@@ -83,8 +79,6 @@ xfs_count_ag_inodes(
 	struct xfs_count_inodes	*ci = arg;
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	char			descr[DESCR_BUFSZ];
-	uint64_t		ag_ino;
-	uint64_t		next_ag_ino;
 	bool			moveon;
 
 	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u inodes"),
@@ -92,11 +86,7 @@ xfs_count_ag_inodes(
 				minor(ctx->fsinfo.fs_datadev),
 				agno);
 
-	ag_ino = cvt_agino_to_ino(&ctx->mnt, agno, 0);
-	next_ag_ino = cvt_agino_to_ino(&ctx->mnt, agno + 1, 0);
-
-	moveon = xfs_count_inodes_range(ctx, descr, ag_ino, next_ag_ino - 1,
-			&ci->counters[agno]);
+	moveon = xfs_count_inodes_ag(ctx, descr, agno, &ci->counters[agno]);
 	if (!moveon)
 		ci->moveon = false;
 }
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 964647ce..4cf8a120 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -82,12 +82,11 @@ xfs_iterate_inodes_range_check(
  * but we also can detect iget failures.
  */
 static bool
-xfs_iterate_inodes_range(
+xfs_iterate_inodes_ag(
 	struct scrub_ctx	*ctx,
 	const char		*descr,
 	void			*fshandle,
-	uint64_t		first_ino,
-	uint64_t		last_ino,
+	uint32_t		agno,
 	xfs_inode_iter_fn	fn,
 	void			*arg)
 {
@@ -113,13 +112,14 @@ xfs_iterate_inodes_range(
 		return false;
 	}
 
-	ireq = xfrog_inumbers_alloc_req(1, first_ino);
+	ireq = xfrog_inumbers_alloc_req(1, 0);
 	if (!ireq) {
 		str_info(ctx, descr, _("Insufficient memory; giving up."));
 		free(breq);
 		return false;
 	}
 	inumbers = &ireq->inumbers[0];
+	xfrog_inumbers_set_ag(ireq, agno);
 
 	/* Find the inode chunk & alloc mask */
 	error = xfrog_inumbers(&ctx->mnt, ireq);
@@ -147,9 +147,6 @@ xfs_iterate_inodes_range(
 		for (i = 0, bs = breq->bulkstat;
 		     i < inumbers->xi_alloccount;
 		     i++, bs++) {
-			if (bs->bs_ino > last_ino)
-				goto out;
-
 			handle.ha_fid.fid_ino = bs->bs_ino;
 			handle.ha_fid.fid_gen = bs->bs_gen;
 			error = fn(ctx, &handle, bs, arg);
@@ -214,8 +211,6 @@ xfs_scan_ag_inodes(
 	struct xfs_scan_inodes	*si = arg;
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	char			descr[DESCR_BUFSZ];
-	uint64_t		ag_ino;
-	uint64_t		next_ag_ino;
 	bool			moveon;
 
 	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u inodes"),
@@ -223,11 +218,8 @@ xfs_scan_ag_inodes(
 				minor(ctx->fsinfo.fs_datadev),
 				agno);
 
-	ag_ino = cvt_agino_to_ino(&ctx->mnt, agno, 0);
-	next_ag_ino = cvt_agino_to_ino(&ctx->mnt, agno + 1, 0);
-
-	moveon = xfs_iterate_inodes_range(ctx, descr, ctx->fshandle, ag_ino,
-			next_ag_ino - 1, si->fn, si->arg);
+	moveon = xfs_iterate_inodes_ag(ctx, descr, ctx->fshandle, agno,
+			si->fn, si->arg);
 	if (!moveon)
 		si->moveon = false;
 }

