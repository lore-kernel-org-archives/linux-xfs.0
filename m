Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B7E9A7F98
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 22:26:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A6C068F8035
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 20:26:28 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id xwwhoQAFpENmQe0K (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 20:26:27 -0700 (PDT)
Subject: [PATCH 07/15] xfs_db: metadump should copy the reflink btree too
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Jun 2015 20:26:24 -0700
Message-ID: <20150630032624.572.31240.stgit@birch.djwong.org>
In-Reply-To: <20150630032538.572.20293.stgit@birch.djwong.org>
References: <20150630032538.572.20293.stgit@birch.djwong.org>
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

Teach metadump to copy the reflink btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/metadump.c |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)


diff --git a/db/metadump.c b/db/metadump.c
index cca9b49..29d93c9 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -397,6 +397,78 @@ copy_free_cnt_btree(
 	return scan_btree(agno, root, levels, TYP_CNTBT, agf, scanfunc_freesp);
 }
 
+static int
+scanfunc_rlbt(
+	struct xfs_btree_block	*block,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	int			level,
+	typnm_t			btype,
+	void			*arg)
+{
+	xfs_reflink_ptr_t	*pp;
+	int			i;
+	int			numrecs;
+
+	if (level == 0)
+		return 1;
+
+	numrecs = be16_to_cpu(block->bb_numrecs);
+	if (numrecs > mp->m_rlbt_mxr[1]) {
+		if (show_warnings)
+			print_warning("invalid numrecs (%u) in %s block %u/%u",
+				numrecs, typtab[btype].name, agno, agbno);
+		return 1;
+	}
+
+	pp = XFS_REFLINK_PTR_ADDR(block, 1, mp->m_rlbt_mxr[1]);
+	for (i = 0; i < numrecs; i++) {
+		if (!valid_bno(agno, be32_to_cpu(pp[i]))) {
+			if (show_warnings)
+				print_warning("invalid block number (%u/%u) "
+					"in %s block %u/%u",
+					agno, be32_to_cpu(pp[i]),
+					typtab[btype].name, agno, agbno);
+			continue;
+		}
+		if (!scan_btree(agno, be32_to_cpu(pp[i]), level, btype, arg,
+				scanfunc_rlbt))
+			return 0;
+	}
+	return 1;
+}
+
+static int
+copy_reflink_btree(
+	xfs_agnumber_t	agno,
+	xfs_agf_t	*agf)
+{
+	xfs_agblock_t	root;
+	int		levels;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return 0;
+
+	root = be32_to_cpu(agf->agf_reflink_root);
+	levels = be32_to_cpu(agf->agf_reflink_level);
+
+	/* validate root and levels before processing the tree */
+	if (root == 0 || root > mp->m_sb.sb_agblocks) {
+		if (show_warnings)
+			print_warning("invalid block number (%u) in bnobt "
+					"root in agf %u", root, agno);
+		return 1;
+	}
+	if (levels >= XFS_BTREE_MAXLEVELS) {
+		if (show_warnings)
+			print_warning("invalid level (%u) in bnobt root "
+					"in agf %u", levels, agno);
+		return 1;
+	}
+
+	return scan_btree(agno, root, levels, TYP_RLBT, agf, scanfunc_rlbt);
+}
+
 /* filename and extended attribute obfuscation routines */
 
 struct name_ent {
@@ -2125,6 +2197,8 @@ scan_ag(
 			goto pop_out;
 		if (!copy_free_cnt_btree(agno, agf))
 			goto pop_out;
+		if (!copy_reflink_btree(agno, agf))
+			goto pop_out;
 	}
 
 	/* copy inode btrees and the inodes and their associated metadata */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
