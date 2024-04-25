Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D651494B4
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 13:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714051036; cv=none; b=P+CKNWFlQXPUbUTeF4Z8Vwkrm5h8XLfRGJ6BKUCj/KVfjelT+xw9X2jJh9rSxAKbkCwHQygGYg0gfRB760+LcGX4QjFT1gCSI/qxMZ5m5UbZ7TcWTQgEol2H0yTKthTJ8CCkYcIBwpCqypAABwwBKcm8DCq33A3zI70KZAGWsY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714051036; c=relaxed/simple;
	bh=5S6XMHyBYka/JzwNat/D3Z8mq3HOyKtm19BuVCNAFBQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t+TQFRdo5tC9v00AAnYooa0Z7WSPI/DoTh1lZIZS8kt53orz7iIsa6NpaHadX9Rhq1YczrdRg286eBpvhTohwqPXflCL7V943Rwx5YsTHKNBwTSHTB//YYIu2DeqejzTqVEejLgVQuj/A5EFgdZTQa7eYKx0o9KATdWljtFruoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=V4/zcp1G; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V4/zcp1G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jHBQWo/etNVXOy3jH9aSywhD2FcYXDbQ3UbdPz0EZiI=; b=V4/zcp1Glq55ErTNHUtGKFj4k9
	9oqMPZnHCzUuBRlol/+aybLNwwRAGatLuwUObJwmZ0HBWiwRxVw7PfTVCtbbZlZEi+3YKD608Ofgb
	usgAnt+2ucVNnCQ/1eaynMCIwKlinO+vi+jnK5Y15S1ESHY176E4B96jeysSz8WOuu3POK22AvlqM
	HnSxXA6pBJZpkbyLFwu3G8qfFcK15Oa7lm1MoAsd/uJPUKuaeuXqp9lMVMzhK/4S7NIQtR657xyNO
	xx99AztXLQlZX8GeM1CcFJ/szSZMy5v9ZDnMi7Gl1Y0LkcMxI3R0ILHm5PexP65QDUwojWrYvqq6M
	oAHq7Q2g==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rzyyQ-00000008RcI-1dnT;
	Thu, 25 Apr 2024 13:17:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] xfs: factor out a xfs_dir_removename_args helper
Date: Thu, 25 Apr 2024 15:17:01 +0200
Message-Id: <20240425131703.928936-4-hch@lst.de>
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
 fs/xfs/libxfs/xfs_dir2.c  | 48 ++++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_dir2.h  |  1 +
 fs/xfs/scrub/dir_repair.c | 20 +---------------
 3 files changed, 27 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index e2727602d0479e..76aa11ade2e92d 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -444,6 +444,30 @@ xfs_dir_lookup(
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
@@ -457,7 +481,6 @@ xfs_dir_removename(
 {
 	struct xfs_da_args	*args;
 	int			rval;
-	bool			v;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
@@ -477,28 +500,7 @@ xfs_dir_removename(
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
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index f5361dd7b90a93..3db54801d69ecd 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -68,6 +68,7 @@ extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 
 int xfs_dir_lookup_args(struct xfs_da_args *args);
 int xfs_dir_createname_args(struct xfs_da_args *args);
+int xfs_dir_removename_args(struct xfs_da_args *args);
 
 /*
  * Direct call from the bmap code, bypassing the generic directory layer.
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 4cad98243d7be8..ce22c0d3571d2d 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -733,8 +733,6 @@ xrep_dir_replay_removename(
 	xfs_extlen_t		total)
 {
 	struct xfs_inode	*dp = rd->args.dp;
-	bool			is_block, is_leaf;
-	int			error;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 
@@ -743,23 +741,7 @@ xrep_dir_replay_removename(
 	rd->args.total = total;
 
 	trace_xrep_dir_replay_removename(dp, name, 0);
-
-	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
-		return xfs_dir2_sf_removename(&rd->args);
-
-	error = xfs_dir2_isblock(&rd->args, &is_block);
-	if (error)
-		return error;
-	if (is_block)
-		return xfs_dir2_block_removename(&rd->args);
-
-	error = xfs_dir2_isleaf(&rd->args, &is_leaf);
-	if (error)
-		return error;
-	if (is_leaf)
-		return xfs_dir2_leaf_removename(&rd->args);
-
-	return xfs_dir2_node_removename(&rd->args);
+	return xfs_dir_removename_args(&rd->args);
 }
 
 /*
-- 
2.39.2

