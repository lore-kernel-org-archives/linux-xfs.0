Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA3623C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881260; cv=none; b=l9hZRo8Gebtlun7EGEjWTIdiiNekZpbxx/Znyx/N0fDA4PwSfFWngdevv2hlEizm45O+ATWPZcM64s7C2XAgbbAotZgVKrIipVF63GgOrafilGrvLNBK5jQmbrEN9tJJtIOkteYqXt8GjO0Sypcl6uU6wST4TGfswjZYM3XiLAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881260; c=relaxed/simple;
	bh=bLof78tYdk+S1R2T0t5UONSbz4MfPZWfxtIfbZ0gmeE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nmD1xJkvZBeiiEtFLiktK2yrQwde3LlEVBqVkieq0BoxwCPd81JJ7u/mtKmrXLcjsgk3xPmUtM3AGFXzRYvJiqO9p9E8EEedDgA1l6gdTtp/uJ6NhtjLsna/K7KB3jgJJC/te3GsTr3ZkBb7I1wISY3d9ziRAnGCqEdK6O2G8pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k5Kk0cog; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5Kk0cog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F369C4CEDD;
	Thu,  6 Feb 2025 22:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881260;
	bh=bLof78tYdk+S1R2T0t5UONSbz4MfPZWfxtIfbZ0gmeE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k5Kk0cogS4EKbZ2hYznpAMFSTB3ETN/BYp8TiuhQ7Pu6WFqfs5ejSEs7X3e6E33F5
	 7NqcM8aGO4svzLZFZv99GjwYlKt24uq/MbzAX9/dHpcCusT5uFPBZ4IMgKktT8Hjdv
	 SfVr4X3pVyrMay9tZyRFTp8O25kjY0q3Ncga5rkBCYbrClnFqDV4eyeRDL6+WDaIxa
	 iDbwbSgKxAiqaQyMUquiZ497GsJ1b2pnfzPLOyId6Sgzavce8YpICm27TRGKYjtpp+
	 fxfqb7Wd6njvsItK8Ngst50PX0TxEbf58fsPTinFerQ+QgmYkKreFEh9DhL5crS3Lr
	 g8RgJxGSDPAKQ==
Date: Thu, 06 Feb 2025 14:34:19 -0800
Subject: [PATCH 14/17] xfs_scrub: don't blow away new inodes in
 bulkstat_single_step
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086274.2738568.5398591109789938783.stgit@frogsfrogsfrogs>
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

bulkstat_single_step has an ugly misfeature -- given the inumbers
record, it expects to find bulkstat data for those inodes, in the exact
order that they were specified in inumbers.  If a new inode is created
after inumbers but before bulkstat, bulkstat will return stat data for
that inode, only to have bulkstat_single_step obliterate it.  Then we
fail to scan that inode.

Instead, we should use the returned bulkstat array to compute a bitmask
of inodes that bulkstat had to have seen while it was walking the inobt.
An important detail is that any inode between the @ino parameter passed
to bulkstat and the last bulkstat record it returns was seen, even if no
bstat record was produced.

Any inode set in xi_allocmask but not set in the seen_mask is missing
and needs to be loaded.  Load bstat data for those inodes into the /end/
of the array so that we don't obliterate bstat data for a newly created
inode, then re-sort the array so we always scan in ascending inumber
order.

Cc: <linux-xfs@vger.kernel.org> # v5.18.0
Fixes: 245c72a6eeb720 ("xfs_scrub: balance inode chunk scan across CPUs")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/inodes.c |  144 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 123 insertions(+), 21 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 3b9026ce8fa2f4..ffdf0f2ae42c17 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -26,16 +26,41 @@
  *
  * This is a little more involved than repeatedly asking BULKSTAT for a
  * buffer's worth of stat data for some number of inodes.  We want to scan as
