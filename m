Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209E14A33
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300420; cv=none; b=Hh7vk/5CtAc1erNuBroYq+7jKGYWyqdKlOUH5AZMMAZIs5royTRpjoVCoM133fZQuiF4AqgjBg43wOK4msBbr9LO6butb8bxl4pVMsVymGTQXDFlfYcUh70aig+mSWxJfbEQr3bQOeWIHbXj+jyjhXejiNFaUVe6geJuhvp7t1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300420; c=relaxed/simple;
	bh=EdK9gIM7NFQbgsqpkm9cEaptvyTxyS42nnAzQcfYplA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iiM42jb9jgXkVjYOUp3X10GzdPQTL6Jjke0bkXzZ2nVS85WOpA72SPZrAR+vH65jCS4MKAmJuY4WgUvfL1eOAlrg2T/wE3GIVLoYCzfJCgmojuLDkNhJqulZ8e5YBpRdCLPhvv794yFV8AsPlM6Ed2hAJo6b7s9A/1CpWDe9PBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TmwPBzEJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TmwPBzEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB33BC32786;
	Tue, 30 Jul 2024 00:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300420;
	bh=EdK9gIM7NFQbgsqpkm9cEaptvyTxyS42nnAzQcfYplA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TmwPBzEJC62lFMAP2MkMFLxcUBp/xyLd8naglol0pAjnuGjUuqT2u8NhVFjFzo3P6
	 992NaiiTnYcLFX/bledp2SHq5uNhhJp97FfHO3stEv3wQ/2RzbirUt29ax/MSh1g4b
	 MrqOko517rrBe60iKkUP11Ozh01qh0qW+tYfWfTOK8o1t4CUF8PygW0cJf126oGqSY
	 h5po4TLcEx/yrBgFYEHFz5vCqrFtMSy5pO+XkuqKKw/Ykxni1Wb1vD89LBovkbSSHc
	 vuAwcOibvLm6f2YUNnVjHhXdrrdNemj9QZJKw/ueUPbdaxg+Cg0Iufwdjd0VA6NVB9
	 4v4iaC79B2E0w==
Date: Mon, 29 Jul 2024 17:46:59 -0700
Subject: [PATCH 089/115] xfs: factor out a xfs_dir_removename_args helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172229843713.1338752.14572981146720826431.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 3866e6e669e2c1b3eebf580b8779ea55838c3f5a

Add a helper to switch between the different directory formats for
removing a directory entry.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_dir2.c |   48 +++++++++++++++++++++++++-----------------------
 libxfs/xfs_dir2.h |    1 +
 2 files changed, 26 insertions(+), 23 deletions(-)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 97c7ddc92..e2e0832c1 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -443,6 +443,30 @@ xfs_dir_lookup(
 	return rval;
 }
 
+int
+xfs_dir_removename_args(
+	struct xfs_da_args	*args)
+{
+	bool			is_block, is_leaf;
+	int			error;
+
+	if (args->dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+		return xfs_dir2_sf_removename(args);
+
+	error = xfs_dir2_isblock(args, &is_block);
+	if (error)
+		return error;
+	if (is_block)
+		return xfs_dir2_block_removename(args);
+
+	error = xfs_dir2_isleaf(args, &is_leaf);
+	if (error)
+		return error;
+	if (is_leaf)
+		return xfs_dir2_leaf_removename(args);
+	return xfs_dir2_node_removename(args);
+}
+
 /*
  * Remove an entry from a directory.
  */
@@ -456,7 +480,6 @@ xfs_dir_removename(
 {
 	struct xfs_da_args	*args;
 	int			rval;
-	bool			v;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
@@ -476,28 +499,7 @@ xfs_dir_removename(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->owner = dp->i_ino;
-
-	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
-		rval = xfs_dir2_sf_removename(args);
-		goto out_free;
-	}
-
-	rval = xfs_dir2_isblock(args, &v);
-	if (rval)
-		goto out_free;
-	if (v) {
-		rval = xfs_dir2_block_removename(args);
-		goto out_free;
-	}
-
-	rval = xfs_dir2_isleaf(args, &v);
-	if (rval)
-		goto out_free;
-	if (v)
-		rval = xfs_dir2_leaf_removename(args);
-	else
-		rval = xfs_dir2_node_removename(args);
-out_free:
+	rval = xfs_dir_removename_args(args);
 	kfree(args);
 	return rval;
 }
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index f5361dd7b..3db54801d 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -68,6 +68,7 @@ extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 
 int xfs_dir_lookup_args(struct xfs_da_args *args);
 int xfs_dir_createname_args(struct xfs_da_args *args);
+int xfs_dir_removename_args(struct xfs_da_args *args);
 
 /*
  * Direct call from the bmap code, bypassing the generic directory layer.

