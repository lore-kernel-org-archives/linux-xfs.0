Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50761 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751492AbdHKHLn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 03:11:43 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7B7BgR6032156
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7BfZr032688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:41 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7B7BfbH020897
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:41 GMT
Subject: [PATCH 14/16] xfs: scrub should cross-reference the realtime bitmap
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 11 Aug 2017 00:11:40 -0700
Message-ID: <150243550075.29473.14529351345894506510.stgit@magnolia>
In-Reply-To: <150243541274.29473.1227559008347544526.stgit@magnolia>
References: <150243541274.29473.1227559008347544526.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

While we're scrubbing various btrees, cross-reference the records
with the other metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   30 ++++++++++++++++++++++++++++++
 fs/xfs/scrub/bmap.c          |   12 ++++++++++++
 fs/xfs/xfs_rtalloc.h         |    4 ++++
 3 files changed, 46 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 5d4e43e..a38d51b 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1086,3 +1086,33 @@ xfs_rtalloc_query_all(
 
 	return xfs_rtalloc_query_range(tp, &keys[0], &keys[1], fn, priv);
 }
+
+/* Is the given extent all free? */
+int
+xfs_rtalloc_extent_is_free(
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
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 21d88aa..8377521 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -38,6 +38,7 @@
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_refcount.h"
+#include "xfs_rtalloc.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -286,6 +287,7 @@ xfs_scrub_bmap_extent(
 	xfs_agnumber_t			agno;
 	bool				is_freesp;
 	bool				has_inodes;
+	bool				is_free = false;
 	int				error = 0;
 
 	if (cur)
@@ -343,6 +345,16 @@ xfs_scrub_bmap_extent(
 			xfs_scrub_fblock_xref_check_ok(info->sc,
 					info->whichfork, irec->br_startoff,
 					!is_freesp);
+	} else {
+		xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+		error = xfs_rtalloc_extent_is_free(mp, info->sc->tp,
+				irec->br_startblock, irec->br_blockcount,
+				&is_free);
+		if (xfs_scrub_should_xref(info->sc, &error, NULL))
+			xfs_scrub_fblock_xref_check_ok(info->sc,
+					info->whichfork, irec->br_startoff,
+					!is_free);
+		xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	}
 
 	/* Cross-reference with inobt. */
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 79defa7..4aa7044 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -138,6 +138,9 @@ int xfs_rtalloc_query_range(struct xfs_trans *tp,
 int xfs_rtalloc_query_all(struct xfs_trans *tp,
 			  xfs_rtalloc_query_range_fn fn,
 			  void *priv);
+int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
+			       xfs_rtblock_t start, xfs_rtblock_t len,
+			       bool *is_free);
 #else
 # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)    (ENOSYS)
 # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
@@ -146,6 +149,7 @@ int xfs_rtalloc_query_all(struct xfs_trans *tp,
 # define xfs_rtalloc_query_range(t,l,h,f,p)             (ENOSYS)
 # define xfs_rtalloc_query_all(t,f,p)                   (ENOSYS)
 # define xfs_rtbuf_get(m,t,b,i,p)                       (ENOSYS)
+# define xfs_rtalloc_extent_is_free(m,t,s,l,i)          (ENOSYS)
 static inline int		/* error */
 xfs_rtmount_init(
 	xfs_mount_t	*mp)	/* file system mount structure */

