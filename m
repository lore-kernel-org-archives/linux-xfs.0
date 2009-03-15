Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FBWeTa006955 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 06:33:00 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67E1519A00D
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:32:17 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail08.adl2.internode.on.net
	[203.16.214.72]) by cuda.sgi.com with ESMTP id Ehvqcx8TltceimVi
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:32:17 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/5] [XFS] Block callers of xfs_flush_inodes() correctly.
Date: Sun, 15 Mar 2009 22:31:45 +1100
Message-Id: <1237116707-25793-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1237116707-25793-1-git-send-email-david@fromorbit.com>
References: <1237116707-25793-1-git-send-email-david@fromorbit.com>
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

xfs_flush_inodes() currently uses a magic timeout to wait for
some inodes to be flushed before returning. This isn't
really reliable but used to be the best that could be done
due to deadlock potential of waiting for the entire flush.

Now the inode flush is safe to execute while we hold page
and inode locks, we can wait for all the inodes to flush
synchronously. Convert the wait mechanism to a completion
to do this efficiently. This should remove all remaining
spurious ENOSPC errors from the delayed allocation reservation
path.

This is extracted almost line for line from a larger patch
from Mikulas Patocka.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   12 +++++++++---
 fs/xfs/linux-2.6/xfs_sync.h |    1 +
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 73cf8dc..f7ba766 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -404,7 +404,8 @@ STATIC void
 xfs_syncd_queue_work(
 	struct xfs_mount *mp,
 	void		*data,
-	void		(*syncer)(struct xfs_mount *, void *))
+	void		(*syncer)(struct xfs_mount *, void *),
+	struct completion *completion)
 {
 	struct xfs_sync_work *work;
 
@@ -413,6 +414,7 @@ xfs_syncd_queue_work(
 	work->w_syncer = syncer;
 	work->w_data = data;
 	work->w_mount = mp;
+	work->w_completion = completion;
 	spin_lock(&mp->m_sync_lock);
 	list_add_tail(&work->w_list, &mp->m_sync_list);
 	spin_unlock(&mp->m_sync_lock);
@@ -441,10 +443,11 @@ xfs_flush_inodes(
 	xfs_inode_t	*ip)
 {
 	struct inode	*inode = VFS_I(ip);
+	DECLARE_COMPLETION_ONSTACK(completion);
 
 	igrab(inode);
-	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_inodes_work);
-	delay(msecs_to_jiffies(500));
+	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_inodes_work, &completion);
+	wait_for_completion(&completion);
 	xfs_log_force(ip->i_mount, (xfs_lsn_t)0, XFS_LOG_FORCE|XFS_LOG_SYNC);
 }
 
@@ -514,6 +517,8 @@ xfssyncd(
 			list_del(&work->w_list);
 			if (work == &mp->m_sync_work)
 				continue;
+			if (work->w_completion)
+				complete(work->w_completion);
 			kmem_free(work);
 		}
 	}
@@ -527,6 +532,7 @@ xfs_syncd_init(
 {
 	mp->m_sync_work.w_syncer = xfs_sync_worker;
 	mp->m_sync_work.w_mount = mp;
+	mp->m_sync_work.w_completion = NULL;
 	mp->m_sync_task = kthread_run(xfssyncd, mp, "xfssyncd");
 	if (IS_ERR(mp->m_sync_task))
 		return -PTR_ERR(mp->m_sync_task);
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index 6e83a35..308d5bf 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -26,6 +26,7 @@ typedef struct xfs_sync_work {
 	struct xfs_mount	*w_mount;
 	void			*w_data;	/* syncer routine argument */
 	void			(*w_syncer)(struct xfs_mount *, void *);
+	struct completion	*w_completion;
 } xfs_sync_work_t;
 
 #define SYNC_ATTR		0x0001	/* sync attributes */
-- 
1.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
