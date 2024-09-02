Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AE519CC04
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301842; cv=none; b=e6KAJo2/s9ecst1UyqCjJR4cvd36jHeZ31Lz66xkl8dTMuBzTALVz1JPSsiRWm6WWtFSxpbgSQJpr6Y9b8EgUpaEBDLj+CVdzWOtLj8bXPnbrg2zwxEfaZInGSDrKDi0z+2vO7HMs2L9EWTP1/xWCRYIKXMqkFXqdcvX4XqWg7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301842; c=relaxed/simple;
	bh=GVq7uQQUr5RGKteM7Tq4sfkmxeNlMEzTKRSd9dNB5DI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V0tk2y8IzyfG8Co16bkARl3oSumR7jhDKQkmWo2Pnk3RKWEsnWM82aLf2/Y0e6mq7qjR6cob1gt+9C9HNbjCyrt96MRcE/zdjA3Qxiz/jHariGyMiLY82Wx1YdYc3cUJtmUD0Z9uURpoU11Muu4oiGT9JFrF4wbYOfalNPZVV7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LVBRI8bo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LVBRI8bo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2A6C4CEC2;
	Mon,  2 Sep 2024 18:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301841;
	bh=GVq7uQQUr5RGKteM7Tq4sfkmxeNlMEzTKRSd9dNB5DI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LVBRI8boU4qrjZBobTfSSmORVjyiZbURhWNOTYQg/wgxbn+yk89aVxI/A9MRuVFmt
	 3Pk3Zi2gNbbKyytOSNEFx3UyKW+oRstTlqlkrcGHLUekjFSkXq5Sojs3K6m9+3hZko
	 QgKXgtEe2MyRz5BoKS2At+T7h+MHb3FCUNjc70X4K41Q0IRLBW9PtzZ5W4ZcRDhSa4
	 6B5MZefHw9HI7acgJBKoIbeygftSi2Mybcg55krMUO0Z1nbyVKBVQeiFiTEv+9Nii/
	 7hb9Upjvak/JZz+lw3DFlcDMDIPj7BD/SZBcghidqU5/35m/kk+5APGrAV9xiGx8KF
	 f/T5NPWY7XhRA==
Date: Mon, 02 Sep 2024 11:30:41 -0700
Subject: [PATCH 04/10] xfs: factor out a xfs_rtallocate_align helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530106833.3326080.2641612257297215834.stgit@frogsfrogsfrogs>
In-Reply-To: <172530106749.3326080.9105141649726807892.stgit@frogsfrogsfrogs>
References: <172530106749.3326080.9105141649726807892.stgit@frogsfrogsfrogs>
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

Split the code to calculate the aligned allocation request from
xfs_bmap_rtalloc into a separate self-contained helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   93 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 59 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index a6b9ba572cdc..61e0c5b7a327 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1336,30 +1336,33 @@ xfs_rtallocate(
 	return error;
 }
 
-int
-xfs_bmap_rtalloc(
-	struct xfs_bmalloca	*ap)
+static int
+xfs_rtallocate_align(
+	struct xfs_bmalloca	*ap,
+	xfs_rtxlen_t		*ralen,
+	xfs_rtxlen_t		*raminlen,
+	xfs_rtxlen_t		*prod,
+	bool			*noalign)
 {
 	struct xfs_mount	*mp = ap->ip->i_mount;
 	xfs_fileoff_t		orig_offset = ap->offset;
-	xfs_rtxnum_t		start = 0;   /* allocation hint rtextent no */
-	xfs_rtxlen_t		prod = 0;  /* product factor for allocators */
-	xfs_extlen_t		mod = 0;   /* product factor for allocators */
-	xfs_rtxlen_t		ralen = 0; /* realtime allocation length */
-	xfs_extlen_t		align;     /* minimum allocation alignment */
-	xfs_extlen_t		orig_length = ap->length;
 	xfs_extlen_t		minlen = mp->m_sb.sb_rextsize;
-	xfs_rtxlen_t		raminlen;
-	bool			rtlocked = false;
+	xfs_extlen_t            align;	/* minimum allocation alignment */
+	xfs_extlen_t		mod;	/* product factor for allocators */
 	int			error;
 
-	align = xfs_get_extsz_hint(ap->ip);
-	if (!align)
-		align = 1;
-retry:
-	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
-					align, 1, ap->eof, 0,
-					ap->conv, &ap->offset, &ap->length);
+	if (*noalign) {
+		align = mp->m_sb.sb_rextsize;
+	} else {
+		align = xfs_get_extsz_hint(ap->ip);
+		if (!align)
+			align = 1;
+		if (align == mp->m_sb.sb_rextsize)
+			*noalign = true;
+	}
+
+	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev, align, 1,
+			ap->eof, 0, ap->conv, &ap->offset, &ap->length);
 	if (error)
 		return error;
 	ASSERT(ap->length);
