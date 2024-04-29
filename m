Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35EED534
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 04:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714366185; cv=none; b=kcjl9a12X/dWaW+RFE7tl7Q7ThkcRHxqTSqv9lRKBvoF4xYAIH5NI1APHVjYcRQ3din6geaW6BRA6hHnlOub/jgLva+hVufLVZDQbaKUn4nOKw13SRxvDVRRQ9WWqKxeIODEbT8p4+syHPVI2uQ3u+DaNVdqq4+RE3Krn/jAr+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714366185; c=relaxed/simple;
	bh=1UtKFrmTo1DCO4xEHPFaxfavne6zXLHyjmkrZK0YBbE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GLeIXr/NjoG8XIPhGaD7pEA6wPAwx3uGiiL3aBS1e7xwXSVi72iVa3APoM5F7lb70km5XSyp2+8BHdnlD5D3uptsQl20XM+t4t0WtK3QvorFd91abjOK5JKEX3d0yHqnbuomfiYRhD/QnR0nlD+BxU38vrmIk+MKTOSTSO1utZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c7Zs/0y2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c7Zs/0y2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2LBnwVJWyfdi8kgWchXm5CVyxntrtaHrqVXkEUlOdrA=; b=c7Zs/0y23+qAW0jAYX8Es/dThd
	FuHG6vzQPx71nzRClfoPktXoR7Oe75H4lUxdSzuQqURGaq0md68MYZKGv3NAvhMY3Z8sODvp8QeyD
	jHgQYFjUExZeJYczsFOFw8iMf3or96RBie4ZdlOI4V8GSkHFwaLVel1yf9Wq5yPoCAmW5Sy3M9wvs
	eAfDmpxkTWq0t7vjwCRUkQP7l/gsbkPhwzeehqVtgGLUckno+FX3HjT209eyhOEWiu9RLmrxWcJcB
	Ko3eqkbKtRrKJxmfJRkW2hX7KsD/QDiLMtZxCb8UHKRnSgEDuBNaoBEsjLti++QiW6rFaHzMbJgWr
	iQ0ruaAA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1IxT-00000001SA8-0zQd;
	Mon, 29 Apr 2024 04:49:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 8/8] xfs: rename the del variable in xfs_reflink_end_cow_extent
Date: Mon, 29 Apr 2024 06:49:17 +0200
Message-Id: <20240429044917.1504566-9-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240429044917.1504566-1-hch@lst.de>
References: <20240429044917.1504566-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

del contains the new extent that we are remapping.  Give it a somewhat
less confusing name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e20db39d1cc46f..f4c4cd4ef72336 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -784,7 +784,7 @@ xfs_reflink_end_cow_extent(
 	xfs_fileoff_t		end_fsb)
 {
 	struct xfs_iext_cursor	icur;
-	struct xfs_bmbt_irec	got, del;
+	struct xfs_bmbt_irec	got, remap;
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
@@ -820,7 +820,7 @@ xfs_reflink_end_cow_extent(
 	 * Only remap real extents that contain data.  With AIO, speculative
 	 * preallocations can leak into the range we are called upon, and we
 	 * need to skip them.  Preserve @got for the eventual CoW fork
-	 * deletion; from now on @del represents the mapping that we're
+	 * deletion; from now on @remap represents the mapping that we're
 	 * actually remapping.
 	 */
 	while (!xfs_bmap_is_written_extent(&got)) {
@@ -830,9 +830,9 @@ xfs_reflink_end_cow_extent(
 			goto out_cancel;
 		}
 	}
-	del = got;
-	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
-	trace_xfs_reflink_cow_remap_from(ip, &del);
+	remap = got;
+	xfs_trim_extent(&remap, *offset_fsb, end_fsb - *offset_fsb);
+	trace_xfs_reflink_cow_remap_from(ip, &remap);
 
 	error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
 			XFS_IEXT_REFLINK_END_COW_CNT);
@@ -840,23 +840,24 @@ xfs_reflink_end_cow_extent(
 		goto out_cancel;
 
 	/* Unmap the old data. */
-	error = xfs_reflink_unmap_old_data(&tp, ip, del.br_startoff,
-			del.br_startoff + del.br_blockcount);
+	error = xfs_reflink_unmap_old_data(&tp, ip, remap.br_startoff,
+			remap.br_startoff + remap.br_blockcount);
 	if (error)
 		goto out_cancel;
 
 	/* Free the CoW orphan record. */
-	xfs_refcount_free_cow_extent(tp, del.br_startblock, del.br_blockcount);
+	xfs_refcount_free_cow_extent(tp, remap.br_startblock,
+			remap.br_blockcount);
 
 	/* Map the new blocks into the data fork. */
-	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, &del);
+	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, &remap);
 
 	/* Charge this new data fork mapping to the on-disk quota. */
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_DELBCOUNT,
-			(long)del.br_blockcount);
+			(long)remap.br_blockcount);
 
 	/* Remove the mapping from the CoW fork. */
-	xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
+	xfs_bmap_del_extent_cow(ip, &icur, &got, &remap);
 
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -864,7 +865,7 @@ xfs_reflink_end_cow_extent(
 		return error;
 
 	/* Update the caller about how much progress we made. */
-	*offset_fsb = del.br_startoff + del.br_blockcount;
+	*offset_fsb = remap.br_startoff + remap.br_blockcount;
 	return 0;
 
 out_cancel:
-- 
2.39.2

