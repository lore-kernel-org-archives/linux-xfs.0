Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z9I0suFx"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3BCB9
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=udvwTMDrzl3TmmWC86yd9hoDMgfsXV9mc2JxM8NDVWY=; b=Z9I0suFx4CK6v61VIxK6SfnmGc
	M9IJbLPEftJ1ofRJS87q5j3Z92f32xk5GKpf2wTKH+aGu/ISjXFmDjdFgbkiLycuJhg23N25sw3Nr
	xD74maarct8j7B50sdY0cWs1vjlboVjUto7YwtnRMzQDtKefDVCSYf58p9cmFk+uXWZSTM3PzBEsd
	kuf+xecbiMR6ePLb7Nb01ODAIjMbGLRiNmBPp/Tq46Eh+TZMrtk8VOVB5NCa1yzJi15hveu7acXvE
	4OSk2yTuGJsE/KBlpvQ8KoIAzmBGGiZrLDtLOId5oSvTenEEHBlpeBfh85XAw/LiX5niEvFHGusqg
	10t52Y6A==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDfJj-00GzVr-1J;
	Thu, 14 Dec 2023 06:35:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 19/19] xfs: fold xfs_rtallocate_extent into xfs_bmap_rtalloc
Date: Thu, 14 Dec 2023 07:34:38 +0100
Message-Id: <20231214063438.290538-20-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231214063438.290538-1-hch@lst.de>
References: <20231214063438.290538-1-hch@lst.de>
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
---
 fs/xfs/xfs_rtalloc.c | 67 ++++++++++++--------------------------------
 1 file changed, 18 insertions(+), 49 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 16255617629ef5..cbcdf604756fd3 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1063,53 +1063,6 @@ xfs_growfs_rt(
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
@@ -1374,6 +1327,10 @@ xfs_bmap_rtalloc(
 	xfs_rtxlen_t		raminlen;
 	bool			rtlocked = false;
 	bool			ignore_locality = false;
+	struct xfs_rtalloc_args	args = {
+		.mp		= mp,
+		.tp		= ap->tp,
+	};
 	int			error;
 
 	align = xfs_get_extsz_hint(ap->ip);
@@ -1406,6 +1363,8 @@ xfs_bmap_rtalloc(
 	 */
 	ralen = xfs_extlen_to_rtxlen(mp, min(ap->length, XFS_MAX_BMBT_EXTLEN));
 	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
+	ASSERT(raminlen > 0);
+	ASSERT(raminlen <= ralen);
 
 	/*
 	 * Lock out modifications to both the RT bitmap and summary inodes
@@ -1447,8 +1406,15 @@ xfs_bmap_rtalloc(
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
@@ -1480,6 +1446,9 @@ xfs_bmap_rtalloc(
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

