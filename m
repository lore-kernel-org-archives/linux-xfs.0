Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795D44A21
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349700; cv=none; b=XApm/WMTfD1FAH71OwSol89F2Tnxmr+rZ5uPFh22W+D/q7t2+FFqKd9E7FgPzx2qvwkQSEgCl8VNOIrPemkPGHBJK8ua4BggA+oj202aYbdMSwFNxthTcvUYC4IvArLkjC3Y46iNsYEEG0bg5CGyGOATlz2ilbkrxa+KFn2ZkYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349700; c=relaxed/simple;
	bh=kJvRsbfzFtB/Ewc1RZtqUFq2Bg14gomPhniMVRQrFNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dISxJFwbz6TAD+hq+Zca1P2GzNOs5YC1Gg4Oy76YtAQffdhaTOUCkmOqEsfaVh4/ntqbijY0bzMUEtcichwMGLh9C7rot17K8ra8T9Nm6JMIGSGyHsx/6FwEzTTOZLrxkP0kwEaYBlQHgqNBvAikFhzVsMY9C0hDSqNUz2TcUME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iE7m2Xc+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iE7m2Xc+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=F9e5PGJgaR0D1hVppEkvxdvErU0PltpJ2mS1HMoWhOQ=; b=iE7m2Xc+0nVTYBh+gxaZtq5CX7
	pWqESkh/aNOSVdnHVedkO5UOrsgZtCTsBEtp5BMJD5llI37A1bT0rH7PkwdqFblQIRbhRwU8zIwql
	TpCMYBy6JFVuPKMaYr8sEQcfX6SjMmHtBkVLzdkCUiX1y8rV5cxMwfJg/2WrJU3y2iPR5famrFJeq
	BD+XqNqsK7WzFSrtHW7zNALH4lcgShJTbMaivFWlWNax/NpDBmKm47a4Y9SejVd89aDG3HZDbeg+9
	NsKzdTFvSPUXAHFisNUZNE8qae5aLkBncTNFT4feV86W1ZSx8Zpqt41cV0Dh4nJcFZ7avrAlKHsbT
	+ddb14+A==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7k2-0000000DlfE-2e5W;
	Fri, 25 Sep 2026 15:21:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 11/13] libxfs: cleanup xfs_trans.h
Date: Fri, 25 Sep 2026 17:20:30 +0200
Message-ID: <20260925152107.3386097-12-hch@lst.de>
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

Add new xfs_trans_priv.h and xfs_log.h stubs for definitions that aren't
in xfs_trans.h in the kernel.  This prepares for pulling in the kernel
version of xfs_trans.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/stubs/xfs_log.h        |  7 +++++++
 libxfs/stubs/xfs_trans.h      |  7 -------
 libxfs/stubs/xfs_trans_priv.h | 16 ++++++++++++++++
 libxfs/xfs_defer.c            |  2 ++
 repair/phase2.c               |  1 +
 5 files changed, 26 insertions(+), 7 deletions(-)
 create mode 100644 libxfs/stubs/xfs_log.h
 create mode 100644 libxfs/stubs/xfs_trans_priv.h

diff --git a/libxfs/stubs/xfs_log.h b/libxfs/stubs/xfs_log.h
new file mode 100644
index 000000000000..98251ee06688
--- /dev/null
+++ b/libxfs/stubs/xfs_log.h
@@ -0,0 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef __XFS_LOG_H__
+#define __XFS_LOG_H__
+
+#define xfs_log_item_in_current_chkpt(lip)	(false)
+
+#endif /* __XFS_LOG_H__ */
diff --git a/libxfs/stubs/xfs_trans.h b/libxfs/stubs/xfs_trans.h
index aa4de91b43a9..2619347df923 100644
--- a/libxfs/stubs/xfs_trans.h
+++ b/libxfs/stubs/xfs_trans.h
@@ -52,7 +52,6 @@ typedef struct xfs_trans {
 	struct list_head	t_dfops;	/* deferred operations */
 } xfs_trans_t;
 
-void	xfs_trans_init(struct xfs_mount *);
 int	xfs_trans_roll(struct xfs_trans **);
 
 int	libxfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
@@ -130,10 +129,4 @@ libxfs_trans_read_buf(
 	return libxfs_trans_read_buf_map(mp, tp, btp, &map, 1, flags, bpp, ops);
 }
 
-#define xfs_log_item_in_current_chkpt(lip)	(false)
-
-/* Contorted mess to make gcc shut up about unused vars. */
-#define xfs_ail_get_push_target(ail)    \
-		((log) == (log) ? NULLCOMMITLSN : NULLCOMMITLSN)
-
 #endif	/* __XFS_TRANS_H__ */
diff --git a/libxfs/stubs/xfs_trans_priv.h b/libxfs/stubs/xfs_trans_priv.h
new file mode 100644
index 000000000000..bab4e6c2b6c2
--- /dev/null
+++ b/libxfs/stubs/xfs_trans_priv.h
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+
+#ifndef __XFS_TRANS_PRIV_H__
+#define __XFS_TRANS_PRIV_H__
+
+void	xfs_trans_init(struct xfs_mount *);
+
+/* Contorted mess to make gcc shut up about unused vars. */
+#define xfs_ail_get_push_target(ail)    \
+	((log) == (log) ? NULLCOMMITLSN : NULLCOMMITLSN)
+
+#endif /* __XFS_TRANS_PRIV_H__ */
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 28e8dcf14475..ab1f81d8bcd2 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -12,10 +12,12 @@
 #include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_trans.h"
+#include "xfs_trans_priv.h"
 #include "xfs_buf_item.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
+#include "xfs_log.h"
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
 #include "xfs_bmap.h"
diff --git a/repair/phase2.c b/repair/phase2.c
index fc96f9c4223c..ee166e62a002 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -16,6 +16,7 @@
 #include "scan.h"
 #include "rt.h"
 #include "quotacheck.h"
+#include "xfs_trans_priv.h"
 
 /* workaround craziness in the xlog routines */
 int xlog_recover_do_trans(struct xlog *log, struct xlog_recover *t, int p)
-- 
2.53.0

