Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759A9C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbiLaBZ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiLaBZ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:25:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B85CCE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:25:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E25261C3A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF0BC433EF;
        Sat, 31 Dec 2022 01:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449954;
        bh=pB91C8ESepMgq9SnrEx2/Bom05O5q2/4IBJ8hAh66Sc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lFex1x8pOCL/0PMaejbw+NhgjkaEPfkQnQjqjS9mNluO0Ah1OvKYLKJEyXk0L1pkv
         qNjHAw0BoHRL2NV80QyLD3FPd521x5SXSc1aBhEX3iZXIQD9shrHUCeYqYtP4lNyaO
         pkvdTLuEFgTJSmdzGTgyhXNoWW+zt3fnp5EQxqqWn21dMaMmxubWopIe+fXhMs6z0a
         EqH1FFefpJIUv4y+UG7LwX6Cf/j8Y7cZc81J7z3fwQMGQdeHzUSYOyVrptZLCAwML9
         s0NcaTIyGAvkW6abKZi9slODURmRiEKzpqxHywDptDjymh5SVT5HqqHVJMQBVdcR/f
         Kj4gQUbYBWk0w==
Subject: [PATCH 5/8] xfs: create helpers for rtbitmap block/wordcount
 computations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:45 -0800
Message-ID: <167243866548.712132.4924224857976121246.stgit@magnolia>
In-Reply-To: <167243866468.712132.9606813674941614562.stgit@magnolia>
References: <167243866468.712132.9606813674941614562.stgit@magnolia>
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
---
 fs/xfs/libxfs/xfs_rtbitmap.c   |   27 +++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtbitmap.h   |   12 ++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.c |    9 +++++----
 fs/xfs/scrub/rtsummary.c       |    7 +++----
 fs/xfs/xfs_rtalloc.c           |    2 +-
 5 files changed, 48 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index b6a1d240c554..2a453f0215ee 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1142,3 +1142,30 @@ xfs_rtalloc_extent_is_free(
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
index f616956b2891..308ce814a908 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -261,6 +261,11 @@ xfs_rtfree_extent(
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
@@ -268,6 +273,13 @@ int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
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
index dd924842716d..67accd613038 100644
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
index 98baca261202..dfbbaab5a734 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -164,12 +164,11 @@ xchk_rtsum_compute(
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
index c63906cf94d1..a64f7abe6409 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -996,7 +996,7 @@ xfs_growfs_rt(
 	 */
 	nrextents = nrblocks;
 	do_div(nrextents, in->extsize);
-	nrbmblocks = howmany_64(nrextents, NBBY * sbp->sb_blocksize);
+	nrbmblocks = xfs_rtbitmap_blockcount(mp, nrextents);
 	nrextslog = xfs_highbit32(nrextents);
 	nrsumlevels = nrextslog + 1;
 	nrsumsize = (uint)sizeof(xfs_suminfo_t) * nrsumlevels * nrbmblocks;

