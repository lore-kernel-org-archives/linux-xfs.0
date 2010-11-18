Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAI1sYhD115683 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 19:54:35 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 943F718BF6F
	for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 17:56:08 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BnohCdJDUMNd43UR for
	<xfs@oss.sgi.com>; Wed, 17 Nov 2010 17:56:08 -0800 (PST)
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 2/6] XFS: handle hole punching via fallocate properly
Date: Wed, 17 Nov 2010 20:46:16 -0500
Message-Id: <1290044780-2902-3-git-send-email-josef@redhat.com>
In-Reply-To: <1290044780-2902-1-git-send-email-josef@redhat.com>
References: <1290044780-2902-1-git-send-email-josef@redhat.com>
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
To: david@fromorbit.com, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com, cluster-devel@redhat.com, joel.becker@oracle.com, jack@suse.cz

This patch simply allows XFS to handle the hole punching flag in fallocate
properly.  I've tested this with a little program that does a bunch of random
hole punching with FL_KEEP_SIZE and without it to make sure it does the right
thing.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 96107ef..07d2164 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -516,6 +516,7 @@ xfs_vn_fallocate(
 	loff_t		new_size = 0;
 	xfs_flock64_t	bf;
 	xfs_inode_t	*ip = XFS_I(inode);
+	int		cmd = XFS_IOC_RESVSP;
 
 	/* preallocation on directories not yet supported */
 	error = -ENODEV;
@@ -528,6 +529,9 @@ xfs_vn_fallocate(
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
+	if (mode & FALLOC_FL_PUNCH_HOLE)
+		cmd = XFS_IOC_UNRESVSP;
+
 	/* check the new inode size is valid before allocating */
 	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 	    offset + len > i_size_read(inode)) {
@@ -537,8 +541,7 @@ xfs_vn_fallocate(
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
