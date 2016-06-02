Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E0F847CA3
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 09:19:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5CBB1AC001
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 07:19:27 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id mjRFfqmN0CRFBP0V (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 02 Jun 2016 07:19:24 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] xfs: add an option to enable reflinks at mount time
Date: Thu,  2 Jun 2016 16:19:10 +0200
Message-Id: <1464877150-20457-4-git-send-email-hch@lst.de>
In-Reply-To: <1464877150-20457-1-git-send-email-hch@lst.de>
References: <1464877150-20457-1-git-send-email-hch@lst.de>
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
To: darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

If the reflink mount option is specified we'll add the reflink btree root
block to each AG late in the mount process and can then use the reflink
tree.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_refcount_btree.c | 83 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_refcount_btree.h |  2 +
 fs/xfs/libxfs/xfs_trans_resv.c     | 23 +++++++++++
 fs/xfs/libxfs/xfs_trans_resv.h     |  1 +
 fs/xfs/xfs_mount.c                 | 24 +++++++++--
 fs/xfs/xfs_mount.h                 |  5 ++-
 fs/xfs/xfs_super.c                 |  7 +++-
 7 files changed, 139 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 7ae3ad7..aaea8da 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -484,3 +484,86 @@ xfs_refcountbt_calc_reserves(
 
 	return error;
 }
+
+static int
+xfs_reflink_ag_add(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_perag	*pag;
+	struct xfs_buf		*bp, *agbp;
+	struct xfs_agf		*agf;
+	__be32			bno;
+	int			stat, error;
+
+	error = __xfs_refcountbt_alloc_block(tp, agno, XFS_AG_RESV_NONE,
+			&bno, &stat);
+	if (error)
+		return error;
+
+	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp,
+			XFS_AGB_TO_DADDR(mp, agno, be32_to_cpu(bno)),
+			mp->m_bsize, 0);
+	if (!bp)
+		return -ENOMEM;
+
+	bp->b_ops = &xfs_refcountbt_buf_ops;
+	xfs_btree_init_block(mp, bp, XFS_REFC_CRC_MAGIC, 0, 0, agno,
+		XFS_BTREE_CRC_BLOCKS);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_BTREE_BUF);
+	xfs_trans_log_buf(tp, bp, 0, XFS_BTREE_SBLOCK_CRC_LEN - 1);
+
+	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+	if (error)
+		return error;
+
+	agf = XFS_BUF_TO_AGF(agbp);
+	agf->agf_refcount_root = bno;
+	agf->agf_refcount_level = cpu_to_be32(1);
+
+	pag = xfs_perag_get(mp, agno);
+	pag->pagf_refcount_level = 1;
+	xfs_perag_put(pag);
+
+	xfs_alloc_log_agf(tp, agbp,
+			XFS_AGF_REFCOUNT_ROOT | XFS_AGF_REFCOUNT_LEVEL);
+	return 0;
+}
+
+int
+xfs_reflink_add(
+	struct xfs_mount	*mp)
+{
+	struct xfs_trans	*tp = NULL;
+	int			error, i;
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
+	tp->t_flags |= XFS_TRANS_RESERVE;
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_add_reflink,
+			mp->m_sb.sb_agcount, 0);
+	if (error)
+		goto out_trans_cancel;
+
+	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+		xfs_log_sb(tp);
+
+		error = xfs_reflink_ag_add(tp, i);
+		if (error)
+			goto out_trans_cancel;
+
+		error = xfs_trans_roll(&tp, NULL);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	mp->m_sb.sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
+	xfs_log_sb(tp);
+
+	return xfs_trans_commit(tp);
+
+out_trans_cancel:
+	if (tp)
+		xfs_trans_cancel(tp);
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
index 6f4bf70..481e0d0 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.h
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -70,4 +70,6 @@ extern xfs_extlen_t xfs_refcountbt_max_size(struct xfs_mount *mp);
 extern int xfs_refcountbt_calc_reserves(struct xfs_mount *mp,
 		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
 
+extern int xfs_reflink_add(struct xfs_mount *mp);
+
 #endif	/* __XFS_REFCOUNT_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index d53fe89..346c0c1 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -802,6 +802,25 @@ xfs_calc_sb_reservation(
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 }
 
