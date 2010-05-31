Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VG6axJ179002 for <xfs@oss.sgi.com>; Mon, 31 May 2010 11:06:36 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1FB6014678E4
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 09:09:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id R1sl2av0uDnJ6Ki8 for
	<xfs@oss.sgi.com>; Mon, 31 May 2010 09:09:02 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OJ7Xy-0001BE-LA
	for xfs@oss.sgi.com; Mon, 31 May 2010 16:09:02 +0000
Message-Id: <20100531160902.541889062@bombadil.infradead.org>
Date: Mon, 31 May 2010 12:07:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 17/17] xfs: remove unused delta tracking code in xfs_bmapi
References: <20100531160727.842750532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmapi-delta-cleanup
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

This code was introduced four years ago in commit
3e57ecf640428c01ba1ed8c8fc538447ada1715b without any review and has
been unused since.  Remove it just as the rest of the code introduced
in that commit to reduce that stack usage and complexity in this central
piece of code.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-05-29 18:44:44.017005812 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-05-29 18:45:03.756004695 +0200
@@ -974,7 +974,7 @@ xfs_aops_discard_page(
 		 */
 		error = xfs_bmapi(NULL, ip, offset_fsb, 1,
 				XFS_BMAPI_ENTIRE,  NULL, 0, &imap,
-				&nimaps, NULL, NULL);
+				&nimaps, NULL);
 
 		if (error) {
 			/* something screwed, just bail */
@@ -1002,7 +1002,7 @@ xfs_aops_discard_page(
 		 */
 		xfs_bmap_init(&flist, &firstblock);
 		error = xfs_bunmapi(NULL, ip, offset_fsb, 1, 0, 1, &firstblock,
-					&flist, NULL, &done);
+					&flist, &done);
 
 		ASSERT(!flist.xbf_count && !flist.xbf_first);
 		if (error) {
Index: xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2010-05-29 18:44:47.747005393 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_file.c	2010-05-29 18:45:03.757024530 +0200
@@ -414,7 +414,7 @@ xfs_zero_last_block(
 	last_fsb = XFS_B_TO_FSBT(mp, isize);
 	nimaps = 1;
 	error = xfs_bmapi(NULL, ip, last_fsb, 1, 0, NULL, 0, &imap,
-			  &nimaps, NULL, NULL);
+			  &nimaps, NULL);
 	if (error) {
 		return error;
 	}
@@ -509,7 +509,7 @@ xfs_zero_eof(
 		nimaps = 1;
 		zero_count_fsb = end_zero_fsb - start_zero_fsb + 1;
 		error = xfs_bmapi(NULL, ip, start_zero_fsb, zero_count_fsb,
-				  0, NULL, 0, &imap, &nimaps, NULL, NULL);
+				  0, NULL, 0, &imap, &nimaps, NULL);
 		if (error) {
 			ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
 			return error;
Index: xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.c	2010-05-29 18:44:47.671005673 +0200
+++ xfs/fs/xfs/quota/xfs_dquot.c	2010-05-29 18:45:03.762254380 +0200
@@ -385,7 +385,7 @@ xfs_qm_dqalloc(
 			      XFS_BMAPI_METADATA | XFS_BMAPI_WRITE,
 			      &firstblock,
 			      XFS_QM_DQALLOC_SPACE_RES(mp),
-			      &map, &nmaps, &flist, NULL))) {
+			      &map, &nmaps, &flist))) {
 		goto error0;
 	}
 	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
@@ -501,7 +501,7 @@ xfs_qm_dqtobp(
 		error = xfs_bmapi(NULL, quotip, dqp->q_fileoffset,
 				  XFS_DQUOT_CLUSTER_SIZE_FSB,
 				  XFS_BMAPI_METADATA,
-				  NULL, 0, &map, &nmaps, NULL, NULL);
+				  NULL, 0, &map, &nmaps, NULL);
 
 		xfs_iunlock(quotip, XFS_ILOCK_SHARED);
 		if (error)
Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2010-05-29 18:44:44.061032213 +0200
+++ xfs/fs/xfs/quota/xfs_qm.c	2010-05-29 18:45:03.769254450 +0200
@@ -1490,7 +1490,7 @@ xfs_qm_dqiterate(
 				  maxlblkcnt - lblkno,
 				  XFS_BMAPI_METADATA,
 				  NULL,
-				  0, map, &nmaps, NULL, NULL);
+				  0, map, &nmaps, NULL);
 		xfs_iunlock(qip, XFS_ILOCK_SHARED);
 		if (error)
 			break;
Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2010-05-29 18:44:47.702005742 +0200
+++ xfs/fs/xfs/xfs_attr.c	2010-05-29 18:45:03.775276311 +0200
@@ -1977,7 +1977,7 @@ xfs_attr_rmtval_get(xfs_da_args_t *args)
 		error = xfs_bmapi(args->trans, args->dp, (xfs_fileoff_t)lblkno,
 				  args->rmtblkcnt,
 				  XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
-				  NULL, 0, map, &nmap, NULL, NULL);
+				  NULL, 0, map, &nmap, NULL);
 		if (error)
 			return(error);
 		ASSERT(nmap >= 1);
@@ -2056,7 +2056,7 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 				  XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA |
 							XFS_BMAPI_WRITE,
 				  args->firstblock, args->total, &map, &nmap,
-				  args->flist, NULL);
+				  args->flist);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
 						&committed);
@@ -2107,7 +2107,7 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 				  args->rmtblkcnt,
 				  XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
 				  args->firstblock, 0, &map, &nmap,
-				  NULL, NULL);
+				  NULL);
 		if (error) {
 			return(error);
 		}
@@ -2172,7 +2172,7 @@ xfs_attr_rmtval_remove(xfs_da_args_t *ar
 					args->rmtblkcnt,
 					XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
 					args->firstblock, 0, &map, &nmap,
-					args->flist, NULL);
+					args->flist);
 		if (error) {
 			return(error);
 		}
