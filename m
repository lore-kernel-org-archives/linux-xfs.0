Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DD7BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I+1L850h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65AFC433C8;
	Sun, 31 Dec 2023 20:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053942;
	bh=vflZdBIWxkLCMC9TzxAIX3TWHsPRxLG25gYIxgDmcWE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=I+1L850hdSF1mYOHe8E7Xg0nJf4K6NMLqyC716TJyuCBo305olVfXNHtipIgegtWZ
	 GsrUbVbB8o+QHl7Sfpf3pSI0wof7pbBpTu6fXbfBFkw+SutpXZHt1N541iEFWL2Nvf
	 f71LNu2S+e4gtBg+IOpwGTPwDZQ/lZlwPfmVtt/amlTERpRJNmJIEGfpaf/iO2YBAx
	 2cqZNihu0qorpqNGp9fJZRRRW7LzZydju4qjk4f6ZuGvaUnmmI8eHhoq0LPAZNS7xu
	 BlOleKzKLCPYnj7+yly0a7X7KYIGvx2XNyb6vJKVHrX9v1uGGBT069uDP0A/fKtVTD
	 b4AK81bf6YUcQ==
Date: Sun, 31 Dec 2023 12:19:02 -0800
Subject: [PATCH 8/9] xfs: set btree block buffer ops in _init_buf
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404830643.1749286.1497935316877337415.stgit@frogsfrogsfrogs>
In-Reply-To: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
References: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_bmap.c  |    1 -
 fs/xfs/libxfs/xfs_btree.c |    1 +
 fs/xfs/scrub/xfbtree.c    |    1 -
 3 files changed, 1 insertion(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 17a2194ac0486..ae98f7e41ca7f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -687,7 +687,6 @@ xfs_bmap_extents_to_btree(
 	/*
 	 * Fill in the child block.
 	 */
-	abp->b_ops = &xfs_bmbt_buf_ops;
 	ablock = XFS_BUF_TO_BLOCK(abp);
 	xfs_btree_init_buf(mp, abp, &xfs_bmbt_ops, 0, 0, ip->i_ino);
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 285dc609daa8d..5af19610d8919 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1278,6 +1278,7 @@ xfs_btree_init_buf(
 {
 	__xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
+	bp->b_ops = ops->buf_ops;
 }
 
 void
diff --git a/fs/xfs/scrub/xfbtree.c b/fs/xfs/scrub/xfbtree.c
index f37f35c206354..9d2e01614d1ff 100644
--- a/fs/xfs/scrub/xfbtree.c
+++ b/fs/xfs/scrub/xfbtree.c
@@ -445,7 +445,6 @@ xfbtree_init_leaf_block(
 
 	trace_xfbtree_create_root_buf(xfbt, bp);
 
-	bp->b_ops = cfg->btree_ops->buf_ops;
 	xfs_btree_init_buf(mp, bp, cfg->btree_ops, 0, 0, cfg->owner);
 	error = xfs_bwrite(bp);
 	xfs_buf_relse(bp);

