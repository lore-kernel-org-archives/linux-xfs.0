Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:50708 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751495AbdB1Str (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 13:49:47 -0500
Subject: [PATCH 5/9] xfs: add a couple of queries to iterate free extents in
 the rtbitmap
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 28 Feb 2017 10:46:22 -0800
Message-ID: <148830758195.22089.11914775154975299005.stgit@birch.djwong.org>
In-Reply-To: <148830755018.22089.4423076490708341523.stgit@birch.djwong.org>
References: <148830755018.22089.4423076490708341523.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, "Darrick J. Wong" <djwong@djwong.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Add _query_range and _query_all functions to the realtime bitmap
allocator.  These two functions are similar in usage to the btree
functions with the same name and will be used for getfsmap and scrub.

Signed-off-by: Darrick J. Wong <djwong@djwong.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   70 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h         |   22 ++++++++++++-
 2 files changed, 90 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index ea45584..e47b99e 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1016,3 +1016,73 @@ xfs_rtfree_extent(
 	}
 	return 0;
 }
+
+/* Find all the free records within a given range. */
+int
+xfs_rtalloc_query_range(
+	struct xfs_trans		*tp,
+	struct xfs_rtalloc_rec		*low_rec,
+	struct xfs_rtalloc_rec		*high_rec,
+	xfs_rtalloc_query_range_fn	fn,
+	void				*priv)
+{
+	struct xfs_rtalloc_rec		rec;
+	struct xfs_mount		*mp = tp->t_mountp;
+	xfs_rtblock_t			rtstart;
+	xfs_rtblock_t			rtend;
+	xfs_rtblock_t			rem;
+	int				is_free;
+	int				error = 0;
+
+	if (low_rec->ar_startblock > high_rec->ar_startblock)
+		return -EINVAL;
+	else if (low_rec->ar_startblock == high_rec->ar_startblock)
+		return 0;
+
+	/* Iterate the bitmap, looking for discrepancies. */
+	rtstart = low_rec->ar_startblock;
+	rem = high_rec->ar_startblock - rtstart;
+	while (rem) {
+		/* Is the first block free? */
+		error = xfs_rtcheck_range(mp, tp, rtstart, 1, 1, &rtend,
+				&is_free);
+		if (error)
+			break;
+
+		/* How long does the extent go for? */
+		error = xfs_rtfind_forw(mp, tp, rtstart,
+				high_rec->ar_startblock - 1, &rtend);
+		if (error)
+			break;
+
+		if (is_free) {
+			rec.ar_startblock = rtstart;
+			rec.ar_blockcount = rtend - rtstart + 1;
+
+			error = fn(tp, &rec, priv);
+			if (error)
+				break;
+		}
+
+		rem -= rtend - rtstart + 1;
+		rtstart = rtend + 1;
+	}
+
+	return error;
+}
+
+/* Find all the free records. */
+int
+xfs_rtalloc_query_all(
+	struct xfs_trans		*tp,
+	xfs_rtalloc_query_range_fn	fn,
+	void				*priv)
+{
+	struct xfs_rtalloc_rec		keys[2];
+
+	keys[0].ar_startblock = 0;
+	keys[1].ar_startblock = tp->t_mountp->m_sb.sb_rblocks;
+	keys[0].ar_blockcount = keys[1].ar_blockcount = 0;
+
+	return xfs_rtalloc_query_range(tp, &keys[0], &keys[1], fn, priv);
+}
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 355dd9e..b0d2761 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -23,6 +23,16 @@
 struct xfs_mount;
 struct xfs_trans;
 
+struct xfs_rtalloc_rec {
+	xfs_rtblock_t		ar_startblock;
+	xfs_rtblock_t		ar_blockcount;
+};
+
+typedef int (*xfs_rtalloc_query_range_fn)(
+	struct xfs_trans	*tp,
+	struct xfs_rtalloc_rec	*rec,
+	void			*priv);
+
 #ifdef CONFIG_XFS_RT
 /*
  * Function prototypes for exported functions.
@@ -119,13 +129,21 @@ int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
 int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		     xfs_rtblock_t start, xfs_extlen_t len,
 		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
-
-
+int xfs_rtalloc_query_range(struct xfs_trans *tp,
+			    struct xfs_rtalloc_rec *low_rec,
+			    struct xfs_rtalloc_rec *high_rec,
+			    xfs_rtalloc_query_range_fn fn,
+			    void *priv);
+int xfs_rtalloc_query_all(struct xfs_trans *tp,
+			  xfs_rtalloc_query_range_fn fn,
+			  void *priv);
 #else
 # define xfs_rtallocate_extent(t,b,min,max,l,a,f,p,rb)  (ENOSYS)
 # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
 # define xfs_rtpick_extent(m,t,l,rb)                    (ENOSYS)
 # define xfs_growfs_rt(mp,in)                           (ENOSYS)
+# define xfs_rtalloc_query_range(t,l,h,f,p)             (ENOSYS)
+# define xfs_rtalloc_query_all(t,f,p)                   (ENOSYS)
 static inline int		/* error */
 xfs_rtmount_init(
 	xfs_mount_t	*mp)	/* file system mount structure */

