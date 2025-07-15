Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D084271449
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582366; cv=none; b=eez+QCZAJAPA4te6Yoyhmqn/HTTApzmH1s4r8wLOwgXLeBYyM/jUfWXxedBu2Bb/UHlwsR10I7m8DCXf5zaxV0R9neA7svU2fvGov0i7nQ92YuGXMohjp12wWoP5Pxj+u0DjG7iraBitY5zshDvi9SW/VMze7pKn91hFe00wiIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582366; c=relaxed/simple;
	bh=leLYuNWLsLW6I6WhY6IFEAn12FH5QwPeiClVQXpV0Wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtutAmFnOmnEAHr1FDXXXKcif6rysJprgrR5FFUkgsLRUhwHADmIqQI327hfzli2Rhggn8y2LqkDqgN0DWXH5Szg5rEzjPlFNWWQgQxgmf9lNfKP4ShGb5uuiGCOwAzvRMFzvMwoe1dYuD+yqu88IkRfpvRdn/ISZOqorCdYXFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BWDICbYh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BWDICbYh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EHYsK7+P2rzOPkPPLrZD7DNT+j2EmwRr9Wmz0gVae1o=; b=BWDICbYhyE2vmaZuFXsF+85LIo
	oFMBAltVHaTR/1bu7KG19VLEzHcl4ORyE1bKAV39eRPP8ushXHTyz0GWseNqOlhl+f9C9pFR7rKLU
	qaYHHstC2JR64+6mEbbTizDxxPH7QkHt/wkz+7lZRT5Jd/z0mHnAxipmnwUfAblP2uq8ZSSUoaese
	ohqgTKN+naK6dqdgZQijkmGlXU8mQiy8YtCRItHOSnF4zAlCZq9NMpBSjNIp2upnEgC23TQr5B7qy
	IwQG3IkisaBJdZcXywbfYVnMRb/pH29PEu89MmhUO10n02/OOCIz+odA3ETR9Wr8TYcEId+0JpdB0
	O7+1cCHg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubejU-000000053za-1HO8;
	Tue, 15 Jul 2025 12:26:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 5/8] xfs: return the allocated transaction from xfs_trans_alloc_empty
