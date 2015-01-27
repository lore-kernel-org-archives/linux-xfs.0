Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B0BF7FA5
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 21:15:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DF169304032
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 19:15:00 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	xHi8xtlRAwlo8KhY for <xfs@oss.sgi.com>;
	Mon, 26 Jan 2015 19:14:59 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/9] xfs: XFS_IOCTL_SETXATTR can run in user namespaces
Date: Tue, 27 Jan 2015 14:14:43 +1100
Message-Id: <1422328486-24661-7-git-send-email-david@fromorbit.com>
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

Currently XFS_IOCTL_SETXATTR will fail if run in a user namespace as
it it not allowed to change project IDs. The current code, however,
also prevents any other change being made as well, so things like
extent size hints cannot be set in user namespaces. This is wrong,
so only disallow access to project IDs and related flags from inside
the init namespace.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 563d2b4..ae6e1e3 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1120,6 +1120,19 @@ xfs_ioctl_setattr(
 		return -EINVAL;
 
 	/*
+	 * Project Quota ID state is only allowed to change from within the init
+	 * namespace. Enforce that restriction only if we are trying to change
+	 * the quota ID state. Everything else is allowed in user namespaces.
+	 */
+	if (current_user_ns() != &init_user_ns) {
+		if (xfs_get_projid(ip) != fa->fsx_projid)
+			return -EINVAL;
+		if ((fa->fsx_xflags & XFS_XFLAG_PROJINHERIT) ^
+		    (ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT))
+			return -EINVAL;
+	}
+
+	/*
 	 * If disk quotas is on, we make sure that the dquots do exist on disk,
 	 * before we start any other transactions. Trying to do this later
 	 * is messy. We don't care to take a readlock to look at the ids
@@ -1139,15 +1152,6 @@ xfs_ioctl_setattr(
 	if (IS_ERR(tp))
 		return PTR_ERR(tp);
 
-	/*
-	 * Do a quota reservation only if projid is actually going to change.
-	 * Only allow changing of projid from init_user_ns since it is a
-	 * non user namespace aware identifier.
-	 */
-	if (current_user_ns() != &init_user_ns) {
-		code = -EINVAL;
-		goto error_return;
-	}
 
 	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
 	    xfs_get_projid(ip) != fa->fsx_projid) {
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
