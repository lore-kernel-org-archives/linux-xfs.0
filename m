Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46062 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755795AbcJYXEv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:04:51 -0400
Subject: [PATCH 11/39] xfs_db: metadump should copy the refcount btree too
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:04:46 -0700
Message-ID: <147743668609.11035.16781673871765061912.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Teach metadump to copy the refcount btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/metadump.c |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)


diff --git a/db/metadump.c b/db/metadump.c
index c769958..1ba6b38 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -615,6 +615,78 @@ copy_rmap_btree(
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
@@ -2525,6 +2597,8 @@ scan_ag(
 			goto pop_out;
 		if (!copy_rmap_btree(agno, agf))
 			goto pop_out;
+		if (!copy_refcount_btree(agno, agf))
+			goto pop_out;
 	}
 
 	/* copy inode btrees and the inodes and their associated metadata */

