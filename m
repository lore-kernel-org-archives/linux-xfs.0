Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B76BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LqJKBExJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED62C433C7;
	Sun, 31 Dec 2023 22:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060451;
	bh=uAJDjql2jkMkQTyEVPud53jQmULkOndoV8eyckj7TqY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LqJKBExJeIkl2v5/Sl4rpANc9/iTbWT+VZk/3xab50fBvwH77TmSevphDX9tjcsHw
	 jrq4NKDQnvbTTrhFPluIG5kajdavlPlFNYMntOslI4QlzGkjLgjucM5XFzvikzEE27
	 FqFu8lCiODr4LRtz/MRfHiV8divQ4mDyTShlUtpDsc2Su+sbmCT+zxz5xDmOhz7bhL
	 1NHomhXqoDGu4dc92TXy14l2DVXw9yV0YGvp6taXHFfosUd94tMucM9ODb4SSOjqWO
	 fmYK7rCO2oLiVLtYZJAQtZ1Fk3lyLAZX6HiboyaGINlB3QrfQauAlnsvU4v8c/fseS
	 7NLNgr3Z4NfIw==
Date: Sun, 31 Dec 2023 14:07:30 -0800
Subject: [PATCH 3/3] xfs: implement live quotacheck inode scan
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404990509.1793446.16497617684420661180.stgit@frogsfrogsfrogs>
In-Reply-To: <170404990467.1793446.3205173493024934532.stgit@frogsfrogsfrogs>
References: <170404990467.1793446.3205173493024934532.stgit@frogsfrogsfrogs>
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

Create a new trio of scrub functions to check quota counters.  While the
dquots themselves are filesystem metadata and should be checked early,
the dquot counter values are computed from other metadata and are
therefore summary counters.  We don't plug these into the scrub dispatch
just yet, because we still need to be able to watch quota updates while
doing our scan.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c |    5 +++++
 libxfs/xfs_fs.h |    3 ++-
 scrub/phase4.c  |   17 +++++++++++++++++
 scrub/repair.c  |    3 +++
 scrub/scrub.c   |    9 +++++++++
 scrub/scrub.h   |    1 +
 6 files changed, 37 insertions(+), 1 deletion(-)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 5a5f522a425..53c47bc2b5d 100644
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
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 711e0fc7efa..07acbed9235 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -710,9 +710,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_GQUOTA	22	/* group quotas */
 #define XFS_SCRUB_TYPE_PQUOTA	23	/* project quotas */
 #define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
+#define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	25
+#define XFS_SCRUB_TYPE_NR	26
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 5dfc3856b82..8807f147aed 100644
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
index 65b6dd89530..3cb7224f7cc 100644
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
index 023cc2c2cd2..a22633a8115 100644
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
index 0033fe7ed93..927f86de9ec 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -27,6 +27,7 @@ int scrub_fs_metadata(struct scrub_ctx *ctx, unsigned int scrub_type,
 int scrub_iscan_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_summary_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_fs_counters(struct scrub_ctx *ctx, struct action_list *alist);
+int scrub_quotacheck(struct scrub_ctx *ctx, struct action_list *alist);
 
 bool can_scrub_fs_metadata(struct scrub_ctx *ctx);
 bool can_scrub_inode(struct scrub_ctx *ctx);

