Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7192C3783AE
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jun 2026 12:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780317867; cv=none; b=RRiIkkzMUT2vZLtPngxLM/ofimhTzoUDOIA2N20jxojFYQq9Yv85UhXJrlwig25Yzpom/Zo1feKHzeL9Bj+hAE1XMcfdABNubGiWn6S6zfoL1EtjjXOGLfiRXsvEhFPyXdYyx0L2vWDjtRy9+YpUt1bTY7BCdljYLfT1d5wba5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780317867; c=relaxed/simple;
	bh=NnE1fXcZQZajZXSBodBQUPC/c+ubzGic2SYqjbsdkAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEmP6xN8feWJ5pB+DHnKPs716P4PcwNlqKxdp7ehv8M0Rv6VuAn75+AEfnjmOpiBk0w4475fVCx5hI44XO0t78QbnEHsQt1AwDJ+r6wj5a14FM4nzQ0dvF1XIOhCnyABfwnynyoiocaTBgPPzOMI1R7KrZuJFs6DaMi5Y3sKl+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OSXfhwSG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OSXfhwSG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3Gh84mPmWqN9ttUREwL3E/JUkHWZ50aYpVnqX+neEJ8=; b=OSXfhwSGGVX5HSzk9/ypXtcfr+
	yHJ2Fbz9l6Y7mGCIGSl7QJx4CzXKksEy8G+9RKbAGcnftYNnj2RS31PgX2vhir5O67yg9prOPe5B+
	kasPGsCwCBx4ryYo5+z7B6DU5nvU73Ib3l2wnPUCd/4xdjhJKv8bLBV1nfqcf65vVZcnce28Z2loJ
	faoqVKwV522QOZ+5Vhn3OZHgJ3o7YZgZLD0MQ7FhFRRrCNWisYlo36m6HZPIwOdnOzGp5M7QTWd2M
	B3HxEi5VEY8zFuVTxxAxXOowHKCzkkkds+/XNvBztzX3wcNCg21o0wtWE2EXSUoibNCEYGETyAkjG
	UROS7ACg==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU20G-0000000BA2V-36i4;
	Mon, 01 Jun 2026 12:44:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] xfs: store an agbno in struct xfs_imap
Date: Mon,  1 Jun 2026 14:43:50 +0200
Message-ID: <20260601124410.3508980-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260601124410.3508980-1-hch@lst.de>
References: <20260601124410.3508980-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The xfs_imap structure is embedded into the xfs_inode, which means the
size of it directly affects the inode size.  Replacing the xfs_daddr_t
with an xfs_agbno_t and taking the AG information from other easily
available sources allows us to shrink the structure including the
typical padding from 16 bytes to 8 bytes.

