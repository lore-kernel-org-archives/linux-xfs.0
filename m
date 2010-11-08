Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA8Kd76r118110 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 14:39:07 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DBD3F1C24E1E
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 12:40:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gvUVtuJxd1ecOTo7 for
	<xfs@oss.sgi.com>; Mon, 08 Nov 2010 12:40:34 -0800 (PST)
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 2/6] XFS: handle hole punching via fallocate properly
Date: Mon,  8 Nov 2010 15:32:03 -0500
Message-Id: <1289248327-16308-2-git-send-email-josef@redhat.com>
In-Reply-To: <1289248327-16308-1-git-send-email-josef@redhat.com>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
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
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, joel.becker@oracle.com, cmm@us.ibm.com, cluster-devel@redhat.com

This patch simply allows XFS to handle the hole punching flag in fallocate
properly.  I've tested this with a little program that does a bunch of random
hole punching with FL_KEEP_SIZE and without it to make sure it does the right
thing.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 96107ef..99df347 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -516,6 +516,7 @@ xfs_vn_fallocate(
 	loff_t		new_size = 0;
 	xfs_flock64_t	bf;
 	xfs_inode_t	*ip = XFS_I(inode);
+	int		cmd = XFS_IOC_RESVSP;
 
 	/* preallocation on directories not yet supported */
 	error = -ENODEV;
@@ -528,17 +529,22 @@ xfs_vn_fallocate(
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
+	if (mode & FALLOC_FL_PUNCH_HOLE)
+		cmd = XFS_IOC_UNRESVSP;
+
 	/* check the new inode size is valid before allocating */
 	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 	    offset + len > i_size_read(inode)) {
-		new_size = offset + len;
+		if (cmd == XFS_IOC_UNRESVSP)
+			new_size = offset;
+		else
+			new_size = offset + len;
 		error = inode_newsize_ok(inode, new_size);
 		if (error)
 			goto out_unlock;
 	}
 
-	error = -xfs_change_file_space(ip, XFS_IOC_RESVSP, &bf,
-				       0, XFS_ATTR_NOLOCK);
+	error = -xfs_change_file_space(ip, cmd, &bf, 0, XFS_ATTR_NOLOCK);
 	if (error)
 		goto out_unlock;
 
-- 
1.6.6.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
