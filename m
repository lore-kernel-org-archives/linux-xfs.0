Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA5644CADC
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 09:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790243885; cv=none; b=n0LsA/I+WzgqG/1BIpU6LKe5KSnYO0QnBzbz0JsLPcNddkUql4L+yynachbR1Ey1ysfTjW0jax1R/0b+MNt5tDRoecRyd9ALS6/JTLdyRlwANeJQ/h09a88IRVhW+wh2wWSmVLxweSbPLeFiy7cRddYrOkaOVOzSRWCDsxmMQAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790243885; c=relaxed/simple;
	bh=no+1bVGetGhFBbgvLZrbu/oNaZ5u0hWWhMrUAIhHpXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkNPVdnHTFGLShAmSuTG0H2Jl1Ca9K0Vqgx+HUvnyMrrUy7qdUz9g4KTxdICXvfclJMIa1wqP16BN8nwjhJkfV4iumYOeYcJR8JHc5QATJUcpFCExhQMC2hRMsJTnl2zCI3uNbiCMt5/W3j2hL9920jG5Q88lz3+9vp2rrRkl+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QS531g7q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QS531g7q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SWgIaBH+EFgW+Ddbu/GEdUm7YRl4FPgwt1PG+mhTKf0=; b=QS531g7qBUoZedSOObLgpKCsUT
	pm60cKgq1uNlEVNoiLuuOOFabdpGxIRrXtbD0MpnjCTgzecksWyYhKk8Aj9buzddLHQH4M96Xe17j
	OECOCsfY4YrauWnfLNO1BfkQ5i8FLUKgUfiHVNF218bsN/kvpP/hdmsS82Y2PMEjuUx1gRBpDPcS3
	LpXNP7b84WKZ0bfSRp92eT44aOcJ9ZH9xymTDy2A3zusPQYZBfDRBmdt0sWukVBQlFmmfNPw399nk
	fqPtGhtKCXhJqsmJhAdBP0FRUocoLJ8vFAIvQtaod4HnxmCv2ccBcdLmvVphEz0FZoRBWusCGm/t8
	wVmiEgJA==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gD8-0000000AeMT-1cs4;
	Thu, 24 Sep 2026 09:57:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/9] xfs: factor out a xfs_rtfile_initialize_buf helper
Date: Thu, 24 Sep 2026 11:57:03 +0200
Message-ID: <20260924095740.2732474-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924095740.2732474-1-hch@lst.de>
References: <20260924095740.2732474-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Share the code to initialize the header and buf ops for rtfile blocks
into a single helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.c    | 38 +++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_rtbitmap.h    |  3 +++
 fs/xfs/scrub/rtbitmap_repair.c  | 15 +------------
 fs/xfs/scrub/rtsummary_repair.c | 15 +------------
 4 files changed, 29 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 3f7877220e05..5cadde81b5da 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1378,6 +1378,27 @@ xfs_rtfile_alloc_blocks(
 	return error;
 }
 
