Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7FA59B42
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798230; cv=none; b=seUD/CvODNvSXHiuaECBAENVDp+uNKAOGiJWo/mkUoeZZhnCw3HUpf3PWrwvl9we+98zvWPFo7LiSnLuvXWuRpbFu+7I5FY6vCWv94PRpIssKleDG7lTOq7bkRVyee9Oo+VYs2G33vIsmrX1MqcgNJ2Tqup3M2/4TE1N9AHuuBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798230; c=relaxed/simple;
	bh=FxtS90omAqnSyGMDMgADMPuhWqp0ydAFOQmqH11HPvk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fLTnWOK9uLFekgAtJ1FZ2Lsc7btDfI1mz1cluae3d0SSxJIZ/eiBqNnPPuJr/NY0pBBjjZwiEFYdb7gODn58dKjhiI64OMfaJbSB/TCED4PPN9F6Pm9QcJg9YJkruIH/FuY7fUY1l/RbSlgrZukpZzulv7mKDOGslVfHwXQIKUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qAgDuIuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qAgDuIuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBDCC433C7;
	Mon, 18 Mar 2024 21:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798230;
	bh=FxtS90omAqnSyGMDMgADMPuhWqp0ydAFOQmqH11HPvk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qAgDuIuZ0mw2diMxfikaPM62uajy5LkcG3qIs/l+AAK1i8W7ZhHWhbDLmdYbQ7JIF
	 TAXVQ0QfVyTb43bq3czq3qKZXtMyH8OB2bO3FKCxBP2Gcd5Rjad/i6kkx+f6nomPID
	 jzLsxzrC40YV5kHzkr58pxYEmbuck7O2DYkRmOlWXpYpYp5NnjokMz3qOdaJw3D7Od
	 tzD0JFaVarq+g61HPDHjjJPhtj75h4J3ZxMtdpUBILcm4fBuzY4bW8Kp5nJZ/uy8PC
	 juotzNLlH46rp7dwe34qBq3TpBxtei14y3oNtit42oD2IJb8D9q22jVZxQfow+KOl+
	 wqppNaw7FrVNw==
Date: Mon, 18 Mar 2024 14:43:49 -0700
Subject: [PATCH 07/23] xfs: add parent attributes to link
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079801988.3806377.15212481540402204570.stgit@frogsfrogsfrogs>
In-Reply-To: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
References: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
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
index 01893f25454b2..4cfda208e9e6b 100644
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
index 96b05ef2548ab..d09d6d144c301 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1318,14 +1318,15 @@ xfs_create_tmpfile(
 
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
 
@@ -1344,11 +1345,25 @@ xfs_link(
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
@@ -1388,6 +1403,17 @@ xfs_link(
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
@@ -1401,12 +1427,15 @@ xfs_link(
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

