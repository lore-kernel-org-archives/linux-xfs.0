Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E0B23844D
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 19:00:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 52F36AC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:00:31 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id YeniwbaR9F8PSbgX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:00:29 -0700 (PDT)
Subject: [PATCH 17/29] xfs_db: support rudimentary checks of the rtrmap btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 17:00:24 -0700
Message-ID: <147216962409.7022.6402301314358084964.stgit@birch.djwong.org>
In-Reply-To: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
References: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Perform some fairly superficial checks of the rtrmap btree.  We'll
do more sophisticated checks in xfs_repair, but provide enough of
a spot-check here that we can do simple things.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c |  191 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 182 insertions(+), 9 deletions(-)


diff --git a/db/check.c b/db/check.c
index 7392852..7ffd5bb 100644
--- a/db/check.c
+++ b/db/check.c
@@ -45,7 +45,7 @@ typedef enum {
 	DBM_LOG,	DBM_MISSING,	DBM_QUOTA,	DBM_RTBITMAP,
 	DBM_RTDATA,	DBM_RTFREE,	DBM_RTSUM,	DBM_SB,
 	DBM_SYMLINK,	DBM_BTFINO,	DBM_BTRMAP,	DBM_BTREFC,
-	DBM_RLDATA,	DBM_COWDATA,
+	DBM_RLDATA,	DBM_COWDATA,	DBM_BTRTRMAP,
 	DBM_NDBM
 } dbm_t;
 
@@ -176,6 +176,8 @@ static const char	*typename[] = {
 	"btrmap",
 	"btrefcnt",
 	"rldata",
+	"cowdata",
+	"btrtrmap",
 	NULL
 };
 static int		verbose;
@@ -316,6 +318,9 @@ static void		process_quota(qtype_t qtype, inodata_t *id,
 				      blkmap_t *blkmap);
 static void		process_rtbitmap(blkmap_t *blkmap);
 static void		process_rtsummary(blkmap_t *blkmap);
