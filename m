Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q585dAJC173221 for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 00:39:10 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	8FS5Vkv14rSm2WKm for <xfs@oss.sgi.com>;
	Thu, 07 Jun 2012 22:39:07 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1ScruK-0004hI-Ul
	for xfs@oss.sgi.com; Fri, 08 Jun 2012 15:38:49 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1ScruK-0002vm-RQ
	for xfs@oss.sgi.com; Fri, 08 Jun 2012 15:38:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/9] xfs: use multiple irec xfs buf support in dabuf
Date: Fri,  8 Jun 2012 15:38:32 +1000
Message-Id: <1339133914-11148-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1339133914-11148-1-git-send-email-david@fromorbit.com>
References: <1339133914-11148-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_da_btree.c |  538 ++++++++++++++++++++++---------------------------
 fs/xfs/xfs_da_btree.h |    6 +-
 2 files changed, 239 insertions(+), 305 deletions(-)

diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 015b946..76e5dba 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -85,7 +85,7 @@ STATIC void xfs_da_node_unbalance(xfs_da_state_t *state,
  */
 STATIC uint	xfs_da_node_lasthash(xfs_dabuf_t *bp, int *count);
 STATIC int	xfs_da_node_order(xfs_dabuf_t *node1_bp, xfs_dabuf_t *node2_bp);
-STATIC xfs_dabuf_t *xfs_da_buf_make(int nbuf, xfs_buf_t **bps);
+STATIC xfs_dabuf_t *xfs_da_buf_make(xfs_buf_t *bp);
 STATIC int	xfs_da_blk_unlink(xfs_da_state_t *state,
 				  xfs_da_state_blk_t *drop_blk,
 				  xfs_da_state_blk_t *save_blk);
@@ -1967,35 +1967,75 @@ xfs_da_map_covers_blocks(
 }
 
 /*
- * Make a dabuf.
- * Used for get_buf, read_buf, read_bufr, and reada_buf.
+ * Convert a struct xfs_bmbt_irec to a struct xfs_buf_map.
+ *
+ * For the single map case, it is assumed that the caller has provided a pointer
+ * to a valid xfs_buf_map.  For the multiple map case, this function will
+ * allocate the xfs_buf_map to hold all the maps and replace the caller's single
+ * map pointer with the allocated map.
  */
-STATIC int
-xfs_da_do_buf(
-	xfs_trans_t	*trans,
-	xfs_inode_t	*dp,
-	xfs_dablk_t	bno,
-	xfs_daddr_t	*mappedbnop,
-	xfs_dabuf_t	**bpp,
-	int		whichfork,
-	int		caller)
+static int
+xfs_buf_map_from_irec(
+	struct xfs_mount	*mp,
+	struct xfs_buf_map	**mapp,
+	unsigned int		*nmaps,
+	struct xfs_bmbt_irec	*irecs,
+	unsigned int		nirecs)
 {
-	xfs_buf_t	*bp = NULL;
-	xfs_buf_t	**bplist;
-	int		error=0;
-	int		i;
-	xfs_bmbt_irec_t	map;
-	xfs_bmbt_irec_t	*mapp;
-	xfs_daddr_t	mappedbno;
-	xfs_mount_t	*mp;
-	int		nbplist=0;
-	int		nfsb;
-	int		nmap;
-	xfs_dabuf_t	*rbp;
+	struct xfs_buf_map	*map;
+	int			i;
+
+	ASSERT(*nmaps == 1);
+	ASSERT(nirecs >= 1);
+
+	if (nirecs > 1) {
+		map = kmem_zalloc(nirecs * sizeof(struct xfs_buf_map), KM_SLEEP);
+		if (!map)
+			return ENOMEM;
+		*mapp = map;
+	}
+
+	*nmaps = nirecs;
+	map = *mapp;
+	for (i = 0; i < *nmaps; i++) {
+		ASSERT(irecs[i].br_startblock != DELAYSTARTBLOCK &&
+		       irecs[i].br_startblock != HOLESTARTBLOCK);
+		map[i].bm_bn = XFS_FSB_TO_DADDR(mp, irecs[i].br_startblock);
+		map[i].bm_len = XFS_FSB_TO_BB(mp, irecs[i].br_blockcount);
+	}
+	return 0;
+}
+
+/*
+ * Map the block we are given ready for reading. There are three possible return
+ * values:
+ *	-1 - will be returned if we land in a hole and mappedbno == -2 so the
+ *	     caller knows not to execute a subsequent read.
+ *	 0 - if we mapped the block successfully
+ *	>0 - positive error number if there was an error.
+ */
+static int
+xfs_dabuf_map(
+	struct xfs_trans	*trans,
+	struct xfs_inode	*dp,
+	xfs_dablk_t		bno,
+	xfs_daddr_t		mappedbno,
+	int			whichfork,
+	struct xfs_buf_map	**map,
+	int			*nmaps)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+	int			nfsb;
+	int			error = 0;
+	struct xfs_bmbt_irec	irec;
+	struct xfs_bmbt_irec	*irecs = &irec;
+	int			nirecs;
+
+	ASSERT(map && *map);
+	ASSERT(*nmaps == 1);
 
-	mp = dp->i_mount;
 	nfsb = (whichfork == XFS_DATA_FORK) ? mp->m_dirblkfsbs : 1;
-	mappedbno = *mappedbnop;
+
 	/*
 	 * Caller doesn't have a mapping.  -2 means don't complain
 	 * if we land in a hole.
@@ -2004,112 +2044,152 @@ xfs_da_do_buf(
 		/*
 		 * Optimize the one-block case.
 		 */
-		if (nfsb == 1)
-			mapp = &map;
-		else
-			mapp = kmem_alloc(sizeof(*mapp) * nfsb, KM_SLEEP);
+		if (nfsb != 1)
+			irecs = kmem_zalloc(sizeof(irec) * nfsb, KM_SLEEP);
 
-		nmap = nfsb;
-		error = xfs_bmapi_read(dp, (xfs_fileoff_t)bno, nfsb, mapp,
-				       &nmap, xfs_bmapi_aflag(whichfork));
+		nirecs = nfsb;
+		error = xfs_bmapi_read(dp, (xfs_fileoff_t)bno, nfsb, irecs,
+				       &nirecs, xfs_bmapi_aflag(whichfork));
 		if (error)
-			goto exit0;
+			goto out;
 	} else {
-		map.br_startblock = XFS_DADDR_TO_FSB(mp, mappedbno);
-		map.br_startoff = (xfs_fileoff_t)bno;
-		map.br_blockcount = nfsb;
-		mapp = &map;
-		nmap = 1;
+		irecs->br_startblock = XFS_DADDR_TO_FSB(mp, mappedbno);
+		irecs->br_startoff = (xfs_fileoff_t)bno;
+		irecs->br_blockcount = nfsb;
+		irecs->br_state = 0;
+		nirecs = 1;
 	}
