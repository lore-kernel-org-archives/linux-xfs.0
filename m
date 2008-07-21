Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 04:32:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6LBVxMK020701
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:32:00 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2AB2E12E8066
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:33:05 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id FKZh9EbP8F6ZIp6V for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:33:05 -0700 (PDT)
Date: Mon, 21 Jul 2008 21:33:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] XFS: Remove xfs_iflush_all and clean up
	xfs_finish_reclaim_all()
Message-ID: <20080721113302.GD6761@disturbed>
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-2-git-send-email-david@fromorbit.com> <20080721075826.GC6692@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721075826.GC6692@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Jul 21, 2008 at 03:58:26AM -0400, Christoph Hellwig wrote:
> On Sun, Jul 20, 2008 at 10:19:51PM +1000, Dave Chinner wrote:
> > xfs_iflush_all() walks the m_inodes list to find inodes that
> > need reclaiming. We already have such a list - the m_del_inodes
> > list. Replace xfs_iflush_all() with a call to xfs_finish_reclaim_all()
> > and clean up xfs_finish_reclaim_all() to handle the different flush
> > modes now needed.
> >
> >
> > 
> > Originally based on a patch from Christoph Hellwig.
> 
> Unlike my original patch is also now calls xfs_finish_reclaim_all
> unconditonal in xfs_syncsub.  This looks harmless but useless in the
> context of this patch, and actually useful for your next patches.

It's not really harmless - it reclaims inodes faster as reclaim
is now triggered by means other than xfssyncd. I'm not sure I should
perturb the reclaim behaviour right now (wasn't my intent) so I'll
change it back to the original code. It doesn't affect the other
patches in any material way...

> The xfs_finish_reclaim_all in xfs_quiesce_fs changes from
> XFS_IFLUSH_DELWRI_ELSE_ASYNC to XFS_IFLUSH_ASYNC, which needs an
> explanation.

Ah - that slipped through from the original patches - this change
was much later in the original series I wrote. It doesn't make much
sense to make this change until the inode writeback clustering gets
optimised.

Fixed patch is below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


XFS: Remove xfs_iflush_all and clean up xfs_finish_reclaim_all() V2

xfs_iflush_all() walks the m_inodes list to find inodes that
need reclaiming. We already have such a list - the m_del_inodes
list. Replace xfs_iflush_all() with a call to xfs_finish_reclaim_all()
and clean up xfs_finish_reclaim_all() to handle the different flush
modes now needed.

Originally based on a patch from Christoph Hellwig.

Signed-off-by: Dave Chinner <david@fromorbit.com>

---
Version 2
o revert xfs_syncsub() inode reclaim behaviour back to original
  code
o xfs_quiesce_fs() should use XFS_IFLUSH_DELWRI_ELSE_ASYNC, not
  XFS_IFLUSH_ASYNC, to prevent change of behaviour.

 fs/xfs/xfs_inode.c    |   39 ---------------------------------------
 fs/xfs/xfs_inode.h    |    3 +--
 fs/xfs/xfs_mount.c    |    2 +-
 fs/xfs/xfs_vfsops.c   |    4 ++--
 fs/xfs/xfs_vnodeops.c |   42 ++++++++++++++++++------------------------
 5 files changed, 22 insertions(+), 68 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 20b6f87..ae19b05 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3456,45 +3456,6 @@ corrupt_out:
 	return XFS_ERROR(EFSCORRUPTED);
 }
 
-
-/*
- * Flush all inactive inodes in mp.
- */
-void
-xfs_iflush_all(
-	xfs_mount_t	*mp)
-{
-	xfs_inode_t	*ip;
-	bhv_vnode_t	*vp;
-
- again:
-	XFS_MOUNT_ILOCK(mp);
-	ip = mp->m_inodes;
-	if (ip == NULL)
-		goto out;
-
-	do {
-		/* Make sure we skip markers inserted by sync */
-		if (ip->i_mount == NULL) {
-			ip = ip->i_mnext;
-			continue;
-		}
-
-		vp = XFS_ITOV_NULL(ip);
-		if (!vp) {
-			XFS_MOUNT_IUNLOCK(mp);
-			xfs_finish_reclaim(ip, 0, XFS_IFLUSH_ASYNC);
-			goto again;
-		}
-
-		ASSERT(vn_count(vp) == 0);
-
-		ip = ip->i_mnext;
-	} while (ip != mp->m_inodes);
- out:
-	XFS_MOUNT_IUNLOCK(mp);
-}
-
 #ifdef XFS_ILOCK_TRACE
 ktrace_t	*xfs_ilock_trace_buf;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 17a04b6..7ce41d3 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -480,7 +480,7 @@ void		xfs_iunlock_map_shared(xfs_inode_t *, uint);
 void		xfs_ifunlock(xfs_inode_t *);
 void		xfs_ireclaim(xfs_inode_t *);
 int		xfs_finish_reclaim(xfs_inode_t *, int, int);
