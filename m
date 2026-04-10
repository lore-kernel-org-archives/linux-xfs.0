Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CE41A6815
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775802030; cv=none; b=LQHuDg26BSiizUzkC+gVA0gzCgDELBpiuVLwCSizo9Iri4qFJdAm98sG9GrqiT8ipmcdnAjt2SPQH7R0BwdZ7owIe7z+b6irevEnJSv2kalWXXtzcrpE+AT9viqriWqrxEWyxd3xNSd9v1wE3J9mxF62yDcXcIHSVZPA+7kpZLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775802030; c=relaxed/simple;
	bh=H+zCnATe3sUVYxYRllJ9JIe0aei3dEs+D56m02VtG/8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X0oy8jWxomtl0lyLC5c1oF8UAxIAtbe7Rn7Ts0Tx7X/e+QCZsIX6NSsgjTSapEZILw1vsx1ejkoGOa9ze6QBgQNMWv08ZXpV8k9ecr6wllcRFrsJuj+6gb+rbyE5Q34csSpZ5VubCcXY+hsiuHKnyV0Ns0aVLr+O+BcyYDnhSQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=meV/YPS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="meV/YPS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924A0C19424;
	Fri, 10 Apr 2026 06:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775802030;
	bh=H+zCnATe3sUVYxYRllJ9JIe0aei3dEs+D56m02VtG/8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=meV/YPS+cQSnZYmJ5AAHg3Bep5tbRwLJRTvQip0sSEpkO/bJfxcwejBsBed7LK+nF
	 vvqqcxjsYpppBmhX5F/Sy80siFXIz1APvuDIgkIUykZaNTMiauwvqYEB7jL4iS3+cg
	 Wtfm7VtAhNJDgIDrLl/oriRS96kWvwrf/tpd1ZQE0K4jK/7gnVkcsuCMK5fzVG9KDe
	 1iuUaO+J/tr9WL3x2hYEIlb4LavxD6D+FyUAIlN7zo71cmZBG0+Ma4aBKTdETsneoQ
	 cxeqpQps6REzk/JeEGVoltmAsDqFbLHzRF4ag8KnI+lVDi8vX/U455IKe41CznUD0J
	 fRtfl2qV/rYow==
Date: Thu, 09 Apr 2026 23:20:30 -0700
Subject: [PATCH 12/21] scrub: simplify verifier threads calculation
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577385253.2090237.9275967585608691676.stgit@frogsfrogsfrogs>
In-Reply-To: <177577384929.2090237.10369276062302001541.stgit@frogsfrogsfrogs>
References: <177577384929.2090237.10369276062302001541.stgit@frogsfrogsfrogs>
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
index 9b99d041ed8bf2..266a2bf0e453ae 100644
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
+		*nr_threads += read_verify_nproc(ctx);
+	if (ctx->fsinfo.fs_log)
+		*nr_threads += read_verify_nproc(ctx);
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

