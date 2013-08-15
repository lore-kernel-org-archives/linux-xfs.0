Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BF8BB7F52
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 13:08:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AF09A304053
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 11:08:12 -0700 (PDT)
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v8 6/7] xfs: add capability check to free eofblocks ioctl
Date: Thu, 15 Aug 2013 14:08:03 -0400
Message-Id: <1376590084-12888-7-git-send-email-dwight.engen@oracle.com>
In-Reply-To: <1376590084-12888-1-git-send-email-dwight.engen@oracle.com>
References: <1376590084-12888-1-git-send-email-dwight.engen@oracle.com>
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
Cc: Dwight Engen <dwight.engen@oracle.com>, Ben Myers <bpm@sgi.com>

Check for CAP_SYS_ADMIN since the caller can truncate preallocated
blocks from files they do not own nor have write access to. A more
fine grained access check was considered: require the caller to
specify their own uid/gid and to use inode_permission to check for
write, but this would not catch the case of an inode not reachable
via path traversal from the callers mount namespace.

Add check for read-only filesystem to free eofblocks ioctl.

Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 fs/xfs/xfs_ioctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 20b4c7a..bdebc21 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1723,6 +1723,12 @@ xfs_file_ioctl(
 		struct xfs_fs_eofblocks eofb;
 		struct xfs_eofblocks keofb;
 
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (mp->m_flags & XFS_MOUNT_RDONLY)
+			return -XFS_ERROR(EROFS);
+
 		if (copy_from_user(&eofb, arg, sizeof(eofb)))
 			return -XFS_ERROR(EFAULT);
 
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
