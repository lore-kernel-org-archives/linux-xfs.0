Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB57BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="to5OUXK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB8AC433C7;
	Sun, 31 Dec 2023 21:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057822;
	bh=WFw9iyY4Qg3XiX2P7hVAlpvdwV/uwzs0r6Ks3CwzLxI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=to5OUXK2GxfSbnaYpG4bboKsjiyGalW16IE9NO8hA0Cx6wSdMeJDsH42AGK3bIUxS
	 6OGZ1UZ8pu1QbvnLXX/tM+p+HV6cbmtWzW37cqy6wqEazpVZ9cM7NUDVJ+FFlHAcVM
	 veUDqTgHMZhXMGM8+3k1C6CyySwsxMLzWQaeLsFR88P2Wsq5f24G+kPgF62IAsnOAJ
	 0EYwhnQ6neG8HqWvwRLM/iXfJZYyyDYBQpswa0ZxYe8aorb5Q7OKjO8aahXTXTwnMy
	 nrtnDGX3POGQ46LjEOTBUU82rdz0dxw2kZBtwULpDTr6V5n+K7i9dGYh9SpHZGthYe
	 xOPywB+3eymaw==
Date: Sun, 31 Dec 2023 13:23:41 -0800
Subject: [PATCH 06/14] xfs: move the zero records logic into
 xfs_bmap_broot_space_calc
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404847463.1763835.2749850954602093074.stgit@frogsfrogsfrogs>
In-Reply-To: <170404847334.1763835.8921217007526026461.stgit@frogsfrogsfrogs>
References: <170404847334.1763835.8921217007526026461.stgit@frogsfrogsfrogs>
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

The bmap btree cannot ever have zero records in an incore btree block.
If the number of records drops to zero, that means we're converting the
fork to extents format and are trying to remove the tree.  This logic
won't hold for the future realtime rmap btree, so move the logic into
the bmbt code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap_btree.h |    7 +++++++
 fs/xfs/libxfs/xfs_inode_fork.c |    6 ++----
 2 files changed, 9 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 3fe9c4f7f1a0b..5a3bae94debd4 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -162,6 +162,13 @@ xfs_bmap_broot_space_calc(
 	struct xfs_mount	*mp,
 	unsigned int		nrecs)
 {
+	/*
+	 * If the bmbt root block is empty, we should be converting the fork
+	 * to extents format.  Hence, the size is zero.
+	 */
+	if (nrecs == 0)
+		return 0;
+
 	return xfs_bmbt_block_len(mp) + \
 	       (nrecs * (sizeof(struct xfs_bmbt_key) + sizeof(xfs_bmbt_ptr_t)));
 }
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index c84def822dd18..fc23087dc2a87 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -502,10 +502,8 @@ xfs_iroot_realloc(
 	cur_max = xfs_bmbt_maxrecs(mp, old_size, 0);
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
-	if (new_max > 0)
-		new_size = xfs_bmap_broot_space_calc(mp, new_max);
-	else
-		new_size = 0;
+
+	new_size = xfs_bmap_broot_space_calc(mp, new_max);
 	if (new_size == 0) {
 		xfs_iroot_free(ip, whichfork);
 		return;

