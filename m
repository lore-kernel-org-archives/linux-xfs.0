Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B4C6AA7
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609469; cv=none; b=qvKITJy1dFi9MJExSG2n7bcxMvKm7KRIANTRw0aWqvEUL5xpDddIogyQA04yjMMEhl6aHU8At8pm38la28rcvAEqPqjaJEjD26fOnGWPFvkYaqXMSVheqnjVVSJTbww1pzKWGzc12SdvTg1X5KK32cZ59YyPBezeo8utt7GXMA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609469; c=relaxed/simple;
	bh=Z27gHmlWh0zJfZc/rmaMXjpiev8zg/lwgXnp+K0XCsY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aDZhKUj+4lDhUZJUo+0sJuK2ILCBUxB9vu8Wlwia0jwz+DdJQSk2d8cjxD62f05bAjG0rbTQ86NIlARlX6MqD5BVWx9HI4VD7S7rzbWRpQ4xPH5pFkcwoiBt/GYlfvxZUFT/HrbHzCuA6tTs6eeRpbk/AdRkdyw/RMqJpUZdOLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pWcNNYvc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pWcNNYvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A862C4CEC5;
	Fri, 11 Oct 2024 01:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609469;
	bh=Z27gHmlWh0zJfZc/rmaMXjpiev8zg/lwgXnp+K0XCsY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pWcNNYvcH9KKJypMsrZ4/bDgrAVdXuSMKj0rVt3KBCCKUKyNzMCudVzg2z0zrdulv
	 6D8gtum1qw6m5E//J/PDYxWVEiWJ0VdYXFjcEiBnc3sPKGe4mfb12cflblVkWazE/D
	 zlc5muVYOz0UHYYdhadHYWMNxKz3Jp3m8R2tCudYU5wRq22777hmXfN3NGO3I8zRyi
	 kXGNWlytRJ6PiYCDEY2wdYSYb8ot/3yaDqv3E0L8rPfQ7fs1XX1Z/Hxe7onB4K4gFO
	 R7yvk4LeMof2SFwyVFxpcyiQAvMsp4nPt77X1k+gzr9P9qq9FDfZ7h17Ec9BpH/pda
	 1dfmvGxA+IbVg==
Date: Thu, 10 Oct 2024 18:17:48 -0700
Subject: [PATCH 14/38] xfs_scrub: scan metadata directories during phase 3
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654191.4183231.2066114568344117426.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Scan metadata directories for correctness during phase 3.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/inodes.c |   11 ++++++++++-
 scrub/inodes.h |    5 ++++-
 scrub/phase3.c |    7 ++++++-
 scrub/phase5.c |    5 ++++-
 scrub/phase6.c |    2 +-
 5 files changed, 25 insertions(+), 5 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 16c79cf495c793..3fe759e8f4867d 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -56,6 +56,7 @@ bulkstat_for_inumbers(
 {
 	struct xfs_bulkstat	*bstat = breq->bulkstat;
 	struct xfs_bulkstat	*bs;
+	unsigned int		flags = 0;
 	int			i;
 	int			error;
 
@@ -70,6 +71,9 @@ bulkstat_for_inumbers(
 			 strerror_r(error, errbuf, DESCR_BUFSZ));
 	}
 
+	if (breq->hdr.flags & XFS_BULK_IREQ_METADIR)
+		flags |= XFS_BULK_IREQ_METADIR;
+
 	/*
 	 * Check each of the stats we got back to make sure we got the inodes
 	 * we asked for.
@@ -84,7 +88,7 @@ bulkstat_for_inumbers(
 
 		/* Load the one inode. */
 		error = -xfrog_bulkstat_single(&ctx->mnt,
-				inumbers->xi_startino + i, 0, bs);
+				inumbers->xi_startino + i, flags, bs);
 		if (error || bs->bs_ino != inumbers->xi_startino + i) {
 			memset(bs, 0, sizeof(struct xfs_bulkstat));
 			bs->bs_ino = inumbers->xi_startino + i;
@@ -100,6 +104,7 @@ struct scan_inodes {
 	scrub_inode_iter_fn	fn;
 	void			*arg;
 	unsigned int		nr_threads;
+	unsigned int		flags;
 	bool			aborted;
 };
 
@@ -158,6 +163,8 @@ alloc_ichunk(
 
 	breq = ichunk_to_bulkstat(ichunk);
 	breq->hdr.icount = LIBFROG_BULKSTAT_CHUNKSIZE;
+	if (si->flags & SCRUB_SCAN_METADIR)
+		breq->hdr.flags |= XFS_BULK_IREQ_METADIR;
 
 	*ichunkp = ichunk;
 	return 0;
@@ -380,10 +387,12 @@ int
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
index 9447fb56aa62e7..7a0b275e575ead 100644
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
index 046a42c1da8beb..c90da78439425a 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -312,6 +312,7 @@ phase3_func(
 	struct scrub_inode_ctx	ictx = { .ctx = ctx };
 	uint64_t		val;
 	xfs_agnumber_t		agno;
+	unsigned int		scan_flags = 0;
 	int			err;
 
 	err = -ptvar_alloc(scrub_nproc(ctx), sizeof(struct action_list),
@@ -328,6 +329,10 @@ phase3_func(
 		goto out_ptvar;
 	}
 
+	/* Scan the metadata directory tree too. */
+	if (ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_METADIR)
+		scan_flags |= SCRUB_SCAN_METADIR;
+
 	/*
 	 * If we already have ag/fs metadata to repair from previous phases,
 	 * we would rather not try to repair file metadata until we've tried
@@ -338,7 +343,7 @@ phase3_func(
 			ictx.always_defer_repairs = true;
 	}
 
-	err = scrub_scan_all_inodes(ctx, scrub_inode, &ictx);
+	err = scrub_scan_all_inodes(ctx, scrub_inode, scan_flags, &ictx);
 	if (!err && ictx.aborted)
 		err = ECANCELED;
 	if (err)
diff --git a/scrub/phase5.c b/scrub/phase5.c
index e1d94f9a3568b1..69b1cae5c5e2c0 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -462,6 +462,9 @@ retry_deferred_inode(
 	unsigned int		flags = 0;
 	int			error;
 
+	if (ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_METADIR)
+		flags |= XFS_BULK_IREQ_METADIR;
+
 	error = -xfrog_bulkstat_single(&ctx->mnt, ino, flags, &bstat);
 	if (error == ENOENT) {
 		/* Directory is gone, mark it clear. */
@@ -772,7 +775,7 @@ _("Filesystem has errors, skipping connectivity checks."));
 
 	pthread_mutex_init(&ncs.lock, NULL);
 
-	ret = scrub_scan_all_inodes(ctx, check_inode_names, &ncs);
+	ret = scrub_scan_all_inodes(ctx, check_inode_names, 0, &ncs);
 	if (ret)
 		goto out_lock;
 	if (ncs.aborted) {
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 54d21820a722a6..e4f26e7f1dd93e 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -578,7 +578,7 @@ report_all_media_errors(
 	}
 
 	/* Scan for unlinked files. */
-	return scrub_scan_all_inodes(ctx, report_inode_loss, vs);
+	return scrub_scan_all_inodes(ctx, report_inode_loss, 0, vs);
 }
 
 /* Schedule a read-verify of a (data block) extent. */

