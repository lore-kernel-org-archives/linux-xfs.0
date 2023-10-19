Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF90CDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbjJSQ2W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbjJSQ2W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:28:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F139B
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:28:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85C2C433C7;
        Thu, 19 Oct 2023 16:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732899;
        bh=vNm3DntLJb9+i7yqkhHfG6slvctiX2rxeKjKHvr+fKY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Z35wigOQH4wY2064n+kk/zW/B5haOmSmLrfcQHxx5aKIX414AySzWOFomzNee0NJI
         hDpD8XdvCMIMuCkMOBMYsAE02kIADlEdKDg9G0bNXa/+zAj3+uN7sl9CAz+1Rcmrzz
         fJtpwc5hVgnkPwGou+PhDNa7XzGhAC5iw3QwZ/RURLOXfjmmWweYfit8n3gMVz2gvO
         90s6mGz+hNO1x56r5vGSlZ0EPWJ48fX6kId7N1g9q/a5d88pkRA0T46C2BhJdMFsq6
         tKCNwRNvbtxK3X3iznOvjbhhSPzp/bZdN7xEMVDbkp0hwtEC8RBudMSmwSFfQMnQAe
         lBqn+mQzQbxKw==
Date:   Thu, 19 Oct 2023 09:28:19 -0700
Subject: [PATCH 3/4] xfs: create helpers for rtsummary block/wordcount
 computations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773211390.225711.5386908694897644329.stgit@frogsfrogsfrogs>
In-Reply-To: <169773211338.225711.17480890063747608115.stgit@frogsfrogsfrogs>
References: <169773211338.225711.17480890063747608115.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   29 +++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtbitmap.h |    7 +++++++
 fs/xfs/xfs_rtalloc.c         |   17 +++++++----------
 3 files changed, 43 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index b81e4ffa1f44..fb05ea0177ec 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1146,3 +1146,32 @@ xfs_rtbitmap_wordcount(
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
index ede24de74620..a3e8288bedea 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -308,6 +308,11 @@ xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
 		rtextents);
 unsigned long long xfs_rtbitmap_wordcount(struct xfs_mount *mp,
 		xfs_rtbxlen_t rtextents);
+
+xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
+		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
+unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
+		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
@@ -322,6 +327,8 @@ xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 	return 0;
 }
 # define xfs_rtbitmap_wordcount(mp, r)			(0)
+# define xfs_rtsummary_blockcount(mp, l, b)		(0)
+# define xfs_rtsummary_wordcount(mp, l, b)		(0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __XFS_RTBITMAP_H__ */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 8e041df12640..3be6bda2fd92 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1001,8 +1001,7 @@ xfs_growfs_rt(
 	nrbmblocks = xfs_rtbitmap_blockcount(mp, nrextents);
 	nrextslog = xfs_highbit32(nrextents);
 	nrsumlevels = nrextslog + 1;
-	nrsumsize = (uint)sizeof(xfs_suminfo_t) * nrsumlevels * nrbmblocks;
-	nrsumblocks = XFS_B_TO_FSB(mp, nrsumsize);
+	nrsumblocks = xfs_rtsummary_blockcount(mp, nrsumlevels, nrbmblocks);
 	nrsumsize = XFS_FSB_TO_B(mp, nrsumblocks);
 	/*
 	 * New summary size can't be more than half the size of
@@ -1063,10 +1062,8 @@ xfs_growfs_rt(
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
@@ -1272,6 +1269,7 @@ xfs_rtmount_init(
 	struct xfs_buf		*bp;	/* buffer for last block of subvolume */
 	struct xfs_sb		*sbp;	/* filesystem superblock copy in mount */
 	xfs_daddr_t		d;	/* address of last block of subvolume */
+	unsigned int		rsumblocks;
 	int			error;
 
 	sbp = &mp->m_sb;
@@ -1283,10 +1281,9 @@ xfs_rtmount_init(
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

