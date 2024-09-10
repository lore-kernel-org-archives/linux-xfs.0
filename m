Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA8F13E02C
	for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 04:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725942551; cv=none; b=mk8dbLSbRXp5FwALy4CIX5XfqVhOMr5RoGmkhd8HL/hy72bBSkJvil4wl/Unc4CDNWBjJAbbTGFUCqvaltwZefg39FQ6o4Ki1sPhtb/OLhUIJa3iurEjkW9vQwEuAZDQ6xQol6SYCzjco5UIoePOwuSXD5Eomw50NNdVlHTnVfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725942551; c=relaxed/simple;
	bh=+66Hb0HONJHDXHVkAlm2hGIduTudkweuULhhEx4Rdm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5tF2Cf/8vgBQCc3kQ6IKwZlSaHuYCaHS9M5JxVRbZuCAh85w0pFESyn+/ltjjbj7Cmeyq9ob4vAASi1TJtm4Ur39Y+t9e3oP1j1sHa79/S75Gib0+y1NnCBtu1Zy+eZiMGNZzcGhVGkcaNpZQJWvVNBeRlp6M7HYyg6Z5YA3Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HigMMC9w; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HigMMC9w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FrjixrgjMALszalxkCXHoLJyrauGFO7VUPv8RAXYHrw=; b=HigMMC9wIOuXxz4ONLEOXKsmtJ
	W0eFMw0kuXMIgN5x53lx6jCWkbSj+33X1GZ++IFa/cs/haEKXgf4w33TnPcetcl/MYj/SBlfgVBHi
	K668+GVzVtcg4roommHGRtMlpPi3x1D6c3hjIhfKQJSgQvdw0KeQOmoHl6yZPCQG/w+0/EXr7Dr7v
	k09dT4OTCGaOfcUT2K07uaiskwrvwQd77kk76WaJWdy45iQuxdoUqXNnw4hI5VV0fXn48nfcqyj/D
	/9idiFr2oQoBVIp0dt7z572pCnVkAhFCBD/csWxfIRgEs+higUcLHSOjnV18/ZQG/aAwTRaYqiLmx
	TYZSPvww==;
Received: from ppp-2-84-49-240.home.otenet.gr ([2.84.49.240] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1snsUx-00000004D4r-3lR7;
	Tue, 10 Sep 2024 04:29:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: pass the exact range to initialize to xfs_initialize_perag
Date: Tue, 10 Sep 2024 07:28:44 +0300
Message-ID: <20240910042855.3480387-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240910042855.3480387-1-hch@lst.de>
References: <20240910042855.3480387-1-hch@lst.de>
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
---
 fs/xfs/libxfs/xfs_ag.c   | 23 +++++------------------
 fs/xfs/libxfs/xfs_ag.h   |  5 +++--
 fs/xfs/xfs_fsops.c       | 18 ++++++++----------
 fs/xfs/xfs_log_recover.c |  5 +++--
 fs/xfs/xfs_mount.c       |  4 ++--
 5 files changed, 21 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 5f0494702e0b55..5186735da5d45a 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -296,27 +296,19 @@ xfs_free_unused_perag_range(
 int
 xfs_initialize_perag(
 	struct xfs_mount	*mp,
+	xfs_agnumber_t		old_agcount,
 	xfs_agnumber_t		agcount,
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
+	if (old_agcount >= agcount)
+		return 0;
 
+	for (index = old_agcount; index < agcount; index++) {
 		pag = kzalloc(sizeof(*pag), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 		if (!pag) {
 			error = -ENOMEM;
@@ -353,10 +345,6 @@ xfs_initialize_perag(
 		/* Active ref owned by mount indicates AG is online. */
 		atomic_set(&pag->pag_active_ref, 1);
 
-		/* first new pag is fully initialized */
-		if (first_initialised == NULLAGNUMBER)
-			first_initialised = index;
-
 		/*
 		 * Pre-calculated geometry
 		 */
@@ -381,8 +369,7 @@ xfs_initialize_perag(
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
index 1a74fe22672e3e..2af02b32f419c2 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3346,6 +3346,7 @@ xlog_do_recover(
 	struct xfs_mount	*mp = log->l_mp;
 	struct xfs_buf		*bp = mp->m_sb_bp;
 	struct xfs_sb		*sbp = &mp->m_sb;
+	xfs_agnumber_t		old_agcount = sbp->sb_agcount;
 	int			error;
 
 	trace_xfs_log_recover(log, head_blk, tail_blk);
@@ -3393,8 +3394,8 @@ xlog_do_recover(
 	/* re-initialise in-core superblock and geometry structures */
 	mp->m_features |= xfs_sb_version_to_features(sbp);
 	xfs_reinit_percpu_counters(mp);
-	error = xfs_initialize_perag(mp, sbp->sb_agcount, sbp->sb_dblocks,
-			&mp->m_maxagi);
+	error = xfs_initialize_perag(mp, old_agcount, sbp->sb_agcount,
+			sbp->sb_dblocks, &mp->m_maxagi);
 	if (error) {
 		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
 		return error;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 460f93a9ce00d1..0f4f56a7f02d9a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -806,8 +806,8 @@ xfs_mountfs(
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

