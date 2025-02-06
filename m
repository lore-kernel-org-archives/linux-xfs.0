Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CE123C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881152; cv=none; b=Xw0YulRi/uKtl4ULZB34tx0yj/I6DQwjxjsmdc2T5TwVvuHrZJxXPHvlPkKO0lskkVdQ52Z+16IddLS6MslMv6m6aMVEJ/dHywGbIEHviQxfaiqXo2ut4HTblqMh12Kx8JGnsUdb4RTahfiLWo2ft2MHrDTcIhVnOdEInRob4Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881152; c=relaxed/simple;
	bh=9VTlwDlEVEUXePinz0+P5OAfQ5luKF96OijHvaxE47k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IEu80qq+GyWjQFoSuuKbTscykhXZp27nAlcf+RfRSNdxYVQdVljFgZEh0hQzE9SvHSJtH1PX0R8NkilgQfudSri9HVwhW6Agc+/Sw5aFdTkZwNgtph7QsEGoHIRWIh1aKrFNfKyFOjn94TOTvUEhtB2tQtZmA3AG29X8YJ+s76k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cbOgC3EO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cbOgC3EO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC57FC4CEDD;
	Thu,  6 Feb 2025 22:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881151;
	bh=9VTlwDlEVEUXePinz0+P5OAfQ5luKF96OijHvaxE47k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cbOgC3EOpSnzDEBQ273rEECR291vr1WTEQfMVjA8wBtkuQ4bf1zSR+L0uB19CB1pD
	 NDIylY+DNTFm/73EtN9MtTYioQnoTDGSRjaMz6UPZlAAqBCahooyUePHF7DvSG8wEH
	 b14NZDOFcdmZL6L0boFudKJJVioV88xmnMeME1vA+lnY+C7T60m2Yzcyy6MUcBCsCi
	 oD/O4O/QOJk78i8XTeRgTmYhAjOc/L4307dYPYdX5W4xJeAYqZBE5H9w/A+ds9Qh5/
	 I5j+nSFp17zqwxqN4Ud/8nhG6dHBArcDFP6Pgt1OgLh+5oJvpj6h6on7LPyxMb2hxe
	 2gJcohH+2HQlA==
Date: Thu, 06 Feb 2025 14:32:30 -0800
Subject: [PATCH 07/17] xfs_scrub: remove flags argument from
 scrub_scan_all_inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086167.2738568.69850505985022498.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that there's only one caller of scrub_scan_all_inodes, remove the
