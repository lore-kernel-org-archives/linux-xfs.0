Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CC80E7F96
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 21:15:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 90B42304039
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 19:15:02 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	xo4lARuIWbSDdP0I for <xfs@oss.sgi.com>;
	Mon, 26 Jan 2015 19:15:01 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/9] xfs; factor projid hint checking out of xfs_ioctl_setattr
Date: Tue, 27 Jan 2015 14:14:45 +1100
Message-Id: <1422328486-24661-9-git-send-email-david@fromorbit.com>
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

The project ID change checking is one of the few remaining open
coded checks in xfs_ioctl_setattr(). Factor it into a helper
function so that the setattr code mostly becomes a flow of check
and action helpers, making it easier to read and follow.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 50 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 7e42d0f..561d142 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1142,6 +1142,34 @@ xfs_ioctl_setattr_check_extsize(
 	return 0;
 }
 
+int
+xfs_ioctl_setattr_check_projid(
+	struct xfs_inode	*ip,
+	struct fsxattr		*fa)
+{
+	/* Disallow 32bit project ids if projid32bit feature is not enabled. */
+	if (fa->fsx_projid > (__uint16_t)-1 &&
+	    !xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
+		return -EINVAL;
+
+	/*
+	 * Project Quota ID state is only allowed to change from within the init
+	 * namespace. Enforce that restriction only if we are trying to change
+	 * the quota ID state. Everything else is allowed in user namespaces.
+	 */
+	if (current_user_ns() == &init_user_ns)
+		return 0;
+
+	if (xfs_get_projid(ip) != fa->fsx_projid)
+		return -EINVAL;
+	if ((fa->fsx_xflags & XFS_XFLAG_PROJINHERIT) ^
+	    (ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT))
+		return -EINVAL;
+
+	return 0;
+}
+
+
 
 STATIC int
 xfs_ioctl_setattr(
@@ -1157,25 +1185,9 @@ xfs_ioctl_setattr(
 
 	trace_xfs_ioctl_setattr(ip);
 
-	/*
-	 * Disallow 32bit project ids when projid32bit feature is not enabled.
-	 */
-	if (fa->fsx_projid > (__uint16_t)-1 &&
-	    !xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
-		return -EINVAL;
-
-	/*
-	 * Project Quota ID state is only allowed to change from within the init
-	 * namespace. Enforce that restriction only if we are trying to change
-	 * the quota ID state. Everything else is allowed in user namespaces.
-	 */
-	if (current_user_ns() != &init_user_ns) {
-		if (xfs_get_projid(ip) != fa->fsx_projid)
-			return -EINVAL;
-		if ((fa->fsx_xflags & XFS_XFLAG_PROJINHERIT) ^
-		    (ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT))
-			return -EINVAL;
-	}
+	code = xfs_ioctl_setattr_check_projid(ip, fa);
+	if (code)
+		return code;
 
 	/*
 	 * If disk quotas is on, we make sure that the dquots do exist on disk,
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
