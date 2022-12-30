Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F62C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiLaBg5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236112AbiLaBgv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:36:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29C813DD9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:36:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61B1561CC6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF02FC433D2;
        Sat, 31 Dec 2022 01:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450609;
        bh=w5FepllMsYyMVdX2Qhl9JKHnsoFPlznlpcw2GAhXf9M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=d7DZrJQj8D997Q8vxK/BVs9nkkQA0tBpPfWv7BLN+r4eSPTEGIroY2UxUcD5Hr/VV
         XSFKcCgwcGO43pSA0ik7qrRxSkKQNEWCiI/2xCmiBpyr7tjiQvD8dhkkHYXOMrHLA/
         5TBkiANms52pXNgTfnmQmtra5zUHXhh//w1SubCQmV7o8xLd/Yx85IM+aF4mKgvyuX
         9vL9A0aHLpEIg6u3jyoXyWdYZ8NF9+prmDLpODmbWMwgDKNWlRYX/scHbAVpLBlAyo
         z/+SaBFjQGOuDg8owqw6dSSnuCRQ/abE/5lF4Xe4xNtjea8z86oD3ptceIgNLUNaln
         rTyOfoafYve1g==
Subject: [PATCH 5/5] xfs: remove xfs_trans_set_rmap_flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:12 -0800
Message-ID: <167243869232.714954.18068558095853437844.stgit@magnolia>
In-Reply-To: <167243869156.714954.12346064053546135919.stgit@magnolia>
References: <167243869156.714954.12346064053546135919.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove this single-use helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rmap_item.c |   79 +++++++++++++++++++++---------------------------
 1 file changed, 34 insertions(+), 45 deletions(-)


diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 38915e92bf2b..a84f7e0e91a3 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -242,49 +242,6 @@ xfs_trans_get_rud(
 	return rudp;
 }
 
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
 /*
  * Finish an rmap update and log it to the RUD. Note that the transaction is
  * marked dirty regardless of whether the rmap update succeeds or fails to
@@ -355,8 +312,40 @@ xfs_rmap_update_log_item(
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

