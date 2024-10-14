Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8019A13777E
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 06:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728885924; cv=none; b=bJPkTq0y6QDd104rJOewetxBdeVAkCgjzomlVpLBunE4tBjInYKg9ngrFY4gjM9+6e/fNMKps7tvawJqz4LURrLkdi0PMdtXAQxUFiJD395AG+Samjp7RRPWzvvSrWtdXE5lgTqWiaY7v4BU5ZslV2E6b/CjPi1t4H5q/aITL7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728885924; c=relaxed/simple;
	bh=nGsawZCnxhpDVJevfi6CMik3+mFaqGea2AbLVvIVhN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHxCE57Amx61lmy2SzZ9afoSrVp0hTVXedpnuGqU+Q5GoJj7M65vfDTbf7p1xGpRaB+iwpR3sS3XJgtQILwqqipr9Ldwd2N1lFZcwsOnih6vpRxgF2wFhMjk7w6HBFIIot18iLmV1USlvHuO81B7fxK5n1C/9uFsrMNw4bG2FpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ioZFVTUr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ioZFVTUr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7TE7wdZ12AeTM9122eWkmcaxZDUOePWUvkxNCTiAGww=; b=ioZFVTUrM+nifo2gCdNodEPJi2
	hovNic8i+7Zn/PRCcqep/Im6Zfmf2YZJLpQW+0UOF61hBUl9kkHQAuSiRjV7jFUG2GH/h2V6PkR+U
	FMedSPmn+C7sGPXJWMN5UJjLw0wtEPLeNCEZ+TBVXAq0uFuk6ffs3bDrXj+rDx5NUGejBtsNRFfRq
	a5F88eSoUI/Z9NiN4gsdO5XrPMpVjDYUulLOKELMnns3blhnqTccciytt3XaTrL1/rxyz+C3YUrvt
	DYhiv9TsrAm4NmQYMfRDjgl9sREe2Pao55/C2bCRhOA+XGpN7rUT2HDDF44hPyA5aDYeMxSblrj5K
	XNZWa61w==;
Received: from 2a02-8389-2341-5b80-fa4a-5f67-ca73-5831.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:fa4a:5f67:ca73:5831] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t0ECo-00000003pdO-3C0y;
	Mon, 14 Oct 2024 06:05:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/6] xfs: pass the exact range to initialize to xfs_initialize_perag
