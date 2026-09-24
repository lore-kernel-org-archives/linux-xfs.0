Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8184457A4
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 09:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790243900; cv=none; b=F701Wp6QPCCEDY54T60zfgd4HaKoomBkfB+s0TBs/B7wnmjDtLkzc9ChMYiUkQcQx4ZCbiNknkuBcx1+CHHXvfUvrAdIMoItFiqjHW4unETE6OByCpIWW6u4bRNrtC0eRTWxWRGvXUxgfZcg1vYywmrG9XH+ZQpUO1jH5HesVLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790243900; c=relaxed/simple;
	bh=HUkZGF/CP7U+laPFngy668ob1AXrLd0qdFjXrTzV/4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bvyo8T7m07vuBG9xpWWJKWc8/0S6czLGHFWZ1aqy8IgLobL+TIczpW9gAwfwxTrkv070DwQKp/9T1ITDSvAHLYRwhRE6XaC00NMMysizuBAIjNBKTIjKoHen6WytccHv2i3y/upLdg2TYmLVeszhY7mlv5YufuAC7j8ruajp29c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IRFwDUX9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IRFwDUX9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RyoWmcIgcQofGCQkVARRqmPujZt6+vAU2fOwO1vnAPw=; b=IRFwDUX9+Q3bROEHoJ6HUMn/Dp
	FL7fJorMwUN0xX+mziawKpCgPu4SsCNWvTbTBZKZqPT+mgSBaEXOaKvdVZhS1Ga0AWK3HKKyP/cK7
	MBphETEoFidYk+3buRTr9Y/AHG6IAWxGOqs3Od0PnhSXXM2fKEn7NKw3im41uTOf3iiMCqEqeb+5/
	kMfVBu6/G/ZRP93eGbZlkZeVHDnSydi2FOgT9rK+SX3SJyc7lNLy4vxBi5GemYbfiC1E5IWj3nuB+
	Vye8BqwSE3DXKs5HfV9gOWcpONUa0R8dJlW9XErX/dI7F7cVr23B1Anq39017Lc7CejcZNumU4WWU
	tfbxHiKQ==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gDR-0000000AeNY-20wn;
	Thu, 24 Sep 2026 09:58:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 8/9] xfs: factor out a xfs_zoned_fill_srcmap helper
Date: Thu, 24 Sep 2026 11:57:09 +0200
Message-ID: <20260924095740.2732474-9-hch@lst.de>
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

The code filling the srcmap in xfs_zoned_buffered_write_iomap_begin isn't
terribly complicated, but fairly deeply indented and will become a bit
more complex soon.  Factor it into a helper and add some comments.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 53 ++++++++++++++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7c6238fed61e..7bc17f179be7 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1588,6 +1588,37 @@ xfs_bmapi_reserve_delalloc(
 	return error;
 }
 
+static int
+xfs_zoned_fill_srcmap(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		offset_fsb,
+	xfs_fileoff_t		*end_fsb,
+	unsigned		flags,
+	struct iomap		*srcmap)
+{
+	struct xfs_bmbt_irec	smap;
+	struct xfs_iext_cursor	scur;
+
+	if (!xfs_iext_lookup_extent(ip, &ip->i_df, offset_fsb, &scur, &smap))
+		smap.br_startoff = *end_fsb; /* fake hole until EOF */
+	if (smap.br_startoff > offset_fsb) {
+		/*
+		 * There is a hole at @offset_fsb.  Only map until the end of
+		 * the of it.
+		 */
+		*end_fsb = min(*end_fsb, smap.br_startoff);
+		return 0;
+	}
+
+	/*
+	 * There is a data fork mapping, only map until the end of it.
+	 */
+	*end_fsb = min(*end_fsb, smap.br_startoff + smap.br_blockcount);
+	xfs_trim_extent(&smap, offset_fsb, *end_fsb - offset_fsb);
+	return xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, 0,
+			xfs_iomap_inode_sequence(ip, 0));
+}
+
 static int
 xfs_zoned_buffered_write_iomap_begin(
 	struct inode		*inode,
@@ -1655,24 +1686,10 @@ xfs_zoned_buffered_write_iomap_begin(
 	if (!IS_ALIGNED(offset, mp->m_sb.sb_blocksize) ||
 	    !IS_ALIGNED(offset + count, mp->m_sb.sb_blocksize) ||
 	    (flags & IOMAP_ZERO)) {
-		struct xfs_bmbt_irec	smap;
-		struct xfs_iext_cursor	scur;
-
-		if (!xfs_iext_lookup_extent(ip, &ip->i_df, offset_fsb, &scur,
-				&smap))
-			smap.br_startoff = end_fsb; /* fake hole until EOF */
-		if (smap.br_startoff > offset_fsb) {
-			end_fsb = min(end_fsb, smap.br_startoff);
-		} else {
-			end_fsb = min(end_fsb,
-				smap.br_startoff + smap.br_blockcount);
-			xfs_trim_extent(&smap, offset_fsb,
-					end_fsb - offset_fsb);
-			error = xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, 0,
-					xfs_iomap_inode_sequence(ip, 0));
-			if (error)
-				goto out_unlock;
-		}
+		error = xfs_zoned_fill_srcmap(ip, offset_fsb, &end_fsb, flags,
+				srcmap);
+		if (error)
+			goto out_unlock;
 	}
 
 	if (!ip->i_cowfp)
-- 
2.53.0

