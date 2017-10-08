Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:64272 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753617AbdJHXyX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Oct 2017 19:54:23 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1e1LOk-0002Ei-1V
        for linux-xfs@vger.kernel.org; Mon, 09 Oct 2017 10:54:18 +1100
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1e1LOk-0003dV-0Q
        for linux-xfs@vger.kernel.org; Mon, 09 Oct 2017 10:54:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/4] xfs: move more RT specific code under CONFIG_XFS_RT
Date: Mon,  9 Oct 2017 10:54:12 +1100
Message-Id: <20171008235414.13866-3-david@fromorbit.com>
In-Reply-To: <20171008235414.13866-1-david@fromorbit.com>
References: <20171008235414.13866-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Various utility functions and interfaces that iterate internal
devices try to reference the realtime device even when RT support is
not compiled into the kernel.

Make sure this code is excluded from the CONFIG_XFS_RT=n build,
and where appropriate stub functions to return fatal errors if
they ever get called when RT support is not present.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c |  2 ++
 fs/xfs/xfs_bmap_util.h | 13 +++++++++++++
 fs/xfs/xfs_fsmap.c     | 12 ++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index e9db7fc95b70..6503cfa44262 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -84,6 +84,7 @@ xfs_zero_extent(
 		GFP_NOFS, 0);
 }
 
+#ifdef CONFIG_XFS_RT
 int
 xfs_bmap_rtalloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
@@ -190,6 +191,7 @@ xfs_bmap_rtalloc(
 	}
 	return 0;
 }
+#endif /* CONFIG_XFS_RT */
 
 /*
  * Check if the endoff is outside the last extent. If so the caller will grow
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 0eaa81dc49be..7d330b3c77c3 100644
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
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 814ed729881d..560e0b40ac1b 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -521,6 +521,7 @@ __xfs_getfsmap_rtdev(
 	return query_fn(tp, info);
 }
 
+#ifdef CONFIG_XFS_RT
 /* Actually query the realtime bitmap. */
 STATIC int
 xfs_getfsmap_rtdev_rtbitmap_query(
@@ -561,6 +562,7 @@ xfs_getfsmap_rtdev_rtbitmap(
 	return __xfs_getfsmap_rtdev(tp, keys, xfs_getfsmap_rtdev_rtbitmap_query,
 			info);
 }
+#endif /* CONFIG_XFS_RT */
 
 /* Execute a getfsmap query against the regular data device. */
 STATIC int
@@ -795,7 +797,15 @@ xfs_getfsmap_check_keys(
 	return false;
 }
 
+/*
+ * There are only two devices if we didn't configure RT devices at build time.
+ */
+#ifdef CONFIG_XFS_RT
 #define XFS_GETFSMAP_DEVS	3
+#else
+#define XFS_GETFSMAP_DEVS	2
+#endif /* CONFIG_XFS_RT */
+
 /*
  * Get filesystem's extents as described in head, and format for
  * output.  Calls formatter to fill the user's buffer until all
@@ -853,10 +863,12 @@ xfs_getfsmap(
 		handlers[1].dev = new_encode_dev(mp->m_logdev_targp->bt_dev);
 		handlers[1].fn = xfs_getfsmap_logdev;
 	}
+#ifdef CONFIG_XFS_RT
 	if (mp->m_rtdev_targp) {
 		handlers[2].dev = new_encode_dev(mp->m_rtdev_targp->bt_dev);
 		handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
 	}
+#endif /* CONFIG_XFS_RT */
 
 	xfs_sort(handlers, XFS_GETFSMAP_DEVS, sizeof(struct xfs_getfsmap_dev),
 			xfs_getfsmap_dev_compare);
-- 
2.14.2

