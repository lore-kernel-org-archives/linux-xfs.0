Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51943 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161539AbdAGAjL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jan 2017 19:39:11 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v070dA6j024081
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:39:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v070dAfp005999
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:39:10 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v070d9vJ016528
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:39:09 GMT
Subject: [PATCH 31/47] xfs: scrub should cross-reference the realtime bitmap
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 06 Jan 2017 16:39:08 -0800
Message-ID: <148374954879.30431.3031775510959585094.stgit@birch.djwong.org>
In-Reply-To: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
References: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
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
index 5cc7d51..bd6a620 100644
--- a/fs/xfs/repair/bmap.c
+++ b/fs/xfs/repair/bmap.c
@@ -39,6 +39,7 @@
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_refcount.h"
+#include "xfs_rtalloc.h"
 #include "repair/common.h"
 #include "repair/btree.h"
 
@@ -113,6 +114,7 @@ xfs_scrub_bmap_extent(
 	bool				is_freesp;
 	bool				has_inodes;
 	bool				has_cowflag;
+	bool				is_free = false;
 	unsigned int			rflags;
 	int				has_rmap;
 	int				has_refcount;
@@ -168,6 +170,14 @@ xfs_scrub_bmap_extent(
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

