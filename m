Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BAB1F4706
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529520; cv=none; b=ZH0IgVZ9HymwN8WJZPj6IxfBkEFqVS0a4h5VM2LKQo9+yWfUAot18fJ1lJILs7IGNoaLWgvyhzHIBc3FCox1Nf0Dej6g7PYV/9Zccu9OuU4jT82YsHlycK77uYQAkxUNoj9BeQacWmtnOjtuyIy5+a7Pxqg09CIaYQ59I44ZLVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529520; c=relaxed/simple;
	bh=bp+WQqStJ4GYY1rGGtj2Cl5f8T3w5MIGlmLjMI4r4UU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sFW7Wbr0QlKvboTK9tusZBrz9a58AB0E8BFfshp+178+8FJAZd4xArqxBbY/MjwodNeB11pBl4SStYbIriuIzeZoRQ4wkPcQAPC98xICUOVeGVnAD5FhFGW3Q1Gc2Wr7grqYJEd2v9WVMUEoTSQz4SYseMhmkcSpkQFxHdkQ1+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZEcVJSNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZEcVJSNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44B1C4CED1;
	Fri,  6 Dec 2024 23:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529519;
	bh=bp+WQqStJ4GYY1rGGtj2Cl5f8T3w5MIGlmLjMI4r4UU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZEcVJSNSNjZTnRUPt4RUArH0dzmGJgnK7mlcpC4pOxnr5/PZijnwuKBw95hj9OnDz
	 FYHYsPpwWn7lcTHYEa0rcheztRM01SGjrU8kJ19SoDi+ZHfOEp9tILCCABVz0zJ6aX
	 18/8c1MvKTlyw7O0kWMIcNl1YONnmN8n6+pw+zmLlMZ4PVsMMphfd+hvq28JRKuFa7
	 8musD25fWkRfFYn5ZHJ9il5QkCxTlcgaZ63SMkTMT1ADWBotAbJrHpNsAryT6iNvsw
	 AJ9w7t5jkK7Tgh/9oLSBfsfmidA3HlecAIMZAW0+Nkle7E8mqC51umq42usv/knKDd
	 vu1Jb3MF0z2MA==
Date: Fri, 06 Dec 2024 15:58:39 -0800
Subject: [PATCH 28/46] xfs: make the RT allocator rtgroup aware
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750423.124560.7682390390340484885.stgit@frogsfrogsfrogs>
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

Source kernel commit: d162491c5459f4dd72e65b72a2c864591668ec07

Make the allocator rtgroup aware by either picking a specific group if
there is a hint, or loop over all groups otherwise.  A simple rotor is
provided to pick the placement for initial allocations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c     |   13 +++++++++++--
 libxfs/xfs_rtbitmap.c |    6 ++++--
 2 files changed, 15 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index bdede0e683ae91..60310d3c1074c8 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3145,8 +3145,17 @@ xfs_bmap_adjacent_valid(
 	struct xfs_mount	*mp = ap->ip->i_mount;
 
 	if (XFS_IS_REALTIME_INODE(ap->ip) &&
-	    (ap->datatype & XFS_ALLOC_USERDATA))
-		return x < mp->m_sb.sb_rblocks;
+	    (ap->datatype & XFS_ALLOC_USERDATA)) {
+		if (x >= mp->m_sb.sb_rblocks)
+			return false;
+		if (!xfs_has_rtgroups(mp))
+			return true;
+
+		return xfs_rtb_to_rgno(mp, x) == xfs_rtb_to_rgno(mp, y) &&
+			xfs_rtb_to_rgno(mp, x) < mp->m_sb.sb_rgcount &&
+			xfs_rtb_to_rtx(mp, x) < mp->m_sb.sb_rgextents;
+
+	}
 
 	return XFS_FSB_TO_AGNO(mp, x) == XFS_FSB_TO_AGNO(mp, y) &&
 		XFS_FSB_TO_AGNO(mp, x) < mp->m_sb.sb_agcount &&
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index b6874885107f09..44c801f31d5dc3 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1080,11 +1080,13 @@ xfs_rtfree_extent(
 	 * Mark more blocks free in the superblock.
 	 */
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_FREXTENTS, (long)len);
+
 	/*
 	 * If we've now freed all the blocks, reset the file sequence
-	 * number to 0.
+	 * number to 0 for pre-RTG file systems.
 	 */
-	if (tp->t_frextents_delta + mp->m_sb.sb_frextents ==
+	if (!xfs_has_rtgroups(mp) &&
+	    tp->t_frextents_delta + mp->m_sb.sb_frextents ==
 	    mp->m_sb.sb_rextents) {
 		if (!(rbmip->i_diflags & XFS_DIFLAG_NEWRTBM))
 			rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;

