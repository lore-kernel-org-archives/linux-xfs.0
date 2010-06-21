Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L8XRLB113437 for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 03:33:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9491A267830
	for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:36:07 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 8loPYz0AVVFyE1ft for
	<xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:36:07 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OQcUB-0007Zi-7y
	for xfs@oss.sgi.com; Mon, 21 Jun 2010 08:36:07 +0000
Message-Id: <20100621083607.163131230@bombadil.infradead.org>
Date: Mon, 21 Jun 2010 04:35:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/12] xfs: reduce stack usage in xfs_iomap
References: <20100621083543.125860679@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-iomap-more-stack-reduction
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

xfs_iomap passes a xfs_bmbt_irec pointer to xfs_iomap_write_direct and
xfs_iomap_write_allocate to give them the results of our read-only
xfs_bmapi query.  Instead of allocating a new xfs_bmbt_irec on stack
for the next call to xfs_bmapi re use the one we got passed as it's not
used after this point.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2010-06-18 09:58:41.210004416 +0200
+++ xfs/fs/xfs/xfs_iomap.c	2010-06-19 14:38:03.535254031 +0200
@@ -242,7 +242,7 @@ xfs_iomap_write_direct(
 	xfs_off_t	offset,
 	size_t		count,
 	int		flags,
-	xfs_bmbt_irec_t *ret_imap,
+	xfs_bmbt_irec_t *imap,
 	int		*nmaps)
 {
 	xfs_mount_t	*mp = ip->i_mount;
@@ -256,7 +256,6 @@ xfs_iomap_write_direct(
 	int		quota_flag;
 	int		rt;
 	xfs_trans_t	*tp;
-	xfs_bmbt_irec_t imap;
 	xfs_bmap_free_t free_list;
 	uint		qblocks, resblks, resrtextents;
 	int		committed;
@@ -280,10 +279,10 @@ xfs_iomap_write_direct(
 		if (error)
 			goto error_out;
 	} else {
-		if (*nmaps && (ret_imap->br_startblock == HOLESTARTBLOCK))
+		if (*nmaps && (imap->br_startblock == HOLESTARTBLOCK))
 			last_fsb = MIN(last_fsb, (xfs_fileoff_t)
-					ret_imap->br_blockcount +
-					ret_imap->br_startoff);
+					imap->br_blockcount +
+					imap->br_startoff);
 	}
 	count_fsb = last_fsb - offset_fsb;
 	ASSERT(count_fsb > 0);
@@ -336,12 +335,15 @@ xfs_iomap_write_direct(
 		bmapi_flag |= XFS_BMAPI_PREALLOC;
 
 	/*
-	 * Issue the xfs_bmapi() call to allocate the blocks
+	 * Issue the xfs_bmapi() call to allocate the blocks.
+	 *
+	 * From this point onwards we overwrite the imap pointer that the
+	 * caller gave to us.
 	 */
 	xfs_bmap_init(&free_list, &firstfsb);
 	nimaps = 1;
 	error = xfs_bmapi(tp, ip, offset_fsb, count_fsb, bmapi_flag,
-		&firstfsb, 0, &imap, &nimaps, &free_list);
+		&firstfsb, 0, imap, &nimaps, &free_list);
 	if (error)
 		goto error0;
 
@@ -363,12 +365,11 @@ xfs_iomap_write_direct(
 		goto error_out;
 	}
 
-	if (!(imap.br_startblock || XFS_IS_REALTIME_INODE(ip))) {
-		error = xfs_cmn_err_fsblock_zero(ip, &imap);
+	if (!(imap->br_startblock || XFS_IS_REALTIME_INODE(ip))) {
+		error = xfs_cmn_err_fsblock_zero(ip, imap);
 		goto error_out;
 	}
 
-	*ret_imap = imap;
 	*nmaps = 1;
 	return 0;
 
@@ -542,7 +543,7 @@ xfs_iomap_write_allocate(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
 	size_t		count,
-	xfs_bmbt_irec_t *map,
+	xfs_bmbt_irec_t *imap,
 	int		*retmap)
 {
 	xfs_mount_t	*mp = ip->i_mount;
@@ -551,7 +552,6 @@ xfs_iomap_write_allocate(
 	xfs_fsblock_t	first_block;
 	xfs_bmap_free_t	free_list;
 	xfs_filblks_t	count_fsb;
-	xfs_bmbt_irec_t	imap;
 	xfs_trans_t	*tp;
 	int		nimaps, committed;
 	int		error = 0;
@@ -567,8 +567,8 @@ xfs_iomap_write_allocate(
 		return XFS_ERROR(error);
 
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	count_fsb = map->br_blockcount;
-	map_start_fsb = map->br_startoff;
+	count_fsb = imap->br_blockcount;
+	map_start_fsb = imap->br_startoff;
 
 	XFS_STATS_ADD(xs_xstrat_bytes, XFS_FSB_TO_B(mp, count_fsb));
 
@@ -647,10 +647,15 @@ xfs_iomap_write_allocate(
 				}
 			}
 
-			/* Go get the actual blocks */
+			/*
+			 * Go get the actual blocks.
+	 	 	 *
+			 * From this point onwards we overwrite the imap
+			 * pointer that the caller gave to us.
+			 */
 			error = xfs_bmapi(tp, ip, map_start_fsb, count_fsb,
 					XFS_BMAPI_WRITE, &first_block, 1,
-					&imap, &nimaps, &free_list);
+					imap, &nimaps, &free_list);
 			if (error)
 				goto trans_cancel;
 
@@ -669,13 +674,12 @@ xfs_iomap_write_allocate(
 		 * See if we were able to allocate an extent that
 		 * covers at least part of the callers request
 		 */
-		if (!(imap.br_startblock || XFS_IS_REALTIME_INODE(ip)))
-			return xfs_cmn_err_fsblock_zero(ip, &imap);
+		if (!(imap->br_startblock || XFS_IS_REALTIME_INODE(ip)))
+			return xfs_cmn_err_fsblock_zero(ip, imap);
 
-		if ((offset_fsb >= imap.br_startoff) &&
-		    (offset_fsb < (imap.br_startoff +
-				   imap.br_blockcount))) {
-			*map = imap;
+		if ((offset_fsb >= imap->br_startoff) &&
+		    (offset_fsb < (imap->br_startoff +
+				   imap->br_blockcount))) {
 			*retmap = 1;
 			XFS_STATS_INC(xs_xstrat_quick);
 			return 0;
@@ -685,8 +689,8 @@ xfs_iomap_write_allocate(
 		 * So far we have not mapped the requested part of the
 		 * file, just surrounding data, try again.
 		 */
-		count_fsb -= imap.br_blockcount;
-		map_start_fsb = imap.br_startoff + imap.br_blockcount;
+		count_fsb -= imap->br_blockcount;
+		map_start_fsb = imap->br_startoff + imap->br_blockcount;
 	}
 
 trans_cancel:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
