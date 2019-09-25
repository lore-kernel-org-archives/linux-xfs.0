Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7757AC4360C
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BF9B20872
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:39:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KgQ6LdGi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbfIYVj2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:39:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35528 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728660AbfIYVj2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:39:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdPq8058294;
        Wed, 25 Sep 2019 21:39:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=1qBUWv6MMDvjT/DGVt5EHaC7HLDLga5aSHXPw1nBbDs=;
 b=KgQ6LdGieb2bbIU0vMPuokzcDafKl810clH9GJIxIx+sFhC9kJkHTmm/0W5dpKYiwv7b
 W8CL7J2w7za6JQqFGBfkaFZw/g1lE4BKD8PDRdSpbuYs79cC+pCzeqNaxSs3Qre8fn/+
 jXsP4Re2vs82bFdN/TP2i5lbqh3jGH6LUYds3IyCYcj1S9a46Sh4qvd9qRRq9vLSsz34
 fuS/7UeOkCc7eOaNqL5i+EAwAGWAYgzzwkuBL1Sw3g2OuXSsyPqfc62mY3hp3NyMVrTK
 382fTXq1hEMITetXjtTJeKmfSGjTfPXp8/VC3h5eToW0B3RLU5yB2t/FM8GHX8DP8Eu8 mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2v5cgr7fd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdL7a088251;
        Wed, 25 Sep 2019 21:39:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2v82tkrngy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:22 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLcOL1022236;
        Wed, 25 Sep 2019 21:38:24 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:38:24 -0700
Subject: [PATCH 03/18] xfs_scrub: remove moveon from inode iteration
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:38:23 -0700
Message-ID: <156944750325.301514.14370939460252055431.stgit@magnolia>
In-Reply-To: <156944748487.301514.14685083474028866113.stgit@magnolia>
References: <156944748487.301514.14685083474028866113.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the moveon retuns in the inode iteration functions with a direct
integer error return.  While we're at it, drop the xfs_ prefix.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/inodes.c |  131 ++++++++++++++++++++++++--------------------------------
 scrub/inodes.h |    6 +--
 scrub/phase3.c |    7 +--
 scrub/phase5.c |   10 ++--
 scrub/phase6.c |    5 +-
 5 files changed, 70 insertions(+), 89 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index bfc0a1e9..9fb9d1a5 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -47,7 +47,7 @@
  * time (or fake it) into the bulkstat data.
  */
 static void
-xfs_iterate_inodes_range_check(
+fill_in_bulkstat_holes(
 	struct scrub_ctx	*ctx,
 	struct xfs_inumbers	*inumbers,
 	struct xfs_bulkstat	*bstat)
@@ -76,54 +76,66 @@ xfs_iterate_inodes_range_check(
 	}
 }
 
+/* BULKSTAT wrapper routines. */
+struct scan_inodes {
+	scrub_inode_iter_fn	fn;
+	void			*arg;
+	bool			aborted;
+};
+
 /*
  * Call into the filesystem for inode/bulkstat information and call our
  * iterator function.  We'll try to fill the bulkstat information in batches,
  * but we also can detect iget failures.
  */
