Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E40353A99
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022533; cv=none; b=OtTHC6gE5wY27pDXGno5gmmLBlYeT7QoTfXutEPEQamsVQ03WKvr1Mnzrwwecam4PceKmL2MUng/w/BvV3jwTCC6dA22c+Cc3w94Yk+XxIQjKpnDIY4iaCBbfk9I7zl9L7F3YnSXmh9p51RTRgggHNZkRyHpoi6dfI4VzNXY3Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022533; c=relaxed/simple;
	bh=9bTYrxMC/RhSism2vY+Q/IWjo3AjPlIpZNVDRvg8UZQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YWL/6OuGXBe8a1rbadgRRtG92HKkAHkZxL4Vvk+m3TthMXcvlCSgDpPm3OpTRfWEEfOAN7u/dCwa+wvj1XCujoJhoowqiVCHmHCJo+C7mQ5bIqP4xYEPzbrXvw1M0ccTApVlazEFgA4b9RTH4TymdrgXhdi/ojaZsdiLejrClb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SF0gErPM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SF0gErPM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 831991F000E9;
	Thu,  2 Jul 2026 20:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022530;
	bh=y3P1mqvV0WoGY4SFCqzsjmZdsceEaHylR+v7JcKW1HM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=SF0gErPMGuZSzEw2kHigC+h9GodbLnhRdlzwf1f+DEFC4mvMno7fff18nJYxugfGE
	 NmgGE2Z5/FEhzqlisX917wR6h5a7+JUbp3m5GhahZcnbBNNbRlQ3Wsy8VFnJjvC0iw
	 EhLC6wYRnd5gMAMM4mzzQP3/bUo0jzp4XBh1hq0w6R14FyIfYP0wsm22JFZaSqNqp0
	 HC9OirWu+oZNUV4wofuS6nGkM7FcqIEUY2+7YLjWmXMoAsVrVFMxGkYvJSm91mGw9p
	 g2Q2+28CAR0KESmmkpW2C14DZ7U87An42l/eKI8gFAdoAW2nA2TIFyXhqtuNcawKTA
	 hPDVfjv8MS4Cg==
Date: Thu, 02 Jul 2026 13:02:10 -0700
Subject: [PATCH 07/18] xfs: add a xfs_rmap_inode_bmbt_owner
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <178302226433.845537.8776431101175840760.stgit@frogsfrogsfrogs>
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

Source kernel commit: ee237a900ceef00c8d1ca17a5cfadbd50fba67e9

Add a small wrapper for initializing the bmbt owner to i_ino.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rmap.h          |    2 ++
 libxfs/xfs_bmap.c          |    4 ++--
 libxfs/xfs_bmap_btree.c    |    4 ++--
 libxfs/xfs_btree.c         |    4 ++--
 repair/bmap_repair.c       |    2 +-
 repair/rtrefcount_repair.c |    2 +-
 repair/rtrmap_repair.c     |    2 +-
 7 files changed, 11 insertions(+), 9 deletions(-)


diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 5f39f6e53cd19a..7188459f61cf3e 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -21,6 +21,8 @@ xfs_rmap_ino_bmbt_owner(
 	if (whichfork == XFS_ATTR_FORK)
 		oi->oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
 }
