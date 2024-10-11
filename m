Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CE42107
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607845; cv=none; b=J3mvX+1xq2zB1MCthfL8Km27YhyhxyjOkV94jZKZrbVB3PtwfaYGqhIHYxEsx0N9ykc5ibew7oGNveTUE1ymArEGTBywbfffMIoSrYN03TlZ8gepsFsYExPzq9HKPm3jud6pbHkh9xwiStPpZT6opMSaK/QQpTu9Bjfgvu0OoaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607845; c=relaxed/simple;
	bh=p+5XrT+P8uCY0fo9XDIOy2FUndfEGNvL9lG2M8Jt0WM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eoL9n5CW15tokTd8RSkzsFBgvx2SNP4qm6EYnMWz0AExmoHAAGWwvFHl4pbPRHWMj1ZXOxMIizUwwv2JBLfNT5USNUqSLg4cjtfOnPnwDcATYenaflLMmJJ8P/A+5dRvgPVgPipbGLzlIt4UgIGme5Hm8/gbHo+kIyXmwIk5MPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qzvNTNRF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qzvNTNRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63F1C4CEC5;
	Fri, 11 Oct 2024 00:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607844;
	bh=p+5XrT+P8uCY0fo9XDIOy2FUndfEGNvL9lG2M8Jt0WM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qzvNTNRFpNEQL0uC9WC0NEJtzYWV95p5r49hH9qI/ppCL0mmg+acqjd2VSJgMS8Cc
	 vL+uu2KvY6joXlFZdh3qdKoyYohisRbtrUIrlx+xKym1aduoN0tAdWzVr1tvxPu5ls
	 qv4GuqrP6BZpJKb25BtzxDAPtnL7WagMqmRbitEoCBHmPZLrwW9JhjXSkuyOb952Qb
	 t6CtivtLMumCnAaHmZEVdsj4a/j0Ln7AjhdmtbwkRxGuytNYlSi82Qms9bKHgKH9k2
	 OcWhkne1uqbqvifOfMlV8l61wHgwKVKts2ZZvLCUPckIvDrW2tW/lz/hI8nq1L8OG7
	 yO4OjT6pWXFaA==
Date: Thu, 10 Oct 2024 17:50:44 -0700
Subject: [PATCH 09/28] xfs: disable the agi rotor for metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642171.4176876.14932292819225669374.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ialloc.c |   58 ++++++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 846e3fa141b04b..6877b2f5a6b7e1 100644
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

