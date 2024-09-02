Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31421A303C
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301811; cv=none; b=Dk/E5CpytkUrUO4jGoY+5ZPUK6vbyNfss8DGt9zGlAtAA/Sy+sJ291PD/cFgv4UBk9MdDWjJkgx1cf0sypdS94QXqTkeq+wEXm2f8OoZ3HYQB0WhzfHvFL7/SIol7E2ADM9eV8EE2oHu94Lg5IjNfTbws2C9ZmGrFIPGpLt9Aec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301811; c=relaxed/simple;
	bh=ziRhO4LritZ4KdIg66JYOtGa4b9U4d82fqN54FxyFng=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fmYAYNGTpMkJnkumXoVVw2R6X0AVYOjCzXRPprj09vC4ShQ6mOYXBOttHp5DwQEsnanO92PPADiqGUuhfWWJB390OLNLz3jeHFlzEOjehuaWQY0lGqnY0y5rJql0F0MpxTFVAbbkDgY/vNPgAR1SohYcTpcJi7hVNZEsUTRMtY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f0gKwfi/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f0gKwfi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DC5C4CEC2;
	Mon,  2 Sep 2024 18:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301810;
	bh=ziRhO4LritZ4KdIg66JYOtGa4b9U4d82fqN54FxyFng=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=f0gKwfi/BSpSMmHLvvtCWv+7O+4mpYJTa4pr46XlVQK/KMim834ybrKgjvCUGqETK
	 /PSv2z9fJ0jobM3OHjeoLu+yhSyN+mIqGLcyRbo3ZQCLV6/BxLhwVT3cDUaQ2m3+jr
	 V5LRTUbVx1u8w+MAPWxVZPszmGm25VRDzYSSnWIAv8aleaazjT13QP/G4nMRRHzMHC
	 wmO1yJCK9/dpaTrs5Q24NUmuDqhBnt+8RwePWcmYZNIUh9+8xMYt3ykMzNv/nllnL4
	 +Hhf86Rt1Ki+rKPh9uhkm1+1p5fB1kzkskwCpHikzDUVa9dlCrhp1phxMBTi1ay5CL
	 V2jk8OiJ08RSw==
Date: Mon, 02 Sep 2024 11:30:10 -0700
Subject: [PATCH 02/10] xfs: factor out a xfs_rtallocate helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530106801.3326080.14582295004318273135.stgit@frogsfrogsfrogs>
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

Split out a helper from xfs_rtallocate that performs the actual
allocation.  This keeps the scope of the xfs_rtalloc_args structure
contained, and prepares for rtgroups support.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   81 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 50 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 72123e2337d8..12cf7cb3c02c 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1263,6 +1263,51 @@ xfs_rtalloc_align_minmax(
 	*raminlen = newminlen;
 }
 
+static int
+xfs_rtallocate(
+	struct xfs_trans	*tp,
+	xfs_rtxnum_t		start,
+	xfs_rtxlen_t		minlen,
+	xfs_rtxlen_t		maxlen,
+	xfs_rtxlen_t		prod,
+	bool			wasdel,
+	xfs_rtblock_t		*bno,
+	xfs_extlen_t		*blen)
+{
+	struct xfs_rtalloc_args	args = {
+		.mp		= tp->t_mountp,
+		.tp		= tp,
+	};
+	xfs_rtxnum_t		rtx;
+	xfs_rtxlen_t		len = 0;
+	int			error;
+
+	if (start) {
+		error = xfs_rtallocate_extent_near(&args, start, minlen, maxlen,
+				&len, prod, &rtx);
+	} else {
+		error = xfs_rtallocate_extent_size(&args, minlen, maxlen, &len,
+				prod, &rtx);
+	}
+
+	if (error)
+		goto out_release;
+
+	error = xfs_rtallocate_range(&args, rtx, len);
+	if (error)
+		goto out_release;
+
+	xfs_trans_mod_sb(tp, wasdel ?
+			XFS_TRANS_SB_RES_FREXTENTS : XFS_TRANS_SB_FREXTENTS,
+			-(long)len);
+	*bno = xfs_rtx_to_rtb(args.mp, rtx);
+	*blen = xfs_rtxlen_to_extlen(args.mp, len);
+
+out_release:
+	xfs_rtbuf_cache_relse(&args);
+	return error;
+}
+
 int
 xfs_bmap_rtalloc(
 	struct xfs_bmalloca	*ap)
@@ -1270,7 +1315,6 @@ xfs_bmap_rtalloc(
 	struct xfs_mount	*mp = ap->ip->i_mount;
 	xfs_fileoff_t		orig_offset = ap->offset;
 	xfs_rtxnum_t		start;	   /* allocation hint rtextent no */
-	xfs_rtxnum_t		rtx;	   /* actually allocated rtextent no */
 	xfs_rtxlen_t		prod = 0;  /* product factor for allocators */
 	xfs_extlen_t		mod = 0;   /* product factor for allocators */
 	xfs_rtxlen_t		ralen = 0; /* realtime allocation length */
@@ -1280,10 +1324,6 @@ xfs_bmap_rtalloc(
 	xfs_rtxlen_t		raminlen;
 	bool			rtlocked = false;
 	bool			ignore_locality = false;
-	struct xfs_rtalloc_args	args = {
-		.mp		= mp,
-		.tp		= ap->tp,
-	};
 	int			error;
 
 	align = xfs_get_extsz_hint(ap->ip);
@@ -1357,19 +1397,9 @@ xfs_bmap_rtalloc(
 			xfs_rtalloc_align_minmax(&raminlen, &ralen, &prod);
 	}
 
-	if (start) {
-		error = xfs_rtallocate_extent_near(&args, start, raminlen,
-				ralen, &ralen, prod, &rtx);
-	} else {
-		error = xfs_rtallocate_extent_size(&args, raminlen,
-				ralen, &ralen, prod, &rtx);
-	}
-
-	if (error) {
-		xfs_rtbuf_cache_relse(&args);
-		if (error != -ENOSPC)
-			return error;
-
+	error = xfs_rtallocate(ap->tp, start, raminlen, ralen, prod, ap->wasdel,
+			       &ap->blkno, &ap->length);
+	if (error == -ENOSPC) {
 		if (align > mp->m_sb.sb_rextsize) {
 			/*
 			 * We previously enlarged the request length to try to
@@ -1397,20 +1427,9 @@ xfs_bmap_rtalloc(
 		ap->length = 0;
 		return 0;
 	}
-
-	error = xfs_rtallocate_range(&args, rtx, ralen);
 	if (error)
-		goto out_release;
+		return error;
 
-	xfs_trans_mod_sb(ap->tp, ap->wasdel ?
-			XFS_TRANS_SB_RES_FREXTENTS : XFS_TRANS_SB_FREXTENTS,
-			-(long)ralen);
-
-	ap->blkno = xfs_rtx_to_rtb(mp, rtx);
-	ap->length = xfs_rtxlen_to_extlen(mp, ralen);
 	xfs_bmap_alloc_account(ap);
-
-out_release:
-	xfs_rtbuf_cache_relse(&args);
-	return error;
+	return 0;
 }

