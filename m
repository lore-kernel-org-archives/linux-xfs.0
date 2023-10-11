Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C495ACDB475
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbjJKSEL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbjJKSEK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:04:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A3A9D
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:04:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F084C433C8;
        Wed, 11 Oct 2023 18:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047449;
        bh=u++vAxQy6sL25UXIJqPecprLo2IIf0kBCmQCKc58RLM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=KrPcYUNhP8SDZ3rQ7mJBC30Lpi8mC/euLW4BnR2deYQkXZ/32LW6vHoDjpGPSJdC8
         v4gl4QeJ7GDeeg/0h2wsIAAFGEtT4u7GnBZEK17voLTP+z+6vZ58krElEsNlCONT5W
         hQTXPFjvW1V5Xi/EDZAuezfB81W1dpTUkaAVwxAKEaw+jdEbfWRhQ95yRt+AApOvrM
         RX/8dONYCcLzVhiPwLgR8J+Csw77RPBXGAq6NNq/m4dwm+R/PJ10+5osvZwFPZf+jC
         lTFKb/fzkv3hVkGr4dVJu8COd0W1nIRT/oiJY6nWoK0y6rncwP0EPWrkW1ahXX+Zrs
         nRaUhyKJ5hLuw==
Date:   Wed, 11 Oct 2023 11:04:08 -0700
Subject: [PATCH 6/7] xfs: rename xfs_verify_rtext to xfs_verify_rtbext
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704720818.1773388.15441286922872459723.stgit@frogsfrogsfrogs>
In-Reply-To: <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs>
References: <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs>
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
index 6aa7fd05ee30b..fd083a3c554e0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6257,7 +6257,7 @@ xfs_bmap_validate_extent_raw(
 		return __this_address;
 
 	if (rtfile && whichfork == XFS_DATA_FORK) {
-		if (!xfs_verify_rtext(mp, irec->br_startblock,
+		if (!xfs_verify_rtbext(mp, irec->br_startblock,
 					  irec->br_blockcount))
 			return __this_address;
 	} else {
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index dfcc1889c2033..b1fa715e5f398 100644
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
index a2fb880433b56..532447a357321 100644
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
index 256ee322cb4af..21fd685415137 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -432,7 +432,7 @@ xchk_bmap_iextent(
 
 	/* Make sure the extent points to a valid place. */
 	if (info->is_rt &&
-	    !xfs_verify_rtext(mp, irec->br_startblock, irec->br_blockcount))
+	    !xfs_verify_rtbext(mp, irec->br_startblock, irec->br_blockcount))
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 	if (!info->is_rt &&
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index c32249a1969aa..0d4bed1e6b8ce 100644
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
index ccf07a63da70e..b96a464ca3e85 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -149,7 +149,7 @@ xchk_rtsum_record_free(
 	rtbno = rec->ar_startext * mp->m_sb.sb_rextsize;
 	rtlen = rec->ar_extcount * mp->m_sb.sb_rextsize;
 
-	if (!xfs_verify_rtext(mp, rtbno, rtlen)) {
+	if (!xfs_verify_rtbext(mp, rtbno, rtlen)) {
 		xchk_ino_xref_set_corrupt(sc, mp->m_rbmip->i_ino);
 		return -EFSCORRUPTED;
 	}
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index e1f54cf8f0442..5dbe4a79e36c5 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -474,7 +474,7 @@ xfs_bui_validate(
 		return false;
 
 	if (map->me_flags & XFS_BMAP_EXTENT_REALTIME)
-		return xfs_verify_rtext(mp, map->me_startblock, map->me_len);
+		return xfs_verify_rtbext(mp, map->me_startblock, map->me_len);
 
 	return xfs_verify_fsbext(mp, map->me_startblock, map->me_len);
 }

