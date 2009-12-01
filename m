Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB1FA7MZ143655 for <xfs@oss.sgi.com>; Tue, 1 Dec 2009 09:10:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66CA02C34C1
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2009 07:10:38 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id WEUWIaoToVWEj5Q2 for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2009 07:10:38 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NFUNB-0005iu-Pu
	for xfs@oss.sgi.com; Tue, 01 Dec 2009 15:10:37 +0000
Message-Id: <20091201151037.707510379@bombadil.infradead.org>
Date: Tue, 01 Dec 2009 10:05:06 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] repair: compare superblock / AG headers fields against
	manual counts
References: <20091201150503.958283878@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-freespace-warn-2
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

Compare the free block / inode counters in the superblock and AG headers
against the values we get from a manual btree traversal.  Ported over from
xfs_db to get the same amount of superblock / AG header checking as in
xfs_check.


Note: this causes additional output in the xfstests 030 and 178 which will need
some adjustments in the testcases.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/scan.c
===================================================================
--- xfsprogs-dev.orig/repair/scan.c	2009-12-01 14:56:22.000000000 +0000
+++ xfsprogs-dev/repair/scan.c	2009-12-01 15:01:43.000000000 +0000
@@ -34,6 +34,29 @@ extern int verify_set_agheader(xfs_mount
 
 static xfs_mount_t	*mp = NULL;
 
+/*
+ * Global variables to validate superblock values against the manual count
+ * from the btree traversal.
+ *
+ * No locking for now as phase2 is not threaded.
+ */
+static __uint64_t	fdblocks;
+static __uint64_t	icount;
+static __uint64_t	ifreecount;
+
+/*
+ * Global variables to validate AG header values against the manual count
+ * from the btree traversal.
+ *
+ * Note: these values must be reset when processing a new AG, and for now
+ * forces the AG scanning in phase2 to not be threaded.
+ */
+static xfs_extlen_t	agffreeblks;
+static xfs_extlen_t	agflongest;
+static __uint64_t	agfbtreeblks;
+static __uint32_t	agicount;
+static __uint32_t	agifreecount;
+
 void
 set_mp(xfs_mount_t *mpp)
 {
@@ -476,6 +499,17 @@ scanfunc_allocbt(
 		if (suspect)
 			return;
 	}
+
+	/*
+	 * All freespace btree blocks except the roots are freed for a
+	 * fully used filesystem, thus they are counted towards the
+	 * free data block counter.
+	 */
+	if (!isroot) {
+		agfbtreeblks++;
+		fdblocks++;
+	}
+
 	if (be16_to_cpu(block->bb_level) != level) {
 		do_warn(_("expected level %d got %d in bt%s block %d/%d\n"),
 			level, be16_to_cpu(block->bb_level), name, agno, bno);
@@ -500,7 +534,6 @@ _("%s freespace btree block claimed (sta
 	numrecs = be16_to_cpu(block->bb_numrecs);
 
 	if (level == 0) {
-
 		if (numrecs > mp->m_alloc_mxr[0])  {
 			numrecs = mp->m_alloc_mxr[0];
 			hdr_errors++;
@@ -550,6 +583,10 @@ _("%s freespace btree block claimed (sta
 					lastblock = b;
 				}
 			} else {
+				fdblocks += len;
+				agffreeblks += len;
+				if (len > agflongest)
+					agflongest = len;
 				if (len < lastcount) {
 					do_warn(_(
 	"out-of-order cnt btree record %d (%u %u) block %u/%u\n"),
@@ -930,8 +967,14 @@ _("inode btree block claimed (state %d),
 		 * of INODES_PER_CHUNK (64) inodes.  off is the offset into
 		 * the block.  skip processing of bogus records.
 		 */
-		for (i = 0; i < numrecs; i++)
+		for (i = 0; i < numrecs; i++) {
+			agicount += XFS_INODES_PER_CHUNK;
+			icount += XFS_INODES_PER_CHUNK;
+			agifreecount += be32_to_cpu(rp[i].ir_freecount);
+			ifreecount += be32_to_cpu(rp[i].ir_freecount);
+
 			suspect = scan_single_ino_chunk(agno, &rp[i], suspect);
+		}
 
 		if (suspect)
 			bad_ino_btree = 1;
@@ -1024,25 +1067,150 @@ scan_freelist(
 		do_warn(_("freeblk count %d != flcount %d in ag %d\n"), count,
 			be32_to_cpu(agf->agf_flcount), agno);
 	}
+
+	fdblocks += count;
+
 	libxfs_putbuf(agflbuf);
 }
 
+static void
+validate_agf(
+	struct xfs_agf		*agf,
+	xfs_agnumber_t		agno)
+{
+	xfs_agblock_t		bno;
+
+	bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
+	if (bno != 0 && verify_agbno(mp, agno, bno)) {
+		scan_sbtree(bno, be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]),
+			    agno, 0, scanfunc_bno, 1);
+	} else {
+		do_warn(_("bad agbno %u for btbno root, agno %d\n"),
+			bno, agno);
+	}
+
+	bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]);
+	if (bno != 0 && verify_agbno(mp, agno, bno)) {
+		scan_sbtree(bno, be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]),
+			    agno, 0, scanfunc_cnt, 1);
+	} else  {
+		do_warn(_("bad agbno %u for btbcnt root, agno %d\n"),
+			bno, agno);
+	}
+
+	if (be32_to_cpu(agf->agf_freeblks) != agffreeblks) {
+		do_warn(_("agf_freeblks %u, counted %u in ag %u\n"),
+			be32_to_cpu(agf->agf_freeblks), agffreeblks, agno);
+	}
+
+	if (be32_to_cpu(agf->agf_longest) != agflongest) {
+		do_warn(_("agf_longest %u, counted %u in ag %u\n"),
+			be32_to_cpu(agf->agf_longest), agflongest, agno);
+	}
+
+	if (xfs_sb_version_haslazysbcount(&mp->m_sb) &&
+	    be32_to_cpu(agf->agf_btreeblks) != agfbtreeblks) {
+		do_warn(_("agf_btreeblks %u, counted %u in ag %u\n"),
+			be32_to_cpu(agf->agf_btreeblks), agfbtreeblks, agno);
+	}
+}
+
+static void
+validate_agi(
+	struct xfs_agi		*agi,
+	xfs_agnumber_t		agno)
+{
+	xfs_agblock_t		bno;
+	int			i;
+
+	bno = be32_to_cpu(agi->agi_root);
+	if (bno != 0 && verify_agbno(mp, agno, bno)) {
+		scan_sbtree(bno, be32_to_cpu(agi->agi_level),
+			    agno, 0, scanfunc_ino, 1);
+	} else {
+		do_warn(_("bad agbno %u for inobt root, agno %d\n"),
+			be32_to_cpu(agi->agi_root), agno);
+	}
+
+	if (be32_to_cpu(agi->agi_count) != agicount) {
+		do_warn(_("agi_count %u, counted %u in ag %u\n"),
+			 be32_to_cpu(agi->agi_count), agicount, agno);
+	}
+
+	if (be32_to_cpu(agi->agi_freecount) != agifreecount) {
+		do_warn(_("agi_freecount %u, counted %u in ag %u\n"),
+			be32_to_cpu(agi->agi_freecount), agifreecount, agno);
+	}
+
+	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
+		xfs_agino_t	agino = be32_to_cpu(agi->agi_unlinked[i]);
+
+		if (agino != NULLAGINO) {
+			do_warn(
+	_("agi unlinked bucket %d is %u in ag %u (inode=%lld)\n"),
+				i, agino, agno,
+				XFS_AGINO_TO_INO(mp, agno, agino));
+		}
+	}
+}
+
+/*
+ * Validate block/inode counts in the superblock.
+ *
+ * Note: needs to be called after scan_ag() has been called for all
+ * allocation groups.
+ */
+void
+validate_sb(
+	struct xfs_sb		*sb)
+{
+	if (sb->sb_icount != icount) {
+		do_warn(_("sb_icount %lld, counted %lld\n"),
+			sb->sb_icount, icount);
+	}
+
+	if (sb->sb_ifree != ifreecount) {
+		do_warn(_("sb_ifree %lld, counted %lld\n"),
+			sb->sb_ifree, ifreecount);
+	}
+
+	if (sb->sb_fdblocks != fdblocks) {
+		do_warn(_("sb_fdblocks %lld, counted %lld\n"),
+			sb->sb_fdblocks, fdblocks);
+	}
+
+	/* XXX: check sb_frextents */
+}
+
+/*
+ * Scan an AG for obvious corruption.
+ *
+ * Note: This code is not reentrant due to the use of global variables.
+ */
 void
 scan_ag(
 	xfs_agnumber_t	agno)
 {
 	xfs_agf_t	*agf;
 	xfs_buf_t	*agfbuf;
-	int		agf_dirty;
+	int		agf_dirty = 0;
 	xfs_agi_t	*agi;
 	xfs_buf_t	*agibuf;
-	int		agi_dirty;
+	int		agi_dirty = 0;
 	xfs_sb_t	*sb;
 	xfs_buf_t	*sbbuf;
-	int		sb_dirty;
+	int		sb_dirty = 0;
 	int		status;
 
-	agi_dirty = agf_dirty = sb_dirty = 0;
+	/*
+	 * Reset the global variables to track the AG header validity.
+	 *
+	 * Because we use global variable but can get called multiple times
+	 * we have to make sure to always reset these variables.
+	 */
+	agicount = agifreecount = 0;
+	agffreeblks = agfbtreeblks = 0;
+	agflongest = 0;
 
 	sbbuf = libxfs_readbuf(mp->m_dev, XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
 				XFS_FSS_TO_BB(mp, 1), 0);
@@ -1135,33 +1303,8 @@ scan_ag(
 
 	scan_freelist(agf);
 
-	if (be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]) != 0 && verify_agbno(mp,
-			agno, be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO])))
-		scan_sbtree(be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]),
-				be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]),
-				agno, 0, scanfunc_bno, 1);
-	else
-		do_warn(_("bad agbno %u for btbno root, agno %d\n"),
-			be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]),
-			agno);
-
-	if (be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]) != 0 && verify_agbno(mp,
-			agno, be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT])))
-		scan_sbtree(be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]),
-				be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]),
-				agno, 0, scanfunc_cnt, 1);
-	else
-		do_warn(_("bad agbno %u for btbcnt root, agno %d\n"),
-			be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]),
-			agno);
-
-	if (be32_to_cpu(agi->agi_root) != 0 && verify_agbno(mp, agno,
-						be32_to_cpu(agi->agi_root)))
-		scan_sbtree(be32_to_cpu(agi->agi_root),
-			be32_to_cpu(agi->agi_level), agno, 0, scanfunc_ino, 1);
-	else
-		do_warn(_("bad agbno %u for inobt root, agno %d\n"),
-			be32_to_cpu(agi->agi_root), agno);
+	validate_agf(agf, agno);
+	validate_agi(agi, agno);
 
 	ASSERT(agi_dirty == 0 || (agi_dirty && !no_modify));
 
Index: xfsprogs-dev/repair/phase2.c
===================================================================
--- xfsprogs-dev.orig/repair/phase2.c	2009-12-01 14:54:18.000000000 +0000
+++ xfsprogs-dev/repair/phase2.c	2009-12-01 14:59:56.000000000 +0000
@@ -27,6 +27,7 @@
 
 void	set_mp(xfs_mount_t *mpp);
 void	scan_ag(xfs_agnumber_t agno);
+void	validate_sb(struct xfs_sb *sb);
 
 /* workaround craziness in the xlog routines */
 int xlog_recover_do_trans(xlog_t *log, xlog_recover_t *t, int p) { return 0; }
@@ -144,6 +145,11 @@ phase2(xfs_mount_t *mp)
 #endif
 	}
 
+	/*
+	 * Validate that our manual counts match the superblock.
+	 */
+	validate_sb(&mp->m_sb);
+
 	print_final_rpt();
 
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
