Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83F6D268
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610515; cv=none; b=iuDbA/dFVLX17uAVt8rZxqCzk79WxAU0X2+rZWooISQM1XqixmH/bF/+7N8QgIzeykJmyCvmwHt1xnYIesbC1ylyRj03bZsIN1ET5EWwrIsBP6Z3IO9fObxVoMB/skrFTyahNrDDG3FPQKN9b/5sSJdf9THTG0HOFyFbpsvI13s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610515; c=relaxed/simple;
	bh=0cCXVPJ8Kq++UtXifcqLe+h2LgWxe0HwWNA8vaAbeBU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B6g+VXFFmTxIuHFXOfZT/0C9Ux7WNt5YIPGzn/oYPwvMKYTP7WBiwwZkjoKEl8voP64Wrn3ebWzjEBczlIB0LjxCbhITHW3Knc5J7x4SYblosllBaOhRFAN2Q50/qayAwWGrW/mneGQQKaM8DrmA35K7YGVZSwygqGRlkIZywMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dv2spH5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dv2spH5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F384C4CEC6;
	Fri, 11 Oct 2024 01:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610515;
	bh=0cCXVPJ8Kq++UtXifcqLe+h2LgWxe0HwWNA8vaAbeBU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Dv2spH5H8VThungcRVlSqBCSHWekAoI1Yzjoq9ixRSe6+efszO8UUVcBxGxeNdxDW
	 aop/YdWhW7IxGV5h30ubggDTpnv3C4IqAKrWn6pkjJnZf2ATRrgPzuB8DsBoSPF0ga
	 lnHvkw9JaWZNdn0TIpKRB7LfS3XmFiNTt9F6o9m3VBE5Ii0OPwKlh9rjfq5JpWKX18
	 JtUuw0qHO4sckdZdiTK/J0oUBKmK4mZ21o9zdAdUoQPBrw/aauoOx5L7Fv/aBb/RSr
	 idRbBZkBBu0FfJ3rGsbMRpId0eg9H2NUCNTh418uGQrVDyNmeqd2S9Utl1ZrKafwss
	 WVP3V7xH38hqg==
Date: Thu, 10 Oct 2024 18:35:14 -0700
Subject: [PATCH 41/43] xfs_scrub: use histograms to speed up phase 8 on the
 realtime volume
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655994.4184637.13096673122769592672.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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
index 475d8f157eecca..01097b67879878 100644
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
index adb177ecdafbeb..e8c72d8eb851af 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -211,13 +211,17 @@ fstrim_rtdev(
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
index 3e7d9138f97ec2..90897cc26cd71d 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -728,6 +728,7 @@ main(
 	int			error;
 
 	hist_init(&ctx.datadev_hist);
+	hist_init(&ctx.rtdev_hist);
 
 	fprintf(stdout, "EXPERIMENTAL xfs_scrub program in use! Use at your own risk!\n");
 	fflush(stdout);
@@ -960,6 +961,7 @@ main(
 	unicrash_unload();
 
 	hist_free(&ctx.datadev_hist);
+	hist_free(&ctx.rtdev_hist);
 
 	/*
 	 * If we're being run as a service, the return code must fit the LSB
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 5d336cb55c7422..6ee359f4cebd47 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -101,6 +101,7 @@ struct scrub_ctx {
 
 	/* Free space histograms, in fsb */
 	struct histogram	datadev_hist;
+	struct histogram	rtdev_hist;
 
 	/*
 	 * Pick the largest value for fstrim minlen such that we trim at least

