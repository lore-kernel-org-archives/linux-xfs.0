Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 10:20:42 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6FHKbbm000365
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 10:20:39 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l6FHKdNK007017
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 19:20:39 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l6FHKdh9007015
	for xfs@oss.sgi.com; Sun, 15 Jul 2007 19:20:39 +0200
Date: Sun, 15 Jul 2007 19:20:39 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix sparse endianess warnings in xfsidbg
Message-ID: <20070715172039.GB6894@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfsidbg was missed in a a few of the previous endianess conversions, and
this patch brings it up to the proper state.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2007-07-15 17:46:49.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2007-07-15 18:17:16.000000000 +0200
@@ -3233,9 +3233,9 @@ xfs_broot(xfs_inode_t *ip, xfs_ifork_t *
 	pp = XFS_BMAP_BROOT_PTR_ADDR(broot, 1, f->if_broot_bytes);
 	for (i = 1; i <= be16_to_cpu(broot->bb_numrecs); i++)
 		kdb_printf("\t%d: startoff %Ld ptr %Lx %s\n",
-			i, (long long)INT_GET(kp[i - 1].br_startoff, ARCH_CONVERT),
-			(unsigned long long)INT_GET(pp[i - 1], ARCH_CONVERT),
-			xfs_fmtfsblock(INT_GET(pp[i - 1], ARCH_CONVERT), ip->i_mount));
+			i, (long long)be64_to_cpu(kp[i - 1].br_startoff),
+			(unsigned long long)be64_to_cpu(pp[i - 1]),
+			xfs_fmtfsblock(be64_to_cpu(pp[i - 1]), ip->i_mount));
 }
 
 /*
@@ -3319,9 +3319,9 @@ xfs_btbmap(xfs_bmbt_block_t *bt, int bsz
 			k = XFS_BTREE_KEY_ADDR(xfs_bmbt, bt, i);
 			p = XFS_BTREE_PTR_ADDR(xfs_bmbt, bt, i, mxr);
 			kdb_printf("key %d startoff %Ld ", i,
-				(unsigned long long)INT_GET(k->br_startoff, ARCH_CONVERT));
+				(unsigned long long)be64_to_cpu(k->br_startoff));
 			kdb_printf("ptr %Lx\n",
-				(unsigned long long)INT_GET(*p, ARCH_CONVERT));
+				(unsigned long long)be64_to_cpu(*p));
 		}
 	}
 }
@@ -3346,9 +3346,9 @@ xfs_btino(xfs_inobt_block_t *bt, int bsz
 
 			r = XFS_BTREE_REC_ADDR(xfs_inobt, bt, i);
 			kdb_printf("rec %d startino 0x%x freecount %d, free %Lx\n",
-				i, INT_GET(r->ir_startino, ARCH_CONVERT),
-				INT_GET(r->ir_freecount, ARCH_CONVERT),
-				(unsigned long long)INT_GET(r->ir_free, ARCH_CONVERT));
+				i, be32_to_cpu(r->ir_startino),
+				be32_to_cpu(r->ir_freecount),
+				(unsigned long long)be64_to_cpu(r->ir_free));
 		}
 	} else {
 		int mxr;
@@ -3361,7 +3361,7 @@ xfs_btino(xfs_inobt_block_t *bt, int bsz
 			k = XFS_BTREE_KEY_ADDR(xfs_inobt, bt, i);
 			p = XFS_BTREE_PTR_ADDR(xfs_inobt, bt, i, mxr);
 			kdb_printf("key %d startino 0x%x ptr 0x%x\n",
-				i, INT_GET(k->ir_startino, ARCH_CONVERT),
+				i, be32_to_cpu(k->ir_startino),
 				be32_to_cpu(*p));
 		}
 	}
@@ -4566,18 +4566,18 @@ xfsidbg_xattrleaf(xfs_attr_leafblock_t *
 	kdb_printf("hdr info forw 0x%x back 0x%x magic 0x%x\n",
 		i->forw, i->back, i->magic);
 	kdb_printf("hdr count %d usedbytes %d firstused %d holes %d\n",
-		INT_GET(h->count, ARCH_CONVERT),
-		INT_GET(h->usedbytes, ARCH_CONVERT),
-		INT_GET(h->firstused, ARCH_CONVERT), h->holes);
+		be16_to_cpu(h->count),
+		be16_to_cpu(h->usedbytes),
+		be16_to_cpu(h->firstused), h->holes);
 	for (j = 0, m = h->freemap; j < XFS_ATTR_LEAF_MAPSIZE; j++, m++) {
 		kdb_printf("hdr freemap %d base %d size %d\n",
-			j, INT_GET(m->base, ARCH_CONVERT),
-			INT_GET(m->size, ARCH_CONVERT));
+			j, be16_to_cpu(m->base),
+			be16_to_cpu(m->size));
 	}
-	for (j = 0, e = leaf->entries; j < INT_GET(h->count, ARCH_CONVERT); j++, e++) {
+	for (j = 0, e = leaf->entries; j < be16_to_cpu(h->count); j++, e++) {
 		kdb_printf("[%2d] hash 0x%x nameidx %d flags 0x%x",
-			j, INT_GET(e->hashval, ARCH_CONVERT),
-			INT_GET(e->nameidx, ARCH_CONVERT), e->flags);
+			j, be32_to_cpu(e->hashval),
+			be16_to_cpu(e->nameidx), e->flags);
 		if (e->flags & XFS_ATTR_LOCAL)
 			kdb_printf("LOCAL ");
 		if (e->flags & XFS_ATTR_ROOT)
@@ -4596,20 +4596,19 @@ xfsidbg_xattrleaf(xfs_attr_leafblock_t *
 			for (k = 0; k < l->namelen; k++)
 				kdb_printf("%c", l->nameval[k]);
 			kdb_printf("\"(%d) value \"", l->namelen);
-			for (k = 0; (k < INT_GET(l->valuelen, ARCH_CONVERT)) && (k < 32); k++)
+			for (k = 0; (k < be16_to_cpu(l->valuelen)) && (k < 32); k++)
 				kdb_printf("%c", l->nameval[l->namelen + k]);
 			if (k == 32)
 				kdb_printf("...");
-			kdb_printf("\"(%d)\n",
-				INT_GET(l->valuelen, ARCH_CONVERT));
+			kdb_printf("\"(%d)\n", be16_to_cpu(l->valuelen));
 		} else {
 			r = XFS_ATTR_LEAF_NAME_REMOTE(leaf, j);
 			for (k = 0; k < r->namelen; k++)
 				kdb_printf("%c", r->name[k]);
 			kdb_printf("\"(%d) value blk 0x%x len %d\n",
 				    r->namelen,
-				    INT_GET(r->valueblk, ARCH_CONVERT),
-				    INT_GET(r->valuelen, ARCH_CONVERT));
+				    be32_to_cpu(r->valueblk),
+				    be32_to_cpu(r->valuelen));
 		}
 	}
 }
@@ -4625,13 +4624,13 @@ xfsidbg_xattrsf(xfs_attr_shortform_t *s)
 	int i, j;
 
 	sfh = &s->hdr;
-	kdb_printf("hdr count %d\n", INT_GET(sfh->count, ARCH_CONVERT));
-	for (i = 0, sfe = s->list; i < INT_GET(sfh->count, ARCH_CONVERT); i++) {
+	kdb_printf("hdr count %d\n", sfh->count);
+	for (i = 0, sfe = s->list; i < sfh->count; i++) {
 		kdb_printf("entry %d namelen %d name \"", i, sfe->namelen);
 		for (j = 0; j < sfe->namelen; j++)
 			kdb_printf("%c", sfe->nameval[j]);
-		kdb_printf("\" valuelen %d value \"", INT_GET(sfe->valuelen, ARCH_CONVERT));
-		for (j = 0; (j < INT_GET(sfe->valuelen, ARCH_CONVERT)) && (j < 32); j++)
+		kdb_printf("\" valuelen %d value \"", sfe->valuelen);
+		for (j = 0; (j < sfe->valuelen) && (j < 32); j++)
 			kdb_printf("%c", sfe->nameval[sfe->namelen + j]);
 		if (j == 32)
 			kdb_printf("...");
@@ -5043,15 +5042,15 @@ xfsidbg_xbuf_real(xfs_buf_t *bp, int sum
 			kdb_printf("buf 0x%p inobt 0x%p\n", bp, bti);
 			xfs_btino(bti, XFS_BUF_COUNT(bp));
 		}
-	} else if (INT_GET((aleaf = d)->hdr.info.magic, ARCH_CONVERT) == XFS_ATTR_LEAF_MAGIC) {
+	} else if (be16_to_cpu((aleaf = d)->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC) {
 		if (summary) {
 			kdb_printf("Attr Leaf, 1st hash 0x%x (at 0x%p)\n",
-				      INT_GET(aleaf->entries[0].hashval, ARCH_CONVERT), aleaf);
+				      be32_to_cpu(aleaf->entries[0].hashval), aleaf);
 		} else {
 			kdb_printf("buf 0x%p attr leaf 0x%p\n", bp, aleaf);
 			xfsidbg_xattrleaf(aleaf);
 		}
-	} else if (INT_GET((node = d)->hdr.info.magic, ARCH_CONVERT) == XFS_DA_NODE_MAGIC) {
+	} else if (be16_to_cpu((node = d)->hdr.info.magic) == XFS_DA_NODE_MAGIC) {
 		if (summary) {
 			kdb_printf("Dir/Attr Node, level %d, 1st hash 0x%x (at 0x%p)\n",
 			      node->hdr.level, node->btree[0].hashval, node);
@@ -5082,35 +5081,35 @@ xfsidbg_xbuf_real(xfs_buf_t *bp, int sum
 		kdb_printf("Quota blk starting ID [%d], type %s at 0x%p\n",
 			be32_to_cpu(dqb->d_id), XFSIDBG_DQTYPESTR(dqb), dqb);
 
-	} else if (INT_GET((d2block = d)->hdr.magic, ARCH_CONVERT) == XFS_DIR2_BLOCK_MAGIC) {
+	} else if (be32_to_cpu((d2block = d)->hdr.magic) == XFS_DIR2_BLOCK_MAGIC) {
 		if (summary) {
 			kdb_printf("Dir2 block (at 0x%p)\n", d2block);
 		} else {
 			kdb_printf("buf 0x%p dir2 block 0x%p\n", bp, d2block);
 			xfs_dir2data((void *)d2block, XFS_BUF_COUNT(bp));
 		}
-	} else if (INT_GET((d2data = d)->hdr.magic, ARCH_CONVERT) == XFS_DIR2_DATA_MAGIC) {
+	} else if (be32_to_cpu((d2data = d)->hdr.magic) == XFS_DIR2_DATA_MAGIC) {
 		if (summary) {
 			kdb_printf("Dir2 data (at 0x%p)\n", d2data);
 		} else {
 			kdb_printf("buf 0x%p dir2 data 0x%p\n", bp, d2data);
 			xfs_dir2data((void *)d2data, XFS_BUF_COUNT(bp));
 		}
-	} else if (INT_GET((d2leaf = d)->hdr.info.magic, ARCH_CONVERT) == XFS_DIR2_LEAF1_MAGIC) {
+	} else if (be16_to_cpu((d2leaf = d)->hdr.info.magic) == XFS_DIR2_LEAF1_MAGIC) {
 		if (summary) {
 			kdb_printf("Dir2 leaf(1) (at 0x%p)\n", d2leaf);
 		} else {
 			kdb_printf("buf 0x%p dir2 leaf 0x%p\n", bp, d2leaf);
 			xfs_dir2leaf(d2leaf, XFS_BUF_COUNT(bp));
 		}
-	} else if (INT_GET(d2leaf->hdr.info.magic, ARCH_CONVERT) == XFS_DIR2_LEAFN_MAGIC) {
+	} else if (be16_to_cpu(d2leaf->hdr.info.magic) == XFS_DIR2_LEAFN_MAGIC) {
 		if (summary) {
 			kdb_printf("Dir2 leaf(n) (at 0x%p)\n", d2leaf);
 		} else {
 			kdb_printf("buf 0x%p dir2 leaf 0x%p\n", bp, d2leaf);
 			xfs_dir2leaf(d2leaf, XFS_BUF_COUNT(bp));
 		}
-	} else if (INT_GET((d2free = d)->hdr.magic, ARCH_CONVERT) == XFS_DIR2_FREE_MAGIC) {
+	} else if (be32_to_cpu((d2free = d)->hdr.magic) == XFS_DIR2_FREE_MAGIC) {
 		if (summary) {
 			kdb_printf("Dir2 free (at 0x%p)\n", d2free);
 		} else {
@@ -5653,12 +5652,12 @@ xfsidbg_xdanode(xfs_da_intnode_t *node)
 	h = &node->hdr;
 	i = &h->info;
 	kdb_printf("hdr info forw 0x%x back 0x%x magic 0x%x\n",
-		INT_GET(i->forw, ARCH_CONVERT), INT_GET(i->back, ARCH_CONVERT), INT_GET(i->magic, ARCH_CONVERT));
+		be32_to_cpu(i->forw), be32_to_cpu(i->back), be16_to_cpu(i->magic));
 	kdb_printf("hdr count %d level %d\n",
-		INT_GET(h->count, ARCH_CONVERT), INT_GET(h->level, ARCH_CONVERT));
-	for (j = 0, e = node->btree; j < INT_GET(h->count, ARCH_CONVERT); j++, e++) {
+		be16_to_cpu(h->count), be16_to_cpu(h->level));
+	for (j = 0, e = node->btree; j < be16_to_cpu(h->count); j++, e++) {
 		kdb_printf("btree %d hashval 0x%x before 0x%x\n",
-			j, (uint_t)INT_GET(e->hashval, ARCH_CONVERT), INT_GET(e->before, ARCH_CONVERT));
+			j, be32_to_cpu(e->hashval), be32_to_cpu(e->before));
 	}
 }
 
@@ -5708,14 +5707,16 @@ xfs_dir2data(void *addr, int size)
 	db = (xfs_dir2_data_t *)addr;
 	bb = (xfs_dir2_block_t *)addr;
 	h = &db->hdr;
-	kdb_printf("hdr magic 0x%x (%s)\nhdr bestfree", INT_GET(h->magic, ARCH_CONVERT),
-		INT_GET(h->magic, ARCH_CONVERT) == XFS_DIR2_DATA_MAGIC ? "DATA" :
-			(INT_GET(h->magic, ARCH_CONVERT) == XFS_DIR2_BLOCK_MAGIC ? "BLOCK" : ""));
+	kdb_printf("hdr magic 0x%x (%s)\nhdr bestfree", be32_to_cpu(h->magic),
+		be32_to_cpu(h->magic) == XFS_DIR2_DATA_MAGIC ? "DATA" :
+			(be32_to_cpu(h->magic) == XFS_DIR2_BLOCK_MAGIC ? "BLOCK" : ""));
 	for (j = 0, m = h->bestfree; j < XFS_DIR2_DATA_FD_COUNT; j++, m++) {
-		kdb_printf(" %d: 0x%x@0x%x", j, INT_GET(m->length, ARCH_CONVERT), INT_GET(m->offset, ARCH_CONVERT));
+		kdb_printf(" %d: 0x%x@0x%x", j,
+			   be16_to_cpu(m->length),
+			   be16_to_cpu(m->offset));
 	}
 	kdb_printf("\n");
-	if (INT_GET(h->magic, ARCH_CONVERT) == XFS_DIR2_DATA_MAGIC)
+	if (be32_to_cpu(h->magic) == XFS_DIR2_DATA_MAGIC)
 		t = (char *)db + size;
 	else {
 		/* XFS_DIR2_BLOCK_TAIL_P */
