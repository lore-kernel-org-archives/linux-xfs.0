Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D4D46C4AE
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244389; cv=none; b=teCivhfjSQ3l+txvv5CaLTu/P7JAhaBJGO1NHZal5j2/tLBerCAlOx+XZUDnLDZitdIcrCQtAtZ8JWWWv/iFRz02Owi5VbX/YjsYnEqWfrQeAbw0Y2z03gZbVNcAkwUhdNKtJyBUvoeTLQfWt4UnqG+ucDQZ4vxhY8lGZ3ZbSJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244389; c=relaxed/simple;
	bh=MCgbq5480ENYo51SGK0soxpnA3m+hKd3mmldFI6ehvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/V497VIoG/YtuSYaUeCdpxsPO6xSoN4p+6Z7/vYwT3dWfALWLBPYGcZohT+J2I7SmR8Yt26uUoR0QoWLgxp63aj9t7qMum+UTICkoBmJvArqlAA46vfhqFJVR48eU22iHr4pREKVmXsL70ukpQ3awrVQNt04E78EV7ycISkWo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=48fJp5gz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="48fJp5gz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EdiOKyn9PdsS7/+r7ap+d38z7VO9D8FirBgDPTDa/x4=; b=48fJp5gzBJ+tDtzNxXTZozM7mG
	6R/+kU+wSB1C5tMUUNBFPZb5VHpvIPrBlm7G/N3c1FIpNkNDY1OGF1YRsnoKVtKmLAFZU1sD8prt7
	MqTIHjgP2ss/149XIqqycswVmbLwawgOkibJQ4kutneaeFu8dL0Q/IUUA8sKK/GVEgsLGNFZ0iPVF
	iKpzJYZMi45pGZT2t/Qf1L4samPIibCnNlAoHTYHpgmEjIN5/ff5fkKH+mHGcvz4SBvow6jokHfgs
	mbD0Z1UO12FocRUr0eAICDIJjdbP6s13SUhqKNEqS8ECccG0nrvZHQiXstaOz9hGC1W/AST9dVpZW
	31ZY8wDg==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gLL-0000000AfMy-11fk;
	Thu, 24 Sep 2026 10:06:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 17/32] xfs: prepare xfs_rtfile_initialize_blocks for larger than FSB blocks
Date: Thu, 24 Sep 2026 12:04:07 +0200
Message-ID: <20260924100512.2733748-18-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100512.2733748-1-hch@lst.de>
References: <20260924100512.2733748-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: e2ab369189d3a62e28b9f7a1de255a21bc8b1534

The upcoming RT data checksum feature will use larger than FSB blocks.
Prepare xfs_rtfile_initialize_blocks to pass the number of FSBs per
RT blocks, and to pass bmapi_flags to ask for contiguous allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtbitmap.c | 44 +++++++++++++++++++++++++------------------
 libxfs/xfs_rtbitmap.h |  3 ++-
 2 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 39a6b45d9526..3abc495c2a3c 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1343,6 +1343,7 @@ xfs_rtfile_alloc_blocks(
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		offset_fsb,
 	xfs_filblks_t		count_fsb,
+	uint32_t		bmapi_flags,
 	struct xfs_bmbt_irec	*map)
 {
 	struct xfs_mount	*mp = ip->i_mount;
@@ -1364,7 +1365,7 @@ xfs_rtfile_alloc_blocks(
 		goto out_trans_cancel;
 
 	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
-			XFS_BMAPI_METADATA, 0, map, &nmap);
+			XFS_BMAPI_METADATA | bmapi_flags, 0, map, &nmap);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1402,34 +1403,43 @@ xfs_rtfile_initialize_block(
 	struct xfs_rtgroup	*rtg,
 	enum xfs_rtg_inodes	type,
 	xfs_fsblock_t		fsbno,
-	void			*data)
+	xfs_filblks_t		nblks,
+	void			**data)
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_inode	*ip = rtg->rtg_inodes[type];
+	size_t			len = XFS_FSB_TO_B(mp, nblks);
+	size_t			copylen = len;
+	struct xfs_trans_res	tres = M_RES(mp)->tr_growrtzero;
 	struct xfs_trans	*tp;
 	struct xfs_buf		*bp;
