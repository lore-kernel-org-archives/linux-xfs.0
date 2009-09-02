Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82HvjIm034374 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 12:58:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D771915B1A28
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 10:58:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id JVchCQzHAjpHurEl for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 10:58:41 -0700 (PDT)
Message-Id: <20090902175841.284697389@bombadil.infradead.org>
Date: Wed, 02 Sep 2009 13:55:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/14] repair: track logical to physical block mapping more
	effeciently
References: <20090902175531.469184575@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-blkmap-opt
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
Cc: Barry Naujok <bnaujok@sgi.com>

Currently we track the logical to physical block mapping by a structure which
contains an array of physicial blocks.  This is extremly efficient and is
replaced with the normal starblock storage we use in the kernel and on disk
in this patch.

In addition also use thread-local storage for the block map, this is possible
because repair only processes one inode at a given time per thread, and the
block map does not have to outlive the processing of a single inode.

The combination of those factors means we can use pthread thread-local
storage to store the block map, and we can re-use the allocation over
and over again.

This should be ported over to xfs_db eventually, or even better we could try
to share the code.

[hch: added a small fix in blkmap_set_ext to not call memmove unless needed]

Signed-off-by: Barry Naujok <bnaujok@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/bmap.c
===================================================================
--- xfsprogs-dev.orig/repair/bmap.c	2009-08-20 02:32:34.000000000 +0000
+++ xfsprogs-dev/repair/bmap.c	2009-08-20 02:32:45.000000000 +0000
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2001,2005,2008 Silicon Graphics, Inc.
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -21,106 +21,46 @@
 #include "bmap.h"
 
 /*
- * Block mapping code taken from xfs_db.
- */
-
-/*
- * Append an extent to the block entry.
- */
-void
-blkent_append(
-	blkent_t	**entp,
-	xfs_dfsbno_t	b,
-	xfs_dfilblks_t	c)
-{
-	blkent_t	*ent;
-	size_t		size;
-	int		i;
-
-	ent = *entp;
-	size = BLKENT_SIZE(c + ent->nblks);
-	if ((*entp = ent = realloc(ent, size)) == NULL) {
-		do_warn(_("realloc failed in blkent_append (%u bytes)\n"),
-			size);
-		return;
-	}
-	for (i = 0; i < c; i++)
-		ent->blks[ent->nblks + i] = b + i;
-	ent->nblks += c;
-}
-
-/*
- * Make a new block entry.
- */
-blkent_t *
-blkent_new(
-	xfs_dfiloff_t	o,
-	xfs_dfsbno_t	b,
-	xfs_dfilblks_t	c)
-{
-	blkent_t	*ent;
-	int		i;
-
-	if ((ent = malloc(BLKENT_SIZE(c))) == NULL) {
-		do_warn(_("malloc failed in blkent_new (%u bytes)\n"),
-			BLKENT_SIZE(c));
-		return ent;
-	}
-	ent->nblks = c;
-	ent->startoff = o;
-	for (i = 0; i < c; i++)
-		ent->blks[i] = b + i;
-	return ent;
-}
-
-/*
- * Prepend an extent to the block entry.
+ * Track the logical to physical block mapping for inodes.
+ *
+ * Repair only processes one inode at a given time per thread, and the
+ * block map does not have to outlive the processing of a single inode.
+ *
+ * The combination of those factors means we can use pthreads thread-local
+ * storage to store the block map, and we can re-use the allocation over
+ * and over again.
  */
-void
-blkent_prepend(
-	blkent_t	**entp,
-	xfs_dfsbno_t	b,
-	xfs_dfilblks_t	c)
-{
-	int		i;
-	blkent_t	*newent;
-	blkent_t	*oldent;
 
-	oldent = *entp;
-	if ((newent = malloc(BLKENT_SIZE(oldent->nblks + c))) == NULL) {
-		do_warn(_("malloc failed in blkent_prepend (%u bytes)\n"),
-			BLKENT_SIZE(oldent->nblks + c));
-		*entp = newent;
-		return;
-	}
-	newent->nblks = oldent->nblks + c;
-	newent->startoff = oldent->startoff - c;
-	for (i = 0; i < c; i++)
-		newent->blks[i] = b + c;
-	for (; i < oldent->nblks + c; i++)
-		newent->blks[i] = oldent->blks[i - c];
-	free(oldent);
-	*entp = newent;
-}
+pthread_key_t	dblkmap_key;
+pthread_key_t	ablkmap_key;
 
