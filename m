Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82HvhpT034366 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 12:57:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 698B341E03E
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 10:58:40 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id yHJhGpswi06gMZKs for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 10:58:40 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Miu6R-0006Sm-W1
	for xfs@oss.sgi.com; Wed, 02 Sep 2009 17:58:40 +0000
Message-Id: <20090902175839.915684396@bombadil.infradead.org>
Date: Wed, 02 Sep 2009 13:55:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/14] repair: merge scanfunc_bno and scanfunc_cnt
References: <20090902175531.469184575@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-unify-scanfunc-bno-cnt
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

Those two functions are almost identical.  The big difference is that we only
move blocks from XR_E_FREE1 to XR_E_FREE state when processing the cnt btree.

Besides that we print bno vs cnt in the messages and obviously validate a
slightly different magic number in the header.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/scan.c
===================================================================
--- xfsprogs-dev.orig/repair/scan.c	2009-08-21 18:24:26.000000000 +0000
+++ xfsprogs-dev/repair/scan.c	2009-08-21 18:40:59.000000000 +0000
@@ -439,15 +439,16 @@ _("out-of-order bmap key (file offset) i
 }
 
 void
-scanfunc_bno(
+scanfunc_allocbt(
 	struct xfs_btree_block	*block,
 	int			level,
 	xfs_agblock_t		bno,
 	xfs_agnumber_t		agno,
 	int			suspect,
-	int			isroot
-	)
+	int			isroot,
+	__uint32_t		magic)
 {
+	const char 		*name;
 	xfs_agblock_t		b, e;
 	int			i;
 	xfs_alloc_ptr_t		*pp;
@@ -456,16 +457,18 @@ scanfunc_bno(
 	int			numrecs;
 	int			state;
 
-	if (be32_to_cpu(block->bb_magic) != XFS_ABTB_MAGIC) {
-		do_warn(_("bad magic # %#x in btbno block %d/%d\n"),
-			be32_to_cpu(block->bb_magic), agno, bno);
+	name = (magic == XFS_ABTB_MAGIC) ? "bno" : "cnt";
+
+	if (be32_to_cpu(block->bb_magic) != magic) {
+		do_warn(_("bad magic # %#x in bt%s block %d/%d\n"),
+			be32_to_cpu(block->bb_magic), name, agno, bno);
 		hdr_errors++;
 		if (suspect)
 			return;
 	}
 	if (be16_to_cpu(block->bb_level) != level) {
-		do_warn(_("expected level %d got %d in btbno block %d/%d\n"),
-			level, be16_to_cpu(block->bb_level), agno, bno);
+		do_warn(_("expected level %d got %d in bt%s block %d/%d\n"),
+			level, be16_to_cpu(block->bb_level), name, agno, bno);
 		hdr_errors++;
 		if (suspect)
 			return;
@@ -483,8 +486,8 @@ scanfunc_bno(
 	default:
 		set_agbno_state(mp, agno, bno, XR_E_MULT);
 		do_warn(
-_("bno freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
-				state, agno, bno, suspect);
+_("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
+				name, state, agno, bno, suspect);
 		return;
 	}
 
@@ -520,15 +523,27 @@ _("bno freespace btree block claimed (st
 				continue;
 			for (b = be32_to_cpu(rp[i].ar_startblock);
 			     b < e; b++)  {
-				if (get_agbno_state(mp, agno, b)
-							== XR_E_UNKNOWN)
+				state = get_agbno_state(mp, agno, b);
+				switch (state) {
+				case XR_E_UNKNOWN:
 					set_agbno_state(mp, agno, b,
 							XR_E_FREE1);
-				else  {
+					break;
+				case XR_E_FREE1:
+					/*
+					 * no warning messages -- we'll catch
+					 * FREE1 blocks later
+					 */
+					if (magic != XFS_ABTB_MAGIC) {
+						set_agbno_state(mp, agno, b,
+								XR_E_FREE);
+						break;
+					}
+				default:
 					do_warn(
-	_("block (%d,%d) multiply claimed by bno space tree, state - %d\n"),
-						agno, b,
-						get_agbno_state(mp, agno, b));
+	_("block (%d,%d) multiply claimed by %s space tree, state - %d\n"),
+						agno, b, name, state);
+					break;
 				}
 			}
 		}
@@ -575,12 +590,26 @@ _("bno freespace btree block claimed (st
 		 */
 		if (be32_to_cpu(pp[i]) != 0 && verify_agbno(mp, agno,
 							be32_to_cpu(pp[i])))
-			scan_sbtree(be32_to_cpu(pp[i]), level, agno,
-					suspect, scanfunc_bno, 0);
+			scan_sbtree(be32_to_cpu(pp[i]), level, agno, suspect,
+				    (magic == XFS_ABTB_MAGIC) ?
+				    	scanfunc_bno : scanfunc_cnt, 0);
 	}
 }
 
 void
+scanfunc_bno(
+	struct xfs_btree_block	*block,
+	int			level,
+	xfs_agblock_t		bno,
+	xfs_agnumber_t		agno,
+	int			suspect,
+	int			isroot)
+{
+	return scanfunc_allocbt(block, level, bno, agno,
+				suspect, isroot, XFS_ABTB_MAGIC);
+}
+
+void
 scanfunc_cnt(
 	struct xfs_btree_block	*block,
 	int			level,
@@ -590,136 +619,8 @@ scanfunc_cnt(
 	int			isroot
 	)
 {
-	xfs_alloc_ptr_t		*pp;
-	xfs_alloc_rec_t		*rp;
-	xfs_agblock_t		b, e;
-	int			i;
-	int			hdr_errors;
-	int			numrecs;
-	int			state;
-
-	hdr_errors = 0;
-
-	if (be32_to_cpu(block->bb_magic) != XFS_ABTC_MAGIC) {
-		do_warn(_("bad magic # %#x in btcnt block %d/%d\n"),
-			be32_to_cpu(block->bb_magic), agno, bno);
-		hdr_errors++;
-		if (suspect)
-			return;
-	}
-	if (be16_to_cpu(block->bb_level) != level) {
-		do_warn(_("expected level %d got %d in btcnt block %d/%d\n"),
-			level, be16_to_cpu(block->bb_level), agno, bno);
-		hdr_errors++;
-		if (suspect)
-			return;
-	}
-
-	/*
-	 * check for btree blocks multiply claimed
-	 */
-	state = get_agbno_state(mp, agno, bno);
-
-	switch (state)  {
-	case XR_E_UNKNOWN:
-		set_agbno_state(mp, agno, bno, XR_E_FS_MAP);
-		break;
-	default:
-		set_agbno_state(mp, agno, bno, XR_E_MULT);
-		do_warn(
-_("bcnt freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
-			state, agno, bno, suspect);
-		return;
-	}
-
-	numrecs = be16_to_cpu(block->bb_numrecs);
-
-	if (level == 0) {
-		if (numrecs > mp->m_alloc_mxr[0])  {
-			numrecs = mp->m_alloc_mxr[0];
-			hdr_errors++;
-		}
-		if (isroot == 0 && numrecs < mp->m_alloc_mnr[0])  {
-			numrecs = mp->m_alloc_mnr[0];
-			hdr_errors++;
-		}
-
-		if (hdr_errors)
-			suspect++;
-
-		rp = XFS_ALLOC_REC_ADDR(mp, block, 1);
-		for (i = 0; i < numrecs; i++) {
-			if (be32_to_cpu(rp[i].ar_blockcount) == 0 ||
-					be32_to_cpu(rp[i].ar_startblock) == 0 ||
-					!verify_agbno(mp, agno, be32_to_cpu(
-							rp[i].ar_startblock)) ||
-			    		be32_to_cpu(rp[i].ar_blockcount) >
-							MAXEXTLEN)
-				continue;
-
-			e = be32_to_cpu(rp[i].ar_startblock) +
-				be32_to_cpu(rp[i].ar_blockcount);
-			if (!verify_agbno(mp, agno, e - 1))
-				continue;
-			for (b = be32_to_cpu(rp[i].ar_startblock); b < e; b++) {
-				state = get_agbno_state(mp, agno, b);
-				/*
-				 * no warning messages -- we'll catch
-				 * FREE1 blocks later
-				 */
-				switch (state)  {
-				case XR_E_FREE1:
-					set_agbno_state(mp, agno, b, XR_E_FREE);
-					break;
-				case XR_E_UNKNOWN:
-					set_agbno_state(mp, agno, b,
-							XR_E_FREE1);
-					break;
-				default:
-					do_warn(
-				_("block (%d,%d) already used, state %d\n"),
-						agno, b, state);
-					break;
-				}
-			}
-		}
-		return;
-	}
-
-	/*
-	 * interior record
-	 */
-	pp = XFS_ALLOC_PTR_ADDR(mp, block, 1, mp->m_alloc_mxr[1]);
-
-	if (numrecs > mp->m_alloc_mxr[1])  {
-		numrecs = mp->m_alloc_mxr[1];
-		hdr_errors++;
-	}
-	if (isroot == 0 && numrecs < mp->m_alloc_mnr[1])  {
-		numrecs = mp->m_alloc_mnr[1];
-		hdr_errors++;
-	}
-
-	/*
-	 * don't pass bogus tree flag down further if this block
-	 * looked ok.  bail out if two levels in a row look bad.
-	 */
-
-	if (suspect && !hdr_errors)
-		suspect = 0;
-
-	if (hdr_errors)  {
-		if (suspect)
-			return;
-		else suspect++;
-	}
-
-	for (i = 0; i < numrecs; i++) {
-		if (be32_to_cpu(pp[i]) != 0 && verify_agbno(mp, agno,
-							be32_to_cpu(pp[i])))
-			scan_sbtree(be32_to_cpu(pp[i]), level, agno,
-					suspect, scanfunc_cnt, 0);
-	}
+	return scanfunc_allocbt(block, level, bno, agno,
+				suspect, isroot, XFS_ABTC_MAGIC);
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
