Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1FB19ABC6
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528082; cv=none; b=Pts9PODqEkJkfdvpn6+0twNC7Pru3O4fpucg9KDojGhp48WYGb/uSI41HguwwSXxDO365MD18dJNCA/MbH/g9aGLHMzaH8bIdw9jeq2OGBfF1mEHBkAZBPOWHGImqI6dcAJ8vaKEL8Ev6+gfOsVh3NP/ogvXX6MfTNM+Wy1AIgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528082; c=relaxed/simple;
	bh=03b6bvIzDIWUT/6CD/uSRAo4qT7p+t7mH0FyxxOz1lE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W2rsGgW8/EXIRs07VAFSmSUsdEF2hAvUfqRBvHoVAVkJBFjNSe7r+Z42UekqjvN3oNrt308/QaGROhGr37S0lo2iBkimT1063ToYTokx1ZQvvFvdRTEEl/t0YVahozKHGDQfkXsGL08n3bm5eWetdd7mw5N2toHxcjn0zFuGM0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BjUSutIp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BjUSutIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518E1C4CED1;
	Fri,  6 Dec 2024 23:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528082;
	bh=03b6bvIzDIWUT/6CD/uSRAo4qT7p+t7mH0FyxxOz1lE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BjUSutIp8Hkw8dOKgE7Te0mdVhBaGTD3s7CQUldfHNGjldPm0m0dQBrjqCNcouG55
	 6XsK/DTAT+/TW6J5rth6wdPRPl3gORH2N9sUtU+3vYQbLmeC2+hwnRGrbKB9vOFy5R
	 zB9OCtd+h2rwOwt/2WaNXEZRze0JWfVsuH+lrgQKsey8iUyPDU20Ptlk36oKfeg0nJ
	 oBcIjkjhHEvj/GW/lA83C/AdupjagSEiLtxFuaz5D1J9FFK/pqcVv7mfjEjU5CSs9g
	 DXQMrnIM55afDe8T1QO2c1n+/ARHT2fW50p7bgHYgTMNxtKYrKo2l3tTefrKDNAZy8
	 QxF1D2UHP+wGg==
Date: Fri, 06 Dec 2024 15:34:41 -0800
Subject: [PATCH 17/36] xfs: switch perag iteration from the for_each macros to
 a while based iterator
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747139.121772.12867537320145180139.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 86437e6abbd2ef040f42ef190264819db6118415

The current for_each_perag* macros are a bit annoying in that they
require the caller to both provide an object and an index iterator, and
also somewhat obsfucate the underlying control flow mechanism.

Switch to open coded while loops using new xfs_perag_next{,_from,_range}
helpers that return the next pag structure to iterate on based on the
previous one or NULL for the loop start.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/fsmap.c           |    4 ++-
 db/info.c            |    5 ++--
 db/iunlink.c         |    4 ++-
 libxfs/xfs_ag.h      |   62 +++++++++++++++++++++++---------------------------
 libxfs/xfs_sb.c      |   15 ++++--------
 libxfs/xfs_types.c   |    5 ++--
 repair/bmap_repair.c |    5 ++--
 repair/phase2.c      |    7 ++----
 repair/phase5.c      |    4 ++-
 9 files changed, 48 insertions(+), 63 deletions(-)