-/*
- * Allocate a block map.
- */
 blkmap_t *
 blkmap_alloc(
-	xfs_extnum_t	nex)
+	xfs_extnum_t	nex,
+	int		whichfork)
 {
+	pthread_key_t	key;
 	blkmap_t	*blkmap;
 
+	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
+
 	if (nex < 1)
 		nex = 1;
-	if ((blkmap = malloc(BLKMAP_SIZE(nex))) == NULL) {
-		do_warn(_("malloc failed in blkmap_alloc (%u bytes)\n"),
-			BLKMAP_SIZE(nex));
-		return blkmap;
+
+	key = whichfork ? ablkmap_key : dblkmap_key;
+	blkmap = pthread_getspecific(key);
+	if (!blkmap || blkmap->naexts < nex) {
+		blkmap = realloc(blkmap, BLKMAP_SIZE(nex));
+		if (!blkmap) {
+			do_warn(_("malloc failed in blkmap_alloc (%u bytes)\n"),
+				BLKMAP_SIZE(nex));
+			return NULL;
+		}
+		pthread_setspecific(key, blkmap);
+		blkmap->naexts = nex;
 	}
-	blkmap->naents = nex;
-	blkmap->nents = 0;
+
+	blkmap->nexts = 0;
 	return blkmap;
 }
 
@@ -131,14 +71,7 @@ void
 blkmap_free(
 	blkmap_t	*blkmap)
 {
-	blkent_t	**entp;
-	xfs_extnum_t	i;
-
-	if (blkmap == NULL)
-		return;
-	for (i = 0, entp = blkmap->ents; i < blkmap->nents; i++, entp++)
-		free(*entp);
-	free(blkmap);
+	/* nothing to do! - keep the memory around for the next inode */
 }
 
 /*
@@ -149,20 +82,18 @@ blkmap_get(
 	blkmap_t	*blkmap,
 	xfs_dfiloff_t	o)
 {
-	blkent_t	*ent;
-	blkent_t	**entp;
+	bmap_ext_t	*ext = blkmap->exts;
 	int		i;
 
-	for (i = 0, entp = blkmap->ents; i < blkmap->nents; i++, entp++) {
-		ent = *entp;
-		if (o >= ent->startoff && o < ent->startoff + ent->nblks)
-			return ent->blks[o - ent->startoff];
+	for (i = 0; i < blkmap->nexts; i++, ext++) {
+		if (o >= ext->startoff && o < ext->startoff + ext->blockcount)
+			return ext->startblock + (o - ext->startoff);
 	}
 	return NULLDFSBNO;
 }
 
 /*
- * Get a chunk of entries from a block map.
+ * Get a chunk of entries from a block map - only used for reading dirv2 blocks
  */
 int
 blkmap_getn(
@@ -172,93 +103,62 @@ blkmap_getn(
 	bmap_ext_t	**bmpp,
 	bmap_ext_t	*bmpp_single)
 {
-	bmap_ext_t	*bmp;
-	blkent_t	*ent;
-	xfs_dfiloff_t	ento;
-	blkent_t	**entp;
+	bmap_ext_t	*bmp = NULL;
+	bmap_ext_t	*ext;
 	int		i;
 	int		nex;
 
 	if (nb == 1) {
-		/* 
+		/*
 		 * in the common case, when mp->m_dirblkfsbs == 1,
 		 * avoid additional malloc/free overhead
 		 */
 		bmpp_single->startblock = blkmap_get(blkmap, o);
-		bmpp_single->blockcount = 1;
-		bmpp_single->startoff = 0;
-		bmpp_single->flag = 0;
-		*bmpp = bmpp_single;
-		return (bmpp_single->startblock != NULLDFSBNO) ? 1 : 0;
+		goto single_ext;
 	}
-	for (i = nex = 0, bmp = NULL, entp = blkmap->ents;
-	     i < blkmap->nents;
-	     i++, entp++) {
-		ent = *entp;
-		if (ent->startoff >= o + nb)
+	ext = blkmap->exts;
+	nex = 0;
+	for (i = 0; i < blkmap->nexts; i++, ext++) {
+
+		if (ext->startoff >= o + nb)
 			break;
-		if (ent->startoff + ent->nblks <= o)
+		if (ext->startoff + ext->blockcount <= o)
 			continue;
-		for (ento = ent->startoff;
-		     ento < ent->startoff + ent->nblks && ento < o + nb;
-		     ento++) {
-			if (ento < o)
-				continue;
-			if (bmp &&
-			    bmp[nex - 1].startoff + bmp[nex - 1].blockcount ==
-				    ento &&
-			    bmp[nex - 1].startblock + bmp[nex - 1].blockcount ==
-				    ent->blks[ento - ent->startoff])
-				bmp[nex - 1].blockcount++;
-			else {
-				bmp = realloc(bmp, ++nex * sizeof(*bmp));
-				if (bmp == NULL) {
-					do_warn(_("blkmap_getn realloc failed"
-						" (%u bytes)\n"),
-						nex * sizeof(*bmp));
-					continue;
-				}
-				bmp[nex - 1].startoff = ento;
-				bmp[nex - 1].startblock =
-					ent->blks[ento - ent->startoff];
-				bmp[nex - 1].blockcount = 1;
-				bmp[nex - 1].flag = 0;
-			}
+
+		/*
+		 * if all the requested blocks are in one extent (also common),
+		 * use the bmpp_single option as well
+		 */
+		if (!bmp && o >= ext->startoff &&
+		    o + nb <= ext->startoff + ext->blockcount) {
+			bmpp_single->startblock =
+				 ext->startblock + (o - ext->startoff);
+			goto single_ext;
 		}
+
+		/*
+		 * rare case - multiple extents for a single dir block
+		 */
+		bmp = malloc(nb * sizeof(bmap_ext_t));
+		if (!bmp)
+			do_error(_("blkmap_getn malloc failed (%u bytes)\n"),
+						nb * sizeof(bmap_ext_t));
+
+		bmp[nex].startblock = ext->startblock + (o - ext->startoff);
+		bmp[nex].blockcount = MIN(nb, ext->blockcount -
+				(bmp[nex].startblock - ext->startblock));
+		o += bmp[nex].blockcount;
+		nb -= bmp[nex].blockcount;
+		nex++;
 	}
 	*bmpp = bmp;
 	return nex;
-}
-
-/*
- * Make a block map larger.
- */
-void
-blkmap_grow(
-	blkmap_t	**blkmapp,
-	blkent_t	**entp,
-	blkent_t	*newent)
-{
-	blkmap_t	*blkmap;
-	size_t		size;
-	int		i;
-	int		idx;
 
-	blkmap = *blkmapp;
-	idx = (int)(entp - blkmap->ents);
-	if (blkmap->naents == blkmap->nents) {
-		size = BLKMAP_SIZE(blkmap->nents + 1);
-		if ((*blkmapp = blkmap = realloc(blkmap, size)) == NULL) {
-			do_warn(_("realloc failed in blkmap_grow (%u bytes)\n"),
-				size);
-			return;
-		}
-		blkmap->naents++;
-	}
-	for (i = blkmap->nents; i > idx; i--)
-		blkmap->ents[i] = blkmap->ents[i - 1];
-	blkmap->ents[idx] = newent;
-	blkmap->nents++;
+single_ext:
+	bmpp_single->blockcount = nb;
+	bmpp_single->startoff = 0;	/* not even used by caller! */
+	*bmpp = bmpp_single;
+	return (bmpp_single->startblock != NULLDFSBNO) ? 1 : 0;
 }
 
 /*
@@ -268,12 +168,12 @@ xfs_dfiloff_t
 blkmap_last_off(
 	blkmap_t	*blkmap)
 {
-	blkent_t	*ent;
+	bmap_ext_t	*ext;
 
-	if (!blkmap->nents)
+	if (!blkmap->nexts)
 		return NULLDFILOFF;
-	ent = blkmap->ents[blkmap->nents - 1];
-	return ent->startoff + ent->nblks;
+	ext = blkmap->exts + blkmap->nexts - 1;
+	return ext->startoff + ext->blockcount;
 }
 
 /*
@@ -285,73 +185,45 @@ blkmap_next_off(
 	xfs_dfiloff_t	o,
 	int		*t)
 {
-	blkent_t	*ent;
-	blkent_t	**entp;
+	bmap_ext_t	*ext;
 
-	if (!blkmap->nents)
+	if (!blkmap->nexts)
 		return NULLDFILOFF;
 	if (o == NULLDFILOFF) {
 		*t = 0;
-		ent = blkmap->ents[0];
-		return ent->startoff;
+		return blkmap->exts[0].startoff;
 	}
-	entp = &blkmap->ents[*t];
-	ent = *entp;
-	if (o < ent->startoff + ent->nblks - 1)
+	ext = blkmap->exts + *t;
+	if (o < ext->startoff + ext->blockcount - 1)
 		return o + 1;
-	entp++;
-	if (entp >= &blkmap->ents[blkmap->nents])
+	if (*t >= blkmap->nexts - 1)
 		return NULLDFILOFF;
 	(*t)++;
-	ent = *entp;
-	return ent->startoff;
+	return ext[1].startoff;
 }
 
 /*
- * Set a block value in a block map.
+ * Make a block map larger.
  */
-void
-blkmap_set_blk(
-	blkmap_t	**blkmapp,
-	xfs_dfiloff_t	o,
-	xfs_dfsbno_t	b)
+static blkmap_t *
+blkmap_grow(
+	blkmap_t	**blkmapp)
 {
-	blkmap_t	*blkmap;
-	blkent_t	*ent;
-	blkent_t	**entp;
-	blkent_t	*nextent;
-
-	blkmap = *blkmapp;
-	for (entp = blkmap->ents; entp < &blkmap->ents[blkmap->nents]; entp++) {
-		ent = *entp;
-		if (o < ent->startoff - 1) {
-			ent = blkent_new(o, b, 1);
-			blkmap_grow(blkmapp, entp, ent);
-			return;
-		}
-		if (o == ent->startoff - 1) {
-			blkent_prepend(entp, b, 1);
-			return;
-		}
-		if (o >= ent->startoff && o < ent->startoff + ent->nblks) {
-			ent->blks[o - ent->startoff] = b;
-			return;
-		}
-		if (o > ent->startoff + ent->nblks)
-			continue;
-		blkent_append(entp, b, 1);
-		if (entp == &blkmap->ents[blkmap->nents - 1])
-			return;
-		ent = *entp;
-		nextent = entp[1];
-		if (ent->startoff + ent->nblks < nextent->startoff)
-			return;
-		blkent_append(entp, nextent->blks[0], nextent->nblks);
-		blkmap_shrink(blkmap, &entp[1]);
-		return;
+	pthread_key_t	key = dblkmap_key;
+	blkmap_t	*blkmap = *blkmapp;
+
+	if (pthread_getspecific(key) != blkmap) {
+		key = ablkmap_key;
+		ASSERT(pthread_getspecific(key) == blkmap);
 	}
-	ent = blkent_new(o, b, 1);
-	blkmap_grow(blkmapp, entp, ent);
+
+	blkmap->naexts += 4;
+	blkmap = realloc(blkmap, BLKMAP_SIZE(blkmap->naexts));
+	if (blkmap == NULL)
+		do_error(_("realloc failed in blkmap_grow\n"));
+	*blkmapp = blkmap;
+	pthread_setspecific(key, blkmap);
+	return blkmap;
 }
 
 /*
@@ -364,46 +236,23 @@ blkmap_set_ext(
 	xfs_dfsbno_t	b,
 	xfs_dfilblks_t	c)
 {
-	blkmap_t	*blkmap;
-	blkent_t	*ent;
-	blkent_t	**entp;
+	blkmap_t	*blkmap = *blkmapp;
 	xfs_extnum_t	i;
 
-	blkmap = *blkmapp;
-	if (!blkmap->nents) {
-		blkmap->ents[0] = blkent_new(o, b, c);
-		blkmap->nents = 1;
-		return;
-	}
-	entp = &blkmap->ents[blkmap->nents - 1];
-	ent = *entp;
-	if (ent->startoff + ent->nblks == o) {
-		blkent_append(entp, b, c);
-		return;
-	}
-	if (ent->startoff + ent->nblks < o) {
-		ent = blkent_new(o, b, c);
-		blkmap_grow(blkmapp, &blkmap->ents[blkmap->nents], ent);
-		return;
-	}
-	for (i = 0; i < c; i++)
-		blkmap_set_blk(blkmapp, o + i, b + i);
-}
+	if (blkmap->nexts == blkmap->naexts)
+		blkmap = blkmap_grow(blkmapp);
 
-/*
- * Make a block map smaller.
- */
-void
-blkmap_shrink(
-	blkmap_t	*blkmap,
-	blkent_t	**entp)
-{
-	int		i;
-	int		idx;
+	for (i = 0; i < blkmap->nexts; i++) {
+		if (blkmap->exts[i].startoff > o) {
+			memmove(blkmap->exts + i + 1,
+				blkmap->exts + i,
+				sizeof(bmap_ext_t) * (blkmap->nexts - i));
+			break;
+		}
+	}
 
-	free(*entp);
-	idx = (int)(entp - blkmap->ents);
-	for (i = idx + 1; i < blkmap->nents; i++)
-		blkmap->ents[i] = blkmap->ents[i - 1];
-	blkmap->nents--;
+	blkmap->exts[i].startoff = o;
+	blkmap->exts[i].startblock = b;
+	blkmap->exts[i].blockcount = c;
+	blkmap->nexts++;
 }
Index: xfsprogs-dev/repair/bmap.h
===================================================================
--- xfsprogs-dev.orig/repair/bmap.h	2009-08-20 02:32:34.000000000 +0000
+++ xfsprogs-dev/repair/bmap.h	2009-08-20 02:32:45.000000000 +0000
@@ -16,59 +16,41 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-/*
- * Block mapping code taken from xfs_db.
- */
+#ifndef _XFS_REPAIR_BMAP_H
+#define _XFS_REPAIR_BMAP_H
 
 /*
- * Block map entry.
+ * Extent descriptor.
  */
-typedef struct blkent {
+typedef struct bmap_ext {
 	xfs_dfiloff_t	startoff;
-	xfs_dfilblks_t	nblks;
-	xfs_dfsbno_t	blks[1];
-} blkent_t;
-#define	BLKENT_SIZE(n)	\
-	(offsetof(blkent_t, blks) + (sizeof(xfs_dfsbno_t) * (n)))
+	xfs_dfsbno_t	startblock;
+	xfs_dfilblks_t	blockcount;
+} bmap_ext_t;
 
 /*
  * Block map.
  */
 typedef	struct blkmap {
-	int		naents;
-	int		nents;
-	blkent_t	*ents[1];
+	int		naexts;
+	int		nexts;
+	bmap_ext_t	exts[1];
 } blkmap_t;
-#define	BLKMAP_SIZE(n)	\
-	(offsetof(blkmap_t, ents) + (sizeof(blkent_t *) * (n)))
 
-/*
- * Extent descriptor.
- */
-typedef struct bmap_ext {
-	xfs_dfiloff_t	startoff;
-	xfs_dfsbno_t	startblock;
-	xfs_dfilblks_t	blockcount;
-	int		flag;
-} bmap_ext_t;
+#define	BLKMAP_SIZE(n)	\
+	(offsetof(blkmap_t, exts) + (sizeof(bmap_ext_t) * (n)))
 
-void		blkent_append(blkent_t **entp, xfs_dfsbno_t b,
-			      xfs_dfilblks_t c);
-blkent_t	*blkent_new(xfs_dfiloff_t o, xfs_dfsbno_t b, xfs_dfilblks_t c);
-void		blkent_prepend(blkent_t **entp, xfs_dfsbno_t b,
-			       xfs_dfilblks_t c);
-blkmap_t	*blkmap_alloc(xfs_extnum_t);
+blkmap_t	*blkmap_alloc(xfs_extnum_t nex, int whichfork);
 void		blkmap_free(blkmap_t *blkmap);
+
+void		blkmap_set_ext(blkmap_t **blkmapp, xfs_dfiloff_t o,
+			       xfs_dfsbno_t b, xfs_dfilblks_t c);
+
 xfs_dfsbno_t	blkmap_get(blkmap_t *blkmap, xfs_dfiloff_t o);
 int		blkmap_getn(blkmap_t *blkmap, xfs_dfiloff_t o,
-			    xfs_dfilblks_t nb, bmap_ext_t **bmpp, 
+			    xfs_dfilblks_t nb, bmap_ext_t **bmpp,
 			    bmap_ext_t *bmpp_single);
-void		blkmap_grow(blkmap_t **blkmapp, blkent_t **entp,
-			    blkent_t *newent);
 xfs_dfiloff_t	blkmap_last_off(blkmap_t *blkmap);
 xfs_dfiloff_t	blkmap_next_off(blkmap_t *blkmap, xfs_dfiloff_t o, int *t);
-void		blkmap_set_blk(blkmap_t **blkmapp, xfs_dfiloff_t o,
-			       xfs_dfsbno_t b);
-void		blkmap_set_ext(blkmap_t **blkmapp, xfs_dfiloff_t o,
-			       xfs_dfsbno_t b, xfs_dfilblks_t c);
-void		blkmap_shrink(blkmap_t *blkmap, blkent_t **entp);
+
+#endif /* _XFS_REPAIR_BMAP_H */
Index: xfsprogs-dev/repair/dinode.c
===================================================================
--- xfsprogs-dev.orig/repair/dinode.c	2009-08-20 02:32:34.000000000 +0000
+++ xfsprogs-dev/repair/dinode.c	2009-08-21 01:23:34.000000000 +0000
@@ -2050,7 +2050,7 @@ process_inode_data_fork(
 		*nextents = 1;
 
 	if (dinoc->di_format != XFS_DINODE_FMT_LOCAL && type != XR_INO_RTDATA)
-		*dblkmap = blkmap_alloc(*nextents);
+		*dblkmap = blkmap_alloc(*nextents, XFS_DATA_FORK);
 	*nextents = 0;
 
 	switch (dinoc->di_format) {
@@ -2172,14 +2172,14 @@ process_inode_attr_fork(
 		err = process_lclinode(mp, agno, ino, dino, XFS_ATTR_FORK);
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
-		ablkmap = blkmap_alloc(*anextents);
+		ablkmap = blkmap_alloc(*anextents, XFS_ATTR_FORK);
 		*anextents = 0;
 		err = process_exinode(mp, agno, ino, dino, type, dirty,
 				atotblocks, anextents, &ablkmap,
 				XFS_ATTR_FORK, check_dups);
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		ablkmap = blkmap_alloc(*anextents);
+		ablkmap = blkmap_alloc(*anextents, XFS_ATTR_FORK);
 		*anextents = 0;
 		err = process_btinode(mp, agno, ino, dino, type, dirty,
 				atotblocks, anextents, &ablkmap,
Index: xfsprogs-dev/repair/init.c
===================================================================
--- xfsprogs-dev.orig/repair/init.c	2009-08-20 02:32:34.000000000 +0000
+++ xfsprogs-dev/repair/init.c	2009-08-20 02:32:45.000000000 +0000
@@ -24,19 +24,24 @@
 #include "pthread.h"
 #include "avl.h"
 #include "dir.h"
+#include "bmap.h"
 #include "incore.h"
 #include "prefetch.h"
 #include <sys/resource.h>
 
+/* TODO: dirbuf/freemap key usage is completely b0rked - only used for dirv1 */
 static pthread_key_t dirbuf_key;
 static pthread_key_t dir_freemap_key;
 static pthread_key_t attr_freemap_key;
 
+extern pthread_key_t dblkmap_key;
+extern pthread_key_t ablkmap_key;
+
 static void
 ts_alloc(pthread_key_t key, unsigned n, size_t size)
 {
 	void *voidp;
-	voidp = malloc((n)*(size));
+	voidp = calloc(n, size);
 	if (voidp == NULL) {
 		do_error(_("ts_alloc: cannot allocate thread specific storage\n"));
 		/* NO RETURN */
@@ -52,6 +57,9 @@ ts_create(void)
 	pthread_key_create(&dirbuf_key, NULL);
 	pthread_key_create(&dir_freemap_key, NULL);
 	pthread_key_create(&attr_freemap_key, NULL);
+
+	pthread_key_create(&dblkmap_key, NULL);
+	pthread_key_create(&ablkmap_key, NULL);
 }
 
 void

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
