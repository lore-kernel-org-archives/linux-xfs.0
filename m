Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714051B3925;
	Mon, 12 Oct 2026 06:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784811; cv=none; b=THyGVApqzfAUdriBEMVsBXbA4uhKpA/BggNjwIKZnzxTa+lc6rVQei+H1pRfVyiN4/gMW9hgQvBjHXcPQ3gyroztSva+b4A/o5K/2Cchw9KeB/uACl9IRYoq5EXWjTIX4qlEkPcb31l+1Vp49cWuujB1wf7cjSWRHDyZQCc6eyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784811; c=relaxed/simple;
	bh=nzim75v42Ovq93Ja0nsXY8zj0Dw3r+fbQSnmO0hrPxc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CFTgyb+0SYm/AJezmzKX2dNFEX1nFzsuJhWymPcv2Tv+68OS2sLgQp/OkvXByR6BierE6NZ5ZkZtyIaMZCis7o16FPgiwB5/04gGshj9rUJ+oW+5G6MGpxrKsa9wvWkTsSoYdJhIP0cJs0doOeGynAHuwfeLrFDKU/gZetzjMiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=chvMOJNC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="chvMOJNC"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 472B71F0089B;
	Mon, 12 Oct 2026 06:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784810;
	bh=bOx2FVg6rDX7SJUBKQf0/PhuyoQNtWNslzV+X67BNxU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=chvMOJNC3WpqAgceeUQP76VssjNpo63f2UARcm8FIv/pi+FyA2oVwPWjM4xHWJ4GB
	 MKgOE1MHYj1DA7h8ITt8MznT6F1re7y8vg+/Jk6Gl+2Hei9897S1IlDcUwpkcQcfAl
	 nskmgMurhKHLFECX37fo99dFewa6Lkw0uKQeGozY/JSbUKkDV7ct4IUVVOHkHhM3Ef
	 DU2JJFwaq6DpsHnZ/T7AI8eWBYuwI4r1QCc+w4AjuXKY4kW0rwfIaUxt9zx8CMlzKT
	 aOCSw5ytJ9eyHqbpFU+Q9LGTy7s6zV47zZTwnF48AlNT6he38JmdNl8U9xbto5v4up
	 v4vnhJjLXW9uw==
Date: Sun, 11 Oct 2026 23:00:09 -0700
Subject: [PATCH 05/12] xfs: update quota flags on secondary supers when
 metadir enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179178065902.1058822.9213708539877630364.stgit@frogsfrogsfrogs>
In-Reply-To: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
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
 fs/xfs/xfs_mount.c |   17 ++++++++++++++++-
 fs/xfs/xfs_qm.c    |   25 ++++++++++++++++++++++++-
 2 files changed, 40 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index be90c7b0399484..4a2470466ad065 100644
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
@@ -458,7 +460,20 @@ xfs_mount_reset_sbqflags(
 	if (!xfs_fs_writable(mp, SB_FREEZE_WRITE))
 		return 0;
 
-	return xfs_sync_sb(mp, false);
+	error = xfs_sync_sb(mp, false);
+	if (error || !xfs_has_metadir(mp))
+		return error;
+
+	/*
+	 * For metadir filesystems, quota flag state persists across mounts, so
+	 * update secondary superblocks in case xfs_repair ever has to recover
+	 * the primary from a secondary.  growfs also updates backup supers so
+	 * lock against that.
+	 */
+	mutex_lock(&mp->m_growlock);
+	error = xfs_update_secondary_sbs(mp);
+	mutex_unlock(&mp->m_growlock);
+	return error;
 }
 
 static const char *const xfs_free_pool_name[] = {
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 008fed8624be2c..2e13c2cde8e2c4 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -718,7 +718,20 @@ xfs_qm_prep_metadir_sb(
 	spin_unlock(&mp->m_sb_lock);
 	xfs_log_sb(tp);
 
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	if (error)
+		return error;
+
+	/*
+	 * For metadir filesystems, quota flag state persists across mounts, so
+	 * update secondary superblocks in case xfs_repair ever has to recover
+	 * the primary from a secondary.  growfs also updates backup supers so
+	 * lock against that.
+	 */
+	mutex_lock(&mp->m_growlock);
+	error = xfs_update_secondary_sbs(mp);
+	mutex_unlock(&mp->m_growlock);
+	return error;
 }
 
 /*
@@ -1684,6 +1697,16 @@ xfs_qm_mount_quotas(
 			xfs_alert(mp, "%s: Superblock update failed!",
 				__func__);
 		}
+
+		/*
+		 * For metadir filesystems, quota flag state persists across
+		 * mounts, so update secondary superblocks in case xfs_repair
+		 * ever has to recover the primary from a secondary.  growfs
+		 * also updates backup supers so lock against that.
+		 */
+		mutex_lock(&mp->m_growlock);
+		xfs_update_secondary_sbs(mp);
+		mutex_unlock(&mp->m_growlock);
 	}
 
 	if (error) {

