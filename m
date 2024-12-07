Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EB93FF1
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530649; cv=none; b=VAXGr3UUu4h8vlz/U9aAlSb0ol42DwIRQItd6Be1Zci8fSO39ekUQIlHkbCjCrsaH96o6S+WSp5Nmc9JAlIQX0AgjHoXuT2YDK6OxAXgSh8HZeun9zmklWTODpnuqyc1OW0D4XjkOjj3XqsFT6NlHgTUbvLbBtLhI6juEGeLdD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530649; c=relaxed/simple;
	bh=xopfR6/SZuIlWNWqk66CQWomvFzWkupOKBA4581JZpw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aGv/qGhAWeAjn67lIEmFqU5BmfSvZJsF+CEB+cYIxo9hBCwcXG6//6i9nXbav/qnRzxDR0ubusuW9Ibkwod734r50KHuYn/K0McHyzHplrtV+mlocrgXv3RmkCD8buicVuXQbPCdohMB//k3u08ylfM9dbQMCG0Zih/DCnk9fVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EwN+YVmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EwN+YVmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0683C4CED1;
	Sat,  7 Dec 2024 00:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530648;
	bh=xopfR6/SZuIlWNWqk66CQWomvFzWkupOKBA4581JZpw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EwN+YVmFrJ3/eVkJODSWArrBd7qRLOcZMvcEzET5dQYyonO6CaJ5qjYG+X3xAcSDc
	 d/TWQ+gtKgyU2HiagtyTKbOHamXBFoqrNDbGW9VYUnkvv7PdJFiv9/fMBtZJzlamlC
	 hk+3JqC47JyLlr0SgR9oPC3Qw4IdgiTHoN5u6WJXKqfJgKEIBjBPtQIsJnPtNxViOb
	 Buk49P97D6j3dIAxw/x/3yxqozz5MJbfWXTMsGdnTr/4lHXQXCOx1k+YnYx4sB5qmz
	 q4U/3Ypgv6zRVVIm2zjgAcX7nNBYOQNgKiPbNa73SC42ghO7op1NQjPoyic8EWaIJH
	 uHutmL8ya34yQ==
Date: Fri, 06 Dec 2024 16:17:28 -0800
Subject: [PATCH 48/50] xfs_scrub: use histograms to speed up phase 8 on the
 realtime volume
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752679.126362.5625686525882316849.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
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

