Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10563CDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbjJSQZa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbjJSQZ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:25:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234359B
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:25:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A6DC433C8;
        Thu, 19 Oct 2023 16:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732727;
        bh=U73Jd712h1S3Eetavh0LOtjqzCWwQRMROteLRJEcstg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=pSYxQorYCu/4qLI1ARXx2156GKWMQmKCrsYE8PDdKdJwETLUjAOCaMQo6Vy4xqr6D
         YlOx9It7xK/EUruiLR4gOP1LjnIR2d7IHmqByI4uZcq4uQ4Sy812Z/hNqRd0OJuoeD
         zCS82WzmsCBvND6pmN2FotFOAeopD4BNVRGXibYa06pFhIiDpCqQCrRQJo/jZouJuG
         u/3lkrL0rqLNAWrKGVFnfWRsHqaStFG7oN6ms2w0Q9EDCCU/dKTjJPe6bJx3YByA2K
         EJONBLgeuuIBNYjVWzi0AFRg/D8DuitJGf6b7OJH4DpBuQvbBRPJu0M+T2G7DdmbtG
         7MLyELN2nfX0w==
Date:   Thu, 19 Oct 2023 09:25:27 -0700
Subject: [PATCH 4/7] xfs: create helpers to convert rt block numbers to rt
 extent numbers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773210618.225313.4237206395320195299.stgit@frogsfrogsfrogs>
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

Create helpers to do unit conversions of rt block numbers to rt extent
numbers.  There are three variations -- one to compute the rt extent
number from an rt block number; one to compute the offset of an rt block
within an rt extent; and one to extract both.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

