Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D5F8F47
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928606; cv=none; b=ibIp3zM523pmxKYMGRzdgWCpCRk4dPsaTwyJk9sIomUe5fzkJHp2ZivnkBG4pzLXCz73MVXGfSA0e9LunN/eEkR1tg6IGa/SETskAJg8rq4oQ7TRm1zHKr6Svpcg6rRGiPgkt1NA+IzgpnoLNa6dYf4qELhuGZYn5TntvUWZQRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928606; c=relaxed/simple;
	bh=dukmPY6/XsV4vaaZF+p4exCzPiL3KtQVGrBaUTStNCE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=URSIZJTGnZyDSjHv6/Jf8Xw5VpLfzwJKb9qjYchiEStlnb3MvFdTVu+F5MH/BqeWwTdmXgDnk/5TWh+1U0IPiijJdE/9d5ZqzI5NlRuacTtTssxKJ5KNqwEqfafyZAp0rTUdRLa8rghImxNE2ZNtgR1mIWX3BFkukvYfuxIKmww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LQoIZSUx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LQoIZSUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D116C116B1;
	Wed, 24 Apr 2024 03:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928606;
	bh=dukmPY6/XsV4vaaZF+p4exCzPiL3KtQVGrBaUTStNCE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LQoIZSUxDrLw0cDo+0fRL6WJ3rY9oSRccyOwP428oq4BMvtXy7fg4vnDbcRUPZjxs
	 PdQLLKQ8DSJ/SywX9m3Edrt9tpg01LVvXNnERhJJ9IOSCnNtndHJlndYm3Gp1oXI01
	 Tg6yk4jpKnXiu9QkAMVG5tEs5SAth5chkQKV7iOO/pdoXlud4xPmtpD0wEEtWb9r6b
	 kfVCBfAd0lxvxAVQS5HTPiuWIgldFMPyJtK2u6cVX6qpoagFoL945xOn/LQ8dpd5R6
	 L6E6+EDDV9YNB4W5QEPEIHI8nfPjDUMLMJLjwd3FHaWV44Mnlw/YUiD1Y4iF1/+r2x
	 MLp6s8NT+aSlA==
Date: Tue, 23 Apr 2024 20:16:45 -0700
Subject: [PATCH 16/30] xfs: add parent attributes to link
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783538.1905110.15649321690461074483.stgit@frogsfrogsfrogs>
In-Reply-To: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
References: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_link to add a parent pointer to the inode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: minor rebase fixes]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_trans_space.c |   14 +++++++++++++
 fs/xfs/libxfs/xfs_trans_space.h |    3 +--
 fs/xfs/scrub/dir_repair.c       |    2 +-
 fs/xfs/scrub/orphanage.c        |    2 +-
 fs/xfs/xfs_inode.c              |   43 ++++++++++++++++++++++++++++++++++-----
 5 files changed, 54 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_trans_space.c b/fs/xfs/libxfs/xfs_trans_space.c
index 90532c3fa205..cf775750120e 100644
--- a/fs/xfs/libxfs/xfs_trans_space.c
+++ b/fs/xfs/libxfs/xfs_trans_space.c
@@ -50,3 +50,17 @@ xfs_mkdir_space_res(
 {
 	return xfs_create_space_res(mp, namelen);
 }
+
+unsigned int
+xfs_link_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret;
+
+	ret = XFS_DIRENTER_SPACE_RES(mp, namelen);
+	if (xfs_has_parent(mp))
+		ret += xfs_parent_calc_space_res(mp, namelen);
+
+	return ret;
+}
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 6cda87153b38..5539634009fb 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -86,8 +86,6 @@
 	(2 * (mp)->m_alloc_maxlevels)
 #define	XFS_GROWFSRT_SPACE_RES(mp,b)	\
 	((b) + XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK))
-#define	XFS_LINK_SPACE_RES(mp,nl)	\
-	XFS_DIRENTER_SPACE_RES(mp,nl)
 #define	XFS_QM_DQALLOC_SPACE_RES(mp)	\
 	(XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK) + \
 	 XFS_DQUOT_CLUSTER_SIZE_FSB)
