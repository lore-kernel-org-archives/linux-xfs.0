Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D79C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:12:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbjEZBM0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjEZBMZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:12:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D485D8
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:12:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EE5764C1F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4C3C433D2;
        Fri, 26 May 2023 01:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063544;
        bh=ilg+Q/ZN915zLmifYngafKtlk8r77EVchEPzJQKub+E=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=By+br4lvlEYtcmoriHRe6plj1FjvH36fglHyPmOisDofxnmJYZU1An0p2XkfCl1+q
         UQP2E2vK7IU+7U6ND7YRXhKlrXLV4nQDfy+bsFd29TCnUAIVP6zom7vWH3h9lAEwMP
         61YR1FLQKzaad1OJJKvFXo6cEzs2uINYU99aO9gUVb0Upopv+aDOiNC9qzaoT19XZK
         yno53bNvfR6lxR81r2qO4B01gqJqbGCbMlkWsKZJ4hhRkI1WCDIrdhKKWNrpxmXVv3
         O2ZBPUkpYGYJjQnRjRAmtbmogQBD4UC22eojKQUGi8vwfH9nNgovpeNMuHjvxt08cH
         g+PBKNztJcgSw==
Date:   Thu, 25 May 2023 18:12:23 -0700
Subject: [PATCH 1/4] xfs: fix xfs_bunmapi to allow unmapping of partial rt
 extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506063865.3734058.2235046441109264397.stgit@frogsfrogsfrogs>
In-Reply-To: <168506063846.3734058.6853885983674617900.stgit@frogsfrogsfrogs>
References: <168506063846.3734058.6853885983674617900.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When XFS_BMAPI_REMAP is passed to bunmapi, that means that we want to
remove part of a block mapping without touching the allocator.  For
realtime files with rtextsize > 1, that also means that we should skip
all the code that changes a partial remove request into an unwritten
extent conversion.  IOWs, bunmapi in this mode should handle removing
the mapping from the rt file and nothing else.

Note that XFS_BMAPI_REMAP callers are required to decrement the
reference count and/or free the space manually.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1479168cccc3..2beff0cfdf38 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5120,15 +5120,14 @@ xfs_bmap_del_extent_real(
 
 	flags = XFS_ILOG_CORE;
 	if (xfs_ifork_is_realtime(ip, whichfork)) {
-		xfs_filblks_t	len;
-		xfs_extlen_t	mod;
-
-		len = div_u64_rem(del->br_blockcount, mp->m_sb.sb_rextsize,
-				  &mod);
-		ASSERT(mod == 0);
-
 		if (!(bflags & XFS_BMAPI_REMAP)) {
 			xfs_fsblock_t	bno;
+			xfs_filblks_t	len;
+			xfs_extlen_t	mod;
+
+			len = div_u64_rem(del->br_blockcount,
+					mp->m_sb.sb_rextsize, &mod);
+			ASSERT(mod == 0);
 
 			bno = div_u64_rem(del->br_startblock,
 					mp->m_sb.sb_rextsize, &mod);
@@ -5137,10 +5136,12 @@ xfs_bmap_del_extent_real(
 			error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
 			if (error)
 				goto done;
+			nblks = len * mp->m_sb.sb_rextsize;
+		} else {
+			nblks = del->br_blockcount;
 		}
 
 		do_fx = 0;
-		nblks = len * mp->m_sb.sb_rextsize;
 		qfield = XFS_TRANS_DQ_RTBCOUNT;
 	} else {
 		do_fx = 1;
@@ -5447,7 +5448,7 @@ __xfs_bunmapi(
 		if (del.br_startoff + del.br_blockcount > end + 1)
 			del.br_blockcount = end + 1 - del.br_startoff;
 
-		if (!isrt)
+		if (!isrt || (flags & XFS_BMAPI_REMAP))
 			goto delete;
 
 		sum = del.br_startblock + del.br_blockcount;
@@ -5465,7 +5466,7 @@ __xfs_bunmapi(
 				 * This piece is unwritten, or we're not
 				 * using unwritten extents.  Skip over it.
 				 */
-				ASSERT(end >= mod);
+				ASSERT((flags & XFS_BMAPI_REMAP) || end >= mod);
 				end -= mod > del.br_blockcount ?
 					del.br_blockcount : mod;
 				if (end < got.br_startoff &&

