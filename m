Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C888479
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882125; cv=none; b=A0vWPjl1R89kWUzTYoLjRrhjsUmtlbvkKaD4ROqF07jPLcbKuW73fgS8SxnPd3jyLnn+07tqKTN4/EoTlGfBgaNWueayPTrttts5emT5rJ5QVcq2D1n0Kt4ibE6qm5gZy7bpoHb21FKH/za97LFXEAGyiT9Areth28T9uK7oFSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882125; c=relaxed/simple;
	bh=Ql6JuC9gZKl6vIqFlVeAsvSE6tzWZZkq8SvKFDoopQw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y885zYry2LIheWLIShvHbTw3i6suELsMsxBowFjTMqcWh37wtLR1Z/7EkIWygAne0yzJ5u1m7nzqk9dvrMEmncmpVCfVRO4beGvXdV/WOrfzuPLcbo8HZ56+qzYdmb+N6Y0HC9JbSywl7Zmb7lBcMPhwmJFTwRejw7mawSBdcSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=irgmiefY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="irgmiefY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD099C116B1;
	Tue,  2 Jul 2024 01:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882125;
	bh=Ql6JuC9gZKl6vIqFlVeAsvSE6tzWZZkq8SvKFDoopQw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=irgmiefYXkDjFUsX3P73wvMytFjbVQzHgErR83nvfPJGHyCG4a+2OGrbOL+1h+GnN
	 S6rRBF1cOx7BQBqI75j/uMTrRGEcp9qgz3+rghZSkRc5MEWAFZMI2KhotfaeQcYsjT
	 ztqPL7sXPy5s4aHv7ZwUhgsiB4PwvGhaZqYtLlz3Kh4BRBheVbzfvPcfYcSTzoyM7m
	 Lsw2e1glmZL7lUgK4JfHuQckDW/UJ75MOrjMNhnhG+SkLdnll/2/6iJ+cY+HW3VJ6p
	 2ea6c54Ms5ro2184LitPBqIgonbq32wXldq323zohMLS9Q8d1k4R14MxuWPj59SyyE
	 DIpF560PFoP7g==
Date: Mon, 01 Jul 2024 18:02:05 -0700
Subject: [PATCH 5/8] xfs_scrub: report FITRIM errors properly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988118206.2007602.14308985688503230669.stgit@frogsfrogsfrogs>
In-Reply-To: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs>
References: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs>
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

Move the error reporting for the FITRIM ioctl out of vfs.c and into
phase8.c.  This makes it so that IO errors encountered during trim are
counted as runtime errors instead of being dropped silently.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |   12 +++++++++++-
 scrub/vfs.c    |   12 +++++++-----
 scrub/vfs.h    |    2 +-
 3 files changed, 19 insertions(+), 7 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index dfe62e8d97be..288800a76cff 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -47,10 +47,20 @@ int
 phase8_func(
 	struct scrub_ctx	*ctx)
 {
+	int			error;
+
 	if (!fstrim_ok(ctx))
 		return 0;
 
-	fstrim(ctx);
+	error = fstrim(ctx);
+	if (error == EOPNOTSUPP)
+		return 0;
+
+	if (error) {
+		str_liberror(ctx, error, _("fstrim"));
+		return error;
+	}
+
 	progress_add(1);
 	return 0;
 }
diff --git a/scrub/vfs.c b/scrub/vfs.c
index 9e459d6243fa..bcfd4f42ca8b 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -296,15 +296,17 @@ struct fstrim_range {
 #endif
 
 /* Call FITRIM to trim all the unused space in a filesystem. */
-void
+int
 fstrim(
 	struct scrub_ctx	*ctx)
 {
 	struct fstrim_range	range = {0};
-	int			error;
 
 	range.len = ULLONG_MAX;
-	error = ioctl(ctx->mnt.fd, FITRIM, &range);
-	if (error && errno != EOPNOTSUPP && errno != ENOTTY)
-		perror(_("fstrim"));
+	if (ioctl(ctx->mnt.fd, FITRIM, &range) == 0)
+		return 0;
+	if (errno == EOPNOTSUPP || errno == ENOTTY)
+		return EOPNOTSUPP;
+
+	return errno;
 }
diff --git a/scrub/vfs.h b/scrub/vfs.h
index 1ac41e5aac07..a8a4d72e290a 100644
--- a/scrub/vfs.h
+++ b/scrub/vfs.h
@@ -24,6 +24,6 @@ typedef int (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
 int scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
 		scan_fs_tree_dirent_fn dirent_fn, void *arg);
 
-void fstrim(struct scrub_ctx *ctx);
+int fstrim(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_VFS_H_ */

