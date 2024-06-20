Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1D31422D5
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924883; cv=none; b=SD1829mJrD2lCUh4difLyjjqvCnR/ZLlyAYjsr1CojLdHtpH4GDTkBlL0v10Zzhl/FJVzUkgGaVCRBQZaYBeyMHlyABUoe/fBcQM++KjX08qSVdp7oEuoEgFTbLLt3O+v25ECxS8hlT+p6icwI5ml0J8uhHn+DIER9NVAUmFPkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924883; c=relaxed/simple;
	bh=BFxE5DkikwfL8tmmJdV0AmavRkX8tlf3DuypLeGx9sM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sEep/O8AeH2YF+5cuCdJihjNTYWtEfxJ/dyVPPZKVz4BAncdLEpTjTH06HBnfGxKVHs822ydOwt8EkEyiWffcLjcNXTMQrY3e+FwjZgTZiOLj3G7ShB/2HSKXXdtz+QPC+zSbuLg0b2Coyx2rHi+Q+9/eVWHxN81OOrSgpAZbG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G+Zg2pWL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G+Zg2pWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45511C2BD10;
	Thu, 20 Jun 2024 23:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924883;
	bh=BFxE5DkikwfL8tmmJdV0AmavRkX8tlf3DuypLeGx9sM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G+Zg2pWLbc4ix9P8V0BIUSNF1x+ShWsUOUNSPXqZCE2EtDDhEezGY6K4vsFXJY/ap
	 v69tjogfWDmBHZjRnIMsxQBz7sNWaTwuGC2cMbLI93gxRrXLDvbMRQ5/SRGngV7Gru
	 8Cfu6+L4A+78wOD1vjdAk7tv6Zvn4FWcnUZGOo/UYvZhyizXF7SMN887ZUk0ufx105
	 bsxBNUY473QFJsR04sGzhyAP1AXUWQSIiqH16HQaabwzOTg4Lt2MgDrsxD+LKUIta7
	 AtXiYgRoR3umjm5h4dFYVO94b8eo0zmbLA/TXovaWsjphKGYG6SZVbkA//hgDxZ+6X
	 NIh91H11j/MRw==
Date: Thu, 20 Jun 2024 16:08:02 -0700
Subject: [PATCH 4/9] xfs: remove xfs_trans_set_rmap_flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892419301.3184396.4725607583390300491.stgit@frogsfrogsfrogs>
In-Reply-To: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
References: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
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
index 2e732aded58e0..7e998a7eb0422 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -226,49 +226,6 @@ static const struct xfs_item_ops xfs_rud_item_ops = {
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
@@ -307,8 +264,40 @@ xfs_rmap_update_log_item(
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