+static void		process_rtrmap(struct inodata *id,
+				       struct xfs_dinode *dip,
+				       xfs_rfsblock_t *toti);
 static xfs_ino_t	process_sf_dir_v2(xfs_dinode_t *dip, int *dot,
 					  int *dotdot, inodata_t *id);
 static void		quota_add(xfs_dqid_t *p, xfs_dqid_t *g, xfs_dqid_t *u,
@@ -343,6 +348,12 @@ static void		scanfunc_bmap(struct xfs_btree_block *block,
 				      xfs_rfsblock_t *toti, xfs_extnum_t *nex,
 				      blkmap_t **blkmapp, int isroot,
 				      typnm_t btype);
+static void		scanfunc_rtrmap(struct xfs_btree_block *block,
+				      int level, dbm_t type, xfs_fsblock_t bno,
+				      inodata_t *id, xfs_rfsblock_t *totd,
+				      xfs_rfsblock_t *toti, xfs_extnum_t *nex,
+				      blkmap_t **blkmapp, int isroot,
+				      typnm_t btype);
 static void		scanfunc_bno(struct xfs_btree_block *block, int level,
 				     xfs_agf_t *agf, xfs_agblock_t bno,
 				     int isroot);
@@ -1060,6 +1071,7 @@ blocktrash_f(
 		   (1 << DBM_QUOTA) |
 		   (1 << DBM_RTBITMAP) |
 		   (1 << DBM_RTSUM) |
+		   (1 << DBM_BTRTRMAP) |
 		   (1 << DBM_SYMLINK) |
 		   (1 << DBM_BTFINO) |
 		   (1 << DBM_BTRMAP) |
@@ -2706,7 +2718,7 @@ process_inode(
 		0				/* type 15 unused */
 	};
 	static char		*fmtnames[] = {
-		"dev", "local", "extents", "btree", "uuid"
+		"dev", "local", "extents", "btree", "uuid", "rtrmap"
 	};
 
 	libxfs_inode_from_disk(&xino, dip);
@@ -2761,12 +2773,23 @@ process_inode(
 				be32_to_cpu(dip->di_next_unlinked), ino);
 		error++;
 	}
-	/*
-	 * di_mode is a 16-bit uint so no need to check the < 0 case
-	 */
+
+	/* Check that mode and data fork format match. */
 	mode = be16_to_cpu(dip->di_mode);
-	if ((((mode & S_IFMT) >> 12) > 15) ||
-	    (!(okfmts[(mode & S_IFMT) >> 12] & (1 << xino.i_d.di_format)))) {
+	if (ino == mp->m_sb.sb_rrmapino) {
+		if ((mode & S_IFMT) != S_IFREG ||
+		    xino.i_d.di_format != XFS_DINODE_FMT_RMAP) {
+			if (v)
+				dbprintf(_("bad format %d for rtrmap inode %lld type %#o\n"),
+					xino.i_d.di_format, id->ino, mode & S_IFMT);
+			error++;
+			return;
+		}
+	} else if ((((mode & S_IFMT) >> 12) > 15) ||
+		   (!(okfmts[(mode & S_IFMT) >> 12] & (1 << xino.i_d.di_format)))) {
+		/*
+		 * di_mode is a 16-bit uint so no need to check the < 0 case
+		 */
 		if (v)
 			dbprintf(_("bad format %d for inode %lld type %#o\n"),
 				xino.i_d.di_format, id->ino, mode & S_IFMT);
@@ -2823,8 +2846,10 @@ process_inode(
 			type = DBM_RTSUM;
 			blkmap = blkmap_alloc(xino.i_d.di_nextents);
 			addlink_inode(id);
-		}
-		else if (id->ino == mp->m_sb.sb_uquotino ||
+		} else if (id->ino == mp->m_sb.sb_rrmapino) {
+			type = DBM_BTRTRMAP;
+			addlink_inode(id);
+		} else if (id->ino == mp->m_sb.sb_uquotino ||
 			 id->ino == mp->m_sb.sb_gquotino ||
 			 id->ino == mp->m_sb.sb_pquotino) {
 			type = DBM_QUOTA;
@@ -2861,6 +2886,9 @@ process_inode(
 		process_btinode(id, dip, type, &totdblocks, &totiblocks,
 			&nextents, &blkmap, XFS_DATA_FORK);
 		break;
+	case XFS_DINODE_FMT_RMAP:
+		process_rtrmap(id, dip, &totiblocks);
+		break;
 	}
 	if (XFS_DFORK_Q(dip)) {
 		sbversion |= XFS_SB_VERSION_ATTRBIT;
@@ -3604,6 +3632,71 @@ process_rtsummary(
 	}
 }
 
+static void
+process_rtrmap(
+	struct inodata		*id,
+	struct xfs_dinode	*dip,
+	xfs_rfsblock_t		*toti)
+{
+	xfs_extnum_t		nex = 0;
+	xfs_rfsblock_t		totd = 0;
+	struct xfs_rtrmap_root	*dib;
+	int			whichfork = XFS_DATA_FORK;
+	int			i;
+	xfs_rtrmap_ptr_t	*pp;
+
+	dib = (struct xfs_rtrmap_root *)XFS_DFORK_PTR(dip, whichfork);
+	if (be16_to_cpu(dib->bb_level) >= mp->m_rtrmap_maxlevels) {
+		if (!sflag || id->ilist)
+			dbprintf(_("level for ino %lld rtrmap root too "
+				 "large (%u)\n"),
+				id->ino,
+				be16_to_cpu(dib->bb_level));
+		error++;
+		return;
+	}
+	if (be16_to_cpu(dib->bb_numrecs) > libxfs_rtrmapbt_maxrecs(mp,
+			XFS_DFORK_SIZE(dip, mp, whichfork),
+			be16_to_cpu(dib->bb_level) == 0)) {
+		if (!sflag || id->ilist)
+			dbprintf(_("numrecs for ino %lld rtrmap root too "
+				 "large (%u)\n"),
+				id->ino,
+				be16_to_cpu(dib->bb_numrecs));
+		error++;
+		return;
+	}
+	if (be16_to_cpu(dib->bb_level) == 0) {
+		struct xfs_rtrmap_rec	*rp;
+		xfs_fsblock_t		lastblock;
+
+		rp = XFS_RTRMAP_ROOT_REC_ADDR(dib, 1);
+		lastblock = 0;
+		for (i = 0; i < be16_to_cpu(dib->bb_numrecs); i++) {
+			if (be64_to_cpu(rp[i].rm_startblock) < lastblock) {
+				dbprintf(_(
+		"out-of-order rtrmap btree record %d (%u %u) root\n"),
+					 i, be64_to_cpu(rp[i].rm_startblock),
+					 be32_to_cpu(rp[i].rm_startblock));
+			} else {
+				lastblock = be64_to_cpu(rp[i].rm_startblock) +
+					    be64_to_cpu(rp[i].rm_blockcount);
+			}
+		}
+		return;
+	} else {
+		pp = XFS_RTRMAP_ROOT_PTR_ADDR(dib, 1,
+				libxfs_rtrmapbt_maxrecs(mp,
+					XFS_DFORK_SIZE(dip, mp, whichfork), 0));
+		for (i = 0; i < be16_to_cpu(dib->bb_numrecs); i++)
+			scan_lbtree(get_unaligned_be64(&pp[i]),
+					be16_to_cpu(dib->bb_level),
+					scanfunc_rtrmap, DBM_BTRTRMAP,
+					id, &totd, toti,
+					&nex, NULL, 1, TYP_RTRMAPBT);
+	}
+}
+
 static xfs_ino_t
 process_sf_dir_v2(
 	xfs_dinode_t		*dip,
@@ -4691,6 +4784,86 @@ scanfunc_rmap(
 }
 
 static void
+scanfunc_rtrmap(
+	struct xfs_btree_block	*block,
+	int			level,
+	dbm_t			type,
+	xfs_fsblock_t		bno,
+	inodata_t		*id,
+	xfs_rfsblock_t		*totd,
+	xfs_rfsblock_t		*toti,
+	xfs_extnum_t		*nex,
+	blkmap_t		**blkmapp,
+	int			isroot,
+	typnm_t			btype)
+{
+	xfs_agblock_t		agbno;
+	xfs_agnumber_t		agno;
+	int			i;
+	xfs_rtrmap_ptr_t	*pp;
+	struct xfs_rtrmap_rec	*rp;
+	xfs_fsblock_t		lastblock;
+
+	agno = XFS_FSB_TO_AGNO(mp, bno);
+	agbno = XFS_FSB_TO_AGBNO(mp, bno);
+	if (be32_to_cpu(block->bb_magic) != XFS_RTRMAP_CRC_MAGIC) {
+		dbprintf(_("bad magic # %#x in rtrmapbt block %u/%u\n"),
+			be32_to_cpu(block->bb_magic), agno, bno);
+		serious_error++;
+		return;
+	}
+	if (be16_to_cpu(block->bb_level) != level) {
+		if (!sflag)
+			dbprintf(_("expected level %d got %d in rtrmapbt block "
+				 "%u/%u\n"),
+				level, be16_to_cpu(block->bb_level), agno, bno);
+		error++;
+	}
+	set_dbmap(agno, bno, 1, type, agno, bno);
+	set_inomap(agno, agbno, 1, id);
+	(*toti)++;
+	if (level == 0) {
+		if (be16_to_cpu(block->bb_numrecs) > mp->m_rtrmap_mxr[0] ||
+		    (isroot == 0 && be16_to_cpu(block->bb_numrecs) < mp->m_rtrmap_mnr[0])) {
+			dbprintf(_("bad btree nrecs (%u, min=%u, max=%u) in "
+				 "rtrmapbt block %u/%u\n"),
+				be16_to_cpu(block->bb_numrecs), mp->m_rtrmap_mnr[0],
+				mp->m_rtrmap_mxr[0], agno, bno);
+			serious_error++;
+			return;
+		}
+		rp = XFS_RTRMAP_REC_ADDR(block, 1);
+		lastblock = 0;
+		for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++) {
+			if (be64_to_cpu(rp[i].rm_startblock) < lastblock) {
+				dbprintf(_(
+		"out-of-order rtrmap btree record %d (%u %u) block %u/%u l %llu\n"),
+					 i, be64_to_cpu(rp[i].rm_startblock),
+					 be64_to_cpu(rp[i].rm_blockcount),
+					 agno, bno, lastblock);
+			} else {
+				lastblock = be64_to_cpu(rp[i].rm_startblock) +
+					    be64_to_cpu(rp[i].rm_blockcount);
+			}
+		}
+		return;
+	}
+	if (be16_to_cpu(block->bb_numrecs) > mp->m_rtrmap_mxr[1] ||
+	    (isroot == 0 && be16_to_cpu(block->bb_numrecs) < mp->m_rtrmap_mnr[1])) {
+		dbprintf(_("bad btree nrecs (%u, min=%u, max=%u) in rtrmapbt "
+			 "block %u/%u\n"),
+			be16_to_cpu(block->bb_numrecs), mp->m_rtrmap_mnr[1],
+			mp->m_rtrmap_mxr[1], agno, bno);
+		serious_error++;
+		return;
+	}
+	pp = XFS_RTRMAP_PTR_ADDR(block, 1, mp->m_rtrmap_mxr[1]);
+	for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++)
+		scan_lbtree(be64_to_cpu(pp[i]), level, scanfunc_rtrmap, type, id,
+					totd, toti, nex, blkmapp, 0, btype);
+}
+
+static void
 scanfunc_refcnt(
 	struct xfs_btree_block	*block,
 	int			level,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
