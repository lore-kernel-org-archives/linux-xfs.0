Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C782CCC5
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582374; cv=none; b=g9l5wT3hg/DkCSykB+t5QqkaXJE+Edm0K/zRsHtD7GK4YvwQJ/7E2SSB1+RuOAPzv+Dui3AHz4Qe/uLI+AdoxMQfQoxxqpF5G5oJlBz3kDbHzGaKCRRjhpPbPp5qncsY3F6KmpA+ZUOQXl56si8qo5Gh9GWKZtSQMW3jZByjYNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582374; c=relaxed/simple;
	bh=Gj4AJieG7iIJ8YwLXPn87SogQpZtGyGeeyhvTAd39KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6gaiBOtuNL5KmNWJTeC89Mwvd1xa1okXcZk6dJaaH0ffGyiD4V3MGPX2rcVIR+sjAvRHG6NOVSqmHP89LVLTZZJZNzF2WjQ2tSjtv08UUTAo/R1XnEK+inhuVcxGqQgAdzECCXXZ7eR4wlJgQ8mlhUakhJOl5k21iE6DvGaz3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SPqE2N+M; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SPqE2N+M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZGP8/TA5/3lN3Cy3b+jzO+uUfoDLA3Kbfn2+eQ0lLaE=; b=SPqE2N+M9E9VfBYKlj/10HfnLX
	joUhg18DSebEQixKP9xqEr0ZLc0MaUUCFAkKukOMtHoABDxIWxbbkKsbeW0+yXcfOHyYhyxmwItbz
	fqPGF6nSn9ge/33HX+k51YRy5a3DuXSIILHjejEbYzn1R/533BNiggc0PddGjhzcKX3YiUqffhLHy
	ZH5oPoEPCw+751b+h5RGxgBfG5SV8EZQ2qtDX9tGtYW194wxDQEM+m0Dt5W72QMgLh6duaRDf/0jL
	ZF7foTfiWwGOnA4/evYZ+slhFnEh2hay1gSugAFQmDPEe7q7WjYVwA1pb4C6AJLWtVunK97DI4/va
	wGyPihRw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubejc-0000000540t-0acG;
	Tue, 15 Jul 2025 12:26:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 7/8] xfs: return the allocated transaction from xrep_trans_alloc_hook_dummy
Date: Tue, 15 Jul 2025 14:25:40 +0200
Message-ID: <20250715122544.1943403-8-hch@lst.de>
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

xrep_trans_alloc_hook_dummy can't return errors, so return the allocated
transaction directly instead of an output double pointer argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/repair.c        | 8 +++-----
 fs/xfs/scrub/repair.h        | 4 ++--
 fs/xfs/scrub/rmap_repair.c   | 5 +----
 fs/xfs/scrub/rtrmap_repair.c | 5 +----
 4 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index f7f80ff32afc..79251c595e18 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1273,16 +1273,14 @@ xrep_setup_xfbtree(
  * function MUST NOT be called from regular repair code because the current
  * process' transaction is saved via the cookie.
  */
-int
+struct xfs_trans *
 xrep_trans_alloc_hook_dummy(
 	struct xfs_mount	*mp,
-	void			**cookiep,
-	struct xfs_trans	**tpp)
+	void			**cookiep)
 {
 	*cookiep = current->journal_info;
 	current->journal_info = NULL;
-	*tpp = xfs_trans_alloc_empty(mp);
-	return 0;
+	return xfs_trans_alloc_empty(mp);
 }
 
 /* Cancel a dummy transaction used by a live update hook function. */
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index af0a3a9e5ed9..0a808e903cf5 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -180,8 +180,8 @@ int xrep_quotacheck(struct xfs_scrub *sc);
 int xrep_reinit_pagf(struct xfs_scrub *sc);
 int xrep_reinit_pagi(struct xfs_scrub *sc);
 
-int xrep_trans_alloc_hook_dummy(struct xfs_mount *mp, void **cookiep,
-		struct xfs_trans **tpp);
+struct xfs_trans *xrep_trans_alloc_hook_dummy(struct xfs_mount *mp,
+		void **cookiep);
 void xrep_trans_cancel_hook_dummy(void **cookiep, struct xfs_trans *tp);
 
 bool xrep_buf_verify_struct(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index bf1e632b449a..6024872a17e5 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -1621,9 +1621,7 @@ xrep_rmapbt_live_update(
 
 	trace_xrep_rmap_live_update(pag_group(rr->sc->sa.pag), action, p);
 
-	error = xrep_trans_alloc_hook_dummy(mp, &txcookie, &tp);
-	if (error)
-		goto out_abort;
+	tp = xrep_trans_alloc_hook_dummy(mp, &txcookie);
 
 	mutex_lock(&rr->lock);
 	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, tp, &rr->rmap_btree);
@@ -1644,7 +1642,6 @@ xrep_rmapbt_live_update(
 out_cancel:
 	xfbtree_trans_cancel(&rr->rmap_btree, tp);
 	xrep_trans_cancel_hook_dummy(&txcookie, tp);
-out_abort:
 	mutex_unlock(&rr->lock);
 	xchk_iscan_abort(&rr->iscan);
 out_unlock:
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index 4a56726d9952..5b8155c87873 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -855,9 +855,7 @@ xrep_rtrmapbt_live_update(
 
 	trace_xrep_rmap_live_update(rtg_group(rr->sc->sr.rtg), action, p);
 
-	error = xrep_trans_alloc_hook_dummy(mp, &txcookie, &tp);
-	if (error)
-		goto out_abort;
+	tp = xrep_trans_alloc_hook_dummy(mp, &txcookie);
 
 	mutex_lock(&rr->lock);
 	mcur = xfs_rtrmapbt_mem_cursor(rr->sc->sr.rtg, tp, &rr->rtrmap_btree);
@@ -878,7 +876,6 @@ xrep_rtrmapbt_live_update(
 out_cancel:
 	xfbtree_trans_cancel(&rr->rtrmap_btree, tp);
 	xrep_trans_cancel_hook_dummy(&txcookie, tp);
-out_abort:
 	xchk_iscan_abort(&rr->iscan);
 	mutex_unlock(&rr->lock);
 out_unlock:
-- 
2.47.2