Date: Mon, 14 Oct 2024 08:04:50 +0200
Message-ID: <20241014060516.245606-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241014060516.245606-1-hch@lst.de>
References: <20241014060516.245606-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently only the new agcount is passed to xfs_initialize_perag, which
requires lookups of existing AGs to skip them and complicates error
handling.  Also pass the previous agcount so that the range that
xfs_initialize_perag operates on is exactly defined.  That way the
extra lookups can be avoided, and error handling can clean up the
exact range from the old count to the last added perag structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c   | 28 ++++++----------------------
 fs/xfs/libxfs/xfs_ag.h   |  5 +++--
 fs/xfs/xfs_fsops.c       | 18 ++++++++----------
 fs/xfs/xfs_log_recover.c |  5 +++--
 fs/xfs/xfs_mount.c       |  4 ++--
 5 files changed, 22 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 5f0494702e0b55..464f682eab4690 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -296,27 +296,16 @@ xfs_free_unused_perag_range(
 int
 xfs_initialize_perag(
 	struct xfs_mount	*mp,
-	xfs_agnumber_t		agcount,
+	xfs_agnumber_t		old_agcount,
+	xfs_agnumber_t		new_agcount,
 	xfs_rfsblock_t		dblocks,
 	xfs_agnumber_t		*maxagi)
 {
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		index;
-	xfs_agnumber_t		first_initialised = NULLAGNUMBER;
 	int			error;
 
-	/*
-	 * Walk the current per-ag tree so we don't try to initialise AGs
-	 * that already exist (growfs case). Allocate and insert all the
-	 * AGs we don't find ready for initialisation.
-	 */
-	for (index = 0; index < agcount; index++) {
-		pag = xfs_perag_get(mp, index);
-		if (pag) {
-			xfs_perag_put(pag);
-			continue;
-		}
-
+	for (index = old_agcount; index < new_agcount; index++) {
 		pag = kzalloc(sizeof(*pag), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 		if (!pag) {
 			error = -ENOMEM;
@@ -353,21 +342,17 @@ xfs_initialize_perag(
 		/* Active ref owned by mount indicates AG is online. */
 		atomic_set(&pag->pag_active_ref, 1);
 
-		/* first new pag is fully initialized */
-		if (first_initialised == NULLAGNUMBER)
-			first_initialised = index;
-
 		/*
 		 * Pre-calculated geometry
 		 */
-		pag->block_count = __xfs_ag_block_count(mp, index, agcount,
+		pag->block_count = __xfs_ag_block_count(mp, index, new_agcount,
 				dblocks);
 		pag->min_block = XFS_AGFL_BLOCK(mp);
 		__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
 				&pag->agino_max);
 	}
 
-	index = xfs_set_inode_alloc(mp, agcount);
+	index = xfs_set_inode_alloc(mp, new_agcount);
 
 	if (maxagi)
 		*maxagi = index;
@@ -381,8 +366,7 @@ xfs_initialize_perag(
 out_free_pag:
 	kfree(pag);
 out_unwind_new_pags:
-	/* unwind any prior newly initialized pags */
-	xfs_free_unused_perag_range(mp, first_initialised, agcount);
+	xfs_free_unused_perag_range(mp, old_agcount, index);
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index d9cccd093b60e0..69fc31e7b84728 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -146,8 +146,9 @@ __XFS_AG_OPSTATE(agfl_needs_reset, AGFL_NEEDS_RESET)
 
 void xfs_free_unused_perag_range(struct xfs_mount *mp, xfs_agnumber_t agstart,
 			xfs_agnumber_t agend);
-int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
-			xfs_rfsblock_t dcount, xfs_agnumber_t *maxagi);
+int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t old_agcount,
+		xfs_agnumber_t agcount, xfs_rfsblock_t dcount,
+		xfs_agnumber_t *maxagi);
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
 void xfs_free_perag(struct xfs_mount *mp);
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 3643cc843f6271..de2bf0594cb474 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -87,6 +87,7 @@ xfs_growfs_data_private(
 	struct xfs_mount	*mp,		/* mount point for filesystem */
 	struct xfs_growfs_data	*in)		/* growfs data input struct */
 {
+	xfs_agnumber_t		oagcount = mp->m_sb.sb_agcount;
 	struct xfs_buf		*bp;
 	int			error;
 	xfs_agnumber_t		nagcount;
@@ -94,7 +95,6 @@ xfs_growfs_data_private(
 	xfs_rfsblock_t		nb, nb_div, nb_mod;
 	int64_t			delta;
 	bool			lastag_extended = false;
-	xfs_agnumber_t		oagcount;
 	struct xfs_trans	*tp;
 	struct aghdr_init_data	id = {};
 	struct xfs_perag	*last_pag;
@@ -138,16 +138,14 @@ xfs_growfs_data_private(
 	if (delta == 0)
 		return 0;
 
-	oagcount = mp->m_sb.sb_agcount;
-	/* allocate the new per-ag structures */
-	if (nagcount > oagcount) {
-		error = xfs_initialize_perag(mp, nagcount, nb, &nagimax);
-		if (error)
-			return error;
-	} else if (nagcount < oagcount) {
-		/* TODO: shrinking the entire AGs hasn't yet completed */
+	/* TODO: shrinking the entire AGs hasn't yet completed */
+	if (nagcount < oagcount)
 		return -EINVAL;
-	}
+
+	/* allocate the new per-ag structures */
+	error = xfs_initialize_perag(mp, oagcount, nagcount, nb, &nagimax);
+	if (error)
+		return error;
 
 	if (delta > 0)
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d6a3ff24c327c3..60d46338f51792 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3346,6 +3346,7 @@ xlog_do_recover(
 	struct xfs_mount	*mp = log->l_mp;
 	struct xfs_buf		*bp = mp->m_sb_bp;
 	struct xfs_sb		*sbp = &mp->m_sb;
+	xfs_agnumber_t		orig_agcount = sbp->sb_agcount;
 	int			error;
 
 	trace_xfs_log_recover(log, head_blk, tail_blk);
@@ -3393,8 +3394,8 @@ xlog_do_recover(
 	/* re-initialise in-core superblock and geometry structures */
 	mp->m_features |= xfs_sb_version_to_features(sbp);
 	xfs_reinit_percpu_counters(mp);
-	error = xfs_initialize_perag(mp, sbp->sb_agcount, sbp->sb_dblocks,
-			&mp->m_maxagi);
+	error = xfs_initialize_perag(mp, orig_agcount, sbp->sb_agcount,
+			sbp->sb_dblocks, &mp->m_maxagi);
 	if (error) {
 		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
 		return error;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 1fdd79c5bfa04e..6fa7239a4a01b6 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -810,8 +810,8 @@ xfs_mountfs(
 	/*
 	 * Allocate and initialize the per-ag data.
 	 */
-	error = xfs_initialize_perag(mp, sbp->sb_agcount, mp->m_sb.sb_dblocks,
-			&mp->m_maxagi);
+	error = xfs_initialize_perag(mp, 0, sbp->sb_agcount,
+			mp->m_sb.sb_dblocks, &mp->m_maxagi);
 	if (error) {
 		xfs_warn(mp, "Failed per-ag init: %d", error);
 		goto out_free_dir;
-- 
2.45.2

