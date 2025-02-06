Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6CC23C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881276; cv=none; b=aTVs/SAJKvI+0HFpH2f5D7clhulFipoj2O7/TWXci78da3tb5s5vJFCFm5nFmiv1CgtRhR0skuE+PkX77+ohYmdM5tzfy1rDScZLRgbFc0icckZSktUaPAJoeM4FXm+1yljpPWy/CeCfcH5IAimh/POYqUARN2RdeqLmJXzKsH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881276; c=relaxed/simple;
	bh=K+QiUzO24GNyuAZCg55P8Vwd8q2Ao1Mw+PKyDl27gCM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ut/bK8ARZvw0OHz1EEbfllR2pT2ZmpmfEBMDdHTLqm9gZaaP3VJ/9VHiyWOMxoyYPP238TUsPG5fp6xd5mOOrXxla3+X/R2mSdpiTOyKVm2AkeZhRu9D/rEbOheYQUMPa5w3mTPgo0LIFcjeOoaHUrIb62ZhjqhgsEXQMFh9t0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kgmFP6Vq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kgmFP6Vq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D60C4CEDD;
	Thu,  6 Feb 2025 22:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881276;
	bh=K+QiUzO24GNyuAZCg55P8Vwd8q2Ao1Mw+PKyDl27gCM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kgmFP6VqMY7QURbtbOUv7/uqZa3zAaKBjbIKg1R1ooRlhfQIiVKv6NMiKRCVdcLq2
	 T8CCuUVopVljCwsvSHB3FdJhU+aB5XurT+3XE57vh5vMcMOxmYznFaz33i4QsZV8gD
	 HlrM63ftLfkA+LtEEF8EMzcHVdN63ljEMraxiMW9r0HyglgbyhEk5OAs5Ye0KFgGL3
	 MLeC7erewb4CgwpkFeU5c0wAf+tqiASjgkRK7YDK0NpmWsMx7ywOUPLg0/agSdEjv5
	 5/aEJbghfYeuYkr3c7fgUBRZ1+T2ZCfn+5GiPe6Zn8shWiAMSXm7PbDGUrEL+omtA2
	 1Uay9eq+IhjdA==
Date: Thu, 06 Feb 2025 14:34:35 -0800
Subject: [PATCH 15/17] xfs_scrub: hoist the phase3 bulkstat single stepping
 code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086287.2738568.12350824518838304954.stgit@frogsfrogsfrogs>
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

We're about to make the bulkstat single step loading code more complex,
so hoist it into a separate function.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/inodes.c |   89 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 53 insertions(+), 36 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index ffdf0f2ae42c17..84696a5bcda7d1 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -120,52 +120,23 @@ compare_bstat(
 }
 
 /*
- * Run bulkstat on an entire inode allocation group, then check that we got
- * exactly the inodes we expected.  If not, load them one at a time (or fake
- * it) into the bulkstat data.
+ * Walk the xi_allocmask looking for set bits that aren't present in
+ * the fill mask.  For each such inode, fill the entries at the end of
+ * the array with stat information one at a time, synthesizing them if
+ * necessary.  At this point, (xi_allocmask & ~seen_mask) should be the
+ * corrupt inodes.
  */
 static void
-bulkstat_for_inumbers(
+bulkstat_single_step(
 	struct scrub_ctx		*ctx,
 	const struct xfs_inumbers	*inumbers,
+	uint64_t			seen_mask,
 	struct xfs_bulkstat_req		*breq)
 {
 	struct xfs_bulkstat		*bs = NULL;
-	const uint64_t			limit_ino =
-		inumbers->xi_startino + LIBFROG_BULKSTAT_CHUNKSIZE;
-	uint64_t			seen_mask = 0;
 	int				i;
 	int				error;
 
-	assert(inumbers->xi_allocmask != 0);
-
-	/* First we try regular bulkstat, for speed. */
-	breq->hdr.ino = inumbers->xi_startino;
-	error = -xfrog_bulkstat(&ctx->mnt, breq);
-	if (!error) {
-		if (!breq->hdr.ocount)
-			return;
-		seen_mask |= seen_mask_from_bulkstat(inumbers,
-					inumbers->xi_startino, breq);
-	}
-
-	/*
-	 * Bulkstat might return inodes beyond xi_startino + CHUNKSIZE.  Reduce
-	 * ocount to ignore inodes not described by the inumbers record.
-	 */
-	for (i = breq->hdr.ocount - 1; i >= 0; i--) {
-		if (breq->bulkstat[i].bs_ino < limit_ino)
-			break;
-		breq->hdr.ocount--;
-	}
-
-	/*
-	 * Walk the xi_allocmask looking for set bits that aren't present in
-	 * the fill mask.  For each such inode, fill the entries at the end of
-	 * the array with stat information one at a time, synthesizing them if
-	 * necessary.  At this point, (xi_allocmask & ~seen_mask) should be the
-	 * corrupt inodes.
-	 */
 	for (i = 0; i < LIBFROG_BULKSTAT_CHUNKSIZE; i++) {
 		/*
 		 * Don't single-step if inumbers said it wasn't allocated or
@@ -205,6 +176,52 @@ bulkstat_for_inumbers(
 				sizeof(struct xfs_bulkstat), compare_bstat);
 }
 
+/*
+ * Run bulkstat on an entire inode allocation group, then check that we got
+ * exactly the inodes we expected.  If not, load them one at a time (or fake
+ * it) into the bulkstat data.
+ */
+static void
+bulkstat_for_inumbers(
+	struct scrub_ctx		*ctx,
+	const struct xfs_inumbers	*inumbers,
+	struct xfs_bulkstat_req		*breq)
+{
+	const uint64_t			limit_ino =
+		inumbers->xi_startino + LIBFROG_BULKSTAT_CHUNKSIZE;
+	uint64_t			seen_mask = 0;
+	int				i;
+	int				error;
+
+	assert(inumbers->xi_allocmask != 0);
+
+	/* First we try regular bulkstat, for speed. */
+	breq->hdr.ino = inumbers->xi_startino;
+	error = -xfrog_bulkstat(&ctx->mnt, breq);
+	if (!error) {
+		if (!breq->hdr.ocount)
+			return;
+		seen_mask |= seen_mask_from_bulkstat(inumbers,
+					inumbers->xi_startino, breq);
+	}
+
+	/*
+	 * Bulkstat might return inodes beyond xi_startino + CHUNKSIZE.  Reduce
+	 * ocount to ignore inodes not described by the inumbers record.
+	 */
+	for (i = breq->hdr.ocount - 1; i >= 0; i--) {
+		if (breq->bulkstat[i].bs_ino < limit_ino)
+			break;
+		breq->hdr.ocount--;
+	}
+
+	/*
+	 * Fill in any missing inodes that are mentioned in the alloc mask but
+	 * weren't previously seen by bulkstat.
+	 */
+	bulkstat_single_step(ctx, inumbers, seen_mask, breq);
+}
+
 /* BULKSTAT wrapper routines. */
 struct scan_inodes {
 	struct workqueue	wq_bulkstat;

