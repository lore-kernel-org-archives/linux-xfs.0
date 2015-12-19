Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B65CB29E57
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:09:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A7F88304062
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:09:39 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id CAmTBJNGPk5nycqj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:09:37 -0800 (PST)
Subject: [PATCH 41/53] xfs_db: add support for checking the refcount btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:09:30 -0800
Message-ID: <20151219090930.14255.62537.stgit@birch.djwong.org>
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

Do some basic checks of the refcount btree.  xfs_repair will have to
check that the reference counts match the various bmbt mappings.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c |  136 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 128 insertions(+), 8 deletions(-)


diff --git a/db/check.c b/db/check.c
index 4721834..661ba06 100644
--- a/db/check.c
+++ b/db/check.c
@@ -44,7 +44,8 @@ typedef enum {
 	DBM_FREE1,	DBM_FREE2,	DBM_FREELIST,	DBM_INODE,
 	DBM_LOG,	DBM_MISSING,	DBM_QUOTA,	DBM_RTBITMAP,
 	DBM_RTDATA,	DBM_RTFREE,	DBM_RTSUM,	DBM_SB,
-	DBM_SYMLINK,	DBM_BTFINO,	DBM_BTRMAP,
+	DBM_SYMLINK,	DBM_BTFINO,	DBM_BTRMAP,	DBM_BTREFC,
+	DBM_RLDATA,
 	DBM_NDBM
 } dbm_t;
 
@@ -52,7 +53,8 @@ typedef struct inodata {
 	struct inodata	*next;
 	nlink_t		link_set;
 	nlink_t		link_add;
-	char		isdir;
+	char		isdir:1;
+	char		isreflink:1;
 	char		security;
 	char		ilist;
 	xfs_ino_t	ino;
@@ -172,6 +174,8 @@ static const char	*typename[] = {
 	"symlink",
 	"btfino",
 	"btrmap",
+	"btrefcnt",
+	"rldata",
 	NULL
 };
 static int		verbose;
@@ -229,7 +233,8 @@ static int		blocktrash_f(int argc, char **argv);
 static int		blockuse_f(int argc, char **argv);
 static int		check_blist(xfs_fsblock_t bno);
 static void		check_dbmap(xfs_agnumber_t agno, xfs_agblock_t agbno,
-				    xfs_extlen_t len, dbm_t type);
+				    xfs_extlen_t len, dbm_t type,
+				    int ignore_reflink);
 static int		check_inomap(xfs_agnumber_t agno, xfs_agblock_t agbno,
 				     xfs_extlen_t len, xfs_ino_t c_ino);
 static void		check_linkcounts(xfs_agnumber_t agno);
