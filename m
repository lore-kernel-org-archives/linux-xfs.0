Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2BMfEss194491 for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 16:41:14 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A3111D2DEB9
	for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 14:42:46 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	MOj1wJpAPD49VnLt for <xfs@oss.sgi.com>;
	Thu, 11 Mar 2010 14:42:45 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 16/19] xfs: don't hold onto reserved blocks on remount,ro
Date: Fri, 12 Mar 2010 09:42:14 +1100
Message-Id: <1268347337-7160-17-git-send-email-david@fromorbit.com>
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

>From cbe132a8bdcff0f9afd9060948fb50597c7400b8
Date: Tue, 26 Jan 2010 15:08:49 +1100
If we hold onto reserved blocks when doing a remount,ro we end
up writing the blocks used count to disk that includes the reserved
blocks. Reserved blocks are not actually used, so this results in
the values in the superblock being incorrect.

Hence if we run xfs_check or xfs_repair -n while the filesystem is
mounted remount,ro we end up with an inconsistent filesystem being
reported. Also, running xfs_copy on the remount,ro filesystem will
result in an inconsistent image being generated.

To fix this, unreserve the blocks when doing the remount,ro, and
reserved them again on remount,rw. This way a remount,ro filesystem
will appear consistent on disk to all utilities.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_super.c |   28 ++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h           |    1 +
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index ea7a59a..aae1249 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1323,6 +1323,8 @@ xfs_fs_remount(
 
 	/* ro -> rw */
 	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & MS_RDONLY)) {
+		__uint64_t resblks;
+
 		mp->m_flags &= ~XFS_MOUNT_RDONLY;
 		if (mp->m_flags & XFS_MOUNT_BARRIER)
 			xfs_mountfs_check_barriers(mp);
@@ -1340,11 +1342,37 @@ xfs_fs_remount(
 			}
 			mp->m_update_flags = 0;
 		}
+
+		/*
+		 * Fill out the reserve pool if it is empty. Use the stashed
+		 * value if it is non-zero, otherwise go with the default.
+		 */
+		if (mp->m_resblks_save) {
+			resblks = mp->m_resblks_save;
+			mp->m_resblks_save = 0;
+		} else {
+			resblks = mp->m_sb.sb_dblocks;
+			do_div(resblks, 20);
+			resblks = min_t(__uint64_t, resblks, 1024);
+		}
+		xfs_reserve_blocks(mp, &resblks, NULL);
 	}
 
 	/* rw -> ro */
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & MS_RDONLY)) {
+		/*
+		 * After we have synced the data but before we sync the
+		 * metadata, we need to free up the reserve block pool so that
+		 * the used block count in the superblock on disk is correct at
+		 * the end of the remount. Stash the current reserve pool size
+		 * so that if we get remounted rw, we can return it to the same
+		 * size.
+		 */
+		__uint64_t resblks = 0;
+
 		xfs_quiesce_data(mp);
+		mp->m_resblks_save = mp->m_resblks;
+		xfs_reserve_blocks(mp, &resblks, NULL);
 		xfs_quiesce_attr(mp);
 		mp->m_flags |= XFS_MOUNT_RDONLY;
 	}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a6c023b..1e6094f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -209,6 +209,7 @@ typedef struct xfs_mount {
 	__uint64_t		m_maxioffset;	/* maximum inode offset */
 	__uint64_t		m_resblks;	/* total reserved blocks */
 	__uint64_t		m_resblks_avail;/* available reserved blocks */
+	__uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
 	int			m_dalign;	/* stripe unit */
 	int			m_swidth;	/* stripe width */
 	int			m_sinoalign;	/* stripe unit inode alignment */
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
