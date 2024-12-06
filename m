Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47D91DD894
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528770; cv=none; b=PWVUWCiEBX6SMDsX2/TSSvPivDO6w/3nQJ9FF0XOioo4z8kANLi8SW5blH9MIVfes/y1rOj8hlMn2hXOLLcNQru/68UEAk5OWm5S8gufT4WshoQe/MVo3SDxaGBvc0GI0ynenvYd3O7gbLBk5Bx10p/KtrfnoEHIAV0Z9sn1g34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528770; c=relaxed/simple;
	bh=5+fDTOlde/MvKD8WYp6wDQRMyZ31NpeHEL9bOcXN0iU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E/sGwYw5yQjhc5wlZ/rWvrG0Ym/bWxdXnflKnj1iigIdVC1rEtzwuT4xgnMLszlctpFehLGr9ugNYvlkj3anFzI+t169gYVhI6P79/dA6i5HgGp/yKUF59ghfX6OI3px+W1zwBWij/cvC7t41KVST1kHWwzm99z22YhVB9nvWfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GCs+DYka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GCs+DYka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32525C4CED1;
	Fri,  6 Dec 2024 23:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528770;
	bh=5+fDTOlde/MvKD8WYp6wDQRMyZ31NpeHEL9bOcXN0iU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GCs+DYkaOiih9YhORW0C6dVCZV9TDdcFU4RlSuYK5dNPZUPfYRyh1I672rBsTPjR1
	 mFIIz9lx59fBoFniiIQ3BS54i/UiVlinahjLr6Sefo32lMzA+ghbWtwEqACgt8ZD7+
	 VUkPsnH4vTpn9s4RVMZfLoCBL0eDkTYwEYurSXsPeMdw4FBz5wMkgEKnYcyYxD5ORE
	 uTqWCvB3jGI4+jQP+lWLZ8LqXGU9xfwEpra9kXqiUJC6Cw9hsJI13ve9r5gpIc44Nk
	 +Q9RgaBXJy7CAYJBQYuhzlRCf5pHR1qsWsBCbM08J0DWbwaXNR3cmK1az2cEBzE2PT
	 HdrgDmqXXKidg==
Date: Fri, 06 Dec 2024 15:46:09 -0800
Subject: [PATCH 25/41] xfs_repair: refactor root directory initialization
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748618.122992.6027492058039719994.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
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

