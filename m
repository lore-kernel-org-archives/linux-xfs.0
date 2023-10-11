Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3703ECDB470
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbjJKSFc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235033AbjJKSF3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:05:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20403CA
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:05:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA9FC433C7;
        Wed, 11 Oct 2023 18:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047527;
        bh=gWLBKDAhhyCzRO9pvit4aHSyErvbYacnXgMqF5ldz6k=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=DIQSYeoXXFVJVkgHn8gD33MbX7bxJ+VL85O2LPJPZ3qKWudCO9X1FJBrHGS55SJCB
         fipDwPjWcCHQ4nsNvJ7NN2ay/EL4CTr7HbDA6a3W8C+snzOStfpDhZmbp48BT/UAN2
         CkSMbWpPGv59qHMhsIuWNBxNowKleno9cFYowKXiN5uvE7ZPx2uqzwWEW+HoGbzox/
         j5v7L34udNJxEcfB67e6Y9gt2JS+MxdOSmoCdqm5BvnKEO3gEA0JHJWlmfJf8blkb9
         8e8+ixq7Iqd8Iz8Fu4H5CX2kPf3rtPfcFpDh3rPTyZ8cvkFOfGYvz9c5MCPRjI9SPE
         7cd6XxV5LhEIQ==
Date:   Wed, 11 Oct 2023 11:05:27 -0700
Subject: [PATCH 4/7] xfs: create helpers to convert rt block numbers to rt
 extent numbers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704721239.1773611.10087575278257926892.stgit@frogsfrogsfrogs>
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

Create helpers to do unit conversions of rt block numbers to rt extent
numbers.  There are two variations -- the suffix "t" denotes the one
that returns only the truncated extent number; the other one also
returns the misalignment.  Convert all the div_u64_rem users; we'll do
the do_div users in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c     |    7 +++----
 fs/xfs/libxfs/xfs_rtbitmap.c |    4 ++--
 fs/xfs/libxfs/xfs_rtbitmap.h |   17 +++++++++++++++++
 fs/xfs/libxfs/xfs_swapext.c  |    7 ++++---
 fs/xfs/xfs_rtalloc.c         |    8 ++++----
 5 files changed, 30 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 82dc95944374e..463174af94333 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5336,7 +5336,6 @@ __xfs_bunmapi(
 	int			tmp_logflags;	/* partial logging flags */
 	int			wasdel;		/* was a delayed alloc extent */
 	int			whichfork;	/* data or attribute fork */
-	xfs_fsblock_t		sum;
 	xfs_filblks_t		len = *rlen;	/* length to unmap in file */
 	xfs_fileoff_t		end;
 	struct xfs_iext_cursor	icur;
@@ -5433,8 +5432,7 @@ __xfs_bunmapi(
 		if (!isrt || (flags & XFS_BMAPI_REMAP))
 			goto delete;
 
-		sum = del.br_startblock + del.br_blockcount;
-		div_u64_rem(sum, mp->m_sb.sb_rextsize, &mod);
+		xfs_rtb_to_rtx(mp, del.br_startblock + del.br_blockcount, &mod);
 		if (mod) {
 			/*
 			 * Realtime extent not lined up at the end.
@@ -5481,7 +5479,8 @@ __xfs_bunmapi(
 				goto error0;
 			goto nodelete;
 		}
-		div_u64_rem(del.br_startblock, mp->m_sb.sb_rextsize, &mod);
+
+		xfs_rtb_to_rtx(mp, del.br_startblock, &mod);
 		if (mod) {
 			xfs_extlen_t off = mp->m_sb.sb_rextsize - mod;
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index ce14436811319..de54386cf52f3 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1031,13 +1031,13 @@ xfs_rtfree_blocks(
 
 	ASSERT(rtlen <= XFS_MAX_BMBT_EXTLEN);
 
-	len = div_u64_rem(rtlen, mp->m_sb.sb_rextsize, &mod);
+	len = xfs_rtb_to_rtx(mp, rtlen, &mod);
 	if (mod) {
 		ASSERT(mod == 0);
 		return -EIO;
 	}
 
-	start = div_u64_rem(rtbno, mp->m_sb.sb_rextsize, &mod);
+	start = xfs_rtb_to_rtx(mp, rtbno, &mod);
 	if (mod) {
 		ASSERT(mod == 0);
 		return -EIO;
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index e2a36fc157c4c..bdd4858a794c2 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -39,6 +39,23 @@ xfs_extlen_to_rtxlen(
 	return len / mp->m_sb.sb_rextsize;
 }
 
+static inline xfs_rtxnum_t
+xfs_rtb_to_rtx(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno,
+	xfs_extlen_t		*mod)
+{
+	return div_u64_rem(rtbno, mp->m_sb.sb_rextsize, mod);
+}
+
+static inline xfs_rtxnum_t
+xfs_rtb_to_rtxt(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return div_u64(rtbno, mp->m_sb.sb_rextsize);
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
diff --git a/fs/xfs/libxfs/xfs_swapext.c b/fs/xfs/libxfs/xfs_swapext.c
index b1d66e0cfac91..6107ec7d8d568 100644
--- a/fs/xfs/libxfs/xfs_swapext.c
+++ b/fs/xfs/libxfs/xfs_swapext.c
@@ -30,6 +30,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_dir2.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_rtbitmap.h"
 
 struct kmem_cache	*xfs_swapext_intent_cache;
 
@@ -202,19 +203,19 @@ xfs_swapext_check_rt_extents(
 					  irec2.br_blockcount);
 
 		/* Both mappings must be aligned to the realtime extent size. */
-		div_u64_rem(irec1.br_startoff, mp->m_sb.sb_rextsize, &mod);
+		xfs_rtb_to_rtx(mp, irec1.br_startoff, &mod);
 		if (mod) {
 			ASSERT(mod == 0);
 			return -EINVAL;
 		}
 
-		div_u64_rem(irec2.br_startoff, mp->m_sb.sb_rextsize, &mod);
+		xfs_rtb_to_rtx(mp, irec1.br_startoff, &mod);
 		if (mod) {
 			ASSERT(mod == 0);
 			return -EINVAL;
 		}
 
-		div_u64_rem(irec1.br_blockcount, mp->m_sb.sb_rextsize, &mod);
+		xfs_rtb_to_rtx(mp, irec1.br_blockcount, &mod);
 		if (mod) {
 			ASSERT(mod == 0);
 			return -EINVAL;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4bb776911a4fb..d3a5112f21156 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1496,16 +1496,16 @@ xfs_rtfile_want_conversion(
 	struct xfs_bmbt_irec	*irec)
 {
 	xfs_fileoff_t		rext_next;
-	uint32_t		modoff, modcnt;
+	xfs_extlen_t		modoff, modcnt;
 
 	if (irec->br_state != XFS_EXT_UNWRITTEN)
 		return false;
 
-	div_u64_rem(irec->br_startoff, mp->m_sb.sb_rextsize, &modoff);
+	xfs_rtb_to_rtx(mp, irec->br_startoff, &modoff);
 	if (modoff == 0) {
-		uint64_t	rexts = div_u64_rem(irec->br_blockcount,
-						mp->m_sb.sb_rextsize, &modcnt);
+		xfs_rtbxlen_t	rexts;
 
+		rexts = xfs_rtb_to_rtx(mp, irec->br_blockcount, &modcnt);
 		if (rexts > 0) {
 			/*
 			 * Unwritten mapping starts at an rt extent boundary

