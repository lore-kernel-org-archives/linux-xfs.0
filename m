Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6593A6F10
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 11:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787571995; cv=none; b=jUWsmiaGU6S8wIZRfF2DHmEg5kbHSUIKSNjNeGpFuhy6hGJQ17AWapfShVl1J/nHWuVE9Bb1kpOVWe7Buq6oIr6gn1RD2O1htfW7ibgeTGHkUpW/ZNt9ICJXc9AQ/kLP+CKWrGrMLpdVedYfFYe/PULFnA/eBV7GgpadkB9TTkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787571995; c=relaxed/simple;
	bh=JwKUY/ZMX9rzLKtNLz37EI9/0aUm4KRIu73uTL57+Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBHcFAUZfXqQoiulrZw8nnGk1JNWG2c2U11vt3yQeD3LedmT66+qazL8yq72cMLO3IpyXYxWF0UP4Eium22j5C9Rwsz8wsrJKiwBd2zCnbHCZjJTQJZ4zmFv9efzpYT4t1uDI9cnXG+TjOUAacjnsVJDOUhP6RTdJ5RJOjBWJRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dMGzjlzF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dMGzjlzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038771F00A3A;
	Mon, 24 Aug 2026 11:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787571994;
	bh=l7wCgA8fdfrfnKn972roXGXIwSzKgJVnXlnnrkksPbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMGzjlzFpTn7qIgMaqt2/ccszRYoITAdBu6TeNFxu8P2yxAMP+izZ5PjkYiuhZVbD
	 0AXedHrJ1l7lwBw2wedys0NKLpuNsqnAH//CLIv++D2lRZv3o1dcSkkxylUPUXLDwF
	 +zO/LeCzK04Jmw6qSHdKO87XxCm45ZWQjrU5HAV+rFwqEtv7MOeiXYvpb/XplTgHQc
	 mG9UK3fMJRPNzl/q7KHCJtyh/LjHmLofQeT1Hnvaf8hlyR1lGmv7S1SlC+vS3o6jw2
	 G2JlMEM5c8kHiMLxldEfsszvBw55nRv8WPW8c1BgnCKChreqB6/mr1vX+cAs3G6T+H
	 6ZbK+Th3lU6Iw==
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
Subject: [PATCH 12/21] xfs: store an agbno in struct xfs_imap
Date: Mon, 24 Aug 2026 12:40:10 +0200
Message-ID: <20260824104022.420566-13-aalbersh@kernel.org>
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
 db/iunlink.c             |  4 +++-
 libxfs/inode.c           |  4 +++-
 libxfs/iunlink.c         |  2 +-
 libxfs/libxfs_api_defs.h |  2 +-
 libxfs/logitem.c         |  6 +++++-
 libxfs/xfs_ialloc.c      | 24 +++++++-----------------
 libxfs/xfs_inode_buf.c   | 11 ++++++-----
 libxfs/xfs_inode_buf.h   |  8 ++++----
 repair/bmap_repair.c     |  6 +++++-
 9 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/db/iunlink.c b/db/iunlink.c
index eaf5a812114b..c44917637352 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -46,6 +46,7 @@ get_next_unlinked(
 	xfs_ino_t		ino;
 	xfs_agino_t		ret;
 	int			error;
+	struct xfs_perag	*pag = libxfs_perag_get(mp, agno);
 
 	ino = XFS_AGINO_TO_INO(mp, agno, agino);
 	error = -libxfs_iget(mp, NULL, ino, 0, &ip);
@@ -65,7 +66,8 @@ get_next_unlinked(
 		dbprintf("\n");
 	}
 
-	error = -libxfs_imap_to_bp(mp, NULL, &ip->i_imap, &ino_bp);
+	error = -libxfs_read_icluster(pag, NULL, ip->i_imap.im_agbno, &ino_bp);
+	libxfs_perag_put(pag);
 	if (error) {
 		libxfs_irele(ip);
 		goto bad;
diff --git a/libxfs/inode.c b/libxfs/inode.c
index 4608e44658d8..21a76c3229f5 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -182,7 +182,7 @@ libxfs_iget(
 	} else {
 		struct xfs_buf		*bp;
 
-		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp);
+		error = xfs_read_icluster(pag, tp, ip->i_imap.im_agbno, &bp);
 		if (error)
 			goto out_destroy;
 
@@ -195,11 +195,13 @@ libxfs_iget(
 		if (error)
 			goto out_destroy;
 	}
+	xfs_perag_put(pag);
 
 	*ipp = ip;
 	return 0;
 
 out_destroy:
+	xfs_perag_put(pag);
 	kmem_cache_free(xfs_inode_cache, ip);
 	*ipp = NULL;
 	return error;
diff --git a/libxfs/iunlink.c b/libxfs/iunlink.c
index 1b96511b6608..aad43dfb27f1 100644
--- a/libxfs/iunlink.c
+++ b/libxfs/iunlink.c
@@ -44,7 +44,7 @@ xfs_iunlink_log_dinode(
 	int			offset;
 	int			error;
 
-	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &ibp);
+	error = xfs_read_icluster(iup->pag, tp, ip->i_imap.im_agbno, &ibp);
 	if (error)
 		return error;
 	/*
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index d7c912e77879..4f542ae7267e 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -200,7 +200,7 @@
 #define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
 #define xfs_iext_next			libxfs_iext_next
 #define xfs_ifork_zap_attr		libxfs_ifork_zap_attr
-#define xfs_imap_to_bp			libxfs_imap_to_bp
+#define xfs_read_icluster		libxfs_read_icluster
 
 #define xfs_initialize_perag		libxfs_initialize_perag
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 67b982788061..b3b27f1656b6 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -16,6 +16,7 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_ag.h"
 
 struct kmem_cache	*xfs_buf_item_cache;
 struct kmem_cache	*xfs_ili_cache;		/* inode log item cache */
@@ -248,6 +249,7 @@ xfs_inode_item_precommit(
 	}
 
 	if (!iip->ili_item.li_buf) {
+		struct xfs_perag	*pag;
 		struct xfs_buf	*bp;
 		int		error;
 
@@ -261,7 +263,9 @@ xfs_inode_item_precommit(
 		 * here.
 		 */
 		spin_unlock(&iip->ili_lock);
-		error = xfs_imap_to_bp(ip->i_mount, tp, &ip->i_imap, &bp);
+		pag = xfs_perag_get(ip->i_mount, XFS_INODE_TO_AGNO(ip));
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
index 4812230ecd57..57ec430680c9 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -745,6 +745,7 @@ rebuild_bmap(
 	xfs_daddr_t		bp_bn;
 	int			bp_length;
 	int			error, err2;
+	struct xfs_perag	*pag;
 
 	bp_bn = xfs_buf_daddr(*ino_bpp);
 	bp_length = (*ino_bpp)->b_length;
@@ -821,7 +822,10 @@ rebuild_bmap(
 	 * Rebuilding the inode fork rolled the transaction, so we need to
 	 * re-grab the inode cluster buffer and dinode pointer for the caller.
 	 */
-	err2 = -libxfs_imap_to_bp(mp, NULL, &sc.ip->i_imap, ino_bpp);
+	pag = libxfs_perag_get(sc.ip->i_mount, XFS_INODE_TO_AGNO(sc.ip));
+	err2 = -libxfs_read_icluster(pag, NULL, sc.ip->i_imap.im_agbno,
+			ino_bpp);
+	libxfs_perag_put(pag);
 	if (err2)
 		do_error(
  _("Unable to re-grab inode cluster buffer after failed repair of inode %llu, error %d.\n"),
-- 
2.55.0

