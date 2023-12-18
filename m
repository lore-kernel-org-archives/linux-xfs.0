Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B95263A8
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 04:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PajDA/Mu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gA0oubjC7cQkXPrzuxt1McNkn8EATDnhrJxOiweeOQk=; b=PajDA/Mu70cbWc+qsp4QwUQqhD
	mtNG5cR6OI/lZWg90fZW2t1D/BdWgLHH8EQsbgp9rR/PbougID1O0tz75PgWuDLCQ/zqRQx5OHUsc
	WCLfDFK0Wqf7AfUzYHSxzXwBK3IcSVTgI59DcQkEoIz7SVGughkxC0ncmakIhK0W1eQBAj8Ycb1Q2
	7I77TIWIn0EGQe92YrNTlKNFoRAVZOW2ScfGPBD8gmlrvDKNoZ9cLPFEBx9b9w5ZrGvJuy1Ax05Ra
	2sR21Y7aulz34YuRZZH/bGwLw2EGuTzHXitr2gcebjQYU8jzCpCOottN9ZIU/S7Ai3CGedtpUpjSg
	Yfv5p+xw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rF5i7-0095K8-1q;
	Mon, 18 Dec 2023 04:58:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 21/22] xfs: fold xfs_rtallocate_extent into xfs_bmap_rtalloc
Date: Mon, 18 Dec 2023 05:57:37 +0100
Message-Id: <20231218045738.711465-22-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231218045738.711465-1-hch@lst.de>
References: <20231218045738.711465-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There isn't really much left in xfs_rtallocate_extent now, fold it into
the only caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 67 ++++++++++++--------------------------------
 1 file changed, 18 insertions(+), 49 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 8a09e42b2dcdcc..4b2de22bdd70cc 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1064,53 +1064,6 @@ xfs_growfs_rt(
 	return error;
 }
 
-/*
- * Allocate an extent in the realtime subvolume, with the usual allocation
- * parameters.  The length units are all in realtime extents, as is the
- * result block number.
- */
-static int
-xfs_rtallocate_extent(
-	struct xfs_trans	*tp,
-	xfs_rtxnum_t		start,	/* starting rtext number to allocate */
-	xfs_rtxlen_t		minlen,	/* minimum length to allocate */
-	xfs_rtxlen_t		maxlen,	/* maximum length to allocate */
-	xfs_rtxlen_t		*len,	/* out: actual length allocated */
-	int			wasdel,	/* was a delayed allocation extent */
-	xfs_rtxlen_t		prod,	/* extent product factor */
-	xfs_rtxnum_t		*rtx)	/* out: start rtext allocated */
-{
-	struct xfs_rtalloc_args	args = {
-		.mp		= tp->t_mountp,
-		.tp		= tp,
-	};
-	int			error;	/* error value */
-
-	ASSERT(xfs_isilocked(args.mp->m_rbmip, XFS_ILOCK_EXCL));
-	ASSERT(minlen > 0 && minlen <= maxlen);
-
-	if (start == 0) {
-		error = xfs_rtallocate_extent_size(&args, minlen,
-				maxlen, len, prod, rtx);
-	} else {
-		error = xfs_rtallocate_extent_near(&args, start, minlen,
-				maxlen, len, prod, rtx);
-	}
-	xfs_rtbuf_cache_relse(&args);
-	if (error)
-		return error;
-
-	/*
-	 * If it worked, update the superblock.
-	 */
-	ASSERT(*len >= minlen && *len <= maxlen);
-	if (wasdel)
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_RES_FREXTENTS, -(long)*len);
-	else
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FREXTENTS, -(long)*len);
-	return 0;
-}
-
 /*
  * Initialize realtime fields in the mount structure.
  */
@@ -1375,6 +1328,10 @@ xfs_bmap_rtalloc(
 	xfs_rtxlen_t		raminlen;
 	bool			rtlocked = false;
 	bool			ignore_locality = false;
+	struct xfs_rtalloc_args	args = {
+		.mp		= mp,
+		.tp		= ap->tp,
+	};
 	int			error;
 
 	align = xfs_get_extsz_hint(ap->ip);
@@ -1407,6 +1364,8 @@ xfs_bmap_rtalloc(
 	 */
 	ralen = xfs_extlen_to_rtxlen(mp, min(ap->length, XFS_MAX_BMBT_EXTLEN));
 	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
+	ASSERT(raminlen > 0);
+	ASSERT(raminlen <= ralen);
 
 	/*
 	 * Lock out modifications to both the RT bitmap and summary inodes
@@ -1448,8 +1407,15 @@ xfs_bmap_rtalloc(
 			xfs_rtalloc_align_minmax(&raminlen, &ralen, &prod);
 	}
 
-	error = xfs_rtallocate_extent(ap->tp, start, raminlen, ralen, &ralen,
-			ap->wasdel, prod, &rtx);
+	if (start) {
+		error = xfs_rtallocate_extent_near(&args, start, raminlen,
+				ralen, &ralen, prod, &rtx);
+	} else {
+		error = xfs_rtallocate_extent_size(&args, raminlen,
+				ralen, &ralen, prod, &rtx);
+	}
+	xfs_rtbuf_cache_relse(&args);
+
 	if (error == -ENOSPC) {
 		if (align > mp->m_sb.sb_rextsize) {
 			/*
@@ -1481,6 +1447,9 @@ xfs_bmap_rtalloc(
 	if (error)
 		return error;
 
+	xfs_trans_mod_sb(ap->tp, ap->wasdel ?
+			XFS_TRANS_SB_RES_FREXTENTS : XFS_TRANS_SB_FREXTENTS,
+			-(long)ralen);
 	ap->blkno = xfs_rtx_to_rtb(mp, rtx);
 	ap->length = xfs_rtxlen_to_extlen(mp, ralen);
 	xfs_bmap_alloc_account(ap);
-- 
2.39.2