@@ -107,5 +105,6 @@ unsigned int xfs_parent_calc_space_res(struct xfs_mount *mp,
 
 unsigned int xfs_create_space_res(struct xfs_mount *mp, unsigned int namelen);
 unsigned int xfs_mkdir_space_res(struct xfs_mount *mp, unsigned int namelen);
+unsigned int xfs_link_space_res(struct xfs_mount *mp, unsigned int namelen);
 
 #endif	/* __XFS_TRANS_SPACE_H__ */
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 38957da26b94..575397aef1f7 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -704,7 +704,7 @@ xrep_dir_replay_update(
 	uint				resblks;
 	int				error;
 
-	resblks = XFS_LINK_SPACE_RES(mp, xname->len);
+	resblks = xfs_link_space_res(mp, xname->len);
 	error = xchk_trans_alloc(rd->sc, resblks);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 885b7d478a0a..5e2c3546f2e9 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -326,7 +326,7 @@ xrep_adoption_trans_alloc(
 
 	/* Compute the worst case space reservation that we need. */
 	adopt->sc = sc;
-	adopt->orphanage_blkres = XFS_LINK_SPACE_RES(mp, MAXNAMELEN);
+	adopt->orphanage_blkres = xfs_link_space_res(mp, MAXNAMELEN);
 	if (S_ISDIR(VFS_I(sc->ip)->i_mode))
 		child_blkres = XFS_RENAME_SPACE_RES(mp, xfs_name_dotdot.len);
 	adopt->child_blkres = child_blkres;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0dd4111a6773..61a390f5e2ae 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1299,14 +1299,15 @@ xfs_create_tmpfile(
 
 int
 xfs_link(
-	xfs_inode_t		*tdp,
-	xfs_inode_t		*sip,
+	struct xfs_inode	*tdp,
+	struct xfs_inode	*sip,
 	struct xfs_name		*target_name)
 {
-	xfs_mount_t		*mp = tdp->i_mount;
-	xfs_trans_t		*tp;
+	struct xfs_mount	*mp = tdp->i_mount;
+	struct xfs_trans	*tp;
 	int			error, nospace_error = 0;
 	int			resblks;
+	struct xfs_parent_args	*ppargs;
 
 	trace_xfs_link(tdp, target_name);
 
@@ -1325,11 +1326,25 @@ xfs_link(
 	if (error)
 		goto std_return;
 
-	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
+	error = xfs_parent_start(mp, &ppargs);
+	if (error)
+		goto std_return;
+
+	resblks = xfs_link_space_res(mp, target_name->len);
 	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
 			&tp, &nospace_error);
 	if (error)
-		goto std_return;
+		goto out_parent;
+
+	/*
+	 * We don't allow reservationless or quotaless hardlinking when parent
+	 * pointers are enabled because we can't back out if the xattrs must
+	 * grow.
+	 */
+	if (ppargs && nospace_error) {
+		error = nospace_error;
+		goto error_return;
+	}
 
 	/*
 	 * If we are using project inheritance, we only allow hard link
@@ -1380,6 +1395,19 @@ xfs_link(
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
 	xfs_bumplink(tp, sip);
+
+	/*
+	 * If we have parent pointers, we now need to add the parent record to
+	 * the attribute fork of the inode. If this is the initial parent
+	 * attribute, we need to create it correctly, otherwise we can just add
+	 * the parent to the inode.
+	 */
+	if (ppargs) {
+		error = xfs_parent_addname(tp, ppargs, tdp, target_name, sip);
+		if (error)
+			goto error_return;
+	}
+
 	xfs_dir_update_hook(tdp, sip, 1, target_name);
 
 	/*
@@ -1393,12 +1421,15 @@ xfs_link(
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, ppargs);
 	return error;
 
  error_return:
 	xfs_trans_cancel(tp);
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+ out_parent:
+	xfs_parent_finish(mp, ppargs);
  std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;

