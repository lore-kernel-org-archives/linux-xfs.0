Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90A927AC31
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 11:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787571984; cv=none; b=sLddbxaThFUMV+6urZMBJvUkPCsB/01Id1b8kQ+80ewV/rAabB2PUY/bnz4esyLs3W51VrOMy3LQ6RLjoO7jgWCAYQHvFt05MQMjVMtKKAiTu1fO0+WOjPZoUnT9tB/Zu3ofDN2Dds+r5LWyeMKlmK3WS/5BE3n186SkT3X4Ylw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787571984; c=relaxed/simple;
	bh=z0nioi6h3LQZpdVUzs+bP/Ggnj34FZqljyJCA7SEMXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqTDidZxyTTxgm+pBpPxztL70SN/fRlzdi+XddalKvQWrJ2kZnxjGkRoDdScwJ5iSCdklXfceSXZ1kIOM7d/FUx8YHPVe/htsgj/WgZ9/yURK7AsBZdiSQw7TUK/CzWGVairXmXK9OFYt7N7EHJ8KRCSq1KRQoncNPa0mjI6YsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fXGKkhEL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXGKkhEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753C51F00A3A;
	Mon, 24 Aug 2026 11:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787571982;
	bh=icr3/KUlMACKci5rtStG4jBqMUlNqk8D7EWhvFayOC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXGKkhELFMgEq7rIdIiIiqclWDT0pvenD0Vyr0eSlS70aLBJC2XTPS0I/4oV4XamV
	 t93uUwhEXczhMpdfXDkMAC7ZejmFj4teLN7+r2oVbXIpWcZ8Thpf7vTjYP4STsIDJb
	 Xy62fI3Z7PkB/nMFeeFQDA0JqYTIn0ZLZPyyZxRajpiwg/N6G4QiJICMknI2FSKCZG
	 8aukMuG9wDtrpo2Ik8VcVAohjOLN+ce+Ld04lR5ZIHaCBor0XoQfJZgnAPdXoaZRTW
	 54mI4AbSCQQZHXn8p6lb7V/RXaplL5dcizTQIgfeoH8cTxGzGszmJbbH/Bfdo+ahyQ
	 gWC4BcL0cZPGw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	aalbersh@kernel.org
Cc: bestswngs@gmail.com,
	brauner@kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn,
	djwong@kernel.org,
	gaoyingjie@uniontech.com,
	hch@lst.de,
	jiapenglin@tencent.com,
	roland.mainz@nrubsig.org,
	xmei5@asu.edu
Subject: [PATCH 09/21] xfs: cleanup xfs_imap
Date: Mon, 24 Aug 2026 12:40:07 +0200
Message-ID: <20260824104022.420566-10-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824104022.420566-1-aalbersh@kernel.org>
References: <20260824104022.420566-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 41397e7ca8a06507ae6f52f68cd27b0812e9a561

Reshuffle the code a bit so that the imap_lookup and filling out of the
xfs_imap structure aren't duplicated.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ialloc.c | 62 ++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 34 deletions(-)

diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 64f0376a1050..8c42c045924d 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2506,43 +2506,37 @@ xfs_imap(
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
+		/*
+		 * If the inode chunks are aligned, use simple maths to find the
+		 * location.
+		 */
+		if (M_IGEO(mp)->inoalign_mask) {
+			offset_agbno = agbno & M_IGEO(mp)->inoalign_mask;
+			chunk_agbno = agbno - offset_agbno;
+			goto out_map;
+		}
 
-		imap->im_blkno = xfs_agbno_to_daddr(pag, agbno);
-		imap->im_len = XFS_FSB_TO_BB(mp, 1);
-		imap->im_boffset = (unsigned short)(offset <<
-							mp->m_sb.sb_inodelog);
-		return 0;
+		/*
+		 * Otherwise we have to do a btree lookup to find the location.
+		 */
 	}
 
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
-	}
+	error = xfs_imap_lookup(pag, tp, agino, agbno, &chunk_agbno,
+			&offset_agbno, flags);
+	if (error)
+		return error;
 
 out_map:
 	ASSERT(agbno >= chunk_agbno);
@@ -2551,7 +2545,7 @@ out_map:
 		 M_IGEO(mp)->blocks_per_cluster);
 	offset = ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock) +
 		XFS_INO_TO_OFFSET(mp, ino);
-
+out:
 	imap->im_blkno = xfs_agbno_to_daddr(pag, cluster_agbno);
 	imap->im_len = XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster);
 	imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
-- 
2.55.0