-	if (!xfs_da_map_covers_blocks(nmap, mapp, bno, nfsb)) {
-		error = mappedbno == -2 ? 0 : XFS_ERROR(EFSCORRUPTED);
+
+	if (!xfs_da_map_covers_blocks(nirecs, irecs, bno, nfsb)) {
+		error = mappedbno == -2 ? -1 : XFS_ERROR(EFSCORRUPTED);
 		if (unlikely(error == EFSCORRUPTED)) {
 			if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
+				int i;
 				xfs_alert(mp, "%s: bno %lld dir: inode %lld",
 					__func__, (long long)bno,
 					(long long)dp->i_ino);
-				for (i = 0; i < nmap; i++) {
+				for (i = 0; i < *nmaps; i++) {
 					xfs_alert(mp,
 "[%02d] br_startoff %lld br_startblock %lld br_blockcount %lld br_state %d",
 						i,
-						(long long)mapp[i].br_startoff,
-						(long long)mapp[i].br_startblock,
-						(long long)mapp[i].br_blockcount,
-						mapp[i].br_state);
+						(long long)irecs[i].br_startoff,
+						(long long)irecs[i].br_startblock,
+						(long long)irecs[i].br_blockcount,
+						irecs[i].br_state);
 				}
 			}
 			XFS_ERROR_REPORT("xfs_da_do_buf(1)",
 					 XFS_ERRLEVEL_LOW, mp);
 		}
-		goto exit0;
+		goto out;
 	}
