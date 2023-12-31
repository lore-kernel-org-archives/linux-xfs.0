Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7D2C129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EUvxHU0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F713C433C8;
	Sun, 31 Dec 2023 22:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061311;
	bh=i8ECzpPFhAb8UC4y3YDK9WexTyPKmY4l8fqCbjdMuTM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EUvxHU0C66bvCviwpVqlNdHBMV2Xb8cAQHrQQAPtTQtsUvlrRmFpilJsv5lzuNPs0
	 TWdksoK+zcahHq4wkY1sPQAxaXBrb0Amd/sn1whtBXc/2JzHTmglUzTDeNqHWZwwl/
	 hoTqF62SJ/N0QlwIXW7WlnaMfAUzfspl610IaTfm3NAz4+7lYGxY143izSElWfO651
	 VGYf/Se8+BX0SZOWRp4Qqc1Zvm4kObyESveDu+16OdqwZl3sN6gyGknempjxHff9CJ
	 KHOeCCDtu93ZHBJdCkEhZaBg0eHfXhlDgNyg1ktrKAKHq8v1/OiIMvr18KeLGKSx50
	 31M1onb49X5qw==
Date: Sun, 31 Dec 2023 14:21:50 -0800
Subject: [PATCH 8/9] xfs: set btree block buffer ops in _init_buf
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404994097.1795132.7145169827970828780.stgit@frogsfrogsfrogs>
In-Reply-To: <170404993983.1795132.17312636757680803212.stgit@frogsfrogsfrogs>
References: <170404993983.1795132.17312636757680803212.stgit@frogsfrogsfrogs>
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

Set the btree block buffer ops in xfs_btree_init_buf since we already
have access to that information through the btree ops.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfbtree.c   |    1 -
 libxfs/xfs_bmap.c  |    1 -
 libxfs/xfs_btree.c |    1 +
 3 files changed, 1 insertion(+), 2 deletions(-)


diff --git a/libxfs/xfbtree.c b/libxfs/xfbtree.c
index 7310f29a8c2..d76b3d5ea70 100644
--- a/libxfs/xfbtree.c
+++ b/libxfs/xfbtree.c
@@ -401,7 +401,6 @@ xfbtree_init_leaf_block(
 
 	trace_xfbtree_create_root_buf(xfbt, bp);
 
-	bp->b_ops = cfg->btree_ops->buf_ops;
 	xfs_btree_init_buf(mp, bp, cfg->btree_ops, 0, 0, cfg->owner);
 	error = xfs_bwrite(bp);
 	xfs_buf_relse(bp);
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 46551021755..9a2cb5662d1 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -681,7 +681,6 @@ xfs_bmap_extents_to_btree(
 	/*
 	 * Fill in the child block.
 	 */
-	abp->b_ops = &xfs_bmbt_buf_ops;
 	ablock = XFS_BUF_TO_BLOCK(abp);
 	xfs_btree_init_buf(mp, abp, &xfs_bmbt_ops, 0, 0, ip->i_ino);
 
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 218e96d7976..6705a6d83f3 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1275,6 +1275,7 @@ xfs_btree_init_buf(
 {
 	__xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
+	bp->b_ops = ops->buf_ops;
 }
 
 void

