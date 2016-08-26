Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B344084A8
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 19:01:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 48171AC001
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:01:46 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 5pAoGkPZHQmkCVSV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:01:44 -0700 (PDT)
Subject: [PATCH 28/29] xfs_repair: rebuild the realtime rmap btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 17:01:39 -0700
Message-ID: <147216969952.7022.7608225228147849784.stgit@birch.djwong.org>
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

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/phase6.c          |   73 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/rmap.c            |   68 +++++++++++++++++++++++++++++++++++++++++++
 repair/rmap.h            |    2 +
 repair/xfs_repair.c      |    5 +++
 5 files changed, 148 insertions(+), 1 deletion(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index a6ea865..44b9065 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -144,5 +144,6 @@
 #define xfs_refc_block			libxfs_refc_block
 #define xfs_rtrmapbt_maxrecs		libxfs_rtrmapbt_maxrecs
 #define xfs_rtrmapbt_init_cursor	libxfs_rtrmapbt_init_cursor
+#define xfs_rmap_map_extent		libxfs_rmap_map_extent
 
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/repair/phase6.c b/repair/phase6.c
index 6981b35..25d6801 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -29,6 +29,8 @@
 #include "dinode.h"
 #include "progress.h"
 #include "versions.h"
+#include "slab.h"
+#include "rmap.h"
 
 static struct cred		zerocr;
 static struct fsxattr 		zerofsx;
@@ -831,6 +833,61 @@ mk_rsumino(xfs_mount_t *mp)
 	IRELE(ip);
 }
 
+static void
+mk_rrmapino(
+	struct xfs_mount	*mp)
+{
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
+	struct cred		creds = {0};
+	struct fsxattr		fsxattrs = {0};
+	struct xfs_btree_block	*block;
+	int			error;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb) || mp->m_sb.sb_rblocks == 0)
+		return;
+
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
+	if (error)
+		res_failed(error);
+
+	if (mp->m_sb.sb_rrmapino == 0 ||
+	    mp->m_sb.sb_rrmapino == NULLFSINO ||
+	    need_rrmapino) {
+		/* Allocate a new inode. */
+		error = -libxfs_inode_alloc(&tp, NULL, S_IFREG, 1, 0,
+				&creds, &fsxattrs, &ip);
+		if (error) {
+			do_error(_("Realtime rmap inode allocation failed -- error %d"),
+				 error);
+		}
+		mp->m_sb.sb_rrmapino = ip->i_ino;
+		ip->i_df.if_broot_bytes = XFS_RTRMAP_BROOT_SPACE_CALC(0, 0);
+		ip->i_df.if_broot = kmem_alloc(ip->i_df.if_broot_bytes,
+				KM_SLEEP | KM_NOFS);
+	} else {
+		/* Grab the existing inode. */
+		error = -libxfs_trans_iget(mp, tp, mp->m_sb.sb_rrmapino,
+				0, 0, &ip);
+		if (error)
+			do_error(_("Could not iget realtime rmapbt inode -- error %d"),
+				error);
+	}
+
+	/* Reset the btree root. */
+	ip->i_d.di_size = 0;
+	ip->i_d.di_nblocks = 0;
+	ip->i_d.di_format = XFS_DINODE_FMT_RMAP;
+	block = ip->i_df.if_broot;
+	block->bb_numrecs = cpu_to_be16(0);
+	block->bb_level = cpu_to_be16(0);
+
+	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE | XFS_ILOG_DBROOT);
+	libxfs_log_sb(tp);
+	libxfs_trans_commit(tp);
+	IRELE(ip);
+}
+
 /*
  * makes a new root directory.
  */
@@ -3248,6 +3305,18 @@ phase6(xfs_mount_t *mp)
 		}
 	}
 
+	/*
+	 * We always reinitialize the rrmapbt inode, but if it was bad we
+	 * ought to say something.
+	 */
+	if (no_modify) {
+		if (need_rrmapino)
+			do_warn(_("would reinitialize realtime rmap btree\n"));
+	} else {
+		need_rrmapino = 0;
+		mk_rrmapino(mp);
+	}
+
 	if (!no_modify)  {
 		do_log(
 _("        - resetting contents of realtime bitmap and summary inodes\n"));
@@ -3260,6 +3329,10 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
 			do_warn(
 			_("Warning:  realtime bitmap may be inconsistent\n"));
 		}
