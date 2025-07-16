Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725302F50A2
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 12:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752669846; cv=none; b=Nm6YjqkWSWrhI/yPp81QW4hNOwKo0GJ553ltEDRlZSoK2dd8gpUUSjUTVKdJBGWTdoVoiOvnPwbkSFcctQjfMqPViX6gLpnRvmp+v8hAmXC5HLTRiio7ApvCBQyiPQD1DgvlRtVV31BRlHuEb3TxSMXWZTxAOqGXlXVpP07f2nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752669846; c=relaxed/simple;
	bh=qlckZRuuHWrMgG+K3rQt5CfyDFVLJEjEvZp6xzfmkdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzaqdv19cGVfzHOKeSSYAg7++L/YIuNle6BIZDcEZNMiIz0YGfW8pu7Kk3yvkwMX8ChYpy3DZWBQNMtiFmrD+PS8ukc4j7HSVsACHk0GsodkNWoEZWdgdmwWEw+KWDee1zdZoWQ7I20h4MGyg1jawi4CYoHM0FhGanjbHReMHsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tLYCMFm2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tLYCMFm2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EucI3SoM/MQpKL0VEj4Jy/2z5SeLxGveyRJOTqXVVWU=; b=tLYCMFm2E1KjcmUlwSRKvlRXha
	QAZk+s+NG+EleT/JPTNcUOxt/hHyKAD/eVhHzeSVvNwvzHG+AEe55WVj7zEx3KdCjbcPt6991uXB8
	0wA/1k7W7KCEeXsL6VsvGWoaRP/pCbXBazcA8XQhQ/xs3MYy1XePfdqErlrio/xzA0Iu0lPkHFdJo
	jwi8wIv+DQnYBVf746NVk51mYQZC6M3Yg16//PLnvSUhgvJ+4+nd8rNzivf0KOBOkbpABs5IS+ltM
	DgaQZHfNgqmMvRpJVqExQlTPpl/7ie2tQ7CZP5Wptbt1cRUAzAL5LZx6DtbUrF3R2YEH5WQSOeDCe
	Vyttqmog==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uc1US-00000007gt4-3J7O;
	Wed, 16 Jul 2025 12:44:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 3/8] xfs: decouple xfs_trans_alloc_empty from xfs_trans_alloc
Date: Wed, 16 Jul 2025 14:43:13 +0200
Message-ID: <20250716124352.2146673-4-hch@lst.de>
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

xfs_trans_alloc_empty only shares the very basic transaction structure
allocation and initialization with xfs_trans_alloc.

Split out a new __xfs_trans_alloc helper for that and otherwise decouple
xfs_trans_alloc_empty from xfs_trans_alloc.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_trans.c | 52 +++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 2213cb2278d2..e5edb89909ed 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -241,6 +241,28 @@ xfs_trans_reserve(
 	return error;
 }
 
+static struct xfs_trans *
+__xfs_trans_alloc(
+	struct xfs_mount	*mp,
+	uint			flags)
+{
+	struct xfs_trans	*tp;
+
+	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) || xfs_has_lazysbcount(mp));
+
+	tp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
+	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
+		sb_start_intwrite(mp->m_super);
+	xfs_trans_set_context(tp);
+	tp->t_flags = flags;
+	tp->t_mountp = mp;
+	INIT_LIST_HEAD(&tp->t_items);
+	INIT_LIST_HEAD(&tp->t_busy);
+	INIT_LIST_HEAD(&tp->t_dfops);
+	tp->t_highest_agno = NULLAGNUMBER;
+	return tp;
+}
+
 int
 xfs_trans_alloc(
 	struct xfs_mount	*mp,
@@ -254,33 +276,16 @@ xfs_trans_alloc(
 	bool			want_retry = true;
 	int			error;
 
+	ASSERT(resp->tr_logres > 0);
+
 	/*
 	 * Allocate the handle before we do our freeze accounting and setting up
 	 * GFP_NOFS allocation context so that we avoid lockdep false positives
 	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
 	 */
 retry:
-	tp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
-	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
-		sb_start_intwrite(mp->m_super);
-	xfs_trans_set_context(tp);
-
-	/*
-	 * Zero-reservation ("empty") transactions can't modify anything, so
-	 * they're allowed to run while we're frozen.
-	 */
-	WARN_ON(resp->tr_logres > 0 &&
-		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
-	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) ||
-	       xfs_has_lazysbcount(mp));
-
-	tp->t_flags = flags;
-	tp->t_mountp = mp;
-	INIT_LIST_HEAD(&tp->t_items);
-	INIT_LIST_HEAD(&tp->t_busy);
-	INIT_LIST_HEAD(&tp->t_dfops);
-	tp->t_highest_agno = NULLAGNUMBER;
-
+	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
+	tp = __xfs_trans_alloc(mp, flags);
 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
 	if (error == -ENOSPC && want_retry) {
 		xfs_trans_cancel(tp);
@@ -329,9 +334,8 @@ xfs_trans_alloc_empty(
 	struct xfs_mount		*mp,
 	struct xfs_trans		**tpp)
 {
-	struct xfs_trans_res		resv = {0};
-
-	return xfs_trans_alloc(mp, &resv, 0, 0, XFS_TRANS_NO_WRITECOUNT, tpp);
+	*tpp = __xfs_trans_alloc(mp, XFS_TRANS_NO_WRITECOUNT);
+	return 0;
 }
 
 /*
-- 
2.47.2

