Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 10AFA7F98
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 21:15:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D40E3304032
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 19:15:02 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Ny2N0Okm8Ea2FGqA for <xfs@oss.sgi.com>;
	Mon, 26 Jan 2015 19:15:00 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/9] xfs; factor extsize hint checking out of xfs_ioctl_setattr
Date: Tue, 27 Jan 2015 14:14:44 +1100
Message-Id: <1422328486-24661-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1422328486-24661-1-git-send-email-david@fromorbit.com>
References: <1422328486-24661-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: iustin@k1024.org

From: Dave Chinner <dchinner@redhat.com>

The extent size hint change checking is fairly complex, so isolate
that into it's own function. This simplifies the logic flow of the
setattr code, making it easier to read.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 82 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ae6e1e3..7e42d0f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1098,6 +1098,51 @@ out_cancel:
 	return ERR_PTR(error);
 }
 
+int
+xfs_ioctl_setattr_check_extsize(
+	struct xfs_inode	*ip,
+	struct fsxattr		*fa)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	/* Can't change extent size if any extents are allocated. */
+	if (ip->i_d.di_nextents &&
+	    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) != fa->fsx_extsize))
+		return -EINVAL;
+
+	/*
+	 * Extent size must be a multiple of the appropriate block size, if set
+	 * at all. It must also be smaller than the maximum extent size
+	 * supported by the filesystem.
+	 *
+	 * Also, for non-realtime files, limit the extent size hint to half the
+	 * size of the AGs in the filesystem so alignment doesn't result in
+	 * extents larger than an AG.
+	 */
+	if (fa->fsx_extsize != 0) {
+		xfs_extlen_t    size;
+		xfs_fsblock_t   extsize_fsb;
+
+		extsize_fsb = XFS_B_TO_FSB(mp, fa->fsx_extsize);
+		if (extsize_fsb > MAXEXTLEN)
+			return -EINVAL;
+
+		if (XFS_IS_REALTIME_INODE(ip) ||
+		    (fa->fsx_xflags & XFS_XFLAG_REALTIME)) {
+			size = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
+		} else {
+			size = mp->m_sb.sb_blocksize;
+			if (extsize_fsb > mp->m_sb.sb_agblocks / 2)
+				return -EINVAL;
+		}
+
+		if (fa->fsx_extsize % size)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+
 STATIC int
 xfs_ioctl_setattr(
 	xfs_inode_t		*ip,
@@ -1161,43 +1206,10 @@ xfs_ioctl_setattr(
 			goto error_return;
 	}
 
-	/* Can't change extent size if any extents are allocated. */
-	code = -EINVAL;
-	if (ip->i_d.di_nextents &&
-	    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) != fa->fsx_extsize))
+	code = xfs_ioctl_setattr_check_extsize(ip, fa);
+	if (code)
 		goto error_return;
 
-	/*
-	 * Extent size must be a multiple of the appropriate block size, if set
-	 * at all. It must also be smaller than the maximum extent size
-	 * supported by the filesystem.
-	 *
-	 * Also, for non-realtime files, limit the extent size hint to half the
-	 * size of the AGs in the filesystem so alignment doesn't result in
-	 * extents larger than an AG.
-	 */
-	if (fa->fsx_extsize != 0) {
-		xfs_extlen_t    size;
-		xfs_fsblock_t   extsize_fsb;
-
-		extsize_fsb = XFS_B_TO_FSB(mp, fa->fsx_extsize);
-		if (extsize_fsb > MAXEXTLEN)
-			goto error_return;
-
-		if (XFS_IS_REALTIME_INODE(ip) ||
-		    (fa->fsx_xflags & XFS_XFLAG_REALTIME)) {
-			size = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
-		} else {
-			size = mp->m_sb.sb_blocksize;
-			if (extsize_fsb > mp->m_sb.sb_agblocks / 2)
-				goto error_return;
-		}
-
-		if (fa->fsx_extsize % size)
-			goto error_return;
-	}
-
-
 	code = xfs_ioctl_setattr_xflags(tp, ip, fa);
 	if (code)
 		goto error_return;
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
