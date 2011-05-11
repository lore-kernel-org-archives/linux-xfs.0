Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4BF7Fdr128125 for <xfs@oss.sgi.com>; Wed, 11 May 2011 10:07:16 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85868445778
	for <xfs@oss.sgi.com>; Wed, 11 May 2011 08:07:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id m58tvoebVUYfZAE2 for
	<xfs@oss.sgi.com>; Wed, 11 May 2011 08:07:15 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QKB0K-0005ew-1c
	for xfs@oss.sgi.com; Wed, 11 May 2011 15:07:12 +0000
Message-Id: <20110511150711.989383617@bombadil.infradead.org>
Date: Wed, 11 May 2011 11:04:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/9] xfs: do not use unchecked extent indices in
	xfs_bmap_add_extent_*
References: <20110511150402.258164661@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-ep-access-1
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

Make sure to only call xfs_iext_get_ext after we've validate the extent index
in the various xfs_bmap_add_extent_* helpers.

Based on an earlier patch from Lachlan McIlroy.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-05-10 13:57:12.297088697 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-05-10 14:00:16.405087271 +0200
@@ -1629,7 +1629,6 @@ xfs_bmap_add_extent_hole_delay(
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	int			*logflagsp) /* inode logging flags */
 {
-	xfs_bmbt_rec_host_t	*ep;	/* extent record for idx */
 	xfs_ifork_t		*ifp;	/* inode fork pointer */
 	xfs_bmbt_irec_t		left;	/* left neighbor extent entry */
 	xfs_filblks_t		newlen=0;	/* new indirect size */
@@ -1639,7 +1638,6 @@ xfs_bmap_add_extent_hole_delay(
 	xfs_filblks_t		temp=0;	/* temp for indirect calculations */
 
 	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-	ep = xfs_iext_get_ext(ifp, *idx);
 	state = 0;
 	ASSERT(isnullstartblock(new->br_startblock));
 
@@ -1660,7 +1658,7 @@ xfs_bmap_add_extent_hole_delay(
 	 */
 	if (*idx < ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
 		state |= BMAP_RIGHT_VALID;
-		xfs_bmbt_get_all(ep, &right);
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx), &right);
 
 		if (isnullstartblock(right.br_startblock))
 			state |= BMAP_RIGHT_DELAY;
@@ -1740,7 +1738,8 @@ xfs_bmap_add_extent_hole_delay(
 		oldlen = startblockval(new->br_startblock) +
 			startblockval(right.br_startblock);
 		newlen = xfs_bmap_worst_indlen(ip, temp);
-		xfs_bmbt_set_allf(ep, new->br_startoff,
+		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, *idx),
+			new->br_startoff,
 			nullstartblock((int)newlen), temp, right.br_state);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 		break;
@@ -1780,7 +1779,6 @@ xfs_bmap_add_extent_hole_real(
 	int			*logflagsp, /* inode logging flags */
 	int			whichfork) /* data or attr fork */
 {
-	xfs_bmbt_rec_host_t	*ep;	/* pointer to extent entry ins. point */
 	int			error;	/* error return value */
 	int			i;	/* temp state */
 	xfs_ifork_t		*ifp;	/* inode fork pointer */
@@ -1791,7 +1789,6 @@ xfs_bmap_add_extent_hole_real(
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(*idx <= ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t));
-	ep = xfs_iext_get_ext(ifp, *idx);
 	state = 0;
 
 	if (whichfork == XFS_ATTR_FORK)
@@ -1813,7 +1810,7 @@ xfs_bmap_add_extent_hole_real(
 	 */
 	if (*idx < ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
 		state |= BMAP_RIGHT_VALID;
-		xfs_bmbt_get_all(ep, &right);
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx), &right);
 		if (isnullstartblock(right.br_startblock))
 			state |= BMAP_RIGHT_DELAY;
 	}
@@ -1925,7 +1922,8 @@ xfs_bmap_add_extent_hole_real(
 		 * Merge the new allocation with the right neighbor.
 		 */
 		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_allf(ep, new->br_startoff, new->br_startblock,
+		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, *idx),
+			new->br_startoff, new->br_startblock,
 			new->br_blockcount + right.br_blockcount,
 			right.br_state);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
