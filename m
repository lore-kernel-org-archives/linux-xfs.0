Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCCE175AD
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 03:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719978748; cv=none; b=ThKuWn2SkKNeRI/oAGTmTZeN4nNZalMxv6OC+3cj9eHl+3SR9hiT6HlpzX3eIAYhVwXhpD0WrEIjsvO5CYuoq+tQf13fHASoeK4T5EvUb98b77DYx0Pb1oGxhH9V462KokhaDSRLtGCsCt1VyC5ae3UFr4bAnfuXs51pyQUai+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719978748; c=relaxed/simple;
	bh=PVtpI0Plope7Jb5P1ZrW7uB9TKClkOnJpiuMkNGGMDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NTnPKJvTUMJcBY/8hMu6UF1nuPxS2FCKLU/o9GVw9RtxuM7mNEoX9Tn/KLWGGt8bz6gdnyFnz6aZVs/knlTSSSJTrb8pBPR70us6uhHUHosgtH9t7ytbLOgd+wPUuEWbxgKq7FwHxQBnZpVtKe486ZGJDiH8/fN7vZtJjv419vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gk3AuHy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gk3AuHy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B11C32781;
	Wed,  3 Jul 2024 03:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719978748;
	bh=PVtpI0Plope7Jb5P1ZrW7uB9TKClkOnJpiuMkNGGMDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gk3AuHy4mh+XbXvV0mYC4P6EaZuYcpLfG417YfcqFwmvix6l7QTFgWmTH0Z7MsKm9
	 EynbXm26jO3Uig+30YwyAfv6LUOokRkRDJ/igBL9VWIHMfwnPNsG40IDxQCnVEulOL
	 G8zuwxvx6Q91oeWKMDEZiWkDgmbXCLRDYgTpigGA4d18O94j7cezv0Zce6U8ez3lSr
	 NLe15JqgwNTIdx3LPUMEsVCMejxz5TKbcesKen5Mb/rFNyioRM88GWsq6swKKWxINR
	 /E+IvthSl5EXucV59bdIRYQ+2mELSkFqvIP4H+xXXq3SxKqKMkimMJKXmh8MdJ8ONs
	 RlgqCQADr1v8A==
Date: Tue, 2 Jul 2024 20:52:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: [PATCH v30.7.1 7/8] xfs_scrub: improve responsiveness while trimming
 the filesystem
Message-ID: <20240703035227.GX612460@frogsfrogsfrogs>
References: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs>
 <171988118237.2007602.9576505614542313879.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988118237.2007602.9576505614542313879.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

On a 10TB filesystem where the free space in each AG is heavily
fragmented, I noticed some very high runtimes on a FITRIM call for the
entire filesystem.  xfs_scrub likes to report progress information on
each phase of the scrub, which means that a strace for the entire
filesystem:

ioctl(3, FITRIM, {start=0x0, len=10995116277760, minlen=0}) = 0 <686.209839>

shows that scrub is uncommunicative for the entire duration.  We can't
report any progress for the duration of the call, and the program is not
responsive to signals.  Reducing the size of the FITRIM requests to a
single AG at a time produces lower times for each individual call, but
even this isn't quite acceptable, because the time between progress
reports are still very high:

Strace for the first 4x 1TB AGs looks like (2):
ioctl(3, FITRIM, {start=0x0, len=1099511627776, minlen=0}) = 0 <68.352033>
ioctl(3, FITRIM, {start=0x10000000000, len=1099511627776, minlen=0}) = 0 <68.760323>
ioctl(3, FITRIM, {start=0x20000000000, len=1099511627776, minlen=0}) = 0 <67.235226>
ioctl(3, FITRIM, {start=0x30000000000, len=1099511627776, minlen=0}) = 0 <69.465744>

I then had the idea to limit the length parameter of each call to a
smallish amount (~11GB) so that we could report progress relatively
quickly, but much to my surprise, each FITRIM call still took ~68
seconds!

Unfortunately, the by-length fstrim implementation handles this poorly
because it walks the entire free space by length index (cntbt), which is
a very inefficient way to walk a subset of an AG when the free space is
fragmented.

To fix that, I created a second implementation in the kernel that will
walk the bnobt and perform the trims in block number order.  This
algorithm constrains the amount of btree scanning to something
resembling the range passed in, which reduces the amount of time it
takes to respond to a signal.

Therefore, break up the FITRIM calls so they don't scan more than 11GB
of space at a time.  Break the calls up by AG so that each call only has
to take one AGF per call, because each AG that we traverse causes a log
force.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |  102 ++++++++++++++++++++++++++++++++++++++++++++++----------
 scrub/vfs.c    |   10 ++++-
 scrub/vfs.h    |    2 +
 3 files changed, 91 insertions(+), 23 deletions(-)

