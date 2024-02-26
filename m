Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B583354BC8
	for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 10:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708941898; cv=none; b=NKN7b37wdrlPtyWfFtAi9hQm4UHCGePGKGdDzQUHFfORtJhVryhlSfwKKF3DnO3xZjk8R65ImyfTLMudkfcUGenoN/9MTDnd2x7KOvkC/C7tFhHY5yfBlePvjCCyfoKa9Tyfk3yg6LjpvMC1HMMjuBeT3emw/hSEyap47NOMWJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708941898; c=relaxed/simple;
	bh=exR0ExNlTU5h9or6fKx9siFTOZ6CEkqb47MfHD5Igvc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FH8MsXyFxbFJVE1dG+PwSzliouKsQbrCsxmXkuhUXf05ROA7yYs2zEXkdNZxGMaupo1EduETpZ+LS51GUSI36TUw55Ct4P8z1wcO4ne7jvjGzqOrgoY1FxliOX3/0c2T8kqY77mfKTRL+eTHjZP0HMmVyGNjmttmoTnlvmtdx/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=spXvGAUT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="spXvGAUT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Y+EgnxBK7yAFduTeo1W7M5SGQjcY+RSl8OjaqalmWDI=; b=spXvGAUTvr4cUlnPfcpKXHPb0l
	llStnc5/s5f5grxWKFLvHVmvtIiP6WE27y1nWkpPy+U05NDlSrVZDlihS80wxU6NqcFPV1QeNZead
	vaPjBAtNxdswaNyGccg8INATtA62lrQGf/gJppCfrYTl3VLh0ACwiG2/Tl0yE6MDGr6TondpaDoNX
	TyleqsjZve4VeNYDsDZvg7Vq35OimK4nMyKPXDReSotmJQfQP4EMXrFVQoQmLM6o4tTcR+JxF3auX
	Ov2y+wqQEzxCjopEBQnbEdQXKZ19T737SahJWqGsR2VQobsNXLV/xuSlmAeeu11q2q4RuezWk/Jkt
	4v2xJG5w==;
Received: from 213-147-167-65.nat.highway.webapn.at ([213.147.167.65] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reXqx-0000000HX27-2Lu0;
	Mon, 26 Feb 2024 10:04:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/10] xfs: cleanup fdblock/frextent accounting in xfs_bmap_del_extent_delay
Date: Mon, 26 Feb 2024 11:04:16 +0100
Message-Id: <20240226100420.280408-7-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226100420.280408-1-hch@lst.de>
References: <20240226100420.280408-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The code to account fdblocks and frextents in xfs_bmap_del_extent_delay
is a bit weird in that it accounts frextents before the iext tree
manipulations and fdblocks after it.  Given that the iext tree
manipulations cannot fail currently that's not really a problem, but
still odd.  Move the frextent manipulation to the end, and use a
fdblocks variable to account of the unconditional indirect blocks and
the data blocks only freed for !RT.  This prepares for following
updates in the area and already makes the code more readable.

Also remove the !isrt assert given that this code clearly handles
rt extents correctly, and we'll soon reinstate delalloc support for
RT inodes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 35968a35e556d8..a4bb46842687cc 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4833,6 +4833,7 @@ xfs_bmap_del_extent_delay(
 	xfs_fileoff_t		del_endoff, got_endoff;
 	xfs_filblks_t		got_indlen, new_indlen, stolen;
 	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
+	uint64_t		fdblocks;
 	int			error = 0;
 	bool			isrt;
 
@@ -4848,15 +4849,11 @@ xfs_bmap_del_extent_delay(
 	ASSERT(got->br_startoff <= del->br_startoff);
 	ASSERT(got_endoff >= del_endoff);
 
-	if (isrt)
-		xfs_add_frextents(mp, xfs_rtb_to_rtx(mp, del->br_blockcount));
-
 	/*
 	 * Update the inode delalloc counter now and wait to update the
 	 * sb counters as we might have to borrow some blocks for the
 	 * indirect block accounting.
 	 */
-	ASSERT(!isrt);
 	error = xfs_quota_unreserve_blkres(ip, del->br_blockcount);
 	if (error)
 		return error;
@@ -4933,12 +4930,15 @@ xfs_bmap_del_extent_delay(
 
 	ASSERT(da_old >= da_new);
 	da_diff = da_old - da_new;
-	if (!isrt)
-		da_diff += del->br_blockcount;
-	if (da_diff) {
-		xfs_add_fdblocks(mp, da_diff);
-		xfs_mod_delalloc(mp, -da_diff);
-	}
+	fdblocks = da_diff;
+
+	if (isrt)
+		xfs_add_frextents(mp, xfs_rtb_to_rtx(mp, del->br_blockcount));
+	else
+		fdblocks += del->br_blockcount;
+
+	xfs_add_fdblocks(mp, fdblocks);
+	xfs_mod_delalloc(mp, -(int64_t)fdblocks);
 	return error;
 }
 
-- 
2.39.2

