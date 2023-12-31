Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5F7D301
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPzWFFX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94262C433C8;
	Sun, 31 Dec 2023 23:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065907;
	bh=mkpgEJwVOnRROSfvNFu1E4O78fSYXVOXDNrfmsFSWHY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mPzWFFX7pBC4xveSkNDIa/6S1J7SX3NDNt+ocANvCvbKYPBlkgex7B+kC7s6u72Kl
	 APX5m6xNFHWr4qelykSAUrJhFp83mA5qrP4AoVNxB5NuOJYbBLWEDW5Ap+iiLDJ7vV
	 6uW1MLBlWTuKabr+iHxT1wy0LkHt+Pyuh9wO04RN7/gOSkNglIT+R1mOxR1QtGGcdw
	 mobxM8Wuk/QTq8TmjM08QwLlTLZL8gYPZKbNiAgc7T7yarq3m3W6LSt16liBUPXzgy
	 8cUAIGgLTaQ4fBkoG3tTKs9TuxbPNm5bbZqMfT7akdeC2P9m//ieMK7GgbJTSgj7Pt
	 vvjNc7KUhX1gA==
Date: Sun, 31 Dec 2023 15:38:27 -0800
Subject: [PATCH 34/58] xfs_scrub: scan metadata directories during phase 3
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010401.1809361.8188720179188151580.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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
index 16c79cf495c..3fe759e8f48 100644
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
index 9447fb56aa6..7a0b275e575 100644
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
index 046a42c1da8..c90da784394 100644
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
index f6c295c64ad..b922f53398e 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -455,6 +455,9 @@ retry_deferred_inode(
 	unsigned int		flags = 0;
 	int			error;
 
+	if (ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_METADIR)
+		flags |= XFS_BULK_IREQ_METADIR;
+
 	error = -xfrog_bulkstat_single(&ctx->mnt, ino, flags, &bstat);
 	if (error == ENOENT) {
 		/* Directory is gone, mark it clear. */
@@ -765,7 +768,7 @@ _("Filesystem has errors, skipping connectivity checks."));
 
 	pthread_mutex_init(&ncs.lock, NULL);
 
-	ret = scrub_scan_all_inodes(ctx, check_inode_names, &ncs);
+	ret = scrub_scan_all_inodes(ctx, check_inode_names, 0, &ncs);
 	if (ret)
 		goto out_lock;
 	if (ncs.aborted) {
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 66ca57507e9..b95966c1f82 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -558,7 +558,7 @@ report_all_media_errors(
 	}
 
 	/* Scan for unlinked files. */
-	return scrub_scan_all_inodes(ctx, report_inode_loss, vs);
+	return scrub_scan_all_inodes(ctx, report_inode_loss, 0, vs);
 }
 
 /* Schedule a read-verify of a (data block) extent. */

