Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78197C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbiLaCQi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiLaCQh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:16:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631562DD5
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:16:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16AB2B81E5A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA4BC433D2;
        Sat, 31 Dec 2022 02:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452993;
        bh=BLmvg4Rqwhm12Rw3rZK/YwtDQ2tBM4JT+/eZfurvbto=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GrQxcD2MdHQMqXdhv0lT7pizt+2qQl1u/2DlJfWYgUGN9ypZwxDxc6Y9gJR/stqop
         HrvzRD9uWXEkuDgyt1dyRSHFjITCAToKUkuUpClFgT2YRq2gZEo73tXV4r+dfWPKYa
         YywZ2vn37lBlZODt9+tmBJ//lguBAoqELFZ3ITRrsd+aZ4AcPJqCtpRkNXSFx66pLm
         uu9Uf8knw/FqfNPgaodp9TPLUu6k2nAu2BZuC6mkd5NQRZsx/oIGY5zx7HlcSSgmTP
         v9yPjeCbTsPGaJHSaZCluCSMwfcTQk8YWfvO8VoJMrMsxR2dXFxdIusdoFQ0YR1R5r
         coRkScpoPQYOg==
Subject: [PATCH 26/46] xfs_scrub: scan metadata directories during phase 3
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:22 -0800
Message-ID: <167243876276.725900.10798991288646986623.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Scan metadata directories for correctness during phase 3.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/inodes.c |    5 +++++
 scrub/inodes.h |    5 ++++-
 scrub/phase3.c |    7 ++++++-
 scrub/phase5.c |    2 +-
 scrub/phase6.c |    2 +-
 5 files changed, 17 insertions(+), 4 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 78f0914b8d9..52d17c5c646 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -100,6 +100,7 @@ struct scan_inodes {
 	scrub_inode_iter_fn	fn;
 	void			*arg;
 	unsigned int		nr_threads;
+	unsigned int		flags;
 	bool			aborted;
 };
 
@@ -158,6 +159,8 @@ alloc_ichunk(
 
 	breq = ichunk_to_bulkstat(ichunk);
 	breq->hdr.icount = LIBFROG_BULKSTAT_CHUNKSIZE;
+	if (si->flags & SCRUB_SCAN_METADIR)
+		breq->hdr.flags |= XFS_BULK_IREQ_METADIR;
 
 	*ichunkp = ichunk;
 	return 0;
@@ -380,10 +383,12 @@ int
 scrub_scan_all_inodes(
 	struct scrub_ctx	*ctx,
 	scrub_inode_iter_fn	fn,
+	unsigned int		flags,
 	void			*arg)
 {
 	struct scan_inodes	si = {
 		.fn		= fn,
+		.flags		= flags,
 		.arg		= arg,
 		.nr_threads	= scrub_nproc_workqueue(ctx),
 	};
diff --git a/scrub/inodes.h b/scrub/inodes.h
index f03180458ab..d99eaf0a2a7 100644
--- a/scrub/inodes.h
+++ b/scrub/inodes.h
@@ -17,8 +17,11 @@
 typedef int (*scrub_inode_iter_fn)(struct scrub_ctx *ctx,
 		struct xfs_handle *handle, struct xfs_bulkstat *bs, void *arg);
 
+/* Return metadata directories too. */
+#define SCRUB_SCAN_METADIR	(1 << 0)
+
 int scrub_scan_all_inodes(struct scrub_ctx *ctx, scrub_inode_iter_fn fn,
-		void *arg);
+		unsigned int flags, void *arg);
 
 int scrub_open_handle(struct xfs_handle *handle);
 
diff --git a/scrub/phase3.c b/scrub/phase3.c
index c5950b1b9e3..56a4385a408 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -247,6 +247,7 @@ phase3_func(
 	struct scrub_inode_ctx	ictx = { .ctx = ctx };
 	uint64_t		val;
 	xfs_agnumber_t		agno;
+	unsigned int		scan_flags = 0;
 	int			err;
 
 	err = -ptvar_alloc(scrub_nproc(ctx), sizeof(struct action_list),
@@ -263,6 +264,10 @@ phase3_func(
 		goto out_ptvar;
 	}
 
+	/* Scan the metadata directory tree too. */
+	if (ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_METADIR)
+		scan_flags |= SCRUB_SCAN_METADIR;
+
 	/*
 	 * If we already have ag/fs metadata to repair from previous phases,
 	 * we would rather not try to repair file metadata until we've tried
@@ -273,7 +278,7 @@ phase3_func(
 			ictx.always_defer_repairs = true;
 	}
 
-	err = scrub_scan_all_inodes(ctx, scrub_inode, &ictx);
+	err = scrub_scan_all_inodes(ctx, scrub_inode, scan_flags, &ictx);
 	if (!err && ictx.aborted)
 		err = ECANCELED;
 	if (err)
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 96e13ac423f..e6786b4f25c 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -532,7 +532,7 @@ _("Filesystem has errors, skipping connectivity checks."));
 	if (ret)
 		return ret;
 
-	ret = scrub_scan_all_inodes(ctx, check_inode_names, &aborted);
+	ret = scrub_scan_all_inodes(ctx, check_inode_names, 0, &aborted);
 	if (ret)
 		return ret;
 	if (aborted)
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 1a2643bdaf0..fb7cd3f13ea 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -507,7 +507,7 @@ report_all_media_errors(
 		return ret;
 
 	/* Scan for unlinked files. */
-	return scrub_scan_all_inodes(ctx, report_inode_loss, vs);
+	return scrub_scan_all_inodes(ctx, report_inode_loss, 0, vs);
 }
 
 /* Schedule a read-verify of a (data block) extent. */

