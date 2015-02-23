Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7E84F7F67
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 09:51:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DEE52AC001
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 07:51:54 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lMDDfy357lpETyuc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 07:51:53 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1NFppBq025103
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 10:51:52 -0500
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1NFppvM006906
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 10:51:51 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 4/4] xfsprogs: consolidate superblock logging functions
Date: Mon, 23 Feb 2015 10:51:49 -0500
Message-Id: <1424706709-21594-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1424706709-21594-1-git-send-email-bfoster@redhat.com>
References: <1424706709-21594-1-git-send-email-bfoster@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a backport of the following kernel commit:

61e63ecb577f xfs: consolidate superblock logging functions

... which converts the xfs_mod_sb() function to xfs_log_sb(). The
xfs_sync_sb() function uses a transaction interface not available in
userspace. The former function is not required, so is dropped from the
patch.

Also update callers of xfs_mod_sb() in mkfs to use xfs_log_sb().

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/support/libxfs_api_defs.h |  2 +-
 libxfs/support/trans.c           |  2 +-
 libxfs/xfs_attr_leaf.c           |  2 +-
 libxfs/xfs_bmap.c                | 10 +++++-----
 libxfs/xfs_sb.c                  | 11 +++++------
 libxfs/xfs_sb.h                  |  3 ++-
 libxfs/xfs_shared.h              | 33 +++++++++++++++------------------
 libxfs/xfs_trans_resv.c          | 14 --------------
 libxfs/xfs_trans_resv.h          |  1 -
 mkfs/proto.c                     |  6 +++---
 10 files changed, 33 insertions(+), 51 deletions(-)

diff --git a/libxfs/support/libxfs_api_defs.h b/libxfs/support/libxfs_api_defs.h
index ebed749..4147df6 100644
--- a/libxfs/support/libxfs_api_defs.h
+++ b/libxfs/support/libxfs_api_defs.h
@@ -99,7 +99,7 @@
 #define xfs_idestroy_fork		libxfs_idestroy_fork
 #define xfs_dinode_verify		libxfs_dinode_verify
 
-#define xfs_mod_sb			libxfs_mod_sb
+#define xfs_log_sb			libxfs_log_sb
 #define xfs_mod_incore_sb		libxfs_mod_incore_sb
 #define xfs_sb_from_disk		libxfs_sb_from_disk
 #define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
