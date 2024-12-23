Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09F81422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990797; cv=none; b=DVxwTBt6X8C4H0M35OHryLBtiLyPEl9Xp/tG3kId0gYcMiZJKkdw10pelqtRs3+c+suLMsKppkjU14KvfCBPNmQKOOuk3ta6WNbAHOJq9cr/PRIwsf8NPIGXDOmJdbh47a5MC5ZM3fM1Prh+clnm8UmUdGaLsWX37sj6hCODJ+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990797; c=relaxed/simple;
	bh=imZXq9QKF4kvk9pelvkd/wue14kpx3uV99MtwOvPozI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WclujlhOtN8vL5ihM4cg/vI6Zp84Yn7m9qtLOTkHjEszJDUq6CN8j6lb6ImDpPTHNRQ1I6TJpnChK9asPSZ000W8UNILP1pYpFWBBy+3xVRc4OiPMto/bXwFxAIiqZq0VePHrV1OHXY5mfeeVqc+I/dBqWjPnHB/WDUH8xqJDDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PKQ+yOqu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PKQ+yOqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7196C4CED3;
	Mon, 23 Dec 2024 21:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990796;
	bh=imZXq9QKF4kvk9pelvkd/wue14kpx3uV99MtwOvPozI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PKQ+yOquqy9Re3QbYakVprwzTF7D3gX1LcXDmLxlkqT4CdQLTepc6Blyg+g/QVmWu
	 8W0c8QmZthE/PwOEx61qPhJIQL+dpkFlyrrW/xpNPi9mvhTkrIqpDe8rx0+HDYmIoo
	 xGKvQrmXuHVNIoMoW8gVMTHUk/+Q0nZ++IOwDdRc6i/HP0PDI7xzv3SPQEGKcgJ9Uk
	 6Q5AUcUTrGuEPuYghFxOoKVX7PTExvhX7ErhqGZBpnm35jW+kAXWNEk2fG9SCgk4vg
	 FLq5A+y/5D2MVfpRoN9JYAzl4zA0cI0qLaID2y5N6t+PcATluiV9H7SPq3kZER3a7L
	 J2cMCK8XAPPRQ==
Date: Mon, 23 Dec 2024 13:53:16 -0800
Subject: [PATCH 26/41] xfs_repair: refactor root directory initialization
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941367.2294268.7228312364539892994.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Refactor root directory initialization into a separate function we can
call for both the root dir and the metadir.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/phase6.c |   63 +++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 23 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 79c8226110a890..b3c013138be6c8 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -587,27 +587,27 @@ mk_rsumino(xfs_mount_t *mp)
 	libxfs_irele(ip);
 }
 
-/*
- * makes a new root directory.
- */
-static void
-mk_root_dir(xfs_mount_t *mp)
+/* Initialize a root directory. */
+static int
+init_fs_root_dir(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	mode_t			mode,
+	struct xfs_inode	**ipp)
 {
-	xfs_trans_t	*tp;
-	xfs_inode_t	*ip;
-	int		i;
-	int		error;
-	const mode_t	mode = 0755;
-	ino_tree_node_t	*irec;
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip = NULL;
+	struct ino_tree_node	*irec;
+	int			error;
 
-	ip = NULL;
-	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 10, 0, 0, &tp);
-	if (i)
-		res_failed(i);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 10, 0, 0, &tp);
+	if (error)
+		return error;
 
-	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rootino, 0, &ip);
+	error = -libxfs_iget(mp, tp, ino, 0, &ip);
 	if (error) {
-		do_error(_("could not iget root inode -- error - %d\n"), error);
+		libxfs_trans_cancel(tp);
+		return error;
 	}
 
 	/* Reset the root directory. */
@@ -616,14 +616,31 @@ mk_root_dir(xfs_mount_t *mp)
 
 	error = -libxfs_trans_commit(tp);
 	if (error)
-		do_error(_("%s: commit failed, error %d\n"), __func__, error);
+		return error;
+
+	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, ino),
+				XFS_INO_TO_AGINO(mp, ino));
+	set_inode_isadir(irec, XFS_INO_TO_AGINO(mp, ino) - irec->ino_startnum);
+	*ipp = ip;
+	return 0;
+}
+
+/*
+ * makes a new root directory.
+ */
+static void
+mk_root_dir(xfs_mount_t *mp)
+{
+	struct xfs_inode	*ip = NULL;
+	int			error;
+
+	error = init_fs_root_dir(mp, mp->m_sb.sb_rootino, 0755, &ip);
+	if (error)
+		do_error(
+	_("Could not reinitialize root directory inode, error %d\n"),
+			error);
 
 	libxfs_irele(ip);
-
-	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
-				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
-	set_inode_isadir(irec, XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino) -
-				irec->ino_startnum);
 }
 
 /*

