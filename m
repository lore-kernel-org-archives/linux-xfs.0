Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95FF19E992;
	Tue, 16 Sep 2025 00:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757982304; cv=none; b=utiaok7VtxJ+Az6Q6oJbC37o9chBqkAmccGkbogoSnlyBjJ0pVS9UzjD0SIMzypo6uVu+XNx5guKbak8suhwYq7CvG6HBYGnCHFKt2gg1IWAmiXxUvyDpItU2lpeb4Y9oyXXmK2ALhyejre2fB4a47brVgaowlWBrKJzfAiF+vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757982304; c=relaxed/simple;
	bh=1DjLUKIn2sHS2FK4+1MiPY6289iFSc23rli0fRwiuCU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DDMzYXzTpyIc0hbDBdsCDFPZ73DypU2tBqfc7MQ886XBkdo6LN/uBDfahNdipth4iHu3el/az9/anyS+uDSvG3G9pvSbN3ecS/7Fs/cJUSFIrJn7MeLXrHUx2LqLtzn3iWDo+FnAFgOy1Lljbwe2mk88bqltl2O2ZKu7HWTvVhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xy+B1/Gi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xy+B1/Gi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED8AC4CEF1;
	Tue, 16 Sep 2025 00:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757982304;
	bh=1DjLUKIn2sHS2FK4+1MiPY6289iFSc23rli0fRwiuCU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xy+B1/GiROqK+Qtg5dSjwgJezbJQcGHuwCby+c4jB7Rtwb/bJi4CuueUFXsFNewoI
	 HgP3M6VSeLyclz5BMaIZlwRDqWO5LNAMI4kJBhVLPAZkmQxdnYiNXZ3CaZdQJkZB/3
	 MF5t0Hf+xCBE+GFNGdiz5lV1Hj0c/9OHLbY3mSMrb44STW5pX8f7GjzpGdf6BYQY3k
	 bLRawt6fTg/RAE/wcJ2ZdT0cUkyFlsxt8MHeCoo78W+99Fn6bZBtOJ9RnaaCj3eGkJ
	 hyhCj0M4qDoVCMTDHFBYqV1Df6cVLESPtryIATQntbKlTzrM7mhWGZ+1KHZSpDz8cA
	 ccGXU4SmELszw==
Date: Mon, 15 Sep 2025 17:25:04 -0700
Subject: [PATCH 4/8] fuse: signal that a fuse filesystem should exhibit local
 fs behaviors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, miklos@szeredi.hu
Cc: bernd@bsbernd.com, linux-xfs@vger.kernel.org, John@groves.net,
 linux-fsdevel@vger.kernel.org, neal@gompa.dev, joannelkoong@gmail.com
Message-ID: <175798150113.381990.4002893785000461185.stgit@frogsfrogsfrogs>
In-Reply-To: <175798149979.381990.14913079500562122255.stgit@frogsfrogsfrogs>
References: <175798149979.381990.14913079500562122255.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a new fuse context flag that indicates that the kernel should
implement various local filesystem behaviors instead of passing vfs
commands straight through to the fuse server and expecting the server to
do all the work.  For example, this means that we'll use the kernel to
transform some ACL updates into mode changes, and later to do
enforcement of the immutable and append iflags.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/fuse/fuse_i.h |    4 ++++
 fs/fuse/inode.c  |    2 ++
 2 files changed, 6 insertions(+)


diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index e93a3c3f11d901..e13e8270f4f58d 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -603,6 +603,7 @@ struct fuse_fs_context {
 	bool no_control:1;
 	bool no_force_umount:1;
 	bool legacy_opts_show:1;
+	bool local_fs:1;
 	enum fuse_dax_mode dax_mode;
 	unsigned int max_read;
 	unsigned int blksize;
@@ -901,6 +902,9 @@ struct fuse_conn {
 	/* Is link not implemented by fs? */
 	unsigned int no_link:1;
 
+	/* Should this filesystem behave like a local filesystem? */
+	unsigned int local_fs:1;
+
 	/* Use io_uring for communication */
 	unsigned int io_uring;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index c94aba627a6f11..c8dd0bcb7e6f9f 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1862,6 +1862,7 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 	fc->destroy = ctx->destroy;
 	fc->no_control = ctx->no_control;
 	fc->no_force_umount = ctx->no_force_umount;
+	fc->local_fs = ctx->local_fs;
 
 	err = -ENOMEM;
 	root = fuse_get_root_inode(sb, ctx->rootmode);
@@ -2029,6 +2030,7 @@ static int fuse_init_fs_context(struct fs_context *fsc)
 	if (fsc->fs_type == &fuseblk_fs_type) {
 		ctx->is_bdev = true;
 		ctx->destroy = true;
+		ctx->local_fs = true;
 	}
 #endif
 

