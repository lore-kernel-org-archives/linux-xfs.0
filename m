Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 12A187F6F
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:42:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D8CC88F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:42:09 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 5v2sYjd5XlaHiJe2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:42:07 -0700 (PDT)
Subject: [PATCH 17/25] xfs: scrub realtime bitmap/summary
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:42:03 -0700
Message-ID: <147216852298.3108.7894874786598979745.stgit@birch.djwong.org>
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

Perform simple tests of the realtime bitmap and summary.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h   |    5 +++
 fs/xfs/libxfs/xfs_fs.h       |    4 ++
 fs/xfs/libxfs/xfs_rtbitmap.c |    2 +
 fs/xfs/xfs_rtalloc.h         |    3 ++
 fs/xfs/xfs_scrub.c           |   78 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 90 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index a3aa5e9..5703b57 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -315,6 +315,11 @@ static inline bool xfs_sb_good_version(struct xfs_sb *sbp)
 	return false;
 }
 
+static inline bool xfs_sb_version_hasrealtime(struct xfs_sb *sbp)
+{
+	return sbp->sb_rblocks > 0;
+}
+
 /*
  * Detect a mismatched features2 field.  Older kernels read/wrote
  * this into the wrong slot, so to be safe we keep them in sync.
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index c688deb..211c874 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -549,7 +549,9 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_BMBTD	11	/* data fork block mapping */
 #define XFS_SCRUB_TYPE_BMBTA	12	/* attr fork block mapping */
 #define XFS_SCRUB_TYPE_BMBTC	13	/* CoW fork block mapping */
-#define XFS_SCRUB_TYPE_MAX	13
+#define XFS_SCRUB_TYPE_RTBITMAP	14	/* realtime bitmap */
+#define XFS_SCRUB_TYPE_RTSUM	15	/* realtime summary */
+#define XFS_SCRUB_TYPE_MAX	15
 
 #define XFS_SCRUB_FLAGS_ALL	0x0	/* no flags yet */
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index ea45584..f4b68c0 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -70,7 +70,7 @@ const struct xfs_buf_ops xfs_rtbuf_ops = {
  * Get a buffer for the bitmap or summary file block specified.
  * The buffer is returned read and locked.
  */
-static int
+int
 xfs_rtbuf_get(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 355dd9e..91e48f9 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -98,6 +98,8 @@ xfs_growfs_rt(
 /*
  * From xfs_rtbitmap.c
  */
+int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
+		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
 int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		      xfs_rtblock_t start, xfs_extlen_t len, int val,
 		      xfs_rtblock_t *new, int *stat);
@@ -126,6 +128,7 @@ int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
 # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
 # define xfs_rtpick_extent(m,t,l,rb)                    (ENOSYS)
 # define xfs_growfs_rt(mp,in)                           (ENOSYS)
+# define xfs_rtbuf_get(m,t,b,i,p)                       (ENOSYS)
 static inline int		/* error */
 xfs_rtmount_init(
 	xfs_mount_t	*mp)	/* file system mount structure */
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 573acd4..22ba07d 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -773,6 +773,7 @@ xfs_scrub_sb(
         XFS_SCRUB_SB_FEAT(metauuid);
         XFS_SCRUB_SB_FEAT(rmapbt);
         XFS_SCRUB_SB_FEAT(reflink);
+        XFS_SCRUB_SB_FEAT(realtime);
 #undef XFS_SCRUB_SB_FEAT
 
 out:
@@ -1674,6 +1675,81 @@ xfs_scrub_bmap_cow(
 	return xfs_scrub_bmap(ip, sm, XFS_COW_FORK);
 }
 
+/* Scrub the realtime bitmap. */
+STATIC int
+xfs_scrub_rtbitmap(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_buf			*bp = NULL;
+	xfs_rtblock_t			rtstart;
+	xfs_rtblock_t			rtend;
+	xfs_rtblock_t			block;
+	xfs_rtblock_t			rem;
+	int				is_free;
+	int				error = 0;
+	int				err2 = 0;
+
+	if (sm->control || sm->flags)
+		return -EINVAL;
+
+	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+
+	/* Iterate the bitmap, looking for discrepancies. */
+	rtstart = 0;
+	rem = mp->m_sb.sb_rblocks;
+	while (rem) {
+		if (xfs_scrub_should_terminate(&error))
+			break;
+
+		/* Is the first block free? */
+		err2 = xfs_rtcheck_range(mp, NULL, rtstart, 1, 1, &rtend,
+				&is_free);
+		if (err2)
+			goto out_unlock;
+
+		/* How long does the extent go for? */
+		err2 = xfs_rtfind_forw(mp, NULL, rtstart,
+				mp->m_sb.sb_rblocks - 1, &rtend);
+		if (err2)
+			goto out_unlock;
+
+		/* Find the buffer for error reporting. */
+		block = XFS_BITTOBLOCK(mp, rtstart);
+		err2 = xfs_rtbuf_get(mp, NULL, block, 0, &bp);
+		if (err2)
+			break;
+		XFS_SCRUB_CHECK(mp, bp, "rtbitmap", rtend >= rtstart);
+
+		xfs_buf_relse(bp);
+		bp = NULL;
+		rem -= rtend - rtstart + 1;
+		rtstart = rtend + 1;
+	}
+
+out_unlock:
+	if (bp)
+		xfs_buf_relse(bp);
+	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	if (!error && err2)
+		error = err2;
+	return error;
+}
+
+/* Scrub the realtime summary. */
+STATIC int
+xfs_scrub_rtsummary(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm)
+{
+	if (sm->control || sm->flags)
+		return -EINVAL;
+
+	/* XXX: implement this some day */
+	return -ENOENT;
+}
+
 /* Scrubbing dispatch. */
 
 struct xfs_scrub_meta_fns {
@@ -1696,6 +1772,8 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_bmap_data,	NULL},
 	{xfs_scrub_bmap_attr,	NULL},
 	{xfs_scrub_bmap_cow,	NULL},
+	{xfs_scrub_rtbitmap,	xfs_sb_version_hasrealtime},
+	{xfs_scrub_rtsummary,	xfs_sb_version_hasrealtime},
 };
 
 /* Dispatch metadata scrubbing. */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