diff --git a/db/fsmap.c b/db/fsmap.c
index 923d7568b9d977..a9259c4632185b 100644
--- a/db/fsmap.c
+++ b/db/fsmap.c
@@ -46,7 +46,7 @@ fsmap(
 	struct xfs_rmap_irec	high = {0};
 	struct xfs_btree_cur	*bt_cur;
 	struct xfs_buf		*agbp;
-	struct xfs_perag	*pag;
+	struct xfs_perag	*pag = NULL;
 	int			error;
 
 	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
@@ -63,7 +63,7 @@ fsmap(
 	end_ag = XFS_FSB_TO_AGNO(mp, end_fsb);
 
 	info.nr = 0;
-	for_each_perag_range(mp, start_ag, end_ag, pag) {
+	while ((pag = xfs_perag_next_range(mp, pag, start_ag, end_ag))) {
 		if (pag_agno(pag) == end_ag)
 			high.rm_startblock = XFS_FSB_TO_AGBNO(mp, end_fsb);
 
diff --git a/db/info.c b/db/info.c
index 6a8765ec761a49..9a86d247839f84 100644
--- a/db/info.c
+++ b/db/info.c
@@ -104,8 +104,7 @@ agresv_f(
 	int			argc,
 	char			**argv)
 {
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag = NULL;
 	int			i;
 
 	if (argc > 1) {
@@ -134,7 +133,7 @@ agresv_f(
 		return 0;
 	}
 
-	for_each_perag(mp, agno, pag)
+	while ((pag = xfs_perag_next(mp, pag)))
 		print_agresv_info(pag);
 
 	return 0;
diff --git a/db/iunlink.c b/db/iunlink.c
index c9977a859e2842..c73f818242b983 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -144,7 +144,7 @@ dump_iunlinked_f(
 	int			argc,
 	char			**argv)
 {
-	struct xfs_perag	*pag;
+	struct xfs_perag	*pag = NULL;
 	xfs_agnumber_t		agno = NULLAGNUMBER;
 	unsigned int		bucket = -1U;
 	bool			quiet = false;
@@ -189,7 +189,7 @@ dump_iunlinked_f(
 		return 0;
 	}
 
-	for_each_perag(mp, agno, pag)
+	while ((pag = xfs_perag_next(mp, pag)))
 		dump_unlinked(pag, bucket, quiet, verbose);
 
 	return 0;
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 69b934ad2c4aad..80969682dc4746 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -208,6 +208,34 @@ xfs_perag_rele(
 	xfs_group_rele(pag_group(pag));
 }
 
+static inline struct xfs_perag *
+xfs_perag_next_range(
+	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
+	xfs_agnumber_t		start_agno,
+	xfs_agnumber_t		end_agno)
+{
+	return to_perag(xfs_group_next_range(mp, pag ? pag_group(pag) : NULL,
+			start_agno, end_agno, XG_TYPE_AG));
+}
+
+static inline struct xfs_perag *
+xfs_perag_next_from(
+	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
+	xfs_agnumber_t		start_agno)
+{
+	return xfs_perag_next_range(mp, pag, start_agno, mp->m_sb.sb_agcount - 1);
+}
+
+static inline struct xfs_perag *
+xfs_perag_next(
+	struct xfs_mount	*mp,
+	struct xfs_perag	*pag)
+{
+	return xfs_perag_next_from(mp, pag, 0);
+}
+
 /*
  * Per-ag geometry infomation and validation
  */
@@ -273,40 +301,6 @@ xfs_ag_contains_log(struct xfs_mount *mp, xfs_agnumber_t agno)
 	       agno == XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart);
 }
 
-/*
- * Perag iteration APIs
- */
-static inline struct xfs_perag *
-xfs_perag_next(
-	struct xfs_perag	*pag,
-	xfs_agnumber_t		*agno,
-	xfs_agnumber_t		end_agno)
-{
-	struct xfs_mount	*mp = pag_mount(pag);
-
-	*agno = pag_agno(pag) + 1;
-	xfs_perag_rele(pag);
-	while (*agno <= end_agno) {
-		pag = xfs_perag_grab(mp, *agno);
-		if (pag)
-			return pag;
-		(*agno)++;
-	}
-	return NULL;
-}
-
-#define for_each_perag_range(mp, agno, end_agno, pag) \
-	for ((pag) = xfs_perag_grab((mp), (agno)); \
-		(pag) != NULL; \
-		(pag) = xfs_perag_next((pag), &(agno), (end_agno)))
-
-#define for_each_perag_from(mp, agno, pag) \
-	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
-
-#define for_each_perag(mp, agno, pag) \
-	(agno) = 0; \
-	for_each_perag_from((mp), (agno), (pag))
-
 static inline struct xfs_perag *
 xfs_perag_next_wrap(
 	struct xfs_perag	*pag,
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index f534ae5d4c4db2..d32f789037389f 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1120,14 +1120,13 @@ int
 xfs_update_secondary_sbs(
 	struct xfs_mount	*mp)
 {
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno = 1;
+	struct xfs_perag	*pag = NULL;
 	int			saved_error = 0;
 	int			error = 0;
 	LIST_HEAD		(buffer_list);
 
 	/* update secondary superblocks. */
-	for_each_perag_from(mp, agno, pag) {
+	while ((pag = xfs_perag_next_from(mp, pag, 1))) {
 		struct xfs_buf		*bp;
 
 		error = xfs_buf_get(mp->m_ddev_targp,
@@ -1157,7 +1156,7 @@ xfs_update_secondary_sbs(
 		xfs_buf_relse(bp);
 
 		/* don't hold too many buffers at once */
-		if (agno % 16)
+		if (pag_agno(pag) % 16)
 			continue;
 
 		error = xfs_buf_delwri_submit(&buffer_list);
@@ -1171,12 +1170,8 @@ xfs_update_secondary_sbs(
 		}
 	}
 	error = xfs_buf_delwri_submit(&buffer_list);
-	if (error) {
-		xfs_warn(mp,
-		"write error %d updating a secondary superblock near ag %d",
-			error, agno);
-	}
-
+	if (error)
+		xfs_warn(mp, "error %d writing secondary superblocks", error);
 	return saved_error ? saved_error : error;
 }
 
diff --git a/libxfs/xfs_types.c b/libxfs/xfs_types.c
index 74ab1965a8f49c..0d1b86ae59d93e 100644
--- a/libxfs/xfs_types.c
+++ b/libxfs/xfs_types.c
@@ -170,13 +170,12 @@ xfs_icount_range(
 	unsigned long long	*max)
 {
 	unsigned long long	nr_inos = 0;
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag = NULL;
 
 	/* root, rtbitmap, rtsum all live in the first chunk */
 	*min = XFS_INODES_PER_CHUNK;
 
-	for_each_perag(mp, agno, pag)
+	while ((pag = xfs_perag_next(mp, pag)))
 		nr_inos += pag->agino_max - pag->agino_min + 1;
 	*max = nr_inos;
 }
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index 7ccbb96fa8dc5e..3a214c85a1de5f 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -218,12 +218,11 @@ STATIC int
 xrep_bmap_find_mappings(
 	struct xrep_bmap	*rb)
 {
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag = NULL;
 	int			error;
 
 	/* Iterate the rmaps for extents. */
-	for_each_perag(rb->sc->mp, agno, pag) {
+	while ((pag = xfs_perag_next(rb->sc->mp, pag))) {
 		error = xrep_bmap_scan_ag(rb, pag);
 		if (error) {
 			libxfs_perag_put(pag);
diff --git a/repair/phase2.c b/repair/phase2.c
index 42a2861dcc3714..17966bb54db09d 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -274,12 +274,11 @@ check_fs_free_space(
 	const struct check_state	*old,
 	struct xfs_sb			*new_sb)
 {
-	struct xfs_perag		*pag;
-	xfs_agnumber_t			agno;
+	struct xfs_perag		*pag = NULL;
 	int				error;
 
 	/* Make sure we have enough space for per-AG reservations. */
-	for_each_perag(mp, agno, pag) {
+	while ((pag = xfs_perag_next(mp, pag))) {
 		struct xfs_trans	*tp;
 		struct xfs_agf		*agf;
 		struct xfs_buf		*agi_bp, *agf_bp;
@@ -365,7 +364,7 @@ check_fs_free_space(
 	 * uninitialized so that we don't trip over stale cached counters
 	 * after the upgrade/
 	 */
-	for_each_perag(mp, agno, pag) {
+	while ((pag = xfs_perag_next(mp, pag))) {
 		libxfs_ag_resv_free(pag);
 		clear_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
 		clear_bit(XFS_AGSTATE_AGI_INIT, &pag->pag_opstate);
diff --git a/repair/phase5.c b/repair/phase5.c
index fdbd9f56998fb4..86b1f681a72bb8 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -632,7 +632,7 @@ void
 phase5(xfs_mount_t *mp)
 {
 	struct bitmap		*lost_blocks = NULL;
-	struct xfs_perag	*pag;
+	struct xfs_perag	*pag = NULL;
 	xfs_agnumber_t		agno;
 	int			error;
 
@@ -679,7 +679,7 @@ phase5(xfs_mount_t *mp)
 	if (error)
 		do_error(_("cannot alloc lost block bitmap\n"));
 
-	for_each_perag(mp, agno, pag)
+	while ((pag = xfs_perag_next(mp, pag)))
 		phase5_func(mp, pag, lost_blocks);
 
 	print_final_rpt();

