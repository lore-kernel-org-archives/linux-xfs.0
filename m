Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5280F499F20;
	Tue, 13 Oct 2026 06:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871781; cv=none; b=Dpi26++x91TXYoZshHqe5rhbo4tJ1crs1s2rHoeMGW7L2MWIc1vlEYH6Aew3E95g1OgJJwqLfqYdaQOcjiW1oa2bTZ66CLKvqOX9+qghmHxpTjRP75BlfvAxbFAJ4v3NFblabs9o9cuJZqofpq6oUzUsd8Vvdanb5SCzLKlQ7b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871781; c=relaxed/simple;
	bh=mIrmOBrHrg2nUpyE80GVrEseOD0XnKtDxXHrv15OhQI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pLS+H4bp2efaOY3ZuUoZJzFvzDMZ3NB0c3FsrZ+3iinvvsjq5VZSWOy5RaGGkJUkS0KIW4KohTBsWG28AYz5tbp62W0YFJFzH2vw54wm58uOHTLuXBLw1xoVgtKqFp0LOhsYClWl9J6IFrL0YGAqIA6f1gw9wmBnEVnpF7GzAy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F5NImxBF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F5NImxBF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D8BF41F000FF;
	Tue, 13 Oct 2026 06:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871778;
	bh=bWRhghy11gS04pYgXQqq5ZyQB95VJsuwhYUZu7pk5Y4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=F5NImxBFMqW0Ec0n6/3PI8Eq8gR5nijF46D2nFB2eVN14JGLBd8RDbYPf4Qowo63v
	 0zdYJNF852K/77lwRM+BOc/CyBj2KceCKXiBhttMCj67+kAxEuqkhB2emTIdLlTZZ+
	 DYMft8JCSzFtU3pZDoa5Z0LWavfPxXMlMgKOm3PmXB7gUftKiOaSt+JJdHnr3y1Uhv
	 L9P0incSgKN8xk+7Rr9xVP6gXjTwAt1TU50oail3nF7s8x0zmBRWzMlmxFEtoQ2nSL
	 ewNNsrWNpP7HOi3z9/lLES2gknDQsZ/by+WDKeNL0dRbRysqLak/0M0yqqlUz6If9o
	 Sak68UkeRAm5Q==
Date: Mon, 12 Oct 2026 23:09:38 -0700
Subject: [PATCH 05/12] xfs: update quota flags on secondary supers when
 metadir enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179186107949.1898896.7157266495683086793.stgit@frogsfrogsfrogs>
In-Reply-To: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
References: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

xfs/085 exposes an interesting bug when metadir is enabled, quotas are
enabled via mount option, and the primary superblock crc fails
validation:

 Phase 1 - find and verify superblock...
 bad primary superblock - bad CRC in superblock !!!

 attempting to find secondary superblock...
 .found candidate secondary superblock...
 verified secondary superblock...
 quota accounting and enforcement flags lost

<snip>

 Phase 3 - for each AG...
         - scan and clear agi unlinked lists...
         - process known inodes and perform inode discovery...
         - agno = 0
         - agno = 1
         - agno = 2
 unexpected regular file inode 16908418 with metadata flag will zap
 cleared inode 16908418
 unexpected regular file inode 16908419 with metadata flag will zap
 cleared inode 16908419
 unexpected regular file inode 16908420 with metadata flag will zap
 cleared inode 16908420
         - agno = 3
         - process newly discovered inodes...

Quota files have been created, but xfs_repair thinks that quotas aren't
enabled and trashes the quota files.  Looking at the filesystem reveals
that the quota accounting flags were indeed persisted to the primary
superblock but not the secondary:

 # xfs_db -c 'sb 0' -c 'print qflags' -c 'sb 1' -c 'print qflags' /dev/sdf
 Metadata corruption detected at 0x561c68436080, inode 0x81 dinode
 xfs_db: Failed to load metadir root directory, error 117
 Metadata corruption detected at 0x561c683f7c80, xfs_agf block 0x1/0x200
 xfs_db: cannot init perag data (117). Continuing anyway.
 Metadata CRC error detected at 0x561c6844d1b5, xfs_sb block 0x0/0x200
 qflags = 0x7cf
 qflags = 0

