Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 15:02:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8TM2XcV000745
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 15:02:33 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6066A9B27BE
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 15:04:07 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id M3JndxuINCJIQ2WV for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 15:04:07 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m8TM45IF031210
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2008 00:04:05 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m8TM45RO031208
	for xfs@oss.sgi.com; Tue, 30 Sep 2008 00:04:05 +0200
Date: Tue, 30 Sep 2008 00:04:05 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] consolidate btree block handling for xfs_db
Message-ID: <20080929220405.GA31113@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Currently xfs_db has five different implementations for poking at btree
blocks, even duplicating code for btree blocks with entirely identical
layout (bmapbta vs bmapbtd and bno vs cnt).  Merge all these into
a single implementation that uses a table of btree characteristics keyed
of their magic number.

There's probably a way to further consolidate the magic arrays for the
different types, but I don't quite understand xfs_db's table driven
command parser for that.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-cmds/xfsprogs/db/bmapbt.c
===================================================================
--- xfs-cmds.orig/xfsprogs/db/bmapbt.c	2008-09-25 20:23:21.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,329 +0,0 @@
-/*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-#include <xfs/libxfs.h>
-#include "type.h"
-#include "faddr.h"
-#include "fprint.h"
-#include "field.h"
-#include "bmapbt.h"
-#include "print.h"
-#include "bit.h"
-#include "init.h"
-
-static int	bmapbta_key_count(void *obj, int startoff);
-static int	bmapbta_key_offset(void *obj, int startoff, int idx);
-static int	bmapbta_ptr_count(void *obj, int startoff);
-static int	bmapbta_ptr_offset(void *obj, int startoff, int idx);
-static int	bmapbta_rec_count(void *obj, int startoff);
-static int	bmapbta_rec_offset(void *obj, int startoff, int idx);
-static int	bmapbtd_key_count(void *obj, int startoff);
-static int	bmapbtd_key_offset(void *obj, int startoff, int idx);
-static int	bmapbtd_ptr_count(void *obj, int startoff);
-static int	bmapbtd_ptr_offset(void *obj, int startoff, int idx);
-static int	bmapbtd_rec_count(void *obj, int startoff);
-static int	bmapbtd_rec_offset(void *obj, int startoff, int idx);
-
-const field_t	bmapbta_hfld[] = {
-	{ "", FLDT_BMAPBTA, OI(0), C1, 0, TYP_NONE },
-	{ NULL }
-};
-const field_t	bmapbtd_hfld[] = {
-	{ "", FLDT_BMAPBTD, OI(0), C1, 0, TYP_NONE },
-	{ NULL }
-};
-
-#define	OFF(f)	bitize(offsetof(xfs_bmbt_block_t, bb_ ## f))
-const field_t	bmapbta_flds[] = {
-	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
-	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
-	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
-	{ "leftsib", FLDT_DFSBNO, OI(OFF(leftsib)), C1, 0, TYP_BMAPBTA },
-	{ "rightsib", FLDT_DFSBNO, OI(OFF(rightsib)), C1, 0, TYP_BMAPBTA },
-	{ "recs", FLDT_BMAPBTAREC, bmapbta_rec_offset, bmapbta_rec_count,
-	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
-	{ "keys", FLDT_BMAPBTAKEY, bmapbta_key_offset, bmapbta_key_count,
-	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
-	{ "ptrs", FLDT_BMAPBTAPTR, bmapbta_ptr_offset, bmapbta_ptr_count,
-	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_BMAPBTA },
-	{ NULL }
-};
-const field_t	bmapbtd_flds[] = {
-	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
-	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
-	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
-	{ "leftsib", FLDT_DFSBNO, OI(OFF(leftsib)), C1, 0, TYP_BMAPBTD },
-	{ "rightsib", FLDT_DFSBNO, OI(OFF(rightsib)), C1, 0, TYP_BMAPBTD },
-	{ "recs", FLDT_BMAPBTDREC, bmapbtd_rec_offset, bmapbtd_rec_count,
-	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
-	{ "keys", FLDT_BMAPBTDKEY, bmapbtd_key_offset, bmapbtd_key_count,
-	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
-	{ "ptrs", FLDT_BMAPBTDPTR, bmapbtd_ptr_offset, bmapbtd_ptr_count,
-	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_BMAPBTD },
-	{ NULL }
-};
-
-#define	KOFF(f)	bitize(offsetof(xfs_bmbt_key_t, br_ ## f))
-const field_t	bmapbta_key_flds[] = {
-	{ "startoff", FLDT_DFILOFFA, OI(KOFF(startoff)), C1, 0, TYP_ATTR },
-	{ NULL }
-};
-const field_t	bmapbtd_key_flds[] = {
-	{ "startoff", FLDT_DFILOFFD, OI(KOFF(startoff)), C1, 0, TYP_INODATA },
-	{ NULL }
-};
-
-#ifndef XFS_NATIVE_HOST
-
-#define BMBT_EXNTFLAG_BITOFF	0
-#define BMBT_STARTOFF_BITOFF	(BMBT_EXNTFLAG_BITOFF + BMBT_EXNTFLAG_BITLEN)
-#define BMBT_STARTBLOCK_BITOFF	(BMBT_STARTOFF_BITOFF + BMBT_STARTOFF_BITLEN)
-#define BMBT_BLOCKCOUNT_BITOFF	\
-	(BMBT_STARTBLOCK_BITOFF + BMBT_STARTBLOCK_BITLEN)
-
-#else
-
-#define BMBT_EXNTFLAG_BITOFF	63
-#define BMBT_STARTOFF_BITOFF	(BMBT_EXNTFLAG_BITOFF - BMBT_STARTOFF_BITLEN)
-#define BMBT_STARTBLOCK_BITOFF	85 /* 128 - 43 (other 9 is in first word) */
-#define BMBT_BLOCKCOUNT_BITOFF	64 /* Start of second 64 bit container */
-
-#endif /* XFS_NATIVE_HOST */
-
-const field_t	bmapbta_rec_flds[] = {
-	{ "startoff", FLDT_CFILEOFFA, OI(BMBT_STARTOFF_BITOFF), C1, 0,
-	  TYP_ATTR },
-	{ "startblock", FLDT_CFSBLOCK, OI(BMBT_STARTBLOCK_BITOFF), C1, 0,
-	  TYP_ATTR },
-	{ "blockcount", FLDT_CEXTLEN, OI(BMBT_BLOCKCOUNT_BITOFF), C1, 0,
-	  TYP_NONE },
-	{ "extentflag", FLDT_CEXTFLG, OI(BMBT_EXNTFLAG_BITOFF), C1, 0,
-	  TYP_NONE },
-	{ NULL }
-};
-const field_t	bmapbtd_rec_flds[] = {
-	{ "startoff", FLDT_CFILEOFFD, OI(BMBT_STARTOFF_BITOFF), C1, 0,
-	  TYP_INODATA },
-	{ "startblock", FLDT_CFSBLOCK, OI(BMBT_STARTBLOCK_BITOFF), C1, 0,
-	  TYP_INODATA },
-	{ "blockcount", FLDT_CEXTLEN, OI(BMBT_BLOCKCOUNT_BITOFF), C1, 0,
-	  TYP_NONE },
-	{ "extentflag", FLDT_CEXTFLG, OI(BMBT_EXNTFLAG_BITOFF), C1, 0,
-	  TYP_NONE },
-	{ NULL }
-};
-
-static int
-bmapbta_key_count(
-	void			*obj,
-	int			startoff)
-{
-	xfs_bmbt_block_t	*block;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	if (be16_to_cpu(block->bb_level) == 0)
-		return 0;
-	return be16_to_cpu(block->bb_numrecs);
-}
-
-static int
-bmapbta_key_offset(
-	void			*obj,
-	int			startoff,
-	int			idx)
-{
-	xfs_bmbt_block_t	*block;
-	xfs_bmbt_key_t		*kp;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	ASSERT(be16_to_cpu(block->bb_level) > 0);
-	kp = XFS_BTREE_KEY_ADDR(xfs_bmbt, block, idx);
-	return bitize((int)((char *)kp - (char *)block));
-}
-
-static int
-bmapbta_ptr_count(
-	void			*obj,
-	int			startoff)
-{
-	xfs_bmbt_block_t	*block;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	if (be16_to_cpu(block->bb_level) == 0)
-		return 0;
-	return be16_to_cpu(block->bb_numrecs);
-}
-
-static int
-bmapbta_ptr_offset(
-	void			*obj,
-	int			startoff,
-	int			idx)
-{
-	xfs_bmbt_block_t	*block;
-	xfs_bmbt_ptr_t		*pp;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	ASSERT(be16_to_cpu(block->bb_level) > 0);
-	pp = XFS_BTREE_PTR_ADDR(xfs_bmbt, block, idx,
-		XFS_BTREE_BLOCK_MAXRECS(mp->m_sb.sb_blocksize, xfs_bmbt, 0));
-	return bitize((int)((char *)pp - (char *)block));
-}
-
-static int
-bmapbta_rec_count(
-	void			*obj,
-	int			startoff)
-{
-	xfs_bmbt_block_t	*block;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	if (be16_to_cpu(block->bb_level) > 0)
-		return 0;
-	return be16_to_cpu(block->bb_numrecs);
-}
-
-static int
-bmapbta_rec_offset(
-	void			*obj,
-	int			startoff,
-	int			idx)
-{
-	xfs_bmbt_block_t	*block;
-	xfs_bmbt_rec_t		*rp;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	ASSERT(be16_to_cpu(block->bb_level) == 0);
-	rp = XFS_BTREE_REC_ADDR(xfs_bmbt, block, idx);
-	return bitize((int)((char *)rp - (char *)block));
-}
-
-int
-bmapbta_size(
-	void	*obj,
-	int	startoff,
-	int	idx)
-{
-	return bitize(mp->m_sb.sb_blocksize);
-}
-
-static int
-bmapbtd_key_count(
-	void			*obj,
-	int			startoff)
-{
-	xfs_bmbt_block_t	*block;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	if (be16_to_cpu(block->bb_level) == 0)
-		return 0;
-	return be16_to_cpu(block->bb_numrecs);
-}
-
-static int
-bmapbtd_key_offset(
-	void			*obj,
-	int			startoff,
-	int			idx)
-{
-	xfs_bmbt_block_t	*block;
-	xfs_bmbt_key_t		*kp;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	ASSERT(be16_to_cpu(block->bb_level) > 0);
-	kp = XFS_BTREE_KEY_ADDR(xfs_bmbt, block, idx);
-	return bitize((int)((char *)kp - (char *)block));
-}
-
-static int
-bmapbtd_ptr_count(
-	void			*obj,
-	int			startoff)
-{
-	xfs_bmbt_block_t	*block;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	if (be16_to_cpu(block->bb_level) == 0)
-		return 0;
-	return be16_to_cpu(block->bb_numrecs);
-}
-
-static int
-bmapbtd_ptr_offset(
-	void			*obj,
-	int			startoff,
-	int			idx)
-{
-	xfs_bmbt_block_t	*block;
-	xfs_bmbt_ptr_t		*pp;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	ASSERT(be16_to_cpu(block->bb_level) > 0);
-	pp = XFS_BTREE_PTR_ADDR(xfs_bmbt, block, idx,
-		XFS_BTREE_BLOCK_MAXRECS(mp->m_sb.sb_blocksize, xfs_bmbt, 0));
-	return bitize((int)((char *)pp - (char *)block));
-}
-
-static int
-bmapbtd_rec_count(
-	void			*obj,
-	int			startoff)
-{
-	xfs_bmbt_block_t	*block;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	if (be16_to_cpu(block->bb_level) > 0)
-		return 0;
-	return be16_to_cpu(block->bb_numrecs);
-}
-
-static int
-bmapbtd_rec_offset(
-	void			*obj,
-	int			startoff,
-	int			idx)
-{
-	xfs_bmbt_block_t	*block;
-	xfs_bmbt_rec_t		*rp;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	ASSERT(be16_to_cpu(block->bb_level) == 0);
-	rp = XFS_BTREE_REC_ADDR(xfs_bmbt, block, idx);
-	return bitize((int)((char *)rp - (char *)block));
-}
-
-int
-bmapbtd_size(
-	void	*obj,
-	int	startoff,
-	int	idx)
-{
-	return bitize(mp->m_sb.sb_blocksize);
-}
Index: xfs-cmds/xfsprogs/db/bmapbt.h
===================================================================
--- xfs-cmds.orig/xfsprogs/db/bmapbt.h	2008-09-25 20:23:21.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,29 +0,0 @@
-/*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-extern const struct field	bmapbta_flds[];
-extern const struct field	bmapbta_hfld[];
-extern const struct field	bmapbta_key_flds[];
-extern const struct field	bmapbta_rec_flds[];
-extern const struct field	bmapbtd_flds[];
-extern const struct field	bmapbtd_hfld[];
-extern const struct field	bmapbtd_key_flds[];
-extern const struct field	bmapbtd_rec_flds[];
-
-extern int	bmapbta_size(void *obj, int startoff, int idx);
-extern int	bmapbtd_size(void *obj, int startoff, int idx);
Index: xfs-cmds/xfsprogs/db/field.c
===================================================================
--- xfs-cmds.orig/xfsprogs/db/field.c	2008-09-25 20:23:21.000000000 +0200
+++ xfs-cmds/xfsprogs/db/field.c	2008-09-29 23:54:59.000000000 +0200
@@ -22,10 +22,7 @@
 #include "fprint.h"
 #include "field.h"
 #include "inode.h"
-#include "bnobt.h"
-#include "cntbt.h"
-#include "inobt.h"
-#include "bmapbt.h"
+#include "btblock.h"
 #include "bmroot.h"
 #include "bit.h"
 #include "agf.h"
@@ -87,7 +84,7 @@ const ftattr_t	ftattrtab[] = {
 	  fa_attrblock, NULL },
 	{ FLDT_ATTRSHORT, "attrshort", NULL, (char *)attr_shortform_flds,
 	  attrshort_size, FTARG_SIZE, NULL, attr_shortform_flds },
-	{ FLDT_BMAPBTA, "bmapbta", NULL, (char *)bmapbta_flds, bmapbta_size,
+	{ FLDT_BMAPBTA, "bmapbta", NULL, (char *)bmapbta_flds, btblock_size,
 	  FTARG_SIZE, NULL, bmapbta_flds },
 	{ FLDT_BMAPBTAKEY, "bmapbtakey", fp_sarray, (char *)bmapbta_key_flds,
 	  SI(bitsz(xfs_bmbt_key_t)), 0, NULL, bmapbta_key_flds },
@@ -95,7 +92,7 @@ const ftattr_t	ftattrtab[] = {
 	  SI(bitsz(xfs_bmbt_ptr_t)), 0, fa_dfsbno, NULL },
 	{ FLDT_BMAPBTAREC, "bmapbtarec", fp_sarray, (char *)bmapbta_rec_flds,
 	  SI(bitsz(xfs_bmbt_rec_t)), 0, NULL, bmapbta_rec_flds },
-	{ FLDT_BMAPBTD, "bmapbtd", NULL, (char *)bmapbtd_flds, bmapbtd_size,
+	{ FLDT_BMAPBTD, "bmapbtd", NULL, (char *)bmapbtd_flds, btblock_size,
 	  FTARG_SIZE, NULL, bmapbtd_flds },
 	{ FLDT_BMAPBTDKEY, "bmapbtdkey", fp_sarray, (char *)bmapbtd_key_flds,
 	  SI(bitsz(xfs_bmbt_key_t)), 0, NULL, bmapbtd_key_flds },
@@ -115,7 +112,7 @@ const ftattr_t	ftattrtab[] = {
 	  SI(bitsz(xfs_bmdr_key_t)), 0, NULL, bmrootd_key_flds },
 	{ FLDT_BMROOTDPTR, "bmrootdptr", fp_num, "%llu",
 	  SI(bitsz(xfs_bmdr_ptr_t)), 0, fa_dfsbno, NULL },
-	{ FLDT_BNOBT, "bnobt", NULL, (char *)bnobt_flds, bnobt_size, FTARG_SIZE,
+	{ FLDT_BNOBT, "bnobt", NULL, (char *)bnobt_flds, btblock_size, FTARG_SIZE,
 	  NULL, bnobt_flds },
 	{ FLDT_BNOBTKEY, "bnobtkey", fp_sarray, (char *)bnobt_key_flds,
 	  SI(bitsz(xfs_alloc_key_t)), 0, NULL, bnobt_key_flds },
@@ -136,7 +133,7 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_CHARNS, "charns", fp_charns, NULL, SI(bitsz(char)), 0, NULL,
 	  NULL },
 	{ FLDT_CHARS, "chars", fp_num, "%c", SI(bitsz(char)), 0, NULL, NULL },
-	{ FLDT_CNTBT, "cntbt", NULL, (char *)cntbt_flds, cntbt_size, FTARG_SIZE,
+	{ FLDT_CNTBT, "cntbt", NULL, (char *)cntbt_flds, btblock_size, FTARG_SIZE,
 	  NULL, cntbt_flds },
 	{ FLDT_CNTBTKEY, "cntbtkey", fp_sarray, (char *)cntbt_key_flds,
 	  SI(bitsz(xfs_alloc_key_t)), 0, NULL, cntbt_key_flds },
@@ -247,7 +244,7 @@ const ftattr_t	ftattrtab[] = {
 	  FTARG_SIGNED, NULL, NULL },
 	{ FLDT_INO, "ino", fp_num, "%llu", SI(bitsz(xfs_ino_t)), FTARG_DONULL,
 	  fa_ino, NULL },
-	{ FLDT_INOBT, "inobt",  NULL, (char *)inobt_flds, inobt_size,
+	{ FLDT_INOBT, "inobt",  NULL, (char *)inobt_flds, btblock_size,
 	  FTARG_SIZE, NULL, inobt_flds },
 	{ FLDT_INOBTKEY, "inobtkey", fp_sarray, (char *)inobt_key_flds,
 	  SI(bitsz(xfs_inobt_key_t)), 0, NULL, inobt_key_flds },
Index: xfs-cmds/xfsprogs/db/Makefile
===================================================================
--- xfs-cmds.orig/xfsprogs/db/Makefile	2008-09-25 20:23:21.000000000 +0200
+++ xfs-cmds/xfsprogs/db/Makefile	2008-09-29 23:54:59.000000000 +0200
@@ -8,12 +8,11 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_db
 
 HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
-	bmapbt.h bmroot.h bnobt.h check.h cntbt.h command.h convert.h \
-	dbread.h debug.h dir.h dir2.h dir2sf.h dirshort.h dquot.h echo.h \
-	faddr.h field.h flist.h fprint.h frag.h freesp.h hash.h help.h \
-	init.h inobt.h inode.h input.h io.h malloc.h metadump.h output.h \
-	print.h quit.h sb.h sig.h strvec.h text.h type.h write.h \
-	attrset.h
+	btblock.h bmroot.h check.h command.h convert.h dbread.h debug.h \
+	dir.h dir2.h dir2sf.h dirshort.h dquot.h echo.h faddr.h field.h \
+	flist.h fprint.h frag.h freesp.h hash.h help.h init.h inode.h input.h \
+	io.h malloc.h metadump.h output.h print.h quit.h sb.h sig.h strvec.h \
+	text.h type.h write.h attrset.h
 CFILES = $(HFILES:.h=.c)
 LSRCFILES = xfs_admin.sh xfs_check.sh xfs_ncheck.sh xfs_metadump.sh
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
Index: xfs-cmds/xfsprogs/db/bnobt.c
===================================================================
--- xfs-cmds.orig/xfsprogs/db/bnobt.c	2008-09-25 20:23:21.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,170 +0,0 @@
-/*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-#include <xfs/libxfs.h>
-#include "type.h"
-#include "faddr.h"
-#include "fprint.h"
-#include "field.h"
-#include "bnobt.h"
-#include "io.h"
-#include "print.h"
-#include "bit.h"
-#include "init.h"
-
-static int	bnobt_key_count(void *obj, int startoff);
-static int	bnobt_key_offset(void *obj, int startoff, int idx);
-static int	bnobt_ptr_count(void *obj, int startoff);
-static int	bnobt_ptr_offset(void *obj, int startoff, int idx);
-static int	bnobt_rec_count(void *obj, int startoff);
-static int	bnobt_rec_offset(void *obj, int startoff, int idx);
-
-const field_t	bnobt_hfld[] = {
-	{ "", FLDT_BNOBT, OI(0), C1, 0, TYP_NONE },
-	{ NULL }
-};
-
-#define	OFF(f)	bitize(offsetof(xfs_alloc_block_t, bb_ ## f))
-const field_t	bnobt_flds[] = {
-	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
-	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
-	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
-	{ "leftsib", FLDT_AGBLOCK, OI(OFF(leftsib)), C1, 0, TYP_BNOBT },
-	{ "rightsib", FLDT_AGBLOCK, OI(OFF(rightsib)), C1, 0, TYP_BNOBT },
-	{ "recs", FLDT_BNOBTREC, bnobt_rec_offset, bnobt_rec_count,
-	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
-	{ "keys", FLDT_BNOBTKEY, bnobt_key_offset, bnobt_key_count,
-	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
-	{ "ptrs", FLDT_BNOBTPTR, bnobt_ptr_offset, bnobt_ptr_count,
-	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_BNOBT },
-	{ NULL }
-};
-
-#define	KOFF(f)	bitize(offsetof(xfs_alloc_key_t, ar_ ## f))
-const field_t	bnobt_key_flds[] = {
-	{ "startblock", FLDT_AGBLOCK, OI(KOFF(startblock)), C1, 0, TYP_DATA },
-	{ "blockcount", FLDT_EXTLEN, OI(KOFF(blockcount)), C1, 0, TYP_NONE },
-	{ NULL }
-};
-
-#define	ROFF(f)	bitize(offsetof(xfs_alloc_rec_t, ar_ ## f))
-const field_t	bnobt_rec_flds[] = {
-	{ "startblock", FLDT_AGBLOCK, OI(ROFF(startblock)), C1, 0, TYP_DATA },
-	{ "blockcount", FLDT_EXTLEN, OI(ROFF(blockcount)), C1, 0, TYP_NONE },
-	{ NULL }
-};
-
-static int
-bnobt_key_count(
-	void			*obj,
-	int			startoff)
-{
-	xfs_alloc_block_t	*block;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	if (be16_to_cpu(block->bb_level) == 0)
-		return 0;
-	return be16_to_cpu(block->bb_numrecs);
-}
-
-static int
-bnobt_key_offset(
-	void			*obj,
-	int			startoff,
-	int			idx)
-{
-	xfs_alloc_block_t	*block;
-	xfs_alloc_key_t		*kp;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	ASSERT(be16_to_cpu(block->bb_level) > 0);
-	kp = XFS_BTREE_KEY_ADDR(xfs_alloc, block, idx);
-	return bitize((int)((char *)kp - (char *)block));
-}
-
-static int
-bnobt_ptr_count(
-	void			*obj,
-	int			startoff)
-{
-	xfs_alloc_block_t	*block;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	if (be16_to_cpu(block->bb_level) == 0)
-		return 0;
-	return be16_to_cpu(block->bb_numrecs);
-}
-
-static int
-bnobt_ptr_offset(
-	void			*obj,
-	int			startoff,
-	int			idx)
-{
-	xfs_alloc_block_t	*block;
-	xfs_alloc_ptr_t		*pp;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	ASSERT(be16_to_cpu(block->bb_level) > 0);
-	pp = XFS_BTREE_PTR_ADDR(xfs_alloc, block, idx,
-		XFS_BTREE_BLOCK_MAXRECS(mp->m_sb.sb_blocksize, xfs_alloc, 0));
-	return bitize((int)((char *)pp - (char *)block));
-}
-
-static int
-bnobt_rec_count(
-	void			*obj,
-	int			startoff)
-{
-	xfs_alloc_block_t	*block;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	if (be16_to_cpu(block->bb_level) > 0)
-		return 0;
-	return be16_to_cpu(block->bb_numrecs);
-}
-
-static int
-bnobt_rec_offset(
-	void			*obj,
-	int			startoff,
-	int			idx)
-{
-	xfs_alloc_block_t	*block;
-	xfs_alloc_rec_t		*rp;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	ASSERT(be16_to_cpu(block->bb_level) == 0);
-	rp = XFS_BTREE_REC_ADDR(xfs_alloc, block, idx);
-	return bitize((int)((char *)rp - (char *)block));
-}
-
-int
-bnobt_size(
-	void	*obj,
-	int	startoff,
-	int	idx)
-{
-	return bitize(mp->m_sb.sb_blocksize);
-}
Index: xfs-cmds/xfsprogs/db/bnobt.h
===================================================================
--- xfs-cmds.orig/xfsprogs/db/bnobt.h	2008-09-25 20:23:21.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,24 +0,0 @@
-/*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-extern const struct field	bnobt_flds[];
-extern const struct field	bnobt_hfld[];
-extern const struct field	bnobt_key_flds[];
-extern const struct field	bnobt_rec_flds[];
-
-extern int	bnobt_size(void *obj, int startoff, int idx);
Index: xfs-cmds/xfsprogs/db/btblock.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfs-cmds/xfsprogs/db/btblock.c	2008-09-29 23:54:59.000000000 +0200
@@ -0,0 +1,414 @@
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <xfs/libxfs.h>
+#include "type.h"
+#include "faddr.h"
+#include "fprint.h"
+#include "field.h"
+#include "btblock.h"
+#include "print.h"
+#include "bit.h"
+#include "init.h"
+
+
+/*
+ * Definition of the possible btree block layouts.
+ */
+struct xfs_db_btree {
+	size_t			block_len;
+	size_t			key_len;
+	size_t			rec_len;
+	size_t			ptr_len;
+} btrees[] = {
+	[/*0x424d415*/0] = { /* BMAP */
+		sizeof(struct xfs_btree_lblock),
+		sizeof(xfs_bmbt_key_t),
+		sizeof(xfs_bmbt_rec_t),
+		sizeof(__be64),
+	},
+	[/*0x4142544*/2] = { /* ABTB */
+		sizeof(struct xfs_btree_sblock),
+		sizeof(xfs_alloc_key_t),
+		sizeof(xfs_alloc_rec_t),
+		sizeof(__be32),
+	},
+	[/*0x4142544*/3] = { /* ABTC */
+		sizeof(struct xfs_btree_sblock),
+		sizeof(xfs_alloc_key_t),
+		sizeof(xfs_alloc_rec_t),
+		sizeof(__be32),
+	},
+	[/*0x4941425*/4] = { /* IABT */
+		sizeof(struct xfs_btree_sblock),
+		sizeof(xfs_inobt_key_t),
+		sizeof(xfs_inobt_rec_t),
+		sizeof(__be32),
+	},
+};
+
+/*
+ * Find the right block defintion for a given ondisk block.
+ *
+ * We use the least significant bit of the magic number as index into
+ * the array of block defintions.
+ */
+#define block_to_bt(bb) \
+	(&btrees[be32_to_cpu((bb)->bb_magic) & 0xf])
+
+/* calculate max records.  Only for non-leaves. */
+static int
+btblock_maxrecs(struct xfs_db_btree *bt, int blocksize)
+{
+	blocksize -= bt->block_len;
+
+	return blocksize / (bt->key_len + bt->ptr_len);
+}
+
+/*
+ * Get the number of keys in a btree block.
+ *
+ * Note: can also be used to get the number of ptrs because there are
+ * always the same number of keys and ptrs in a block.
+ */
+static int
+btblock_key_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_btree_block	*block = obj;
+
+	ASSERT(startoff == 0);
+
+	if (block->bb_level == 0)
+		return 0;
+	return be16_to_cpu(block->bb_numrecs);
+}
+
+/*
+ * Get the number of keys in a btree block.
+ */
+static int
+btblock_rec_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_btree_block	*block = obj;
+
+	ASSERT(startoff == 0);
+
+	if (block->bb_level != 0)
+		return 0;
+	return be16_to_cpu(block->bb_numrecs);
+}
+
+/*
+ * Get the offset of the key at idx in a btree block.
+ */
+static int
+btblock_key_offset(
+	void			*obj,
+	int			startoff,
+	int			idx)
+{
+	struct xfs_btree_block	*block = obj;
+	struct xfs_db_btree	*bt = block_to_bt(block);
+	int			offset;
+
+	ASSERT(startoff == 0);
+	ASSERT(block->bb_level != 0);
+
+	offset = bt->block_len + (idx - 1) * bt->key_len;
+	return bitize(offset);
+}
+
+/*
+ * Get the offset of the ptr at idx in a btree block.
+ */
+static int
+btblock_ptr_offset(
+	void			*obj,
+	int			startoff,
+	int			idx)
+{
+	struct xfs_btree_block	*block = obj;
+	struct xfs_db_btree	*bt = block_to_bt(block);
+	int			offset;
+	int			maxrecs;
+
+	ASSERT(startoff == 0);
+	ASSERT(block->bb_level != 0);
+
+	maxrecs = btblock_maxrecs(bt, mp->m_sb.sb_blocksize);
+	offset = bt->block_len +
+			maxrecs * bt->key_len +
+			(idx - 1) * bt->ptr_len;
+
+	return bitize(offset);
+}
+
+/*
+ * Get the offset of the record at idx in a btree block.
+ */
+static int
+btblock_rec_offset(
+	void			*obj,
+	int			startoff,
+	int			idx)
+{
+	struct xfs_btree_block	*block = obj;
+	struct xfs_db_btree	*bt = block_to_bt(block);
+	int			offset;
+
+	ASSERT(startoff == 0);
+	ASSERT(block->bb_level == 0);
+
+	offset = bt->block_len + (idx - 1) * bt->rec_len;
+	return bitize(offset);
+}
+
+/*
+ * Get the size of a btree block.
+ */
+int
+btblock_size(
+	void	*obj,
+	int	startoff,
+	int	idx)
+{
+	return bitize(mp->m_sb.sb_blocksize);
+}
+
+
+/*
+ * Bmap btree.
+ */
+
+const field_t	bmapbta_hfld[] = {
+	{ "", FLDT_BMAPBTA, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+const field_t	bmapbtd_hfld[] = {
+	{ "", FLDT_BMAPBTD, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+#define	OFF(f)	bitize(offsetof(xfs_bmbt_block_t, bb_ ## f))
+const field_t	bmapbta_flds[] = {
+	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
+	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
+	{ "leftsib", FLDT_DFSBNO, OI(OFF(leftsib)), C1, 0, TYP_BMAPBTA },
+	{ "rightsib", FLDT_DFSBNO, OI(OFF(rightsib)), C1, 0, TYP_BMAPBTA },
+	{ "recs", FLDT_BMAPBTAREC, btblock_rec_offset, btblock_rec_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "keys", FLDT_BMAPBTAKEY, btblock_key_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "ptrs", FLDT_BMAPBTAPTR, btblock_ptr_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_BMAPBTA },
+	{ NULL }
+};
+const field_t	bmapbtd_flds[] = {
+	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
+	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
+	{ "leftsib", FLDT_DFSBNO, OI(OFF(leftsib)), C1, 0, TYP_BMAPBTD },
+	{ "rightsib", FLDT_DFSBNO, OI(OFF(rightsib)), C1, 0, TYP_BMAPBTD },
+	{ "recs", FLDT_BMAPBTDREC, btblock_rec_offset, btblock_rec_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "keys", FLDT_BMAPBTDKEY, btblock_key_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "ptrs", FLDT_BMAPBTDPTR, btblock_ptr_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_BMAPBTD },
+	{ NULL }
+};
+#undef OFF
+
+#define	KOFF(f)	bitize(offsetof(xfs_bmbt_key_t, br_ ## f))
+const field_t	bmapbta_key_flds[] = {
+	{ "startoff", FLDT_DFILOFFA, OI(KOFF(startoff)), C1, 0, TYP_ATTR },
+	{ NULL }
+};
+const field_t	bmapbtd_key_flds[] = {
+	{ "startoff", FLDT_DFILOFFD, OI(KOFF(startoff)), C1, 0, TYP_INODATA },
+	{ NULL }
+};
+#undef KOFF
+
+#ifndef XFS_NATIVE_HOST
+
+#define BMBT_EXNTFLAG_BITOFF	0
+#define BMBT_STARTOFF_BITOFF	(BMBT_EXNTFLAG_BITOFF + BMBT_EXNTFLAG_BITLEN)
+#define BMBT_STARTBLOCK_BITOFF	(BMBT_STARTOFF_BITOFF + BMBT_STARTOFF_BITLEN)
+#define BMBT_BLOCKCOUNT_BITOFF	\
+	(BMBT_STARTBLOCK_BITOFF + BMBT_STARTBLOCK_BITLEN)
+
+#else
+
+#define BMBT_EXNTFLAG_BITOFF	63
+#define BMBT_STARTOFF_BITOFF	(BMBT_EXNTFLAG_BITOFF - BMBT_STARTOFF_BITLEN)
+#define BMBT_STARTBLOCK_BITOFF	85 /* 128 - 43 (other 9 is in first word) */
+#define BMBT_BLOCKCOUNT_BITOFF	64 /* Start of second 64 bit container */
+
+#endif /* XFS_NATIVE_HOST */
+
+const field_t	bmapbta_rec_flds[] = {
+	{ "startoff", FLDT_CFILEOFFA, OI(BMBT_STARTOFF_BITOFF), C1, 0,
+	  TYP_ATTR },
+	{ "startblock", FLDT_CFSBLOCK, OI(BMBT_STARTBLOCK_BITOFF), C1, 0,
+	  TYP_ATTR },
+	{ "blockcount", FLDT_CEXTLEN, OI(BMBT_BLOCKCOUNT_BITOFF), C1, 0,
+	  TYP_NONE },
+	{ "extentflag", FLDT_CEXTFLG, OI(BMBT_EXNTFLAG_BITOFF), C1, 0,
+	  TYP_NONE },
+	{ NULL }
+};
+const field_t	bmapbtd_rec_flds[] = {
+	{ "startoff", FLDT_CFILEOFFD, OI(BMBT_STARTOFF_BITOFF), C1, 0,
+	  TYP_INODATA },
+	{ "startblock", FLDT_CFSBLOCK, OI(BMBT_STARTBLOCK_BITOFF), C1, 0,
+	  TYP_INODATA },
+	{ "blockcount", FLDT_CEXTLEN, OI(BMBT_BLOCKCOUNT_BITOFF), C1, 0,
+	  TYP_NONE },
+	{ "extentflag", FLDT_CEXTFLG, OI(BMBT_EXNTFLAG_BITOFF), C1, 0,
+	  TYP_NONE },
+	{ NULL }
+};
+
+
+/*
+ * Inode allocation btree.
+ */
+
+const field_t	inobt_hfld[] = {
+	{ "", FLDT_INOBT, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+#define	OFF(f)	bitize(offsetof(struct xfs_btree_sblock, bb_ ## f))
+const field_t	inobt_flds[] = {
+	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
+	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
+	{ "leftsib", FLDT_AGBLOCK, OI(OFF(leftsib)), C1, 0, TYP_INOBT },
+	{ "rightsib", FLDT_AGBLOCK, OI(OFF(rightsib)), C1, 0, TYP_INOBT },
+	{ "recs", FLDT_INOBTREC, btblock_rec_offset, btblock_rec_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "keys", FLDT_INOBTKEY, btblock_key_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "ptrs", FLDT_INOBTPTR, btblock_ptr_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_INOBT },
+	{ NULL }
+};
+#undef OFF
+
+#define	KOFF(f)	bitize(offsetof(xfs_inobt_key_t, ir_ ## f))
+const field_t	inobt_key_flds[] = {
+	{ "startino", FLDT_AGINO, OI(KOFF(startino)), C1, 0, TYP_INODE },
+	{ NULL }
+};
+#undef KOFF
+
+#define	ROFF(f)	bitize(offsetof(xfs_inobt_rec_t, ir_ ## f))
+const field_t	inobt_rec_flds[] = {
+	{ "startino", FLDT_AGINO, OI(ROFF(startino)), C1, 0, TYP_INODE },
+	{ "freecount", FLDT_INT32D, OI(ROFF(freecount)), C1, 0, TYP_NONE },
+	{ "free", FLDT_INOFREE, OI(ROFF(free)), C1, 0, TYP_NONE },
+	{ NULL }
+};
+#undef ROFF
+
+
+/*
+ * Allocation btrees.
+ */
+const field_t	bnobt_hfld[] = {
+	{ "", FLDT_BNOBT, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+#define	OFF(f)	bitize(offsetof(xfs_alloc_block_t, bb_ ## f))
+const field_t	bnobt_flds[] = {
+	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
+	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
+	{ "leftsib", FLDT_AGBLOCK, OI(OFF(leftsib)), C1, 0, TYP_BNOBT },
+	{ "rightsib", FLDT_AGBLOCK, OI(OFF(rightsib)), C1, 0, TYP_BNOBT },
+	{ "recs", FLDT_BNOBTREC, btblock_rec_offset, btblock_rec_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "keys", FLDT_BNOBTKEY, btblock_key_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "ptrs", FLDT_BNOBTPTR, btblock_ptr_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_BNOBT },
+	{ NULL }
+};
+#undef OFF
+
+#define	KOFF(f)	bitize(offsetof(xfs_alloc_key_t, ar_ ## f))
+const field_t	bnobt_key_flds[] = {
+	{ "startblock", FLDT_AGBLOCK, OI(KOFF(startblock)), C1, 0, TYP_DATA },
+	{ "blockcount", FLDT_EXTLEN, OI(KOFF(blockcount)), C1, 0, TYP_NONE },
+	{ NULL }
+};
+#undef KOFF
+
+#define	ROFF(f)	bitize(offsetof(xfs_alloc_rec_t, ar_ ## f))
+const field_t	bnobt_rec_flds[] = {
+	{ "startblock", FLDT_AGBLOCK, OI(ROFF(startblock)), C1, 0, TYP_DATA },
+	{ "blockcount", FLDT_EXTLEN, OI(ROFF(blockcount)), C1, 0, TYP_NONE },
+	{ NULL }
+};
+#undef ROFF
+
+const field_t	cntbt_hfld[] = {
+	{ "", FLDT_CNTBT, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+#define	OFF(f)	bitize(offsetof(xfs_alloc_block_t, bb_ ## f))
+const field_t	cntbt_flds[] = {
+	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
+	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
+	{ "leftsib", FLDT_AGBLOCK, OI(OFF(leftsib)), C1, 0, TYP_CNTBT },
+	{ "rightsib", FLDT_AGBLOCK, OI(OFF(rightsib)), C1, 0, TYP_CNTBT },
+	{ "recs", FLDT_CNTBTREC, btblock_rec_offset, btblock_rec_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "keys", FLDT_CNTBTKEY, btblock_key_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "ptrs", FLDT_CNTBTPTR, btblock_ptr_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_CNTBT },
+	{ NULL }
+};
+#undef OFF
+
+#define	KOFF(f)	bitize(offsetof(xfs_alloc_key_t, ar_ ## f))
+const field_t	cntbt_key_flds[] = {
+	{ "blockcount", FLDT_EXTLEN, OI(KOFF(blockcount)), C1, 0, TYP_NONE },
+	{ "startblock", FLDT_AGBLOCK, OI(KOFF(startblock)), C1, 0, TYP_DATA },
+	{ NULL }
+};
+#undef KOFF
+
+#define	ROFF(f)	bitize(offsetof(xfs_alloc_rec_t, ar_ ## f))
+const field_t	cntbt_rec_flds[] = {
+	{ "startblock", FLDT_AGBLOCK, OI(ROFF(startblock)), C1, 0, TYP_DATA },
+	{ "blockcount", FLDT_EXTLEN, OI(ROFF(blockcount)), C1, 0, TYP_NONE },
+	{ NULL }
+};
+#undef ROFF
Index: xfs-cmds/xfsprogs/db/btblock.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfs-cmds/xfsprogs/db/btblock.h	2008-09-29 23:54:59.000000000 +0200
@@ -0,0 +1,44 @@
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+extern const struct field	bmapbta_flds[];
+extern const struct field	bmapbta_hfld[];
+extern const struct field	bmapbta_key_flds[];
+extern const struct field	bmapbta_rec_flds[];
+
+extern const struct field	bmapbtd_flds[];
+extern const struct field	bmapbtd_hfld[];
+extern const struct field	bmapbtd_key_flds[];
+extern const struct field	bmapbtd_rec_flds[];
+
+extern const struct field	inobt_flds[];
+extern const struct field	inobt_hfld[];
+extern const struct field	inobt_key_flds[];
+extern const struct field	inobt_rec_flds[];
+
+extern const struct field	bnobt_flds[];
+extern const struct field	bnobt_hfld[];
+extern const struct field	bnobt_key_flds[];
+extern const struct field	bnobt_rec_flds[];
+
+extern const struct field	cntbt_flds[];
+extern const struct field	cntbt_hfld[];
+extern const struct field	cntbt_key_flds[];
+extern const struct field	cntbt_rec_flds[];
+
+extern int	btblock_size(void *obj, int startoff, int idx);
Index: xfs-cmds/xfsprogs/db/cntbt.c
===================================================================
--- xfs-cmds.orig/xfsprogs/db/cntbt.c	2008-09-25 20:23:21.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,176 +0,0 @@
-/*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-#include <xfs/libxfs.h>
-#include "type.h"
-#include "faddr.h"
-#include "fprint.h"
-#include "field.h"
-#include "cntbt.h"
-#include "print.h"
-#include "bit.h"
-#include "init.h"
-
-static int	cntbt_key_count(void *obj, int startoff);
-static int	cntbt_key_offset(void *obj, int startoff, int idx);
-static int	cntbt_ptr_count(void *obj, int startoff);
-static int	cntbt_ptr_offset(void *obj, int startoff, int idx);
-static int	cntbt_rec_count(void *obj, int startoff);
-static int	cntbt_rec_offset(void *obj, int startoff, int idx);
-
-const field_t	cntbt_hfld[] = {
-	{ "", FLDT_CNTBT, OI(0), C1, 0, TYP_NONE },
-	{ NULL }
-};
-
-#define	OFF(f)	bitize(offsetof(xfs_alloc_block_t, bb_ ## f))
-const field_t	cntbt_flds[] = {
-	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
-	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
-	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
-	{ "leftsib", FLDT_AGBLOCK, OI(OFF(leftsib)), C1, 0, TYP_CNTBT },
-	{ "rightsib", FLDT_AGBLOCK, OI(OFF(rightsib)), C1, 0, TYP_CNTBT },
-	{ "recs", FLDT_CNTBTREC, cntbt_rec_offset, cntbt_rec_count,
-	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
-	{ "keys", FLDT_CNTBTKEY, cntbt_key_offset, cntbt_key_count,
-	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
-	{ "ptrs", FLDT_CNTBTPTR, cntbt_ptr_offset, cntbt_ptr_count,
-	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_CNTBT },
-	{ NULL }
-};
-
-#define	KOFF(f)	bitize(offsetof(xfs_alloc_key_t, ar_ ## f))
-const field_t	cntbt_key_flds[] = {
-	{ "blockcount", FLDT_EXTLEN, OI(KOFF(blockcount)), C1, 0, TYP_NONE },
-	{ "startblock", FLDT_AGBLOCK, OI(KOFF(startblock)), C1, 0, TYP_DATA },
-	{ NULL }
-};
-
-#define	ROFF(f)	bitize(offsetof(xfs_alloc_rec_t, ar_ ## f))
-const field_t	cntbt_rec_flds[] = {
-	{ "startblock", FLDT_AGBLOCK, OI(ROFF(startblock)), C1, 0, TYP_DATA },
-	{ "blockcount", FLDT_EXTLEN, OI(ROFF(blockcount)), C1, 0, TYP_NONE },
-	{ NULL }
-};
-
-/*ARGSUSED*/
-static int
-cntbt_key_count(
-	void			*obj,
-	int			startoff)
-{
-	xfs_alloc_block_t	*block;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	if (be16_to_cpu(block->bb_level) == 0)
-		return 0;
-	return be16_to_cpu(block->bb_numrecs);
-}
-
-/*ARGSUSED*/
-static int
-cntbt_key_offset(
-	void			*obj,
-	int			startoff,
-	int			idx)
-{
-	xfs_alloc_block_t	*block;
-	xfs_alloc_key_t		*kp;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	ASSERT(be16_to_cpu(block->bb_level) > 0);
-	kp = XFS_BTREE_KEY_ADDR(xfs_alloc, block, idx);
-	return bitize((int)((char *)kp - (char *)block));
-}
-
-/*ARGSUSED*/
-static int
-cntbt_ptr_count(
-	void			*obj,
-	int			startoff)
-{
-	xfs_alloc_block_t	*block;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	if (be16_to_cpu(block->bb_level) == 0)
-		return 0;
-	return be16_to_cpu(block->bb_numrecs);
-}
-
-/*ARGSUSED*/
-static int
-cntbt_ptr_offset(
-	void			*obj,
-	int			startoff,
-	int			idx)
-{
-	xfs_alloc_block_t	*block;
-	xfs_alloc_ptr_t		*pp;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	ASSERT(be16_to_cpu(block->bb_level) > 0);
-	pp = XFS_BTREE_PTR_ADDR(xfs_alloc, block, idx,
-		XFS_BTREE_BLOCK_MAXRECS(mp->m_sb.sb_blocksize, xfs_alloc, 0));
-	return bitize((int)((char *)pp - (char *)block));
-}
-
-/*ARGSUSED*/
-static int
-cntbt_rec_count(
-	void			*obj,
-	int			startoff)
-{
-	xfs_alloc_block_t	*block;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	if (be16_to_cpu(block->bb_level) > 0)
-		return 0;
-	return be16_to_cpu(block->bb_numrecs);
-}
-
-/*ARGSUSED*/
-static int
-cntbt_rec_offset(
-	void			*obj,
-	int			startoff,
-	int			idx)
-{
-	xfs_alloc_block_t	*block;
-	xfs_alloc_rec_t		*rp;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	ASSERT(be16_to_cpu(block->bb_level) == 0);
-	rp = XFS_BTREE_REC_ADDR(xfs_alloc, block, idx);
-	return bitize((int)((char *)rp - (char *)block));
-}
-
-/*ARGSUSED*/
-int
-cntbt_size(
-	void	*obj,
-	int	startoff,
-	int	idx)
-{
-	return bitize(mp->m_sb.sb_blocksize);
-}
Index: xfs-cmds/xfsprogs/db/cntbt.h
===================================================================
--- xfs-cmds.orig/xfsprogs/db/cntbt.h	2008-09-25 20:23:21.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,24 +0,0 @@
-/*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-extern const struct field	cntbt_flds[];
-extern const struct field	cntbt_hfld[];
-extern const struct field	cntbt_key_flds[];
-extern const struct field	cntbt_rec_flds[];
-
-extern int	cntbt_size(void *obj, int startoff, int idx);
Index: xfs-cmds/xfsprogs/db/fprint.c
===================================================================
--- xfs-cmds.orig/xfsprogs/db/fprint.c	2008-09-25 20:23:21.000000000 +0200
+++ xfs-cmds/xfsprogs/db/fprint.c	2008-09-29 23:54:59.000000000 +0200
@@ -24,7 +24,7 @@
 #include "fprint.h"
 #include "field.h"
 #include "inode.h"
-#include "inobt.h"
+#include "btblock.h"
 #include "bit.h"
 #include "print.h"
 #include "output.h"
Index: xfs-cmds/xfsprogs/db/inobt.c
===================================================================
--- xfs-cmds.orig/xfsprogs/db/inobt.c	2008-09-25 20:23:21.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,176 +0,0 @@
-/*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-#include <xfs/libxfs.h>
-#include "type.h"
-#include "faddr.h"
-#include "fprint.h"
-#include "field.h"
-#include "inobt.h"
-#include "print.h"
-#include "bit.h"
-#include "init.h"
-
-static int	inobt_key_count(void *obj, int startoff);
-static int	inobt_key_offset(void *obj, int startoff, int idx);
-static int	inobt_ptr_count(void *obj, int startoff);
-static int	inobt_ptr_offset(void *obj, int startoff, int idx);
-static int	inobt_rec_count(void *obj, int startoff);
-static int	inobt_rec_offset(void *obj, int startoff, int idx);
-
-const field_t	inobt_hfld[] = {
-	{ "", FLDT_INOBT, OI(0), C1, 0, TYP_NONE },
-	{ NULL }
-};
-
-#define	OFF(f)	bitize(offsetof(xfs_inobt_block_t, bb_ ## f))
-const field_t	inobt_flds[] = {
-	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
-	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
-	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
-	{ "leftsib", FLDT_AGBLOCK, OI(OFF(leftsib)), C1, 0, TYP_INOBT },
-	{ "rightsib", FLDT_AGBLOCK, OI(OFF(rightsib)), C1, 0, TYP_INOBT },
-	{ "recs", FLDT_INOBTREC, inobt_rec_offset, inobt_rec_count,
-	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
-	{ "keys", FLDT_INOBTKEY, inobt_key_offset, inobt_key_count,
-	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
-	{ "ptrs", FLDT_INOBTPTR, inobt_ptr_offset, inobt_ptr_count,
-	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_INOBT },
-	{ NULL }
-};
-
-#define	KOFF(f)	bitize(offsetof(xfs_inobt_key_t, ir_ ## f))
-const field_t	inobt_key_flds[] = {
-	{ "startino", FLDT_AGINO, OI(KOFF(startino)), C1, 0, TYP_INODE },
-	{ NULL }
-};
-
-#define	ROFF(f)	bitize(offsetof(xfs_inobt_rec_t, ir_ ## f))
-const field_t	inobt_rec_flds[] = {
-	{ "startino", FLDT_AGINO, OI(ROFF(startino)), C1, 0, TYP_INODE },
-	{ "freecount", FLDT_INT32D, OI(ROFF(freecount)), C1, 0, TYP_NONE },
-	{ "free", FLDT_INOFREE, OI(ROFF(free)), C1, 0, TYP_NONE },
-	{ NULL }
-};
-
-/*ARGSUSED*/
-static int
-inobt_key_count(
-	void			*obj,
-	int			startoff)
-{
-	xfs_inobt_block_t	*block;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	if (be16_to_cpu(block->bb_level) == 0)
-		return 0;
-	return be16_to_cpu(block->bb_numrecs);
-}
-
-/*ARGSUSED*/
-static int
-inobt_key_offset(
-	void			*obj,
-	int			startoff,
-	int			idx)
-{
-	xfs_inobt_block_t	*block;
-	xfs_inobt_key_t		*kp;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	ASSERT(be16_to_cpu(block->bb_level) > 0);
-	kp = XFS_BTREE_KEY_ADDR(xfs_inobt, block, idx);
-	return bitize((int)((char *)kp - (char *)block));
-}
-
-/*ARGSUSED*/
-static int
-inobt_ptr_count(
-	void			*obj,
-	int			startoff)
-{
-	xfs_inobt_block_t	*block;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	if (be16_to_cpu(block->bb_level) == 0)
-		return 0;
-	return be16_to_cpu(block->bb_numrecs);
-}
-
-/*ARGSUSED*/
-static int
-inobt_ptr_offset(
-	void			*obj,
-	int			startoff,
-	int			idx)
-{
-	xfs_inobt_block_t	*block;
-	xfs_inobt_ptr_t		*pp;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	ASSERT(be16_to_cpu(block->bb_level) > 0);
-	pp = XFS_BTREE_PTR_ADDR(xfs_inobt, block, idx,
-		XFS_BTREE_BLOCK_MAXRECS(mp->m_sb.sb_blocksize, xfs_inobt, 0));
-	return bitize((int)((char *)pp - (char *)block));
-}
-
-/*ARGSUSED*/
-static int
-inobt_rec_count(
-	void			*obj,
-	int			startoff)
-{
-	xfs_inobt_block_t	*block;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	if (be16_to_cpu(block->bb_level) > 0)
-		return 0;
-	return be16_to_cpu(block->bb_numrecs);
-}
-
-/*ARGSUSED*/
-static int
-inobt_rec_offset(
-	void			*obj,
-	int			startoff,
-	int			idx)
-{
-	xfs_inobt_block_t	*block;
-	xfs_inobt_rec_t		*rp;
-
-	ASSERT(startoff == 0);
-	block = obj;
-	ASSERT(be16_to_cpu(block->bb_level) == 0);
-	rp = XFS_BTREE_REC_ADDR(xfs_inobt, block, idx);
-	return bitize((int)((char *)rp - (char *)block));
-}
-
-/*ARGSUSED*/
-int
-inobt_size(
-	void	*obj,
-	int	startoff,
-	int	idx)
-{
-	return bitize(mp->m_sb.sb_blocksize);
-}
Index: xfs-cmds/xfsprogs/db/inobt.h
===================================================================
--- xfs-cmds.orig/xfsprogs/db/inobt.h	2008-09-25 20:23:21.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,24 +0,0 @@
-/*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-extern const struct field	inobt_flds[];
-extern const struct field	inobt_hfld[];
-extern const struct field	inobt_key_flds[];
-extern const struct field	inobt_rec_flds[];
-
-extern int	inobt_size(void *obj, int startoff, int idx);
Index: xfs-cmds/xfsprogs/db/type.c
===================================================================
--- xfs-cmds.orig/xfsprogs/db/type.c	2008-09-25 20:23:21.000000000 +0200
+++ xfs-cmds/xfsprogs/db/type.c	2008-09-29 23:54:59.000000000 +0200
@@ -26,10 +26,7 @@
 #include "print.h"
 #include "sb.h"
 #include "inode.h"
-#include "bnobt.h"
-#include "cntbt.h"
-#include "inobt.h"
-#include "bmapbt.h"
+#include "btblock.h"
 #include "bmroot.h"
 #include "agf.h"
 #include "agfl.h"
