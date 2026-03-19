Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809B310E3
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895720; cv=none; b=ikAyayvn2c5/1LSw6Pxc7mVDy7DWwZjXCe/KhsvvY6Wcgcys+C5PerbWOBoN25qSMAMyJVWDMGYlbEsVDy5a0rrbOabiTvkKnmURY/dh0CvGWbLI1j7AcJiyAs3leDYb+CqHCQeKDzxaFMoTPTFAl50nDf0BCJVQU9y5YFTeLWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895720; c=relaxed/simple;
	bh=Tk6Z9CWvdVED7SWf3ljQD1EGfUiOxBKIdSAC/tg+s+0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ByQ1w2ksTI9mSHyr2j8GG1r1eOdelDK6RUg/x1z2Zv7+vFC3EHo0XeUv286CTmtp1kHi5/Q4nVO7JQOvPfkJ1/vEQ4W7CxcezZOakpnPy8hP6fLPyUZ9zuf56zKuai7Znwq0bcpnjrt8f8uUiBsqRe17szoKUnJK0u5n9VmKz5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=McVxQp1t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="McVxQp1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0CBC19425;
	Thu, 19 Mar 2026 04:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895720;
	bh=Tk6Z9CWvdVED7SWf3ljQD1EGfUiOxBKIdSAC/tg+s+0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=McVxQp1tgrEqnemdr3/qiT6LtZRwyYr37F4P9W6eJqLqzbwAn+YUtsTwqBVUtG1I5
	 QOqIk90dSUxIwZ03EYzaMeakqEs2kMJfenAXfE6l/INozsi9ZTxg0sNDdaOLzBxFQ9
	 0elWOqUHTP/uVoEOrTUD6ApSvwgG5yccLH9M2TpatNlK2l7g3zcyFTwE+PpxaoxEOb
	 kFeaqiW5+Ha5KyCl2Wo2O+6yGJOOs48zHbm7zSELcUW0vw67ZWlWJQQKy9Sv9+8bF3
	 esHoIReYNfOHPiPfBKHikT+iV7J42jw6/3JZ+L7G8VLBwUi5V9vRSbUK/wXYoNejcn
	 HNKZq+hvE1PiA==
Date: Wed, 18 Mar 2026 21:48:39 -0700
Subject: [PATCH 12/22] scrub: simplify verifier threads calculation
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177389507160.3681140.8569325058823307289.stgit@frogsfrogsfrogs>
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

Throwing all CPUs at verifying seems like a bad idea for foreground
scrub, as does abusing I/O opt/min as that says absolutely nothing
about parallelism.  I can't really think of a better way than manually
configuring this except maybe kernel hints.  But the current decisions
are not good defaults, and also are the only user of struct disk for
file systems using the kernel verify ioctl.

The best default seems to be 8, because verification speed increases
diminish above that level.  Note that background service mode now obeys
the thread count restrictions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
[djwong: rebase atop previous patches, leave disk_heads() alone]
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/read_verify.h |    2 ++
 scrub/phase6.c      |   10 +++++-----
 scrub/read_verify.c |   20 ++++++++++++++++++--
 3 files changed, 25 insertions(+), 7 deletions(-)


diff --git a/scrub/read_verify.h b/scrub/read_verify.h
index e4b36f6aaa20e1..6a338abb896bc3 100644
--- a/scrub/read_verify.h
+++ b/scrub/read_verify.h
@@ -33,4 +33,6 @@ bool try_read_verify_schedule_io(struct read_verify_schedule *rs,
 
 int read_verify_bytes(struct read_verify_pool *rvp, uint64_t *bytes);
 
+unsigned int read_verify_nproc(struct scrub_ctx *ctx);
+
 #endif /* XFS_SCRUB_READ_VERIFY_H_ */
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 02b25fe73aa656..bae4d7c5d92ce0 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -889,11 +889,11 @@ phase6_estimate(
 	 * can contribute to the progress counter.  Hence we need to set
 	 * nr_threads appropriately to handle that many threads.
 	 */
-	*nr_threads = disk_heads(ctx->verify_disks[XFS_DEV_DATA]);
-	if (ctx->verify_disks[XFS_DEV_RT])
-		*nr_threads += disk_heads(ctx->verify_disks[XFS_DEV_RT]);
-	if (ctx->verify_disks[XFS_DEV_LOG])
-		*nr_threads += disk_heads(ctx->verify_disks[XFS_DEV_LOG]);
+	*nr_threads = read_verify_nproc(ctx);
+	if (ctx->fsinfo.fs_rt)
+		*nr_threads = read_verify_nproc(ctx);
+	if (ctx->fsinfo.fs_log)
+		*nr_threads = read_verify_nproc(ctx);
 	*rshift = 20;
 	return 0;
 }
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 9b692a923dfdf3..ba04ad3684ebd7 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -70,6 +70,22 @@ struct read_verify_pool {
 	int			runtime_error;
 };
 
+unsigned int
+read_verify_nproc(
+	struct scrub_ctx		*ctx)
+{
+	if (force_nr_threads)
+		return force_nr_threads;
+
+	/*
+	 * Throwing all CPUs at verifying seems like a bad idea for foreground
+	 * scrub, as does abusing I/O opt/min as that says absolutely nothing
+	 * about parallelism.  The authors observed diminishing returns on
+	 * verification speed past 8 IO threads, so that's the default.
+	 */
+	return 8;
+}
+
 /*
  * Create a thread pool to run read verifiers.
  *
@@ -84,8 +100,8 @@ read_verify_pool_alloc(
 	struct read_verify_pool		**prvp)
 {
 	struct read_verify_pool		*rvp;
-	unsigned int			verifier_threads =
-		disk_heads(ctx->verify_disks[XFS_DEV_DATA]);
+	const unsigned int		verifier_threads =
+		read_verify_nproc(ctx);
 	int				ret;
 
 	if (rvp_io_max_size() % ctx->mnt.fsgeom.blocksize)

