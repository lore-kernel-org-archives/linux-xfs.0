Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81D7323D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300404; cv=none; b=Mi6KrkLVQJ63j846kMP4pdF7Ggh09KehYhbJcC/vU16xvaNNIIW+bq3Y0Np0zDoQiChJzJ0dILgS8j3xVTML/UnAnOfouabJtCyVKa7uCdH4V4qr+R5UfTpSVUHG5MO4eaE2fyMAWZEMMOIH45tdXLm121pDcAbbLcG6koFQ664=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300404; c=relaxed/simple;
	bh=S7QttBtVytd0daLtf2VkXk1Dn542MmSUwqvsn6zDxH4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QCM5zbA1phscpG+Y6GW794LwkNTB7LEq2vYerI6707Z+Nvv2DEV4UY6kZrTayDU6/90emzNAbMNg/RwbEFthtbIip2jgD5tZNwlmlyysiMBpQIZp17IYUYN8/OBTD3GkGzqBfThnWEwhr0fgdeUk4DpoxQ2zM4utOoBNIuPGvug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cy3SVfkS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cy3SVfkS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D58C32786;
	Tue, 30 Jul 2024 00:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300404;
	bh=S7QttBtVytd0daLtf2VkXk1Dn542MmSUwqvsn6zDxH4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Cy3SVfkSja4000074Ktp+cADNNZ5ailp4qppdauqqx1mKUBuWGEoEOXCfM8e1Afzy
	 Y2pf82YCQErWkZa9r6yyH07un7Ee0X5D1dAswppxa0qYyT/I+1kNfGt7Ouk91Tikuy
	 tcZgEReR2zD8Oj8JiKBiEBLqT8nlI+7FnVWj69atmorFOlofoUPhGMolB7+uvhuBLN
	 OMdbIejWpagcYQLUuG8ArJus2HIjXKNTvklVFS7auaIh2X6gUJCrgKB7Zq1BfplR1F
	 oD3/16Fzt29Keydj7xFRSPaTKs/F9khoNx9rJiLVQCuB733ialyIw4KuWiB8AKMmnQ
	 i6HcgIS9zxs8w==
Date: Mon, 29 Jul 2024 17:46:43 -0700
Subject: [PATCH 088/115] xfs: factor out a xfs_dir_createname_args helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172229843698.1338752.16435627130749242510.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4d893a40514e9c4ee6e3be48ed1b77efb38c313b

Add a helper to switch between the different directory formats for
creating a directory entry and to handle the XFS_DA_OP_JUSTCHECK flag
based on the passed in ino number field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_dir2.c |   53 ++++++++++++++++++++++++++++-------------------------
 libxfs/xfs_dir2.h |    1 +
 2 files changed, 29 insertions(+), 25 deletions(-)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 0cf4120fe..97c7ddc92 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -255,6 +255,33 @@ xfs_dir_init(
 	return error;
 }
 
+int
+xfs_dir_createname_args(
+	struct xfs_da_args	*args)
+{
+	bool			is_block, is_leaf;
+	int			error;
+
+	if (!args->inumber)
+		args->op_flags |= XFS_DA_OP_JUSTCHECK;
+
+	if (args->dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+		return xfs_dir2_sf_addname(args);
+
+	error = xfs_dir2_isblock(args, &is_block);
+	if (error)
+		return error;
+	if (is_block)
+		return xfs_dir2_block_addname(args);
+
+	error = xfs_dir2_isleaf(args, &is_leaf);
+	if (error)
+		return error;
+	if (is_leaf)
+		return xfs_dir2_leaf_addname(args);
+	return xfs_dir2_node_addname(args);
+}
+
 /*
  * Enter a name in a directory, or check for available space.
  * If inum is 0, only the available space test is performed.
@@ -269,7 +296,6 @@ xfs_dir_createname(
 {
 	struct xfs_da_args	*args;
 	int			rval;
-	bool			v;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 
@@ -296,31 +322,8 @@ xfs_dir_createname(
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
 	args->owner = dp->i_ino;
-	if (!inum)
-		args->op_flags |= XFS_DA_OP_JUSTCHECK;
 
-	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
-		rval = xfs_dir2_sf_addname(args);
-		goto out_free;
-	}
-
-	rval = xfs_dir2_isblock(args, &v);
-	if (rval)
-		goto out_free;
-	if (v) {
-		rval = xfs_dir2_block_addname(args);
-		goto out_free;
-	}
-
-	rval = xfs_dir2_isleaf(args, &v);
-	if (rval)
-		goto out_free;
-	if (v)
-		rval = xfs_dir2_leaf_addname(args);
-	else
-		rval = xfs_dir2_node_addname(args);
-
-out_free:
+	rval = xfs_dir_createname_args(args);
 	kfree(args);
 	return rval;
 }
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 982c2249b..f5361dd7b 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -67,6 +67,7 @@ extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
 int xfs_dir_lookup_args(struct xfs_da_args *args);
+int xfs_dir_createname_args(struct xfs_da_args *args);
 
 /*
  * Direct call from the bmap code, bypassing the generic directory layer.

