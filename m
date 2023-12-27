Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B7ECA46
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oLhCKtXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9770C433C7;
	Mon,  1 Jan 2024 00:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067361;
	bh=tjVaQsB6BH0nz1JKaxN6mWhri86sG6kFnmx8R4MTyq0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oLhCKtXE8fjkXyAkNe6Fvevtt6xoM/P3nMqTJpYDCOYxBFbR4v8xR2ooH6aKunDQS
	 zL3dRVYBgXgzk8BZdJEb3LRW6wqn82b1DbTfkG+4ONCbAsHqrF8YirB0DIJ6fe7gMh
	 U6kDJFQkMavaz+tKasZ1WWWN5aKyCc+ahUPuvK43Qu2CaEufyT96/QWufRuaB4/z68
	 4456oLT1C97MJUBOkCMVpGAHUxz9C14mUl9/FeRUJDyAkKNG+h2B8CwJHkxMVpnpyr
	 RstJky0ztsQ+pbmgHyRGjiYsn5ETbbkBzMEYD2j2+1y0XWsyqhtoxa2eHYeWZYrrAm
	 xnY2Ytl3OEfjg==
Date: Sun, 31 Dec 2023 16:02:41 +9900
Subject: [PATCH 06/14] xfs: move the zero records logic into
 xfs_bmap_broot_space_calc
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405013282.1812545.6411434942512618095.stgit@frogsfrogsfrogs>
In-Reply-To: <170405013189.1812545.1581948480545654103.stgit@frogsfrogsfrogs>
References: <170405013189.1812545.1581948480545654103.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_bmap_btree.h |    7 +++++++
 libxfs/xfs_inode_fork.c |    6 ++----
 2 files changed, 9 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_bmap_btree.h b/libxfs/xfs_bmap_btree.h
index 3fe9c4f7f1a..5a3bae94deb 100644
--- a/libxfs/xfs_bmap_btree.h
+++ b/libxfs/xfs_bmap_btree.h
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
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index edf6dff28b4..81f054cd212 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -500,10 +500,8 @@ xfs_iroot_realloc(
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

