Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F9E43AC7
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816568; cv=none; b=QAOJVSvSvfFE/PLH9EdLjfkfmZ3rduqH43O0QkYTP8JZPgpyfFwKIA8wYNFBUu1/MBNrU9Cguh9LcR7hz/LObGjIzYNEwEx2s9bFAsubihaSRpip5RgG9GGT5TDzDxDsysIgC2GOWp9gTE7AMsnE6B0tgpqhZ0y1x8/NPWdN1bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816568; c=relaxed/simple;
	bh=lNfZFJRZzGVoQMQFv3rOTSTDMCPOHGGKqr4Bm7VD/CE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k9tqHTOZIizw6WKj8Py82/wW+Co1B7IS7fQYyWY+1uUjKklGCyJGejva0SI+JZ+U/fQtTSno504hJ3Xi+25/Uk5Ms18KI1ewr8y0aNK17M8b9XLywr67aSdOQcsRL/GqESm1W+lDGLndYxHePIM1HJpPI9w1hznLkbtWPMnhP1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qu/VoB0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qu/VoB0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50ED1C433C7;
	Thu,  1 Feb 2024 19:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816568;
	bh=lNfZFJRZzGVoQMQFv3rOTSTDMCPOHGGKqr4Bm7VD/CE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Qu/VoB0pioD7ujWkgCoAl51xOCGnlSI+Mlhsd3zxITNtYAUCT2m1V39tBV8v8DzFd
	 sxSrLymuoDNoPcDK27AClvLhj5it+WKQmFiDPtE+1oLIfyPzr1D1UavznifM4e6pNN
	 q5y9pRpBjahFg+nZHtzcZgRwKzM9EST0Gi2fIPWlNcZAAsNLdF4W/Dvej4tFRoO+W5
	 OyAWlET0BJlLc9fPbKg6OH7GsG//7lyL4jAOgTd5Agv5kd6lCsO0jMRfrKojSe0k+m
	 K9uXrzBDen+mtzxeIYYaXISBejNziipJnfr9dfdUnkusBnI+cFs23+CfCA5Ir5N7ET
	 SRU7fQRooSvkQ==
Date: Thu, 01 Feb 2024 11:42:47 -0800
Subject: [PATCH 12/23] xfs: rename btree block/buffer init functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334134.1604831.12016520931269462305.stgit@frogsfrogsfrogs>
In-Reply-To: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Rename xfs_btree_init_block_int to xfs_btree_init_block, and
xfs_btree_init_block to xfs_btree_init_buf so that the name suggests the
type that caller are supposed to pass in.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag.c            |    6 +++---
 fs/xfs/libxfs/xfs_bmap_btree.c    |    4 ++--
 fs/xfs/libxfs/xfs_btree.c         |    8 ++++----
 fs/xfs/libxfs/xfs_btree.h         |    4 ++--
 fs/xfs/libxfs/xfs_btree_staging.c |    2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index daeffc280f746..02d8c1caa26a8 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -492,7 +492,7 @@ xfs_btroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 0, id->agno);
+	xfs_btree_init_buf(mp, bp, id->bc_ops, 0, 0, id->agno);
 }
 
 /* Finish initializing a free space btree. */
@@ -558,7 +558,7 @@ xfs_bnoroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 0, id->agno);
+	xfs_btree_init_buf(mp, bp, id->bc_ops, 0, 0, id->agno);
 	xfs_freesp_init_recs(mp, bp, id);
 }
 
@@ -574,7 +574,7 @@ xfs_rmaproot_init(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_rmap_rec	*rrec;
 
-	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 4, id->agno);
+	xfs_btree_init_buf(mp, bp, id->bc_ops, 0, 4, id->agno);
 
 	/*
 	 * mark the AG header regions as static metadata The BNO
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index f9de93499bce4..ddaf40e0f3092 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -35,10 +35,10 @@ xfs_bmbt_init_block(
 	__u16				numrecs)
 {
 	if (bp)
-		xfs_btree_init_block(ip->i_mount, bp, &xfs_bmbt_ops, level,
+		xfs_btree_init_buf(ip->i_mount, bp, &xfs_bmbt_ops, level,
 				numrecs, ip->i_ino);
 	else
-		xfs_btree_init_block_int(ip->i_mount, buf, &xfs_bmbt_ops,
+		xfs_btree_init_block(ip->i_mount, buf, &xfs_bmbt_ops,
 				XFS_BUF_DADDR_NULL, level, numrecs, ip->i_ino);
 }
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index f8d982704b410..afa9d15fe7884 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1154,7 +1154,7 @@ xfs_btree_set_sibling(
 }
 
 void
-xfs_btree_init_block_int(
+xfs_btree_init_block(
 	struct xfs_mount	*mp,
 	struct xfs_btree_block	*buf,
 	const struct xfs_btree_ops *ops,
@@ -1196,7 +1196,7 @@ xfs_btree_init_block_int(
 }
 
 void
-xfs_btree_init_block(
+xfs_btree_init_buf(
 	struct xfs_mount		*mp,
 	struct xfs_buf			*bp,
 	const struct xfs_btree_ops	*ops,
@@ -1204,7 +1204,7 @@ xfs_btree_init_block(
 	__u16				numrecs,
 	__u64				owner)
 {
-	xfs_btree_init_block_int(mp, XFS_BUF_TO_BLOCK(bp), ops,
+	xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
 }
 
@@ -1228,7 +1228,7 @@ xfs_btree_init_block_cur(
 	else
 		owner = cur->bc_ag.pag->pag_agno;
 
-	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), cur->bc_ops,
+	xfs_btree_init_block(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), cur->bc_ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
 }
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index cf3958151be53..e07d06da64579 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -435,10 +435,10 @@ xfs_btree_reada_bufs(
 /*
  * Initialise a new btree block header
  */
-void xfs_btree_init_block(struct xfs_mount *mp, struct xfs_buf *bp,
+void xfs_btree_init_buf(struct xfs_mount *mp, struct xfs_buf *bp,
 		const struct xfs_btree_ops *ops, __u16 level, __u16 numrecs,
 		__u64 owner);
-void xfs_btree_init_block_int(struct xfs_mount *mp,
+void xfs_btree_init_block(struct xfs_mount *mp,
 		struct xfs_btree_block *buf, const struct xfs_btree_ops *ops,
 		xfs_daddr_t blkno, __u16 level, __u16 numrecs, __u64 owner);
 
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index ff2e468f4c0f6..fa89c1e5175e2 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -410,7 +410,7 @@ xfs_btree_bload_prep_block(
 		ifp->if_broot_bytes = (int)new_size;
 
 		/* Initialize it and send it out. */
-		xfs_btree_init_block_int(cur->bc_mp, ifp->if_broot,
+		xfs_btree_init_block(cur->bc_mp, ifp->if_broot,
 				cur->bc_ops, XFS_BUF_DADDR_NULL, level,
 				nr_this_block, cur->bc_ino.ip->i_ino);
 

