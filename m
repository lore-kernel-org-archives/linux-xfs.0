Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBB4381E88
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435680; cv=none; b=knxdpWzpukEIZls9BdtH+gbMuJ2XC5D9tM6cwzGs0fsEqIcmb7A1Q54F3jQcwFm+ajMybaq37Q452wFtGqo/IuTZvRiJi5/GKkvwCTO4usqpdPMnAO6l01P7Ho24fnz82+kcgae7d5wrE+dhkWLyuo2C1DIGSxQVRE8DIskEABg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435680; c=relaxed/simple;
	bh=uBfY3KiMldXpoibf6mtmbjdbFNM1Ml5RL1xSYQpUPtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L18AG96VrGAlMw/RN+VgEeZBXTkfdeaNMwKQvWhoeQx+b49310bgUrMToKmXW3OblLBOIz9hupEwH+PPljNfvSjrTNLIoLfOE7Q40xZ1NUcROgoWqX2mlkEY4yBS2pPgwnpEP8xxRcWeQ0+MH2i6+t77uq2shhGIqK4buD5yH14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AGjFqEmw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AGjFqEmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25A81F000E9;
	Thu,  3 Sep 2026 11:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435669;
	bh=QUMpxeMoml2tRwSh/zXPCKwPKx/+VWZuGQSneNaAcr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AGjFqEmwEV0x1AAHSjEnydDKb/8KQQ1TW7LJQ2h5WKjR0sjNEqhvsI8y5q42CAXBg
	 EUlQYepbb/NyEzQR4MRzX4/aI9736FgesJUW9LNpHHZzuXupRwIibp6ohAot/UjE2l
	 /MKPSrkD4ur6uFAtfv0pFHwXwmvSjMc7CczYGhBYLG6y+u2rHzqrUv+OHwLM3BJlxH
	 pMvuGQouk1R+UpK9vpBKNnWMz/PwFH+gKYURsXsmQ9Wulrkb6YR2xSnyGDZ610DmfU
	 oTD3pei16xRQtmV3Dqo/KA+Owyl/6l5wKFg2u3dr/mVLuwKtxoWCJG7vYf5Ln9ohZb
	 wislZ0N3p3HtA==
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
Subject: [PATCH v2 07/23] xfs: add a xfs_rmap_inode_bmbt_owner
Date: Thu,  3 Sep 2026 13:39:49 +0200
Message-ID: <20260903114022.570210-8-aalbersh@kernel.org>
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

Source kernel commit: ee237a900ceef00c8d1ca17a5cfadbd50fba67e9

Add a small wrapper for initializing the bmbt owner to i_ino.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c          | 4 ++--
 libxfs/xfs_bmap_btree.c    | 4 ++--
 libxfs/xfs_btree.c         | 4 ++--
 libxfs/xfs_rmap.h          | 2 ++
 repair/bmap_repair.c       | 2 +-
 repair/rtrefcount_repair.c | 2 +-
 repair/rtrmap_repair.c     | 2 +-
 7 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index d211d31697a2..1bd65a0cba26 100644
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
index 6038c4567455..077b862ca6d2 100644
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
index 0069fba162a8..c7db42a47860 100644
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
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 5f39f6e53cd1..7188459f61cf 100644
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
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index 192f189de052..335a35af5379 100644
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
index 228d080e5a5d..7906af17e893 100644
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
index 955db1738fe2..136fafc01024 100644
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
-- 
2.55.0

