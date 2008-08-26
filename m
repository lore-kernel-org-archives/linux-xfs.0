Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Aug 2008 19:19:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7Q2JSN1015438
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 19:19:30 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id MAA13883 for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 12:20:51 +1000
Date: Tue, 26 Aug 2008 12:21:54 +1000
Subject: REVIEW: Remove convert_extent function in xfs_repair
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.ugg16sju3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

It seems convert_extent is not that useful, so remove it and call
libxfs_bmbt_disk_get_all() directly and use the xfs_bmbt_irec_t
structure directly.

---
  xfsprogs/repair/dinode.c   |  239  
+++++++++++++++++++--------------------------
  xfsprogs/repair/prefetch.c |   33 +++---
  2 files changed, 122 insertions(+), 150 deletions(-)

Index: repair/xfsprogs/repair/dinode.c
===================================================================
--- repair.orig/xfsprogs/repair/dinode.c
+++ repair/xfsprogs/repair/dinode.c
@@ -455,35 +455,6 @@ verify_agbno(xfs_mount_t	*mp,
  	return verify_ag_bno(sbp, agno, agbno) == 0;
  }

-void
-convert_extent(
-	xfs_bmbt_rec_32_t	*rp,
-	xfs_dfiloff_t		*op,	/* starting offset (blockno in file) */
-	xfs_dfsbno_t		*sp,	/* starting block (fs blockno) */
-	xfs_dfilblks_t		*cp,	/* blockcount */
-	int			*fp)	/* extent flag */
-{
-	xfs_bmbt_irec_t irec, *s = &irec;
-	xfs_bmbt_rec_t rpcopy, *p = &rpcopy;
-
-	memcpy(&rpcopy, rp, sizeof(rpcopy));
-	/* Just use the extent parsing routine from the kernel */
-	libxfs_bmbt_disk_get_all(p, s);
-
-	if (fs_has_extflgbit)  {
-		if (s->br_state == XFS_EXT_UNWRITTEN) {
-			*fp = 1;
-		} else {
-			*fp = 0;
-		}
-	} else  {
-		*fp = 0;
-	}
-	*op = s->br_startoff;
-	*sp = s->br_startblock;
-	*cp = s->br_blockcount;
-}
-
  /*
   * return address of block fblock if it's within the range described
   * by the extent list.  Otherwise, returns a null address.
@@ -492,20 +463,18 @@ convert_extent(
  xfs_dfsbno_t
  get_bmbt_reclist(
  	xfs_mount_t		*mp,
-	xfs_bmbt_rec_32_t	*rp,
+	xfs_bmbt_rec_t		*rp,
  	int			numrecs,
  	xfs_dfiloff_t		fblock)
  {
  	int			i;
-	xfs_dfilblks_t		cnt;
-	xfs_dfiloff_t		off_bno;
-	xfs_dfsbno_t		start;
-	int			flag;
+	xfs_bmbt_irec_t 	irec;

  	for (i = 0; i < numrecs; i++, rp++) {
-		convert_extent(rp, &off_bno, &start, &cnt, &flag);
-		if (off_bno >= fblock && off_bno + cnt < fblock)
-			return(start + fblock - off_bno);
+		libxfs_bmbt_disk_get_all(rp, &irec);
+		if (irec.br_startoff >= fblock &&
+				irec.br_startoff + irec.br_blockcount < fblock)
+			return (irec.br_startblock + fblock - irec.br_startoff);
  	}

  	return(NULLDFSBNO);
@@ -515,39 +484,36 @@ get_bmbt_reclist(
  static int
  process_rt_rec(
  	xfs_mount_t		*mp,
-	xfs_bmbt_rec_32_t	*rp,
+	xfs_bmbt_irec_t 	*irec,
  	xfs_ino_t		ino,
  	xfs_drfsbno_t		*tot,
  	int			check_dups)
  {
  	xfs_dfsbno_t		b;
  	xfs_drtbno_t		ext;
-	xfs_dfilblks_t		c;		/* count */
-	xfs_dfsbno_t		s;		/* start */
-	xfs_dfiloff_t		o;		/* offset */
  	int			state;
-	int			flag;		/* extent flag */
  	int			pwe;		/* partially-written extent */

-	convert_extent(rp, &o, &s, &c, &flag);
-
  	/*
  	 * check numeric validity of the extent
  	 */
