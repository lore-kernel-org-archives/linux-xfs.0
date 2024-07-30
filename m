Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9300C10E3
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301861; cv=none; b=s0Q6vXgSP9c+aFsyeGfmMqgYoO/gIzEX3g7AzfrkLPo2Hqd8iv5WY7BXSgrV2NMi/kSDTPfpkiYlQmGbmjaxMbWxSTwc3P5dj98jSLmeaEQ8lT9x9PbOaQfze2zt/WvNx2utKns35xrT6THol878B04gALGVc3qZ0OBYVFtIZms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301861; c=relaxed/simple;
	bh=8XChWzotnXNdjHNOruyLXW2cI9kJWIMBSjU/gI11kd0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G8ihJIZL4tpyXDstpG4g+PUE6k992X8pw1GgxERG1Y0tgDvMeafTS+RC0lzB3GLwBL2fWzaM2KkYs5XD+P0ODha7Gpeffm1VYhxtrfcWx3UYTy52JXhidZ4BdOKKkVYkhpGwglSWhZmP+twSNpvU9Z8RBXBdBfP0FhbFWprdmUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EmrW7JKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EmrW7JKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D67C32786;
	Tue, 30 Jul 2024 01:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301861;
	bh=8XChWzotnXNdjHNOruyLXW2cI9kJWIMBSjU/gI11kd0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EmrW7JKNqrlS/kAtg8mWP6nKn9tlVSvdjvAK9SzHFSzNXIpuaDRD/9igMvjyOkoQx
	 gtNJC0xtJH/G3WIXfaPbtXKdwCWRNUqXCClKJljNpxIqFFR4XVpxTUFMoOlAIfAlq0
	 r0gtMPBn4pz2eCKyiv028i0UWUJeZkWp1gSYQsYjbvuuVoC7YH9Zmy0FC6KgisBA/o
	 XP7cOmrwCKaqxDhguEHpC6zNidbJ8KAJXSden1ib7jxcFDWAEgETo2rt7JVAYcVg9P
	 S2CPGBp6/bDKYnki1NHyTNJ3odMefxoTbVYfhzYm0JA4GAOFxrHzO2c9XraFgXoLiv
	 hR4DyLWb38OiA==
Date: Mon, 29 Jul 2024 18:11:00 -0700
Subject: [PATCH 7/7] xfs_scrub: improve responsiveness while trimming the
 filesystem
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229848138.1349330.4764336698265605990.stgit@frogsfrogsfrogs>
In-Reply-To: <172229848026.1349330.12889405227098722037.stgit@frogsfrogsfrogs>
References: <172229848026.1349330.12889405227098722037.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase8.c |  102 ++++++++++++++++++++++++++++++++++++++++++++++----------
 scrub/vfs.c    |   10 ++++-
 scrub/vfs.h    |    2 +
 3 files changed, 91 insertions(+), 23 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index 75400c968..e35bf11bf 100644
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
index bcfd4f42c..cc958ba94 100644
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
index a8a4d72e2..1af8d80d1 100644
--- a/scrub/vfs.h
+++ b/scrub/vfs.h
@@ -24,6 +24,6 @@ typedef int (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
 int scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
 		scan_fs_tree_dirent_fn dirent_fn, void *arg);
 
-int fstrim(struct scrub_ctx *ctx);
+int fstrim(struct scrub_ctx *ctx, uint64_t start, uint64_t len);
 
 #endif /* XFS_SCRUB_VFS_H_ */