-int		xfs_finish_reclaim_all(struct xfs_mount *, int);
+int		xfs_finish_reclaim_all(struct xfs_mount *, int, int);
 
 /*
  * xfs_inode.c prototypes.
@@ -518,7 +518,6 @@ void		xfs_ipin(xfs_inode_t *);
 void		xfs_iunpin(xfs_inode_t *);
 int		xfs_iextents_copy(xfs_inode_t *, xfs_bmbt_rec_t *, int);
 int		xfs_iflush(xfs_inode_t *, uint);
-void		xfs_iflush_all(struct xfs_mount *);
 void		xfs_ichgtime(xfs_inode_t *, int);
 xfs_fsize_t	xfs_file_last_byte(xfs_inode_t *);
 void		xfs_lock_inodes(xfs_inode_t **, int, uint);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 6c5d132..0c23f6a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1268,7 +1268,7 @@ xfs_unmountfs(xfs_mount_t *mp)
 	 * need to force the log first.
 	 */
 	xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE | XFS_LOG_SYNC);
-	xfs_iflush_all(mp);
+	xfs_finish_reclaim_all(mp, 0, XFS_IFLUSH_ASYNC);
 
 	XFS_QM_DQPURGEALL(mp, XFS_QMOPT_QUOTALL | XFS_QMOPT_UMOUNTING);
 
diff --git a/fs/xfs/xfs_vfsops.c b/fs/xfs/xfs_vfsops.c
index 4a9a433..ab3f004 100644
--- a/fs/xfs/xfs_vfsops.c
+++ b/fs/xfs/xfs_vfsops.c
@@ -65,7 +65,7 @@ xfs_quiesce_fs(
 	int			count = 0, pincount;
 
 	xfs_flush_buftarg(mp->m_ddev_targp, 0);
-	xfs_finish_reclaim_all(mp, 0);
+	xfs_finish_reclaim_all(mp, 0, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
 
 	/* This loop must run at least twice.
 	 * The first instance of the loop will flush
@@ -654,7 +654,7 @@ xfs_syncsub(
 
 	if (flags & (SYNC_ATTR|SYNC_DELWRI)) {
 		if (flags & SYNC_BDFLUSH)
-			xfs_finish_reclaim_all(mp, 1);
+			xfs_finish_reclaim_all(mp, 1, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
 		else
 			error = xfs_sync_inodes(mp, flags, bypassed);
 	}
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index b792a12..2af1be3 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2985,36 +2985,30 @@ xfs_finish_reclaim(
 }
 
 int
-xfs_finish_reclaim_all(xfs_mount_t *mp, int noblock)
+xfs_finish_reclaim_all(
+	xfs_mount_t	*mp,
+	int		 noblock,
+	int		mode)
 {
-	int		purged;
 	xfs_inode_t	*ip, *n;
-	int		done = 0;
 
-	while (!done) {
-		purged = 0;
-		XFS_MOUNT_ILOCK(mp);
-		list_for_each_entry_safe(ip, n, &mp->m_del_inodes, i_reclaim) {
-			if (noblock) {
-				if (xfs_ilock_nowait(ip, XFS_ILOCK_EXCL) == 0)
-					continue;
-				if (xfs_ipincount(ip) ||
-				    !xfs_iflock_nowait(ip)) {
-					xfs_iunlock(ip, XFS_ILOCK_EXCL);
-					continue;
-				}
+restart:
+	XFS_MOUNT_ILOCK(mp);
+	list_for_each_entry_safe(ip, n, &mp->m_del_inodes, i_reclaim) {
+		if (noblock) {
+			if (xfs_ilock_nowait(ip, XFS_ILOCK_EXCL) == 0)
+				continue;
+			if (xfs_ipincount(ip) ||
+			    !xfs_iflock_nowait(ip)) {
+				xfs_iunlock(ip, XFS_ILOCK_EXCL);
+				continue;
 			}
-			XFS_MOUNT_IUNLOCK(mp);
-			if (xfs_finish_reclaim(ip, noblock,
-					XFS_IFLUSH_DELWRI_ELSE_ASYNC))
-				delay(1);
-			purged = 1;
-			break;
 		}
-
-		done = !purged;
+		XFS_MOUNT_IUNLOCK(mp);
+		if (xfs_finish_reclaim(ip, noblock, mode))
+			delay(1);
+		goto restart;
 	}
-
 	XFS_MOUNT_IUNLOCK(mp);
 	return 0;
 }
