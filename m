Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39683C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ITuFrA1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16CFC433C7;
	Sun, 31 Dec 2023 23:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066032;
	bh=bCeMXBu7C10Z+pudnyV8K/59uBY8IW3/L1KgjRGCyC0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ITuFrA1xhTcTp5z0Wb2BvQ9m7l9YkQn4y6BAd778ASCr03SlhAzH6to62kGXn2vit
	 N2gEXj8ep1otTp/3l6QdGYmqg5aKG20jA74UyZm6ZbwWD9JYhjC3SJHsQ7vI7fIuPQ
	 NsNOJddRGJGnfrWbafl4ju6+C/0o2VKKRdO21zCtSQQLHMZrDNTbLcggNQ5nI0uBA0
	 ucWQUCmAqq/5kRPVdT7FQwUgFErnekv1r6NBgoZTmfaSC40BIKkSsW9pEmCoTl2Epe
	 PvEEKbcaWHreNvfcpbPWxcukYIC/s6YL0aGC6MjPLI3xpeoYmkSvyynJNCn78Cq6LA
	 iIt+wOaJQ8uqg==
Date: Sun, 31 Dec 2023 15:40:32 -0800
Subject: [PATCH 42/58] xfs_repair: refactor root directory initialization
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010506.1809361.2695340498551995034.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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
index e01e81ae014..017c46f43af 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -773,27 +773,27 @@ mk_rsumino(xfs_mount_t *mp)
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
@@ -802,14 +802,31 @@ mk_root_dir(xfs_mount_t *mp)
 
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

