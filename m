Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4FE9A29E2A
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:09:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 260E18F8039
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:09:44 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Y8LWliUIAV4BK2R3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:09:42 -0800 (PST)
Subject: [PATCH 42/53] xfs_db: metadump should copy the refcount btree too
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:09:36 -0800
Message-ID: <20151219090936.14255.66838.stgit@birch.djwong.org>
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

Teach metadump to copy the refcount btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/metadump.c |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)


diff --git a/db/metadump.c b/db/metadump.c
index 94c22a9..56c7ae2 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -596,6 +596,78 @@ copy_rmap_btree(
 	return scan_btree(agno, root, levels, TYP_RMAPBT, agf, scanfunc_rmapbt);
 }
 
+static int
+scanfunc_refcntbt(
+	struct xfs_btree_block	*block,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	int			level,
+	typnm_t			btype,
+	void			*arg)
+{
+	xfs_refcount_ptr_t	*pp;
+	int			i;
+	int			numrecs;
+
+	if (level == 0)
+		return 1;
+
+	numrecs = be16_to_cpu(block->bb_numrecs);
+	if (numrecs > mp->m_refc_mxr[1]) {
+		if (show_warnings)
+			print_warning("invalid numrecs (%u) in %s block %u/%u",
+				numrecs, typtab[btype].name, agno, agbno);
+		return 1;
+	}
+
+	pp = XFS_REFCOUNT_PTR_ADDR(block, 1, mp->m_refc_mxr[1]);
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
+				scanfunc_refcntbt))
+			return 0;
+	}
+	return 1;
+}
+
+static int
+copy_refcount_btree(
+	xfs_agnumber_t	agno,
+	struct xfs_agf	*agf)
+{
+	xfs_agblock_t	root;
+	int		levels;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return 1;
+
+	root = be32_to_cpu(agf->agf_refcount_root);
+	levels = be32_to_cpu(agf->agf_refcount_level);
+
+	/* validate root and levels before processing the tree */
+	if (root == 0 || root > mp->m_sb.sb_agblocks) {
+		if (show_warnings)
+			print_warning("invalid block number (%u) in refcntbt "
+					"root in agf %u", root, agno);
+		return 1;
+	}
+	if (levels >= XFS_BTREE_MAXLEVELS) {
+		if (show_warnings)
+			print_warning("invalid level (%u) in refcntbt root "
+					"in agf %u", levels, agno);
+		return 1;
+	}
+
+	return scan_btree(agno, root, levels, TYP_REFCBT, agf, scanfunc_refcntbt);
+}
+
 /* filename and extended attribute obfuscation routines */
 
 struct name_ent {
@@ -2506,6 +2578,8 @@ scan_ag(
 			goto pop_out;
 		if (!copy_rmap_btree(agno, agf))
 			goto pop_out;
+		if (!copy_refcount_btree(agno, agf))
+			goto pop_out;
 	}
 
 	/* copy inode btrees and the inodes and their associated metadata */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
