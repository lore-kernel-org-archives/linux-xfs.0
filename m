Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A0D1A238E
	for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 14:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747146930; cv=none; b=RcXpvlmMHejtntzxsm+6f+qVfmJc4UM1bDe7d9ONAyNwSmR23M+tHyyQGpKtuYaYBB/bE68apxjO8zKvCvWZ2aYZI414o0NY9UH2N6sccXDz4f5AxJcL2961m2V0WXk1eWvALwHFhD7oduEJeiqIr22SBMCHXwEvuO/DKvuLd2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747146930; c=relaxed/simple;
	bh=p0RcOuiG4ZRv+M2VGCk9EJXxok9GpC6yvp0rb7lawn4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WRy70loWNE4y50HnVsbkdGWu8XojSW7Vzmpd78zAuqu/QrKXMjIcrvy3AcBhVENiogFsT+AhcBFc+RzAAsH0jvqaXUu1mEzX+OOFK/uNQh1HirO/iZ3W/KjrmOTHnJnU91XWRlRpbTzvKLr92/Dl+LQhaBAvptjnJdNZvEChPOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iIl7rT+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iIl7rT+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3FBC4CEE4;
	Tue, 13 May 2025 14:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747146929;
	bh=p0RcOuiG4ZRv+M2VGCk9EJXxok9GpC6yvp0rb7lawn4=;
	h=Date:From:To:Cc:Subject:From;
	b=iIl7rT+6I0t6EHqlEurYs+J6jL80VsqB4pdu+I5um2tyrRvkcEzWaz+63z8SuvU/s
	 369vTpleS2HdIM7RbLyX5hBfwJa23TIlPeM2MdqNDjRCsK8dIWfjpMjlTwTtpTvSBk
	 DZ+Qez6PnmsoBQTfLyGwty+v/XHxCQiKTk8aNStsajT2IRx326CWJGtezRo3AyNoKt
	 Ju/Fn7XEYt8egZ2ZZZnVZMJevulFCF2mpVz0bTYQGBlwc8lR9OJ83cQ5xSc9WfPgF6
	 H1wkxH6VCRABs7+OKJiHZWkjv7vvJmGHZcfMz3IhwApPpQmskKU2mqY7rfumwOT7RK
	 sgrLphkpKmhZA==
