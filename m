Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 92B967F37
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 10:46:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 31BCB304039
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 08:46:08 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id ioTbLFSDgPZhlFpc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 08:46:04 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1Vh03P-0003Y8-OV
	for xfs@oss.sgi.com; Thu, 14 Nov 2013 16:46:03 +0000
Date: Thu, 14 Nov 2013 08:46:03 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: require 64-bit sector_t
Message-ID: <20131114164603.GA13628@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Trying to support tiny disks only and saving a bit memory might have
made sense on an SGI O2 15 years ago, but is pretty pointless today.

Remove the rarely tested codepath that uses various smaller in-memory
types to reduce our test matrix and make the codebase a little bit
smaller and less complicated.


Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 399e8ce..5d47b4d 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -1,6 +1,7 @@
 config XFS_FS
 	tristate "XFS filesystem support"
 	depends on BLOCK
+	depends on (64BIT || LBDAF)
 	select EXPORTFS
 	select LIBCRC32C
 	help
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 1c02da8..b0eccfc 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -393,7 +393,7 @@ xfs_bmap_check_leaf_extents(
 	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
 	bno = be64_to_cpu(*pp);
 
-	ASSERT(bno != NULLDFSBNO);
+	ASSERT(bno != NULLFSBLOCK);
 	ASSERT(XFS_FSB_TO_AGNO(mp, bno) < mp->m_sb.sb_agcount);
 	ASSERT(XFS_FSB_TO_AGBNO(mp, bno) < mp->m_sb.sb_agblocks);
 
@@ -1295,7 +1295,7 @@ xfs_bmap_read_extents(
 	ASSERT(level > 0);
 	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
 	bno = be64_to_cpu(*pp);
-	ASSERT(bno != NULLDFSBNO);
+	ASSERT(bno != NULLFSBLOCK);
 	ASSERT(XFS_FSB_TO_AGNO(mp, bno) < mp->m_sb.sb_agcount);
 	ASSERT(XFS_FSB_TO_AGBNO(mp, bno) < mp->m_sb.sb_agblocks);
 	/*
@@ -1425,11 +1425,7 @@ xfs_bmap_search_multi_extents(
 	gotp->br_startoff = 0xffa5a5a5a5a5a5a5LL;
 	gotp->br_blockcount = 0xa55a5a5a5a5a5a5aLL;
 	gotp->br_state = XFS_EXT_INVALID;
-#if XFS_BIG_BLKNOS
 	gotp->br_startblock = 0xffffa5a5a5a5a5a5LL;
-#else
-	gotp->br_startblock = 0xffffa5a5;
-#endif
 	prevp->br_startoff = NULLFILEOFF;
 
 	ep = xfs_iext_bno_to_ext(ifp, bno, &lastx);
diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index 706bc3f..9c05b00 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -111,23 +111,8 @@ __xfs_bmbt_get_all(
 	ext_flag = (int)(l0 >> (64 - BMBT_EXNTFLAG_BITLEN));
 	s->br_startoff = ((xfs_fileoff_t)l0 &
 			   xfs_mask64lo(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
-#if XFS_BIG_BLKNOS
 	s->br_startblock = (((xfs_fsblock_t)l0 & xfs_mask64lo(9)) << 43) |
 			   (((xfs_fsblock_t)l1) >> 21);
-#else
-#ifdef DEBUG
-	{
-		xfs_dfsbno_t	b;
-
-		b = (((xfs_dfsbno_t)l0 & xfs_mask64lo(9)) << 43) |
-		    (((xfs_dfsbno_t)l1) >> 21);
-		ASSERT((b >> 32) == 0 || isnulldstartblock(b));
-		s->br_startblock = (xfs_fsblock_t)b;
-	}
-#else	/* !DEBUG */
-	s->br_startblock = (xfs_fsblock_t)(((xfs_dfsbno_t)l1) >> 21);
-#endif	/* DEBUG */
-#endif	/* XFS_BIG_BLKNOS */
 	s->br_blockcount = (xfs_filblks_t)(l1 & xfs_mask64lo(21));
 	/* This is xfs_extent_state() in-line */
 	if (ext_flag) {
@@ -163,21 +148,8 @@ xfs_fsblock_t
 xfs_bmbt_get_startblock(
 	xfs_bmbt_rec_host_t	*r)
 {
-#if XFS_BIG_BLKNOS
 	return (((xfs_fsblock_t)r->l0 & xfs_mask64lo(9)) << 43) |
 	       (((xfs_fsblock_t)r->l1) >> 21);
-#else
-#ifdef DEBUG
-	xfs_dfsbno_t	b;
-
-	b = (((xfs_dfsbno_t)r->l0 & xfs_mask64lo(9)) << 43) |
-	    (((xfs_dfsbno_t)r->l1) >> 21);
-	ASSERT((b >> 32) == 0 || isnulldstartblock(b));
-	return (xfs_fsblock_t)b;
-#else	/* !DEBUG */
-	return (xfs_fsblock_t)(((xfs_dfsbno_t)r->l1) >> 21);
-#endif	/* DEBUG */
-#endif	/* XFS_BIG_BLKNOS */
 }
 
 /*
@@ -241,7 +213,6 @@ xfs_bmbt_set_allf(
 	ASSERT((startoff & xfs_mask64hi(64-BMBT_STARTOFF_BITLEN)) == 0);
 	ASSERT((blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
 
-#if XFS_BIG_BLKNOS
 	ASSERT((startblock & xfs_mask64hi(64-BMBT_STARTBLOCK_BITLEN)) == 0);
 
 	r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
@@ -250,23 +221,6 @@ xfs_bmbt_set_allf(
 	r->l1 = ((xfs_bmbt_rec_base_t)startblock << 21) |
 		((xfs_bmbt_rec_base_t)blockcount &
 		(xfs_bmbt_rec_base_t)xfs_mask64lo(21));
-#else	/* !XFS_BIG_BLKNOS */
-	if (isnullstartblock(startblock)) {
-		r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
-			((xfs_bmbt_rec_base_t)startoff << 9) |
-			 (xfs_bmbt_rec_base_t)xfs_mask64lo(9);
-		r->l1 = xfs_mask64hi(11) |
-			  ((xfs_bmbt_rec_base_t)startblock << 21) |
-			  ((xfs_bmbt_rec_base_t)blockcount &
-			   (xfs_bmbt_rec_base_t)xfs_mask64lo(21));
-	} else {
-		r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
-			((xfs_bmbt_rec_base_t)startoff << 9);
-		r->l1 = ((xfs_bmbt_rec_base_t)startblock << 21) |
-			 ((xfs_bmbt_rec_base_t)blockcount &
-			 (xfs_bmbt_rec_base_t)xfs_mask64lo(21));
-	}
-#endif	/* XFS_BIG_BLKNOS */
 }
 
 /*
@@ -298,8 +252,6 @@ xfs_bmbt_disk_set_allf(
 	ASSERT(state == XFS_EXT_NORM || state == XFS_EXT_UNWRITTEN);
 	ASSERT((startoff & xfs_mask64hi(64-BMBT_STARTOFF_BITLEN)) == 0);
 	ASSERT((blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
-
-#if XFS_BIG_BLKNOS
 	ASSERT((startblock & xfs_mask64hi(64-BMBT_STARTBLOCK_BITLEN)) == 0);
 
 	r->l0 = cpu_to_be64(
@@ -310,26 +262,6 @@ xfs_bmbt_disk_set_allf(
 		((xfs_bmbt_rec_base_t)startblock << 21) |
 		 ((xfs_bmbt_rec_base_t)blockcount &
 		  (xfs_bmbt_rec_base_t)xfs_mask64lo(21)));
-#else	/* !XFS_BIG_BLKNOS */
-	if (isnullstartblock(startblock)) {
-		r->l0 = cpu_to_be64(
-			((xfs_bmbt_rec_base_t)extent_flag << 63) |
-			 ((xfs_bmbt_rec_base_t)startoff << 9) |
-			  (xfs_bmbt_rec_base_t)xfs_mask64lo(9));
-		r->l1 = cpu_to_be64(xfs_mask64hi(11) |
-			  ((xfs_bmbt_rec_base_t)startblock << 21) |
-			  ((xfs_bmbt_rec_base_t)blockcount &
-			   (xfs_bmbt_rec_base_t)xfs_mask64lo(21)));
-	} else {
-		r->l0 = cpu_to_be64(
-			((xfs_bmbt_rec_base_t)extent_flag << 63) |
-			 ((xfs_bmbt_rec_base_t)startoff << 9));
-		r->l1 = cpu_to_be64(
-			((xfs_bmbt_rec_base_t)startblock << 21) |
-			 ((xfs_bmbt_rec_base_t)blockcount &
-			  (xfs_bmbt_rec_base_t)xfs_mask64lo(21)));
-	}
-#endif	/* XFS_BIG_BLKNOS */
 }
 
 /*
@@ -365,24 +297,11 @@ xfs_bmbt_set_startblock(
 	xfs_bmbt_rec_host_t *r,
 	xfs_fsblock_t	v)
 {
-#if XFS_BIG_BLKNOS
 	ASSERT((v & xfs_mask64hi(12)) == 0);
 	r->l0 = (r->l0 & (xfs_bmbt_rec_base_t)xfs_mask64hi(55)) |
 		  (xfs_bmbt_rec_base_t)(v >> 43);
 	r->l1 = (r->l1 & (xfs_bmbt_rec_base_t)xfs_mask64lo(21)) |
 		  (xfs_bmbt_rec_base_t)(v << 21);
-#else	/* !XFS_BIG_BLKNOS */
-	if (isnullstartblock(v)) {
-		r->l0 |= (xfs_bmbt_rec_base_t)xfs_mask64lo(9);
-		r->l1 = (xfs_bmbt_rec_base_t)xfs_mask64hi(11) |
-			  ((xfs_bmbt_rec_base_t)v << 21) |
-			  (r->l1 & (xfs_bmbt_rec_base_t)xfs_mask64lo(21));
-	} else {
-		r->l0 &= ~(xfs_bmbt_rec_base_t)xfs_mask64lo(9);
-		r->l1 = ((xfs_bmbt_rec_base_t)v << 21) |
-			  (r->l1 & (xfs_bmbt_rec_base_t)xfs_mask64lo(21));
-	}
-#endif	/* XFS_BIG_BLKNOS */
 }
 
 /*
@@ -438,8 +357,8 @@ xfs_bmbt_to_bmdr(
 		       cpu_to_be64(XFS_BUF_DADDR_NULL));
 	} else
 		ASSERT(rblock->bb_magic == cpu_to_be32(XFS_BMAP_MAGIC));
-	ASSERT(rblock->bb_u.l.bb_leftsib == cpu_to_be64(NULLDFSBNO));
-	ASSERT(rblock->bb_u.l.bb_rightsib == cpu_to_be64(NULLDFSBNO));
+	ASSERT(rblock->bb_u.l.bb_leftsib == cpu_to_be64(NULLFSBLOCK));
+	ASSERT(rblock->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK));
 	ASSERT(rblock->bb_level != 0);
 	dblock->bb_level = rblock->bb_level;
 	dblock->bb_numrecs = rblock->bb_numrecs;
@@ -765,11 +684,11 @@ xfs_bmbt_verify(
 
 	/* sibling pointer verification */
 	if (!block->bb_u.l.bb_leftsib ||
-	    (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLDFSBNO) &&
+	    (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK) &&
 	     !XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_u.l.bb_leftsib))))
 		return false;
 	if (!block->bb_u.l.bb_rightsib ||
-	    (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLDFSBNO) &&
+	    (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK) &&
 	     !XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_u.l.bb_rightsib))))
 		return false;
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 5887e41..699776e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -467,7 +467,7 @@ xfs_bmap_count_blocks(
 	ASSERT(level > 0);
 	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
 	bno = be64_to_cpu(*pp);
-	ASSERT(bno != NULLDFSBNO);
+	ASSERT(bno != NULLFSBLOCK);
 	ASSERT(XFS_FSB_TO_AGNO(mp, bno) < mp->m_sb.sb_agcount);
 	ASSERT(XFS_FSB_TO_AGBNO(mp, bno) < mp->m_sb.sb_agblocks);
 
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 9adaae4..6f217a5 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -76,11 +76,11 @@ xfs_btree_check_lblock(
 		be16_to_cpu(block->bb_numrecs) <=
 			cur->bc_ops->get_maxrecs(cur, level) &&
 		block->bb_u.l.bb_leftsib &&
-		(block->bb_u.l.bb_leftsib == cpu_to_be64(NULLDFSBNO) ||
+		(block->bb_u.l.bb_leftsib == cpu_to_be64(NULLFSBLOCK) ||
 		 XFS_FSB_SANITY_CHECK(mp,
 			be64_to_cpu(block->bb_u.l.bb_leftsib))) &&
 		block->bb_u.l.bb_rightsib &&
-		(block->bb_u.l.bb_rightsib == cpu_to_be64(NULLDFSBNO) ||
+		(block->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK) ||
 		 XFS_FSB_SANITY_CHECK(mp,
 			be64_to_cpu(block->bb_u.l.bb_rightsib)));
 
@@ -165,12 +165,12 @@ xfs_btree_check_block(
 int					/* error (0 or EFSCORRUPTED) */
 xfs_btree_check_lptr(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
-	xfs_dfsbno_t		bno,	/* btree block disk address */
+	xfs_fsblock_t		bno,	/* btree block disk address */
 	int			level)	/* btree block level */
 {
 	XFS_WANT_CORRUPTED_RETURN(
 		level > 0 &&
-		bno != NULLDFSBNO &&
+		bno != NULLFSBLOCK &&
 		XFS_FSB_SANITY_CHECK(cur->bc_mp, bno));
 	return 0;
 }
@@ -601,7 +601,7 @@ xfs_btree_islastblock(
 	block = xfs_btree_get_block(cur, level, &bp);
 	xfs_btree_check_block(cur, block, level, bp);
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
-		return block->bb_u.l.bb_rightsib == cpu_to_be64(NULLDFSBNO);
+		return block->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK);
 	else
 		return block->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK);
 }
@@ -778,16 +778,16 @@ xfs_btree_readahead_lblock(
 	struct xfs_btree_block	*block)
 {
 	int			rval = 0;
-	xfs_dfsbno_t		left = be64_to_cpu(block->bb_u.l.bb_leftsib);
-	xfs_dfsbno_t		right = be64_to_cpu(block->bb_u.l.bb_rightsib);
+	xfs_fsblock_t		left = be64_to_cpu(block->bb_u.l.bb_leftsib);
+	xfs_fsblock_t		right = be64_to_cpu(block->bb_u.l.bb_rightsib);
 
-	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLDFSBNO) {
+	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLFSBLOCK) {
 		xfs_btree_reada_bufl(cur->bc_mp, left, 1,
 				     cur->bc_ops->buf_ops);
 		rval++;
 	}
 
-	if ((lr & XFS_BTCUR_RIGHTRA) && right != NULLDFSBNO) {
+	if ((lr & XFS_BTCUR_RIGHTRA) && right != NULLFSBLOCK) {
 		xfs_btree_reada_bufl(cur->bc_mp, right, 1,
 				     cur->bc_ops->buf_ops);
 		rval++;
@@ -859,7 +859,7 @@ xfs_btree_ptr_to_daddr(
 	union xfs_btree_ptr	*ptr)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		ASSERT(ptr->l != cpu_to_be64(NULLDFSBNO));
+		ASSERT(ptr->l != cpu_to_be64(NULLFSBLOCK));
 
 		return XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->l));
 	} else {
@@ -907,9 +907,9 @@ xfs_btree_setbuf(
 
 	b = XFS_BUF_TO_BLOCK(bp);
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		if (b->bb_u.l.bb_leftsib == cpu_to_be64(NULLDFSBNO))
+		if (b->bb_u.l.bb_leftsib == cpu_to_be64(NULLFSBLOCK))
 			cur->bc_ra[lev] |= XFS_BTCUR_LEFTRA;
-		if (b->bb_u.l.bb_rightsib == cpu_to_be64(NULLDFSBNO))
+		if (b->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK))
 			cur->bc_ra[lev] |= XFS_BTCUR_RIGHTRA;
 	} else {
 		if (b->bb_u.s.bb_leftsib == cpu_to_be32(NULLAGBLOCK))
@@ -925,7 +925,7 @@ xfs_btree_ptr_is_null(
 	union xfs_btree_ptr	*ptr)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
-		return ptr->l == cpu_to_be64(NULLDFSBNO);
+		return ptr->l == cpu_to_be64(NULLFSBLOCK);
 	else
 		return ptr->s == cpu_to_be32(NULLAGBLOCK);
 }
@@ -936,7 +936,7 @@ xfs_btree_set_ptr_null(
 	union xfs_btree_ptr	*ptr)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
-		ptr->l = cpu_to_be64(NULLDFSBNO);
+		ptr->l = cpu_to_be64(NULLFSBLOCK);
 	else
 		ptr->s = cpu_to_be32(NULLAGBLOCK);
 }
