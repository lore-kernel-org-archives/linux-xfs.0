Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0A0gvME175722 for <xfs@oss.sgi.com>; Sun, 9 Jan 2011 18:42:58 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A1F0FBBE47
	for <xfs@oss.sgi.com>; Sun,  9 Jan 2011 16:45:04 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	SDqyOMNNGxzILEUZ for <xfs@oss.sgi.com>;
	Sun, 09 Jan 2011 16:45:04 -0800 (PST)
Received: from dastard (unverified [121.44.135.206])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	52000645-1927428
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 11:15:03 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Pc5sb-0004Kq-Mm
	for xfs@oss.sgi.com; Mon, 10 Jan 2011 11:45:01 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Pc5rk-0004SI-5U
	for xfs@oss.sgi.com; Mon, 10 Jan 2011 11:44:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs_repair: multithread phase 2
Date: Mon, 10 Jan 2011 11:44:08 +1100
Message-Id: <1294620248-17098-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Running some recent repair tests on broken filesystem meant running
phase 1 and 2 repeatedly to reproduce an issue at the start of phase
3. Phase 2 was taking approximately 10 minutes to run as it
processes each AG serially.

Phase 2 can be trivially parallelised - it is simply scanning the
per AG trees to calculate free block counts and free and used inodes
counts. This can be done safely in parallel by giving each AG it's
own structure to aggregate counts into, then once the AG scan is
complete adding them all together.

This patch uses 32-way threading which results in no noticable
slowdown on single SATA drives with NCQ, but results in ~10x
reduction in runtime on a 12 disk RAID-0 array.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/phase2.c     |   20 +---
 repair/scan.c       |  294 +++++++++++++++++++++++++++++----------------------
 repair/scan.h       |   39 +------
 repair/xfs_repair.c |   10 ++-
 4 files changed, 182 insertions(+), 181 deletions(-)

diff --git a/repair/phase2.c b/repair/phase2.c
index e81ebf0..1e9377e 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -24,10 +24,9 @@
 #include "err_protos.h"
 #include "incore.h"
 #include "progress.h"
+#include "scan.h"
 
 void	set_mp(xfs_mount_t *mpp);
-void	scan_ag(xfs_agnumber_t agno);
-void	validate_sb(struct xfs_sb *sb);
 
 /* workaround craziness in the xlog routines */
 int xlog_recover_do_trans(xlog_t *log, xlog_recover_t *t, int p) { return 0; }
@@ -107,9 +106,10 @@ zero_log(xfs_mount_t *mp)
  */
 
 void
