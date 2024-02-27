Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD208F9CF
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000358; cv=none; b=WPiP9r6/KFjHAguCzqlq4nsrN4zEtPCX7YK5rUI43b1rDwJlBTB0p7AY7UKViUg0HMjfBhkAbobHogzRzKwP3gVjqQiWfpZuCM8aQTUuZM+sb6+xTSYi1eaI0J7l5M8qDgRc2jdiUsnxaRxriqerAx0VNct+zyUf9XLfuq+A3MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000358; c=relaxed/simple;
	bh=ACJwEmL1OqS0Hfjv2NJIGJM70QCVkY+gH14mL9yv5mU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T71el2xGj4rvFFYT0vzkiP3e8+hfzfANsV/SQcCvzVy0iOzKqdV0SNpUaxp7+CEKbdo6shZYZGmDmdTJW+T2Avv/udRCfHs/7JGGJHvHXj6QAaLwWz7LGJFXA5tQiIbkg10A3PG+ONcgHUN3YcQhcuAZv/CAEBm0jyM8jdw4sFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OOhg79Ri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OOhg79Ri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B12C433F1;
	Tue, 27 Feb 2024 02:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000358;
	bh=ACJwEmL1OqS0Hfjv2NJIGJM70QCVkY+gH14mL9yv5mU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OOhg79Ri2ALJCadOtkqvTUP6O9LdCF4r+nAzWYiX+T8TlJA7bNSBtuqHTNV0fokbf
	 9omVgJCqfMggpoLPHuI+PFrJrL3LFe6mCSkUrI8jV6lmkytP0189EpZpT+LYrVmEG7
	 FKxg/pUNevpvarrnX9ruuF3Cru0KJIv14cnNlB+2ZpvC8/RXahDtxIuTu8fCWOH8ly
	 tVKkHDhxjAkX3O1qjNbDgXxqpXsysDrqdRsm7LhxIdf4aquGsvKPfCliS5bKYa6BeT
	 ylTHZgGVN1hiohw68Lv0fs6Xn/HIRvxEQsMOirT+iBGHLV2/zLT5deFWjjIK+YVPNa
	 Zb2HVbA5Yi9Qg==
Date: Mon, 26 Feb 2024 18:19:18 -0800
Subject: [PATCH 2/2] xfs: only add log incompat features with explicit
 permission
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900010779.937966.9414612497822598030.stgit@frogsfrogsfrogs>
In-Reply-To: <170900010739.937966.5871198955451070108.stgit@frogsfrogsfrogs>
References: <170900010739.937966.5871198955451070108.stgit@frogsfrogsfrogs>
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

Only allow the addition of new log incompat features to the primary
superblock if the sysadmin provides explicit consent via a mount option
or if the process has administrative privileges.  This should prevent
surprises when trying to recover dirty logs on old kernels.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 Documentation/admin-guide/xfs.rst |    7 +++++++
 fs/xfs/xfs_mount.c                |   26 ++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h                |    3 +++
 fs/xfs/xfs_super.c                |   12 +++++++++++-
 4 files changed, 47 insertions(+), 1 deletion(-)


diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index b67772cf36d6d..52acd95b2b754 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -21,6 +21,13 @@ Mount Options
 
 When mounting an XFS filesystem, the following options are accepted.
 
+  add_log_feat/noadd_log_feat
+        Permit unprivileged userspace to use functionality that requires
+        the addition of log incompat feature bits to the superblock.
+        The feature bits will be cleared during a clean unmount.
+        Old kernels cannot recover dirty logs if they do not recognize
+        all log incompat feature bits.
+
   allocsize=size
 	Sets the buffered I/O end-of-file preallocation size when
 	doing delayed allocation writeout (default size is 64KiB).
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 912f3972ab413..6fd4ceeab0e26 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1279,6 +1279,27 @@ xfs_force_summary_recalc(
 	xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
 }
 
+/*
+ * Allow the log feature upgrade only if the sysadmin permits it via mount
+ * option; or the caller is the administrator.  If the @want_audit parameter
+ * is true, then a denial due to insufficient privileges will be logged.
+ */
+bool
+xfs_can_add_incompat_log_features(
+	struct xfs_mount	*mp,
+	bool			want_audit)
+{
+	/* Always allowed if the mount option is set */
+	if (mp->m_features & XFS_FEAT_ADD_LOG_FEAT)
+		return true;
+
+	/* Allowed for administrators */
+	if (want_audit)
+		return capable(CAP_SYS_ADMIN);
+
+	return has_capability_noaudit(current, CAP_SYS_ADMIN);
+}
+
 /*
  * Enable a log incompat feature flag in the primary superblock.  The caller
  * cannot have any other transactions in progress.
@@ -1320,6 +1341,11 @@ xfs_add_incompat_log_feature(
 	if (xfs_sb_has_incompat_log_feature(&mp->m_sb, feature))
 		goto rele;
 
+	if (!xfs_can_add_incompat_log_features(mp, true)) {
+		error = -EOPNOTSUPP;
+		goto rele;
+	}
+
 	/*
 	 * Write the primary superblock to disk immediately, because we need
 	 * the log_incompat bit to be set in the primary super now to protect
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 6ec038b88454c..654d282234b1e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -294,6 +294,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
 
 /* Mount features */
+#define XFS_FEAT_ADD_LOG_FEAT	(1ULL << 47)	/* can add log incompat features */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
 #define XFS_FEAT_NOALIGN	(1ULL << 49)	/* ignore alignment */
 #define XFS_FEAT_ALLOCSIZE	(1ULL << 50)	/* user specified allocation size */
@@ -356,6 +357,8 @@ __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 
+bool xfs_can_add_incompat_log_features(struct xfs_mount *mp, bool want_audit);
+
 /*
  * Mount features
  *
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4b22c30ac97a4..679b99bed5499 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -103,7 +103,8 @@ enum {
 	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
 	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
-	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum,
+	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_add_log_feat,
+	Opt_noadd_log_feat,
 };
 
 static const struct fs_parameter_spec xfs_fs_parameters[] = {
@@ -148,6 +149,8 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
 	fsparam_flag("nodiscard",	Opt_nodiscard),
 	fsparam_flag("dax",		Opt_dax),
 	fsparam_enum("dax",		Opt_dax_enum, dax_param_enums),
+	fsparam_flag("add_log_feat",	Opt_add_log_feat),
+	fsparam_flag("noadd_log_feat",	Opt_noadd_log_feat),
 	{}
 };
 
@@ -176,6 +179,7 @@ xfs_fs_show_options(
 		{ XFS_FEAT_LARGE_IOSIZE,	",largeio" },
 		{ XFS_FEAT_DAX_ALWAYS,		",dax=always" },
 		{ XFS_FEAT_DAX_NEVER,		",dax=never" },
+		{ XFS_FEAT_ADD_LOG_FEAT,	",add_log_feat" },
 		{ 0, NULL }
 	};
 	struct xfs_mount	*mp = XFS_M(root->d_sb);
@@ -1371,6 +1375,12 @@ xfs_fs_parse_param(
 		xfs_mount_set_dax_mode(parsing_mp, result.uint_32);
 		return 0;
 #endif
+	case Opt_add_log_feat:
+		parsing_mp->m_features |= XFS_FEAT_ADD_LOG_FEAT;
+		return 0;
+	case Opt_noadd_log_feat:
+		parsing_mp->m_features &= ~XFS_FEAT_ADD_LOG_FEAT;
+		return 0;
 	/* Following mount options will be removed in September 2025 */
 	case Opt_ikeep:
 		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_IKEEP, true);