@@ -1004,8 +1004,8 @@ xfs_btree_init_block_int(
 	buf->bb_numrecs = cpu_to_be16(numrecs);
 
 	if (flags & XFS_BTREE_LONG_PTRS) {
-		buf->bb_u.l.bb_leftsib = cpu_to_be64(NULLDFSBNO);
-		buf->bb_u.l.bb_rightsib = cpu_to_be64(NULLDFSBNO);
+		buf->bb_u.l.bb_leftsib = cpu_to_be64(NULLFSBLOCK);
+		buf->bb_u.l.bb_rightsib = cpu_to_be64(NULLFSBLOCK);
 		if (flags & XFS_BTREE_CRC_BLOCKS) {
 			buf->bb_u.l.bb_blkno = cpu_to_be64(blkno);
 			buf->bb_u.l.bb_owner = cpu_to_be64(owner);
diff --git a/fs/xfs/xfs_btree.h b/fs/xfs/xfs_btree.h
index 91e34f2..a5f0ee7 100644
--- a/fs/xfs/xfs_btree.h
+++ b/fs/xfs/xfs_btree.h
@@ -255,7 +255,7 @@ xfs_btree_check_block(
 int					/* error (0 or EFSCORRUPTED) */
 xfs_btree_check_lptr(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
-	xfs_dfsbno_t		ptr,	/* btree block disk address */
+	xfs_fsblock_t		ptr,	/* btree block disk address */
 	int			level);	/* btree block level */
 
 /*
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 796272a..6ea2c63 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -2002,7 +2002,7 @@ xfs_da_grow_inode_int(
 	struct xfs_trans	*tp = args->trans;
 	struct xfs_inode	*dp = args->dp;
 	int			w = args->whichfork;
-	xfs_drfsbno_t		nblks = dp->i_d.di_nblocks;
+	xfs_rfsblock_t		nblks = dp->i_d.di_nblocks;
 	struct xfs_bmbt_irec	map, *mapp;
 	int			nmap, error, got, i, mapi;
 
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index aafc6e4..411407d 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -51,10 +51,9 @@ static void xfs_dir2_sf_check(xfs_da_args_t *args);
 #else
 #define	xfs_dir2_sf_check(args)
 #endif /* DEBUG */
-#if XFS_BIG_INUMS
+
 static void xfs_dir2_sf_toino4(xfs_da_args_t *args);
 static void xfs_dir2_sf_toino8(xfs_da_args_t *args);
-#endif /* XFS_BIG_INUMS */
 
 /*
  * Given a block directory (dp/block), calculate its size as a shortform (sf)
@@ -115,10 +114,10 @@ xfs_dir2_block_sfsize(
 		isdotdot =
 			dep->namelen == 2 &&
 			dep->name[0] == '.' && dep->name[1] == '.';
-#if XFS_BIG_INUMS
+
 		if (!isdot)
 			i8count += be64_to_cpu(dep->inumber) > XFS_DIR2_MAX_SHORT_INUM;
-#endif
+
 		/* take into account the file type field */
 		if (!isdot && !isdotdot) {
 			count++;
@@ -309,7 +308,7 @@ xfs_dir2_sf_addname(
 	add_entsize = dp->d_ops->sf_entsize(sfp, args->namelen);
 	incr_isize = add_entsize;
 	objchange = 0;
-#if XFS_BIG_INUMS
+
 	/*
 	 * Do we have to change to 8 byte inodes?
 	 */
@@ -326,7 +325,7 @@ xfs_dir2_sf_addname(
 			 (uint)sizeof(xfs_dir2_ino4_t));
 		objchange = 1;
 	}
-#endif
+
 	old_isize = (int)dp->i_d.di_size;
 	new_isize = old_isize + incr_isize;
 	/*
@@ -365,10 +364,8 @@ xfs_dir2_sf_addname(
 	 */
 	else {
 		ASSERT(pick == 2);
-#if XFS_BIG_INUMS
 		if (objchange)
 			xfs_dir2_sf_toino8(args);
-#endif
 		xfs_dir2_sf_addname_hard(args, objchange, new_isize);
 	}
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
@@ -420,10 +417,8 @@ xfs_dir2_sf_addname_easy(
 	 * Update the header and inode.
 	 */
 	sfp->count++;
-#if XFS_BIG_INUMS
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM)
 		sfp->i8count++;
-#endif
 	dp->i_d.di_size = new_isize;
 	xfs_dir2_sf_check(args);
 }
@@ -511,10 +506,8 @@ xfs_dir2_sf_addname_hard(
 	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
 	dp->d_ops->sf_put_ftype(sfep, args->filetype);
 	sfp->count++;
-#if XFS_BIG_INUMS
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
 		sfp->i8count++;
-#endif
 	/*
 	 * If there's more left to copy, do that.
 	 */
@@ -588,13 +581,8 @@ xfs_dir2_sf_addname_pick(
 	/*
 	 * If changing the inode number size, do it the hard way.
 	 */
-#if XFS_BIG_INUMS
-	if (objchange) {
+	if (objchange)
 		return 2;
-	}
-#else
-	ASSERT(objchange == 0);
-#endif
 	/*
 	 * If it won't fit at the end then do it the hard way (use the hole).
 	 */
@@ -645,7 +633,6 @@ xfs_dir2_sf_check(
 		ASSERT(dp->d_ops->sf_get_ftype(sfep) < XFS_DIR3_FT_MAX);
 	}
 	ASSERT(i8count == sfp->i8count);
-	ASSERT(XFS_BIG_INUMS || i8count == 0);
 	ASSERT((char *)sfep - (char *)sfp == dp->i_d.di_size);
 	ASSERT(offset +
 	       (sfp->count + 2) * (uint)sizeof(xfs_dir2_leaf_entry_t) +
@@ -865,7 +852,6 @@ xfs_dir2_sf_removename(
 	 */
 	xfs_idata_realloc(dp, newsize - oldsize, XFS_DATA_FORK);
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
-#if XFS_BIG_INUMS
 	/*
 	 * Are we changing inode number size?
 	 */
@@ -875,7 +861,6 @@ xfs_dir2_sf_removename(
 		else
 			sfp->i8count--;
 	}
-#endif
 	xfs_dir2_sf_check(args);
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
 	return 0;
@@ -890,12 +875,8 @@ xfs_dir2_sf_replace(
 {
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			i;		/* entry index */
-#if XFS_BIG_INUMS || defined(DEBUG)
 	xfs_ino_t		ino=0;		/* entry old inode number */
-#endif
-#if XFS_BIG_INUMS
 	int			i8elevated;	/* sf_toino8 set i8count=1 */
-#endif
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 
@@ -915,7 +896,7 @@ xfs_dir2_sf_replace(
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
-#if XFS_BIG_INUMS
+
 	/*
 	 * New inode number is large, and need to convert to 8-byte inodes.
 	 */
@@ -946,17 +927,15 @@ xfs_dir2_sf_replace(
 		sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	} else
 		i8elevated = 0;
-#endif
+
 	ASSERT(args->namelen != 1 || args->name[0] != '.');
 	/*
 	 * Replace ..'s entry.
 	 */
 	if (args->namelen == 2 &&
 	    args->name[0] == '.' && args->name[1] == '.') {
-#if XFS_BIG_INUMS || defined(DEBUG)
 		ino = dp->d_ops->sf_get_parent_ino(sfp);
 		ASSERT(args->inumber != ino);
-#endif
 		dp->d_ops->sf_put_parent_ino(sfp, args->inumber);
 	}
 	/*
@@ -967,10 +946,8 @@ xfs_dir2_sf_replace(
 		     i++, sfep = dp->d_ops->sf_nextentry(sfp, sfep)) {
 			if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
 								XFS_CMP_EXACT) {
-#if XFS_BIG_INUMS || defined(DEBUG)
 				ino = dp->d_ops->sf_get_ino(sfp, sfep);
 				ASSERT(args->inumber != ino);
-#endif
 				dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
 				dp->d_ops->sf_put_ftype(sfep, args->filetype);
 				break;
@@ -981,14 +958,11 @@ xfs_dir2_sf_replace(
 		 */
 		if (i == sfp->count) {
 			ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
-#if XFS_BIG_INUMS
 			if (i8elevated)
 				xfs_dir2_sf_toino4(args);
-#endif
 			return XFS_ERROR(ENOENT);
 		}
 	}
-#if XFS_BIG_INUMS
 	/*
 	 * See if the old number was large, the new number is small.
 	 */
@@ -1015,13 +989,11 @@ xfs_dir2_sf_replace(
 		if (!i8elevated)
 			sfp->i8count++;
 	}
-#endif
 	xfs_dir2_sf_check(args);
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_DDATA);
 	return 0;
 }
 
-#if XFS_BIG_INUMS
 /*
  * Convert from 8-byte inode numbers to 4-byte inode numbers.
  * The last 8-byte inode number is gone, but the count is still 1.
@@ -1176,4 +1148,3 @@ xfs_dir2_sf_toino8(
 	dp->i_d.di_size = newsize;
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
 }
-#endif	/* XFS_BIG_INUMS */
diff --git a/fs/xfs/xfs_format.h b/fs/xfs/xfs_format.h
index b6ab5a3..e6b8f7d 100644
--- a/fs/xfs/xfs_format.h
+++ b/fs/xfs/xfs_format.h
@@ -68,11 +68,7 @@ struct xfs_ifork;
 #define	XFS_RTLOBIT(w)	xfs_lowbit32(w)
 #define	XFS_RTHIBIT(w)	xfs_highbit32(w)
 
-#if XFS_BIG_BLKNOS
 #define	XFS_RTBLOCKLOG(b)	xfs_highbit64(b)
-#else
-#define	XFS_RTBLOCKLOG(b)	xfs_highbit32(b)
-#endif
 
 /*
  * Dquot and dquot block format definitions
@@ -290,23 +286,15 @@ typedef struct xfs_bmbt_rec_host {
  * Values and macros for delayed-allocation startblock fields.
  */
 #define STARTBLOCKVALBITS	17
-#define STARTBLOCKMASKBITS	(15 + XFS_BIG_BLKNOS * 20)
-#define DSTARTBLOCKMASKBITS	(15 + 20)
+#define STARTBLOCKMASKBITS	(15 + 20)
 #define STARTBLOCKMASK		\
 	(((((xfs_fsblock_t)1) << STARTBLOCKMASKBITS) - 1) << STARTBLOCKVALBITS)
-#define DSTARTBLOCKMASK		\
-	(((((xfs_dfsbno_t)1) << DSTARTBLOCKMASKBITS) - 1) << STARTBLOCKVALBITS)
 
 static inline int isnullstartblock(xfs_fsblock_t x)
 {
 	return ((x) & STARTBLOCKMASK) == STARTBLOCKMASK;
 }
 
-static inline int isnulldstartblock(xfs_dfsbno_t x)
-{
-	return ((x) & DSTARTBLOCKMASK) == DSTARTBLOCKMASK;
-}
-
 static inline xfs_fsblock_t nullstartblock(int k)
 {
 	ASSERT(k < (1 << STARTBLOCKVALBITS));
diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index c5fc116..7e907f2 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -254,8 +254,8 @@ typedef struct xfs_fsop_resblks {
 	((2 * 1024 * 1024 * 1024ULL) - XFS_MIN_LOG_BYTES)
 
 /* Used for sanity checks on superblock */
-#define XFS_MAX_DBLOCKS(s) ((xfs_drfsbno_t)(s)->sb_agcount * (s)->sb_agblocks)
-#define XFS_MIN_DBLOCKS(s) ((xfs_drfsbno_t)((s)->sb_agcount - 1) *	\
+#define XFS_MAX_DBLOCKS(s) ((xfs_rfsblock_t)(s)->sb_agcount * (s)->sb_agblocks)
+#define XFS_MIN_DBLOCKS(s) ((xfs_rfsblock_t)((s)->sb_agcount - 1) *	\
 			 (s)->sb_agblocks + XFS_MIN_AG_BLOCKS)
 
 /*
diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
index cfee14a..cb2677c 100644
--- a/fs/xfs/xfs_inode_fork.c
+++ b/fs/xfs/xfs_inode_fork.c
@@ -526,7 +526,7 @@ xfs_iroot_realloc(
 		ifp->if_broot_bytes = (int)new_size;
 		ASSERT(XFS_BMAP_BMDR_SPACE(ifp->if_broot) <=
 			XFS_IFORK_SIZE(ip, whichfork));
-		memmove(np, op, cur_max * (uint)sizeof(xfs_dfsbno_t));
+		memmove(np, op, cur_max * (uint)sizeof(xfs_fsblock_t));
 		return;
 	}
 
@@ -573,7 +573,7 @@ xfs_iroot_realloc(
 						     ifp->if_broot_bytes);
 		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, new_broot, 1,
 						     (int)new_size);
-		memcpy(np, op, new_max * (uint)sizeof(xfs_dfsbno_t));
+		memcpy(np, op, new_max * (uint)sizeof(xfs_fsblock_t));
 	}
 	kmem_free(ifp->if_broot);
 	ifp->if_broot = new_broot;
diff --git a/fs/xfs/xfs_inum.h b/fs/xfs/xfs_inum.h
index 90efdaf..4ff2278 100644
--- a/fs/xfs/xfs_inum.h
+++ b/fs/xfs/xfs_inum.h
@@ -54,11 +54,7 @@ struct xfs_mount;
 #define	XFS_OFFBNO_TO_AGINO(mp,b,o)	\
 	((xfs_agino_t)(((b) << XFS_INO_OFFSET_BITS(mp)) | (o)))
 
-#if XFS_BIG_INUMS
 #define	XFS_MAXINUMBER		((xfs_ino_t)((1ULL << 56) - 1ULL))
-#else
-#define	XFS_MAXINUMBER		((xfs_ino_t)((1ULL << 32) - 1ULL))
-#endif
 #define	XFS_MAXINUMBER_32	((xfs_ino_t)((1ULL << 32) - 1ULL))
 
 #endif	/* __XFS_INUM_H__ */
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index f9bb590..9dc1349 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -21,18 +21,6 @@
 #include <linux/types.h>
 
 /*
- * XFS_BIG_BLKNOS needs block layer disk addresses to be 64 bits.
- * XFS_BIG_INUMS requires XFS_BIG_BLKNOS to be set.
- */
-#if defined(CONFIG_LBDAF) || (BITS_PER_LONG == 64)
-# define XFS_BIG_BLKNOS	1
-# define XFS_BIG_INUMS	1
-#else
-# define XFS_BIG_BLKNOS	0
-# define XFS_BIG_INUMS	0
-#endif
-
-/*
  * Kernel specific type declarations for XFS
  */
 typedef signed char		__int8_t;
diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
index f0969c7..aff12f2 100644
--- a/fs/xfs/xfs_log_format.h
+++ b/fs/xfs/xfs_log_format.h
@@ -380,7 +380,7 @@ typedef struct xfs_icdinode {
 	xfs_ictimestamp_t di_mtime;	/* time last modified */
 	xfs_ictimestamp_t di_ctime;	/* time created/inode modified */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
-	xfs_drfsbno_t	di_nblocks;	/* # of direct & btree blocks used */
+	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
 	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
 	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
@@ -516,7 +516,7 @@ xfs_blft_from_flags(struct xfs_buf_log_format *blf)
  * EFI/EFD log format definitions
  */
 typedef struct xfs_extent {
-	xfs_dfsbno_t	ext_start;
+	xfs_fsblock_t	ext_start;
 	xfs_extlen_t	ext_len;
 } xfs_extent_t;
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index da88f16..1053aa2 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -172,13 +172,9 @@ xfs_sb_validate_fsb_count(
 	ASSERT(PAGE_SHIFT >= sbp->sb_blocklog);
 	ASSERT(sbp->sb_blocklog >= BBSHIFT);
 
-#if XFS_BIG_BLKNOS     /* Limited by ULONG_MAX of page cache index */
+	/* Limited by ULONG_MAX of page cache index */
 	if (nblocks >> (PAGE_CACHE_SHIFT - sbp->sb_blocklog) > ULONG_MAX)
 		return EFBIG;
-#else                  /* Limited by UINT_MAX of sectors */
-	if (nblocks << (sbp->sb_blocklog - BBSHIFT) > UINT_MAX)
-		return EFBIG;
-#endif
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index a6a76b2..4176e8d 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -944,9 +944,9 @@ xfs_growfs_rt(
 	xfs_buf_t	*bp;		/* temporary buffer */
 	int		error;		/* error return value */
 	xfs_mount_t	*nmp;		/* new (fake) mount structure */
-	xfs_drfsbno_t	nrblocks;	/* new number of realtime blocks */
+	xfs_rfsblock_t	nrblocks;	/* new number of realtime blocks */
 	xfs_extlen_t	nrbmblocks;	/* new number of rt bitmap blocks */
-	xfs_drtbno_t	nrextents;	/* new number of realtime extents */
+	xfs_rtblock_t	nrextents;	/* new number of realtime extents */
 	uint8_t		nrextslog;	/* new log2 of sb_rextents */
 	xfs_extlen_t	nrsumblocks;	/* new number of summary blocks */
 	uint		nrsumlevels;	/* new rt summary levels */
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 35061d4..c24a9ab 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -104,11 +104,11 @@ struct xfs_trans;
 typedef struct xfs_sb {
 	__uint32_t	sb_magicnum;	/* magic number == XFS_SB_MAGIC */
 	__uint32_t	sb_blocksize;	/* logical block size, bytes */
-	xfs_drfsbno_t	sb_dblocks;	/* number of data blocks */
-	xfs_drfsbno_t	sb_rblocks;	/* number of realtime blocks */
-	xfs_drtbno_t	sb_rextents;	/* number of realtime extents */
+	xfs_rfsblock_t	sb_dblocks;	/* number of data blocks */
+	xfs_rfsblock_t	sb_rblocks;	/* number of realtime blocks */
+	xfs_rtblock_t	sb_rextents;	/* number of realtime extents */
 	uuid_t		sb_uuid;	/* file system unique id */
-	xfs_dfsbno_t	sb_logstart;	/* starting block of log if internal */
+	xfs_fsblock_t	sb_logstart;	/* starting block of log if internal */
 	xfs_ino_t	sb_rootino;	/* root inode number */
 	xfs_ino_t	sb_rbmino;	/* bitmap inode for realtime extents */
 	xfs_ino_t	sb_rsumino;	/* summary inode for rt bitmap */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d971f49..0eeb30c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -204,9 +204,6 @@ xfs_parseargs(
 	 */
 	mp->m_flags |= XFS_MOUNT_BARRIER;
 	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
-#if !XFS_BIG_INUMS
-	mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
-#endif
 
 	/*
 	 * These can be overridden by the mount option parsing.
@@ -313,11 +310,6 @@ xfs_parseargs(
 			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
 		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
 			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
-#if !XFS_BIG_INUMS
-			xfs_warn(mp, "%s option not allowed on this system",
-				this_char);
-			return EINVAL;
-#endif
 		} else if (!strcmp(this_char, MNTOPT_NOUUID)) {
 			mp->m_flags |= XFS_MOUNT_NOUUID;
 		} else if (!strcmp(this_char, MNTOPT_BARRIER)) {
diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index bbe3d15..31f757c 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -44,16 +44,6 @@ extern void xfs_qm_exit(void);
 # define XFS_REALTIME_STRING
 #endif
 
-#if XFS_BIG_BLKNOS
-# if XFS_BIG_INUMS
-#  define XFS_BIGFS_STRING	"large block/inode numbers, "
-# else
-#  define XFS_BIGFS_STRING	"large block numbers, "
-# endif
-#else
-# define XFS_BIGFS_STRING
-#endif
-
 #ifdef DEBUG
 # define XFS_DBG_STRING		"debug"
 #else
@@ -64,7 +54,6 @@ extern void xfs_qm_exit(void);
 #define XFS_BUILD_OPTIONS	XFS_ACL_STRING \
 				XFS_SECURITY_STRING \
 				XFS_REALTIME_STRING \
-				XFS_BIGFS_STRING \
 				XFS_DBG_STRING /* DBG must be last */
 
 struct xfs_inode;
diff --git a/fs/xfs/xfs_types.h b/fs/xfs/xfs_types.h
index 82bbc34..14e3d87 100644
--- a/fs/xfs/xfs_types.h
+++ b/fs/xfs/xfs_types.h
@@ -38,43 +38,18 @@ typedef	__int32_t	xfs_tid_t;	/* transaction identifier */
 typedef	__uint32_t	xfs_dablk_t;	/* dir/attr block number (in file) */
 typedef	__uint32_t	xfs_dahash_t;	/* dir/attr hash value */
 
-/*
- * These types are 64 bits on disk but are either 32 or 64 bits in memory.
- * Disk based types:
- */
-typedef __uint64_t	xfs_dfsbno_t;	/* blockno in filesystem (agno|agbno) */
-typedef __uint64_t	xfs_drfsbno_t;	/* blockno in filesystem (raw) */
-typedef	__uint64_t	xfs_drtbno_t;	/* extent (block) in realtime area */
-typedef	__uint64_t	xfs_dfiloff_t;	/* block number in a file */
-typedef	__uint64_t	xfs_dfilblks_t;	/* number of blocks in a file */
-
-/*
- * Memory based types are conditional.
- */
-#if XFS_BIG_BLKNOS
 typedef	__uint64_t	xfs_fsblock_t;	/* blockno in filesystem (agno|agbno) */
 typedef __uint64_t	xfs_rfsblock_t;	/* blockno in filesystem (raw) */
 typedef __uint64_t	xfs_rtblock_t;	/* extent (block) in realtime area */
-typedef	__int64_t	xfs_srtblock_t;	/* signed version of xfs_rtblock_t */
-#else
-typedef	__uint32_t	xfs_fsblock_t;	/* blockno in filesystem (agno|agbno) */
-typedef __uint32_t	xfs_rfsblock_t;	/* blockno in filesystem (raw) */
-typedef __uint32_t	xfs_rtblock_t;	/* extent (block) in realtime area */
-typedef	__int32_t	xfs_srtblock_t;	/* signed version of xfs_rtblock_t */
-#endif
 typedef __uint64_t	xfs_fileoff_t;	/* block number in a file */
-typedef __int64_t	xfs_sfiloff_t;	/* signed block number in a file */
 typedef __uint64_t	xfs_filblks_t;	/* number of blocks in a file */
 
+typedef	__int64_t	xfs_srtblock_t;	/* signed version of xfs_rtblock_t */
+typedef __int64_t	xfs_sfiloff_t;	/* signed block number in a file */
 
 /*
  * Null values for the types.
  */
-#define	NULLDFSBNO	((xfs_dfsbno_t)-1)
-#define	NULLDRFSBNO	((xfs_drfsbno_t)-1)
-#define	NULLDRTBNO	((xfs_drtbno_t)-1)
-#define	NULLDFILOFF	((xfs_dfiloff_t)-1)
-
 #define	NULLFSBLOCK	((xfs_fsblock_t)-1)
 #define	NULLRFSBLOCK	((xfs_rfsblock_t)-1)
 #define	NULLRTBLOCK	((xfs_rtblock_t)-1)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
