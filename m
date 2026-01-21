Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E9544A73B;
	Wed, 21 Jan 2026 06:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977540; cv=none; b=pw9O0GyeeHUS4nivgb50RGO07U1rVRIH35k2Dxm3IX3zQ5pXxcrsFEGMwYuQr+oJ7rfjDqxmIseUVwFmwxybDnfcDs/enbsIzyDr/CjajGgcEH9OMum/Yubow8f0O0wXWPf8L9f1gPxjETOet5Jx1MKsJb98wCqIPc7sRPOKiGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977540; c=relaxed/simple;
	bh=tGwe/ysEYuZR8J5CPexq7ZZWJzeyRWgxg8diucmF4jo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sNH7ET7cXb+ZYMqxoPRnrUS2zwiirn9TvTGSgIG7cWBmJRNWO/EZ9Pp7edH+s0/iDLbu6a/FiA39QQJFnJFR3Aax4f6ONhz6XTUpCusfAoIxeAEU1uvlaOBcedI33rZrMOl/vh0FGfGfklbc9njKqUZN1yEk+MuSjA05h/EfL8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VWD7ka7r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VWD7ka7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFEAC16AAE;
	Wed, 21 Jan 2026 06:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768977540;
	bh=tGwe/ysEYuZR8J5CPexq7ZZWJzeyRWgxg8diucmF4jo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VWD7ka7rJTVXQjR9ebykzmJCyj3EE3eIiiecB4HiGB+R6Bks0lU50DQtuXy3mVtQ5
	 XY9EfHJ54qjVQxcnE9SSFR7WM/N6jnQhYAYSkxIMVcnxE3Qyn1+QRaG8pOGBKg/iqP
	 l3R7HuihiMj87npn/mTnHkWORh+Rl7tj1Puso5LYsXQQewlMjkpNMuLkboDJCadKJw
	 O68NUmIMEog64TM/z76vG1k/28dqidXgC4M1WH+Phlja7nDDlp6eUGeCbdXGFYZQhZ
	 KMJRxDVvNJ5WKls1zJrUWpp/4Ag3yHlM7nIupl2w4thvg4ivXNJu5oZE62pKqEEA5D
	 Ozuv5wgn1PVwQ==
Date: Tue, 20 Jan 2026 22:38:59 -0800
Subject: [PATCH 5/6] xfs: fix the xattr scrub to detect freemap/entries array
 collisions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176897695663.202569.9251656342143621163.stgit@frogsfrogsfrogs>
In-Reply-To: <176897695523.202569.10735226881884087217.stgit@frogsfrogsfrogs>
References: <176897695523.202569.10735226881884087217.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In the previous patches, we observed that it's possible for there to be
freemap entries with zero size but a nonzero base.  This isn't an
inconsistency per se, but older kernels can get confused by this and
corrupt the block, leading to corruption.

If we see this, flag the xattr structure for optimization so that it
gets rebuilt.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: 13791d3b833428 ("xfs: scrub extended attribute leaf space")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c |   54 ++++++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 708334f9b2bd13..ef299be01de5ea 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -287,32 +287,6 @@ xchk_xattr_set_map(
 	return ret;
 }
 
-/*
- * Check the leaf freemap from the usage bitmap.  Returns false if the
- * attr freemap has problems or points to used space.
- */
-STATIC bool
-xchk_xattr_check_freemap(
-	struct xfs_scrub		*sc,
-	struct xfs_attr3_icleaf_hdr	*leafhdr)
-{
-	struct xchk_xattr_buf		*ab = sc->buf;
-	unsigned int			mapsize = sc->mp->m_attr_geo->blksize;
-	int				i;
-
-	/* Construct bitmap of freemap contents. */
-	bitmap_zero(ab->freemap, mapsize);
-	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
-		if (!xchk_xattr_set_map(sc, ab->freemap,
-				leafhdr->freemap[i].base,
-				leafhdr->freemap[i].size))
-			return false;
-	}
-
-	/* Look for bits that are set in freemap and are marked in use. */
-	return !bitmap_intersects(ab->freemap, ab->usedmap, mapsize);
-}
-
 /*
  * Check this leaf entry's relations to everything else.
  * Returns the number of bytes used for the name/value data.
@@ -403,6 +377,7 @@ xchk_xattr_block(
 
 	*last_checked = blk->blkno;
 	bitmap_zero(ab->usedmap, mp->m_attr_geo->blksize);
+	bitmap_zero(ab->freemap, mp->m_attr_geo->blksize);
 
 	/* Check all the padding. */
 	if (xfs_has_crc(ds->sc->mp)) {
@@ -449,6 +424,9 @@ xchk_xattr_block(
 	if ((char *)&entries[leafhdr.count] > (char *)leaf + leafhdr.firstused)
 		xchk_da_set_corrupt(ds, level);
 
+	if (ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
 	buf_end = (char *)bp->b_addr + mp->m_attr_geo->blksize;
 	for (i = 0, ent = entries; i < leafhdr.count; ent++, i++) {
 		/* Mark the leaf entry itself. */
@@ -467,7 +445,29 @@ xchk_xattr_block(
 			goto out;
 	}
 
-	if (!xchk_xattr_check_freemap(ds->sc, &leafhdr))
+	/* Construct bitmap of freemap contents. */
+	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
+		if (!xchk_xattr_set_map(ds->sc, ab->freemap,
+				leafhdr.freemap[i].base,
+				leafhdr.freemap[i].size))
+			xchk_da_set_corrupt(ds, level);
+
+		/*
+		 * freemap entries with zero length and nonzero base can cause
+		 * problems with older kernels, so we mark these for preening
+		 * even though there's no inconsistency.
+		 */
+		if (leafhdr.freemap[i].size == 0 &&
+		    leafhdr.freemap[i].base > 0)
+			xchk_da_set_preen(ds, level);
+
+		if (ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+			goto out;
+	}
+
+	/* Look for bits that are set in freemap and are marked in use. */
+	if (bitmap_intersects(ab->freemap, ab->usedmap,
+			mp->m_attr_geo->blksize))
 		xchk_da_set_corrupt(ds, level);
 
 	if (leafhdr.usedbytes != usedbytes)

