Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C8B156652
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 02:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711333479; cv=none; b=AiECbvdZa+obWGXLzm+qPYsIqcSIQFtn7NzgAfxEg1pEspCZYmTPfP75ig3h4a2MzOQ79FtKC1qLU8wqCqgJOgzqEVWH7D00Uz9Vp/uQEP3HQ/mqKPYJI6CiNHOJazssFEvmawJAESfwmhE7uGD9Dcob/WGG9H51aRrNME5WYTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711333479; c=relaxed/simple;
	bh=qnNrA6ZM/9vX3CO3b8pBjbaMhFd6lscfutn3a76l/O4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sw7yT59u0hLrR9+pzmR039s97nqFtNaTPyec1K+x67EhxdUSqNk4GzFKiYIfHSTJIcvDWkt5QKtUj9OZslax4X1DZpq03//UXXCajMOl3a05VP+8oMig++58WLI+U9x3fR6QtlKrwpPl+BjxQKVNt/I3Aw9WMmbvf5SH4tPJe28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fX75xdfH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fX75xdfH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rP8NHdOdpNG79lyZfUM4DmclQYwxNyDASfkhjfOMYLw=; b=fX75xdfHA8l0cuEmhrhuHxCdhO
	oc65QkQrDZbWhzFLUXWlroyFzdCf6XV+sFvab7KoA72ah8x7zZ65eBl74SSh/28y6WVYZ4E0Lxt1H
	dX55jNI2Iwa15pz6ObHgQKGPZsb8Sv3rhXwahnNqQNWKKdA3Fo28CW+uT2jGgEMBMBl0iwFNHw4GZ
	rAQIBqHBInPc1xTYQ6vdCvFBejOSIRq4fCB6n1WCVXlJx1M9T5St4wokcK/nSYrb/Uk2H8ddo/MDz
	9T7Xk50hFs7HPdN/jJM4a7A/JQCCxQPOrStljDspGI1JpNIHnMmEOMn8GKk525pqOgr5gDOnIAWjw
	kwXC+1eA==;
Received: from [210.13.83.2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1roa0r-0000000EeUf-2HHj;
	Mon, 25 Mar 2024 02:24:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/11] xfs: cleanup fdblock/frextent accounting in xfs_bmap_del_extent_delay
Date: Mon, 25 Mar 2024 10:24:06 +0800
Message-Id: <20240325022411.2045794-7-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240325022411.2045794-1-hch@lst.de>
References: <20240325022411.2045794-1-hch@lst.de>
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
index 1114e057e55783..94b4aad1989bec 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4917,6 +4917,7 @@ xfs_bmap_del_extent_delay(
 	xfs_fileoff_t		del_endoff, got_endoff;
 	xfs_filblks_t		got_indlen, new_indlen, stolen;
 	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
+	uint64_t		fdblocks;
 	int			error = 0;
 	bool			isrt;
 
@@ -4932,15 +4933,11 @@ xfs_bmap_del_extent_delay(
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
@@ -5017,12 +5014,15 @@ xfs_bmap_del_extent_delay(
 
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

