Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332231C548E
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528301; cv=none; b=RiV7pyDSNAlgJDMsgznYH7WLqdlxbm2+faBdNx+BhB+t+vRh29UKgwWBoIvfKoUL/e5TZ4ps1PVUQpe3FcbAobXFpaTw/L1xnRLDCg15xg84JGjuD5qpJLsc6ymbRVnWKq+ajU7258Qyvlq8yv46TtsETc0avmFspF7ezgLgzpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528301; c=relaxed/simple;
	bh=oxjh7kBLjtEhobK1FPbM45oYdkoYPhXqz8TCDXlHHPI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YsQJ/uggTBEiMipWVZRjuDmeM7RHyQrOHAK3WzCSZwR+yiclEh5gvhd2YVx8sK7DCSYgtseZXb8KE1iHOmXAYky5o6mYIzXSVc6WgZMgiHOVPtzfWVY0RPhD2Xp2kRdk08Z99LsfDsG8ZeBAsd+Z3nqIxC7ZWkCFbxYchkaqtpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G/8N++31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G/8N++31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D3AC4CED1;
	Fri,  6 Dec 2024 23:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528301;
	bh=oxjh7kBLjtEhobK1FPbM45oYdkoYPhXqz8TCDXlHHPI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G/8N++31Gdg9U6QGpy4wTwsrb6IMd2EQxcvjRU/4l6pIY8Qhq7aEmeCFB6KvQSpYc
	 xiPlgEt5dFQ/06DE8C+p5qnTO1gP/xcRCGXGISRF+NI1sVBEXEgn3zoP2sazLJiOAp
	 c/4SQfErpGRpUYiPiYAE/mcmv5fz/DsMYijIXGyVYBCf+6Ua56dAqy1PaFYlxcIXzi
	 S2UtTwNwBVWSRJ0ZidhDbenvNMbNZVS9kuObfLRB52+WUvVS3tADkPQMRXn9ZT+w08
	 P/j9t9TtPUiOt5gesiF0/fz6hNz4GOCPKTZDFfIWzGCkD87NIhm/gxtQm5+FG+h6uG
	 Qv4jRzQMCWR6Q==
Date: Fri, 06 Dec 2024 15:38:20 -0800
Subject: [PATCH 31/36] xfs: disable the agi rotor for metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747349.121772.12239653896060824999.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 8651b410ae781cc607159c51dbb0b317b23543b1

Ideally, we'd put all the metadata inodes in one place if we could, so
that the metadata all stay reasonably close together instead of
spreading out over the disk.  Furthermore, if the log is internal we'd
probably prefer to keep the metadata near the log.  Therefore, disable
AGI rotoring for metadata inode allocations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ialloc.c |   58 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 18 deletions(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 055eff477faceb..2575447f92dfbb 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1836,6 +1836,40 @@ xfs_dialloc_try_ag(
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
@@ -1851,31 +1885,19 @@ xfs_dialloc(
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

