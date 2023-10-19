Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90437CDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjJSQ0B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbjJSQ0B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:26:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6489B
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:25:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201A1C433C8;
        Thu, 19 Oct 2023 16:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732759;
        bh=xJD1ENK4+yqDj6E6JeSZav9vlrN/Gl7mEP7q6YzsIGY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=uyYk60lID6oHqRPkG0wJM4tpHiNlv+Im0qlh/yilUcin3AFQg2BFxlJoqjaiEBpY7
         SqESgBOLB0oiT7C5T2Wy0XBlYY3amuxjC5Axg7+br59i3rvG51VKEmQDl3a+yQvp0O
         KAM1jTYTxH7IpmR6sdLuyJ2UBmZdJvB2SGuAblm/fBFEwetE1KfjYqTDuCf5qj9pnE
         +GWvttjYpVXUzlJ3fTlq0v2dBwzQXb1Qnx4pV7neVbQbh/Pio0AIWR4Gqb7wWszD3d
         F5w20NQIXldAUioneL9xVgsic3R4mAyoxHu4TDflFZkxG4p13WuUOqStRjwJCCApVK
         MkJWbXIpWZcVw==
Date:   Thu, 19 Oct 2023 09:25:58 -0700
Subject: [PATCH 6/7] xfs: create rt extent rounding helpers for realtime
 extent blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773210651.225313.6307196834395269986.stgit@frogsfrogsfrogs>
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

Create a pair of functions to round rtblock numbers up or down to the
nearest rt extent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.h |   18 ++++++++++++++++++
 fs/xfs/xfs_bmap_util.c       |    8 +++-----
 2 files changed, 21 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index ff901bf3d1ee..ecf5645dd670 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -84,6 +84,24 @@ xfs_rtb_to_rtxup(
 	return rtbno;
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
index 25a03c1276e3..c640dfc2d00f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -684,7 +684,7 @@ xfs_can_free_eofblocks(
 	 */
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
 	if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 1)
-		end_fsb = roundup_64(end_fsb, mp->m_sb.sb_rextsize);
+		end_fsb = xfs_rtb_roundup_rtx(mp, end_fsb);
 	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	if (last_fsb <= end_fsb)
 		return false;
@@ -983,10 +983,8 @@ xfs_free_file_space(
 
 	/* We can only free complete realtime extents. */
 	if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 1) {
-		startoffset_fsb = roundup_64(startoffset_fsb,
-					     mp->m_sb.sb_rextsize);
-		endoffset_fsb = rounddown_64(endoffset_fsb,
-					     mp->m_sb.sb_rextsize);
+		startoffset_fsb = xfs_rtb_roundup_rtx(mp, startoffset_fsb);
+		endoffset_fsb = xfs_rtb_rounddown_rtx(mp, endoffset_fsb);
 	}
 
 	/*

