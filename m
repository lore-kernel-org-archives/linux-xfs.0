Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FE2146597
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 11:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713784854; cv=none; b=c8YDxKW4zVAot9LwqLxq1cN0RYGiBYhuxlZppkQ8YPT80L3z7/I3rvxapQJtJMTW3B+z6Wpc/s3irnXTIHAO/+y+utMHiff2+EHZidlvfosMvmXJKKL48lFY/MgmE0aquwzZJbOq6iotxoy2cWb/228NsMQ23DKdT6kJlaU1Jxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713784854; c=relaxed/simple;
	bh=k+Cn2n4vSSHHTeci7WoMv9LtmwpUiK9sLxPi840IGqw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U4zDocTXlY0PBpT30Alnq4RQ1uBqPQborZl+E1RQ8XSpmjQKXIbsuxBIXvjr+cWyF+XBfOhqtwv8zc1rcJuH3j6FySeWLgJG4IZPhErm4fbOQK0sudNXdVvJaMPbYOKsTjnq4aXN1txI7OFhrn1XAnc03j70ZxzE48KyI4XSqxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GmRWMg61; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GmRWMg61"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=CnATw0lXU3qv1PUroha4UOg1s5sQYu2ed/aMDSpRJiQ=; b=GmRWMg61uH7Aa4+E3ysid4JMEl
	Lx1kfrHepxJ1oPjI9l+qWtpDE6LVjOdBLpaeYAn9UXKW5qlQA0B5iDu7ByNqo3VYFTVhIW986tb+z
	lXB4n3j1pKtJUZlXGewJKip2TqAw9MjrkkL427Iy+xpOXMx0NBLMWHWxTx5zZCha7G9AyePKmJLNg
	PoObZQOZFDufY2gFIg++/RK/Gfkk6vdOzABe1nYyRm+4YNvdHBfuJRLrEro8EZzwmUVqF1CCLWSKX
	C2jRSEw3XC6Uxnev4k0qBJkn6Epjob3xu7Fsyw5plHw0i2SUjS34fTtSB89GuQyQ2BYfOxezZJf8e
	Hv7mTPtQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ryrjA-0000000DLI0-0g5U;
	Mon, 22 Apr 2024 11:20:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 08/13] xfs: cleanup fdblock/frextent accounting in xfs_bmap_del_extent_delay
Date: Mon, 22 Apr 2024 13:20:14 +0200
Message-Id: <20240422112019.212467-9-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240422112019.212467-1-hch@lst.de>
References: <20240422112019.212467-1-hch@lst.de>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f14224ff4d561d..d7a5ce2e4305af 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4919,6 +4919,7 @@ xfs_bmap_del_extent_delay(
 	xfs_fileoff_t		del_endoff, got_endoff;
 	xfs_filblks_t		got_indlen, new_indlen, stolen;
 	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
+	uint64_t		fdblocks;
 	int			error = 0;
 	bool			isrt;
 
@@ -4934,15 +4935,11 @@ xfs_bmap_del_extent_delay(
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
@@ -5019,12 +5016,15 @@ xfs_bmap_del_extent_delay(
 
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

