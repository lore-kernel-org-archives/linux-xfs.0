Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 75B937FE1
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:37:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DAF09AC005
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:37:19 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	mVCYZFKHxHr2d8a1 for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:37:16 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB4z-0003DL-3d
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:37:13 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB4y-0000HK-VV
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:37:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 48/50] xfs: refactor xfs_trans_reserve() interface
Date: Wed, 19 Jun 2013 15:36:11 +1000
Message-Id: <1371620173-712-49-git-send-email-david@fromorbit.com>
In-Reply-To: <1371620173-712-1-git-send-email-david@fromorbit.com>
References: <1371620173-712-1-git-send-email-david@fromorbit.com>
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

From: Jie Liu <jeff.liu@oracle.com>

With the new xfs_trans_res structure has been introduced, the log
reservation size, log count as well as log flags are pre-initialized
at mount time.  So it's time to refine xfs_trans_reserve() interface
to be more neat.

Also, introduce a new helper M_RES() to return a pointer to the
mp->m_resv structure to simplify the input.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/libxfs.h         |    3 +-
 include/xfs_trans_resv.h |    3 ++
 libxfs/trans.c           |   20 +++++------
 libxfs/util.c            |   15 +++++---
 libxfs/xfs_attr.c        |   33 +++++++++--------
 libxfs/xfs_bmap.c        |    4 +--
 libxfs/xfs_trans_resv.c  |    7 ++--
 mkfs/proto.c             |   24 ++++++++-----
 mkfs/xfs_mkfs.c          |    5 ++-
 repair/phase5.c          |    3 +-
 repair/phase6.c          |   89 ++++++++++++++++++++++------------------------
 repair/phase7.c          |    7 ++--
 12 files changed, 115 insertions(+), 98 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index d1e3bf1..4a3dbb8 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -511,7 +511,8 @@ typedef struct xfs_trans {
 
 extern xfs_trans_t	*libxfs_trans_alloc (xfs_mount_t *, int);
 extern xfs_trans_t	*libxfs_trans_dup (xfs_trans_t *);
-extern int	libxfs_trans_reserve (xfs_trans_t *, uint,uint,uint,uint,uint);
+extern int	libxfs_trans_reserve(struct xfs_trans *, struct xfs_trans_res *,
+				     uint, uint);
 extern int	libxfs_trans_commit (xfs_trans_t *, uint);
 extern void	libxfs_trans_cancel (xfs_trans_t *, int);
 extern xfs_buf_t	*libxfs_trans_getsb (xfs_trans_t *, xfs_mount_t *, int);
diff --git a/include/xfs_trans_resv.h b/include/xfs_trans_resv.h
index 27b64c5..e62a804 100644
--- a/include/xfs_trans_resv.h
+++ b/include/xfs_trans_resv.h
@@ -63,6 +63,9 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
 };
 
+/* shorthand way of accessing reservation structure */
+#define M_RES(mp)	(&(mp)->m_resv)
+
 /*
  * Per-extent log reservation for the allocation btree changes
  * involved in freeing or allocating an extent.
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 7b75316..3111d18 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -91,7 +91,7 @@ libxfs_trans_roll(
 	struct xfs_inode	*dp)
 {
 	struct xfs_trans	*trans;
-	unsigned int		logres, count;
+	struct xfs_trans_res	tres;
 	int			error;
 
 	/*
@@ -103,8 +103,8 @@ libxfs_trans_roll(
 	/*
 	 * Copy the critical parameters from one trans to the next.
 	 */
-	logres = trans->t_log_res;
-	count = trans->t_log_count;
+	tres.tr_logres = trans->t_log_res;
+	tres.tr_logcount = trans->t_log_count;
 	*tpp = xfs_trans_dup(trans);
 
 	/*
@@ -128,8 +128,8 @@ libxfs_trans_roll(
 	 * across this call, or that anything that is locked be logged in
 	 * the prior and the next transactions.
 	 */