Date: Tue, 13 May 2025 07:35:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2] xfs: remove some EXPERIMENTAL warnings
Message-ID: <20250513143529.GI2701446@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Online fsck was finished a year ago, in Linux 6.10.  The exchange-range
syscall and parent pointers were merged in the same cycle.  None of
these have encountered any serious errors in the year that they've been
in the kernel (or the many many years they've been under development) so
let's drop the shouty warnings.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
v2: add reviews, remove the opstate values too
---
 fs/xfs/xfs_message.h |    3 ---
 fs/xfs/xfs_mount.h   |    7 -------
 fs/xfs/scrub/scrub.c |    2 --
 fs/xfs/xfs_message.c |   12 ------------
 fs/xfs/xfs_super.c   |    7 -------
 5 files changed, 31 deletions(-)

diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index a92a4d09c8e9fa..bce9942f394a6f 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -92,12 +92,9 @@ void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
 
 enum xfs_experimental_feat {
 	XFS_EXPERIMENTAL_PNFS,
-	XFS_EXPERIMENTAL_SCRUB,
 	XFS_EXPERIMENTAL_SHRINK,
 	XFS_EXPERIMENTAL_LARP,
 	XFS_EXPERIMENTAL_LBS,
-	XFS_EXPERIMENTAL_EXCHRANGE,
-	XFS_EXPERIMENTAL_PPTR,
 	XFS_EXPERIMENTAL_METADIR,
 	XFS_EXPERIMENTAL_ZONED,
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 5b5df70570c0db..168b4d340cfc81 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -559,8 +559,6 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 
 /* Kernel has logged a warning about pNFS being used on this fs. */
 #define XFS_OPSTATE_WARNED_PNFS		7
-/* Kernel has logged a warning about online fsck being used on this fs. */
-#define XFS_OPSTATE_WARNED_SCRUB	8
 /* Kernel has logged a warning about shrink being used on this fs. */
 #define XFS_OPSTATE_WARNED_SHRINK	9
 /* Kernel has logged a warning about logged xattr updates being used. */
@@ -573,10 +571,6 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 #define XFS_OPSTATE_USE_LARP		13
 /* Kernel has logged a warning about blocksize > pagesize on this fs. */
 #define XFS_OPSTATE_WARNED_LBS		14
-/* Kernel has logged a warning about exchange-range being used on this fs. */
-#define XFS_OPSTATE_WARNED_EXCHRANGE	15
-/* Kernel has logged a warning about parent pointers being used on this fs. */
-#define XFS_OPSTATE_WARNED_PPTR		16
 /* Kernel has logged a warning about metadata dirs being used on this fs. */
 #define XFS_OPSTATE_WARNED_METADIR	17
 /* Filesystem should use qflags to determine quotaon status */
@@ -645,7 +639,6 @@ xfs_should_warn(struct xfs_mount *mp, long nr)
 	{ (1UL << XFS_OPSTATE_READONLY),		"read_only" }, \
 	{ (1UL << XFS_OPSTATE_INODEGC_ENABLED),		"inodegc" }, \
 	{ (1UL << XFS_OPSTATE_BLOCKGC_ENABLED),		"blockgc" }, \
-	{ (1UL << XFS_OPSTATE_WARNED_SCRUB),		"wscrub" }, \
 	{ (1UL << XFS_OPSTATE_WARNED_SHRINK),		"wshrink" }, \
 	{ (1UL << XFS_OPSTATE_WARNED_LARP),		"wlarp" }, \
 	{ (1UL << XFS_OPSTATE_QUOTACHECK_RUNNING),	"quotacheck" }, \
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 9908850bf76f9e..76e24032e99a53 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -680,8 +680,6 @@ xfs_scrub_metadata(
 	if (error)
 		goto out;
 
-	xfs_warn_experimental(mp, XFS_EXPERIMENTAL_SCRUB);
-
 	sc = kzalloc(sizeof(struct xfs_scrub), XCHK_GFP_FLAGS);
 	if (!sc) {
 		error = -ENOMEM;
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 15d410d16bb27c..54fc5ada519c43 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -145,10 +145,6 @@ xfs_warn_experimental(
 			.opstate	= XFS_OPSTATE_WARNED_PNFS,
 			.name		= "pNFS",
 		},
-		[XFS_EXPERIMENTAL_SCRUB] = {
-			.opstate	= XFS_OPSTATE_WARNED_SCRUB,
-			.name		= "online scrub",
-		},
 		[XFS_EXPERIMENTAL_SHRINK] = {
 			.opstate	= XFS_OPSTATE_WARNED_SHRINK,
 			.name		= "online shrink",
@@ -161,14 +157,6 @@ xfs_warn_experimental(
 			.opstate	= XFS_OPSTATE_WARNED_LBS,
 			.name		= "large block size",
 		},
-		[XFS_EXPERIMENTAL_EXCHRANGE] = {
-			.opstate	= XFS_OPSTATE_WARNED_EXCHRANGE,
-			.name		= "exchange range",
-		},
-		[XFS_EXPERIMENTAL_PPTR] = {
-			.opstate	= XFS_OPSTATE_WARNED_PPTR,
-			.name		= "parent pointer",
-		},
 		[XFS_EXPERIMENTAL_METADIR] = {
 			.opstate	= XFS_OPSTATE_WARNED_METADIR,
 			.name		= "metadata directory tree",
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 696874e72eacf1..b4e830fe101b2f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1953,13 +1953,6 @@ xfs_fs_fill_super(
 		}
 	}
 
-
-	if (xfs_has_exchange_range(mp))
-		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_EXCHRANGE);
-
-	if (xfs_has_parent(mp))
-		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_PPTR);
-
 	/*
 	 * If no quota mount options were provided, maybe we'll try to pick
 	 * up the quota accounting and enforcement flags from the ondisk sb.
