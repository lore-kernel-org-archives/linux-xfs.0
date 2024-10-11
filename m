Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855A2391
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607514; cv=none; b=SKbBVEe5gILAdK7cecxoanChZmvltduDCWVVlvilHuxrmnoCmou4rlbJu+wPdleLnAUWDJSHCZF/3NCLJXJXstWdWFO9gE5BSjKYNI7HWskeG93sq0onsnznFgqjvfO9j82YZ4YmSf+P1yrujoxyJnxt9kaeRV/7+cw5j0bNWFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607514; c=relaxed/simple;
	bh=MUPGU2u3/fRn6Q/jL+oTI2YJCbNOY3bxOvW9c4cbKv8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t5f+ZUW+xhxbP/hLl1V8WIXiTV87LuND36NJUDh9ZcuPW1jyjTuIHln6/CupUnnFbrIN0V8/GLQNLPudH3AoPTaLnZFrJYsNrkdhAz+RdXmorhdKrA4WWnm4WOsbj/zfbzPLx7Mv7ADvMh/5wrwli68+M4OLgRKKAgdGyPx8Rz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LywW6zMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LywW6zMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596D2C4CEC5;
	Fri, 11 Oct 2024 00:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607514;
	bh=MUPGU2u3/fRn6Q/jL+oTI2YJCbNOY3bxOvW9c4cbKv8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LywW6zMMCOuUw1uRzYrylFXhdnf8eEG4gG464W+fl7XwkA0dzYgnCjYXjW/1HcmNC
	 hzjo+1rb2lh9EymGyHdtlJHR/ciUa5xnY7DlOrlCCmfX9KVO34/uE+NNpujXkPoqgA
	 KzbfftyD5HYkG7vRJup8yA7nKxUkb2/5gMsIJ/vcJzjVLhL9dN0AugWdbfjNWYpfcW
	 h5Dz7pzdGp8fy4R3TTe8rjFsj3mzHXjfnAWel2kabwNCS93JKeCrnS6668FZk5Z2mL
	 Gi6H+y3NxqMlcETCTSkMH6dDiegcmj99Dm9ZXNW2lLdo4Fm8bsa8MZWtQuNBMGjuQn
	 zkUEHy5H8LUQQ==
Date: Thu, 10 Oct 2024 17:45:13 -0700
Subject: [PATCH 04/16] xfs: switch perag iteration from the for_each macros to
 a while based iterator
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860641328.4176300.10235230297764982182.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
References: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_ag.h      |   62 +++++++++++++++++++------------------------
 fs/xfs/libxfs/xfs_sb.c      |   15 +++-------
 fs/xfs/libxfs/xfs_types.c   |    5 +--
 fs/xfs/scrub/bmap.c         |    5 +--
 fs/xfs/scrub/bmap_repair.c  |    5 +--
 fs/xfs/scrub/fscounters.c   |   10 +++----
 fs/xfs/scrub/health.c       |   11 +++-----
 fs/xfs/scrub/inode_repair.c |    5 +--
 fs/xfs/xfs_discard.c        |    6 ++--
 fs/xfs/xfs_extent_busy.c    |    5 +--
 fs/xfs/xfs_fsmap.c          |    7 ++---
 fs/xfs/xfs_fsops.c          |   10 +++----
 fs/xfs/xfs_health.c         |    5 +--
 fs/xfs/xfs_icache.c         |    5 +--
 fs/xfs/xfs_iwalk.c          |   18 +++++++-----
 fs/xfs/xfs_log_recover.c    |    5 +--
 fs/xfs/xfs_reflink.c        |    5 +--
 17 files changed, 79 insertions(+), 105 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index b08daa27fb5879..5e1f2c59740ddb 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -202,6 +202,34 @@ xfs_perag_rele(
 	xfs_group_rele(&pag->pag_group);
 }
 