-	if (caller != 3 && nmap > 1) {
-		bplist = kmem_alloc(sizeof(*bplist) * nmap, KM_SLEEP);
-		nbplist = 0;
-	} else
-		bplist = NULL;
-	/*
-	 * Turn the mapping(s) into buffer(s).
-	 */
-	for (i = 0; i < nmap; i++) {
-		int	nmapped;
-
-		mappedbno = XFS_FSB_TO_DADDR(mp, mapp[i].br_startblock);
-		if (i == 0)
-			*mappedbnop = mappedbno;
-		nmapped = (int)XFS_FSB_TO_BB(mp, mapp[i].br_blockcount);
-		switch (caller) {
-		case 0:
-			bp = xfs_trans_get_buf(trans, mp->m_ddev_targp,
-				mappedbno, nmapped, 0);
-			error = bp ? bp->b_error : XFS_ERROR(EIO);
-			break;
-		case 1:
-		case 2:
-			bp = NULL;
-			error = xfs_trans_read_buf(mp, trans, mp->m_ddev_targp,
-				mappedbno, nmapped, 0, &bp);
-			break;
-		case 3:
-			xfs_buf_readahead(mp->m_ddev_targp, mappedbno, nmapped);
+	error = xfs_buf_map_from_irec(mp, map, nmaps, irecs, nirecs);
+out:
+	if (irecs != &irec)
+		kmem_free(irecs);
+	return error;
+}
+
+/*
+ * Get a buffer for the dir/attr block.
+ */
+int
+xfs_da_get_buf(
+	struct xfs_trans	*trans,
+	struct xfs_inode	*dp,
+	xfs_dablk_t		bno,
+	xfs_daddr_t		mappedbno,
+	xfs_dabuf_t		**bpp,
+	int			whichfork)
+{
+	struct xfs_buf		*bp;
+	struct xfs_buf_map	map;
+	struct xfs_buf_map	*mapp;
+	int			nmap;
+	int			error;
+
+	*bpp = NULL;
+	mapp = &map;
+	nmap = 1;
+	error = xfs_dabuf_map(trans, dp, bno, mappedbno, whichfork,
+				&mapp, &nmap);
+	if (error) {
+		/* mapping a hole is not an error, but we don't continue */
+		if (error == -1)
 			error = 0;
-			bp = NULL;
-			break;
-		}
-		if (error) {
-			if (bp)
-				xfs_trans_brelse(trans, bp);
-			goto exit1;
-		}
-		if (!bp)
-			continue;
-		if (caller == 1) {
-			if (whichfork == XFS_ATTR_FORK)
-				xfs_buf_set_ref(bp, XFS_ATTR_BTREE_REF);
-			else
-				xfs_buf_set_ref(bp, XFS_DIR_BTREE_REF);
-		}
-		if (bplist) {
-			bplist[nbplist++] = bp;
-		}
+		goto out_free;
 	}
-	/*
-	 * Build a dabuf structure.
-	 */
-	if (bplist) {
-		rbp = xfs_da_buf_make(nbplist, bplist);
-	} else if (bp)
-		rbp = xfs_da_buf_make(1, &bp);
+
+	bp = xfs_trans_get_buf_map(trans, dp->i_mount->m_ddev_targp,
+				    mapp, nmap, 0);
+	error = bp ? bp->b_error : XFS_ERROR(EIO);
+	if (error) {
+		xfs_trans_brelse(trans, bp);
+		goto out_free;
+	}
+
+	*bpp = xfs_da_buf_make(bp);
+
+out_free:
+	if (mapp != &map)
+		kmem_free(mapp);
+
+	return error;
+}
+
+/*
+ * Get a buffer for the dir/attr block, fill in the contents.
+ */
+int
+xfs_da_read_buf(
+	struct xfs_trans	*trans,
+	struct xfs_inode	*dp,
+	xfs_dablk_t		bno,
+	xfs_daddr_t		mappedbno,
+	xfs_dabuf_t		**bpp,
+	int			whichfork)
+{
+	struct xfs_buf		*bp;
+	struct xfs_buf_map	map;
+	struct xfs_buf_map	*mapp;
+	int			nmap;
+	int			error;
+
+	*bpp = NULL;
+	mapp = &map;
+	nmap = 1;
+	error = xfs_dabuf_map(trans, dp, bno, mappedbno, whichfork,
+				&mapp, &nmap);
+	if (error) {
+		/* mapping a hole is not an error, but we don't continue */
+		if (error == -1)
+			error = 0;
+		goto out_free;
+	}
+
+	error = xfs_trans_read_buf_map(dp->i_mount, trans,
+					dp->i_mount->m_ddev_targp,
+					mapp, nmap, 0, &bp);
+	if (error)
+		goto out_free;
+
+	if (whichfork == XFS_ATTR_FORK)
+		xfs_buf_set_ref(bp, XFS_ATTR_BTREE_REF);
 	else
-		rbp = NULL;
+		xfs_buf_set_ref(bp, XFS_DIR_BTREE_REF);
+
+	*bpp = xfs_da_buf_make(bp);
+
 	/*
-	 * For read_buf, check the magic number.
+	 * This verification code will be moved to a CRC verification callback
+	 * function so just leave it here unchanged until then.
 	 */
-	if (caller == 1) {
-		xfs_dir2_data_hdr_t	*hdr = rbp->data;
-		xfs_dir2_free_t		*free = rbp->data;
-		xfs_da_blkinfo_t	*info = rbp->data;
+	{
+		xfs_dir2_data_hdr_t	*hdr = (*bpp)->data;
+		xfs_dir2_free_t		*free = (*bpp)->data;
+		xfs_da_blkinfo_t	*info = (*bpp)->data;
 		uint			magic, magic1;
+		struct xfs_mount	*mp = dp->i_mount;
 
 		magic = be16_to_cpu(info->magic);
 		magic1 = be32_to_cpu(hdr->magic);
@@ -2123,66 +2203,20 @@ xfs_da_do_buf(
 				   (free->hdr.magic != cpu_to_be32(XFS_DIR2_FREE_MAGIC)),
 				mp, XFS_ERRTAG_DA_READ_BUF,
 				XFS_RANDOM_DA_READ_BUF))) {
-			trace_xfs_da_btree_corrupt(rbp->bps[0], _RET_IP_);
+			trace_xfs_da_btree_corrupt(bp, _RET_IP_);
 			XFS_CORRUPTION_ERROR("xfs_da_do_buf(2)",
 					     XFS_ERRLEVEL_LOW, mp, info);
 			error = XFS_ERROR(EFSCORRUPTED);
-			xfs_da_brelse(trans, rbp);
-			nbplist = 0;
-			goto exit1;
+			xfs_da_brelse(trans, *bpp);
+			goto out_free;
 		}
 	}