@@ -5726,38 +5727,38 @@ xfs_dir2data(void *addr, int size)
 	}
 	for (p = (char *)(h + 1); p < t; ) {
 		u = (xfs_dir2_data_unused_t *)p;
-		if (u->freetag == XFS_DIR2_DATA_FREE_TAG) {
+		if (be16_to_cpu(u->freetag) == XFS_DIR2_DATA_FREE_TAG) {
 			kdb_printf("0x%lx unused freetag 0x%x length 0x%x tag 0x%x\n",
 				(unsigned long) (p - (char *)addr),
-				INT_GET(u->freetag, ARCH_CONVERT),
-				INT_GET(u->length, ARCH_CONVERT),
-				INT_GET(*xfs_dir2_data_unused_tag_p(u), ARCH_CONVERT));
-			p += INT_GET(u->length, ARCH_CONVERT);
+				be16_to_cpu(u->freetag),
+				be16_to_cpu(u->length),
+				be16_to_cpu(*xfs_dir2_data_unused_tag_p(u)));
+			p += be16_to_cpu(u->length);
 			continue;
 		}
 		e = (xfs_dir2_data_entry_t *)p;
 		kdb_printf("0x%lx entry inumber %llu namelen %d name \"",
 			(unsigned long) (p - (char *)addr),
-			(unsigned long long) INT_GET(e->inumber, ARCH_CONVERT),
+			(unsigned long long) be64_to_cpu(e->inumber),
 			e->namelen);
 		for (k = 0; k < e->namelen; k++)
 			kdb_printf("%c", e->name[k]);
-		kdb_printf("\" tag 0x%x\n", INT_GET(*xfs_dir2_data_entry_tag_p(e), ARCH_CONVERT));
+		kdb_printf("\" tag 0x%x\n", be16_to_cpu(*xfs_dir2_data_entry_tag_p(e)));
 		p += xfs_dir2_data_entsize(e->namelen);
 	}