diff --git a/libxfs/support/trans.c b/libxfs/support/trans.c
index bf13127..885c5f4 100644
--- a/libxfs/support/trans.c
+++ b/libxfs/support/trans.c
@@ -845,7 +845,7 @@ libxfs_trans_commit(
 			sbp->sb_fdblocks += tp->t_fdblocks_delta;
 		if (tp->t_frextents_delta)
 			sbp->sb_frextents += tp->t_frextents_delta;
-		xfs_mod_sb(tp);
+		xfs_log_sb(tp);
 	}
 
 #ifdef XACT_DEBUG
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 8d38a04..f3f70fb 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -399,7 +399,7 @@ xfs_sbversion_add_attr2(xfs_mount_t *mp, xfs_trans_t *tp)
 		if (!xfs_sb_version_hasattr2(&mp->m_sb)) {
 			xfs_sb_version_addattr2(&mp->m_sb);
 			spin_unlock(&mp->m_sb_lock);
-			xfs_mod_sb(tp);
+			xfs_log_sb(tp);
 		} else
 			spin_unlock(&mp->m_sb_lock);
 	}
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index cf500a6..09f0847 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1213,20 +1213,20 @@ xfs_bmap_add_attrfork(
 		goto bmap_cancel;
 	if (!xfs_sb_version_hasattr(&mp->m_sb) ||
 	   (!xfs_sb_version_hasattr2(&mp->m_sb) && version == 2)) {
-		bool mod_sb = false;
+		bool log_sb = false;
 
 		spin_lock(&mp->m_sb_lock);
 		if (!xfs_sb_version_hasattr(&mp->m_sb)) {
 			xfs_sb_version_addattr(&mp->m_sb);
-			mod_sb = true;
+			log_sb = true;
 		}
 		if (!xfs_sb_version_hasattr2(&mp->m_sb) && version == 2) {
 			xfs_sb_version_addattr2(&mp->m_sb);
-			mod_sb = true;
+			log_sb = true;
 		}
 		spin_unlock(&mp->m_sb_lock);
-		if (mod_sb)
-			xfs_mod_sb(tp);
+		if (log_sb)
+			xfs_log_sb(tp);
 	}
 
 	error = xfs_bmap_finish(&tp, &flist, &committed);
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 05f0c94..cbd47d7 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -736,14 +736,13 @@ xfs_initialize_perag_data(
 }
 
 /*
- * xfs_mod_sb() can be used to copy arbitrary changes to the
- * in-core superblock into the superblock buffer to be logged.
- * It does not provide the higher level of locking that is
- * needed to protect the in-core superblock from concurrent
- * access.
+ * xfs_log_sb() can be used to copy arbitrary changes to the in-core superblock
+ * into the superblock buffer to be logged.  It does not provide the higher
+ * level of locking that is needed to protect the in-core superblock from
+ * concurrent access.
  */
 void
-xfs_mod_sb(
+xfs_log_sb(
 	struct xfs_trans	*tp)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
diff --git a/libxfs/xfs_sb.h b/libxfs/xfs_sb.h
index e193caa..b25bb9a 100644
--- a/libxfs/xfs_sb.h
+++ b/libxfs/xfs_sb.h
@@ -28,7 +28,8 @@ extern void	xfs_perag_put(struct xfs_perag *pag);
 extern int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
 
 extern void	xfs_sb_calc_crc(struct xfs_buf *bp);
-extern void	xfs_mod_sb(struct xfs_trans *tp);
+extern void	xfs_log_sb(struct xfs_trans *tp);
+extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
 extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
 extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
 extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 82404da..8dda4b3 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -82,7 +82,7 @@ extern const struct xfs_buf_ops xfs_symlink_buf_ops;
 #define	XFS_TRANS_ATTR_RM		23
 #define	XFS_TRANS_ATTR_FLAG		24
 #define	XFS_TRANS_CLEAR_AGI_BUCKET	25
-#define XFS_TRANS_QM_SBCHANGE		26
+#define XFS_TRANS_SB_CHANGE		26
 /*
  * Dummy entries since we use the transaction type to index into the
  * trans_type[] in xlog_recover_print_trans_head()
@@ -95,17 +95,15 @@ extern const struct xfs_buf_ops xfs_symlink_buf_ops;
 #define XFS_TRANS_QM_DQCLUSTER		32
 #define XFS_TRANS_QM_QINOCREATE		33
 #define XFS_TRANS_QM_QUOTAOFF_END	34
-#define XFS_TRANS_SB_UNIT		35
-#define XFS_TRANS_FSYNC_TS		36
-#define	XFS_TRANS_GROWFSRT_ALLOC	37
-#define	XFS_TRANS_GROWFSRT_ZERO		38
-#define	XFS_TRANS_GROWFSRT_FREE		39
-#define	XFS_TRANS_SWAPEXT		40
-#define	XFS_TRANS_SB_COUNT		41
-#define	XFS_TRANS_CHECKPOINT		42
-#define	XFS_TRANS_ICREATE		43
-#define	XFS_TRANS_CREATE_TMPFILE	44
-#define	XFS_TRANS_TYPE_MAX		44
+#define XFS_TRANS_FSYNC_TS		35
+#define	XFS_TRANS_GROWFSRT_ALLOC	36
+#define	XFS_TRANS_GROWFSRT_ZERO		37
+#define	XFS_TRANS_GROWFSRT_FREE		38
+#define	XFS_TRANS_SWAPEXT		39
+#define	XFS_TRANS_CHECKPOINT		40
+#define	XFS_TRANS_ICREATE		41
+#define	XFS_TRANS_CREATE_TMPFILE	42
+#define	XFS_TRANS_TYPE_MAX		43
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
 #define XFS_TRANS_TYPES \
@@ -113,7 +111,6 @@ extern const struct xfs_buf_ops xfs_symlink_buf_ops;
 	{ XFS_TRANS_SETATTR_SIZE,	"SETATTR_SIZE" }, \
 	{ XFS_TRANS_INACTIVE,		"INACTIVE" }, \
 	{ XFS_TRANS_CREATE,		"CREATE" }, \
-	{ XFS_TRANS_CREATE_TMPFILE,	"CREATE_TMPFILE" }, \
 	{ XFS_TRANS_CREATE_TRUNC,	"CREATE_TRUNC" }, \
 	{ XFS_TRANS_TRUNCATE_FILE,	"TRUNCATE_FILE" }, \
 	{ XFS_TRANS_REMOVE,		"REMOVE" }, \
@@ -134,23 +131,23 @@ extern const struct xfs_buf_ops xfs_symlink_buf_ops;
 	{ XFS_TRANS_ATTR_RM,		"ATTR_RM" }, \
 	{ XFS_TRANS_ATTR_FLAG,		"ATTR_FLAG" }, \
 	{ XFS_TRANS_CLEAR_AGI_BUCKET,	"CLEAR_AGI_BUCKET" }, \
-	{ XFS_TRANS_QM_SBCHANGE,	"QM_SBCHANGE" }, \
+	{ XFS_TRANS_SB_CHANGE,		"SBCHANGE" }, \
+	{ XFS_TRANS_DUMMY1,		"DUMMY1" }, \
+	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
 	{ XFS_TRANS_QM_QUOTAOFF,	"QM_QUOTAOFF" }, \
 	{ XFS_TRANS_QM_DQALLOC,		"QM_DQALLOC" }, \
 	{ XFS_TRANS_QM_SETQLIM,		"QM_SETQLIM" }, \
 	{ XFS_TRANS_QM_DQCLUSTER,	"QM_DQCLUSTER" }, \
 	{ XFS_TRANS_QM_QINOCREATE,	"QM_QINOCREATE" }, \
 	{ XFS_TRANS_QM_QUOTAOFF_END,	"QM_QOFF_END" }, \
-	{ XFS_TRANS_SB_UNIT,		"SB_UNIT" }, \
 	{ XFS_TRANS_FSYNC_TS,		"FSYNC_TS" }, \
 	{ XFS_TRANS_GROWFSRT_ALLOC,	"GROWFSRT_ALLOC" }, \
 	{ XFS_TRANS_GROWFSRT_ZERO,	"GROWFSRT_ZERO" }, \
 	{ XFS_TRANS_GROWFSRT_FREE,	"GROWFSRT_FREE" }, \
 	{ XFS_TRANS_SWAPEXT,		"SWAPEXT" }, \
-	{ XFS_TRANS_SB_COUNT,		"SB_COUNT" }, \
 	{ XFS_TRANS_CHECKPOINT,		"CHECKPOINT" }, \
-	{ XFS_TRANS_DUMMY1,		"DUMMY1" }, \
-	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
+	{ XFS_TRANS_ICREATE,		"ICREATE" }, \
+	{ XFS_TRANS_CREATE_TMPFILE,	"CREATE_TMPFILE" }, \
 	{ XLOG_UNMOUNT_REC_TYPE,	"UNMOUNT" }
 
 /*
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index d81ce08..0c40b52 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -715,17 +715,6 @@ xfs_calc_clear_agi_bucket_reservation(
 }
 
 /*
- * Clearing the quotaflags in the superblock.
- *	the super block for changing quota flags: sector size
- */
-STATIC uint
-xfs_calc_qm_sbchange_reservation(
-	struct xfs_mount	*mp)
-{
-	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
-}
-
-/*
  * Adjusting quota limits.
  *    the xfs_disk_dquot_t: sizeof(struct xfs_disk_dquot)
  */
@@ -863,9 +852,6 @@ xfs_trans_resv_calc(
 	 * The following transactions are logged in logical format with
 	 * a default log count.
 	 */
-	resp->tr_qm_sbchange.tr_logres = xfs_calc_qm_sbchange_reservation(mp);
-	resp->tr_qm_sbchange.tr_logcount = XFS_DEFAULT_LOG_COUNT;
-
 	resp->tr_qm_setqlim.tr_logres = xfs_calc_qm_setqlim_reservation(mp);
 	resp->tr_qm_setqlim.tr_logcount = XFS_DEFAULT_LOG_COUNT;
 
diff --git a/libxfs/xfs_trans_resv.h b/libxfs/xfs_trans_resv.h
index 1097d14..2d5bdfc 100644
--- a/libxfs/xfs_trans_resv.h
+++ b/libxfs/xfs_trans_resv.h
@@ -56,7 +56,6 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_growrtalloc;	/* grow realtime allocations */
 	struct xfs_trans_res	tr_growrtzero;	/* grow realtime zeroing */
 	struct xfs_trans_res	tr_growrtfree;	/* grow realtime freeing */
-	struct xfs_trans_res	tr_qm_sbchange;	/* change quota flags */
 	struct xfs_trans_res	tr_qm_setqlim;	/* adjust quota limits */
 	struct xfs_trans_res	tr_qm_dqalloc;	/* allocate quota on disk */
 	struct xfs_trans_res	tr_qm_quotaoff;	/* turn quota off */
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 18a2553..45565b7 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -551,7 +551,7 @@ parseproto(
 		if (!pip) {
 			pip = ip;
 			mp->m_sb.sb_rootino = ip->i_ino;
-			libxfs_mod_sb(tp);
+			libxfs_log_sb(tp);
 			isroot = 1;
 		} else {
 			libxfs_trans_ijoin(tp, pip, 0);
@@ -657,7 +657,7 @@ rtinit(
 	rbmip->i_d.di_flags = XFS_DIFLAG_NEWRTBM;
 	*(__uint64_t *)&rbmip->i_d.di_atime = 0;
 	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
-	libxfs_mod_sb(tp);
+	libxfs_log_sb(tp);
 	mp->m_rbmip = rbmip;
 	error = -libxfs_inode_alloc(&tp, NULL, S_IFREG, 1, 0,
 					&creds, &fsxattrs, &rsumip);
@@ -667,7 +667,7 @@ rtinit(
 	mp->m_sb.sb_rsumino = rsumip->i_ino;
 	rsumip->i_d.di_size = mp->m_rsumsize;
 	libxfs_trans_log_inode(tp, rsumip, XFS_ILOG_CORE);
-	libxfs_mod_sb(tp);
+	libxfs_log_sb(tp);
 	libxfs_trans_commit(tp, 0);
 	mp->m_rsumip = rsumip;
 	/*
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