@@ -2210,7 +2210,7 @@ xfs_attr_rmtval_remove(xfs_da_args_t *ar
 		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
 				    XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
 				    1, args->firstblock, args->flist,
-				    NULL, &done);
+				    &done);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
 						&committed);
Index: xfs/fs/xfs/xfs_attr_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr_leaf.c	2010-05-29 18:44:44.107255638 +0200
+++ xfs/fs/xfs/xfs_attr_leaf.c	2010-05-29 18:45:03.779011469 +0200
@@ -2928,7 +2928,7 @@ xfs_attr_leaf_freextent(xfs_trans_t **tr
 		nmap = 1;
 		error = xfs_bmapi(*trans, dp, (xfs_fileoff_t)tblkno, tblkcnt,
 					XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
-					NULL, 0, &map, &nmap, NULL, NULL);
+					NULL, 0, &map, &nmap, NULL);
 		if (error) {
 			return(error);
 		}
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2010-05-29 18:45:02.175004206 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2010-05-29 18:45:03.785016777 +0200
@@ -101,7 +101,6 @@ xfs_bmap_add_extent(
 	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
 	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
 	int			*logflagsp, /* inode logging flags */
-	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			whichfork, /* data or attr fork */
 	int			rsvd);	/* OK to allocate reserved blocks */
 
@@ -119,7 +118,6 @@ xfs_bmap_add_extent_delay_real(
 	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
 	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
 	int			*logflagsp, /* inode logging flags */
-	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			rsvd);	/* OK to allocate reserved blocks */
 
 /*
@@ -132,7 +130,6 @@ xfs_bmap_add_extent_hole_delay(
 	xfs_extnum_t		idx,	/* extent number to update/insert */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	int			*logflagsp,/* inode logging flags */
-	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			rsvd);	/* OK to allocate reserved blocks */
 
 /*
@@ -146,7 +143,6 @@ xfs_bmap_add_extent_hole_real(
 	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	int			*logflagsp, /* inode logging flags */
-	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			whichfork); /* data or attr fork */
 
 /*
@@ -159,8 +155,7 @@ xfs_bmap_add_extent_unwritten_real(
 	xfs_extnum_t		idx,	/* extent number to update/insert */
 	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
-	int			*logflagsp, /* inode logging flags */
-	xfs_extdelta_t		*delta); /* Change made to incore extents */
+	int			*logflagsp); /* inode logging flags */
 
 /*
  * xfs_bmap_alloc is called by xfs_bmapi to allocate an extent for a file.
@@ -197,7 +192,6 @@ xfs_bmap_del_extent(
 	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	int			*logflagsp,/* inode logging flags */
-	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			whichfork, /* data or attr fork */
 	int			rsvd);	 /* OK to allocate reserved blocks */
 
@@ -486,7 +480,6 @@ xfs_bmap_add_extent(
 	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
 	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
 	int			*logflagsp, /* inode logging flags */
-	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			whichfork, /* data or attr fork */
 	int			rsvd)	/* OK to use reserved data blocks */
 {
@@ -521,15 +514,6 @@ xfs_bmap_add_extent(
 			logflags = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 		} else
 			logflags = 0;
-		/* DELTA: single new extent */
-		if (delta) {
-			if (delta->xed_startoff > new->br_startoff)
-				delta->xed_startoff = new->br_startoff;
-			if (delta->xed_blockcount <
-					new->br_startoff + new->br_blockcount)
-				delta->xed_blockcount = new->br_startoff +
-						new->br_blockcount;
-		}
 	}
 	/*
 	 * Any kind of new delayed allocation goes here.
@@ -539,7 +523,7 @@ xfs_bmap_add_extent(
 			ASSERT((cur->bc_private.b.flags &
 				XFS_BTCUR_BPRV_WASDEL) == 0);
 		if ((error = xfs_bmap_add_extent_hole_delay(ip, idx, new,
-				&logflags, delta, rsvd)))
+				&logflags, rsvd)))
 			goto done;
 	}
 	/*
@@ -550,7 +534,7 @@ xfs_bmap_add_extent(
 			ASSERT((cur->bc_private.b.flags &
 				XFS_BTCUR_BPRV_WASDEL) == 0);
 		if ((error = xfs_bmap_add_extent_hole_real(ip, idx, cur, new,
-				&logflags, delta, whichfork)))
+				&logflags, whichfork)))
 			goto done;
 	} else {
 		xfs_bmbt_irec_t	prev;	/* old extent at offset idx */
@@ -575,17 +559,17 @@ xfs_bmap_add_extent(
 						XFS_BTCUR_BPRV_WASDEL);
 				if ((error = xfs_bmap_add_extent_delay_real(ip,
 					idx, &cur, new, &da_new, first, flist,
-					&logflags, delta, rsvd)))
+					&logflags, rsvd)))
 					goto done;
 			} else if (new->br_state == XFS_EXT_NORM) {
 				ASSERT(new->br_state == XFS_EXT_NORM);
 				if ((error = xfs_bmap_add_extent_unwritten_real(
-					ip, idx, &cur, new, &logflags, delta)))
+					ip, idx, &cur, new, &logflags)))
 					goto done;
 			} else {
 				ASSERT(new->br_state == XFS_EXT_UNWRITTEN);
 				if ((error = xfs_bmap_add_extent_unwritten_real(
-					ip, idx, &cur, new, &logflags, delta)))
+					ip, idx, &cur, new, &logflags)))
 					goto done;
 			}
 			ASSERT(*curp == cur || *curp == NULL);
@@ -598,7 +582,7 @@ xfs_bmap_add_extent(
 				ASSERT((cur->bc_private.b.flags &
 					XFS_BTCUR_BPRV_WASDEL) == 0);
 			if ((error = xfs_bmap_add_extent_hole_real(ip, idx, cur,
-					new, &logflags, delta, whichfork)))
+					new, &logflags, whichfork)))
 				goto done;
 		}
 	}
