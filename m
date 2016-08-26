Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6EEA68458
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 19:00:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 409D68F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:00:50 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id wF0fWpdReetlwtP4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:00:48 -0700 (PDT)
Subject: [PATCH 18/29] xfs_db: copy the realtime rmap btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 17:00:30 -0700
Message-ID: <147216963038.7022.4032781758440858795.stgit@birch.djwong.org>
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

Copy the realtime rmapbt when we're metadumping the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/metadump.c |  124 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 124 insertions(+)


diff --git a/db/metadump.c b/db/metadump.c
index ab64fbd..34f5f47 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -616,6 +616,54 @@ copy_rmap_btree(
 }
 
 static int
+scanfunc_rtrmapbt(
+	struct xfs_btree_block	*block,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	int			level,
+	typnm_t			btype,
+	void			*arg)
+{
+	xfs_rtrmap_ptr_t	*pp;
+	int			i;
+	int			numrecs;
+
+	if (level == 0)
+		return 1;
+
+	numrecs = be16_to_cpu(block->bb_numrecs);
+	if (numrecs > mp->m_rtrmap_mxr[1]) {
+		if (show_warnings)
+			print_warning("invalid numrecs (%u) in %s block %u/%u",
+				numrecs, typtab[btype].name, agno, agbno);
+		return 1;
+	}
+
+	pp = XFS_RTRMAP_PTR_ADDR(block, 1, mp->m_rtrmap_mxr[1]);
+	for (i = 0; i < numrecs; i++) {
+		xfs_agnumber_t	pagno;
+		xfs_agblock_t	pbno;
+
+		pagno = XFS_FSB_TO_AGNO(mp, get_unaligned_be64(&pp[i]));
+		pbno = XFS_FSB_TO_AGBNO(mp, get_unaligned_be64(&pp[i]));
+
+		if (pbno == 0 || pbno > mp->m_sb.sb_agblocks ||
+		    pagno > mp->m_sb.sb_agcount) {
+			if (show_warnings)
+				print_warning("invalid block number (%u/%u) "
+						"in inode %llu %s block %u/%u",
+						pagno, pbno, (long long)cur_ino,
+						typtab[btype].name, agno, agbno);
+			continue;
+		}
+		if (!scan_btree(pagno, pbno, level, btype, arg,
+				scanfunc_rtrmapbt))
+			return 0;
+	}
+	return 1;
+}
+
+static int
 scanfunc_refcntbt(
 	struct xfs_btree_block	*block,
 	xfs_agnumber_t		agno,
@@ -2152,6 +2200,79 @@ process_exinode(
 }
 
 static int
+process_rtrmap(
+	struct xfs_dinode	*dip,
+	typnm_t			itype)
+{
+	struct xfs_rtrmap_root	*dib;
+	int			i;
+	xfs_rtrmap_ptr_t	*pp;
+	int			level;
+	int			nrecs;
+	int			maxrecs;
+	int			whichfork;
+	typnm_t			btype;
+
+	if (itype == TYP_ATTR && show_warnings) {
+		print_warning("ignoring rtrmapbt root in inode %llu attr fork",
+				(long long)cur_ino);
+		return 1;
+	}
+
+	whichfork = XFS_DATA_FORK;
+	btype = TYP_RTRMAPBT;
+
+	dib = (struct xfs_rtrmap_root *)XFS_DFORK_PTR(dip, whichfork);
+	level = be16_to_cpu(dib->bb_level);
+	nrecs = be16_to_cpu(dib->bb_numrecs);
+
+	if (level > mp->m_rtrmap_maxlevels) {
+		if (show_warnings)
+			print_warning("invalid level (%u) in inode %lld %s "
+					"root", level, (long long)cur_ino,
+					typtab[btype].name);
+		return 1;
+	}
+
+	if (level == 0)
+		return 1;
+
+	maxrecs = libxfs_rtrmapbt_maxrecs(mp,
+			XFS_DFORK_SIZE(dip, mp, whichfork), 0);
+	if (nrecs > maxrecs) {
+		if (show_warnings)
+			print_warning("invalid numrecs (%u) in inode %lld %s "
+					"root", nrecs, (long long)cur_ino,
+					typtab[btype].name);
+		return 1;
+	}
+
+	pp = XFS_RTRMAP_ROOT_PTR_ADDR(dib, 1, maxrecs);
+	for (i = 0; i < nrecs; i++) {
+		xfs_agnumber_t	ag;
+		xfs_agblock_t	bno;
+
+		ag = XFS_FSB_TO_AGNO(mp, get_unaligned_be64(&pp[i]));
+		bno = XFS_FSB_TO_AGBNO(mp, get_unaligned_be64(&pp[i]));
+
+		if (bno == 0 || bno > mp->m_sb.sb_agblocks ||
+				ag > mp->m_sb.sb_agcount) {
+			if (show_warnings)
+				print_warning("invalid block number (%u/%u) "
+						"in inode %llu %s root", ag,
+						bno, (long long)cur_ino,
+						typtab[btype].name);
+			continue;
+		}
+
+		if (!scan_btree(ag, bno, level, btype, &itype,
+				scanfunc_rtrmapbt))
+			return 0;
+	}
+	return 1;
+}
+
+static int
 process_inode_data(
 	xfs_dinode_t		*dip,
 	typnm_t			itype)
@@ -2177,6 +2298,9 @@ process_inode_data(
 
 		case XFS_DINODE_FMT_BTREE:
 			return process_btinode(dip, itype);
+
+		case XFS_DINODE_FMT_RMAP:
+			return process_rtrmap(dip, itype);
 	}
 	return 1;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
