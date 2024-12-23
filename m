Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B358F188596
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992673; cv=none; b=SGw73jnvyTw/NI1GWQc+k97JpHgkVUXg0CYblfTFHYuRwo4r9Vd6hrERsW4ba3HzdUuSxS6+dGNshVgEqZcNdqAwKX8HbLw/8TRLJ2l1mHp6zmnjab7PQY0WDAfgHzJ7c5AAmXMlxtEinLHEVa4tAQPrjQmMO9SDZe8v+vHubzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992673; c=relaxed/simple;
	bh=/Hti1zn4lnxGJa0O/Mh4a8yFYdG9sarkJ36U622PjGY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eVEEs9i3y7argHwtyMP+KBG1gPZ6J2pnzh87A0DhMjcishkltbPTs3v9J2oB4svjeGPKdJjI9yaSv4Ex+FShBMWGBd1DIcVx7lAimGk0hSl6R8jMmIkuTludGnekhUpFenQAJ2Am0h4SBGkIJUVNIbDjyCxCkmeGd0/fa3LUC0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hnAYu5Ef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hnAYu5Ef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6E1C4CED3;
	Mon, 23 Dec 2024 22:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992673;
	bh=/Hti1zn4lnxGJa0O/Mh4a8yFYdG9sarkJ36U622PjGY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hnAYu5EfvYNXzt8jeAGjmINtZnefhkBuyHe3O6Dyn6Ai6mxPY+81bxBz+JxCqp7qu
	 g5eqI1sEWmzbbtYGoJmnlnYSLymjMaqxb2g8LGPSimflUzZwRNMJ4tLDpFSODuzMqk
	 PE1PNMHVonAyoIDprJn/LpTRcE2fQlkXRlI5IU/tZY6lc7OYTAkNBZdK7To1tmSDmy
	 1FH1Iz2CKLnaesqO+P+oUjo38DtPu8nx3uXWxLbwb11vp/hfQdMUcoYhGpV7jl60Ca
	 0eAlwFj4Rmem63eCWLDFr/QKdT2tRabb7yuhv4836ajV3cEfFZA6nOgZFVgYUX8zy0
	 KS8BA2/KYPGzA==
Date: Mon, 23 Dec 2024 14:24:32 -0800
Subject: [PATCH 49/51] xfs_scrub: use histograms to speed up phase 8 on the
 realtime volume
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944553.2297565.13377801037666623869.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