@@ -663,7 +647,6 @@ xfs_bmap_add_extent_delay_real(
 	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
 	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
 	int			*logflagsp, /* inode logging flags */
-	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			rsvd)	/* OK to use reserved data block allocation */
 {
 	xfs_btree_cur_t		*cur;	/* btree cursor */
@@ -794,11 +777,6 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		*dnew = 0;
-		/* DELTA: Three in-core extents are replaced by one. */
-		temp = LEFT.br_startoff;
-		temp2 = LEFT.br_blockcount +
-			PREV.br_blockcount +
-			RIGHT.br_blockcount;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
@@ -829,10 +807,6 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		*dnew = 0;
-		/* DELTA: Two in-core extents are replaced by one. */
-		temp = LEFT.br_startoff;
-		temp2 = LEFT.br_blockcount +
-			PREV.br_blockcount;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -864,10 +838,6 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		*dnew = 0;
-		/* DELTA: Two in-core extents are replaced by one. */
-		temp = PREV.br_startoff;
-		temp2 = PREV.br_blockcount +
-			RIGHT.br_blockcount;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
@@ -897,9 +867,6 @@ xfs_bmap_add_extent_delay_real(
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
 		*dnew = 0;
-		/* DELTA: The in-core extent described by new changed type. */
-		temp = new->br_startoff;
-		temp2 = new->br_blockcount;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
@@ -939,10 +906,6 @@ xfs_bmap_add_extent_delay_real(
 		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
 		*dnew = temp;
-		/* DELTA: The boundary between two in-core extents moved. */
-		temp = LEFT.br_startoff;
-		temp2 = LEFT.br_blockcount +
-			PREV.br_blockcount;
 		break;
 
 	case BMAP_LEFT_FILLING:
@@ -987,9 +950,6 @@ xfs_bmap_add_extent_delay_real(
 		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 		trace_xfs_bmap_post_update(ip, idx + 1, state, _THIS_IP_);
 		*dnew = temp;
-		/* DELTA: One in-core extent is split in two. */
-		temp = PREV.br_startoff;
-		temp2 = PREV.br_blockcount;
 		break;
 
 	case BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -1028,10 +988,6 @@ xfs_bmap_add_extent_delay_real(
 		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
 		*dnew = temp;
-		/* DELTA: The boundary between two in-core extents moved. */
-		temp = PREV.br_startoff;
-		temp2 = PREV.br_blockcount +
-			RIGHT.br_blockcount;
 		break;
 
 	case BMAP_RIGHT_FILLING:
@@ -1075,9 +1031,6 @@ xfs_bmap_add_extent_delay_real(
 		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
 		*dnew = temp;
-		/* DELTA: One in-core extent is split in two. */
-		temp = PREV.br_startoff;
-		temp2 = PREV.br_blockcount;
 		break;
 
 	case 0:
@@ -1158,9 +1111,6 @@ xfs_bmap_add_extent_delay_real(
 			nullstartblock((int)temp2));
 		trace_xfs_bmap_post_update(ip, idx + 2, state, _THIS_IP_);
 		*dnew = temp + temp2;
-		/* DELTA: One in-core extent is split in three. */
-		temp = PREV.br_startoff;
-		temp2 = PREV.br_blockcount;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
@@ -1176,13 +1126,6 @@ xfs_bmap_add_extent_delay_real(
 		ASSERT(0);
 	}
 	*curp = cur;
-	if (delta) {
-		temp2 += temp;
-		if (delta->xed_startoff > temp)
-			delta->xed_startoff = temp;
-		if (delta->xed_blockcount < temp2)
-			delta->xed_blockcount = temp2;
-	}
 done:
 	*logflagsp = rval;
 	return error;
@@ -1201,8 +1144,7 @@ xfs_bmap_add_extent_unwritten_real(
 	xfs_extnum_t		idx,	/* extent number to update/insert */
 	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
-	int			*logflagsp, /* inode logging flags */
-	xfs_extdelta_t		*delta) /* Change made to incore extents */
+	int			*logflagsp) /* inode logging flags */
 {
 	xfs_btree_cur_t		*cur;	/* btree cursor */
 	xfs_bmbt_rec_host_t	*ep;	/* extent entry for idx */
@@ -1216,8 +1158,6 @@ xfs_bmap_add_extent_unwritten_real(
 					/* left is 0, right is 1, prev is 2 */
 	int			rval=0;	/* return value (logging flags) */
 	int			state = 0;/* state bits, accessed thru macros */
-	xfs_filblks_t		temp=0;
-	xfs_filblks_t		temp2=0;
 
 #define	LEFT		r[0]
 #define	RIGHT		r[1]
@@ -1338,11 +1278,6 @@ xfs_bmap_add_extent_unwritten_real(
 				RIGHT.br_blockcount, LEFT.br_state)))
 				goto done;
 		}
-		/* DELTA: Three in-core extents are replaced by one. */
-		temp = LEFT.br_startoff;
-		temp2 = LEFT.br_blockcount +
-			PREV.br_blockcount +
-			RIGHT.br_blockcount;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
@@ -1379,10 +1314,6 @@ xfs_bmap_add_extent_unwritten_real(
 				LEFT.br_state)))
 				goto done;
 		}
-		/* DELTA: Two in-core extents are replaced by one. */
-		temp = LEFT.br_startoff;
-		temp2 = LEFT.br_blockcount +
-			PREV.br_blockcount;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -1419,10 +1350,6 @@ xfs_bmap_add_extent_unwritten_real(
 				newext)))
 				goto done;
 		}
-		/* DELTA: Two in-core extents are replaced by one. */
-		temp = PREV.br_startoff;
-		temp2 = PREV.br_blockcount +
-			RIGHT.br_blockcount;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
@@ -1450,9 +1377,6 @@ xfs_bmap_add_extent_unwritten_real(
 				newext)))
 				goto done;
 		}
