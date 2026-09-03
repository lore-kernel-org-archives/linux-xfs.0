Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EB144E055
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435700; cv=none; b=jhazoOAx+b1/CT8MClH/fdSSmD8kfgzsl4WZIa+tTEncPnJ+mtU73FE7LroddFnBzJbU4mOlKJbss3NLE+M2NX0ms7OTohAWcLkhY7MVl8AybGHx+icCPcGBb6qeMJw2sbcw7pTRrosEzllTNHbBfKsoSntagUFAQcI4GHo0Snw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435700; c=relaxed/simple;
	bh=q+Zou8rjcmIbUswHYCGww7vCwNRsvWMeg+OZitWa8L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLDsfrlNDsnLvyHlcxvIpAdeP2gqBYnhJ9ag9z9Cuwx6AvfQdOnbZRO14FrX+aeFqb9k7UmYly9hKSCUOdc46oEXQOnX8UTYmaE+osHb+08UdxiuBzAJk6e2+dXwLFBTzwKC5TAczGwmosXv8ON0B7otPx+zUupiDpq+lj9029A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eD0NHPb7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eD0NHPb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C1C1F00A3D;
	Thu,  3 Sep 2026 11:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435690;
	bh=obAGNIvUdjQizLVCOsOeFSv2jerTXhHpGtl/iDrSPfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eD0NHPb7TskTJT3KPtsj4uR34U1agTCLVepAZpqX3iRPFf2xDsdU+5RLajLcGLXLx
	 iOTXzsf1UzL6lKc2U+VEmkezpnMPQiWV3KeIhn4n++eT5bPMTN3c8Qaq1vuXUGf0lZ
	 c/r+9I16wddXea1qwa2N4C+NZT+EXmvcvSQzzXuNNSj5cRqpMcjdreV9ei27RKIxIV
	 FRA2w++IScwVd57pIujPW7H5sQQCgML9++vfa6msuxEsNqPC+ZoeZgBN8Rk+7SHgP+
	 8C8YU/FyzmpPo+rNTS5DZuMYFZmlotxxG0RB/AozWDMCQotAG0J2tlY3/hOQwqy+Gu
	 KQwGcu5CUHrMA==
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
Subject: [PATCH v2 13/23] xfs: store an agbno in struct xfs_imap
Date: Thu,  3 Sep 2026 13:39:55 +0200
Message-ID: <20260903114022.570210-14-aalbersh@kernel.org>
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

Source kernel commit: 9b64ca202f364a6bf8e19bdd20953bc2d776c67f

The xfs_imap structure is embedded into the xfs_inode, which means the
size of it directly affects the inode size.  Replacing the xfs_daddr_t
with an xfs_agbno_t and taking the AG information from other easily
available sources allows us to shrink the structure including the
typical padding from 16 bytes to 8 bytes.

As a side-effect the debugging check in xfs_imap() naturally now
converges to a stricter variant that checks that the cluster is located
inside a single AG, and not just inside the entire device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/iunlink.c           |  5 ++++-
 libxfs/inode.c         |  2 +-
 libxfs/iunlink.c       |  2 +-
 libxfs/logitem.c       | 14 +++++++++-----
 libxfs/xfs_ialloc.c    | 24 +++++++-----------------
 libxfs/xfs_inode_buf.c | 11 ++++++-----
 libxfs/xfs_inode_buf.h |  8 ++++----
 repair/bmap_repair.c   |  6 +++++-
 8 files changed, 37 insertions(+), 35 deletions(-)

