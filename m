Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D998AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236169AbiLaClQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236173AbiLaClO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:41:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D72DF0C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:41:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F7EE61CBF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC259C433D2;
        Sat, 31 Dec 2022 02:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454472;
        bh=ckFPZwwSFTTIdeK98JTDtIW3LMR6YBuCnLS4yTXiAOc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RBExLAC71ac4W75LYsnJ1BNyUBodck51tDOpgp0mz3rrEZeK+EWoICJ/pHta7MXmr
         yZy1tsmH814t8KjtzaGp/Zdi5CcWU7MB9AvasQbdcI7EEegrW1TUaWohLVy8vzV10F
         vBbYhqRiY2u5ytKOlcdODLqUJrMdiED1VTIY3Y1VO415kM+j2hOcIzn6bRKWFn/RmC
         4C1TO+/mH04g6tGFYIPvbCDrsczoJewhlAvG1VBhiCpZS5C47HqT1/kSDAXdoK7pYc
         ujONb76XJIzab9U9dQ62vUv1FfhUkeqCEbxHa3hSeUJ9R0go/KBu+EWYsm62qPhMO7
         knDJ4AxkuLgCw==
Subject: [PATCH 43/45] mkfs: add headers to realtime bitmap blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:49 -0800
Message-ID: <167243878925.731133.17838280747426031006.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When the rtgroups feature is enabled, format rtbitmap blocks with the
appropriate block headers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/proto.c    |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/xfs_mkfs.c |    6 +++++-
 2 files changed, 56 insertions(+), 1 deletion(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 21fe2c7f972..daf0d419bce 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -813,6 +813,50 @@ rtsummary_create(
 	libxfs_imeta_end_update(mp, &upd, 0);
 }
 
+/* Initialize block headers of rt free space files. */
+static int
+init_rtblock_headers(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		nrblocks,
+	const struct xfs_buf_ops *ops,
+	uint32_t		magic)
+{
+	struct xfs_bmbt_irec	map;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_rtbuf_blkinfo *hdr;
+	xfs_fileoff_t		off = 0;
+	int			error;
+
+	while (off < nrblocks) {
+		struct xfs_buf	*bp;
+		xfs_daddr_t	daddr;
+		int		nimaps = 1;
+
+		error = -libxfs_bmapi_read(ip, off, 1, &map, &nimaps, 0);
+		if (error)
+			return error;
+
+		daddr = XFS_FSB_TO_DADDR(mp, map.br_startblock);
+		error = -libxfs_buf_get(mp->m_ddev_targp, daddr,
+				XFS_FSB_TO_BB(mp, map.br_blockcount), &bp);
+		if (error)
+			return error;
+
+		bp->b_ops = ops;
+		hdr = bp->b_addr;
+		hdr->rt_magic = cpu_to_be32(magic);
+		hdr->rt_owner = cpu_to_be64(ip->i_ino);
+		hdr->rt_blkno = cpu_to_be64(daddr);
+		platform_uuid_copy(&hdr->rt_uuid, &mp->m_sb.sb_meta_uuid);
+		libxfs_buf_mark_dirty(bp);
+		libxfs_buf_relse(bp);
+
+		off = map.br_startoff + map.br_blockcount;
+	}
+
+	return 0;
+}
+
 /* Zero the realtime bitmap. */
 static void
 rtbitmap_init(
@@ -856,6 +900,13 @@ rtbitmap_init(
 	if (error)
 		fail(_("Block allocation of the realtime bitmap inode failed"),
 				error);
+
+	if (xfs_has_rtgroups(mp)) {
+		error = init_rtblock_headers(mp->m_rbmip, mp->m_sb.sb_rbmblocks,
+				&xfs_rtbitmap_buf_ops, XFS_RTBITMAP_MAGIC);
+		if (error)
+			fail(_("Initialization of rtbitmap failed"), error);
+	}
 }
 
 /* Zero the realtime summary file. */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 0324daaad3a..826f9e53309 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -870,6 +870,7 @@ struct sb_feat_args {
 	bool	nodalign;
 	bool	nortalign;
 	bool	nrext64;
+	bool	rtgroups;		/* XFS_SB_FEAT_COMPAT_RTGROUPS */
 };
 
 struct cli_params {
@@ -3065,6 +3066,7 @@ validate_rtdev(
 	char			**devname)
 {
 	struct libxfs_xinit	*xi = cli->xi;
+	unsigned int		rbmblocksize = cfg->blocksize;
 
 	*devname = NULL;
 
@@ -3112,8 +3114,10 @@ reported by the device (%u).\n"),
 	}
 
 	cfg->rtextents = cfg->rtblocks / cfg->rtextblocks;
+	if (cfg->sb_feat.rtgroups)
+		rbmblocksize -= sizeof(struct xfs_rtbuf_blkinfo);
 	cfg->rtbmblocks = (xfs_extlen_t)howmany(cfg->rtextents,
-						NBBY * cfg->blocksize);
+						NBBY * rbmblocksize);
 }
 
 static bool

