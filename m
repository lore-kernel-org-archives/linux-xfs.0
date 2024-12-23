Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC431422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990687; cv=none; b=RwjM9SkgYMvnJywxMSf22AlAmvx73xveBze60NfHbgU7q2HSCieUHQiwdOZiITqYyAZOWZEenw01g9fOG7ASImhoaUBzru3zel0C0r0SGuIFhuv9s2EUnDU9DBhqN19sV4+lWn0HVIiHElL0fBZfW+I0eKS8a6ZT10obwwJnIUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990687; c=relaxed/simple;
	bh=dRrTkaUo7KfbtybU+pDZVmYawbYfTTNszCIPdIkxY8U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H+ZZvwIzY6/u1G/NXJIDUtz49iDlBXZwsAecu2E0oKvL2pJZ5uRC2qu7h0IItDRDO0bmLbtO0KnzrWoLMhOwvEOK+4YC4H6uKnKv7Xw2hT1WX14/GOeFdVzxb/IO/+rS3oKKvBoZotucD/W4AXCVfvtZ2M+A69eZRbsjJSX+ABQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fEGYJ3O3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fEGYJ3O3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA86C4CED3;
	Mon, 23 Dec 2024 21:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990687;
	bh=dRrTkaUo7KfbtybU+pDZVmYawbYfTTNszCIPdIkxY8U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fEGYJ3O34kZjfH7cDGT4X1Lu3tvyQhX7eWB0zPFgvbYIxeAnnosyd22JsSYhQlnVy
	 xb0QKCGb474Orermq5JCFdf6ff1JaP1A8oqxbZhAXjvxfozMNnMTTe1Xop0CpJPc/s
	 Rfhcn/ZCZjSGEfMnWorS2kX7kfHAnH6KCBIkmeI1kzSG6TlZx8Vcz56vzM9U4a/8t+
	 USup377WDVkdS6jYWkRInptavowxXkujaQlbQGKdOGQ2Hehdqet0Qc/TaeoprXZhZH
	 YuCznggGqslRjH9QsKSB9tfj34VWnzQUEIwpHR2Zmhv/nuD7b/FyR9ib0wvoQYKLoK
	 WQbc9Q8pIjn/g==
Date: Mon, 23 Dec 2024 13:51:26 -0800
Subject: [PATCH 19/41] xfs_scrub: tread zero-length read verify as an IO error
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941259.2294268.12717372688725284669.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

