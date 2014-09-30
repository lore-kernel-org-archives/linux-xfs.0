Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E1E568016
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 20:46:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C73BA8F8050
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 18:46:29 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	pQJfr7qo2yL3Fzb4 for <xfs@oss.sgi.com>;
	Mon, 29 Sep 2014 18:46:28 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: only set extent size hint when asked
Date: Tue, 30 Sep 2014 11:46:05 +1000
Message-Id: <1412041565-18873-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1412041565-18873-1-git-send-email-david@fromorbit.com>
References: <1412041565-18873-1-git-send-email-david@fromorbit.com>
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
Cc: iusty@k1024.org

From: Dave Chinner <dchinner@redhat.com>

Currently the extent size hint is set unconditionally in
xfs_ioctl_setattr(), even when the FSX_EXTSIZE flag is not set. This
means we can set values from uninitialised stack variables. Hence
only set the extent size hint from userspace when both the mask
falg is set and the inode has the XFS_DIFLAG_EXTSIZE flag set to
indicate that we should have an extent size hint set on the inode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 87c3bd1..24c926b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1231,13 +1231,25 @@ xfs_ioctl_setattr(
 
 	}
 
-	if (mask & FSX_EXTSIZE)
-		ip->i_d.di_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
 	if (mask & FSX_XFLAGS) {
 		xfs_set_diflags(ip, fa->fsx_xflags);
 		xfs_diflags_to_linux(ip);
 	}
 
+	/*
+	 * Only set the extent size hint if we've already determined that the
+	 * extent size hint should be set on the inode. If no extent size flags
+	 * are set on the inode then unconditionally clear the extent size hint.
+	 */
+	if (mask & FSX_EXTSIZE) {
+		int	extsize = 0;
+
+		if (ip->i_d.di_flags &
+				(XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT))
+			extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
+		ip->i_d.di_extsize = extsize;
+	}
+
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
