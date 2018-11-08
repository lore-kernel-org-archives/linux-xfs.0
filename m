Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54778 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbeKII6P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Nov 2018 03:58:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA8NJIN7066181
        for <linux-xfs@vger.kernel.org>; Thu, 8 Nov 2018 23:20:22 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2nh4ar47v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 08 Nov 2018 23:20:22 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wA8NKMZQ026171
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 8 Nov 2018 23:20:22 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wA8NKLUk013925
        for <linux-xfs@vger.kernel.org>; Thu, 8 Nov 2018 23:20:21 GMT
Subject: [PATCH 2/5] xfs: remove xfs_rmap_ag_owner and friends
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 08 Nov 2018 15:20:13 -0800
Message-ID: <154171921390.30818.8627531125794999636.stgit@magnolia>
In-Reply-To: <154171920164.30818.2178553842722589349.stgit@magnolia>
References: <154171920164.30818.2178553842722589349.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Owner information for static fs metadata can be defined readonly at
build time because it never changes across filesystems.  This enables us
to reduce stack usage (particularly in scrub) because we can use the
statically defined oinfo structures.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ag.c             |    9 ++++-----
 fs/xfs/libxfs/xfs_alloc.c          |    8 +++-----
 fs/xfs/libxfs/xfs_bmap.c           |    4 ++--
 fs/xfs/libxfs/xfs_ialloc.c         |    8 +++-----
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    7 ++-----
 fs/xfs/libxfs/xfs_refcount_btree.c |    6 ++----
 fs/xfs/libxfs/xfs_rmap.c           |   28 ++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap.h           |   34 ++++++++++------------------------
 fs/xfs/scrub/agheader.c            |   25 +++++++------------------
 fs/xfs/scrub/agheader_repair.c     |    5 ++---
 fs/xfs/scrub/alloc.c               |    4 +---
 fs/xfs/scrub/ialloc.c              |   28 +++++++++-------------------
 fs/xfs/scrub/inode.c               |    4 +---
 fs/xfs/scrub/refcount.c            |   15 +++++----------
 fs/xfs/scrub/repair.c              |    4 +---
 fs/xfs/scrub/rmap.c                |    5 +----
 fs/xfs/xfs_extfree_item.c          |    5 ++---
 17 files changed, 83 insertions(+), 116 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 9345802c99f7..999ad8d00d43 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -414,7 +414,6 @@ xfs_ag_extend_space(
 	struct aghdr_init_data	*id,
 	xfs_extlen_t		len)
 {
-	struct xfs_owner_info	oinfo;
 	struct xfs_buf		*bp;
 	struct xfs_agi		*agi;
 	struct xfs_agf		*agf;
@@ -448,17 +447,17 @@ xfs_ag_extend_space(
 	/*
 	 * Free the new space.
 	 *
-	 * XFS_RMAP_OWN_NULL is used here to tell the rmap btree that
+	 * XFS_RMAP_OINFO_SKIP_UPDATE is used here to tell the rmap btree that
 	 * this doesn't actually exist in the rmap btree.
 	 */
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_NULL);
 	error = xfs_rmap_free(tp, bp, id->agno,
 				be32_to_cpu(agf->agf_length) - len,
-				len, &oinfo);
+				len, &XFS_RMAP_OINFO_SKIP_UPDATE);
 	if (error)
 		return error;
 
 	return  xfs_free_extent(tp, XFS_AGB_TO_FSB(mp, id->agno,
 					be32_to_cpu(agf->agf_length) - len),
-				len, &oinfo, XFS_AG_RESV_NONE);
+				len, &XFS_RMAP_OINFO_SKIP_UPDATE,
+				XFS_AG_RESV_NONE);
 }
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index bce46fa0ee38..0f5e10a0c024 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1594,7 +1594,6 @@ xfs_alloc_ag_vextent_small(
 	xfs_extlen_t	*flenp,	/* result length */
 	int		*stat)	/* status: 0-freelist, 1-normal/none */
 {
-	struct xfs_owner_info	oinfo;
 	int		error;
 	xfs_agblock_t	fbno;
 	xfs_extlen_t	flen;
@@ -1648,9 +1647,8 @@ xfs_alloc_ag_vextent_small(
 			 * doesn't live in the free space, we need to clear
 			 * out the OWN_AG rmap.
 			 */
-			xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
 			error = xfs_rmap_free(args->tp, args->agbp, args->agno,
-					fbno, 1, &oinfo);
+					fbno, 1, &XFS_RMAP_OINFO_AG);
 			if (error)
 				goto error0;
 
@@ -2315,9 +2313,9 @@ xfs_alloc_fix_freelist(
 	 */
 	memset(&targs, 0, sizeof(targs));
 	if (flags & XFS_ALLOC_FLAG_NORMAP)
-		xfs_rmap_skip_owner_update(&targs.oinfo);
+		targs.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
 	else
-		xfs_rmap_ag_owner(&targs.oinfo, XFS_RMAP_OWN_AG);
+		targs.oinfo = XFS_RMAP_OINFO_AG;
 	while (!(flags & XFS_ALLOC_FLAG_NOSHRINK) && pag->pagf_flcount > need) {
 		error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
 		if (error)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 60abaa2e8146..c8095db42e7b 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -564,7 +564,7 @@ __xfs_bmap_add_free(
 	if (oinfo)
 		new->xefi_oinfo = *oinfo;
 	else
-		xfs_rmap_skip_owner_update(&new->xefi_oinfo);
+		new->xefi_oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
 	new->xefi_skip_discard = skip_discard;
 	trace_xfs_bmap_free_defer(tp->t_mountp,
 			XFS_FSB_TO_AGNO(tp->t_mountp, bno), 0,
@@ -3450,7 +3450,7 @@ xfs_bmap_btalloc(
 	args.tp = ap->tp;
 	args.mp = mp;
 	args.fsbno = ap->blkno;
-	xfs_rmap_skip_owner_update(&args.oinfo);
+	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
 
 	/* Trim the allocation back to the maximum an AG can fit. */
 	args.maxlen = min(ap->length, mp->m_ag_max_usable);
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index a8f6db735d5d..fcf0d17405d8 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -641,7 +641,7 @@ xfs_ialloc_ag_alloc(
 	args.tp = tp;
 	args.mp = tp->t_mountp;
 	args.fsbno = NULLFSBLOCK;
-	xfs_rmap_ag_owner(&args.oinfo, XFS_RMAP_OWN_INODES);
+	args.oinfo = XFS_RMAP_OINFO_INODES;
 
 #ifdef DEBUG
 	/* randomly do sparse inode allocations */
@@ -1849,14 +1849,12 @@ xfs_difree_inode_chunk(
 	int				nextbit;
 	xfs_agblock_t			agbno;
 	int				contigblk;
-	struct xfs_owner_info		oinfo;
 	DECLARE_BITMAP(holemask, XFS_INOBT_HOLEMASK_BITS);
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
 
 	if (!xfs_inobt_issparse(rec->ir_holemask)) {
 		/* not sparse, calculate extent info directly */
 		xfs_bmap_add_free(tp, XFS_AGB_TO_FSB(mp, agno, sagbno),
-				  mp->m_ialloc_blks, &oinfo);
+				  mp->m_ialloc_blks, &XFS_RMAP_OINFO_INODES);
 		return;
 	}
 
@@ -1900,7 +1898,7 @@ xfs_difree_inode_chunk(
 		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
 		xfs_bmap_add_free(tp, XFS_AGB_TO_FSB(mp, agno, agbno),
-				  contigblk, &oinfo);
+				  contigblk, &XFS_RMAP_OINFO_INODES);
 
 		/* reset range to current bit and carry on... */
 		startidx = endidx = nextbit;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 86c50208a143..2ab5bcd903a7 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -84,7 +84,7 @@ __xfs_inobt_alloc_block(
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
-	xfs_rmap_ag_owner(&args.oinfo, XFS_RMAP_OWN_INOBT);
+	args.oinfo = XFS_RMAP_OINFO_INOBT;
 	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.a.agno, sbno);
 	args.minlen = 1;
 	args.maxlen = 1;
@@ -136,12 +136,9 @@ __xfs_inobt_free_block(
 	struct xfs_buf		*bp,
 	enum xfs_ag_resv_type	resv)
 {
-	struct xfs_owner_info	oinfo;
-
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
 	return xfs_free_extent(cur->bc_tp,
 			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
-			&oinfo, resv);
+			&XFS_RMAP_OINFO_INOBT, resv);
 }
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 1aaa01c97517..d9eab657b63e 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -70,7 +70,7 @@ xfs_refcountbt_alloc_block(
 	args.type = XFS_ALLOCTYPE_NEAR_BNO;
 	args.fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
 			xfs_refc_block(args.mp));
-	xfs_rmap_ag_owner(&args.oinfo, XFS_RMAP_OWN_REFC);
+	args.oinfo = XFS_RMAP_OINFO_REFC;
 	args.minlen = args.maxlen = args.prod = 1;
 	args.resv = XFS_AG_RESV_METADATA;
 
@@ -106,15 +106,13 @@ xfs_refcountbt_free_block(
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
 	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
-	struct xfs_owner_info	oinfo;
 	int			error;
 
 	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_private.a.agno,
 			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1);
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_REFC);
 	be32_add_cpu(&agf->agf_refcount_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
-	error = xfs_free_extent(cur->bc_tp, fsbno, 1, &oinfo,
+	error = xfs_free_extent(cur->bc_tp, fsbno, 1, &XFS_RMAP_OINFO_REFC,
 			XFS_AG_RESV_METADATA);
 	if (error)
 		return error;
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index e7d06295338d..8ed885507dd8 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2550,3 +2550,31 @@ xfs_rmap_has_other_keys(
 	*has_rmap = rks.has_rmap;
 	return error;
 }
+
+const struct xfs_owner_info XFS_RMAP_OINFO_SKIP_UPDATE = {
+	.oi_owner = XFS_RMAP_OWN_NULL,
+};
+const struct xfs_owner_info XFS_RMAP_OINFO_ANY_OWNER = {
+	.oi_owner = XFS_RMAP_OWN_UNKNOWN,
+};
+const struct xfs_owner_info XFS_RMAP_OINFO_FS = {
+	.oi_owner = XFS_RMAP_OWN_FS,
+};
+const struct xfs_owner_info XFS_RMAP_OINFO_LOG = {
+	.oi_owner = XFS_RMAP_OWN_LOG,
+};
+const struct xfs_owner_info XFS_RMAP_OINFO_AG = {
+	.oi_owner = XFS_RMAP_OWN_AG,
+};
+const struct xfs_owner_info XFS_RMAP_OINFO_INOBT = {
+	.oi_owner = XFS_RMAP_OWN_INOBT,
+};
+const struct xfs_owner_info XFS_RMAP_OINFO_INODES = {
+	.oi_owner = XFS_RMAP_OWN_INODES,
+};
+const struct xfs_owner_info XFS_RMAP_OINFO_REFC = {
+	.oi_owner = XFS_RMAP_OWN_REFC,
+};
+const struct xfs_owner_info XFS_RMAP_OINFO_COW = {
+	.oi_owner = XFS_RMAP_OWN_COW,
+};
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 00e38505037f..2c42b49b6b09 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -6,16 +6,6 @@
 #ifndef __XFS_RMAP_H__
 #define __XFS_RMAP_H__
 
-static inline void
-xfs_rmap_ag_owner(
-	struct xfs_owner_info	*oi,
-	uint64_t		owner)
-{
-	oi->oi_owner = owner;
-	oi->oi_offset = 0;
-	oi->oi_flags = 0;
-}
-
 static inline void
 xfs_rmap_ino_bmbt_owner(
 	struct xfs_owner_info	*oi,
@@ -43,13 +33,6 @@ xfs_rmap_ino_owner(
 		oi->oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
 }
 
-static inline void
-xfs_rmap_skip_owner_update(
-	struct xfs_owner_info	*oi)
-{
-	xfs_rmap_ag_owner(oi, XFS_RMAP_OWN_NULL);
-}
-
 static inline bool
 xfs_rmap_should_skip_owner_update(
 	const struct xfs_owner_info	*oi)
@@ -57,13 +40,6 @@ xfs_rmap_should_skip_owner_update(
 	return oi->oi_owner == XFS_RMAP_OWN_NULL;
 }
 
-static inline void
-xfs_rmap_any_owner_update(
-	struct xfs_owner_info	*oi)
-{
-	xfs_rmap_ag_owner(oi, XFS_RMAP_OWN_UNKNOWN);
-}
-
 /* Reverse mapping functions. */
 
 struct xfs_buf;
@@ -225,4 +201,14 @@ int xfs_rmap_has_other_keys(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		bool *has_rmap);
 int xfs_rmap_map_raw(struct xfs_btree_cur *cur, struct xfs_rmap_irec *rmap);
 
+extern const struct xfs_owner_info XFS_RMAP_OINFO_SKIP_UPDATE;
+extern const struct xfs_owner_info XFS_RMAP_OINFO_ANY_OWNER;
+extern const struct xfs_owner_info XFS_RMAP_OINFO_FS;
+extern const struct xfs_owner_info XFS_RMAP_OINFO_LOG;
+extern const struct xfs_owner_info XFS_RMAP_OINFO_AG;
+extern const struct xfs_owner_info XFS_RMAP_OINFO_INOBT;
+extern const struct xfs_owner_info XFS_RMAP_OINFO_INODES;
+extern const struct xfs_owner_info XFS_RMAP_OINFO_REFC;
+extern const struct xfs_owner_info XFS_RMAP_OINFO_COW;
+
 #endif	/* __XFS_RMAP_H__ */
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 3068a9382feb..90955ab1e895 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -32,7 +32,6 @@ xchk_superblock_xref(
 	struct xfs_scrub	*sc,
 	struct xfs_buf		*bp)
 {
-	struct xfs_owner_info	oinfo;
 	struct xfs_mount	*mp = sc->mp;
 	xfs_agnumber_t		agno = sc->sm->sm_agno;
 	xfs_agblock_t		agbno;
@@ -49,8 +48,7 @@ xchk_superblock_xref(
 
 	xchk_xref_is_used_space(sc, agbno, 1);
 	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
-	xchk_xref_is_owned_by(sc, agbno, 1, &oinfo);
+	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
 	xchk_xref_is_not_shared(sc, agbno, 1);
 
 	/* scrub teardown will take care of sc->sa for us */
@@ -484,7 +482,6 @@ STATIC void
 xchk_agf_xref(
 	struct xfs_scrub	*sc)
 {
-	struct xfs_owner_info	oinfo;
 	struct xfs_mount	*mp = sc->mp;
 	xfs_agblock_t		agbno;
 	int			error;
@@ -502,8 +499,7 @@ xchk_agf_xref(
 	xchk_agf_xref_freeblks(sc);
 	xchk_agf_xref_cntbt(sc);
 	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
-	xchk_xref_is_owned_by(sc, agbno, 1, &oinfo);
+	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
 	xchk_agf_xref_btreeblks(sc);
 	xchk_xref_is_not_shared(sc, agbno, 1);
 	xchk_agf_xref_refcblks(sc);
@@ -598,7 +594,6 @@ xchk_agf(
 /* AGFL */
 
 struct xchk_agfl_info {
-	struct xfs_owner_info	oinfo;
 	unsigned int		sz_entries;
 	unsigned int		nr_entries;
 	xfs_agblock_t		*entries;
@@ -609,15 +604,14 @@ struct xchk_agfl_info {
 STATIC void
 xchk_agfl_block_xref(
 	struct xfs_scrub	*sc,
-	xfs_agblock_t		agbno,
-	struct xfs_owner_info	*oinfo)
+	xfs_agblock_t		agbno)
 {
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
 
 	xchk_xref_is_used_space(sc, agbno, 1);
 	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
-	xchk_xref_is_owned_by(sc, agbno, 1, oinfo);
+	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_AG);
 	xchk_xref_is_not_shared(sc, agbno, 1);
 }
 
@@ -638,7 +632,7 @@ xchk_agfl_block(
 	else
 		xchk_block_set_corrupt(sc, sc->sa.agfl_bp);
 
-	xchk_agfl_block_xref(sc, agbno, priv);
+	xchk_agfl_block_xref(sc, agbno);
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return XFS_BTREE_QUERY_RANGE_ABORT;
@@ -662,7 +656,6 @@ STATIC void
 xchk_agfl_xref(
 	struct xfs_scrub	*sc)
 {
-	struct xfs_owner_info	oinfo;
 	struct xfs_mount	*mp = sc->mp;
 	xfs_agblock_t		agbno;
 	int			error;
@@ -678,8 +671,7 @@ xchk_agfl_xref(
 
 	xchk_xref_is_used_space(sc, agbno, 1);
 	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
-	xchk_xref_is_owned_by(sc, agbno, 1, &oinfo);
+	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
 	xchk_xref_is_not_shared(sc, agbno, 1);
 
 	/*
@@ -732,7 +724,6 @@ xchk_agfl(
 	}
 
 	/* Check the blocks in the AGFL. */
-	xfs_rmap_ag_owner(&sai.oinfo, XFS_RMAP_OWN_AG);
 	error = xfs_agfl_walk(sc->mp, XFS_BUF_TO_AGF(sc->sa.agf_bp),
 			sc->sa.agfl_bp, xchk_agfl_block, &sai);
 	if (error == XFS_BTREE_QUERY_RANGE_ABORT) {
@@ -791,7 +782,6 @@ STATIC void
 xchk_agi_xref(
 	struct xfs_scrub	*sc)
 {
-	struct xfs_owner_info	oinfo;
 	struct xfs_mount	*mp = sc->mp;
 	xfs_agblock_t		agbno;
 	int			error;
@@ -808,8 +798,7 @@ xchk_agi_xref(
 	xchk_xref_is_used_space(sc, agbno, 1);
 	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
 	xchk_agi_xref_icounts(sc);
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
-	xchk_xref_is_owned_by(sc, agbno, 1, &oinfo);
+	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
 	xchk_xref_is_not_shared(sc, agbno, 1);
 
 	/* scrub teardown will take care of sc->sa for us */
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index f7568a4b5fe5..03d1e15cceba 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -646,7 +646,6 @@ int
 xrep_agfl(
 	struct xfs_scrub	*sc)
 {
-	struct xfs_owner_info	oinfo;
 	struct xfs_bitmap	agfl_extents;
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_buf		*agf_bp;
@@ -708,8 +707,8 @@ xrep_agfl(
 		goto err;
 
 	/* Dump any AGFL overflow. */
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
-	return xrep_reap_extents(sc, &agfl_extents, &oinfo, XFS_AG_RESV_AGFL);
+	return xrep_reap_extents(sc, &agfl_extents, &XFS_RMAP_OINFO_AG,
+			XFS_AG_RESV_AGFL);
 err:
 	xfs_bitmap_destroy(&agfl_extents);
 	return error;
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 376bcb585ae6..44883e9112ad 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -125,12 +125,10 @@ xchk_allocbt(
 	struct xfs_scrub	*sc,
 	xfs_btnum_t		which)
 {
-	struct xfs_owner_info	oinfo;
 	struct xfs_btree_cur	*cur;
 
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
 	cur = which == XFS_BTNUM_BNO ? sc->sa.bno_cur : sc->sa.cnt_cur;
-	return xchk_btree(sc, cur, xchk_allocbt_rec, &oinfo, NULL);
+	return xchk_btree(sc, cur, xchk_allocbt_rec, &XFS_RMAP_OINFO_AG, NULL);
 }
 
 int
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 224dba937492..72f45b298fa5 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -82,15 +82,12 @@ xchk_iallocbt_chunk_xref(
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len)
 {
-	struct xfs_owner_info		oinfo;
-
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
 
 	xchk_xref_is_used_space(sc, agbno, len);
 	xchk_iallocbt_chunk_xref_other(sc, irec, agino);
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
-	xchk_xref_is_owned_by(sc, agbno, len, &oinfo);
+	xchk_xref_is_owned_by(sc, agbno, len, &XFS_RMAP_OINFO_INODES);
 	xchk_xref_is_not_shared(sc, agbno, len);
 }
 
@@ -186,7 +183,6 @@ xchk_iallocbt_check_freemask(
 	struct xchk_btree		*bs,
 	struct xfs_inobt_rec_incore	*irec)
 {
-	struct xfs_owner_info		oinfo;
 	struct xfs_imap			imap;
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_dinode		*dip;
@@ -205,7 +201,6 @@ xchk_iallocbt_check_freemask(
 	/* Make sure the freemask matches the inode records. */
 	blks_per_cluster = xfs_icluster_size_fsb(mp);
 	nr_inodes = XFS_OFFBNO_TO_AGINO(mp, blks_per_cluster, 0);
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
 
 	for (agino = irec->ir_startino;
 	     agino < irec->ir_startino + XFS_INODES_PER_CHUNK;
@@ -230,12 +225,13 @@ xchk_iallocbt_check_freemask(
 		/* If any part of this is a hole, skip it. */
 		if (ir_holemask) {
 			xchk_xref_is_not_owned_by(bs->sc, agbno,
-					blks_per_cluster, &oinfo);
+					blks_per_cluster,
+					&XFS_RMAP_OINFO_INODES);
 			continue;
 		}
 
 		xchk_xref_is_owned_by(bs->sc, agbno, blks_per_cluster,
-				&oinfo);
+				&XFS_RMAP_OINFO_INODES);
 
 		/* Grab the inode cluster buffer. */
 		imap.im_blkno = XFS_AGB_TO_DADDR(mp, bs->cur->bc_private.a.agno,
@@ -366,7 +362,6 @@ xchk_iallocbt_xref_rmap_btreeblks(
 	struct xfs_scrub	*sc,
 	int			which)
 {
-	struct xfs_owner_info	oinfo;
 	xfs_filblks_t		blocks;
 	xfs_extlen_t		inobt_blocks = 0;
 	xfs_extlen_t		finobt_blocks = 0;
@@ -388,9 +383,8 @@ xchk_iallocbt_xref_rmap_btreeblks(
 			return;
 	}
 
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
-	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, &oinfo,
-			&blocks);
+	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur,
+			&XFS_RMAP_OINFO_INOBT, &blocks);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
 		return;
 	if (blocks != inobt_blocks + finobt_blocks)
@@ -407,7 +401,6 @@ xchk_iallocbt_xref_rmap_inodes(
 	int			which,
 	xfs_filblks_t		inode_blocks)
 {
-	struct xfs_owner_info	oinfo;
 	xfs_filblks_t		blocks;
 	int			error;
 
@@ -415,9 +408,8 @@ xchk_iallocbt_xref_rmap_inodes(
 		return;
 
 	/* Check that we saw as many inode blocks as the rmap knows about. */
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
-	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, &oinfo,
-			&blocks);
+	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur,
+			&XFS_RMAP_OINFO_INODES, &blocks);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
 		return;
 	if (blocks != inode_blocks)
@@ -431,13 +423,11 @@ xchk_iallocbt(
 	xfs_btnum_t		which)
 {
 	struct xfs_btree_cur	*cur;
-	struct xfs_owner_info	oinfo;
 	xfs_filblks_t		inode_blocks = 0;
 	int			error;
 
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
 	cur = which == XFS_BTNUM_INO ? sc->sa.ino_cur : sc->sa.fino_cur;
-	error = xchk_btree(sc, cur, xchk_iallocbt_rec, &oinfo,
+	error = xchk_btree(sc, cur, xchk_iallocbt_rec, &XFS_RMAP_OINFO_INOBT,
 			&inode_blocks);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index e386c9b0b4ab..e213efc194a1 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -509,7 +509,6 @@ xchk_inode_xref(
 	xfs_ino_t		ino,
 	struct xfs_dinode	*dip)
 {
-	struct xfs_owner_info	oinfo;
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
 	int			error;
@@ -526,8 +525,7 @@ xchk_inode_xref(
 
 	xchk_xref_is_used_space(sc, agbno, 1);
 	xchk_inode_xref_finobt(sc, ino);
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
-	xchk_xref_is_owned_by(sc, agbno, 1, &oinfo);
+	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_INODES);
 	xchk_xref_is_not_shared(sc, agbno, 1);
 	xchk_inode_xref_bmap(sc, dip);
 
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index b7ade620acee..708b4158eb90 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -385,7 +385,6 @@ xchk_refcount_xref_rmap(
 	struct xfs_scrub	*sc,
 	xfs_filblks_t		cow_blocks)
 {
-	struct xfs_owner_info	oinfo;
 	xfs_extlen_t		refcbt_blocks = 0;
 	xfs_filblks_t		blocks;
 	int			error;
@@ -394,21 +393,19 @@ xchk_refcount_xref_rmap(
 		return;
 
 	/* Check that we saw as many refcbt blocks as the rmap knows about. */
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_REFC);
 	error = xfs_btree_count_blocks(sc->sa.refc_cur, &refcbt_blocks);
 	if (!xchk_btree_process_error(sc, sc->sa.refc_cur, 0, &error))
 		return;
-	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, &oinfo,
-			&blocks);
+	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur,
+			&XFS_RMAP_OINFO_REFC, &blocks);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
 		return;
 	if (blocks != refcbt_blocks)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
 
 	/* Check that we saw as many cow blocks as the rmap knows about. */
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_COW);
-	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, &oinfo,
-			&blocks);
+	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur,
+			&XFS_RMAP_OINFO_COW, &blocks);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
 		return;
 	if (blocks != cow_blocks)
@@ -420,13 +417,11 @@ int
 xchk_refcountbt(
 	struct xfs_scrub	*sc)
 {
-	struct xfs_owner_info	oinfo;
 	xfs_agblock_t		cow_blocks = 0;
 	int			error;
 
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_REFC);
 	error = xchk_btree(sc, sc->sa.refc_cur, xchk_refcountbt_rec,
-			&oinfo, &cow_blocks);
+			&XFS_RMAP_OINFO_REFC, &cow_blocks);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 90ae9e173de7..1c8eecfe52b8 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -505,7 +505,6 @@ xrep_put_freelist(
 	struct xfs_scrub	*sc,
 	xfs_agblock_t		agbno)
 {
-	struct xfs_owner_info	oinfo;
 	int			error;
 
 	/* Make sure there's space on the freelist. */
@@ -518,9 +517,8 @@ xrep_put_freelist(
 	 * create an rmap for the block prior to merging it or else other
 	 * parts will break.
 	 */
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
 	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.agno, agbno, 1,
-			&oinfo);
+			&XFS_RMAP_OINFO_AG);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 8a5bf15d544d..92a140c5b55e 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -174,11 +174,8 @@ int
 xchk_rmapbt(
 	struct xfs_scrub	*sc)
 {
-	struct xfs_owner_info	oinfo;
-
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
 	return xchk_btree(sc, sc->sa.rmap_cur, xchk_rmapbt_rec,
-			&oinfo, NULL);
+			&XFS_RMAP_OINFO_AG, NULL);
 }
 
 /* xref check that the extent is owned by a given owner */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index d9da66c718bb..74ddf66f4cfe 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -494,7 +494,6 @@ xfs_efi_recover(
 	int			error = 0;
 	xfs_extent_t		*extp;
 	xfs_fsblock_t		startblock_fsb;
-	struct xfs_owner_info	oinfo;
 
 	ASSERT(!test_bit(XFS_EFI_RECOVERED, &efip->efi_flags));
 
@@ -526,11 +525,11 @@ xfs_efi_recover(
 		return error;
 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
 
-	xfs_rmap_any_owner_update(&oinfo);
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
 		extp = &efip->efi_format.efi_extents[i];
 		error = xfs_trans_free_extent(tp, efdp, extp->ext_start,
-					      extp->ext_len, &oinfo, false);
+					      extp->ext_len,
+					      &XFS_RMAP_OINFO_ANY_OWNER, false);
 		if (error)
 			goto abort_error;
 
