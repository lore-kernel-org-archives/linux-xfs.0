Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8884219CB4
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191384; cv=none; b=t2DKeddXsLvxW87wIJpgFEKHfh0IqfxCT7tlHkLREDM/TncU8J5GhM6oVefdbUUg0gtn41F5J72EyujI79w046bVBjNUhZpUKVw7EnUFrF0jp7ZYZdJcNnQFP7EqP2gO9mseHpyMSsCGCORBvMqowTZsSzfZwW/FXRzuWWWLgcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191384; c=relaxed/simple;
	bh=J6FlkJMLJx8EH2C0ymhJg2f3XEpocxCn6q1Focl/ij0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fJvyU5q4F2A77MEeMyGDa7sKILlPtZSwdovumxarbkZYhtRSudfJUw9G5zFqxRkd8ZLLjN+YagNYrD+635H9gnIg3FKnDqBilBEn01YVzGkZpByOkGLlVAzH/HNjQdPh9W+NRawyzn/az/2nwMtyqW0JA6WkV1Kc+hpqlyPdz6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I/pOPPJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I/pOPPJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A86EC4CEC3;
	Thu, 17 Oct 2024 18:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191384;
	bh=J6FlkJMLJx8EH2C0ymhJg2f3XEpocxCn6q1Focl/ij0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=I/pOPPJnEN8Y33l70p6d5VDtA5v0qgbTL1lZQD8O6uwZkAMCxkwIXwkcvoSCwTI6v
	 eV/fHR+MseRojyOKAq704JYu8B4M6xvIkr1P7O2MCr6CqC3TdwFa8NUsr1jREprX61
	 iBx2h3/epZpcaJnjChlyPWCr2ydZx++26nItHFtHIdJw2BDTE3Xwb8lDPd/bYrxIyd
	 5ATILkaSBW7pzgEaJvLaaeUlkeRq9FWB37d+OTGaIJYZ1DfFCQFmrxTtgtdoWyi9bp
	 iJVtMmz+84Xd4BGEKqr2gU2rgZ5yfB2X4GB/DkHUoqxz5EdIrY4SpOxzKs6irEu5aV
	 Oc335lR9aRTQA==
Date: Thu, 17 Oct 2024 11:56:24 -0700
Subject: [PATCH 10/29] xfs: disable the agi rotor for metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919069621.3451313.1575396046788808304.stgit@frogsfrogsfrogs>
In-Reply-To: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Ideally, we'd put all the metadata inodes in one place if we could, so
that the metadata all stay reasonably close together instead of
spreading out over the disk.  Furthermore, if the log is internal we'd
probably prefer to keep the metadata near the log.  Therefore, disable
AGI rotoring for metadata inode allocations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ialloc.c |   58 ++++++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index f0261c4d91061c..8b84e2cf711b19 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1841,6 +1841,40 @@ xfs_dialloc_try_ag(
 	return error;
 }
 
+/*
+ * Pick an AG for the new inode.
+ *
+ * Directories, symlinks, and regular files frequently allocate at least one
+ * block, so factor that potential expansion when we examine whether an AG has
+ * enough space for file creation.  Try to keep metadata files all in the same
+ * AG.
+ */
+static inline xfs_agnumber_t
+xfs_dialloc_pick_ag(
+	struct xfs_mount	*mp,
+	struct xfs_inode	*dp,
+	umode_t			mode)
+{
+	xfs_agnumber_t		start_agno;
+
+	if (!dp)
+		return 0;
+	if (xfs_is_metadir_inode(dp)) {
+		if (mp->m_sb.sb_logstart)
+			return XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart);
+		return 0;
+	}
+
+	if (S_ISDIR(mode))
+		return (atomic_inc_return(&mp->m_agirotor) - 1) % mp->m_maxagi;
+
+	start_agno = XFS_INO_TO_AGNO(mp, dp->i_ino);
+	if (start_agno >= mp->m_maxagi)
+		start_agno = 0;
+
+	return start_agno;
+}
+
 /*
  * Allocate an on-disk inode.
  *
@@ -1856,31 +1890,19 @@ xfs_dialloc(
 	xfs_ino_t		*new_ino)
 {
 	struct xfs_mount	*mp = (*tpp)->t_mountp;
+	struct xfs_perag	*pag;
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	xfs_ino_t		ino = NULLFSINO;
 	xfs_ino_t		parent = args->pip ? args->pip->i_ino : 0;
-	umode_t			mode = args->mode & S_IFMT;
 	xfs_agnumber_t		agno;
-	int			error = 0;
 	xfs_agnumber_t		start_agno;
-	struct xfs_perag	*pag;
-	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	umode_t			mode = args->mode & S_IFMT;
 	bool			ok_alloc = true;
 	bool			low_space = false;
 	int			flags;
-	xfs_ino_t		ino = NULLFSINO;
+	int			error = 0;
 
-	/*
-	 * Directories, symlinks, and regular files frequently allocate at least
-	 * one block, so factor that potential expansion when we examine whether
-	 * an AG has enough space for file creation.
-	 */
-	if (S_ISDIR(mode))
-		start_agno = (atomic_inc_return(&mp->m_agirotor) - 1) %
-				mp->m_maxagi;
-	else {
-		start_agno = XFS_INO_TO_AGNO(mp, parent);
-		if (start_agno >= mp->m_maxagi)
-			start_agno = 0;
-	}
+	start_agno = xfs_dialloc_pick_ag(mp, args->pip, mode);
 
 	/*
 	 * If we have already hit the ceiling of inode blocks then clear

