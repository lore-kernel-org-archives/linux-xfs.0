Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66FD0CDB475
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbjJKSGB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346207AbjJKSGA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:06:00 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A84A94
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:05:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE29CC433C7;
        Wed, 11 Oct 2023 18:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047559;
        bh=UJD/AnAy5k43DrNyqfYi8yNVnFGlcXcIOABov2HOYME=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jkCZXMCHmNNPVFtvV+xrzr6g4wcO7X4t4h9uTC7GAVFExARz8UVK7An6c/6aNhf6g
         TYyRNscHzELjy4oiJDq1Uzg6YX3X9CxIGhi93P5DtV86dBpSV+7ZJLWP0uPkaIicjL
         VXLymcTYAzbdZq+yd+eHHVSAWkAFVZ6E2ewuH7YCEWSGX1r4+QNt1huQYzIcvkXXQV
         Zh/V6wFq9ck4y9O9jy3XaYobIo0ZZ6JFXsCVSP2KCOOQcfCw95+bFysUdBQ2MSkO36
         JQ/bXSDU5yRjKXSHZh11CGwRK2nvCY5XYcV044MzmMOfq4ujYMfY6vTj7PKLcPEb72
         +IfaY98DfCAIA==
Date:   Wed, 11 Oct 2023 11:05:58 -0700
Subject: [PATCH 6/7] xfs: create rt extent rounding helpers for realtime
 extent blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704721269.1773611.8447535257561725790.stgit@frogsfrogsfrogs>
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

Create a pair of functions to round rtblock numbers up or down to the
nearest rt extent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.h |   18 ++++++++++++++++++
 fs/xfs/xfs_bmap_util.c       |    8 +++-----
 fs/xfs/xfs_rtalloc.c         |    4 ++--
 fs/xfs/xfs_xchgrange.c       |    4 ++--
 4 files changed, 25 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index bdd4858a794c2..bc51d3bfc7c45 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -56,6 +56,24 @@ xfs_rtb_to_rtxt(
 	return div_u64(rtbno, mp->m_sb.sb_rextsize);
 }
 
+/* Round this rtblock up to the nearest rt extent size. */
+static inline xfs_rtblock_t
+xfs_rtb_roundup_rtx(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return roundup_64(rtbno, mp->m_sb.sb_rextsize);
+}
+
+/* Round this rtblock down to the nearest rt extent size. */
+static inline xfs_rtblock_t
+xfs_rtb_rounddown_rtx(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return rounddown_64(rtbno, mp->m_sb.sb_rextsize);
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 8f1e16e49dab2..b17332b84812e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -685,7 +685,7 @@ xfs_can_free_eofblocks(
 	 */
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
 	if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 1)
-		end_fsb = roundup_64(end_fsb, mp->m_sb.sb_rextsize);
+		end_fsb = xfs_rtb_roundup_rtx(mp, end_fsb);
 	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	if (last_fsb <= end_fsb)
 		return false;
@@ -984,10 +984,8 @@ xfs_free_file_space(
 
 	/* We can only free complete realtime extents. */
 	if (xfs_inode_has_bigrtextents(ip)) {
-		startoffset_fsb = roundup_64(startoffset_fsb,
-					     mp->m_sb.sb_rextsize);
-		endoffset_fsb = rounddown_64(endoffset_fsb,
-					     mp->m_sb.sb_rextsize);
+		startoffset_fsb = xfs_rtb_roundup_rtx(mp, startoffset_fsb);
+		endoffset_fsb = xfs_rtb_rounddown_rtx(mp, endoffset_fsb);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 8db8f957a683b..e62ca51b995ba 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1633,8 +1633,8 @@ xfs_rtfile_convert_unwritten(
 	if (mp->m_sb.sb_rextsize == 1)
 		return 0;
 
-	off = rounddown_64(XFS_B_TO_FSBT(mp, pos), mp->m_sb.sb_rextsize);
-	endoff = roundup_64(XFS_B_TO_FSB(mp, pos + len), mp->m_sb.sb_rextsize);
+	off = xfs_rtb_rounddown_rtx(mp, XFS_B_TO_FSBT(mp, pos));
+	endoff = xfs_rtb_roundup_rtx(mp, XFS_B_TO_FSB(mp, pos + len));
 
 	trace_xfs_rtfile_convert_unwritten(ip, pos, len);
 
diff --git a/fs/xfs/xfs_xchgrange.c b/fs/xfs/xfs_xchgrange.c
index befa915089ce6..a4a352e027c97 100644
--- a/fs/xfs/xfs_xchgrange.c
+++ b/fs/xfs/xfs_xchgrange.c
@@ -28,6 +28,7 @@
 #include "xfs_icache.h"
 #include "xfs_log.h"
 #include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include <linux/fsnotify.h>
 
 /*
@@ -1236,8 +1237,7 @@ xfs_xchg_range(
 	 * offsets and length in @fxr are safe to round up.
 	 */
 	if (XFS_IS_REALTIME_INODE(ip2))
-		req.blockcount = roundup_64(req.blockcount,
-					    mp->m_sb.sb_rextsize);
+		req.blockcount = xfs_rtb_roundup_rtx(mp, req.blockcount);
 
 	error = xfs_xchg_range_estimate(&req);
 	if (error)

