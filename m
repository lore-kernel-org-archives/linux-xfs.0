Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F398D5227
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231045; cv=none; b=kKOzfmO2I0qAeAMT3jlWE0zu7iYLVCRG0eQxu0fZpYEi2A+af5FeEcAmk8dnsvj572iEnMKtba5av0Gdj49Tt1lT8yEcZUyl5jVBvbMgqxc6xySTbbsPsHD6V4CZx5Z1Au4SSKVKpVfBgDBxoSSvAPIFZAXxGnx0KlQFvGtC9lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231045; c=relaxed/simple;
	bh=xNLmbhv9JU1BWThRYGUbs3pduSSKcwMum11GM0Shtz8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aaM00ASXLHoAFHZUmoNyNQw/PMc5gMSzvvMfXd/4tVeS3z8KrUPG8cHWNagVPGse5qUEQlc5r6dJTTRfXz811ISS5+n6sdgcUuUo+j9b9GAfS47Us9dNxNLtWZ09gXGeSx2/39uTclcPzEyAUlQiton6T1HXrDEA+drYrrHjAik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V1ZvB8FE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V1ZvB8FE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927FEC113CC;
	Tue, 16 Apr 2024 01:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231044;
	bh=xNLmbhv9JU1BWThRYGUbs3pduSSKcwMum11GM0Shtz8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V1ZvB8FEcixEDbIIma9PAeokjnjWmRc11eVGbLxmBU6qOWWkcjezJQ0/8a+/0k/3n
	 i01wF/iH6RgP4hyQfuNLjWtbs5UVOMAnTNLGK2NueNzmjvsfPO9ASr5vmLBqvrgaRs
	 qg56aID/+HpOJ3TC9cfq8c222PThtBzKH55ViWK6OuHO2N2dtLyCftyyDI4RihjRpb
	 6Ug0R0x5UvAx0KBYAe0DxDH7l20JZP1KuH3XUJP1Kk1te3KYJO4S4GMOFSE7p1RnkE
	 IdfYMcRXOQLLABCmx6k2PKgi7I9gpD5ESvVvQ0OLfF4MTkWwUmUz6cd9fdUIT8XY4W
	 rdMcH/fNFX2Ww==
Date: Mon, 15 Apr 2024 18:30:44 -0700
Subject: [PATCH 18/31] xfs: remove parent pointers in unlink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323028079.251715.11466634525466841811.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
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

This patch removes the parent pointer attribute during unlink

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: adjust to new ondisk format, minor rebase fixes]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_parent.c      |   22 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |    3 +++
 fs/xfs/libxfs/xfs_trans_space.c |   13 +++++++++++++
 fs/xfs/libxfs/xfs_trans_space.h |    3 +--
 fs/xfs/xfs_inode.c              |   27 +++++++++++++++++++++------
 5 files changed, 60 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 1cd655c6b3181..7b068ae4f449f 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -205,3 +205,25 @@ xfs_parent_addname(
 	xfs_attr_defer_parent(&ppargs->args, XFS_ATTR_DEFER_SET);
 	return 0;
 }
