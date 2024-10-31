Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE9919F430
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416404; cv=none; b=G61U1aPQUb++w8OM26jjztCH85iwyYi+OPxH7bTv9h/bYhxuCRH2qvBMBtLzM5a5zObrCXwtYKJW674DQv69y1SDdo8qTG/H+8mCPM9t79gE283aopIW3Xx4fT6kPCYkb4pULg+wr5ZEyi5tj8HY568Gddv5VOtx0Ih1Y4ywlsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416404; c=relaxed/simple;
	bh=oG+f4AX5lGEUmIbRkYV4kNB8pd7rIdbFVAcjbDq1x/A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q5dE5n1cPWUN63gLgcaCJ1j8cGSiR8dqz84pKYIgaqXMpIFNF6FeH+0YOCLOfAmX4Y99MUYRxxt/sP43PnZ4oz4GTlUTTcjeuCsW8JF7t93I3WJpNZedgyLDVvb5WY5mqXqFN4YX1zDVGO4CuJ8WW4J30EIAMNfGPzqmwhDqCK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ci26pZPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ci26pZPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7147C4CECF;
	Thu, 31 Oct 2024 23:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416403;
	bh=oG+f4AX5lGEUmIbRkYV4kNB8pd7rIdbFVAcjbDq1x/A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ci26pZPqqazNXERmAEJY3Tu3+DnPVcDs24wEZH3bXBWEpF2XQpaI0WCc4COU+YNG0
	 86WVduZzyKDnag4vQAGBc6lo9d5yUsR+tlowNQyEQhVsnjmPqDdG+pABbgA8kR1DUE
	 JJRP+GxbI2ES9TutDm5dbARSAgPHbwBcQJ3ZqawnHREa6S8/YNicr7DD6BSuZW6wNu
	 +zSt42Gz7d5zwPZ7CcAcjm8/I+pUogTeftnT4ll4PceinrqfhVYEfH9gMjcdNxgrSe
	 Uvef1KTAB7dooJqkAA5di+nz/o9MUAOGTlx2n/SdvzHBANMtLnthF3Es5BxFwttjsa
	 v3mdEVALf0U7A==
Date: Thu, 31 Oct 2024 16:13:23 -0700
Subject: [PATCH 18/41] xfs: remove xfs_{rtbitmap,rtsummary}_wordcount
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566192.962545.17596134285171375124.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 1fc51cf11dd8b26856ae1c4111e402caec73019c

xfs_rtbitmap_wordcount and xfs_rtsummary_wordcount are currently unused,
so remove them to simplify refactoring other rtbitmap helpers.  They
can be added back or simply open coded when actually needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c            |    3 +--
 libxfs/xfs_rtbitmap.c |   31 -------------------------------
 libxfs/xfs_rtbitmap.h |    7 -------
 repair/rt.c           |    5 ++---
 4 files changed, 3 insertions(+), 43 deletions(-)


diff --git a/db/check.c b/db/check.c
index bceaf318d75ed8..00ef3c1d4b508c 100644
--- a/db/check.c
+++ b/db/check.c
@@ -1958,8 +1958,7 @@ init(
 
 		dbmap[c] = xcalloc(mp->m_sb.sb_rblocks, sizeof(**dbmap));
 		inomap[c] = xcalloc(mp->m_sb.sb_rblocks, sizeof(**inomap));
-		words = libxfs_rtsummary_wordcount(mp, mp->m_rsumlevels,
-				mp->m_sb.sb_rbmblocks);
+		words = mp->m_rsumsize >> XFS_WORDLOG;
 		sumfile = xcalloc(words, sizeof(union xfs_suminfo_raw));
 		sumcompute = xcalloc(words, sizeof(union xfs_suminfo_raw));
 	}
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 3f534a4724a26b..1c657da907132e 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1146,21 +1146,6 @@ xfs_rtbitmap_blockcount(
 	return howmany_64(rtextents, NBBY * mp->m_sb.sb_blocksize);
 }
 
-/*
- * Compute the number of rtbitmap words needed to populate every block of a
- * bitmap that is large enough to track the given number of rt extents.
- */
-unsigned long long
-xfs_rtbitmap_wordcount(
-	struct xfs_mount	*mp,
-	xfs_rtbxlen_t		rtextents)
-{
-	xfs_filblks_t		blocks;
-
-	blocks = xfs_rtbitmap_blockcount(mp, rtextents);
-	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
-}
-
 /* Compute the number of rtsummary blocks needed to track the given rt space. */
 xfs_filblks_t
 xfs_rtsummary_blockcount(
@@ -1174,22 +1159,6 @@ xfs_rtsummary_blockcount(
 	return XFS_B_TO_FSB(mp, rsumwords << XFS_WORDLOG);
 }
 
-/*
- * Compute the number of rtsummary info words needed to populate every block of
- * a summary file that is large enough to track the given rt space.
- */
-unsigned long long
-xfs_rtsummary_wordcount(
-	struct xfs_mount	*mp,
-	unsigned int		rsumlevels,
-	xfs_extlen_t		rbmblocks)
-{
-	xfs_filblks_t		blocks;
-
-	blocks = xfs_rtsummary_blockcount(mp, rsumlevels, rbmblocks);
-	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
-}
-
 /* Lock both realtime free space metadata inodes for a freespace update. */
 void
 xfs_rtbitmap_lock(
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 0dbc9bb40668a2..140513d1d6bcf1 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -316,13 +316,8 @@ int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 
 xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
 		rtextents);
-unsigned long long xfs_rtbitmap_wordcount(struct xfs_mount *mp,
-		xfs_rtbxlen_t rtextents);
-
 xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
 		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
-unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
-		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
 
 int xfs_rtfile_initialize_blocks(struct xfs_inode *ip,
 		xfs_fileoff_t offset_fsb, xfs_fileoff_t end_fsb, void *data);
@@ -355,9 +350,7 @@ xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 	/* shut up gcc */
 	return 0;
 }
-# define xfs_rtbitmap_wordcount(mp, r)			(0)
 # define xfs_rtsummary_blockcount(mp, l, b)		(0)
-# define xfs_rtsummary_wordcount(mp, l, b)		(0)
 # define xfs_rtbitmap_lock(mp)			do { } while (0)
 # define xfs_rtbitmap_trans_join(tp)		do { } while (0)
 # define xfs_rtbitmap_unlock(mp)		do { } while (0)
diff --git a/repair/rt.c b/repair/rt.c
index 4c81e2114c7735..879946ab0b154e 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -27,14 +27,13 @@ rtinit(xfs_mount_t *mp)
 	 * information.  The rtbitmap buffer must be large enough to compare
 	 * against any unused bytes in the last block of the file.
 	 */
-	wordcnt = libxfs_rtbitmap_wordcount(mp, mp->m_sb.sb_rextents);
+	wordcnt = XFS_FSB_TO_B(mp, mp->m_sb.sb_rbmblocks) >> XFS_WORDLOG;
 	btmcompute = calloc(wordcnt, sizeof(union xfs_rtword_raw));
 	if (!btmcompute)
 		do_error(
 	_("couldn't allocate memory for incore realtime bitmap.\n"));
 
-	wordcnt = libxfs_rtsummary_wordcount(mp, mp->m_rsumlevels,
-			mp->m_sb.sb_rbmblocks);
+	wordcnt = mp->m_rsumsize >> XFS_WORDLOG;
 	sumcompute = calloc(wordcnt, sizeof(union xfs_suminfo_raw));
 	if (!sumcompute)
 		do_error(

