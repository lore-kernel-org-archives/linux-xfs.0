Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F20BB653
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372940; cv=none; b=p+Zf3IoUzg3gTRUthapEOK0F26J+AtV8nBwUtvgLD3Mkaq7mELeqfm7vGIUV/mFuA4BZ3ztQH2CkmVUyqonKU3fHMFNCjWkfSNyKhcbk3oP+EM/6LsK2NEYlUEM8/QlifdWXKNmAZWiR3dp1Y1NtiTL9NcYOI5x5LemLtoSbruI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372940; c=relaxed/simple;
	bh=G0RHyyVoWqK0I9L730r1frFQT7tlsaPmsaiAm7md5qc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h9RqmqEqgDWRuQJqEO96eaFMxJkhQBKyNjr9CTOSlcKU/DtKsNLSkkrASv+1MY2KaY2Do9sjlzZlw8Ro/0uecMs40oGP4j2twN9e0G5d/JwoEyMcBnV8O0oGZciDODo9xa9TgB6gFl1jfHoMrzG6UJOmf+YUjyMnANZkdxwS3n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aBWxH3Ts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aBWxH3Ts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192CBC32782;
	Fri, 23 Aug 2024 00:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372940;
	bh=G0RHyyVoWqK0I9L730r1frFQT7tlsaPmsaiAm7md5qc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aBWxH3Tsv80o02JUNZTopkAlXsDn8v41x1ONuW5uDXERq75+SDkQFONg1IDQCKOA4
	 +L2Nf62aNsVxQwxRSJGtsBaUlfvX86L5r58+20tior7AfbMl7Bh5N7+qu6EZ9f/D/y
	 ACzeQRx5ONfk0G1fjt23cIzNLFfFonbBnjMWxBP70QTQC4j0r9fPNH5QTrEgy4krx5
	 TZVjQmXEX3RtakgfV7z2bo2Gi6FvwL3HVf53BI4ItmFTlCrDF/aUlPzCkc8bQdWmWx
	 vuQYnLezz+PhG6js9/1d6yBWdOeaQkj/OFGxDFWm+wdbpaAQdI7b91ZtEsgMkL1cHx
	 NuQ+0iJI2QQEg==
Date: Thu, 22 Aug 2024 17:28:59 -0700
Subject: [PATCH 4/6] xfs: persist quota flags with metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437089432.61495.8117184114353548540.stgit@frogsfrogsfrogs>
In-Reply-To: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
References: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
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

It's annoying that one has to keep reminding XFS about what quota
options it should mount with, since the quota flags recording the
previous state are sitting right there in the primary superblock.  Even
more strangely, there exists a noquota option to disable quotas
completely, so it's odder still that providing no options is the same as
noquota.