-		/* DELTA: The in-core extent described by new changed type. */
-		temp = new->br_startoff;
-		temp2 = new->br_blockcount;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
@@ -1498,10 +1422,6 @@ xfs_bmap_add_extent_unwritten_real(
 				LEFT.br_state))
 				goto done;
 		}
-		/* DELTA: The boundary between two in-core extents moved. */
-		temp = LEFT.br_startoff;
-		temp2 = LEFT.br_blockcount +
-			PREV.br_blockcount;
 		break;
 
 	case BMAP_LEFT_FILLING:
@@ -1541,9 +1461,6 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
-		/* DELTA: One in-core extent is split in two. */
-		temp = PREV.br_startoff;
-		temp2 = PREV.br_blockcount;
 		break;
 
 	case BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -1584,10 +1501,6 @@ xfs_bmap_add_extent_unwritten_real(
 				newext)))
 				goto done;
 		}
-		/* DELTA: The boundary between two in-core extents moved. */
-		temp = PREV.br_startoff;
-		temp2 = PREV.br_blockcount +
-			RIGHT.br_blockcount;
 		break;
 
 	case BMAP_RIGHT_FILLING:
@@ -1627,9 +1540,6 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
-		/* DELTA: One in-core extent is split in two. */
-		temp = PREV.br_startoff;
-		temp2 = PREV.br_blockcount;
 		break;
 
 	case 0:
@@ -1689,9 +1599,6 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
-		/* DELTA: One in-core extent is split in three. */
-		temp = PREV.br_startoff;
-		temp2 = PREV.br_blockcount;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
@@ -1707,13 +1614,6 @@ xfs_bmap_add_extent_unwritten_real(
 		ASSERT(0);
 	}
 	*curp = cur;
-	if (delta) {
-		temp2 += temp;
-		if (delta->xed_startoff > temp)
-			delta->xed_startoff = temp;
-		if (delta->xed_blockcount < temp2)
-			delta->xed_blockcount = temp2;
-	}
 done:
 	*logflagsp = rval;
 	return error;
@@ -1733,7 +1633,6 @@ xfs_bmap_add_extent_hole_delay(
 	xfs_extnum_t		idx,	/* extent number to update/insert */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	int			*logflagsp, /* inode logging flags */
-	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			rsvd)		/* OK to allocate reserved blocks */
 {
 	xfs_bmbt_rec_host_t	*ep;	/* extent record for idx */
@@ -1744,7 +1643,6 @@ xfs_bmap_add_extent_hole_delay(
 	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
 	int			state;  /* state bits, accessed thru macros */
 	xfs_filblks_t		temp=0;	/* temp for indirect calculations */
-	xfs_filblks_t		temp2=0;
 
 	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	ep = xfs_iext_get_ext(ifp, idx);
@@ -1816,9 +1714,6 @@ xfs_bmap_add_extent_hole_delay(
 
 		xfs_iext_remove(ip, idx, 1, state);
 		ip->i_df.if_lastex = idx - 1;
-		/* DELTA: Two in-core extents were replaced by one. */
-		temp2 = temp;
-		temp = left.br_startoff;
 		break;
 
 	case BMAP_LEFT_CONTIG:
@@ -1838,9 +1733,6 @@ xfs_bmap_add_extent_hole_delay(
 		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
 
 		ip->i_df.if_lastex = idx - 1;
-		/* DELTA: One in-core extent grew into a hole. */
-		temp2 = temp;
-		temp = left.br_startoff;
 		break;
 
 	case BMAP_RIGHT_CONTIG:
@@ -1859,9 +1751,6 @@ xfs_bmap_add_extent_hole_delay(
 		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
 
 		ip->i_df.if_lastex = idx;
-		/* DELTA: One in-core extent grew into a hole. */
-		temp2 = temp;
-		temp = new->br_startoff;
 		break;
 
 	case 0:
@@ -1873,9 +1762,6 @@ xfs_bmap_add_extent_hole_delay(
 		oldlen = newlen = 0;
 		xfs_iext_insert(ip, idx, 1, new, state);
 		ip->i_df.if_lastex = idx;
-		/* DELTA: A new in-core extent was added in a hole. */
-		temp2 = new->br_blockcount;
-		temp = new->br_startoff;
 		break;
 	}
 	if (oldlen != newlen) {
@@ -1886,13 +1772,6 @@ xfs_bmap_add_extent_hole_delay(
 		 * Nothing to do for disk quota accounting here.
 		 */
 	}
-	if (delta) {
-		temp2 += temp;
-		if (delta->xed_startoff > temp)
-			delta->xed_startoff = temp;
-		if (delta->xed_blockcount < temp2)
-			delta->xed_blockcount = temp2;
-	}
 	*logflagsp = 0;
 	return 0;
 }
@@ -1908,7 +1787,6 @@ xfs_bmap_add_extent_hole_real(
 	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	int			*logflagsp, /* inode logging flags */
-	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			whichfork) /* data or attr fork */
 {
 	xfs_bmbt_rec_host_t	*ep;	/* pointer to extent entry ins. point */
@@ -1919,8 +1797,6 @@ xfs_bmap_add_extent_hole_real(
 	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
 	int			rval=0;	/* return value (logging flags) */
 	int			state;	/* state bits, accessed thru macros */
-	xfs_filblks_t		temp=0;
-	xfs_filblks_t		temp2=0;
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(idx <= ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t));
@@ -2017,11 +1893,6 @@ xfs_bmap_add_extent_hole_real(
 					left.br_state)))
 				goto done;
 		}
-		/* DELTA: Two in-core extents were replaced by one. */
-		temp = left.br_startoff;
-		temp2 = left.br_blockcount +
-			new->br_blockcount +
-			right.br_blockcount;
 		break;
 
 	case BMAP_LEFT_CONTIG:
@@ -2053,10 +1924,6 @@ xfs_bmap_add_extent_hole_real(
 					left.br_state)))
 				goto done;
 		}
