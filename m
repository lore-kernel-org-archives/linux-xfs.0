Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294D01494B4
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 13:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714051031; cv=none; b=ko1QelAioiMkkuoky5ZG1Id3EJPaALJhAX72K8fXn+FA/S7hLXTQaRvHHX5+B13Vm7jz+yVjUPq0o5NnNPKe8gTKhR9Q4aEpeYAKBt/qc6L9l5XMSK8bhjgVGwbGU41Ls2jBDGmv64e2jok9SsMJMZwznUBUSxUqAeozPe716fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714051031; c=relaxed/simple;
	bh=C1albHJd/WmRn+TS4wqB3fdwY5iEd+TUtbSUiPrRTrU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mVcx0vu1i+nLTiZJ2rAXNTtIVwH/Ih/w+UOrb8Ac/06Uo0YIXfKatyZr2Q9jeNSv0IqkpxWQbpGSMVPCz6/OUSky7BkR4YOPJV2/XfHGmODznYL4rJojBrTS072sUWyBCQjPevniVQNHXCYlNt+30FCw74MpWSlao/P6RBE8sqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ddOqLBXN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ddOqLBXN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DO85Hx0gB6R31990IWHGGl8RMK6rYst4Iy3T4KZLg84=; b=ddOqLBXNUPlcDbrIg2qSaqo/uC
	2T6mR5n/D+4VllHDzzw0n+YdeqrekuyxnU4Uws28QNPr7l5TlwyqHqb+FH4AAkxLoB8wivdQDIWi/
	fwnAZ+Z5EMbC5o1TKHuNOUAildfDuLzipis0HEUAatGrDXdYOshi/G86Rr5U7rV4xm7RBaHUgEhdJ
	YXQIWNDfiVJs13gCpr2gGV7pBOcxDNkjw8By3KzscQGRjVNsHYTRoVp5GGDZ6JcuM+6ReYxZSMAlM
	KCmVWkG609evFWIDoNgnykFLz5pmGixK/kKnGicBPnSJGzBWgKuo1gwpPO3zJPD32vQ2BXFYGmY3x
	rFsFsGbA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rzyyL-00000008Rao-1Is5;
	Thu, 25 Apr 2024 13:17:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] xfs: factor out a xfs_dir_lookup_args helper
Date: Thu, 25 Apr 2024 15:16:59 +0200
Message-Id: <20240425131703.928936-2-hch@lst.de>
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
lookup and to handle the -EEXIST return for a successful lookup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2.c | 66 ++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_dir2.h |  2 ++
 fs/xfs/scrub/readdir.c   | 35 +--------------------
 3 files changed, 43 insertions(+), 60 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 7634344dc51538..b4f9359089117e 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -352,6 +352,45 @@ xfs_dir_cilookup_result(
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
@@ -368,7 +407,6 @@ xfs_dir_lookup(
 {
 	struct xfs_da_args	*args;
 	int			rval;
-	bool			v;
 	int			lock_mode;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
@@ -390,30 +428,7 @@ xfs_dir_lookup(
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
@@ -421,7 +436,6 @@ xfs_dir_lookup(
 			ci_name->len = args->valuelen;
 		}
 	}
-out_free:
 	xfs_iunlock(dp, lock_mode);
 	kfree(args);
 	return rval;
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index b580a78bcf4fc2..982c2249bfa305 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -66,6 +66,8 @@ extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
+int xfs_dir_lookup_args(struct xfs_da_args *args);
+
 /*
  * Direct call from the bmap code, bypassing the generic directory layer.
  */
diff --git a/fs/xfs/scrub/readdir.c b/fs/xfs/scrub/readdir.c
index 28a94c78b0b199..0ac77359d8e9f8 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -328,7 +328,6 @@ xchk_dir_lookup(
 		.op_flags	= XFS_DA_OP_OKNOENT,
 		.owner		= dp->i_ino,
 	};
-	bool			isblock, isleaf;
 	int			error;
 
 	if (xfs_is_shutdown(dp->i_mount))
@@ -344,39 +343,7 @@ xchk_dir_lookup(
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	xfs_assert_ilocked(dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
 
-	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
-		error = xfs_dir2_sf_lookup(&args);
-		goto out_check_rval;
-	}
-
-	/* dir2 functions require that the data fork is loaded */
-	error = xfs_iread_extents(sc->tp, dp, XFS_DATA_FORK);
-	if (error)
-		return error;
-
-	error = xfs_dir2_isblock(&args, &isblock);
-	if (error)
-		return error;
-
-	if (isblock) {
-		error = xfs_dir2_block_lookup(&args);
-		goto out_check_rval;
-	}
-
-	error = xfs_dir2_isleaf(&args, &isleaf);
-	if (error)
-		return error;
-
-	if (isleaf) {
-		error = xfs_dir2_leaf_lookup(&args);
-		goto out_check_rval;
-	}
-
-	error = xfs_dir2_node_lookup(&args);
-
-out_check_rval:
-	if (error == -EEXIST)
-		error = 0;
+	error = xfs_dir_lookup_args(&args);
 	if (!error)
 		*ino = args.inumber;
 	return error;
-- 
2.39.2