diff --git a/db/iunlink.c b/db/iunlink.c
index ba5637553d6d..447d2859b104 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -43,6 +43,7 @@ get_next_unlinked(
 	struct xfs_buf		*ino_bp;
 	struct xfs_dinode	*dip;
 	struct xfs_inode	*ip;
+	struct xfs_perag	*pag;
 	xfs_ino_t		ino;
 	xfs_agino_t		ret;
 	int			error;
@@ -65,7 +66,9 @@ get_next_unlinked(
 		dbprintf("\n");
 	}
 
-	error = -libxfs_read_icluster(mp, NULL, ip->i_imap.im_blkno, &ino_bp);
+	pag = libxfs_perag_get(mp, agno);
+	error = -libxfs_read_icluster(pag, NULL, ip->i_imap.im_agbno, &ino_bp);
+	libxfs_perag_put(pag);
 	if (error) {
 		libxfs_irele(ip);
 		goto bad;
diff --git a/libxfs/inode.c b/libxfs/inode.c
index fe127160ed0a..b6838d3d4bd3 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -182,7 +182,7 @@ libxfs_iget(
 	} else {
 		struct xfs_buf		*bp;
 
-		error = xfs_read_icluster(mp, tp, ip->i_imap.im_blkno, &bp);
+		error = xfs_read_icluster(pag, tp, ip->i_imap.im_agbno, &bp);
 		if (error)
 			goto out_destroy;
 
diff --git a/libxfs/iunlink.c b/libxfs/iunlink.c
index 15654d262ba0..875e0caae988 100644
--- a/libxfs/iunlink.c
+++ b/libxfs/iunlink.c
@@ -44,7 +44,7 @@ xfs_iunlink_log_dinode(
 	int			offset;
 	int			error;
 
-	error = xfs_read_icluster(mp, tp, ip->i_imap.im_blkno, &ibp);
+	error = xfs_read_icluster(iup->pag, tp, ip->i_imap.im_agbno, &ibp);
 	if (error)
 		return error;
 	/*
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index ac50b680d386..6e56e476d1ea 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -16,6 +16,7 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_ag.h"
 
 struct kmem_cache	*xfs_buf_item_cache;
 struct kmem_cache	*xfs_ili_cache;		/* inode log item cache */
@@ -180,6 +181,7 @@ xfs_inode_item_precommit(
 {
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
+	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
 	unsigned int		flags = iip->ili_dirty_flags;
 
@@ -200,7 +202,7 @@ xfs_inode_item_precommit(
 	 * to upgrade this inode to bigtime format, do so now.
 	 */
 	if ((flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
-	    xfs_has_bigtime(ip->i_mount) &&
+	    xfs_has_bigtime(mp) &&
 	    !xfs_inode_has_bigtime(ip)) {
 		ip->i_diflags2 |= XFS_DIFLAG2_BIGTIME;
 		flags |= XFS_ILOG_CORE;
@@ -214,7 +216,7 @@ xfs_inode_item_precommit(
 	 */
 	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
 	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
-	    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_extsize) > 0) {
+	    xfs_extlen_to_rtxmod(mp, ip->i_extsize) > 0) {
 		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
 				   XFS_DIFLAG_EXTSZINHERIT);
 		ip->i_extsize = 0;
@@ -241,13 +243,14 @@ xfs_inode_item_precommit(
 	 */
 	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
 	    (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
-	    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_cowextsize) > 0) {
+	    xfs_extlen_to_rtxmod(mp, ip->i_cowextsize) > 0) {
 		ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
 		ip->i_cowextsize = 0;
 		flags |= XFS_ILOG_CORE;
 	}
 
 	if (!iip->ili_item.li_buf) {
+		struct xfs_perag *pag;
 		struct xfs_buf	*bp;
 		int		error;
 
@@ -261,8 +264,9 @@ xfs_inode_item_precommit(
 		 * here.
 		 */
 		spin_unlock(&iip->ili_lock);
-		error = xfs_read_icluster(ip->i_mount, tp, ip->i_imap.im_blkno,
-				&bp);
+		pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
+		error = xfs_read_icluster(pag, tp, ip->i_imap.im_agbno, &bp);
+		xfs_perag_put(pag);
 		if (error)
 			return error;
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 7ecb7d54577a..f2669dc4907e 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1070,7 +1070,7 @@ xfs_dialloc_check_ino(
 	if (error)
 		return -EAGAIN;
 
-	error = xfs_read_icluster(pag_mount(pag), tp, imap.im_blkno, &bp);
+	error = xfs_read_icluster(pag, tp, imap.im_agbno, &bp);
 	if (error)
 		return -EAGAIN;
 
@@ -2546,23 +2546,13 @@ out_map:
 	offset = ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock) +
 		XFS_INO_TO_OFFSET(mp, ino);
 out:
-	imap->im_blkno = xfs_agbno_to_daddr(pag, cluster_agbno);
+	imap->im_agbno = cluster_agbno;
 	imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
-
-	/*
-	 * If the inode number maps to a block outside the bounds
-	 * of the file system then return NULL rather than calling
-	 * read_buf and panicing when we get an error from the
-	 * driver.
-	 */
-	if (imap->im_blkno +
-	    XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster) >
-	    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
-		xfs_alert(mp,
-	"%s: (im_blkno (0x%llx) + len (0x%x)) > sb_dblocks (0x%llx)",
-			__func__, imap->im_blkno,
-			XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster),
-			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
+	if (imap->im_agbno + M_IGEO(mp)->blocks_per_cluster >
+	    pag_group(pag)->xg_block_count) {
+		xfs_alert(mp, "inode cluster out of range: %u/%u > %u",
+			imap->im_agbno, M_IGEO(mp)->blocks_per_cluster,
+			pag_group(pag)->xg_block_count);
 		return -EINVAL;
 	}
 	return 0;
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 6882f7099ab0..9990aaeef5fd 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -124,19 +124,20 @@ const struct xfs_buf_ops xfs_inode_buf_ra_ops = {
  */
 int
 xfs_read_icluster(
-	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
-	xfs_daddr_t		bno,
+	xfs_agblock_t		agbno,
 	struct xfs_buf		**bpp)
 {
+	struct xfs_mount	*mp = pag_mount(pag);
 	int			error;
 
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, bno,
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
+			xfs_agbno_to_daddr(pag, agbno),
 			XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster),
 			0, bpp, &xfs_inode_buf_ops);
 	if (xfs_metadata_is_sick(error))
-		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, bno),
-				XFS_SICK_AG_INODES);
+		xfs_agno_mark_sick(mp, pag_agno(pag), XFS_SICK_AG_INODES);
 	return error;
 }
 
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index bcad22871b5c..57192adc7744 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -14,12 +14,12 @@ struct xfs_dinode;
  * xfs_read_icluster() to get a buffer and dinode for a given inode.
  */
 struct xfs_imap {
-	xfs_daddr_t	im_blkno;	/* starting BB of inode chunk */
-	unsigned short	im_boffset;	/* inode offset in block in bytes */
+	xfs_agblock_t	im_agbno;	/* starting agbno of inode cluster */
+	unsigned short	im_boffset;	/* offset in inode cluster in bytes */
 };
 
-int	xfs_read_icluster(struct xfs_mount *mp, struct xfs_trans *tp,
-		xfs_daddr_t bno, struct xfs_buf **bpp);
+int	xfs_read_icluster(struct xfs_perag *pag, struct xfs_trans *tp,
+		xfs_agblock_t agbno, struct xfs_buf **bpp);
 void	xfs_dinode_calc_crc(struct xfs_mount *mp, struct xfs_dinode *dip);
 void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
 			  xfs_lsn_t lsn);
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index dadd6e2ce39f..dfdce1a0e01f 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -740,6 +740,7 @@ rebuild_bmap(
 		.mp		= mp,
 	};
 	const struct xfs_buf_ops *bp_ops;
+	struct xfs_perag	*pag;
 	unsigned long		boffset;
 	unsigned long long	resblks;
 	xfs_daddr_t		bp_bn;
@@ -821,7 +822,10 @@ rebuild_bmap(
 	 * Rebuilding the inode fork rolled the transaction, so we need to
 	 * re-grab the inode cluster buffer and dinode pointer for the caller.
 	 */
-	err2 = -libxfs_read_icluster(mp, NULL, sc.ip->i_imap.im_blkno, ino_bpp);
+	pag = libxfs_perag_get(mp, XFS_INODE_TO_AGNO(sc.ip));
+	err2 = -libxfs_read_icluster(pag, NULL, sc.ip->i_imap.im_agbno,
+			ino_bpp);
+	libxfs_perag_put(pag);
 	if (err2)
 		do_error(
  _("Unable to re-grab inode cluster buffer after failed repair of inode %llu, error %d.\n"),
-- 
2.55.0

