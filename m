Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1211CC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbiL3XsJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbiL3XsH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:48:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AAEF64FA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:48:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D76A0B81D67
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DB2C433EF;
        Fri, 30 Dec 2022 23:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444084;
        bh=brU6FnF+7hK4nCHVQd8bbLTJ3kt+2Nq+PXfNYXDlxQk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SrOxSZVcw0QOULHdnXCJD2iOtOvT9sB88q1IrvzKTGff7SdjGyF+5aWOe68kZS6at
         jBqf/aa2I+/tUFymu7UOQtI6PWuaMpNnkVHSSdBJwdnqYO8tQ71wa/beYuKQQKlSuB
         wyQkbnHhNcZkAmPPVWpUN3s7tI6f4blk7RNX8el4Abb+OvhSWhb6p101EcMGepbFAO
         M+vpbgFf91Hmqs6UanUUnfGKDKphpGt1+3yw9z2qyQV0MIlz/wRmDZTXA6A+al8qJp
         oTE4RHqVPfR2dNbn7KulKzQTTGABawsSZ/TMb4NAi29gmtIlE7hCRgxajpR/4p9KnN
         stlsefWMYseDg==
Subject: [PATCH 1/4] xfs: fix xfs_bunmapi to allow unmapping of partial rt
 extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:44 -0800
Message-ID: <167243842477.699102.12483237163364592102.stgit@magnolia>
In-Reply-To: <167243842459.699102.4471319762222972730.stgit@magnolia>
References: <167243842459.699102.4471319762222972730.stgit@magnolia>
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
index ce12a1fd3209..ac5a0d3718f2 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5148,15 +5148,14 @@ xfs_bmap_del_extent_real(
 
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
@@ -5165,10 +5164,12 @@ xfs_bmap_del_extent_real(
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
@@ -5475,7 +5476,7 @@ __xfs_bunmapi(
 		if (del.br_startoff + del.br_blockcount > end + 1)
 			del.br_blockcount = end + 1 - del.br_startoff;
 
-		if (!isrt)
+		if (!isrt || (flags & XFS_BMAPI_REMAP))
 			goto delete;
 
 		sum = del.br_startblock + del.br_blockcount;
@@ -5493,7 +5494,7 @@ __xfs_bunmapi(
 				 * This piece is unwritten, or we're not
 				 * using unwritten extents.  Skip over it.
 				 */
-				ASSERT(end >= mod);
+				ASSERT((flags & XFS_BMAPI_REMAP) || end >= mod);
 				end -= mod > del.br_blockcount ?
 					del.br_blockcount : mod;
 				if (end < got.br_startoff &&

