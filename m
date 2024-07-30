Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149D61361
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300076; cv=none; b=QNwyDmA65qxoPmQeQdDLxNdrINJ5hSE+VL0HLrjkC7Fc0r+We7rpprosCjICXyGiNAn+BZi3g32yHL63PyjfyfCa8/RQG8u0d1gAkXEIv6nNkpobkCFHZFZ86yg4rkLNFOGCIMt3HFMJvpMxK8yjG2beSsW4BH/OgaBwZKYzcEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300076; c=relaxed/simple;
	bh=kaLRQCp17v83jsZtJNCdGInYOkS6mN7wMxYyUremahI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mA/HAILBqmG4/0MByd9IwiX59SMUP4HH52jTHWQXcvEHMCK/dzSAhG2bF57OSXZqJEGnqB+mPmgsbb60kynADdmJ+UY5Ws72gbMtFMRZ5CePT4e1qVtbAPKxoiDA/bBe6s2SSb7jP+HdObrfA4fYFTqrrua/djLRDmHB514rgVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ibxkqveK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ibxkqveK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9970CC32786;
	Tue, 30 Jul 2024 00:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300075;
	bh=kaLRQCp17v83jsZtJNCdGInYOkS6mN7wMxYyUremahI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ibxkqveKO2zZwmiwQSZwqyHNzjIe/LeFFNuAV1h2JBSr3TxepLBrNi3XashZkfSQV
	 voSfHlgXlBgCra+5FyQh96TO6dbuLtg+i5q+v243UAEFZofioytxZUlvJy+iFet5Sw
	 oMn96eFO84WZ5oamSRJTIVl7qwZMTUeG6YWYva+sJgL/1lRGY2knZ+pKAcf4IHULgu
	 +jMocxxJTu1Y4KQjio/M/6wr2Vkg1FIVdpw1bQ3foNBBO1gDCT1SSvTw7g8l4OLPt3
	 IM03A700sUgYsO8DZF0mIVdlgQ93wGrO3L0VU0ONCz7Uo4SyZtP56163YuAblhOEtH
	 2+IGIazKPCzTA==
Date: Mon, 29 Jul 2024 17:41:15 -0700
Subject: [PATCH 067/115] xfs: Add parent pointers to rename
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843387.1338752.4325658647941757571.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 5a8338c88284df4e9e697225aa65f2709333a659

This patch removes the old parent pointer attribute during the rename
operation, and re-adds the updated parent pointer.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: adjust to new ondisk format]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_parent.c      |   30 ++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h      |    6 ++++++
 libxfs/xfs_trans_space.c |   25 +++++++++++++++++++++++++
 libxfs/xfs_trans_space.h |    6 ++++--
 4 files changed, 65 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 0657728e6..a53b7d13d 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -224,3 +224,33 @@ xfs_parent_removename(
 	xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_REMOVE);
 	return 0;
 }
+
+/* Replace one parent pointer with another to reflect a rename. */
+int
+xfs_parent_replacename(
+	struct xfs_trans	*tp,
+	struct xfs_parent_args	*ppargs,
+	struct xfs_inode	*old_dp,
+	const struct xfs_name	*old_name,
+	struct xfs_inode	*new_dp,
+	const struct xfs_name	*new_name,
+	struct xfs_inode	*child)
+{
+	int			error;
+
+	error = xfs_parent_iread_extents(tp, child);
+	if (error)
+		return error;
+
+	xfs_inode_to_parent_rec(&ppargs->rec, old_dp);
+	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
+			child->i_ino, old_name);
+
+	xfs_inode_to_parent_rec(&ppargs->new_rec, new_dp);
+	ppargs->args.new_name = new_name->name;
+	ppargs->args.new_namelen = new_name->len;
+	ppargs->args.new_value = &ppargs->new_rec;
+	ppargs->args.new_valuelen = sizeof(struct xfs_parent_rec);
+	xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_REPLACE);
+	return 0;
+}
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 4a7fd48c2..768633b31 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -45,6 +45,7 @@ extern struct kmem_cache	*xfs_parent_args_cache;
  */
 struct xfs_parent_args {
 	struct xfs_parent_rec	rec;
+	struct xfs_parent_rec	new_rec;
 	struct xfs_da_args	args;
 };
 
@@ -84,5 +85,10 @@ int xfs_parent_addname(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
 int xfs_parent_removename(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
 		struct xfs_inode *dp, const struct xfs_name *parent_name,
 		struct xfs_inode *child);
+int xfs_parent_replacename(struct xfs_trans *tp,
+		struct xfs_parent_args *ppargs,
+		struct xfs_inode *old_dp, const struct xfs_name *old_name,
+		struct xfs_inode *new_dp, const struct xfs_name *new_name,
+		struct xfs_inode *child);
 
 #endif /* __XFS_PARENT_H__ */
diff --git a/libxfs/xfs_trans_space.c b/libxfs/xfs_trans_space.c
index 86a91a3a8..373f5cc24 100644
--- a/libxfs/xfs_trans_space.c
+++ b/libxfs/xfs_trans_space.c
@@ -94,3 +94,28 @@ xfs_remove_space_res(
 
 	return ret;
 }
+
+unsigned int
+xfs_rename_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		src_namelen,
+	bool			target_exists,
+	unsigned int		target_namelen,
+	bool			has_whiteout)
+{
+	unsigned int		ret;
+
+	ret = XFS_DIRREMOVE_SPACE_RES(mp) +
+			XFS_DIRENTER_SPACE_RES(mp, target_namelen);
+
+	if (xfs_has_parent(mp)) {
+		if (has_whiteout)
+			ret += xfs_parent_calc_space_res(mp, src_namelen);
+		ret += 2 * xfs_parent_calc_space_res(mp, target_namelen);
+	}
+
+	if (target_exists)
+		ret += xfs_parent_calc_space_res(mp, target_namelen);
+
+	return ret;
+}
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index a4490813c..1155ff2d3 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
@@ -91,8 +91,6 @@
 	 XFS_DQUOT_CLUSTER_SIZE_FSB)
 #define	XFS_QM_QINOCREATE_SPACE_RES(mp)	\
 	XFS_IALLOC_SPACE_RES(mp)
-#define	XFS_RENAME_SPACE_RES(mp,nl)	\
-	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define XFS_IFREE_SPACE_RES(mp)		\
 	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
 
@@ -106,4 +104,8 @@ unsigned int xfs_symlink_space_res(struct xfs_mount *mp, unsigned int namelen,
 		unsigned int fsblocks);
 unsigned int xfs_remove_space_res(struct xfs_mount *mp, unsigned int namelen);
 
+unsigned int xfs_rename_space_res(struct xfs_mount *mp,
+		unsigned int src_namelen, bool target_exists,
+		unsigned int target_namelen, bool has_whiteout);
+
 #endif	/* __XFS_TRANS_SPACE_H__ */

