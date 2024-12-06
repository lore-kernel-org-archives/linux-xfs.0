Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD67148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529207; cv=none; b=qlyrRm+alZgMC82E1CyAxN7VlD3FPHrPRhqVhdBah1gcxprpmtv1Jq6oCJBpNOLBQ3t8EQxBXI3ghKLWlBBx8b6XDweWPWUcvAiPLfX9N2UuQ+hNpR0hZNU5rYbKZQfDb0BgzyBLowypjdpF2WmMoHB3MrW5fkfv5MMx7nBBTAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529207; c=relaxed/simple;
	bh=vcJCACUURCIlHVmoKBYPHHUSy8sf4SAFnqp85UOX8Lc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sq3aOC0NYvGzAlkTnQonM039TPY5vVQ38Vd2Ux/cqlCPmh2Qgj5SpT0UGk4FkaBz50MMDZ63OIf7xWwFRfm2rjrTE4vgjCyMPobwipsEwu10XMSNhq3XyHoeSMI8djhYciYFd/OZq6fAF51OyoH043FN80yxWDZ3IFF4afkowjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PPYT9y8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PPYT9y8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E2AC4CED1;
	Fri,  6 Dec 2024 23:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529207;
	bh=vcJCACUURCIlHVmoKBYPHHUSy8sf4SAFnqp85UOX8Lc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PPYT9y8+YXTEHySMdbVaG3TOffr2yGgegG6rLjRb2nJpGuESXBjd84DMxFFMu+nLb
	 W8dj+scWqOa0ojltGZkkGyvrnA7zzMmh1e1Y1TxX/t6KUKDVhebaY1c9so47V5haoc
	 AZUykOJ62mLQorVaihSBm403ejSxfFGlZsHTMpahOmg9/ZBFGe1Ud7fN4Kq+bEaOJe
	 j8r0CYg1YLTohwYGrQDgtK/ftiOnYZ+PoL0Ice5NXZRNWljDTGXpiBgxlM6Q4qfRnh
	 hkESGZMuOwC/NkOBoUMHjncFUTBHKKEqe++DGaI+wE4TbU9hFgdc2t8tHsa+QU90dW
	 b+6lHCq6/fqLg==
Date: Fri, 06 Dec 2024 15:53:27 -0800
Subject: [PATCH 08/46] xfs: refactor xfs_rtbitmap_blockcount
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750117.124560.2183969397595100729.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 5a7566c8d6b9b5c0aac34882f30448d29d9deafc

Rename the existing xfs_rtbitmap_blockcount to
xfs_rtbitmap_blockcount_len and add a new xfs_rtbitmap_blockcount wrapper
around it that takes the number of extents from the mount structure.

This will simplify the move to per-rtgroup bitmaps as those will need to
pass in the number of extents per rtgroup instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtbitmap.c   |   12 +++++++++++-
 libxfs/xfs_rtbitmap.h   |    7 ++++---
 libxfs/xfs_trans_resv.c |    2 +-
 3 files changed, 16 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index c686cd5309e87c..cebeef5134e666 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1147,13 +1147,23 @@ xfs_rtalloc_extent_is_free(
  * extents.
  */
 xfs_filblks_t
-xfs_rtbitmap_blockcount(
+xfs_rtbitmap_blockcount_len(
 	struct xfs_mount	*mp,
 	xfs_rtbxlen_t		rtextents)
 {
 	return howmany_64(rtextents, NBBY * mp->m_sb.sb_blocksize);
 }
 
+/*
+ * Compute the number of rtbitmap blocks used for a given file system.
+ */
+xfs_filblks_t
+xfs_rtbitmap_blockcount(
+	struct xfs_mount	*mp)
+{
+	return xfs_rtbitmap_blockcount_len(mp, mp->m_sb.sb_rextents);
+}
+
 /* Compute the number of rtsummary blocks needed to track the given rt space. */
 xfs_filblks_t
 xfs_rtsummary_blockcount(
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index e4994a3e461d33..58672863053a94 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -307,8 +307,9 @@ int xfs_rtfree_extent(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 int xfs_rtfree_blocks(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 		xfs_fsblock_t rtbno, xfs_filblks_t rtlen);
 
-xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
-		rtextents);
+xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp);
+xfs_filblks_t xfs_rtbitmap_blockcount_len(struct xfs_mount *mp,
+		xfs_rtbxlen_t rtextents);
 xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
 		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
 
@@ -336,7 +337,7 @@ static inline int xfs_rtfree_blocks(struct xfs_trans *tp,
 # define xfs_rtbuf_cache_relse(a)			(0)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
 static inline xfs_filblks_t
-xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
+xfs_rtbitmap_blockcount_len(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 {
 	/* shut up gcc */
 	return 0;
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 3da18fb4027420..93047e149693d6 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -221,7 +221,7 @@ xfs_rtalloc_block_count(
 	xfs_rtxlen_t		rtxlen;
 
 	rtxlen = xfs_extlen_to_rtxlen(mp, XFS_MAX_BMBT_EXTLEN);
-	rtbmp_blocks = xfs_rtbitmap_blockcount(mp, rtxlen);
+	rtbmp_blocks = xfs_rtbitmap_blockcount_len(mp, rtxlen);
 	return (rtbmp_blocks + 1) * num_ops;
 }
 