+#define xfs_rmap_inode_bmbt_owner(oi, ip, whichfork) \
+	xfs_rmap_ino_bmbt_owner(oi, (ip)->i_ino, whichfork)
 
 static inline void
 xfs_rmap_ino_owner(
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index d211d31697a2ee..1bd65a0cba2629 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -596,7 +596,7 @@ xfs_bmap_btree_to_extents(
 	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
 		return error;
 
-	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
+	xfs_rmap_inode_bmbt_owner(&oinfo, ip, whichfork);
 	error = xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo,
 			XFS_AG_RESV_NONE, 0);
 	if (error)
@@ -670,7 +670,7 @@ xfs_bmap_extents_to_btree(
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = mp;
-	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, whichfork);
+	xfs_rmap_inode_bmbt_owner(&args.oinfo, ip, whichfork);
 
 	args.minlen = args.maxlen = args.prod = 1;
 	args.wasdel = wasdel;
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 6038c45674557b..077b862ca6d2ca 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -216,7 +216,7 @@ xfs_bmbt_alloc_block(
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
-	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_ino.ip->i_ino,
+	xfs_rmap_inode_bmbt_owner(&args.oinfo, cur->bc_ino.ip,
 			cur->bc_ino.whichfork);
 	args.minlen = args.maxlen = args.prod = 1;
 	args.wasdel = cur->bc_flags & XFS_BTREE_BMBT_WASDEL;
@@ -279,7 +279,7 @@ xfs_bmbt_free_block(
 	struct xfs_owner_info	oinfo;
 	int			error;
 
-	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
+	xfs_rmap_inode_bmbt_owner(&oinfo, ip, cur->bc_ino.whichfork);
 	error = xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo,
 			XFS_AG_RESV_NONE, 0);
 	if (error)
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 0069fba162a8de..c7db42a4786005 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -5604,7 +5604,7 @@ xfs_btree_alloc_metafile_block(
 
 	ASSERT(xfs_is_metadir_inode(ip));
 
-	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, cur->bc_ino.whichfork);
+	xfs_rmap_inode_bmbt_owner(&args.oinfo, ip, cur->bc_ino.whichfork);
 	error = xfs_alloc_vextent_start_ag(&args, XFS_INODE_TO_FSB(ip));
 	if (error)
 		return error;
@@ -5636,7 +5636,7 @@ xfs_btree_free_metafile_block(
 
 	ASSERT(xfs_is_metadir_inode(ip));
 
-	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
+	xfs_rmap_inode_bmbt_owner(&oinfo, ip, cur->bc_ino.whichfork);
 	error = xfs_free_extent_later(tp, fsbno, 1, &oinfo, XFS_AG_RESV_METAFILE,
 			0);
 	if (error)
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index 192f189de05217..335a35af5379dc 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -576,7 +576,7 @@ xrep_bmap_build_new_fork(
 	 * Prepare to construct the new fork by initializing the new btree
 	 * structure and creating a fake ifork in the ifakeroot structure.
 	 */
-	libxfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, rb->whichfork);
+	xfs_rmap_inode_bmbt_owner(&oinfo, sc->ip, rb->whichfork);
 	bulkload_init_inode(&rb->new_fork_info, sc, rb->whichfork, &oinfo);
 	bmap_cur = libxfs_bmbt_init_cursor(sc->mp, NULL, sc->ip,
 			XFS_STAGING_FORK);
diff --git a/repair/rtrefcount_repair.c b/repair/rtrefcount_repair.c
index 228d080e5a5dcb..7906af17e8936b 100644
--- a/repair/rtrefcount_repair.c
+++ b/repair/rtrefcount_repair.c
@@ -173,7 +173,7 @@ xrep_rtrefc_build_new_tree(
 	 * Prepare to construct the new fork by initializing the new btree
 	 * structure and creating a fake ifork in the ifakeroot structure.
 	 */
-	libxfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, XFS_DATA_FORK);
+	xfs_rmap_inode_bmbt_owner(&oinfo, sc->ip, XFS_DATA_FORK);
 	bulkload_init_inode(&rr->new_fork_info, sc, XFS_DATA_FORK, &oinfo);
 	cur = libxfs_rtrefcountbt_init_cursor(NULL, rr->rtg);
 	libxfs_btree_stage_ifakeroot(cur, ifake);
diff --git a/repair/rtrmap_repair.c b/repair/rtrmap_repair.c
index 955db1738fe240..136fafc010243c 100644
--- a/repair/rtrmap_repair.c
+++ b/repair/rtrmap_repair.c
@@ -211,7 +211,7 @@ xrep_rtrmap_build_new_tree(
 	 * Prepare to construct the new fork by initializing the new btree
 	 * structure and creating a fake ifork in the ifakeroot structure.
 	 */
-	libxfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, XFS_DATA_FORK);
+	xfs_rmap_inode_bmbt_owner(&oinfo, sc->ip, XFS_DATA_FORK);
 	bulkload_init_inode(&rr->new_fork_info, sc, XFS_DATA_FORK, &oinfo);
 	cur = libxfs_rtrmapbt_init_cursor(NULL, rr->rtg);
 	libxfs_btree_stage_ifakeroot(cur, ifake);