Date: Tue, 15 Jul 2025 14:25:38 +0200
Message-ID: <20250715122544.1943403-6-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250715122544.1943403-1-hch@lst.de>
References: <20250715122544.1943403-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_trans_alloc_empty can't return errors, so return the allocated
transaction directly instead of an output double pointer argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_refcount.c |  4 +---
 fs/xfs/scrub/common.c        |  3 ++-
 fs/xfs/scrub/repair.c        | 12 ++----------
 fs/xfs/scrub/scrub.c         |  5 +----
 fs/xfs/xfs_attr_item.c       |  5 +----
 fs/xfs/xfs_discard.c         | 12 +++---------
 fs/xfs/xfs_fsmap.c           |  4 +---
 fs/xfs/xfs_icache.c          |  5 +----
 fs/xfs/xfs_inode.c           |  5 +----
 fs/xfs/xfs_itable.c          | 18 +++---------------
 fs/xfs/xfs_iwalk.c           | 11 +++--------
 fs/xfs/xfs_notify_failure.c  |  5 +----
 fs/xfs/xfs_qm.c              | 10 ++--------
 fs/xfs/xfs_rtalloc.c         | 13 +++----------
 fs/xfs/xfs_trans.c           |  8 +++-----
 fs/xfs/xfs_trans.h           |  3 +--
 fs/xfs/xfs_zone_gc.c         |  5 +----
 17 files changed, 30 insertions(+), 98 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index cebe83f7842a..897784037483 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -2099,9 +2099,7 @@ xfs_refcount_recover_cow_leftovers(
 	 * recording the CoW debris we cancel the (empty) transaction
 	 * and everything goes away cleanly.
 	 */
-	error = xfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		return error;
+	tp = xfs_trans_alloc_empty(mp);
 
 	if (isrt) {
 		xfs_rtgroup_lock(to_rtg(xg), XFS_RTGLOCK_REFCOUNT);
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 28ad341df8ee..d080f4e6e9d8 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -870,7 +870,8 @@ int
 xchk_trans_alloc_empty(
 	struct xfs_scrub	*sc)
 {
-	return xfs_trans_alloc_empty(sc->mp, &sc->tp);
+	sc->tp = xfs_trans_alloc_empty(sc->mp);
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index f8f9ed30f56b..f7f80ff32afc 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1279,18 +1279,10 @@ xrep_trans_alloc_hook_dummy(
 	void			**cookiep,
 	struct xfs_trans	**tpp)
 {
-	int			error;
-
 	*cookiep = current->journal_info;
 	current->journal_info = NULL;
-
-	error = xfs_trans_alloc_empty(mp, tpp);
-	if (!error)
-		return 0;
-
-	current->journal_info = *cookiep;
-	*cookiep = NULL;
-	return error;
+	*tpp = xfs_trans_alloc_empty(mp);
+	return 0;
 }
 
 /* Cancel a dummy transaction used by a live update hook function. */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 76e24032e99a..3c3b0d25006f 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -876,10 +876,7 @@ xchk_scrubv_open_by_handle(
 	struct xfs_inode		*ip;
 	int				error;
 
-	error = xfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		return NULL;
-
+	tp = xfs_trans_alloc_empty(mp);
 	error = xfs_iget(mp, tp, head->svh_ino, XCHK_IGET_FLAGS, 0, &ip);
 	xfs_trans_cancel(tp);
 	if (error)
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index f683b7a9323f..da1e11f38eb0 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -616,10 +616,7 @@ xfs_attri_iread_extents(
 	struct xfs_trans		*tp;
 	int				error;
 
-	error = xfs_trans_alloc_empty(ip->i_mount, &tp);
-	if (error)
-		return error;
-
+	tp = xfs_trans_alloc_empty(ip->i_mount);
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_iread_extents(tp, ip, XFS_ATTR_FORK);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 603d51365645..ee49f20875af 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -189,9 +189,7 @@ xfs_trim_gather_extents(
 	 */
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
-	error = xfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		return error;
+	tp = xfs_trans_alloc_empty(mp);
 
 	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
 	if (error)
@@ -583,9 +581,7 @@ xfs_trim_rtextents(
 	struct xfs_trans	*tp;
 	int			error;
 
-	error = xfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		return error;
+	tp = xfs_trans_alloc_empty(mp);
 
 	/*
 	 * Walk the free ranges between low and high.  The query_range function
@@ -701,9 +697,7 @@ xfs_trim_rtgroup_extents(
 	struct xfs_trans	*tp;
 	int			error;
 
-	error = xfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		return error;
+	tp = xfs_trans_alloc_empty(mp);
 
 	/*
 	 * Walk the free ranges between low and high.  The query_range function
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 414b27a86458..af68c7de8ee8 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -1270,9 +1270,7 @@ xfs_getfsmap(
 		 * buffer locking abilities to detect cycles in the rmapbt
 		 * without deadlocking.
 		 */
-		error = xfs_trans_alloc_empty(mp, &tp);
-		if (error)
-			break;
+		tp = xfs_trans_alloc_empty(mp);
 
 		info.dev = handlers[i].dev;
 		info.last = false;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index bbc2f2973dcc..4cf7abe50143 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -893,10 +893,7 @@ xfs_metafile_iget(
 	struct xfs_trans	*tp;
 	int			error;
 
-	error = xfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		return error;
-
+	tp = xfs_trans_alloc_empty(mp);
 	error = xfs_trans_metafile_iget(tp, ino, metafile_type, ipp);
 	xfs_trans_cancel(tp);
 	return error;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 761a996a857c..4264f8c92e53 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2934,10 +2934,7 @@ xfs_inode_reload_unlinked(
 	struct xfs_trans	*tp;
 	int			error;
 
-	error = xfs_trans_alloc_empty(ip->i_mount, &tp);
-	if (error)
-		return error;
-
+	tp = xfs_trans_alloc_empty(ip->i_mount);
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	if (xfs_inode_unlinked_incomplete(ip))
 		error = xfs_inode_reload_unlinked_bucket(tp, ip);
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 1fa1c0564b0c..c8c9b8d8309f 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -239,14 +239,10 @@ xfs_bulkstat_one(
 	 * Grab an empty transaction so that we can use its recursive buffer
 	 * locking abilities to detect cycles in the inobt without deadlocking.
 	 */
-	error = xfs_trans_alloc_empty(breq->mp, &tp);
-	if (error)
-		goto out;
-
+	tp = xfs_trans_alloc_empty(breq->mp);
 	error = xfs_bulkstat_one_int(breq->mp, breq->idmap, tp,
 			breq->startino, &bc);
 	xfs_trans_cancel(tp);
-out:
 	kfree(bc.buf);
 
 	/*
@@ -331,17 +327,13 @@ xfs_bulkstat(
 	 * Grab an empty transaction so that we can use its recursive buffer
 	 * locking abilities to detect cycles in the inobt without deadlocking.
 	 */
-	error = xfs_trans_alloc_empty(breq->mp, &tp);
-	if (error)
-		goto out;
-
+	tp = xfs_trans_alloc_empty(breq->mp);
 	if (breq->flags & XFS_IBULK_SAME_AG)
 		iwalk_flags |= XFS_IWALK_SAME_AG;
 
 	error = xfs_iwalk(breq->mp, tp, breq->startino, iwalk_flags,
 			xfs_bulkstat_iwalk, breq->icount, &bc);
 	xfs_trans_cancel(tp);
-out:
 	kfree(bc.buf);
 
 	/*
@@ -464,14 +456,10 @@ xfs_inumbers(
 	 * Grab an empty transaction so that we can use its recursive buffer
 	 * locking abilities to detect cycles in the inobt without deadlocking.
 	 */
-	error = xfs_trans_alloc_empty(breq->mp, &tp);
-	if (error)
-		goto out;
-
+	tp = xfs_trans_alloc_empty(breq->mp);
 	error = xfs_inobt_walk(breq->mp, tp, breq->startino, breq->flags,
 			xfs_inumbers_walk, breq->icount, &ic);
 	xfs_trans_cancel(tp);
-out:
 
 	/*
 	 * We found some inode groups, so clear the error status and return
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 7db3ece370b1..c1c31d1a8e21 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -377,11 +377,8 @@ xfs_iwalk_run_callbacks(
 	if (!has_more)
 		return 0;
 
-	if (iwag->drop_trans) {
-		error = xfs_trans_alloc_empty(mp, &iwag->tp);
-		if (error)
-			return error;
-	}
+	if (iwag->drop_trans)
+		iwag->tp = xfs_trans_alloc_empty(mp);
 
 	/* ...and recreate the cursor just past where we left off. */
 	error = xfs_ialloc_read_agi(iwag->pag, iwag->tp, 0, agi_bpp);
@@ -617,9 +614,7 @@ xfs_iwalk_ag_work(
 	 * Grab an empty transaction so that we can use its recursive buffer
 	 * locking abilities to detect cycles in the inobt without deadlocking.
 	 */
-	error = xfs_trans_alloc_empty(mp, &iwag->tp);
-	if (error)
-		goto out;
+	iwag->tp = xfs_trans_alloc_empty(mp);
 	iwag->drop_trans = 1;
 
 	error = xfs_iwalk_ag(iwag);
diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index 42e9c72b85c0..fbd521f89874 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -279,10 +279,7 @@ xfs_dax_notify_dev_failure(
 		kernel_frozen = xfs_dax_notify_failure_freeze(mp) == 0;
 	}
 
-	error = xfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		goto out;
-
+	tp = xfs_trans_alloc_empty(mp);
 	start_gno = xfs_fsb_to_gno(mp, start_bno, type);
 	end_gno = xfs_fsb_to_gno(mp, end_bno, type);
 	while ((xg = xfs_group_next_range(mp, xg, start_gno, end_gno, type))) {
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index fa135ac26471..23ba84ec919a 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -660,10 +660,7 @@ xfs_qm_load_metadir_qinos(
 	struct xfs_trans	*tp;
 	int			error;
 
-	error = xfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		return error;
-
+	tp = xfs_trans_alloc_empty(mp);
 	error = xfs_dqinode_load_parent(tp, &qi->qi_dirip);
 	if (error == -ENOENT) {
 		/* no quota dir directory, but we'll create one later */
@@ -1755,10 +1752,7 @@ xfs_qm_qino_load(
 	struct xfs_inode	*dp = NULL;
 	int			error;
 
-	error = xfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		return error;
-
+	tp = xfs_trans_alloc_empty(mp);
 	if (xfs_has_metadir(mp)) {
 		error = xfs_dqinode_load_parent(tp, &dp);
 		if (error)
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 736eb0924573..6907e871fa15 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -729,9 +729,7 @@ xfs_rtginode_ensure(
 	if (rtg->rtg_inodes[type])
 		return 0;
 
-	error = xfs_trans_alloc_empty(rtg_mount(rtg), &tp);
-	if (error)
-		return error;
+	tp = xfs_trans_alloc_empty(rtg_mount(rtg));
 	error = xfs_rtginode_load(rtg, type, tp);
 	xfs_trans_cancel(tp);
 
@@ -1305,9 +1303,7 @@ xfs_growfs_rt_prep_groups(
 	if (!mp->m_rtdirip) {
 		struct xfs_trans	*tp;
 
-		error = xfs_trans_alloc_empty(mp, &tp);
-		if (error)
-			return error;
+		tp = xfs_trans_alloc_empty(mp);
 		error = xfs_rtginode_load_parent(tp);
 		xfs_trans_cancel(tp);
 
@@ -1674,10 +1670,7 @@ xfs_rtmount_inodes(
 	struct xfs_rtgroup	*rtg = NULL;
 	int			error;
 
-	error = xfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		return error;
-
+	tp = xfs_trans_alloc_empty(mp);
 	if (xfs_has_rtgroups(mp) && mp->m_sb.sb_rgcount > 0) {
 		error = xfs_rtginode_load_parent(tp);
 		if (error)
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 553128b7f86a..dc7199c81a78 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -298,13 +298,11 @@ xfs_trans_alloc(
  * where we can be grabbing buffers at the same time that freeze is trying to
  * drain the buffer LRU list.
  */
-int
+struct xfs_trans *
 xfs_trans_alloc_empty(
-	struct xfs_mount		*mp,
-	struct xfs_trans		**tpp)
+	struct xfs_mount		*mp)
 {
-	*tpp = __xfs_trans_alloc(mp, XFS_TRANS_NO_WRITECOUNT);
-	return 0;
+	return __xfs_trans_alloc(mp, XFS_TRANS_NO_WRITECOUNT);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 2b366851e9a4..a6b10aaeb1f1 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -168,8 +168,7 @@ int		xfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
 			struct xfs_trans **tpp);
 int		xfs_trans_reserve_more(struct xfs_trans *tp,
 			unsigned int blocks, unsigned int rtextents);
-int		xfs_trans_alloc_empty(struct xfs_mount *mp,
-			struct xfs_trans **tpp);
+struct xfs_trans *xfs_trans_alloc_empty(struct xfs_mount *mp);
 void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
 
 int xfs_trans_get_buf_map(struct xfs_trans *tp, struct xfs_buftarg *target,
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 9c00fc5baa30..e1954b0e6021 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -328,10 +328,7 @@ xfs_zone_gc_query(
 	iter->rec_idx = 0;
 	iter->rec_count = 0;
 
-	error = xfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		return error;
-
+	tp = xfs_trans_alloc_empty(mp);
 	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
 	cur = xfs_rtrmapbt_init_cursor(tp, rtg);
 	error = xfs_rmap_query_range(cur, &ri_low, &ri_high,
-- 
2.47.2

