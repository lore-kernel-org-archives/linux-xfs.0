Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98984D1781
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349540; cv=none; b=FbMCUgdgBTUwHrnuHBEWD5D7/WqAkJZtoPG4XQJoRPu1Qbi29w7rdq9E4fiJTJqdKWyT0Xxcb+Q8ulSlTvVP9+gIcXImyYc1zbQ/Gadbszx1zp9pVuHkSl3F7p40Q3thUyCuBBtd4V+3NhP0VmeeuK8mI6ZXDz98ELNERKXtGmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349540; c=relaxed/simple;
	bh=A752t2r+5zGumfObxt8nS/RPWKCDPDL4YqUuJ2H9Zpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7dr+K0DukyS3VNebnsVagHr9nmt+UOPl9XK0mWdlDtHq0MyQeMzTYodLCjTh0XFTjNqEstI8yFaR+EEGoc0uRWwlV5lSGKCoG9wxdfvDL6SMm5fvdP5IyiYjek1byxK+8xBbJqx8tOnPD90QmrvfU6UBVO+4F3r/arnSExL3sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3+y7N8Gs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3+y7N8Gs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OmKQMsWDOQG8Y6Mb6UtBKK9UeRZhJyVY+bbXWSLMzxU=; b=3+y7N8Gsr5ZA1fVT03bfCZTKtH
	WRV9/7JFkm1v6+nGSS9WbifgKPi3Ef+1Gp34+jsQ/nY27DIpUfBazpCfGNOoTYgfU80wzrQ/W/J31
	tEN1C2ZTy8SKSx2OXy1JKkzVpXHJ7HKPADYBVBXwM8FN4tO9qLYPe0A5ytOz0foe8OjGUx5P4SPSE
	RUS5Gpt9qx7rK4C/cqC/fNd57CE5Cqp60Z+h4gJDOwfJn90DRfJBYU5L17TAfNEZi1mtbJoZsUyYa
	ei8Z3EhW23zBEyjliasvPtQv1TBhbQomPLFLof/+FPNRy3QJG/39DxmdXSojTaaQsTDUEO5AwFitS
	erQMGnPA==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7hH-0000000DlF8-0NT1;
	Fri, 25 Sep 2026 15:18:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: remove various unused includes in libxfs/
Date: Fri, 25 Sep 2026 17:18:26 +0200
Message-ID: <20260925151841.3385994-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925151841.3385994-1-hch@lst.de>
References: <20260925151841.3385994-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Remove a few unused includes in libxfs/ that cause spurious differences
between the kernel and userspace versions of these files.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_defer.c     | 1 -
 fs/xfs/libxfs/xfs_inode_buf.c | 1 -
 fs/xfs/libxfs/xfs_refcount.c  | 1 -
 fs/xfs/libxfs/xfs_rtbitmap.c  | 1 -
 fs/xfs/libxfs/xfs_rtgroup.c   | 1 -
 fs/xfs/libxfs/xfs_sb.c        | 1 -
 6 files changed, 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 3152acdc335d..c5fa4450281d 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -24,7 +24,6 @@
 #include "xfs_refcount.h"
 #include "xfs_bmap.h"
 #include "xfs_alloc.h"
-#include "xfs_buf.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 0340e2189921..b82f067ca5b1 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -14,7 +14,6 @@
 #include "xfs_inode.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
-#include "xfs_icache.h"
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
 #include "xfs_dir2.h"
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 0ec6ccd8b4dc..6b67308fa594 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -26,7 +26,6 @@
 #include "xfs_health.h"
 #include "xfs_refcount_item.h"
 #include "xfs_rtgroup.h"
-#include "xfs_rtalloc.h"
 #include "xfs_rtrefcount_btree.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index e62786e90f7b..590e0641ff0d 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -16,7 +16,6 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_trans.h"
-#include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_health.h"
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index fe7222bbe449..c6981f566860 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -27,7 +27,6 @@
 #include "xfs_trans.h"
 #include "xfs_trace.h"
 #include "xfs_inode.h"
-#include "xfs_icache.h"
 #include "xfs_buf_item.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index d2ef7b20a49f..ce44123c98ce 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -26,7 +26,6 @@
 #include "xfs_health.h"
 #include "xfs_ag.h"
 #include "xfs_rtbitmap.h"
-#include "xfs_exchrange.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtrefcount_btree.h"
-- 
2.53.0

