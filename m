Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23B4CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbiLaBWf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236061AbiLaBWd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:22:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EBF26ED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:22:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C484B61C3A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C1AC433D2;
        Sat, 31 Dec 2022 01:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449752;
        bh=T97IjKRnoIUspVe4NKDvyPxnEZ7zgzTC99X9ofPNluA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tqlXn28YH/3/A+btkJ9hwYfTrgOraofNbBgYva+4IUeFOyJLEDyYnwXeTkmW4NGCI
         NWO+dD2cLdBV8YWKdoRouD0lLdhY6M6PrjzqwvZQCyUok4wRRmCyK3TVeOzqnwIApy
         6tVaf72LZbI8BebmEwEd8BzggwpeWpAO3p5xnhXs5wT9p5YcrT9W6RTgeKnaxz/9en
         WVJZe9x+2dA0/FrKeREEdS3Pl6HJz8JoLium6Pw1ejESvs5o2ptzZlUDlBA/27tVcG
         Kpg6cPHB4MGSe1lNrCPlEmBx3V4e1CjU9k8HcR86ge0MhyQYwrsVlWy3qgECr2HfZH
         bPp/Qhhd7xAnw==
Subject: [PATCH 10/11] xfs: rename xfs_verify_rtext to xfs_verify_rtbext
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:37 -0800
Message-ID: <167243865758.709511.10207651963643385126.stgit@magnolia>
In-Reply-To: <167243865605.709511.15650588946095003543.stgit@magnolia>
References: <167243865605.709511.15650588946095003543.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This helper function validates that a range of *blocks* in the
realtime section is completely contained within the realtime section.
It does /not/ validate ranges of *rtextents*.  Rename the function to
avoid suggesting that it does, and change the type of the @len parameter
since xfs_rtblock_t is a position unit, not a length unit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c  |    2 +-
 fs/xfs/libxfs/xfs_types.c |    4 ++--
 fs/xfs/libxfs/xfs_types.h |    4 ++--
 fs/xfs/scrub/bmap.c       |    2 +-
 fs/xfs/scrub/rtbitmap.c   |    4 ++--
 fs/xfs/scrub/rtsummary.c  |    2 +-
 fs/xfs/xfs_bmap_item.c    |    2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6adc7e90e59d..7f7f0d435b33 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6292,7 +6292,7 @@ xfs_bmap_validate_extent_raw(
 		return __this_address;
 
 	if (rtfile && whichfork == XFS_DATA_FORK) {
-		if (!xfs_verify_rtext(mp, irec->br_startblock,
+		if (!xfs_verify_rtbext(mp, irec->br_startblock,
 					  irec->br_blockcount))
 			return __this_address;
 	} else {
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index dfcc1889c203..b1fa715e5f39 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -147,10 +147,10 @@ xfs_verify_rtbno(
 
 /* Verify that a realtime device extent is fully contained inside the volume. */
 bool
-xfs_verify_rtext(
+xfs_verify_rtbext(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno,
-	xfs_rtblock_t		len)
+	xfs_filblks_t		len)
 {
 	if (rtbno + len <= rtbno)
 		return false;
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index a2fb880433b5..532447a35732 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -240,8 +240,8 @@ bool xfs_verify_ino(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_verify_dir_ino(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
-bool xfs_verify_rtext(struct xfs_mount *mp, xfs_rtblock_t rtbno,
-		xfs_rtblock_t len);
+bool xfs_verify_rtbext(struct xfs_mount *mp, xfs_rtblock_t rtbno,
+		xfs_filblks_t len);
 bool xfs_verify_icount(struct xfs_mount *mp, unsigned long long icount);
 bool xfs_verify_dablk(struct xfs_mount *mp, xfs_fileoff_t off);
 void xfs_icount_range(struct xfs_mount *mp, unsigned long long *min,
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 47d6bae9d6da..b5b081d23ca2 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -469,7 +469,7 @@ xchk_bmap_iextent(
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 	if (info->is_rt &&
-	    !xfs_verify_rtext(mp, irec->br_startblock, irec->br_blockcount))
+	    !xfs_verify_rtbext(mp, irec->br_startblock, irec->br_blockcount))
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 	if (!info->is_rt &&
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 6f8becb557bd..051abef66bc6 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -60,12 +60,12 @@ xchk_rtbitmap_rec(
 {
 	struct xfs_scrub	*sc = priv;
 	xfs_rtblock_t		startblock;
-	xfs_rtblock_t		blockcount;
+	xfs_filblks_t		blockcount;
 
 	startblock = rec->ar_startext * mp->m_sb.sb_rextsize;
 	blockcount = rec->ar_extcount * mp->m_sb.sb_rextsize;
 
-	if (!xfs_verify_rtext(mp, startblock, blockcount))
+	if (!xfs_verify_rtbext(mp, startblock, blockcount))
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 	return 0;
 }
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index f4a2456e01d0..c9e5a3bbdfdc 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -141,7 +141,7 @@ xchk_rtsum_record_free(
 	rtbno = rec->ar_startext * mp->m_sb.sb_rextsize;
 	rtlen = rec->ar_extcount * mp->m_sb.sb_rextsize;
 
-	if (!xfs_verify_rtext(mp, rtbno, rtlen)) {
+	if (!xfs_verify_rtbext(mp, rtbno, rtlen)) {
 		xchk_ino_xref_set_corrupt(sc, mp->m_rbmip->i_ino);
 		return -EFSCORRUPTED;
 	}
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 5561c0e1136b..bf52d30d7d1c 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -476,7 +476,7 @@ xfs_bui_validate(
 		return false;
 
 	if (map->me_flags & XFS_BMAP_EXTENT_REALTIME)
-		return xfs_verify_rtext(mp, map->me_startblock, map->me_len);
+		return xfs_verify_rtbext(mp, map->me_startblock, map->me_len);
 
 	return xfs_verify_fsbext(mp, map->me_startblock, map->me_len);
 }

