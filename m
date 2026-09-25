Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D724C8C5A
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349684; cv=none; b=sLevsebvkUSRAsOP0ZEoZqCsqnHA+qSKZ6uI8+17V0pXNeEm5ee12IBtqi3mh0eApbV6dI6/32mK+6yrBwwYsNIxdIqnKzZeo0XXhhD1FLzaSND1S7jNzn8ONdNZNeWscmSmNNsuD6Opnoect/fum0LnzaMT/Nk+OipNvYDP4sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349684; c=relaxed/simple;
	bh=H646JbF2dUU2qpbclz6uCOnzDcQ3d/8pyzFpx0GSzOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyCZXr6EBad2q/I23zhqkABgbyljSZUaF7sG6iC1ZtjG8eDCAkPkdCsQfA448sydG6V295OsYGmu2xMkSG2TLam1ZDfbshhKKuWPbjHrWst2hHSjV8dX3Ih5HwWL208rwKOGEl8rsNgzRR+6PH7o2JiaLleGxnk311QkcCK0148=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=orAM4UWk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="orAM4UWk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SZ+mDC7mBqC7zK0BxCfXVfxRtvkju1EDXe4yFZlGzAQ=; b=orAM4UWk2BHXsQwX0bmTt792xn
	gUW5WdzYCFiH1c0TOlkM9ulAXo9phBhwrSx4SrDb04iSzfCVBZxrMODPu4+GEoy02OhllSnRXLwmM
	1ZRr9WrSj+gZN6TyLVkWN44og8KqMcC+IaNV9uHJpUQfdsWxe9uV2zLhhNZPP0YP8RcuCNZze6W+s
	YUaD5rdlsWDYABL8uVJLA1YoDjVNpnq7mPG2TIuoJGLnqT8MpmcsEXcA6ajbs9ef9SN4clJ1CNDxO
	axEjYL6SixAsCBeCB6K83eUQ+HjNu+UYvdgGK4vlr1xcHXaQxdTLqwZUNU0XmEJmk4RoZQ8izyx6B
	nhgjgDww==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7jm-0000000Dlcw-2ZHy;
	Fri, 25 Sep 2026 15:21:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 05/13] libxfs: remove the unused xfs_log_item.li_mountp field
Date: Fri, 25 Sep 2026 17:20:24 +0200
Message-ID: <20260925152107.3386097-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925152107.3386097-1-hch@lst.de>
References: <20260925152107.3386097-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

To prepare for reusing the kernel version of the struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/stubs/xfs_trans.h | 1 -
 libxfs/trans.c           | 1 -
 libxfs/util.c            | 1 -
 3 files changed, 3 deletions(-)

diff --git a/libxfs/stubs/xfs_trans.h b/libxfs/stubs/xfs_trans.h
index 9102bc6f5b27..9b6a47988147 100644
--- a/libxfs/stubs/xfs_trans.h
+++ b/libxfs/stubs/xfs_trans.h
@@ -24,7 +24,6 @@ struct xfs_item_ops {
 typedef struct xfs_log_item {
 	struct list_head		li_trans;	/* transaction list */
 	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
-	struct xfs_mount		*li_mountp;	/* ptr to fs mount */
 	uint				li_type;	/* item type */
 	unsigned long			li_flags;	/* misc flags */
 	struct xfs_buf			*li_buf;	/* real buffer pointer */
diff --git a/libxfs/trans.c b/libxfs/trans.c
index c89b035ffeaf..9dd2e244a812 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -52,7 +52,6 @@ libxfs_trans_add_item(
 	struct xfs_trans	*tp,
 	struct xfs_log_item	*lip)
 {
-	ASSERT(lip->li_mountp == tp->t_mountp);
 	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
 	ASSERT(list_empty(&lip->li_trans));
 	ASSERT(!test_bit(XFS_LI_DIRTY, &lip->li_flags));
diff --git a/libxfs/util.c b/libxfs/util.c
index 6cbbe9056eba..2d8f57abd585 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -408,7 +408,6 @@ xfs_log_item_init(
 	int			type,
 	const struct xfs_item_ops *ops)
 {
-	item->li_mountp = mp; 
 	item->li_type = type;
 	item->li_ops = ops;
 
-- 
2.53.0

