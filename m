Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8779B3E476
	for <linux-xfs@vger.kernel.org>; Sat, 27 Apr 2024 05:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714194252; cv=none; b=npGXugo/cQ+aoo0K9Ser8bzeo1yvVlFN/Vj3h4DrZ1iVgMRnaPtMxzy4GXQVMclBpxYAB5EX8ehUrkQ55ocWU24ZOEiBSuadP5YJj+X8sSBQceWDHSLQmmxgtOcUG2CA2U19FQ8XB+SLUIKYifDgz1NS1cl+9KW62QRNlDzkL88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714194252; c=relaxed/simple;
	bh=8oSoNhm3XHFHTtgl3UvryDs83wBF+bSPWVFdDnnVKT0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QCcKOO4Jlcrp1H3Ojmld+/4ibyOzZ3Yx1nAICKfjEOP6vtOsBe+AOxo9iBP4TuOt/TTEeKTKtI4LzTRxkFdM4dKmwRpHewXVF3gm6qtzvYx/rusrM6I1oKZdx+E74Ko/lZYbz3l4HffQzatybHKDxKtiSC0TozjfhOJIvgsPQsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xpC4VlvY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xpC4VlvY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rFEOkL8elgIXkHyooX3gkugA7WUFv6Ar05xGFzpNEjQ=; b=xpC4VlvY3nlw1OurPIGfSw+QLF
	qR4QjIXwtTWrwKrGjnnkEHVLLWvHRRp6ZCTLIxH2d5NGHHX22+U+uYFWMgDqDfYM7L7KiLfLQiew5
	gQ+BIDCwO9c2/HGmOlbamxnOVVPx/HOkNBEHb7PFJaxAc9QKLRoT/6n/pq8n2J9eeauTpRtoYig/2
	K9uOWoHI/jASBEiGHKmzyauM4ejlpQIOSGe+E8ZjqklPQEjt39UYFW1ud1E60dUa8mye4hCbPle85
	RoMjwDwTLoGPg1ADyeeiqof4oNsbQzRX/XQ6H4nztbSKuOm3wshmG68F7HiWa9fYAnMwAHgluGEZS
	VY2TuF9w==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s0aEL-0000000EqC1-1MwM;
	Sat, 27 Apr 2024 05:04:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] xfs: factor out a xfs_dir_createname_args helper
Date: Sat, 27 Apr 2024 07:03:57 +0200
Message-Id: <20240427050400.1126656-3-hch@lst.de>
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
creating a directory entry and to handle the XFS_DA_OP_JUSTCHECK flag
based on the passed in ino number field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c  | 53 +++++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_dir2.h  |  1 +
 fs/xfs/scrub/dir_repair.c | 19 +-------------
 3 files changed, 30 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index b4f9359089117e..e2727602d0479e 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -256,6 +256,33 @@ xfs_dir_init(
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
@@ -270,7 +297,6 @@ xfs_dir_createname(
 {
 	struct xfs_da_args	*args;
 	int			rval;
-	bool			v;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 
@@ -297,31 +323,8 @@ xfs_dir_createname(
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
 	args->owner = dp->i_ino;
-	if (!inum)
-		args->op_flags |= XFS_DA_OP_JUSTCHECK;
-
-	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
-		rval = xfs_dir2_sf_addname(args);
-		goto out_free;
-	}
 
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
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 982c2249bfa305..f5361dd7b90a93 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -67,6 +67,7 @@ extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
 int xfs_dir_lookup_args(struct xfs_da_args *args);
+int xfs_dir_createname_args(struct xfs_da_args *args);
 
 /*
  * Direct call from the bmap code, bypassing the generic directory layer.
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index fa1a9954d48d93..a1e31b7827881c 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -687,7 +687,6 @@ xrep_dir_replay_createname(
 {
 	struct xfs_scrub	*sc = rd->sc;
 	struct xfs_inode	*dp = rd->sc->tempip;
-	bool			is_block, is_leaf;
 	int			error;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
@@ -702,23 +701,7 @@ xrep_dir_replay_createname(
 	rd->args.inumber = inum;
 	rd->args.total = total;
 	rd->args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
-
-	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
-		return xfs_dir2_sf_addname(&rd->args);
-
-	error = xfs_dir2_isblock(&rd->args, &is_block);
-	if (error)
-		return error;
-	if (is_block)
-		return xfs_dir2_block_addname(&rd->args);
-
-	error = xfs_dir2_isleaf(&rd->args, &is_leaf);
-	if (error)
-		return error;
-	if (is_leaf)
-		return xfs_dir2_leaf_addname(&rd->args);
-
-	return xfs_dir2_node_addname(&rd->args);
+	return xfs_dir_createname_args(&rd->args);
 }
 
 /* Replay a stashed removename onto the temporary directory. */
-- 
2.39.2