-	if (INT_GET(h->magic, ARCH_CONVERT) == XFS_DIR2_DATA_MAGIC)
+	if (be32_to_cpu(h->magic) == XFS_DIR2_DATA_MAGIC)
 		return;
-	for (j = 0; j < INT_GET(tail->count, ARCH_CONVERT); j++, l++) {
+	for (j = 0; j < be32_to_cpu(tail->count); j++, l++) {
 		kdb_printf("0x%lx leaf %d hashval 0x%x address 0x%x (byte 0x%x)\n",
 			(unsigned long) ((char *)l - (char *)addr), j,
-			(uint_t)INT_GET(l->hashval, ARCH_CONVERT),
-			INT_GET(l->address, ARCH_CONVERT),
+			be32_to_cpu(l->hashval),
+			be32_to_cpu(l->address),
 			/* XFS_DIR2_DATAPTR_TO_BYTE */
-			INT_GET(l->address, ARCH_CONVERT) << XFS_DIR2_DATA_ALIGN_LOG);
+			be32_to_cpu(l->address) << XFS_DIR2_DATA_ALIGN_LOG);
 	}
 	kdb_printf("0x%lx tail count %d\n",
 		(unsigned long) ((char *)tail - (char *)addr),
-		INT_GET(tail->count, ARCH_CONVERT));
+		be32_to_cpu(tail->count));
 }
 
 static void