-	if (s >= mp->m_sb.sb_rblocks)  {
+	if (irec->br_startblock >= mp->m_sb.sb_rblocks) {
  		do_warn(_("inode %llu - bad rt extent start block number "
-				"%llu, offset %llu\n"), ino, s, o);
+				"%llu, offset %llu\n"), ino,
+				irec->br_startblock, irec->br_startoff);
  		return 1;
  	}
-	if (s + c - 1 >= mp->m_sb.sb_rblocks)  {
+	if (irec->br_startblock + irec->br_blockcount - 1 >=  
mp->m_sb.sb_rblocks) {
  		do_warn(_("inode %llu - bad rt extent last block number %llu, "
-				"offset %llu\n"), ino, s + c - 1, o);
+				"offset %llu\n"), ino, irec->br_startblock +
+				irec->br_blockcount - 1, irec->br_startoff);
  		return 1;
  	}
-	if (s + c - 1 < s)  {
+	if (irec->br_startblock + irec->br_blockcount - 1 < irec->br_startblock)  
{
  		do_warn(_("inode %llu - bad rt extent overflows - start %llu, "
-				"end %llu, offset %llu\n"),
-				ino, s, s + c - 1, o);
+				"end %llu, offset %llu\n"), ino,
+				irec->br_startblock, irec->br_startblock +
+				irec->br_blockcount - 1, irec->br_startoff);
  		return 1;
  	}

@@ -556,19 +522,22 @@ process_rt_rec(
  	 * are multiples of an extent
  	 */
  	if (XFS_SB_VERSION_HASEXTFLGBIT(&mp->m_sb) == 0 &&
-			(s % mp->m_sb.sb_rextsize != 0 ||
-			 c % mp->m_sb.sb_rextsize != 0)) {
+			(irec->br_startblock % mp->m_sb.sb_rextsize != 0 ||
+			 irec->br_blockcount % mp->m_sb.sb_rextsize != 0)) {
  		do_warn(_("malformed rt inode extent [%llu %llu] (fs rtext "
-				"size = %u)\n"), s, c, mp->m_sb.sb_rextsize);
+				"size = %u)\n"), irec->br_startblock,
+				irec->br_blockcount, mp->m_sb.sb_rextsize);
  		return 1;
  	}

  	/*
  	 * set the appropriate number of extents
  	 */