+
+/* Remove a parent pointer to reflect a dirent removal. */
+int
+xfs_parent_removename(
+	struct xfs_trans	*tp,
+	struct xfs_parent_args	*ppargs,
+	struct xfs_inode	*dp,
+	const struct xfs_name	*parent_name,
+	struct xfs_inode	*child)
+{
+	int			error;
+
+	error = xfs_parent_iread_extents(tp, child);
+	if (error)
+		return error;
+
+	xfs_inode_to_parent_rec(&ppargs->rec, dp);
+	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
+			child->i_ino, parent_name);
+	xfs_attr_defer_parent(&ppargs->args, XFS_ATTR_DEFER_REMOVE);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 6de24e3ef318c..4a7fd48c226a4 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -81,5 +81,8 @@ xfs_parent_finish(
 int xfs_parent_addname(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
 		struct xfs_inode *dp, const struct xfs_name *parent_name,
 		struct xfs_inode *child);
+int xfs_parent_removename(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
+		struct xfs_inode *dp, const struct xfs_name *parent_name,
+		struct xfs_inode *child);
 
 #endif /* __XFS_PARENT_H__ */
diff --git a/fs/xfs/libxfs/xfs_trans_space.c b/fs/xfs/libxfs/xfs_trans_space.c
index c8adda82debe0..df729e4f1a4c9 100644
--- a/fs/xfs/libxfs/xfs_trans_space.c
+++ b/fs/xfs/libxfs/xfs_trans_space.c
@@ -81,3 +81,16 @@ xfs_symlink_space_res(
 
 	return ret;
 }
+
+unsigned int
+xfs_remove_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret = XFS_DIRREMOVE_SPACE_RES(mp);
+
+	if (xfs_has_parent(mp))
+		ret += xfs_parent_calc_space_res(mp, namelen);
+
+	return ret;
+}
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 354ad1d6e18d6..a4490813c56f1 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -91,8 +91,6 @@
 	 XFS_DQUOT_CLUSTER_SIZE_FSB)
 #define	XFS_QM_QINOCREATE_SPACE_RES(mp)	\
 	XFS_IALLOC_SPACE_RES(mp)
-#define	XFS_REMOVE_SPACE_RES(mp)	\
-	XFS_DIRREMOVE_SPACE_RES(mp)
 #define	XFS_RENAME_SPACE_RES(mp,nl)	\
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define XFS_IFREE_SPACE_RES(mp)		\
@@ -106,5 +104,6 @@ unsigned int xfs_mkdir_space_res(struct xfs_mount *mp, unsigned int namelen);
 unsigned int xfs_link_space_res(struct xfs_mount *mp, unsigned int namelen);
 unsigned int xfs_symlink_space_res(struct xfs_mount *mp, unsigned int namelen,
 		unsigned int fsblocks);
+unsigned int xfs_remove_space_res(struct xfs_mount *mp, unsigned int namelen);
 
 #endif	/* __XFS_TRANS_SPACE_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4a3fbd8d33099..492d8d1055e9e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2720,16 +2720,17 @@ xfs_iunpin_wait(
  */
 int
 xfs_remove(
-	xfs_inode_t             *dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*name,
-	xfs_inode_t		*ip)
+	struct xfs_inode	*ip)
 {
-	xfs_mount_t		*mp = dp->i_mount;
-	xfs_trans_t             *tp = NULL;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_trans	*tp = NULL;
 	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
 	int			dontcare;
 	int                     error = 0;
 	uint			resblks;
+	struct xfs_parent_args	*ppargs;
 
 	trace_xfs_remove(dp, name);
 
@@ -2746,6 +2747,10 @@ xfs_remove(
 	if (error)
 		goto std_return;
 
+	error = xfs_parent_start(mp, &ppargs);
+	if (error)
+		goto std_return;
+
 	/*
 	 * We try to get the real space reservation first, allowing for
 	 * directory btree deletion(s) implying possible bmap insert(s).  If we
@@ -2757,12 +2762,12 @@ xfs_remove(
 	 * the directory code can handle a reservationless update and we don't
 	 * want to prevent a user from trying to free space by deleting things.
 	 */
-	resblks = XFS_REMOVE_SPACE_RES(mp);
+	resblks = xfs_remove_space_res(mp, name->len);
 	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip, &resblks,
 			&tp, &dontcare);
 	if (error) {
 		ASSERT(error != -ENOSPC);
-		goto std_return;
+		goto out_parent;
 	}
 
 	/*
@@ -2822,6 +2827,13 @@ xfs_remove(
 		goto out_trans_cancel;
 	}
 
+	/* Remove parent pointer. */
+	if (ppargs) {
+		error = xfs_parent_removename(tp, ppargs, dp, name, ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * Drop the link from dp to ip, and if ip was a directory, remove the
 	 * '.' and '..' references since we freed the directory.
@@ -2845,6 +2857,7 @@ xfs_remove(
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, ppargs);
 	return 0;
 
  out_trans_cancel:
@@ -2852,6 +2865,8 @@ xfs_remove(
  out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+ out_parent:
+	xfs_parent_finish(mp, ppargs);
  std_return:
 	return error;
 }

