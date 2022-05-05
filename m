Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A47C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381821AbiEEQNJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381787AbiEEQM2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:12:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91A95C853
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:08:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B7F1B82E07
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82A4C385BB;
        Thu,  5 May 2022 16:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766916;
        bh=QhyMgOnwigwwrvbJ3tU4gSwSNkkDcUAkUJVDF6H8mgo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Fyxkwsih1quvW1mA90oiV6QvBkfdw6wkPpHrHw3YC3HGJ1mqFXVpavNZ1WLBatND2
         cEIwOGWJRze4kKVqneSVIltwokAU6FjW/MxGx7nCrWtJ4LmmRie0iBU0OhzM3veW2T
         Z1KZTKCF64e3wP+Kh33Q6mXTk38JqDBhcVtTrpEQoNvCl0ZuiscSHQNupG2ukCTmnU
         WWSISFDs0vyP3kCl2u8ntOBR8Ra694Cy25Fs/GPwjBjVJpwZlS+JNdg/cUpJYRXO0k
         ek52q96fQL5SZCH4lrN7Mp+SSc+S7l4KMQ8qzRRoClVBDAiOokgdeA+HFO2U6pYSU+
         cddATKvbV/H0w==
Subject: [PATCH 3/4] xfs_scrub: balance inode chunk scan across CPUs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:08:35 -0700
Message-ID: <165176691556.252326.13840084561552016776.stgit@magnolia>
In-Reply-To: <165176689880.252326.13947902143386455815.stgit@magnolia>
References: <165176689880.252326.13947902143386455815.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use the bounded workqueue functionality to spread the inode chunk scan
load across the CPUs more evenly.  First, we create per-AG workers to
walk each AG's inode btree to create inode batch work items for each
inobt record.  These items are added to a (second) bounded workqueue
that invokes BULKSTAT and invokes the caller's function on each bulkstat
record.

By splitting the work items into batches of 64 inodes instead of one
thread per AG, we keep the level of parallelism at a reasonably high
level almost all the way to the end of the inode scan if the inodes are
not evenly divided across AGs or if a few files have far more extent
records than average.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/inodes.c |  336 +++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 248 insertions(+), 88 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 80af8a74..41e5fdc7 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -16,6 +16,7 @@
 #include "xfs_scrub.h"
 #include "common.h"
 #include "inodes.h"
+#include "descr.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
 
