Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4872CA9
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548499; cv=none; b=EjMNDjF68+4B9B/F4FaBR8+7lG9iTG9Kg2MTI1Jx/pfPuNgn6ZBHw2onXpx4+vZvYqmwPros8WBHtUdi2c0GmCjqdYGBzHu6zq7cEPbZIaJoEsM2HTVNHxU/CJfJR8gc2yukbLD5WOXxYmlm4Ro63MGEKTee6Xa9MMSxj1hLm1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548499; c=relaxed/simple;
	bh=gljjXFH81UV8Kku1UmvWTGlfcPv4duH1tPlozJDvJC4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XV1fgElfjpCYtahlg6ksUGh7EmJG89Qk3aRCdQy2KqtM/D0vtfHMjwsNk3Wtcn2GUdu2g+Cti2rn/U7TB0ez6T2DYuQSPcoPtMKtGdPNCdPhSk+rvJvqHAQKF24ahFiOIjI8oaU4tsbHdaXTod/muTFEMDEa1tIDCH+XPRudRoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ic/N7tmj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ic/N7tmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67159C4CEC3;
	Mon, 21 Oct 2024 22:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548499;
	bh=gljjXFH81UV8Kku1UmvWTGlfcPv4duH1tPlozJDvJC4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ic/N7tmjToX4BSVw3h08Ak1ssBbf/MAyC9zvD/L3li8DE9vj1NApvcqGdnTl7LuNF
	 mLdB25ZsG/lijkHQCQkSpnbpCtp4PCu6gSsw1t8fC1aiMiEDHq+OWRQQ/SwzwQNsnU
	 5e8Aau17QG1pG8BKk2k7BLpLkdbiPtFA/IPfmzTDHjfDDC/NdDJOHBA9i8MFLHfy2S
	 2/vn1HFnZH89E6OBCe0fl0U26tqJobfnwwpd165itCvsXlY+dIAC1dNtsZGawk04IW
	 fnO/tNpnvwel20RM+5bhahN3bsPNo04P3EMI4MAnbdp5jyqz4JDzjLsNg++FizDXfY
	 C2HkyXiRG6mkQ==
Date: Mon, 21 Oct 2024 15:08:18 -0700
Subject: [PATCH 36/37] xfs: call xfs_bmap_exact_minlen_extent_alloc from
 xfs_bmap_btalloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954784016.34558.2635913694225058412.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 405ee87c6938f67e6ab62a3f8f85b3c60a093886

xfs_bmap_exact_minlen_extent_alloc duplicates the args setup in
xfs_bmap_btalloc.  Switch to call it from xfs_bmap_btalloc after
doing the basic setup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_bmap.c |   61 +++++++++++------------------------------------------
 1 file changed, 13 insertions(+), 48 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 3c4922424f3fd0..02f26854c53cfe 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3473,28 +3473,17 @@ xfs_bmap_process_allocated_extent(
 
 static int
 xfs_bmap_exact_minlen_extent_alloc(
-	struct xfs_bmalloca	*ap)
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args)
 {
-	struct xfs_mount	*mp = ap->ip->i_mount;
-	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
-	xfs_fileoff_t		orig_offset;
-	xfs_extlen_t		orig_length;
-	int			error;
-
-	ASSERT(ap->length);
-
 	if (ap->minlen != 1) {
-		ap->blkno = NULLFSBLOCK;
-		ap->length = 0;
+		args->fsbno = NULLFSBLOCK;
 		return 0;
 	}
 
-	orig_offset = ap->offset;
-	orig_length = ap->length;
-
-	args.alloc_minlen_only = 1;
-
-	xfs_bmap_compute_alignments(ap, &args);
+	args->alloc_minlen_only = 1;
+	args->minlen = args->maxlen = ap->minlen;
+	args->total = ap->total;
 
 	/*
 	 * Unlike the longest extent available in an AG, we don't track
@@ -3504,33 +3493,9 @@ xfs_bmap_exact_minlen_extent_alloc(
 	 * we need not be concerned about a drop in performance in
 	 * "debug only" code paths.
 	 */
-	ap->blkno = XFS_AGB_TO_FSB(mp, 0, 0);
+	ap->blkno = XFS_AGB_TO_FSB(ap->ip->i_mount, 0, 0);
 
-	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
-	args.minlen = args.maxlen = ap->minlen;
-	args.total = ap->total;
-
-	args.alignment = 1;
-	args.minalignslop = 0;
-
-	args.minleft = ap->minleft;
-	args.wasdel = ap->wasdel;
-	args.resv = XFS_AG_RESV_NONE;
-	args.datatype = ap->datatype;
-
-	error = xfs_alloc_vextent_first_ag(&args, ap->blkno);
-	if (error)
-		return error;
-
-	if (args.fsbno != NULLFSBLOCK) {
-		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
-			orig_length);
-	} else {
-		ap->blkno = NULLFSBLOCK;
-		ap->length = 0;
-	}
-
-	return 0;
+	return xfs_alloc_vextent_first_ag(args, ap->blkno);
 }
 
 /*
@@ -3789,8 +3754,11 @@ xfs_bmap_btalloc(
 	/* Trim the allocation back to the maximum an AG can fit. */
 	args.maxlen = min(ap->length, mp->m_ag_max_usable);
 
-	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
-	    xfs_inode_is_filestream(ap->ip))
+	if (unlikely(XFS_TEST_ERROR(false, mp,
+			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
+		error = xfs_bmap_exact_minlen_extent_alloc(ap, &args);
+	else if ((ap->datatype & XFS_ALLOC_USERDATA) &&
+			xfs_inode_is_filestream(ap->ip))
 		error = xfs_bmap_btalloc_filestreams(ap, &args, stripe_align);
 	else
 		error = xfs_bmap_btalloc_best_length(ap, &args, stripe_align);
@@ -4205,9 +4173,6 @@ xfs_bmapi_allocate(
 	if ((bma->datatype & XFS_ALLOC_USERDATA) &&
 	    XFS_IS_REALTIME_INODE(bma->ip))
 		error = xfs_bmap_rtalloc(bma);
-	else if (unlikely(XFS_TEST_ERROR(false, mp,
-			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
-		error = xfs_bmap_exact_minlen_extent_alloc(bma);
 	else
 		error = xfs_bmap_btalloc(bma);
 	if (error)

