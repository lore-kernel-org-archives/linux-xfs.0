Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5MJI5N5115551 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 14:18:05 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D1F1255B1
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 12:18:04 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	XvMwBSjhYz0Qqc2W for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2011 12:18:04 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QZSw7-00081Q-Qd
	for xfs@oss.sgi.com; Wed, 22 Jun 2011 19:18:03 +0000
Message-Id: <20110622191803.786124787@bombadil.infradead.org>
Date: Wed, 22 Jun 2011 15:17:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/6] xfs: remove i_transp
References: <20110622191745.364749314@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-i_transp
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

Remove the transaction pointer in the inode.  It's only used to avoid
passing down an argument in the bmap code, and for a few asserts in
the transaction code right now.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_trans_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_trans_dquot.c	2011-04-02 22:30:58.000000000 +0200
+++ xfs/fs/xfs/quota/xfs_trans_dquot.c	2011-06-22 08:53:30.508174678 +0200
@@ -59,7 +59,7 @@ xfs_trans_dqjoin(
 	xfs_trans_add_item(tp, &dqp->q_logitem.qli_item);
 
 	/*
-	 * Initialize i_transp so we can later determine if this dquot is
+	 * Initialize d_transp so we can later determine if this dquot is
 	 * associated with this transaction.
 	 */
 	dqp->q_transp = tp;
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-06-21 16:43:03.000000000 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-06-22 08:55:57.554833900 +0200
@@ -94,6 +94,7 @@ xfs_bmap_add_attrfork_local(
  */
 STATIC int				/* error */
 xfs_bmap_add_extent_delay_real(
+	struct xfs_trans	*tp,	/* transaction pointer */
 	xfs_inode_t		*ip,	/* incore inode pointer */
 	xfs_extnum_t		*idx,	/* extent number to update/insert */
 	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
@@ -439,6 +440,7 @@ xfs_bmap_add_attrfork_local(
  */
 STATIC int				/* error */
 xfs_bmap_add_extent(
+	struct xfs_trans	*tp,	/* transaction pointer */
 	xfs_inode_t		*ip,	/* incore inode pointer */
 	xfs_extnum_t		*idx,	/* extent number to update/insert */
 	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
@@ -524,7 +526,7 @@ xfs_bmap_add_extent(
 				if (cur)
 					ASSERT(cur->bc_private.b.flags &
 						XFS_BTCUR_BPRV_WASDEL);
-				error = xfs_bmap_add_extent_delay_real(ip,
+				error = xfs_bmap_add_extent_delay_real(tp, ip,
 						idx, &cur, new, &da_new,
 						first, flist, &logflags);
 			} else {
@@ -561,7 +563,7 @@ xfs_bmap_add_extent(
 		int	tmp_logflags;	/* partial log flag return val */
 
 		ASSERT(cur == NULL);
-		error = xfs_bmap_extents_to_btree(ip->i_transp, ip, first,
+		error = xfs_bmap_extents_to_btree(tp, ip, first,
 			flist, &cur, da_old > 0, &tmp_logflags, whichfork);
 		logflags |= tmp_logflags;
 		if (error)
@@ -604,6 +606,7 @@ done:
  */
 STATIC int				/* error */
 xfs_bmap_add_extent_delay_real(
+	struct xfs_trans	*tp,	/* transaction pointer */
 	xfs_inode_t		*ip,	/* incore inode pointer */
 	xfs_extnum_t		*idx,	/* extent number to update/insert */
 	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
@@ -901,7 +904,7 @@ xfs_bmap_add_extent_delay_real(
 		}
 		if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
 		    ip->i_d.di_nextents > ip->i_df.if_ext_max) {
-			error = xfs_bmap_extents_to_btree(ip->i_transp, ip,
+			error = xfs_bmap_extents_to_btree(tp, ip,
 					first, flist, &cur, 1, &tmp_rval,
 					XFS_DATA_FORK);
 			rval |= tmp_rval;
@@ -984,7 +987,7 @@ xfs_bmap_add_extent_delay_real(
 		}
 		if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
 		    ip->i_d.di_nextents > ip->i_df.if_ext_max) {
-			error = xfs_bmap_extents_to_btree(ip->i_transp, ip,
+			error = xfs_bmap_extents_to_btree(tp, ip,
 				first, flist, &cur, 1, &tmp_rval,
 				XFS_DATA_FORK);
 			rval |= tmp_rval;
@@ -1052,7 +1055,7 @@ xfs_bmap_add_extent_delay_real(
 		}
 		if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
 		    ip->i_d.di_nextents > ip->i_df.if_ext_max) {
-			error = xfs_bmap_extents_to_btree(ip->i_transp, ip,
+			error = xfs_bmap_extents_to_btree(tp, ip,
 					first, flist, &cur, 1, &tmp_rval,
 					XFS_DATA_FORK);
 			rval |= tmp_rval;
@@ -2871,8 +2874,8 @@ xfs_bmap_del_extent(
 			len = del->br_blockcount;
 			do_div(bno, mp->m_sb.sb_rextsize);
 			do_div(len, mp->m_sb.sb_rextsize);
-			if ((error = xfs_rtfree_extent(ip->i_transp, bno,
-					(xfs_extlen_t)len)))
+			error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
+			if (error)
 				goto done;
 			do_fx = 0;
 			nblks = len * mp->m_sb.sb_rextsize;
@@ -4662,7 +4665,7 @@ xfs_bmapi(
 				if (!wasdelay && (flags & XFS_BMAPI_PREALLOC))
 					got.br_state = XFS_EXT_UNWRITTEN;
 			}
-			error = xfs_bmap_add_extent(ip, &lastx, &cur, &got,
+			error = xfs_bmap_add_extent(tp, ip, &lastx, &cur, &got,
 				firstblock, flist, &tmp_logflags,
 				whichfork);
 			logflags |= tmp_logflags;
@@ -4763,7 +4766,7 @@ xfs_bmapi(
 			mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
 						? XFS_EXT_NORM
 						: XFS_EXT_UNWRITTEN;
-			error = xfs_bmap_add_extent(ip, &lastx, &cur, mval,
+			error = xfs_bmap_add_extent(tp, ip, &lastx, &cur, mval,
 				firstblock, flist, &tmp_logflags,
 				whichfork);
 			logflags |= tmp_logflags;
@@ -5117,7 +5120,7 @@ xfs_bunmapi(
 				del.br_blockcount = mod;
 			}
 			del.br_state = XFS_EXT_UNWRITTEN;
-			error = xfs_bmap_add_extent(ip, &lastx, &cur, &del,
+			error = xfs_bmap_add_extent(tp, ip, &lastx, &cur, &del,
 				firstblock, flist, &logflags,
 				XFS_DATA_FORK);
 			if (error)
@@ -5175,18 +5178,18 @@ xfs_bunmapi(
 				}
 				prev.br_state = XFS_EXT_UNWRITTEN;
 				lastx--;
-				error = xfs_bmap_add_extent(ip, &lastx, &cur,
-					&prev, firstblock, flist, &logflags,
-					XFS_DATA_FORK);
+				error = xfs_bmap_add_extent(tp, ip, &lastx,
+						&cur, &prev, firstblock, flist,
+						&logflags, XFS_DATA_FORK);
 				if (error)
 					goto error0;
 				goto nodelete;
 			} else {
 				ASSERT(del.br_state == XFS_EXT_NORM);
 				del.br_state = XFS_EXT_UNWRITTEN;
-				error = xfs_bmap_add_extent(ip, &lastx, &cur,
-					&del, firstblock, flist, &logflags,
-					XFS_DATA_FORK);
+				error = xfs_bmap_add_extent(tp, ip, &lastx,
+						&cur, &del, firstblock, flist,
+						&logflags, XFS_DATA_FORK);
 				if (error)
 					goto error0;
 				goto nodelete;
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-06-21 16:43:37.000000000 +0200
+++ xfs/fs/xfs/xfs_inode.c	2011-06-22 08:53:30.521508012 +0200
@@ -1284,7 +1284,6 @@ xfs_itruncate_finish(
 	ASSERT((new_size == 0) || (new_size <= ip->i_size));
 	ASSERT(*tp != NULL);
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
-	ASSERT(ip->i_transp == *tp);
 	ASSERT(ip->i_itemp != NULL);
 	ASSERT(ip->i_itemp->ili_lock_flags == 0);
 
@@ -1537,7 +1536,6 @@ xfs_iunlink(
 
 	ASSERT(ip->i_d.di_nlink == 0);
 	ASSERT(ip->i_d.di_mode != 0);
-	ASSERT(ip->i_transp == tp);
 
 	mp = tp->t_mountp;
 
@@ -1929,7 +1927,6 @@ xfs_ifree(
 	xfs_buf_t       	*ibp;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(ip->i_transp == tp);
 	ASSERT(ip->i_d.di_nlink == 0);
 	ASSERT(ip->i_d.di_nextents == 0);
 	ASSERT(ip->i_d.di_anextents == 0);
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2011-06-21 16:43:37.000000000 +0200
+++ xfs/fs/xfs/xfs_inode.h	2011-06-22 08:53:30.521508012 +0200
@@ -241,7 +241,6 @@ typedef struct xfs_inode {
 	xfs_ifork_t		i_df;		/* data fork */
 
 	/* Transaction and locking information. */
-	struct xfs_trans	*i_transp;	/* ptr to owning transaction*/
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
 	mrlock_t		i_lock;		/* inode lock */
 	mrlock_t		i_iolock;	/* inode IO lock */
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2011-05-27 13:07:40.645495673 +0200
+++ xfs/fs/xfs/xfs_inode_item.c	2011-06-22 08:53:30.521508012 +0200
@@ -636,11 +636,6 @@ xfs_inode_item_unlock(
 	ASSERT(xfs_isilocked(iip->ili_inode, XFS_ILOCK_EXCL));
 
 	/*
-	 * Clear the transaction pointer in the inode.
-	 */
-	ip->i_transp = NULL;
-
-	/*
 	 * If the inode needed a separate buffer with which to log
 	 * its extents, then free it now.
 	 */
Index: xfs/fs/xfs/xfs_trans_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_inode.c	2011-04-22 06:21:45.623182391 +0200
+++ xfs/fs/xfs/xfs_trans_inode.c	2011-06-22 08:53:30.524841345 +0200
@@ -55,7 +55,6 @@ xfs_trans_ijoin(
 {
 	xfs_inode_log_item_t	*iip;
 
-	ASSERT(ip->i_transp == NULL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	if (ip->i_itemp == NULL)
 		xfs_inode_item_init(ip, ip->i_mount);
@@ -68,12 +67,6 @@ xfs_trans_ijoin(
 	xfs_trans_add_item(tp, &iip->ili_item);
 
 	xfs_trans_inode_broot_debug(ip);
-
-	/*
-	 * Initialize i_transp so we can find it with xfs_inode_incore()
-	 * in xfs_trans_iget() above.
-	 */
-	ip->i_transp = tp;
 }
 
 /*
@@ -111,7 +104,6 @@ xfs_trans_ichgtime(
 
 	ASSERT(tp);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(ip->i_transp == tp);
 
 	tv = current_fs_time(inode->i_sb);
 
@@ -140,7 +132,6 @@ xfs_trans_log_inode(
 	xfs_inode_t	*ip,
 	uint		flags)
 {
-	ASSERT(ip->i_transp == tp);
 	ASSERT(ip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
