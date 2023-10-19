Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C49CDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbjJSQZP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbjJSQZO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:25:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75269119
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:25:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172BEC433C8;
        Thu, 19 Oct 2023 16:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732712;
        bh=hHBYxqlFJX3D+BREoPo7WWLy2SxREfA86S9xVcxVk+U=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=OK9KaqPkiFmjeGDUS/pczfb8GEQnOgVJBUchbvX6yseyAzPTY/VHF9zrmwaVFzgob
         KfVThL4JXMsHCb1m92kQBcfVh7sBO+eSdoETAd4ffJr6vbbvyW8Wb1CrgEPpayHgzn
         7uxcsuV0d7TllXuFzCuWoLILQ20xmcPQ/8sYOnzeOgipB9gGfaFRxwc5ypg1DXkwV5
         AdXzIFH8GvjO2dUSInrboBxxVtnsBjl3I3mYTypB+MPnzzVblnFYmkjok8ivA8dZQF
         xulahynabwUMvhsMVNWNUQONf7/miPjIRhWy8LZyMSp0ofe0m6d+uVA/wpjaw6onSL
         QO1MKYJOXG4iw==
Date:   Thu, 19 Oct 2023 09:25:11 -0700
Subject: [PATCH 3/7] xfs: create a helper to convert extlen to rtextlen
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773210603.225313.1623178619254830297.stgit@frogsfrogsfrogs>
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

Create a helper to compute the realtime extent (xfs_rtxlen_t) from an
extent length (xfs_extlen_t) value.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.h   |    8 ++++++++
 fs/xfs/libxfs/xfs_trans_resv.c |    3 ++-
 fs/xfs/xfs_bmap_util.c         |   11 ++++-------
 fs/xfs/xfs_trans.c             |    3 ++-
 4 files changed, 16 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index b6a4c46bddc0..e2a36fc157c4 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -31,6 +31,14 @@ xfs_extlen_to_rtxmod(
 	return len % mp->m_sb.sb_rextsize;
 }
 
+static inline xfs_rtxlen_t
+xfs_extlen_to_rtxlen(
+	struct xfs_mount	*mp,
+	xfs_extlen_t		len)
+{
+	return len / mp->m_sb.sb_rextsize;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 5b2f27cbdb80..4629f10d2f67 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -19,6 +19,7 @@
 #include "xfs_trans.h"
 #include "xfs_qm.h"
 #include "xfs_trans_space.h"
+#include "xfs_rtbitmap.h"
 
 #define _ALLOC	true
 #define _FREE	false
@@ -220,7 +221,7 @@ xfs_rtalloc_block_count(
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
 	unsigned int		rtbmp_bytes;
 
-	rtbmp_bytes = (XFS_MAX_BMBT_EXTLEN / mp->m_sb.sb_rextsize) / NBBY;
+	rtbmp_bytes = xfs_extlen_to_rtxlen(mp, XFS_MAX_BMBT_EXTLEN) / NBBY;
 	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
 }
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 8895184ff90a..4f53f784f06d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -90,7 +90,7 @@ xfs_bmap_rtalloc(
 
 	align = xfs_get_extsz_hint(ap->ip);
 retry:
-	prod = align / mp->m_sb.sb_rextsize;
+	prod = xfs_extlen_to_rtxlen(mp, align);
 	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
 					align, 1, ap->eof, 0,
 					ap->conv, &ap->offset, &ap->length);
@@ -117,17 +117,14 @@ xfs_bmap_rtalloc(
 		prod = 1;
 	/*
 	 * Set ralen to be the actual requested length in rtextents.
-	 */
-	ralen = ap->length / mp->m_sb.sb_rextsize;
-	/*
+	 *
 	 * If the old value was close enough to XFS_BMBT_MAX_EXTLEN that
 	 * we rounded up to it, cut it back so it's valid again.
 	 * Note that if it's a really large request (bigger than
 	 * XFS_BMBT_MAX_EXTLEN), we don't hear about that number, and can't
 	 * adjust the starting point to match it.
 	 */
-	if (xfs_rtxlen_to_extlen(mp, ralen) >= XFS_MAX_BMBT_EXTLEN)
-		ralen = XFS_MAX_BMBT_EXTLEN / mp->m_sb.sb_rextsize;
+	ralen = xfs_extlen_to_rtxlen(mp, min(ap->length, XFS_MAX_BMBT_EXTLEN));
 
 	/*
 	 * Lock out modifications to both the RT bitmap and summary inodes
@@ -164,7 +161,7 @@ xfs_bmap_rtalloc(
 		do_div(ap->blkno, mp->m_sb.sb_rextsize);
 	rtx = ap->blkno;
 	ap->length = ralen;
-	raminlen = max_t(xfs_extlen_t, 1, minlen / mp->m_sb.sb_rextsize);
+	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
 	error = xfs_rtallocate_extent(ap->tp, ap->blkno, raminlen, ap->length,
 			&ralen, ap->wasdel, prod, &rtx);
 	if (error)
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 8c0bfc9a33b1..338dd3774507 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -24,6 +24,7 @@
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_icache.h"
+#include "xfs_rtbitmap.h"
 
 struct kmem_cache	*xfs_trans_cache;
 
@@ -1196,7 +1197,7 @@ xfs_trans_alloc_inode(
 
 retry:
 	error = xfs_trans_alloc(mp, resv, dblocks,
-			rblocks / mp->m_sb.sb_rextsize,
+			xfs_extlen_to_rtxlen(mp, rblocks),
 			force ? XFS_TRANS_RESERVE : 0, &tp);
 	if (error)
 		return error;

