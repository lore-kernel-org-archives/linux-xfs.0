Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0666137BE63
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jun 2026 12:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780317860; cv=none; b=oOooCX411k1V9yfabzVYGC1wiXF1UoRpE+rTtT8yIKMpK2HvUCUL07++TwiH/LfbtNSIIe37xrTHJ1mKqzEgA5VcZgr3antKMsLfw0XiotfAr5iu9YjDgjtfDje2RtPFmsXFhjYjFvFst18jtsemhZiuOSknE1lWYCHX2MHZU+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780317860; c=relaxed/simple;
	bh=a02Oup7vBkFHSlY3ewX+P1Gw+CAU+S43mH98CnyGxiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezHI9G6nw/xUwSBYUgCNCEXjMolM5xoEKxc6YvYcxAxPTLtMQDJynuzWO18SEcn9VEdyj5K7QkqXAT87QwjwshS59lEIwkgjUGyA2uYsvsKfxM4gQR/ByQxZczsVzLlYyFeP7RxSgJIrHw9ZaMUd7UhiPXuQIaEuyuKwPKINW0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Gty1aEW/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gty1aEW/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DnwkirZVJTYOjT0AL9GyUFq0hJPW3DGTAO7tZMtC8/k=; b=Gty1aEW/HvlpWr2goY5fGfks9C
	r5TiZj/d2MUcPVOEKMeaMTcCfAXFg8Wl6oJjzCpA/+/D9c0sGyyAXDIcblAGCY8hYxMPGlAJfEdci
	BZZ9BZgC7MYi+65SwqcAV7lb2mCsBJEQVYnH28yJzmpwN924W4vq2vTgZs3FedIeJ+BZIhpgg7jpL
	TAQ2a9Vw4ETeIyEhcTVKYQ0YpDk5vtx7pWCd3JfDobFS5h2MGK2WznuA3P7qeazUmaSdbvWm3BfDD
	s5/aWRBVzXuePI7PBKCvQNq94fRLlFieXGhnrp4icsc9vZwDbRdO/7RHVyvw1Saa314fh6hWDGUA5
	AmEXbvbQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU208-0000000BA1e-3VqC;
	Mon, 01 Jun 2026 12:44:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] xfs: cleanup xfs_imap
Date: Mon,  1 Jun 2026 14:43:47 +0200
Message-ID: <20260601124410.3508980-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260601124410.3508980-1-hch@lst.de>
References: <20260601124410.3508980-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Reshuffle the code a bit so that the imap_lookup and filling out of the
xfs_imap structure aren't duplicated.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ialloc.c | 64 +++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 8d6a4fe4228c..a3fe4e5b1cdd 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2511,44 +2511,38 @@ xfs_imap(
 	 * inodes in stale state on disk. Hence we have to do a btree lookup
 	 * in all cases where an untrusted inode number is passed.
 	 */
-	if (flags & XFS_IGET_UNTRUSTED) {
-		error = xfs_imap_lookup(pag, tp, agino, agbno,
-					&chunk_agbno, &offset_agbno, flags);
-		if (error)
-			return error;
-		goto out_map;
-	}
+	if (!(flags & XFS_IGET_UNTRUSTED)) {
+		/*
+		 * If the inode cluster size is the same or smaller than the
+		 * blocksize, get to the buffer by simple arithmetics.
+		 */
+		if (M_IGEO(mp)->blocks_per_cluster == 1) {
+			cluster_agbno = agbno;
+			offset = XFS_INO_TO_OFFSET(mp, ino);
+			ASSERT(offset < mp->m_sb.sb_inopblock);
+			goto out;
+		}
 
-	/*
-	 * If the inode cluster size is the same as the blocksize or
-	 * smaller we get to the buffer by simple arithmetics.
-	 */
-	if (M_IGEO(mp)->blocks_per_cluster == 1) {
-		offset = XFS_INO_TO_OFFSET(mp, ino);
-		ASSERT(offset < mp->m_sb.sb_inopblock);
-
-		imap->im_blkno = xfs_agbno_to_daddr(pag, agbno);
-		imap->im_len = XFS_FSB_TO_BB(mp, 1);
-		imap->im_boffset = (unsigned short)(offset <<
-							mp->m_sb.sb_inodelog);
-		return 0;
-	}
+		/*
+		 * If the inode chunks are aligned, use simple maths to find the
+		 * location.
+		 */
+		if (M_IGEO(mp)->inoalign_mask) {
+			offset_agbno = agbno & M_IGEO(mp)->inoalign_mask;
+			chunk_agbno = agbno - offset_agbno;
+			goto out_map;
+		}
 
-	/*
-	 * If the inode chunks are aligned then use simple maths to
-	 * find the location. Otherwise we have to do a btree
-	 * lookup to find the location.
-	 */
-	if (M_IGEO(mp)->inoalign_mask) {
-		offset_agbno = agbno & M_IGEO(mp)->inoalign_mask;
-		chunk_agbno = agbno - offset_agbno;
-	} else {
-		error = xfs_imap_lookup(pag, tp, agino, agbno,
-					&chunk_agbno, &offset_agbno, flags);
-		if (error)
-			return error;
+		/*
+		 * Otherwise we have to do a btree lookup to find the location.
+		 */
 	}
 
+	error = xfs_imap_lookup(pag, tp, agino, agbno, &chunk_agbno,
+			&offset_agbno, flags);
+	if (error)
+		return error;
+
 out_map:
 	ASSERT(agbno >= chunk_agbno);
 	cluster_agbno = chunk_agbno +
@@ -2556,7 +2550,7 @@ xfs_imap(
 		 M_IGEO(mp)->blocks_per_cluster);
 	offset = ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock) +
 		XFS_INO_TO_OFFSET(mp, ino);
-
+out:
 	imap->im_blkno = xfs_agbno_to_daddr(pag, cluster_agbno);
 	imap->im_len = XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster);
 	imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
-- 
2.53.0

