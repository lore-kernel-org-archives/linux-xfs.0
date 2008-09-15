Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Sep 2008 17:45:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8F0jbOS024525
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 17:45:37 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 614271FE1C5
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 17:46:44 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id cHnsNE3eQrlnuF2b for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 17:46:44 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m8F0kiIF012278
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 02:46:44 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m8F0kiCJ012276
	for xfs@oss.sgi.com; Mon, 15 Sep 2008 02:46:44 +0200
Date: Mon, 15 Sep 2008 02:46:44 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] make xfsidbg independent of the main btree implementation
Message-ID: <20080915004644.GC12213@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-btree-generic-xfsidbg
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Add a small btree framework inside xfsidbg which makes it independent
of the main btree implementation and it's soon to be changing macros.
This will also allow xfsidbg to easily select the right btree type
depending on the magic number in the header.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-09-01 10:00:08.000000000 -0300
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-09-01 10:00:53.000000000 -0300
@@ -212,9 +212,6 @@ static void	xfs_page_trace_entry(ktrace_
 static int	xfs_rw_trace_entry(ktrace_entry_t *ktep);
 #endif
 static void	xfs_broot(xfs_inode_t *ip, xfs_ifork_t *f);
-static void	xfs_btalloc(xfs_alloc_block_t *bt, int bsz);
-static void	xfs_btbmap(xfs_bmbt_block_t *bt, int bsz);
-static void	xfs_btino(xfs_inobt_block_t *bt, int bsz);
 static void	xfs_buf_item_print(xfs_buf_log_item_t *blip, int summary);
 static void	xfs_dastate_path(xfs_da_state_path_t *p);
 static void	xfs_dir2data(void *addr, int size);
@@ -2964,168 +2961,212 @@ xfs_btree_trace_entry(
 }
 #endif
 
-/*
- * Print an xfs in-inode bmap btree root.
- */
-static void
-xfs_broot(xfs_inode_t *ip, xfs_ifork_t *f)
+struct xfsidbg_btree {
+	size_t			block_len;
+	size_t			key_len;
+	size_t			rec_len;
+	size_t			ptr_len;
+	void			(*print_block)(struct xfs_btree_block *);
+	void			(*print_rec)(int i, union xfs_btree_rec *);
+	void			(*print_key)(int i, union xfs_btree_key *,
+					     union xfs_btree_ptr *);
+};
+
+/* calculate max records.  Only for non-leaves. */
+static int
+xfsidbg_maxrecs(struct xfsidbg_btree *bt, int blocksize)
 {
-	xfs_bmbt_block_t	*broot;
-	int			format;
-	int			i;
-	xfs_bmbt_key_t		*kp;
-	xfs_bmbt_ptr_t		*pp;
+	blocksize -= bt->block_len;
 
-	format = f == &ip->i_df ? ip->i_d.di_format : ip->i_d.di_aformat;
-	if ((f->if_flags & XFS_IFBROOT) == 0 ||
-	    format != XFS_DINODE_FMT_BTREE) {
-		kdb_printf("inode 0x%p not btree format\n", ip);
-		return;
-	}
-	broot = f->if_broot;
-	kdb_printf("block @0x%p magic %x level %d numrecs %d\n",
-		broot,
-		be32_to_cpu(broot->bb_magic),
-		be16_to_cpu(broot->bb_level),
-		be16_to_cpu(broot->bb_numrecs));
-	kp = XFS_BMAP_BROOT_KEY_ADDR(broot, 1, f->if_broot_bytes);
-	pp = XFS_BMAP_BROOT_PTR_ADDR(broot, 1, f->if_broot_bytes);
-	for (i = 1; i <= be16_to_cpu(broot->bb_numrecs); i++)
-		kdb_printf("\t%d: startoff %Ld ptr %Lx %s\n",
-			i, (long long)be64_to_cpu(kp[i - 1].br_startoff),
-			(unsigned long long)be64_to_cpu(pp[i - 1]),
-			xfs_fmtfsblock(be64_to_cpu(pp[i - 1]), ip->i_mount));
+	return blocksize / (bt->key_len + bt->ptr_len);
+}
+
+
+static union xfs_btree_key *
+xfsidbg_btree_key_addr(struct xfsidbg_btree *bt,
+		struct xfs_btree_block *block, int index)
+{
+	return (union xfs_btree_key *)
+		((char *)block +
+		 bt->block_len +
+		 (index - 1) * bt->key_len);
+}
+
+static union xfs_btree_rec *
+xfsidbg_btree_rec_addr(struct xfsidbg_btree *bt,
+	struct xfs_btree_block *block, int index)
+{
+	return (union xfs_btree_rec *)
+		((char *)block +
+		 bt->block_len +
+		 (index - 1) * bt->rec_len);
+}
+
+static union xfs_btree_ptr *
+xfsidbg_btree_ptr_addr(struct xfsidbg_btree *bt,
+	struct xfs_btree_block *block, int index, int maxrecs)
+{
+	return (union xfs_btree_ptr *)
+		((char *)block +
+		 bt->block_len +
+		 maxrecs * bt->key_len +
+		 (index - 1) * bt->ptr_len);
 }
 
 /*
- * Print allocation btree block.
+ * Print a btree block.
  */
 static void
-xfs_btalloc(xfs_alloc_block_t *bt, int bsz)
+xfs_btblock(struct xfs_btree_block *block, int blocksize, struct xfsidbg_btree *bt)
 {
 	int i;
 
-	kdb_printf("magic 0x%x level %d numrecs %d leftsib 0x%x rightsib 0x%x\n",
-		be32_to_cpu(bt->bb_magic),
-		be16_to_cpu(bt->bb_level),
-		be16_to_cpu(bt->bb_numrecs),
-		be32_to_cpu(bt->bb_leftsib),
-		be32_to_cpu(bt->bb_rightsib));
-	if (!bt->bb_level) {
-		for (i = 1; i <= be16_to_cpu(bt->bb_numrecs); i++) {
-			xfs_alloc_rec_t *r;
+	bt->print_block(block);
 
-			r = XFS_BTREE_REC_ADDR(xfs_alloc, bt, i);
-			kdb_printf("rec %d startblock 0x%x blockcount %d\n",
-				i,
-				be32_to_cpu(r->ar_startblock),
-				be32_to_cpu(r->ar_blockcount));
-		}
+	if (!block->bb_level) {
+		for (i = 1; i <= be16_to_cpu(block->bb_numrecs); i++)
+			bt->print_rec(i, xfsidbg_btree_rec_addr(bt, block, i));
 	} else {
 		int mxr;
 
-		mxr = XFS_BTREE_BLOCK_MAXRECS(bsz, xfs_alloc, 0);
-		for (i = 1; i <= be16_to_cpu(bt->bb_numrecs); i++) {
-			xfs_alloc_key_t *k;
-			xfs_alloc_ptr_t *p;
-
-			k = XFS_BTREE_KEY_ADDR(xfs_alloc, bt, i);
-			p = XFS_BTREE_PTR_ADDR(xfs_alloc, bt, i, mxr);
-			kdb_printf("key %d startblock 0x%x blockcount %d ptr 0x%x\n",
-				i,
-				be32_to_cpu(k->ar_startblock),
-				be32_to_cpu(k->ar_blockcount),
-				be32_to_cpu(*p));
+		mxr = xfsidbg_maxrecs(bt, blocksize);
+		for (i = 1; i <= xfs_btree_get_numrecs(block); i++) {
+			bt->print_key(i, xfsidbg_btree_key_addr(bt, block, i),
+				xfsidbg_btree_ptr_addr(bt, block, i, mxr));
 		}
 	}
 }
 
-/*
- * Print a bmap btree block.
- */
 static void
-xfs_btbmap(xfs_bmbt_block_t *bt, int bsz)
+xfsidbg_print_btree_sblock(struct xfs_btree_block *block)
 {
-	int i;
+	kdb_printf("magic 0x%x level %d numrecs %d leftsib 0x%x rightsib 0x%x\n",
+			be32_to_cpu(block->bb_magic),
+			be16_to_cpu(block->bb_level),
+			be16_to_cpu(block->bb_numrecs),
+			be32_to_cpu(block->bb_u.s.bb_leftsib),
+			be32_to_cpu(block->bb_u.s.bb_rightsib));
+}
 
+static void
+xfsidbg_print_btree_lblock(struct xfs_btree_block *block)
+{
 	kdb_printf("magic 0x%x level %d numrecs %d leftsib %Lx rightsib %Lx\n",
-		be32_to_cpu(bt->bb_magic),
-		be16_to_cpu(bt->bb_level),
-		be16_to_cpu(bt->bb_numrecs),
-		(unsigned long long)be64_to_cpu(bt->bb_leftsib),
-		(unsigned long long)be64_to_cpu(bt->bb_rightsib));
-	if (!bt->bb_level) {
-		for (i = 1; i <= be16_to_cpu(bt->bb_numrecs); i++) {
-			xfs_bmbt_rec_t *r;
-			xfs_bmbt_irec_t	irec;
-
-			r = (xfs_bmbt_rec_t *)XFS_BTREE_REC_ADDR(xfs_bmbt, bt, i);
-
-			xfs_bmbt_disk_get_all((xfs_bmbt_rec_t *)r, &irec);
-			kdb_printf("rec %d startoff %Ld startblock %Lx blockcount %Ld flag %d\n",
-				i, irec.br_startoff,
-				(__uint64_t)irec.br_startblock,
-				irec.br_blockcount, irec.br_state);
-		}
-	} else {
-		int mxr;
+			be32_to_cpu(block->bb_magic),
+			be16_to_cpu(block->bb_level),
+			be16_to_cpu(block->bb_numrecs),
+			(unsigned long long)be64_to_cpu(block->bb_u.l.bb_leftsib),
+			(unsigned long long)be64_to_cpu(block->bb_u.l.bb_rightsib));
+}
 
-		mxr = XFS_BTREE_BLOCK_MAXRECS(bsz, xfs_bmbt, 0);
-		for (i = 1; i <= be16_to_cpu(bt->bb_numrecs); i++) {
-			xfs_bmbt_key_t *k;
-			xfs_bmbt_ptr_t *p;
+static void
+xfsidbg_print_alloc_rec(int i, union xfs_btree_rec *rec)
+{
+	kdb_printf("rec %d startblock 0x%x blockcount %d\n", i,
+			be32_to_cpu(rec->alloc.ar_startblock),
+			be32_to_cpu(rec->alloc.ar_blockcount));
+}
 
-			k = XFS_BTREE_KEY_ADDR(xfs_bmbt, bt, i);
-			p = XFS_BTREE_PTR_ADDR(xfs_bmbt, bt, i, mxr);
-			kdb_printf("key %d startoff %Ld ", i,
-				(unsigned long long)be64_to_cpu(k->br_startoff));
-			kdb_printf("ptr %Lx\n",
-				(unsigned long long)be64_to_cpu(*p));
-		}
-	}
+static void
+xfsidbg_print_alloc_key(int i, union xfs_btree_key *key,
+		union xfs_btree_ptr *ptr)
+{
+	kdb_printf("key %d startblock 0x%x blockcount %d ptr 0x%x\n", i,
+			be32_to_cpu(key->alloc.ar_startblock),
+			be32_to_cpu(key->alloc.ar_blockcount),
+			be32_to_cpu(ptr->s));
 }
 
+static struct xfsidbg_btree xfsidbg_allocbt = {
+	.block_len	= sizeof(struct xfs_btree_sblock),
+	.key_len	= sizeof(xfs_alloc_key_t),
+	.rec_len	= sizeof(xfs_alloc_rec_t),
+	.ptr_len	= sizeof(__be32),
+	.print_block	= xfsidbg_print_btree_sblock,
+	.print_rec	= xfsidbg_print_alloc_rec,
+	.print_key	= xfsidbg_print_alloc_key,
+};
+
+static void
+xfsidbg_print_bmbt_rec(int i, union xfs_btree_rec *rec)
+{
+	xfs_bmbt_irec_t	irec;
+
+	xfs_bmbt_disk_get_all(&rec->bmbt, &irec);
+
+	kdb_printf("rec %d startoff %Ld startblock %Lx blockcount %Ld flag %d\n",
+			i, irec.br_startoff,
+			(__uint64_t)irec.br_startblock,
+			irec.br_blockcount, irec.br_state);
+}
+
+static void
+xfsidbg_print_bmbt_key(int i, union xfs_btree_key *key,
+		union xfs_btree_ptr *ptr)
+{
+	kdb_printf("key %d startoff %Ld ", i,
+			(unsigned long long)be64_to_cpu(key->bmbt.br_startoff));
+	kdb_printf("ptr %Lx\n", (unsigned long long)be64_to_cpu(ptr->l));
+}
+
+static struct xfsidbg_btree xfsidbg_bmbt = {
+	.block_len	= sizeof(struct xfs_btree_lblock),
+	.key_len	= sizeof(xfs_bmbt_key_t),
+	.rec_len	= sizeof(xfs_bmbt_rec_t),
+	.ptr_len	= sizeof(__be64),
+	.print_block	= xfsidbg_print_btree_lblock,
+	.print_rec	= xfsidbg_print_bmbt_rec,
+	.print_key	= xfsidbg_print_bmbt_key,
+};
+
+static void
+xfsidbg_print_inobt_rec(int i, union xfs_btree_rec *rec)
+{
+	kdb_printf("rec %d startino 0x%x freecount %d, free %Lx\n", i,
+			be32_to_cpu(rec->inobt.ir_startino),
+			be32_to_cpu(rec->inobt.ir_freecount),
+			(unsigned long long)be64_to_cpu(rec->inobt.ir_free));
+}
+
+static void
+xfsidbg_print_inobt_key(int i, union xfs_btree_key *key,
+		union xfs_btree_ptr *ptr)
+{
+	kdb_printf("key %d startino 0x%x ptr 0x%x\n", i,
+			be32_to_cpu(key->inobt.ir_startino),
+			be32_to_cpu(ptr->s));
+}
+
+static struct xfsidbg_btree xfsidbg_inobtbt = {
+	.block_len	= sizeof(struct xfs_btree_sblock),
+	.key_len	= sizeof(xfs_inobt_key_t),
+	.rec_len	= sizeof(xfs_inobt_rec_t),
+	.ptr_len	= sizeof(__be32),
+	.print_block	= xfsidbg_print_btree_sblock,
+	.print_rec	= xfsidbg_print_inobt_rec,
+	.print_key	= xfsidbg_print_inobt_key,
+};
+
 /*
- * Print an inode btree block.
+ * Print an xfs in-inode bmap btree root.
  */
 static void
-xfs_btino(xfs_inobt_block_t *bt, int bsz)
+xfs_broot(xfs_inode_t *ip, xfs_ifork_t *f)
 {
-	int i;
-
-	kdb_printf("magic 0x%x level %d numrecs %d leftsib 0x%x rightsib 0x%x\n",
-		be32_to_cpu(bt->bb_magic),
-		be16_to_cpu(bt->bb_level),
-		be16_to_cpu(bt->bb_numrecs),
-		be32_to_cpu(bt->bb_leftsib),
-		be32_to_cpu(bt->bb_rightsib));
-	if (!bt->bb_level) {
-		for (i = 1; i <= be16_to_cpu(bt->bb_numrecs); i++) {
-			xfs_inobt_rec_t *r;
-
-			r = XFS_BTREE_REC_ADDR(xfs_inobt, bt, i);
-			kdb_printf("rec %d startino 0x%x freecount %d, free %Lx\n",
-				i, be32_to_cpu(r->ir_startino),
-				be32_to_cpu(r->ir_freecount),
-				(unsigned long long)be64_to_cpu(r->ir_free));
-		}
-	} else {
-		int mxr;
+	int			format;
 
-		mxr = XFS_BTREE_BLOCK_MAXRECS(bsz, xfs_inobt, 0);
-		for (i = 1; i <= be16_to_cpu(bt->bb_numrecs); i++) {
-			xfs_inobt_key_t *k;
-			xfs_inobt_ptr_t *p;
-
-			k = XFS_BTREE_KEY_ADDR(xfs_inobt, bt, i);
-			p = XFS_BTREE_PTR_ADDR(xfs_inobt, bt, i, mxr);
-			kdb_printf("key %d startino 0x%x ptr 0x%x\n",
-				i, be32_to_cpu(k->ir_startino),
-				be32_to_cpu(*p));
-		}
+	format = f == &ip->i_df ? ip->i_d.di_format : ip->i_d.di_aformat;
+	if ((f->if_flags & XFS_IFBROOT) == 0 ||
+	    format != XFS_DINODE_FMT_BTREE) {
+		kdb_printf("inode 0x%p not btree format\n", ip);
+		return;
 	}
+
+	xfs_btblock((struct xfs_btree_block *)f->if_broot, f->if_broot_bytes,
+		    &xfsidbg_bmbt);
 }
 
+
 /*
  * Print a buf log item.
  */
@@ -4731,9 +4772,7 @@ xfsidbg_xbuf_real(xfs_buf_t *bp, int sum
 	xfs_agf_t *agf;
 	xfs_agi_t *agi;
 	xfs_dsb_t *sb;
-	xfs_alloc_block_t *bta;
-	xfs_bmbt_block_t *btb;
-	xfs_inobt_block_t *bti;
+	struct xfs_btree_block *bt;
 	xfs_attr_leafblock_t *aleaf;
 	xfs_da_intnode_t *node;
 	xfs_dinode_t *di;
@@ -4760,37 +4799,37 @@ xfsidbg_xbuf_real(xfs_buf_t *bp, int sum
 			kdb_printf("buf 0x%p agi 0x%p\n", bp, agi);
 			xfsidbg_xagi(agi);
 		}
-	} else if (be32_to_cpu((bta = d)->bb_magic) == XFS_ABTB_MAGIC) {
+	} else if (be32_to_cpu((bt = d)->bb_magic) == XFS_ABTB_MAGIC) {
 		if (summary) {
 			kdb_printf("Alloc BNO Btree blk, level %d (at 0x%p)\n",
-				       be16_to_cpu(bta->bb_level), bta);
+				       be16_to_cpu(bt->bb_level), bt);
 		} else {
-			kdb_printf("buf 0x%p abtbno 0x%p\n", bp, bta);
-			xfs_btalloc(bta, XFS_BUF_COUNT(bp));
+			kdb_printf("buf 0x%p abtbno 0x%p\n", bp, bt);
+			xfs_btblock(bt, XFS_BUF_COUNT(bp), &xfsidbg_allocbt);
 		}
-	} else if (be32_to_cpu((bta = d)->bb_magic) == XFS_ABTC_MAGIC) {
+	} else if (be32_to_cpu((bt = d)->bb_magic) == XFS_ABTC_MAGIC) {
 		if (summary) {
 			kdb_printf("Alloc COUNT Btree blk, level %d (at 0x%p)\n",
-				       be16_to_cpu(bta->bb_level), bta);
+				       be16_to_cpu(bt->bb_level), bt);
 		} else {
-			kdb_printf("buf 0x%p abtcnt 0x%p\n", bp, bta);
-			xfs_btalloc(bta, XFS_BUF_COUNT(bp));
+			kdb_printf("buf 0x%p abtcnt 0x%p\n", bp, bt);
+			xfs_btblock(bt, XFS_BUF_COUNT(bp), &xfsidbg_allocbt);
 		}
-	} else if (be32_to_cpu((btb = d)->bb_magic) == XFS_BMAP_MAGIC) {
+	} else if (be32_to_cpu((bt = d)->bb_magic) == XFS_BMAP_MAGIC) {
 		if (summary) {
 			kdb_printf("Bmap Btree blk, level %d (at 0x%p)\n",
-				      be16_to_cpu(btb->bb_level), btb);
+				      be16_to_cpu(bt->bb_level), bt);
 		} else {
-			kdb_printf("buf 0x%p bmapbt 0x%p\n", bp, btb);
-			xfs_btbmap(btb, XFS_BUF_COUNT(bp));
+			kdb_printf("buf 0x%p bmapbt 0x%p\n", bp, bt);
+			xfs_btblock(bt, XFS_BUF_COUNT(bp), &xfsidbg_bmbt);
 		}
-	} else if (be32_to_cpu((bti = d)->bb_magic) == XFS_IBT_MAGIC) {
+	} else if (be32_to_cpu((bt = d)->bb_magic) == XFS_IBT_MAGIC) {
 		if (summary) {
 			kdb_printf("Inode Btree blk, level %d (at 0x%p)\n",
-				       be16_to_cpu(bti->bb_level), bti);
+				       be16_to_cpu(bt->bb_level), bt);
 		} else {
-			kdb_printf("buf 0x%p inobt 0x%p\n", bp, bti);
-			xfs_btino(bti, XFS_BUF_COUNT(bp));
+			kdb_printf("buf 0x%p inobt 0x%p\n", bp, bt);
+			xfs_btblock(bt, XFS_BUF_COUNT(bp), &xfsidbg_inobtbt);
 		}
 	} else if (be16_to_cpu((aleaf = d)->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC) {
 		if (summary) {

-- 
