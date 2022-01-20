Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D907FC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357734AbiATAUE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:20:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57996 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233299AbiATAUD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:20:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92BA561514
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8021C004E1;
        Thu, 20 Jan 2022 00:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638003;
        bh=hPKIA8sy5+U7xHk6OK388JWVpWLk2Lv+JPcnMNNBOXw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KuK3Cre4f/XK40VDkSNJiQPQeGWvLdIXJLpoLtcFZ1yBQFUnkGI27Hf0glZUGT13S
         rNBHxD3JHCROme5Lg37a5ey0svkuQejg09+je42vusVWaeTefhZ6H8lFB987Ek6eCC
         jE19cmjal/vcnkmJNNySdg25byH4b4yaN336FnEKg8agwzMHcWs2YWUXxlkLQTVJUh
         5SEPXZHPks0DTI44JgjjYCzd05/GnMt8+rf3MzMir6M+B9t3DIw1qvwdhITy+MWYyc
         oLNVxDp5usRTonvEh2M61SMZMiYvVy0cANBTj8UY1Ohwo6Q4s2VnajaT0NDaCGNUZB
         1PaLGBZUlQRxw==
Subject: [PATCH 29/45] xfs: convert xfs_fs_geometry to use mount feature
 checks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:20:02 -0800
Message-ID: <164263800259.860211.4053587252148975871.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 03288b19093b9bcff72f0d5f90c578daf053f759

Reporting filesystem features to userspace is currently superblock
based. Now we have a general mount-based feature infrastructure,
switch to using the xfs_mount rather than the superblock directly.

This reduces the size of the function by over 300 bytes.

$ size -t fs/xfs/built-in.a
text    data     bss     dec     hex filename
before  1127855  311352     484 1439691  15f7cb (TOTALS)
after   1127535  311352     484 1439371  15f68b (TOTALS)

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/info.c       |    2 +-
 libxfs/xfs_sb.c |   46 ++++++++++++++++++++++++----------------------
 libxfs/xfs_sb.h |    2 +-
 mkfs/xfs_mkfs.c |    2 +-
 4 files changed, 27 insertions(+), 25 deletions(-)


diff --git a/db/info.c b/db/info.c
index fdee76ba..b69bae91 100644
--- a/db/info.c
+++ b/db/info.c
@@ -29,7 +29,7 @@ info_f(
 {
 	struct xfs_fsop_geom	geo;
 
-	libxfs_fs_geometry(&mp->m_sb, &geo, XFS_FS_GEOM_MAX_STRUCT_VER);
+	libxfs_fs_geometry(mp, &geo, XFS_FS_GEOM_MAX_STRUCT_VER);
 	xfs_report_geom(&geo, fsdevice, x.logname, x.rtname);
 	return 0;
 }
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index d2de96d1..bc226208 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1014,10 +1014,12 @@ xfs_sync_sb_buf(
 
 void
 xfs_fs_geometry(
-	struct xfs_sb		*sbp,
+	struct xfs_mount	*mp,
 	struct xfs_fsop_geom	*geo,
 	int			struct_version)
 {
+	struct xfs_sb		*sbp = &mp->m_sb;
+
 	memset(geo, 0, sizeof(struct xfs_fsop_geom));
 
 	geo->blocksize = sbp->sb_blocksize;
@@ -1048,51 +1050,51 @@ xfs_fs_geometry(
 	geo->flags = XFS_FSOP_GEOM_FLAGS_NLINK |
 		     XFS_FSOP_GEOM_FLAGS_DIRV2 |
 		     XFS_FSOP_GEOM_FLAGS_EXTFLG;
-	if (xfs_sb_version_hasattr(sbp))
+	if (xfs_has_attr(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATTR;
-	if (xfs_sb_version_hasquota(sbp))
+	if (xfs_has_quota(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_QUOTA;
-	if (xfs_sb_version_hasalign(sbp))
+	if (xfs_has_align(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_IALIGN;
-	if (xfs_sb_version_hasdalign(sbp))
+	if (xfs_has_dalign(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_DALIGN;
-	if (xfs_sb_version_hassector(sbp))
-		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
-	if (xfs_sb_version_hasasciici(sbp))
+	if (xfs_has_asciici(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_DIRV2CI;
-	if (xfs_sb_version_haslazysbcount(sbp))
+	if (xfs_has_lazysbcount(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_LAZYSB;
-	if (xfs_sb_version_hasattr2(sbp))
+	if (xfs_has_attr2(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATTR2;
-	if (xfs_sb_version_hasprojid32(sbp))
+	if (xfs_has_projid32(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_PROJID32;
-	if (xfs_sb_version_hascrc(sbp))
+	if (xfs_has_crc(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_V5SB;
-	if (xfs_sb_version_hasftype(sbp))
+	if (xfs_has_ftype(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_FTYPE;
-	if (xfs_sb_version_hasfinobt(sbp))
+	if (xfs_has_finobt(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_FINOBT;
-	if (xfs_sb_version_hassparseinodes(sbp))
+	if (xfs_has_sparseinodes(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_SPINODES;
-	if (xfs_sb_version_hasrmapbt(sbp))
+	if (xfs_has_rmapbt(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_RMAPBT;
-	if (xfs_sb_version_hasreflink(sbp))
+	if (xfs_has_reflink(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_REFLINK;
-	if (xfs_sb_version_hasbigtime(sbp))
+	if (xfs_has_bigtime(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
-	if (xfs_sb_version_hasinobtcounts(sbp))
+	if (xfs_has_inobtcounts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
-	if (xfs_sb_version_hassector(sbp))
+	if (xfs_has_sector(mp)) {
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
 		geo->logsectsize = sbp->sb_logsectsize;
-	else
+	} else {
 		geo->logsectsize = BBSIZE;
+	}
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
 	if (struct_version < 4)
 		return;
 
-	if (xfs_sb_version_haslogv2(sbp))
+	if (xfs_has_logv2(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_LOGV2;
 
 	geo->logsunit = sbp->sb_logsunit;
diff --git a/libxfs/xfs_sb.h b/libxfs/xfs_sb.h
index d2dd99cb..8902f4bf 100644
--- a/libxfs/xfs_sb.h
+++ b/libxfs/xfs_sb.h
@@ -25,7 +25,7 @@ extern uint64_t	xfs_sb_version_to_features(struct xfs_sb *sbp);
 extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);
 
 #define XFS_FS_GEOM_MAX_STRUCT_VER	(4)
-extern void	xfs_fs_geometry(struct xfs_sb *sbp, struct xfs_fsop_geom *geo,
+extern void	xfs_fs_geometry(struct xfs_mount *mp, struct xfs_fsop_geom *geo,
 				int struct_version);
 extern int	xfs_sb_read_secondary(struct xfs_mount *mp,
 				struct xfs_trans *tp, xfs_agnumber_t agno,
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2340b7b1..63895f28 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4038,7 +4038,7 @@ main(
 	if (!quiet || dry_run) {
 		struct xfs_fsop_geom	geo;
 
-		libxfs_fs_geometry(sbp, &geo, XFS_FS_GEOM_MAX_STRUCT_VER);
+		libxfs_fs_geometry(mp, &geo, XFS_FS_GEOM_MAX_STRUCT_VER);
 		xfs_report_geom(&geo, dfile, logfile, rtfile);
 		if (dry_run)
 			exit(0);

