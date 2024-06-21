Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DA81D52C
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 05:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718946036; cv=none; b=BP7GE3ewpzMgImENATOKut9JOFg0pOYcstWbuEBxV0f3d7iW+nBZ1LkOx1+OpNtWhYgrdXbQM5of0wHV4fRWT9jUdjzmZOoZt9D0DSfEsgXGVP4J36TTzdTQPIEf4nitOynGXiK4oLwNYR61XYi5a9Oi1HUb1GkPRfOadalFWPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718946036; c=relaxed/simple;
	bh=upPaVLX6cSfSWq6FF0Bt5v53CXYiXrBYaMie9XablU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f83RuIFq0foqMOVGS7Yx5fcCTWAMaaFLiQVdLZAKODDnOdO5TbFfceL48BkfMVLsg7Rudk3JjEG6iv/C+m7VjcbMS1hLpXMZhRydr2rUrMaeJwYWeaJPGgERXguJj25W9BBY9JrlToCqPFawKq2egGuYYAbooUQPnMb7sjM1oos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RBk0ju9v; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RBk0ju9v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7xN+Uj6aLf5mSOuP7Y2+toNJzBkwOMHiXzvdtGM5UQE=; b=RBk0ju9vg4y0ilVOiS3eBFTX3g
	q5GDSrXjoSBObblpVBjV5ro4FvExirHPMTqyR9dpwOuoRT07De2cX2hJVFlAGzzUYzx2QxRvgXzVM
	pRuVKK6C0SufaXZ/YlVR/HFeh1nUGaZGQ1/zT0NhDcNgKYZGXAyfUjUovRRqq5zyb9Nt9fg/vA4bK
	XvHdFH7HLVgLURpWV+syfsZeD9RVbDihmLNhKwCBxDHnknFF3grriT3r+LdxwMoM8aFKd5sjUrIa7
	rLdGCH2MNVjOrdIsxbLr1hWWmIg0r/1OttA6jm4pMt7tMaDnDgPqbPWDUAdEw5uQM79rObaReFANY
	3cT6+GQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKWO0-00000007hv2-1hwF;
	Fri, 21 Jun 2024 05:00:32 +0000
Date: Thu, 20 Jun 2024 22:00:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Konst Mayer <cdlscpmv@gmail.com>, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/1] xfs: enable FITRIM on the realtime device
Message-ID: <ZnUI8Jd1m5j0RUN5@infradead.org>
References: <171892420288.3185132.3927361357396911761.stgit@frogsfrogsfrogs>
 <171892420308.3185132.6252829732531290655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892420308.3185132.6252829732531290655.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	if (!bdev_max_discard_sectors(mp->m_ddev_targp->bt_bdev))
> +		goto rt_discard;
> +

I think this would looks much better if we split the ddev trimming
into a separate helper, just like this patch does for the RT device:

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 3ad5b0505848b0..4eb71edf732c48 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -595,6 +595,48 @@ xfs_trim_rtdev_extents(
 # define xfs_trim_rtdev_extents(m,s,e,n,b)	(-EOPNOTSUPP)
 #endif /* CONFIG_XFS_RT */
 
+static int
+xfs_trim_dddev_extents(
+	struct xfs_mount	*mp,
+	xfs_daddr_t		start,
+	xfs_daddr_t		end,
+	xfs_extlen_t		minlen,
+	uint64_t		*blocks_trimmed)
+{
+	xfs_agnumber_t		start_agno, end_agno;
+	xfs_agblock_t		start_agbno, end_agbno;
+	xfs_daddr_t		ddev_end;
+	struct xfs_perag	*pag;
+	int			last_error = 0, error;
+
+	ddev_end = min_t(xfs_daddr_t, end,
+			 XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1);
+
+	start_agno = xfs_daddr_to_agno(mp, start);
+	start_agbno = xfs_daddr_to_agbno(mp, start);
+	end_agno = xfs_daddr_to_agno(mp, ddev_end);
+	end_agbno = xfs_daddr_to_agbno(mp, ddev_end);
+
+	for_each_perag_range(mp, start_agno, end_agno, pag) {
+		xfs_agblock_t	agend = pag->block_count;
+
+		if (start_agno == end_agno)
+			agend = end_agbno;
+		error = xfs_trim_extents(pag, start_agbno, agend, minlen,
+				blocks_trimmed);
+		if (error)
+			last_error = error;
+
+		if (xfs_trim_should_stop()) {
+			xfs_perag_rele(pag);
+			break;
+		}
+		start_agbno = 0;
+	}
+
+	return last_error;
+}
+
 /*
  * trim a range of the filesystem.
  *
@@ -612,15 +654,12 @@ xfs_ioc_trim(
 	struct xfs_mount		*mp,
 	struct fstrim_range __user	*urange)
 {
-	struct xfs_perag	*pag;
 	unsigned int		granularity =
 		bdev_discard_granularity(mp->m_ddev_targp->bt_bdev);
 	struct block_device	*rt_bdev = NULL;
 	struct fstrim_range	range;
-	xfs_daddr_t		start, end, ddev_end;
+	xfs_daddr_t		start, end;
 	xfs_extlen_t		minlen;
-	xfs_agnumber_t		start_agno, end_agno;
-	xfs_agblock_t		start_agbno, end_agbno;
 	xfs_rfsblock_t		max_blocks;
 	uint64_t		blocks_trimmed = 0;
 	int			error, last_error = 0;
@@ -666,35 +705,13 @@ xfs_ioc_trim(
 	start = BTOBB(range.start);
 	end = start + BTOBBT(range.len) - 1;
 
-	if (!bdev_max_discard_sectors(mp->m_ddev_targp->bt_bdev))
-		goto rt_discard;
-
-	ddev_end = min_t(xfs_daddr_t, end,
-			 XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1);
-
-	start_agno = xfs_daddr_to_agno(mp, start);
-	start_agbno = xfs_daddr_to_agbno(mp, start);
-	end_agno = xfs_daddr_to_agno(mp, ddev_end);
-	end_agbno = xfs_daddr_to_agbno(mp, ddev_end);
-
-	for_each_perag_range(mp, start_agno, end_agno, pag) {
-		xfs_agblock_t	agend = pag->block_count;
-
-		if (start_agno == end_agno)
-			agend = end_agbno;
-		error = xfs_trim_extents(pag, start_agbno, agend, minlen,
+	if (bdev_max_discard_sectors(mp->m_ddev_targp->bt_bdev)) {
+		error = xfs_trim_dddev_extents(mp, start, end, minlen,
 				&blocks_trimmed);
 		if (error)
 			last_error = error;
-
-		if (xfs_trim_should_stop()) {
-			xfs_perag_rele(pag);
-			break;
-		}
-		start_agbno = 0;
 	}
 
-rt_discard:
 	if (rt_bdev && bdev_max_discard_sectors(rt_bdev)) {
 		error = xfs_trim_rtdev_extents(mp, start, end, minlen,
 				&blocks_trimmed);