-phase2(xfs_mount_t *mp)
+phase2(
+	struct xfs_mount	*mp,
+	int			scan_threads)
 {
-	xfs_agnumber_t		i;
 	int			j;
 	ino_tree_node_t		*ino_rec;
 
@@ -138,17 +138,7 @@ phase2(xfs_mount_t *mp)
 
 	set_progress_msg(PROG_FMT_SCAN_AG, (__uint64_t) glob_agcount);
 
-	for (i = 0; i < mp->m_sb.sb_agcount; i++)  {
-		scan_ag(i);
-#ifdef XR_INODE_TRACE
-		print_inode_list(i);
-#endif
-	}
-
-	/*
-	 * Validate that our manual counts match the superblock.
-	 */
-	validate_sb(&mp->m_sb);
+	scan_ags(mp, scan_threads);
 
 	print_final_rpt();
 
diff --git a/repair/scan.c b/repair/scan.c
index 85017ff..afed693 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -28,6 +28,7 @@
 #include "versions.h"
 #include "bmap.h"
 #include "progress.h"
+#include "threads.h"
 
 extern int verify_set_agheader(xfs_mount_t *mp, xfs_buf_t *sbuf, xfs_sb_t *sb,
 		xfs_agf_t *agf, xfs_agi_t *agi, xfs_agnumber_t i);
@@ -35,27 +36,31 @@ extern int verify_set_agheader(xfs_mount_t *mp, xfs_buf_t *sbuf, xfs_sb_t *sb,
 static xfs_mount_t	*mp = NULL;
 
 /*
- * Global variables to validate superblock values against the manual count
+ * Variables to validate AG header values against the manual count
  * from the btree traversal.
- *
- * No locking for now as phase2 is not threaded.
  */
-static __uint64_t	fdblocks;
-static __uint64_t	icount;
-static __uint64_t	ifreecount;
+struct aghdr_cnts {
+	xfs_agnumber_t	agno;
+	xfs_extlen_t	agffreeblks;
+	xfs_extlen_t	agflongest;
+	__uint64_t	agfbtreeblks;
+	__uint32_t	agicount;
+	__uint32_t	agifreecount;
+	__uint64_t	fdblocks;
+	__uint64_t	icount;
+	__uint64_t	ifreecount;
+};
 
-/*
- * Global variables to validate AG header values against the manual count
- * from the btree traversal.
- *
- * Note: these values must be reset when processing a new AG, and for now
- * forces the AG scanning in phase2 to not be threaded.
- */
-static xfs_extlen_t	agffreeblks;
-static xfs_extlen_t	agflongest;
-static __uint64_t	agfbtreeblks;
-static __uint32_t	agicount;
-static __uint32_t	agifreecount;
+static void
+scanfunc_allocbt(
+	struct xfs_btree_block	*block,
+	int			level,
+	xfs_agblock_t		bno,
+	xfs_agnumber_t		agno,
+	int			suspect,
+	int			isroot,
+	__uint32_t		magic,
+	struct aghdr_cnts	*agcnts);
 
 void
 set_mp(xfs_mount_t *mpp)
@@ -75,8 +80,10 @@ scan_sbtree(
 				xfs_agblock_t		bno,
 				xfs_agnumber_t		agno,
 				int			suspect,
-				int			isroot),
-	int		isroot)
+				int			isroot,
+				void			*priv),
+	int		isroot,
+	void		*priv)
 {
 	xfs_buf_t	*bp;
 
@@ -86,7 +93,8 @@ scan_sbtree(
 		do_error(_("can't read btree block %d/%d\n"), agno, root);
 		return;
 	}
-	(*func)(XFS_BUF_TO_BLOCK(bp), nlevels - 1, root, agno, suspect, isroot);
+	(*func)(XFS_BUF_TO_BLOCK(bp), nlevels - 1, root, agno, suspect,
+							isroot, priv);
 	libxfs_putbuf(bp);
 }
 
@@ -468,7 +476,35 @@ _("out-of-order bmap key (file offset) in inode %llu, %s fork, fsbno %llu\n"),
 	return(0);
 }
 
