Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D7F197
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371502; cv=none; b=bW1F5l00qYJPESfZRKEJchBvC3Zb8t/vBR9xj+SopELoSvF1SoXpgkDYeD7aNSfsFFDdPuOZNcS+vBU92llSu7Wu8xXmS9918h5BrYJGX9NQF03cdHVUPc3nG0plF3fyQMdoDwB8cyeVQuvhQTSMehJMSYNhQMaC+3Qa5zz+FnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371502; c=relaxed/simple;
	bh=mnOLIbu1a6DuCWvg7xbqF07L5Xe8Es+e0Hl+uVgOX0g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B7naSvXwv9GOlafrzSj94Yt+niEDV61Ke8BhlLlEsZm55NT8JNhw6/NP2ysq+uyHZSa6qhNNVj0u4/k2BKGq/bJHn6edjAIrWVBlWHRRFmzxx4oH7jnCWn9cH13WwpQTq81cC3RXG23kuqUzEy6Hw5VI/9sTNBtlCUwYLzCLGFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fLgttHEi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fLgttHEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5D1C32782;
	Fri, 23 Aug 2024 00:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371502;
	bh=mnOLIbu1a6DuCWvg7xbqF07L5Xe8Es+e0Hl+uVgOX0g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fLgttHEi6FuiXVFfEkLWctPM9dzP+Cc/M960PDxfSe2zApaYJ/EQlHMg3Jy5c023T
	 zYat0JawfyWD8swya/8GYDcH0s2AS5u8BkM6xtI5rs7Ixe6CHTH3KTYQJs7ihVMewS
	 MOW5gda5a6I2j6vvpaZSwPYi5LyXLxLcUni9iCEarlnM3uq4rYj4A6XaXhxIDFxRJW
	 zOw7UtdEEVv9+0xk59pT9qQm6w2K/GiDFS7NdpIij1Rs/8fdQRml5Y+XUkH+yk4OvS
	 Ax0s7X+b7cbNOp+ZiRF3yhO3VDHW6QFD41n0EjlPeaUyFoE3bgmHFyPYIe4VsQeSwQ
	 V8xHTAe0DUjYw==
Date: Thu, 22 Aug 2024 17:05:01 -0700
Subject: [PATCH 11/26] xfs: don't count metadata directory files to quota
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085364.57482.4719664018853105804.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
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

Files in the metadata directory tree are internal to the filesystem.
Don't count the inodes or the blocks they use in the root dquot because
users do not need to know about their resource usage.  This will also
quiet down complaints about dquot usage not matching du output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_dquot.c       |    1 +
 fs/xfs/xfs_qm.c          |   11 +++++++++++
 fs/xfs/xfs_quota.h       |    5 +++++
 fs/xfs/xfs_trans_dquot.c |    6 ++++++
 4 files changed, 23 insertions(+)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index c1b211c260a9d..3bf47458c517a 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -983,6 +983,7 @@ xfs_qm_dqget_inode(
 
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 	ASSERT(xfs_inode_dquot(ip, type) == NULL);
+	ASSERT(!xfs_is_metadir_inode(ip));
 
 	id = xfs_qm_id_for_quotatype(ip, type);
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index d0674d84af3ec..ec983cca9adae 100644
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
index 23d71a55bbc00..645761997bf2d 100644
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
index b368e13424c4f..ca7df018290e0 100644
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

