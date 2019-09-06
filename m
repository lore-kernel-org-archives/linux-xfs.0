Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75FD7C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66E93206BB
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:41:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="doA4MWCJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392166AbfIFDlN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:41:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54568 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392165AbfIFDlN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:41:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863dbWs113331;
        Fri, 6 Sep 2019 03:41:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=nRnwG5U/yj0CH9oqmR92YrbN7u01zu31QvkgIhf904s=;
 b=doA4MWCJlniUG5pR9ME7KpILa1Iq/BPvmn1Xhje9yLwShSI1J6iKM3Ca0urjnveVcCE2
 rAll4m6cra5+pV1tNLdM4symXCX/knSAHfXz7kAGhm4qVyA45IriYLhKcIfOnQL+TaWC
 P8G7qubCqgKDOoJl3dreJCtFZfniBEOPsEfH862QTDwVOF41JfXV3grdZXzdjCCEjSQO
 EKE2TzOGcTxP8ZXsBF2wKzbYWQ3WvXryyqevrqMkjhz2XfqSPX/cfxbrC09U5Iq0c2Bz
 UlP8BvNSuic4l6zdf/zakvmm7mZX7i4reLxv4ev1gZAwGJ5sUqyAFTOJ/fBJMQJcpCr0 rQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2uufr08063-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:41:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863dHIt112753;
        Fri, 6 Sep 2019 03:41:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2uud7p2tr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:41:10 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863f9Gf017256;
        Fri, 6 Sep 2019 03:41:09 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:41:08 -0700
Subject: [PATCH 02/18] xfs_scrub: remove moveon from the fscounters functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:41:08 -0700
Message-ID: <156774126831.2646807.6005798813344089038.stgit@magnolia>
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

Replace the moveon returns in the fscounters functions with direct error
returns.  Drop the xfs_ prefixes while we're at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/fscounters.c |  129 ++++++++++++++++++++--------------------------------
 scrub/fscounters.h |    4 +-
 scrub/phase6.c     |   12 +++--
 scrub/phase7.c     |   15 ++++--
 4 files changed, 68 insertions(+), 92 deletions(-)


diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index 98aa3826..2581947f 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -25,8 +25,8 @@
 /* Count the number of inodes in the filesystem. */
 
 /* INUMBERS wrapper routines. */
