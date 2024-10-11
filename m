Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C882D517
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609126; cv=none; b=spxKyktMcdXejkG1UdNwXCPAZDH/RMiOKXeV8kbtSNbJa7jXqz3DAUk5gHG/kwIEA5GBVEp5+iEGze4CDfcWG/sap2LQHAQUQhCPRNBpnuGzmPPo2DGvonXf4Fc6TQFcR9Ave/1ZArtq2ZU8zXUOfrxAP+R9wFVslHRxR/KEuBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609126; c=relaxed/simple;
	bh=XL/YH+KvYK0JHcj6w+ZmiOx+zDACNbVTneMi9zpcJ04=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gK/VlNog4dntoEwqZzEptuAInh+eZFZk+3HFaEZomQgFEgz8QzZA8FmiO86i3d9mlT3Elf0KcgJVOipyF1Cude6wj0X4DLuhaBFrMhDORJhgq4pSqWdtGmM3M0GGVU+P4gP4YhQHNttDMS4NZOZWy5RjGd+mwMlAo1Ph5rLmfaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yd0/a6YC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yd0/a6YC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED29EC4CEC5;
	Fri, 11 Oct 2024 01:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609126;
	bh=XL/YH+KvYK0JHcj6w+ZmiOx+zDACNbVTneMi9zpcJ04=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Yd0/a6YC5Rlg+bA2bDKt0t5Hti5KjY0wdisrHhOVxGVPWC1S5x0otT60iZEa7Ulpj
	 dftZC8I9o4MOvxLAf5yDUOAN5mwTcC1p1vxtzIDCH4XcsGig9UZ49/Jdf8t9r+pZFk
	 6krLyYPYB+FoS74BpNpCNb00b84EHuB5/TGVLL5rSspGTMaTqXntj7B+3+5+diyH/t
	 vYdbnEFoNclr8gK0Wmtiohnko91BtD9kPRFHYi0OFITjpclYAbNoYvgpUdukuYzUbi
	 jOJhFXpVBgTrmUu1IaVCHLy4BBC5MRyHSu0VQ/oOCwjgw/bOnXJjQyZJskF7VYSest
	 JulB0rdQf6cHQ==
Date: Thu, 10 Oct 2024 18:12:05 -0700
Subject: [PATCH 4/4] xfs: persist quota flags with metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860645301.4179917.7707822427462299866.stgit@frogsfrogsfrogs>
In-Reply-To: <172860645220.4179917.14075452764287165701.stgit@frogsfrogsfrogs>
References: <172860645220.4179917.14075452764287165701.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_mount.c  |   15 +++++++++++++++
 fs/xfs/xfs_mount.h  |    6 ++++++
 fs/xfs/xfs_qm_bhv.c |   18 ++++++++++++++++++
 fs/xfs/xfs_quota.h  |    2 ++
 fs/xfs/xfs_super.c  |   22 ++++++++++++++++++++++
 5 files changed, 63 insertions(+)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index dba1f6fc688166..5918f433dba754 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -852,6 +852,13 @@ xfs_mountfs(
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
@@ -865,6 +872,14 @@ xfs_mountfs(
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
index 5c9c53b3591b2e..0f6a1be3967c36 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -489,6 +489,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 #define XFS_OPSTATE_UNSET_LOG_INCOMPAT	11
 /* Filesystem can use logged extended attributes */
 #define XFS_OPSTATE_USE_LARP		12
+/* Filesystem should use qflags to determine quotaon status */
+#define XFS_OPSTATE_RESUMING_QUOTAON	13
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -513,8 +515,12 @@ __XFS_IS_OPSTATE(inodegc_enabled, INODEGC_ENABLED)
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
index a11436579877d5..79a96558f739e3 100644
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
index 645761997bf2d9..2d36d967380e7c 100644
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
index 503db1308515dd..90d79d22793e79 100644
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
@@ -1773,6 +1785,14 @@ xfs_fs_fill_super(
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
@@ -1959,6 +1979,8 @@ xfs_fs_reconfigure(
 	int			flags = fc->sb_flags;
 	int			error;
 
+	new_mp->m_qflags &= ~XFS_QFLAGS_MNTOPTS;
+
 	/* version 5 superblocks always support version counters. */
 	if (xfs_has_crc(mp))
 		fc->sb_flags |= SB_I_VERSION;

