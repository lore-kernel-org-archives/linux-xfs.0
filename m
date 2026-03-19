Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EEE10E3
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895736; cv=none; b=B88SMZJL2p0v95oH/W/eokxkZSXmfQYgbTJL4U+JQwnbcpWPQJmSySLTG3l4wDWhAQYE54OhS+otduNy1Pe/P/mY9mwCycNAYC+17bPWNt/ulVV/x1GryekAqrDOgQYp8t3uDFlftoO8NyP8hPnYMaUnaNOb1/NdA/iJk9w88Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895736; c=relaxed/simple;
	bh=VKI4jbGNOyl9FvIxM0wk1Vj4mzKwR0giNgYGHEtr7so=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WDgf0UDidshENOrA/KitAPEPS6uDAiexWGeTlEryoQ3FGmTP3B2R78g6nePc/vyj2UPQVHr0Pimb0PAkMZlnW3mgRBwjDxEcWn0XHgy2sIIyxNcI7YWHiLBx74CxlCrlYCJ8IfE5C6/CPhTwMmNuHX69CwIGN8g66rgNXNbHbEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MdS4sseq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MdS4sseq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E27C19425;
	Thu, 19 Mar 2026 04:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895736;
	bh=VKI4jbGNOyl9FvIxM0wk1Vj4mzKwR0giNgYGHEtr7so=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MdS4sseqZGl5pqSPc4znWEOiDggdwJxsb4dLYg0B4IBBBYyfefwLJKXhqqSGlqJFe
	 b/aF3uHJvaVS3RCXEExTer1NmbM/Ll0saSOBVZIVg2KNkJ3ZBYJJF9l40xFmZB+mqw
	 UpEM0YWo1qbitJPoqHkth5OalzN6fjj4TS9mdBgxZC277D5NGBe3GFWHhssmzwjrUM
	 oEwvDiI1HUy+Py+utbPsoBEHTj5QeE0ykULJUhbR+NlvzK0az3l3EPR374YzK0IekT
	 XLZ2qKFHDwVmQ6g4izJUsQJ60RqNHplKn0DJ2Uv/l8w0eCL2TVUwS1JKGzcjSibk3+
	 BpGufIoeLiFiA==
Date: Wed, 18 Mar 2026 21:48:55 -0700
Subject: [PATCH 13/22] xfs_scrub: move disk media verification error injection
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177389507178.3681140.1737889167463602377.stgit@frogsfrogsfrogs>
In-Reply-To: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

This isn't really disk-related since it's a knob to make the
read_verify_pool pretend that the media is defective.  Move this code
before we add a new media verify path that doesn't require the disk
abstraction.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
[djwong: split off from another hch patch, create a new commit message]
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/disk.c        |   71 -------------------------------------------
 scrub/read_verify.c |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 83 insertions(+), 73 deletions(-)


