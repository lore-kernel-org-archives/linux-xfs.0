Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F9AFC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiJBS2P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiJBS2O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:28:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B4C3BC61
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:28:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD8B3B80D7E
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6319FC433D6;
        Sun,  2 Oct 2022 18:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735288;
        bh=1uI4KpfoORsZLN9CNHZsnAZYG3bm/86mlOHDoyfXGio=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Fmwuyz5j6tjuvhz69sObmLyr49qJgkQwqQRSVaFeTkCRoRKyhaJJ6XEgq6kNTBnuR
         lPyr4i6tvyUuAsFpRlaxJaku3iS0g9a/i/Ofj+bMVpJKGA2h+iMth6ETOPsZHKUtHZ
         FjQJkzd+tA8QcgCKp2QZIF2kY/MWE1Q7oBod4oxwnDWyvj3N7ESNOAKYj3r5xxBNO+
         /+/pjlMv4OUioh2ek8DJ3Snhdsn+OXoGSUvRHqcdluiklCTP8VAtgM1NExj8OFCbVH
         PgSV5kZnpzcd7lAu0DppFpI8QdWvuB86cISYGI4zjQUqT+Eo0GD2Wh+JxaxpP/DM3s
         yqH2DXsbQDDPQ==
Subject: [PATCH 4/4] xfs: make AGFL repair function avoid crosslinked blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:19:49 -0700
Message-ID: <166473478907.1083155.14312237700092531574.stgit@magnolia>
In-Reply-To: <166473478844.1083155.9238102682926048449.stgit@magnolia>
References: <166473478844.1083155.9238102682926048449.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the AGFL repair function to check each block of the proposed AGFL
against the rmap btree.  If the rmapbt finds any mappings that are not
OWN_AG, strike that block from the list.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |   78 ++++++++++++++++++++++++++++++++++------
 1 file changed, 66 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 2e75ff9b5b2e..82ceb60ea5fc 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -442,12 +442,18 @@ xrep_agf(
 /* AGFL */
 
 struct xrep_agfl {
+	/* Bitmap of alleged AGFL blocks that we're not going to add. */
+	struct xbitmap		crossed;
+
 	/* Bitmap of other OWN_AG metadata blocks. */
 	struct xbitmap		agmetablocks;
 
 	/* Bitmap of free space. */
 	struct xbitmap		*freesp;
 
+	/* rmapbt cursor for finding crosslinked blocks */
+	struct xfs_btree_cur	*rmap_cur;
+
 	struct xfs_scrub	*sc;
 };
 
@@ -477,6 +483,41 @@ xrep_agfl_walk_rmap(
 	return xbitmap_set_btcur_path(&ra->agmetablocks, cur);
 }
 
+/* Strike out the blocks that are cross-linked according to the rmapbt. */
+STATIC int
+xrep_agfl_check_extent(
+	struct xrep_agfl	*ra,
+	uint64_t		start,
+	uint64_t		len)
+{
+	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(ra->sc->mp, start);
+	xfs_agblock_t		last_agbno = agbno + len - 1;
+	int			error;
+
+	ASSERT(XFS_FSB_TO_AGNO(ra->sc->mp, start) == ra->sc->sa.pag->pag_agno);
+
+	while (agbno <= last_agbno) {
+		bool		other_owners;
+
+		error = xfs_rmap_has_other_keys(ra->rmap_cur, agbno, 1,
+				&XFS_RMAP_OINFO_AG, &other_owners);
+		if (error)
+			return error;
+
+		if (other_owners) {
+			error = xbitmap_set(&ra->crossed, agbno, 1);
+			if (error)
+				return error;
+		}
+
+		if (xchk_should_terminate(ra->sc, &error))
+			return error;
+		agbno++;
+	}
+
+	return 0;
+}
+
 /*
  * Map out all the non-AGFL OWN_AG space in this AG so that we can deduce
  * which blocks belong to the AGFL.
@@ -496,44 +537,58 @@ xrep_agfl_collect_blocks(
 	struct xrep_agfl	ra;
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_btree_cur	*cur;
+	struct xbitmap_range	*br, *n;
 	int			error;
 
 	ra.sc = sc;
 	ra.freesp = agfl_extents;
 	xbitmap_init(&ra.agmetablocks);
+	xbitmap_init(&ra.crossed);
 
 	/* Find all space used by the free space btrees & rmapbt. */
 	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.pag);
 	error = xfs_rmap_query_all(cur, xrep_agfl_walk_rmap, &ra);
-	if (error)
-		goto err;
 	xfs_btree_del_cursor(cur, error);
+	if (error)
+		goto out_bmp;
 
 	/* Find all blocks currently being used by the bnobt. */
 	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp,
 			sc->sa.pag, XFS_BTNUM_BNO);
 	error = xbitmap_set_btblocks(&ra.agmetablocks, cur);
-	if (error)
-		goto err;
 	xfs_btree_del_cursor(cur, error);
+	if (error)
+		goto out_bmp;
 
 	/* Find all blocks currently being used by the cntbt. */
 	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp,
 			sc->sa.pag, XFS_BTNUM_CNT);
 	error = xbitmap_set_btblocks(&ra.agmetablocks, cur);
-	if (error)
-		goto err;
-
 	xfs_btree_del_cursor(cur, error);
+	if (error)
+		goto out_bmp;
 
 	/*
 	 * Drop the freesp meta blocks that are in use by btrees.
 	 * The remaining blocks /should/ be AGFL blocks.
 	 */
 	error = xbitmap_disunion(agfl_extents, &ra.agmetablocks);
-	xbitmap_destroy(&ra.agmetablocks);
 	if (error)
-		return error;
+		goto out_bmp;
+
+	/* Strike out the blocks that are cross-linked. */
+	ra.rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.pag);
+	for_each_xbitmap_extent(br, n, agfl_extents) {
+		error = xrep_agfl_check_extent(&ra, br->start, br->len);
+		if (error)
+			break;
+	}
+	xfs_btree_del_cursor(ra.rmap_cur, error);
+	if (error)
+		goto out_bmp;
+	error = xbitmap_disunion(agfl_extents, &ra.crossed);
+	if (error)
+		goto out_bmp;
 
 	/*
 	 * Calculate the new AGFL size.  If we found more blocks than fit in
@@ -541,11 +596,10 @@ xrep_agfl_collect_blocks(
 	 */
 	*flcount = min_t(uint64_t, xbitmap_hweight(agfl_extents),
 			 xfs_agfl_size(mp));
-	return 0;
 
-err:
+out_bmp:
+	xbitmap_destroy(&ra.crossed);
 	xbitmap_destroy(&ra.agmetablocks);
-	xfs_btree_del_cursor(cur, error);
 	return error;
 }
 

