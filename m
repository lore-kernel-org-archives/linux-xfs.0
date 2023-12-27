Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6113CC2DE
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CohV0y+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C801BC433C8;
	Mon,  1 Jan 2024 00:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067220;
	bh=UNehyCrpT2CiQQez/iI3XcEejINKi2g18L7QPXSn0uQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CohV0y+nxEVBHR0f/et2Z02JIGF8QcpXg5a+uoiU/2pdiZJhAjaNYMZAjbKucnwWr
	 e89U4eQp74ls+Fh8G9VTaMws4YMsNT0OyMpeon+B4YSukPrtXNSoMIO7B8VuuW7HLE
	 tRSfRqnPSVWNP+N+rvwi2Hr1w0HnhGzzFLF0D5Dm+gDEBfH60Mbmpiw7RqpIpJJVNn
	 eQYfX3/0soY6OSlqiNANzZToJvjx+/ajtzsg7zqotyW31gBYHfrCX1H/SQoj7IQv8j
	 ULRUjIpnNQwkTJzaMyg4hjBmB84iT/I0RJ3jzH9BsUlnnabnFHkrZsqHR1n2JEL8aX
	 KdkI1Pht7xifA==
Date: Sun, 31 Dec 2023 16:00:20 +9900
Subject: [PATCH 49/52] xfs_scrub: use histograms to speed up phase 8 on the
 realtime volume
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012817.1811243.7494449792829565677.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

Use the same statistical methods that we use on the data volume to
compute the minimum threshold size for fstrims on the realtime volume.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase7.c    |    7 +++++++
 scrub/phase8.c    |    6 +++++-
 scrub/xfs_scrub.c |    2 ++
 scrub/xfs_scrub.h |    1 +
 4 files changed, 15 insertions(+), 1 deletion(-)


diff --git a/scrub/phase7.c b/scrub/phase7.c
index 475d8f157ee..01097b67879 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -31,6 +31,7 @@ struct summary_counts {
 
 	/* Free space histogram, in fsb */
 	struct histogram	datadev_hist;
+	struct histogram	rtdev_hist;
 };
 
 /*
@@ -56,6 +57,7 @@ summary_count_init(
 	struct summary_counts	*counts = data;
 
 	init_freesp_hist(&counts->datadev_hist);
+	init_freesp_hist(&counts->rtdev_hist);
 }
 
 /* Record block usage. */
@@ -83,6 +85,8 @@ count_block_summary(
 		blocks = cvt_b_to_off_fsbt(&ctx->mnt, fsmap->fmr_length);
 		if (fsmap->fmr_device == ctx->fsinfo.fs_datadev)
 			hist_add(&counts->datadev_hist, blocks);
+		else if (fsmap->fmr_device == ctx->fsinfo.fs_rtdev)
+			hist_add(&counts->rtdev_hist, blocks);
 		return 0;
 	}
 
@@ -124,7 +128,9 @@ add_summaries(
 	total->agbytes += item->agbytes;
 
 	hist_import(&total->datadev_hist, &item->datadev_hist);
+	hist_import(&total->rtdev_hist, &item->rtdev_hist);
 	hist_free(&item->datadev_hist);
+	hist_free(&item->rtdev_hist);
 	return 0;
 }
 
@@ -195,6 +201,7 @@ phase7_func(
 
 	/* Preserve free space histograms for phase 8. */
 	hist_move(&ctx->datadev_hist, &totalcount.datadev_hist);
+	hist_move(&ctx->rtdev_hist, &totalcount.rtdev_hist);
 
 	/* Scan the whole fs. */
 	error = scrub_count_all_inodes(ctx, &counted_inodes);
diff --git a/scrub/phase8.c b/scrub/phase8.c
index 25d1ec3693e..d59bab7009c 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -195,13 +195,17 @@ fstrim_rtdev(
 	struct scrub_ctx	*ctx)
 {
 	struct xfs_fsop_geom	*geo = &ctx->mnt.fsgeom;
+	uint64_t		minlen_fsb;
+
+	minlen_fsb = fstrim_compute_minlen(ctx, &ctx->rtdev_hist);
 
 	/*
 	 * The fstrim ioctl pretends that the realtime volume is in the address
 	 * space immediately after the data volume.  Ignore EINVAL if someone
 	 * tries to run us on an older kernel.
 	 */
-	return fstrim_fsblocks(ctx, geo->datablocks, geo->rtblocks, 0, true);
+	return fstrim_fsblocks(ctx, geo->datablocks, geo->rtblocks,
+			minlen_fsb, true);
 }
 
 /* Trim the filesystem, if desired. */
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 7c73e4d3cca..c510d9534a8 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -713,6 +713,7 @@ main(
 	int			error;
 
 	hist_init(&ctx.datadev_hist);
+	hist_init(&ctx.rtdev_hist);
 
 	fprintf(stdout, "EXPERIMENTAL xfs_scrub program in use! Use at your own risk!\n");
 	fflush(stdout);
@@ -944,6 +945,7 @@ main(
 	unicrash_unload();
 
 	hist_free(&ctx.datadev_hist);
+	hist_free(&ctx.rtdev_hist);
 
 	/*
 	 * If we're being run as a service, the return code must fit the LSB
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 4d9a028921b..8389551c067 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -94,6 +94,7 @@ struct scrub_ctx {
 
 	/* Free space histograms, in fsb */
 	struct histogram	datadev_hist;
+	struct histogram	rtdev_hist;
 
 	/*
 	 * Pick the largest value for fstrim minlen such that we trim at least

