Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o193tbMJ182485 for <xfs@oss.sgi.com>; Mon, 8 Feb 2010 21:55:37 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6248A1CB5F52
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2010 19:56:48 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	Td93y6E8GVye24vs for <xfs@oss.sgi.com>;
	Mon, 08 Feb 2010 19:56:48 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	12912035-1927428
	for <xfs@oss.sgi.com>; Tue, 09 Feb 2010 14:26:47 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NehDS-0000O0-0t
	for xfs@oss.sgi.com; Tue, 09 Feb 2010 14:56:46 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NehDR-0002SC-9K
	for xfs@oss.sgi.com; Tue, 09 Feb 2010 14:56:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/9] xfs: Make inode reclaim states explicit
Date: Tue,  9 Feb 2010 14:56:34 +1100
Message-Id: <1265687802-23043-2-git-send-email-david@fromorbit.com>
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

A.K.A.: don't rely on xfs_iflush() return value in reclaim

We have gradually been moving checks out of the reclaim code because
they are duplicated in xfs_iflush(). We've had a history of problems
in this area, and many of them stem from the overloading of the
return values from xfs_iflush() and interaction with inode flush
locking to determine if the inode is safe to reclaim.

With the desire to move to delayed write flushing of inodes and
non-blocking inode tree reclaim walks, the overloading of the
return value of xfs_iflush makes it very difficult to determine
the correct thing to do next.

This patch explicitly re-adds the checks to the inode reclaim code,
removing the reliance on the return value of xfs_iflush() to
determine what to do next. It also means that we can clearly
document all the inode states that reclaim must handle and hence
we can easily see that we handled all the necessary cases.

This also removes the need for the xfs_inode_clean() check in
xfs_iflush() as all callers now check this first (safely).

Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_sync.c |   81 +++++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_inode.c          |   11 +-----
 fs/xfs/xfs_inode.h          |    1 +
 3 files changed, 64 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index c9b863e..525260c 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -706,12 +706,43 @@ __xfs_inode_clear_reclaim_tag(
 			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
 }
 
+/*
+ * Inodes in different states need to be treated differently, and the return
+ * value of xfs_iflush is not sufficient to get this right. The following table
+ * lists the inode states and the reclaim actions necessary for non-blocking
+ * reclaim:
+ *
+ *
+ *	inode state	     iflush ret		required action
+ *      ---------------      ----------         ---------------
+ *	bad			-		reclaim
+ *	shutdown		EIO		unpin and reclaim
+ *	clean, unpinned		0		reclaim
+ *	stale, unpinned		0		reclaim
+ *	clean, pinned(*)	0		unpin and reclaim
+ *	stale, pinned		0		unpin and reclaim
+ *	dirty, async		0		block on flush lock, reclaim
+ *	dirty, sync flush	0		block on flush lock, reclaim
+ *
+ * (*) dgc: I don't think the clean, pinned state is possible but it gets
+ * handled anyway given the order of checks implemented.
+ *
+ * Hence the order of actions after gaining the locks should be:
+ *	bad		=> reclaim
+ *	shutdown	=> unpin and reclaim
+ *	pinned		=> unpin
+ *	stale		=> reclaim
+ *	clean		=> reclaim
+ *	dirty		=> flush, wait and reclaim
+ */
 STATIC int
 xfs_reclaim_inode(
 	struct xfs_inode	*ip,
 	struct xfs_perag	*pag,
 	int			sync_mode)
 {
+	int	error;
+
 	/*
 	 * The radix tree lock here protects a thread in xfs_iget from racing
 	 * with us starting reclaim on the inode.  Once we have the
@@ -729,30 +760,42 @@ xfs_reclaim_inode(
 	spin_unlock(&ip->i_flags_lock);
 	write_unlock(&pag->pag_ici_lock);
 
-	/*
-	 * If the inode is still dirty, then flush it out.  If the inode
-	 * is not in the AIL, then it will be OK to flush it delwri as
-	 * long as xfs_iflush() does not keep any references to the inode.
-	 * We leave that decision up to xfs_iflush() since it has the
-	 * knowledge of whether it's OK to simply do a delwri flush of
-	 * the inode or whether we need to wait until the inode is
-	 * pulled from the AIL.
-	 * We get the flush lock regardless, though, just to make sure
-	 * we don't free it while it is being flushed.
-	 */
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_iflock(ip);
 
-	/*
-	 * In the case of a forced shutdown we rely on xfs_iflush() to
-	 * wait for the inode to be unpinned before returning an error.
-	 */
-	if (!is_bad_inode(VFS_I(ip)) && xfs_iflush(ip, sync_mode) == 0) {
-		/* synchronize with xfs_iflush_done */
-		xfs_iflock(ip);
-		xfs_ifunlock(ip);
+	if (is_bad_inode(VFS_I(ip)))
+		goto reclaim;
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+		xfs_iunpin_wait(ip);
+		goto reclaim;
+	}
+	if (xfs_ipincount(ip))
+		xfs_iunpin_wait(ip);
+	if (xfs_iflags_test(ip, XFS_ISTALE))
+		goto reclaim;
+	if (xfs_inode_clean(ip))
+		goto reclaim;
+
+	/* Now we have an inode that needs flushing */
+	error = xfs_iflush(ip, sync_mode);
+	if (!error) {
+		switch(sync_mode) {
+		case XFS_IFLUSH_DELWRI_ELSE_ASYNC:
+		case XFS_IFLUSH_DELWRI:
+		case XFS_IFLUSH_ASYNC:
+		case XFS_IFLUSH_DELWRI_ELSE_SYNC:
+		case XFS_IFLUSH_SYNC:
+			/* IO issued, synchronise with IO completion */
+			xfs_iflock(ip);
+			break;
+		default:
+			ASSERT(0);
+			break;
+		}
 	}
 
+reclaim:
+	xfs_ifunlock(ip);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_ireclaim(ip);
 	return 0;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d0d1b5a..8d0666d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2493,7 +2493,7 @@ __xfs_iunpin_wait(
 		wait_event(ip->i_ipin_wait, (atomic_read(&ip->i_pincount) == 0));
 }
 
-static inline void
+void
 xfs_iunpin_wait(
 	xfs_inode_t	*ip)
 {
@@ -2849,15 +2849,6 @@ xfs_iflush(
 	mp = ip->i_mount;
 
 	/*
-	 * If the inode isn't dirty, then just release the inode flush lock and
-	 * do nothing.
-	 */
-	if (xfs_inode_clean(ip)) {
-		xfs_ifunlock(ip);
-		return 0;
-	}
-
-	/*
 	 * We can't flush the inode until it is unpinned, so wait for it if we
 	 * are allowed to block.  We know noone new can pin it, because we are
 	 * holding the inode lock shared and you need to hold it exclusively to
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index ec1f28c..8b618ea 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -483,6 +483,7 @@ int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
 void		xfs_ipin(xfs_inode_t *);
 void		xfs_iunpin(xfs_inode_t *);
+void		xfs_iunpin_wait(xfs_inode_t *);
 int		xfs_iflush(xfs_inode_t *, uint);
 void		xfs_ichgtime(xfs_inode_t *, int);
 void		xfs_lock_inodes(xfs_inode_t **, int, uint);
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