On a metadir filesystem, quota state is supposed to persist across
mount cycles if the sysadmin doesn't provide any quota mount options.
Therefore, any time we update the quota flags on a metadir filesystem,
we should write the same change to the secondary supers so that
xfs_repair will find the quota data if it ever has to restore from a
secondary.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: d5d9dd5b3026a8 ("xfs: persist quota flags with metadir")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_quota.h |    9 +++++++++
 fs/xfs/xfs_mount.c |    9 ++++++++-
 fs/xfs/xfs_qm.c    |   36 +++++++++++++++++++++++++++++++++++-
 3 files changed, 52 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 105e6eb5762011..b323a72dafbcde 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -151,6 +151,8 @@ void xfs_dqtrx_hook_setup(struct xfs_dqtrx_hook *hook, notifier_fn_t mod_fn,
 		xfs_trans_mod_dquot((tp), (dqp), (field), (delta))
 # endif /* CONFIG_XFS_LIVE_HOOKS */
 
+void __xfs_qm_update_secondary_sb(struct xfs_mount *mp,
+		const char *func);
 #else
 static inline int
 xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
@@ -216,8 +218,15 @@ static inline int xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
 #  define xfs_dqtrx_hook_disable()		((void)0)
 # endif /* CONFIG_XFS_LIVE_HOOKS */
 
+static inline void __xfs_qm_update_secondary_sb(struct xfs_mount *mp,
+		const char *func)
+{
+}
 #endif /* CONFIG_XFS_QUOTA */
 
+#define xfs_qm_update_secondary_sb(mp) \
+	__xfs_qm_update_secondary_sb((mp), __func__)
+
 static inline void
 xfs_quota_unreserve_blkres(struct xfs_inode *ip, uint64_t blocks)
 {
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index be90c7b0399484..8838eff1f054d5 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -446,6 +446,8 @@ int
 xfs_mount_reset_sbqflags(
 	struct xfs_mount	*mp)
 {
+	int			error;
+
 	mp->m_qflags = 0;
 
 	/* It is OK to look at sb_qflags in the mount path without m_sb_lock. */
@@ -458,7 +460,12 @@ xfs_mount_reset_sbqflags(
 	if (!xfs_fs_writable(mp, SB_FREEZE_WRITE))
 		return 0;
 
-	return xfs_sync_sb(mp, false);
+	error = xfs_sync_sb(mp, false);
+	if (error)
+		return error;
+
+	xfs_qm_update_secondary_sb(mp);
+	return 0;
 }
 
 static const char *const xfs_free_pool_name[] = {
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 008fed8624be2c..dd5011f578a63b 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -693,6 +693,32 @@ xfs_qm_create_metadir_qinos(
 	return 0;
 }
 
+/*
+ * For metadir filesystems, quota flag state persists across mounts, so update
+ * secondary superblocks in case xfs_repair ever has to recover the primary
+ * from a secondary.  growfs also updates backup supers so lock against that.
+ * Note that the secondary backups are opportunistic, so we log but do not
+ * return write errors.
+ */
+void
+__xfs_qm_update_secondary_sb(
+	struct xfs_mount	*mp,
+	const char		*func)
+{
+	int			error;
+
+	if (!xfs_has_metadir(mp))
+		return;
+
+	mutex_lock(&mp->m_growlock);
+	error = xfs_update_secondary_sbs(mp);
+	mutex_unlock(&mp->m_growlock);
+
+	if (error)
+		xfs_alert(mp, "%s: Secondary super update failed, err=%d!",
+				func, error);
+}
+
 /*
  * Add QUOTABIT to sb_versionnum and initialize qflags in preparation for
  * creating quota files on a metadir filesystem.
@@ -718,7 +744,12 @@ xfs_qm_prep_metadir_sb(
 	spin_unlock(&mp->m_sb_lock);
 	xfs_log_sb(tp);
 
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	if (error)
+		return error;
+
+	xfs_qm_update_secondary_sb(mp);
+	return 0;
 }
 
 /*
@@ -1683,6 +1714,9 @@ xfs_qm_mount_quotas(
 			ASSERT(!(XFS_IS_QUOTA_ON(mp)));
 			xfs_alert(mp, "%s: Superblock update failed!",
 				__func__);
+		} else {
+			/* Primary update succeeded, try to write secondary */
+			xfs_qm_update_secondary_sb(mp);
 		}
 	}
 

