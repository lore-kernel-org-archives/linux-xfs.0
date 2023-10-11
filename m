Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C3FCDB473
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbjJKSFO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbjJKSFN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:05:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F62F94
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:05:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FCBC433C7;
        Wed, 11 Oct 2023 18:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047512;
        bh=k2J1S7+PW8uAsud6zLCq0IkcArv4G8w9CB68ulsW/5E=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=qaiFju2FWrfdYpgNMeXadP+/vvNPvC+1n+1vCThGlXXpCnZ8CKgD6RDSb8DnITzgQ
         +KeHqU36YtzbmZh1+m4NxyHdnUIK4bu2BxJirD52AsmqwtMsI+e4O+sR2SQwf57GpS
         Fw5A3lZx+XFaNxbTM6m2URrsgweiw9Vc+/Ll+fX5Zo1qIHUHGdLE3sOYnYERgwH+m2
         l0kTOPh5MbQumDRNzixjMSJgZ2fQ3MW5o/haTTpvLlpkScu5cYBBUGdmWo8XUyZPFe
         oEg/6yO/Ss8oArqKjXvnE8dAaQPdhoclpeUfosE9tz+CFOWsauejqjVY9q6qbPw1rh
         Qyyd0t8b+T5hw==
Date:   Wed, 11 Oct 2023 11:05:11 -0700
Subject: [PATCH 3/7] xfs: create a helper to compute leftovers of realtime
 extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704721225.1773611.3934306904978045115.stgit@frogsfrogsfrogs>
In-Reply-To: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs>
References: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_rtbitmap.h   |    8 ++++++++
 fs/xfs/libxfs/xfs_trans_resv.c |    3 ++-
 fs/xfs/xfs_bmap_util.c         |   11 ++++-------
 fs/xfs/xfs_trans.c             |    5 +++--
 4 files changed, 17 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index b6a4c46bddc0a..e2a36fc157c4c 100644
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
index 328c569c20a35..9c3dbcbe05358 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -22,6 +22,7 @@
 #include "xfs_attr_item.h"
 #include "xfs_log.h"
 #include "xfs_da_format.h"
+#include "xfs_rtbitmap.h"
 
 #define _ALLOC	true
 #define _FREE	false
@@ -223,7 +224,7 @@ xfs_rtalloc_block_count(
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
 	unsigned int		rtbmp_bytes;
 
-	rtbmp_bytes = (XFS_MAX_BMBT_EXTLEN / mp->m_sb.sb_rextsize) / NBBY;
+	rtbmp_bytes = xfs_extlen_to_rtxlen(mp, XFS_MAX_BMBT_EXTLEN) / NBBY;
 	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
 }
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0590d55cd88f6..c246f25aaad55 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -91,7 +91,7 @@ xfs_bmap_rtalloc(
 
 	align = xfs_get_extsz_hint(ap->ip);
 retry:
-	prod = align / mp->m_sb.sb_rextsize;
+	prod = xfs_extlen_to_rtxlen(mp, align);
 	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
 					align, 1, ap->eof, 0,
 					ap->conv, &ap->offset, &ap->length);
@@ -118,17 +118,14 @@ xfs_bmap_rtalloc(
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
@@ -165,7 +162,7 @@ xfs_bmap_rtalloc(
 		do_div(ap->blkno, mp->m_sb.sb_rextsize);
 	rtx = ap->blkno;
 	ap->length = ralen;
-	raminlen = max_t(xfs_extlen_t, 1, minlen / mp->m_sb.sb_rextsize);
+	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
 	error = xfs_rtallocate_extent(ap->tp, ap->blkno, raminlen, ap->length,
 			&ralen, ap->wasdel, prod, &rtx);
 	if (error)
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index ea045af01f5e8..22aa2111b6cab 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -24,6 +24,7 @@
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_icache.h"
+#include "xfs_rtbitmap.h"
 
 struct kmem_cache	*xfs_trans_cache;
 
@@ -1252,7 +1253,7 @@ xfs_trans_alloc_inode(
 
 retry:
 	error = xfs_trans_alloc(mp, resv, dblocks,
-			rblocks / mp->m_sb.sb_rextsize,
+			xfs_extlen_to_rtxlen(mp, rblocks),
 			force ? XFS_TRANS_RESERVE : 0, &tp);
 	if (error)
 		return error;
@@ -1298,7 +1299,7 @@ xfs_trans_reserve_more_inode(
 	bool			force_quota)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	unsigned int		rtx = rblocks / mp->m_sb.sb_rextsize;
+	unsigned int		rtx = xfs_extlen_to_rtxlen(mp, rblocks);
 	int			error;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));

