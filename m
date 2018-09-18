Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41736 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727660AbeISA3L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Sep 2018 20:29:11 -0400
Subject: [PATCH 3/4] libxfs: fix xfs_trans_alloc reservation abuse
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 18 Sep 2018 11:55:10 -0700
Message-ID: <153729691089.13178.16318528592869733356.stgit@magnolia>
In-Reply-To: <153729689066.13178.8524619838625486047.stgit@magnolia>
References: <153729689066.13178.8524619838625486047.stgit@magnolia>
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
 mkfs/proto.c    |   19 +++++++++----------
 mkfs/xfs_mkfs.c |    4 ++--
 repair/phase5.c |    4 ++--
 repair/phase6.c |   20 ++++++++------------
 repair/rmap.c   |    7 +++----
 5 files changed, 24 insertions(+), 30 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 9eb15ab0..141c27b8 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -123,9 +123,8 @@ getres(
 	uint		r;
 
 	for (i = 0, r = MKFS_BLOCKRES(blocks); r >= blocks; r--) {
-		struct xfs_trans_res    tres = {0};
-
-		i = -libxfs_trans_alloc(mp, &tres, r, 0, 0, &tp);
+		i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+				r, 0, 0, &tp);
 		if (i == 0)
 			return tp;
 	}
@@ -180,7 +179,6 @@ rsvfile(
 {
 	int		error;
 	xfs_trans_t	*tp;
-	struct xfs_trans_res tres = {0};
 
 	error = -libxfs_alloc_file_space(ip, 0, llen, 1, 0);
 
@@ -192,7 +190,7 @@ rsvfile(
 	/*
 	 * update the inode timestamp, mode, and prealloc flag bits
 	 */
-	error = -libxfs_trans_alloc(mp, &tres, 0, 0, 0, &tp);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
 	if (error)
 		fail(_("allocating transaction for a file"), error);
 	libxfs_trans_ijoin(tp, ip, 0);
@@ -636,12 +634,12 @@ rtinit(
 	xfs_trans_t	*tp;
 	struct cred	creds;
 	struct fsxattr	fsxattrs;
-	struct xfs_trans_res tres = {0};
 
 	/*
 	 * First, allocate the inodes.
 	 */
-	i = -libxfs_trans_alloc(mp, &tres, MKFS_BLOCKRES_INODE, 0, 0, &tp);
+	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+			MKFS_BLOCKRES_INODE, 0, 0, &tp);
 	if (i)
 		res_failed(i);
 
@@ -678,7 +676,7 @@ rtinit(
 	/*
 	 * Next, give the bitmap file some zero-filled blocks.
 	 */
-	i = -libxfs_trans_alloc(mp, &tres,
+	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
 		mp->m_sb.sb_rbmblocks + (XFS_BM_MAXLEVELS(mp,XFS_DATA_FORK) - 1),
 				0, 0, &tp);
 	if (i)
@@ -716,7 +714,7 @@ rtinit(
 	 * Give the summary file some zero-filled blocks.
 	 */
 	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
-	i = -libxfs_trans_alloc(mp, &tres,
+	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
 			nsumblocks + (XFS_BM_MAXLEVELS(mp,XFS_DATA_FORK) - 1),
 				0, 0, &tp);
 	if (i)
@@ -753,7 +751,8 @@ rtinit(
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
index c6ef3a71..9ef6e84a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3674,10 +3674,10 @@ initialise_ag_freespace(
 {
 	struct xfs_alloc_arg	args;
 	struct xfs_trans	*tp;
-	struct xfs_trans_res tres = {0};
 	int			c;
 
-	c = -libxfs_trans_alloc(mp, &tres, worst_freelist, 0, 0, &tp);
+	c = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+			worst_freelist, 0, 0, &tp);
 	if (c)
 		res_failed(c);
 
diff --git a/repair/phase5.c b/repair/phase5.c
index 64f7b6e8..ac2eea54 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -2421,7 +2421,6 @@ inject_lost_blocks(
 	struct xfs_trans	*tp = NULL;
 	struct xfs_slab_cursor	*cur = NULL;
 	xfs_fsblock_t		*fsb;
-	struct xfs_trans_res	tres = {0};
 	struct xfs_owner_info	oinfo;
 	int			error;
 
@@ -2431,7 +2430,8 @@ inject_lost_blocks(
 		return error;
 
 	while ((fsb = pop_slab_cursor(cur)) != NULL) {
-		error = -libxfs_trans_alloc(mp, &tres, 16, 0, 0, &tp);
+		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+				16, 0, 0, &tp);
 		if (error)
 			goto out_cancel;
 
diff --git a/repair/phase6.c b/repair/phase6.c
index 19ad54d3..58b23aa3 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -528,12 +528,12 @@ mk_rbmino(xfs_mount_t *mp)
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
 	int		vers;
 	int		times;
-	struct xfs_trans_res tres = {0};
 
 	/*
 	 * first set up inode
 	 */
-	i = -libxfs_trans_alloc(mp, &tres, 10, 0, 0, &tp);
+	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+			10, 0, 0, &tp);
 	if (i)
 		res_failed(i);
 
@@ -581,7 +581,7 @@ mk_rbmino(xfs_mount_t *mp)
 	 * then allocate blocks for file and fill with zeroes (stolen
 	 * from mkfs)
 	 */
-	error = -libxfs_trans_alloc(mp, &tres,
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
 		mp->m_sb.sb_rbmblocks + (XFS_BM_MAXLEVELS(mp,XFS_DATA_FORK) - 1),
 				   0, 0, &tp);
 	if (error)
@@ -631,12 +631,12 @@ fill_rbmino(xfs_mount_t *mp)
 	int		error;
 	xfs_fileoff_t	bno;
 	xfs_bmbt_irec_t	map;
-	struct xfs_trans_res tres = {0};
 
 	bmp = btmcompute;
 	bno = 0;
 
-	error = -libxfs_trans_alloc(mp, &tres, 10, 0, 0, &tp);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+			10, 0, 0, &tp);
 	if (error)
 		res_failed(error);
 
@@ -701,13 +701,13 @@ fill_rsumino(xfs_mount_t *mp)
 	xfs_fileoff_t	bno;
 	xfs_fileoff_t	end_bno;
 	xfs_bmbt_irec_t	map;
-	struct xfs_trans_res tres = {0};
 
 	smp = sumcompute;
 	bno = 0;
 	end_bno = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
 
-	error = -libxfs_trans_alloc(mp, &tres, 10, 0, 0, &tp);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+			10, 0, 0, &tp);
 	if (error)
 		res_failed(error);
 
@@ -776,7 +776,6 @@ mk_rsumino(xfs_mount_t *mp)
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
 	int		vers;
 	int		times;
-	struct xfs_trans_res tres = {0};
 
 	/*
 	 * first set up inode
@@ -832,10 +831,7 @@ mk_rsumino(xfs_mount_t *mp)
 	libxfs_defer_init(&dfops, &first);
 
 	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
-	tres.tr_logres = BBTOB(128);
-	tres.tr_logcount = XFS_DEFAULT_PERM_LOG_COUNT;
-	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-	error = -libxfs_trans_alloc(mp, &tres,
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
 		mp->m_sb.sb_rbmblocks + (XFS_BM_MAXLEVELS(mp,XFS_DATA_FORK) - 1),
 				    0, 0, &tp);
 	if (error)
diff --git a/repair/rmap.c b/repair/rmap.c
index bffb5b61..43eac288 100644
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
@@ -507,7 +506,8 @@ rmap_store_ag_btree_rec(
 	/* Insert rmaps into the btree one at a time */
 	rm_rec = pop_slab_cursor(rm_cur);
 	while (rm_rec) {
-		error = -libxfs_trans_alloc(mp, &tres, 16, 0, 0, &tp);
+		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+				16, 0, 0, &tp);
 		if (error)
 			goto err_slab;
 
@@ -1366,7 +1366,6 @@ fix_freelist(
 {
 	xfs_alloc_arg_t		args;
 	xfs_trans_t		*tp;
-	struct xfs_trans_res	tres = {0};
 	int			flags;
 	int			error;
 
@@ -1375,7 +1374,7 @@ fix_freelist(
 	args.agno = agno;
 	args.alignment = 1;
 	args.pag = libxfs_perag_get(mp, agno);
-	error = -libxfs_trans_alloc(mp, &tres,
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
 			libxfs_alloc_min_freelist(mp, args.pag), 0, 0, &tp);
 	if (error)
 		do_error(_("failed to fix AGFL on AG %d, error %d\n"),