Starting with metadir, let's change the behavior so that if the user
does not specify any quota-related mount options at all, the ondisk
quota flags will be used to bring up quota.  In other words, the
filesystem will mount in the same state and with the same functionality
as it had during the last mount.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.c  |   15 +++++++++++++++
 fs/xfs/xfs_mount.h  |    6 ++++++
 fs/xfs/xfs_qm_bhv.c |   18 ++++++++++++++++++
 fs/xfs/xfs_quota.h  |    2 ++
 fs/xfs/xfs_super.c  |   22 ++++++++++++++++++++++
 5 files changed, 63 insertions(+)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5726ea597f5a2..cbf47354561c1 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -850,6 +850,13 @@ xfs_mountfs(
 	if (error)
 		goto out_fail_wait;
 
+	/*
+	 * If we're resuming quota status, pick up the preliminary qflags from
+	 * the ondisk superblock so that we know if we should recover dquots.
+	 */
+	if (xfs_is_resuming_quotaon(mp))
+		xfs_qm_resume_quotaon(mp);
+
 	/*
 	 * Log's mount-time initialization. The first part of recovery can place
 	 * some items on the AIL, to be handled when recovery is finished or
@@ -863,6 +870,14 @@ xfs_mountfs(
 		goto out_inodegc_shrinker;
 	}
 
+	/*
+	 * If we're resuming quota status and recovered the log, re-sample the
+	 * qflags from the ondisk superblock now that we've recovered it, just
+	 * in case someone shut down enforcement just before a crash.
+	 */
+	if (xfs_clear_resuming_quotaon(mp) && xlog_recovery_needed(mp->m_log))
+		xfs_qm_resume_quotaon(mp);
+
 	/*
 	 * If logged xattrs are still enabled after log recovery finishes, then
 	 * they'll be available until unmount.  Otherwise, turn them off.
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7e68812db1be7..ba9af63aec143 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -459,6 +459,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 #define XFS_OPSTATE_UNSET_LOG_INCOMPAT	11
 /* Filesystem can use logged extended attributes */
 #define XFS_OPSTATE_USE_LARP		12
+/* Filesystem should use qflags to determine quotaon status */
+#define XFS_OPSTATE_RESUMING_QUOTAON	13
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -483,8 +485,12 @@ __XFS_IS_OPSTATE(inodegc_enabled, INODEGC_ENABLED)
 __XFS_IS_OPSTATE(blockgc_enabled, BLOCKGC_ENABLED)
 #ifdef CONFIG_XFS_QUOTA
 __XFS_IS_OPSTATE(quotacheck_running, QUOTACHECK_RUNNING)
+__XFS_IS_OPSTATE(resuming_quotaon, RESUMING_QUOTAON)
 #else
 # define xfs_is_quotacheck_running(mp)	(false)
+# define xfs_is_resuming_quotaon(mp)	(false)
+# define xfs_set_resuming_quotaon(mp)	(false)
+# define xfs_clear_resuming_quotaon(mp)	(false)
 #endif
 __XFS_IS_OPSTATE(done_with_log_incompat, UNSET_LOG_INCOMPAT)
 __XFS_IS_OPSTATE(using_logged_xattrs, USE_LARP)
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index a11436579877d..79a96558f739e 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -135,3 +135,21 @@ xfs_qm_newmount(
 
 	return 0;
 }
+
+/*
+ * If the sysadmin didn't provide any quota mount options, restore the quota
+ * accounting and enforcement state from the ondisk superblock.  Only do this
+ * for metadir filesystems because this is a behavior change.
+ */
+void
+xfs_qm_resume_quotaon(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_has_metadir(mp))
+		return;
+	if (xfs_has_norecovery(mp))
+		return;
+
+	mp->m_qflags = mp->m_sb.sb_qflags & (XFS_ALL_QUOTA_ACCT |
+					     XFS_ALL_QUOTA_ENFD);
+}
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 645761997bf2d..2d36d967380e7 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -125,6 +125,7 @@ extern void xfs_qm_dqdetach(struct xfs_inode *);
 extern void xfs_qm_dqrele(struct xfs_dquot *);
 extern void xfs_qm_statvfs(struct xfs_inode *, struct kstatfs *);
 extern int xfs_qm_newmount(struct xfs_mount *, uint *, uint *);
+void xfs_qm_resume_quotaon(struct xfs_mount *mp);
 extern void xfs_qm_mount_quotas(struct xfs_mount *);
 extern void xfs_qm_unmount(struct xfs_mount *);
 extern void xfs_qm_unmount_quotas(struct xfs_mount *);
@@ -202,6 +203,7 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
 #define xfs_qm_dqrele(d)			do { (d) = (d); } while(0)
 #define xfs_qm_statvfs(ip, s)			do { } while(0)
 #define xfs_qm_newmount(mp, a, b)					(0)
