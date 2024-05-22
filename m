Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032455234
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346722; cv=none; b=CxOYscBt4QkwlfdDLuFhBN3HJRaciKZtZOdZ4I3ChaerjEa8eLnEy+y54wgIlvAdVktzoEr4xXBvCF+J7/xluocnz71rgGXNCcPqiYkt/QAnkvIuj8njM6S9aHU4No12IfdrVYGTWsvQNsTmACHbcJDvMNMxjE4pdbRJzKEJ8QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346722; c=relaxed/simple;
	bh=7LFPmkSw06nOeptjiiSrNac6oHZQCNwmt2Uc7y/fhow=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pwyRWVKW/JLnWei5AXDIi+WPQV3Mh4uxxB4uCA8RHkdSY/c+yZIUb89Hcg+ZXJd3ruHO6sgIhkuLb2dfkCaDHnYp7ezWtdaZGOR3e+CohnMKY8ydCGWjzhjLMxgWv8Zb7I+bWv9cxF4yT674WcdZe1O7woyYDdn01MnICpMjeiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hsC22vMH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hsC22vMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDAEC2BD11;
	Wed, 22 May 2024 02:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346721;
	bh=7LFPmkSw06nOeptjiiSrNac6oHZQCNwmt2Uc7y/fhow=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hsC22vMHaMszdygBlDOu3/3hyRibnYtim9avEMmwhK3Oivy6GTWo+Re2DuQB8kR0t
	 VeEWRLM5hGzUeok7P8Qh078AG+M2cvySGJyUelTwdIvD0EFXw0zku5ABDYK8gdaGGw
	 vRky7pcCdCayrwO5gZFbNhyd1/E6CuhNRoqUSFChwG7fBSMvW+sPaprFVXZ/HGBFME
	 cd09npn/Ikf8vz4pr1uCixRVLTDlzzNWGjfwi8YVJVU7m0yc/E9LbsD2TV6TH0Hpxc
	 oNLCYIw42cTsmy9nU+tkUlugAVhTJMGGDePDdQIU19DkZA7GlmbFyWWbCHlMw+oMKT
	 IcYzTYspne9cg==
Date: Tue, 21 May 2024 19:58:41 -0700
Subject: [PATCH 038/111] xfs: rename btree block/buffer init functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532282.2478931.5236483281318272084.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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
index 932bdfb8d..cdca7f247 100644
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
index a3732b4c4..65ba3ae8a 100644
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
index 5675dd5ae..541f2336c 100644
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
index 923f884fe..56901d259 100644
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
index ba3383cad..47ef8e23a 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -410,7 +410,7 @@ xfs_btree_bload_prep_block(
 		ifp->if_broot_bytes = (int)new_size;
 
 		/* Initialize it and send it out. */
-		xfs_btree_init_block_int(cur->bc_mp, ifp->if_broot,
+		xfs_btree_init_block(cur->bc_mp, ifp->if_broot,
 				cur->bc_ops, XFS_BUF_DADDR_NULL, level,
 				nr_this_block, cur->bc_ino.ip->i_ino);
 

