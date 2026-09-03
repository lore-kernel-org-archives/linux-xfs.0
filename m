Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4F345FFDC
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435673; cv=none; b=Yhv2vFKfsAbU6nFbLs9nMkPYh4HeGCWur82QdTXPPU7REQlGUHcF+OIoJRvCgTtTJ21eGCUdpi7qiD4d6GUNhtCTUfAxRLlhUKMcpxkd7UcQhxzWOwc5lThjsNtKzqVhsfcr/yDEx93YXrddgegfDgxh/8NNRk8zxHYsLXtTaME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435673; c=relaxed/simple;
	bh=6FgUclgiiu/mPY0ZwOf/W7SFGYcGzt1CF5fKIz6gGMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqJEbPkRy2iB4KvlAyGo+DraOdJCkfSUvmMw6sm051sPwqVQalwVQTFWOblQoRiUyGNhw0UBk5vZ+S80Xx5z+T0Gl2oLumi4gH2DO6ojqVGhuG4nhPfRIziWC1eehNGyEFfIE++vfPYR3Etx8evFJYc0WNE1iH1XXtYeQNlcPjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dMGzIjBn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dMGzIjBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C441F00A3A;
	Thu,  3 Sep 2026 11:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435666;
	bh=lGdYD9gaLJMrsbwDZPt6dAWu3QTaezOM8j43HZzAHCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMGzIjBnYAJQrZBJAIraTixDtLDRV4Ztz+Q8R6X7efd9R6aYze7qInaGkTR1Hs6tp
	 PdwgNy4FuZo8VSc0UQa5c8LoYqFuHYU2r/TDWMbsKAYFv4e4z6myU7eYrKc0fS6dYD
	 SRgMivUMDGZucgDXd+DlKxYYeIQLsIYt4NbMaH7o0ymF2xBV1rc+Td1E4EuRFkJ9O1
	 8qHngmUzojZ2XA+jOP9EW3qnwgU4Q9J22WGQUPKp8ntm7ijDsYM5YZ6TwKccBFHoTf
	 XypqD27bf4Z83FjySC8s08cKEAAewg71Ieq3uEKvPHcUSPBFk6A3MZTm5Xf9TnhgMe
	 MJjkKA6naZMPw==
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
Subject: [PATCH v2 06/23] xfs: add a XFS_INO_TO_FSB helper
Date: Thu,  3 Sep 2026 13:39:48 +0200
Message-ID: <20260903114022.570210-7-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903114022.570210-1-aalbersh@kernel.org>
References: <20260903114022.570210-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: f8b7c9a8b0a9e43b054981d134b426d9464264f6

Add a shortcut for the common XFS_INO_TO_FSB(mp, ip->i_ino) pattern.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c   | 8 +++-----
 libxfs/xfs_btree.c  | 6 ++----
 libxfs/xfs_format.h | 2 ++
 repair/bulkload.c   | 2 +-
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 96975f88497a..d211d31697a2 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -675,8 +675,7 @@ xfs_bmap_extents_to_btree(
 	args.minlen = args.maxlen = args.prod = 1;
 	args.wasdel = wasdel;
 	*logflagsp = 0;
-	error = xfs_alloc_vextent_start_ag(&args,
-				XFS_INO_TO_FSB(mp, ip->i_ino));
+	error = xfs_alloc_vextent_start_ag(&args, XFS_INODE_TO_FSB(ip));
 	if (error)
 		goto out_root_realloc;
 
@@ -822,8 +821,7 @@ xfs_bmap_local_to_extents(
 	 */
 	args.total = total;
 	args.minlen = args.maxlen = args.prod = 1;
-	error = xfs_alloc_vextent_start_ag(&args,
-			XFS_INO_TO_FSB(args.mp, ip->i_ino));
+	error = xfs_alloc_vextent_start_ag(&args, XFS_INODE_TO_FSB(ip));
 	if (error)
 		goto done;
 
@@ -3584,7 +3582,7 @@ xfs_bmap_btalloc_best_length(
 	xfs_extlen_t		blen = 0;
 	int			error;
 
-	ap->blkno = XFS_INO_TO_FSB(args->mp, ap->ip->i_ino);
+	ap->blkno = XFS_INODE_TO_FSB(ap->ip);
 	if (!xfs_bmap_adjacent(ap))
 		ap->eof = false;
 
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 4ab0d8d3789b..0069fba162a8 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -3240,8 +3240,7 @@ xfs_btree_new_iroot(
 	if (level > 0)
 		aptr = *xfs_btree_ptr_addr(cur, 1, block);
 	else
-		aptr.l = cpu_to_be64(XFS_INO_TO_FSB(cur->bc_mp,
-				cur->bc_ino.ip->i_ino));
+		aptr.l = cpu_to_be64(XFS_INODE_TO_FSB(cur->bc_ino.ip));
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
 	error = xfs_btree_alloc_block(cur, &aptr, &nptr, stat);
@@ -5606,8 +5605,7 @@ xfs_btree_alloc_metafile_block(
 	ASSERT(xfs_is_metadir_inode(ip));
 
 	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, cur->bc_ino.whichfork);
-	error = xfs_alloc_vextent_start_ag(&args,
-			XFS_INO_TO_FSB(cur->bc_mp, ip->i_ino));
+	error = xfs_alloc_vextent_start_ag(&args, XFS_INODE_TO_FSB(ip));
 	if (error)
 		return error;
 	if (args.fsbno == NULLFSBLOCK) {
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index f812c6782492..9886af0507e3 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1289,6 +1289,8 @@ static inline bool xfs_dinode_is_metadir(const struct xfs_dinode *dip)
 	((int)(i) & XFS_INO_MASK(XFS_INO_OFFSET_BITS(mp)))
 #define	XFS_INO_TO_FSB(mp,i)		\
 	XFS_AGB_TO_FSB(mp, XFS_INO_TO_AGNO(mp,i), XFS_INO_TO_AGBNO(mp,i))
+#define	XFS_INODE_TO_FSB(ip)		\
+	XFS_INO_TO_FSB((ip)->i_mount, (ip)->i_ino)
 #define	XFS_AGINO_TO_INO(mp,a,i)	\
 	(((xfs_ino_t)(a) << XFS_INO_AGINO_BITS(mp)) | (i))
 #define	XFS_AGINO_TO_AGBNO(mp,i)	((i) >> XFS_INO_OFFSET_BITS(mp))
diff --git a/repair/bulkload.c b/repair/bulkload.c
index a9e51de0a24c..6bc110071f02 100644
--- a/repair/bulkload.c
+++ b/repair/bulkload.c
@@ -32,7 +32,7 @@ bulkload_init_inode(
 	int				whichfork,
 	const struct xfs_owner_info	*oinfo)
 {
-	bulkload_init_ag(bkl, sc, oinfo, XFS_INO_TO_FSB(sc->mp, sc->ip->i_ino));
+	bulkload_init_ag(bkl, sc, oinfo, XFS_INODE_TO_FSB(sc->ip));
 	bkl->ifake.if_fork = kmem_cache_zalloc(xfs_ifork_cache, 0);
 	bkl->ifake.if_fork_size = xfs_inode_fork_size(sc->ip, whichfork);
 }
-- 
2.55.0