+
+		if (rmap_populate_realtime_rmapbt(mp))
+			do_warn(
+			_("Warning:  realtime rmapbt may be inconsistent\n"));
 	}
 
 	mark_standalone_inodes(mp);
diff --git a/repair/rmap.c b/repair/rmap.c
index 9f9a47c..f5ab167 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1525,3 +1525,71 @@ rmap_store_agflcount(
 
 	rmap_for_ag(agno)->ar_flcount = count;
 }
+
+/* Store the realtime reverse-mappings in the rtrmapbt. */
+int
+rmap_populate_realtime_rmapbt(
+	struct xfs_mount	*mp)
+{
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
+	struct xfs_inode	fakei;
+	struct xfs_slab_cursor	*rmap_cur;
+	struct xfs_defer_ops	dfops;
+	xfs_fsblock_t		firstfsb;
+	struct xfs_rmap_irec	*rm_rec;
+	struct xfs_bmbt_irec	imap;
+	int			error;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb) || mp->m_sb.sb_rblocks == 0)
+		return 0;
+
+	error = rmap_init_cursor(NULLAGNUMBER, &rmap_cur);
+	if (error) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	error = -libxfs_iget(mp, NULL, mp->m_sb.sb_rrmapino, 0, &ip, 0);
+	if (error)
+		goto out_inode;
+
+	mp->m_rrmapip = ip;
+	fakei.i_d.di_flags = XFS_DIFLAG_REALTIME;
+	fakei.i_d.di_flags2 = 0;
+
+	libxfs_defer_init(&dfops, &firstfsb);
+	while ((rm_rec = pop_slab_cursor(rmap_cur))) {
+		imap.br_startoff = rm_rec->rm_offset;
+		imap.br_startblock = rm_rec->rm_startblock;
+		imap.br_blockcount = rm_rec->rm_blockcount;
+		imap.br_state = (rm_rec->rm_flags & XFS_RMAP_UNWRITTEN ?
+				XFS_EXT_UNWRITTEN : XFS_EXT_NORM);
+		fakei.i_ino = rm_rec->rm_owner;
+		error = -libxfs_rmap_map_extent(mp, &dfops, &fakei,
+				XFS_DATA_FORK, &imap);
+		if (error)
+			goto out_defer;
+	}
+
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
+	if (error)
+		goto out_defer;
+
+	error = -libxfs_defer_finish(&tp, &dfops, NULL);
+	if (error)
+		goto out_cancel;
+
+	error = -libxfs_trans_commit(tp);
+	goto out_inode;
+
+out_cancel:
+	libxfs_trans_cancel(tp);
+out_defer:
+	libxfs_defer_cancel(&dfops);
+out_inode:
+	mp->m_rrmapip = NULL;
+	IRELE(ip);
+out:
+	return error;
+}
diff --git a/repair/rmap.h b/repair/rmap.h
index 7069b6b..9fb6ba2 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -70,4 +70,6 @@ extern void rmap_store_agflcount(struct xfs_mount *, xfs_agnumber_t, int);
 	for ((agno) = NULLAGNUMBER; (agno) == NULLAGNUMBER || \
 	(agno) < (mp)->m_sb.sb_agcount; (agno)++)
 
+extern int rmap_populate_realtime_rmapbt(struct xfs_mount *mp);
+
 #endif /* RMAP_H_ */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 4d92b90..9a2f7c7 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -936,11 +936,14 @@ main(int argc, char **argv)
 	/*
 	 * Done with the block usage maps, toss them...
 	 */
-	rmaps_free(mp);
+	if (mp->m_sb.sb_rblocks == 0)
+		rmaps_free(mp);
 	free_bmaps(mp);
 
 	if (!bad_ino_btree)  {
 		phase6(mp);
+		if (mp->m_sb.sb_rblocks != 0)
+			rmaps_free(mp);
 		timestamp(PHASE_END, 6, NULL);
 
 		phase7(mp, phase2_threads);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
