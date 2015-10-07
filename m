Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B31D629E90
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:07:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 21C9CAC007
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:07:46 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ttFPkjDNJwjOxg2f (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:07:44 -0700 (PDT)
Subject: [PATCH 23/51] xfs_db: copy the rmap btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:07:41 -0700
Message-ID: <20151007050741.1504.12253.stgit@birch.djwong.org>
In-Reply-To: <20151007050513.1504.28089.stgit@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
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
 db/metadump.c |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)


diff --git a/db/metadump.c b/db/metadump.c
index af96e12..545f55b 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -523,6 +523,78 @@ copy_free_cnt_btree(
 	return scan_btree(agno, root, levels, TYP_CNTBT, agf, scanfunc_freesp);
 }
 
+static int
+scanfunc_rmapbt(
+	struct xfs_btree_block	*block,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	int			level,
+	typnm_t			btype,
+	void			*arg)
+{
+	xfs_rmap_ptr_t		*pp;
+	int			i;
+	int			numrecs;
+
+	if (level == 0)
+		return 1;
+
+	numrecs = be16_to_cpu(block->bb_numrecs);
+	if (numrecs > mp->m_rmap_mxr[1]) {
+		if (show_warnings)
+			print_warning("invalid numrecs (%u) in %s block %u/%u",
+				numrecs, typtab[btype].name, agno, agbno);
+		return 1;
+	}
+
+	pp = XFS_RMAP_PTR_ADDR(block, 1, mp->m_rmap_mxr[1]);
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
+				scanfunc_rmapbt))
+			return 0;
+	}
+	return 1;
+}
+
+static int
+copy_rmap_btree(
+	xfs_agnumber_t	agno,
+	struct xfs_agf	*agf)
+{
+	xfs_agblock_t	root;
+	int		levels;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return 1;
+
+	root = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
+	levels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
+
+	/* validate root and levels before processing the tree */
+	if (root == 0 || root > mp->m_sb.sb_agblocks) {
+		if (show_warnings)
+			print_warning("invalid block number (%u) in rmapbt "
+					"root in agf %u", root, agno);
+		return 1;
+	}
+	if (levels >= XFS_BTREE_MAXLEVELS) {
+		if (show_warnings)
+			print_warning("invalid level (%u) in rmapbt root "
+					"in agf %u", levels, agno);
+		return 1;
+	}
+
+	return scan_btree(agno, root, levels, TYP_RMAPBT, agf, scanfunc_rmapbt);
+}
+
 /* filename and extended attribute obfuscation routines */
 
 struct name_ent {
@@ -2431,6 +2503,8 @@ scan_ag(
 			goto pop_out;
 		if (!copy_free_cnt_btree(agno, agf))
 			goto pop_out;
+		if (!copy_rmap_btree(agno, agf))
+			goto pop_out;
 	}
 
 	/* copy inode btrees and the inodes and their associated metadata */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
