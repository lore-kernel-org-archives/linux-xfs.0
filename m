Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB1AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381780AbiEEQLw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381747AbiEEQLt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:11:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970B35C65F
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:07:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3411461DD3
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BE7C385A8;
        Thu,  5 May 2022 16:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766873;
        bh=gJFDHujHI94fE5y9uN7S9hLjZSOQs1vfo6cSp4JTR3U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Wqpb2DX468H+tYPsuea5p32tXssRaaPbqQfyR4X9iru0uSANSttzFyVElRgTlh6wZ
         kdxQhHeM2lKYxt5WFraIEV/sJ/YQqYFruLR+a8zwhHDlj7avAVIm5u3LObXhc5FTND
         FTK//geuuMWpdeGM8ofeV3qVh8zaPWRGwe9f9vk+v3mhLCIu0NzukYIuZ8fD+gaEd+
         oXphWYVHHla56t7f/w21j8iFoIATAKHuH2xvBOCNiNyVxdAYRriQchHx024+VsQiUP
         etNw2FQh9DMTjTtMtY+IwQXwANZR0rSsA1cBXN6hrY41Jd3wSgCj7X9ep+EaSSi8VO
         a59t7+LJS5s6Q==
Subject: [PATCH 2/6] xfs_scrub: in phase 3,
 use the opened file descriptor for scrub calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:07:53 -0700
Message-ID: <165176687314.252160.7990093715132347267.stgit@magnolia>
In-Reply-To: <165176686186.252160.2880340500532409944.stgit@magnolia>
References: <165176686186.252160.2880340500532409944.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While profiling the performance of xfs_scrub, I noticed that phase3 only
employs the scrub-by-handle interface.  The kernel has had the ability
to skip the untrusted iget lookup if the fd matches the handle data
since the beginning, and using it reduces the phase 3 runtime by 5% on
the author's system.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase3.c |   32 ++++++++++++++++++++++----------
 scrub/scrub.c  |   21 ++++++++++++++++++---
 scrub/scrub.h  |    2 +-
 3 files changed, 41 insertions(+), 14 deletions(-)


diff --git a/scrub/phase3.c b/scrub/phase3.c
index 868f444d..7da11299 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -59,16 +59,27 @@ scrub_inode(
 	agno = cvt_ino_to_agno(&ctx->mnt, bstat->bs_ino);
 	background_sleep();
 
-	/* Try to open the inode to pin it. */
+	/*
+	 * Open this regular file to pin it in memory.  Avoiding the use of
+	 * scan-by-handle means that the in-kernel scrubber doesn't pay the
+	 * cost of opening the handle (looking up the inode in the inode btree,
+	 * grabbing the inode, checking the generation) with every scrub call.
+	 *
+	 * Note: We cannot use this same trick for directories because the VFS
+	 * will try to reconnect directory file handles to the root directory
+	 * by walking '..' entries upwards, and loops in the dirent index
+	 * btree will cause livelocks.
+	 *
+	 * ESTALE means we scan the whole cluster again.
+	 */
 	if (S_ISREG(bstat->bs_mode)) {
 		fd = scrub_open_handle(handle);
-		/* Stale inode means we scan the whole cluster again. */
 		if (fd < 0 && errno == ESTALE)
 			return ESTALE;
 	}
 
 	/* Scrub the inode. */
-	error = scrub_file(ctx, bstat, XFS_SCRUB_TYPE_INODE, &alist);
+	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_INODE, &alist);
 	if (error)
 		goto out;
 
@@ -77,13 +88,13 @@ scrub_inode(
 		goto out;
 
 	/* Scrub all block mappings. */
-	error = scrub_file(ctx, bstat, XFS_SCRUB_TYPE_BMBTD, &alist);
+	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_BMBTD, &alist);
 	if (error)
 		goto out;
-	error = scrub_file(ctx, bstat, XFS_SCRUB_TYPE_BMBTA, &alist);
+	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_BMBTA, &alist);
 	if (error)
 		goto out;
-	error = scrub_file(ctx, bstat, XFS_SCRUB_TYPE_BMBTC, &alist);
+	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_BMBTC, &alist);
 	if (error)
 		goto out;
 
