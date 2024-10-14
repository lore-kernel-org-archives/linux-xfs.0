Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289D12B9A6
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 06:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728885928; cv=none; b=aTwHmTgdIxfgjypOae9pHv8e5q0d5YJU13Aze5F8mRgatL6KJOyLY6Y5qsUcWIB/XRIewD1h2lSY2zMBUtHP/7isfTwWYKfBLCVNcj9cQyJBB8QDCqaQEMZEpsz3u0QHMg2h2ZnWSuobm10K/ozGnP0xrBlnyp/FKKn9vYXcRIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728885928; c=relaxed/simple;
	bh=f2IQ0B+wdfeyt1uzCjy9WFjUINDhTgbuXtTz0QLhUtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPeM3rp5QXmN43V8TEc+GblmAbkIeXZerXvtIM7r0vNMC5fiy3/T5Xb71EVN6xp13FzuolKBpugAO1DkFbrnASGV0OAHzWoGD0BV11iiFJko/OpOJ/GWUj0s+PUyJZa/76yiSQXPLpe/tVmMpPEp4uUuqUtAtFBE35hsxdMMmIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SWAP8qIe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SWAP8qIe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VvX2vleVmQhN8aw/WkPAA9sTtX8z/8zYs/IpEisnhWY=; b=SWAP8qIeurVrKMJh0ex/UvHBDw
	zlXA5+7JgimnT1JC2ZjpRTAMvto6ao9d6uPhyXeKfjMDLU5ybUdUMmfTnxsUsWTkQNJB4tOAj3R32
	jg8Xs1ygqP/eqCTvtjmgpyW9JqsKRXUNmQCq1Sv+Rs0EiQoXnPW5560Af4A+EQ6GbepWoKGe/h10x
	gLHLqjp8OaoWHEzsCglaebYw647p+rfgXa0ohHf1A/RZr0+EHlPj69eMYkJFxhIu7aScuG1fgiAd7
	gpV/isKNMWW1QfpGFzy9rOJl5uflN2Y8u0qZ6s8UCPbYKqvb9dKzOsDbuJbN9yMaQTgQXampjeJbk
	Iea1axcQ==;
Received: from 2a02-8389-2341-5b80-fa4a-5f67-ca73-5831.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:fa4a:5f67:ca73:5831] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t0ECr-00000003pdZ-0vz3;
	Mon, 14 Oct 2024 06:05:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/6] xfs: merge the perag freeing helpers
Date: Mon, 14 Oct 2024 08:04:51 +0200
Message-ID: <20241014060516.245606-3-hch@lst.de>
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

There is no good reason to have two different routines for freeing perag
structures for the unmount and error cases.  Add two arguments to specify
the range of AGs to free to xfs_free_perag, and use that to replace
xfs_free_unused_perag_range.

The addition RCU grace period for the error case is harmless, and the
extra check for the AG to actually exist is not required now that the
callers pass the exact known allocated range.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c | 40 ++++++++++------------------------------
 fs/xfs/libxfs/xfs_ag.h |  5 ++---
 fs/xfs/xfs_fsops.c     |  2 +-
 fs/xfs/xfs_mount.c     |  5 ++---
 4 files changed, 15 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 464f682eab4690..8ace2cc200a60e 100644
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
@@ -366,7 +346,7 @@ xfs_initialize_perag(
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
index 6fa7239a4a01b6..25bbcc3f4ee08b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1048,7 +1048,7 @@ xfs_mountfs(
 		xfs_buftarg_drain(mp->m_logdev_targp);
 	xfs_buftarg_drain(mp->m_ddev_targp);
  out_free_perag:
-	xfs_free_perag(mp);
+	xfs_free_perag_range(mp, 0, mp->m_sb.sb_agcount);
  out_free_dir:
 	xfs_da_unmount(mp);
  out_remove_uuid:
@@ -1129,8 +1129,7 @@ xfs_unmountfs(
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