- * many of the inodes that the inobt thinks there are, including the ones that
- * are broken, but if we ask for n inodes starting at x, it'll skip the bad
- * ones and fill from beyond the range (x + n).
- *
- * Therefore, we ask INUMBERS to return one inobt chunk's worth of inode
- * bitmap information.  Then we try to BULKSTAT only the inodes that were
- * present in that chunk, and compare what we got against what INUMBERS said
- * was there.  If there's a mismatch, we know that we have an inode that fails
- * the verifiers but we can inject the bulkstat information to force the scrub
- * code to deal with the broken inodes.
+ * many of the inodes that the inobt thinks there are, so we use the INUMBERS
+ * ioctl to walk all the inobt records in the filesystem and spawn a worker to
+ * bulkstat and iterate.  The worker starts with an inumbers record that can
+ * look like this:
+ *
+ * {startino = S, allocmask = 0b11011}
+ *
+ * Given a starting inumber S and count C=64, bulkstat will return a sorted
+ * array of stat information.  The bs_ino of those array elements can look like
+ * any of the following:
+ *
+ * 0. [S, S+1, S+3, S+4]
+ * 1. [S+e, S+e+1, S+e+3, S+e+4, S+e+C+1...], where e >= 0
+ * 2. [S+e+n], where n >= 0
+ * 3. []
+ * 4. [], errno == EFSCORRUPTED
+ *
+ * We know that bulkstat scanned the entire inode range between S and bs_ino of
+ * the last array element, even though it only fills out an array element for
+ * allocated inodes.  Therefore, we can say in cases 0-2 that S was filled,
+ * even if there is no bstat[] record for S.  In turn, we can create a bitmask
+ * of inodes that we have seen, and set bits 0 through (bstat[-1].bs_ino - S),
+ * being careful not to set any bits past S+C.
+ *
+ * In case (0) we find that seen mask matches the inumber record
+ * exactly, so the caller can walk the stat records and move on.  In case (1)
+ * this is also true, but we must be careful to reduce the array length to
+ * avoid scanning inodes that are not in the inumber chunk.  In case (3) we
+ * conclude that there were no inodes left to scan and terminate.
+ *
+ * Inodes that are set in the allocmask but not set in the seen mask are the
+ * corrupt inodes.  For each of these cases, we try to populate the bulkstat
+ * array one inode at a time.  If the kernel returns a matching record we can
+ * use it; if instead we receive an error, we synthesize enough of a record
+ * to be able to run online scrub by handle.
  *
  * If the iteration function returns ESTALE, that means that the inode has
  * been deleted and possibly recreated since the BULKSTAT call.  We wil
@@ -43,6 +68,57 @@
  * the staleness as an error.
  */
 
+/*
+ * Return the inumber of the highest inode in the bulkstat data, assuming the
+ * records are sorted in inumber order.
+ */
+static inline uint64_t last_bstat_ino(const struct xfs_bulkstat_req *b)
+{
+	return b->hdr.ocount ? b->bulkstat[b->hdr.ocount - 1].bs_ino : 0;
+}
+
+/*
+ * Deduce the bitmask of the inodes in inums that were seen by bulkstat.  If
+ * the inode is present in the bstat array this is trivially true; or if it is
+ * not in the array but higher inumbers are present, then it was freed.
+ */
+static __u64
+seen_mask_from_bulkstat(
+	const struct xfs_inumbers	*inums,
+	__u64				breq_startino,
+	const struct xfs_bulkstat_req	*breq)
+{
+	const __u64			limit_ino =
+		inums->xi_startino + LIBFROG_BULKSTAT_CHUNKSIZE;
+	const __u64			last = last_bstat_ino(breq);
+	__u64				ret = 0;
+	int				i, maxi;
+
+	/* Ignore the bulkstat results if they don't cover inumbers */
+	if (breq_startino > limit_ino || last < inums->xi_startino)
+		return 0;
+
+	maxi = min(LIBFROG_BULKSTAT_CHUNKSIZE, last - inums->xi_startino + 1);
+	for (i = breq_startino - inums->xi_startino; i < maxi; i++)
+		ret |= 1ULL << i;
+
+	return ret;
+}
+
+#define cmp_int(l, r)		((l > r) - (l < r))
+
+/* Compare two bulkstat records by inumber. */
+static int
+compare_bstat(
+	const void		*a,
+	const void		*b)
+{
+	const struct xfs_bulkstat *ba = a;
+	const struct xfs_bulkstat *bb = b;
+
+	return cmp_int(ba->bs_ino, bb->bs_ino);
+}
+
 /*
  * Run bulkstat on an entire inode allocation group, then check that we got
  * exactly the inodes we expected.  If not, load them one at a time (or fake
@@ -54,10 +130,10 @@ bulkstat_for_inumbers(
 	const struct xfs_inumbers	*inumbers,
 	struct xfs_bulkstat_req		*breq)
 {
-	struct xfs_bulkstat		*bstat = breq->bulkstat;
-	struct xfs_bulkstat		*bs;
+	struct xfs_bulkstat		*bs = NULL;
 	const uint64_t			limit_ino =
 		inumbers->xi_startino + LIBFROG_BULKSTAT_CHUNKSIZE;
+	uint64_t			seen_mask = 0;
 	int				i;
 	int				error;
 
@@ -66,8 +142,12 @@ bulkstat_for_inumbers(
 	/* First we try regular bulkstat, for speed. */
 	breq->hdr.ino = inumbers->xi_startino;
 	error = -xfrog_bulkstat(&ctx->mnt, breq);
