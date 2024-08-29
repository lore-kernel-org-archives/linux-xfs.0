Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70DE1870
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 04:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724904550; cv=none; b=dkzAjxkPbgX4RG+Q205XYtUTvsc2FQ9ZFxNlXn0jrstaEwFyAPKJWZOO6gRJ6Nn5BDUrum4hviC5wVlk7CTdk/qSfZBgN+udZf/uFUWja7HgzeAAedKERBqPJKrQbvkYx6aGKqKaSOsTQ08kCTAucBvFR/LgaoMsunypewLsWkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724904550; c=relaxed/simple;
	bh=91ApzQLf/S4N8snc6igXdHkVv9Myi8XKOwHDWABhZuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbNcyQyxOCA/PWt4FTBIlFtAyokxerG8bu0D/rtBkSfBLF3UBBYScrjGuN3DNdxlBUCQPXXc5rKEr5An9d41MnqOOPpaT2S+WAh9Lh24bPpC9SJBBcuAONpY2aq002nsUxGGalP2am7Ez09vVifZ3JSbfLmzbqRrbr4AuiDoYJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rpzBjSMu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rpzBjSMu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QFTXjl9bFzBRwcPLm4i913YUYG9dkAAbGjQ0r8g9hdU=; b=rpzBjSMuF700ZljiuOC/jIlSbA
	lPcEpyCbKH9D3QCnwqqfh5q3ILXzZzGs5WU5SQuOva0UtEsqhCp0qhCo7VbMA9dpdamzMB80i1KqF
	a5vH4Gvix6sD/BmwAZLUYfNRkzPKsE1x5xrlET7eafZgzDpB40eH3/Ubv4kXH0lnEsIVw8LAn293A
	QFtBeL3HgU7wCAV5hExdd50qIV/FWTihvFoa9iz3vVetWd0zDRewzLwzTy5bKh+fYVBZiAbH2qcnx
	5GuoTl6BlZcDgkzzxCHIZXcWrqbx9ItzQ0lr4NogZxcG/l/0pk646cUpkXmDfSuT0CARJrpU4bFtl
	/KtPGaYA==;
Received: from ppp-2-84-49-240.home.otenet.gr ([2.84.49.240] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sjWT5-00000000RxX-2qWT;
	Thu, 29 Aug 2024 04:09:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] xfs: simplify tagged perag iteration
Date: Thu, 29 Aug 2024 07:08:39 +0300
Message-ID: <20240829040848.1977061-4-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240829040848.1977061-1-hch@lst.de>
References: <20240829040848.1977061-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Pass the old perag structure to the tagged loop helpers so that they can
grab the old agno before releasing the reference.  This removes the need
to separately track the agno and the iterator macro, and thus also
obsoletes the for_each_perag_tag syntactic sugar.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 71 +++++++++++++++++++++------------------------
 fs/xfs/xfs_trace.h  |  4 +--
 2 files changed, 35 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index ac604640d36229..573743b1841fe7 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -293,63 +293,66 @@ xfs_perag_clear_inode_tag(
 }
 
 /*
- * Search from @first to find the next perag with the given tag set.
+ * Find the next AG after @pag, or the first AG if @pag is NULL.
  */
 static struct xfs_perag *
-xfs_perag_get_tag(
+xfs_perag_get_next_tag(
 	struct xfs_mount	*mp,
-	xfs_agnumber_t		first,
+	struct xfs_perag	*pag,
 	unsigned int		tag)
 {
-	struct xfs_perag	*pag;
+	unsigned long		index = 0;
 	int			found;
 
+	if (pag) {
+		index = pag->pag_agno + 1;
+		xfs_perag_rele(pag);
+	}
+
 	rcu_read_lock();
 	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
-					(void **)&pag, first, 1, tag);
+					(void **)&pag, index, 1, tag);
 	if (found <= 0) {
 		rcu_read_unlock();
 		return NULL;
 	}
-	trace_xfs_perag_get_tag(pag, _RET_IP_);
+	trace_xfs_perag_get_next_tag(pag, _RET_IP_);
 	atomic_inc(&pag->pag_ref);
 	rcu_read_unlock();
 	return pag;
 }
 
 /*
- * Search from @first to find the next perag with the given tag set.
+ * Find the next AG after @pag, or the first AG if @pag is NULL.
  */
 static struct xfs_perag *
-xfs_perag_grab_tag(
+xfs_perag_grab_next_tag(
 	struct xfs_mount	*mp,
-	xfs_agnumber_t		first,
+	struct xfs_perag	*pag,
 	int			tag)
 {
-	struct xfs_perag	*pag;
+	unsigned long		index = 0;
 	int			found;
 
+	if (pag) {
+		index = pag->pag_agno + 1;
+		xfs_perag_rele(pag);
+	}
+
 	rcu_read_lock();
 	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
-					(void **)&pag, first, 1, tag);
+					(void **)&pag, index, 1, tag);
 	if (found <= 0) {
 		rcu_read_unlock();
 		return NULL;
 	}