@@ -5766,35 +5767,35 @@ xfs_dir2leaf(xfs_dir2_leaf_t *leaf, int 
 	xfs_dir2_leaf_hdr_t *h;
 	xfs_da_blkinfo_t *i;
 	xfs_dir2_leaf_entry_t *e;
-	xfs_dir2_data_off_t *b;
 	xfs_dir2_leaf_tail_t *t;
+	__be16 *b;
 	int j;
 
 	h = &leaf->hdr;
 	i = &h->info;
 	e = leaf->ents;
 	kdb_printf("hdr info forw 0x%x back 0x%x magic 0x%x\n",
-		INT_GET(i->forw, ARCH_CONVERT), INT_GET(i->back, ARCH_CONVERT), INT_GET(i->magic, ARCH_CONVERT));
-	kdb_printf("hdr count %d stale %d\n", INT_GET(h->count, ARCH_CONVERT), INT_GET(h->stale, ARCH_CONVERT));
-	for (j = 0; j < INT_GET(h->count, ARCH_CONVERT); j++, e++) {
+		be32_to_cpu(i->forw), be32_to_cpu(i->back), be16_to_cpu(i->magic));
+	kdb_printf("hdr count %d stale %d\n", be16_to_cpu(h->count), be16_to_cpu(h->stale));
+	for (j = 0; j < be16_to_cpu(h->count); j++, e++) {
 		kdb_printf("0x%lx ent %d hashval 0x%x address 0x%x (byte 0x%x)\n",
 			(unsigned long) ((char *)e - (char *)leaf), j,
-			(uint_t)INT_GET(e->hashval, ARCH_CONVERT),
-			INT_GET(e->address, ARCH_CONVERT),
+			be32_to_cpu(e->hashval),
+			be32_to_cpu(e->address),
 			/* XFS_DIR2_DATAPTR_TO_BYTE */
-			INT_GET(e->address, ARCH_CONVERT) << XFS_DIR2_DATA_ALIGN_LOG);
+			be32_to_cpu(e->address) << XFS_DIR2_DATA_ALIGN_LOG);
 	}