@@ -353,6 +358,9 @@ static void		scanfunc_fino(struct xfs_btree_block *block, int level,
 static void		scanfunc_rmap(struct xfs_btree_block *block, int level,
 				     struct xfs_agf *agf, xfs_agblock_t bno,
 				     int isroot);
+static void		scanfunc_refcnt(struct xfs_btree_block *block, int level,
+				     struct xfs_agf *agf, xfs_agblock_t bno,
+				     int isroot);
 static void		set_dbmap(xfs_agnumber_t agno, xfs_agblock_t agbno,
 				  xfs_extlen_t len, dbm_t type,
 				  xfs_agnumber_t c_agno, xfs_agblock_t c_agbno);
@@ -1055,6 +1063,7 @@ blocktrash_f(
 		   (1 << DBM_SYMLINK) |
 		   (1 << DBM_BTFINO) |
 		   (1 << DBM_BTRMAP) |
+		   (1 << DBM_BTREFC) |
 		   (1 << DBM_SB);
 	while ((c = getopt(argc, argv, "0123n:o:s:t:x:y:z")) != EOF) {
 		switch (c) {
@@ -1291,18 +1300,25 @@ check_dbmap(
 	xfs_agnumber_t	agno,
 	xfs_agblock_t	agbno,
 	xfs_extlen_t	len,
-	dbm_t		type)
+	dbm_t		type,
+	int		ignore_reflink)
 {
 	xfs_extlen_t	i;
 	char		*p;
+	dbm_t		d;
 
 	for (i = 0, p = &dbmap[agno][agbno]; i < len; i++, p++) {
+		d = (dbm_t)*p;
+		if (ignore_reflink && (d == DBM_UNKNOWN || d == DBM_DATA ||
+				       d == DBM_RLDATA))
+			continue;
 		if ((dbm_t)*p != type) {
-			if (!sflag || CHECK_BLISTA(agno, agbno + i))
+			if (!sflag || CHECK_BLISTA(agno, agbno + i)) {
 				dbprintf(_("block %u/%u expected type %s got "
 					 "%s\n"),
 					agno, agbno + i, typename[type],
 					typename[(dbm_t)*p]);
+			}
 			error++;
 		}
 	}
@@ -1336,7 +1352,7 @@ check_inomap(
 		return 0;
 	}
 	for (i = 0, rval = 1, idp = &inomap[agno][agbno]; i < len; i++, idp++) {
-		if (*idp) {
+		if (*idp && !(*idp)->isreflink) {
 			if (!sflag || (*idp)->ilist ||
 			    CHECK_BLISTA(agno, agbno + i))
 				dbprintf(_("block %u/%u claimed by inode %lld, "
@@ -1542,6 +1558,26 @@ check_rrange(
 	return 1;
 }
 
+/*
+ * We don't check the accuracy of reference counts -- all we do is ensure
+ * that a data block never crosses with non-data blocks.  repair can check
+ * those kinds of things.
+ *
+ * So with that in mind, if we're setting a block to be data or rldata,
+ * don't complain so long as the block is currently unknown, data, or rldata.
+ * Don't let blocks downgrade from rldata -> data.
+ */
+static bool
+is_reflink(
+	dbm_t		type2)
+{
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return false;
+	if (type2 == DBM_DATA || type2 == DBM_RLDATA)
+		return true;
+	return false;
+}
+
 static void
 check_set_dbmap(
 	xfs_agnumber_t	agno,
@@ -1561,10 +1597,15 @@ check_set_dbmap(
 			agbno, agbno + len - 1, c_agno, c_agbno);
 		return;
 	}
-	check_dbmap(agno, agbno, len, type1);
+	check_dbmap(agno, agbno, len, type1, is_reflink(type2));
 	mayprint = verbose | blist_size;
 	for (i = 0, p = &dbmap[agno][agbno]; i < len; i++, p++) {
-		*p = (char)type2;
+		if (*p == DBM_RLDATA && type2 == DBM_DATA)
+			;	/* do nothing */
+		if (*p == DBM_DATA && type2 == DBM_DATA)
+			*p = (char)DBM_RLDATA;
+		else
+			*p = (char)type2;
 		if (mayprint && (verbose || CHECK_BLISTA(agno, agbno + i)))
 			dbprintf(_("setting block %u/%u to %s\n"), agno, agbno + i,
 				typename[type2]);
@@ -2806,6 +2847,7 @@ process_inode(
 		type = DBM_UNKNOWN;
 		break;
 	}
+	id->isreflink = !!(idic.di_flags2 & XFS_DIFLAG2_REFLINK);
 	if (idic.di_version == 1)
 		setlink_inode(id, idic.di_onlink, type == DBM_DIR, security);
 	else {
@@ -3918,6 +3960,12 @@ scan_ag(
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]),
 			1, scanfunc_rmap, TYP_RMAPBT);
 	}
+	if (agf->agf_refcount_root) {
+		scan_sbtree(agf,
+			be32_to_cpu(agf->agf_refcount_root),
+			be32_to_cpu(agf->agf_refcount_level),
+			1, scanfunc_refcnt, TYP_REFCBT);
+	}
 	scan_sbtree(agf,
 		be32_to_cpu(agi->agi_root),
 		be32_to_cpu(agi->agi_level),
@@ -4741,6 +4789,78 @@ scanfunc_rmap(
 }
 
 static void
+scanfunc_refcnt(
+	struct xfs_btree_block	*block,
+	int			level,
+	struct xfs_agf		*agf,
+	xfs_agblock_t		bno,
+	int			isroot)
+{
+	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
+	int			i;
+	xfs_refcount_ptr_t	*pp;
+	struct xfs_refcount_rec	*rp;
+	xfs_agblock_t		lastblock;
+
+	if (be32_to_cpu(block->bb_magic) != XFS_REFC_CRC_MAGIC) {
+		dbprintf(_("bad magic # %#x in refcntbt block %u/%u\n"),
+			be32_to_cpu(block->bb_magic), seqno, bno);
+		serious_error++;
+		return;
+	}
+	if (be16_to_cpu(block->bb_level) != level) {
+		if (!sflag)
+			dbprintf(_("expected level %d got %d in refcntbt block "
+				 "%u/%u\n"),
+				level, be16_to_cpu(block->bb_level), seqno, bno);
+		error++;
+	}
+	set_dbmap(seqno, bno, 1, DBM_BTREFC, seqno, bno);
+	if (level == 0) {
+		if (be16_to_cpu(block->bb_numrecs) > mp->m_refc_mxr[0] ||
+		    (isroot == 0 && be16_to_cpu(block->bb_numrecs) < mp->m_refc_mnr[0])) {
+			dbprintf(_("bad btree nrecs (%u, min=%u, max=%u) in "
+				 "refcntbt block %u/%u\n"),
+				be16_to_cpu(block->bb_numrecs), mp->m_refc_mnr[0],
+				mp->m_refc_mxr[0], seqno, bno);
+			serious_error++;
+			return;
+		}
+		rp = XFS_REFCOUNT_REC_ADDR(block, 1);
+		lastblock = 0;
+		for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++) {
+			set_dbmap(seqno, be32_to_cpu(rp[i].rc_startblock),
+				be32_to_cpu(rp[i].rc_blockcount), DBM_RLDATA,
+				seqno, bno);
+			if (be32_to_cpu(rp[i].rc_startblock) < lastblock) {
+				dbprintf(_(
+		"out-of-order refcnt btree record %d (%u %u) block %u/%u\n"),
+					 i, be32_to_cpu(rp[i].rc_startblock),
+					 be32_to_cpu(rp[i].rc_startblock),
+					 be32_to_cpu(agf->agf_seqno), bno);
+			} else {
+				lastblock = be32_to_cpu(rp[i].rc_startblock) +
+					    be32_to_cpu(rp[i].rc_blockcount);
+			}
+		}
+		return;
+	}
+	if (be16_to_cpu(block->bb_numrecs) > mp->m_refc_mxr[1] ||
+	    (isroot == 0 && be16_to_cpu(block->bb_numrecs) < mp->m_refc_mnr[1])) {
+		dbprintf(_("bad btree nrecs (%u, min=%u, max=%u) in refcntbt "
+			 "block %u/%u\n"),
+			be16_to_cpu(block->bb_numrecs), mp->m_refc_mnr[1],
+			mp->m_refc_mxr[1], seqno, bno);
+		serious_error++;
+		return;
+	}
+	pp = XFS_REFCOUNT_PTR_ADDR(block, 1, mp->m_refc_mxr[1]);
+	for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++)
+		scan_sbtree(agf, be32_to_cpu(pp[i]), level, 0, scanfunc_refcnt,
+				TYP_REFCBT);
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
