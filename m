Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE4ACDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344145AbjJQPuR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343995AbjJQPuO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:50:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D42BB0
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:50:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA39C43140;
        Tue, 17 Oct 2023 15:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557812;
        bh=K8bi/uWXgVyGd8zFwG/nMcOaN+Gn4FBymmj+iYbycWU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Hb3yx1oBys81VZCxM1DQ+hB6UEspdDWat/RteZMt/s+QNbh6lJosvUJJS6546IYDO
         jDQhMGCmUKCDOyr0nVP0o/Znl8DW6f1zabtgy5TzZEptZ54utnlaaPdxmpONwpMzsR
         UC/ez0R6RcVh/v6DaNZnajDDFpFan38kkVq56Muj0S/WGs6L09C2iwD7O8TwXoPaiL
         73DdadFHuTiSGy7sI1VG5VbrCXr0bbUrnwHshAALGvHWkVvp560YMTRagas/7eKMso
         iRASeG9XWKrUe7i83qGqIS8cCwhG+NPNme0J2le65CCSIY1Kep//CYu4LmH3HqMCe6
         /Y0721vsynVjA==
Date:   Tue, 17 Oct 2023 08:50:12 -0700
Subject: [PATCH 1/7] xfs: create a helper to convert rtextents to rtblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, osandov@fb.com,
        linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755741741.3165781.14411234656942899333.stgit@frogsfrogsfrogs>
In-Reply-To: <169755741717.3165781.12142780069035126128.stgit@frogsfrogsfrogs>
References: <169755741717.3165781.12142780069035126128.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a helper to convert a realtime extent to a realtime block.  Later
on we'll change the helper to use bit shifts when possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.h |   16 ++++++++++++++++
 fs/xfs/scrub/rtbitmap.c      |    4 ++--
 fs/xfs/scrub/rtsummary.c     |    4 ++--
 fs/xfs/xfs_bmap_util.c       |    9 +++++----
 fs/xfs/xfs_fsmap.c           |    6 +++---
 fs/xfs/xfs_super.c           |    3 ++-
 6 files changed, 30 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 5e2afb7fea0e..099ea8902aaa 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -6,6 +6,22 @@
 #ifndef __XFS_RTBITMAP_H__
 #define	__XFS_RTBITMAP_H__
 
