Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 21C467D17
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:39:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 88562AC004
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:39:31 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 5lpwGz1ir3HGPcrZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:39:29 -0700 (PDT)
Subject: [PATCH 69/71] xfs: various swapext cleanups
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:39:25 -0700
Message-ID: <147216836590.867.2683058902048991965.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
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

Replace structure typedefs with struct expressions and fix some
whitespace issues that result.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 584e2ad..86cd7d4 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1542,8 +1542,8 @@ xfs_insert_file_space(
  */
 static int
 xfs_swap_extents_check_format(
-	xfs_inode_t	*ip,	/* target inode */
-	xfs_inode_t	*tip)	/* tmp inode */
+	struct xfs_inode	*ip,	/* target inode */
+	struct xfs_inode	*tip)	/* tmp inode */
 {
 
 	/* Should never get a local format */
@@ -1629,22 +1629,22 @@ xfs_swap_extent_flush(
 
 int
 xfs_swap_extents(
-	xfs_inode_t	*ip,	/* target inode */
-	xfs_inode_t	*tip,	/* tmp inode */
-	xfs_swapext_t	*sxp)
+	struct xfs_inode	*ip,	/* target inode */
+	struct xfs_inode	*tip,	/* tmp inode */
+	struct xfs_swapext	*sxp)
 {
-	xfs_mount_t	*mp = ip->i_mount;
-	xfs_trans_t	*tp;
-	xfs_bstat_t	*sbp = &sxp->sx_stat;
-	xfs_ifork_t	*tempifp, *ifp, *tifp;
-	int		src_log_flags, target_log_flags;
-	int		error = 0;
-	int		aforkblks = 0;
-	int		taforkblks = 0;
-	__uint64_t	tmp;
-	int		lock_flags;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	struct xfs_bstat	*sbp = &sxp->sx_stat;
+	struct xfs_ifork	*tempifp, *ifp, *tifp;
+	int			src_log_flags, target_log_flags;
+	int			error = 0;
+	int			aforkblks = 0;
+	int			taforkblks = 0;
+	__uint64_t		tmp;
+	int			lock_flags;
 	struct xfs_ifork	*cowfp;
-	__uint64_t	f;
+	__uint64_t		f;
 
 	/* XXX: we can't do this with rmap, will fix later */
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
