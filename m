Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 026C67CA2
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 23:22:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 98371AC004
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 21:22:27 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	bqzCEAMzcG1Ock3Z for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 21:22:24 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/4] xfs: S_DAX is only for regular files
Date: Mon, 15 Feb 2016 16:22:12 +1100
Message-Id: <1455513734-15192-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1455513734-15192-1-git-send-email-david@fromorbit.com>
References: <1455513734-15192-1-git-send-email-david@fromorbit.com>
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
Cc: ross.zwisler@linux.intel.com, jack@suse.cz

From: Dave Chinner <dchinner@redhat.com>

Only regular files can use DAX for data operations, so we should
restrict setting it on the VFS inode to regular files. Setting it on
metadata inodes may cause the VFS to do the wrong thing for such
inodes, so avoid potential problems by restricting the scope of the
flag to what we know is supported.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iops.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 0d38b1d..9c984a0 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1185,8 +1185,9 @@ xfs_diflags_to_iflags(
 		inode->i_flags |= S_SYNC;
 	if (flags & XFS_DIFLAG_NOATIME)
 		inode->i_flags |= S_NOATIME;
-	if (ip->i_mount->m_flags & XFS_MOUNT_DAX ||
-	    ip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
+	if (S_ISREG(inode->i_mode) &&
+	    (ip->i_mount->m_flags & XFS_MOUNT_DAX ||
+	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
 		inode->i_flags |= S_DAX;
 }
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
