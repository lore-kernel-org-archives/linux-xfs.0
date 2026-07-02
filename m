Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D32353A99
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022517; cv=none; b=OwqxBlLCft/1/TklNwwDCXPZPH7rVyanZrJYgQ9EM4n6KlofX4+0EbUTepR2XraHbQIv7Bbmy71HJW41Eosb0JvKeGBTT6zueJGpM3dEK6LAA0XH+MqmmedcjbiuUEIzQ8uElD3fa4ZW1WK2Af7U3WQ903GatHic+Ww1lmM3SNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022517; c=relaxed/simple;
	bh=gEuk2nHjUB3MfKj6OeQsfeEwP3gr16t0BrMto427eus=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QzOIzY8d0QLJGVk77pgwmKawRBwlCwt94zHC9rgmK2rfEUOioUi/fwvF9gMbUHFXGcvJtUztFnBoCD9JrinFcHOgFsi9B+Run1twYuu6ZkCbXMUWPBjJ79pJNj01vD3GvUgPg3oQLmg9pXNTBq9Gws9j/EXrMYe81O38WKUtSUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WgAhS/pg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WgAhS/pg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 02AC21F000E9;
	Thu,  2 Jul 2026 20:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022515;
	bh=bwVIsdYTMna+RhTB6O4cshQdZ7ArYzq58G/37vpUPrU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=WgAhS/pgiryp0F2EME8O+jM2as7bgWOrOjR/XtiGBaG/KPndJM1ZG16/tQZTL4JYY
	 O/5uaoanwxHr97bfLIw1wTsWkeLooMfAjRAvXu05+9bh3YF/VuQLAhwB6aeKvhQa2D
	 diQvTtyodnhT58/lB9BJFbsYk0xrOoYXJZxVSFznMhNxyicjUn4Y0CPhPu40anMwJC
	 bWr32M3Xx8PKjGxiw9hNOUp5GqWdVKj/G5MqahaY7J5dvn0WJk/Sk6/ex9pGVAssCs
	 lqj4+SLhqeOklIa0hp+9WuEJQG9ldgmuL+W8Z3tCk3QP8+Tdduf6k0wHmS1awYzTjv
	 VrH/bI5vG5lHg==
Date: Thu, 02 Jul 2026 13:01:54 -0700
Subject: [PATCH 06/18] xfs: add a XFS_INO_TO_FSB helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <178302226415.845537.16722054422953812852.stgit@frogsfrogsfrogs>
In-Reply-To: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
References: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: f8b7c9a8b0a9e43b054981d134b426d9464264f6

Add a shortcut for the common XFS_INO_TO_FSB(mp, ip->i_ino) pattern.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_format.h |    2 ++
 libxfs/xfs_bmap.c   |    8 +++-----
 libxfs/xfs_btree.c  |    6 ++----
 repair/bulkload.c   |    2 +-
 4 files changed, 8 insertions(+), 10 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index f812c6782492cb..9886af0507e3af 100644
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
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 96975f88497add..d211d31697a2ee 100644
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
index 4ab0d8d3789b18..0069fba162a8de 100644
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
diff --git a/repair/bulkload.c b/repair/bulkload.c
index a9e51de0a24c17..6bc110071f022d 100644
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

