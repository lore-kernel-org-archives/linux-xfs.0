Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D871870
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 04:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724904558; cv=none; b=lriJCxKKhdpGwUSoI4IUdqEchwYWsIksUnihvOUrq/tQi7CiS4m3+MunBwcIAWWYEWmtGu5ovl3rBj4boU25V/S/gHBfiJseM2lHQ7PP8QKtZkPbotuVRPL68rPY/MEsw+06pkcdiFtNKmdrj321qVUf6BvJ/OgL+oH2rzogyUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724904558; c=relaxed/simple;
	bh=bcdtL2rA6xvys0bGpPScdtxXF08MzmFOUxCbOD/W2/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wauy00LA3p5oqnYiaA6MtFK5AeGlM3HYbK7VN7OzrooDogg0ztRea9LDNtxfZJiD0YDeZU/Oy1L2cAPZmK+gMSwdk7igMaUcm6UrqvlFaSwLbzhr6rr6L2150j4NMZ6tf4t4w8/kD/lXAvNjYvBaYfr2luAm0bb7lM5xCTZNuMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eEL+Nv49; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eEL+Nv49"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tgNuZ2jfckH6W7FWcgMXwJc2Lse4X7m9rWGmX50R65E=; b=eEL+Nv49axUfDmpOCHgU7M+/lH
	2YwB6DDaLMce8nWxkbe+sy7alehIZawOGafP2d+W0aX0JXdSo9rd8naISd8s/IUm/c+Uop3LT+UIw
	EfWegf/KuZUV/+WRnh07I1trh7eqJSfgRezsCwOy1k85VJwlDO5Ic76d3l7MjeBPCKQJ5qhQwE1sM
	5/J624ymu3lBM7LyQ1bVCo9CDPcVbYZMqa/U2bMfKph1kRkfod+nJKXjgMngiOP6rbeFE6kFvAg3J
	r3zkJtDcOORIg1033N/z9rfRFJzogLxngnm1lEwjc8CBKiIZmG6iYoIripzu1yLrQO9BCIBx+5W4i
	tFKyKE5A==;
Received: from ppp-2-84-49-240.home.otenet.gr ([2.84.49.240] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sjWTD-00000000Rzd-1VMh;
	Thu, 29 Aug 2024 04:09:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] xfs: use xas_for_each_marked in xfs_reclaim_inodes_count
Date: Thu, 29 Aug 2024 07:08:41 +0300
Message-ID: <20240829040848.1977061-6-hch@lst.de>
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

xfs_reclaim_inodes_count iterates over all AGs to sum up the reclaimable
inodes counts.  There is no point in grabbing a reference to the them or
unlock the RCU critical section for each iteration, so switch to the
more efficient xas_for_each_marked iterator.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c | 36 ++++++++----------------------------
 fs/xfs/xfs_trace.h  |  2 +-
 2 files changed, 9 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 7ee32056897d58..d36dbaba660013 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -300,32 +300,6 @@ xfs_perag_clear_inode_tag(
 	trace_xfs_perag_clear_inode_tag(pag, _RET_IP_);
 }
 
-/*
- * Find the next AG after @pag, or the first AG if @pag is NULL.
- */
-static struct xfs_perag *
-xfs_perag_get_next_tag(
-	struct xfs_mount	*mp,
-	struct xfs_perag	*pag,
-	unsigned int		tag)
-{
-	unsigned long		index = 0;
-
-	if (pag) {
-		index = pag->pag_agno + 1;
-		xfs_perag_rele(pag);
-	}
-
-	rcu_read_lock();
-	pag = xa_find(&mp->m_perags, &index, ULONG_MAX, ici_tag_to_mark(tag));
-	if (pag) {
-		trace_xfs_perag_get_next_tag(pag, _RET_IP_);
-		atomic_inc(&pag->pag_ref);
-	}
-	rcu_read_unlock();
-	return pag;
-}
-
 /*
  * Find the next AG after @pag, or the first AG if @pag is NULL.
  */
@@ -1080,11 +1054,17 @@ long
 xfs_reclaim_inodes_count(
 	struct xfs_mount	*mp)
 {
-	struct xfs_perag	*pag = NULL;
+	XA_STATE		(xas, &mp->m_perags, 0);
 	long			reclaimable = 0;
+	struct xfs_perag	*pag;
 
-	while ((pag = xfs_perag_get_next_tag(mp, pag, XFS_ICI_RECLAIM_TAG)))
+	rcu_read_lock();
+	xas_for_each_marked(&xas, pag, ULONG_MAX, XFS_PERAG_RECLAIM_MARK) {
+		trace_xfs_reclaim_inodes_count(pag, _THIS_IP_);
 		reclaimable += pag->pag_ici_reclaimable;
+	}
+	rcu_read_unlock();
+
 	return reclaimable;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 002d012ebd83cb..d73c0a49d9dc29 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -210,7 +210,6 @@ DEFINE_EVENT(xfs_perag_class, name,	\
 	TP_PROTO(struct xfs_perag *pag, unsigned long caller_ip), \
 	TP_ARGS(pag, caller_ip))
 DEFINE_PERAG_REF_EVENT(xfs_perag_get);
-DEFINE_PERAG_REF_EVENT(xfs_perag_get_next_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_hold);
 DEFINE_PERAG_REF_EVENT(xfs_perag_put);
 DEFINE_PERAG_REF_EVENT(xfs_perag_grab);
@@ -218,6 +217,7 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_grab_next_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_rele);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_inode_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
+DEFINE_PERAG_REF_EVENT(xfs_reclaim_inodes_count);
 
 TRACE_EVENT(xfs_inodegc_worker,
 	TP_PROTO(struct xfs_mount *mp, unsigned int shrinker_hits),
-- 
2.43.0

