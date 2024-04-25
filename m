Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0961494B4
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 13:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714051038; cv=none; b=KczLDp0D5Dgm5fVFiqKx9JfISHzeiuRQWfWVGHYADh84BnXU6zEDu1z68ijBf1k6mPdADtukLrnMimuXORcAfvzhK8bDazDGFwFZLe6/4f5RtuE9af6akYmWKgprYJPNQVxuEG3xiCmHTbxgDb+2dwTxc3wTY8OFHCMazvo9p9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714051038; c=relaxed/simple;
	bh=DVHVr5crb/iChG7FbXvbXh2VrYx7a6scPD9XYIcC0To=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZxG5atXByWjtVLKXrauJvXF4lZrxNWyOinZuz1ottgfhyHD4FNIlhEKZNAhNuiz8c0F60WXD38ROsM1ldCWqRUrnbdVypxJV/Bkz8+kuGa4whZCEVL4kc09+JVYoUVM2SV2oOiFm+B02YaZOiYZ0bfJx5jAqQJeUWFEXJkSzkl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Xh3XZXyW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xh3XZXyW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=p07UfNpckEe8L5VHZl6dPcCljLbyg3FxeLHMTzSBTMI=; b=Xh3XZXyWtqsLj4YcCN5SRvPnPr
	em0t/9/nqbYk3Qk6WgwcPQ3eKVUhIRdf3fXaWm/teWT3PJcc7WTpU1GolOr1lqSVoZpFkYMj+avV3
	q/btyFAoZiqEc9npdIrNVwCuzWxOWl4MlxnUGKmWrN9o6Ffx/Z/mzHeOXRpwRzyReR3VQGeoSlv/T
	HooWr7BZDXRuHU869PO/g9Ap9WXY5VHDo44uvSJl9l8AaNHlrg7BbTlRlD+6xkLtdINOlir7ipB9r
	YkgobW7WMuTfzzC+/z9s5fhDcMp9ErAZCX9BhunnAELZVv9aKg+Dy5bgFWNv0FmdLO6+/ovXV7Cfv
	yQEcQ4TA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rzyyS-00000008Rcr-3Jq3;
	Thu, 25 Apr 2024 13:17:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] xfs: factor out a xfs_dir_replace_args helper
Date: Thu, 25 Apr 2024 15:17:02 +0200
Message-Id: <20240425131703.928936-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240425131703.928936-1-hch@lst.de>
References: <20240425131703.928936-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a helper to switch between the different directory formats for
removing a directory entry.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2.c  | 49 +++++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_dir2.h  |  1 +
 fs/xfs/scrub/dir_repair.c | 19 +--------------
 3 files changed, 28 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 76aa11ade2e92d..d3d4d80c2098d3 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -505,6 +505,31 @@ xfs_dir_removename(
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
@@ -518,7 +543,6 @@ xfs_dir_replace(
 {
 	struct xfs_da_args	*args;
 	int			rval;
-	bool			v;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 
@@ -541,28 +565,7 @@ xfs_dir_replace(
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
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 3db54801d69ecd..6c00fe24a8987e 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -69,6 +69,7 @@ extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 int xfs_dir_lookup_args(struct xfs_da_args *args);
 int xfs_dir_createname_args(struct xfs_da_args *args);
 int xfs_dir_removename_args(struct xfs_da_args *args);
+int xfs_dir_replace_args(struct xfs_da_args *args);
 
 /*
  * Direct call from the bmap code, bypassing the generic directory layer.
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index ce22c0d3571d2d..09fd0b76516e03 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1534,7 +1534,6 @@ xrep_dir_replace(
 	xfs_extlen_t		total)
 {
 	struct xfs_scrub	*sc = rd->sc;
-	bool			is_block, is_leaf;
 	int			error;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
@@ -1546,23 +1545,7 @@ xrep_dir_replace(
 	xrep_dir_init_args(rd, dp, name);
 	rd->args.inumber = inum;
 	rd->args.total = total;
-
-	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
-		return xfs_dir2_sf_replace(&rd->args);
-
-	error = xfs_dir2_isblock(&rd->args, &is_block);
-	if (error)
-		return error;
-	if (is_block)
-		return xfs_dir2_block_replace(&rd->args);
-
-	error = xfs_dir2_isleaf(&rd->args, &is_leaf);
-	if (error)
-		return error;
-	if (is_leaf)
-		return xfs_dir2_leaf_replace(&rd->args);
-
-	return xfs_dir2_node_replace(&rd->args);
+	return xfs_dir_replace_args(&rd->args);
 }
 
 /*
-- 
2.39.2

