Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69F114D717
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528676; cv=none; b=G0ybqgZJzRwXC6AR72bFL3Z2RKOGJs7CUUNsHzwfh1qd3kfY7zS/A8o99kpJvNrBDfIH8VCAhnXakleow3ifjenDfQH+II8BKv9hzqGetR/qUxb1iGpZzcJoe0dW1MweVlWz3URuicbJJb01MQ48JZnsxvCp6KNKkiKEVEyJLug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528676; c=relaxed/simple;
	bh=uDv0CKV+fUC4jzdg/pOua9cADhzuUkNm9FoZpVWdcYE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kSpMfJDmzSZoMzbIboWdClPpYBb1ZeiFKorwHlvlfv5t/+jj1XYLcUXUV7jiP9xJ2m8whJZDAGCXreFElPVwL7J7S2f+BzlODxvNVDWJsyTdJV8Wdd99bCPvddPI6Zik23ZyAEL0p8pGU1zVDReJYniRYjPb86ktwxqB6TZZ1io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WZ+7rjxl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WZ+7rjxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF94C4CED1;
	Fri,  6 Dec 2024 23:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528676;
	bh=uDv0CKV+fUC4jzdg/pOua9cADhzuUkNm9FoZpVWdcYE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WZ+7rjxlWgK8bU+PkWBdOHORsoZbNlwCXaknfAG8LinIEQP6t0Z57lALqL0CRfkCn
	 JzlDTyKduLHsAI/L3wNHExcGrnk49+A3hZ0e+Jdqk32MObhucIuuq5XKGVXGtmuy4f
	 f5bgIeFb5bigi857WqCLi3wU6tA4p9hI4vFwzzXi1cuHyZkQbRY8u2kmfQinvbcdYr
	 x6ab6sF91ES2duHCcdUEe1UBeYeL+vWaEXoGM/SKiC019Baf5tQ60U33xL8ZQFqWVO
	 S6xFx+pEeRpILuZiKQoQz594Ay2wSQ3mqQdELP24txBgNWX+dkWDJ4817JhdycRw5l
	 SwwYjzffOL1RQ==
Date: Fri, 06 Dec 2024 15:44:36 -0800
Subject: [PATCH 19/41] xfs_scrub: scan metadata directories during phase 3
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748528.122992.10939627158010208077.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
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