-		/* DELTA: One in-core extent grew. */
-		temp = left.br_startoff;
-		temp2 = left.br_blockcount +
-			new->br_blockcount;
 		break;
 
 	case BMAP_RIGHT_CONTIG:
@@ -2089,10 +1956,6 @@ xfs_bmap_add_extent_hole_real(
 					right.br_state)))
 				goto done;
 		}
-		/* DELTA: One in-core extent grew. */
-		temp = new->br_startoff;
-		temp2 = new->br_blockcount +
-			right.br_blockcount;
 		break;
 
 	case 0:
@@ -2120,18 +1983,8 @@ xfs_bmap_add_extent_hole_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
-		/* DELTA: A new extent was added in a hole. */
-		temp = new->br_startoff;
-		temp2 = new->br_blockcount;
 		break;
 	}
-	if (delta) {
-		temp2 += temp;
-		if (delta->xed_startoff > temp)
-			delta->xed_startoff = temp;
-		if (delta->xed_blockcount < temp2)
-			delta->xed_blockcount = temp2;
-	}
 done:
 	*logflagsp = rval;
 	return error;
@@ -2944,7 +2797,6 @@ xfs_bmap_del_extent(
 	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*del,	/* data to remove from extents */
 	int			*logflagsp, /* inode logging flags */
-	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			whichfork, /* data or attr fork */
 	int			rsvd)	/* OK to allocate reserved blocks */
 {
@@ -3250,14 +3102,6 @@ xfs_bmap_del_extent(
 	if (da_old > da_new)
 		xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS, (int64_t)(da_old - da_new),
 			rsvd);
-	if (delta) {
-		/* DELTA: report the original extent. */
-		if (delta->xed_startoff > got.br_startoff)
-			delta->xed_startoff = got.br_startoff;
-		if (delta->xed_blockcount < got.br_startoff+got.br_blockcount)
-			delta->xed_blockcount = got.br_startoff +
-							got.br_blockcount;
-	}
 done:
 	*logflagsp = flags;
 	return error;
@@ -4469,8 +4313,7 @@ xfs_bmapi(
 	xfs_extlen_t	total,		/* total blocks needed */
 	xfs_bmbt_irec_t	*mval,		/* output: map values */
 	int		*nmap,		/* i/o: mval size/count */
-	xfs_bmap_free_t	*flist,		/* i/o: list extents to free */
-	xfs_extdelta_t	*delta)		/* o: change made to incore extents */
+	xfs_bmap_free_t	*flist)		/* i/o: list extents to free */
 {
 	xfs_fsblock_t	abno;		/* allocated block number */
 	xfs_extlen_t	alen;		/* allocated extent length */
@@ -4582,10 +4425,7 @@ xfs_bmapi(
 	end = bno + len;
 	obno = bno;
 	bma.ip = NULL;
-	if (delta) {
-		delta->xed_startoff = NULLFILEOFF;
-		delta->xed_blockcount = 0;
-	}
+
 	while (bno < end && n < *nmap) {
 		/*
 		 * Reading past eof, act as though there's a hole
@@ -4811,7 +4651,7 @@ xfs_bmapi(
 					got.br_state = XFS_EXT_UNWRITTEN;
 			}
 			error = xfs_bmap_add_extent(ip, lastx, &cur, &got,
-				firstblock, flist, &tmp_logflags, delta,
+				firstblock, flist, &tmp_logflags,
 				whichfork, (flags & XFS_BMAPI_RSVBLOCKS));
 			logflags |= tmp_logflags;
 			if (error)
@@ -4907,7 +4747,7 @@ xfs_bmapi(
 			}
 			mval->br_state = XFS_EXT_NORM;
 			error = xfs_bmap_add_extent(ip, lastx, &cur, mval,
-				firstblock, flist, &tmp_logflags, delta,
+				firstblock, flist, &tmp_logflags,
 				whichfork, (flags & XFS_BMAPI_RSVBLOCKS));
 			logflags |= tmp_logflags;
 			if (error)
@@ -4997,14 +4837,6 @@ xfs_bmapi(
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE ||
 	       XFS_IFORK_NEXTENTS(ip, whichfork) > ifp->if_ext_max);
 	error = 0;
-	if (delta && delta->xed_startoff != NULLFILEOFF) {
-		/* A change was actually made.
-		 * Note that delta->xed_blockount is an offset at this
-		 * point and needs to be converted to a block count.
-		 */
-		ASSERT(delta->xed_blockcount > delta->xed_startoff);
-		delta->xed_blockcount -= delta->xed_startoff;
-	}
 error0:
 	/*
 	 * Log everything.  Do this after conversion, there's no point in
@@ -5116,8 +4948,6 @@ xfs_bunmapi(
 	xfs_fsblock_t		*firstblock,	/* first allocated block
 						   controls a.g. for allocs */
 	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
-	xfs_extdelta_t		*delta,		/* o: change made to incore
-						   extents */
 	int			*done)		/* set if not done yet */
 {
 	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
@@ -5176,10 +5006,7 @@ xfs_bunmapi(
 	bno = start + len - 1;
 	ep = xfs_bmap_search_extents(ip, bno, whichfork, &eof, &lastx, &got,
 		&prev);
-	if (delta) {
-		delta->xed_startoff = NULLFILEOFF;
-		delta->xed_blockcount = 0;
-	}
+
 	/*
 	 * Check to see if the given block number is past the end of the
 	 * file, back up to the last block if so...
@@ -5277,7 +5104,7 @@ xfs_bunmapi(
 			}
 			del.br_state = XFS_EXT_UNWRITTEN;
 			error = xfs_bmap_add_extent(ip, lastx, &cur, &del,
-				firstblock, flist, &logflags, delta,
+				firstblock, flist, &logflags,
 				XFS_DATA_FORK, 0);
 			if (error)
 				goto error0;
@@ -5332,7 +5159,7 @@ xfs_bunmapi(
 				prev.br_state = XFS_EXT_UNWRITTEN;
 				error = xfs_bmap_add_extent(ip, lastx - 1, &cur,
 					&prev, firstblock, flist, &logflags,
-					delta, XFS_DATA_FORK, 0);
+					XFS_DATA_FORK, 0);
 				if (error)
 					goto error0;
 				goto nodelete;
@@ -5341,7 +5168,7 @@ xfs_bunmapi(
 				del.br_state = XFS_EXT_UNWRITTEN;
 				error = xfs_bmap_add_extent(ip, lastx, &cur,
 					&del, firstblock, flist, &logflags,
-					delta, XFS_DATA_FORK, 0);
+					XFS_DATA_FORK, 0);
 				if (error)
 					goto error0;
 				goto nodelete;
@@ -5394,7 +5221,7 @@ xfs_bunmapi(
 			goto error0;
 		}
 		error = xfs_bmap_del_extent(ip, tp, lastx, flist, cur, &del,
-				&tmp_logflags, delta, whichfork, rsvd);
+				&tmp_logflags, whichfork, rsvd);
 		logflags |= tmp_logflags;
 		if (error)
 			goto error0;
@@ -5451,14 +5278,6 @@ nodelete:
 	ASSERT(ifp->if_ext_max ==
 	       XFS_IFORK_SIZE(ip, whichfork) / (uint)sizeof(xfs_bmbt_rec_t));
 	error = 0;
-	if (delta && delta->xed_startoff != NULLFILEOFF) {
-		/* A change was actually made.
-		 * Note that delta->xed_blockount is an offset at this
-		 * point and needs to be converted to a block count.
-		 */
-		ASSERT(delta->xed_blockcount > delta->xed_startoff);
-		delta->xed_blockcount -= delta->xed_startoff;
-	}
 error0:
 	/*
 	 * Log everything.  Do this after conversion, there's no point in
@@ -5671,7 +5490,7 @@ xfs_getbmap(
 		error = xfs_bmapi(NULL, ip, XFS_BB_TO_FSBT(mp, bmv->bmv_offset),
 				  XFS_BB_TO_FSB(mp, bmv->bmv_length),
 				  bmapi_flags, NULL, 0, map, &nmap,
-				  NULL, NULL);
+				  NULL);
 		if (error)
 			goto out_free_map;
 		ASSERT(nmap <= subnex);
Index: xfs/fs/xfs/xfs_bmap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.h	2010-05-29 18:45:02.175004206 +0200
+++ xfs/fs/xfs/xfs_bmap.h	2010-05-29 18:45:03.792276730 +0200
@@ -28,20 +28,6 @@ struct xfs_trans;
 extern kmem_zone_t	*xfs_bmap_free_item_zone;
 
 /*
- * DELTA: describe a change to the in-core extent list.
- *
- * Internally the use of xed_blockount is somewhat funky.
- * xed_blockcount contains an offset much of the time because this
- * makes merging changes easier.  (xfs_fileoff_t and xfs_filblks_t are
- * the same underlying type).
- */
-typedef struct xfs_extdelta
-{
-	xfs_fileoff_t		xed_startoff;	/* offset of range */
-	xfs_filblks_t		xed_blockcount;	/* blocks in range */
-} xfs_extdelta_t;
-
-/*
  * List of extents to be free "later".
  * The list is kept sorted on xbf_startblock.
  */
@@ -305,9 +291,7 @@ xfs_bmapi(
 	xfs_extlen_t		total,		/* total blocks needed */
 	struct xfs_bmbt_irec	*mval,		/* output: map values */
 	int			*nmap,		/* i/o: mval size/count */
-	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
-	xfs_extdelta_t		*delta);	/* o: change made to incore
-						   extents */
+	xfs_bmap_free_t		*flist);	/* i/o: list extents to free */
 
 /*
  * Map file blocks to filesystem blocks, simple version.
@@ -341,8 +325,6 @@ xfs_bunmapi(
 	xfs_fsblock_t		*firstblock,	/* first allocated block
 						   controls a.g. for allocs */
 	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
-	xfs_extdelta_t		*delta,		/* o: change made to incore
-						   extents */
 	int			*done);		/* set if not done yet */
 
 /*
Index: xfs/fs/xfs/xfs_da_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_da_btree.c	2010-05-29 18:44:44.247005742 +0200
+++ xfs/fs/xfs/xfs_da_btree.c	2010-05-29 18:45:03.800254799 +0200
@@ -1596,7 +1596,7 @@ xfs_da_grow_inode(xfs_da_args_t *args, x
 			xfs_bmapi_aflag(w)|XFS_BMAPI_WRITE|XFS_BMAPI_METADATA|
 			XFS_BMAPI_CONTIG,
 			args->firstblock, args->total, &map, &nmap,
-			args->flist, NULL))) {
+			args->flist))) {
 		return error;
 	}
 	ASSERT(nmap <= 1);
@@ -1617,8 +1617,7 @@ xfs_da_grow_inode(xfs_da_args_t *args, x
 					xfs_bmapi_aflag(w)|XFS_BMAPI_WRITE|
 					XFS_BMAPI_METADATA,
 					args->firstblock, args->total,
-					&mapp[mapi], &nmap, args->flist,
-					NULL))) {
+					&mapp[mapi], &nmap, args->flist))) {
 				kmem_free(mapp);
 				return error;
 			}
@@ -1879,7 +1878,7 @@ xfs_da_shrink_inode(xfs_da_args_t *args,
 		 */
 		if ((error = xfs_bunmapi(tp, dp, dead_blkno, count,
 				xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA,
-				0, args->firstblock, args->flist, NULL,
+				0, args->firstblock, args->flist,
 				&done)) == ENOSPC) {
 			if (w != XFS_DATA_FORK)
 				break;
@@ -1984,7 +1983,7 @@ xfs_da_do_buf(
 					nfsb,
 					XFS_BMAPI_METADATA |
 						xfs_bmapi_aflag(whichfork),
-					NULL, 0, mapp, &nmap, NULL, NULL)))
+					NULL, 0, mapp, &nmap, NULL)))
 				goto exit0;
 		}
 	} else {
Index: xfs/fs/xfs/xfs_dir2.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2.c	2010-05-29 18:44:44.250006161 +0200
+++ xfs/fs/xfs/xfs_dir2.c	2010-05-29 18:45:03.805255777 +0200
@@ -547,7 +547,7 @@ xfs_dir2_grow_inode(
 	if ((error = xfs_bmapi(tp, dp, bno, count,
 			XFS_BMAPI_WRITE|XFS_BMAPI_METADATA|XFS_BMAPI_CONTIG,
 			args->firstblock, args->total, &map, &nmap,
-			args->flist, NULL)))
+			args->flist)))
 		return error;
 	ASSERT(nmap <= 1);
 	if (nmap == 1) {
@@ -579,8 +579,7 @@ xfs_dir2_grow_inode(
 			if ((error = xfs_bmapi(tp, dp, b, c,
 					XFS_BMAPI_WRITE|XFS_BMAPI_METADATA,
 					args->firstblock, args->total,
-					&mapp[mapi], &nmap, args->flist,
-					NULL))) {
+					&mapp[mapi], &nmap, args->flist))) {
 				kmem_free(mapp);
 				return error;
 			}
