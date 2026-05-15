Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E07E322DB7
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 13:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778853084; cv=none; b=UC1o4WYWHD5KSeOYkGKu9KE7Fc9aJAjTim9FrXanC+mP8ERYTcGsQK3C32ntwQSkE+JjLDDBgYV19lzOfnjxIzOgycGH4QejLHm1Hg2ADQ8MsnS99Xhv1KyK+iBVE2ZxgbR+J2LFIQu0gc/VvZFtDuE3akgBYc/23K1z1EDycRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778853084; c=relaxed/simple;
	bh=fMqMRQY6kg61GkK07Cw8IuKYjdxqwVHW9wvhEtFyTPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVf232Tpwy9tL5qwk5EtzpqxNM2yS1ReRd/Sh7vBKPZDxhg/rbTyUwXb5bLHpM9nTdtBMpdkSzgI5KofSlo3iIxuh+9aAH4dnFMIrZjYFn+l3OK5UwlQrfsg2CumCZHEsJt/o6e+QfMtAkwjIKq9Da86VGOSZCg8oOBSy7DPiNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XXdxL2Ae; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XXdxL2Ae"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rVXLiXUWpf2cyrPyqM8Ugg3XuENSz6ZsXrlIFy6NIro=; b=XXdxL2AecVWnpB52LWyx3bsSB9
	ROfGawii/TSviub2VmsQVJ/QQ7DsirMP6r2oLlh2ZMektPrxCnkIUhQQ2pXnCiIiYe+cY2F4jKuPl
	LlwJcZx6jZBBnl7WvNFMBsMxafPfdT/rPbg9nXqLZksJl08dBNcSp40BHuLRM+JfEO8u0BkzYlmUV
	zyujDaSlf0uqOcI8lMcAN3keT46X1jNNBkMg5KainEcaXMze4llXsIwUjSKJKP3Vgvm1XBk8+EQJ9
	4/29cWdC2PKCV7IafexxBuikjPeb+ANcah6gcmWuWBOfOBi+8jdZgKSQcjttcqhoiOd86a3XLK302
	cil3s7fw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNswf-00000008UWi-0lRK;
	Fri, 15 May 2026 13:51:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 3/9] xfs: add a XFS_INO_TO_FSB helper
