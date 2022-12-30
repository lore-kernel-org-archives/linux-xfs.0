Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D30FBC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbiLaBXh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236061AbiLaBXg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:23:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD749FE3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:23:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37A9661C3A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A09C433EF;
        Sat, 31 Dec 2022 01:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449814;
        bh=xLQLJK2PodHxcV2BRxPxuNRN8K2TETA8igyXsDWceFg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ODygilNM6HfL+5Mb5YUi1eAL1ME+Jcregc2zRef7NuO/frsswQ0UXxZ0UgqdSN96A
         kPODE+vna+4H1snKJgu1O6CyQyahldir0DbSSTH5prfkj8iSgoMrWE7WcEUtES2psV
         B9qKsBAMOdP0wetWpJ1EZQBU4ggJxspvGFQklnHcR6U5QrmvXVsCaJW3eU/LzY0dTE
         pmsoWbfwyxY7HGRd5flyXGOBM3diq3uWh8lwSY1quf8LK1iDnwvwPZcFCxPZ7jKesC
         it+hYwLw2lEEzKy1XSELdWa4aDcL6HdXmBFE7yTN/PPyhyXrCJGABG/d+NTiM64BAE
         vZIiQyNFmhKKA==
Subject: [PATCH 3/7] xfs: create a helper to compute leftovers of realtime
 extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:41 -0800
Message-ID: <167243866118.711673.6252664305542197438.stgit@magnolia>
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
index 791fad6dba74..dd924842716d 100644
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
index cc158e5e095f..a55347c693ed 100644
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
index 1e95d11b6d7d..3e81826c9a0a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -24,6 +24,7 @@
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_icache.h"
+#include "xfs_rtbitmap.h"
 
 struct kmem_cache	*xfs_trans_cache;
 
@@ -1245,7 +1246,7 @@ xfs_trans_alloc_inode(
 
 retry:
 	error = xfs_trans_alloc(mp, resv, dblocks,
-			rblocks / mp->m_sb.sb_rextsize,
+			xfs_extlen_to_rtxlen(mp, rblocks),
 			force ? XFS_TRANS_RESERVE : 0, &tp);
 	if (error)
 		return error;
@@ -1291,7 +1292,7 @@ xfs_trans_reserve_more_inode(
 	bool			force_quota)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	unsigned int		rtx = rblocks / mp->m_sb.sb_rextsize;
+	unsigned int		rtx = xfs_extlen_to_rtxlen(mp, rblocks);
 	int			error;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));

