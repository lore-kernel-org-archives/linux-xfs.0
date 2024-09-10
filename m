Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BC214A4C3
	for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 04:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725942553; cv=none; b=ICDn0CkuPYzf9fIwrSInjbrTDEY0YAg5NKetmyEh8NMNAg/4hRi8w/a5/C8i3Vnd+t0aE444UpFomI9da7K3aZ7rFJUVcntX1i0YXVFCokAsfipqI6CEODVtxJQ+2iNmPOX/A07U98r/2kJtMXjfHljpkzopUteC9qJJtHOMPM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725942553; c=relaxed/simple;
	bh=5nnXUtyYfZ7DLo7NaIxf2PdvDY+fx0h1jl/thkheHFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awFOUDFcYxzNM7gSMFt9qKpFY/UK8ARFINQl9E3kcRxYeMRi7+7CXzwGEHMAMab4zfa2BtPDTgTXxxDa/JSItJKZc0OAjWa4YvsZlu7FCZjLFb3uhNo0CeLtO/nrfzpGp83rrFruXYg2e5M8J/gOM0ZUVlpI8uZJ2sEiOe7KsjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=llkx/v6T; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="llkx/v6T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+cwr44IoqVLLnQZA90U3ZGU+9W7x7ZS5rDhtOUdbAbU=; b=llkx/v6T810smL63+RmZbJdDLL
	bhapBML8aTE04jNUCQ2/UIQVvuvIk1sbpTkqHPJYi3Fv5cDvb1iV61jGrKJkKZAqdATaOuj6dZxNQ
	r7DTQ3oFXdr5ZdSIG70WzvYjAJnO4NJMXmmCxEchMbhwtrW8xY4czwR2+RYf7xZs+mYP5y5GvrOSl
	R70CpGoo7zo/xfgrEkxdIZfS5Ced7Q61HLIYMl3KVgMdPQK9DRk+xD+9k7Z+rBJTXbKHJttdWasC+
	56JKFqcwO73vx22xDodH5BfmBKIHLFgyyCp5//AdqhVoXGjKlGH+ZFBrfy5/8SQNzwAnqKt0A8oli
	8k/uNKEA==;
Received: from ppp-2-84-49-240.home.otenet.gr ([2.84.49.240] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1snsV2-00000004D5C-27Ci;
	Tue, 10 Sep 2024 04:29:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] xfs: merge the perag freeing helpers
Date: Tue, 10 Sep 2024 07:28:45 +0300
Message-ID: <20240910042855.3480387-3-hch@lst.de>
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

There is no good reason to have two different routines for freeing perag
structures for the unmount and error cases.  Add two arguments to specify
the range of AGs to free to xfs_free_perag, and use that to replace
xfs_free_unused_perag_range.

The addition RCU grace period for the error case is harmless, and the
extra check for the AG to actually exist is not required now that the
callers pass the exact known allocated range.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag.c | 40 ++++++++++------------------------------
 fs/xfs/libxfs/xfs_ag.h |  5 ++---
 fs/xfs/xfs_fsops.c     |  2 +-
 fs/xfs/xfs_mount.c     |  5 ++---
 4 files changed, 15 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 5186735da5d45a..3f695100d7ab58 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -185,17 +185,20 @@ xfs_initialize_perag_data(
 }
 
 /*
- * Free up the per-ag resources associated with the mount structure.
+ * Free up the per-ag resources  within the specified AG range.
  */
 void
-xfs_free_perag(
-	struct xfs_mount	*mp)
+xfs_free_perag_range(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		first_agno,
+	xfs_agnumber_t		end_agno)
+
 {
-	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		pag = xa_erase(&mp->m_perags, agno);
+	for (agno = first_agno; agno < end_agno; agno++) {
+		struct xfs_perag	*pag = xa_erase(&mp->m_perags, agno);
+
 		ASSERT(pag);
 		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
 		xfs_defer_drain_free(&pag->pag_intents_drain);
@@ -270,29 +273,6 @@ xfs_agino_range(
 	return __xfs_agino_range(mp, xfs_ag_block_count(mp, agno), first, last);
 }
 
-/*
- * Free perag within the specified AG range, it is only used to free unused
- * perags under the error handling path.
- */
-void
-xfs_free_unused_perag_range(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agstart,
-	xfs_agnumber_t		agend)
-{
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		index;
-
-	for (index = agstart; index < agend; index++) {
-		pag = xa_erase(&mp->m_perags, index);
-		if (!pag)
-			break;
-		xfs_buf_cache_destroy(&pag->pag_bcache);
-		xfs_defer_drain_free(&pag->pag_intents_drain);
-		kfree(pag);
-	}
-}
-
 int
 xfs_initialize_perag(
 	struct xfs_mount	*mp,
@@ -369,7 +349,7 @@ xfs_initialize_perag(
 out_free_pag:
 	kfree(pag);
 out_unwind_new_pags:
-	xfs_free_unused_perag_range(mp, old_agcount, index);
+	xfs_free_perag_range(mp, old_agcount, index);
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 69fc31e7b84728..6e68d6a3161a0f 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -144,13 +144,12 @@ __XFS_AG_OPSTATE(prefers_metadata, PREFERS_METADATA)
 __XFS_AG_OPSTATE(allows_inodes, ALLOWS_INODES)
 __XFS_AG_OPSTATE(agfl_needs_reset, AGFL_NEEDS_RESET)
 
-void xfs_free_unused_perag_range(struct xfs_mount *mp, xfs_agnumber_t agstart,
-			xfs_agnumber_t agend);
 int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t old_agcount,
 		xfs_agnumber_t agcount, xfs_rfsblock_t dcount,
 		xfs_agnumber_t *maxagi);
+void xfs_free_perag_range(struct xfs_mount *mp, xfs_agnumber_t first_agno,
+		xfs_agnumber_t end_agno);
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
-void xfs_free_perag(struct xfs_mount *mp);
 
 /* Passive AG references */
 struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index de2bf0594cb474..b247d895c276d2 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -229,7 +229,7 @@ xfs_growfs_data_private(
 	xfs_trans_cancel(tp);
 out_free_unused_perag:
 	if (nagcount > oagcount)
-		xfs_free_unused_perag_range(mp, oagcount, nagcount);
+		xfs_free_perag_range(mp, oagcount, nagcount);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 0f4f56a7f02d9a..6671ee3849c239 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1044,7 +1044,7 @@ xfs_mountfs(
 		xfs_buftarg_drain(mp->m_logdev_targp);
 	xfs_buftarg_drain(mp->m_ddev_targp);
  out_free_perag:
-	xfs_free_perag(mp);
+	xfs_free_perag_range(mp, 0, mp->m_sb.sb_agcount);
  out_free_dir:
 	xfs_da_unmount(mp);
  out_remove_uuid:
@@ -1125,8 +1125,7 @@ xfs_unmountfs(
 	xfs_errortag_clearall(mp);
 #endif
 	shrinker_free(mp->m_inodegc_shrinker);
-	xfs_free_perag(mp);
-
+	xfs_free_perag_range(mp, 0, mp->m_sb.sb_agcount);
 	xfs_errortag_del(mp);
 	xfs_error_sysfs_del(mp);
 	xchk_stats_unregister(mp->m_scrub_stats);
-- 
2.45.2