+void
+xfs_rtfile_initialize_buf(
+	struct xfs_rtgroup	*rtg,
+	enum xfs_rtg_inodes	type,
+	struct xfs_buf		*bp,
+	struct xfs_trans	*tp)
+{
+	bp->b_ops = xfs_rtblock_ops(bp->b_mount, type);
+	if (tp)
+		xfs_trans_buf_set_type(tp, bp, xfs_rtblock_buf_types[type]);
+	if (xfs_has_rtgroups(bp->b_mount)) {
+		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+
+		hdr->rt_magic = bp->b_ops->magic[1];
+		hdr->rt_owner = cpu_to_be64(I_INO(rtg->rtg_inodes[type]));
+		hdr->rt_blkno = cpu_to_be64(xfs_buf_daddr(bp));
+		hdr->rt_lsn = 0;
+		uuid_copy(&hdr->rt_uuid, &bp->b_mount->m_sb.sb_meta_uuid);
+	}
+}
+
 /* Get a buffer for the block. */
 static int
 xfs_rtfile_initialize_block(
@@ -1408,21 +1429,10 @@ xfs_rtfile_initialize_block(
 	}
 	bufdata = bp->b_addr;
 
-	xfs_trans_buf_set_type(tp, bp, xfs_rtblock_buf_types[type]);
-	bp->b_ops = xfs_rtblock_ops(mp, type);
-
-	if (xfs_has_rtgroups(mp)) {
-		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
-
-		hdr->rt_magic = bp->b_ops->magic[1];
-		hdr->rt_owner = cpu_to_be64(I_INO(ip));
-		hdr->rt_blkno = cpu_to_be64(XFS_FSB_TO_DADDR(mp, fsbno));
-		hdr->rt_lsn = 0;
-		uuid_copy(&hdr->rt_uuid, &mp->m_sb.sb_meta_uuid);
-
-		bufdata += sizeof(*hdr);
-	}
+	xfs_rtfile_initialize_buf(rtg, type, bp, tp);
 
+	if (xfs_has_rtgroups(mp))
+		bufdata += sizeof(struct xfs_rtbuf_blkinfo);
 	if (data)
 		memcpy(bufdata, data, copylen);
 	else
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 375cc48e1a53..4a87e1fd3e99 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -408,6 +408,9 @@ xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
 
 const struct xfs_buf_ops *xfs_rtblock_ops(struct xfs_mount *mp,
 		enum xfs_rtg_inodes type);
+void xfs_rtfile_initialize_buf(struct xfs_rtgroup *rtg,
+		enum xfs_rtg_inodes type, struct xfs_buf *bp,
+		struct xfs_trans *tp);
 int xfs_rtfile_initialize_blocks(struct xfs_rtgroup *rtg,
 		enum xfs_rtg_inodes type, xfs_fileoff_t offset_fsb,
 		xfs_fileoff_t end_fsb, void *data);
diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
index 442a17bf9720..6a2efe3115f4 100644
--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -383,21 +383,8 @@ xrep_rtbitmap_prep_buf(
 	if (error)
 		return error;
 
-	if (xfs_has_rtgroups(sc->mp)) {
-		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
-
-		hdr->rt_magic = cpu_to_be32(XFS_RTBITMAP_MAGIC);
-		hdr->rt_owner = cpu_to_be64(I_INO(sc->ip));
-		hdr->rt_blkno = cpu_to_be64(xfs_buf_daddr(bp));
-		hdr->rt_lsn = 0;
-		uuid_copy(&hdr->rt_uuid, &sc->mp->m_sb.sb_meta_uuid);
-		bp->b_ops = &xfs_rtbitmap_buf_ops;
-	} else {
-		bp->b_ops = &xfs_rtbuf_ops;
-	}
-
+	xfs_rtfile_initialize_buf(sc->sr.rtg, XFS_RTGI_BITMAP, bp, sc->tp);
 	rtb->prep_wordoff += mp->m_blockwsize;
-	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_RTBITMAP_BUF);
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
index f065c3e51ce2..6a66113f6562 100644
--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -87,21 +87,8 @@ xrep_rtsummary_prep_buf(
 	if (error)
 		return error;
 
-	if (xfs_has_rtgroups(sc->mp)) {
-		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
-
-		hdr->rt_magic = cpu_to_be32(XFS_RTSUMMARY_MAGIC);
-		hdr->rt_owner = cpu_to_be64(I_INO(sc->ip));
-		hdr->rt_blkno = cpu_to_be64(xfs_buf_daddr(bp));
-		hdr->rt_lsn = 0;
-		uuid_copy(&hdr->rt_uuid, &sc->mp->m_sb.sb_meta_uuid);
-		bp->b_ops = &xfs_rtsummary_buf_ops;
-	} else {
-		bp->b_ops = &xfs_rtbuf_ops;
-	}
-
+	xfs_rtfile_initialize_buf(sc->sr.rtg, XFS_RTGI_SUMMARY, bp, sc->tp);
 	rts->prep_wordoff += mp->m_blockwsize;
-	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_RTSUMMARY_BUF);
 	return 0;
 }
 
-- 
2.53.0

