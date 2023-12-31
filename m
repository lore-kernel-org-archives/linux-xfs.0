Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1C0C13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ip4dtN4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF75C433C7;
	Sun, 31 Dec 2023 22:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063015;
	bh=0ht5OmFX3QmyILDP8MSE0UGuR7FaSBNu08HIuiCyZUU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ip4dtN4LVcfd4sWpMfpcqYP4l0Jr9pWE0zkya+VGvPwZtAxapcdMODGoYvydzD5So
	 H/9KfJXM7OJbAqueyhMPpD0NQ+ksIm/WHEScqsfptxw9YnFKvXGtZkxsaWgcxUaQ8O
	 VKur5SMpVBtrE2ouOQIj5ftwZOoDk56Kb0Jk9ijmydozV7K6QL+Ci1Oc1DxdIhVNBl
	 NiT7cCD5/aUzB2RMCTnOAaOkGXhDvc6Qcv+QmhlDM4JoO/G4MENxwjSa2pHSftYMFh
	 lyy0xf9fqTEkb5vN1zn9EEaytJxXON2Yr6dRK3OyXAI19AbfuSvB2BxejB4CX4NPy/
	 cJl8ZaDjjXiOQ==
Date: Sun, 31 Dec 2023 14:50:15 -0800
Subject: [PATCH 7/8] xfs_scrub: don't trim the first agbno of each AG for
 better performance
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405001142.1798752.5565677389390007777.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001045.1798752.4380751003208751209.stgit@frogsfrogsfrogs>
References: <170405001045.1798752.4380751003208751209.stgit@frogsfrogsfrogs>
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

XFS issues discard IOs while holding the free space btree and the AGF
buffers locked.  If the discard IOs are slow or the free space is
extremely fragmented, this can lead to long stalls for every other
thread trying to access that AG.  On a 10TB high performance flash
storage device with a severely fragmented free space btree in every AG,
this results in many threads tripping the hangcheck warnings while
waiting for the AGF.  This happens even after we've run fstrim a few
times and waited for the nvme namespace utilization counters to
stabilize.

Strace for the entire 10TB looks like:
ioctl(3, FITRIM, {start=0x0, len=10995116277760, minlen=0}) = 0 <686.209839>

Reducing the size of the FITRIM requests to a single AG at a time
produces lower times for each individual call, but even this isn't quite
acceptable, because the lock hold times are still high enough to cause
stall warnings:

Strace for the first 4x 1TB AGs looks like (2):
ioctl(3, FITRIM, {start=0x0, len=1099511627776, minlen=0}) = 0 <68.352033>
ioctl(3, FITRIM, {start=0x10000000000, len=1099511627776, minlen=0}) = 0 <68.760323>
ioctl(3, FITRIM, {start=0x20000000000, len=1099511627776, minlen=0}) = 0 <67.235226>
ioctl(3, FITRIM, {start=0x30000000000, len=1099511627776, minlen=0}) = 0 <69.465744>

The fstrim code has to synchronize discards with block allocations, so
we must hold the AGF lock while issuing discard IOs.  Breaking up the
calls into smaller start/len segments ought to reduce the lock hold time
and allow other threads a chance to make progress.  Unfortunately, the
current fstrim implementation handles this poorly because it walks the
entire free space by length index (cntbt) and it's not clear if we can
cycle the AGF periodically to reduce latency because there's no
less-than btree lookup.

The first solution I thought of was to limit latency by scanning parts
of an AG at a time, but this doesn't solve the stalling problem when the
free space is heavily fragmented because each sub-AG scan has to walk
the entire cntbt to find free space that fits within the given range.
In fact, this dramatically increases the runtime!

Ultimately, I forked the kernel implementations -- for full AG fstrims,
it still trims by length.  However, for a sub-AG scan, it will walk the
bnobt and perform the trims in block number order.  Since the cursor
has an obviously monotonically increasing value, it is easy to cycle the
AGF periodically to allow other threads to do work.  This implementation
avoids the worst problems of the original code, though it lacks the
desirable attribute of freeing the biggest chunks first.

This second algorithm is what we want for xfs_scrub, which generally
runs as a background service.  Skip the first block of each AG to ensure
that we get the sub-AG algorithm,

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++---------
 scrub/vfs.c    |   10 ++++++---
 scrub/vfs.h    |    2 +-
 3 files changed, 61 insertions(+), 14 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index 75400c96859..570083be9d8 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -45,29 +45,72 @@ fstrim_ok(
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
+		 * partial-AG discard implementation, which cycles the AGF lock
+		 * to prevent foreground threads from stalling.
+		 */
+		fsbcount = min(geo->datablocks - fsbno + 1, geo->agblocks);
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
index bcfd4f42ca8..cc958ba9438 100644
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
index a8a4d72e290..1af8d80d1de 100644
--- a/scrub/vfs.h
+++ b/scrub/vfs.h
@@ -24,6 +24,6 @@ typedef int (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
 int scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
 		scan_fs_tree_dirent_fn dirent_fn, void *arg);
 
-int fstrim(struct scrub_ctx *ctx);
+int fstrim(struct scrub_ctx *ctx, uint64_t start, uint64_t len);
 
 #endif /* XFS_SCRUB_VFS_H_ */