-void
+static void
+scanfunc_bno(
+	struct xfs_btree_block	*block,
+	int			level,
+	xfs_agblock_t		bno,
+	xfs_agnumber_t		agno,
+	int			suspect,
+	int			isroot,
+	void			*agcnts)
+{
+	return scanfunc_allocbt(block, level, bno, agno,
+				suspect, isroot, XFS_ABTB_MAGIC, agcnts);
+}
+
+static void
+scanfunc_cnt(
+	struct xfs_btree_block	*block,
+	int			level,
+	xfs_agblock_t		bno,
+	xfs_agnumber_t		agno,
+	int			suspect,
+	int			isroot,
+	void			*agcnts)
+{
+	return scanfunc_allocbt(block, level, bno, agno,
+				suspect, isroot, XFS_ABTC_MAGIC, agcnts);
+}
+
+static void
 scanfunc_allocbt(
 	struct xfs_btree_block	*block,
 	int			level,
@@ -476,7 +512,8 @@ scanfunc_allocbt(
 	xfs_agnumber_t		agno,
 	int			suspect,
 	int			isroot,
-	__uint32_t		magic)
+	__uint32_t		magic,
+	struct aghdr_cnts	*agcnts)
 {
 	const char 		*name;
 	int			i;
@@ -506,8 +543,8 @@ scanfunc_allocbt(
 	 * free data block counter.
 	 */
 	if (!isroot) {
-		agfbtreeblks++;
-		fdblocks++;
+		agcnts->agfbtreeblks++;
+		agcnts->fdblocks++;
 	}
 
 	if (be16_to_cpu(block->bb_level) != level) {
@@ -583,10 +620,10 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 					lastblock = b;
 				}
 			} else {
-				fdblocks += len;
-				agffreeblks += len;
-				if (len > agflongest)
-					agflongest = len;
+				agcnts->fdblocks += len;
+				agcnts->agffreeblks += len;
+				if (len > agcnts->agflongest)
+					agcnts->agflongest = len;
 				if (len < lastcount) {
 					do_warn(_(
 	"out-of-order cnt btree record %d (%u %u) block %u/%u\n"),
@@ -670,38 +707,12 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		if (bno != 0 && verify_agbno(mp, agno, bno)) {
 			scan_sbtree(bno, level, agno, suspect,
 				    (magic == XFS_ABTB_MAGIC) ?
-				     scanfunc_bno : scanfunc_cnt, 0);
+				     scanfunc_bno : scanfunc_cnt, 0,
+				     (void *)agcnts);
 		}
 	}
 }
 
-void
-scanfunc_bno(
-	struct xfs_btree_block	*block,
-	int			level,
-	xfs_agblock_t		bno,
-	xfs_agnumber_t		agno,
-	int			suspect,
-	int			isroot)
-{
-	return scanfunc_allocbt(block, level, bno, agno,
-				suspect, isroot, XFS_ABTB_MAGIC);
-}
-
-void
-scanfunc_cnt(
-	struct xfs_btree_block	*block,
-	int			level,
-	xfs_agblock_t		bno,
-	xfs_agnumber_t		agno,
-	int			suspect,
-	int			isroot
-	)
-{
-	return scanfunc_allocbt(block, level, bno, agno,
-				suspect, isroot, XFS_ABTC_MAGIC);
-}
-
 static int
 scan_single_ino_chunk(
 	xfs_agnumber_t		agno,
@@ -879,16 +890,17 @@ _("inode rec for ino %llu (%d/%d) overlaps existing rec (start %d/%d)\n"),
  * get the start and alignment of the inode chunks right.  Those chunks
  * that we aren't sure about go into the uncertain list.
  */
-void
+static void
 scanfunc_ino(
 	struct xfs_btree_block	*block,
 	int			level,
 	xfs_agblock_t		bno,
 	xfs_agnumber_t		agno,
 	int			suspect,
-	int			isroot
-	)
+	int			isroot,
+	void			*priv)
 {
+	struct aghdr_cnts	*agcnts = priv;
 	int			i;
 	int			numrecs;
 	int			state;
@@ -968,10 +980,10 @@ _("inode btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		 * the block.  skip processing of bogus records.
 		 */
 		for (i = 0; i < numrecs; i++) {
-			agicount += XFS_INODES_PER_CHUNK;
-			icount += XFS_INODES_PER_CHUNK;
-			agifreecount += be32_to_cpu(rp[i].ir_freecount);
-			ifreecount += be32_to_cpu(rp[i].ir_freecount);
+			agcnts->agicount += XFS_INODES_PER_CHUNK;
+			agcnts->icount += XFS_INODES_PER_CHUNK;
+			agcnts->agifreecount += be32_to_cpu(rp[i].ir_freecount);
+			agcnts->ifreecount += be32_to_cpu(rp[i].ir_freecount);
 
 			suspect = scan_single_ino_chunk(agno, &rp[i], suspect);
 		}
@@ -1015,13 +1027,14 @@ _("inode btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		if (be32_to_cpu(pp[i]) != 0 && verify_agbno(mp, agno,
 							be32_to_cpu(pp[i])))
 			scan_sbtree(be32_to_cpu(pp[i]), level, agno,
-					suspect, scanfunc_ino, 0);
+					suspect, scanfunc_ino, 0, priv);
 	}
 }
 
-void
+static void
 scan_freelist(
-	xfs_agf_t	*agf)
+	xfs_agf_t	*agf,
+	struct aghdr_cnts *agcnts)
 {
 	xfs_agfl_t	*agfl;
 	xfs_buf_t	*agflbuf;
@@ -1068,7 +1081,7 @@ scan_freelist(
 			be32_to_cpu(agf->agf_flcount), agno);
 	}
 
