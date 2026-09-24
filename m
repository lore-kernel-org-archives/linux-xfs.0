Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602164570E9
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 09:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790243881; cv=none; b=jkKt6y9badxyfax+RqNrvbbW+Evb7zYke905RCwY21s1HS0W9CaEBCCzu7c+RWu7llHJ5K9loNUUFXUrl9B6hswpWVd/hv/3rtl3huN8q4alDGOCZDxljwfKRRmqxv51IpGfYxb/lXbibu/5LN1Q1Eb5ArQMOVe4ybKh5k97Xrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790243881; c=relaxed/simple;
	bh=sRF6QT43ndu3mUlgXVe372doOdFo+IRZBXAvDTcQ71E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+ppeghWo+Gx7ZlK79PNhtFRYa8LWLlPfXFtfy9u3C5xbY3dsIqdXoLcVRg/IpilEdwoYabrOOnWni2W+XMO4Yiij4Uw41npXfzPvoEYgjcHlf0raNyS2kcMrZYV0O377XqKoHGNuIuOk+xGXAph91tpc9uVMbXjDipzoqj7bv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uwRdy50K; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uwRdy50K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZXpV4D0SukIyf5PJPNY7rcFuHmOWBqE65hqDGgNiX8U=; b=uwRdy50KkTtFCzFc+xVMQKIVok
	f/kFOQoFecJEb5Di+AQAdWK4HsSXEoNyJIWk2ri7y3QbUtJpEB/d6ZjkJQ2uMI7FJsiCjWx/xuGS7
	T3Jw+m8kaaSc/hmfTmVMBKqG4F1DsCyGXJ8c1y+sNZe4GSf1dWFahPtIkPNa84xfWO99puIC1R02f
	F017FIC1Sx9+Ket/jOPvL9gtanrsRBD5yM+1nLodNuMUi8CCnDpBMOhzJGJ6sgzNCfjdSZnusbmEX
	QO5Gb9Ls9wI+O9NUV9sA5GJEDsrYDzq24dSOkk4Gn3Pt7+TLZjP74UgXTYOmtkPfPSrQx1tY9gVjQ
	5ZTGjo3A==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gD5-0000000AeMG-1403;
	Thu, 24 Sep 2026 09:57:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/9] xfs: centralize setting of buf_ops/buf_type/magic for rtblocks
Date: Thu, 24 Sep 2026 11:57:02 +0200
Message-ID: <20260924095740.2732474-2-hch@lst.de>
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

Add two tables for the buf_ops and buf_type, and derive the magic from
the buf_ops to make have a single source of truth for the different RT
block variants.  This cleans up the existing code and makes adding another
type of block/file easier.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.c | 40 +++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_rtbitmap.h | 15 ++------------
 2 files changed, 25 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index e62786e90f7b..3f7877220e05 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -125,6 +125,26 @@ const struct xfs_buf_ops xfs_rtsummary_buf_ops = {
 	.verify_struct	= xfs_rtbuf_verify,
 };
 