single defined flag because it can set the METADIR bulkstat flag if
needed.  Clarify in the documentation that this is a special purpose
inode iterator that picks up things that don't normally happen.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/inodes.c |   23 ++++++++++-------------
 scrub/inodes.h |    6 ++----
 scrub/phase3.c |    7 +------
 3 files changed, 13 insertions(+), 23 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 58969131628f8f..c32dfb624e3e95 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -57,7 +57,6 @@ bulkstat_for_inumbers(
 {
 	struct xfs_bulkstat	*bstat = breq->bulkstat;
 	struct xfs_bulkstat	*bs;
-	unsigned int		flags = 0;
 	int			i;
 	int			error;
 
@@ -72,9 +71,6 @@ bulkstat_for_inumbers(
 			 strerror_r(error, errbuf, DESCR_BUFSZ));
 	}
 
-	if (breq->hdr.flags & XFS_BULK_IREQ_METADIR)
-		flags |= XFS_BULK_IREQ_METADIR;
-
 	/*
 	 * Check each of the stats we got back to make sure we got the inodes
 	 * we asked for.
@@ -89,7 +85,7 @@ bulkstat_for_inumbers(
 
 		/* Load the one inode. */
 		error = -xfrog_bulkstat_single(&ctx->mnt,
-				inumbers->xi_startino + i, flags, bs);
+				inumbers->xi_startino + i, breq->hdr.flags, bs);
 		if (error || bs->bs_ino != inumbers->xi_startino + i) {
 			memset(bs, 0, sizeof(struct xfs_bulkstat));
 			bs->bs_ino = inumbers->xi_startino + i;
@@ -105,7 +101,6 @@ struct scan_inodes {
 	scrub_inode_iter_fn	fn;
 	void			*arg;
 	unsigned int		nr_threads;
-	unsigned int		flags;
 	bool			aborted;
 };
 
@@ -139,6 +134,7 @@ ichunk_to_bulkstat(
 
 static inline int
 alloc_ichunk(
+	struct scrub_ctx	*ctx,
 	struct scan_inodes	*si,
 	uint32_t		agno,
 	uint64_t		startino,
@@ -164,7 +160,9 @@ alloc_ichunk(
 
 	breq = ichunk_to_bulkstat(ichunk);
 	breq->hdr.icount = LIBFROG_BULKSTAT_CHUNKSIZE;
-	if (si->flags & SCRUB_SCAN_METADIR)
+
+	/* Scan the metadata directory tree too. */
+	if (ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_METADIR)
 		breq->hdr.flags |= XFS_BULK_IREQ_METADIR;
 
 	*ichunkp = ichunk;
@@ -302,7 +300,7 @@ scan_ag_inumbers(
 
 	descr_set(&dsc, &agno);
 
-	error = alloc_ichunk(si, agno, 0, &ichunk);
+	error = alloc_ichunk(ctx, si, agno, 0, &ichunk);
 	if (error)
 		goto err;
 	ireq = ichunk_to_inumbers(ichunk);
@@ -355,7 +353,7 @@ scan_ag_inumbers(
 		}
 
 		if (!ichunk) {
-			error = alloc_ichunk(si, agno, nextino, &ichunk);
+			error = alloc_ichunk(ctx, si, agno, nextino, &ichunk);
 			if (error)
 				goto err;
 		}
@@ -375,19 +373,18 @@ scan_ag_inumbers(
 }
 
 /*
- * Scan all the inodes in a filesystem.  On error, this function will log
- * an error message and return -1.
+ * Scan all the inodes in a filesystem, including metadata directory files and
+ * broken files.  On error, this function will log an error message and return
+ * -1.
  */
 int
 scrub_scan_all_inodes(
 	struct scrub_ctx	*ctx,
 	scrub_inode_iter_fn	fn,
-	unsigned int		flags,
 	void			*arg)
 {
 	struct scan_inodes	si = {
 		.fn		= fn,
-		.flags		= flags,
 		.arg		= arg,
 		.nr_threads	= scrub_nproc_workqueue(ctx),
 	};
diff --git a/scrub/inodes.h b/scrub/inodes.h
index 99b78fa1f76515..d68e94eb216895 100644
--- a/scrub/inodes.h
+++ b/scrub/inodes.h
@@ -17,11 +17,9 @@
 typedef int (*scrub_inode_iter_fn)(struct scrub_ctx *ctx,
 		struct xfs_handle *handle, struct xfs_bulkstat *bs, void *arg);
 
-/* Return metadata directories too. */
-#define SCRUB_SCAN_METADIR	(1 << 0)
-
+/* Scan every file in the filesystem, including metadir and corrupt ones. */
 int scrub_scan_all_inodes(struct scrub_ctx *ctx, scrub_inode_iter_fn fn,
-		unsigned int flags, void *arg);
+		void *arg);
 
 /* Scan all user-created files in the filesystem. */
 int scrub_scan_user_files(struct scrub_ctx *ctx, scrub_inode_iter_fn fn,
diff --git a/scrub/phase3.c b/scrub/phase3.c
index c90da78439425a..046a42c1da8beb 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -312,7 +312,6 @@ phase3_func(
 	struct scrub_inode_ctx	ictx = { .ctx = ctx };
 	uint64_t		val;
 	xfs_agnumber_t		agno;
-	unsigned int		scan_flags = 0;
 	int			err;
 
 	err = -ptvar_alloc(scrub_nproc(ctx), sizeof(struct action_list),
@@ -329,10 +328,6 @@ phase3_func(
 		goto out_ptvar;
 	}
 
-	/* Scan the metadata directory tree too. */
-	if (ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_METADIR)
-		scan_flags |= SCRUB_SCAN_METADIR;
-
 	/*
 	 * If we already have ag/fs metadata to repair from previous phases,
 	 * we would rather not try to repair file metadata until we've tried
@@ -343,7 +338,7 @@ phase3_func(
 			ictx.always_defer_repairs = true;
 	}
 
-	err = scrub_scan_all_inodes(ctx, scrub_inode, scan_flags, &ictx);
+	err = scrub_scan_all_inodes(ctx, scrub_inode, &ictx);
 	if (!err && ictx.aborted)
 		err = ECANCELED;
 	if (err)

