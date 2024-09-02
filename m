Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9854219CC04
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301827; cv=none; b=JKwedtZmMpUaG5Nd3SJGH7bxQchSJV1V0Muc7vYdxLIMeCfJ8SPAFgwcMzdfAx1uM7+xhQY6joAOermm2dxLoSZ62lAKX1/2VqEXXmsnHwNM8JnAE4GJjXOQEnrfRa5tfA0qnU9G46hE/1yLY8YQkBkI2PiJjJ8IsdUhelXeVio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301827; c=relaxed/simple;
	bh=Y2fNuAFzHXmvGno8tyiMdW6YWlLtgpAw1MiwmPRKcjY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sRiqz2WV5WvOwCyp1RgySZo4sUSHaIbkAEV5F928iOeEoMy+U0vyRgBzsA//wTMxhdt+fZySatrbZ6W0eFe3HqOrHdFj+wsrpsADuCGiaJLsiN+r9iPaFFaDJEqx1j0LYcwhHNBHRrcF+K4+l1jSQUj7eJ83dXOAjHFBQ6trun4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XFWZBIcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XFWZBIcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A64C4CEC7;
	Mon,  2 Sep 2024 18:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301826;
	bh=Y2fNuAFzHXmvGno8tyiMdW6YWlLtgpAw1MiwmPRKcjY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XFWZBIcdJzRthLwvz8bZcW41w5SS+iXTZbn4MZ7tlwmvZr+8iBIamD2CYeDfawH83
	 O8iW2JtRjqI43jm83qzK8Lx63bQ8clUB2tGfWUBikWGFoJQKJwz8LzXGIlQEMWSqmM
	 2a5ZWgkITpEn1Bzu2ZhPdLrfyRQ3Xy9g3MrBZ8uKsSQssIECy/m0V1Rbl2HRCBrFDE
	 sShMqxyot5odRRCN865De+ZPsEnnpCrmPSgNk8/cLYJZvnf08RwT3CTwxaVpQcAd1X
	 d67yX0yez+VoAA8nfXYuZkn6qsBBH/IiwjUXUGTSyPtxvZSDFi8PQ10u2Xv0GNKT8x
	 XbHUTOHfz6tNg==
Date: Mon, 02 Sep 2024 11:30:25 -0700
Subject: [PATCH 03/10] xfs: rework the rtalloc fallback handling
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530106818.3326080.8590032731537560388.stgit@frogsfrogsfrogs>
In-Reply-To: <172530106749.3326080.9105141649726807892.stgit@frogsfrogsfrogs>
References: <172530106749.3326080.9105141649726807892.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

xfs_rtallocate currently has two fallbacks, when an allocation fails:

 1) drop the requested extent size alignment, if any, and retry
 2) ignore the locality hint

Oddly enough it does those in order, as trying a different location
is more in line with what the user asked for, and does it in a very
unstructured way.