+#define xfs_qm_resume_quotaon(mp)		((void)0)
 #define xfs_qm_mount_quotas(mp)
 #define xfs_qm_unmount(mp)
 #define xfs_qm_unmount_quotas(mp)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 835886c322a83..d02bfe9ddfe58 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -67,6 +67,9 @@ enum xfs_dax_mode {
 	XFS_DAX_NEVER = 2,
 };
 
+/* Were quota mount options provided?  Must use the upper 16 bits of qflags. */
+#define XFS_QFLAGS_MNTOPTS	(1U << 31)
+
 static void
 xfs_mount_set_dax_mode(
 	struct xfs_mount	*mp,
@@ -1264,6 +1267,8 @@ xfs_fs_parse_param(
 	int			size = 0;
 	int			opt;
 
+	BUILD_BUG_ON(XFS_QFLAGS_MNTOPTS & XFS_MOUNT_QUOTA_ALL);
+
 	opt = fs_parse(fc, xfs_fs_parameters, param, &result);
 	if (opt < 0)
 		return opt;
@@ -1341,32 +1346,39 @@ xfs_fs_parse_param(
 	case Opt_noquota:
 		parsing_mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
 		parsing_mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
+		parsing_mp->m_qflags |= XFS_QFLAGS_MNTOPTS;
 		return 0;
 	case Opt_quota:
 	case Opt_uquota:
 	case Opt_usrquota:
 		parsing_mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ENFD);
+		parsing_mp->m_qflags |= XFS_QFLAGS_MNTOPTS;
 		return 0;
 	case Opt_qnoenforce:
 	case Opt_uqnoenforce:
 		parsing_mp->m_qflags |= XFS_UQUOTA_ACCT;
 		parsing_mp->m_qflags &= ~XFS_UQUOTA_ENFD;
+		parsing_mp->m_qflags |= XFS_QFLAGS_MNTOPTS;
 		return 0;
 	case Opt_pquota:
 	case Opt_prjquota:
 		parsing_mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ENFD);
+		parsing_mp->m_qflags |= XFS_QFLAGS_MNTOPTS;
 		return 0;
 	case Opt_pqnoenforce:
 		parsing_mp->m_qflags |= XFS_PQUOTA_ACCT;
 		parsing_mp->m_qflags &= ~XFS_PQUOTA_ENFD;
+		parsing_mp->m_qflags |= XFS_QFLAGS_MNTOPTS;
 		return 0;
 	case Opt_gquota:
 	case Opt_grpquota:
 		parsing_mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ENFD);
+		parsing_mp->m_qflags |= XFS_QFLAGS_MNTOPTS;
 		return 0;
 	case Opt_gqnoenforce:
 		parsing_mp->m_qflags |= XFS_GQUOTA_ACCT;
 		parsing_mp->m_qflags &= ~XFS_GQUOTA_ENFD;
+		parsing_mp->m_qflags |= XFS_QFLAGS_MNTOPTS;
 		return 0;
 	case Opt_discard:
 		parsing_mp->m_features |= XFS_FEAT_DISCARD;
@@ -1761,6 +1773,14 @@ xfs_fs_fill_super(
 		xfs_warn(mp,
 	"EXPERIMENTAL parent pointer feature enabled. Use at your own risk!");
 
+	/*
+	 * If no quota mount options were provided, maybe we'll try to pick
+	 * up the quota accounting and enforcement flags from the ondisk sb.
+	 */
+	if (!(mp->m_qflags & XFS_QFLAGS_MNTOPTS))
+		xfs_set_resuming_quotaon(mp);
+	mp->m_qflags &= ~XFS_QFLAGS_MNTOPTS;
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;
@@ -1947,6 +1967,8 @@ xfs_fs_reconfigure(
 	int			flags = fc->sb_flags;
 	int			error;
 
+	new_mp->m_qflags &= ~XFS_QFLAGS_MNTOPTS;
+
 	/* version 5 superblocks always support version counters. */
 	if (xfs_has_crc(mp))
 		fc->sb_flags |= SB_I_VERSION;

