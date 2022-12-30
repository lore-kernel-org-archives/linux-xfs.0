Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDF8C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236280AbiLaCxm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiLaCxm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:53:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726A819039
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:53:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EF60B81E52
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76C6C433EF;
        Sat, 31 Dec 2022 02:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455218;
        bh=N9QzaOejGIRXgvjwhseYkP2RWBq6ZckwMaT6jjPOvew=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=a+rhZVRPRrkqM8/1LHpe6ZSog46ZyXYno+YBd17tQ/WY0hp52F6mhw+4KeGfTlzbX
         fmIRcq+sZ4pUvce9eIatMKDDx1XhyZ5mXa7AEb8D3cYjvDj6XcBvKBt6n3pfolaz6I
         2gP/GoXok3PxZIOnQ6hwd83BIbnZX/OWp+zs1CAI28up7xsxDeqpYzgWgoLYGtnc76
         Q844rlxUHlAiHM48cqWbXbDD56hz3DsB8VhGQEPHUYFy51c4V1RApeIPdMDEg8XzAJ
         CIGTtpbpSxNFrPxsVblyKOhsQ3yFoGyDu0fiTjDNzkMXFIqBD1WDlQFc6slIICqqHD
         u9OC5+s3jcocg==
Subject: [PATCH 2/4] mkfs: use libxfs_alloc_file_space for rtinit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:04 -0800
Message-ID: <167243880425.733953.339860757617150024.stgit@magnolia>
In-Reply-To: <167243880399.733953.2483387870694006201.stgit@magnolia>
References: <167243880399.733953.2483387870694006201.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Since xfs_bmapi_write can now zero newly allocated blocks, use it to
initialize the realtime inodes instead of open coding this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/proto.c |   92 +++++++++++-----------------------------------------------
 1 file changed, 17 insertions(+), 75 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index b11b7fa5f95..c62918a2f7d 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -916,43 +916,14 @@ static void
 rtbitmap_init(
 	struct xfs_mount	*mp)
 {
-	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
-	struct xfs_trans	*tp;
-	struct xfs_bmbt_irec	*ep;
-	xfs_fileoff_t		bno;
-	uint			blocks;
-	int			i;
-	int			nmap;
 	int			error;
 
-	blocks = mp->m_sb.sb_rbmblocks +
-			XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
-	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
+	error = -libxfs_alloc_file_space(mp->m_rbmip, 0,
+			mp->m_sb.sb_rbmblocks << mp->m_sb.sb_blocklog,
+			XFS_BMAPI_ZERO);
 	if (error)
-		res_failed(error);
-
-	libxfs_trans_ijoin(tp, mp->m_rbmip, 0);
-	bno = 0;
-	while (bno < mp->m_sb.sb_rbmblocks) {
-		nmap = XFS_BMAP_MAX_NMAP;
-		error = -libxfs_bmapi_write(tp, mp->m_rbmip, bno,
-				(xfs_extlen_t)(mp->m_sb.sb_rbmblocks - bno),
-				0, mp->m_sb.sb_rbmblocks, map, &nmap);
-		if (error)
-			fail(_("Allocation of the realtime bitmap failed"),
-				error);
-
-		for (i = 0, ep = map; i < nmap; i++, ep++) {
-			libxfs_device_zero(mp->m_ddev_targp,
-				XFS_FSB_TO_DADDR(mp, ep->br_startblock),
-				XFS_FSB_TO_BB(mp, ep->br_blockcount));
-			bno += ep->br_blockcount;
-		}
-	}
-
-	error = -libxfs_trans_commit(tp);
-	if (error)
-		fail(_("Block allocation of the realtime bitmap inode failed"),
+		fail(
+	_("Block allocation of the realtime bitmap inode failed"),
 				error);
 
 	if (xfs_has_rtgroups(mp)) {
@@ -968,44 +939,13 @@ static void
 rtsummary_init(
 	struct xfs_mount	*mp)
 {
-	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
-	struct xfs_trans	*tp;
-	struct xfs_bmbt_irec	*ep;
-	xfs_fileoff_t		bno;
-	xfs_extlen_t		nsumblocks;
-	uint			blocks;
-	int			i;
-	int			nmap;
 	int			error;
 
-	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
-	blocks = nsumblocks + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
-	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
+	error = -libxfs_alloc_file_space(mp->m_rsumip, 0, mp->m_rsumsize,
+			XFS_BMAPI_ZERO);
 	if (error)
-		res_failed(error);
-	libxfs_trans_ijoin(tp, mp->m_rsumip, 0);
-
-	bno = 0;
-	while (bno < nsumblocks) {
-		nmap = XFS_BMAP_MAX_NMAP;
-		error = -libxfs_bmapi_write(tp, mp->m_rsumip, bno,
-				(xfs_extlen_t)(nsumblocks - bno),
-				0, nsumblocks, map, &nmap);
-		if (error)
-			fail(_("Allocation of the realtime summary failed"),
-				error);
-
-		for (i = 0, ep = map; i < nmap; i++, ep++) {
-			libxfs_device_zero(mp->m_ddev_targp,
-				XFS_FSB_TO_DADDR(mp, ep->br_startblock),
-				XFS_FSB_TO_BB(mp, ep->br_blockcount));
-			bno += ep->br_blockcount;
-		}
-	}
-
-	error = -libxfs_trans_commit(tp);
-	if (error)
-		fail(_("Block allocation of the realtime summary inode failed"),
+		fail(
+	_("Block allocation of the realtime summary inode failed"),
 				error);
 
 	if (xfs_has_rtgroups(mp)) {
@@ -1111,12 +1051,14 @@ rtinit(
 			rtrmapbt_create(rtg);
 	}
 
-	rtbitmap_init(mp);
-	rtsummary_init(mp);
-	if (xfs_has_rtgroups(mp))
-		rtfreesp_init_groups(mp);
-	else
-		rtfreesp_init(mp);
+	if (mp->m_sb.sb_rbmblocks) {
+		rtbitmap_init(mp);
+		rtsummary_init(mp);
+		if (xfs_has_rtgroups(mp))
+			rtfreesp_init_groups(mp);
+		else
+			rtfreesp_init(mp);
+	}
 }
 
 static long