+static inline xfs_rtblock_t
+xfs_rtx_to_rtb(
+	struct xfs_mount	*mp,
+	xfs_rtxnum_t		rtx)
+{
+	return rtx * mp->m_sb.sb_rextsize;
+}
+
+static inline xfs_extlen_t
+xfs_rtxlen_to_extlen(
+	struct xfs_mount	*mp,
+	xfs_rtxlen_t		rtxlen)
+{
+	return rtxlen * mp->m_sb.sb_rextsize;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index bea5a2b75a06..584a2b8badac 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -50,8 +50,8 @@ xchk_rtbitmap_rec(
 	xfs_rtblock_t		startblock;
 	xfs_filblks_t		blockcount;
 
-	startblock = rec->ar_startext * mp->m_sb.sb_rextsize;
-	blockcount = rec->ar_extcount * mp->m_sb.sb_rextsize;
+	startblock = xfs_rtx_to_rtb(mp, rec->ar_startext);
+	blockcount = xfs_rtx_to_rtb(mp, rec->ar_extcount);
 
 	if (!xfs_verify_rtbext(mp, startblock, blockcount))
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index d998f0c378a4..d363286e8b72 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -134,8 +134,8 @@ xchk_rtsum_record_free(
 	lenlog = XFS_RTBLOCKLOG(rec->ar_extcount);
 	offs = XFS_SUMOFFS(mp, lenlog, rbmoff);
 
-	rtbno = rec->ar_startext * mp->m_sb.sb_rextsize;
-	rtlen = rec->ar_extcount * mp->m_sb.sb_rextsize;
+	rtbno = xfs_rtx_to_rtb(mp, rec->ar_startext);
+	rtlen = xfs_rtx_to_rtb(mp, rec->ar_extcount);
 
 	if (!xfs_verify_rtbext(mp, rtbno, rtlen)) {
 		xchk_ino_xref_set_corrupt(sc, mp->m_rbmip->i_ino);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 557330281ae3..2d747084c199 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -28,6 +28,7 @@
 #include "xfs_icache.h"
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
+#include "xfs_rtbitmap.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -125,7 +126,7 @@ xfs_bmap_rtalloc(
 	 * XFS_BMBT_MAX_EXTLEN), we don't hear about that number, and can't
 	 * adjust the starting point to match it.
 	 */
-	if (ralen * mp->m_sb.sb_rextsize >= XFS_MAX_BMBT_EXTLEN)
+	if (xfs_rtxlen_to_extlen(mp, ralen) >= XFS_MAX_BMBT_EXTLEN)
 		ralen = XFS_MAX_BMBT_EXTLEN / mp->m_sb.sb_rextsize;
 
 	/*
@@ -147,7 +148,7 @@ xfs_bmap_rtalloc(
 		error = xfs_rtpick_extent(mp, ap->tp, ralen, &rtx);
 		if (error)
 			return error;
-		ap->blkno = rtx * mp->m_sb.sb_rextsize;
+		ap->blkno = xfs_rtx_to_rtb(mp, rtx);
 	} else {
 		ap->blkno = 0;
 	}
@@ -170,8 +171,8 @@ xfs_bmap_rtalloc(
 		return error;
 
 	if (rtx != NULLRTEXTNO) {
-		ap->blkno = rtx * mp->m_sb.sb_rextsize;
-		ap->length = ralen * mp->m_sb.sb_rextsize;
+		ap->blkno = xfs_rtx_to_rtb(mp, rtx);
+		ap->length = xfs_rtxlen_to_extlen(mp, ralen);
 		ap->ip->i_nblocks += ap->length;
 		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 		if (ap->wasdel)
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 8982c5d6cbd0..1a187bc9da3d 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -483,11 +483,11 @@ xfs_getfsmap_rtdev_rtbitmap_helper(
 	xfs_rtblock_t			rtbno;
 	xfs_daddr_t			rec_daddr, len_daddr;
 
-	rtbno = rec->ar_startext * mp->m_sb.sb_rextsize;
+	rtbno = xfs_rtx_to_rtb(mp, rec->ar_startext);
 	rec_daddr = XFS_FSB_TO_BB(mp, rtbno);
 	irec.rm_startblock = rtbno;
 
-	rtbno = rec->ar_extcount * mp->m_sb.sb_rextsize;
+	rtbno = xfs_rtx_to_rtb(mp, rec->ar_extcount);
 	len_daddr = XFS_FSB_TO_BB(mp, rtbno);
 	irec.rm_blockcount = rtbno;
 
@@ -514,7 +514,7 @@ xfs_getfsmap_rtdev_rtbitmap(
 	uint64_t			eofs;
 	int				error;
 
-	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rextents * mp->m_sb.sb_rextsize);
+	eofs = XFS_FSB_TO_BB(mp, xfs_rtx_to_rtb(mp, mp->m_sb.sb_rextents));
 	if (keys[0].fmr_physical >= eofs)
 		return 0;
 	start_rtb = XFS_BB_TO_FSBT(mp,
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 819a3568b28f..991a31089dc7 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -42,6 +42,7 @@
 #include "xfs_xattr.h"
 #include "xfs_iunlink_item.h"
 #include "xfs_dahash_test.h"
+#include "xfs_rtbitmap.h"
 #include "scrub/stats.h"
 
 #include <linux/magic.h>
@@ -890,7 +891,7 @@ xfs_fs_statfs(
 
 		statp->f_blocks = sbp->sb_rblocks;
 		freertx = percpu_counter_sum_positive(&mp->m_frextents);
-		statp->f_bavail = statp->f_bfree = freertx * sbp->sb_rextsize;
+		statp->f_bavail = statp->f_bfree = xfs_rtx_to_rtb(mp, freertx);
 	}
 
 	return 0;