+static inline struct xfs_perag *
+xfs_perag_next_range(
+	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
+	xfs_agnumber_t		start_agno,
+	xfs_agnumber_t		end_agno)
+{
+	return to_perag(xfs_group_next_range(mp, pag ? &pag->pag_group : NULL,
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
@@ -267,40 +295,6 @@ xfs_ag_contains_log(struct xfs_mount *mp, xfs_agnumber_t agno)
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
-	*agno = pag->pag_group.xg_index + 1;
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
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index d2012fbf07aa65..061c8c961d5bc9 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1109,14 +1109,13 @@ int
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
@@ -1146,7 +1145,7 @@ xfs_update_secondary_sbs(
 		xfs_buf_relse(bp);
 
 		/* don't hold too many buffers at once */
-		if (agno % 16)
+		if (pag_agno(pag) % 16)
 			continue;
 
 		error = xfs_buf_delwri_submit(&buffer_list);
@@ -1160,12 +1159,8 @@ xfs_update_secondary_sbs(
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
 
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index c299b16c9365fa..c91db4f5140743 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
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
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index a43912227dd478..fb022b403716b1 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -760,11 +760,10 @@ xchk_bmap_check_rmaps(
 	struct xfs_scrub	*sc,
 	int			whichfork)
 {
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag = NULL;
 	int			error;
 
-	for_each_perag(sc->mp, agno, pag) {
+	while ((pag = xfs_perag_next(sc->mp, pag))) {
 		error = xchk_bmap_check_ag_rmaps(sc, whichfork, pag);
 		if (error ||
 		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)) {
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index dc8fdd2da174ed..be408e50484b54 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -407,12 +407,11 @@ xrep_bmap_find_mappings(
 	struct xrep_bmap	*rb)
 {
 	struct xfs_scrub	*sc = rb->sc;
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag = NULL;
 	int			error = 0;
 
 	/* Iterate the rmaps for extents. */
-	for_each_perag(sc->mp, agno, pag) {
+	while ((pag = xfs_perag_next(sc->mp, pag))) {
 		error = xrep_bmap_scan_ag(rb, pag);
 		if (error) {
 			xfs_perag_rele(pag);
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 1d3e98346933e1..28db0c83819c20 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -74,10 +74,9 @@ xchk_fscount_warmup(
 	struct xfs_buf		*agi_bp = NULL;
 	struct xfs_buf		*agf_bp = NULL;
 	struct xfs_perag	*pag = NULL;
-	xfs_agnumber_t		agno;
 	int			error = 0;
 
-	for_each_perag(mp, agno, pag) {
+	while ((pag = xfs_perag_next(mp, pag))) {
 		if (xchk_should_terminate(sc, &error))
 			break;
 		if (xfs_perag_initialised_agi(pag) &&
@@ -295,9 +294,8 @@ xchk_fscount_aggregate_agcounts(
 	struct xchk_fscounters	*fsc)
 {
 	struct xfs_mount	*mp = sc->mp;
-	struct xfs_perag	*pag;
+	struct xfs_perag	*pag = NULL;
 	uint64_t		delayed;
-	xfs_agnumber_t		agno;
 	int			tries = 8;
 	int			error = 0;
 
@@ -306,7 +304,7 @@ xchk_fscount_aggregate_agcounts(
 	fsc->ifree = 0;
 	fsc->fdblocks = 0;
 
-	for_each_perag(mp, agno, pag) {
+	while ((pag = xfs_perag_next(mp, pag))) {
 		if (xchk_should_terminate(sc, &error))
 			break;
 
@@ -327,7 +325,7 @@ xchk_fscount_aggregate_agcounts(
 		if (xfs_has_lazysbcount(sc->mp)) {
 			fsc->fdblocks += pag->pagf_btreeblks;
 		} else {
-			error = xchk_fscount_btreeblks(sc, fsc, agno);
+			error = xchk_fscount_btreeblks(sc, fsc, pag_agno(pag));
 			if (error)
 				break;
 		}
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index b712a8bd34f543..112dd05e5551d3 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -160,12 +160,11 @@ STATIC void
 xchk_mark_all_healthy(
 	struct xfs_mount	*mp)
 {
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag = NULL;
 
 	xfs_fs_mark_healthy(mp, XFS_SICK_FS_INDIRECT);
 	xfs_rt_mark_healthy(mp, XFS_SICK_RT_INDIRECT);
-	for_each_perag(mp, agno, pag)
+	while ((pag = xfs_perag_next(mp, pag)))
 		xfs_ag_mark_healthy(pag, XFS_SICK_AG_INDIRECT);
 }
 
@@ -294,9 +293,7 @@ xchk_health_record(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_mount	*mp = sc->mp;
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno;
-
+	struct xfs_perag	*pag = NULL;
 	unsigned int		sick;
 	unsigned int		checked;
 
@@ -308,7 +305,7 @@ xchk_health_record(
 	if (sick & XFS_SICK_RT_PRIMARY)
 		xchk_set_corrupt(sc);
 
-	for_each_perag(mp, agno, pag) {
+	while ((pag = xfs_perag_next(mp, pag))) {
 		xfs_ag_measure_sickness(pag, &sick, &checked);
 		if (sick & XFS_SICK_AG_PRIMARY)
 			xchk_set_corrupt(sc);
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 3e45b9b72312ab..5da9e1a387a8bb 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -761,14 +761,13 @@ STATIC int
 xrep_dinode_count_rmaps(
 	struct xrep_inode	*ri)
 {
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag = NULL;
 	int			error;
 
 	if (!xfs_has_rmapbt(ri->sc->mp) || xfs_has_realtime(ri->sc->mp))
 		return -EOPNOTSUPP;
 
-	for_each_perag(ri->sc->mp, agno, pag) {
+	while ((pag = xfs_perag_next(ri->sc->mp, pag))) {
 		error = xrep_dinode_count_ag_rmaps(ri, pag);
 		if (error) {
 			xfs_perag_rele(pag);
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index dfd6edcebb6ea4..739ec69c44281c 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -387,8 +387,8 @@ xfs_trim_datadev_extents(
 {
 	xfs_agnumber_t		start_agno, end_agno;
 	xfs_agblock_t		start_agbno, end_agbno;
+	struct xfs_perag	*pag = NULL;
 	xfs_daddr_t		ddev_end;
-	struct xfs_perag	*pag;
 	int			last_error = 0, error;
 
 	ddev_end = min_t(xfs_daddr_t, end,
@@ -399,10 +399,10 @@ xfs_trim_datadev_extents(
 	end_agno = xfs_daddr_to_agno(mp, ddev_end);
 	end_agbno = xfs_daddr_to_agbno(mp, ddev_end);
 
-	for_each_perag_range(mp, start_agno, end_agno, pag) {
+	while ((pag = xfs_perag_next_range(mp, pag, start_agno, end_agno))) {
 		xfs_agblock_t	agend = pag->block_count;
 
-		if (start_agno == end_agno)
+		if (pag_agno(pag) == end_agno)
 			agend = end_agbno;
 		error = xfs_trim_perag_extents(pag, start_agbno, agend, minlen);
 		if (error)
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 79b0f833c511e3..3d5a57d7ac5e14 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -629,11 +629,10 @@ void
 xfs_extent_busy_wait_all(
 	struct xfs_mount	*mp)
 {
-	struct xfs_perag	*pag;
+	struct xfs_perag	*pag = NULL;
 	DEFINE_WAIT		(wait);
-	xfs_agnumber_t		agno;
 
-	for_each_perag(mp, agno, pag) {
+	while ((pag = xfs_perag_next(mp, pag))) {
 		do {
 			prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
 			if  (RB_EMPTY_ROOT(&pag->pagb_tree))
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 918e1c38a15592..a26fb054346b68 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -460,11 +460,11 @@ __xfs_getfsmap_datadev(
 	void				*priv)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_perag		*pag;
+	struct xfs_perag		*pag = NULL;
 	struct xfs_btree_cur		*bt_cur = NULL;
 	xfs_fsblock_t			start_fsb;
 	xfs_fsblock_t			end_fsb;
-	xfs_agnumber_t			start_ag, end_ag, ag;
+	xfs_agnumber_t			start_ag, end_ag;
 	uint64_t			eofs;
 	int				error = 0;
 
@@ -512,8 +512,7 @@ __xfs_getfsmap_datadev(
 	start_ag = XFS_FSB_TO_AGNO(mp, start_fsb);
 	end_ag = XFS_FSB_TO_AGNO(mp, end_fsb);
 
-	ag = start_ag;
-	for_each_perag_range(mp, ag, end_ag, pag) {
+	while ((pag = xfs_perag_next_range(mp, pag, start_ag, end_ag))) {
 		/*
 		 * Set the AG high key from the fsmap high key if this
 		 * is the last AG that we're querying.
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index b247d895c276d2..82812a458cf10f 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -528,13 +528,12 @@ int
 xfs_fs_reserve_ag_blocks(
 	struct xfs_mount	*mp)
 {
-	xfs_agnumber_t		agno;
-	struct xfs_perag	*pag;
+	struct xfs_perag	*pag = NULL;
 	int			error = 0;
 	int			err2;
 
 	mp->m_finobt_nores = false;
-	for_each_perag(mp, agno, pag) {
+	while ((pag = xfs_perag_next(mp, pag))) {
 		err2 = xfs_ag_resv_init(pag, NULL);
 		if (err2 && !error)
 			error = err2;
@@ -556,9 +555,8 @@ void
 xfs_fs_unreserve_ag_blocks(
 	struct xfs_mount	*mp)
 {
-	xfs_agnumber_t		agno;
-	struct xfs_perag	*pag;
+	struct xfs_perag	*pag = NULL;
 
-	for_each_perag(mp, agno, pag)
+	while ((pag = xfs_perag_next(mp, pag)))
 		xfs_ag_resv_free(pag);
 }
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index d6492128582a3e..ff5aca875ab0d0 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -28,8 +28,7 @@ void
 xfs_health_unmount(
 	struct xfs_mount	*mp)
 {
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag = NULL;
 	unsigned int		sick = 0;
 	unsigned int		checked = 0;
 	bool			warn = false;
@@ -38,7 +37,7 @@ xfs_health_unmount(
 		return;
 
 	/* Measure AG corruption levels. */
-	for_each_perag(mp, agno, pag) {
+	while ((pag = xfs_perag_next(mp, pag))) {
 		xfs_ag_measure_sickness(pag, &sick, &checked);
 		if (sick) {
 			trace_xfs_ag_unfixed_corruption(pag, sick);
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index b269a25dadf25d..21e06f091c65b1 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1383,13 +1383,12 @@ void
 xfs_blockgc_stop(
 	struct xfs_mount	*mp)
 {
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag = NULL;
 
 	if (!xfs_clear_blockgc_enabled(mp))
 		return;
 
-	for_each_perag(mp, agno, pag)
+	while ((pag = xfs_perag_next(mp, pag)))
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
 	trace_xfs_blockgc_stop(mp, __return_address);
 }
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index ec2d56f1840fc6..7db3ece370b100 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -540,23 +540,25 @@ xfs_iwalk_args(
 	unsigned int		flags)
 {
 	struct xfs_mount	*mp = iwag->mp;
-	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, iwag->startino);
+	xfs_agnumber_t		start_agno;
 	int			error;
 
-	ASSERT(agno < mp->m_sb.sb_agcount);
+	start_agno = XFS_INO_TO_AGNO(iwag->mp, iwag->startino);
+	ASSERT(start_agno < iwag->mp->m_sb.sb_agcount);
 	ASSERT(!(flags & ~XFS_IWALK_FLAGS_ALL));
 
 	error = xfs_iwalk_alloc(iwag);
 	if (error)
 		return error;
 
-	for_each_perag_from(mp, agno, iwag->pag) {
+	while ((iwag->pag = xfs_perag_next_from(mp, iwag->pag, start_agno))) {
 		error = xfs_iwalk_ag(iwag);
 		if (error || (flags & XFS_IWALK_SAME_AG)) {
 			xfs_perag_rele(iwag->pag);
 			break;
 		}
-		iwag->startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
+		iwag->startino =
+			XFS_AGINO_TO_INO(mp, pag_agno(iwag->pag) + 1, 0);
 	}
 
 	xfs_iwalk_free(iwag);
@@ -644,19 +646,19 @@ xfs_iwalk_threaded(
 	bool			polled,
 	void			*data)
 {
+	xfs_agnumber_t		start_agno = XFS_INO_TO_AGNO(mp, startino);
 	struct xfs_pwork_ctl	pctl;
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
+	struct xfs_perag	*pag = NULL;
 	int			error;
 
-	ASSERT(agno < mp->m_sb.sb_agcount);
+	ASSERT(start_agno < mp->m_sb.sb_agcount);
 	ASSERT(!(flags & ~XFS_IWALK_FLAGS_ALL));
 
 	error = xfs_pwork_init(mp, &pctl, xfs_iwalk_ag_work, "xfs_iwalk");
 	if (error)
 		return error;
 
-	for_each_perag_from(mp, agno, pag) {
+	while ((pag = xfs_perag_next_from(mp, pag, start_agno))) {
 		struct xfs_iwalk_ag	*iwag;
 
 		if (xfs_pwork_ctl_want_abort(&pctl))
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a3cc76bb93274d..0856080f87d3e6 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2845,10 +2845,9 @@ static void
 xlog_recover_process_iunlinks(
 	struct xlog	*log)
 {
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag = NULL;
 
-	for_each_perag(log->l_mp, agno, pag)
+	while ((pag = xfs_perag_next(log->l_mp, pag)))
 		xlog_recover_iunlink_ag(pag);
 }
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 2e82b5b6ed52d2..b11769c009effc 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -894,14 +894,13 @@ int
 xfs_reflink_recover_cow(
 	struct xfs_mount	*mp)
 {
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag = NULL;
 	int			error = 0;
 
 	if (!xfs_has_reflink(mp))
 		return 0;
 
-	for_each_perag(mp, agno, pag) {
+	while ((pag = xfs_perag_next(mp, pag))) {
 		error = xfs_refcount_recover_cow_leftovers(mp, pag);
 		if (error) {
 			xfs_perag_rele(pag);