@@ -93,21 +104,22 @@ scrub_inode(
 
 	if (S_ISLNK(bstat->bs_mode)) {
 		/* Check symlink contents. */
-		error = scrub_file(ctx, bstat, XFS_SCRUB_TYPE_SYMLINK, &alist);
+		error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_SYMLINK,
+				&alist);
 	} else if (S_ISDIR(bstat->bs_mode)) {
 		/* Check the directory entries. */
-		error = scrub_file(ctx, bstat, XFS_SCRUB_TYPE_DIR, &alist);
+		error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_DIR, &alist);
 	}
 	if (error)
 		goto out;
 
 	/* Check all the extended attributes. */
-	error = scrub_file(ctx, bstat, XFS_SCRUB_TYPE_XATTR, &alist);
+	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_XATTR, &alist);
 	if (error)
 		goto out;
 
 	/* Check parent pointers. */
-	error = scrub_file(ctx, bstat, XFS_SCRUB_TYPE_PARENT, &alist);
+	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_PARENT, &alist);
 	if (error)
 		goto out;
 
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 0034f11d..19a0b2d0 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -122,6 +122,7 @@ scrub_warn_incomplete_scrub(
 static enum check_outcome
 xfs_check_metadata(
 	struct scrub_ctx		*ctx,
+	struct xfs_fd			*xfdp,
 	struct xfs_scrub_metadata	*meta,
 	bool				is_inode)
 {
@@ -135,7 +136,7 @@ xfs_check_metadata(
 
 	dbg_printf("check %s flags %xh\n", descr_render(&dsc), meta->sm_flags);
 retry:
-	error = -xfrog_scrub_metadata(&ctx->mnt, meta);
+	error = -xfrog_scrub_metadata(xfdp, meta);
 	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !error)
 		meta->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 	switch (error) {
@@ -316,7 +317,7 @@ scrub_meta_type(
 	background_sleep();
 
 	/* Check the item. */
-	fix = xfs_check_metadata(ctx, &meta, false);
+	fix = xfs_check_metadata(ctx, &ctx->mnt, &meta, false);
 	progress_add(1);
 
 	switch (fix) {
@@ -452,11 +453,14 @@ scrub_estimate_ag_work(
 int
 scrub_file(
 	struct scrub_ctx		*ctx,
+	int				fd,
 	const struct xfs_bulkstat	*bstat,
 	unsigned int			type,
 	struct action_list		*alist)
 {
 	struct xfs_scrub_metadata	meta = {0};
+	struct xfs_fd			xfd;
+	struct xfs_fd			*xfdp = &ctx->mnt;
 	enum check_outcome		fix;
 
 	assert(type < XFS_SCRUB_TYPE_NR);
@@ -466,8 +470,19 @@ scrub_file(
 	meta.sm_ino = bstat->bs_ino;
 	meta.sm_gen = bstat->bs_gen;
 
+	/*
+	 * If the caller passed us a file descriptor for a scrub, use it
+	 * instead of scrub-by-handle because this enables the kernel to skip
+	 * costly inode btree lookups.
+	 */
+	if (fd >= 0) {
+		memcpy(&xfd, xfdp, sizeof(xfd));
+		xfd.fd = fd;
+		xfdp = &xfd;
+	}
+
 	/* Scrub the piece of metadata. */
-	fix = xfs_check_metadata(ctx, &meta, true);
+	fix = xfs_check_metadata(ctx, xfdp, &meta, true);
 	if (fix == CHECK_ABORT)
 		return ECANCELED;
 	if (fix == CHECK_DONE)
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 5b5f6b65..325d8f95 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -34,7 +34,7 @@ bool can_scrub_symlink(struct scrub_ctx *ctx);
 bool can_scrub_parent(struct scrub_ctx *ctx);
 bool xfs_can_repair(struct scrub_ctx *ctx);
 
-int scrub_file(struct scrub_ctx *ctx, const struct xfs_bulkstat *bstat,
+int scrub_file(struct scrub_ctx *ctx, int fd, const struct xfs_bulkstat *bstat,
 		unsigned int type, struct action_list *alist);
 
 /* Repair parameters are the scrub inputs and retry count. */