-	if (INT_GET(i->magic, ARCH_CONVERT) == XFS_DIR2_LEAFN_MAGIC)
+	if (be16_to_cpu(i->magic) == XFS_DIR2_LEAFN_MAGIC)
 		return;
 	/* XFS_DIR2_LEAF_TAIL_P */
 	t = (xfs_dir2_leaf_tail_t *)((char *)leaf + size - sizeof(*t));
 	b = xfs_dir2_leaf_bests_p(t);
-	for (j = 0; j < INT_GET(t->bestcount, ARCH_CONVERT); j++, b++) {
+	for (j = 0; j < be32_to_cpu(t->bestcount); j++, b++) {
 		kdb_printf("0x%lx best %d 0x%x\n",
 			(unsigned long) ((char *)b - (char *)leaf), j,
-			INT_GET(*b, ARCH_CONVERT));
+			be16_to_cpu(*b));
 	}
-	kdb_printf("tail bestcount %d\n", INT_GET(t->bestcount, ARCH_CONVERT));
+	kdb_printf("tail bestcount %d\n", be32_to_cpu(t->bestcount));
 }
 
 /*
@@ -5834,10 +5835,11 @@ xfsidbg_xdir2free(xfs_dir2_free_t *f)
 	int	i;
 
 	kdb_printf("hdr magic 0x%x firstdb %d nvalid %d nused %d\n",
-		INT_GET(f->hdr.magic, ARCH_CONVERT), INT_GET(f->hdr.firstdb, ARCH_CONVERT), INT_GET(f->hdr.nvalid, ARCH_CONVERT), INT_GET(f->hdr.nused, ARCH_CONVERT));
-	for (i = 0; i < INT_GET(f->hdr.nvalid, ARCH_CONVERT); i++) {
+		   be32_to_cpu(f->hdr.magic), be32_to_cpu(f->hdr.firstdb),
+		   be32_to_cpu(f->hdr.nvalid), be32_to_cpu(f->hdr.nused));
+	for (i = 0; i < be32_to_cpu(f->hdr.nvalid); i++) {
 		kdb_printf("entry %d db %d count %d\n",
-			i, i + INT_GET(f->hdr.firstdb, ARCH_CONVERT), INT_GET(f->bests[i], ARCH_CONVERT));
+			i, i + be32_to_cpu(f->hdr.firstdb), be16_to_cpu(f->bests[i]));
 	}
 }
 
