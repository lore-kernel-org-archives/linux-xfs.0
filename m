Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EEE375ACB
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 12:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205018; cv=none; b=Lv8o/XJqqykMdmnedrPir48jAOIAl3etIda7/1y2ZjKTocKww93ywEW+j1YqbKSqyzYo70ja3NZwbGaQoVqaqmSVOoz0lWT4c1/OQXqnyJaLmGThFhuGp8ViMoJ5eoEfZXTaIz+3c+Q4bEMDzsxDbzv4Ib53/GnWyAu2e7rBgi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205018; c=relaxed/simple;
	bh=H646JbF2dUU2qpbclz6uCOnzDcQ3d/8pyzFpx0GSzOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGgI5q0oAtoLyaCJwhbjZ0OshrSQzq6gmWxovIGTEXESMdYb9JuKfi4TZ4JicRygx+XXgAlQ926KI9l5gtx1QVZPHmGw4qOXvVJWrI/r4b5iL+rLsCfTujhMnqb3WUGRREpVTcEbiAKv6Ve+xZ426u6jiXmjeocq62LEJ8Mi85Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xYZdj1j3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xYZdj1j3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SZ+mDC7mBqC7zK0BxCfXVfxRtvkju1EDXe4yFZlGzAQ=; b=xYZdj1j3ZZhrTc1VFKpR7gPcSk
	Fnqn4Ar4B9RJRBmzr1bUDomdLCo683Jvs6zyGWkuXBqL4KTD5Yj5uVKHZpBbLlArU8Ii3gJ6Ak56T
	yzKRzEj04uZesaAqQZ9Z4ge7nOUa5uHKdAQugmZPTPBkxje5kfWM62dg7jzHEoChE1Jaq1lySwlFl
	3C8dj/bL3KOqP1+/CyijSCAdMqVCyILz5xeAUQ61rj653hkjn/AmDRC06oCspatKtAKxH3s2qroWx
	XLxs5WiEfOq2I2Xc+PLp/kXFQAZS/RaQm8MiKwFvjim5yS40GtnngKElsSieaHx7kGxN4Lb4qc0Yp
	EWXoeFag==;
Received: from 2a02-8389-2301-9f00-88fd-fcdd-06aa-821c.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:88fd:fcdd:6aa:821c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDiFT-0000000GR59-34L0;
	Mon, 05 Oct 2026 12:56:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/13] libxfs: remove the unused xfs_log_item.li_mountp field
Date: Mon,  5 Oct 2026 14:56:15 +0200
Message-ID: <20261005125637.1340355-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261005125637.1340355-1-hch@lst.de>
References: <20261005125637.1340355-1-hch@lst.de>
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

