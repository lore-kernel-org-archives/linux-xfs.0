Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C72123C9
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300389; cv=none; b=VvKvvDdH+PZULy+/9NZ7I57PO/cf5bWy33HTkT+3j/3Umpke9z4UEznQh7Z9k6l2+rE0FEw09PSqDw9ncBI4wU3lY4R9Xcaz13HAqXjyONhAzY0VVNauQQbZsZeD/gGDirf+yWNet6idWi2ByLOezL9dJ94DKQiKFuhrRPCwNrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300389; c=relaxed/simple;
	bh=0lF6D0Ln7xG1USqIc4zn/VFLBCdCCVRxLr/XMWzq2fA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ejsO7hToNpl++Cptb0N7bwe5GlUC7pKP0A3WRZuSMJfW5uVMUdhwkY/l8VzfyoYS6bb0h64MumzJFWtG/DU15SDsnjHZv95/CGiWYayu3U+uxmo++bWgEaqTWhebNnr9yR5+/mwUVRQ6+ZNOGyjNCyO4fsUi8ZvnJPKQA8NcH+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LK3WPX9X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LK3WPX9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB73DC32786;
	Tue, 30 Jul 2024 00:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300388;
	bh=0lF6D0Ln7xG1USqIc4zn/VFLBCdCCVRxLr/XMWzq2fA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LK3WPX9XVIWXyuFflLjlwnbBt6hTnsgXOxsa5zzLA90uYGrdQV+4V9L30XgUvMLMy
	 Nh0WgtT8k64M7qFexgWlsm6vc5Bx+pmF7+PTRD78UshIrkiDbD3VRBT7wq5wUUaLhG
	 13GUMTlvEHIsxbWQIMZyrVtauKHDFlF8bHVXib6vm4jpa1759FHhz9JnuySPs1hGqf
	 7cTQJg2+wYyFtuxpZilPFN3OJhuf/rL8Hli6P1I9eNr0mM/1Yc5K3k8gN++j7lPudD
	 F6FbEJM7/najsHNCXFm3xZqlTmYmaneLIe9m6vMulel/eNiUfZPg+mJYgyioIyAwx/
	 3UXmYKAQZvKjg==
Date: Mon, 29 Jul 2024 17:46:28 -0700
Subject: [PATCH 087/115] xfs: factor out a xfs_dir_lookup_args helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172229843683.1338752.11126016823215172761.stgit@frogsfrogsfrogs>
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

Source kernel commit: 14ee22fef420c864c0869419e54aa4e88f64b4e6

Add a helper to switch between the different directory formats for
lookup and to handle the -EEXIST return for a successful lookup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_dir2.c |   66 ++++++++++++++++++++++++++++++++---------------------
 libxfs/xfs_dir2.h |    2 ++
 2 files changed, 42 insertions(+), 26 deletions(-)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index e309e1e58..0cf4120fe 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -351,6 +351,45 @@ xfs_dir_cilookup_result(
 	return -EEXIST;
 }
 
+int
+xfs_dir_lookup_args(
+	struct xfs_da_args	*args)
+{
+	bool			is_block, is_leaf;
+	int			error;
+
+	if (args->dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
+		error = xfs_dir2_sf_lookup(args);
+		goto out;
+	}
+
+	/* dir2 functions require that the data fork is loaded */
+	error = xfs_iread_extents(args->trans, args->dp, XFS_DATA_FORK);
+	if (error)
+		goto out;
+
+	error = xfs_dir2_isblock(args, &is_block);
+	if (error)
+		goto out;
+
+	if (is_block) {
+		error = xfs_dir2_block_lookup(args);
+		goto out;
+	}
+
+	error = xfs_dir2_isleaf(args, &is_leaf);
+	if (error)
+		goto out;
+	if (is_leaf)
+		error = xfs_dir2_leaf_lookup(args);
+	else
+		error = xfs_dir2_node_lookup(args);
+out:
+	if (error != -EEXIST)
+		return error;
+	return 0;
+}
+
 /*
  * Lookup a name in a directory, give back the inode number.
  * If ci_name is not NULL, returns the actual name in ci_name if it differs
@@ -367,7 +406,6 @@ xfs_dir_lookup(
 {
 	struct xfs_da_args	*args;
 	int			rval;
-	bool			v;
 	int			lock_mode;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
@@ -389,30 +427,7 @@ xfs_dir_lookup(
 		args->op_flags |= XFS_DA_OP_CILOOKUP;
 
 	lock_mode = xfs_ilock_data_map_shared(dp);
-	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
-		rval = xfs_dir2_sf_lookup(args);
-		goto out_check_rval;
-	}
-
-	rval = xfs_dir2_isblock(args, &v);
-	if (rval)
-		goto out_free;
-	if (v) {
-		rval = xfs_dir2_block_lookup(args);
-		goto out_check_rval;
-	}
-
-	rval = xfs_dir2_isleaf(args, &v);
-	if (rval)
-		goto out_free;
-	if (v)
-		rval = xfs_dir2_leaf_lookup(args);
-	else
-		rval = xfs_dir2_node_lookup(args);
-
-out_check_rval:
-	if (rval == -EEXIST)
-		rval = 0;
+	rval = xfs_dir_lookup_args(args);
 	if (!rval) {
 		*inum = args->inumber;
 		if (ci_name) {
@@ -420,7 +435,6 @@ xfs_dir_lookup(
 			ci_name->len = args->valuelen;
 		}
 	}
-out_free:
 	xfs_iunlock(dp, lock_mode);
 	kfree(args);
 	return rval;
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index b580a78bc..982c2249b 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -66,6 +66,8 @@ extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
+int xfs_dir_lookup_args(struct xfs_da_args *args);
+
 /*
  * Direct call from the bmap code, bypassing the generic directory layer.
  */

