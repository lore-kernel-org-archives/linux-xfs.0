Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE81045D915
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244385; cv=none; b=KbSe/6MjYRtEKuasv1sbUV/2Tj/wvUki8odoPZ9QmTT3vhnCSKJhdnNmBbaufZDrnC3T+R7F47pQ9I+3DGSJ8EaSeB0FQzV1vqLN7u0SKMqoc8hqBODSfsrmFcAbOHDRwM42mFwnoEQ8E4k3VgLYFjerJIccjbEfuAXPAcoj2SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244385; c=relaxed/simple;
	bh=F28CqPwxc02LNI3TeHsbP2+XNloNnzgfyOo5EECdHNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjxerRGfgunH0cpny6AJ6xyIX5/4uCRbamcBn1ARq5DBIaR4lyjPeL9UpdtJ3txWfTGHiYeX9LYZ5TP7GXcSJO5KBTybdBbPlY/BcZBScU09baGftQi7PMzdUNZf3hhszD1Bf572ksZaSgyU1rHPHLCXtqgeSwTfkIJOO0Bjz1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K4DF8gOO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K4DF8gOO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=w1t2jYXiWUkhtLVcz0SqE+rVXXWGg2SA3ArLegjQPl8=; b=K4DF8gOOHFErxAUTgluSjc8jWj
	ainhF8BuwHGHBjOVFHdxdlFmtEFO5BwKJOQtATF5iT3IbEQ62fcAJ60I63NW+UOV4WjeQhTc2zcEG
	A4s2EYXT2Zi4M7K3igZ5QQWX00SSrvo+tHMFiGbq9LdqrrnDA5PC3Ki/aSVzobYwS25Gm77DNga0H
	IAEQFAYCrFm6NMthdTqKx+YDJn48Oa6mAb/PEpD1HIM2y0N3KQ1hmO/RszRUxiPEBN9k9nQKO80fb
	01fgUQyE2Tmshpdb3FkjswAMiFcTjcjGqC02/K7SsnyifuxzN53wOiTH2Z6TQQewHnLVBUZNLhPFQ
	aZQqhVMQ==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gLG-0000000AfMB-0yoF;
	Thu, 24 Sep 2026 10:06:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 16/32] xfs: add a xfs_rtblock_payload helper
Date: Thu, 24 Sep 2026 12:04:06 +0200
Message-ID: <20260924100512.2733748-17-hch@lst.de>
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

Source kernel commit: c63d609c1ed6dd49664e4f822a70abaf2572b35b

Add a helper to calculate the rtblock payload start with or without the
self-describing metadata header.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtbitmap.c |  9 ++-------
 libxfs/xfs_rtbitmap.h | 27 ++++++++++++---------------
 2 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 245cdd9c22ca..39a6b45d9526 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1408,7 +1408,6 @@ xfs_rtfile_initialize_block(
 	struct xfs_inode	*ip = rtg->rtg_inodes[type];
 	struct xfs_trans	*tp;
 	struct xfs_buf		*bp;
-	void			*bufdata;
 	const size_t		copylen = mp->m_blockwsize << XFS_WORDLOG;
 	int			error;
 
@@ -1424,16 +1423,12 @@ xfs_rtfile_initialize_block(
 		xfs_trans_cancel(tp);
 		return error;
 	}
-	bufdata = bp->b_addr;
 
 	xfs_rtfile_initialize_buf(rtg, type, bp, tp);
-
-	if (xfs_has_rtgroups(mp))
-		bufdata += sizeof(struct xfs_rtbuf_blkinfo);
 	if (data)
-		memcpy(bufdata, data, copylen);
+		memcpy(xfs_rtblock_payload(bp), data, copylen);
 	else
-		memset(bufdata, 0, copylen);
+		memset(xfs_rtblock_payload(bp), 0, copylen);
 	xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 	return xfs_trans_commit(tp);
 }
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 4a87e1fd3e99..750d74fbf4ed 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -20,6 +20,16 @@ struct xfs_rtalloc_args {
 	xfs_fileoff_t		sumoff;	/* summary block number */
 };
 
+/* Return the payload of the buffer after the optional header. */
+static inline void *
+xfs_rtblock_payload(
+	struct xfs_buf		*bp)
+{
+	if (!xfs_has_rtgroups(bp->b_mount))
+		return bp->b_addr;
+	return bp->b_addr + sizeof(struct xfs_rtbuf_blkinfo);
+}
+
 static inline xfs_rtblock_t
 xfs_rtx_to_rtb(
 	struct xfs_rtgroup	*rtg,
@@ -221,14 +231,7 @@ xfs_rbmblock_wordptr(
 	struct xfs_rtalloc_args	*args,
 	unsigned int		index)
 {
-	struct xfs_mount	*mp = args->mp;
-	union xfs_rtword_raw	*words;
-	struct xfs_rtbuf_blkinfo *hdr = args->rbmbp->b_addr;
-
-	if (xfs_has_rtgroups(mp))
-		words = (union xfs_rtword_raw *)(hdr + 1);
-	else
-		words = args->rbmbp->b_addr;
+	union xfs_rtword_raw	*words = xfs_rtblock_payload(args->rbmbp);
 
 	return words + index;
 }
@@ -312,13 +315,7 @@ xfs_rsumblock_infoptr(
 	struct xfs_rtalloc_args	*args,
 	unsigned int		index)
 {
-	union xfs_suminfo_raw	*info;
-	struct xfs_rtbuf_blkinfo *hdr = args->sumbp->b_addr;
-
-	if (xfs_has_rtgroups(args->mp))
-		info = (union xfs_suminfo_raw *)(hdr + 1);
-	else
-		info = args->sumbp->b_addr;
+	union xfs_suminfo_raw	*info = xfs_rtblock_payload(args->sumbp);
 
 	return info + index;
 }
-- 
2.53.0

