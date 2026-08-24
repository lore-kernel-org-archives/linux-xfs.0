Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77198408636
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 11:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787571972; cv=none; b=hatQ4kb4b17iRX+UHcRgdHqPjfU4auxoQP+szoIq+xVXgP6RGiAVVb2m1Rk7PCg2Dh2dPeRXC1TaRlU0lFhdRb5NXCPSzwrx8JL0R9nt8yn7XsIdUdWA9UDdkTvv3LN4DY9/14Zud7DMKsn6tKtfBhMETmoTnobK89Br/9dR2Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787571972; c=relaxed/simple;
	bh=COI+DvLTh0z0DiC/+BTiDuy+lyT4aZtFBdAFaUupp6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mx4HN58+y1Falel20ozKC8aLi2Hxh8wqX+9hC2t5aXFo+vKFK9lM0wlU0Yz+c8bwfiseIUJSlSaUiQPQ0FfRIp6Fa835bY5Gay1QTMWHOsnV/O91LtYHgK/Va+G1xXXFmGqSxAVTvTUL4SbUqbp107N5lGwviC2g3uhaPOyKySA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OijwhOt7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OijwhOt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47961F000E9;
	Mon, 24 Aug 2026 11:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787571971;
	bh=9aP2bFkFY+K6VZ0QFnt34GiHyyVOGy97/Ha+oHQ/f34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OijwhOt7fYEcMvzalZHT2HZUET2T1aAsmSEMSxEdUl48jvUI0SuNsMoZJZAC82MQp
	 VY8GFB7Z3iZkjO6ljuLVym6NmJiozj1GmhDhiuna7S/t/h18lbq4uRNHnkgJSj559l
	 5YE9I6fznMlIkKO/liLsGtuzLMHs5VVy83OBUcCHbSC+jAxMifIaXmV1NvSNOfbEg3
	 iddjn4NduVNzOZzr3in+ZHJVSWQfcsEDoyZZN8nTKa+/jwWBeCpCx+rwwn584BJjDF
	 KeOzyzmw+kcmX7qInchnkFOrBtj7IZDuylkM8G57MuytQyUMw+AVjWD8cKoo0f9ZiL
	 zq0wnR2Udg7pQ==
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
Subject: [PATCH 06/21] xfs: add a xfs_rmap_inode_bmbt_owner
Date: Mon, 24 Aug 2026 12:40:04 +0200
Message-ID: <20260824104022.420566-7-aalbersh@kernel.org>
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

Source kernel commit: ee237a900ceef00c8d1ca17a5cfadbd50fba67e9

Add a small wrapper for initializing the bmbt owner to i_ino.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_bmap.c       | 4 ++--
 libxfs/xfs_bmap_btree.c | 4 ++--
 libxfs/xfs_btree.c      | 4 ++--
 libxfs/xfs_rmap.h       | 2 ++
 4 files changed, 8 insertions(+), 6 deletions(-)

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
-- 
2.55.0