As a side-effect the debugging check in xfs_imap() naturally now
converges to a stricter variant that checks that the cluster is located
inside a single AG, and not just inside the entire device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ialloc.c    | 24 +++++++-----------------
 fs/xfs/libxfs/xfs_inode_buf.c | 11 ++++++-----
 fs/xfs/libxfs/xfs_inode_buf.h |  8 ++++----
 fs/xfs/scrub/ialloc.c         |  8 ++++----
 fs/xfs/scrub/ialloc_repair.c  |  3 +--
 fs/xfs/scrub/inode_repair.c   |  3 ++-
 fs/xfs/scrub/trace.h          | 12 ++++++------
 fs/xfs/xfs_icache.c           |  2 +-
 fs/xfs/xfs_inode_item.c       | 18 +++++++++++-------
 fs/xfs/xfs_itable.c           |  2 +-
 fs/xfs/xfs_iunlink_item.c     |  2 +-
 11 files changed, 44 insertions(+), 49 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 18d07cf4c3e0..ffcdd1f691fd 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1075,7 +1075,7 @@ xfs_dialloc_check_ino(
 	if (error)
 		return -EAGAIN;
 
-	error = xfs_read_icluster(pag_mount(pag), tp, imap.im_blkno, &bp);
+	error = xfs_read_icluster(pag, tp, imap.im_agbno, &bp);
 	if (error)
 		return -EAGAIN;
 
@@ -2551,23 +2551,13 @@ xfs_imap(
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
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index a9864e3050cb..336ef843f2fe 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -127,19 +127,20 @@ const struct xfs_buf_ops xfs_inode_buf_ra_ops = {
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
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index bcad22871b5c..57192adc7744 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
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
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index fafbf1636723..19c0b1b2a787 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -363,6 +363,7 @@ xchk_iallocbt_check_cluster(
 	struct xfs_inobt_rec_incore	*irec,
 	unsigned int			cluster_base)
 {
+	struct xfs_perag		*pag = to_perag(bs->cur->bc_group);
 	struct xfs_imap			imap;
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_buf			*cluster_bp;
@@ -394,7 +395,7 @@ xchk_iallocbt_check_cluster(
 	 * ir_startino can be large enough to make im_boffset nonzero.
 	 */
 	ir_holemask = (irec->ir_holemask & cluster_mask);
-	imap.im_blkno = xfs_agbno_to_daddr(to_perag(bs->cur->bc_group), agbno);
+	imap.im_agbno = agbno;
 	imap.im_boffset = XFS_INO_TO_OFFSET(mp, irec->ir_startino) <<
 			mp->m_sb.sb_inodelog;
 
@@ -404,8 +405,7 @@ xchk_iallocbt_check_cluster(
 		return 0;
 	}
 
-	trace_xchk_iallocbt_check_cluster(to_perag(bs->cur->bc_group),
-			irec->ir_startino, imap.im_blkno,
+	trace_xchk_iallocbt_check_cluster(pag, irec->ir_startino, imap.im_agbno,
 			XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster),
 			cluster_base, nr_inodes, cluster_mask, ir_holemask,
 			XFS_INO_TO_OFFSET(mp, irec->ir_startino +
@@ -429,7 +429,7 @@ xchk_iallocbt_check_cluster(
 			&XFS_RMAP_OINFO_INODES);
 
 	/* Grab the inode cluster buffer. */
-	error = xfs_read_icluster(mp, bs->cur->bc_tp, imap.im_blkno,
+	error = xfs_read_icluster(pag, bs->cur->bc_tp, imap.im_agbno,
 			&cluster_bp);
 	if (!xchk_btree_xref_process_error(bs->sc, bs->cur, 0, &error))
 		return error;
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
index 167f605a4962..46b1c8ac5543 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -304,8 +304,7 @@ xrep_ibt_process_cluster(
 	 * inobt because imap_to_bp directly maps the buffer without touching
 	 * either inode btree.
 	 */
-	error = xfs_read_icluster(mp, sc->tp,
-			xfs_agbno_to_daddr(sc->sa.pag, cluster_bno),
+	error = xfs_read_icluster(sc->sa.pag, sc->tp, cluster_bno,
 			&cluster_bp);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 8d180673b76b..493dcf5cc6c1 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1561,7 +1561,8 @@ xrep_dinode_core(
 
 	/* Read the inode cluster buffer. */
 	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
-			ri->imap.im_blkno,
+			XFS_AGB_TO_DADDR(mp, XFS_INO_TO_AGNO(mp, ino),
+					ri->imap.im_agbno),
 			XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster),
 			0, &bp, NULL);
 	if (error)
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index d27c99beee13..1b7d9e07a27d 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -785,17 +785,17 @@ TRACE_EVENT(xchk_xref_error,
 
 TRACE_EVENT(xchk_iallocbt_check_cluster,
 	TP_PROTO(const struct xfs_perag *pag, xfs_agino_t startino,
-		 xfs_daddr_t map_daddr,  unsigned short map_len,
+		 xfs_agblock_t map_agblock,  unsigned short map_len,
 		 unsigned int chunk_ino,  unsigned int nr_inodes,
 		 uint16_t cluster_mask, uint16_t holemask,
 		 unsigned int cluster_ino),
-	TP_ARGS(pag, startino, map_daddr, map_len, chunk_ino, nr_inodes,
+	TP_ARGS(pag, startino, map_agblock, map_len, chunk_ino, nr_inodes,
 		cluster_mask, holemask, cluster_ino),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_agino_t, startino)
-		__field(xfs_daddr_t, map_daddr)
+		__field(xfs_agblock_t, map_agblock)
 		__field(unsigned short, map_len)
 		__field(unsigned int, chunk_ino)
 		__field(unsigned int, nr_inodes)
@@ -807,7 +807,7 @@ TRACE_EVENT(xchk_iallocbt_check_cluster,
 		__entry->dev = pag_mount(pag)->m_super->s_dev;
 		__entry->agno = pag_agno(pag);
 		__entry->startino = startino;
-		__entry->map_daddr = map_daddr;
+		__entry->map_agblock = map_agblock;
 		__entry->map_len = map_len;
 		__entry->chunk_ino = chunk_ino;
 		__entry->nr_inodes = nr_inodes;
@@ -815,11 +815,11 @@ TRACE_EVENT(xchk_iallocbt_check_cluster,
 		__entry->holemask = holemask;
 		__entry->cluster_ino = cluster_ino;
 	),
-	TP_printk("dev %d:%d agno 0x%x startino 0x%x daddr 0x%llx bbcount 0x%x chunkino 0x%x nr_inodes %u cluster_mask 0x%x holemask 0x%x cluster_ino 0x%x",
+	TP_printk("dev %d:%d agno 0x%x startino 0x%x agblock 0x%x bbcount 0x%x chunkino 0x%x nr_inodes %u cluster_mask 0x%x holemask 0x%x cluster_ino 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->startino,
-		  __entry->map_daddr,
+		  __entry->map_agblock,
 		  __entry->map_len,
 		  __entry->chunk_ino,
 		  __entry->nr_inodes,
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 234c1e6974e4..9d8dd30bd927 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -663,7 +663,7 @@ xfs_iget_cache_miss(
 	} else {
 		struct xfs_buf		*bp;
 
-		error = xfs_read_icluster(mp, tp, ip->i_imap.im_blkno, &bp);
+		error = xfs_read_icluster(pag, tp, ip->i_imap.im_agbno, &bp);
 		if (error)
 			goto out_destroy;
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index b4a835eb2e6d..99d6ecccdaa7 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -18,6 +18,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
+#include "xfs_ag.h"
 #include "xfs_error.h"
 #include "xfs_rtbitmap.h"
 
@@ -104,6 +105,7 @@ xfs_inode_item_precommit(
 {
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
+	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
 	unsigned int		flags = iip->ili_dirty_flags;
 
@@ -124,8 +126,7 @@ xfs_inode_item_precommit(
 	 * to upgrade this inode to bigtime format, do so now.
 	 */
 	if ((flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
-	    xfs_has_bigtime(ip->i_mount) &&
-	    !xfs_inode_has_bigtime(ip)) {
+	    xfs_has_bigtime(mp) && !xfs_inode_has_bigtime(ip)) {
 		ip->i_diflags2 |= XFS_DIFLAG2_BIGTIME;
 		flags |= XFS_ILOG_CORE;
 	}
@@ -138,14 +139,14 @@ xfs_inode_item_precommit(
 	 */
 	if (ip->i_diflags & XFS_DIFLAG_RTINHERIT) {
 		if ((ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
-		    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_extsize) > 0) {
+		    xfs_extlen_to_rtxmod(mp, ip->i_extsize) > 0) {
 			ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
 					   XFS_DIFLAG_EXTSZINHERIT);
 			ip->i_extsize = 0;
 			flags |= XFS_ILOG_CORE;
 		}
 		if ((ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
-		    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_cowextsize) > 0) {
+		    xfs_extlen_to_rtxmod(mp, ip->i_cowextsize) > 0) {
 			ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
 			ip->i_cowextsize = 0;
 			flags |= XFS_ILOG_CORE;
@@ -154,6 +155,7 @@ xfs_inode_item_precommit(
 
 	spin_lock(&iip->ili_lock);
 	if (!iip->ili_item.li_buf) {
+		struct xfs_perag *pag;
 		struct xfs_buf	*bp;
 		int		error;
 
@@ -167,8 +169,9 @@ xfs_inode_item_precommit(
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
 
@@ -654,7 +657,8 @@ xfs_inode_item_format(
 	ilf = xlog_format_start(lfb, XLOG_REG_TYPE_IFORMAT);
 	ilf->ilf_type = XFS_LI_INODE;
 	ilf->ilf_ino = I_INO(ip);
-	ilf->ilf_blkno = ip->i_imap.im_blkno;
+	ilf->ilf_blkno = XFS_AGB_TO_DADDR(mp, XFS_INODE_TO_AGNO(ip),
+				ip->i_imap.im_agbno);
 	ilf->ilf_len = XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster);
 	ilf->ilf_boffset = ip->i_imap.im_boffset;
 	ilf->ilf_fields = XFS_ILOG_CORE;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 97f106d2b4cd..159295c63e8f 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -97,7 +97,7 @@ xfs_bulkstat_one_int(
 	}
 
 	ASSERT(ip != NULL);
-	ASSERT(ip->i_imap.im_blkno != 0);
+	ASSERT(ip->i_imap.im_agbno != 0);
 	inode = VFS_I(ip);
 	vfsuid = i_uid_into_vfsuid(idmap, inode);
 	vfsgid = i_gid_into_vfsgid(idmap, inode);
diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
index f8f2edea0934..d76d3f0434f1 100644
--- a/fs/xfs/xfs_iunlink_item.c
+++ b/fs/xfs/xfs_iunlink_item.c
@@ -59,7 +59,7 @@ xfs_iunlink_log_dinode(
 	int			offset;
 	int			error;
 
-	error = xfs_read_icluster(tp->t_mountp, tp, ip->i_imap.im_blkno, &ibp);
+	error = xfs_read_icluster(iup->pag, tp, ip->i_imap.im_agbno, &ibp);
 	if (error)
 		return error;
 	/*
-- 
2.53.0

