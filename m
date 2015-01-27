Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C88CA7F90
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 21:15:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 999688F8071
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 19:15:00 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	FoKnFWfDXDutFAhS for <xfs@oss.sgi.com>;
	Mon, 26 Jan 2015 19:14:59 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/9] xfs: separate xflags from xfs_ioctl_setattr
Date: Tue, 27 Jan 2015 14:14:39 +1100
Message-Id: <1422328486-24661-3-git-send-email-david@fromorbit.com>
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

The setting of the extended flags is down through two separate
interfaces, but they are munged together into xfs_ioctl_setattr
and make that function far more complex than it needs to be.
Separate it out into a helper function along with all the other
common inode changes and transaction manipulations in
xfs_ioctl_setattr().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 89 +++++++++++++++++++++++++-----------------------------
 1 file changed, 41 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 09325ff..ba98412 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1013,6 +1013,44 @@ xfs_diflags_to_linux(
 		inode->i_flags &= ~S_NOATIME;
 }
 
+static int
+xfs_ioctl_setattr_xflags(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct fsxattr		*fa)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	/* Can't change realtime flag if any extents are allocated. */
+	if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
+	    XFS_IS_REALTIME_INODE(ip) != (fa->fsx_xflags & XFS_XFLAG_REALTIME))
+		return -EINVAL;
+
+	/* If realtime flag is set then must have realtime device */
+	if (fa->fsx_xflags & XFS_XFLAG_REALTIME) {
+		if (mp->m_sb.sb_rblocks == 0 || mp->m_sb.sb_rextsize == 0 ||
+		    (ip->i_d.di_extsize % mp->m_sb.sb_rextsize))
+			return -EINVAL;
+	}
+
+	/*
+	 * Can't modify an immutable/append-only file unless
+	 * we have appropriate permission.
+	 */
+	if (((ip->i_d.di_flags & (XFS_DIFLAG_IMMUTABLE | XFS_DIFLAG_APPEND)) ||
+	     (fa->fsx_xflags & (XFS_XFLAG_IMMUTABLE | XFS_XFLAG_APPEND))) &&
+	    !capable(CAP_LINUX_IMMUTABLE))
+		return -EPERM;
+
+	xfs_trans_ijoin(tp, ip, 0);
+	xfs_set_diflags(ip, fa->fsx_xflags);
+	xfs_diflags_to_linux(ip);
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	XFS_STATS_INC(xs_ig_attrchg);
+	return 0;
+}
+
 #define FSX_PROJID	1
 #define FSX_EXTSIZE	2
 #define FSX_XFLAGS	4
@@ -1159,44 +1197,9 @@ xfs_ioctl_setattr(
 	}
 
 
-	if (mask & FSX_XFLAGS) {
-		/*
-		 * Can't change realtime flag if any extents are allocated.
-		 */
-		if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
-		    (XFS_IS_REALTIME_INODE(ip)) !=
-		    (fa->fsx_xflags & XFS_XFLAG_REALTIME)) {
-			code = -EINVAL;	/* EFBIG? */
-			goto error_return;
-		}
-
-		/*
-		 * If realtime flag is set then must have realtime data.
-		 */
-		if ((fa->fsx_xflags & XFS_XFLAG_REALTIME)) {
-			if ((mp->m_sb.sb_rblocks == 0) ||
-			    (mp->m_sb.sb_rextsize == 0) ||
-			    (ip->i_d.di_extsize % mp->m_sb.sb_rextsize)) {
-				code = -EINVAL;
-				goto error_return;
-			}
-		}
-
-		/*
-		 * Can't modify an immutable/append-only file unless
-		 * we have appropriate permission.
-		 */
-		if ((ip->i_d.di_flags &
-				(XFS_DIFLAG_IMMUTABLE|XFS_DIFLAG_APPEND) ||
-		     (fa->fsx_xflags &
-				(XFS_XFLAG_IMMUTABLE | XFS_XFLAG_APPEND))) &&
-		    !capable(CAP_LINUX_IMMUTABLE)) {
-			code = -EPERM;
-			goto error_return;
-		}
-	}
-
-	xfs_trans_ijoin(tp, ip, 0);
+	code = xfs_ioctl_setattr_xflags(tp, ip, fa);
+	if (code)
+		goto error_return;
 
 	/*
 	 * Change file ownership.  Must be the owner or privileged.
@@ -1227,11 +1230,6 @@ xfs_ioctl_setattr(
 
 	}
 
-	if (mask & FSX_XFLAGS) {
-		xfs_set_diflags(ip, fa->fsx_xflags);
-		xfs_diflags_to_linux(ip);
-	}
-
 	/*
 	 * Only set the extent size hint if we've already determined that the
 	 * extent size hint should be set on the inode. If no extent size flags
@@ -1246,11 +1244,6 @@ xfs_ioctl_setattr(
 		ip->i_d.di_extsize = extsize;
 	}
 
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-	XFS_STATS_INC(xs_ig_attrchg);
-
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * transaction goes to disk before returning to the user.
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
