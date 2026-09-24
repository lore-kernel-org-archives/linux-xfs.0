Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD11E4534AE;
	Thu, 24 Sep 2026 10:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244098; cv=none; b=fkxokf30mJ4CtJwPvcrqFsp2xa9bHQFRQtdeKHbG9mtyrJ/iToo2OnLY5+tTE08XZXMyeuob+ekEauIA20HiuxIacMEWfnC5DwCd5xa4J5dQe7Qav1FUlo/R1mhhBzS9FK3SCmCJOkbULWbaCRsdCE3TOtmBUjAdIRoufxD18uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244098; c=relaxed/simple;
	bh=7XN4WzGweNrbLOqRiZQDqkezlM6nXGfplrf5qG2Ajck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5WRyFdY7+A82fiSX9pimhk4+gLB9b01hHxARIaINU8Vy2eWjZuFwJ1qUOCG6Xyth5YFuMaf93qx89IdOlhS3jItmrQex086ZMJcydz7adoveowWLJlR9neRs+tNSHzchvbu0HDZw9aotzAD04Uwj6kZeurOPwLKB9ltmE7ca6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=03JH6is9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="03JH6is9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RulkngjYB9TEFnAfod2iQHbKgTL+3JZGWA0bq3JObP8=; b=03JH6is9drhMRcxZhSUhIoeY+S
	DYEpBoCa2MHkiMjsQ7aJFk7iBjzj6boJ4pjGMKyQGubO1Xtmm4wftE3p9Qn8VKl0wnHKCCgriH8RW
	AaAauf3rCJZVMMnL+ffaG1wyyLxPlsSuJa2jj0UnWi+AM7JMhqIafdiURK6zxNxf+x2P9ucWxb5J/
	v3BOR3FqJxC2yvn7AkNkktzYIF+n//sgPtbSEDFAqj3ZpnJL8frIBHCeRH+1lewtA+hNLBS7ARMZe
	93wXPoEsZyJO28+3oNjGZeR/N+hlkeXeWtG9iQnp+Gl6ngst9grIHvgQ5AHfAJwVNOPirW2fCbmAT
	4IGGpLsA==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gGR-0000000AeUa-0QLY;
	Thu, 24 Sep 2026 10:01:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 06/21] xfs: prepare xfs_rtfile_initialize_blocks for larger than FSB blocks
Date: Thu, 24 Sep 2026 11:59:38 +0200
Message-ID: <20260924100032.2733101-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100032.2733101-1-hch@lst.de>
References: <20260924100032.2733101-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The upcoming RT data checksum feature will use larger than FSB blocks.
Prepare xfs_rtfile_initialize_blocks to pass the number of FSBs per
RT blocks, and to pass bmapi_flags to ask for contiguous allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.c | 44 +++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_rtbitmap.h |  3 ++-
 fs/xfs/xfs_rtalloc.c         |  4 ++--
 3 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 01536f4fb386..db6a22b4506a 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1346,6 +1346,7 @@ xfs_rtfile_alloc_blocks(
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		offset_fsb,
 	xfs_filblks_t		count_fsb,
+	uint32_t		bmapi_flags,
 	struct xfs_bmbt_irec	*map)
 {
 	struct xfs_mount	*mp = ip->i_mount;
@@ -1367,7 +1368,7 @@ xfs_rtfile_alloc_blocks(
 		goto out_trans_cancel;
 
 	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
-			XFS_BMAPI_METADATA, 0, map, &nmap);
+			XFS_BMAPI_METADATA | bmapi_flags, 0, map, &nmap);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1405,34 +1406,43 @@ xfs_rtfile_initialize_block(
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
 
@@ -1447,33 +1457,31 @@ xfs_rtfile_initialize_blocks(
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
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 750d74fbf4ed..e9e3378d15aa 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
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
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 84efe5a8fb11..78a1c066c7eb 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1191,11 +1191,11 @@ xfs_growfs_rt_alloc_blocks(
 	}
 
 	error = xfs_rtfile_initialize_blocks(rtg, XFS_RTGI_BITMAP, orbmblocks,
-			nmp->m_sb.sb_rbmblocks, NULL);
+			nmp->m_sb.sb_rbmblocks, 1, 0, NULL);
 	if (error)
 		goto out_free;
 	error = xfs_rtfile_initialize_blocks(rtg, XFS_RTGI_SUMMARY, orsumblocks,
-			nmp->m_rsumblocks, NULL);
+			nmp->m_rsumblocks, 1, 0, NULL);
 out_free:
 	kfree(nmp);
 	return error;
-- 
2.53.0

