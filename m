Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E98F3C36
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372111; cv=none; b=C+wMk8TIVJaMcuJc8Gx4Oj9KMBhrxtYH9HyBgLp9ja2HmeHNH0O3DoEvy3yCNeFVwfVFrqbRjKqu+eNr+L99ROyfNcQ/S+fn9DxdKVBsA19qarsulWi8zdTdIGWLCpO6InHPxuT4K9NtlDFRwoxPjdp/BS1WgYkSQ4CtnoHNLbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372111; c=relaxed/simple;
	bh=0r5KbjMoN50bbZqPU7uuimt3YP9bqe9hH7T890jwL1U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J1dsVt4S32ERNn/LglECnHAKD49Sbvy23m8zglbsVGE6eobMWrQeAlddVw/ZN7r7BRkgeBwt1AWynb+US72QJaVb72BG7kQ2GX7YrCnynHWPY12NtJmdophBCECj545A9QIUavt3ssNn5c9Ru9+SsIkBh33RBK041d1DwgHk/aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i9J60lGy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i9J60lGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DD1C32782;
	Fri, 23 Aug 2024 00:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372111;
	bh=0r5KbjMoN50bbZqPU7uuimt3YP9bqe9hH7T890jwL1U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i9J60lGyzBbDi59p5Rm9xdS/ZtqkzZD7An8cY9UNdqG3dEtmnbKM5Tsde+4VvTSbn
	 jjYTsh9uP6ehgqIZvgXJymxFKW1gPuFi0e/QBQ9gKPDkUpExC/xVu1/nRK6tl1pIkS
	 F0h4tMzGiW5qJXSMhryAQNuiaadHLqk1k0T73RSl1Spcq78EQnq7WVZ+iazTOzWM5t
	 9ZFR3pDsufx7b3w2KQzZHWtHFttoR5l1mVb+RpW6F1jf50pJMR5GBfL6+Y8lrjFKy5
	 WhXGd1L1UALnSzn2Qrlq1BU/7Rf804U3qRY7un9d0aR2qup9zCQaA+VEg4czWQyHog
	 ZpWuyQQlrZNlg==
Date: Thu, 22 Aug 2024 17:15:10 -0700
Subject: [PATCH 02/24] xfs: factor out a xfs_rtallocate helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087277.59588.1424560489617257464.stgit@frogsfrogsfrogs>
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
index 4e7db8d4c0827..861a82471b5d0 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1269,6 +1269,51 @@ xfs_rtalloc_align_minmax(
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
@@ -1276,7 +1321,6 @@ xfs_bmap_rtalloc(
 	struct xfs_mount	*mp = ap->ip->i_mount;
 	xfs_fileoff_t		orig_offset = ap->offset;
 	xfs_rtxnum_t		start;	   /* allocation hint rtextent no */
-	xfs_rtxnum_t		rtx;	   /* actually allocated rtextent no */
 	xfs_rtxlen_t		prod = 0;  /* product factor for allocators */
 	xfs_extlen_t		mod = 0;   /* product factor for allocators */
 	xfs_rtxlen_t		ralen = 0; /* realtime allocation length */
@@ -1286,10 +1330,6 @@ xfs_bmap_rtalloc(
 	xfs_rtxlen_t		raminlen;
 	bool			rtlocked = false;
 	bool			ignore_locality = false;
-	struct xfs_rtalloc_args	args = {
-		.mp		= mp,
-		.tp		= ap->tp,
-	};
 	int			error;
 
 	align = xfs_get_extsz_hint(ap->ip);
@@ -1363,19 +1403,9 @@ xfs_bmap_rtalloc(
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
@@ -1403,20 +1433,9 @@ xfs_bmap_rtalloc(
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