-	if (!error && !breq->hdr.ocount)
-		return;
+	if (!error) {
+		if (!breq->hdr.ocount)
+			return;
+		seen_mask |= seen_mask_from_bulkstat(inumbers,
+					inumbers->xi_startino, breq);
+	}
 
 	/*
 	 * Bulkstat might return inodes beyond xi_startino + CHUNKSIZE.  Reduce
@@ -80,18 +160,33 @@ bulkstat_for_inumbers(
 	}
 
 	/*
-	 * Check each of the stats we got back to make sure we got the inodes
-	 * we asked for.
+	 * Walk the xi_allocmask looking for set bits that aren't present in
+	 * the fill mask.  For each such inode, fill the entries at the end of
+	 * the array with stat information one at a time, synthesizing them if
+	 * necessary.  At this point, (xi_allocmask & ~seen_mask) should be the
+	 * corrupt inodes.
 	 */
-	for (i = 0, bs = bstat; i < LIBFROG_BULKSTAT_CHUNKSIZE; i++) {
+	for (i = 0; i < LIBFROG_BULKSTAT_CHUNKSIZE; i++) {
+		/*
+		 * Don't single-step if inumbers said it wasn't allocated or
+		 * bulkstat actually filled it.
+		 */
 		if (!(inumbers->xi_allocmask & (1ULL << i)))
 			continue;
-		if (bs->bs_ino == inumbers->xi_startino + i) {
-			bs++;
+		if (seen_mask & (1ULL << i))
 			continue;
-		}
 
-		/* Load the one inode. */
+		assert(breq->hdr.ocount < LIBFROG_BULKSTAT_CHUNKSIZE);
+
+		if (!bs)
+			bs = &breq->bulkstat[breq->hdr.ocount];
+
+		/*
+		 * Didn't get desired stat data and we've hit the end of the
+		 * returned data.  We can't distinguish between the inode being
+		 * freed vs. the inode being to corrupt to load, so try a
+		 * bulkstat single to see if we can load the inode.
+		 */
 		error = -xfrog_bulkstat_single(&ctx->mnt,
 				inumbers->xi_startino + i, breq->hdr.flags, bs);
 		if (error || bs->bs_ino != inumbers->xi_startino + i) {
@@ -99,8 +194,15 @@ bulkstat_for_inumbers(
 			bs->bs_ino = inumbers->xi_startino + i;
 			bs->bs_blksize = ctx->mnt_sv.f_frsize;
 		}
+
+		breq->hdr.ocount++;
 		bs++;
 	}
+
+	/* If we added any entries, re-sort the array. */
+	if (bs)
+		qsort(breq->bulkstat, breq->hdr.ocount,
+				sizeof(struct xfs_bulkstat), compare_bstat);
 }
 
 /* BULKSTAT wrapper routines. */

