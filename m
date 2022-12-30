Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CECDC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236172AbiLaCLL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:11:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCLJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:11:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE3CF78
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:11:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEDD861D06
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180D2C433D2;
        Sat, 31 Dec 2022 02:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452667;
        bh=ga/plt6siSV0+UtTF9eFL1/rKwrL+BrdZMWkl43inkE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=r//YCnKtRTpcvr5IXMPTI1LeFPK9s7c+jlKAklMy1I3cAtIGabeK96aqGZVSFReQo
         mVY1bVM20Q3EkcAG1sUpcpueG6//EtLZpZ4SkYP1HgCcF0qxg0J7/bhmlgXEiVuPk2
         jrzjLZIAyx7aTLXY0f5c+C1ObEPgVFvmfd7N4wumuVpOgXEJjmEAO+P8JaWoZzbXnD
         mhztXHFRgHWd+6U4XRxgGj5naMtfFyYXa2yvXo90yx/i6hyBe4luqipWTYW131Ery6
         7elFQY8fS1+caoEXbd8KJ7K0CVUgD+d20Xr4MKaoVksa4pMrir6ZyyVRk4NLo0FxYb
         FfqMM7N4TUuPA==
Subject: [PATCH 05/46] mkfs: break up the rest of the rtinit() function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:20 -0800
Message-ID: <167243876008.725900.6268187767537280671.stgit@magnolia>
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

Break up this really long function into smaller functions that each do
one thing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/proto.c |  106 +++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 79 insertions(+), 27 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 354c9fa8a02..f145a7ba753 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -673,28 +673,16 @@ parse_proto(
 	parseproto(mp, NULL, fsx, pp, NULL);
 }
 
-/*
- * Allocate the realtime bitmap and summary inodes, and fill in data if any.
- */
+/* Create the realtime bitmap inode. */
 static void
-rtinit(
+rtbitmap_create(
 	struct xfs_mount	*mp)
 {
 	struct xfs_imeta_update	upd;
-	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
+	struct xfs_trans	*tp;
 	struct xfs_inode	*rbmip;
-	struct xfs_inode	*rsumip;
-	struct xfs_trans	*tp;
-	struct xfs_bmbt_irec	*ep;
-	xfs_fileoff_t		bno;
-	xfs_fileoff_t		ebno;
-	xfs_extlen_t		nsumblocks;
-	uint			blocks;
-	int			i;
-	int			nmap;
 	int			error;
 
-	/* Create the realtime bitmap inode. */
 	error = -libxfs_imeta_start_update(mp, &XFS_IMETA_RTBITMAP, &upd);
 	if (error)
 		res_failed(error);
@@ -719,8 +707,18 @@ rtinit(
 				error);
 	mp->m_rbmip = rbmip;
 	libxfs_imeta_end_update(mp, &upd, 0);
+}
+
+/* Create the realtime summary inode. */
+static void
+rtsummary_create(
+	struct xfs_mount	*mp)
+{
+	struct xfs_imeta_update	upd;
+	struct xfs_trans	*tp;
+	struct xfs_inode	*rsumip;
+	int			error;
 
-	/* Create the realtime summary inode. */
 	error = -libxfs_imeta_start_update(mp, &XFS_IMETA_RTSUMMARY, &upd);
 	if (error)
 		res_failed(error);
@@ -743,19 +741,33 @@ rtinit(
 				error);
 	mp->m_rsumip = rsumip;
 	libxfs_imeta_end_update(mp, &upd, 0);
+}
+
+/* Zero the realtime bitmap. */
+static void
+rtbitmap_init(
+	struct xfs_mount	*mp)
+{
+	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
+	struct xfs_trans	*tp;
+	struct xfs_bmbt_irec	*ep;
+	xfs_fileoff_t		bno;
+	uint			blocks;
+	int			i;
+	int			nmap;
+	int			error;
 
-	/* Zero the realtime bitmap. */
 	blocks = mp->m_sb.sb_rbmblocks +
 			XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
 	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
 	if (error)
 		res_failed(error);
 
-	libxfs_trans_ijoin(tp, rbmip, 0);
+	libxfs_trans_ijoin(tp, mp->m_rbmip, 0);
 	bno = 0;
 	while (bno < mp->m_sb.sb_rbmblocks) {
 		nmap = XFS_BMAP_MAX_NMAP;
-		error = -libxfs_bmapi_write(tp, rbmip, bno,
+		error = -libxfs_bmapi_write(tp, mp->m_rbmip, bno,
 				(xfs_extlen_t)(mp->m_sb.sb_rbmblocks - bno),
 				0, mp->m_sb.sb_rbmblocks, map, &nmap);
 		if (error)
@@ -774,19 +786,34 @@ rtinit(
 	if (error)
 		fail(_("Block allocation of the realtime bitmap inode failed"),
 				error);
+}
+
+/* Zero the realtime summary file. */
+static void
+rtsummary_init(
+	struct xfs_mount	*mp)
+{
+	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
+	struct xfs_trans	*tp;
+	struct xfs_bmbt_irec	*ep;
+	xfs_fileoff_t		bno;
+	xfs_extlen_t		nsumblocks;
+	uint			blocks;
+	int			i;
+	int			nmap;
+	int			error;
 
-	/* Zero the summary file. */
 	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
 	blocks = nsumblocks + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
 	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
 	if (error)
 		res_failed(error);
-	libxfs_trans_ijoin(tp, rsumip, 0);
+	libxfs_trans_ijoin(tp, mp->m_rsumip, 0);
 
 	bno = 0;
 	while (bno < nsumblocks) {
 		nmap = XFS_BMAP_MAX_NMAP;
-		error = -libxfs_bmapi_write(tp, rsumip, bno,
+		error = -libxfs_bmapi_write(tp, mp->m_rsumip, bno,
 				(xfs_extlen_t)(nsumblocks - bno),
 				0, nsumblocks, map, &nmap);
 		if (error)
@@ -805,18 +832,28 @@ rtinit(
 	if (error)
 		fail(_("Block allocation of the realtime summary inode failed"),
 				error);
+}
+
+/*
+ * Free the whole realtime area using transactions.
+ * Do one transaction per bitmap block.
+ */
+static void
+rtfreesp_init(
+	struct xfs_mount	*mp)
+{
+	struct xfs_trans	*tp;
+	xfs_fileoff_t		bno;
+	xfs_fileoff_t		ebno;
+	int			error;
 
-	/*
-	 * Free the whole area using transactions.
-	 * Do one transaction per bitmap block.
-	 */
 	for (bno = 0; bno < mp->m_sb.sb_rextents; bno = ebno) {
 		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
 				0, 0, 0, &tp);
 		if (error)
 			res_failed(error);
 
-		libxfs_trans_ijoin(tp, rbmip, 0);
+		libxfs_trans_ijoin(tp, mp->m_rbmip, 0);
 		ebno = XFS_RTMIN(mp->m_sb.sb_rextents,
 			bno + NBBY * mp->m_sb.sb_blocksize);
 
@@ -832,6 +869,21 @@ rtinit(
 	}
 }
 
+/*
+ * Allocate the realtime bitmap and summary inodes, and fill in data if any.
+ */
+static void
+rtinit(
+	struct xfs_mount	*mp)
+{
+	rtbitmap_create(mp);
+	rtsummary_create(mp);
+
+	rtbitmap_init(mp);
+	rtsummary_init(mp);
+	rtfreesp_init(mp);
+}
+
 static long
 filesize(
 	int		fd)

