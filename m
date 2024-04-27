Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485173BB50
	for <linux-xfs@vger.kernel.org>; Sat, 27 Apr 2024 05:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714194256; cv=none; b=arPb0SB+W40WiZwuWZBqbL782QLtgUyg5RC1ncUXPMYl9BMss7iAvDrBEP45WD0bHAB0vEW1KB6mLN0xNFrM0fwX1Pt9m85sJAsvxoN2vkeNOePZ5SQ1+i4TxUOOKDX47ELdvwRiQ8Nu/usgmALP1RVefXf9A7ROfwgGdVA4HAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714194256; c=relaxed/simple;
	bh=+k3spCQtWBXQM4wgwTbxRPU4+fZgj9qTdSaMfOx+KJw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Rks8nNAjs2B8HZZa2Y6d2NHFE5uBafTcBuwav8YrnSSGOD2rklKKD/XTooBlZU1Jrv8EpkX+ZBQRi1IVskHVNwNe87juO4mbf02ZG4aLyMghkXx8rfJATlVRxD90Ryk69qutO/mhOjolbXK+9zWZT5fKl1tz+FHR7XfgOcUR92g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bR6RwcaJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bR6RwcaJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zb75gW7eusoNmloUJLe8H8xYPEjIU7cMfjeims56Eko=; b=bR6RwcaJumZ3Trrq3kUBv/Rt8F
	6X0ki02HN1Z43bD9wwp3Cnh1R+fqKydOooDJRGwQs49P5LwDxM16VOtTdlp8ZywqAMntynFeJOlIY
	CwEFl5C6ybgX8WFXImfaTDtUn1bA1rT2vNtu2SaQLOYz3vlFAXvKiGfNH+2XZZe+y8jQfj4/UME+h
	dfcZ+/hz6A0lt5gQid0PQXPHAbn5w0zCroyfVLE5UDDzbf8Er1Lh/E6x1pj6xte3TTnG5jPNKfq36
	K0xWwJBYCZLos0VnKR9icylf4JtgfqLqetgb8CVT8FT926gxZqrDabZN7DcWnvaGVVlgFTLIC169V
	KgDz9j6w==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s0aEQ-0000000EqCU-28Rs;
	Sat, 27 Apr 2024 05:04:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] xfs: factor out a xfs_dir_replace_args helper
Date: Sat, 27 Apr 2024 07:03:59 +0200
Message-Id: <20240427050400.1126656-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240427050400.1126656-1-hch@lst.de>
References: <20240427050400.1126656-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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
index 98e4ed25cc2309..64679fe0844650 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1513,7 +1513,6 @@ xrep_dir_replace(
 	xfs_extlen_t		total)
 {
 	struct xfs_scrub	*sc = rd->sc;
-	bool			is_block, is_leaf;
 	int			error;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
@@ -1525,23 +1524,7 @@ xrep_dir_replace(
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

