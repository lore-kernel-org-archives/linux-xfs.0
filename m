Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13A5ACDB470
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbjJKSIG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbjJKSIF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:08:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE3F93
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:08:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E83BC433C8;
        Wed, 11 Oct 2023 18:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047684;
        bh=LaNhfRXKS2ioFnsBobt0+wEUePAVusLRq6mseeaqmVs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=hfryiDaduczRLt3whAxwgfCehWgeG5TBxNRDI8ts1MJvkzEHWFuXFeicsrmPe3Qra
         9aA5nlYbgEfWotJh4WTEVLNh9hmAabMB/F6TI3brszG7b4JRLVG1FMw/IE0DxnVwfB
         5CruhCyqAf7xa1Al+uOJOC55WKDKDpPEstX9f2DT0VrWFTN8IGSHFHqBzT+jgarZ3w
         pUXBnF9uTauzCkCyVxVwXlzLZ3o2cgjQherVLbn0BpSWi0QYP2SqpZXKjoAsxXX33x
         HgnAJYousPEnNTwMnOQ637OO3EWHlh/A0x9MAuabG6aUje51z7WFqqUB008icvXeWy
         3pip5sf/URdKg==
Date:   Wed, 11 Oct 2023 11:08:03 -0700
Subject: [PATCH 7/8] xfs: create helpers for rtsummary block/wordcount
 computations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704721736.1773834.4052037252966105617.stgit@frogsfrogsfrogs>
In-Reply-To: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create helper functions that compute the number of blocks or words
necessary to store the rt summary file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   29 +++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtbitmap.h |    7 +++++++
 fs/xfs/scrub/rtsummary.c     |    5 ++++-
 fs/xfs/xfs_rtalloc.c         |   17 +++++++----------
 4 files changed, 47 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index b2b1a1aec3422..be5c793da46c9 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1205,3 +1205,32 @@ xfs_rtbitmap_wordcount(
 	blocks = xfs_rtbitmap_blockcount(mp, rtextents);
 	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
 }
+
+/* Compute the number of rtsummary blocks needed to track the given rt space. */
+xfs_filblks_t
+xfs_rtsummary_blockcount(
+	struct xfs_mount	*mp,
+	unsigned int		rsumlevels,
+	xfs_extlen_t		rbmblocks)
+{
+	unsigned long long	rsumwords;
+
+	rsumwords = (unsigned long long)rsumlevels * rbmblocks;
+	return XFS_B_TO_FSB(mp, rsumwords << XFS_WORDLOG);
+}
+
+/*
+ * Compute the number of rtsummary info words needed to populate every block of
+ * a summary file that is large enough to track the given rt space.
+ */
+unsigned long long
+xfs_rtsummary_wordcount(
+	struct xfs_mount	*mp,
+	unsigned int		rsumlevels,
+	xfs_extlen_t		rbmblocks)
+{
+	xfs_filblks_t		blocks;
+
+	blocks = xfs_rtsummary_blockcount(mp, rsumlevels, rbmblocks);
+	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
+}
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 0a3c6299af8e2..a66357cf002be 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -270,6 +270,11 @@ xfs_rtword_t xfs_rtbitmap_getword(struct xfs_mount *mp,
 		union xfs_rtword_ondisk *wordptr);
 void xfs_rtbitmap_setword(struct xfs_mount *mp,
 		union xfs_rtword_ondisk *wordptr, xfs_rtword_t incore);
+
+xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
+		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
+unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
+		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
@@ -284,6 +289,8 @@ xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 	return 0;
 }
 # define xfs_rtbitmap_wordcount(mp, r)			(0)
+# define xfs_rtsummary_blockcount(mp, l, b)		(0)
+# define xfs_rtsummary_wordcount(mp, l, b)		(0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __XFS_RTBITMAP_H__ */
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 29cd26b7779d1..3fcf7de9f685f 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -41,6 +41,7 @@ xchk_setup_rtsummary(
 	struct xfs_mount	*mp = sc->mp;
 	char			*descr;
 	size_t			bufsize = mp->m_sb.sb_blocksize;
+	unsigned int		wordcnt;
 	unsigned int		resblks = 0;
 	int			error;
 
@@ -54,8 +55,10 @@ xchk_setup_rtsummary(
 	 * Create an xfile to construct a new rtsummary file.  The xfile allows
 	 * us to avoid pinning kernel memory for this purpose.
 	 */
+	wordcnt = xfs_rtsummary_wordcount(mp, mp->m_rsumlevels,
+			mp->m_sb.sb_rbmblocks);
 	descr = xchk_xfile_descr(sc, "realtime summary file");
-	error = xfile_create(descr, mp->m_rsumsize, &sc->xfile);
+	error = xfile_create(descr, wordcnt << XFS_WORDLOG, &sc->xfile);
 	kfree(descr);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 32e3ac40e28f7..2e7857a528408 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -999,8 +999,7 @@ xfs_growfs_rt(
 	nrbmblocks = xfs_rtbitmap_blockcount(mp, nrextents);
 	nrextslog = xfs_highbit32(nrextents);
 	nrsumlevels = nrextslog + 1;
-	nrsumsize = (uint)sizeof(xfs_suminfo_t) * nrsumlevels * nrbmblocks;
-	nrsumblocks = XFS_B_TO_FSB(mp, nrsumsize);
+	nrsumblocks = xfs_rtsummary_blockcount(mp, nrsumlevels, nrbmblocks);
 	nrsumsize = XFS_FSB_TO_B(mp, nrsumblocks);
 	/*
 	 * New summary size can't be more than half the size of
@@ -1061,10 +1060,8 @@ xfs_growfs_rt(
 		ASSERT(nsbp->sb_rextents != 0);
 		nsbp->sb_rextslog = xfs_highbit32(nsbp->sb_rextents);
 		nrsumlevels = nmp->m_rsumlevels = nsbp->sb_rextslog + 1;
-		nrsumsize =
-			(uint)sizeof(xfs_suminfo_t) * nrsumlevels *
-			nsbp->sb_rbmblocks;
-		nrsumblocks = XFS_B_TO_FSB(mp, nrsumsize);
+		nrsumblocks = xfs_rtsummary_blockcount(mp, nrsumlevels,
+				nsbp->sb_rbmblocks);
 		nmp->m_rsumsize = nrsumsize = XFS_FSB_TO_B(mp, nrsumblocks);
 		/*
 		 * Start a transaction, get the log reservation.
@@ -1270,6 +1267,7 @@ xfs_rtmount_init(
 	struct xfs_buf		*bp;	/* buffer for last block of subvolume */
 	struct xfs_sb		*sbp;	/* filesystem superblock copy in mount */
 	xfs_daddr_t		d;	/* address of last block of subvolume */
+	unsigned int		rsumblocks;
 	int			error;
 
 	sbp = &mp->m_sb;
@@ -1281,10 +1279,9 @@ xfs_rtmount_init(
 		return -ENODEV;
 	}
 	mp->m_rsumlevels = sbp->sb_rextslog + 1;
-	mp->m_rsumsize =
-		(uint)sizeof(xfs_suminfo_t) * mp->m_rsumlevels *
-		sbp->sb_rbmblocks;
-	mp->m_rsumsize = roundup(mp->m_rsumsize, sbp->sb_blocksize);
+	rsumblocks = xfs_rtsummary_blockcount(mp, mp->m_rsumlevels,
+			mp->m_sb.sb_rbmblocks);
+	mp->m_rsumsize = XFS_FSB_TO_B(mp, rsumblocks);
 	mp->m_rbmip = mp->m_rsumip = NULL;
 	/*
 	 * Check that the realtime section is an ok size.

