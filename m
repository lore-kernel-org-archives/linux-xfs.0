Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BE0D329E1F
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:07:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AE56E30404E
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:07:22 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id dB1AQ9wahgYDlLps (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:07:21 -0800 (PST)
Subject: [PATCH 22/53] xfs_db: check rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:07:18 -0800
Message-ID: <20151219090718.14255.26056.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 84 insertions(+), 1 deletion(-)


diff --git a/db/check.c b/db/check.c
index f1620f8..4721834 100644
--- a/db/check.c
+++ b/db/check.c
@@ -44,7 +44,7 @@ typedef enum {
 	DBM_FREE1,	DBM_FREE2,	DBM_FREELIST,	DBM_INODE,
 	DBM_LOG,	DBM_MISSING,	DBM_QUOTA,	DBM_RTBITMAP,
 	DBM_RTDATA,	DBM_RTFREE,	DBM_RTSUM,	DBM_SB,
-	DBM_SYMLINK,	DBM_BTFINO,
+	DBM_SYMLINK,	DBM_BTFINO,	DBM_BTRMAP,
 	DBM_NDBM
 } dbm_t;
 
@@ -171,6 +171,7 @@ static const char	*typename[] = {
 	"sb",
 	"symlink",
 	"btfino",
+	"btrmap",
 	NULL
 };
 static int		verbose;
@@ -349,6 +350,9 @@ static void		scanfunc_ino(struct xfs_btree_block *block, int level,
 static void		scanfunc_fino(struct xfs_btree_block *block, int level,
 				     struct xfs_agf *agf, xfs_agblock_t bno,
 				     int isroot);
+static void		scanfunc_rmap(struct xfs_btree_block *block, int level,
+				     struct xfs_agf *agf, xfs_agblock_t bno,
+				     int isroot);
 static void		set_dbmap(xfs_agnumber_t agno, xfs_agblock_t agbno,
 				  xfs_extlen_t len, dbm_t type,
 				  xfs_agnumber_t c_agno, xfs_agblock_t c_agbno);
@@ -1050,6 +1054,7 @@ blocktrash_f(
 		   (1 << DBM_RTSUM) |
 		   (1 << DBM_SYMLINK) |
 		   (1 << DBM_BTFINO) |
+		   (1 << DBM_BTRMAP) |
 		   (1 << DBM_SB);
 	while ((c = getopt(argc, argv, "0123n:o:s:t:x:y:z")) != EOF) {
 		switch (c) {
@@ -3907,6 +3912,12 @@ scan_ag(
 		be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]),
 		be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]),
 		1, scanfunc_cnt, TYP_CNTBT);
+	if (agf->agf_roots[XFS_BTNUM_RMAP]) {
+		scan_sbtree(agf,
+			be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]),
+			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]),
+			1, scanfunc_rmap, TYP_RMAPBT);
+	}
 	scan_sbtree(agf,
 		be32_to_cpu(agi->agi_root),
 		be32_to_cpu(agi->agi_level),
@@ -4658,6 +4669,78 @@ scanfunc_fino(
 }
 
 static void
+scanfunc_rmap(
+	struct xfs_btree_block	*block,
+	int			level,
+	struct xfs_agf		*agf,
+	xfs_agblock_t		bno,
+	int			isroot)
+{
+	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
+	int			i;
+	xfs_rmap_ptr_t		*pp;
+	struct xfs_rmap_rec	*rp;
+	xfs_agblock_t		lastblock;
+
+	if (be32_to_cpu(block->bb_magic) != XFS_RMAP_CRC_MAGIC) {
+		dbprintf(_("bad magic # %#x in rmapbt block %u/%u\n"),
+			be32_to_cpu(block->bb_magic), seqno, bno);
+		serious_error++;
+		return;
+	}
+	if (be16_to_cpu(block->bb_level) != level) {
+		if (!sflag)
+			dbprintf(_("expected level %d got %d in rmapbt block "
+				 "%u/%u\n"),
+				level, be16_to_cpu(block->bb_level), seqno, bno);
+		error++;
+	}
+	if (!isroot) {
+		fdblocks++;
+		agfbtreeblks++;
+	}
+	set_dbmap(seqno, bno, 1, DBM_BTRMAP, seqno, bno);
+	if (level == 0) {
+		if (be16_to_cpu(block->bb_numrecs) > mp->m_rmap_mxr[0] ||
+		    (isroot == 0 && be16_to_cpu(block->bb_numrecs) < mp->m_rmap_mnr[0])) {
+			dbprintf(_("bad btree nrecs (%u, min=%u, max=%u) in "
+				 "rmapbt block %u/%u\n"),
+				be16_to_cpu(block->bb_numrecs), mp->m_rmap_mnr[0],
+				mp->m_rmap_mxr[0], seqno, bno);
+			serious_error++;
+			return;
+		}
+		rp = XFS_RMAP_REC_ADDR(block, 1);
+		lastblock = 0;
+		for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++) {
+			if (be32_to_cpu(rp[i].rm_startblock) < lastblock) {
+				dbprintf(_(
+		"out-of-order rmap btree record %d (%u %u) block %u/%u\n"),
+					 i, be32_to_cpu(rp[i].rm_startblock),
+					 be32_to_cpu(rp[i].rm_startblock),
+					 be32_to_cpu(agf->agf_seqno), bno);
+			} else {
+				lastblock = be32_to_cpu(rp[i].rm_startblock);
+			}
+		}
+		return;
+	}
+	if (be16_to_cpu(block->bb_numrecs) > mp->m_rmap_mxr[1] ||
+	    (isroot == 0 && be16_to_cpu(block->bb_numrecs) < mp->m_rmap_mnr[1])) {
+		dbprintf(_("bad btree nrecs (%u, min=%u, max=%u) in rmapbt "
+			 "block %u/%u\n"),
+			be16_to_cpu(block->bb_numrecs), mp->m_rmap_mnr[1],
+			mp->m_rmap_mxr[1], seqno, bno);
+		serious_error++;
+		return;
+	}
+	pp = XFS_RMAP_PTR_ADDR(block, 1, mp->m_rmap_mxr[1]);
+	for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++)
+		scan_sbtree(agf, be32_to_cpu(pp[i]), level, 0, scanfunc_rmap,
+				TYP_RMAPBT);
+}
+
+static void
 set_dbmap(
 	xfs_agnumber_t	agno,
 	xfs_agblock_t	agbno,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