-struct xfs_count_inodes {
-	bool			moveon;
+struct count_inodes {
+	int			error;
 	uint64_t		counters[0];
 };
 
@@ -34,13 +34,14 @@ struct xfs_count_inodes {
  * Count the number of inodes.  Use INUMBERS to figure out how many inodes
  * exist in the filesystem, assuming we've already scrubbed that.
  */
-static bool
-xfs_count_inodes_ag(
-	struct scrub_ctx	*ctx,
-	const char		*descr,
-	uint32_t		agno,
-	uint64_t		*count)
+static void
+count_ag_inodes(
+	struct workqueue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
 {
+	struct count_inodes	*ci = arg;
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	struct xfs_inumbers_req	*ireq;
 	uint64_t		nr = 0;
 	unsigned int		i;
@@ -48,107 +49,78 @@ xfs_count_inodes_ag(
 
 	ireq = xfrog_inumbers_alloc_req(64, 0);
 	if (!ireq) {
-		str_info(ctx, descr, _("Insufficient memory; giving up."));
-		return false;
+		ci->error = errno;
+		return;
 	}
 	xfrog_inumbers_set_ag(ireq, agno);
 
-	while (!(error = xfrog_inumbers(&ctx->mnt, ireq))) {
+	while (!ci->error && (error = xfrog_inumbers(&ctx->mnt, ireq)) == 0) {
 		if (ireq->hdr.ocount == 0)
 			break;
 		for (i = 0; i < ireq->hdr.ocount; i++)
 			nr += ireq->inumbers[i].xi_alloccount;
 	}
+	if (error)
+		ci->error = error;
 
 	free(ireq);
 
-	if (error) {
-		str_liberror(ctx, error, descr);
-		return false;
-	}
-
-	*count = nr;
-	return true;
-}
-
-/* Scan all the inodes in an AG. */
-static void
-xfs_count_ag_inodes(
-	struct workqueue	*wq,
-	xfs_agnumber_t		agno,
-	void			*arg)
-{
-	struct xfs_count_inodes	*ci = arg;
-	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
-	char			descr[DESCR_BUFSZ];
-	bool			moveon;
-
-	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u inodes"),
-				major(ctx->fsinfo.fs_datadev),
-				minor(ctx->fsinfo.fs_datadev),
-				agno);
-
-	moveon = xfs_count_inodes_ag(ctx, descr, agno, &ci->counters[agno]);
-	if (!moveon)
-		ci->moveon = false;
+	ci->counters[agno] = nr;
 }
 
-/* Count all the inodes in a filesystem. */
-bool
-xfs_count_all_inodes(
+/*
+ * Count all the inodes in a filesystem.  Returns 0 or a positive error number.
+ */
+int
+scrub_count_all_inodes(
 	struct scrub_ctx	*ctx,
 	uint64_t		*count)
 {
-	struct xfs_count_inodes	*ci;
+	struct count_inodes	*ci;
 	xfs_agnumber_t		agno;
 	struct workqueue	wq;
-	bool			moveon = true;
-	int			ret;
+	int			ret, ret2;
 
-	ci = calloc(1, sizeof(struct xfs_count_inodes) +
+	ci = calloc(1, sizeof(struct count_inodes) +
 			(ctx->mnt.fsgeom.agcount * sizeof(uint64_t)));
 	if (!ci)
-		return false;
-	ci->moveon = true;
+		return errno;
 
 	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
-	if (ret) {
-		moveon = false;
-		str_liberror(ctx, ret, _("creating icount workqueue"));
+	if (ret)
 		goto out_free;
-	}
-	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
-		ret = workqueue_add(&wq, xfs_count_ag_inodes, agno, ci);
-		if (ret) {
-			moveon = false;
-			str_liberror(ctx, ret, _("queueing icount work"));
+
+	for (agno = 0; agno < ctx->mnt.fsgeom.agcount && !ci->error; agno++) {
+		ret = workqueue_add(&wq, count_ag_inodes, agno, ci);
+		if (ret)
 			break;
-		}
 	}
 
-	ret = workqueue_terminate(&wq);
-	if (ret) {
-		moveon = false;
-		str_liberror(ctx, ret, _("finishing icount work"));
-	}
+	ret2 = workqueue_terminate(&wq);
+	if (!ret && ret2)
+		ret = ret2;
 	workqueue_destroy(&wq);
 
-	if (!moveon)
+	if (ci->error) {
+		ret = ci->error;
 		goto out_free;
+	}
 
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++)
 		*count += ci->counters[agno];
-	moveon = ci->moveon;
 
 out_free:
 	free(ci);
-	return moveon;
+	return ret;
 }
 
-/* Estimate the number of blocks and inodes in the filesystem. */
-bool
-xfs_scan_estimate_blocks(
+/*
+ * Estimate the number of blocks and inodes in the filesystem.  Returns 0
+ * or a positive error number.
+ */
+int
+scrub_scan_estimate_blocks(
 	struct scrub_ctx		*ctx,
 	unsigned long long		*d_blocks,
 	unsigned long long		*d_bfree,
@@ -164,17 +136,13 @@ xfs_scan_estimate_blocks(
 
 	/* Grab the fstatvfs counters, since it has to report accurately. */
 	error = fstatvfs(ctx->mnt.fd, &sfs);
-	if (error) {
-		str_errno(ctx, ctx->mntpoint);
-		return false;
-	}
+	if (error)
+		return errno;
 
 	/* Fetch the filesystem counters. */
 	error = ioctl(ctx->mnt.fd, XFS_IOC_FSCOUNTS, &fc);
-	if (error) {
-		str_errno(ctx, ctx->mntpoint);
-		return false;
-	}
+	if (error)
+		return errno;
 
 	/*
 	 * XFS reserves some blocks to prevent hard ENOSPC, so add those
@@ -182,7 +150,8 @@ xfs_scan_estimate_blocks(
 	 */
 	error = ioctl(ctx->mnt.fd, XFS_IOC_GET_RESBLKS, &rb);
 	if (error)
-		str_errno(ctx, ctx->mntpoint);
+		return errno;
+
 	sfs.f_bfree += rb.resblks_avail;
 
 	*d_blocks = sfs.f_blocks;
@@ -194,5 +163,5 @@ xfs_scan_estimate_blocks(
 	*f_files = sfs.f_files;
 	*f_free = sfs.f_ffree;
 
-	return true;
+	return 0;
 }
diff --git a/scrub/fscounters.h b/scrub/fscounters.h
index e3a79740..1fae58a6 100644
--- a/scrub/fscounters.h
+++ b/scrub/fscounters.h
@@ -6,10 +6,10 @@
 #ifndef XFS_SCRUB_FSCOUNTERS_H_
 #define XFS_SCRUB_FSCOUNTERS_H_
 
-bool xfs_scan_estimate_blocks(struct scrub_ctx *ctx,
+int scrub_scan_estimate_blocks(struct scrub_ctx *ctx,
 		unsigned long long *d_blocks, unsigned long long *d_bfree,
 		unsigned long long *r_blocks, unsigned long long *r_bfree,
 		unsigned long long *f_files, unsigned long long *f_free);
-bool xfs_count_all_inodes(struct scrub_ctx *ctx, uint64_t *count);
+int scrub_count_all_inodes(struct scrub_ctx *ctx, uint64_t *count);
 
 #endif /* XFS_SCRUB_FSCOUNTERS_H_ */
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 3c9eec09..7607001a 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -779,17 +779,19 @@ xfs_estimate_verify_work(
 	unsigned long long	r_bfree;
 	unsigned long long	f_files;
 	unsigned long long	f_free;
-	bool			moveon;
+	int			ret;
 
-	moveon = xfs_scan_estimate_blocks(ctx, &d_blocks, &d_bfree,
+	ret = scrub_scan_estimate_blocks(ctx, &d_blocks, &d_bfree,
 				&r_blocks, &r_bfree, &f_files, &f_free);
-	if (!moveon)
-		return moveon;
+	if (ret) {
+		str_liberror(ctx, ret, _("estimating verify work"));
+		return false;
+	}
 
 	*items = cvt_off_fsb_to_b(&ctx->mnt, d_blocks + r_blocks);
 	if (scrub_data == 1)
 		*items -= cvt_off_fsb_to_b(&ctx->mnt, d_bfree + r_bfree);
 	*nr_threads = disk_heads(ctx->datadev);
 	*rshift = 20;
-	return moveon;
+	return true;
 }
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 2622bc45..64e52359 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -156,14 +156,19 @@ xfs_scan_summary(
 	ptvar_free(ptvar);
 
 	/* Scan the whole fs. */
-	moveon = xfs_count_all_inodes(ctx, &counted_inodes);
-	if (!moveon)
+	error = scrub_count_all_inodes(ctx, &counted_inodes);
+	if (error) {
+		str_liberror(ctx, error, _("counting inodes"));
+		moveon = false;
 		goto out;
+	}
 
-	moveon = xfs_scan_estimate_blocks(ctx, &d_blocks, &d_bfree, &r_blocks,
+	error = scrub_scan_estimate_blocks(ctx, &d_blocks, &d_bfree, &r_blocks,
 			&r_bfree, &f_files, &f_free);
-	if (!moveon)
-		return moveon;
+	if (error) {
+		str_liberror(ctx, error, _("estimating verify work"));
+		return false;
+	}
 
 	/*
 	 * If we counted blocks with fsmap, then dblocks includes

