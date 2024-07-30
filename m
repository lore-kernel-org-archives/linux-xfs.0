Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0301263D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300436; cv=none; b=XFJhEVB9mqQ/Sgz9Yde5+u42fxGh6i+4y4NuVJPz0VDNErLYrRlXG/eZMj1u0SOIi8O81WJO+9fvojezn+kwxvsnf+PSpWfzoofRomZVBmr+Ya6gnI2gfM0zT1PG1ieGFdxRv3PsDioY4CWSo/dmWZuchDBhtzjQXP33QC59bt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300436; c=relaxed/simple;
	bh=+wlKImvTxN6GylziK+s/GFztScRavAGhRv1tCfXZC88=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ePIRpBCT4sdBZcDPffL5vhe4u5D1/P8AwZ3ztEYZHDoAbzNgIpWw1RwFeIRFOA3Iphj/XoDmnL3ho99ecurcE4v+DFQflYhEctwFaLXiw/TCPDuaq2r8i9a03RcFhi9c9S7lgFsDWM1hiEkYS64OxWVL40t52p2wRLrkT6ZogEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZFuPZMgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZFuPZMgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDDFC32786;
	Tue, 30 Jul 2024 00:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300435;
	bh=+wlKImvTxN6GylziK+s/GFztScRavAGhRv1tCfXZC88=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZFuPZMgudpW5V8JPI/WW4FxqkDj831HlSEsvNpRYCjU2dtVkrC6t2c54yBSkkRrpp
	 3/KQvna3Eo+q+wpqAUuB4gPBCAtaZC+SDlcMLegd3GodK0Y5WWNuNnAn8A0BqXpzVg
	 Jxs9KCaCQAwutkaVn9ic3y/Sk7ILoanrSca82LTuE6AegktAVR7eLsVigl09yNL4Op
	 6u4yakUi3svVK2R2P54RhmsMsKygI4yYKJhfdCQFRzOANtORXD9Vpg+xtOqcM2byXg
	 QFG9Ln+Oz3h70ne1ZYrSIiSJsRSp1yN2E5fTeF8x9FpoopBqwZbdLLc8XTyGw0FOY+
	 U5nyQQ/Xq0EZw==
Date: Mon, 29 Jul 2024 17:47:15 -0700
Subject: [PATCH 090/115] xfs: factor out a xfs_dir_replace_args helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172229843728.1338752.11874161429350723398.stgit@frogsfrogsfrogs>
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

Source kernel commit: dfe5febe2b6a175d730861441bff4f726fc58a6c

Add a helper to switch between the different directory formats for
removing a directory entry.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_dir2.c |   49 ++++++++++++++++++++++++++-----------------------
 libxfs/xfs_dir2.h |    1 +
 2 files changed, 27 insertions(+), 23 deletions(-)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index e2e0832c1..55cf39e11 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -504,6 +504,31 @@ xfs_dir_removename(
 	return rval;
 }
 
+int
+xfs_dir_replace_args(
+	struct xfs_da_args	*args)
+{
+	bool			is_block, is_leaf;
+	int			error;
+
+	if (args->dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+		return xfs_dir2_sf_replace(args);
+
+	error = xfs_dir2_isblock(args, &is_block);
+	if (error)
+		return error;
+	if (is_block)
+		return xfs_dir2_block_replace(args);
+
+	error = xfs_dir2_isleaf(args, &is_leaf);
+	if (error)
+		return error;
+	if (is_leaf)
+		return xfs_dir2_leaf_replace(args);
+
+	return xfs_dir2_node_replace(args);
+}
+
 /*
  * Replace the inode number of a directory entry.
  */
@@ -517,7 +542,6 @@ xfs_dir_replace(
 {
 	struct xfs_da_args	*args;
 	int			rval;
-	bool			v;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 
@@ -540,28 +564,7 @@ xfs_dir_replace(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->owner = dp->i_ino;
-
-	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
-		rval = xfs_dir2_sf_replace(args);
-		goto out_free;
-	}
-
-	rval = xfs_dir2_isblock(args, &v);
-	if (rval)
-		goto out_free;
-	if (v) {
-		rval = xfs_dir2_block_replace(args);
-		goto out_free;
-	}
-
-	rval = xfs_dir2_isleaf(args, &v);
-	if (rval)
-		goto out_free;
-	if (v)
-		rval = xfs_dir2_leaf_replace(args);
-	else
-		rval = xfs_dir2_node_replace(args);
-out_free:
+	rval = xfs_dir_replace_args(args);
 	kfree(args);
 	return rval;
 }
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 3db54801d..6c00fe24a 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -69,6 +69,7 @@ extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 int xfs_dir_lookup_args(struct xfs_da_args *args);
 int xfs_dir_createname_args(struct xfs_da_args *args);
 int xfs_dir_removename_args(struct xfs_da_args *args);
+int xfs_dir_replace_args(struct xfs_da_args *args);
 
 /*
  * Direct call from the bmap code, bypassing the generic directory layer.