+/*
+ * For adding the reflinking we need to allocate the new root block
+ * and modify the AGF and SB, giving:
+ *    the AGF: sectorsize
+ *    the superblock for the reflink flag: sector size
+ *    the reflink root block itself: sector size
+ *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ */
+STATIC uint
+xfs_calc_add_reflink_resv_alloc(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		mp->m_sb.sb_sectsize +
+		mp->m_sb.sb_sectsize +
+		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
+				 XFS_FSB_TO_B(mp, 1));
+}
+
 void
 xfs_trans_resv_calc(
 	struct xfs_mount	*mp,
@@ -885,6 +904,10 @@ xfs_trans_resv_calc(
 		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	resp->tr_add_reflink.tr_logres = xfs_calc_add_reflink_resv_alloc(mp);
+	resp->tr_add_reflink.tr_logcount = XFS_DEFAULT_LOG_COUNT;
+	resp->tr_add_reflink.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+
 	/*
 	 * The following transactions are logged in logical format with
 	 * a default log count.
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index cf734cf..1c007da 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -60,6 +60,7 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_qm_dqalloc;	/* allocate quota on disk */
 	struct xfs_trans_res	tr_qm_quotaoff;	/* turn quota off */
 	struct xfs_trans_res	tr_qm_equotaoff;/* end of turn quota off */
+	struct xfs_trans_res	tr_add_reflink; /* add reflink */
 	struct xfs_trans_res	tr_sb;		/* modify superblock */
 	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
 };
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 792f547..6e4cebf 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -962,11 +962,27 @@ xfs_mountfs(
 
 		xfs_fs_reserve_ag_blocks(mp);
 
-		/* Recover any CoW blocks that never got remapped. */
-		error = xfs_reflink_recover_cow(mp);
-		if (error && !XFS_FORCED_SHUTDOWN(mp))
-			xfs_err(mp,
+		if (!xfs_sb_version_hasreflink(&mp->m_sb) &&
+		    (mp->m_flags & XFS_MOUNT_REFLINK)) {
+			if (XFS_SB_VERSION_NUM(&mp->m_sb) < XFS_SB_VERSION_5) {
+				xfs_warn(mp,
+	"Can't enable reflinks on version %d superblock.",
+					XFS_SB_VERSION_NUM(&mp->m_sb));
+				return -EINVAL;
+			}
+
+			error = xfs_reflink_add(mp);
+			if (error) {
+				xfs_err(mp,
+	"Failed to enable reflinks: %d\n", error);
+			}
+		} else {
+			/* Recover any CoW blocks that never got remapped. */
+			error = xfs_reflink_recover_cow(mp);
+			if (error && !XFS_FORCED_SHUTDOWN(mp))
+				xfs_err(mp,
 	"Error %d recovering leftover CoW allocations.", error);
+		}
 	}
 
 	return 0;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index c2e1294..e3002cb 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -178,6 +178,8 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_WSYNC		(1ULL << 0)	/* for nfs - all metadata ops
 						   must be synchronous except
 						   for space allocations */
+#define XFS_MOUNT_REFLINK	(1ULL << 1)	/* allow use of reflinks (will
+						   be permanent once used) */
 #define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
 						   operations, typically for
@@ -229,7 +231,8 @@ typedef struct xfs_mount {
 
 static inline bool xfs_mp_hasreflink(struct xfs_mount *mp)
 {
-	return xfs_sb_version_hasreflink(&mp->m_sb);
+	return xfs_sb_version_hasreflink(&mp->m_sb) ||
+		(mp->m_flags & XFS_MOUNT_REFLINK);
 }
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 84348af..dfa5077 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -82,7 +82,7 @@ enum {
 	Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota, Opt_prjquota,
 	Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
-	Opt_discard, Opt_nodiscard, Opt_dax, Opt_err,
+	Opt_discard, Opt_nodiscard, Opt_reflink, Opt_dax, Opt_err,
 };
 
 static const match_table_t tokens = {
@@ -132,6 +132,7 @@ static const match_table_t tokens = {
 	{Opt_qnoenforce, "qnoenforce"},	/* same as uqnoenforce */
 	{Opt_discard,	"discard"},	/* Discard unused blocks */
 	{Opt_nodiscard,	"nodiscard"},	/* Do not discard unused blocks */
+	{Opt_reflink,	"reflink"},	/* Do not discard unused blocks */
 
 	{Opt_dax,	"dax"},		/* Enable direct access to bdev pages */
 	{Opt_err,	NULL},
@@ -219,6 +220,7 @@ xfs_parseargs(
 	 */
 	mp->m_flags |= XFS_MOUNT_BARRIER;
 	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
+	mp->m_flags |= XFS_MOUNT_REFLINK;
 
 	/*
 	 * These can be overridden by the mount option parsing.
@@ -368,6 +370,9 @@ xfs_parseargs(
 		case Opt_nodiscard:
 			mp->m_flags &= ~XFS_MOUNT_DISCARD;
 			break;
+		case Opt_reflink:
+			mp->m_flags |= XFS_MOUNT_REFLINK;
+			break;
 #ifdef CONFIG_FS_DAX
 		case Opt_dax:
 			mp->m_flags |= XFS_MOUNT_DAX;
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
