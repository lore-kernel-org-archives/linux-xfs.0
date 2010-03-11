Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2BMf5um194423 for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 16:41:06 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4C39233ABF
	for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 14:42:37 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	aS5agsDl2lqePLtr for <xfs@oss.sgi.com>;
	Thu, 11 Mar 2010 14:42:37 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/19] xfs: I/O completion handlers must use NOFS allocations
Date: Fri, 12 Mar 2010 09:42:01 +1100
Message-Id: <1268347337-7160-4-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

>From 80641dc66a2d6dfb22af4413227a92b8ab84c7bb
Date: Mon, 19 Oct 2009 04:00:03 +0000
When completing I/O requests we must not allow the memory allocator to
recurse into the filesystem, as we might deadlock on waiting for the
I/O completion otherwise.  The only thing currently allocating normal
GFP_KERNEL memory is the allocation of the transaction structure for
the unwritten extent conversion.  Add a memflags argument to
_xfs_trans_alloc to allow controlling the allocator behaviour.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Thomas Neumann <tneumann@users.sourceforge.net>
Tested-by: Thomas Neumann <tneumann@users.sourceforge.net>
Reviewed-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_fsops.c |    2 +-
 fs/xfs/xfs_iomap.c |    9 ++++++++-
 fs/xfs/xfs_mount.c |    2 +-
 fs/xfs/xfs_trans.c |    7 ++++---
 fs/xfs/xfs_trans.h |    2 +-
 5 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 2d0b3e1..6f83f58 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -611,7 +611,7 @@ xfs_fs_log_dummy(
 	xfs_inode_t	*ip;
 	int		error;
 
-	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1);
+	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1, KM_SLEEP);
 	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 67ae555..7294abc 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -860,8 +860,15 @@ xfs_iomap_write_unwritten(
 		 * set up a transaction to convert the range of extents
 		 * from unwritten to real. Do allocations in a loop until
 		 * we have covered the range passed in.
+		 *
+		 * Note that we open code the transaction allocation here
+		 * to pass KM_NOFS--we can't risk to recursing back into
+		 * the filesystem here as we might be asked to write out
+		 * the same inode that we complete here and might deadlock
+		 * on the iolock.
 		 */
-		tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
+		xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
+		tp = _xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE, KM_NOFS);
 		tp->t_flags |= XFS_TRANS_RESERVE;
 		error = xfs_trans_reserve(tp, resblks,
 				XFS_WRITE_LOG_RES(mp), 0,
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 8b6c9e8..4d509f7 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1471,7 +1471,7 @@ xfs_log_sbcount(
 	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
 		return 0;
 
-	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT);
+	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT, KM_SLEEP);
 	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
 					XFS_DEFAULT_LOG_COUNT);
 	if (error) {
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 66b8493..237badc 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -236,19 +236,20 @@ xfs_trans_alloc(
 	uint		type)
 {
 	xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
-	return _xfs_trans_alloc(mp, type);
+	return _xfs_trans_alloc(mp, type, KM_SLEEP);
 }
 
 xfs_trans_t *
 _xfs_trans_alloc(
 	xfs_mount_t	*mp,
-	uint		type)
+	uint		type,
+	uint		memflags)
 {
 	xfs_trans_t	*tp;
 
 	atomic_inc(&mp->m_active_trans);
 
-	tp = kmem_zone_zalloc(xfs_trans_zone, KM_SLEEP);
+	tp = kmem_zone_zalloc(xfs_trans_zone, memflags);
 	tp->t_magic = XFS_TRANS_MAGIC;
 	tp->t_type = type;
 	tp->t_mountp = mp;
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index ed47fc7..a0574f5 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -924,7 +924,7 @@ typedef struct xfs_trans {
  * XFS transaction mechanism exported interfaces.
  */
 xfs_trans_t	*xfs_trans_alloc(struct xfs_mount *, uint);
-xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint);
+xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint, uint);
 xfs_trans_t	*xfs_trans_dup(xfs_trans_t *);
 int		xfs_trans_reserve(xfs_trans_t *, uint, uint, uint,
 				  uint, uint);
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