-	fdblocks += count;
+	agcnts->fdblocks += count;
 
 	libxfs_putbuf(agflbuf);
 }
@@ -1076,14 +1089,15 @@ scan_freelist(
 static void
 validate_agf(
 	struct xfs_agf		*agf,
-	xfs_agnumber_t		agno)
+	xfs_agnumber_t		agno,
+	struct aghdr_cnts	*agcnts)
 {
 	xfs_agblock_t		bno;
 
 	bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
 	if (bno != 0 && verify_agbno(mp, agno, bno)) {
 		scan_sbtree(bno, be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]),
-			    agno, 0, scanfunc_bno, 1);
+			    agno, 0, scanfunc_bno, 1, agcnts);
 	} else {
 		do_warn(_("bad agbno %u for btbno root, agno %d\n"),
 			bno, agno);
@@ -1092,33 +1106,34 @@ validate_agf(
 	bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]);
 	if (bno != 0 && verify_agbno(mp, agno, bno)) {
 		scan_sbtree(bno, be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]),
-			    agno, 0, scanfunc_cnt, 1);
+			    agno, 0, scanfunc_cnt, 1, agcnts);
 	} else  {
 		do_warn(_("bad agbno %u for btbcnt root, agno %d\n"),
 			bno, agno);
 	}
 
-	if (be32_to_cpu(agf->agf_freeblks) != agffreeblks) {
+	if (be32_to_cpu(agf->agf_freeblks) != agcnts->agffreeblks) {
 		do_warn(_("agf_freeblks %u, counted %u in ag %u\n"),
-			be32_to_cpu(agf->agf_freeblks), agffreeblks, agno);
+			be32_to_cpu(agf->agf_freeblks), agcnts->agffreeblks, agno);
 	}
 
