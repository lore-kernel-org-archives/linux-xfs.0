Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0758A208A8
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537436; cv=none; b=VkUyX2a7I4VqW44L4k+1h+kpY9Zk2X8PGGhwM9vrQa6PsP4g0zOXj5LeiIHm8CEjLHUP0DOHSDD61QMve1fx+kWVf4WUWtgoqrr5naxAoJhw8JG2yMXq4yrYHskWhImBisv0N8RzMI3Xe+kI0+t3BcD+pwImyN3gcPPNQLIijGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537436; c=relaxed/simple;
	bh=MfQYQBPeyjWNTn7OOlttSPQCIIXE1jFgUnSN501DyTU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SymzW9ClJo8+cDym3SzlXTT1XQmpUv3Ag8QdI3aSS96VIV2Eit6KvQq2azlM8si9LYqtFI2QDwcyFTFW2G1g4XH0f4MtK3uy8R2k+e9+3uklO7VJcFf/6QvB8aQ9r9tF7WbRkeczG2oIehXu6Rf7ScW10N3swBt//rTunC5EU/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fgFSF8K1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fgFSF8K1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=P++dA9yb1mzeduh+7OVHDsKoQdcmXAc6kQ9fY/N1pnQ=; b=fgFSF8K17CiEjlsMF3sB59bSx0
	78yx4ERs34aYasv2kti8PXx02V9DdNNogwIdv5CVTH/N1EhtytX6PUWtbNWAEsbA/fAMsJ0tK0iog
	ATVWA8zegCm3g/2AA2DHAhYog7HLsU4DGYHnw9n7CUkE+Q53PI/BGwodKb8FqaEJO0m0Ygt/oBmEl
	Vwznz3ArvdHS3OvR7wd8QSly66Ve9x8XSCvsDmlwOyv9Y1FVX8/pfQn9kuCx2jBqMJi9jEXilROhU
	ukm1Kqa/0dOFxkz15glRp847p4imb1aMkObCDD6h7hzunN2GuXUiDllWUw2btz6QX4xdi5umhsaCt
	BpCOuVSQ==;
Received: from [89.144.223.137] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpR4T-00000008Whx-0u82;
	Wed, 27 Mar 2024 11:03:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/13] xfs: cleanup fdblock/frextent accounting in xfs_bmap_del_extent_delay
Date: Wed, 27 Mar 2024 12:03:13 +0100
Message-Id: <20240327110318.2776850-9-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240327110318.2776850-1-hch@lst.de>
References: <20240327110318.2776850-1-hch@lst.de>
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
index 572c91c986b6af..a9a23a5d2e487f 100644
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

