Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B54514D717
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528661; cv=none; b=eNHBNGOrrA+6LcWxsxE2KyiugoqUF66ClQRY6ur0Ssv1VJnBHuzSlVMP0aNDdneff+s065paI+16B8uyuTbc2/1/JbwrxhR+3KaH9u9+In1A4+vVYM4nT/aDFcFLSPCqQVnuE88CP5p03dZQoxZy3B3QOMMK+MtT5SKX70ApVag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528661; c=relaxed/simple;
	bh=TTbcCyuPT7E5MTOV49X0nRIcwDbrmxaDggsY4g0/EVk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e7QUa5eQHBn99sAOvPsT4EZq9UHiwOb1k6Vfpqs9Ev0V7XkVi+qvq/nVLS+mqtNGPxF/j7+iPP0OPzw1u6NRI22FdXfdH+ZuljrcqFCxWfyELfsM9dIrA53mopGxavQ7t8q0ZMOUXkpXlAcN0JUdffMA9cMjSlyMD1s8N6DWnaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j0NXhull; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j0NXhull"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80B6C4CED1;
	Fri,  6 Dec 2024 23:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528660;
	bh=TTbcCyuPT7E5MTOV49X0nRIcwDbrmxaDggsY4g0/EVk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=j0NXhull9vZtG1oaXLp6CCshMUi5Yi2+c+5NbfelqJGzL65SgaX/GfjF+mR4b7dQH
	 rUtfy4q8B9PoBlTbjN8wBEwDUymyptLwuK1PkL1EuxJyrHMUXLLnhdMtZ1A6L9hlZr
	 urhDUQrTqmoxRq0dg4x5FanULMvfyjW7uN/pkgjoI4rRND6AAYAjfyQ9AHgVcR7viq
	 TMMVvuhth/0bIlLYG6Ti3FOREB4EB2wthcDj7uKbs3ENHAhrFxMVFZKelGNVlnf5rj
	 o0AVW/FlWnn4DlmHhyf7L/5rFw6f+1JGtKU+ZHvYU2j7RIT/Pzyo9f/TkDh+BE8fEV
	 /WFBOst5cHUqw==
Date: Fri, 06 Dec 2024 15:44:20 -0800
Subject: [PATCH 18/41] xfs_scrub: tread zero-length read verify as an IO error
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748513.122992.17419278779179180704.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

While doing some chaos testing on the xfs_scrub read verify code, I
noticed that if the device under a live filesystem gets resized while
scrub is running a media scan, reads will start returning 0.  This
causes read_verify() to run around in an infinite loop instead of
erroring out like it should.

Cc: <linux-xfs@vger.kernel.org> # v5.3.0
Fixes: 27464242956fac ("xfs_scrub: fix read verify disk error handling strategy")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase6.c      |   22 ++++++++++++++++++++++
 scrub/read_verify.c |    8 ++++++++
 2 files changed, 30 insertions(+)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index a61853019e290c..54d21820a722a6 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -44,6 +44,9 @@ struct media_verify_state {
 	struct read_verify_pool	*rvp_realtime;
 	struct bitmap		*d_bad;		/* bytes */
 	struct bitmap		*r_bad;		/* bytes */
+	bool			d_trunc:1;
+	bool			r_trunc:1;
+	bool			l_trunc:1;
 };
 
 /* Find the fd for a given device identifier. */
@@ -544,6 +547,13 @@ report_all_media_errors(
 {
 	int				ret;
 
+	if (vs->d_trunc)
+		str_corrupt(ctx, ctx->mntpoint, _("data device truncated"));
+	if (vs->l_trunc)
+		str_corrupt(ctx, ctx->mntpoint, _("log device truncated"));
+	if (vs->r_trunc)
+		str_corrupt(ctx, ctx->mntpoint, _("rt device truncated"));
+
 	ret = report_disk_ioerrs(ctx, ctx->datadev, vs);
 	if (ret) {
 		str_liberror(ctx, ret, _("walking datadev io errors"));
@@ -663,6 +673,18 @@ remember_ioerr(
 	struct bitmap			*tree;
 	int				ret;
 
+	if (!length) {
+		dev_t			dev = disk_to_dev(ctx, disk);
+
+		if (dev == ctx->fsinfo.fs_datadev)
+			vs->d_trunc = true;
+		else if (dev == ctx->fsinfo.fs_rtdev)
+			vs->r_trunc = true;
+		else if (dev == ctx->fsinfo.fs_logdev)
+			vs->l_trunc = true;
+		return;
+	}
+
 	tree = bitmap_for_disk(ctx, disk, vs);
 	if (!tree) {
 		str_liberror(ctx, ENOENT, _("finding bad block bitmap"));
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 52348274be2c25..1219efe2590182 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -245,6 +245,14 @@ read_verify(
 					read_error);
 			rvp->ioerr_fn(rvp->ctx, rvp->disk, rv->io_start, sz,
 					read_error, rv->io_end_arg);
+		} else if (sz == 0) {
+			/* No bytes at all?  Did we hit the end of the disk? */
+			dbg_printf("EOF %d @ %"PRIu64" %zu err %d\n",
+					rvp->disk->d_fd, rv->io_start, sz,
+					read_error);
+			rvp->ioerr_fn(rvp->ctx, rvp->disk, rv->io_start, sz,
+					read_error, rv->io_end_arg);
+			break;
 		} else if (sz < len) {
 			/*
 			 * A short direct read suggests that we might have hit

