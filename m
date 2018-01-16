Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46226 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751389AbeAPX1y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 18:27:54 -0500
Date: Tue, 16 Jan 2018 15:27:51 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3 20/21] xfs: cross-reference the realtime bitmap
Message-ID: <20180116232751.GE5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398989544.18741.8012375240764840486.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398989544.18741.8012375240764840486.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

While we're scrubbing various btrees, cross-reference the records
with the other metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v3: fix indenting and standardize helper naming, refactor helpers per dave's
    suggestion and add clarifying comments
v2: streamline scrubber arguments, remove stack allocated objects
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   21 +++++++++++++++++++++
 fs/xfs/scrub/bmap.c          |    3 +++
 fs/xfs/scrub/rtbitmap.c      |   23 +++++++++++++++++++++++
 fs/xfs/scrub/scrub.h         |    6 ++++++
 fs/xfs/xfs_rtalloc.h         |    4 ++++
 5 files changed, 57 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 3fb29a5..106be2d 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1097,3 +1097,24 @@ xfs_verify_rtbno(
 {
 	return rtbno < mp->m_sb.sb_rblocks;
 }
+
+/* Is the given extent all free? */
+int
+xfs_rtalloc_extent_is_free(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	xfs_rtblock_t			start,
+	xfs_extlen_t			len,
+	bool				*is_free)
+{
+	xfs_rtblock_t			end;
+	int				matches;
+	int				error;
+
+	error = xfs_rtcheck_range(mp, tp, start, len, 1, &end, &matches);
+	if (error)
+		return error;
+
+	*is_free = matches;
+	return 0;
+}
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 7b2cf8f..2bb3e0c 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -243,6 +243,9 @@ xfs_scrub_bmap_rt_extent_xref(
 {
 	if (info->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
+
+	xfs_scrub_xref_is_used_rt_space(info->sc, irec->br_startblock,
+			irec->br_blockcount);
 }
 
 /* Cross-reference a single datadev extent record. */
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 6860d5d..2639099 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -98,3 +98,26 @@ xfs_scrub_rtsummary(
 	/* XXX: implement this some day */
 	return -ENOENT;
 }
+
+
+/* xref check that the extent is not free in the rtbitmap */
+void
+xfs_scrub_xref_is_used_rt_space(
+	struct xfs_scrub_context	*sc,
+	xfs_rtblock_t			fsbno,
+	xfs_extlen_t			len)
+{
+	bool				is_free;
+	int				error;
+
+	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, fsbno, len,
+			&is_free);
+	if (!xfs_scrub_should_check_xref(sc, &error, NULL))
+		goto out_unlock;
+	if (is_free)
+		xfs_scrub_ino_xref_set_corrupt(sc, sc->mp->m_rbmip->i_ino,
+				NULL);
+out_unlock:
+	xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+}
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index c8f8b42..0d92af8 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -142,5 +142,11 @@ void xfs_scrub_xref_is_cow_staging(struct xfs_scrub_context *sc,
 		xfs_agblock_t bno, xfs_extlen_t len);
 void xfs_scrub_xref_is_not_shared(struct xfs_scrub_context *sc,
 		xfs_agblock_t bno, xfs_extlen_t len);
+#ifdef CONFIG_XFS_RT
+void xfs_scrub_xref_is_used_rt_space(struct xfs_scrub_context *sc,
+		xfs_rtblock_t rtbno, xfs_extlen_t len);
+#else
+# define xfs_scrub_xref_is_used_rt_space(sc, rtbno, len) do { } while (0)
+#endif
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 3f30f84..dfee3c9 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -139,6 +139,9 @@ int xfs_rtalloc_query_all(struct xfs_trans *tp,
 			  xfs_rtalloc_query_range_fn fn,
 			  void *priv);
 bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
+int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
+			       xfs_rtblock_t start, xfs_extlen_t len,
+			       bool *is_free);
 #else
 # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)    (ENOSYS)
 # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
@@ -148,6 +151,7 @@ bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
 # define xfs_rtalloc_query_all(t,f,p)                   (ENOSYS)
 # define xfs_rtbuf_get(m,t,b,i,p)                       (ENOSYS)
 # define xfs_verify_rtbno(m, r)			(false)
+# define xfs_rtalloc_extent_is_free(m,t,s,l,i)          (ENOSYS)
 static inline int		/* error */
 xfs_rtmount_init(
 	xfs_mount_t	*mp)	/* file system mount structure */
