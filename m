Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAONxuHD179280 for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 17:59:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 98D6312D2CB1
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 16:00:22 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 7fMyf1633snyJZQE for
	<xfs@oss.sgi.com>; Tue, 24 Nov 2009 16:00:22 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1ND5J0-00078g-07
	for xfs@oss.sgi.com; Wed, 25 Nov 2009 00:00:22 +0000
Date: Tue, 24 Nov 2009 19:00:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] xfs: change the xfs_iext_insert / xfs_iext_remove
Message-ID: <20091125000021.GB25432@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Change the xfs_iext_insert / xfs_iext_remove prototypes to pass more
information which will allow pushing the trace points from the callers
into those functions.  This includes folding the whichfork information
into the state variable to minimize the addition stack footprint.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_bmap.c	2009-11-22 15:51:48.909278905 +0100
+++ linux-2.6/fs/xfs/xfs_bmap.c	2009-11-22 15:57:44.358255697 +0100
@@ -592,7 +592,9 @@ xfs_bmap_add_extent(
 	if (nextents == 0) {
 		XFS_BMAP_TRACE_INSERT("insert empty", ip, 0, 1, new, NULL,
 			whichfork);
-		xfs_iext_insert(ifp, 0, 1, new);
+		xfs_iext_insert(ip, 0, 1, new,
+				whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0);
+
 		ASSERT(cur == NULL);
 		ifp->if_lastex = 0;
 		if (!isnullstartblock(new->br_startblock)) {
@@ -849,7 +851,7 @@ xfs_bmap_add_extent_delay_real(
 		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|LC|RC", ip, idx - 1,
 			XFS_DATA_FORK);
 		XFS_BMAP_TRACE_DELETE("LF|RF|LC|RC", ip, idx, 2, XFS_DATA_FORK);
-		xfs_iext_remove(ifp, idx, 2);
+		xfs_iext_remove(ip, idx, 2, state);
 		ip->i_df.if_lastex = idx - 1;
 		ip->i_d.di_nextents--;
 		if (cur == NULL)
@@ -895,7 +897,7 @@ xfs_bmap_add_extent_delay_real(
 			XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx - 1;
 		XFS_BMAP_TRACE_DELETE("LF|RF|LC", ip, idx, 1, XFS_DATA_FORK);
-		xfs_iext_remove(ifp, idx, 1);
+		xfs_iext_remove(ip, idx, 1, state);
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
 		else {
@@ -930,7 +932,7 @@ xfs_bmap_add_extent_delay_real(
 		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|RC", ip, idx, XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx;
 		XFS_BMAP_TRACE_DELETE("LF|RF|RC", ip, idx + 1, 1, XFS_DATA_FORK);
-		xfs_iext_remove(ifp, idx + 1, 1);
+		xfs_iext_remove(ip, idx + 1, 1, state);
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
 		else {
@@ -1037,7 +1039,7 @@ xfs_bmap_add_extent_delay_real(
 		xfs_bmbt_set_blockcount(ep, temp);
 		XFS_BMAP_TRACE_INSERT("LF", ip, idx, 1, new, NULL,
 			XFS_DATA_FORK);
-		xfs_iext_insert(ifp, idx, 1, new);
+		xfs_iext_insert(ip, idx, 1, new, state);
 		ip->i_df.if_lastex = idx;
 		ip->i_d.di_nextents++;
 		if (cur == NULL)
@@ -1127,7 +1129,7 @@ xfs_bmap_add_extent_delay_real(
 		xfs_bmbt_set_blockcount(ep, temp);
 		XFS_BMAP_TRACE_INSERT("RF", ip, idx + 1, 1, new, NULL,
 			XFS_DATA_FORK);
-		xfs_iext_insert(ifp, idx + 1, 1, new);
+		xfs_iext_insert(ip, idx + 1, 1, new, state);
 		ip->i_df.if_lastex = idx + 1;
 		ip->i_d.di_nextents++;
 		if (cur == NULL)
@@ -1182,7 +1184,7 @@ xfs_bmap_add_extent_delay_real(
 		r[1].br_blockcount = temp2;
 		XFS_BMAP_TRACE_INSERT("0", ip, idx + 1, 2, &r[0], &r[1],
 			XFS_DATA_FORK);
-		xfs_iext_insert(ifp, idx + 1, 2, &r[0]);
+		xfs_iext_insert(ip, idx + 1, 2, &r[0], state);
 		ip->i_df.if_lastex = idx + 1;
 		ip->i_d.di_nextents++;
 		if (cur == NULL)
@@ -1397,7 +1399,7 @@ xfs_bmap_add_extent_unwritten_real(
 		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|LC|RC", ip, idx - 1,
 			XFS_DATA_FORK);
 		XFS_BMAP_TRACE_DELETE("LF|RF|LC|RC", ip, idx, 2, XFS_DATA_FORK);
-		xfs_iext_remove(ifp, idx, 2);
+		xfs_iext_remove(ip, idx, 2, state);
 		ip->i_df.if_lastex = idx - 1;
 		ip->i_d.di_nextents -= 2;
 		if (cur == NULL)
@@ -1447,7 +1449,7 @@ xfs_bmap_add_extent_unwritten_real(
 			XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx - 1;
 		XFS_BMAP_TRACE_DELETE("LF|RF|LC", ip, idx, 1, XFS_DATA_FORK);
-		xfs_iext_remove(ifp, idx, 1);
+		xfs_iext_remove(ip, idx, 1, state);
 		ip->i_d.di_nextents--;
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -1490,7 +1492,7 @@ xfs_bmap_add_extent_unwritten_real(
 			XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx;
 		XFS_BMAP_TRACE_DELETE("LF|RF|RC", ip, idx + 1, 1, XFS_DATA_FORK);
-		xfs_iext_remove(ifp, idx + 1, 1);
+		xfs_iext_remove(ip, idx + 1, 1, state);
 		ip->i_d.di_nextents--;
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -1616,7 +1618,7 @@ xfs_bmap_add_extent_unwritten_real(
 		XFS_BMAP_TRACE_POST_UPDATE("LF", ip, idx, XFS_DATA_FORK);
 		XFS_BMAP_TRACE_INSERT("LF", ip, idx, 1, new, NULL,
 			XFS_DATA_FORK);
-		xfs_iext_insert(ifp, idx, 1, new);
+		xfs_iext_insert(ip, idx, 1, new, state);
 		ip->i_df.if_lastex = idx;
 		ip->i_d.di_nextents++;
 		if (cur == NULL)
@@ -1702,7 +1704,7 @@ xfs_bmap_add_extent_unwritten_real(
 		XFS_BMAP_TRACE_POST_UPDATE("RF", ip, idx, XFS_DATA_FORK);
 		XFS_BMAP_TRACE_INSERT("RF", ip, idx + 1, 1, new, NULL,
 			XFS_DATA_FORK);
-		xfs_iext_insert(ifp, idx + 1, 1, new);
+		xfs_iext_insert(ip, idx + 1, 1, new, state);
 		ip->i_df.if_lastex = idx + 1;
 		ip->i_d.di_nextents++;
 		if (cur == NULL)
@@ -1752,7 +1754,7 @@ xfs_bmap_add_extent_unwritten_real(
 		r[1].br_state = oldext;
 		XFS_BMAP_TRACE_INSERT("0", ip, idx + 1, 2, &r[0], &r[1],
 			XFS_DATA_FORK);
-		xfs_iext_insert(ifp, idx + 1, 2, &r[0]);
+		xfs_iext_insert(ip, idx + 1, 2, &r[0], state);
 		ip->i_df.if_lastex = idx + 1;
 		ip->i_d.di_nextents += 2;
 		if (cur == NULL)
@@ -1918,7 +1920,7 @@ xfs_bmap_add_extent_hole_delay(
 		XFS_BMAP_TRACE_POST_UPDATE("LC|RC", ip, idx - 1,
 			XFS_DATA_FORK);
 		XFS_BMAP_TRACE_DELETE("LC|RC", ip, idx, 1, XFS_DATA_FORK);
-		xfs_iext_remove(ifp, idx, 1);
+		xfs_iext_remove(ip, idx, 1, state);
 		ip->i_df.if_lastex = idx - 1;
 		/* DELTA: Two in-core extents were replaced by one. */
 		temp2 = temp;
@@ -1977,7 +1979,7 @@ xfs_bmap_add_extent_hole_delay(
 		oldlen = newlen = 0;
 		XFS_BMAP_TRACE_INSERT("0", ip, idx, 1, new, NULL,
 			XFS_DATA_FORK);
-		xfs_iext_insert(ifp, idx, 1, new);
+		xfs_iext_insert(ip, idx, 1, new, state);
 		ip->i_df.if_lastex = idx;
 		/* DELTA: A new in-core extent was added in a hole. */
 		temp2 = new->br_blockcount;
@@ -2033,6 +2035,9 @@ xfs_bmap_add_extent_hole_real(
 	ep = xfs_iext_get_ext(ifp, idx);
 	state = 0;
 
+	if (whichfork == XFS_ATTR_FORK)
+		state |= BMAP_ATTRFORK;
+
 	/*
 	 * Check and set flags if this segment has a left neighbor.
 	 */
@@ -2094,7 +2099,7 @@ xfs_bmap_add_extent_hole_real(
 		XFS_BMAP_TRACE_POST_UPDATE("LC|RC", ip, idx - 1,
 			whichfork);
 		XFS_BMAP_TRACE_DELETE("LC|RC", ip, idx, 1, whichfork);
-		xfs_iext_remove(ifp, idx, 1);
+		xfs_iext_remove(ip, idx, 1, state);
 		ifp->if_lastex = idx - 1;
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
@@ -2205,7 +2210,7 @@ xfs_bmap_add_extent_hole_real(
 		 * Insert a new entry.
 		 */
 		XFS_BMAP_TRACE_INSERT("0", ip, idx, 1, new, NULL, whichfork);
-		xfs_iext_insert(ifp, idx, 1, new);
+		xfs_iext_insert(ip, idx, 1, new, state);
 		ifp->if_lastex = idx;
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 			XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
@@ -3147,7 +3152,8 @@ xfs_bmap_del_extent(
 		 * Matches the whole extent.  Delete the entry.
 		 */
 		XFS_BMAP_TRACE_DELETE("3", ip, idx, 1, whichfork);
-		xfs_iext_remove(ifp, idx, 1);
+		xfs_iext_remove(ip, idx, 1,
+				whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0);
 		ifp->if_lastex = idx;
 		if (delay)
 			break;
@@ -3317,7 +3323,8 @@ xfs_bmap_del_extent(
 		XFS_BMAP_TRACE_POST_UPDATE("0", ip, idx, whichfork);
 		XFS_BMAP_TRACE_INSERT("0", ip, idx + 1, 1, &new, NULL,
 			whichfork);
-		xfs_iext_insert(ifp, idx + 1, 1, &new);
+		xfs_iext_insert(ip, idx + 1, 1, &new,
+				whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0);
 		ifp->if_lastex = idx + 1;
 		break;
 	}
Index: linux-2.6/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.c	2009-11-22 15:51:48.914278285 +0100
+++ linux-2.6/fs/xfs/xfs_inode.c	2009-11-22 15:59:32.268005938 +0100
@@ -3300,11 +3300,13 @@ xfs_iext_get_ext(
  */
 void
 xfs_iext_insert(
-	xfs_ifork_t	*ifp,		/* inode fork pointer */
+	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_extnum_t	idx,		/* starting index of new items */
 	xfs_extnum_t	count,		/* number of inserted items */
-	xfs_bmbt_irec_t	*new)		/* items to insert */
+	xfs_bmbt_irec_t	*new,		/* items to insert */
+	int		state)		/* type of extent conversion */
 {
+	xfs_ifork_t	*ifp = (state & BMAP_ATTRFORK) ? ip->i_afp : &ip->i_df;
 	xfs_extnum_t	i;		/* extent record index */
 
 	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
@@ -3549,10 +3551,12 @@ xfs_iext_add_indirect_multi(
  */
 void
 xfs_iext_remove(
-	xfs_ifork_t	*ifp,		/* inode fork pointer */
+	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_extnum_t	idx,		/* index to begin removing exts */
-	int		ext_diff)	/* number of extents to remove */
+	int		ext_diff,	/* number of extents to remove */
+	int		state)		/* type of extent conversion */
 {
+	xfs_ifork_t	*ifp = (state & BMAP_ATTRFORK) ? ip->i_afp : &ip->i_df;
 	xfs_extnum_t	nextents;	/* number of extents in file */
 	int		new_size;	/* size of extents after removal */
 
Index: linux-2.6/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.h	2009-11-22 15:51:48.921276942 +0100
+++ linux-2.6/fs/xfs/xfs_inode.h	2009-11-22 15:57:45.993323026 +0100
@@ -577,11 +577,11 @@ int		xfs_iread_extents(struct xfs_trans 
 int		xfs_iextents_copy(struct xfs_inode *, xfs_bmbt_rec_t *, int);
 
 xfs_bmbt_rec_host_t *xfs_iext_get_ext(xfs_ifork_t *, xfs_extnum_t);
-void		xfs_iext_insert(xfs_ifork_t *, xfs_extnum_t, xfs_extnum_t,
-				xfs_bmbt_irec_t *);
+void		xfs_iext_insert(xfs_inode_t *, xfs_extnum_t, xfs_extnum_t,
+				xfs_bmbt_irec_t *, int);
 void		xfs_iext_add(xfs_ifork_t *, xfs_extnum_t, int);
 void		xfs_iext_add_indirect_multi(xfs_ifork_t *, int, xfs_extnum_t, int);
-void		xfs_iext_remove(xfs_ifork_t *, xfs_extnum_t, int);
+void		xfs_iext_remove(xfs_inode_t *, xfs_extnum_t, int, int);
 void		xfs_iext_remove_inline(xfs_ifork_t *, xfs_extnum_t, int);
 void		xfs_iext_remove_direct(xfs_ifork_t *, xfs_extnum_t, int);
 void		xfs_iext_remove_indirect(xfs_ifork_t *, xfs_extnum_t, int);
Index: linux-2.6/fs/xfs/xfs_bmap.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_bmap.h	2009-11-22 15:57:08.815003664 +0100
+++ linux-2.6/fs/xfs/xfs_bmap.h	2009-11-22 15:57:20.990282919 +0100
@@ -146,6 +146,7 @@ typedef struct xfs_bmalloca {
 #define BMAP_RIGHT_DELAY	(1 << 5)
 #define BMAP_LEFT_VALID		(1 << 6)
 #define BMAP_RIGHT_VALID	(1 << 7)
+#define BMAP_ATTRFORK		(1 << 8)
 
 #if defined(__KERNEL__) && defined(XFS_BMAP_TRACE)
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