Date: Fri, 15 May 2026 15:50:24 +0200
Message-ID: <20260515135103.4042407-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260515135103.4042407-1-hch@lst.de>
References: <20260515135103.4042407-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a shortcut for the common XFS_INO_TO_FSB(mp, ip->i_ino) pattern.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c   | 8 +++-----
 fs/xfs/libxfs/xfs_btree.c  | 6 ++----
 fs/xfs/libxfs/xfs_format.h | 2 ++
 fs/xfs/scrub/cow_repair.c  | 3 +--
 fs/xfs/scrub/newbt.c       | 6 ++----
 fs/xfs/scrub/trace.c       | 2 +-
 6 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7a4c8f1aa76c..a11a8aee5b79 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -681,8 +681,7 @@ xfs_bmap_extents_to_btree(
 	args.minlen = args.maxlen = args.prod = 1;
 	args.wasdel = wasdel;
 	*logflagsp = 0;
-	error = xfs_alloc_vextent_start_ag(&args,
-				XFS_INO_TO_FSB(mp, ip->i_ino));
+	error = xfs_alloc_vextent_start_ag(&args, XFS_INODE_TO_FSB(ip));
 	if (error)
 		goto out_root_realloc;
 
@@ -828,8 +827,7 @@ xfs_bmap_local_to_extents(
 	 */
 	args.total = total;
 	args.minlen = args.maxlen = args.prod = 1;
-	error = xfs_alloc_vextent_start_ag(&args,
-			XFS_INO_TO_FSB(args.mp, ip->i_ino));
+	error = xfs_alloc_vextent_start_ag(&args, XFS_INODE_TO_FSB(ip));
 	if (error)
 		goto done;
 
@@ -3590,7 +3588,7 @@ xfs_bmap_btalloc_best_length(
 	xfs_extlen_t		blen = 0;
 	int			error;
 
-	ap->blkno = XFS_INO_TO_FSB(args->mp, ap->ip->i_ino);
+	ap->blkno = XFS_INODE_TO_FSB(ap->ip);
 	if (!xfs_bmap_adjacent(ap))
 		ap->eof = false;
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 7012f3570c8d..71d65f2fa005 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3243,8 +3243,7 @@ xfs_btree_new_iroot(
 	if (level > 0)
 		aptr = *xfs_btree_ptr_addr(cur, 1, block);
 	else
-		aptr.l = cpu_to_be64(XFS_INO_TO_FSB(cur->bc_mp,
-				cur->bc_ino.ip->i_ino));
+		aptr.l = cpu_to_be64(XFS_INODE_TO_FSB(cur->bc_ino.ip));
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
 	error = xfs_btree_alloc_block(cur, &aptr, &nptr, stat);
@@ -5609,8 +5608,7 @@ xfs_btree_alloc_metafile_block(
 	ASSERT(xfs_is_metadir_inode(ip));
 
 	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, cur->bc_ino.whichfork);
-	error = xfs_alloc_vextent_start_ag(&args,
-			XFS_INO_TO_FSB(cur->bc_mp, ip->i_ino));
+	error = xfs_alloc_vextent_start_ag(&args, XFS_INODE_TO_FSB(ip));
 	if (error)
 		return error;
 	if (args.fsbno == NULLFSBLOCK) {
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index f812c6782492..9886af0507e3 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1289,6 +1289,8 @@ static inline bool xfs_dinode_is_metadir(const struct xfs_dinode *dip)
 	((int)(i) & XFS_INO_MASK(XFS_INO_OFFSET_BITS(mp)))
 #define	XFS_INO_TO_FSB(mp,i)		\
 	XFS_AGB_TO_FSB(mp, XFS_INO_TO_AGNO(mp,i), XFS_INO_TO_AGBNO(mp,i))
+#define	XFS_INODE_TO_FSB(ip)		\
+	XFS_INO_TO_FSB((ip)->i_mount, (ip)->i_ino)
 #define	XFS_AGINO_TO_INO(mp,a,i)	\
 	(((xfs_ino_t)(a) << XFS_INO_AGINO_BITS(mp)) | (i))
 #define	XFS_AGINO_TO_AGBNO(mp,i)	((i) >> XFS_INO_OFFSET_BITS(mp))
diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index bffc4666ce60..7b36b87f2c1a 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -426,8 +426,7 @@ xrep_cow_alloc(
 	if (error)
 		return error;
 
-	error = xfs_alloc_vextent_start_ag(&args,
-			XFS_INO_TO_FSB(sc->mp, sc->ip->i_ino));
+	error = xfs_alloc_vextent_start_ag(&args, XFS_INODE_TO_FSB(sc->ip));
 	if (error)
 		return error;
 	if (args.fsbno == NULLFSBLOCK)
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 2e4981c1baf2..6ab0eff7d2ea 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -123,8 +123,7 @@ xrep_newbt_init_inode(
 	if (!ifp)
 		return -ENOMEM;
 
-	xrep_newbt_init_ag(xnr, sc, oinfo,
-			XFS_INO_TO_FSB(sc->mp, sc->ip->i_ino),
+	xrep_newbt_init_ag(xnr, sc, oinfo, XFS_INODE_TO_FSB(sc->ip),
 			XFS_AG_RESV_NONE);
 	xnr->ifake.if_fork = ifp;
 	xnr->ifake.if_fork_size = xfs_inode_fork_size(sc->ip, whichfork);
@@ -160,8 +159,7 @@ xrep_newbt_init_metadir_inode(
 	 * as if they were regular file blocks.  This exposes us to a higher
 	 * risk of the repair being cancelled due to ENOSPC.
 	 */
-	xrep_newbt_init_ag(xnr, sc, &oinfo,
-			XFS_INO_TO_FSB(sc->mp, sc->ip->i_ino),
+	xrep_newbt_init_ag(xnr, sc, &oinfo, XFS_INODE_TO_FSB(sc->ip),
 			XFS_AG_RESV_NONE);
 	xnr->ifake.if_fork = ifp;
 	xnr->ifake.if_fork_size = xfs_inode_fork_size(sc->ip, XFS_DATA_FORK);
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 70d353287993..e5efc680651f 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -48,7 +48,7 @@ xchk_btree_cur_fsbno(
 
 	if (level == cur->bc_nlevels - 1 &&
 	    cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
-		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_ino.ip->i_ino);
+		return XFS_INODE_TO_FSB(cur->bc_ino.ip);
 
 	return NULLFSBLOCK;
 }
-- 
2.53.0

