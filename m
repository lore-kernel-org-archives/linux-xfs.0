Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKfjfX200907 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:41:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 774C11C234FD
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:41:44 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	QkAS0HTI9LFyjyPk for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:41:44 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R5OBL-0004hC-R8
	for xfs@oss.sgi.com; Sun, 18 Sep 2011 20:41:43 +0000
Message-Id: <20110918204143.789847557@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:40:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/27] xfs: factor delalloc reservations out of xfs_bmapi
References: <20110918204040.266805129@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmapi-factor-delalloc-reservation
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

Move the reservation of delayed allocations, and addition of delalloc
regions to the extent trees into a new helper function.  For now
this adds some twisted goto logic to xfs_bmapi, but that will be
cleaned up in the following patches.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-09-11 08:43:05.433123235 -0400
+++ xfs/fs/xfs/xfs_bmap.c	2011-09-11 08:43:08.033123225 -0400
@@ -4441,6 +4441,120 @@ xfs_bmapi_read(
 	return 0;
 }
 
+STATIC int
+xfs_bmapi_reserve_delalloc(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		aoff,
+	xfs_filblks_t		len,
+	struct xfs_bmbt_irec	*got,
+	struct xfs_bmbt_irec	*prev,
+	xfs_extnum_t		*lastx,
+	int			eof)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	xfs_extlen_t		alen;
+	xfs_extlen_t		indlen;
+	xfs_fsblock_t		firstblock = NULLFSBLOCK;
+	struct xfs_btree_cur	*cur = NULL;
+	int			tmp_logflags = 0;
+	char			rt = XFS_IS_REALTIME_INODE(ip);
+	xfs_extlen_t		extsz;
+	int			error;
+
+	alen = XFS_FILBLKS_MIN(len, MAXEXTLEN);
+	if (!eof)
+		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
+
+	/* Figure out the extent size, adjust alen */
+	extsz = xfs_get_extsz_hint(ip);
+	if (extsz) {
+		/*
+		 * Make sure we don't exceed a single extent length when we
+		 * align the extent by reducing length we are going to
+		 * allocate by the maximum amount extent size aligment may
+		 * require.
+		 */
+		alen = XFS_FILBLKS_MIN(len, MAXEXTLEN - (2 * extsz - 1));
+		error = xfs_bmap_extsize_align(mp, got, prev, extsz, rt, eof,
+					       1, 0, &aoff, &alen);
+		ASSERT(!error);
+	}
+
+	if (rt)
+		extsz = alen / mp->m_sb.sb_rextsize;
+
+	/*
+	 * Make a transaction-less quota reservation for delayed allocation
+	 * blocks.  This number gets adjusted later.  We return if we haven't
+	 * allocated blocks already inside this loop.
+	 */
+	error = xfs_trans_reserve_quota_nblks(NULL, ip, (long)alen, 0,
+			rt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
+	if (error)
+		return error;
+
+	/*
+	 * Split changing sb for alen and indlen since they could be coming
+	 * from different places.
+	 */
+	indlen = (xfs_extlen_t)xfs_bmap_worst_indlen(ip, alen);
+	ASSERT(indlen > 0);
+
+	if (rt) {
+		error = xfs_mod_incore_sb(mp, XFS_SBS_FREXTENTS,
+					  -((int64_t)extsz), 0);
+	} else {
+		error = xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
+						 -((int64_t)alen), 0);
+	}
+
+	if (error)
+		goto out_unreserve_quota;
+
+	error = xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
+					 -((int64_t)indlen), 0);
+	if (error)
+		goto out_unreserve_blocks;
+
+
+	ip->i_delayed_blks += alen;
+
+	got->br_startoff = aoff;
+	got->br_startblock = nullstartblock(indlen);
+	got->br_blockcount = alen;
+	got->br_state = XFS_EXT_NORM;
+
+	error = xfs_bmap_add_extent(NULL, ip, lastx, &cur, got, &firstblock,
+				    NULL, &tmp_logflags, XFS_DATA_FORK);
+	ASSERT(!error);
+	ASSERT(!tmp_logflags);
+	ASSERT(!cur);
+
+	/*
+	 * Update our extent pointer, given that xfs_bmap_add_extent might
+	 * have merged it into one of the neighbouring ones.
+	 */
+	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx), got);
+
+	ASSERT(got->br_startoff <= aoff);
+	ASSERT(got->br_startoff + got->br_blockcount >= aoff + alen);
+	ASSERT(isnullstartblock(got->br_startblock));
+	ASSERT(got->br_state == XFS_EXT_NORM);
+	return 0;
+
+out_unreserve_blocks:
+	if (rt)
+		xfs_mod_incore_sb(mp, XFS_SBS_FREXTENTS, extsz, 0);
+	else
+		xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS, alen, 0);
+out_unreserve_quota:
+	if (XFS_IS_QUOTA_ON(mp))
+		xfs_trans_unreserve_quota_nblks(NULL, ip, alen, 0, rt ?
+				XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
+	return error;
+}
+
 /*
  * Map file blocks to filesystem blocks.
  * File range is given by the bno/len pair.
@@ -4479,7 +4593,6 @@ xfs_bmapi(
 	int		error;		/* error return */
 	xfs_bmbt_irec_t	got;		/* current file extent record */
 	xfs_ifork_t	*ifp;		/* inode fork pointer */
