Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o193tlZj182555 for <xfs@oss.sgi.com>; Mon, 8 Feb 2010 21:55:47 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6209F1BBE09
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2010 19:56:59 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	PmukB8oDooE2SVnD for <xfs@oss.sgi.com>;
	Mon, 08 Feb 2010 19:56:59 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	12946199-1927428
	for <xfs@oss.sgi.com>; Tue, 09 Feb 2010 14:26:57 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NehDS-0000O1-1z
	for xfs@oss.sgi.com; Tue, 09 Feb 2010 14:56:46 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NehDR-0002SF-Bc
	for xfs@oss.sgi.com; Tue, 09 Feb 2010 14:56:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/9] xfs: Use delayed write for inodes rather than async V2
Date: Tue,  9 Feb 2010 14:56:35 +1100
Message-Id: <1265687802-23043-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1265687802-23043-1-git-send-email-david@fromorbit.com>
References: <1265687802-23043-1-git-send-email-david@fromorbit.com>
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

We currently do background inode flush asynchronously, resulting in
inodes being written in whatever order the background writeback
issues them. Not only that, there are also blocking and non-blocking
asynchronous inode flushes, depending on where the flush comes from.

This patch completely removes asynchronous inode writeback. It
removes all the strange writeback modes and replaces them with
either a synchronous flush or a non-blocking delayed write flush.
That is, inode flushes will only issue IO directly if they are
synchronous, and background flushing may do nothing if the operation
would block (e.g. on a pinned inode or buffer lock).

Delayed write flushes will now result in the inode buffer sitting in
the delwri queue of the buffer cache to be flushed by either an AIL
push or by the xfsbufd timing out the buffer. This will allow
accumulation of dirty inode buffers in memory and allow optimisation
of inode cluster writeback at the xfsbufd level where we have much
greater queue depths than the block layer elevators. We will also
get adjacent inode cluster buffer IO merging for free when a later
patch in the series allows sorting of the delayed write buffers
before dispatch.

This effectively means that any inode that is written back by
background writeback will be seen as flush locked during AIL
pushing, and will result in the buffers being pushed from there.
This writeback path is currently non-optimal, but the next patch
in the series will fix that problem.

A side effect of this delayed write mechanism is that background
inode reclaim will no longer directly flush inodes, nor can it wait
on the flush lock. The result is that inode reclaim must leave the
inode in the reclaimable state until it is clean. Hence attempts to
reclaim a dirty inode in the background will simply skip the inode
until it is clean and this allows other mechanisms (i.e. xfsbufd) to
do more optimal writeback of the dirty buffers. As a result, the
inode reclaim code has been rewritten so that it no longer relies on
the ambiguous return values of xfs_iflush() to determine whether it
is safe to reclaim an inode.

Portions of this patch are derived from patches by Christoph
Hellwig.

Version 2:
- cleanup reclaim code as suggested by Christoph
- log background reclaim inode flush errors
- just pass sync flags to xfs_iflush

Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_super.c |    4 +-
 fs/xfs/linux-2.6/xfs_sync.c  |  105 ++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_inode.c           |   75 ++----------------------------
 fs/xfs/xfs_inode.h           |   10 ----
 fs/xfs/xfs_inode_item.c      |   10 +++-
 fs/xfs/xfs_mount.c           |   13 +++++-
 6 files changed, 102 insertions(+), 115 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 6ce828e..3b5b46b 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1064,7 +1064,7 @@ xfs_fs_write_inode(
 		xfs_ilock(ip, XFS_ILOCK_SHARED);
 		xfs_iflock(ip);
 
-		error = xfs_iflush(ip, XFS_IFLUSH_SYNC);
+		error = xfs_iflush(ip, SYNC_WAIT);
 	} else {
 		error = EAGAIN;
 		if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
@@ -1072,7 +1072,7 @@ xfs_fs_write_inode(
 		if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip))
 			goto out_unlock;
 
-		error = xfs_iflush(ip, XFS_IFLUSH_ASYNC_NOBLOCK);
+		error = xfs_iflush(ip, 0);
 	}
 
  out_unlock:
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 525260c..a9f6d20 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -270,8 +270,7 @@ xfs_sync_inode_attr(
 		goto out_unlock;
 	}
 
-	error = xfs_iflush(ip, (flags & SYNC_WAIT) ?
-			   XFS_IFLUSH_SYNC : XFS_IFLUSH_DELWRI);
+	error = xfs_iflush(ip, flags);
 
  out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
