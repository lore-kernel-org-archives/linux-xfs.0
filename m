Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE59B85291
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817163; cv=none; b=e8JuwoY8BFa3gyVrhhLJQ0L+KW9x5GLydBHFTiywuKqdldhh5z5HstX+jg/pvg8GSAe6tQheaqdXBvRqcY2VeJAxCl3X7GwBEdfYYrRcSNDwj4mlHYGENhMs0ci+1Ak2RH5rbHhqLVy2uRIecwTBn0CsMd3/DcH+ypEM2xE9CYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817163; c=relaxed/simple;
	bh=3YkgNTuchGlAbl+chCgQyzIo9+Zw0dal8WQPq5i32rU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dFikRyfErkmwjoF+6OvAIk7Wpu7+RIq6n+6UmT4A1JZ+720ALBJeut3BEZpu29bU4Ph8kG9NXBDgsRhJ542AOR6UCq2Fo5cEWw6HEmyYqFFNaGRq9N01IsG9FvVOWRIbaBBrJ8IqNC76/QW6nzQtaZCLNUGJ2yqO6cUr/1J/Utc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sAsBnf2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sAsBnf2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6ECC433C7;
	Thu,  1 Feb 2024 19:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817162;
	bh=3YkgNTuchGlAbl+chCgQyzIo9+Zw0dal8WQPq5i32rU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sAsBnf2No3QTFF1T9Zhc82kNp5N8JOI1ghqr7GfkB9w7oXo/pI3AA/wU1C8NTrBUW
	 0IKOfod0WinoIKa0M6BtIqyuRpXv/k6hhJZOUa75lMwEBFwiI9ygi99OL24Uwu1Oil
	 KDrR2o0Xw7tIpMhjZMW6gPmZo2WezD69bX+aFrJPuz/X405iPfAyQomidHPXS66kqw
	 XUn0tN0fpFV/9QrW6MrVDVjSUgHFPVOundvzRpBm2t0f3jz8R+Zmr/qlRbCclV0pnl
	 dJp4nY22XJGwxRXqnPZ7dhg6k6K0+mfJbp1Lh1RvMmIAnARKZhMEZ8HXQYlAlCOY4P
	 qy5UgUxv+d42w==
Date: Thu, 01 Feb 2024 11:52:42 -0800
Subject: [PATCH 27/27] xfs: remove xfs_btnum_t
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335228.1605438.17748936583757359670.stgit@frogsfrogsfrogs>
In-Reply-To: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
References: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

