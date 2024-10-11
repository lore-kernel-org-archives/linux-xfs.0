Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AD1391
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609454; cv=none; b=mVuTm/n6TICgHWMdGOmxnQ6XgxRWoEd/6LEYefj7gfhRghPrqtZj8PAOHkiRKrxr/MySQqGII4nRyNwfZdu+TzcP1bxh6ZzxXw1iPF6jSR1GgFkuDjgem3b8+Vl7j+OwGRB2METwJz7yxwIQol/YuQ0lvFzoJsOc8ofsEAFKuJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609454; c=relaxed/simple;
	bh=3DWC31o/G1vD4pBXcnct9/Igi3K+PtWqTW0I/XBptb8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kGlq72q6i39YE5QWq0wupKcDNKrxjhKZa9IJCg8+NNeQzv4wxqApQCvr0Yyhpf8qHuRTETLWZ4aaG1YsD1g30FHBA8QMYKT8qtjb3I3ttw5+A3MQCFrm/pWWAAjvVBwLW7OVNQXL8twguSj8DPQCfaWqy/SN0ozaWzTl3PKJodo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vw8aCPWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vw8aCPWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A52C4CEC5;
	Fri, 11 Oct 2024 01:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609453;
	bh=3DWC31o/G1vD4pBXcnct9/Igi3K+PtWqTW0I/XBptb8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Vw8aCPWx6KDTZsUygV9Gn3wr+H/QU80wfIMplBTZydo/tj7YkGo5aDH9YZh3dwMQD
	 4yvUdZGIu5l9nz1KdvO8Z5Qpqgm0ov3woyGOJm8yUZ7/ywotrRphizBXkqtfXrWQqN
	 9YzNuc6rT3tSzZhAg2t/n3AE6ilv7EwJdBYdWGdSGIE10tS27VVDN5e7nhBW/TeykY
	 7Mb1audi6L3B1l1bn0dk1qQV9cOq2AdhW+0X6XFQDfQLekEoeP/TgMgjDvnJ9MGBzY
	 xZExzfKNz3lxIUP7I5HiukfsuRMuV8bMA1BqiC1VUPYa+pIpYTClqUrOn5djeJqJ52
	 I5KmHPGkvGC+A==
Date: Thu, 10 Oct 2024 18:17:33 -0700
Subject: [PATCH 13/38] xfs_scrub: tread zero-length read verify as an IO error
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654176.4183231.4710409081266557549.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

While doing some chaos testing on the xfs_scrub read verify code, I
noticed that if the device under a live filesystem gets resized while
scrub is running a media scan, reads will start returning 0.  This
causes read_verify() to run around in an infinite loop instead of
erroring out like it should.

Cc: <linux-xfs@vger.kernel.org> # v5.3.0
Fixes: 27464242956fac ("xfs_scrub: fix read verify disk error handling strategy")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

