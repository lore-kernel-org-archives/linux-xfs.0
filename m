Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MJPkJt227596 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 14:25:46 -0500
Received: from coco.kroah.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 816162E79C4
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 12:27:46 -0700 (PDT)
Received: from coco.kroah.org (kroah.org [198.145.64.141]) by cuda.sgi.com
	with ESMTP id ueJMONQxNtKpzfcS for <xfs@oss.sgi.com>;
	Thu, 22 Apr 2010 12:27:46 -0700 (PDT)
Message-Id: <20100422190909.635239163@kvm.kroah.org>
Date: Thu, 22 Apr 2010 12:07:56 -0700
From: Greg KH <gregkh@suse.de>
Subject: [025/197] xfs: remove invalid barrier optimization from xfs_fsync
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
Cc: stable-review@kernel.org, akpm@linux-foundation.org, xfs@oss.sgi.com, torvalds@linux-foundation.org, Christoph Hellwig <hch@lst.de>, alan@lxorguk.ukuu.org.uk

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Christoph Hellwig <hch@lst.de>

commit e8b217e7530c6a073ac69f1c85b922d93fdf5647 upstream

Date: Tue, 2 Feb 2010 10:16:26 +1100
We always need to flush the disk write cache and can't skip it just because
the no inode attributes have changed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/xfs_vnodeops.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -597,7 +597,7 @@ xfs_fsync(
 {
 	xfs_trans_t	*tp;
 	int		error = 0;
-	int		log_flushed = 0, changed = 1;
+	int		log_flushed = 0;
 
 	xfs_itrace_entry(ip);
 
@@ -627,19 +627,11 @@ xfs_fsync(
 		 * disk yet, the inode will be still be pinned.  If it is,
 		 * force the log.
 		 */
-
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
 		if (xfs_ipincount(ip)) {
 			error = _xfs_log_force(ip->i_mount, (xfs_lsn_t)0,
 				      XFS_LOG_FORCE | XFS_LOG_SYNC,
 				      &log_flushed);
-		} else {
-			/*
-			 * If the inode is not pinned and nothing has changed
-			 * we don't need to flush the cache.
-			 */
-			changed = 0;
 		}
 	} else	{
 		/*
@@ -674,7 +666,7 @@ xfs_fsync(
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 
-	if ((ip->i_mount->m_flags & XFS_MOUNT_BARRIER) && changed) {
+	if (ip->i_mount->m_flags & XFS_MOUNT_BARRIER) {
 		/*
 		 * If the log write didn't issue an ordered tag we need
 		 * to flush the disk cache for the data device now.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
