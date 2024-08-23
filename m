Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9595695
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371439; cv=none; b=n8cde6tDj1S3tU0YZzjZ6NmSWV1lLwxq7vz9/cptAXwFgoOyIJsvBdF1T1X8t2bmZxtmvvRrYbQLfD0STklryNJJ7GQXqmhr128EyNWv/9AC6ybqYh3wLhAgiXiEmbjt65b5os0751bLnd7dw2gdEusE1oEPycj2+Xf+F6UgSPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371439; c=relaxed/simple;
	bh=GcE9ZLcRbUU94yBpztx3w0Ur18nVEimYyQkE/MDluso=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d4hGsr3WTARBd7Zn6PQgXAW/XPm0BKyp+F6BrbsCgn/GgYf9a4UQGh5rSp59F+ZvHtjoqpK70iDVWbFYl2kWUTbbW28G0q5Ga5FRBA2Z7xeRs9Lhx2GdRyyUVtt0PWmiCB9xqUCUFB2p7jUDWIGrS99PHIQKl0Hj7lyC8YBIUZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rAmk5zMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rAmk5zMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E2CC32782;
	Fri, 23 Aug 2024 00:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371439;
	bh=GcE9ZLcRbUU94yBpztx3w0Ur18nVEimYyQkE/MDluso=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rAmk5zMbiw5NXP+QVbUBGWEyiK8aiehX5aNGdYZTwyUhQzCTx4pKF+RqPGFVN9mFg
	 g4ixcWfxazHf89eNeFPLz54Zofu5nfLezXPjNO+b8q/+1Sk5B7wqI3Z+07BzOktQZR
	 5780wJRtiJilSedMYfUFXXefbNEguVH17mTrCr476OyiGiTBqOFyrZV+i6hHQyfPix
	 pEkYhsiOWcv2WePMZ17Yr/9kvajRKp0fDr1FnFYK4Pqbdhh3sBbWdXJpZb486o1/aO
	 /WgJSiRmdxARZtaVTdsKWgO1OP8mVenaAmjJugX8n7Zn4auyHsvBIpBaNxWSyFr/Q8
	 fTKC7OskPH32w==
Date: Thu, 22 Aug 2024 17:03:58 -0700
Subject: [PATCH 07/26] xfs: disable the agi rotor for metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085295.57482.10452896060816611340.stgit@frogsfrogsfrogs>
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

Ideally, we'd put all the metadata inodes in one place if we could, so
that the metadata all stay reasonably close together instead of
spreading out over the disk.  Furthermore, if the log is internal we'd
probably prefer to keep the metadata near the log.  Therefore, disable
AGI rotoring for metadata inode allocations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c |   58 ++++++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index fc70601e8d8ee..79321aed6dc20 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1844,6 +1844,40 @@ xfs_dialloc_try_ag(
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
@@ -1859,31 +1893,19 @@ xfs_dialloc(
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

