Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86F62F5301
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 12:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752669858; cv=none; b=D9J37pL809k9VemqvMRxbjsDEuDG16EgsESXje4svWHoCCgDGfbouiHNDeedcwgFKCrQGtysxBe9r6sMYlZFkNRFRdeLOC1ec9p2/bD50wbdZX9ULvZ/wj73c7dTHT/VHBTw9dS/aYfDXHAOsMZp2rSstk1n+RydHLbud2atlVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752669858; c=relaxed/simple;
	bh=UIPWoCIhHisA6XEMP2x/wIrR2XDCK2d1nb90YRAA9Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOI3eT1kO0Lsfqf98SriG4fY5+SxhhJUgb1yNTykiho0ty9garrdVVzw5pDttZJy3qcLvPg0NeLzO5FTt5QMbsJHuyxFdylc9gNPgFlNdpzxfsuEaLR8+5FbwkbYq4Ib6KZMVT1Fd4bSzQ/7yfImJrGTRFekVkcJjmKhIH1LG+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=5DrgZpZO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="5DrgZpZO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1ag9Nvk/Cys3Mu19mNBeZmBxlMmHt3D/vSvbOAfczDY=; b=5DrgZpZOB/FyNl7syWLFDy/lSH
	xSxObF8v8mTl/2y1/vKGPC+2A/i7wBTwo0VQXo+ufyHZKFfax3bIFLERCkbCsJzOGx82na9Ptew1/
	92WThNO6pHbxPleiyWVNlX5fkGcnxwmglX/mPtSi8B9cFn+SH15aqQjXxtuHQwSKjAPWhvbCYiJLy
	Nje1MQCgsjUAyFYkwhnT6KhF+AjOvYI7x7zILwV0Hq8n8LknGYVuTa0u1HQ2AlJ2jpGUX3+mzp7lZ
	AIVKQeV9zBmDo1JRAt37o2u/TuUnsW0WOTF1dJEXxa2UGAweJ8TDXOyZrSYTx2bylPT2/I/Sfi69W
	c2oqQDSA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uc1Ue-00000007guU-1WyH;
	Wed, 16 Jul 2025 12:44:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 7/8] xfs: remove xrep_trans_{alloc,cancel}_hook_dummy
Date: Wed, 16 Jul 2025 14:43:17 +0200
Message-ID: <20250716124352.2146673-8-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250716124352.2146673-1-hch@lst.de>
References: <20250716124352.2146673-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

