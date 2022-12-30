Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A65C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbiLaCKi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCKh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:10:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0017D15FC9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:10:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90DFD61D02
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04B3C433EF;
        Sat, 31 Dec 2022 02:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452636;
        bh=dhDKuXb5mU+nRlIRErLHJ1ggI05k0tY0Fu1fuBmb+Bw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MKlT1VcUan2raASDGbt7iR6PhzG1lLFCcG3ElI//rTA4kjb/2Hk/DsgWAdaE+WoC3
         3oM3C0fzul+en5UEP+E5HqVdBXoXhewTbMDvyx6J7XymCr2p5w4Xd9xC2r8JIHegQm
         VUwdokbKzzGB6ewloRQBFaufUGwy2YVsi1ri258FPY0djS208KIXibWi0bdTpIgP6+
         vyZc5sE6mgmyWwEkUzyHV74gMLW7QB1mh7GNKVh/9CJjd5N5EHS1Fulcs/S3H1JYj9
         AcXEVfIpJi9RBtlXASPWbE4+B/9FN8kjjoqroaPtA2huGV7/8T4fX/Jg6I0ZDfNvNY
         Dwse1Fbfw8WCw==
Subject: [PATCH 03/46] mkfs: clean up the rtinit() function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:19 -0800
Message-ID: <167243875982.725900.18291235948732233308.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Clean up some of the warts in this function, like the inconsistent use
of @i for @error, missing comments, and make this more visually pleasing
by adding some whitespace between major sections.  Some things are left
untouched for the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/proto.c |   81 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 41 insertions(+), 40 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index b60def70652..3121c35baa1 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -678,29 +678,27 @@ parse_proto(
  */
 static void
 rtinit(
-	xfs_mount_t	*mp)
+	struct xfs_mount	*mp)
 {
-	xfs_fileoff_t	bno;
-	xfs_fileoff_t	ebno;
-	xfs_bmbt_irec_t	*ep;
-	int		error;
-	int		i;
-	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
-	xfs_extlen_t	nsumblocks;
-	uint		blocks;
-	int		nmap;
-	xfs_inode_t	*rbmip;
-	xfs_inode_t	*rsumip;
-	xfs_trans_t	*tp;
-	struct cred	creds;
-	struct fsxattr	fsxattrs;
+	struct cred		creds;
+	struct fsxattr		fsxattrs;
+	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
+	struct xfs_inode	*rbmip;
+	struct xfs_inode	*rsumip;
+	struct xfs_trans	*tp;
+	struct xfs_bmbt_irec	*ep;
+	xfs_fileoff_t		bno;
+	xfs_fileoff_t		ebno;
+	xfs_extlen_t		nsumblocks;
+	uint			blocks;
+	int			i;
+	int			nmap;
+	int			error;
 
-	/*
-	 * First, allocate the inodes.
-	 */
-	i = -libxfs_trans_alloc_rollable(mp, MKFS_BLOCKRES_INODE, &tp);
-	if (i)
-		res_failed(i);
+	/* Create the realtime bitmap inode. */
+	error = -libxfs_trans_alloc_rollable(mp, MKFS_BLOCKRES_INODE, &tp);
+	if (error)
+		res_failed(error);
 
 	memset(&creds, 0, sizeof(creds));
 	memset(&fsxattrs, 0, sizeof(fsxattrs));
@@ -721,6 +719,8 @@ rtinit(
 	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
 	libxfs_log_sb(tp);
 	mp->m_rbmip = rbmip;
+
+	/* Create the realtime summary inode. */
 	error = creatproto(&tp, NULL, S_IFREG, 1, 0, &creds, &fsxattrs,
 			&rsumip);
 	if (error) {
@@ -735,14 +735,13 @@ rtinit(
 		fail(_("Completion of the realtime summary inode failed"),
 				error);
 	mp->m_rsumip = rsumip;
-	/*
-	 * Next, give the bitmap file some zero-filled blocks.
-	 */
+
+	/* Zero the realtime bitmap. */
 	blocks = mp->m_sb.sb_rbmblocks +
 			XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
-	i = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
-	if (i)
-		res_failed(i);
+	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
+	if (error)
+		res_failed(error);
 
 	libxfs_trans_ijoin(tp, rbmip, 0);
 	bno = 0;
@@ -751,10 +750,10 @@ rtinit(
 		error = -libxfs_bmapi_write(tp, rbmip, bno,
 				(xfs_extlen_t)(mp->m_sb.sb_rbmblocks - bno),
 				0, mp->m_sb.sb_rbmblocks, map, &nmap);
-		if (error) {
+		if (error)
 			fail(_("Allocation of the realtime bitmap failed"),
 				error);
-		}
+
 		for (i = 0, ep = map; i < nmap; i++, ep++) {
 			libxfs_device_zero(mp->m_ddev_targp,
 				XFS_FSB_TO_DADDR(mp, ep->br_startblock),
@@ -768,25 +767,24 @@ rtinit(
 		fail(_("Block allocation of the realtime bitmap inode failed"),
 				error);
 
-	/*
-	 * Give the summary file some zero-filled blocks.
-	 */
+	/* Zero the summary file. */
 	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
 	blocks = nsumblocks + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
-	i = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
-	if (i)
-		res_failed(i);
+	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
+	if (error)
+		res_failed(error);
 	libxfs_trans_ijoin(tp, rsumip, 0);
+
 	bno = 0;
 	while (bno < nsumblocks) {
 		nmap = XFS_BMAP_MAX_NMAP;
 		error = -libxfs_bmapi_write(tp, rsumip, bno,
 				(xfs_extlen_t)(nsumblocks - bno),
 				0, nsumblocks, map, &nmap);
-		if (error) {
+		if (error)
 			fail(_("Allocation of the realtime summary failed"),
 				error);
-		}
+
 		for (i = 0, ep = map; i < nmap; i++, ep++) {
 			libxfs_device_zero(mp->m_ddev_targp,
 				XFS_FSB_TO_DADDR(mp, ep->br_startblock),
@@ -794,6 +792,7 @@ rtinit(
 			bno += ep->br_blockcount;
 		}
 	}
+
 	error = -libxfs_trans_commit(tp);
 	if (error)
 		fail(_("Block allocation of the realtime summary inode failed"),
@@ -804,13 +803,15 @@ rtinit(
 	 * Do one transaction per bitmap block.
 	 */
 	for (bno = 0; bno < mp->m_sb.sb_rextents; bno = ebno) {
-		i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
 				0, 0, 0, &tp);
-		if (i)
-			res_failed(i);
+		if (error)
+			res_failed(error);
+
 		libxfs_trans_ijoin(tp, rbmip, 0);
 		ebno = XFS_RTMIN(mp->m_sb.sb_rextents,
 			bno + NBBY * mp->m_sb.sb_blocksize);
+
 		error = -libxfs_rtfree_extent(tp, bno, (xfs_extlen_t)(ebno-bno));
 		if (error) {
 			fail(_("Error initializing the realtime space"),

