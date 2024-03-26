Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8C71292E6
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424300; cv=none; b=tM4WKjSfX8Uc3ezkbSBAfdVWLFzkV/+tQbVPFe9B2oe/8lFoFnddPaQr5e6epW6tDP2CZEwLw7asNI0fCMuGIsytqVFV1B05NOKBB8Sa96R2W8cwLWcWACwQ9T2LNTT8SnBrg0AKFQ9ZIDl4GgfsZ+hGzzRmFslOc50PGFuYYOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424300; c=relaxed/simple;
	bh=GTT8rUSm81XqagtDPSnpWj2Bch0o0EZDlZRGR5UAf2I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XGTkklxvvsA79JuIQkzzA/npvHptpuMVECWCy5vVTarMJc+CWgoqWVI9Yi2Nho/GkvmaxbEU9IF+LnHiW9ax/GiExYX9pjTdfGMYTzax0htQThNd7rBeM3weCNGDLEX12hmY08kCkdEcyK6j9+OAQpxsKJAN1IXYmx5ARuDb2wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WtifGJJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WtifGJJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7A2C43390;
	Tue, 26 Mar 2024 03:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424300;
	bh=GTT8rUSm81XqagtDPSnpWj2Bch0o0EZDlZRGR5UAf2I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WtifGJJ8p7MFLg3nV0JB5KUef9sl8IDU9uMk+lbxeRku5nTWaI90rkNL/Pi5ps9di
	 gHZ2jHmwq/kcKyUl+deTqS6NbC2orMBxMdPXAqYKqmnzM8f+yg/iYuPAw1sj9hu1ES
	 fwXlnNCmvVjfnMJsLj8aTYdIj96S0dk/ryVCFMGB2rFGelTzweAFt95VgRSYkcbcZo
	 Hmd0dNUUH2KaANvdkBC1SQM8HLm/2qotYKsjrmQRf3iQ4d72Or44y1B8q2wDhrE4/q
	 v7AcM5CWEE23LrvZjaiDivz82vk5xUasWJFXy7cgriyLm7Ia1OlH1SvXHGyZr7FjU3
	 Wiskx6Th0t6ZQ==
Date: Mon, 25 Mar 2024 20:38:19 -0700
Subject: [PATCH 038/110] xfs: rename btree block/buffer init functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131932.2215168.11863239786850807692.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 3c68858b264fac292f74733eeaf558595978a5e5

Rename xfs_btree_init_block_int to xfs_btree_init_block, and
xfs_btree_init_block to xfs_btree_init_buf so that the name suggests the
type that caller are supposed to pass in.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ag.c            |    6 +++---
 libxfs/xfs_bmap_btree.c    |    4 ++--
 libxfs/xfs_btree.c         |    8 ++++----
 libxfs/xfs_btree.h         |    4 ++--
 libxfs/xfs_btree_staging.c |    2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 932bdfb8de6a..cdca7f2470f2 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -490,7 +490,7 @@ xfs_btroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 0, id->agno);
+	xfs_btree_init_buf(mp, bp, id->bc_ops, 0, 0, id->agno);
 }
 
 /* Finish initializing a free space btree. */
@@ -556,7 +556,7 @@ xfs_bnoroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 0, id->agno);
+	xfs_btree_init_buf(mp, bp, id->bc_ops, 0, 0, id->agno);
 	xfs_freesp_init_recs(mp, bp, id);
 }
 
@@ -572,7 +572,7 @@ xfs_rmaproot_init(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_rmap_rec	*rrec;
 
-	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 4, id->agno);
+	xfs_btree_init_buf(mp, bp, id->bc_ops, 0, 4, id->agno);
 
 	/*
 	 * mark the AG header regions as static metadata The BNO
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index a3732b4c4d72..65ba3ae8a549 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -34,10 +34,10 @@ xfs_bmbt_init_block(
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
 
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 5675dd5aedcf..541f2336c4d5 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1151,7 +1151,7 @@ xfs_btree_set_sibling(
 }
 
 void
-xfs_btree_init_block_int(
+xfs_btree_init_block(
 	struct xfs_mount	*mp,
 	struct xfs_btree_block	*buf,
 	const struct xfs_btree_ops *ops,
@@ -1193,7 +1193,7 @@ xfs_btree_init_block_int(
 }
 
 void
-xfs_btree_init_block(
+xfs_btree_init_buf(
 	struct xfs_mount		*mp,
 	struct xfs_buf			*bp,
 	const struct xfs_btree_ops	*ops,
@@ -1201,7 +1201,7 @@ xfs_btree_init_block(
 	__u16				numrecs,
 	__u64				owner)
 {
-	xfs_btree_init_block_int(mp, XFS_BUF_TO_BLOCK(bp), ops,
+	xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
 }
 
@@ -1225,7 +1225,7 @@ xfs_btree_init_block_cur(
 	else
 		owner = cur->bc_ag.pag->pag_agno;
 
-	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), cur->bc_ops,
+	xfs_btree_init_block(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), cur->bc_ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
 }
 
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 923f884fe526..56901d2591ed 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
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
 
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index ba3383cad438..47ef8e23a59e 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -410,7 +410,7 @@ xfs_btree_bload_prep_block(
 		ifp->if_broot_bytes = (int)new_size;
 
 		/* Initialize it and send it out. */
-		xfs_btree_init_block_int(cur->bc_mp, ifp->if_broot,
+		xfs_btree_init_block(cur->bc_mp, ifp->if_broot,
 				cur->bc_ops, XFS_BUF_DADDR_NULL, level,
 				nr_this_block, cur->bc_ino.ip->i_ino);
 

