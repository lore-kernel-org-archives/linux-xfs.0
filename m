Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61142EB5A6;
	Sun,  1 Mar 2026 01:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329909; cv=none; b=e9VKl6yqacGeIuO9rpGCu2FStbOJ3WanH7guU17WGKQZDLxUBC/KLVEnmYB87GdqpSR+6OwkktzlAcR5YN/InN/TUWqOElpXbs1uw0DoVFsGyDtezJrUwC3ET3cJln8EEXw0w19DkQF7Mn8RTBv4l3Y+KlbK4NQG439U4JPlXNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329909; c=relaxed/simple;
	bh=7z76xb171HD2hMrBxyWUmjotyA7KN35ExyJ38+UkB40=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GmneNdfLGm1fJxE7WKizcMrgSE966yvTI29sEIYhuGaJ6DRCat4krkQeEG1wS3gmmWUckjF7+XFdFtetTuVn20JkWeqNS9cK18sXCxdI42KAuMpXRSGZyBL9Vvha5rZikuGhamGfU1sFjb7r1J/rdYO+PF+3NwQxapPdgiFkaRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uchm0juv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uchm0juv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3649FC19421;
	Sun,  1 Mar 2026 01:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329909;
	bh=7z76xb171HD2hMrBxyWUmjotyA7KN35ExyJ38+UkB40=;
	h=From:To:Cc:Subject:Date:From;
	b=Uchm0juvltNI7UXoU7lHtGYqBbGKOboXcGn2VVUBtDQppIFZ449nlCjQkSYa5UcIs
	 oiIPeRE86zBcs//kuHxfk7Gk8YflD/hhsUBHcV8eefT7M6hCzebm/muw1oRhngi8Py
	 /aWjdEOUCB/LPNlF22on2pC0ChpsPmM/V381mpfgd4x0gAVt18ZatNqVAqJDvGVE/A
	 ye2obfJwYOqv3ASLgIIqJxdpcRINBo3F3wrRgng7j2GFXHW/mVarUKngiqaedckWKn
	 b0mVHzuVKQhsfgqRJWyQNmTNl+swLp/Qi1V6wwjBvIpTfgGxEteY95iMhFWpZkYnjv
	 Qbc8o8F7aksUQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: FAILED: Patch "xfs: fix the xattr scrub to detect freemap/entries array collisions" failed to apply to 5.15-stable tree
Date: Sat, 28 Feb 2026 20:51:47 -0500
Message-ID: <20260301015148.1718226-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 6fed8270448c246e706921c177e9633013dd3fcf Mon Sep 17 00:00:00 2001
From: "Darrick J. Wong" <djwong@kernel.org>
Date: Fri, 23 Jan 2026 09:27:33 -0800
Subject: [PATCH] xfs: fix the xattr scrub to detect freemap/entries array
 collisions

In the previous patches, we observed that it's possible for there to be
freemap entries with zero size but a nonzero base.  This isn't an
inconsistency per se, but older kernels can get confused by this and
corrupt the block, leading to corruption.

If we see this, flag the xattr structure for optimization so that it
gets rebuilt.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: 13791d3b833428 ("xfs: scrub extended attribute leaf space")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/attr.c | 54 ++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index eeb5ac34d7422..a397c50b77943 100644
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
-- 
2.51.0




