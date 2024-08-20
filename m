Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2823D1922D3
	for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2024 17:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724173539; cv=none; b=Vwk2lmlnmm3rixMviNkqs++TeYXZy4yGOpWtbu6KBpfCvkoG3TWOL+y9f6LleHCrVv6pOGl12n6gFowpu4U3ntfK9qvszUkTl8BHxYBAmqesdyBH2BlKLa/lUVqab3d2WbHNFPnjqBDGblmvglkrGqMb07DscPPYHo3lntp4ED4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724173539; c=relaxed/simple;
	bh=m9tTEfylWBuO14G9tpxvTKkcICbwxmU6zr2kJRLTc9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuXuoVt9Ntrtcrl/+qT+rnml0l3CUlS96xhPLFLbXXt5JBY6+qgHGkWOtUgrv6tMUawA+8Sl3cUwpnqgCIH2SMH6Jr+j6W38iJ/2zpiT9NiewsBXxCnMjqCWno6Qtomr9ty0b8r9++f1M9OeSy9wK5S18LUNlDE8gKNOa+WZ3AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F3kDBV9l; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F3kDBV9l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4sezW40oJuQHGpDawOTlaiilF1ouERkRpavusvIJ7p8=; b=F3kDBV9lGhM3knwF2jenAjoMyz
	cdVh3O8xZCIGoAlmQnTsLacUu9ocm0gLWB+qLSE9Ik1b7Suza2iFayUT6MyVu7Y8J/3Ck/J/Dqndp
	LRuAJ/b8DG8zLHhtPVKg3EPC9Z/IWpJgiqLuIamZjnnEBTyCcKkyEsLl9tzzCf0QJeVM/jhwY3KZ/
	O4LiKUZu7e37dvskwhn8IjBlUaGtfSgWb2KiAfGBNY8h+06y68JG/XJKYT1WBLHBzJQkEGbSzs9jA
	iVr5dgyCmrt2rNM2TxhaQ1SHHoW3RIwdawhqaOkDHHd5hpcfhBziKDj2k3wLucKwNkkAWZANN4pb7
	7KHk2LCQ==;
Received: from 2a02-8389-2341-5b80-6a7b-305c-cbe0-c9b8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:6a7b:305c:cbe0:c9b8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sgSIb-000000066d5-12JJ;
	Tue, 20 Aug 2024 17:05:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/6] xfs: call xfs_bmap_exact_minlen_extent_alloc from xfs_bmap_btalloc
Date: Tue, 20 Aug 2024 19:04:56 +0200
Message-ID: <20240820170517.528181-6-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240820170517.528181-1-hch@lst.de>
References: <20240820170517.528181-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_bmap_exact_minlen_extent_alloc duplicates the args setup in
xfs_bmap_btalloc.  Switch to call it from xfs_bmap_btalloc after
doing the basic setup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 61 +++++++++-------------------------------
 1 file changed, 13 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1db9d084a44c47..b5eeaea164ee46 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3471,28 +3471,17 @@ xfs_bmap_process_allocated_extent(
 #ifdef DEBUG
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
@@ -3502,33 +3491,9 @@ xfs_bmap_exact_minlen_extent_alloc(
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
 #else
 
@@ -3792,8 +3757,11 @@ xfs_bmap_btalloc(
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
@@ -4208,9 +4176,6 @@ xfs_bmapi_allocate(
 	if ((bma->datatype & XFS_ALLOC_USERDATA) &&
 	    XFS_IS_REALTIME_INODE(bma->ip))
 		error = xfs_bmap_rtalloc(bma);
-	else if (unlikely(XFS_TEST_ERROR(false, mp,
-			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
-		error = xfs_bmap_exact_minlen_extent_alloc(bma);
 	else
 		error = xfs_bmap_btalloc(bma);
 	if (error)
-- 
2.43.0

