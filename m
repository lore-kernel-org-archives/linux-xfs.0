Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 873647FA5
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:42:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5AA84304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:42:59 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 74GOYGXS8T8jemAc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:42:57 -0700 (PDT)
Subject: [PATCH 24/25] xfs: scrub should cross-reference the realtime bitmap
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:42:52 -0700
Message-ID: <147216857200.3108.11169547765266171675.stgit@birch.djwong.org>
In-Reply-To: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
References: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

While we're scrubbing various btrees, cross-reference the records
with the other metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   29 +++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h         |    3 +++
 fs/xfs/xfs_scrub.c           |    9 +++++++++
 3 files changed, 41 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index f4b68c0..0f95c19 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1016,3 +1016,32 @@ xfs_rtfree_extent(
 	}
 	return 0;
 }
+
+/* Is the given extent all free? */
+int
+xfs_rtbitmap_extent_is_free(
+	struct xfs_mount		*mp,
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
+		error = xfs_rtcheck_range(mp, NULL, start, clen, 1, &end,
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
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 91e48f9..14fd2c3 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -121,6 +121,8 @@ int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
 int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		     xfs_rtblock_t start, xfs_extlen_t len,
 		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
+int xfs_rtbitmap_extent_is_free(struct xfs_mount *mp,
+		xfs_rtblock_t start, xfs_rtblock_t len, bool *is_free);
 
 
 #else
@@ -129,6 +131,7 @@ int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
 # define xfs_rtpick_extent(m,t,l,rb)                    (ENOSYS)
 # define xfs_growfs_rt(mp,in)                           (ENOSYS)
 # define xfs_rtbuf_get(m,t,b,i,p)                       (ENOSYS)
+# define xfs_rtbitmap_extent_is_free(m,s,l,i)           (ENOSYS)
 static inline int		/* error */
 xfs_rtmount_init(
 	xfs_mount_t	*mp)	/* file system mount structure */
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index ff55d8c..e4e3210 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -2304,6 +2304,7 @@ xfs_scrub_bmap_extent(
 	xfs_extlen_t			flen;
 	bool				is_freesp;
 	bool				has_inodes;
+	bool				is_free;
 	unsigned int			rflags;
 	int				has_rmap;
 	int				has_refcount;
@@ -2390,6 +2391,14 @@ xfs_scrub_bmap_extent(
 			xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR :
 							  XFS_BTREE_NOERROR);
 		}
+	} else {
+		/* Cross-reference with rtbitmap. */
+		xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+		err2 = xfs_rtbitmap_extent_is_free(mp, irec->br_startblock,
+				irec->br_blockcount, &is_free);
+		if (!err2)
+			XFS_BTREC_SCRUB_CHECK(&info->bs, !is_free);
+		xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	}
 
 	/* Cross-reference with rmapbt. */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
