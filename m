Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAEF31D36B;
	Fri, 23 Jan 2026 07:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769151725; cv=none; b=AJkQ5l/Gf7rsaSdKiT/Z3flQqroITWeLm7qWkj9U7Cw4J3Rimt4PnuSsraD2hZZiqNnEMXDea6+mY+JOttoEpFDdz/clhoXBlmVDsi6XRqYKFnVVv6Z/D0ogTJAyeP1ykR9jAUGAUwXE3CyipcRMQAFmVuxi8LOhuQukxw1yK04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769151725; c=relaxed/simple;
	bh=P+x+eNJ3yET/qiSsJT1535LQkacynghRpdRaUzPSFiU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BkInVYGTohTaTqkhrvgT+rYcRPRcUrY1T1dPcikzt566mvfhCVSw4zpOm2UlNVWZlq5bmzm1k6bF/DSY1iWWM9XVJomv144TgaYE/RpXiKax/DGAhe0Ef07D8+D58jHNoR6Wg3/ZmBXU0IVFTIK5HXTG3yZk6ZA/z+TVWqGAwxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pe75yKio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pe75yKio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9ADC4CEF1;
	Fri, 23 Jan 2026 07:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769151724;
	bh=P+x+eNJ3yET/qiSsJT1535LQkacynghRpdRaUzPSFiU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pe75yKioJ6Nwl/sSjmRJWrq3gn+Z/dgDCQZKRxZznhw0L4iieRFGv1KkxtJzr900i
	 K386ouMw/qypgYbtsgmTxAg1KhlLrLvQZc7EWwToyX/8xG/jGi8JPisFYkLE0Rr9+m
	 IhD/U8iEV1DMS6DXmV/GVS2NUEzsms4ikZuzeny+SYq/A2I5/FDliON8pjpRBL3hNB
	 7c9cq+eoPiweL1bQWFa12Udit13uJoNpa7YXa11RiinY14hb5HC2RySJxFwwQ+sF7H
	 H2KkKJdhlS31BUG8gyXVlNOtIg0PeC9keh0vuHzBo1dlVG8oeMQbXjPQr7YW3/jK2J
	 wKVqnuJ0X4MUQ==
Date: Thu, 22 Jan 2026 23:02:04 -0800
Subject: [PATCH 5/6] xfs: fix the xattr scrub to detect freemap/entries array
 collisions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176915153117.1677392.15954705106402703328.stgit@frogsfrogsfrogs>
In-Reply-To: <176915152981.1677392.17448598289298023614.stgit@frogsfrogsfrogs>
References: <176915152981.1677392.17448598289298023614.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