-	if (bplist) {
-		kmem_free(bplist);
-	}
-	if (mapp != &map) {
-		kmem_free(mapp);
-	}
-	if (bpp)
-		*bpp = rbp;
-	return 0;
-exit1:
-	if (bplist) {
-		for (i = 0; i < nbplist; i++)
-			xfs_trans_brelse(trans, bplist[i]);
-		kmem_free(bplist);
-	}
-exit0:
+
+out_free:
 	if (mapp != &map)
 		kmem_free(mapp);
-	if (bpp)
-		*bpp = NULL;
-	return error;
-}
-
-/*
- * Get a buffer for the dir/attr block.
- */
-int
-xfs_da_get_buf(
-	xfs_trans_t	*trans,
-	xfs_inode_t	*dp,
-	xfs_dablk_t	bno,
-	xfs_daddr_t		mappedbno,
-	xfs_dabuf_t	**bpp,
-	int		whichfork)
-{
-	return xfs_da_do_buf(trans, dp, bno, &mappedbno, bpp, whichfork, 0);
-}
 
-/*
- * Get a buffer for the dir/attr block, fill in the contents.
- */
-int
-xfs_da_read_buf(
-	xfs_trans_t	*trans,
-	xfs_inode_t	*dp,
-	xfs_dablk_t	bno,
-	xfs_daddr_t		mappedbno,
-	xfs_dabuf_t	**bpp,
-	int		whichfork)
-{
-	return xfs_da_do_buf(trans, dp, bno, &mappedbno, bpp, whichfork, 1);
+	return error;
 }
 
 /*
@@ -2190,18 +2224,38 @@ xfs_da_read_buf(
  */
 xfs_daddr_t
 xfs_da_reada_buf(
-	xfs_trans_t	*trans,
-	xfs_inode_t	*dp,
-	xfs_dablk_t	bno,
-	int		whichfork)
+	struct xfs_trans	*trans,
+	struct xfs_inode	*dp,
+	xfs_dablk_t		bno,
+	int			whichfork)
 {
-	xfs_daddr_t		rval;
+	xfs_daddr_t		mappedbno = -1;
+	struct xfs_buf_map	map;
+	struct xfs_buf_map	*mapp;
+	int			nmap;
+	int			error;
+
+	mapp = &map;
+	nmap = 1;
+	error = xfs_dabuf_map(trans, dp, bno, -1, whichfork,
+				&mapp, &nmap);
+	if (error) {
+		/* mapping a hole is not an error, but we don't continue */
+		if (error == -1)
+			error = 0;
+		goto out_free;
+	}
 
-	rval = -1;
-	if (xfs_da_do_buf(trans, dp, bno, &rval, NULL, whichfork, 3))
+	mappedbno = mapp[0].bm_bn;
+	xfs_buf_readahead_map(dp->i_mount->m_ddev_targp, mapp, nmap);
+
+out_free:
+	if (mapp != &map)
+		kmem_free(mapp);
+
+	if (error)
 		return -1;
-	else
-		return rval;
+	return mappedbno;
 }
 
 kmem_zone_t *xfs_da_state_zone;	/* anchor for state struct zone */
