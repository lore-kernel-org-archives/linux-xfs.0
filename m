Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F33CDB483
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235464AbjJSQYM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235474AbjJSQYL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:24:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A186F126
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:24:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F2CC433C7;
        Thu, 19 Oct 2023 16:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732649;
        bh=lqV0iskL4NVlAXcgAodf7xbUeOxCjPQ9CSOLMQdVn2Q=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=pwL/rV1zaVMJMlFTiGEHpnK9TN0ZE+znjb6d5Yrfqp9S3lKA9V0yyunggIrA9PYjn
         v9km9LTvRqlQ+wKn3BOKgFWi36m1PL0nyQWMrprjGPvZ952xa2xVpEBgO7d98pi9Yp
         MPyfQ2krU4JZMRDGm/vJXNag5/gLoxl4rtbGzK0woyQia5++GtnQ4+l9RP8H3bDVUq
         U6lUMwP9ebM25xCZQDgPYuERX3u0Np0GIMeS56ome5GK6D7BwIm5EZ38aS1ctIOmJK
         YBr/TU7oSQURaQ7Rb4Z1B1d1UW0H1uqTl2IbIhRfGNmJlJYX1jLqCnJCdvp1tJE3gF
         cHe5Z2Yz8c0tA==
Date:   Thu, 19 Oct 2023 09:24:08 -0700
Subject: [PATCH 7/8] xfs: rename xfs_verify_rtext to xfs_verify_rtbext
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773210234.225045.3058606170768827038.stgit@frogsfrogsfrogs>
In-Reply-To: <169773210112.225045.8142885021045785858.stgit@frogsfrogsfrogs>
References: <169773210112.225045.8142885021045785858.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c  |    4 ++--
 fs/xfs/libxfs/xfs_types.c |    4 ++--
 fs/xfs/libxfs/xfs_types.h |    4 ++--
 fs/xfs/scrub/bmap.c       |    2 +-
 fs/xfs/scrub/rtbitmap.c   |    4 ++--
 fs/xfs/scrub/rtsummary.c  |    2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a47da8d3d1bc..4e7de4f2fd7a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6196,8 +6196,8 @@ xfs_bmap_validate_extent(
 		return __this_address;
 
 	if (XFS_IS_REALTIME_INODE(ip) && whichfork == XFS_DATA_FORK) {
-		if (!xfs_verify_rtext(mp, irec->br_startblock,
-					  irec->br_blockcount))
+		if (!xfs_verify_rtbext(mp, irec->br_startblock,
+					   irec->br_blockcount))
 			return __this_address;
 	} else {
 		if (!xfs_verify_fsbext(mp, irec->br_startblock,
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 5c2765934732..c299b16c9365 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -148,10 +148,10 @@ xfs_verify_rtbno(
 
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
index 9af98a975239..9e45f13f6d70 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -231,8 +231,8 @@ bool xfs_verify_ino(struct xfs_mount *mp, xfs_ino_t ino);
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
index 75588915572e..06d8c1996a33 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -410,7 +410,7 @@ xchk_bmap_iextent(
 
 	/* Make sure the extent points to a valid place. */
 	if (info->is_rt &&
-	    !xfs_verify_rtext(mp, irec->br_startblock, irec->br_blockcount))
+	    !xfs_verify_rtbext(mp, irec->br_startblock, irec->br_blockcount))
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 	if (!info->is_rt &&
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 71d3e8b85844..8c8a611cc6d4 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -48,12 +48,12 @@ xchk_rtbitmap_rec(
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
index f4635a920470..d998f0c378a4 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -137,7 +137,7 @@ xchk_rtsum_record_free(
 	rtbno = rec->ar_startext * mp->m_sb.sb_rextsize;
 	rtlen = rec->ar_extcount * mp->m_sb.sb_rextsize;
 
-	if (!xfs_verify_rtext(mp, rtbno, rtlen)) {
+	if (!xfs_verify_rtbext(mp, rtbno, rtlen)) {
 		xchk_ino_xref_set_corrupt(sc, mp->m_rbmip->i_ino);
 		return -EFSCORRUPTED;
 	}

