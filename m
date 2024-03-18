Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4295A11B
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798449; cv=none; b=B1OPQ7lV4YT2waXlILlgoCRzpHqWnH55wDRxEGTYQeVbW0m/yBQl4GESz3mcMuMSUEM/gKem9JE8TpiOE1vCRDSuKWNnTJkDt2sXFEA9Y15EnAUgN08ePtFoMu+Yavs7NSs3msanxV+Ea0NYKBBw1tNXtlOrKRsR1hEkPYw18xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798449; c=relaxed/simple;
	bh=zX4KIAyxRg49lFIhK8UCJ3hJ7PVtMLIqLrAdAe8SMug=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bSF2et3+H6ffPNfUqwGAhqj+gZquwhs+IQijCvjVJkJPIHgaUEgE2qOViBtn+ogpTN/dC4/K9MqenPQlAbE25ZgOwhOfZVuQ+FzhCIim4z3f8aIxcOjrjvUK/VO989efjpDYPVrqO+knUA4Ylyzi5xvrrrP/cGzRYT2P8wt9ypo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UpxhnIEU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UpxhnIEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD58C43399;
	Mon, 18 Mar 2024 21:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798449;
	bh=zX4KIAyxRg49lFIhK8UCJ3hJ7PVtMLIqLrAdAe8SMug=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UpxhnIEUrBLP3xO4j+cOOk1vUlZazZTKMOMvM2JLjOdBVdj6ezt+jge4UcNJEyJGL
	 /OChp6K/vhl/FVw3Di6S9Rl+OFxt81Fc5QeIRck7b6X7htGrSJF6HLgFe9q7ZYaJ9H
	 o/0dd+3usUoVYLPVen5R0ol5+OfGI8i/xjbz85pkwepbFnYkBfqAbAjaRfvFIi3yPD
	 r5ONG7PWJXZM213QnQPbZVst5GR29Fq/ug/eH2mudEJSFhw6fErtuSj1AMecT3SK3P
	 0SnWTr0ULxZLETGKzB1bolIS0y2jqy5cgLbEPirLpKkrEbhcylnsrkGax/VXTX/8cg
	 tEVsLiAz+LDbw==
Date: Mon, 18 Mar 2024 14:47:28 -0700
Subject: [PATCH 21/23] xfs: allow adding multiple log incompat feature bits
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802217.3806377.16057182826490832508.stgit@frogsfrogsfrogs>
In-Reply-To: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
References: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
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

Make it so that we can set multiple log incompat feature bits at once.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../filesystems/xfs/xfs-online-fsck-design.rst     |    2 +-
 fs/xfs/xfs_exchrange.c                             |    2 +-
 fs/xfs/xfs_mount.c                                 |   13 ++++++-------
 fs/xfs/xfs_mount.h                                 |    2 +-
 fs/xfs/xfs_xattr.c                                 |    2 +-
 5 files changed, 10 insertions(+), 11 deletions(-)


diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
index 1b454282ea9cf..f2f8509fa8540 100644
--- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
@@ -4055,7 +4055,7 @@ series.
 | clear the bit; if the lock attempt fails, the feature bit remains set.   |
 | The code supporting a log incompat feature should create wrapper         |
 | functions to obtain the log feature and call                             |
-| ``xfs_add_incompat_log_feature`` to set the feature bits in the primary  |
+| ``xfs_add_incompat_log_features`` to set the feature bits in the primary |
 | superblock.                                                              |
 | The superblock update is performed transactionally, so the wrapper to    |
 | obtain log assistance must be called just prior to the creation of the   |
diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index 73eae27a23016..3a68957c72d28 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -72,7 +72,7 @@ xfs_exchrange_enable(
 	if (!xfs_exchrange_upgradeable(mp))
 		return -EOPNOTSUPP;
 
-	error = xfs_add_incompat_log_feature(mp,
+	error = xfs_add_incompat_log_features(mp,
 			XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 49d6c6de7b33b..8d56ec1779f26 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1305,15 +1305,14 @@ xfs_can_add_incompat_log_features(
  * cannot have any other transactions in progress.
  */
 int
-xfs_add_incompat_log_feature(
+xfs_add_incompat_log_features(
 	struct xfs_mount	*mp,
-	uint32_t		feature)
+	uint32_t		features)
 {
 	struct xfs_dsb		*dsb;
 	int			error;
 
-	ASSERT(hweight32(feature) == 1);
-	ASSERT(!(feature & XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN));
+	ASSERT(!(features & XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN));
 
 	/*
 	 * Force the log to disk and kick the background AIL thread to reduce
@@ -1338,7 +1337,7 @@ xfs_add_incompat_log_feature(
 		goto rele;
 	}
 
-	if (xfs_sb_has_incompat_log_feature(&mp->m_sb, feature))
+	if ((mp->m_sb.sb_features_log_incompat & features) == features)
 		goto rele;
 
 	if (!xfs_can_add_incompat_log_features(mp, true)) {
@@ -1353,7 +1352,7 @@ xfs_add_incompat_log_feature(
 	 */
 	dsb = mp->m_sb_bp->b_addr;
 	xfs_sb_to_disk(dsb, &mp->m_sb);
-	dsb->sb_features_log_incompat |= cpu_to_be32(feature);
+	dsb->sb_features_log_incompat |= cpu_to_be32(features);
 	error = xfs_bwrite(mp->m_sb_bp);
 	if (error)
 		goto shutdown;
@@ -1362,7 +1361,7 @@ xfs_add_incompat_log_feature(
 	 * Add the feature bits to the incore superblock before we unlock the
 	 * buffer.
 	 */
-	xfs_sb_add_incompat_log_features(&mp->m_sb, feature);
+	xfs_sb_add_incompat_log_features(&mp->m_sb, features);
 	xfs_buf_relse(mp->m_sb_bp);
 
 	/* Log the superblock to disk. */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 0d9f66ac50af2..fc812bad57b84 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -577,7 +577,7 @@ int	xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
 struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
 		int error_class, int error);
 void xfs_force_summary_recalc(struct xfs_mount *mp);
-int xfs_add_incompat_log_feature(struct xfs_mount *mp, uint32_t feature);
+int xfs_add_incompat_log_features(struct xfs_mount *mp, uint32_t feature);
 bool xfs_clear_incompat_log_features(struct xfs_mount *mp);
 void xfs_mod_delalloc(struct xfs_mount *mp, int64_t delta);
 
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 055283fb147ae..6fb41705a10fb 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -44,7 +44,7 @@ xfs_attr_grab_log_assist(
 		return -EOPNOTSUPP;
 
 	/* Enable log-assisted xattrs. */
-	error = xfs_add_incompat_log_feature(mp,
+	error = xfs_add_incompat_log_features(mp,
 			XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
 	if (error)
 		return error;