Lift the fallback to try to allocate without the locality hint into
xfs_rtallocate to both perform them in a more sensible order and to
clean up the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   69 +++++++++++++++++++++++++-------------------------
 1 file changed, 34 insertions(+), 35 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 12cf7cb3c02c..a6b9ba572cdc 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1271,6 +1271,8 @@ xfs_rtallocate(
 	xfs_rtxlen_t		maxlen,
 	xfs_rtxlen_t		prod,
 	bool			wasdel,
+	bool			initial_user_data,
+	bool			*rtlocked,
 	xfs_rtblock_t		*bno,
 	xfs_extlen_t		*blen)
 {
@@ -1280,12 +1282,38 @@ xfs_rtallocate(
 	};
 	xfs_rtxnum_t		rtx;
 	xfs_rtxlen_t		len = 0;
-	int			error;
+	int			error = 0;
+
+	/*
+	 * Lock out modifications to both the RT bitmap and summary inodes.
+	 */
+	if (!*rtlocked) {
+		xfs_rtbitmap_lock(args.mp);
+		xfs_rtbitmap_trans_join(tp);
+		*rtlocked = true;
+	}
+
+	/*
+	 * For an allocation to an empty file at offset 0, pick an extent that
+	 * will space things out in the rt area.
+	 */
+	if (!start && initial_user_data)
+		start = xfs_rtpick_extent(args.mp, tp, maxlen);
 
 	if (start) {
 		error = xfs_rtallocate_extent_near(&args, start, minlen, maxlen,
 				&len, prod, &rtx);
-	} else {
+		/*
+		 * If we can't allocate near a specific rt extent, try again
+		 * without locality criteria.
+		 */
+		if (error == -ENOSPC) {
+			xfs_rtbuf_cache_relse(&args);
+			error = 0;
+		}
+	}
+
+	if (!error) {
 		error = xfs_rtallocate_extent_size(&args, minlen, maxlen, &len,
 				prod, &rtx);
 	}
@@ -1314,7 +1342,7 @@ xfs_bmap_rtalloc(
 {
 	struct xfs_mount	*mp = ap->ip->i_mount;
 	xfs_fileoff_t		orig_offset = ap->offset;
-	xfs_rtxnum_t		start;	   /* allocation hint rtextent no */
+	xfs_rtxnum_t		start = 0;   /* allocation hint rtextent no */
 	xfs_rtxlen_t		prod = 0;  /* product factor for allocators */
 	xfs_extlen_t		mod = 0;   /* product factor for allocators */
 	xfs_rtxlen_t		ralen = 0; /* realtime allocation length */
@@ -1323,7 +1351,6 @@ xfs_bmap_rtalloc(
 	xfs_extlen_t		minlen = mp->m_sb.sb_rextsize;
 	xfs_rtxlen_t		raminlen;
 	bool			rtlocked = false;
-	bool			ignore_locality = false;
 	int			error;
 
 	align = xfs_get_extsz_hint(ap->ip);
@@ -1361,28 +1388,8 @@ xfs_bmap_rtalloc(
 	ASSERT(raminlen > 0);
 	ASSERT(raminlen <= ralen);
 
-	/*
-	 * Lock out modifications to both the RT bitmap and summary inodes
-	 */
-	if (!rtlocked) {
-		xfs_rtbitmap_lock(mp);
-		xfs_rtbitmap_trans_join(ap->tp);
-		rtlocked = true;
-	}
-
-	if (ignore_locality) {
-		start = 0;
-	} else if (xfs_bmap_adjacent(ap)) {
+	if (xfs_bmap_adjacent(ap))
 		start = xfs_rtb_to_rtx(mp, ap->blkno);
-	} else if (ap->datatype & XFS_ALLOC_INITIAL_USER_DATA) {
-		/*
-		 * If it's an allocation to an empty file at offset 0, pick an
-		 * extent that will space things out in the rt area.
-		 */
-		start = xfs_rtpick_extent(mp, ap->tp, ralen);
-	} else {
-		start = 0;
-	}
 
 	/*
 	 * Only bother calculating a real prod factor if offset & length are
@@ -1398,7 +1405,8 @@ xfs_bmap_rtalloc(
 	}
 
 	error = xfs_rtallocate(ap->tp, start, raminlen, ralen, prod, ap->wasdel,
-			       &ap->blkno, &ap->length);
+			ap->datatype & XFS_ALLOC_INITIAL_USER_DATA, &rtlocked,
+			&ap->blkno, &ap->length);
 	if (error == -ENOSPC) {
 		if (align > mp->m_sb.sb_rextsize) {
 			/*
@@ -1414,15 +1422,6 @@ xfs_bmap_rtalloc(
 			goto retry;
 		}
 
-		if (!ignore_locality && start != 0) {
-			/*
-			 * If we can't allocate near a specific rt extent, try
-			 * again without locality criteria.
-			 */
-			ignore_locality = true;
-			goto retry;
-		}
-
 		ap->blkno = NULLFSBLOCK;
 		ap->length = 0;
 		return 0;