-	for (b = s; b < s + c; b += mp->m_sb.sb_rextsize)  {
+	for (b = irec->br_startblock; b < irec->br_startblock +
+			irec->br_blockcount; b += mp->m_sb.sb_rextsize)  {
  		ext = (xfs_drtbno_t) b / mp->m_sb.sb_rextsize;
-		pwe = XFS_SB_VERSION_HASEXTFLGBIT(&mp->m_sb) && flag &&
+		pwe = XFS_SB_VERSION_HASEXTFLGBIT(&mp->m_sb) &&
+				irec->br_state == XFS_EXT_UNWRITTEN &&
  				(b % mp->m_sb.sb_rextsize != 0);

  		if (check_dups == 1)  {
@@ -576,7 +545,9 @@ process_rt_rec(
  				do_warn(_("data fork in rt ino %llu claims "
  						"dup rt extent, off - %llu, "
  						"start - %llu, count %llu\n"),
-						ino, o, s, c);
+						ino, irec->br_startoff,
+						irec->br_startblock,
+						irec->br_blockcount);
  				return 1;
  			}
  			continue;
@@ -598,8 +569,8 @@ process_rt_rec(
  			case XR_E_INO:
  			case XR_E_INUSE_FS:
  				do_error(_("data fork in rt inode %llu found "
-						"metadata block %llu in rt bmap\n"),
-						ino, ext);
+					"metadata block %llu in rt bmap\n"),
+					ino, ext);

  			case XR_E_INUSE:
  				if (pwe)
@@ -622,7 +593,7 @@ process_rt_rec(
  	/*
  	 * bump up the block counter
  	 */
-	*tot += c;
+	*tot += irec->br_blockcount;

  	return 0;
  }
@@ -638,7 +609,7 @@ process_rt_rec(
  int
  process_bmbt_reclist_int(
  	xfs_mount_t		*mp,
-	xfs_bmbt_rec_32_t	*rp,
+	xfs_bmbt_rec_t		*rp,
  	int			numrecs,
  	int			type,
  	xfs_ino_t		ino,
@@ -649,18 +620,15 @@ process_bmbt_reclist_int(
  	int			check_dups,
  	int			whichfork)
  {
-	xfs_dfsbno_t		b;
-	xfs_dfilblks_t		c;		/* count */
+	xfs_bmbt_irec_t		irec;
  	xfs_dfilblks_t		cp = 0;		/* prev count */
-	xfs_dfsbno_t		s;		/* start */
  	xfs_dfsbno_t		sp = 0;		/* prev start */
-	xfs_dfiloff_t		o = 0;		/* offset */
  	xfs_dfiloff_t		op = 0;		/* prev offset */
+	xfs_dfsbno_t		b;
  	char			*ftype;
  	char			*forkname;
  	int			i;
  	int			state;
-	int			flag;		/* extent flag */
  	xfs_dfsbno_t		e;
  	xfs_agnumber_t		agno;
  	xfs_agblock_t		agbno;
@@ -678,27 +646,29 @@ process_bmbt_reclist_int(
  		ftype = _("regular");

  	for (i = 0; i < numrecs; i++, rp++) {
-		convert_extent(rp, &o, &s, &c, &flag);
+		libxfs_bmbt_disk_get_all(rp, &irec);
  		if (i == 0)
-			*last_key = *first_key = o;
+			*last_key = *first_key = irec.br_startoff;
  		else
-			*last_key = o;
-		if (i > 0 && op + cp > o)  {
+			*last_key = irec.br_startoff;
+		if (i > 0 && op + cp > irec.br_startoff)  {
  			do_warn(_("bmap rec out of order, inode %llu entry %d "
  	  			"[o s c] [%llu %llu %llu], %d [%llu %llu %llu]\n"),
-				ino, i, o, s, c, i-1, op, sp, cp);
+				ino, i, irec.br_startoff, irec.br_startblock,
+				irec.br_blockcount, i - 1, op, sp, cp);
  			goto done;
  		}
-		op = o;
-		cp = c;
-		sp = s;
+		op = irec.br_startoff;
+		cp = irec.br_blockcount;
+		sp = irec.br_startblock;

  		/*
  		 * check numeric validity of the extent
  		 */
-		if (c == 0)  {
-			do_warn(_("zero length extent (off = %llu, "
-				"fsbno = %llu) in ino %llu\n"), o, s, ino);
+		if (irec.br_blockcount == 0)  {
+			do_warn(_("zero length extent (off = %llu, fsbno = "
+				"%llu) in ino %llu\n"), irec.br_startoff,
+				irec.br_startblock, ino);
  			goto done;
  		}

@@ -707,10 +677,10 @@ process_bmbt_reclist_int(
  			 * realtime bitmaps don't use AG locks, so returning
  			 * immediately is fine for this code path.
  			 */
-			if (process_rt_rec(mp, rp, ino, tot, check_dups))
+			if (process_rt_rec(mp, &irec, ino, tot, check_dups))
  				return 1;
  			/*
-			 * skip rest of loop processing since that's
+			 * skip rest of loop processing since that'irec.br_startblock
  			 * all for regular file forks and attr forks
  			 */
  			continue;
@@ -719,44 +689,51 @@ process_bmbt_reclist_int(
  		/*
  		 * regular file data fork or attribute fork
  		 */
-		switch (verify_dfsbno_range(mp, s, c)) {
+		switch (verify_dfsbno_range(mp, irec.br_startblock,
+						irec.br_blockcount)) {
  			case XR_DFSBNORANGE_VALID:
  				break;

  			case XR_DFSBNORANGE_BADSTART:
  				do_warn(_("inode %llu - bad extent starting "
  					"block number %llu, offset %llu\n"),
-					ino, s, o);
+					ino, irec.br_startblock,
+					irec.br_startoff);
  				goto done;

  			case XR_DFSBNORANGE_BADEND:
  				do_warn(_("inode %llu - bad extent last block "
-					"number %llu, offset %llu\n"),
-					ino, s + c - 1, o);
+					"number %llu, offset %llu\n"), ino,
+					irec.br_startblock + irec.br_blockcount
+					- 1, irec.br_startoff);
  				goto done;

  			case XR_DFSBNORANGE_OVERFLOW:
  				do_warn(_("inode %llu - bad extent overflows - "
  					"start %llu, end %llu, offset %llu\n"),
-					ino, s, s + c - 1, o);
+					ino, irec.br_startblock,
+					irec.br_startblock + irec.br_blockcount
+					- 1, irec.br_startoff);
  				goto done;
  		}
-		if (o >= fs_max_file_offset)  {
+		if (irec.br_startoff >= fs_max_file_offset)  {
  			do_warn(_("inode %llu - extent offset too large - "
  				"start %llu, count %llu, offset %llu\n"),
-				ino, s, c, o);
+				ino, irec.br_startblock, irec.br_blockcount,
+				irec.br_startoff);
  			goto done;
  		}

  		if (blkmapp && *blkmapp)
-			blkmap_set_ext(blkmapp, o, s, c);
+			blkmap_set_ext(blkmapp, irec.br_startoff,
+					irec.br_startblock, irec.br_blockcount);
  		/*
  		 * Profiling shows that the following loop takes the
  		 * most time in all of xfs_repair.
  		 */
-		agno = XFS_FSB_TO_AGNO(mp, s);
-		agbno = XFS_FSB_TO_AGBNO(mp, s);
-		e = s + c;
+		agno = XFS_FSB_TO_AGNO(mp, irec.br_startblock);
+		agbno = XFS_FSB_TO_AGBNO(mp, irec.br_startblock);
+		e = irec.br_startblock + irec.br_blockcount;
  		if (agno != locked_agno) {
  			if (locked_agno != -1)
  				pthread_mutex_unlock(&ag_locks[locked_agno]);
@@ -771,25 +748,27 @@ process_bmbt_reclist_int(
  			 * checking each entry without setting the
  			 * block bitmap
  			 */
-			for (b = s; b < e; b++, agbno++)  {
+			for (b = irec.br_startblock; b < e; b++, agbno++)  {
  				if (search_dup_extent(mp, agno, agbno)) {
  					do_warn(_("%s fork in ino %llu claims "
  						"dup extent, off - %llu, "
  						"start - %llu, cnt %llu\n"),
-						forkname, ino, o, s, c);
+						forkname, ino, irec.br_startoff,
+						irec.br_startblock,
+						irec.br_blockcount);
  					goto done;
  				}
  			}
-			*tot += c;
+			*tot += irec.br_blockcount;
  			continue;
  		}

-		for (b = s; b < e; b++, agbno++)  {
+		for (b = irec.br_startblock; b < e; b++, agbno++)  {
  			/*
  			 * Process in chunks of 16 (XR_BB_UNIT/XR_BB)
  			 * for common XR_E_UNKNOWN to XR_E_INUSE transition
  			 */
-			if (((agbno & XR_BB_MASK) == 0) && ((s + c - b) >=  
(XR_BB_UNIT/XR_BB))) {
+			if (((agbno & XR_BB_MASK) == 0) && ((irec.br_startblock +  
irec.br_blockcount - b) >= (XR_BB_UNIT/XR_BB))) {
  				if (ba_bmap[agno][agbno>>XR_BB] == XR_E_UNKNOWN_LL) {
  					ba_bmap[agno][agbno>>XR_BB] = XR_E_INUSE_LL;
  					agbno += (XR_BB_UNIT/XR_BB) - 1;
@@ -836,7 +815,7 @@ process_bmbt_reclist_int(
  					state, b);
  			}
  		}
-		*tot += c;
+		*tot += irec.br_blockcount;
  	}
  	error = 0;
  done:
@@ -862,9 +841,9 @@ process_bmbt_reclist(
  	xfs_dfiloff_t		*last_key,
  	int			whichfork)
  {
-	return(process_bmbt_reclist_int(mp, rp, numrecs, type, ino, tot,
-					blkmapp, first_key, last_key, 0,
-					whichfork));
+	return(process_bmbt_reclist_int(mp, (xfs_bmbt_rec_t *)rp, numrecs, type,
+					ino, tot, blkmapp, first_key, last_key,
+					0, whichfork));
  }

  /*
@@ -884,9 +863,9 @@ scan_bmbt_reclist(
  	xfs_dfiloff_t		first_key = 0;
  	xfs_dfiloff_t		last_key = 0;

-	return(process_bmbt_reclist_int(mp, rp, numrecs, type, ino, tot,
-					NULL, &first_key, &last_key, 1,
-					whichfork));
+	return(process_bmbt_reclist_int(mp, (xfs_bmbt_rec_t *)rp, numrecs, type,
+					ino, tot, NULL, &first_key, &last_key,
+					1, whichfork));
  }

  /*
@@ -943,21 +922,18 @@ getfunc_extlist(xfs_mount_t		*mp,
  		xfs_dfiloff_t		bno,
  		int			whichfork)
  {
-	xfs_dfiloff_t		fbno;
-	xfs_dfilblks_t		bcnt;
-	xfs_dfsbno_t		fsbno;
+	xfs_bmbt_irec_t		irec;
  	xfs_dfsbno_t		final_fsbno = NULLDFSBNO;
-	xfs_bmbt_rec_32_t	*rootblock = (xfs_bmbt_rec_32_t *)
+	xfs_bmbt_rec_t		*rootblock = (xfs_bmbt_rec_t *)
  						XFS_DFORK_PTR(dip, whichfork);
  	xfs_extnum_t		nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
  	int			i;
-	int			flag;

  	for (i = 0; i < nextents; i++)  {
-		convert_extent(rootblock + i, &fbno, &fsbno, &bcnt, &flag);
-
-		if (fbno <= bno && bno < fbno + bcnt)  {
-			final_fsbno = bno - fbno + fsbno;
+		libxfs_bmbt_disk_get_all(rootblock + i, &irec);
+		if (irec.br_startoff <= bno &&
+				bno < irec.br_startoff + irec.br_blockcount) {
+			final_fsbno = bno - irec.br_startoff + irec.br_startblock;
  			break;
  		}
  	}
@@ -976,16 +952,14 @@ getfunc_btree(xfs_mount_t		*mp,
  #ifdef DEBUG
  	int			prev_level;
  #endif
-	int			flag;
  	int			found;
-	xfs_bmbt_rec_32_t	*rec;
+	xfs_bmbt_rec_t		*rec;
+	xfs_bmbt_irec_t		irec;
  	xfs_bmbt_ptr_t		*pp;
  	xfs_bmbt_key_t		*key;
  	xfs_bmdr_key_t		*rkey;
  	xfs_bmdr_ptr_t		*rp;
-	xfs_dfiloff_t		fbno;
  	xfs_dfsbno_t		fsbno;
-	xfs_dfilblks_t		bcnt;
  	xfs_buf_t		*bp;
  	xfs_dfsbno_t		final_fsbno = NULLDFSBNO;
  	xfs_bmbt_block_t	*block;
@@ -1120,13 +1094,13 @@ getfunc_btree(xfs_mount_t		*mp,
  			ino, INT_GET(block->bb_numrecs, ARCH_CONVERT),
  			mp->m_bmap_dmnr[0]);

-	rec = (xfs_bmbt_rec_32_t *)XFS_BTREE_REC_ADDR(mp->m_sb.sb_blocksize,
-		xfs_bmbt, block, 1, mp->m_bmap_dmxr[0]);
+	rec = XFS_BTREE_REC_ADDR(mp->m_sb.sb_blocksize, xfs_bmbt, block, 1,
+			mp->m_bmap_dmxr[0]);
  	for (i = 0; i < INT_GET(block->bb_numrecs, ARCH_CONVERT); i++)  {
-		convert_extent(rec + i, &fbno, &fsbno, &bcnt, &flag);
-
-		if (fbno <= bno && bno < fbno + bcnt)  {
-			final_fsbno = bno - fbno + fsbno;
+		libxfs_bmbt_disk_get_all(rec + i, &irec);
+		if (irec.br_startoff <= bno &&
+				bno < irec.br_startoff + irec.br_blockcount) {
+			final_fsbno = bno - irec.br_startoff + irec.br_startblock;
  			break;
  		}
  	}
@@ -1464,16 +1438,13 @@ process_lclinode(
  int
  process_symlink_extlist(xfs_mount_t *mp, xfs_ino_t lino, xfs_dinode_t  
*dino)
  {
-	xfs_dfsbno_t		start;		/* start */
-	xfs_dfilblks_t		cnt;		/* count */
-	xfs_dfiloff_t		offset;		/* offset */
  	xfs_dfiloff_t		expected_offset;
-	xfs_bmbt_rec_32_t	*rp;
+	xfs_bmbt_rec_t		*rp;
+	xfs_bmbt_irec_t		irec;
  	int			numrecs;
  	int			i;
  	int			max_blocks;
  	int			whichfork = XFS_DATA_FORK;
-	int			flag;

  	if (INT_GET(dino->di_core.di_size, ARCH_CONVERT) <=
  	    XFS_DFORK_SIZE(dino, mp, whichfork))  {
@@ -1496,7 +1467,7 @@ process_symlink_extlist(xfs_mount_t *mp,
  		return(1);
  	}

-	rp = (xfs_bmbt_rec_32_t *)XFS_DFORK_PTR(dino, whichfork);
+	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dino, whichfork);
  	numrecs = XFS_DFORK_NEXTENTS(dino, whichfork);

  	/*
@@ -1514,23 +1485,23 @@ process_symlink_extlist(xfs_mount_t *mp,
  	expected_offset = 0;

  	for (i = 0; numrecs > 0; i++, numrecs--)  {
-		convert_extent(rp, &offset, &start, &cnt, &flag);
+		libxfs_bmbt_disk_get_all(rp, &irec);

-		if (offset != expected_offset)  {
+		if (irec.br_startoff != expected_offset)  {
  			do_warn(
  		_("bad extent #%d offset (%llu) in symlink %llu data fork\n"),
-				i, offset, lino);
+				i, irec.br_startoff, lino);
  			return(1);
  		}
-		if (cnt == 0 || cnt > max_blocks)  {
+		if (irec.br_blockcount == 0 || irec.br_blockcount > max_blocks) {
  			do_warn(
  		_("bad extent #%d count (%llu) in symlink %llu data fork\n"),
-				i, cnt, lino);
+				i, irec.br_blockcount, lino);
  			return(1);
  		}

-		max_blocks -= cnt;
-		expected_offset += cnt;
+		max_blocks -= irec.br_blockcount;
+		expected_offset += irec.br_blockcount;
  	}

  	return(0);
Index: repair/xfsprogs/repair/prefetch.c
===================================================================
--- repair.orig/xfsprogs/repair/prefetch.c
+++ repair/xfsprogs/repair/prefetch.c
@@ -152,38 +152,39 @@ pf_read_bmbt_reclist(
  	int			numrecs)
  {
  	int			i;
-	xfs_dfsbno_t		s;		/* start */
-	xfs_dfilblks_t		c;		/* count */
-	xfs_dfiloff_t		o;		/* offset */
+	xfs_bmbt_irec_t		irec;
  	xfs_dfilblks_t		cp = 0;		/* prev count */
  	xfs_dfiloff_t		op = 0;		/* prev offset */
-	int			flag;		/* extent flag */

  	for (i = 0; i < numrecs; i++, rp++) {
-		convert_extent((xfs_bmbt_rec_32_t*)rp, &o, &s, &c, &flag);
+		libxfs_bmbt_disk_get_all(rp, &irec);

-		if (((i > 0) && (op + cp > o)) || (c == 0) ||
-				(o >= fs_max_file_offset))
+		if (((i > 0) && (op + cp > irec.br_startoff)) ||
+				(irec.br_blockcount == 0) ||
+				(irec.br_startoff >= fs_max_file_offset))
  			return 0;

-		if (!verify_dfsbno(mp, s) || !verify_dfsbno(mp, s + c - 1))
+		if (!verify_dfsbno(mp, irec.br_startblock) || !verify_dfsbno(mp,
+				irec.br_startblock + irec.br_blockcount - 1))
  			return 0;

-		if (!args->dirs_only && ((o + c) >= mp->m_dirfreeblk))
+		if (!args->dirs_only && ((irec.br_startoff +
+				irec.br_blockcount) >= mp->m_dirfreeblk))
  			break;	/* only Phase 6 reads the free blocks */

-		op = o;
-		cp = c;
+		op = irec.br_startoff;
+		cp = irec.br_blockcount;

-		while (c) {
+		while (irec.br_blockcount) {
  			unsigned int	len;
  #ifdef XR_PF_TRACE
  			pftrace("queuing dir extent in AG %d", args->agno);
  #endif
-			len = (c > mp->m_dirblkfsbs) ? mp->m_dirblkfsbs : c;
-			pf_queue_io(args, s, len, B_DIR_META);
-			c -= len;
-			s += len;
+			len = (irec.br_blockcount > mp->m_dirblkfsbs) ?
+					mp->m_dirblkfsbs : irec.br_blockcount;
+			pf_queue_io(args, irec.br_startblock, len, B_DIR_META);
+			irec.br_blockcount -= len;
+			irec.br_startblock += len;
  		}
  	}
  	return 1;
