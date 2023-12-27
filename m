Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A1D1368
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RiGFBAD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13955C433C7;
	Mon,  1 Jan 2024 00:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069427;
	bh=9pv1rkYXXMJTeiyVq3v6/cvxZe9xQIMipsUMmfAIY6I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RiGFBAD6YwC6h9nO0cqh7ioMQMM9+AN/YpktC0qhV22awmhHVf/2j0/4T72pEvDRq
	 wd8c4ONRg31qoAKW0v7+5B5T2TwviY4QHYJm8MAjP/OeNNNCLT3EO0cliKbPN6EEcN
	 FAwqVBWmrH/qNIwjwYihGo5cBxha71DA61Ehw6xh7/2EV/TUDCtWW/3ycfQSxcFR9O
	 Y+opMIOvlL7YHQqaKVJKImciwTbKdIwHqEFdkcBB8fZcknApdN8tRfcKK3tnDRYMfe
	 F4vSoUGL70zBc4klnXzBxvQDavw+xi43zzUmATOH+QYz8ZZCcucxUR7bHaGxu6O+QI
	 dYpBiqvkMQ14g==
Date: Sun, 31 Dec 2023 16:37:06 +9900
Subject: [PATCH 42/42] mkfs: enable reflink on the realtime device
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017688.1817107.10396777646471443602.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

