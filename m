Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F27C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbjEZBML (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233448AbjEZBMK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:12:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62899125
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:12:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F37DC64C1F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5830FC433EF;
        Fri, 26 May 2023 01:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063528;
        bh=yAO/YuUjyWvvhqNKKQDjsdNreMmg7VMzwRHz+zu3ms4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=kz9GDxi5roEToEijp2MyGQ4sor7FBoSt8ZmGKkKNYk4/wfHP7vbJSZxdvhf3RtFRK
         yuRj/EWy0l56qyUquuehQ2uXa4spWriu5RXbIjRM5tEDW3WFzChgLcPfVZNxEzehjb
         ago7uoOEky50S+0RDwBWrOvFuGZ4QnoTGEsyQO96Npv4kZJPgVz1I0NB/T7HM9KSI2
         BCBh2p+z7s5UdzV+6SaL6zqqu1q+AnWoDMoYFdn2uC4yuEuY+TzOw6MSSGiJ544rYL
         JptQ1xLiEfZ/4L3xYlrGMHYm4IWKOARE0VhGJJR6aYqdWz5Hrw+xPRmgsRg2mn3ua1
         fbXyZGLfGJ18w==
Date:   Thu, 25 May 2023 18:12:07 -0700
Subject: [PATCH 3/3] xfs: remove xfs_trans_set_bmap_flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506063533.3733930.12257382591923869936.stgit@frogsfrogsfrogs>
In-Reply-To: <168506063487.3733930.3765429104183077810.stgit@frogsfrogsfrogs>
References: <168506063487.3733930.3765429104183077810.stgit@frogsfrogsfrogs>
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
 fs/xfs/xfs_bmap_item.c |   38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 7551c3ec4ea5..803127a16904 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -281,29 +281,6 @@ xfs_bmap_update_diff_items(
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
@@ -329,8 +306,19 @@ xfs_bmap_update_log_item(
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