The last checks for bc_btnum can be replaced with helpers that check
the btree ops.  This allows adding new btrees to XFS without having
to update a global enum.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: complete the ops predicates]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c          |    6 +++---
 fs/xfs/libxfs/xfs_alloc_btree.c    |   12 ++++++------
 fs/xfs/libxfs/xfs_bmap_btree.c     |    4 ++--
 fs/xfs/libxfs/xfs_btree.c          |    4 ++--
 fs/xfs/libxfs/xfs_btree.h          |   11 -----------
 fs/xfs/libxfs/xfs_ialloc.c         |    2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   10 +++++-----
 fs/xfs/libxfs/xfs_refcount_btree.c |    5 ++---
 fs/xfs/libxfs/xfs_rmap_btree.c     |    2 +-
 fs/xfs/libxfs/xfs_shared.h         |   35 +++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_types.h          |    9 ---------
 fs/xfs/scrub/btree.c               |   10 ++++------
 fs/xfs/scrub/ialloc.c              |    6 +++---
 fs/xfs/scrub/trace.h               |    8 --------
 fs/xfs/xfs_health.c                |    2 +-
 fs/xfs/xfs_trace.h                 |    9 ---------
 16 files changed, 65 insertions(+), 70 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 2b74aded4a2c7..9da52e92172ab 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -918,7 +918,7 @@ xfs_alloc_cur_check(
 	bool			busy;
 	unsigned		busy_gen = 0;
 	bool			deactivate = false;
-	bool			isbnobt = cur->bc_btnum == XFS_BTNUM_BNO;
+	bool			isbnobt = xfs_btree_is_bno(cur->bc_ops);
 
 	*new = 0;
 
@@ -4026,7 +4026,7 @@ xfs_alloc_query_range(
 	union xfs_btree_irec			high_brec = { .a = *high_rec };
 	struct xfs_alloc_query_range_info	query = { .priv = priv, .fn = fn };
 
-	ASSERT(cur->bc_btnum == XFS_BTNUM_BNO);
+	ASSERT(xfs_btree_is_bno(cur->bc_ops));
 	return xfs_btree_query_range(cur, &low_brec, &high_brec,
 			xfs_alloc_query_range_helper, &query);
 }
@@ -4040,7 +4040,7 @@ xfs_alloc_query_all(
 {
 	struct xfs_alloc_query_range_info	query;
 
-	ASSERT(cur->bc_btnum == XFS_BTNUM_BNO);
+	ASSERT(xfs_btree_is_bno(cur->bc_ops));
 	query.priv = priv;
 	query.fn = fn;
 	return xfs_btree_query_all(cur, xfs_alloc_query_range_helper, &query);
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 7228634642897..885c7db5d6e73 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -51,7 +51,7 @@ xfs_allocbt_set_root(
 
 	ASSERT(ptr->s != 0);
 
-	if (cur->bc_btnum == XFS_BTNUM_BNO) {
+	if (xfs_btree_is_bno(cur->bc_ops)) {
 		agf->agf_bno_root = ptr->s;
 		be32_add_cpu(&agf->agf_bno_level, inc);
 		cur->bc_ag.pag->pagf_bno_level += inc;
@@ -131,7 +131,7 @@ xfs_allocbt_update_lastrec(
 	__be32			len;
 	int			numrecs;
 
-	ASSERT(cur->bc_btnum == XFS_BTNUM_CNT);
+	ASSERT(!xfs_btree_is_bno(cur->bc_ops));
 
 	switch (reason) {
 	case LASTREC_UPDATE:
@@ -241,7 +241,7 @@ xfs_allocbt_init_ptr_from_cur(
 
 	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 
-	if (cur->bc_btnum == XFS_BTNUM_BNO)
+	if (xfs_btree_is_bno(cur->bc_ops))
 		ptr->s = agf->agf_bno_root;
 	else
 		ptr->s = agf->agf_cnt_root;
@@ -554,7 +554,7 @@ xfs_bnobt_init_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BNO, &xfs_bnobt_ops,
+	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_bnobt_ops,
 			mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.agbp = agbp;
@@ -580,7 +580,7 @@ xfs_cntbt_init_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_CNT, &xfs_cntbt_ops,
+	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_cntbt_ops,
 			mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.agbp = agbp;
@@ -607,7 +607,7 @@ xfs_allocbt_commit_staged_btree(
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
 
-	if (cur->bc_btnum == XFS_BTNUM_BNO) {
+	if (xfs_btree_is_bno(cur->bc_ops)) {
 		agf->agf_bno_root = cpu_to_be32(afake->af_root);
 		agf->agf_bno_level = cpu_to_be32(afake->af_levels);
 	} else {
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 25193551e95b4..54fdf0df8ec35 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -574,8 +574,8 @@ xfs_bmbt_init_cursor(
 		maxlevels = mp->m_bm_maxlevels[whichfork];
 		break;
 	}
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP, &xfs_bmbt_ops,
-			maxlevels, xfs_bmbt_cur_cache);
+	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_bmbt_ops, maxlevels,
+			xfs_bmbt_cur_cache);
 	cur->bc_ino.ip = ip;
 	cur->bc_ino.whichfork = whichfork;
 	cur->bc_bmap.allocated = 0;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 278461d0f64d0..769be61ad63f3 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -454,7 +454,7 @@ xfs_btree_del_cursor(
 	 * zero, then we should be shut down or on our way to shutdown due to
 	 * cancelling a dirty transaction on error.
 	 */
-	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_bmap.allocated == 0 ||
+	ASSERT(!xfs_btree_is_bmap(cur->bc_ops) || cur->bc_bmap.allocated == 0 ||
 	       xfs_is_shutdown(cur->bc_mp) || error != 0);
 
 	switch (cur->bc_ops->type) {
@@ -3016,7 +3016,7 @@ xfs_btree_split(
 	struct xfs_btree_split_args	args;
 	DECLARE_COMPLETION_ONSTACK(done);
 
-	if (cur->bc_btnum != XFS_BTNUM_BMAP ||
+	if (!xfs_btree_is_bmap(cur->bc_ops) ||
 	    cur->bc_tp->t_highest_agno == NULLAGNUMBER)
 		return __xfs_btree_split(cur, level, ptrp, key, curp, stat);
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 01d6eac267655..c1d8d9895d15d 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -55,14 +55,6 @@ union xfs_btree_rec {
 #define	XFS_LOOKUP_LE	((xfs_lookup_t)XFS_LOOKUP_LEi)
 #define	XFS_LOOKUP_GE	((xfs_lookup_t)XFS_LOOKUP_GEi)
 
-#define	XFS_BTNUM_BNO	((xfs_btnum_t)XFS_BTNUM_BNOi)
-#define	XFS_BTNUM_CNT	((xfs_btnum_t)XFS_BTNUM_CNTi)
-#define	XFS_BTNUM_BMAP	((xfs_btnum_t)XFS_BTNUM_BMAPi)
-#define	XFS_BTNUM_INO	((xfs_btnum_t)XFS_BTNUM_INOi)
-#define	XFS_BTNUM_FINO	((xfs_btnum_t)XFS_BTNUM_FINOi)
-#define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
-#define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
-
 struct xfs_btree_ops;
 uint32_t xfs_btree_magic(struct xfs_mount *mp, const struct xfs_btree_ops *ops);
 
@@ -272,7 +264,6 @@ struct xfs_btree_cur
 	const struct xfs_btree_ops *bc_ops;
 	struct kmem_cache	*bc_cache; /* cursor cache */
 	unsigned int		bc_flags; /* btree features - below */
-	xfs_btnum_t		bc_btnum; /* identifies which btree type */
 	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
 	uint8_t			bc_nlevels; /* number of levels in the tree */
 	uint8_t			bc_maxlevels; /* maximum levels for this btree type */
@@ -726,7 +717,6 @@ static inline struct xfs_btree_cur *
 xfs_btree_alloc_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_btnum_t		btnum,
 	const struct xfs_btree_ops *ops,
 	uint8_t			maxlevels,
 	struct kmem_cache	*cache)
@@ -740,7 +730,6 @@ xfs_btree_alloc_cursor(
 	cur->bc_ops = ops;
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
-	cur->bc_btnum = btnum;
 	cur->bc_maxlevels = maxlevels;
 	cur->bc_cache = cache;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index e6decc37ff18b..e5ac3e5430c4e 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2848,7 +2848,7 @@ xfs_ialloc_count_inodes(
 	struct xfs_ialloc_count_inodes	ci = {0};
 	int				error;
 
-	ASSERT(cur->bc_btnum == XFS_BTNUM_INO);
+	ASSERT(xfs_btree_is_ino(cur->bc_ops));
 	error = xfs_btree_query_all(cur, xfs_ialloc_count_inodes_rec, &ci);
 	if (error)
 		return error;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 9cb5da9be9044..74f144b2db68a 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -90,9 +90,9 @@ xfs_inobt_mod_blockcount(
 	if (!xfs_has_inobtcounts(cur->bc_mp))
 		return;
 
-	if (cur->bc_btnum == XFS_BTNUM_FINO)
+	if (xfs_btree_is_fino(cur->bc_ops))
 		be32_add_cpu(&agi->agi_fblocks, howmuch);
-	else if (cur->bc_btnum == XFS_BTNUM_INO)
+	else
 		be32_add_cpu(&agi->agi_iblocks, howmuch);
 	xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_IBLOCKS);
 }
@@ -481,7 +481,7 @@ xfs_inobt_init_cursor(
 	struct xfs_mount	*mp = pag->pag_mount;
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_INO, &xfs_inobt_ops,
+	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_inobt_ops,
 			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.agbp = agbp;
@@ -507,7 +507,7 @@ xfs_finobt_init_cursor(
 	struct xfs_mount	*mp = pag->pag_mount;
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_FINO, &xfs_finobt_ops,
+	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_finobt_ops,
 			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.agbp = agbp;
@@ -535,7 +535,7 @@ xfs_inobt_commit_staged_btree(
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
 
-	if (cur->bc_btnum == XFS_BTNUM_INO) {
+	if (xfs_btree_is_ino(cur->bc_ops)) {
 		fields = XFS_AGI_ROOT | XFS_AGI_LEVEL;
 		agi->agi_root = cpu_to_be32(afake->af_root);
 		agi->agi_level = cpu_to_be32(afake->af_levels);
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 6388a0c9b6915..f93dae3db7012 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -364,9 +364,8 @@ xfs_refcountbt_init_cursor(
 
 	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_REFC,
-			&xfs_refcountbt_ops, mp->m_refc_maxlevels,
-			xfs_refcountbt_cur_cache);
+	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_refcountbt_ops,
+			mp->m_refc_maxlevels, xfs_refcountbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_refc.nr_ops = 0;
 	cur->bc_refc.shape_changes = 0;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index abaf5e190e998..b1ecc061fdc9c 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -518,7 +518,7 @@ xfs_rmapbt_init_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP, &xfs_rmapbt_ops,
+	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_rmapbt_ops,
 			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.agbp = agbp;
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 518ea9456ebae..6b8bc276d4616 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -52,6 +52,41 @@ extern const struct xfs_btree_ops xfs_bmbt_ops;
 extern const struct xfs_btree_ops xfs_refcountbt_ops;
 extern const struct xfs_btree_ops xfs_rmapbt_ops;
 
+static inline bool xfs_btree_is_bno(const struct xfs_btree_ops *ops)
+{
+	return ops == &xfs_bnobt_ops;
+}
+
+static inline bool xfs_btree_is_cnt(const struct xfs_btree_ops *ops)
+{
+	return ops == &xfs_cntbt_ops;
+}
+
+static inline bool xfs_btree_is_bmap(const struct xfs_btree_ops *ops)
+{
+	return ops == &xfs_bmbt_ops;
+}
+
+static inline bool xfs_btree_is_ino(const struct xfs_btree_ops *ops)
+{
+	return ops == &xfs_inobt_ops;
+}
+
+static inline bool xfs_btree_is_fino(const struct xfs_btree_ops *ops)
+{
+	return ops == &xfs_finobt_ops;
+}
+
+static inline bool xfs_btree_is_refcount(const struct xfs_btree_ops *ops)
+{
+	return ops == &xfs_refcountbt_ops;
+}
+
+static inline bool xfs_btree_is_rmap(const struct xfs_btree_ops *ops)
+{
+	return ops == &xfs_rmapbt_ops;
+}
+
 /* log size calculation functions */
 int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
 int	xfs_log_calc_minimum_size(struct xfs_mount *);
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index f577247b748d3..76eb9e328835f 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -116,15 +116,6 @@ typedef enum {
 	{ XFS_LOOKUP_LEi,	"le" }, \
 	{ XFS_LOOKUP_GEi,	"ge" }
 
-/*
- * This enum is used in string mapping in xfs_trace.h and scrub/trace.h;
- * please keep the TRACE_DEFINE_ENUMs for it up to date.
- */
-typedef enum {
-	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
-	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
-} xfs_btnum_t;
-
 struct xfs_name {
 	const unsigned char	*name;
 	int			len;
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 1ec3339755b92..187d692a0b58a 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -374,14 +374,12 @@ xchk_btree_check_block_owner(
 {
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
-	xfs_btnum_t		btnum;
 	bool			init_sa;
 	int			error = 0;
 
 	if (!bs->cur)
 		return 0;
 
-	btnum = bs->cur->bc_btnum;
 	agno = xfs_daddr_to_agno(bs->cur->bc_mp, daddr);
 	agbno = xfs_daddr_to_agbno(bs->cur->bc_mp, daddr);
 
@@ -404,11 +402,11 @@ xchk_btree_check_block_owner(
 	 * have to nullify it (to shut down further block owner checks) if
 	 * self-xref encounters problems.
 	 */
-	if (!bs->sc->sa.bno_cur && btnum == XFS_BTNUM_BNO)
+	if (!bs->sc->sa.bno_cur && xfs_btree_is_bno(bs->cur->bc_ops))
 		bs->cur = NULL;
 
 	xchk_xref_is_only_owned_by(bs->sc, agbno, 1, bs->oinfo);
-	if (!bs->sc->sa.rmap_cur && btnum == XFS_BTNUM_RMAP)
+	if (!bs->sc->sa.rmap_cur && xfs_btree_is_rmap(bs->cur->bc_ops))
 		bs->cur = NULL;
 
 out_free:
@@ -447,7 +445,7 @@ xchk_btree_check_owner(
 	 * duplicate cursors.  Therefore, save the buffer daddr for
 	 * later scanning.
 	 */
-	if (cur->bc_btnum == XFS_BTNUM_BNO || cur->bc_btnum == XFS_BTNUM_RMAP) {
+	if (xfs_btree_is_bno(cur->bc_ops) || xfs_btree_is_rmap(cur->bc_ops)) {
 		struct check_owner	*co;
 
 		co = kmalloc(sizeof(struct check_owner), XCHK_GFP_FLAGS);
@@ -480,7 +478,7 @@ xchk_btree_check_iroot_minrecs(
 	 * existing filesystems, so instead we disable the check for data fork
 	 * bmap btrees when there's an attr fork.
 	 */
-	if (bs->cur->bc_btnum == XFS_BTNUM_BMAP &&
+	if (xfs_btree_is_bmap(bs->cur->bc_ops) &&
 	    bs->cur->bc_ino.whichfork == XFS_DATA_FORK &&
 	    xfs_inode_has_attr_fork(bs->sc->ip))
 		return false;
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 26d589e9ba1c3..750d7b0cd25a7 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -76,7 +76,7 @@ xchk_inobt_xref_finobt(
 	int			has_record;
 	int			error;
 
-	ASSERT(cur->bc_btnum == XFS_BTNUM_FINO);
+	ASSERT(xfs_btree_is_fino(cur->bc_ops));
 
 	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &has_record);
 	if (error)
@@ -179,7 +179,7 @@ xchk_finobt_xref_inobt(
 	int			has_record;
 	int			error;
 
-	ASSERT(cur->bc_btnum == XFS_BTNUM_INO);
+	ASSERT(xfs_btree_is_ino(cur->bc_ops));
 
 	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &has_record);
 	if (error)
@@ -514,7 +514,7 @@ xchk_iallocbt_rec_alignment(
 	 * Otherwise, we expect that the finobt record is aligned to the
 	 * cluster alignment as told by the superblock.
 	 */
-	if (bs->cur->bc_btnum == XFS_BTNUM_FINO) {
+	if (xfs_btree_is_fino(bs->cur->bc_ops)) {
 		unsigned int	imask;
 
 		imask = min_t(unsigned int, XFS_INODES_PER_CHUNK,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 2c2f99d8772cb..b840f25c03d6f 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -32,14 +32,6 @@ struct xchk_fscounters;
  * ring buffer.  Somehow this was only worth mentioning in the ftrace sample
  * code.
  */
-TRACE_DEFINE_ENUM(XFS_BTNUM_BNOi);
-TRACE_DEFINE_ENUM(XFS_BTNUM_CNTi);
-TRACE_DEFINE_ENUM(XFS_BTNUM_BMAPi);
-TRACE_DEFINE_ENUM(XFS_BTNUM_INOi);
-TRACE_DEFINE_ENUM(XFS_BTNUM_FINOi);
-TRACE_DEFINE_ENUM(XFS_BTNUM_RMAPi);
-TRACE_DEFINE_ENUM(XFS_BTNUM_REFCi);
-
 TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_SHARED);
 TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_COW);
 
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index c5ed6ff08a616..9729dc56c6c9a 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -516,7 +516,7 @@ xfs_btree_mark_sick(
 		xfs_ag_mark_sick(cur->bc_ag.pag, cur->bc_ops->sick_mask);
 		return;
 	case XFS_BTREE_TYPE_INODE:
-		if (cur->bc_btnum == XFS_BTNUM_BMAP) {
+		if (xfs_btree_is_bmap(cur->bc_ops)) {
 			xfs_bmap_mark_sick(cur->bc_ino.ip,
 					   cur->bc_ino.whichfork);
 			return;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index feb681a1eed1a..630eb641d497e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2450,15 +2450,6 @@ DEFINE_DISCARD_EVENT(xfs_discard_toosmall);
 DEFINE_DISCARD_EVENT(xfs_discard_exclude);
 DEFINE_DISCARD_EVENT(xfs_discard_busy);
 
-/* btree cursor events */
-TRACE_DEFINE_ENUM(XFS_BTNUM_BNOi);
-TRACE_DEFINE_ENUM(XFS_BTNUM_CNTi);
-TRACE_DEFINE_ENUM(XFS_BTNUM_BMAPi);
-TRACE_DEFINE_ENUM(XFS_BTNUM_INOi);
-TRACE_DEFINE_ENUM(XFS_BTNUM_FINOi);
-TRACE_DEFINE_ENUM(XFS_BTNUM_RMAPi);
-TRACE_DEFINE_ENUM(XFS_BTNUM_REFCi);
-
 DECLARE_EVENT_CLASS(xfs_btree_cur_class,
 	TP_PROTO(struct xfs_btree_cur *cur, int level, struct xfs_buf *bp),
 	TP_ARGS(cur, level, bp),

