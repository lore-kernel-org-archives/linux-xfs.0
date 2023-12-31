Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDE9BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UP8ytuRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842FFC433C8;
	Sun, 31 Dec 2023 21:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058229;
	bh=g3yt/g2jKxvOOBbJWEIe4uJrGekVPt3gIQnnrWxt0m4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UP8ytuRIHPTMrJ0Wp9D7WcnZ/aZt87f/8mpxmjNJmR9H5IRNgeiY7whfXV+B+XiUS
	 dNUCCBlLMpmDc0QjFp4GswJ3y+WNK6hsuxKWlrwLTKSzGroqFP0Ko5xY2qhyeNYgRh
	 YDD2E/IJ483a3gCJwAvD13Bg03cK6yeWjT0uL/LX6p4BlRnc2dpbhcBxVo3m7NUpBj
	 +zKoObspUXoNDjq2XQrs89LedY6hdTaTXFg4dt/YeEK8oO/gvR68ukzvltOfnjnzFV
	 Mt6vwR/TdnHNt4Lat8pczPiqFCAdEXe16xDpyKwu64y5ESEMQZ1nAJ7W3+244SHHC0
	 DyfbqhurLlTzw==
Date: Sun, 31 Dec 2023 13:30:29 -0800
Subject: [PATCH 05/10] xfs: remove xfs_trans_set_rmap_flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404849315.1764703.8444810479623957001.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
References: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
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
 fs/xfs/xfs_rmap_item.c |   79 +++++++++++++++++++++---------------------------
 1 file changed, 34 insertions(+), 45 deletions(-)


diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 183544ac74c98..3e67fe2133263 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -225,49 +225,6 @@ static const struct xfs_item_ops xfs_rud_item_ops = {
 	.iop_intent	= xfs_rud_item_intent,
 };
 
-/* Set the map extent flags for this reverse mapping. */
-static void
-xfs_trans_set_rmap_flags(
-	struct xfs_map_extent		*map,
-	enum xfs_rmap_intent_type	type,
-	int				whichfork,
-	xfs_exntst_t			state)
-{
-	map->me_flags = 0;
-	if (state == XFS_EXT_UNWRITTEN)
-		map->me_flags |= XFS_RMAP_EXTENT_UNWRITTEN;
-	if (whichfork == XFS_ATTR_FORK)
-		map->me_flags |= XFS_RMAP_EXTENT_ATTR_FORK;
-	switch (type) {
-	case XFS_RMAP_MAP:
-		map->me_flags |= XFS_RMAP_EXTENT_MAP;
-		break;
-	case XFS_RMAP_MAP_SHARED:
-		map->me_flags |= XFS_RMAP_EXTENT_MAP_SHARED;
-		break;
-	case XFS_RMAP_UNMAP:
-		map->me_flags |= XFS_RMAP_EXTENT_UNMAP;
-		break;
-	case XFS_RMAP_UNMAP_SHARED:
-		map->me_flags |= XFS_RMAP_EXTENT_UNMAP_SHARED;
-		break;
-	case XFS_RMAP_CONVERT:
-		map->me_flags |= XFS_RMAP_EXTENT_CONVERT;
-		break;
-	case XFS_RMAP_CONVERT_SHARED:
-		map->me_flags |= XFS_RMAP_EXTENT_CONVERT_SHARED;
-		break;
-	case XFS_RMAP_ALLOC:
-		map->me_flags |= XFS_RMAP_EXTENT_ALLOC;
-		break;
-	case XFS_RMAP_FREE:
-		map->me_flags |= XFS_RMAP_EXTENT_FREE;
-		break;
-	default:
-		ASSERT(0);
-	}
-}
-
 /* Sort rmap intents by AG. */
 static int
 xfs_rmap_update_diff_items(
@@ -306,8 +263,40 @@ xfs_rmap_update_log_item(
 	map->me_startblock = ri->ri_bmap.br_startblock;
 	map->me_startoff = ri->ri_bmap.br_startoff;
 	map->me_len = ri->ri_bmap.br_blockcount;
-	xfs_trans_set_rmap_flags(map, ri->ri_type, ri->ri_whichfork,
-			ri->ri_bmap.br_state);
+
+	map->me_flags = 0;
+	if (ri->ri_bmap.br_state == XFS_EXT_UNWRITTEN)
+		map->me_flags |= XFS_RMAP_EXTENT_UNWRITTEN;
+	if (ri->ri_whichfork == XFS_ATTR_FORK)
+		map->me_flags |= XFS_RMAP_EXTENT_ATTR_FORK;
+	switch (ri->ri_type) {
+	case XFS_RMAP_MAP:
+		map->me_flags |= XFS_RMAP_EXTENT_MAP;
+		break;
+	case XFS_RMAP_MAP_SHARED:
+		map->me_flags |= XFS_RMAP_EXTENT_MAP_SHARED;
+		break;
+	case XFS_RMAP_UNMAP:
+		map->me_flags |= XFS_RMAP_EXTENT_UNMAP;
+		break;
+	case XFS_RMAP_UNMAP_SHARED:
+		map->me_flags |= XFS_RMAP_EXTENT_UNMAP_SHARED;
+		break;
+	case XFS_RMAP_CONVERT:
+		map->me_flags |= XFS_RMAP_EXTENT_CONVERT;
+		break;
+	case XFS_RMAP_CONVERT_SHARED:
+		map->me_flags |= XFS_RMAP_EXTENT_CONVERT_SHARED;
+		break;
+	case XFS_RMAP_ALLOC:
+		map->me_flags |= XFS_RMAP_EXTENT_ALLOC;
+		break;
+	case XFS_RMAP_FREE:
+		map->me_flags |= XFS_RMAP_EXTENT_FREE;
+		break;
+	default:
+		ASSERT(0);
+	}
 }
 
 static struct xfs_log_item *