diff --git a/scrub/phase8.c b/scrub/phase8.c
index 75400c968595..e35bf11bf329 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -45,27 +45,90 @@ fstrim_ok(
 	return true;
 }
 
+/*
+ * Limit the amount of fstrim scanning that we let the kernel do in a single
+ * call so that we can implement decent progress reporting and CPU resource
+ * control.  Pick a prime number of gigabytes for interest.
+ */
+#define FSTRIM_MAX_BYTES	(11ULL << 30)
+
+/* Trim a certain range of the filesystem. */
+static int
+fstrim_fsblocks(
+	struct scrub_ctx	*ctx,
+	uint64_t		start_fsb,
+	uint64_t		fsbcount)
+{
+	uint64_t		start = cvt_off_fsb_to_b(&ctx->mnt, start_fsb);
+	uint64_t		len = cvt_off_fsb_to_b(&ctx->mnt, fsbcount);
+	int			error;
+
+	while (len > 0) {
+		uint64_t	run;
+
+		run = min(len, FSTRIM_MAX_BYTES);
+
+		error = fstrim(ctx, start, run);
+		if (error == EOPNOTSUPP) {
+			/* Pretend we finished all the work. */
+			progress_add(len);
+			return 0;
+		}
+		if (error) {
+			char		descr[DESCR_BUFSZ];
+
+			snprintf(descr, sizeof(descr) - 1,
+					_("fstrim start 0x%llx run 0x%llx"),
+					(unsigned long long)start,
+					(unsigned long long)run);
+			str_liberror(ctx, error, descr);
+			return error;
+		}
+
+		progress_add(run);
+		len -= run;
+		start += run;
+	}
+
+	return 0;
+}
+
+/* Trim each AG on the data device. */
+static int
+fstrim_datadev(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_fsop_geom	*geo = &ctx->mnt.fsgeom;
+	uint64_t		fsbno;
+	int			error;
+
+	for (fsbno = 0; fsbno < geo->datablocks; fsbno += geo->agblocks) {
+		uint64_t	fsbcount;
+
+		/*
+		 * Make sure that trim calls do not cross AG boundaries so that
+		 * the kernel only performs one log force (and takes one AGF
+		 * lock) per call.
+		 */
+		progress_add(geo->blocksize);
+		fsbcount = min(geo->datablocks - fsbno, geo->agblocks);
+		error = fstrim_fsblocks(ctx, fsbno, fsbcount);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
 /* Trim the filesystem, if desired. */
 int
 phase8_func(
 	struct scrub_ctx	*ctx)
 {
-	int			error;
-
 	if (!fstrim_ok(ctx))
 		return 0;
 
-	error = fstrim(ctx);
-	if (error == EOPNOTSUPP)
-		return 0;
-
-	if (error) {
-		str_liberror(ctx, error, _("fstrim"));
-		return error;
-	}
-
-	progress_add(1);
-	return 0;
+	return fstrim_datadev(ctx);
 }
 
 /* Estimate how much work we're going to do. */
@@ -76,12 +139,13 @@ phase8_estimate(
 	unsigned int		*nr_threads,
 	int			*rshift)
 {
-	*items = 0;
-
-	if (fstrim_ok(ctx))
-		*items = 1;
-
+	if (fstrim_ok(ctx)) {
+		*items = cvt_off_fsb_to_b(&ctx->mnt,
+				ctx->mnt.fsgeom.datablocks);
+	} else {
+		*items = 0;
+	}
 	*nr_threads = 1;
-	*rshift = 0;
+	*rshift = 30; /* GiB */
 	return 0;
 }
diff --git a/scrub/vfs.c b/scrub/vfs.c
index bcfd4f42ca8b..cc958ba9438e 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -298,11 +298,15 @@ struct fstrim_range {
 /* Call FITRIM to trim all the unused space in a filesystem. */
 int
 fstrim(
-	struct scrub_ctx	*ctx)
+	struct scrub_ctx	*ctx,
+	uint64_t		start,
+	uint64_t		len)
 {
-	struct fstrim_range	range = {0};
+	struct fstrim_range	range = {
+		.start		= start,
+		.len		= len,
+	};
 
-	range.len = ULLONG_MAX;
 	if (ioctl(ctx->mnt.fd, FITRIM, &range) == 0)
 		return 0;
 	if (errno == EOPNOTSUPP || errno == ENOTTY)
diff --git a/scrub/vfs.h b/scrub/vfs.h
index a8a4d72e290a..1af8d80d1de6 100644
--- a/scrub/vfs.h
+++ b/scrub/vfs.h
@@ -24,6 +24,6 @@ typedef int (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
 int scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
 		scan_fs_tree_dirent_fn dirent_fn, void *arg);
 
-int fstrim(struct scrub_ctx *ctx);
+int fstrim(struct scrub_ctx *ctx, uint64_t start, uint64_t len);
 
 #endif /* XFS_SCRUB_VFS_H_ */
