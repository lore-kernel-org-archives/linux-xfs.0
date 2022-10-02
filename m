Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F44C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiJBSbX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiJBSbW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:31:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1087934990
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:31:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0A16B80D89
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784A2C433C1;
        Sun,  2 Oct 2022 18:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735478;
        bh=4LCPPZ81h7dJvRYf3g9vrepbbmuzaS6Ppe7ve6ixvVk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cg9IhOdMEtkKGSCQfPlevkkiB8OID6UqIxj5WfBjYEyewtmVp5oOoFFrrj252Prs2
         NavOPAwB5incxZMvW+QHLRl2MWIJffMLqup+8hAWKzd04pdlr3ro9gToQCwSeEaEDp
         qfYJ+/IopsrXe4iqQFkzB3uioCk7Cw4G/vpbmZdob8FnslwS0dr1yLJM7YlRolpAki
         grI8qpsqy65RlmLfBy1BtGCnWHgHrtjPNOvDahjtatHMBxwa+VlwUrFNfxDrKqyndV
         WBiLBQaQJf5qd1X4qeUf5P1kdpnUV1UCXbBAvKS9lJb8pyOM9KCytHGy0Y2skk8g4t
         BIvyxFuJxezqw==
Subject: [PATCH 3/6] xfs: block map scrub should handle incore delalloc
 reservations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:09 -0700
Message-ID: <166473480915.1083927.736458976932286147.stgit@magnolia>
In-Reply-To: <166473480864.1083927.11062319917293302327.stgit@magnolia>
References: <166473480864.1083927.11062319917293302327.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Enhance the block map scrubber to check delayed allocation reservations.
Though there are no physical space allocations to check, we do need to
make sure that the range of file offsets being mapped are correct, and
to bump the lastoff cursor so that key order checking works correctly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c |   55 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index c78323c87bfe..6986aef80002 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -371,14 +371,13 @@ xchk_bmap_dirattr_extent(
 }
 
 /* Scrub a single extent record. */
-STATIC int
+STATIC void
 xchk_bmap_iextent(
 	struct xfs_inode	*ip,
 	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec)
 {
 	struct xfs_mount	*mp = info->sc->mp;
-	int			error = 0;
 
 	/*
 	 * Check for out-of-order extents.  This record could have come
@@ -399,14 +398,6 @@ xchk_bmap_iextent(
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
-	/*
-	 * Check for delalloc extents.  We never iterate the ones in the
-	 * in-core extent scan, and we should never see these in the bmbt.
-	 */
-	if (isnullstartblock(irec->br_startblock))
-		xchk_fblock_set_corrupt(info->sc, info->whichfork,
-				irec->br_startoff);
-
 	/* Make sure the extent points to a valid place. */
 	if (irec->br_blockcount > XFS_MAX_BMBT_EXTLEN)
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
@@ -427,15 +418,12 @@ xchk_bmap_iextent(
 				irec->br_startoff);
 
 	if (info->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		return 0;
+		return;
 
 	if (info->is_rt)
 		xchk_bmap_rt_iextent_xref(ip, info, irec);
 	else
 		xchk_bmap_iextent_xref(ip, info, irec);
-
-	info->lastoff = irec->br_startoff + irec->br_blockcount;
-	return error;
 }
 
 /* Scrub a bmbt record. */
@@ -683,6 +671,33 @@ xchk_bmap_check_rmaps(
 	return 0;
 }
 
+/* Scrub a delalloc reservation from the incore extent map tree. */
+STATIC void
+xchk_bmap_iextent_delalloc(
+	struct xfs_inode	*ip,
+	struct xchk_bmap_info	*info,
+	struct xfs_bmbt_irec	*irec)
+{
+	struct xfs_mount	*mp = info->sc->mp;
+
+	/*
+	 * Check for out-of-order extents.  This record could have come
+	 * from the incore list, for which there is no ordering check.
+	 */
+	if (irec->br_startoff < info->lastoff)
+		xchk_fblock_set_corrupt(info->sc, info->whichfork,
+				irec->br_startoff);
+
+	if (!xfs_verify_fileext(mp, irec->br_startoff, irec->br_blockcount))
+		xchk_fblock_set_corrupt(info->sc, info->whichfork,
+				irec->br_startoff);
+
+	/* Make sure the extent points to a valid place. */
+	if (irec->br_blockcount > XFS_MAX_BMBT_EXTLEN)
+		xchk_fblock_set_corrupt(info->sc, info->whichfork,
+				irec->br_startoff);
+}
+
 /*
  * Scrub an inode fork's block mappings.
  *
@@ -767,16 +782,18 @@ xchk_bmap(
 		if (xchk_should_terminate(sc, &error) ||
 		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 			goto out;
-		if (isnullstartblock(irec.br_startblock))
-			continue;
+
 		if (irec.br_startoff >= endoff) {
 			xchk_fblock_set_corrupt(sc, whichfork,
 					irec.br_startoff);
 			goto out;
 		}
-		error = xchk_bmap_iextent(ip, &info, &irec);
-		if (error)
-			goto out;
+
+		if (isnullstartblock(irec.br_startblock))
+			xchk_bmap_iextent_delalloc(ip, &info, &irec);
+		else
+			xchk_bmap_iextent(ip, &info, &irec);
+		info.lastoff = irec.br_startoff + irec.br_blockcount;
 	}
 
 	error = xchk_bmap_check_rmaps(sc, whichfork);