@@ -1383,32 +1386,54 @@ xfs_bmap_rtalloc(
 	 * XFS_BMBT_MAX_EXTLEN), we don't hear about that number, and can't
 	 * adjust the starting point to match it.
 	 */
-	ralen = xfs_extlen_to_rtxlen(mp, min(ap->length, XFS_MAX_BMBT_EXTLEN));
-	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
-	ASSERT(raminlen > 0);
-	ASSERT(raminlen <= ralen);
-
-	if (xfs_bmap_adjacent(ap))
-		start = xfs_rtb_to_rtx(mp, ap->blkno);
+	*ralen = xfs_extlen_to_rtxlen(mp, min(ap->length, XFS_MAX_BMBT_EXTLEN));
+	*raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
+	ASSERT(*raminlen > 0);
+	ASSERT(*raminlen <= *ralen);
 
 	/*
 	 * Only bother calculating a real prod factor if offset & length are
 	 * perfectly aligned, otherwise it will just get us in trouble.
 	 */
 	div_u64_rem(ap->offset, align, &mod);
-	if (mod || ap->length % align) {
-		prod = 1;
-	} else {
-		prod = xfs_extlen_to_rtxlen(mp, align);
-		if (prod > 1)
-			xfs_rtalloc_align_minmax(&raminlen, &ralen, &prod);
-	}
+	if (mod || ap->length % align)
+		*prod = 1;
+	else
+		*prod = xfs_extlen_to_rtxlen(mp, align);
+
+	if (*prod > 1)
+		xfs_rtalloc_align_minmax(raminlen, ralen, prod);
+	return 0;
+}
+
+int
+xfs_bmap_rtalloc(
+	struct xfs_bmalloca	*ap)
+{
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	xfs_fileoff_t		orig_offset = ap->offset;
+	xfs_rtxnum_t		start = 0; /* allocation hint rtextent no */
+	xfs_rtxlen_t		prod = 0;  /* product factor for allocators */
+	xfs_rtxlen_t		ralen = 0; /* realtime allocation length */
+	xfs_extlen_t		orig_length = ap->length;
+	xfs_rtxlen_t		raminlen;
+	bool			rtlocked = false;
+	bool			noalign = false;
+	int			error;
+
+retry:
+	error = xfs_rtallocate_align(ap, &ralen, &raminlen, &prod, &noalign);
+	if (error)
+		return error;
+
+	if (xfs_bmap_adjacent(ap))
+		start = xfs_rtb_to_rtx(mp, ap->blkno);
 
 	error = xfs_rtallocate(ap->tp, start, raminlen, ralen, prod, ap->wasdel,
 			ap->datatype & XFS_ALLOC_INITIAL_USER_DATA, &rtlocked,
 			&ap->blkno, &ap->length);
 	if (error == -ENOSPC) {
-		if (align > mp->m_sb.sb_rextsize) {
+		if (!noalign) {
 			/*
 			 * We previously enlarged the request length to try to
 			 * satisfy an extent size hint.  The allocator didn't
@@ -1418,7 +1443,7 @@ xfs_bmap_rtalloc(
 			 */
 			ap->offset = orig_offset;
 			ap->length = orig_length;
-			minlen = align = mp->m_sb.sb_rextsize;
+			noalign = true;
 			goto retry;
 		}
 

