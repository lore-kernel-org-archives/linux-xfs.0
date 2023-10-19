Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303F4CDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbjJSQYn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbjJSQYn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:24:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124F3115
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:24:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA04DC433C7;
        Thu, 19 Oct 2023 16:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732680;
        bh=K8bi/uWXgVyGd8zFwG/nMcOaN+Gn4FBymmj+iYbycWU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=e236RO5wItqI0ZKeGVrrDeZ73nUtRTrM4kYN6tbWyxnaGa8YnMle8wqXeAvAcLMS1
         Jb61SxWxmzZsov1ma1qslhTrJz+VRX8oGLVUVI/7Vgm9XOes8h7JaT/78xWzPjyBoS
         ggPxerwkMWKOLsAm0jbb/E4/hNqQOWuQvZPuc9rNRvduzEJODQI2s/2dVLF4x6UcuC
         mqqQepCyFphJ9p6IqayycWMfaqv80pxLQrSKXpVngusi58lFJ5fx3pgBjT0AE6vmiY
         s85O7nU/kU2MboRy2gdOV6x9nsOWwAivx1Zyq1pOL1GMJR4PVHUKE1ulTqyxZvFOOU
         CcrzDKWZrlCsg==
Date:   Thu, 19 Oct 2023 09:24:40 -0700
Subject: [PATCH 1/7] xfs: create a helper to convert rtextents to rtblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773210572.225313.10952725000772688229.stgit@frogsfrogsfrogs>
In-Reply-To: <169773210547.225313.10976140314084989407.stgit@frogsfrogsfrogs>
References: <169773210547.225313.10976140314084989407.stgit@frogsfrogsfrogs>
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