@@ -713,7 +712,7 @@ xfs_dir2_shrink_inode(
 	 */
 	if ((error = xfs_bunmapi(tp, dp, da, mp->m_dirblkfsbs,
 			XFS_BMAPI_METADATA, 0, args->firstblock, args->flist,
-			NULL, &done))) {
+			&done))) {
 		/*
 		 * ENOSPC actually can happen if we're in a removename with
 		 * no space reservation, and the resulting block removal
Index: xfs/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2010-05-29 18:44:44.260005393 +0200
+++ xfs/fs/xfs/xfs_dir2_leaf.c	2010-05-29 18:45:03.809255847 +0200
@@ -873,7 +873,7 @@ xfs_dir2_leaf_getdents(
 					xfs_dir2_byte_to_da(mp,
 						XFS_DIR2_LEAF_OFFSET) - map_off,
 					XFS_BMAPI_METADATA, NULL, 0,
-					&map[map_valid], &nmap, NULL, NULL);
+					&map[map_valid], &nmap, NULL);
 				/*
 				 * Don't know if we should ignore this or
 				 * try to return an error.
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2010-05-29 18:45:02.178253752 +0200
+++ xfs/fs/xfs/xfs_inode.c	2010-05-29 18:45:03.814005812 +0200
@@ -1225,7 +1225,7 @@ xfs_isize_check(
 				       (xfs_ufsize_t)XFS_MAXIOFFSET(mp)) -
 			  map_first),
 			 XFS_BMAPI_ENTIRE, NULL, 0, imaps, &nimaps,
-			 NULL, NULL))
+			 NULL))
 	    return;
 	ASSERT(nimaps == 1);
 	ASSERT(imaps[0].br_startblock == HOLESTARTBLOCK);
@@ -1591,7 +1591,7 @@ xfs_itruncate_finish(
 				    xfs_bmapi_aflag(fork),
 				    XFS_ITRUNC_MAX_EXTENTS,
 				    &first_block, &free_list,
-				    NULL, &done);
+				    &done);
 		if (error) {
 			/*
 			 * If the bunmapi call encounters an error,
Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2010-05-29 18:44:47.721006022 +0200
+++ xfs/fs/xfs/xfs_iomap.c	2010-05-29 18:45:03.820005533 +0200
@@ -118,7 +118,7 @@ xfs_iomap(
 	error = xfs_bmapi(NULL, ip, offset_fsb,
 			(xfs_filblks_t)(end_fsb - offset_fsb),
 			bmapi_flags,  NULL, 0, imap,
-			nimaps, NULL, NULL);
+			nimaps, NULL);
 
 	if (error)
 		goto out;
@@ -341,7 +341,7 @@ xfs_iomap_write_direct(
 	xfs_bmap_init(&free_list, &firstfsb);
 	nimaps = 1;
 	error = xfs_bmapi(tp, ip, offset_fsb, count_fsb, bmapi_flag,
-		&firstfsb, 0, &imap, &nimaps, &free_list, NULL);
+		&firstfsb, 0, &imap, &nimaps, &free_list);
 	if (error)
 		goto error0;
 
@@ -419,7 +419,7 @@ xfs_iomap_eof_want_preallocate(
 		imaps = nimaps;
 		firstblock = NULLFSBLOCK;
 		error = xfs_bmapi(NULL, ip, start_fsb, count_fsb, 0,
-				  &firstblock, 0, imap, &imaps, NULL, NULL);
+				  &firstblock, 0, imap, &imaps, NULL);
 		if (error)
 			return error;
 		for (n = 0; n < imaps; n++) {
@@ -494,7 +494,7 @@ retry:
 			  (xfs_filblks_t)(last_fsb - offset_fsb),
 			  XFS_BMAPI_DELAY | XFS_BMAPI_WRITE |
 			  XFS_BMAPI_ENTIRE, &firstblock, 1, imap,
-			  &nimaps, NULL, NULL);
+			  &nimaps, NULL);
 	if (error && (error != ENOSPC))
 		return XFS_ERROR(error);
 
@@ -650,7 +650,7 @@ xfs_iomap_write_allocate(
 			/* Go get the actual blocks */
 			error = xfs_bmapi(tp, ip, map_start_fsb, count_fsb,
 					XFS_BMAPI_WRITE, &first_block, 1,
-					&imap, &nimaps, &free_list, NULL);
+					&imap, &nimaps, &free_list);
 			if (error)
 				goto trans_cancel;
 
