Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:32884 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753980AbdJSOXb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 10:23:31 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/16] xfs: move more RT specific code under CONFIG_XFS_RT
Date: Thu, 19 Oct 2017 16:22:54 +0200
Message-Id: <20171019142259.20082-12-hch@lst.de>
In-Reply-To: <20171019142259.20082-1-hch@lst.de>
References: <20171019142259.20082-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Dave Chinner <dchinner@redhat.com>

commit bb9c2e5433250f5b477035dc478314f8e6dd5e36 upstream.

Various utility functions and interfaces that iterate internal
devices try to reference the realtime device even when RT support is
not compiled into the kernel.

Make sure this code is excluded from the CONFIG_XFS_RT=n build,
and where appropriate stub functions to return fatal errors if
they ever get called when RT support is not present.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |  2 ++
 fs/xfs/xfs_bmap_util.h | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index bbc389e353e8..cb62871fb91d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -84,6 +84,7 @@ xfs_zero_extent(
 		GFP_NOFS, true);
 }
 
+#ifdef CONFIG_XFS_RT
 int
 xfs_bmap_rtalloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
@@ -195,6 +196,7 @@ xfs_bmap_rtalloc(
 	}
 	return 0;
 }
+#endif /* CONFIG_XFS_RT */
 
 /*
  * Check if the endoff is outside the last extent. If so the caller will grow
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index f1005393785c..ce330f06563e 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -28,7 +28,20 @@ struct xfs_mount;
 struct xfs_trans;
 struct xfs_bmalloca;
 
+#ifdef CONFIG_XFS_RT
 int	xfs_bmap_rtalloc(struct xfs_bmalloca *ap);
+#else /* !CONFIG_XFS_RT */
+/*
+ * Attempts to allocate RT extents when RT is disable indicates corruption and
+ * should trigger a shutdown.
+ */
+static inline int
+xfs_bmap_rtalloc(struct xfs_bmalloca *ap)
+{
+	return -EFSCORRUPTED;
+}
+#endif /* CONFIG_XFS_RT */
+
 int	xfs_bmap_eof(struct xfs_inode *ip, xfs_fileoff_t endoff,
 		     int whichfork, int *eof);
 int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
-- 
2.14.2