Allow the creation of filesystems with both reflink and realtime volumes
enabled.  For now we don't support a realtime extent size > 1.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c   |    4 ++--
 mkfs/proto.c    |   36 ++++++++++++++++++++++++++++++++++
 mkfs/xfs_mkfs.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 92 insertions(+), 7 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 6add79121b2..2e0d3b1ce94 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -300,9 +300,9 @@ rtmount_init(
 	if (mp->m_sb.sb_rblocks == 0)
 		return 0;
 
-	if (xfs_has_reflink(mp)) {
+	if (xfs_has_reflink(mp) && mp->m_sb.sb_rextsize > 1) {
 		fprintf(stderr,
-	_("%s: Reflink not compatible with realtime device. Please try a newer xfsprogs.\n"),
+	_("%s: Reflink not compatible with realtime extent size > 1. Please try a newer xfsprogs.\n"),
 				progname);
 		return -1;
 	}
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 436f9ac82b2..5b9f3642486 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -884,6 +884,40 @@ rtrmapbt_create(
 	libxfs_imeta_free_path(path);
 }
 
+/* Create the realtime refcount btree inode. */
+static void
+rtrefcountbt_create(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_imeta_update	upd;
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_imeta_path	*path;
+	int			error;
+
+	error = -libxfs_rtrefcountbt_create_path(mp, rtg->rtg_rgno, &path);
+	if (error)
+		fail( _("rtrefcount inode path creation failed"), error);
+
+	error = -libxfs_imeta_ensure_dirpath(mp, path);
+	if (error)
+		fail(_("rtgroup allocation failed"),
+				error);
+
+	error = -libxfs_imeta_start_create(mp, path, &upd);
+	if (error)
+		res_failed(error);
+
+	error = -libxfs_rtrefcountbt_create(&upd, &rtg->rtg_refcountip);
+	if (error)
+		fail(_("rtrefcount inode creation failed"), error);
+
+	error = -libxfs_imeta_commit_update(&upd);
+	if (error)
+		fail(_("rtrefcountbt commit failed"), error);
+
+	libxfs_imeta_free_path(path);
+}
+
 /* Initialize block headers of rt free space files. */
 static int
 init_rtblock_headers(
@@ -1066,6 +1100,8 @@ rtinit(
 	for_each_rtgroup(mp, rgno, rtg) {
 		if (xfs_has_rtrmapbt(mp))
 			rtrmapbt_create(rtg);
+		if (xfs_has_rtreflink(mp))
+			rtrefcountbt_create(rtg);
 	}
 
 	if (mp->m_sb.sb_rbmblocks == 0)
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index bcdfbf6fbf6..83ab4a6c316 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2467,12 +2467,36 @@ _("parent pointers not supported on v4 filesystems\n"));
 	}
 
 	if (cli->xi->rt.name) {
-		if (cli->sb_feat.reflink && cli_opt_set(&mopts, M_REFLINK)) {
-			fprintf(stderr,
-_("reflink not supported with realtime devices\n"));
-			usage();
+		if (cli->rtextsize && cli->sb_feat.reflink) {
+			if (cli_opt_set(&mopts, M_REFLINK)) {
+				fprintf(stderr,
+_("reflink not supported on realtime devices with rt extent size specified\n"));
+				usage();
+			}
+			cli->sb_feat.reflink = false;
+		}
+		if (cli->blocksize < XFS_MIN_RTEXTSIZE && cli->sb_feat.reflink) {
+			if (cli_opt_set(&mopts, M_REFLINK)) {
+				fprintf(stderr,
+_("reflink not supported on realtime devices with blocksize %d < %d\n"),
+						cli->blocksize,
+						XFS_MIN_RTEXTSIZE);
+				usage();
+			}
+			cli->sb_feat.reflink = false;
+		}
+		if (!cli->sb_feat.rtgroups && cli->sb_feat.reflink) {
+			if (cli_opt_set(&mopts, M_REFLINK) &&
+			    cli_opt_set(&ropts, R_RTGROUPS)) {
+				fprintf(stderr,
+_("reflink not supported on realtime devices without rtgroups feature\n"));
+				usage();
+			} else if (cli_opt_set(&mopts, M_REFLINK)) {
+				cli->sb_feat.rtgroups = true;
+			} else {
+				cli->sb_feat.reflink = false;
+			}
 		}
-		cli->sb_feat.reflink = false;
 
 		if (!cli->sb_feat.rtgroups && cli->sb_feat.rmapbt) {
 			if (cli_opt_set(&mopts, M_RMAPBT) &&
@@ -2640,6 +2664,19 @@ validate_rtextsize(
 			usage();
 		}
 		cfg->rtextblocks = (xfs_extlen_t)(rtextbytes >> cfg->blocklog);
+	} else if (cli->sb_feat.reflink && cli->xi->rt.name) {
+		/*
+		 * reflink doesn't support rt extent size > 1FSB yet, so set
+		 * an extent size of 1FSB.  Make sure we still satisfy the
+		 * minimum rt extent size.
+		 */
+		if (cfg->blocksize < XFS_MIN_RTEXTSIZE) {
+			fprintf(stderr,
+		_("reflink not supported on rt volume with blocksize %d\n"),
+				cfg->blocksize);
+			usage();
+		}
+		cfg->rtextblocks = 1;
 	} else {
 		/*
 		 * If realtime extsize has not been specified by the user,
@@ -2671,6 +2708,12 @@ validate_rtextsize(
 		}
 	}
 	ASSERT(cfg->rtextblocks);
+
+	if (cli->sb_feat.reflink && cfg->rtblocks > 0 && cfg->rtextblocks > 1) {
+		fprintf(stderr,
+_("reflink not supported on realtime with extent sizes > 1\n"));
+		usage();
+	}
 }
 
 /* Validate the incoming extsize hint. */
@@ -4636,10 +4679,16 @@ check_rt_meta_prealloc(
 		error = -libxfs_imeta_resv_init_inode(rtg->rtg_rmapip, ask);
 		if (error)
 			prealloc_fail(mp, error, ask, _("realtime rmap btree"));
+
+		ask = libxfs_rtrefcountbt_calc_reserves(mp);
+		error = -libxfs_imeta_resv_init_inode(rtg->rtg_refcountip, ask);
+		if (error)
+			prealloc_fail(mp, error, ask, _("realtime refcount btree"));
 	}
 
 	/* Unreserve the realtime metadata reservations. */
 	for_each_rtgroup(mp, rgno, rtg) {
+		libxfs_imeta_resv_free_inode(rtg->rtg_refcountip);
 		libxfs_imeta_resv_free_inode(rtg->rtg_rmapip);
 	}
 