@@ -768,7 +768,7 @@ xfs_iomap_write_unwritten(
 		nimaps = 1;
 		error = xfs_bmapi(tp, ip, offset_fsb, count_fsb,
 				  XFS_BMAPI_WRITE|XFS_BMAPI_CONVERT, &firstfsb,
-				  1, &imap, &nimaps, &free_list, NULL);
+				  1, &imap, &nimaps, &free_list);
 		if (error)
 			goto error_on_bmapi_transaction;
 
Index: xfs/fs/xfs/xfs_rtalloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rtalloc.c	2010-05-29 18:44:44.204005882 +0200
+++ xfs/fs/xfs/xfs_rtalloc.c	2010-05-29 18:45:03.826256825 +0200
@@ -122,7 +122,7 @@ xfs_growfs_rt_alloc(
 		cancelflags |= XFS_TRANS_ABORT;
 		error = xfs_bmapi(tp, ip, oblocks, nblocks - oblocks,
 			XFS_BMAPI_WRITE | XFS_BMAPI_METADATA, &firstblock,
-			resblks, &map, &nmap, &flist, NULL);
+			resblks, &map, &nmap, &flist);
 		if (!error && nmap < 1)
 			error = XFS_ERROR(ENOSPC);
 		if (error)
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2010-05-29 18:44:47.686004066 +0200
+++ xfs/fs/xfs/xfs_vnodeops.c	2010-05-29 18:45:03.835005393 +0200
@@ -492,7 +492,7 @@ xfs_readlink_bmap(
 	int		error = 0;
 
 	error = xfs_bmapi(NULL, ip, 0, XFS_B_TO_FSB(mp, pathlen), 0, NULL, 0,
-			mval, &nmaps, NULL, NULL);
+			mval, &nmaps, NULL);
 	if (error)
 		goto out;
 