-	trace_xfs_perag_grab_tag(pag, _RET_IP_);
+	trace_xfs_perag_grab_next_tag(pag, _RET_IP_);
 	if (!atomic_inc_not_zero(&pag->pag_active_ref))
 		pag = NULL;
 	rcu_read_unlock();
 	return pag;
 }
 
-#define for_each_perag_tag(mp, agno, pag, tag) \
-	for ((agno) = 0, (pag) = xfs_perag_grab_tag((mp), 0, (tag)); \
-		(pag) != NULL; \
-		(agno) = (pag)->pag_agno + 1, \
-		xfs_perag_rele(pag), \
-		(pag) = xfs_perag_grab_tag((mp), (agno), (tag)))
-
 /*
  * When we recycle a reclaimable inode, we need to re-initialise the VFS inode
  * part of the structure. This is made more complex by the fact we store
@@ -1077,15 +1080,11 @@ long
 xfs_reclaim_inodes_count(
 	struct xfs_mount	*mp)
 {
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		ag = 0;
+	struct xfs_perag	*pag = NULL;
 	long			reclaimable = 0;
 
-	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
-		ag = pag->pag_agno + 1;
+	while ((pag = xfs_perag_get_next_tag(mp, pag, XFS_ICI_RECLAIM_TAG)))
 		reclaimable += pag->pag_ici_reclaimable;
-		xfs_perag_put(pag);
-	}
 	return reclaimable;
 }
 
@@ -1427,14 +1426,13 @@ void
 xfs_blockgc_start(
 	struct xfs_mount	*mp)
 {
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag = NULL;
 
 	if (xfs_set_blockgc_enabled(mp))
 		return;
 
 	trace_xfs_blockgc_start(mp, __return_address);
-	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
+	while ((pag = xfs_perag_grab_next_tag(mp, pag, XFS_ICI_BLOCKGC_TAG)))
 		xfs_blockgc_queue(pag);
 }
 
@@ -1550,21 +1548,19 @@ int
 xfs_blockgc_flush_all(
 	struct xfs_mount	*mp)
 {
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag = NULL;
 
 	trace_xfs_blockgc_flush_all(mp, __return_address);
 
 	/*
-	 * For each blockgc worker, move its queue time up to now.  If it
-	 * wasn't queued, it will not be requeued.  Then flush whatever's
-	 * left.
+	 * For each blockgc worker, move its queue time up to now.  If it wasn't
+	 * queued, it will not be requeued.  Then flush whatever is left.
 	 */
-	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
+	while ((pag = xfs_perag_grab_next_tag(mp, pag, XFS_ICI_BLOCKGC_TAG)))
 		mod_delayed_work(pag->pag_mount->m_blockgc_wq,
 				&pag->pag_blockgc_work, 0);
 
-	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
+	while ((pag = xfs_perag_grab_next_tag(mp, pag, XFS_ICI_BLOCKGC_TAG)))
 		flush_delayed_work(&pag->pag_blockgc_work);
 
 	return xfs_inodegc_flush(mp);
@@ -1810,12 +1806,11 @@ xfs_icwalk(
 	enum xfs_icwalk_goal	goal,
 	struct xfs_icwalk	*icw)
 {
-	struct xfs_perag	*pag;
+	struct xfs_perag	*pag = NULL;
 	int			error = 0;
 	int			last_error = 0;
-	xfs_agnumber_t		agno;
 
-	for_each_perag_tag(mp, agno, pag, goal) {
+	while ((pag = xfs_perag_grab_next_tag(mp, pag, goal))) {
 		error = xfs_icwalk_ag(pag, goal, icw);
 		if (error) {
 			last_error = error;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 180ce697305a92..002d012ebd83cb 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -210,11 +210,11 @@ DEFINE_EVENT(xfs_perag_class, name,	\
 	TP_PROTO(struct xfs_perag *pag, unsigned long caller_ip), \
 	TP_ARGS(pag, caller_ip))
 DEFINE_PERAG_REF_EVENT(xfs_perag_get);
-DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag);
+DEFINE_PERAG_REF_EVENT(xfs_perag_get_next_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_hold);
 DEFINE_PERAG_REF_EVENT(xfs_perag_put);
 DEFINE_PERAG_REF_EVENT(xfs_perag_grab);
-DEFINE_PERAG_REF_EVENT(xfs_perag_grab_tag);
+DEFINE_PERAG_REF_EVENT(xfs_perag_grab_next_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_rele);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_inode_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
-- 
2.43.0

