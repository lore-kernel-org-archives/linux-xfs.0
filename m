Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7189BBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZzYNOlZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBE7C433C7;
	Sun, 31 Dec 2023 20:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055820;
	bh=oohAL0wQbW5ZmFHnT9tQTGXP0N0ALueH+bgE2ngb/cM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZzYNOlZr9Kh7y78FDTK1ujQsknGlsE2Z155yLujrB8nT9Yz5NOz4zlK78hxEWloik
	 0CCksZmeTlcUmc6ydLWcF9MK6gebvv16ecC76s1jfjXWrrINrg1a6NeGr4O9FN4fJh
	 /k/rGt0TZVskt2rwhnqPzMS0WS/ufs3gf11YV2j7yTrRPLruM7zlcw+52AY9v9Ko4x
	 0RBbxq+/obhAoWKaEU/8EhNwnd0oYs75EpzYckUIRaxoDtlClDDhxIy27+NyaH19/f
	 HQ/K/OCEJmy4J0puO0g+uwtz8gGZdBsiuWHmsxPOxyBVPN7gc15qmajRSCICwg1ZBj
	 cBU3d0tQH9stQ==
Date: Sun, 31 Dec 2023 12:50:19 -0800
Subject: [PATCH 07/18] xfs: add parent attributes to link
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <170404841152.1756905.9141159000997600645.stgit@frogsfrogsfrogs>
In-Reply-To: <170404840995.1756905.18018727013229504371.stgit@frogsfrogsfrogs>
References: <170404840995.1756905.18018727013229504371.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_trans_space.c |   14 +++++++++++++
 fs/xfs/libxfs/xfs_trans_space.h |    3 +--
 fs/xfs/scrub/dir_repair.c       |    2 +-
 fs/xfs/scrub/orphanage.c        |    2 +-
 fs/xfs/xfs_inode.c              |   41 +++++++++++++++++++++++++++++++++------
 5 files changed, 52 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_trans_space.c b/fs/xfs/libxfs/xfs_trans_space.c
index 90532c3fa2053..cf775750120e8 100644
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
index 6cda87153b38c..5539634009fb2 100644
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
index 48e30a9baeae0..e74f456c7b444 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -705,7 +705,7 @@ xrep_dir_replay_update(
 	uint				resblks;
 	int				error;
 
-	resblks = XFS_LINK_SPACE_RES(mp, dirent->namelen);
+	resblks = xfs_link_space_res(mp, dirent->namelen);
 	error = xchk_trans_alloc(rd->sc, resblks);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index e1024a7bc9e96..84e6dcef067c1 100644
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
index 20aee9db1b43a..4d7d923cf72ec 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1309,14 +1309,15 @@ xfs_create_tmpfile(
 
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
 
@@ -1335,11 +1336,25 @@ xfs_link(
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
@@ -1379,6 +1394,17 @@ xfs_link(
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
 	xfs_bumplink(tp, sip);
+
+	/*
+	 * If we have parent pointers, we now need to add the parent record to
+	 * the attribute fork of the inode. If this is the initial parent
+	 * attribute, we need to create it correctly, otherwise we can just add
+	 * the parent to the inode.
+	 */
+	error = xfs_parent_add(tp, ppargs, tdp, target_name, sip);
+	if (error)
+		goto error_return;
+
 	xfs_dir_update_hook(tdp, sip, 1, target_name);
 
 	/*
@@ -1392,12 +1418,15 @@ xfs_link(
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

