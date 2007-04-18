Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Apr 2007 10:57:41 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3IHvXfB017246
	for <xfs@oss.sgi.com>; Wed, 18 Apr 2007 10:57:36 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l3IHvVLD018372
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 18 Apr 2007 19:57:31 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l3IHvUal018370
	for xfs@oss.sgi.com; Wed, 18 Apr 2007 19:57:30 +0200
Date: Wed, 18 Apr 2007 19:57:30 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove various useless min/max macros
Message-ID: <20070418175730.GA18315@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_btree.h has various macros to calculate a min/max after casting
it's arguments to a specific type.  This can be done much simpler
by using min_t/max_t with the type as first argument.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_alloc.c	2007-04-13 13:40:00.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_alloc.c	2007-04-13 13:44:07.000000000 +0200
@@ -151,11 +151,11 @@ xfs_alloc_compute_diff(
 		if (newbno1 >= freeend)
 			newbno1 = NULLAGBLOCK;
 		else
-			newlen1 = XFS_EXTLEN_MIN(wantlen, freeend - newbno1);
+			newlen1 = min_t(xfs_extlen_t, wantlen, freeend - newbno1);
 		if (newbno2 < freebno)
 			newbno2 = NULLAGBLOCK;
 		else
-			newlen2 = XFS_EXTLEN_MIN(wantlen, freeend - newbno2);
+			newlen2 = min_t(xfs_extlen_t, wantlen, freeend - newbno2);
 		if (newbno1 != NULLAGBLOCK && newbno2 != NULLAGBLOCK) {
 			if (newlen1 < newlen2 ||
 			    (newlen1 == newlen2 &&
@@ -686,7 +686,7 @@ xfs_alloc_ag_vextent_exact(
 	 * End of extent will be smaller of the freespace end and the
 	 * maximal requested end.
 	 */
-	end = XFS_AGBLOCK_MIN(fend, maxend);
+	end = min_t(xfs_agblock_t, fend, maxend);
 	/*
 	 * Fix the length according to mod and prod if given.
 	 */
@@ -850,7 +850,7 @@ xfs_alloc_ag_vextent_near(
 					args->alignment, args->minlen,
 					&ltbnoa, &ltlena))
 				continue;
-			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
+			args->len = min_t(xfs_extlen_t, ltlena, args->maxlen);
 			xfs_alloc_fix_len(args);
 			ASSERT(args->len >= args->minlen);
 			if (args->len < blen)
@@ -1007,7 +1007,7 @@ xfs_alloc_ag_vextent_near(
 			/*
 			 * Fix up the length.
 			 */
-			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
+			args->len = min_t(xfs_extlen_t, ltlena, args->maxlen);
 			xfs_alloc_fix_len(args);
 			rlen = args->len;
 			ltdiff = xfs_alloc_compute_diff(args->agbno, rlen,
@@ -1045,7 +1045,7 @@ xfs_alloc_ag_vextent_near(
 					 */
 					if (gtlena >= args->minlen) {
 						args->len =
-							XFS_EXTLEN_MIN(gtlena,
+							min_t(xfs_extlen_t, gtlena,
 								args->maxlen);
 						xfs_alloc_fix_len(args);
 						rlen = args->len;
@@ -1104,7 +1104,7 @@ xfs_alloc_ag_vextent_near(
 			/*
 			 * Fix up the length.
 			 */
-			args->len = XFS_EXTLEN_MIN(gtlena, args->maxlen);
+			args->len = min_t(xfs_extlen_t, gtlena, args->maxlen);
 			xfs_alloc_fix_len(args);
 			rlen = args->len;
 			gtdiff = xfs_alloc_compute_diff(args->agbno, rlen,
@@ -1141,7 +1141,7 @@ xfs_alloc_ag_vextent_near(
 					 * compare the two and pick the best.
 					 */
 					if (ltlena >= args->minlen) {
-						args->len = XFS_EXTLEN_MIN(
+						args->len = min_t(xfs_extlen_t,
 							ltlena, args->maxlen);
 						xfs_alloc_fix_len(args);
 						rlen = args->len;
@@ -1221,7 +1221,7 @@ xfs_alloc_ag_vextent_near(
 	 * Fix up the length and compute the useful address.
 	 */
 	ltend = ltbno + ltlen;
-	args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
+	args->len = min_t(xfs_extlen_t, ltlena, args->maxlen);
 	xfs_alloc_fix_len(args);
 	if (!xfs_alloc_fix_minleft(args)) {
 		TRACE_ALLOC("nominleft", args);
@@ -1320,7 +1320,7 @@ xfs_alloc_ag_vextent_size(
 	 */
 	xfs_alloc_compute_aligned(fbno, flen, args->alignment, args->minlen,
 		&rbno, &rlen);
-	rlen = XFS_EXTLEN_MIN(args->maxlen, rlen);
+	rlen = min_t(xfs_extlen_t, args->maxlen, rlen);
 	XFS_WANT_CORRUPTED_GOTO(rlen == 0 ||
 			(rlen <= flen && rbno + rlen <= fbno + flen), error0);
 	if (rlen < args->maxlen) {
@@ -1346,7 +1346,7 @@ xfs_alloc_ag_vextent_size(
 				break;
 			xfs_alloc_compute_aligned(fbno, flen, args->alignment,
 				args->minlen, &rbno, &rlen);
-			rlen = XFS_EXTLEN_MIN(args->maxlen, rlen);
+			rlen = min_t(xfs_extlen_t, args->maxlen, rlen);
 			XFS_WANT_CORRUPTED_GOTO(rlen == 0 ||
 				(rlen <= flen && rbno + rlen <= fbno + flen),
 				error0);
Index: linux-2.6/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_bmap.c	2007-04-13 13:41:43.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_bmap.c	2007-04-13 13:45:14.000000000 +0200
@@ -994,7 +994,7 @@ xfs_bmap_add_extent_delay_real(
 					LEFT.br_state)))
 				goto done;
 		}
-		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+		temp = min_t(xfs_filblks_t, xfs_bmap_worst_indlen(ip, temp),
 			STARTBLOCKVAL(PREV.br_startblock));
 		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
 		xfs_bmap_trace_post_update(fname, "LF|LC", ip, idx,
@@ -1043,7 +1043,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
-		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+		temp = min_t(xfs_filblks_t, xfs_bmap_worst_indlen(ip, temp),
 			STARTBLOCKVAL(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
 		ep = xfs_iext_get_ext(ifp, idx + 1);
@@ -1090,7 +1090,7 @@ xfs_bmap_add_extent_delay_real(
 					RIGHT.br_state)))
 				goto done;
 		}
-		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+		temp = min_t(xfs_filblks_t, xfs_bmap_worst_indlen(ip, temp),
 			STARTBLOCKVAL(PREV.br_startblock));
 		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
 		xfs_bmap_trace_post_update(fname, "RF|RC", ip, idx,
@@ -1138,7 +1138,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
-		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+		temp = min_t(xfs_filblks_t, xfs_bmap_worst_indlen(ip, temp),
 			STARTBLOCKVAL(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
 		ep = xfs_iext_get_ext(ifp, idx);
@@ -3177,7 +3177,7 @@ xfs_bmap_del_extent(
 		xfs_bmbt_set_blockcount(ep, temp);
 		ifp->if_lastex = idx;
 		if (delay) {
-			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+			temp = min_t(xfs_filblks_t, xfs_bmap_worst_indlen(ip, temp),
 				da_old);
 			xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
 			xfs_bmap_trace_post_update(fname, "2", ip, idx,
@@ -3206,7 +3206,7 @@ xfs_bmap_del_extent(
 		xfs_bmbt_set_blockcount(ep, temp);
 		ifp->if_lastex = idx;
 		if (delay) {
-			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+			temp = min_t(xfs_filblks_t, xfs_bmap_worst_indlen(ip, temp),
 				da_old);
 			xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
 			xfs_bmap_trace_post_update(fname, "1", ip, idx,
@@ -4337,7 +4337,7 @@ xfs_bmap_first_unused(
 			return 0;
 		}
 		lastaddr = off + xfs_bmbt_get_blockcount(ep);
-		max = XFS_FILEOFF_MAX(lastaddr, lowest);
+		max = max_t(xfs_fileoff_t, lastaddr, lowest);
 	}
 	*first_unused = max;
 	return 0;
@@ -4850,16 +4850,16 @@ xfs_bmapi(
 				}
 			} else if (wasdelay) {
 				alen = (xfs_extlen_t)
-					XFS_FILBLKS_MIN(len,
+					min_t(xfs_filblks_t, len,
 						(got.br_startoff +
 						 got.br_blockcount) - bno);
 				aoff = bno;
 			} else {
 				alen = (xfs_extlen_t)
-					XFS_FILBLKS_MIN(len, MAXEXTLEN);
+					min_t(xfs_filblks_t, len, MAXEXTLEN);
 				if (!eof)
 					alen = (xfs_extlen_t)
-						XFS_FILBLKS_MIN(alen,
+						min_t(xfs_filblks_t, alen,
 							got.br_startoff - bno);
 				aoff = bno;
 			}
@@ -5087,7 +5087,7 @@ xfs_bmapi(
 			mval->br_startoff = bno;
 			mval->br_startblock = HOLESTARTBLOCK;
 			mval->br_blockcount =
-				XFS_FILBLKS_MIN(len, got.br_startoff - bno);
+				min_t(xfs_filblks_t, len, got.br_startoff - bno);
 			mval->br_state = XFS_EXT_NORM;
 			bno += mval->br_blockcount;
 			len -= mval->br_blockcount;
@@ -5122,7 +5122,7 @@ xfs_bmapi(
 			 * didn't overlap what was asked for.
 			 */
 			mval->br_blockcount =
-				XFS_FILBLKS_MIN(end - bno, got.br_blockcount -
+				min_t(xfs_filblks_t, end - bno, got.br_blockcount -
 					(bno - got.br_startoff));
 			mval->br_state = got.br_state;
 			ASSERT(mval->br_blockcount <= len);
@@ -5462,7 +5462,7 @@ xfs_bunmapi(
 		 * Is the last block of this extent before the range
 		 * we're supposed to delete?  If so, we're done.
 		 */
-		bno = XFS_FILEOFF_MIN(bno,
+		bno = min_t(xfs_fileoff_t, bno,
 			got.br_startoff + got.br_blockcount - 1);
 		if (bno < start)
 			break;
Index: linux-2.6/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_btree.h	2007-04-13 13:43:19.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_btree.h	2007-04-13 13:43:56.000000000 +0200
@@ -440,35 +440,6 @@ xfs_btree_setbuf(
 
 #endif	/* __KERNEL__ */
 
-
-/*
- * Min and max functions for extlen, agblock, fileoff, and filblks types.
- */
-#define	XFS_EXTLEN_MIN(a,b)	\
-	((xfs_extlen_t)(a) < (xfs_extlen_t)(b) ? \
-		(xfs_extlen_t)(a) : (xfs_extlen_t)(b))
-#define	XFS_EXTLEN_MAX(a,b)	\
-	((xfs_extlen_t)(a) > (xfs_extlen_t)(b) ? \
-		(xfs_extlen_t)(a) : (xfs_extlen_t)(b))
-#define	XFS_AGBLOCK_MIN(a,b)	\
-	((xfs_agblock_t)(a) < (xfs_agblock_t)(b) ? \
-		(xfs_agblock_t)(a) : (xfs_agblock_t)(b))
-#define	XFS_AGBLOCK_MAX(a,b)	\
-	((xfs_agblock_t)(a) > (xfs_agblock_t)(b) ? \
-		(xfs_agblock_t)(a) : (xfs_agblock_t)(b))
-#define	XFS_FILEOFF_MIN(a,b)	\
-	((xfs_fileoff_t)(a) < (xfs_fileoff_t)(b) ? \
-		(xfs_fileoff_t)(a) : (xfs_fileoff_t)(b))
-#define	XFS_FILEOFF_MAX(a,b)	\
-	((xfs_fileoff_t)(a) > (xfs_fileoff_t)(b) ? \
-		(xfs_fileoff_t)(a) : (xfs_fileoff_t)(b))
-#define	XFS_FILBLKS_MIN(a,b)	\
-	((xfs_filblks_t)(a) < (xfs_filblks_t)(b) ? \
-		(xfs_filblks_t)(a) : (xfs_filblks_t)(b))
-#define	XFS_FILBLKS_MAX(a,b)	\
-	((xfs_filblks_t)(a) > (xfs_filblks_t)(b) ? \
-		(xfs_filblks_t)(a) : (xfs_filblks_t)(b))
-
 #define	XFS_FSB_SANITY_CHECK(mp,fsb)	\
 	(XFS_FSB_TO_AGNO(mp, fsb) < mp->m_sb.sb_agcount && \
 		XFS_FSB_TO_AGBNO(mp, fsb) < mp->m_sb.sb_agblocks)
Index: linux-2.6/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.c	2007-04-13 13:42:08.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_inode.c	2007-04-13 13:42:19.000000000 +0200
@@ -1341,7 +1341,7 @@ xfs_file_last_byte(
 		last_block = 0;
 	}
 	size_last_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)ip->i_d.di_size);
-	last_block = XFS_FILEOFF_MAX(last_block, size_last_block);
+	last_block = max_t(xfs_fileoff_t, last_block, size_last_block);
 
 	last_byte = XFS_FSB_TO_B(mp, last_block);
 	if (last_byte < 0) {
Index: linux-2.6/fs/xfs/xfs_iomap.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_iomap.c	2007-04-13 13:42:08.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_iomap.c	2007-04-13 13:42:23.000000000 +0200
@@ -820,7 +820,7 @@ xfs_iomap_write_allocate(
 			end_fsb = XFS_B_TO_FSB(mp, ip->i_d.di_size);
 			xfs_bmap_last_offset(NULL, ip, &last_block,
 				XFS_DATA_FORK);
-			last_block = XFS_FILEOFF_MAX(last_block, end_fsb);
+			last_block = max_t(xfs_fileoff_t, last_block, end_fsb);
 			if ((map_start_fsb + count_fsb) > last_block) {
 				count_fsb = last_block - map_start_fsb;
 				if (count_fsb == 0) {
