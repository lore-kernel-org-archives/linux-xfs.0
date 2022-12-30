Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05FC0C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235694AbiLaAdu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235655AbiLaAdt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:33:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B160F1EAC0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:33:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40662B81DC6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA4FC433D2;
        Sat, 31 Dec 2022 00:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446824;
        bh=hbiMdzorGC3EjBzi8Jfg/+CDYC7OaaYzXNoSwvHEtpE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ddVruT2+w3U1qOKMLeA3alpYKqSn6qJL+r3gIEx6tIFDOiQtnwwkcvg3CQTslnPN7
         MteXy1tOWJ+MSfTL9VYs1uptOdtCszrNbdSIjqhEgtlmO98DL8OkRFwJIYVsPZPbUf
         T2vJC9PZKSpaSWLfJuvRjWdoZu2RZi8b1dbrVtmiTE07b3y+Sc9eupauqaouiNGfIc
         16GY2xhFmC4qZIJD8vHTV1ZG1dRefUvFMA8km/U1iKnhokbiwpiXOL20i8RmfgQ2yH
         IH340Yi9/+imTjrB8xw2g1msO8SQkg6LYmzrj4Wn1l7baHbA1Oi7UDGgLYts8J3siN
         TOPglYmwJr6iQ==
Subject: [PATCH 7/7] xfs_scrub: fstrim each AG in parallel
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:28 -0800
Message-ID: <167243870836.716924.15770089283981898048.stgit@magnolia>
In-Reply-To: <167243870748.716924.8460607901853339412.stgit@magnolia>
References: <167243870748.716924.8460607901853339412.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Newer flash storage devices aren't as bad as the old ones when it comes
to trimming unused storage.  We know that the first block of each AG is
always used, and therefore each AG can be trimmed independently.
Therefore, do them all in parallel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |   80 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 scrub/vfs.c    |   10 +++++--
 scrub/vfs.h    |    2 +
 3 files changed, 81 insertions(+), 11 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index ac667fc91fb..a8ea8db706b 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -18,6 +18,7 @@
 #include "repair.h"
 #include "vfs.h"
 #include "atomic.h"
+#include "disk.h"
 
 /* Phase 8: Trim filesystem. */
 
@@ -45,24 +46,89 @@ fstrim_ok(
 	return true;
 }
 
+struct trim_ctl {
+	uint64_t	datadev_end_pos;
+	bool		aborted;
+};
+
+/* Trim each AG. */
+static void
+trim_ag(
+	struct workqueue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
+	struct trim_ctl		*tctl = arg;
+	uint64_t		pos, len, eoag_pos;
+	int			error;
+
+	pos = cvt_agbno_to_b(&ctx->mnt, agno, 0);
+	eoag_pos = cvt_agbno_to_b(&ctx->mnt, agno, ctx->mnt.fsgeom.agblocks);
+	len = min(tctl->datadev_end_pos, eoag_pos) - pos;
+
+	error = fstrim(ctx, pos, len);
+	if (error) {
+		char		descr[DESCR_BUFSZ];
+
+		snprintf(descr, sizeof(descr) - 1, _("fstrim agno %u"), agno);
+		str_liberror(ctx, error, descr);
+		tctl->aborted = true;
+		return;
+	}
+
+	progress_add(1);
+}
+
 /* Trim the filesystem, if desired. */
 int
 phase8_func(
 	struct scrub_ctx	*ctx)
 {
-	int			error;
+	struct workqueue	wq;
+	struct trim_ctl		tctl = {
+		.aborted	= false,
+	};
+	xfs_agnumber_t		agno;
+	int			error, err2;
 
 	if (!fstrim_ok(ctx))
 		return 0;
 
-	error = fstrim(ctx);
+	tctl.datadev_end_pos = cvt_off_fsb_to_b(&ctx->mnt,
+			ctx->mnt.fsgeom.datablocks);
+
+	error = -workqueue_create(&wq, (struct xfs_mount *)ctx,
+			disk_heads(ctx->datadev));
 	if (error) {
-		str_liberror(ctx, error, _("fstrim"));
+		str_liberror(ctx, error, _("creating fstrim workqueue"));
 		return error;
 	}
 
-	progress_add(1);
-	return 0;
+	/* Trim each AG in parallel. */
+	for (agno = 0;
+	     agno < ctx->mnt.fsgeom.agcount && !tctl.aborted;
+	     agno++) {
+		error = -workqueue_add(&wq, trim_ag, agno, &tctl);
+		if (error) {
+			str_liberror(ctx, error,
+					_("queueing per-AG fstrim work"));
+			goto out_wq;
+		}
+	}
+
+out_wq:
+	err2 = -workqueue_terminate(&wq);
+	if (err2) {
+		str_liberror(ctx, err2, _("finishing fstrim work"));
+		if (!error && err2)
+			error = err2;
+	}
+	workqueue_destroy(&wq);
+
+	if (!error && tctl.aborted)
+		return ECANCELED;
+	return error;
 }
 
 /* Estimate how much work we're going to do. */
@@ -76,9 +142,9 @@ phase8_estimate(
 	*items = 0;
 
 	if (fstrim_ok(ctx))
-		*items = 1;
+		*items = ctx->mnt.fsgeom.agcount;
 
-	*nr_threads = 1;
+	*nr_threads = disk_heads(ctx->datadev);
 	*rshift = 0;
 	return 0;
 }
diff --git a/scrub/vfs.c b/scrub/vfs.c
index ca34972d401..85ee2694b00 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -298,11 +298,15 @@ struct fstrim_range {
 /* Call FITRIM to trim all the unused space in a filesystem. */
 int
 fstrim(
-	struct scrub_ctx	*ctx)
+	struct scrub_ctx	*ctx,
+	uint64_t		offset,
+	uint64_t		len)
 {
-	struct fstrim_range	range = {0};
+	struct fstrim_range	range = {
+		.start		= offset,
+		.len		= len,
+	};
 
-	range.len = ULLONG_MAX;
 	if (ioctl(ctx->mnt.fd, FITRIM, &range) == 0)
 		return 0;
 	if (errno == EOPNOTSUPP || errno == ENOTTY)
diff --git a/scrub/vfs.h b/scrub/vfs.h
index 14f2a583eb1..311c403fa4e 100644
--- a/scrub/vfs.h
+++ b/scrub/vfs.h
@@ -24,6 +24,6 @@ typedef int (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
 int scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
 		scan_fs_tree_dirent_fn dirent_fn, void *arg);
 
-int fstrim(struct scrub_ctx *ctx);
+int fstrim(struct scrub_ctx *ctx, uint64_t offset, uint64_t len);
 
 #endif /* XFS_SCRUB_VFS_H_ */

