Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33534 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751719AbeAIV23 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 16:28:29 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w09LQXcA106413
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 21:28:29 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2fd599045p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jan 2018 21:28:28 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w09LQAnb019190
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 21:26:10 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w09LQAQQ012959
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 21:26:10 GMT
Date: Tue, 9 Jan 2018 13:26:09 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 20/21] xfs: cross-reference the realtime bitmap
Message-ID: <20180109212609.GO5602@magnolia>
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

From: Darrick J. Wong <darrick.wong@oracle.com>

While we're scrubbing various btrees, cross-reference the records
with the other metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: streamline scrubber arguments, remove stack allocated objects
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   30 ++++++++++++++++++++++++++++++
 fs/xfs/scrub/bmap.c          |    3 +++
 fs/xfs/scrub/rtbitmap.c      |   20 ++++++++++++++++++++
 fs/xfs/scrub/scrub.h         |    6 ++++++
 fs/xfs/xfs_rtalloc.h         |    4 ++++
 5 files changed, 63 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 3fb29a5..a3f25a2 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1097,3 +1097,33 @@ xfs_verify_rtbno(
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
index 5c34e025..2908a1b 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -278,6 +278,9 @@ xfs_scrub_bmap_rt_extent_xref(
 {
 	if (info->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
+
+	xfs_scrub_xref_not_rtfree(info->sc, irec->br_startblock,
+			irec->br_blockcount);
 }
 
 /* Cross-reference a single datadev extent record. */
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 6860d5d..1828b17 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -98,3 +98,23 @@ xfs_scrub_rtsummary(
 	/* XXX: implement this some day */
 	return -ENOENT;
 }
+
+
+/* xref check that the extent is not free in the rtbitmap */
+void
+xfs_scrub_xref_not_rtfree(
+	struct xfs_scrub_context	*sc,
+	xfs_fsblock_t			fsbno,
+	xfs_fsblock_t			len)
+{
+	bool				is_free;
+	int				error;
+
+	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, fsbno, len,
+			&is_free);
+	if (xfs_scrub_should_check_xref(sc, &error, NULL) && is_free)
+		xfs_scrub_ino_xref_set_corrupt(sc, sc->mp->m_rbmip->i_ino,
+				NULL);
+	xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+}
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 06c2d17..0b21f34 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -142,5 +142,11 @@ void xfs_scrub_xref_has_cow_staging(struct xfs_scrub_context *sc,
 		xfs_agblock_t bno, xfs_extlen_t len);
 void xfs_scrub_xref_not_shared(struct xfs_scrub_context *sc,
 		xfs_agblock_t bno, xfs_extlen_t len);
+#ifdef CONFIG_XFS_RT
+void xfs_scrub_xref_not_rtfree(struct xfs_scrub_context *sc,
+		xfs_fsblock_t fsbno, xfs_fsblock_t len);
+#else
+# define xfs_scrub_xref_not_rtfree(sc, fsbno, len)	do { } while (0)
+#endif
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 3f30f84..540d506 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -139,6 +139,9 @@ int xfs_rtalloc_query_all(struct xfs_trans *tp,
 			  xfs_rtalloc_query_range_fn fn,
 			  void *priv);
 bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
+int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
+			       xfs_rtblock_t start, xfs_rtblock_t len,
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