@@ -596,7 +596,7 @@ xfs_free_eofblocks(
 	nimaps = 1;
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	error = xfs_bmapi(NULL, ip, end_fsb, map_len, 0,
-			  NULL, 0, &imap, &nimaps, NULL, NULL);
+			  NULL, 0, &imap, &nimaps, NULL);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	if (!error && (nimaps != 0) &&
@@ -733,7 +733,7 @@ xfs_inactive_symlink_rmt(
 	nmaps = ARRAY_SIZE(mval);
 	if ((error = xfs_bmapi(tp, ip, 0, XFS_B_TO_FSB(mp, size),
 			XFS_BMAPI_METADATA, &first_block, 0, mval, &nmaps,
-			&free_list, NULL)))
+			&free_list)))
 		goto error0;
 	/*
 	 * Invalidate the block(s).
@@ -748,7 +748,7 @@ xfs_inactive_symlink_rmt(
 	 * Unmap the dead block(s) to the free_list.
 	 */
 	if ((error = xfs_bunmapi(tp, ip, 0, size, XFS_BMAPI_METADATA, nmaps,
-			&first_block, &free_list, NULL, &done)))
+			&first_block, &free_list, &done)))
 		goto error1;
 	ASSERT(done);
 	/*
@@ -2095,7 +2095,7 @@ xfs_symlink(
 		error = xfs_bmapi(tp, ip, first_fsb, fs_blocks,
 				  XFS_BMAPI_WRITE | XFS_BMAPI_METADATA,
 				  &first_block, resblks, mval, &nmaps,
-				  &free_list, NULL);
+				  &free_list);
 		if (error) {
 			goto error1;
 		}
@@ -2347,7 +2347,7 @@ xfs_alloc_file_space(
 		error = xfs_bmapi(tp, ip, startoffset_fsb,
 				  allocatesize_fsb, bmapi_flag,
 				  &firstfsb, 0, imapp, &nimaps,
-				  &free_list, NULL);
+				  &free_list);
 		if (error) {
 			goto error0;
 		}
@@ -2436,7 +2436,7 @@ xfs_zero_remaining_bytes(
 		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 		nimap = 1;
 		error = xfs_bmapi(NULL, ip, offset_fsb, 1, 0,
-			NULL, 0, &imap, &nimap, NULL, NULL);
+			NULL, 0, &imap, &nimap, NULL);
 		if (error || nimap < 1)
 			break;
 		ASSERT(imap.br_blockcount >= 1);
@@ -2556,7 +2556,7 @@ xfs_free_file_space(
 	if (rt && !xfs_sb_version_hasextflgbit(&mp->m_sb)) {
 		nimap = 1;
 		error = xfs_bmapi(NULL, ip, startoffset_fsb,
-			1, 0, NULL, 0, &imap, &nimap, NULL, NULL);
+			1, 0, NULL, 0, &imap, &nimap, NULL);
 		if (error)
 			goto out_unlock_iolock;
 		ASSERT(nimap == 0 || nimap == 1);
@@ -2571,7 +2571,7 @@ xfs_free_file_space(
 		}
 		nimap = 1;
 		error = xfs_bmapi(NULL, ip, endoffset_fsb - 1,
-			1, 0, NULL, 0, &imap, &nimap, NULL, NULL);
+			1, 0, NULL, 0, &imap, &nimap, NULL);
 		if (error)
 			goto out_unlock_iolock;
 		ASSERT(nimap == 0 || nimap == 1);
@@ -2647,7 +2647,7 @@ xfs_free_file_space(
 		xfs_bmap_init(&free_list, &firstfsb);
 		error = xfs_bunmapi(tp, ip, startoffset_fsb,
 				  endoffset_fsb - startoffset_fsb,
-				  0, 2, &firstfsb, &free_list, NULL, &done);
+				  0, 2, &firstfsb, &free_list, &done);
 		if (error) {
 			goto error0;
 		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
