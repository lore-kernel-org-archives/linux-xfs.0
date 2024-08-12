Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C0914A616
	for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2024 05:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723440247; cv=none; b=AaLF8dV9F9tcebHcoRsQvAJBho4Xi7BbpHuQyzJKddAelqUMbOGBBuN6E+apH1xAIiZSIuYCkOdjCHRjra6gBQgG/P+C8OH2Kv918kEWGZywz6pfpBZwQ3y1+EbS62J7H0Qvxsiq5dSePh/LXC8HlZiIvlXq7WsHE29W3OdNOZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723440247; c=relaxed/simple;
	bh=W6mAiQCEpqOwiDl1jpNgbjnqlh3ZJq5pbbyFZX2xofg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXLn7XKdOHBTBUyLnTyASdI4XjSVxU7aNwNfkILP9ZUdGz3TQ+lE0qbYCW4Pc9XPh/FDvMABd/LyuUPmdL97pAJjQ/b9kDdiX3ufSGGZzwsXr36oSX/Rb0TRll7pLXpL1qcdOP4rDnBJObYBV6V4Rr50oGO4hyBW960RgmlDVe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LmnKs/u/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LmnKs/u/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pWc24pgVG8BWv7ylAz76mNdH/ub09rz4B+Iuz4S7Wjg=; b=LmnKs/u/M8+amDbs3HP0gQqy/N
	ko/M7Wi9epnlzqq9A9MBJGVKK8iNvhGs6V4x46cN+p1ZcFP+HRGabXEHcn3l0z+n15zEHTNHb9Fz5
	c4BAXtgXR+iZF0sG4AS7/AXumq5+MZ91nQ9Srbj64ciAT8jQMtjE1vAU1WLi4GNZsxtJMwisHu/7j
	yF0S/CPtEEFB2xdmrE4lW1N+qfMHO+KZM9mnydTF+BxoeKJD0WTuhgPyQ8Lz9aRS0uKO80pouBkEn
	WG5abpLdxBNXWu1g6N/FxFIo50sjtUy8dnQrARnWprPYVOoY+6mMGRiuM/Fd54qP+jCFWQnZoRgIg
	djE2PFNA==;
Received: from 2a02-8389-2341-5b80-ee60-2eea-6f8f-8d7f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:ee60:2eea:6f8f:8d7f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdNXI-0000000Gv5X-29no;
	Mon, 12 Aug 2024 05:24:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: fix handling of RCU freed inodes from other AGs in xrep_iunlink_mark_incore
Date: Mon, 12 Aug 2024 07:23:01 +0200
Message-ID: <20240812052352.3786445-3-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240812052352.3786445-1-hch@lst.de>
References: <20240812052352.3786445-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When xrep_iunlink_mark_incore skips an inode because it was RCU freed
from another AG, the slot for the inode in the batch array needs to be
zeroed.  Also un-duplicate the check and remove the need for the
xrep_iunlink_igrab helper.

Fixes: ab97f4b1c030 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/agheader_repair.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 2f98d90d7fd66d..558bc86b1b83c3 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1108,23 +1108,6 @@ xrep_iunlink_walk_ondisk_bucket(
 	return 0;
 }
 
-/* Decide if this is an unlinked inode in this AG. */
-STATIC bool
-xrep_iunlink_igrab(
-	struct xfs_perag	*pag,
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = pag->pag_mount;
-
-	if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
-		return false;
-
-	if (!xfs_inode_on_unlinked_list(ip))
-		return false;
-
-	return true;
-}
-
 /*
  * Mark the given inode in the lookup batch in our unlinked inode bitmap, and
  * remember if this inode is the start of the unlinked chain.
@@ -1196,9 +1179,6 @@ xrep_iunlink_mark_incore(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_inode *ip = ragi->lookup_batch[i];
 
-			if (done || !xrep_iunlink_igrab(pag, ip))
-				ragi->lookup_batch[i] = NULL;
-
 			/*
 			 * Update the index for the next lookup. Catch
 			 * overflows into the next AG range which can occur if
@@ -1211,8 +1191,14 @@ xrep_iunlink_mark_incore(
 			 * us to see this inode, so another lookup from the
 			 * same index will not find it again.
 			 */
-			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
+			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno) {
+				ragi->lookup_batch[i] = NULL;
 				continue;
+			}
+
+			if (done || !xfs_inode_on_unlinked_list(ip))
+				ragi->lookup_batch[i] = NULL;
+
 			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
 			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
 				done = true;
-- 
2.43.0

