Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31D0134BF
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 07:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708672560; cv=none; b=sFRcdSUsAZeZmt2hgFIsgz4LBvrE9Y/+hATV4bXHm89fD2gUdEkXnmX06uhRPyuTYNyjgEbZvacfb7l8NuntGeo9HGrVk4p2TofiOOR71EE5yD3R50wFoaYIaLOgUgELGNrFuEDBHxGF2R/JdeD04rZPvD0+DPz8eYfo7yywo+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708672560; c=relaxed/simple;
	bh=UFz+2XqdHsn3ljB2zd1hbVE+1vC4c0k3xhs1dqMS41A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dJU7RabCJViVGTeGE8NEg1+tRoTwPd46q/n0qYv/h4OBy/fFrrciZWsz1cTXb8KZeDv89hrv9R+QWWk8TGy0GfZOI/rvFAOGZrfxFsNS6q9+ZJF/KkYmUnO26KtNdSAn94EWejT6emH8ptK35b4AG1nieY1VyuRvb5G8BXuHD4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i/TvOrNz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i/TvOrNz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KCJ8HK8wJXoCmNa1hNznfRtTXvc5pNKrOQanp5blxN4=; b=i/TvOrNz/+8DREmgN0J7QKnN8l
	CMBOwzO+ImZOBuXQ7QclYTxnXF/wcQNE6HrLSF09TE6kEA/o8dwIBNAltyxW111uxm+OEU9bJnxTa
	kufxhRFwBrq7UFh4F7OLwtwJRqMyHGdGc/xSxXzgSWfF0WB8Qc1z06POsegOoxs1sUgNJPzTfN89X
	I+Hs0mekNVqVqryv38rBxv7Ef84BNWlw87nuR5FJ8YD4SWa7m4YGcFUzg9af4P2PfCc3Z0X+fAvMl
	5bDsGMNlOXpqAdnIdCo/oHhx43NG9037EDeW7wwIQBU1joLTqYMH/ayeu66PuUUwEeE2IwxIvFrgN
	lUZI1pJg==;
Received: from [2001:4bb8:19a:62b2:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rdPmn-00000008GvN-3TdL;
	Fri, 23 Feb 2024 07:15:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/10] xfs: cleanup fdblock/frextent accounting in xfs_bmap_del_extent_delay
Date: Fri, 23 Feb 2024 08:15:02 +0100
Message-Id: <20240223071506.3968029-7-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240223071506.3968029-1-hch@lst.de>
References: <20240223071506.3968029-1-hch@lst.de>
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
manipulations can fail currently that's not really a problem, but
still odd.  Move the frextent manipulation to the end, and use a
fdblocks variable to account of the unconditional indirect blocks and
the data blocks only freed for !RT.  This prepares for following
updates in the area and already makes the code more readable.

Also remove the !isrt assert given that this code clearly handles
rt extents correctly, and we'll soon reinstate delalloc support for
RT inodes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 95e93534cd1264..074d833e845af3 100644
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

