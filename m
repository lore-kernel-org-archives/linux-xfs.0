Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAA81DD0D2
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845219; cv=none; b=Oc34G2DXPusGR6sazNqN78OzonOqRk2jkMiQIytkJEx7VrgTKugxnJldO0zG/yWC0Eig+y/N8AgrnaZ/f0as9tlryrvvCy73Fm3fOpwxk/b870FZ+JPCRu9G0FiWbtdZ2ehonLEkrHk+LqC0JtoP4zHQBsJLU4rijx+cRWbSE20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845219; c=relaxed/simple;
	bh=BNFWjkLUzE0vCwCjD48h24sd9P0c8J8fCAn2eHmK+ZA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A0vqh+oALVzrTb13u3hN8GThQsJigRBGA7j/5YRToEGbZ0f4nXsDI/AHnKk7xmSN9uIp1qEocox/QKHLvvKqzrpyxO7zW1L67lJFdU3zMV2nZKp8kSUwm2vYtQ1hlAV8CG81tS9tLb9id7X2EsS97RF0oTWn5lXY+h3AlJMvq+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GGM4+mlx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GGM4+mlx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D269C4CECF;
	Tue,  5 Nov 2024 22:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845217;
	bh=BNFWjkLUzE0vCwCjD48h24sd9P0c8J8fCAn2eHmK+ZA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GGM4+mlxQ9xXl0YYKdA+uRhh8QxSP6VDVkRqthDudIIfBBAEz6uiw0m/nK38+uByo
	 /cWAMTamt+lrL1/++nX35m1m8hWz9UVAwX3HOIxC6zURmwBjHCMZrZVbKhNMrMf5qo
	 GEcuyPsYcTGBTUPhKFDHuCQOS5cpzuW/jmR0XPkqg6eL5QbtC7A4Ahxe3qacEncAyX
	 h6S1ed6IAwz2s9XDFjauoWWoBeH4AK4UOtuVD5nelDPF8eXmqCEP96jpCnMU6LwedS
	 TeYSmZQpO7u1ir2j4TKDMs0YoKssvtWfyE/w0oDfq/D9aMEUwfaRkuBuFON8OrqM0v
	 vjUAe5c5ottVg==
Date: Tue, 05 Nov 2024 14:20:16 -0800
Subject: [PATCH 14/28] xfs: don't count metadata directory files to quota
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396260.1870066.5496086039511886577.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
References: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Files in the metadata directory tree are internal to the filesystem.
Don't count the inodes or the blocks they use in the root dquot because
users do not need to know about their resource usage.  This will also
quiet down complaints about dquot usage not matching du output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c       |    1 +
 fs/xfs/xfs_qm.c          |   11 +++++++++++
 fs/xfs/xfs_quota.h       |    5 +++++
 fs/xfs/xfs_trans_dquot.c |    6 ++++++
 4 files changed, 23 insertions(+)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index c1b211c260a9d5..3bf47458c517af 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -983,6 +983,7 @@ xfs_qm_dqget_inode(
 
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 	ASSERT(xfs_inode_dquot(ip, type) == NULL);
+	ASSERT(!xfs_is_metadir_inode(ip));
 
 	id = xfs_qm_id_for_quotatype(ip, type);
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index d0674d84af3ec5..ec983cca9adaed 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -304,6 +304,8 @@ xfs_qm_need_dqattach(
 		return false;
 	if (xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
 		return false;
+	if (xfs_is_metadir_inode(ip))
+		return false;
 	return true;
 }
 
@@ -326,6 +328,7 @@ xfs_qm_dqattach_locked(
 		return 0;
 
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
+	ASSERT(!xfs_is_metadir_inode(ip));
 
 	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
 		error = xfs_qm_dqattach_one(ip, XFS_DQTYPE_USER,
@@ -1204,6 +1207,10 @@ xfs_qm_dqusage_adjust(
 		}
 	}
 
+	/* Metadata directory files are not accounted to user-visible quotas. */
+	if (xfs_is_metadir_inode(ip))
+		goto error0;
+
 	ASSERT(ip->i_delayed_blks == 0);
 
 	if (XFS_IS_REALTIME_INODE(ip)) {
@@ -1754,6 +1761,8 @@ xfs_qm_vop_dqalloc(
 	if (!XFS_IS_QUOTA_ON(mp))
 		return 0;
 
+	ASSERT(!xfs_is_metadir_inode(ip));
+
 	lockflags = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, lockflags);
 
@@ -1883,6 +1892,7 @@ xfs_qm_vop_chown(
 
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 	ASSERT(XFS_IS_QUOTA_ON(ip->i_mount));
+	ASSERT(!xfs_is_metadir_inode(ip));
 
 	/* old dquot */
 	prevdq = *IO_olddq;
@@ -1970,6 +1980,7 @@ xfs_qm_vop_create_dqattach(
 		return;
 
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
+	ASSERT(!xfs_is_metadir_inode(ip));
 
 	if (udqp && XFS_IS_UQUOTA_ON(mp)) {
 		ASSERT(ip->i_udquot == NULL);
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 23d71a55bbc006..645761997bf2d9 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -29,6 +29,11 @@ struct xfs_buf;
 	 (XFS_IS_GQUOTA_ON(mp) && (ip)->i_gdquot == NULL) || \
 	 (XFS_IS_PQUOTA_ON(mp) && (ip)->i_pdquot == NULL))
 
+#define XFS_IS_DQDETACHED(ip) \
+	((ip)->i_udquot == NULL && \
+	 (ip)->i_gdquot == NULL && \
+	 (ip)->i_pdquot == NULL)
+
 #define XFS_QM_NEED_QUOTACHECK(mp) \
 	((XFS_IS_UQUOTA_ON(mp) && \
 		(mp->m_sb.sb_qflags & XFS_UQUOTA_CHKD) == 0) || \
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index b368e13424c4f4..ca7df018290e0e 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -156,6 +156,8 @@ xfs_trans_mod_ino_dquot(
 	unsigned int			field,
 	int64_t				delta)
 {
+	ASSERT(!xfs_is_metadir_inode(ip) || XFS_IS_DQDETACHED(ip));
+
 	xfs_trans_mod_dquot(tp, dqp, field, delta);
 
 	if (xfs_hooks_switched_on(&xfs_dqtrx_hooks_switch)) {
@@ -247,6 +249,8 @@ xfs_trans_mod_dquot_byino(
 	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
 		return;
 
+	ASSERT(!xfs_is_metadir_inode(ip) || XFS_IS_DQDETACHED(ip));
+
 	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
 		xfs_trans_mod_ino_dquot(tp, ip, ip->i_udquot, field, delta);
 	if (XFS_IS_GQUOTA_ON(mp) && ip->i_gdquot)
@@ -962,6 +966,8 @@ xfs_trans_reserve_quota_nblks(
 
 	if (!XFS_IS_QUOTA_ON(mp))
 		return 0;
+	if (xfs_is_metadir_inode(ip))
+		return 0;
 
 	ASSERT(!xfs_is_quota_inode(&mp->m_sb, ip->i_ino));
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);