-	if (be32_to_cpu(agf->agf_longest) != agflongest) {
+	if (be32_to_cpu(agf->agf_longest) != agcnts->agflongest) {
 		do_warn(_("agf_longest %u, counted %u in ag %u\n"),
-			be32_to_cpu(agf->agf_longest), agflongest, agno);
+			be32_to_cpu(agf->agf_longest), agcnts->agflongest, agno);
 	}
 
 	if (xfs_sb_version_haslazysbcount(&mp->m_sb) &&
-	    be32_to_cpu(agf->agf_btreeblks) != agfbtreeblks) {
+	    be32_to_cpu(agf->agf_btreeblks) != agcnts->agfbtreeblks) {
 		do_warn(_("agf_btreeblks %u, counted %u in ag %u\n"),
-			be32_to_cpu(agf->agf_btreeblks), agfbtreeblks, agno);
+			be32_to_cpu(agf->agf_btreeblks), agcnts->agfbtreeblks, agno);
 	}
 }
 
 static void
 validate_agi(
 	struct xfs_agi		*agi,
-	xfs_agnumber_t		agno)
+	xfs_agnumber_t		agno,
+	struct aghdr_cnts	*agcnts)
 {
 	xfs_agblock_t		bno;
 	int			i;
@@ -1126,20 +1141,20 @@ validate_agi(
 	bno = be32_to_cpu(agi->agi_root);
 	if (bno != 0 && verify_agbno(mp, agno, bno)) {
 		scan_sbtree(bno, be32_to_cpu(agi->agi_level),
-			    agno, 0, scanfunc_ino, 1);
+			    agno, 0, scanfunc_ino, 1, agcnts);
 	} else {
 		do_warn(_("bad agbno %u for inobt root, agno %d\n"),
 			be32_to_cpu(agi->agi_root), agno);
 	}
 
-	if (be32_to_cpu(agi->agi_count) != agicount) {
+	if (be32_to_cpu(agi->agi_count) != agcnts->agicount) {
 		do_warn(_("agi_count %u, counted %u in ag %u\n"),
-			 be32_to_cpu(agi->agi_count), agicount, agno);
+			 be32_to_cpu(agi->agi_count), agcnts->agicount, agno);
 	}
 
-	if (be32_to_cpu(agi->agi_freecount) != agifreecount) {
+	if (be32_to_cpu(agi->agi_freecount) != agcnts->agifreecount) {
 		do_warn(_("agi_freecount %u, counted %u in ag %u\n"),
-			be32_to_cpu(agi->agi_freecount), agifreecount, agno);
+			be32_to_cpu(agi->agi_freecount), agcnts->agifreecount, agno);
 	}
 
 	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
@@ -1155,42 +1170,15 @@ validate_agi(
 }
 
 /*
- * Validate block/inode counts in the superblock.
- *
- * Note: needs to be called after scan_ag() has been called for all
- * allocation groups.
- */
-void
-validate_sb(
-	struct xfs_sb		*sb)
-{
-	if (sb->sb_icount != icount) {
-		do_warn(_("sb_icount %lld, counted %lld\n"),
-			sb->sb_icount, icount);
-	}
-
-	if (sb->sb_ifree != ifreecount) {
-		do_warn(_("sb_ifree %lld, counted %lld\n"),
-			sb->sb_ifree, ifreecount);
-	}
-
-	if (sb->sb_fdblocks != fdblocks) {
-		do_warn(_("sb_fdblocks %lld, counted %lld\n"),
-			sb->sb_fdblocks, fdblocks);
-	}
-
-	/* XXX: check sb_frextents */
-}
-
-/*
  * Scan an AG for obvious corruption.
- *
- * Note: This code is not reentrant due to the use of global variables.
  */
-void
+static void
 scan_ag(
-	xfs_agnumber_t	agno)
+	work_queue_t	*wq,
+	xfs_agnumber_t	agno,
+	void		*arg)
 {
+	struct aghdr_cnts *agcnts = arg;
 	xfs_agf_t	*agf;
 	xfs_buf_t	*agfbuf;
 	int		agf_dirty = 0;
@@ -1202,16 +1190,6 @@ scan_ag(
 	int		sb_dirty = 0;
 	int		status;
 
-	/*
-	 * Reset the global variables to track the AG header validity.
-	 *
-	 * Because we use global variable but can get called multiple times
-	 * we have to make sure to always reset these variables.
-	 */
-	agicount = agifreecount = 0;
-	agffreeblks = agfbtreeblks = 0;
-	agflongest = 0;
-
 	sbbuf = libxfs_readbuf(mp->m_dev, XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
 				XFS_FSS_TO_BB(mp, 1), 0);
 	if (!sbbuf)  {
@@ -1301,10 +1279,10 @@ scan_ag(
 		return;
 	}
 
-	scan_freelist(agf);
+	scan_freelist(agf, agcnts);
 
-	validate_agf(agf, agno);
-	validate_agi(agi, agno);
+	validate_agf(agf, agno, agcnts);
+	validate_agi(agi, agno, agcnts);
 
 	ASSERT(agi_dirty == 0 || (agi_dirty && !no_modify));
 
@@ -1331,4 +1309,64 @@ scan_ag(
 		libxfs_putbuf(sbbuf);
 	free(sb);
 	PROG_RPT_INC(prog_rpt_done[agno], 1);
+
+#ifdef XR_INODE_TRACE
+	print_inode_list(i);
+#endif
+	return;
 }
+
+#define SCAN_THREADS 32
+
+void
+scan_ags(
+	struct xfs_mount	*mp,
+	int			scan_threads)
+{
+	struct aghdr_cnts *agcnts;
+	__uint64_t	fdblocks = 0;
+	__uint64_t	icount = 0;
+	__uint64_t	ifreecount = 0;
+	xfs_agnumber_t	i;
+	work_queue_t	wq;
+
+	agcnts = malloc(mp->m_sb.sb_agcount * sizeof(*agcnts));
+	if (!agcnts) {
+		do_abort(_("no memory for ag header counts\n"));
+		return;
+	}
+	memset(agcnts, 0, mp->m_sb.sb_agcount * sizeof(*agcnts));
+
+	create_work_queue(&wq, mp, scan_threads);
+
+	for (i = 0; i < mp->m_sb.sb_agcount; i++)
+		queue_work(&wq, scan_ag, i, &agcnts[i]);
+
+	destroy_work_queue(&wq);
+
+	/* tally up the counts */
+	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+		fdblocks += agcnts[i].fdblocks;
+		icount += agcnts[i].icount;
+		ifreecount += agcnts[i].ifreecount;
+	}
+
+	/*
+	 * Validate that our manual counts match the superblock.
+	 */
+	if (mp->m_sb.sb_icount != icount) {
+		do_warn(_("sb_icount %lld, counted %lld\n"),
+			mp->m_sb.sb_icount, icount);
+	}
+
+	if (mp->m_sb.sb_ifree != ifreecount) {
+		do_warn(_("sb_ifree %lld, counted %lld\n"),
+			mp->m_sb.sb_ifree, ifreecount);
+	}
+
+	if (mp->m_sb.sb_fdblocks != fdblocks) {
+		do_warn(_("sb_fdblocks %lld, counted %lld\n"),
+			mp->m_sb.sb_fdblocks, fdblocks);
+	}
+}
+
diff --git a/repair/scan.h b/repair/scan.h
index 20567fb..9f945cf 100644
--- a/repair/scan.h
+++ b/repair/scan.h
@@ -20,19 +20,6 @@
 
 struct blkmap;
 
-void scan_sbtree(
-	xfs_agblock_t	root,
-	int		nlevels,
-	xfs_agnumber_t	agno,
-	int		suspect,
-	void		(*func)(struct xfs_btree_block	*block,
-				int			level,
-				xfs_agblock_t		bno,
-				xfs_agnumber_t		agno,
-				int			suspect,
-				int			isroot),
-	int		isroot);
-
 int scan_lbtree(
 	xfs_dfsbno_t	root,
 	int		nlevels,
@@ -74,29 +61,9 @@ int scanfunc_bmap(
 	int			check_dups,
 	int			*dirty);
 
-void scanfunc_bno(
-	struct xfs_btree_block	*block,
-	int			level,
-	xfs_agblock_t		bno,
-	xfs_agnumber_t		agno,
-	int			suspect,
-	int			isroot);
-
-void scanfunc_cnt(
-	struct xfs_btree_block	*block,
-	int			level,
-	xfs_agblock_t		bno,
-	xfs_agnumber_t		agno,
-	int			suspect,
-	int			isroot);
-
 void
-scanfunc_ino(
-	struct xfs_btree_block	*block,
-	int			level,
-	xfs_agblock_t		bno,
-	xfs_agnumber_t		agno,
-	int			suspect,
-	int			isroot);
+scan_ags(
+	struct xfs_mount	*mp,
+	int			scan_threads);
 
 #endif /* _XR_SCAN_H */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 1d9ad46..4707b83 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -33,7 +33,7 @@
 #define	rounddown(x, y)	(((x)/(y))*(y))
 
 extern void	phase1(xfs_mount_t *);
-extern void	phase2(xfs_mount_t *);
+extern void	phase2(xfs_mount_t *, int);
 extern void	phase3(xfs_mount_t *);
 extern void	phase4(xfs_mount_t *);
 extern void	phase5(xfs_mount_t *);
@@ -63,6 +63,8 @@ char *o_opts[] = {
 	"ag_stride",
 #define FORCE_GEO	5
 	"force_geometry",
+#define PHASE2_THREADS	6
+	"phase2_threads",
 	NULL
 };
 
@@ -80,6 +82,7 @@ char *c_opts[] = {
 static int	ihash_option_used;
 static int	bhash_option_used;
 static long	max_mem_specified;	/* in megabytes */
+static int	phase2_threads = 32;
 
 static void
 usage(void)
@@ -266,6 +269,9 @@ process_args(int argc, char **argv)
 						respec('o', o_opts, FORCE_GEO);
 					force_geo = 1;
 					break;
+				case PHASE2_THREADS:
+					phase2_threads = (int)strtol(val, NULL, 0);
+					break;
 				default:
 					unknown('o', val);
 					break;
@@ -709,7 +715,7 @@ main(int argc, char **argv)
 	}
 
 	/* make sure the per-ag freespace maps are ok so we can mount the fs */
-	phase2(mp);
+	phase2(mp, phase2_threads);
 	timestamp(PHASE_END, 2, NULL);
 
 	if (do_prefetch)
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
