Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08C823A6
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372127; cv=none; b=DM/8aBC+1iMTfG/4OYyrvJdpu+QZlgVWzW4l5IivaBUDXfxtOkYVQAduZafySn9kd/0KkVVTPtPKJmY0WcFL7nQIsVngAtxfXAT7KTkP3jWwH9ecvDUpH3+JetyEp5w3l/TbsPZWtBH0q+AwlbsuiRHXmw3CFoF/XoAO+TCMs/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372127; c=relaxed/simple;
	bh=2UfE5ccd+bJCJ4lIVqkQAC7na7/4gpuiHYMB2kSC524=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h4HVr3kitVG2aUNJh1nYQpWMCBEpWVlX9G7rx3doleIrXbvYDw6Lk7qdLqPjl5hdoHV7oDoUQr2ok0VSE4MQfk/8U/UwXgVWnbieBXwa2cp5WOYFgJ/PN0VqP+dL7EFrGkRK9XP87mpGKv4goLbKuyN2KnvNOD9VUua7avJnwtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i4lF5O1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i4lF5O1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BD9C32782;
	Fri, 23 Aug 2024 00:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372126;
	bh=2UfE5ccd+bJCJ4lIVqkQAC7na7/4gpuiHYMB2kSC524=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i4lF5O1wasbxhcsetfD2Dw2G/iNjr28PnBIofQKLxIfptUyYWvNxrKphSP1cLdHdn
	 ccLSVunl0qjdksBjYePOX5URMR4yrl58WjGcQo7iCmxw0PUaBf5JVvogki6XkRHWqg
	 tXbQ6l/aOBXKkyCakQLCsPNnMmam/E6lFy1xq+IGjGM36I2e7PT7VJBok7ns9DhBuu
	 RIeITPclkAvbf+lTE5MHI335MqIsXj6jdsRuuO7v4z7SbH7GCyIhluiBsNY1iasTGr
	 v/0qleAfXx1n50c99n7q71sFSVu6EhidJgKjMvWkowpH8A50wXYFGKC1JUXFSF3AXv
	 cM6DmIbUDBx6w==
Date: Thu, 22 Aug 2024 17:15:26 -0700
Subject: [PATCH 03/24] xfs: rework the rtalloc fallback handling
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087294.59588.10330585198208756592.stgit@frogsfrogsfrogs>
In-Reply-To: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
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
index 861a82471b5d0..f39f05397201a 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1277,6 +1277,8 @@ xfs_rtallocate(
 	xfs_rtxlen_t		maxlen,
 	xfs_rtxlen_t		prod,
 	bool			wasdel,
+	bool			initial_user_data,
+	bool			*rtlocked,
 	xfs_rtblock_t		*bno,
 	xfs_extlen_t		*blen)
 {
@@ -1286,12 +1288,38 @@ xfs_rtallocate(
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
@@ -1320,7 +1348,7 @@ xfs_bmap_rtalloc(
 {
 	struct xfs_mount	*mp = ap->ip->i_mount;
 	xfs_fileoff_t		orig_offset = ap->offset;
-	xfs_rtxnum_t		start;	   /* allocation hint rtextent no */
+	xfs_rtxnum_t		start = 0;   /* allocation hint rtextent no */
 	xfs_rtxlen_t		prod = 0;  /* product factor for allocators */
 	xfs_extlen_t		mod = 0;   /* product factor for allocators */
 	xfs_rtxlen_t		ralen = 0; /* realtime allocation length */
@@ -1329,7 +1357,6 @@ xfs_bmap_rtalloc(
 	xfs_extlen_t		minlen = mp->m_sb.sb_rextsize;
 	xfs_rtxlen_t		raminlen;
 	bool			rtlocked = false;
-	bool			ignore_locality = false;
 	int			error;
 
 	align = xfs_get_extsz_hint(ap->ip);
@@ -1367,28 +1394,8 @@ xfs_bmap_rtalloc(
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
@@ -1404,7 +1411,8 @@ xfs_bmap_rtalloc(
 	}
 
 	error = xfs_rtallocate(ap->tp, start, raminlen, ralen, prod, ap->wasdel,
-			       &ap->blkno, &ap->length);
+			ap->datatype & XFS_ALLOC_INITIAL_USER_DATA, &rtlocked,
+			&ap->blkno, &ap->length);
 	if (error == -ENOSPC) {
 		if (align > mp->m_sb.sb_rextsize) {
 			/*
@@ -1420,15 +1428,6 @@ xfs_bmap_rtalloc(
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

