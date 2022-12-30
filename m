Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F167C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbiLaBXH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236061AbiLaBXH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:23:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37B69FE3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:23:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8AEFB81A16
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690BEC433D2;
        Sat, 31 Dec 2022 01:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449783;
        bh=kr7erTnBsH1ukWNV2xea0OoJbRirWOBbdx11r7e/IuQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QqkajvZi6rgkdD6OOHsVmNCBXgWLXCdKqOdtcmGdCwWT7XZa7WXsx1d6iILg0tetV
         iU/qZ+xMe1uoI/6srckUfxR/Qp31D+bHLPQulF/aRpmfSO7Tt6MxvDHC3nwdmhHTOz
         XvosZXApXuqT7mVc77ArjdUgekanI+sF740GM+q4aB1XHxfV5q7q117aVFz9EQrMmu
         FhRRvIGPCEHgmFD6dnu6GEBls4K8m1k7/6JeKa1nUGRpDuoB7K6lOEu1XgN4HW7LMN
         8gTykOfcR69u13uyzMS1wj0sunK4LGkvNBAoi/AqPXmFShBT0VvonfVYmnBHHIBFx0
         DeJl7GM/iQHrw==
Subject: [PATCH 1/7] xfs: create a helper to convert rtextents to rtblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:40 -0800
Message-ID: <167243866089.711673.18244427216606300004.stgit@magnolia>
In-Reply-To: <167243866067.711673.17279545989126573423.stgit@magnolia>
References: <167243866067.711673.17279545989126573423.stgit@magnolia>
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
---
 fs/xfs/libxfs/xfs_rtbitmap.h |   16 ++++++++++++++++
 fs/xfs/scrub/rtbitmap.c      |    4 ++--
 fs/xfs/scrub/rtsummary.c     |    4 ++--
 fs/xfs/xfs_bmap_util.c       |    9 +++++----
 fs/xfs/xfs_fsmap.c           |    4 ++--
 fs/xfs/xfs_super.c           |    3 ++-
 6 files changed, 29 insertions(+), 11 deletions(-)


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
index 29c5af5a289f..af9eee6ed5ce 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -62,8 +62,8 @@ xchk_rtbitmap_rec(
 	xfs_rtxnum_t		startblock;
 	xfs_filblks_t		blockcount;
 
-	startblock = rec->ar_startext * mp->m_sb.sb_rextsize;
-	blockcount = rec->ar_extcount * mp->m_sb.sb_rextsize;
+	startblock = xfs_rtx_to_rtb(mp, rec->ar_startext);
+	blockcount = xfs_rtx_to_rtb(mp, rec->ar_extcount);
 
 	if (!xfs_verify_rtbext(mp, startblock, blockcount))
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 91c39564298c..7885ddd2d733 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -138,8 +138,8 @@ xchk_rtsum_record_free(
 	lenlog = XFS_RTBLOCKLOG(rec->ar_extcount);
 	offs = XFS_SUMOFFS(mp, lenlog, rbmoff);
 
-	rtbno = rec->ar_startext * mp->m_sb.sb_rextsize;
-	rtlen = rec->ar_extcount * mp->m_sb.sb_rextsize;
+	rtbno = xfs_rtx_to_rtb(mp, rec->ar_startext);
+	rtlen = xfs_rtx_to_rtb(mp, rec->ar_extcount);
 
 	if (!xfs_verify_rtbext(mp, rtbno, rtlen)) {
 		xchk_ino_xref_set_corrupt(sc, mp->m_rbmip->i_ino);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 018c3bcc225e..e0d3c60c7d9c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -29,6 +29,7 @@
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
 #include "xfs_swapext.h"
+#include "xfs_rtbitmap.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -126,7 +127,7 @@ xfs_bmap_rtalloc(
 	 * XFS_BMBT_MAX_EXTLEN), we don't hear about that number, and can't
 	 * adjust the starting point to match it.
 	 */
-	if (ralen * mp->m_sb.sb_rextsize >= XFS_MAX_BMBT_EXTLEN)
+	if (xfs_rtxlen_to_extlen(mp, ralen) >= XFS_MAX_BMBT_EXTLEN)
 		ralen = XFS_MAX_BMBT_EXTLEN / mp->m_sb.sb_rextsize;
 
 	/*
@@ -148,7 +149,7 @@ xfs_bmap_rtalloc(
 		error = xfs_rtpick_extent(mp, ap->tp, ralen, &rtx);
 		if (error)
 			return error;
-		ap->blkno = rtx * mp->m_sb.sb_rextsize;
+		ap->blkno = xfs_rtx_to_rtb(mp, rtx);
 	} else {
 		ap->blkno = 0;
 	}
@@ -171,8 +172,8 @@ xfs_bmap_rtalloc(
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
index 0027e186bd52..3738dc936d85 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -459,9 +459,9 @@ xfs_getfsmap_rtdev_rtbitmap_helper(
 	struct xfs_rmap_irec		irec;
 	xfs_daddr_t			rec_daddr;
 
-	irec.rm_startblock = rec->ar_startext * mp->m_sb.sb_rextsize;
+	irec.rm_startblock = xfs_rtx_to_rtb(mp, rec->ar_startext);
 	rec_daddr = XFS_FSB_TO_BB(mp, irec.rm_startblock);
-	irec.rm_blockcount = rec->ar_extcount * mp->m_sb.sb_rextsize;
+	irec.rm_blockcount = xfs_rtx_to_rtb(mp, rec->ar_extcount);
 	irec.rm_owner = XFS_RMAP_OWN_NULL;	/* "free" */
 	irec.rm_offset = 0;
 	irec.rm_flags = 0;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9eff9ee106c4..19a22f9225e4 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -43,6 +43,7 @@
 #include "xfs_iunlink_item.h"
 #include "scrub/rcbag_btree.h"
 #include "xfs_swapext_item.h"
+#include "xfs_rtbitmap.h"
 
 #include <linux/magic.h>
 #include <linux/fs_context.h>
@@ -863,7 +864,7 @@ xfs_fs_statfs(
 
 		statp->f_blocks = sbp->sb_rblocks;
 		freertx = percpu_counter_sum_positive(&mp->m_frextents);
-		statp->f_bavail = statp->f_bfree = freertx * sbp->sb_rextsize;
+		statp->f_bavail = statp->f_bfree = xfs_rtx_to_rtb(mp, freertx);
 	}
 
 	return 0;