@@ -2261,78 +2315,25 @@ xfs_da_state_free(xfs_da_state_t *state)
  */
 /* ARGSUSED */
 STATIC xfs_dabuf_t *
-xfs_da_buf_make(int nbuf, xfs_buf_t **bps)
+xfs_da_buf_make(xfs_buf_t *bp)
 {
-	xfs_buf_t	*bp;
 	xfs_dabuf_t	*dabuf;
-	int		i;
-	int		off;
 
-	if (nbuf == 1)
-		dabuf = kmem_zone_alloc(xfs_dabuf_zone, KM_NOFS);
-	else
-		dabuf = kmem_alloc(XFS_DA_BUF_SIZE(nbuf), KM_NOFS);
-	dabuf->dirty = 0;
-	if (nbuf == 1) {
-		dabuf->nbuf = 1;
-		bp = bps[0];
-		dabuf->bbcount = bp->b_length;
-		dabuf->data = bp->b_addr;
-		dabuf->bps[0] = bp;
-	} else {
-		dabuf->nbuf = nbuf;
-		for (i = 0, dabuf->bbcount = 0; i < nbuf; i++) {
-			dabuf->bps[i] = bp = bps[i];
-			dabuf->bbcount += bp->b_length;
-		}
-		dabuf->data = kmem_alloc(BBTOB(dabuf->bbcount), KM_SLEEP);
-		for (i = off = 0; i < nbuf; i++, off += BBTOB(bp->b_length)) {
-			bp = bps[i];
-			memcpy((char *)dabuf->data + off, bp->b_addr,
-				BBTOB(bp->b_length));
-		}
-	}
+	dabuf = kmem_zone_alloc(xfs_dabuf_zone, KM_NOFS);
+	dabuf->bbcount = bp->b_length;
+	dabuf->data = bp->b_addr;
+	dabuf->bp = bp;
 	return dabuf;
 }
 
 /*
- * Un-dirty a dabuf.
- */
-STATIC void
-xfs_da_buf_clean(xfs_dabuf_t *dabuf)
-{
-	xfs_buf_t	*bp;
-	int		i;
-	int		off;
-
-	if (dabuf->dirty) {
-		ASSERT(dabuf->nbuf > 1);
-		dabuf->dirty = 0;
-		for (i = off = 0; i < dabuf->nbuf;
-				i++, off += BBTOB(bp->b_length)) {
-			bp = dabuf->bps[i];
-			memcpy(bp->b_addr, dabuf->data + off,
-						BBTOB(bp->b_length));
-		}
-	}
-}
-
-/*
  * Release a dabuf.
  */
 void
 xfs_da_buf_done(xfs_dabuf_t *dabuf)
 {
-	ASSERT(dabuf);
-	ASSERT(dabuf->nbuf && dabuf->data && dabuf->bbcount && dabuf->bps[0]);
-	if (dabuf->dirty)
-		xfs_da_buf_clean(dabuf);
-	if (dabuf->nbuf > 1) {
-		kmem_free(dabuf->data);
-		kmem_free(dabuf);
-	} else {
-		kmem_zone_free(xfs_dabuf_zone, dabuf);
-	}
+	ASSERT(dabuf->data && dabuf->bbcount && dabuf->bp);
+	kmem_zone_free(xfs_dabuf_zone, dabuf);
 }
 
 /*
@@ -2341,41 +2342,9 @@ xfs_da_buf_done(xfs_dabuf_t *dabuf)
 void
 xfs_da_log_buf(xfs_trans_t *tp, xfs_dabuf_t *dabuf, uint first, uint last)
 {
-	xfs_buf_t	*bp;
-	uint		f;
-	int		i;
-	uint		l;
-	int		off;
-
-	ASSERT(dabuf->nbuf && dabuf->data && dabuf->bbcount && dabuf->bps[0]);
-	if (dabuf->nbuf == 1) {
-		ASSERT(dabuf->data == dabuf->bps[0]->b_addr);
-		xfs_trans_log_buf(tp, dabuf->bps[0], first, last);
-		return;
-	}
-	dabuf->dirty = 1;
-	ASSERT(first <= last);
-	for (i = off = 0; i < dabuf->nbuf; i++, off += BBTOB(bp->b_length)) {
-		bp = dabuf->bps[i];
-		f = off;
-		l = f + BBTOB(bp->b_length) - 1;
-		if (f < first)
-			f = first;
-		if (l > last)
-			l = last;
-		if (f <= l)
-			xfs_trans_log_buf(tp, bp, f - off, l - off);
-		/*
-		 * B_DONE is set by xfs_trans_log buf.
-		 * If we don't set it on a new buffer (get not read)
-		 * then if we don't put anything in the buffer it won't
-		 * be set, and at commit it it released into the cache,
-		 * and then a read will fail.
-		 */
-		else if (!(XFS_BUF_ISDONE(bp)))
-		  XFS_BUF_DONE(bp);
-	}
-	ASSERT(last < off);
+	ASSERT(dabuf->data && dabuf->bbcount && dabuf->bp);
+	ASSERT(dabuf->data == dabuf->bp->b_addr);
+	xfs_trans_log_buf(tp, dabuf->bp, first, last);
 }
 
 /*
@@ -2386,24 +2355,9 @@ xfs_da_log_buf(xfs_trans_t *tp, xfs_dabuf_t *dabuf, uint first, uint last)
 void
 xfs_da_brelse(xfs_trans_t *tp, xfs_dabuf_t *dabuf)
 {
-	xfs_buf_t	*bp;
-	xfs_buf_t	**bplist;
-	int		i;
-	int		nbuf;
-
-	ASSERT(dabuf->nbuf && dabuf->data && dabuf->bbcount && dabuf->bps[0]);
-	if ((nbuf = dabuf->nbuf) == 1) {
-		bplist = &bp;
-		bp = dabuf->bps[0];
-	} else {
-		bplist = kmem_alloc(nbuf * sizeof(*bplist), KM_SLEEP);
-		memcpy(bplist, dabuf->bps, nbuf * sizeof(*bplist));
-	}
+	ASSERT(dabuf->data && dabuf->bbcount && dabuf->bp);
+	xfs_trans_brelse(tp, dabuf->bp);
 	xfs_da_buf_done(dabuf);
-	for (i = 0; i < nbuf; i++)
-		xfs_trans_brelse(tp, bplist[i]);
-	if (bplist != &bp)
-		kmem_free(bplist);
 }
 
 /*
@@ -2412,24 +2366,9 @@ xfs_da_brelse(xfs_trans_t *tp, xfs_dabuf_t *dabuf)
 void
 xfs_da_binval(xfs_trans_t *tp, xfs_dabuf_t *dabuf)
 {
-	xfs_buf_t	*bp;
-	xfs_buf_t	**bplist;
-	int		i;
-	int		nbuf;
-
-	ASSERT(dabuf->nbuf && dabuf->data && dabuf->bbcount && dabuf->bps[0]);
-	if ((nbuf = dabuf->nbuf) == 1) {
-		bplist = &bp;
-		bp = dabuf->bps[0];
-	} else {
-		bplist = kmem_alloc(nbuf * sizeof(*bplist), KM_SLEEP);
-		memcpy(bplist, dabuf->bps, nbuf * sizeof(*bplist));
-	}
+	ASSERT(dabuf->data && dabuf->bbcount && dabuf->bp);
 	xfs_da_buf_done(dabuf);
-	for (i = 0; i < nbuf; i++)
-		xfs_trans_binval(tp, bplist[i]);
-	if (bplist != &bp)
-		kmem_free(bplist);
+	xfs_trans_binval(tp, dabuf->bp);
 }
 
 /*
@@ -2438,7 +2377,6 @@ xfs_da_binval(xfs_trans_t *tp, xfs_dabuf_t *dabuf)
 xfs_daddr_t
 xfs_da_blkno(xfs_dabuf_t *dabuf)
 {
-	ASSERT(dabuf->nbuf);
 	ASSERT(dabuf->data);
-	return XFS_BUF_ADDR(dabuf->bps[0]);
+	return XFS_BUF_ADDR(dabuf->bp);
 }
diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index dbf7c07..0b64c4a 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -141,14 +141,10 @@ typedef struct xfs_da_args {
  * same place as the b_addr field for the buffer, else to kmem_alloced memory.
  */
 typedef struct xfs_dabuf {
-	int		nbuf;		/* number of buffer pointers present */
-	short		dirty;		/* data needs to be copied back */
 	short		bbcount;	/* how large is data in bbs */
 	void		*data;		/* pointer for buffers' data */
-	struct xfs_buf	*bps[1];	/* actually nbuf of these */
+	struct xfs_buf	*bp;		/* actually nbuf of these */
 } xfs_dabuf_t;
-#define	XFS_DA_BUF_SIZE(n)	\
-	(sizeof(xfs_dabuf_t) + sizeof(struct xfs_buf *) * ((n) - 1))
 
 /*
  * Storage for holding state during Btree searches and split/join ops.
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