-	xfs_extlen_t	indlen;		/* indirect blocks length */
 	xfs_extnum_t	lastx;		/* last useful extent number */
 	int		logflags;	/* flags for transaction logging */
 	xfs_extlen_t	minleft;	/* min blocks left after allocation */
@@ -4615,43 +4728,8 @@ xfs_bmapi(
 			}
 			minlen = (flags & XFS_BMAPI_CONTIG) ? alen : 1;
 			if (flags & XFS_BMAPI_DELAY) {
-				xfs_extlen_t	extsz;
-
-				/* Figure out the extent size, adjust alen */
-				extsz = xfs_get_extsz_hint(ip);
-				if (extsz) {
-					/*
-					 * make sure we don't exceed a single
-					 * extent length when we align the
-					 * extent by reducing length we are
-					 * going to allocate by the maximum
-					 * amount extent size aligment may
-					 * require.
-					 */
-					alen = XFS_FILBLKS_MIN(len,
-						   MAXEXTLEN - (2 * extsz - 1));
-					error = xfs_bmap_extsize_align(mp,
-							&got, &prev, extsz,
-							rt, eof,
-							flags&XFS_BMAPI_DELAY,
-							flags&XFS_BMAPI_CONVERT,
-							&aoff, &alen);
-					ASSERT(!error);
-				}
-
-				if (rt)
-					extsz = alen / mp->m_sb.sb_rextsize;
-
-				/*
-				 * Make a transaction-less quota reservation for
-				 * delayed allocation blocks. This number gets
-				 * adjusted later.  We return if we haven't
-				 * allocated blocks already inside this loop.
-				 */
-				error = xfs_trans_reserve_quota_nblks(
-						NULL, ip, (long)alen, 0,
-						rt ? XFS_QMOPT_RES_RTBLKS :
-						     XFS_QMOPT_RES_REGBLKS);
+				error = xfs_bmapi_reserve_delalloc(ip, bno, len, &got,
+								   &prev, &lastx, eof);
 				if (error) {
 					if (n == 0) {
 						*nmap = 0;
@@ -4661,51 +4739,7 @@ xfs_bmapi(
 					break;
 				}
 
-				/*
-				 * Split changing sb for alen and indlen since
-				 * they could be coming from different places.
-				 */
-				indlen = (xfs_extlen_t)
-					xfs_bmap_worst_indlen(ip, alen);
-				ASSERT(indlen > 0);
-
-				if (rt) {
-					error = xfs_mod_incore_sb(mp,
-							XFS_SBS_FREXTENTS,
-							-((int64_t)extsz), 0);
-				} else {
-					error = xfs_icsb_modify_counters(mp,
-							XFS_SBS_FDBLOCKS,
-							-((int64_t)alen), 0);
-				}
-				if (!error) {
-					error = xfs_icsb_modify_counters(mp,
-							XFS_SBS_FDBLOCKS,
-							-((int64_t)indlen), 0);
-					if (error && rt)
-						xfs_mod_incore_sb(mp,
-							XFS_SBS_FREXTENTS,
-							(int64_t)extsz, 0);
-					else if (error)
-						xfs_icsb_modify_counters(mp,
-							XFS_SBS_FDBLOCKS,
-							(int64_t)alen, 0);
-				}
-
-				if (error) {
-					if (XFS_IS_QUOTA_ON(mp))
-						/* unreserve the blocks now */
-						(void)
-						xfs_trans_unreserve_quota_nblks(
-							NULL, ip,
-							(long)alen, 0, rt ?
-							XFS_QMOPT_RES_RTBLKS :
-							XFS_QMOPT_RES_REGBLKS);
-					break;
-				}
-
-				ip->i_delayed_blks += alen;
-				abno = nullstartblock(indlen);
+				goto trim_extent;
 			} else {
 				/*
 				 * If first time, allocate and fill in
@@ -4843,7 +4877,7 @@ xfs_bmapi(
 			n++;
 			continue;
 		}
-
+trim_extent:
 		/* Deal with the allocated space we found.  */
 		xfs_bmapi_trim_map(mval, &got, &bno, len, obno, end, n, flags);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