diff --git a/scrub/disk.c b/scrub/disk.c
index 2cf84d91887587..afce801d3f2076 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -266,63 +266,6 @@ disk_close(
 #define LBASIZE(d)		(1ULL << (d)->d_lbalog)
 #define BTOLBA(d, bytes)	(((uint64_t)(bytes) + LBASIZE(d) - 1) >> (d)->d_lbalog)
 
-/* Simulate disk errors. */
-static int
-disk_simulate_read_error(
-	struct disk		*disk,
-	uint64_t		start,
-	uint64_t		*length)
-{
-	static int64_t		interval;
-	uint64_t		start_interval;
-
-	/* Simulated disk errors are disabled. */
-	if (interval < 0)
-		return 0;
-
-	/* Figure out the disk read error interval. */
-	if (interval == 0) {
-		char		*p;
-
-		/* Pretend there's bad media every so often, in bytes. */
-		p = getenv("XFS_SCRUB_DISK_ERROR_INTERVAL");
-		if (p == NULL) {
-			interval = -1;
-			return 0;
-		}
-		interval = strtoull(p, NULL, 10);
-		interval &= ~((1U << disk->d_lbalog) - 1);
-	}
-	if (interval <= 0) {
-		interval = -1;
-		return 0;
-	}
-
-	/*
-	 * We simulate disk errors by pretending that there are media errors at
-	 * predetermined intervals across the disk.  If a read verify request
-	 * crosses one of those intervals we shorten it so that the next read
-	 * will start on an interval threshold.  If the read verify request
-	 * starts on an interval threshold, we send back EIO as if it had
-	 * failed.
-	 */
-	if ((start % interval) == 0) {
-		dbg_printf("fd %d: simulating disk error at %"PRIu64".\n",
-				disk->d_fd, start);
-		return EIO;
-	}
-
-	start_interval = start / interval;
-	if (start_interval != (start + *length) / interval) {
-		*length = ((start_interval + 1) * interval) - start;
-		dbg_printf(
-"fd %d: simulating short read at %"PRIu64" to length %"PRIu64".\n",
-				disk->d_fd, start, *length);
-	}
-
-	return 0;
-}
-
 /* Read-verify an extent of a disk device. */
 ssize_t
 disk_read_verify(
@@ -331,20 +274,6 @@ disk_read_verify(
 	uint64_t		start,
 	uint64_t		length)
 {
-	if (debug) {
-		int		ret;
-
-		ret = disk_simulate_read_error(disk, start, &length);
-		if (ret) {
-			errno = ret;
-			return -1;
-		}
-
-		/* Don't actually issue the IO */
-		if (getenv("XFS_SCRUB_DISK_VERIFY_SKIP"))
-			return length;
-	}
-
 	/* Convert to logical block size. */
 	if (disk->d_flags & DISK_FLAG_SCSI_VERIFY)
 		return disk_scsi_verify(disk, BTOLBAT(disk, start),
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index ba04ad3684ebd7..adee67d922fc76 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -168,6 +168,88 @@ read_verify_pool_destroy(
 	free(rvp);
 }
 
+/* Simulate disk errors. */
+static int
+verify_simulate_read_error(
+	struct read_verify_pool	*rvp,
+	uint64_t		start,
+	ssize_t			*length)
+{
+	static int64_t		interval;
+	uint64_t		start_interval;
+
+	/* Simulated disk errors are disabled. */
+	if (interval < 0)
+		return 0;
+
+	/* Figure out the disk read error interval. */
+	if (interval == 0) {
+		char		*p;
+
+		/* Pretend there's bad media every so often, in bytes. */
+		p = getenv("XFS_SCRUB_DISK_ERROR_INTERVAL");
+		if (p == NULL) {
+			interval = -1;
+			return 0;
+		}
+		interval = strtoull(p, NULL, 10);
+		interval &= (rvp->miniosz - 1);
+	}
+	if (interval <= 0) {
+		interval = -1;
+		return 0;
+	}
+
+	/*
+	 * We simulate disk errors by pretending that there are media errors at
+	 * predetermined intervals across the disk.  If a read verify request
+	 * crosses one of those intervals we shorten it so that the next read
+	 * will start on an interval threshold.  If the read verify request
+	 * starts on an interval threshold, we send back EIO as if it had
+	 * failed.
+	 */
+	if ((start % interval) == 0) {
+		dbg_printf("dev %u: simulating disk error at %"PRIu64".\n",
+				rvp->dev, start);
+		return EIO;
+	}
+
+	start_interval = start / interval;
+	if (start_interval != (start + *length) / interval) {
+		*length = ((start_interval + 1) * interval) - start;
+		dbg_printf(
+"dev %u: simulating short read at %"PRIu64" to length %"PRIu64".\n",
+				rvp->dev, start, *length);
+	}
+
+	return 0;
+}
+
+/* Read-verify an extent of a disk device. */
+static ssize_t
+read_verify_one(
+	struct read_verify_pool	*rvp,
+	struct read_verify	*rv,
+	ssize_t			len)
+{
+	if (debug) {
+		int		ret;
+
+		ret = verify_simulate_read_error(rvp, rv->io_start, &len);
+		if (ret) {
+			errno = ret;
+			return -1;
+		}
+
+		/* Don't actually issue the IO */
+		if (getenv("XFS_SCRUB_DISK_VERIFY_SKIP"))
+			return len;
+	}
+
+	return disk_read_verify(rvp->ctx->verify_disks[rvp->dev], rvp->readbuf,
+			rv->io_start, len);
+}
+
 /*
  * Issue a read-verify IO in big batches.
  */
@@ -197,8 +279,7 @@ read_verify(
 		len = min(rv->io_length, io_max_size);
 		dbg_printf("diskverify %u %"PRIu64" %zu\n", rvp->dev,
 				rv->io_start, len);
-		sz = disk_read_verify(rvp->ctx->verify_disks[rvp->dev],
-				rvp->readbuf, rv->io_start, len);
+		sz = read_verify_one(rvp, rv, len);
 		if (sz == len && io_max_size < rvp->miniosz) {
 			/*
 			 * If the verify request was 100% successful and less

