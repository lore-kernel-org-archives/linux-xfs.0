Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB4712838F
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425554; cv=none; b=lPibZ+53xYnL9ldsv5Qbsii3TOHaWOrlA60u6CLXPtDzgc7bjm75tjrHVgbT/AjGQHFBY5UHtpv6PGgBPib7AhFDe+ftEO2blfs2De0O7UPfNpBLrRU1zbusomHTfEk+bGN52L+iIfHfArFuSsF9kGRBwTy/QQ+wsiSCOfKpS0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425554; c=relaxed/simple;
	bh=MFyGH1nIlUYo+prmAWDMTbaxr13CNIHQBRsZyVi+dFI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gZyFRW4/v0E1Vg8lxbe+DDOdM1ljlCLMEfnnz8lwq8bxDvRvKXRsBdnP1uQEeyt1VdzCsYDlJia2IeC5eu4Q6tnd9SAdVtaIx1+s+naTCyYFLeEQtB3ANDGPE8kPztfPBS5Gx5e/DlsEdAwT5eUt5B3Fzj5mALYdlPyISEqlrp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=idvioy5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="idvioy5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB148C433C7;
	Tue, 26 Mar 2024 03:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425554;
	bh=MFyGH1nIlUYo+prmAWDMTbaxr13CNIHQBRsZyVi+dFI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=idvioy5Fbcj47R0kuChFg9CAAi587wcsYzaNbwI3GKofitDqA4g8sgiXHhaTAMfHn
	 7vap17l8JNN5qdmtwO8SUpBL+nlmO3X18D7Q1YHv99HacUleNOay7L5rL/2YU1IUMl
	 YZZDvgkPZd7XzFNLz2Ncc4VUpW7nYcrxY6pPArryQA/8trLOkvYhYTxHDRIy/cYkth
	 Fpar85wLZkpyQ5hHFmD/DrB9sKUP2YLpSZfC+qAwMksapb3ZOWsD8HWRSodqTG/fD1
	 ub/9prH1iC8sKxDw/ahf0nvWGw7bNbeC6btWOcqwgl+0rSPVtaCQ0neLQvHzeqSGa+
	 AXtZDy0eA2Ubw==
Date: Mon, 25 Mar 2024 20:59:13 -0700
Subject: [PATCH 1/5] xfs_scrub: implement live quotacheck inode scan
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142134323.2218196.1865684046006657533.stgit@frogsfrogsfrogs>
In-Reply-To: <171142134302.2218196.4456442187285422971.stgit@frogsfrogsfrogs>
References: <171142134302.2218196.4456442187285422971.stgit@frogsfrogsfrogs>
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

Teach xfs_scrub to check quota resource usage counters when checking a
filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c |    5 +++++
 scrub/phase4.c  |   17 +++++++++++++++++
 scrub/repair.c  |    3 +++
 scrub/scrub.c   |    9 +++++++++
 scrub/scrub.h   |    1 +
 5 files changed, 35 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 5a5f522a4258..53c47bc2b5dc 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -134,6 +134,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "filesystem summary counters",
 		.group	= XFROG_SCRUB_GROUP_SUMMARY,
 	},
+	[XFS_SCRUB_TYPE_QUOTACHECK] = {
+		.name	= "quotacheck",
+		.descr	= "quota counters",
+		.group	= XFROG_SCRUB_GROUP_ISCAN,
+	},
 };
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 5dfc3856b82f..8807f147aed1 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -128,6 +128,7 @@ int
 phase4_func(
 	struct scrub_ctx	*ctx)
 {
+	struct xfs_fsop_geom	fsgeom;
 	int			ret;
 
 	if (!have_action_items(ctx))
@@ -143,6 +144,22 @@ phase4_func(
 	if (ret)
 		return ret;
 
+	/*
+	 * Repair possibly bad quota counts before starting other repairs,
+	 * because wildly incorrect quota counts can cause shutdowns.
+	 * Quotacheck scans all inodes, so we only want to do it if we know
+	 * it's sick.
+	 */
+	ret = xfrog_geometry(ctx->mnt.fd, &fsgeom);
+	if (ret)
+		return ret;
+
+	if (fsgeom.sick & XFS_FSOP_GEOM_SICK_QUOTACHECK) {
+		ret = scrub_quotacheck(ctx, &ctx->action_lists[0]);
+		if (ret)
+			return ret;
+	}
+
 	ret = repair_everything(ctx);
 	if (ret)
 		return ret;
diff --git a/scrub/repair.c b/scrub/repair.c
index 65b6dd895309..3cb7224f7cc5 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -84,6 +84,9 @@ xfs_action_item_priority(
 	case XFS_SCRUB_TYPE_GQUOTA:
 	case XFS_SCRUB_TYPE_PQUOTA:
 		return PRIO(aitem, XFS_SCRUB_TYPE_UQUOTA);
+	case XFS_SCRUB_TYPE_QUOTACHECK:
+		/* This should always go after [UGP]QUOTA no matter what. */
+		return PRIO(aitem, aitem->type);
 	case XFS_SCRUB_TYPE_FSCOUNTERS:
 		/* This should always go after AG headers no matter what. */
 		return PRIO(aitem, INT_MAX);
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 023cc2c2cd2c..a22633a81157 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -440,6 +440,15 @@ scrub_fs_counters(
 	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_FSCOUNTERS, 0, alist);
 }
 
+/* Scrub /only/ the quota counters. */
+int
+scrub_quotacheck(
+	struct scrub_ctx		*ctx,
+	struct action_list		*alist)
+{
+	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_QUOTACHECK, 0, alist);
+}
+
 /* How many items do we have to check? */
 unsigned int
 scrub_estimate_ag_work(
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 0033fe7ed931..927f86de9ec2 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -27,6 +27,7 @@ int scrub_fs_metadata(struct scrub_ctx *ctx, unsigned int scrub_type,
 int scrub_iscan_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_summary_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_fs_counters(struct scrub_ctx *ctx, struct action_list *alist);
+int scrub_quotacheck(struct scrub_ctx *ctx, struct action_list *alist);
 
 bool can_scrub_fs_metadata(struct scrub_ctx *ctx);
 bool can_scrub_inode(struct scrub_ctx *ctx);

