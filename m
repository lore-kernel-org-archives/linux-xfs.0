Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAF5BA46
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372142; cv=none; b=Ybas4AKq2IPK+j+v3mOHgobauTVGHJhG6NYSqTT2RIsPXTKVG/v/T23F42IXt1r/l6FG8MLGqMcLwVsn3zjFXr0EGhO4MvB4fPfqH8gy+5oiGRao08q3aiVKsqpayp633krBUFN0AklcK+4AAKaC0Qm86xwiHXQGT4yMnrnepfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372142; c=relaxed/simple;
	bh=Gweqe2aN+DAQAwGJx5MI6dQddJVJLULbkJil+45r5pA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QIBhYvA30JSn1RQj34QE6DE2RDKmFzFCs1vnHHp3BR/9209GIGtza7/JWsq6E2lTqVH5ffMJtwaX7r1+abp2Zv1JH3kik6mkg8tJKwTEIjd3vY1Ggy46+I5Ethq5HIyC6NIny6PJdFhVYnylXO6FpP20oSm7MqxyATWnF1EHyC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pZa3eIiB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pZa3eIiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC88C32782;
	Fri, 23 Aug 2024 00:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372142;
	bh=Gweqe2aN+DAQAwGJx5MI6dQddJVJLULbkJil+45r5pA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pZa3eIiBCBNIhio/MB+ydZUNCnYguN1LX/ket1gCv79BbKvsBtJPvBXHOb3pyq+tV
	 tYXeNr4gIg4nleVAcr8HW7bl2OWlnBe2LOckg3wp4KcjUNJ6KuGVszvMVFcR2JFytm
	 i0JMDXBUmS3rDonROJSFxalC7lT1TH7xeFrpj4rZirfEX7/yMsL8ElgaPyETUk86LY
	 oQiSOYNneYkzwTudF8oDpDiHWRB/vUF8vkgQKUhNFqlFhyCSed+9GNHdZH8S1R6zMh
	 F9tapV2iNivznnhbwlYCwIpzxC7cFUfvBT7LaIslFwHn0pblNMJnFTU5Qo6bFxEoGA
	 T4+xbQVOd8q0g==
Date: Thu, 22 Aug 2024 17:15:41 -0700
Subject: [PATCH 04/24] xfs: factor out a xfs_rtallocate_align helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087312.59588.11806080366381184380.stgit@frogsfrogsfrogs>
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

Split the code to calculate the aligned allocation request from
xfs_bmap_rtalloc into a separate self-contained helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   93 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 59 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index f39f05397201a..7f20bc412d074 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1342,30 +1342,33 @@ xfs_rtallocate(
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
@@ -1389,32 +1392,54 @@ xfs_bmap_rtalloc(
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
@@ -1424,7 +1449,7 @@ xfs_bmap_rtalloc(
 			 */
 			ap->offset = orig_offset;
 			ap->length = orig_length;
-			minlen = align = mp->m_sb.sb_rextsize;
+			noalign = true;
 			goto retry;
 		}
 