-	error = xfs_trans_reserve(trans, 0, logres, 0,
-				  XFS_TRANS_PERM_LOG_RES, count);
+	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+	error = xfs_trans_reserve(trans, &tres, 0, 0);
 	/*
 	 *  Ensure that the inode is in the new transaction and locked.
 	 */
@@ -176,12 +176,10 @@ libxfs_trans_dup(
 
 int
 libxfs_trans_reserve(
-	xfs_trans_t	*tp,
-	uint		blocks,
-	uint		logspace,
-	uint		rtextents,
-	uint		flags,
-	uint		logcount)
+	struct xfs_trans	*tp,
+	struct xfs_trans_res	*resp,
+	uint			blocks,
+	uint			rtextents)
 {
 	xfs_sb_t	*mpsb = &tp->t_mountp->m_sb;
 
diff --git a/libxfs/util.c b/libxfs/util.c
index 1d3113a..d7459e0 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -473,7 +473,8 @@ libxfs_alloc_file_space(
 
 		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
 		resblks = (uint)XFS_DIOSTRAT_SPACE_RES(mp, datablocks);
-		error = xfs_trans_reserve(tp, resblks, 0, 0, 0, 0);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
+					  resblks, 0);
 		if (error)
 			break;
 		xfs_trans_ijoin(tp, ip, 0);
@@ -536,7 +537,6 @@ libxfs_inode_alloc(
 	struct fsxattr	*fsx,
 	xfs_inode_t	**ipp)
 {
-	int		i;
 	xfs_buf_t	*ialloc_context;
 	xfs_inode_t	*ip;
 	xfs_trans_t	*ntp;
@@ -555,13 +555,20 @@ libxfs_inode_alloc(
 	}
 
 	if (ialloc_context) {
+		struct xfs_trans_res	tres;
+
 		xfs_trans_bhold(*tp, ialloc_context);
+		tres.tr_logres = (*tp)->t_log_res;
+		tres.tr_logcount = (*tp)->t_log_count;
+
 		ntp = xfs_trans_dup(*tp);
 		xfs_trans_commit(*tp, 0);
 		*tp = ntp;
-		if ((i = xfs_trans_reserve(*tp, 0, 0, 0, 0, 0))) {
+		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+		error = xfs_trans_reserve(*tp, &tres, 0, 0);
+		if (error) {
 			fprintf(stderr, _("%s: cannot reserve space: %s\n"),
-				progname, strerror(i));
+				progname, strerror(error));
 			exit(1);
 		}
 		xfs_trans_bjoin(*tp, ialloc_context);
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 8fe892e..f554e60 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -202,13 +202,14 @@ xfs_attr_set_int(
 	int		valuelen,
 	int		flags)
 {
-	xfs_da_args_t	args;
-	xfs_fsblock_t	firstblock;
-	xfs_bmap_free_t flist;
-	int		error, err2, committed;
-	xfs_mount_t	*mp = dp->i_mount;
-	int             rsvd = (flags & ATTR_ROOT) != 0;
-	int		local;
+	xfs_da_args_t		args;
+	xfs_fsblock_t		firstblock;
+	xfs_bmap_free_t		flist;
+	int			error, err2, committed;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_trans_res	tres;
+	int			rsvd = (flags & ATTR_ROOT) != 0;
+	int			local;
 
 	/*
 	 * Attach the dquots to the inode.
@@ -268,11 +269,11 @@ xfs_attr_set_int(
 	if (rsvd)
 		args.trans->t_flags |= XFS_TRANS_RESERVE;
 
-	error = xfs_trans_reserve(args.trans, args.total,
-				  XFS_ATTRSETM_LOG_RES(mp) +
-				  XFS_ATTRSETRT_LOG_RES(mp) * args.total,
-				  0, XFS_TRANS_PERM_LOG_RES,
-				  XFS_ATTRSET_LOG_COUNT);
+	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
+			 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
+	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
+	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+	error = xfs_trans_reserve(args.trans, &tres, args.total, 0);
 	if (error) {
 		xfs_trans_cancel(args.trans, 0);
 		return(error);
@@ -492,11 +493,9 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 	if (flags & ATTR_ROOT)
 		args.trans->t_flags |= XFS_TRANS_RESERVE;
 
-	if ((error = xfs_trans_reserve(args.trans,
-				      XFS_ATTRRM_SPACE_RES(mp),
-				      XFS_ATTRRM_LOG_RES(mp),
-				      0, XFS_TRANS_PERM_LOG_RES,
-				      XFS_ATTRRM_LOG_COUNT))) {
+	error = xfs_trans_reserve(args.trans, &M_RES(mp)->tr_attrrm,
+				  XFS_ATTRRM_SPACE_RES(mp), 0);
+	if (error) {
 		xfs_trans_cancel(args.trans, 0);
 		return(error);
 	}
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index eeaea94..2d480cc 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1113,8 +1113,8 @@ xfs_bmap_add_attrfork(
 	blks = XFS_ADDAFORK_SPACE_RES(mp);
 	if (rsvd)
 		tp->t_flags |= XFS_TRANS_RESERVE;
-	if ((error = xfs_trans_reserve(tp, blks, XFS_ADDAFORK_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_ADDAFORK_LOG_COUNT)))
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_addafork, blks, 0);
+	if (error)
 		goto error0;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 36aeafe..d134136 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -522,7 +522,8 @@ xfs_calc_attrsetm_reservation(
  * Since the runtime attribute transaction space is dependent on the total
  * blocks needed for the 1st bmap, here we calculate out the space unit for
  * one block so that the caller could figure out the total space according
- * to the attibute extent length in blocks by: ext * XFS_ATTRSETRT_LOG_RES(mp).
+ * to the attibute extent length in blocks by:
+ *	ext * M_RES(mp)->tr_attrsetrt.tr_logres
  */
 STATIC uint
 xfs_calc_attrsetrt_reservation(
@@ -594,14 +595,14 @@ xfs_calc_qm_setqlim_reservation(
 
 /*
  * Allocating quota on disk if needed.
- *	the write transaction log space: XFS_WRITE_LOG_RES(mp)
+ *	the write transaction log space: M_RES(mp)->tr_write.tr_logres
  *	the unit of quota allocation: one system block size
  */
 STATIC uint
 xfs_calc_qm_dqalloc_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_WRITE_LOG_RES(mp) +
+	return M_RES(mp)->tr_write.tr_logres +
 		xfs_calc_buf_res(1,
 			XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) - 1);
 }
diff --git a/mkfs/proto.c b/mkfs/proto.c
index ee84699..e33d238 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -119,7 +119,9 @@ getres(
 
 	mp = tp->t_mountp;
 	for (i = 0, r = MKFS_BLOCKRES(blocks); r >= blocks; r--) {
-		i = libxfs_trans_reserve(tp, r, 0, 0, 0, 0);
+		struct xfs_trans_res    tres = {0};
+
+		i = libxfs_trans_reserve(tp, &tres, r, 0);
 		if (i == 0)
 			return;
 	}
@@ -615,13 +617,16 @@ rtinit(
 	xfs_trans_t	*tp;
 	struct cred	creds;
 	struct fsxattr	fsxattrs;
+	struct xfs_trans_res tres = {0};
 
 	/*
 	 * First, allocate the inodes.
 	 */
 	tp = libxfs_trans_alloc(mp, 0);
-	if ((i = libxfs_trans_reserve(tp, MKFS_BLOCKRES_INODE, 0, 0, 0, 0)))
+	i = libxfs_trans_reserve(tp, &tres, MKFS_BLOCKRES_INODE, 0);
+	if (i)
 		res_failed(i);
+
 	memset(&creds, 0, sizeof(creds));
 	memset(&fsxattrs, 0, sizeof(fsxattrs));
 	error = libxfs_inode_alloc(&tp, NULL, S_IFREG, 1, 0,
@@ -658,9 +663,11 @@ rtinit(
 	 * Next, give the bitmap file some zero-filled blocks.
 	 */
 	tp = libxfs_trans_alloc(mp, 0);
-	if ((i = libxfs_trans_reserve(tp, mp->m_sb.sb_rbmblocks +
-			(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1), 0, 0, 0, 0)))
+	i = libxfs_trans_reserve(tp, &tres, mp->m_sb.sb_rbmblocks +
+				 (XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1), 0);
+	if (i)
 		res_failed(i);
+
 	libxfs_trans_ijoin(tp, rbmip, 0);
 	libxfs_trans_ihold(tp, rbmip);
 	bno = 0;
@@ -694,9 +701,9 @@ rtinit(
 	 */
 	tp = libxfs_trans_alloc(mp, 0);
 	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
-	if ((i = libxfs_trans_reserve(tp,
-			nsumblocks + (XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1),
-			0, 0, 0, 0)))
+	i = libxfs_trans_reserve(tp, &tres, nsumblocks +
+				 (XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1), 0);
+	if (i)
 		res_failed(i);
 	libxfs_trans_ijoin(tp, rsumip, 0);
 	libxfs_trans_ihold(tp, rsumip);
@@ -731,7 +738,8 @@ rtinit(
 	 */
 	for (bno = 0; bno < mp->m_sb.sb_rextents; bno = ebno) {
 		tp = libxfs_trans_alloc(mp, 0);
-		if ((i = libxfs_trans_reserve(tp, 0, 0, 0, 0, 0)))
+		i = libxfs_trans_reserve(tp, &tres, 0, 0);
+		if (i)
 			res_failed(i);
 		libxfs_trans_ijoin(tp, rbmip, 0);
 		libxfs_trans_ihold(tp, rbmip);
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index bb5d8d4..a940150 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2821,6 +2821,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	for (agno = 0; agno < agcount; agno++) {
 		xfs_alloc_arg_t	args;
 		xfs_trans_t	*tp;
+		struct xfs_trans_res tres = {0};
 
 		memset(&args, 0, sizeof(args));
 		args.tp = tp = libxfs_trans_alloc(mp, 0);
@@ -2828,8 +2829,10 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		args.agno = agno;
 		args.alignment = 1;
 		args.pag = xfs_perag_get(mp,agno);
-		if ((c = libxfs_trans_reserve(tp, worst_freelist, 0, 0, 0, 0)))
+		c = libxfs_trans_reserve(tp, &tres, worst_freelist, 0);
+		if (c)
 			res_failed(c);
+
 		libxfs_alloc_fix_freelist(&args, 0);
 		xfs_perag_put(args.pag);
 		libxfs_trans_commit(tp, 0);
diff --git a/repair/phase5.c b/repair/phase5.c
index 2eae42a..27bb47e 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1405,6 +1405,7 @@ build_agf_agfl(xfs_mount_t	*mp,
 	{
 		xfs_alloc_arg_t	args;
 		xfs_trans_t	*tp;
+		struct xfs_trans_res tres = {0};
 
 		memset(&args, 0, sizeof(args));
 		args.tp = tp = libxfs_trans_alloc(mp, 0);
@@ -1412,7 +1413,7 @@ build_agf_agfl(xfs_mount_t	*mp,
 		args.agno = agno;
 		args.alignment = 1;
 		args.pag = xfs_perag_get(mp,agno);
-		libxfs_trans_reserve(tp, XFS_MIN_FREELIST(agf, mp), 0, 0, 0, 0);
+		libxfs_trans_reserve(tp, &tres, XFS_MIN_FREELIST(agf, mp), 0);
 		libxfs_alloc_fix_freelist(&args, 0);
 		xfs_perag_put(args.pag);
 		libxfs_trans_commit(tp, 0);
diff --git a/repair/phase6.c b/repair/phase6.c
index 2905a1c..df9b92e 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -429,13 +429,15 @@ mk_rbmino(xfs_mount_t *mp)
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
 	int		vers;
 	int		times;
+	struct xfs_trans_res tres = {0};
 
 	/*
 	 * first set up inode
 	 */
 	tp = libxfs_trans_alloc(mp, 0);
 
-	if ((i = libxfs_trans_reserve(tp, 10, 0, 0, 0, 0)))
+	i = libxfs_trans_reserve(tp, &tres, 10, 0);
+	if (i)
 		res_failed(i);
 
 	error = libxfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0, 0, &ip);
@@ -490,8 +492,9 @@ mk_rbmino(xfs_mount_t *mp)
 	 * from mkfs)
 	 */
 	tp = libxfs_trans_alloc(mp, 0);
-	if ((error = libxfs_trans_reserve(tp, mp->m_sb.sb_rbmblocks +
-			(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1), 0, 0, 0, 0)))
+	error = libxfs_trans_reserve(tp, &tres, mp->m_sb.sb_rbmblocks +
+				(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1), 0);
+	if (error)
 		res_failed(error);
 
 	libxfs_trans_ijoin(tp, ip, 0);
@@ -536,13 +539,15 @@ fill_rbmino(xfs_mount_t *mp)
 	int		error;
 	xfs_dfiloff_t	bno;
 	xfs_bmbt_irec_t	map;
+	struct xfs_trans_res tres = {0};
 
 	bmp = btmcompute;
 	bno = 0;
 
 	tp = libxfs_trans_alloc(mp, 0);
 
-	if ((error = libxfs_trans_reserve(tp, 10, 0, 0, 0, 0)))
+	error = libxfs_trans_reserve(tp, &tres, 10, 0);
+	if (error)
 		res_failed(error);
 
 	error = libxfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0, 0, &ip);
@@ -604,6 +609,7 @@ fill_rsumino(xfs_mount_t *mp)
 	xfs_dfiloff_t	bno;
 	xfs_dfiloff_t	end_bno;
 	xfs_bmbt_irec_t	map;
+	struct xfs_trans_res tres = {0};
 
 	smp = sumcompute;
 	bno = 0;
@@ -611,7 +617,8 @@ fill_rsumino(xfs_mount_t *mp)
 
 	tp = libxfs_trans_alloc(mp, 0);
 
-	if ((error = libxfs_trans_reserve(tp, 10, 0, 0, 0, 0)))
+	error = libxfs_trans_reserve(tp, &tres, 10, 0);
+	if (error)
 		res_failed(error);
 
 	error = libxfs_trans_iget(mp, tp, mp->m_sb.sb_rsumino, 0, 0, &ip);
@@ -677,14 +684,15 @@ mk_rsumino(xfs_mount_t *mp)
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
 	int		vers;
 	int		times;
+	struct xfs_trans_res tres = {0};
 
 	/*
 	 * first set up inode
 	 */
 	tp = libxfs_trans_alloc(mp, 0);
 
-	if ((i = libxfs_trans_reserve(tp, 10, XFS_ICHANGE_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES, XFS_MKDIR_LOG_COUNT)))
+	i = libxfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 10, 0);
+	if (i)
 		res_failed(i);
 
 	error = libxfs_trans_iget(mp, tp, mp->m_sb.sb_rsumino, 0, 0, &ip);
@@ -742,11 +750,12 @@ mk_rsumino(xfs_mount_t *mp)
 	xfs_bmap_init(&flist, &first);
 
 	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
-	if ((error = libxfs_trans_reserve(tp,
-				  mp->m_sb.sb_rbmblocks +
-				      (XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1),
-				  BBTOB(128), 0, XFS_TRANS_PERM_LOG_RES,
-				  XFS_DEFAULT_PERM_LOG_COUNT)))
+	tres.tr_logres = BBTOB(128);
+	tres.tr_logcount = XFS_DEFAULT_PERM_LOG_COUNT;
+	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+	error = libxfs_trans_reserve(tp, &tres, mp->m_sb.sb_rbmblocks +
+			      (XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1), 0);
+	if (error)
 		res_failed(error);
 
 	libxfs_trans_ijoin(tp, ip, 0);
@@ -798,8 +807,8 @@ mk_root_dir(xfs_mount_t *mp)
 	tp = libxfs_trans_alloc(mp, 0);
 	ip = NULL;
 
-	if ((i = libxfs_trans_reserve(tp, 10, XFS_ICHANGE_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES, XFS_MKDIR_LOG_COUNT)))
+	i = libxfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 10, 0);
+	if (i)
 		res_failed(i);
 
 	error = libxfs_trans_iget(mp, tp, mp->m_sb.sb_rootino, 0, 0, &ip);
@@ -904,8 +913,8 @@ mk_orphanage(xfs_mount_t *mp)
 	xfs_bmap_init(&flist, &first);
 
 	nres = XFS_MKDIR_SPACE_RES(mp, xname.len);
-	if ((i = libxfs_trans_reserve(tp, nres, XFS_MKDIR_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES, XFS_MKDIR_LOG_COUNT)))
+	i = libxfs_trans_reserve(tp, &M_RES(mp)->tr_mkdir, nres, 0);
+	if (i)
 		res_failed(i);
 
 	/*
@@ -1041,10 +1050,9 @@ mv_orphanage(
 		if (err) {
 			ASSERT(err == ENOENT);
 
-			if ((err = libxfs_trans_reserve(tp, nres,
-					XFS_RENAME_LOG_RES(mp), 0,
-					XFS_TRANS_PERM_LOG_RES,
-					XFS_RENAME_LOG_COUNT)))
+			err = libxfs_trans_reserve(tp, &M_RES(mp)->tr_rename,
+						   nres, 0);
+			if (err)
 				do_error(
 	_("space reservation failed (%d), filesystem may be out of space\n"),
 					err);
@@ -1085,10 +1093,9 @@ mv_orphanage(
 			libxfs_trans_commit(tp,
 				XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
 		} else  {
-			if ((err = libxfs_trans_reserve(tp, nres,
-					XFS_RENAME_LOG_RES(mp), 0,
-					XFS_TRANS_PERM_LOG_RES,
-					XFS_RENAME_LOG_COUNT)))
+			err = libxfs_trans_reserve(tp, &M_RES(mp)->tr_rename,
+						   nres, 0);
+			if (err)
 				do_error(
 	_("space reservation failed (%d), filesystem may be out of space\n"),
 					err);
@@ -1143,8 +1150,8 @@ mv_orphanage(
 		 * also accounted for in the create
 		 */
 		nres = XFS_DIRENTER_SPACE_RES(mp, xname.len);
-		err = libxfs_trans_reserve(tp, nres, XFS_REMOVE_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES, XFS_REMOVE_LOG_COUNT);
+		err = libxfs_trans_reserve(tp, &M_RES(mp)->tr_remove,
+					   nres, 0);
 		if (err)
 			do_error(
 	_("space reservation failed (%d), filesystem may be out of space\n"),
@@ -1239,8 +1246,7 @@ longform_dir2_rebuild(
 
 	tp = libxfs_trans_alloc(mp, 0);
 	nres = XFS_REMOVE_SPACE_RES(mp);
-	error = libxfs_trans_reserve(tp, nres, XFS_REMOVE_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_REMOVE_LOG_COUNT);
+	error = libxfs_trans_reserve(tp, &M_RES(mp)->tr_remove, nres, 0);
 	if (error)
 		res_failed(error);
 	libxfs_trans_ijoin(tp, ip, 0);
@@ -1280,8 +1286,8 @@ longform_dir2_rebuild(
 
 		tp = libxfs_trans_alloc(mp, 0);
 		nres = XFS_CREATE_SPACE_RES(mp, p->name.len);
-		error = libxfs_trans_reserve(tp, nres, XFS_CREATE_LOG_RES(mp),
-				0, XFS_TRANS_PERM_LOG_RES, XFS_CREATE_LOG_COUNT);
+		error = libxfs_trans_reserve(tp, &M_RES(mp)->tr_create,
+					     nres, 0);
 		if (error) {
 			do_warn(
 	_("space reservation failed (%d), filesystem may be out of space\n"),
@@ -1342,8 +1348,7 @@ dir2_kill_block(
 
 	tp = libxfs_trans_alloc(mp, 0);
 	nres = XFS_REMOVE_SPACE_RES(mp);
-	error = libxfs_trans_reserve(tp, nres, XFS_REMOVE_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_REMOVE_LOG_COUNT);
+	error = libxfs_trans_reserve(tp, &M_RES(mp)->tr_remove, nres, 0);
 	if (error)
 		res_failed(error);
 	libxfs_trans_ijoin(tp, ip, 0);
@@ -1531,8 +1536,7 @@ longform_dir2_entry_check_data(
 		freetab->nents = db + 1;
 
 	tp = libxfs_trans_alloc(mp, 0);
-	error = libxfs_trans_reserve(tp, 0, XFS_REMOVE_LOG_RES(mp), 0,
-		XFS_TRANS_PERM_LOG_RES, XFS_REMOVE_LOG_COUNT);
+	error = libxfs_trans_reserve(tp, &M_RES(mp)->tr_remove, 0, 0);
 	if (error)
 		res_failed(error);
 	libxfs_trans_ijoin(tp, ip, 0);
@@ -2589,10 +2593,8 @@ process_dir_inode(
 			 * new define in ourselves.
 			 */
 			nres = no_modify ? 0 : XFS_REMOVE_SPACE_RES(mp);
-			error = libxfs_trans_reserve(tp, nres,
-					XFS_REMOVE_LOG_RES(mp), 0,
-					XFS_TRANS_PERM_LOG_RES,
-					XFS_REMOVE_LOG_COUNT);
+			error = libxfs_trans_reserve(tp, &M_RES(mp)->tr_remove,
+						     nres, 0);
 			if (error)
 				res_failed(error);
 
@@ -2640,8 +2642,7 @@ process_dir_inode(
 		ASSERT(tp != NULL);
 
 		nres = XFS_MKDIR_SPACE_RES(mp, 2);
-		error = libxfs_trans_reserve(tp, nres, XFS_MKDIR_LOG_RES(mp),
-				0, XFS_TRANS_PERM_LOG_RES, XFS_MKDIR_LOG_COUNT);
+		error = libxfs_trans_reserve(tp, &M_RES(mp)->tr_mkdir, nres, 0);
 		if (error)
 			res_failed(error);
 
@@ -2702,12 +2703,8 @@ process_dir_inode(
 			ASSERT(tp != NULL);
 
 			nres = XFS_MKDIR_SPACE_RES(mp, 1);
-			error = libxfs_trans_reserve(tp, nres,
-					XFS_MKDIR_LOG_RES(mp),
-					0,
-					XFS_TRANS_PERM_LOG_RES,
-					XFS_MKDIR_LOG_COUNT);
-
+			error = libxfs_trans_reserve(tp, &M_RES(mp)->tr_mkdir,
+						     nres, 0);
 			if (error)
 				res_failed(error);
 
diff --git a/repair/phase7.c b/repair/phase7.c
index bd1668e..18f2d88 100644
--- a/repair/phase7.c
+++ b/repair/phase7.c
@@ -68,13 +68,12 @@ update_inode_nlinks(
 	xfs_inode_t		*ip;
 	int			error;
 	int			dirty;
+	int			nres;
 
 	tp = libxfs_trans_alloc(mp, XFS_TRANS_REMOVE);
 
-	error = libxfs_trans_reserve(tp, (no_modify ? 0 : 10),
-			XFS_REMOVE_LOG_RES(mp), 0, XFS_TRANS_PERM_LOG_RES,
-			XFS_REMOVE_LOG_COUNT);
-
+	nres = no_modify ? 0 : 10;
+	error = libxfs_trans_reserve(tp, &M_RES(mp)->tr_remove, nres, 0);
 	ASSERT(error == 0);
 
 	error = libxfs_trans_iget(mp, tp, ino, 0, 0, &ip);
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