XFS stopped using current->journal_info in commit f2e812c1522d ("xfs:
don't use current->journal_info"), so there is no point in saving and
restoring it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/repair.c        | 28 ----------------------------
 fs/xfs/scrub/repair.h        |  4 ----
 fs/xfs/scrub/rmap_repair.c   | 10 +++-------
 fs/xfs/scrub/rtrmap_repair.c | 10 +++-------
 4 files changed, 6 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index f7f80ff32afc..d00c18954a26 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1268,34 +1268,6 @@ xrep_setup_xfbtree(
 	return xmbuf_alloc(sc->mp, descr, &sc->xmbtp);
 }
 
-/*
- * Create a dummy transaction for use in a live update hook function.  This
- * function MUST NOT be called from regular repair code because the current
- * process' transaction is saved via the cookie.
- */
-int
-xrep_trans_alloc_hook_dummy(
-	struct xfs_mount	*mp,
-	void			**cookiep,
-	struct xfs_trans	**tpp)
-{
-	*cookiep = current->journal_info;
-	current->journal_info = NULL;
-	*tpp = xfs_trans_alloc_empty(mp);
-	return 0;
-}
-
-/* Cancel a dummy transaction used by a live update hook function. */
-void
-xrep_trans_cancel_hook_dummy(
-	void			**cookiep,
-	struct xfs_trans	*tp)
-{
-	xfs_trans_cancel(tp);
-	current->journal_info = *cookiep;
-	*cookiep = NULL;
-}
-
 /*
  * See if this buffer can pass the given ->verify_struct() function.
  *
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index af0a3a9e5ed9..9c04295742c8 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -180,10 +180,6 @@ int xrep_quotacheck(struct xfs_scrub *sc);
 int xrep_reinit_pagf(struct xfs_scrub *sc);
 int xrep_reinit_pagi(struct xfs_scrub *sc);
 
-int xrep_trans_alloc_hook_dummy(struct xfs_mount *mp, void **cookiep,
-		struct xfs_trans **tpp);
-void xrep_trans_cancel_hook_dummy(void **cookiep, struct xfs_trans *tp);
-
 bool xrep_buf_verify_struct(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
 void xrep_inode_set_nblocks(struct xfs_scrub *sc, int64_t new_blocks);
 int xrep_reset_metafile_resv(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index bf1e632b449a..17d4a38d735c 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -1610,7 +1610,6 @@ xrep_rmapbt_live_update(
 	struct xfs_mount		*mp;
 	struct xfs_btree_cur		*mcur;
 	struct xfs_trans		*tp;
-	void				*txcookie;
 	int				error;
 
 	rr = container_of(nb, struct xrep_rmap, rhook.rmap_hook.nb);
@@ -1621,9 +1620,7 @@ xrep_rmapbt_live_update(
 
 	trace_xrep_rmap_live_update(pag_group(rr->sc->sa.pag), action, p);
 
-	error = xrep_trans_alloc_hook_dummy(mp, &txcookie, &tp);
-	if (error)
-		goto out_abort;
+	tp = xfs_trans_alloc_empty(mp);
 
 	mutex_lock(&rr->lock);
 	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, tp, &rr->rmap_btree);
@@ -1637,14 +1634,13 @@ xrep_rmapbt_live_update(
 	if (error)
 		goto out_cancel;
 
-	xrep_trans_cancel_hook_dummy(&txcookie, tp);
+	xfs_trans_cancel(tp);
 	mutex_unlock(&rr->lock);
 	return NOTIFY_DONE;
 
 out_cancel:
 	xfbtree_trans_cancel(&rr->rmap_btree, tp);
-	xrep_trans_cancel_hook_dummy(&txcookie, tp);
-out_abort:
+	xfs_trans_cancel(tp);
 	mutex_unlock(&rr->lock);
 	xchk_iscan_abort(&rr->iscan);
 out_unlock:
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index 4a56726d9952..7561941a337a 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -844,7 +844,6 @@ xrep_rtrmapbt_live_update(
 	struct xfs_mount		*mp;
 	struct xfs_btree_cur		*mcur;
 	struct xfs_trans		*tp;
-	void				*txcookie;
 	int				error;
 
 	rr = container_of(nb, struct xrep_rtrmap, rhook.rmap_hook.nb);
@@ -855,9 +854,7 @@ xrep_rtrmapbt_live_update(
 
 	trace_xrep_rmap_live_update(rtg_group(rr->sc->sr.rtg), action, p);
 
-	error = xrep_trans_alloc_hook_dummy(mp, &txcookie, &tp);
-	if (error)
-		goto out_abort;
+	tp = xfs_trans_alloc_empty(mp);
 
 	mutex_lock(&rr->lock);
 	mcur = xfs_rtrmapbt_mem_cursor(rr->sc->sr.rtg, tp, &rr->rtrmap_btree);
@@ -871,14 +868,13 @@ xrep_rtrmapbt_live_update(
 	if (error)
 		goto out_cancel;
 
-	xrep_trans_cancel_hook_dummy(&txcookie, tp);
+	xfs_trans_cancel(tp);
 	mutex_unlock(&rr->lock);
 	return NOTIFY_DONE;
 
 out_cancel:
 	xfbtree_trans_cancel(&rr->rtrmap_btree, tp);
-	xrep_trans_cancel_hook_dummy(&txcookie, tp);
-out_abort:
+	xfs_trans_cancel(tp);
 	xchk_iscan_abort(&rr->iscan);
 	mutex_unlock(&rr->lock);
 out_unlock:
-- 
2.47.2

