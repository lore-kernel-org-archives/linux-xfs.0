Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47294 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbeJAXnc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 19:43:32 -0400
Subject: [PATCH 4/8] libxfs: fix xfs_trans_alloc reservation abuse
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Oct 2018 10:04:42 -0700
Message-ID: <153841348278.27952.4347774293221367664.stgit@magnolia>
In-Reply-To: <153841345236.27952.5050172703525712660.stgit@magnolia>
References: <153841345236.27952.5050172703525712660.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Various xfsprogs tools have been abusing the transaction reservation
system by allocating the transaction with zero reservation.  This has
always worked in the past because userspace transactions do not require
reservations.  However, once we merge deferred ops into the transaction
structure, we will need to use a permanent reservation type to set up
any transaction that can roll.  tr_itruncate has all we need, so use
that as the reservation dummy.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trans.h |    2 ++
 libxfs/trans.c      |   15 +++++++++++++++
 mkfs/proto.c        |   25 +++++++++++--------------
 mkfs/xfs_mkfs.c     |    3 +--
 repair/phase5.c     |    3 +--
 repair/phase6.c     |   26 ++++++++++----------------
 repair/rmap.c       |    8 +++-----
 7 files changed, 43 insertions(+), 39 deletions(-)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 54546da8..eda2f894 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -86,6 +86,8 @@ int	xfs_trans_roll(struct xfs_trans **);
 int	libxfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
 			   uint blocks, uint rtextents, uint flags,
 			   struct xfs_trans **tpp);
+int	libxfs_trans_alloc_rollable(struct xfs_mount *mp, uint blocks,
+				    struct xfs_trans **tpp);
 int	libxfs_trans_alloc_empty(struct xfs_mount *mp, struct xfs_trans **tpp);
 int	libxfs_trans_commit(struct xfs_trans *);
 void	libxfs_trans_cancel(struct xfs_trans *);
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 11a2098d..508d12d7 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -295,6 +295,21 @@ libxfs_trans_alloc_empty(
 	return xfs_trans_alloc(mp, &resv, 0, 0, XFS_TRANS_NO_WRITECOUNT, tpp);
 }
 
