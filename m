Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CDFBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f8gI7egE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D520FC433C8;
	Sun, 31 Dec 2023 20:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054067;
	bh=TRl2/nWiAH9R7ZbHdO1gYavReFBpD1VrNnGkbrLItMo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=f8gI7egEgL6snzXnaCEqgaXcf7vbQPRoWtKP+R6+K1LQDqlckf3o4YNfa7pT2kYuI
	 fex7GA17Kknx6wdhgfaFaJoY4rv07NModOCKxqVfy+a21ydFI1GFs4XU9L46FUcF0x
	 Kv4ARySLxyy15iOufhvZfjvEqNKXnij6JWzvWWm80THhKxbxVBASirtLQh5mxWrqPs
	 YlpoKENyEc1TZNCLaDhRXxEIttu41m7FvboTtR9guSvdjkge7P8X+LuI8j4JOYM9d5
	 zIse+xQqzcSaBV6r2dEtf7vLXYWgLpgIsleOcX70uX7ql8c+JTB1tqUHlmbutsbo94
	 w1Drx0EgLGLhg==
Date: Sun, 31 Dec 2023 12:21:07 -0800
Subject: [PATCH 3/7] xfs: remove xfs_trans_set_bmap_flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404831473.1749708.3949699027505473459.stgit@frogsfrogsfrogs>
In-Reply-To: <170404831410.1749708.14664484779809794342.stgit@frogsfrogsfrogs>
References: <170404831410.1749708.14664484779809794342.stgit@frogsfrogsfrogs>
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

Remove this single-use helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_item.c |   38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 52fb8a148b7dc..6faa9b9da95a3 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -236,29 +236,6 @@ xfs_bmap_update_diff_items(
 	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
 }
 
-/* Set the map extent flags for this mapping. */
-static void
-xfs_trans_set_bmap_flags(
-	struct xfs_map_extent		*map,
-	enum xfs_bmap_intent_type	type,
-	int				whichfork,
-	xfs_exntst_t			state)
-{
-	map->me_flags = 0;
-	switch (type) {
-	case XFS_BMAP_MAP:
-	case XFS_BMAP_UNMAP:
-		map->me_flags = type;
-		break;
-	default:
-		ASSERT(0);
-	}
-	if (state == XFS_EXT_UNWRITTEN)
-		map->me_flags |= XFS_BMAP_EXTENT_UNWRITTEN;
-	if (whichfork == XFS_ATTR_FORK)
-		map->me_flags |= XFS_BMAP_EXTENT_ATTR_FORK;
-}
-
 /* Log bmap updates in the intent item. */
 STATIC void
 xfs_bmap_update_log_item(
@@ -281,8 +258,19 @@ xfs_bmap_update_log_item(
 	map->me_startblock = bi->bi_bmap.br_startblock;
 	map->me_startoff = bi->bi_bmap.br_startoff;
 	map->me_len = bi->bi_bmap.br_blockcount;
-	xfs_trans_set_bmap_flags(map, bi->bi_type, bi->bi_whichfork,
-			bi->bi_bmap.br_state);
+
+	switch (bi->bi_type) {
+	case XFS_BMAP_MAP:
+	case XFS_BMAP_UNMAP:
+		map->me_flags = bi->bi_type;
+		break;
+	default:
+		ASSERT(0);
+	}
+	if (bi->bi_bmap.br_state == XFS_EXT_UNWRITTEN)
+		map->me_flags |= XFS_BMAP_EXTENT_UNWRITTEN;
+	if (bi->bi_whichfork == XFS_ATTR_FORK)
+		map->me_flags |= XFS_BMAP_EXTENT_ATTR_FORK;
 }
 
 static struct xfs_log_item *

