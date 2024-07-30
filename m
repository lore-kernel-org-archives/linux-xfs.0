Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B95C8D7
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301830; cv=none; b=ZEXwRJw4T8O8Sl9g9RfW6X6GqWZ6pDbYgGpLqH6TpAsbD9wUojpxn/LIZzR19RjPzpIXh4/UshDM3noHeJETqZ29s5xAZjR91kBsbDhHWIpt1L6noxhPy9+n9U150QVmAzgrKLOyAYVDrxGgHzYvGEM5y01TPeML9g2XbiBUBfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301830; c=relaxed/simple;
	bh=YR9YmA00yTaL9KAhXeOr1R8goAwaA+FBABiD9DEOws0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EcB5zax2i+7UohLu/uIKp+ZNYG8NPZUVp14WHlMx7PdOM4KbtFmPR/F+UGvju3Lzy315PnWVr9NPIvqy6SunlnFOQ0PgpaHc/FQS6F6tqU8wWTjEuuldBqmISp0PvhFFCamLsPaCfG1Sh7H3vhq2Ie/RO0cjmD7G/u1rh7e03Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jgZtR95L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jgZtR95L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E36C32786;
	Tue, 30 Jul 2024 01:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301830;
	bh=YR9YmA00yTaL9KAhXeOr1R8goAwaA+FBABiD9DEOws0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jgZtR95LDesFLrrrBhxEqmhEuzXZG3GDW7nQG9WPq747jFlrDpHlBuWMtaQ0Nz72b
	 7fcL1ePfk+LOy8TPyVdu66sYFqtT9WgiTGuIw78hQzL0pzrM9xQsBap84xd+gRmta8
	 +Nz4tac3sVUhLcqMtMWnS+p5I4HPn9EEMRC/Yqa1G2OBuqPoH1WzZFrZT0+0SaxSRY
	 9qnRy2+oCK2BK6LOxD65MMS1H7CZPJjDbdXLSnOvs/qN6S6X9JXiFZyXIMyZliMa9g
	 caMpE+A1cS4VmS+R8twB6W80BuysnOogUqR6aTUVkU4DPOWEjP3WPpeHHlov+TiEls
	 e5GjLDe9nbYHQ==
Date: Mon, 29 Jul 2024 18:10:29 -0700
Subject: [PATCH 5/7] xfs_scrub: report FITRIM errors properly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229848108.1349330.13679178387676040837.stgit@frogsfrogsfrogs>
In-Reply-To: <172229848026.1349330.12889405227098722037.stgit@frogsfrogsfrogs>
References: <172229848026.1349330.12889405227098722037.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase8.c |   12 +++++++++++-
 scrub/vfs.c    |   12 +++++++-----
 scrub/vfs.h    |    2 +-
 3 files changed, 19 insertions(+), 7 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index dfe62e8d9..288800a76 100644
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
index 9e459d624..bcfd4f42c 100644
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
index 1ac41e5aa..a8a4d72e2 100644
--- a/scrub/vfs.h
+++ b/scrub/vfs.h
@@ -24,6 +24,6 @@ typedef int (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
 int scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
 		scan_fs_tree_dirent_fn dirent_fn, void *arg);
 
-void fstrim(struct scrub_ctx *ctx);
+int fstrim(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_VFS_H_ */

