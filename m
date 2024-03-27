Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EA118C36
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504261; cv=none; b=auuT80Wap8ym63q+t5LWS+8AfJUC5C9LJLEj79cUoMq5VoeZccsEiIFJjtxeSnLEMatpv3RBkt38kg6giaAiBRxadthlHxIo9vBwliC7m+gKELbFomrJeUEpFaby5rxiTfyux4sDIWptUQiEeLDQlI5j6oUeC0kVxw658mM+2dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504261; c=relaxed/simple;
	bh=CiS5ziXf5tEXw2jVqIcO/I+qWrkssnUASCPRjXhRx4s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D1ejpgP35iH1/Dzf1cJE33eWoQQTrMSOScBwKdli0VFAr6l3SSjBuYGlJW9JcKpuFV7HfFtudeV34wJVMRuYZfDy6pm88WA4q6ODpWrzeZ872HQrrdCrREdEYEMDCldoKYxjYYC7Bv5DNQhHN2+j4Hx4qo+EVkZqsJOAX8DA71g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bVddcDOa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bVddcDOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DE6C43394;
	Wed, 27 Mar 2024 01:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504261;
	bh=CiS5ziXf5tEXw2jVqIcO/I+qWrkssnUASCPRjXhRx4s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bVddcDOaiOe2XbHmmCvCXR37maR2+iet3fBer6WX7swqmDkDLjJnQWEJrCxv5yBvR
	 p/P/K1AYzsHBx7gZB3WYkvQD9/MCGaEw/PVXV6uM9p1btEiPJW9YHZubadDqiZ38KH
	 35d6Bx9ovyZTypzRFUXE7dDtNyWf4yA2w08K2EPCD+l+VqCPfr9Tmtb8mbKo5iMBUn
	 ijXxa6kMb/Xlr++6uRUARVlDs5HtxZN+A0qYhvVJYzCK4UD7ISdNUFlMrPhU8VbqJR
	 wIx53IstLT29HDEV/DJrqs2QNxpdjU1cO9Fi/m+gOhIQELaXQ/Q1sAJiunz3B+abbz
	 CF2nAji4k0wXQ==
Date: Tue, 26 Mar 2024 18:51:00 -0700
Subject: [PATCH 2/2] xfs: only add log incompat features with explicit
 permission
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150379761.3216346.9053282853553134545.stgit@frogsfrogsfrogs>
In-Reply-To: <171150379721.3216346.4387266050277204544.stgit@frogsfrogsfrogs>
References: <171150379721.3216346.4387266050277204544.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index d37ba10f5fa33..a0b271758f910 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1281,6 +1281,27 @@ xfs_force_summary_recalc(
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
@@ -1322,6 +1343,11 @@ xfs_add_incompat_log_feature(
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
index c21f10ab0f5db..a2dcbac6effe9 100644
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
@@ -1368,6 +1372,12 @@ xfs_fs_parse_param(
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