+static const struct xfs_buf_ops *xfs_rtblock_buf_ops[XFS_RTGI_MAX] = {
+	[XFS_RTGI_SUMMARY]	= &xfs_rtsummary_buf_ops,
+	[XFS_RTGI_BITMAP]	= &xfs_rtbitmap_buf_ops,
+};
+
+const struct xfs_buf_ops *
+xfs_rtblock_ops(
+	struct xfs_mount	*mp,
+	enum xfs_rtg_inodes	type)
+{
+	if (!xfs_has_rtgroups(mp))
+		return &xfs_rtbuf_ops;
+	return xfs_rtblock_buf_ops[type];
+}
+
+static enum xfs_blft xfs_rtblock_buf_types[XFS_RTGI_MAX] = {
+	[XFS_RTGI_SUMMARY]	= XFS_BLFT_RTSUMMARY_BUF,
+	[XFS_RTGI_BITMAP]	= XFS_BLFT_RTBITMAP_BUF,
+};
+
 /* Release cached rt bitmap and summary buffers. */
 void
 xfs_rtbuf_cache_relse(
@@ -158,7 +178,6 @@ xfs_rtbuf_get(
 	xfs_fileoff_t		*coffp;	/* cached block number */
 	struct xfs_buf		*bp;	/* block buffer, result */
 	struct xfs_bmbt_irec	map;
-	enum xfs_blft		buf_type;
 	int			nmap = 1;
 	int			error;
 
@@ -166,12 +185,10 @@ xfs_rtbuf_get(
 	case XFS_RTGI_SUMMARY:
 		cbpp = &args->sumbp;
 		coffp = &args->sumoff;
-		buf_type = XFS_BLFT_RTSUMMARY_BUF;
 		break;
 	case XFS_RTGI_BITMAP:
 		cbpp = &args->rbmbp;
 		coffp = &args->rbmoff;
-		buf_type = XFS_BLFT_RTBITMAP_BUF;
 		break;
 	default:
 		return -EINVAL;
@@ -222,7 +239,7 @@ xfs_rtbuf_get(
 		}
 	}
 
-	xfs_trans_buf_set_type(args->tp, bp, buf_type);
+	xfs_trans_buf_set_type(args->tp, bp, xfs_rtblock_buf_types[type]);
 	*cbpp = bp;
 	*coffp = block;
 	return 0;
@@ -1375,16 +1392,8 @@ xfs_rtfile_initialize_block(
 	struct xfs_buf		*bp;
 	void			*bufdata;
 	const size_t		copylen = mp->m_blockwsize << XFS_WORDLOG;
-	enum xfs_blft		buf_type;
 	int			error;
 
-	if (type == XFS_RTGI_BITMAP)
-		buf_type = XFS_BLFT_RTBITMAP_BUF;
-	else if (type == XFS_RTGI_SUMMARY)
-		buf_type = XFS_BLFT_RTSUMMARY_BUF;
-	else
-		return -EINVAL;
-
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtzero, 0, 0, 0, &tp);
 	if (error)
 		return error;
@@ -1399,16 +1408,13 @@ xfs_rtfile_initialize_block(
 	}
 	bufdata = bp->b_addr;
 
-	xfs_trans_buf_set_type(tp, bp, buf_type);
+	xfs_trans_buf_set_type(tp, bp, xfs_rtblock_buf_types[type]);
 	bp->b_ops = xfs_rtblock_ops(mp, type);
 
 	if (xfs_has_rtgroups(mp)) {
 		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
 
-		if (type == XFS_RTGI_BITMAP)
-			hdr->rt_magic = cpu_to_be32(XFS_RTBITMAP_MAGIC);
-		else
-			hdr->rt_magic = cpu_to_be32(XFS_RTSUMMARY_MAGIC);
+		hdr->rt_magic = bp->b_ops->magic[1];
 		hdr->rt_owner = cpu_to_be64(I_INO(ip));
 		hdr->rt_blkno = cpu_to_be64(XFS_FSB_TO_DADDR(mp, fsbno));
 		hdr->rt_lsn = 0;
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 22e5d9cd95f4..375cc48e1a53 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -354,19 +354,6 @@ xfs_suminfo_add(
 	return info->old;
 }
 
-static inline const struct xfs_buf_ops *
-xfs_rtblock_ops(
-	struct xfs_mount	*mp,
-	enum xfs_rtg_inodes	type)
-{
-	if (xfs_has_rtgroups(mp)) {
-		if (type == XFS_RTGI_SUMMARY)
-			return &xfs_rtsummary_buf_ops;
-		return &xfs_rtbitmap_buf_ops;
-	}
-	return &xfs_rtbuf_ops;
-}
-
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
@@ -419,6 +406,8 @@ xfs_filblks_t xfs_rtbitmap_blockcount_len(struct xfs_mount *mp,
 xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
 		unsigned int *rsumlevels);
 
+const struct xfs_buf_ops *xfs_rtblock_ops(struct xfs_mount *mp,
+		enum xfs_rtg_inodes type);
 int xfs_rtfile_initialize_blocks(struct xfs_rtgroup *rtg,
 		enum xfs_rtg_inodes type, xfs_fileoff_t offset_fsb,
 		xfs_fileoff_t end_fsb, void *data);
-- 
2.53.0