@@ -49,7 +50,7 @@
 static void
 bulkstat_for_inumbers(
 	struct scrub_ctx	*ctx,
-	const char		*descr,
+	struct descr		*dsc,
 	const struct xfs_inumbers *inumbers,
 	struct xfs_bulkstat_req	*breq)
 {
@@ -65,7 +66,7 @@ bulkstat_for_inumbers(
 	if (error) {
 		char	errbuf[DESCR_BUFSZ];
 
-		str_info(ctx, descr, "%s",
+		str_info(ctx, descr_render(dsc), "%s",
 			 strerror_r(error, errbuf, DESCR_BUFSZ));
 	}
 
@@ -95,61 +96,206 @@ bulkstat_for_inumbers(
 
 /* BULKSTAT wrapper routines. */
 struct scan_inodes {
+	struct workqueue	wq_bulkstat;
 	scrub_inode_iter_fn	fn;
 	void			*arg;
+	unsigned int		nr_threads;
 	bool			aborted;
 };
 
 /*
- * Call into the filesystem for inode/bulkstat information and call our
- * iterator function.  We'll try to fill the bulkstat information in batches,
- * but we also can detect iget failures.
+ * A single unit of inode scan work.  This contains a pointer to the parent
+ * information, followed by an INUMBERS request structure, followed by a
+ * BULKSTAT request structure.  The last two are VLAs, so we can't represent
+ * them here.
  */
-static void
-scan_ag_inodes(
-	struct workqueue	*wq,
-	xfs_agnumber_t		agno,
-	void			*arg)
+struct scan_ichunk {
+	struct scan_inodes	*si;
+};
+
+static inline struct xfs_inumbers_req *
+ichunk_to_inumbers(
+	struct scan_ichunk	*ichunk)
 {
-	struct xfs_handle	handle = { };
-	char			descr[DESCR_BUFSZ];
+	char			*p = (char *)ichunk;
+
+	return (struct xfs_inumbers_req *)(p + sizeof(struct scan_ichunk));
+}
+
+static inline struct xfs_bulkstat_req *
+ichunk_to_bulkstat(
+	struct scan_ichunk	*ichunk)
+{
+	char			*p = (char *)ichunk_to_inumbers(ichunk);
+
+	return (struct xfs_bulkstat_req *)(p + XFS_INUMBERS_REQ_SIZE(1));
+}
+
+static inline int
+alloc_ichunk(
+	struct scan_inodes	*si,
+	uint32_t		agno,
+	uint64_t		startino,
+	struct scan_ichunk	**ichunkp)
+{
+	struct scan_ichunk	*ichunk;
 	struct xfs_inumbers_req	*ireq;
 	struct xfs_bulkstat_req	*breq;
-	struct scan_inodes	*si = arg;
-	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
-	struct xfs_bulkstat	*bs;
-	struct xfs_inumbers	*inumbers;
-	uint64_t		nextino = cvt_agino_to_ino(&ctx->mnt, agno, 0);
-	int			i;
-	int			error;
-	int			stale_count = 0;
-
-	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u inodes"),
+
+	ichunk = calloc(1, sizeof(struct scan_ichunk) +
+			   XFS_INUMBERS_REQ_SIZE(1) +
+			   XFS_BULKSTAT_REQ_SIZE(LIBFROG_BULKSTAT_CHUNKSIZE));
+	if (!ichunk)
+		return -errno;
+
+	ichunk->si = si;
+
+	ireq = ichunk_to_inumbers(ichunk);
+	ireq->hdr.icount = 1;
+	ireq->hdr.ino = startino;
+	ireq->hdr.agno = agno;
+	ireq->hdr.flags |= XFS_BULK_IREQ_AGNO;
+
+	breq = ichunk_to_bulkstat(ichunk);
+	breq->hdr.icount = LIBFROG_BULKSTAT_CHUNKSIZE;
+
+	*ichunkp = ichunk;
+	return 0;
+}
+
+int
+render_ino_from_bulkstat(
+	struct scrub_ctx	*ctx,
+	char			*buf,
+	size_t			buflen,
+	void			*data)
+{
+	struct xfs_bulkstat	*bstat = data;
+
+	return scrub_render_ino_descr(ctx, buf, buflen, bstat->bs_ino,
+			bstat->bs_gen, NULL);
+}
+
+static int
+render_inumbers_from_agno(
+	struct scrub_ctx	*ctx,
+	char			*buf,
+	size_t			buflen,
+	void			*data)
+{
+	xfs_agnumber_t		*agno = data;
+
+	return snprintf(buf, buflen, _("dev %d:%d AG %u inodes"),
 				major(ctx->fsinfo.fs_datadev),
 				minor(ctx->fsinfo.fs_datadev),
-				agno);
+				*agno);
+}
+
+/*
+ * Call BULKSTAT for information on a single chunk's worth of inodes and call
+ * our iterator function.  We'll try to fill the bulkstat information in
+ * batches, but we also can detect iget failures.
+ */
+static void
+scan_ag_bulkstat(
+	struct workqueue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct xfs_handle	handle = { };
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
+	struct scan_ichunk	*ichunk = arg;
+	struct xfs_inumbers_req	*ireq = ichunk_to_inumbers(ichunk);
+	struct xfs_bulkstat_req	*breq = ichunk_to_bulkstat(ichunk);
+	struct scan_inodes	*si = ichunk->si;
+	struct xfs_bulkstat	*bs;
+	struct xfs_inumbers	*inumbers = &ireq->inumbers[0];
+	int			i;
+	int			error;
+	int			stale_count = 0;
+	DEFINE_DESCR(dsc_bulkstat, ctx, render_ino_from_bulkstat);
+	DEFINE_DESCR(dsc_inumbers, ctx, render_inumbers_from_agno);
+
+	descr_set(&dsc_inumbers, &agno);
 
 	memcpy(&handle.ha_fsid, ctx->fshandle, sizeof(handle.ha_fsid));
 	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
 			sizeof(handle.ha_fid.fid_len);
 	handle.ha_fid.fid_pad = 0;
 
-	error = -xfrog_bulkstat_alloc_req(LIBFROG_BULKSTAT_CHUNKSIZE, 0, &breq);
-	if (error) {
-		str_liberror(ctx, error, descr);
-		si->aborted = true;
-		return;
+retry:
+	bulkstat_for_inumbers(ctx, &dsc_inumbers, inumbers, breq);
+
+	/* Iterate all the inodes. */
+	bs = &breq->bulkstat[0];
+	for (i = 0; !si->aborted && i < inumbers->xi_alloccount; i++, bs++) {
+		descr_set(&dsc_bulkstat, bs);
+		handle.ha_fid.fid_ino = bs->bs_ino;
+		handle.ha_fid.fid_gen = bs->bs_gen;
+		error = si->fn(ctx, &handle, bs, si->arg);
+		switch (error) {
+		case 0:
+			break;
+		case ESTALE: {
+			stale_count++;
+			if (stale_count < 30) {
+				ireq->hdr.ino = inumbers->xi_startino;
+				error = -xfrog_inumbers(&ctx->mnt, ireq);
+				if (error)
+					goto err;
+				goto retry;
+			}
+			str_info(ctx, descr_render(&dsc_bulkstat),
+_("Changed too many times during scan; giving up."));
+			si->aborted = true;
+			goto out;
+		}
+		case ECANCELED:
+			error = 0;
+			fallthrough;
+		default:
+			goto err;
+		}
+		if (scrub_excessive_errors(ctx)) {
+			si->aborted = true;
+			goto out;
+		}
 	}
 
-	error = -xfrog_inumbers_alloc_req(1, 0, &ireq);
+err:
 	if (error) {
-		str_liberror(ctx, error, descr);
-		free(breq);
+		str_liberror(ctx, error, descr_render(&dsc_bulkstat));
 		si->aborted = true;
-		return;
 	}
-	inumbers = &ireq->inumbers[0];
-	xfrog_inumbers_set_ag(ireq, agno);
+out:
+	free(ichunk);
+}
+
+/*
+ * Call INUMBERS for information about inode chunks, then queue the inumbers
+ * responses in the bulkstat workqueue.  This helps us maximize CPU parallelism
+ * if the filesystem AGs are not evenly loaded.
+ */
+static void
+scan_ag_inumbers(
+	struct workqueue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct scan_ichunk	*ichunk = NULL;
+	struct scan_inodes	*si = arg;
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
+	struct xfs_inumbers_req	*ireq;
+	uint64_t		nextino = cvt_agino_to_ino(&ctx->mnt, agno, 0);
+	int			error;
+	DEFINE_DESCR(dsc, ctx, render_inumbers_from_agno);
+
+	descr_set(&dsc, &agno);
+
+	error = alloc_ichunk(si, agno, 0, &ichunk);
+	if (error)
+		goto err;
+	ireq = ichunk_to_inumbers(ichunk);
 
 	/* Find the inode chunk & alloc mask */
 	error = -xfrog_inumbers(&ctx->mnt, ireq);
@@ -158,8 +304,8 @@ scan_ag_inodes(
 		 * Make sure that we always make forward progress while we
 		 * scan the inode btree.
 		 */
-		if (nextino > inumbers->xi_startino) {
-			str_corrupt(ctx, descr,
+		if (nextino > ireq->inumbers[0].xi_startino) {
+			str_corrupt(ctx, descr_render(&dsc),
 	_("AG %u inode btree is corrupt near agino %lu, got %lu"), agno,
 				cvt_ino_to_agino(&ctx->mnt, nextino),
 				cvt_ino_to_agino(&ctx->mnt,
@@ -169,64 +315,53 @@ scan_ag_inodes(
 		}
 		nextino = ireq->hdr.ino;
 
-		/*
-		 * We can have totally empty inode chunks on filesystems where
-		 * there are more than 64 inodes per block.  Skip these.
-		 */
-		if (inumbers->xi_alloccount == 0)
-			goto igrp_retry;
-
-		bulkstat_for_inumbers(ctx, descr, inumbers, breq);
-
-		/* Iterate all the inodes. */
-		for (i = 0, bs = breq->bulkstat;
-		     !si->aborted && i < inumbers->xi_alloccount;
-		     i++, bs++) {
-			handle.ha_fid.fid_ino = bs->bs_ino;
-			handle.ha_fid.fid_gen = bs->bs_gen;
-			error = si->fn(ctx, &handle, bs, si->arg);
-			switch (error) {
-			case 0:
-				break;
-			case ESTALE: {
-				char	idescr[DESCR_BUFSZ];
-
-				stale_count++;
-				if (stale_count < 30) {
-					ireq->hdr.ino = inumbers->xi_startino;
-					goto igrp_retry;
-				}
-				scrub_render_ino_descr(ctx, idescr, DESCR_BUFSZ,
-						bs->bs_ino, bs->bs_gen, NULL);
-				str_info(ctx, idescr,
-_("Changed too many times during scan; giving up."));
-				break;
-			}
-			case ECANCELED:
-				error = 0;
-				fallthrough;
-			default:
-				goto err;
-			}
-			if (scrub_excessive_errors(ctx)) {
+		if (ireq->inumbers[0].xi_alloccount == 0) {
+			/*
+			 * We can have totally empty inode chunks on
+			 * filesystems where there are more than 64 inodes per
+			 * block.  Skip these.
+			 */
+			;
+		} else if (si->nr_threads > 0) {
+			/* Queue this inode chunk on the bulkstat workqueue. */
+			error = -workqueue_add(&si->wq_bulkstat,
+					scan_ag_bulkstat, agno, ichunk);
+			if (error) {
 				si->aborted = true;
+				str_liberror(ctx, error,
+						_("queueing bulkstat work"));
 				goto out;
 			}
+			ichunk = NULL;
+		} else {
+			/*
+			 * Only one thread, call bulkstat directly.  Remember,
+			 * ichunk is freed by the worker before returning.
+			 */
+			scan_ag_bulkstat(wq, agno, ichunk);
+			ichunk = NULL;
+			if (si->aborted)
+				break;
 		}
 
-		stale_count = 0;
-igrp_retry:
+		if (!ichunk) {
+			error = alloc_ichunk(si, agno, nextino, &ichunk);
+			if (error)
+				goto err;
+		}
+		ireq = ichunk_to_inumbers(ichunk);
+
 		error = -xfrog_inumbers(&ctx->mnt, ireq);
 	}
 
 err:
 	if (error) {
-		str_liberror(ctx, error, descr);
+		str_liberror(ctx, error, descr_render(&dsc));
 		si->aborted = true;
 	}
 out:
-	free(ireq);
-	free(breq);
+	if (ichunk)
+		free(ichunk);
 }
 
 /*
@@ -242,33 +377,58 @@ scrub_scan_all_inodes(
 	struct scan_inodes	si = {
 		.fn		= fn,
 		.arg		= arg,
+		.nr_threads	= scrub_nproc_workqueue(ctx),
 	};
 	xfs_agnumber_t		agno;
-	struct workqueue	wq;
+	struct workqueue	wq_inumbers;
+	unsigned int		max_bulkstat;
 	int			ret;
 
-	ret = -workqueue_create(&wq, (struct xfs_mount *)ctx,
-			scrub_nproc_workqueue(ctx));
+	/*
+	 * The bulkstat workqueue should queue at most one inobt block's worth
+	 * of inode chunk records per worker thread.  If we're running in
+	 * single thread mode (nr_threads==0) then we skip the workqueues.
+	 */
+	max_bulkstat = si.nr_threads * (ctx->mnt.fsgeom.blocksize / 16);
+
+	ret = -workqueue_create_bound(&si.wq_bulkstat, (struct xfs_mount *)ctx,
+			si.nr_threads, max_bulkstat);
 	if (ret) {
 		str_liberror(ctx, ret, _("creating bulkstat workqueue"));
 		return -1;
 	}
 
+	ret = -workqueue_create(&wq_inumbers, (struct xfs_mount *)ctx,
+			si.nr_threads);
+	if (ret) {
+		str_liberror(ctx, ret, _("creating inumbers workqueue"));
+		si.aborted = true;
+		goto kill_bulkstat;
+	}
+
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
-		ret = -workqueue_add(&wq, scan_ag_inodes, agno, &si);
+		ret = -workqueue_add(&wq_inumbers, scan_ag_inumbers, agno, &si);
 		if (ret) {
 			si.aborted = true;
-			str_liberror(ctx, ret, _("queueing bulkstat work"));
+			str_liberror(ctx, ret, _("queueing inumbers work"));
 			break;
 		}
 	}
 
-	ret = -workqueue_terminate(&wq);
+	ret = -workqueue_terminate(&wq_inumbers);
+	if (ret) {
+		si.aborted = true;
+		str_liberror(ctx, ret, _("finishing inumbers work"));
+	}
+	workqueue_destroy(&wq_inumbers);
+
+kill_bulkstat:
+	ret = -workqueue_terminate(&si.wq_bulkstat);
 	if (ret) {
 		si.aborted = true;
 		str_liberror(ctx, ret, _("finishing bulkstat work"));
 	}
-	workqueue_destroy(&wq);
+	workqueue_destroy(&si.wq_bulkstat);
 
 	return si.aborted ? -1 : 0;
 }