-static bool
-xfs_iterate_inodes_ag(
-	struct scrub_ctx	*ctx,
-	const char		*descr,
-	void			*fshandle,
-	uint32_t		agno,
-	xfs_inode_iter_fn	fn,
+static void
+scan_ag_inodes(
+	struct workqueue	*wq,
+	xfs_agnumber_t		agno,
 	void			*arg)
 {
 	struct xfs_handle	handle;
+	char			descr[DESCR_BUFSZ];
 	struct xfs_inumbers_req	*ireq;
 	struct xfs_bulkstat_req	*breq;
-	char			idescr[DESCR_BUFSZ];
+	struct scan_inodes	*si = arg;
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	struct xfs_bulkstat	*bs;
 	struct xfs_inumbers	*inumbers;
-	bool			moveon = true;
 	int			i;
 	int			error;
 	int			stale_count = 0;
 
-	memcpy(&handle.ha_fsid, fshandle, sizeof(handle.ha_fsid));
+	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u inodes"),
+				major(ctx->fsinfo.fs_datadev),
+				minor(ctx->fsinfo.fs_datadev),
+				agno);
+
+	memcpy(&handle.ha_fsid, ctx->fshandle, sizeof(handle.ha_fsid));
 	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
 			sizeof(handle.ha_fid.fid_len);
 	handle.ha_fid.fid_pad = 0;
 
 	breq = xfrog_bulkstat_alloc_req(XFS_INODES_PER_CHUNK, 0);
 	if (!breq) {
-		str_info(ctx, descr, _("Insufficient memory; giving up."));
-		return false;
+		str_errno(ctx, descr);
+		si->aborted = true;
+		return;
 	}
 
 	ireq = xfrog_inumbers_alloc_req(1, 0);
 	if (!ireq) {
-		str_info(ctx, descr, _("Insufficient memory; giving up."));
+		str_errno(ctx, descr);
 		free(breq);
-		return false;
+		si->aborted = true;
+		return;
 	}
 	inumbers = &ireq->inumbers[0];
 	xfrog_inumbers_set_ag(ireq, agno);
 
 	/* Find the inode chunk & alloc mask */
 	error = xfrog_inumbers(&ctx->mnt, ireq);
-	while (!error && ireq->hdr.ocount > 0) {
+	while (!error && !si->aborted && ireq->hdr.ocount > 0) {
 		/*
 		 * We can have totally empty inode chunks on filesystems where
 		 * there are more than 64 inodes per block.  Skip these.
@@ -141,19 +153,21 @@ xfs_iterate_inodes_ag(
 						errbuf, DESCR_BUFSZ));
 		}
 
-		xfs_iterate_inodes_range_check(ctx, inumbers, breq->bulkstat);
+		fill_in_bulkstat_holes(ctx, inumbers, breq->bulkstat);
 
 		/* Iterate all the inodes. */
 		for (i = 0, bs = breq->bulkstat;
-		     i < inumbers->xi_alloccount;
+		     !si->aborted && i < inumbers->xi_alloccount;
 		     i++, bs++) {
 			handle.ha_fid.fid_ino = bs->bs_ino;
 			handle.ha_fid.fid_gen = bs->bs_gen;
-			error = fn(ctx, &handle, bs, arg);
+			error = si->fn(ctx, &handle, bs, si->arg);
 			switch (error) {
 			case 0:
 				break;
-			case ESTALE:
+			case ESTALE: {
+				char	idescr[DESCR_BUFSZ];
+
 				stale_count++;
 				if (stale_count < 30) {
 					ireq->hdr.ino = inumbers->xi_startino;
@@ -164,17 +178,16 @@ xfs_iterate_inodes_ag(
 				str_info(ctx, idescr,
 _("Changed too many times during scan; giving up."));
 				break;
+			}
 			case XFS_ITERATE_INODES_ABORT:
 				error = 0;
 				/* fall thru */
 			default:
-				moveon = false;
-				errno = error;
 				goto err;
 			}
 			if (xfs_scrub_excessive_errors(ctx)) {
-				moveon = false;
-				goto out;
+				si->aborted = true;
+				return;
 			}
 		}
 
@@ -186,71 +199,41 @@ _("Changed too many times during scan; giving up."));
 err:
 	if (error) {
 		str_liberror(ctx, error, descr);
-		moveon = false;
+		si->aborted = true;
 	}
 	free(ireq);
 	free(breq);
-out:
-	return moveon;
-}
-
-/* BULKSTAT wrapper routines. */
-struct xfs_scan_inodes {
-	xfs_inode_iter_fn	fn;
-	void			*arg;
-	bool			moveon;
-};
-
-/* Scan all the inodes in an AG. */
-static void
-xfs_scan_ag_inodes(
-	struct workqueue	*wq,
-	xfs_agnumber_t		agno,
-	void			*arg)
-{
-	struct xfs_scan_inodes	*si = arg;
-	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
-	char			descr[DESCR_BUFSZ];
-	bool			moveon;
-
-	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u inodes"),
-				major(ctx->fsinfo.fs_datadev),
-				minor(ctx->fsinfo.fs_datadev),
-				agno);
-
-	moveon = xfs_iterate_inodes_ag(ctx, descr, ctx->fshandle, agno,
-			si->fn, si->arg);
-	if (!moveon)
-		si->moveon = false;
 }
 
-/* Scan all the inodes in a filesystem. */
-bool
-xfs_scan_all_inodes(
+/*
+ * Scan all the inodes in a filesystem.  On error, this function will log
+ * an error message and return -1.
+ */
+int
+scrub_scan_all_inodes(
 	struct scrub_ctx	*ctx,
-	xfs_inode_iter_fn	fn,
+	scrub_inode_iter_fn	fn,
 	void			*arg)
 {
-	struct xfs_scan_inodes	si;
+	struct scan_inodes	si = {
+		.fn		= fn,
+		.arg		= arg,
+	};
 	xfs_agnumber_t		agno;
 	struct workqueue	wq;
 	int			ret;
 
-	si.moveon = true;
-	si.fn = fn;
-	si.arg = arg;
-
 	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
 		str_liberror(ctx, ret, _("creating bulkstat workqueue"));
-		return false;
+		return -1;
 	}
 
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
-		ret = workqueue_add(&wq, xfs_scan_ag_inodes, agno, &si);
+		ret = workqueue_add(&wq, scan_ag_inodes, agno, &si);
 		if (ret) {
-			si.moveon = false;
+			si.aborted = true;
 			str_liberror(ctx, ret, _("queueing bulkstat work"));
 			break;
 		}
@@ -258,19 +241,17 @@ xfs_scan_all_inodes(
 
 	ret = workqueue_terminate(&wq);
 	if (ret) {
-		si.moveon = false;
+		si.aborted = true;
 		str_liberror(ctx, ret, _("finishing bulkstat work"));
 	}
 	workqueue_destroy(&wq);
 
-	return si.moveon;
+	return si.aborted ? -1 : 0;
 }
 
-/*
- * Open a file by handle, or return a negative error code.
- */
+/* Open a file by handle, returning either the fd or -1 on error. */
 int
-xfs_open_handle(
+scrub_open_handle(
 	struct xfs_handle	*handle)
 {
 	return open_by_fshandle(handle, sizeof(*handle),
diff --git a/scrub/inodes.h b/scrub/inodes.h
index 3341c6d9..5bedd55b 100644
--- a/scrub/inodes.h
+++ b/scrub/inodes.h
@@ -6,13 +6,13 @@
 #ifndef XFS_SCRUB_INODES_H_
 #define XFS_SCRUB_INODES_H_
 
-typedef int (*xfs_inode_iter_fn)(struct scrub_ctx *ctx,
+typedef int (*scrub_inode_iter_fn)(struct scrub_ctx *ctx,
 		struct xfs_handle *handle, struct xfs_bulkstat *bs, void *arg);
 
 #define XFS_ITERATE_INODES_ABORT	(-1)
-bool xfs_scan_all_inodes(struct scrub_ctx *ctx, xfs_inode_iter_fn fn,
+int scrub_scan_all_inodes(struct scrub_ctx *ctx, scrub_inode_iter_fn fn,
 		void *arg);
 
-int xfs_open_handle(struct xfs_handle *handle);
+int scrub_open_handle(struct xfs_handle *handle);
 
 #endif /* XFS_SCRUB_INODES_H_ */
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 48bcc21c..13601ed7 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -78,7 +78,7 @@ xfs_scrub_inode(
 
 	/* Try to open the inode to pin it. */
 	if (S_ISREG(bstat->bs_mode)) {
-		fd = xfs_open_handle(handle);
+		fd = scrub_open_handle(handle);
 		/* Stale inode means we scan the whole cluster again. */
 		if (fd < 0 && errno == ESTALE)
 			return ESTALE;
@@ -161,7 +161,6 @@ xfs_scan_inodes(
 	struct scrub_inode_ctx	ictx;
 	uint64_t		val;
 	int			err;
-	bool			ret;
 
 	ictx.moveon = true;
 	err = ptcounter_alloc(scrub_nproc(ctx), &ictx.icount);
@@ -170,8 +169,8 @@ xfs_scan_inodes(
 		return false;
 	}
 
-	ret = xfs_scan_all_inodes(ctx, xfs_scrub_inode, &ictx);
-	if (!ret)
+	err = scrub_scan_all_inodes(ctx, xfs_scrub_inode, &ictx);
+	if (err)
 		ictx.moveon = false;
 	if (!ictx.moveon)
 		goto free;
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 18056afd..3ee6df1b 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -264,7 +264,7 @@ xfs_scrub_connections(
 
 	/* Open the dir, let the kernel try to reconnect it to the root. */
 	if (S_ISDIR(bstat->bs_mode)) {
-		fd = xfs_open_handle(handle);
+		fd = scrub_open_handle(handle);
 		if (fd < 0) {
 			if (errno == ESTALE)
 				return ESTALE;
@@ -360,7 +360,7 @@ xfs_scan_connections(
 	struct scrub_ctx	*ctx)
 {
 	bool			moveon = true;
-	bool			ret;
+	int			ret;
 
 	if (ctx->errors_found || ctx->unfixable_errors) {
 		str_info(ctx, ctx->mntpoint,
@@ -372,9 +372,9 @@ _("Filesystem has errors, skipping connectivity checks."));
 	if (!moveon)
 		return false;
 
-	ret = xfs_scan_all_inodes(ctx, xfs_scrub_connections, &moveon);
-	if (!ret)
-		moveon = false;
+	ret = scrub_scan_all_inodes(ctx, xfs_scrub_connections, &moveon);
+	if (ret)
+		return false;
 	if (!moveon)
 		return false;
 	xfs_scrub_report_preen_triggers(ctx);
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 7607001a..55b5a611 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -273,7 +273,7 @@ xfs_report_verify_inode(
 			bstat->bs_ino, bstat->bs_gen, _(" (unlinked)"));
 
 	/* Try to open the inode. */
-	fd = xfs_open_handle(handle);
+	fd = scrub_open_handle(handle);
 	if (fd < 0) {
 		error = errno;
 		if (error == ESTALE)
@@ -530,7 +530,8 @@ xfs_report_verify_errors(
 		return false;
 
 	/* Scan for unlinked files. */
-	return xfs_scan_all_inodes(ctx, xfs_report_verify_inode, vs);
+	ret = scrub_scan_all_inodes(ctx, xfs_report_verify_inode, vs);
+	return ret == 0;
 }
 
 /* Schedule a read-verify of a (data block) extent. */

