Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A94C6CDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbjJSQ1g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbjJSQ1f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:27:35 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47784119
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:27:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CE2C433C7;
        Thu, 19 Oct 2023 16:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732852;
        bh=qE92AgKNlZHQAQiRFFzLPvPH05hbH11E5cwjJxNRPsM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=s2shBtPvZekUNL2jm3vCcT17RmIpor8InQWamexLzSnDepUeXXLyGAMdffWcHcRvJ
         zBeryZrJH9w+5ZlLijEuCWEbaECFxOkeCM3bnI45+V7MthkAT0Ovo2eBbnEi00bZn8
         AO6OLMyGiz8HOcWUwV/mKd2WHv88VREpw6Zgt2HkNGV1222snjLDUH73hYeu9gWCXU
         w8YJrPVPp2VGfbgR6hd8LU1x/CS/IUioFTHk4ntzSWovKWqAMTb4fv0vhBgqIkZqiK
         gIOBzNlICTEBSQwxeJlxERU1g73IdZuFRNCpx4pxQX+8Jh2ppLvScKDW5iXSEvm73p
         lhfdkto1m2/gg==
Date:   Thu, 19 Oct 2023 09:27:32 -0700
Subject: [PATCH 5/5] xfs: create helpers for rtbitmap block/wordcount
 computations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773211046.225536.5937847006570613860.stgit@frogsfrogsfrogs>
In-Reply-To: <169773210961.225536.12900854938759335651.stgit@frogsfrogsfrogs>
References: <169773210961.225536.12900854938759335651.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create helper functions that compute the number of blocks or words
necessary to store the rt bitmap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.c   |   27 +++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtbitmap.h   |   12 ++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.c |    9 +++++----
 fs/xfs/scrub/rtsummary.c       |    7 +++----
 fs/xfs/xfs_rtalloc.c           |    2 +-
 5 files changed, 48 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index efa084de58c2..aefa2b0747a5 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1135,3 +1135,30 @@ xfs_rtalloc_extent_is_free(
 	*is_free = matches;
 	return 0;
 }
+
+/*
+ * Compute the number of rtbitmap blocks needed to track the given number of rt
+ * extents.
+ */
+xfs_filblks_t
+xfs_rtbitmap_blockcount(
+	struct xfs_mount	*mp,
+	xfs_rtbxlen_t		rtextents)
+{
+	return howmany_64(rtextents, NBBY * mp->m_sb.sb_blocksize);
+}
+
+/*
+ * Compute the number of rtbitmap words needed to populate every block of a
+ * bitmap that is large enough to track the given number of rt extents.
+ */
+unsigned long long
+xfs_rtbitmap_wordcount(
+	struct xfs_mount	*mp,
+	xfs_rtbxlen_t		rtextents)
+{
+	xfs_filblks_t		blocks;
+
+	blocks = xfs_rtbitmap_blockcount(mp, rtextents);
+	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
+}
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 79ade6d2361b..01eabb9b5516 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -280,6 +280,11 @@ xfs_rtfree_extent(
 /* Same as above, but in units of rt blocks. */
 int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 		xfs_filblks_t rtlen);
+
+xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
+		rtextents);
+unsigned long long xfs_rtbitmap_wordcount(struct xfs_mount *mp,
+		xfs_rtbxlen_t rtextents);
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
@@ -287,6 +292,13 @@ int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 # define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
 # define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
+static inline xfs_filblks_t
+xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
+{
+	/* shut up gcc */
+	return 0;
+}
+# define xfs_rtbitmap_wordcount(mp, r)			(0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __XFS_RTBITMAP_H__ */
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 4629f10d2f67..6cd45e8c118d 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -218,11 +218,12 @@ xfs_rtalloc_block_count(
 	struct xfs_mount	*mp,
 	unsigned int		num_ops)
 {
-	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
-	unsigned int		rtbmp_bytes;
+	unsigned int		rtbmp_blocks;
+	xfs_rtxlen_t		rtxlen;
 
-	rtbmp_bytes = xfs_extlen_to_rtxlen(mp, XFS_MAX_BMBT_EXTLEN) / NBBY;
-	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
+	rtxlen = xfs_extlen_to_rtxlen(mp, XFS_MAX_BMBT_EXTLEN);
+	rtbmp_blocks = xfs_rtbitmap_blockcount(mp, rtxlen);
+	return (rtbmp_blocks + 1) * num_ops;
 }
 
 /*
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 3c8a6cc33800..0971d002d906 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -160,12 +160,11 @@ xchk_rtsum_compute(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_mount	*mp = sc->mp;
-	unsigned long long	rtbmp_bytes;
+	unsigned long long	rtbmp_blocks;
 
 	/* If the bitmap size doesn't match the computed size, bail. */
-	rtbmp_bytes = howmany_64(mp->m_sb.sb_rextents, NBBY);
-	if (roundup_64(rtbmp_bytes, mp->m_sb.sb_blocksize) !=
-			mp->m_rbmip->i_disk_size)
+	rtbmp_blocks = xfs_rtbitmap_blockcount(mp, mp->m_sb.sb_rextents);
+	if (XFS_FSB_TO_B(mp, rtbmp_blocks) != mp->m_rbmip->i_disk_size)
 		return -EFSCORRUPTED;
 
 	return xfs_rtalloc_query_all(sc->mp, sc->tp, xchk_rtsum_record_free,
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index fdfb22baa6da..8e041df12640 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -998,7 +998,7 @@ xfs_growfs_rt(
 	 */
 	nrextents = nrblocks;
 	do_div(nrextents, in->extsize);
-	nrbmblocks = howmany_64(nrextents, NBBY * sbp->sb_blocksize);
+	nrbmblocks = xfs_rtbitmap_blockcount(mp, nrextents);
 	nrextslog = xfs_highbit32(nrextents);
 	nrsumlevels = nrextslog + 1;
 	nrsumsize = (uint)sizeof(xfs_suminfo_t) * nrsumlevels * nrbmblocks;

