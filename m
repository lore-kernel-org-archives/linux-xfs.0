Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88128CDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235082AbjJQPvD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235093AbjJQPvB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:51:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141B69E
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:51:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07D7C433C8;
        Tue, 17 Oct 2023 15:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557859;
        bh=rQ6VO9wu5pqBd37kUVoWQsjibrzu5yK9ex/jvalh0uU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ESLdNftVRoBC5RWmfjFBIDoFQruCm9u10qrvc0pxNxt7jGKdE9TyDuWI7WnrYREfi
         6DT+hmx3kOa5pbCaldsywIFxeqICYzugNbh6Kv9bLO5zn89pr6X+8bmSbed9/7riLd
         58oV4SJ7hZbD4WAoZYYHvaoBJOJD9vk/yQP2Rng496zLURMxfgzH0PSvN1ys85bzRX
         kwuvLBpftNbw3RGHyf+hPRV4BhTf+r2pcEIu8CcAhveKqIdkTxkv3AlLhqpWCPH/JA
         WBnBTDTGh93JZTw4Gzmrpkj96Pl2d1b9PAjwCqWoeAt5snJ1mpQz9MIM2bLJDuvRui
         g25g1/K9oI0NQ==
Date:   Tue, 17 Oct 2023 08:50:59 -0700
Subject: [PATCH 4/7] xfs: create helpers to convert rt block numbers to rt
 extent numbers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     osandov@fb.com, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755741788.3165781.7214654965503182220.stgit@frogsfrogsfrogs>
In-Reply-To: <169755741717.3165781.12142780069035126128.stgit@frogsfrogsfrogs>
References: <169755741717.3165781.12142780069035126128.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_bmap.c     |    8 ++++----
 fs/xfs/libxfs/xfs_rtbitmap.c |    4 ++--
 fs/xfs/libxfs/xfs_rtbitmap.h |   31 +++++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 19203699b992..fc96aa59a691 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5276,7 +5276,6 @@ __xfs_bunmapi(
 	int			tmp_logflags;	/* partial logging flags */
 	int			wasdel;		/* was a delayed alloc extent */
 	int			whichfork;	/* data or attribute fork */
-	xfs_fsblock_t		sum;
 	xfs_filblks_t		len = *rlen;	/* length to unmap in file */
 	xfs_fileoff_t		end;
 	struct xfs_iext_cursor	icur;
@@ -5371,8 +5370,8 @@ __xfs_bunmapi(
 		if (!isrt)
 			goto delete;
 
-		sum = del.br_startblock + del.br_blockcount;
-		div_u64_rem(sum, mp->m_sb.sb_rextsize, &mod);
+		mod = xfs_rtb_to_rtxoff(mp,
+				del.br_startblock + del.br_blockcount);
 		if (mod) {
 			/*
 			 * Realtime extent not lined up at the end.
@@ -5419,7 +5418,8 @@ __xfs_bunmapi(
 				goto error0;
 			goto nodelete;
 		}
-		div_u64_rem(del.br_startblock, mp->m_sb.sb_rextsize, &mod);
+
+		mod = xfs_rtb_to_rtxoff(mp, del.br_startblock);
 		if (mod) {
 			xfs_extlen_t off = mp->m_sb.sb_rextsize - mod;
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index f64e4aeb393b..383c6437e042 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1024,13 +1024,13 @@ xfs_rtfree_blocks(
 
 	ASSERT(rtlen <= XFS_MAX_BMBT_EXTLEN);
 
-	len = div_u64_rem(rtlen, mp->m_sb.sb_rextsize, &mod);
+	len = xfs_rtb_to_rtxrem(mp, rtlen, &mod);
 	if (mod) {
 		ASSERT(mod == 0);
 		return -EIO;
 	}
 
-	start = div_u64_rem(rtbno, mp->m_sb.sb_rextsize, &mod);
+	start = xfs_rtb_to_rtxrem(mp, rtbno, &mod);
 	if (mod) {
 		ASSERT(mod == 0);
 		return -EIO;
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index e2a36fc157c4..9df583083407 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -39,6 +39,37 @@ xfs_extlen_to_rtxlen(
 	return len / mp->m_sb.sb_rextsize;
 }
 
+/* Convert an rt block number into an rt extent number. */
+static inline xfs_rtxnum_t
+xfs_rtb_to_rtx(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return div_u64(rtbno, mp->m_sb.sb_rextsize);
+}
+
+/* Return the offset of an rt block number within an rt extent. */
+static inline xfs_extlen_t
+xfs_rtb_to_rtxoff(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return do_div(rtbno, mp->m_sb.sb_rextsize);
+}
+
+/*
+ * Crack an rt block number into an rt extent number and an offset within that
+ * rt extent.  Returns the rt extent number directly and the offset in @off.
+ */
+static inline xfs_rtxnum_t
+xfs_rtb_to_rtxrem(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno,
+	xfs_extlen_t		*off)
+{
+	return div_u64_rem(rtbno, mp->m_sb.sb_rextsize, off);
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */

