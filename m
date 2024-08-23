Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EFFB662
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372189; cv=none; b=gGH7Hh8fXQl/+3FHcgS85CMjnGGekVDOrAHl3qbvDNnvdGDtQLaDmw8gVTngZ2U81fQHYBhFOHKCRzQxCK0bKaC3gkd3MbS+sB5N1fKzo1pvi0uZPrg2rtf+6Poj5RtPPjZJmRuLZFk4arMZVgsS48lARnQM5imCa8o+T5NAz48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372189; c=relaxed/simple;
	bh=CjoKqodlPqZh0BP2v2A2PbXkXVSDyNgI5r0LbN9nPBg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CDwEOSwDeOQoEruO9o+tLBCYnQRKJ8MCp9nHMKWPC39FgxXFbQRSZ1pRQ2QXUmGO61YV6oqE+ZUw7epNVfL5w4cziVKLfFh81IgHWMoxkxCWbnxz9oMTiW8B5SKQQe3r3KK4zhGbhphFtrgcNguK3FUx6eeFs54t3atkhzblSHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bJ28JFGP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bJ28JFGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A9AC32782;
	Fri, 23 Aug 2024 00:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372189;
	bh=CjoKqodlPqZh0BP2v2A2PbXkXVSDyNgI5r0LbN9nPBg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bJ28JFGPqkAP+Zy9ESee6IkmEhOb+Uc+jyijaVA1XES82upv0Un6z/5SRAp5JCNlv
	 8a4P5I2MQv/dnsaNVtWMpUMPaHW6qYeXRE+XJLeC3hNhxC/lSfEhpZBsegYrvYw28c
	 ef2C4SA1jb2LuJ125tXF21fLnqW+b/g6m3j445+6/3ZrzBI5PRwjhRey9QJYcqkOkI
	 r+NyJnmgp9Q6awpca54maEzSCeovaAS+zsQKAFDpGqqTSWDxcjdUVpoZEbFTYzguZx
	 lTZeXP9q7JIjeKZIkaW2DCLmp9XwX44h+wC/a1Bowp5LnBXJytfKR/NQGwm3qJm1w1
	 b9wTKwyus8GrQ==
Date: Thu, 22 Aug 2024 17:16:28 -0700
Subject: [PATCH 07/24] xfs: remove xfs_{rtbitmap,rtsummary}_wordcount
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087363.59588.1958048546474059875.stgit@frogsfrogsfrogs>
In-Reply-To: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

xfs_rtbitmap_wordcount and xfs_rtsummary_wordcount are currently unused,
so remove them to simplify refactoring other rtbitmap helpers.  They
can be added back or simply open coded when actually needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   31 -------------------------------
 fs/xfs/libxfs/xfs_rtbitmap.h |    7 -------
 2 files changed, 38 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index c58eb75ef0fa0..76706e8bbc4ea 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1148,21 +1148,6 @@ xfs_rtbitmap_blockcount(
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
@@ -1176,22 +1161,6 @@ xfs_rtsummary_blockcount(
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
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 0dbc9bb40668a..140513d1d6bcf 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
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