-	const size_t		copylen = mp->m_blockwsize << XFS_WORDLOG;
 	int			error;
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtzero, 0, 0, 0, &tp);
+	tres.tr_logres *= nblks;
+	error = xfs_trans_alloc(mp, &tres, 0, 0, 0, &tp);
 	if (error)
 		return error;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
 	error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
-			XFS_FSB_TO_DADDR(mp, fsbno), mp->m_bsize, 0, &bp);
+			XFS_FSB_TO_DADDR(mp, fsbno), BTOBB(len), 0, &bp);
 	if (error) {
 		xfs_trans_cancel(tp);
 		return error;
 	}
 
+	if (xfs_has_rtgroups(mp))
+		copylen -= sizeof(struct xfs_rtbuf_blkinfo);
+
 	xfs_rtfile_initialize_buf(rtg, type, bp, tp);
-	if (data)
-		memcpy(xfs_rtblock_payload(bp), data, copylen);
-	else
+	if (*data) {
+		memcpy(xfs_rtblock_payload(bp), *data, copylen);
+		*data += copylen;
+	} else {
 		memset(xfs_rtblock_payload(bp), 0, copylen);
-	xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
+	}
+	xfs_trans_log_buf(tp, bp, 0, len - 1);
 	return xfs_trans_commit(tp);
 }
 
@@ -1444,33 +1454,31 @@ xfs_rtfile_initialize_blocks(
 	enum xfs_rtg_inodes	type,
 	xfs_fileoff_t		offset_fsb,	/* offset to start from */
 	xfs_fileoff_t		end_fsb,	/* offset to allocate to */
+	xfs_filblks_t		bsize,
+	uint32_t		bmapi_flags,
 	void			*data)		/* data to fill the blocks */
 {
-	struct xfs_mount	*mp = rtg_mount(rtg);
-	const size_t		copylen = mp->m_blockwsize << XFS_WORDLOG;
-
 	while (offset_fsb < end_fsb) {
 		struct xfs_bmbt_irec	map;
 		xfs_filblks_t		i;
 		int			error;
 
 		error = xfs_rtfile_alloc_blocks(rtg->rtg_inodes[type],
-				offset_fsb, end_fsb - offset_fsb, &map);
+				offset_fsb, end_fsb - offset_fsb, bmapi_flags,
+				&map);
 		if (error)
 			return error;
 
 		/*
-		 * Now we need to clear the allocated blocks.
+		 * Now we need to clear or initialize the allocated blocks.
 		 *
 		 * Do this one block per transaction, to keep it simple.
 		 */
-		for (i = 0; i < map.br_blockcount; i++) {
+		for (i = 0; i < map.br_blockcount; i += bsize) {
 			error = xfs_rtfile_initialize_block(rtg, type,
-					map.br_startblock + i, data);
+					map.br_startblock + i, bsize, &data);
 			if (error)
 				return error;
-			if (data)
-				data += copylen;
 		}
 
 		offset_fsb = map.br_startoff + map.br_blockcount;
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 750d74fbf4ed..e9e3378d15aa 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -410,7 +410,8 @@ void xfs_rtfile_initialize_buf(struct xfs_rtgroup *rtg,
 		struct xfs_trans *tp);
 int xfs_rtfile_initialize_blocks(struct xfs_rtgroup *rtg,
 		enum xfs_rtg_inodes type, xfs_fileoff_t offset_fsb,
-		xfs_fileoff_t end_fsb, void *data);
+		xfs_fileoff_t end_fsb, xfs_filblks_t bsize,
+		uint32_t bmapi_flags, void *data);
 int xfs_rtbitmap_create(struct xfs_rtgroup *rtg, struct xfs_inode *ip,
 		struct xfs_trans *tp, bool init);
 int xfs_rtsummary_create(struct xfs_rtgroup *rtg, struct xfs_inode *ip,
-- 
2.53.0