+/*
+ * Allocate a transaction that can be rolled.  Since userspace doesn't have
+ * a need for log reservations, we really only tr_itruncate to get the
+ * permanent log reservation flag to avoid blowing asserts.
+ */
+int
+libxfs_trans_alloc_rollable(
+	struct xfs_mount	*mp,
+	unsigned int		blocks,
+	struct xfs_trans	**tpp)
+{
+	return libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, blocks,
+			0, 0, tpp);
+}
+
 void
 libxfs_trans_cancel(
 	struct xfs_trans	*tp)
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 07d019d6..50a1bc54 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -123,9 +123,7 @@ getres(
 	uint		r;
 
 	for (i = 0, r = MKFS_BLOCKRES(blocks); r >= blocks; r--) {
-		struct xfs_trans_res    tres = {0};
-
-		i = -libxfs_trans_alloc(mp, &tres, r, 0, 0, &tp);
+		i = -libxfs_trans_alloc_rollable(mp, r, &tp);
 		if (i == 0)
 			return tp;
 	}
@@ -180,7 +178,6 @@ rsvfile(
 {
 	int		error;
 	xfs_trans_t	*tp;
-	struct xfs_trans_res tres = {0};
 
 	error = -libxfs_alloc_file_space(ip, 0, llen, 1, 0);
 
@@ -192,7 +189,7 @@ rsvfile(
 	/*
 	 * update the inode timestamp, mode, and prealloc flag bits
 	 */
-	error = -libxfs_trans_alloc(mp, &tres, 0, 0, 0, &tp);
+	error = -libxfs_trans_alloc_rollable(mp, 0, &tp);
 	if (error)
 		fail(_("allocating transaction for a file"), error);
 	libxfs_trans_ijoin(tp, ip, 0);
@@ -604,18 +601,18 @@ rtinit(
 	int		i;
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
 	xfs_extlen_t	nsumblocks;
+	uint		blocks;
 	int		nmap;
 	xfs_inode_t	*rbmip;
 	xfs_inode_t	*rsumip;
 	xfs_trans_t	*tp;
 	struct cred	creds;
 	struct fsxattr	fsxattrs;
-	struct xfs_trans_res tres = {0};
 
 	/*
 	 * First, allocate the inodes.
 	 */
-	i = -libxfs_trans_alloc(mp, &tres, MKFS_BLOCKRES_INODE, 0, 0, &tp);
+	i = -libxfs_trans_alloc_rollable(mp, MKFS_BLOCKRES_INODE, &tp);
 	if (i)
 		res_failed(i);
 
@@ -652,9 +649,9 @@ rtinit(
 	/*
 	 * Next, give the bitmap file some zero-filled blocks.
 	 */
-	i = -libxfs_trans_alloc(mp, &tres,
-		mp->m_sb.sb_rbmblocks + (XFS_BM_MAXLEVELS(mp,XFS_DATA_FORK) - 1),
-				0, 0, &tp);
+	blocks = mp->m_sb.sb_rbmblocks +
+			XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
+	i = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
 	if (i)
 		res_failed(i);
 
@@ -683,9 +680,8 @@ rtinit(
 	 * Give the summary file some zero-filled blocks.
 	 */
 	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
-	i = -libxfs_trans_alloc(mp, &tres,
-			nsumblocks + (XFS_BM_MAXLEVELS(mp,XFS_DATA_FORK) - 1),
-				0, 0, &tp);
+	blocks = nsumblocks + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
+	i = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
 	if (i)
 		res_failed(i);
 	libxfs_trans_ijoin(tp, rsumip, 0);
@@ -713,7 +709,8 @@ rtinit(
 	 * Do one transaction per bitmap block.
 	 */
 	for (bno = 0; bno < mp->m_sb.sb_rextents; bno = ebno) {
-		i = -libxfs_trans_alloc(mp, &tres, 0, 0, 0, &tp);
+		i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+				0, 0, 0, &tp);
 		if (i)
 			res_failed(i);
 		libxfs_trans_ijoin(tp, rbmip, 0);
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index c6ef3a71..982d3871 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3674,10 +3674,9 @@ initialise_ag_freespace(
 {
 	struct xfs_alloc_arg	args;
 	struct xfs_trans	*tp;
-	struct xfs_trans_res tres = {0};
 	int			c;
 
-	c = -libxfs_trans_alloc(mp, &tres, worst_freelist, 0, 0, &tp);
+	c = -libxfs_trans_alloc_rollable(mp, worst_freelist, &tp);
 	if (c)
 		res_failed(c);
 
diff --git a/repair/phase5.c b/repair/phase5.c
index 64f7b6e8..85d1f4fb 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -2421,7 +2421,6 @@ inject_lost_blocks(
 	struct xfs_trans	*tp = NULL;
 	struct xfs_slab_cursor	*cur = NULL;
 	xfs_fsblock_t		*fsb;
-	struct xfs_trans_res	tres = {0};
 	struct xfs_owner_info	oinfo;
 	int			error;
 
@@ -2431,7 +2430,7 @@ inject_lost_blocks(
 		return error;
 
 	while ((fsb = pop_slab_cursor(cur)) != NULL) {
-		error = -libxfs_trans_alloc(mp, &tres, 16, 0, 0, &tp);
+		error = -libxfs_trans_alloc_rollable(mp, 16, &tp);
 		if (error)
 			goto out_cancel;
 
diff --git a/repair/phase6.c b/repair/phase6.c
index afa65c51..d6cb0a5a 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -526,12 +526,12 @@ mk_rbmino(xfs_mount_t *mp)
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
 	int		vers;
 	int		times;
-	struct xfs_trans_res tres = {0};
+	uint		blocks;
 
 	/*
 	 * first set up inode
 	 */
-	i = -libxfs_trans_alloc(mp, &tres, 10, 0, 0, &tp);
+	i = -libxfs_trans_alloc_rollable(mp, 10, &tp);
 	if (i)
 		res_failed(i);
 
@@ -579,9 +579,9 @@ mk_rbmino(xfs_mount_t *mp)
 	 * then allocate blocks for file and fill with zeroes (stolen
 	 * from mkfs)
 	 */
-	error = -libxfs_trans_alloc(mp, &tres,
-		mp->m_sb.sb_rbmblocks + (XFS_BM_MAXLEVELS(mp,XFS_DATA_FORK) - 1),
-				   0, 0, &tp);
+	blocks = mp->m_sb.sb_rbmblocks +
+			XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
+	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
 	if (error)
 		res_failed(error);
 
@@ -619,12 +619,11 @@ fill_rbmino(xfs_mount_t *mp)
 	int		error;
 	xfs_fileoff_t	bno;
 	xfs_bmbt_irec_t	map;
-	struct xfs_trans_res tres = {0};
 
 	bmp = btmcompute;
 	bno = 0;
 
-	error = -libxfs_trans_alloc(mp, &tres, 10, 0, 0, &tp);
+	error = -libxfs_trans_alloc_rollable(mp, 10, &tp);
 	if (error)
 		res_failed(error);
 
@@ -686,13 +685,12 @@ fill_rsumino(xfs_mount_t *mp)
 	xfs_fileoff_t	bno;
 	xfs_fileoff_t	end_bno;
 	xfs_bmbt_irec_t	map;
-	struct xfs_trans_res tres = {0};
 
 	smp = sumcompute;
 	bno = 0;
 	end_bno = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
 
-	error = -libxfs_trans_alloc(mp, &tres, 10, 0, 0, &tp);
+	error = -libxfs_trans_alloc_rollable(mp, 10, &tp);
 	if (error)
 		res_failed(error);
 
@@ -757,7 +755,7 @@ mk_rsumino(xfs_mount_t *mp)
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
 	int		vers;
 	int		times;
-	struct xfs_trans_res tres = {0};
+	uint		blocks;
 
 	/*
 	 * first set up inode
@@ -811,12 +809,8 @@ mk_rsumino(xfs_mount_t *mp)
 	 * from mkfs)
 	 */
 	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
-	tres.tr_logres = BBTOB(128);
-	tres.tr_logcount = XFS_DEFAULT_PERM_LOG_COUNT;
-	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-	error = -libxfs_trans_alloc(mp, &tres,
-		nsumblocks + (XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1),
-				    0, 0, &tp);
+	blocks = nsumblocks + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
+	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
 	if (error)
 		res_failed(error);
 
diff --git a/repair/rmap.c b/repair/rmap.c
index f991144a..d596d0ff 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -449,7 +449,6 @@ rmap_store_ag_btree_rec(
 	struct xfs_buf		*agbp = NULL;
 	struct xfs_buf		*agflbp = NULL;
 	struct xfs_trans	*tp;
-	struct xfs_trans_res tres = {0};
 	__be32			*agfl_bno, *b;
 	int			error = 0;
 	struct xfs_owner_info	oinfo;
@@ -507,7 +506,7 @@ rmap_store_ag_btree_rec(
 	/* Insert rmaps into the btree one at a time */
 	rm_rec = pop_slab_cursor(rm_cur);
 	while (rm_rec) {
-		error = -libxfs_trans_alloc(mp, &tres, 16, 0, 0, &tp);
+		error = -libxfs_trans_alloc_rollable(mp, 16, &tp);
 		if (error)
 			goto err_slab;
 
@@ -1366,7 +1365,6 @@ fix_freelist(
 {
 	xfs_alloc_arg_t		args;
 	xfs_trans_t		*tp;
-	struct xfs_trans_res	tres = {0};
 	int			flags;
 	int			error;
 
@@ -1375,8 +1373,8 @@ fix_freelist(
 	args.agno = agno;
 	args.alignment = 1;
 	args.pag = libxfs_perag_get(mp, agno);
-	error = -libxfs_trans_alloc(mp, &tres,
-			libxfs_alloc_min_freelist(mp, args.pag), 0, 0, &tp);
+	error = -libxfs_trans_alloc_rollable(mp,
+			libxfs_alloc_min_freelist(mp, args.pag), &tp);
 	if (error)
 		do_error(_("failed to fix AGFL on AG %d, error %d\n"),
 				agno, error);
