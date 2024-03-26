Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C083128801
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424394; cv=none; b=qVMU8Ii2SqEZOnmUPX0p4bVEsJqaeGr04sAOvcrxeVLW3awcMY88qOtQNDWSk8EHIKQ20KHFqyPZ6TrJ0tOH0/bUQXwsItQa0fyu12LldPCl2NqyFx3zZb4jdN6e3IyALSqGvXUrK0vXm4XWysFNKDWKWhQDMlIvZrwMM983GLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424394; c=relaxed/simple;
	bh=d3P6jIlxgzRYZBVQzgUhVBzlpb+G46OYDS68Ib6oou8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q99cJRQjEEhy+AUKKeVmeq1UkLeUdSCGryqQ0pHHsfSQZTQLPffC2KQa2yyGQsCh3oUPLrpip5xPSI0XryGEvbfqOCMLhEV64N26UCsa6cvdsw4f1OlxqaofMa3NXt2keGpr4ldXLLugzysv/Bn+SlPP4EsNYWa7igYgr1RDEAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mPY9aDM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPY9aDM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37420C433C7;
	Tue, 26 Mar 2024 03:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424394;
	bh=d3P6jIlxgzRYZBVQzgUhVBzlpb+G46OYDS68Ib6oou8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mPY9aDM7mgyqrHovtLwoSVW85D9DEWpcZn/Sy2DEPJOCQmd1RoW4SUrSLON8xaxE6
	 DkDOEUTILYoJw5e9JZ8yNMKLG7OZvbXEJGTH3SX/wSTD6vnI1H1tKoP2lNnKhA/k3E
	 7rWzlOAaBt2pHPJSPBTsdUNha7RJoO/e1MyUGCVV1JCK9nUJRF/P22+dKC+UUcKQf3
	 r75URx2dzrPCsgsRQDiUhUyEuJBzjzr+5lcVGZcXumGnto3tnuuspnFWwg2hu3yVD5
	 63BN6RztToKjTlfXgKOd4FMipD51xwgGH4kHe0/hYdXa2MdYJ97wVOIv8TtZo2I19o
	 T5O3/xstJa0Dg==
Date: Mon, 25 Mar 2024 20:39:53 -0700
Subject: [PATCH 044/110] xfs: factor out a xfs_btree_owner helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132018.2215168.11207812038648892055.stgit@frogsfrogsfrogs>
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

Source kernel commit: 2054cf051698d30cc9479678c2b807a364248f38

Split out a helper to calculate the owner for a given btree instead of
duplicating the logic in two places.  While we're at it, make the
bc_ag/bc_ino switch logic depend on the correct geometry flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: break this up into two patches for the owner check]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 150f8ac23d9d..dab571222c96 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1219,6 +1219,15 @@ xfs_btree_init_buf(
 	bp->b_ops = ops->buf_ops;
 }
 
+static inline __u64
+xfs_btree_owner(
+	struct xfs_btree_cur    *cur)
+{
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE)
+		return cur->bc_ino.ip->i_ino;
+	return cur->bc_ag.pag->pag_agno;
+}
+
 void
 xfs_btree_init_block_cur(
 	struct xfs_btree_cur	*cur,
@@ -1226,20 +1235,8 @@ xfs_btree_init_block_cur(
 	int			level,
 	int			numrecs)
 {
-	__u64			owner;
-
-	/*
-	 * we can pull the owner from the cursor right now as the different
-	 * owners align directly with the pointer size of the btree. This may
-	 * change in future, but is safe for current users of the generic btree
-	 * code.
-	 */
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
-		owner = cur->bc_ino.ip->i_ino;
-	else
-		owner = cur->bc_ag.pag->pag_agno;
-
-	xfs_btree_init_buf(cur->bc_mp, bp, cur->bc_ops, level, numrecs, owner);
+	xfs_btree_init_buf(cur->bc_mp, bp, cur->bc_ops, level, numrecs,
+			xfs_btree_owner(cur));
 }
 
 /*

