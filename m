Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92AFC140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BRdfxGVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBF5C433C7;
	Sun, 31 Dec 2023 22:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062984;
	bh=ZRnDknJbezFFW/Hut6MV1aSUfthgI2IsQECqVn7bYPc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BRdfxGVCCLI+h2WjwMeWfoZVLPSpJhwS6Mi0LX0Iruhz/827cI5Zfd+Vx+Qp9+xXW
	 5Rc3l9uj5p3QtyUPQ4wpV7Y3Fql3GgH15kVtEhiOt4lz4R/DVVsHoY72ODAZj+83hw
	 S+An8ttsGX5qXTnMBx9Zk2UVfaPJfGd3Ue2L2Ea/HwRgjsc1GxnGLWWZFGzaxjYKzK
	 muE+sbl7aRyXkJxda8X8IRNFMpKISQ2rfboPASazBNODj+u2QjyEdkxyeHmcibhw3m
	 ZGtzvLiq9atBUz2EmWZnUfw4RFwK7OnbHBsoJxw4YQ3x6atMjdUiJ153DcIj7SmD/v
	 ykEqiDYUZcjBQ==
Date: Sun, 31 Dec 2023 14:49:43 -0800
Subject: [PATCH 5/8] xfs_scrub: report FITRIM errors properly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405001115.1798752.4682959777961980500.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001045.1798752.4380751003208751209.stgit@frogsfrogsfrogs>
References: <170405001045.1798752.4380751003208751209.stgit@frogsfrogsfrogs>
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
index dfe62e8d97b..288800a76cf 100644
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
index 9e459d6243f..bcfd4f42ca8 100644
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
index 1ac41e5aac0..a8a4d72e290 100644
--- a/scrub/vfs.h
+++ b/scrub/vfs.h
@@ -24,6 +24,6 @@ typedef int (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
 int scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
 		scan_fs_tree_dirent_fn dirent_fn, void *arg);
 
-void fstrim(struct scrub_ctx *ctx);
+int fstrim(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_VFS_H_ */

