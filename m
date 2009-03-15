Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FAxD39004564 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 05:59:34 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D53A41C436D7
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 03:58:29 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail02.adl2.internode.on.net
	[203.16.214.66]) by cuda.sgi.com with ESMTP id YWsoxvRhCK46MlKR
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 03:58:29 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/5] [XFS] Make inode flush at ENOSPC synchronous
Date: Sun, 15 Mar 2009 21:57:56 +1100
Message-Id: <1237114679-18808-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1237114679-18808-1-git-send-email-david@fromorbit.com>
References: <1237114679-18808-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com
Cc: mpatocka@redhat.com

From: Dave Chinner <dgc@evostor.com>

When we are writing to a single file and hit ENOSPC, we trigger a background
flush of the inode and try again.  Because we hold page locks and the iolock,
the flush won't proceed until after we release these locks. This occurs once
we've given up and ENOSPC has been reported. Hence if this one is the only
dirty inode in the system, we'll get an ENOSPC prematurely.

To fix this, remove the async flush from the allocation routines and move
it to the top of the write path where we can do a synchronous flush
and retry the write again. Only retry once as a second ENOSPC indicates
that we really are ENOSPC.

This avoids a page cache deadlock when trying to do this flush synchronously
in the allocation layer that was identified by Mikulas Patocka.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_lrw.c  |   18 +++++++++++++++++-
 fs/xfs/linux-2.6/xfs_sync.c |   25 -------------------------
 fs/xfs/linux-2.6/xfs_sync.h |    1 -
 fs/xfs/xfs_iomap.c          |    2 +-
 4 files changed, 18 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_lrw.c b/fs/xfs/linux-2.6/xfs_lrw.c
index 7e90daa..9142192 100644
--- a/fs/xfs/linux-2.6/xfs_lrw.c
+++ b/fs/xfs/linux-2.6/xfs_lrw.c
@@ -751,10 +751,26 @@ start:
 			goto relock;
 		}
 	} else {
+		int enospc = 0;
+		ssize_t ret2 = 0;
+
+write_retry:
 		xfs_rw_enter_trace(XFS_WRITE_ENTER, xip, (void *)iovp, segs,
 				*offset, ioflags);
-		ret = generic_file_buffered_write(iocb, iovp, segs,
+		ret2 = generic_file_buffered_write(iocb, iovp, segs,
 				pos, offset, count, ret);
+		/*
+		 * if we just got an ENOSPC, flush the inode now we
+		 * aren't holding any page locks and retry *once*
+		 */
+		if (ret2 == -ENOSPC && !enospc) {
+			error = xfs_flush_pages(xip, 0, -1, 0, FI_NONE);
+			if (error)
+				goto out_unlock_internal;
+			enospc = 1;
+			goto write_retry;
+		}
+		ret = ret2;
 	}
 
 	current->backing_dev_info = NULL;
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 88caafc..73cf8dc 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -426,31 +426,6 @@ xfs_syncd_queue_work(
  * heads, looking about for more room...
  */
 STATIC void
-xfs_flush_inode_work(
-	struct xfs_mount *mp,
-	void		*arg)
-{
-	struct inode	*inode = arg;
-	filemap_flush(inode->i_mapping);
-	iput(inode);
-}
-
-void
-xfs_flush_inode(
-	xfs_inode_t	*ip)
-{
-	struct inode	*inode = VFS_I(ip);
-
-	igrab(inode);
-	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_inode_work);
-	delay(msecs_to_jiffies(500));
-}
-
-/*
- * This is the "bigger hammer" version of xfs_flush_inode_work...
- * (IOW, "If at first you don't succeed, use a Bigger Hammer").
- */
-STATIC void
 xfs_flush_inodes_work(
 	struct xfs_mount *mp,
 	void		*arg)
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index ec95e26..6e83a35 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -44,7 +44,6 @@ int xfs_sync_fsdata(struct xfs_mount *mp, int flags);
 int xfs_quiesce_data(struct xfs_mount *mp);
 void xfs_quiesce_attr(struct xfs_mount *mp);
 
-void xfs_flush_inode(struct xfs_inode *ip);
 void xfs_flush_inodes(struct xfs_inode *ip);
 
 int xfs_reclaim_inode(struct xfs_inode *ip, int locked, int sync_mode);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 8b97d82..7b8b170 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -347,7 +347,7 @@ xfs_flush_space(
 	case 0:
 		if (ip->i_delayed_blks) {
 			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-			xfs_flush_inode(ip);
+			delay(1);
 			xfs_ilock(ip, XFS_ILOCK_EXCL);
 			*fsynced = 1;
 		} else {
-- 
1.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
