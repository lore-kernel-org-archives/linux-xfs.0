Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88901C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbiL3Xrv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbiL3Xru (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:47:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE1B64FA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:47:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9EAE61B98
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181FDC433EF;
        Fri, 30 Dec 2022 23:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444069;
        bh=HKzfYdfqvSjBrWjsMo2jUPokMEIN3GDd75eyDeXHfv4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gi5J/z+Od0fJh4qp87rNaPV6o4+AbO53xZKo3m/xYzhnvLLnKsH6kgE2bjagANjIt
         p2gy3LWhnkcNsd3TEhw7AF3q8tGMvqvItzsVTsfOZDsLdJ7nIDH8tJDtcUwD//fh2v
         WY38KT2QidoAEVqoI1ak+4mo0m6DXtKQMKk37INiMWO8g5jnu8p1puJuzArax+JWX+
         HLSAqLPgOnp3X03Gc4/WeceJZNmZzz6bLcTtf7Axg4tWspomKIHCEAPR+qu0V72vbz
         Yjzi8h/C77lGJri8BxDfG/r3G/3T5cPWcvLXEqeKN9HV/xMzz4dddxkblS4/7Npbaj
         JBqyJX/7RT5Wg==
Subject: [PATCH 3/3] xfs: remove xfs_trans_set_bmap_flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:41 -0800
Message-ID: <167243842167.698982.2026883373634453822.stgit@magnolia>
In-Reply-To: <167243842121.698982.2011083519163197266.stgit@magnolia>
References: <167243842121.698982.2011083519163197266.stgit@magnolia>
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
index e13184afebaf..b4ecba7c7663 100644
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

