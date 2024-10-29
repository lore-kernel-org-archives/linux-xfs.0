Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96070192B63
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 15:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730214753; cv=none; b=TvIdve6KYiBTQ4WweMrTtjsijsugTdURG3tdYxVFOL9MtZOmoyJlDncWV0mtetY4uNydp0nadWViS3KjRkTKzdfrgGa6+EEDE+BvLRX8DxLoM/Ob52T4q1aMtKPF49GABdjTXa/ZvKX9MuIT9YuqNiOfIky4iN85Mr8F6arnTY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730214753; c=relaxed/simple;
	bh=GPh2GAapT0BQVloyUXp6jQFdR/WUu53FO3h1cwuQh8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eabq1CujHvMLzFuDerhSiK9s45SC7jelQFdUB4isb5AtXnVz67rjw6c4dF/oP/oF9kiVk0PS0HRkH1RSMaCuFJb4KEJrBhpLsAj4a3Ea0duTBdFUQuHOEMaBqoC+0DXMUORW8ib2JSPfAhA9bKfEYSFNSZb10JfJ9/XOvOieLnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UHe6BwMn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UHe6BwMn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ddrkNXVxAfkB5dngi+D0S6YET5DG/cNomisnRWc7EeE=; b=UHe6BwMnRLL6UagVd8zllZZPws
	eCJvTG5sb9Q8UwhCCYZeTAqP9b40yRkinSyAWL2w3iiocaIYwRS+37++cZ9GOhoG1egz9HZUTL+r8
	icNM62iebGYRAUYXWonhp3P5PtCsho/M9TIgCM9qTqaYTAfiqpBi3kkB98zPo7alhW6mBU6DPkXgJ
	A8jPBXccJrR7eHGIXaYXB80ETv0fEMkrsP8SnjOaxNEYPkOGOj0Y83QA81YKDEQybS0N3CJFyDfCa
	yK4tVlPLZe3hkvVFwPkiAuwm12PrHpVCQZHcIjmSIFdQ2A4oX3klNCXTy+UhNsNPgWzgzav8fmwqC
	Ryqpg3Ag==;
Received: from 2a02-8389-2341-5b80-1009-120a-6297-8bca.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1009:120a:6297:8bca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t5ntW-0000000Eqtx-2ZzM;
	Tue, 29 Oct 2024 15:12:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs: remove xfs_page_mkwrite_iomap_ops
Date: Tue, 29 Oct 2024 16:12:00 +0100
Message-ID: <20241029151214.255015-5-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241029151214.255015-1-hch@lst.de>
References: <20241029151214.255015-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Shared the regular buffered write iomap_ops with the page fault path
and just check for the IOMAP_FAULT flag to skip delalloc punching.

This keeps the delalloc punching checks in one place, and will make it
easier to convert iomap to an iter model where the begin and end
handlers are merged into a single callback.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c  |  2 +-
 fs/xfs/xfs_iomap.c | 17 ++++++++---------
 fs/xfs/xfs_iomap.h |  1 -
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7464d874e766..c6de6b865ef1 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1474,7 +1474,7 @@ xfs_write_fault(
 	if (IS_DAX(inode))
 		ret = xfs_dax_fault_locked(vmf, order, true);
 	else
-		ret = iomap_page_mkwrite(vmf, &xfs_page_mkwrite_iomap_ops);
+		ret = iomap_page_mkwrite(vmf, &xfs_buffered_write_iomap_ops);
 	xfs_iunlock(ip, lock_mode);
 
 	sb_end_pagefault(inode->i_sb);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 916531d9f83c..bfc5b0a4d633 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1234,6 +1234,14 @@ xfs_buffered_write_iomap_end(
 	if (iomap->type != IOMAP_DELALLOC || !(iomap->flags & IOMAP_F_NEW))
 		return 0;
 
+	/*
+	 * iomap_page_mkwrite() will never fail in a way that requires delalloc
+	 * extents that it allocated to be revoked.  Hence never try to release
+	 * them here.
+	 */
+	if (flags & IOMAP_FAULT)
+		return 0;
+
 	/* Nothing to do if we've written the entire delalloc extent */
 	start_byte = iomap_last_written_block(inode, offset, written);
 	end_byte = round_up(offset + length, i_blocksize(inode));
@@ -1260,15 +1268,6 @@ const struct iomap_ops xfs_buffered_write_iomap_ops = {
 	.iomap_end		= xfs_buffered_write_iomap_end,
 };
 
-/*
- * iomap_page_mkwrite() will never fail in a way that requires delalloc extents
- * that it allocated to be revoked. Hence we do not need an .iomap_end method
- * for this operation.
- */
-const struct iomap_ops xfs_page_mkwrite_iomap_ops = {
-	.iomap_begin		= xfs_buffered_write_iomap_begin,
-};
-
 static int
 xfs_read_iomap_begin(
 	struct inode		*inode,
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 4da13440bae9..8347268af727 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -48,7 +48,6 @@ xfs_aligned_fsb_count(
 }
 
 extern const struct iomap_ops xfs_buffered_write_iomap_ops;
-extern const struct iomap_ops xfs_page_mkwrite_iomap_ops;
 extern const struct iomap_ops xfs_direct_write_iomap_ops;
 extern const struct iomap_ops xfs_read_iomap_ops;
 extern const struct iomap_ops xfs_seek_iomap_ops;
-- 
2.45.2

