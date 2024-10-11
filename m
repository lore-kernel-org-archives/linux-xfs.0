Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D47D268
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609578; cv=none; b=sP0Bznc4TcncCva9ySIkOInUQLSFjUkhvasSds7KGzT6jtDZGlICOsLF9zS20WW47hIkpvdDm5boNKFIIEnphXRGDyE9nzUCHO8vMllNIap7m4NBruTkzZZb5lvX8bZ2/mcWz/mVIupFz/DR4fh1ydPRtvZLPP1zv5KwpmHhgaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609578; c=relaxed/simple;
	bh=ynzm1+xnnnC0V7zUHJWA3CsyFpuqM2oGmYGbX1K0qzo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eZuxOM44wPgFCza+RhGGTS/YKBD/GGA3nbi5GAWsOdpjP/Af+4d85GA3eSsmpS1HDWDGfz9BqiGcohyhnexWeQG4/QjbHLBZV+OJexw21PYDQNRE/8eecGrms3Lqajqzfxru7beRvSmHfhIBxFsd1J60gi6lADLDzwdzj644Oww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WiGFf4Om; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WiGFf4Om"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771CAC4CEC5;
	Fri, 11 Oct 2024 01:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609578;
	bh=ynzm1+xnnnC0V7zUHJWA3CsyFpuqM2oGmYGbX1K0qzo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WiGFf4Om2thWazdlUHqbDnX+o/G+7pQ6k89LZpTNKldbuXDyN4yHqDb8Pj2qXjwxi
	 kSuxCBqhyhAF5yCt/ZEqtU14WhGWS2ug7lfwMqoIML8/I1B3DuuP94Iudrnn9ez+CR
	 X8gO5xNkp/w3E+D265zGcMvAWQB/haDFtJuosEVWfT4JitsnKRBgoWmnmm86q6QvD9
	 KFc0r+M3Y8Szt3x7rvOnTCsAg8W3ynWKltmMaAHKk0xMS3sph9wejFPOEmA/JZAQtv
	 2mqkQhY9Fb8keuB8ULG7PpGj9NSbxfieVXUzltkN0yTx71uSpwPwvaRy8MT2tWcYGZ
	 s+8nvOGPgltFg==
Date: Thu, 10 Oct 2024 18:19:38 -0700
Subject: [PATCH 21/38] xfs_repair: refactor root directory initialization
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654298.4183231.7928562743337595309.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

Refactor root directory initialization into a separate function we can
call for both the root dir and the metadir.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   63 +++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 23 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 0c80c4aa36af4a..ae83d69fe12cd3 100644
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

