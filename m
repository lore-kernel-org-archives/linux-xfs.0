Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1BF306776
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022625; cv=none; b=TYJ6zK+0bC3CiSvO/YIwXhnXcAweHO5QNKofQf24X49tZJG4R6t0j9ipoQdMNUDnrxnL0kRXsF6w55Y/v57hP805s/31nifuF49KOHhLvxGyNNFjXaPsOEPAu2hI0QqZ1kDDoEnqlaJ8pzaD2PuQYTwgR1oM1YxdGX30A3N7OrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022625; c=relaxed/simple;
	bh=xWlR+USxGidwLCnFZmgbocM+7/fiRcI5EOf2VnG9w7o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YJKbU3cN1W1ahMLsgC0ZyF8NM3179JOUN10aWlsrEtTYFTYCl/LJmR7LrcSgVmZvtKgMmW7b2F+zU6ibs6qJSJb6UZM/EQc+uZVIy0vCYdkdwS37Wl1zMrXxjgha4VGrudEYmPkZdAgx9YiGSXpWB6Bf+mtA3FC4Q46DI6SOfgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rh7mBJuI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rh7mBJuI"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9DDA41F000E9;
	Thu,  2 Jul 2026 20:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022623;
	bh=RqiGWlLLPSnDSG3LC2lwF6yjUYYqf177CdCa3Qt1fl4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Rh7mBJuIhl8inWkWH7DjmTfxma3AxVCPypzRA3WnXwb+dtDsmSBFYDC5xUkamRKUh
	 QvSnpNDzQWw+gcGDwY3lXcFrhzqjS+T4hYuRkaBamMjam6Dgjjbdyry/QnpNJjE0ms
	 JgPSWHpvWVhm5f6dJnyY9glK1XwWduqOkswIsCh6dLARthGjtOOEdq+ETlm1uIIVR/
	 6O8wVIfW9d98lge1zxjBKxpoLTPwU9JXb9FCNYL68vrCGdQhVicaFsCBYYba/FQg7j
	 vh0bGQYiIFiCcA5mujc58Wq2eDosXCcrDctSLm9sIiz7tE9c6KnBZQYvI29yPesK2y
	 qWRuF5TrIrawg==
Date: Thu, 02 Jul 2026 13:03:43 -0700
Subject: [PATCH 13/18] xfs: store an agbno in struct xfs_imap
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <178302226546.845537.9014551247110564469.stgit@frogsfrogsfrogs>
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
---
 libxfs/xfs_inode_buf.h |    8 ++++----
 db/iunlink.c           |    5 ++++-
 libxfs/inode.c         |    2 +-
 libxfs/iunlink.c       |    2 +-
 libxfs/logitem.c       |   14 +++++++++-----
 libxfs/xfs_ialloc.c    |   24 +++++++-----------------
 libxfs/xfs_inode_buf.c |   11 ++++++-----
 repair/bmap_repair.c   |    6 +++++-
 8 files changed, 37 insertions(+), 35 deletions(-)


diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index bcad22871b5c40..57192adc774491 100644
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
diff --git a/db/iunlink.c b/db/iunlink.c
index ba5637553d6de5..447d2859b104c7 100644
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
index fe127160ed0a11..b6838d3d4bd30d 100644
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
index 15654d262ba0d1..875e0caae98818 100644
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
index ac50b680d38623..6e56e476d1ea08 100644
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
index 7ecb7d54577a0d..f2669dc4907ecf 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1070,7 +1070,7 @@ xfs_dialloc_check_ino(
 	if (error)
 		return -EAGAIN;
 
-	error = xfs_read_icluster(pag_mount(pag), tp, imap.im_blkno, &bp);
+	error = xfs_read_icluster(pag, tp, imap.im_agbno, &bp);
 	if (error)
 		return -EAGAIN;
 
@@ -2546,23 +2546,13 @@ xfs_imap(
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
index 6882f7099ab030..9990aaeef5fd76 100644
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
 
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index dadd6e2ce39f8b..dfdce1a0e01f4a 100644
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