@@ -460,16 +459,18 @@ xfs_quiesce_fs(
 {
 	int	count = 0, pincount;
 
+	xfs_reclaim_inodes(mp, 0);
 	xfs_flush_buftarg(mp->m_ddev_targp, 0);
-	xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
 
 	/*
 	 * This loop must run at least twice.  The first instance of the loop
 	 * will flush most meta data but that will generate more meta data
 	 * (typically directory updates).  Which then must be flushed and
-	 * logged before we can write the unmount record.
+	 * logged before we can write the unmount record. We also so sync
+	 * reclaim of inodes to catch any that the above delwri flush skipped.
 	 */
 	do {
+		xfs_reclaim_inodes(mp, SYNC_WAIT);
 		xfs_sync_attr(mp, SYNC_WAIT);
 		pincount = xfs_flush_buftarg(mp->m_ddev_targp, 1);
 		if (!pincount) {
@@ -585,7 +586,7 @@ xfs_sync_worker(
 
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
 		xfs_log_force(mp, 0);
-		xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
+		xfs_reclaim_inodes(mp, 0);
 		/* dgc: errors ignored here */
 		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
 		error = xfs_sync_fsdata(mp, SYNC_TRYLOCK);
@@ -719,21 +720,42 @@ __xfs_inode_clear_reclaim_tag(
  *	shutdown		EIO		unpin and reclaim
  *	clean, unpinned		0		reclaim
  *	stale, unpinned		0		reclaim
- *	clean, pinned(*)	0		unpin and reclaim
- *	stale, pinned		0		unpin and reclaim
- *	dirty, async		0		block on flush lock, reclaim
- *	dirty, sync flush	0		block on flush lock, reclaim
+ *	clean, pinned(*)	0		requeue
+ *	stale, pinned		EAGAIN		requeue
+ *	dirty, delwri ok	0		requeue
+ *	dirty, delwri blocked	EAGAIN		requeue
+ *	dirty, sync flush	0		reclaim
  *
  * (*) dgc: I don't think the clean, pinned state is possible but it gets
  * handled anyway given the order of checks implemented.
  *
+ * As can be seen from the table, the return value of xfs_iflush() is not
+ * sufficient to correctly decide the reclaim action here. The checks in
+ * xfs_iflush() might look like duplicates, but they are not.
+ *
+ * Also, because we get the flush lock first, we know that any inode that has
+ * been flushed delwri has had the flush completed by the time we check that
+ * the inode is clean. The clean inode check needs to be done before flushing
+ * the inode delwri otherwise we would loop forever requeuing clean inodes as
+ * we cannot tell apart a successful delwri flush and a clean inode from the
+ * return value of xfs_iflush().
+ *
+ * Note that because the inode is flushed delayed write by background
+ * writeback, the flush lock may already be held here and waiting on it can
+ * result in very long latencies. Hence for sync reclaims, where we wait on the
+ * flush lock, the caller should push out delayed write inodes first before
+ * trying to reclaim them to minimise the amount of time spent waiting. For
+ * background relaim, we just requeue the inode for the next pass.
+ *
  * Hence the order of actions after gaining the locks should be:
  *	bad		=> reclaim
  *	shutdown	=> unpin and reclaim
- *	pinned		=> unpin
+ *	pinned, delwri	=> requeue
+ *	pinned, sync	=> unpin
  *	stale		=> reclaim
  *	clean		=> reclaim
- *	dirty		=> flush, wait and reclaim
+ *	dirty, delwri	=> flush and requeue
+ *	dirty, sync	=> flush, wait and reclaim
  */
 STATIC int
 xfs_reclaim_inode(
@@ -741,7 +763,7 @@ xfs_reclaim_inode(
 	struct xfs_perag	*pag,
 	int			sync_mode)
 {
-	int	error;
+	int	error = 0;
 
 	/*
 	 * The radix tree lock here protects a thread in xfs_iget from racing
@@ -761,7 +783,11 @@ xfs_reclaim_inode(
 	write_unlock(&pag->pag_ici_lock);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_iflock(ip);
+	if (!xfs_iflock_nowait(ip)) {
+		if (!(sync_mode & SYNC_WAIT))
+			goto out;
+		xfs_iflock(ip);
+	}
 
 	if (is_bad_inode(VFS_I(ip)))
 		goto reclaim;
@@ -769,8 +795,13 @@ xfs_reclaim_inode(
 		xfs_iunpin_wait(ip);
 		goto reclaim;
 	}
-	if (xfs_ipincount(ip))
+	if (xfs_ipincount(ip)) {
+		if (!(sync_mode & SYNC_WAIT)) {
+			xfs_ifunlock(ip);
+			goto out;
+		}
 		xfs_iunpin_wait(ip);
+	}
 	if (xfs_iflags_test(ip, XFS_ISTALE))
 		goto reclaim;
 	if (xfs_inode_clean(ip))
@@ -778,27 +809,43 @@ xfs_reclaim_inode(
 
 	/* Now we have an inode that needs flushing */
 	error = xfs_iflush(ip, sync_mode);
-	if (!error) {
-		switch(sync_mode) {
-		case XFS_IFLUSH_DELWRI_ELSE_ASYNC:
-		case XFS_IFLUSH_DELWRI:
-		case XFS_IFLUSH_ASYNC:
-		case XFS_IFLUSH_DELWRI_ELSE_SYNC:
-		case XFS_IFLUSH_SYNC:
-			/* IO issued, synchronise with IO completion */
-			xfs_iflock(ip);
-			break;
-		default:
-			ASSERT(0);
-			break;
-		}
+	if (sync_mode & SYNC_WAIT) {
+		xfs_iflock(ip);
+		goto reclaim;
 	}
 
+	/*
+	 * When we have to flush an inode but don't have SYNC_WAIT set, we
+	 * flush the inode out using a delwri buffer and wait for the next
+	 * call into reclaim to find it in a clean state instead of waiting for
+	 * it now. We also don't return errors here - if the error is transient
+	 * then the next reclaim pass will flush the inode, and if the error
+	 * is permanent then the next sync reclaim will relcaim the inode and
+	 * pass on the error.
+	 */
+	if (error && !XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+		xfs_fs_cmn_err(CE_WARN, ip->i_mount,
+			"inode 0x%llx background reclaim flush failed with %d",
+			(long long)ip->i_ino, error);
+	}
+out:
+	xfs_iflags_clear(ip, XFS_IRECLAIM);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	/*
+	 * We could return EAGAIN here to make reclaim rescan the inode tree in
+	 * a short while. However, this just burns CPU time scanning the tree
+	 * waiting for IO to complete and xfssyncd never goes back to the idle
+	 * state. Instead, return 0 to let the next scheduled background reclaim
+	 * attempt to reclaim the inode again.
+	 */
+	return 0;
+
 reclaim:
 	xfs_ifunlock(ip);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_ireclaim(ip);
-	return 0;
+	return error;
+
 }
 
 int
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8d0666d..fa31360 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2835,8 +2835,6 @@ xfs_iflush(
 	xfs_dinode_t		*dip;
 	xfs_mount_t		*mp;
 	int			error;
-	int			noblock = (flags == XFS_IFLUSH_ASYNC_NOBLOCK);
-	enum { INT_DELWRI = (1 << 0), INT_ASYNC = (1 << 1) };
 
 	XFS_STATS_INC(xs_iflush_count);
 
@@ -2859,7 +2857,7 @@ xfs_iflush(
 	 * in the same cluster are dirty, they will probably write the inode
 	 * out for us if they occur after the log force completes.
 	 */
-	if (noblock && xfs_ipincount(ip)) {
+	if (!(flags & SYNC_WAIT) && xfs_ipincount(ip)) {
 		xfs_iunpin_nowait(ip);
 		xfs_ifunlock(ip);
 		return EAGAIN;
@@ -2893,60 +2891,10 @@ xfs_iflush(
 	}
 
 	/*
-	 * Decide how buffer will be flushed out.  This is done before
-	 * the call to xfs_iflush_int because this field is zeroed by it.
-	 */
-	if (iip != NULL && iip->ili_format.ilf_fields != 0) {
-		/*
-		 * Flush out the inode buffer according to the directions
-		 * of the caller.  In the cases where the caller has given
-		 * us a choice choose the non-delwri case.  This is because
-		 * the inode is in the AIL and we need to get it out soon.
-		 */
-		switch (flags) {
-		case XFS_IFLUSH_SYNC:
-		case XFS_IFLUSH_DELWRI_ELSE_SYNC:
-			flags = 0;
-			break;
-		case XFS_IFLUSH_ASYNC_NOBLOCK:
-		case XFS_IFLUSH_ASYNC:
-		case XFS_IFLUSH_DELWRI_ELSE_ASYNC:
-			flags = INT_ASYNC;
-			break;
-		case XFS_IFLUSH_DELWRI:
-			flags = INT_DELWRI;
-			break;
-		default:
-			ASSERT(0);
-			flags = 0;
-			break;
-		}
-	} else {
-		switch (flags) {
-		case XFS_IFLUSH_DELWRI_ELSE_SYNC:
-		case XFS_IFLUSH_DELWRI_ELSE_ASYNC:
-		case XFS_IFLUSH_DELWRI:
-			flags = INT_DELWRI;
-			break;
-		case XFS_IFLUSH_ASYNC_NOBLOCK:
-		case XFS_IFLUSH_ASYNC:
-			flags = INT_ASYNC;
-			break;
-		case XFS_IFLUSH_SYNC:
-			flags = 0;
-			break;
-		default:
-			ASSERT(0);
-			flags = 0;
-			break;
-		}
-	}
-
-	/*
 	 * Get the buffer containing the on-disk inode.
 	 */
 	error = xfs_itobp(mp, NULL, ip, &dip, &bp,
-				noblock ? XBF_TRYLOCK : XBF_LOCK);
+				(flags & SYNC_WAIT) ? XBF_LOCK : XBF_TRYLOCK);
 	if (error || !bp) {
 		xfs_ifunlock(ip);
 		return error;
@@ -2974,13 +2922,10 @@ xfs_iflush(
 	if (error)
 		goto cluster_corrupt_out;
 
-	if (flags & INT_DELWRI) {
-		xfs_bdwrite(mp, bp);
-	} else if (flags & INT_ASYNC) {
-		error = xfs_bawrite(mp, bp);
-	} else {
+	if (flags & SYNC_WAIT)
 		error = xfs_bwrite(mp, bp);
-	}
+	else
+		xfs_bdwrite(mp, bp);
 	return error;
 
 corrupt_out:
@@ -3015,16 +2960,6 @@ xfs_iflush_int(
 	iip = ip->i_itemp;
 	mp = ip->i_mount;
 
-
-	/*
-	 * If the inode isn't dirty, then just release the inode
-	 * flush lock and do nothing.
-	 */
-	if (xfs_inode_clean(ip)) {
-		xfs_ifunlock(ip);
-		return 0;
-	}
-
 	/* set *dip = inode's place in the buffer */
 	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 8b618ea..6c912b0 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -420,16 +420,6 @@ static inline void xfs_ifunlock(xfs_inode_t *ip)
 #define XFS_ILOCK_DEP(flags)	(((flags) & XFS_ILOCK_DEP_MASK) >> XFS_ILOCK_SHIFT)
 
 /*
- * Flags for xfs_iflush()
- */
-#define	XFS_IFLUSH_DELWRI_ELSE_SYNC	1
-#define	XFS_IFLUSH_DELWRI_ELSE_ASYNC	2
-#define	XFS_IFLUSH_SYNC			3
-#define	XFS_IFLUSH_ASYNC		4
-#define	XFS_IFLUSH_DELWRI		5
-#define	XFS_IFLUSH_ASYNC_NOBLOCK	6
-
-/*
  * Flags for xfs_itruncate_start().
  */
 #define	XFS_ITRUNC_DEFINITE	0x1
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 48ec1c0..207553e 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -866,10 +866,14 @@ xfs_inode_item_push(
 	       iip->ili_format.ilf_fields != 0);
 
 	/*
-	 * Write out the inode.  The completion routine ('iflush_done') will
-	 * pull it from the AIL, mark it clean, unlock the flush lock.
+	 * Push the inode to it's backing buffer. This will not remove the
+	 * inode from the AIL - a further push will be required to trigger a
+	 * buffer push. However, this allows all the dirty inodes to be pushed
+	 * to the buffer before it is pushed to disk. THe buffer IO completion
+	 * will pull th einode from the AIL, mark it clean and unlock the flush
+	 * lock.
 	 */
-	(void) xfs_iflush(ip, XFS_IFLUSH_ASYNC);
+	(void) xfs_iflush(ip, 0);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	return;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5061149..6afaaeb 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1468,7 +1468,18 @@ xfs_unmountfs(
 	 * need to force the log first.
 	 */
 	xfs_log_force(mp, XFS_LOG_SYNC);
-	xfs_reclaim_inodes(mp, XFS_IFLUSH_ASYNC);
+
+	/*
+	 * Do a delwri reclaim pass first so that as many dirty inodes are
+	 * queued up for IO as possible. Then flush the buffers before making
+	 * a synchronous path to catch all the remaining inodes are reclaimed.
+	 * This makes the reclaim process as quick as possible by avoiding
+	 * synchronous writeout and blocking on inodes already in the delwri
+	 * state as much as possible.
+	 */
+	xfs_reclaim_inodes(mp, 0);
+	XFS_bflush(mp->m_ddev_targp);
+	xfs_reclaim_inodes(mp, SYNC_WAIT);
 
 	xfs_qm_unmount(mp);
 
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
