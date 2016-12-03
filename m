Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23586 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758457AbcLCBjk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:39:40 -0500
Subject: [PATCH 39/55] xfs: scrub should cross-reference the realtime bitmap
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:39:35 -0800
Message-ID: <148072917492.12995.15436117682023792587.stgit@birch.djwong.org>
In-Reply-To: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
References: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

While we're scrubbing various btrees, cross-reference the records
with the other metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   30 ++++++++++++++++++++++++++++++
 fs/xfs/repair/bmap.c         |   10 ++++++++++
 fs/xfs/xfs_rtalloc.h         |    3 +++
 3 files changed, 43 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index f4b68c0..4b8457c 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1016,3 +1016,33 @@ xfs_rtfree_extent(
 	}
 	return 0;
 }
+
+/* Is the given extent all free? */
+int
+xfs_rtbitmap_extent_is_free(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	xfs_rtblock_t			start,
+	xfs_rtblock_t			len,
+	bool				*is_free)
+{
+	xfs_rtblock_t			end;
+	xfs_extlen_t			clen;
+	int				matches;
+	int				error;
+
+	*is_free = false;
+	while (len) {
+		clen = len > ~0U ? ~0U : len;
+		error = xfs_rtcheck_range(mp, tp, start, clen, 1, &end,
+				&matches);
+		if (error || !matches || end < start + clen)
+			return error;
+
+		len -= end - start;
+		start = end + 1;
+	}
+
+	*is_free = true;
+	return error;
+}
diff --git a/fs/xfs/repair/bmap.c b/fs/xfs/repair/bmap.c
index 2bc661d..5c8fd3f 100644
--- a/fs/xfs/repair/bmap.c
+++ b/fs/xfs/repair/bmap.c
@@ -39,6 +39,7 @@
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_refcount.h"
+#include "xfs_rtalloc.h"
 #include "repair/common.h"
 #include "repair/btree.h"
 
@@ -90,6 +91,7 @@ xfs_scrub_bmap_extent(
 	bool				is_freesp;
 	bool				has_inodes;
 	bool				has_cowflag;
+	bool				is_free;
 	unsigned int			rflags;
 	int				has_rmap;
 	int				has_refcount;
@@ -145,6 +147,14 @@ xfs_scrub_bmap_extent(
 				irec->br_blockcount, &is_freesp);
 		if (xfs_scrub_should_xref(info->sc, err2, &sa.bno_cur))
 			XFS_SCRUB_BMAP_CHECK(!is_freesp);
+	} else {
+		xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+		err2 = xfs_rtbitmap_extent_is_free(mp, info->sc->tp,
+				irec->br_startblock, irec->br_blockcount,
+				&is_free);
+		if (xfs_scrub_should_xref(info->sc, err2, NULL))
+			XFS_SCRUB_BMAP_CHECK(!is_free);
+		xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	}
 
 	/* Cross-reference with inobt. */
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 3036349..bd1c6a9 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -121,6 +121,8 @@ int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
 int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		     xfs_rtblock_t start, xfs_extlen_t len,
 		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
+int xfs_rtbitmap_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
+		xfs_rtblock_t start, xfs_rtblock_t len, bool *is_free);
 
 
 #else
@@ -131,6 +133,7 @@ int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
 # define xfs_rtcheck_range(...)                         (ENOSYS)
 # define xfs_rtfind_forw(...)                           (ENOSYS)
 # define xfs_rtbuf_get(m,t,b,i,p)                       (ENOSYS)
+# define xfs_rtbitmap_extent_is_free(m,t,s,l,i)         (ENOSYS)
 static inline int		/* error */
 xfs_rtmount_init(
 	xfs_mount_t	*mp)	/* file system mount structure */

