Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MJPjxa227578 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 14:25:45 -0500
Received: from coco.kroah.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD5A61AE628B
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 12:27:45 -0700 (PDT)
Received: from coco.kroah.org (kroah.org [198.145.64.141]) by cuda.sgi.com
	with ESMTP id VKHxKi7PizK8NxTG for <xfs@oss.sgi.com>;
	Thu, 22 Apr 2010 12:27:45 -0700 (PDT)
Message-Id: <20100422190909.551446158@kvm.kroah.org>
Date: Thu, 22 Apr 2010 12:07:55 -0700
From: Greg KH <gregkh@suse.de>
Subject: [024/197] xfs: dont hold onto reserved blocks on remount, ro
In-Reply-To: <20100422191857.GA13268@kroah.com>
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
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: xfs@oss.sgi.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, stable-review@kernel.org, alan@lxorguk.ukuu.org.uk

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Chinner <david@fromorbit.com>

commit cbe132a8bdcff0f9afd9060948fb50597c7400b8 upstream

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_super.c |   28 ++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h           |    1 +
 2 files changed, 29 insertions(+)

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


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
