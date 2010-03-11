Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2BMf5q4194427 for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 16:41:06 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 03D4A1D2DEB4
	for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 14:42:37 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	eQkpPI5l3uLuaZVq for <xfs@oss.sgi.com>;
	Thu, 11 Mar 2010 14:42:37 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/19] xfs: Fix error return for fallocate() on XFS
Date: Fri, 12 Mar 2010 09:42:03 +1100
Message-Id: <1268347337-7160-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1268347337-7160-1-git-send-email-david@fromorbit.com>
References: <1268347337-7160-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stable@kernel.org
Cc: xfs@oss.sgi.com

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

>From 44a743f68705c681439f264deb05f8f38e9048d3
Date: Tue, 24 Nov 2009 21:52:53 +0000
Noticed that through glibc fallocate would return 28 rather than -1
and errno = 28 for ENOSPC. The xfs routines uses XFS_ERROR format
positive return error codes while the syscalls use negative return
codes.  Fixup the two cases in xfs_vn_fallocate syscall to convert to
negative.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index cd42ef7..1f3b4b8 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -573,8 +573,8 @@ xfs_vn_fallocate(
 	bf.l_len = len;
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
-	error = xfs_change_file_space(ip, XFS_IOC_RESVSP, &bf,
-				      0, XFS_ATTR_NOLOCK);
+	error = -xfs_change_file_space(ip, XFS_IOC_RESVSP, &bf,
+				       0, XFS_ATTR_NOLOCK);
 	if (!error && !(mode & FALLOC_FL_KEEP_SIZE) &&
 	    offset + len > i_size_read(inode))
 		new_size = offset + len;
@@ -585,7 +585,7 @@ xfs_vn_fallocate(
 
 		iattr.ia_valid = ATTR_SIZE;
 		iattr.ia_size = new_size;
-		error = xfs_setattr(ip, &iattr, XFS_ATTR_NOLOCK);
+		error = -xfs_setattr(ip, &iattr, XFS_ATTR_NOLOCK);
 	}
 
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
