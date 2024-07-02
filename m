Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF8E4C8B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882157; cv=none; b=c3m2tjLcNbSzh4O02Vxuy4ZeBV9HSDc3jRsv6JZXlewNIOkNZOCPTYkxSnaVacgkhwfx9vK6CzteKPYD1jeUO/MbhOleaMzl98XP+TMxeRexexfXW5TlBLPYRIHby/4T55qdKUAN78ixauNqUeZQ+lVTbk7HLqYo/phxPkG7kI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882157; c=relaxed/simple;
	bh=l2Zn3oyirNmNSuwJp95Z7HkdP56rQZIrg26yVwmqY0Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kkGL/gTEaoMONoOq/aEeMYeF8j7l4Ad4prFLvBbHCTz0BRRYlGb/ZFQcQggJFQgUaaiOzpuUjsoWZRxWp0p85UqEJOnQqdJYUC/q8VZyrLljOBJ/5VidFhkfh+o9OpJwRwmKsJT/Z6IWqvz7whgQEN7XyMjkLWXJSWy/tewEFCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QfEaPcEA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QfEaPcEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093AEC116B1;
	Tue,  2 Jul 2024 01:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882157;
	bh=l2Zn3oyirNmNSuwJp95Z7HkdP56rQZIrg26yVwmqY0Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QfEaPcEAUevKOkQAViaGXJu/+TGbzwcF7UzPxiXwkBiJkjxyU+ZUURHunsUUWzVqu
	 YJd8vjILHsdmRoakd6eqJzbt3mMG25yT1XUjwRhqFwpETdTy56OYwm+XmX/GIr73GI
	 lZ0gOMtAImJzDZC+akayEDlMcwcF4/58rWIWq76U83m5wHE3F4+Q6ihTlpSbRE/8hS
	 2Ej3HPF2e1327qDfiI9GLj/a9lxjin594eOmmnekngLCqUwVDq5zOSDpXLgxmviYCv
	 TD5ORcHQYPHOXxxVLjbwFfTbqih7AK/JZPnLrUDKSgMZ1AX/jBIEu/3ZfkfaHB5RaK
	 etujUt0udBOfA==
Date: Mon, 01 Jul 2024 18:02:36 -0700
Subject: [PATCH 7/8] xfs_scrub: don't trim the first agbno of each AG for
 better performance
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988118237.2007602.9576505614542313879.stgit@frogsfrogsfrogs>
In-Reply-To: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs>
References: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs>
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

shows that scrub is uncommunicative for the entire duration.  Reducing
the size of the FITRIM requests to a single AG at a time produces lower
times for each individual call, but even this isn't quite acceptable,
because the time between progress reports are still very high:

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
a very inefficient way to walk a subset of an AG.

Therefore, we created a second implementation that will walk the bnobt
and perform the trims in block number order.  This implementation avoids
the worst problems of the original code, though it lacks the desirable
attribute of freeing the biggest chunks first.

On the other hand, this second implementation will be much easier to
constrain the system call latency, and makes it much easier to report
fstrim progress to anyone who's running xfs_scrub.  Skip the first block
of each AG to ensure that we get the sub-AG algorithm.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++---------
 scrub/vfs.c    |   10 ++++++---
 scrub/vfs.h    |    2 +-
 3 files changed, 62 insertions(+), 14 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index 75400c968595..e5f5619a80b5 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -45,29 +45,73 @@ fstrim_ok(
 	return true;
 }
 
-/* Trim the filesystem, if desired. */
-int
-phase8_func(
-	struct scrub_ctx	*ctx)
+/* Trim a certain range of the filesystem. */
+static int
+fstrim_fsblocks(
+	struct scrub_ctx	*ctx,
+	uint64_t		start_fsb,
+	uint64_t		fsbcount)
 {
+	uint64_t		start = cvt_off_fsb_to_b(&ctx->mnt, start_fsb);
+	uint64_t		len = cvt_off_fsb_to_b(&ctx->mnt, fsbcount);
 	int			error;
 
-	if (!fstrim_ok(ctx))
-		return 0;
-
-	error = fstrim(ctx);
+	error = fstrim(ctx, start, len);
 	if (error == EOPNOTSUPP)
 		return 0;
-
 	if (error) {
-		str_liberror(ctx, error, _("fstrim"));
+		char		descr[DESCR_BUFSZ];
+
+		snprintf(descr, sizeof(descr) - 1,
+				_("fstrim start 0x%llx len 0x%llx"),
+				(unsigned long long)start,
+				(unsigned long long)len);
+		str_liberror(ctx, error, descr);
 		return error;
 	}
 
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
+		 * Skip the first block of each AG to ensure that we get the
+		 * partial-AG discard implementation.  This means that we can
+		 * report trim progress to userspace in units smaller than
+		 * entire AGs.
+		 */
+		fsbcount = min(geo->datablocks - (fsbno + 1), geo->agblocks - 1);
+		error = fstrim_fsblocks(ctx, fsbno + 1, fsbcount);
+		if (error)
+			return error;
+	}
+
 	progress_add(1);
 	return 0;
 }
 
+/* Trim the filesystem, if desired. */
+int
+phase8_func(
+	struct scrub_ctx	*ctx)
+{
+	if (!fstrim_ok(ctx))
+		return 0;
+
+	return fstrim_datadev(ctx);
+}
+
 /* Estimate how much work we're going to do. */
 int
 phase8_estimate(
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

