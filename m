Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41245C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BAE7206CD
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:42:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L+glWy64"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392168AbfIFDm2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:42:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41328 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbfIFDm2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:42:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863fsCZ110351;
        Fri, 6 Sep 2019 03:42:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=j2oUoY5uLEJX/VoDUMwKe7TBSvQ+xgA2X5ARKoXdRio=;
 b=L+glWy64cyF8t7nrz4S/bhInhharqrRcxQzOw3Hpw1nEjyUqKB/g8ZNx3OZTdCqddk6G
 pKSvrqCRP1xun8LtQ9/B+uLs4V96HuPFF6cw/r/DsRq7uX5gVhB+aO0X04Iz/hha9v+l
 SXKsNckiFzQ2cVfl+TzVDWNYXRJwQc24tWuR4qgEshcpCDrxmae6hFvs4c+9/SXVHxe0
 qvbHiAoxigwi5uvXvlpz/7JgQjJ+a40oGf2X67PnMBf1OFGREOagvsZddHDUbDiqaymL
 IZMVmk+eotp1UcUxCRuZ9nRjqzO/Ymfbue68SiPycKKtbPHEF915fxy3gwBhpcasXtJX Og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uufsar02y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:42:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863cTUf096009;
        Fri, 6 Sep 2019 03:42:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2uu1b99vba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:42:25 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863gOc1007557;
        Fri, 6 Sep 2019 03:42:24 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:42:24 -0700
Subject: [PATCH 14/18] xfs_scrub: remove moveon from phase 3 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:42:23 -0700
Message-ID: <156774134389.2646807.7574306592470108275.stgit@magnolia>
In-Reply-To: <156774125578.2646807.1183436616735969617.stgit@magnolia>
References: <156774125578.2646807.1183436616735969617.stgit@magnolia>
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

Replace the moveon returns in the phase 3 code with a direct integer
error return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase3.c |   73 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 48 insertions(+), 25 deletions(-)


diff --git a/scrub/phase3.c b/scrub/phase3.c
index a5f95004..354cc8ed 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -38,12 +38,12 @@ scrub_fd(
 
 struct scrub_inode_ctx {
 	struct ptcounter	*icount;
-	bool			moveon;
+	bool			aborted;
 };
 
 /* Report a filesystem error that the vfs fed us on close. */
 static void
-xfs_scrub_inode_vfs_error(
+report_close_error(
 	struct scrub_ctx	*ctx,
 	struct xfs_bulkstat	*bstat)
 {
@@ -58,7 +58,7 @@ xfs_scrub_inode_vfs_error(
 
 /* Verify the contents, xattrs, and extent maps of an inode. */
 static int
-xfs_scrub_inode(
+scrub_inode(
 	struct scrub_ctx	*ctx,
 	struct xfs_handle	*handle,
 	struct xfs_bulkstat	*bstat,
@@ -68,7 +68,6 @@ xfs_scrub_inode(
 	struct scrub_inode_ctx	*ictx = arg;
 	struct ptcounter	*icount = ictx->icount;
 	xfs_agnumber_t		agno;
-	bool			moveon = true;
 	int			fd = -1;
 	int			error;
 
@@ -136,61 +135,75 @@ xfs_scrub_inode(
 
 out:
 	if (error)
-		moveon = false;
+		ictx->aborted = true;
+
 	error = ptcounter_add(icount, 1);
 	if (error) {
 		str_liberror(ctx, error,
 				_("incrementing scanned inode counter"));
-		return false;
+		ictx->aborted = true;
 	}
 	progress_add(1);
 	action_list_defer(ctx, agno, &alist);
 	if (fd >= 0) {
-		error = close(fd);
-		if (error)
-			xfs_scrub_inode_vfs_error(ctx, bstat);
+		int	err2;
+
+		err2 = close(fd);
+		if (err2) {
+			report_close_error(ctx, bstat);
+			ictx->aborted = true;
+		}
 	}
-	if (!moveon)
-		ictx->moveon = false;
-	return ictx->moveon ? 0 : XFS_ITERATE_INODES_ABORT;
+
+	if (!error && ictx->aborted)
+		error = ECANCELED;
+	return error;
 }
 
 /* Verify all the inodes in a filesystem. */
-bool
-xfs_scan_inodes(
+int
+phase3_func(
 	struct scrub_ctx	*ctx)
 {
-	struct scrub_inode_ctx	ictx;
+	struct scrub_inode_ctx	ictx = { NULL };
 	uint64_t		val;
 	int			err;
 
-	ictx.moveon = true;
 	err = ptcounter_alloc(scrub_nproc(ctx), &ictx.icount);
 	if (err) {
 		str_liberror(ctx, err, _("creating scanned inode counter"));
-		return false;
+		return err;
 	}
 
-	err = scrub_scan_all_inodes(ctx, xfs_scrub_inode, &ictx);
+	err = scrub_scan_all_inodes(ctx, scrub_inode, &ictx);
+	if (!err && ictx.aborted)
+		err = ECANCELED;
 	if (err)
-		ictx.moveon = false;
-	if (!ictx.moveon)
 		goto free;
+
 	xfs_scrub_report_preen_triggers(ctx);
 	err = ptcounter_value(ictx.icount, &val);
 	if (err) {
 		str_liberror(ctx, err, _("summing scanned inode counter"));
-		return false;
+		return err;
 	}
+
 	ctx->inodes_checked = val;
 free:
 	ptcounter_free(ictx.icount);
-	return ictx.moveon;
+	return err;
 }
 
-/* Estimate how much work we're going to do. */
 bool
-xfs_estimate_inodes_work(
+xfs_scan_inodes(
+	struct scrub_ctx	*ctx)
+{
+	return phase3_func(ctx) == 0;
+}
+
+/* Estimate how much work we're going to do. */
+int
+phase3_estimate(
 	struct scrub_ctx	*ctx,
 	uint64_t		*items,
 	unsigned int		*nr_threads,
@@ -199,5 +212,15 @@ xfs_estimate_inodes_work(
 	*items = ctx->mnt_sv.f_files - ctx->mnt_sv.f_ffree;
 	*nr_threads = scrub_nproc(ctx);
 	*rshift = 0;
-	return true;
+	return 0;
+}
+
+bool
+xfs_estimate_inodes_work(
+	struct scrub_ctx	*ctx,
+	uint64_t		*items,
+	unsigned int		*nr_threads,
+	int			*rshift)
+{
+	return phase3_estimate(ctx, items, nr_threads, rshift) == 0;
 }

