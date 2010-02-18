Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1ICg3Ox050916 for <xfs@oss.sgi.com>; Thu, 18 Feb 2010 06:42:04 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 301D41CDD6C3
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2010 04:43:22 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id oB9HjTFLeopD2SWy for
	<xfs@oss.sgi.com>; Thu, 18 Feb 2010 04:43:22 -0800 (PST)
Date: Thu, 18 Feb 2010 07:43:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: remove xfs_ipin/xfs_iunpin
Message-ID: <20100218124322.GB6016@infradead.org>
References: <20100217194407.GB28758@infradead.org>
	<20100217230033.GW28392@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100217230033.GW28392@discord.disaster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Feb 18, 2010 at 10:00:33AM +1100, Dave Chinner wrote:
> > +	ASSERT(atomic_read(&->i_pincount) > 0);
> 
> I don't think that compiles. ;)

It does in fact compile for non-debug builds, but here's an updated
version that also compiles in a debug build:

---

From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] xfs: remove xfs_ipin/xfs_iunpin

Inodes are only pinned/unpinned via the inode item methods, and lots of
code relies on that fact.  So remove the separate xfs_ipin/xfs_iunpin
helpers and merge them into their only callers.  This also fixes up
various duplicate and/or incorrect comments.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2010-02-17 10:56:31.726003891 +0100
+++ xfs/fs/xfs/xfs_inode.c	2010-02-17 11:00:21.126005288 +0100
@@ -2439,34 +2439,6 @@ xfs_idestroy_fork(
 }
 
 /*
- * Increment the pin count of the given buffer.
- * This value is protected by ipinlock spinlock in the mount structure.
- */
-void
-xfs_ipin(
-	xfs_inode_t	*ip)
-{
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	atomic_inc(&ip->i_pincount);
-}
-
-/*
- * Decrement the pin count of the given inode, and wake up
- * anyone in xfs_iwait_unpin() if the count goes to 0.  The
- * inode must have been previously pinned with a call to xfs_ipin().
- */
-void
-xfs_iunpin(
-	xfs_inode_t	*ip)
-{
-	ASSERT(atomic_read(&ip->i_pincount) > 0);
-
-	if (atomic_dec_and_test(&ip->i_pincount))
-		wake_up(&ip->i_ipin_wait);
-}
-
-/*
  * This is called to unpin an inode.  The caller must have the inode locked
  * in at least shared mode so that the buffer cannot be subsequently pinned
  * once someone is waiting for it to be unpinned.
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2010-02-17 10:56:31.740273062 +0100
+++ xfs/fs/xfs/xfs_inode.h	2010-02-17 11:00:00.410005428 +0100
@@ -471,8 +471,6 @@ int		xfs_itruncate_finish(struct xfs_tra
 int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);
 
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
-void		xfs_ipin(xfs_inode_t *);
-void		xfs_iunpin(xfs_inode_t *);
 void		xfs_iunpin_wait(xfs_inode_t *);
 int		xfs_iflush(xfs_inode_t *, uint);
 void		xfs_ichgtime(xfs_inode_t *, int);
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2010-02-17 10:56:31.713003821 +0100
+++ xfs/fs/xfs/xfs_inode_item.c	2010-02-18 13:39:35.888276695 +0100
@@ -535,23 +535,23 @@ xfs_inode_item_format(
 
 /*
  * This is called to pin the inode associated with the inode log
- * item in memory so it cannot be written out.  Do this by calling
- * xfs_ipin() to bump the pin count in the inode while holding the
- * inode pin lock.
+ * item in memory so it cannot be written out.
  */
 STATIC void
 xfs_inode_item_pin(
 	xfs_inode_log_item_t	*iip)
 {
 	ASSERT(xfs_isilocked(iip->ili_inode, XFS_ILOCK_EXCL));
-	xfs_ipin(iip->ili_inode);
+
+	atomic_inc(&iip->ili_inode->i_pincount);
 }
 
 
 /*
  * This is called to unpin the inode associated with the inode log
  * item which was previously pinned with a call to xfs_inode_item_pin().
- * Just call xfs_iunpin() on the inode to do this.
+ *
+ * Also wake up anyone in xfs_iunpin_wait() if the count goes to 0.
  */
 /* ARGSUSED */
 STATIC void
@@ -559,7 +559,11 @@ xfs_inode_item_unpin(
 	xfs_inode_log_item_t	*iip,
 	int			stale)
 {
-	xfs_iunpin(iip->ili_inode);
+	struct xfs_inode	*ip = iip->ili_inode;
+
+	ASSERT(atomic_read(&ip->i_pincount) > 0);
+	if (atomic_dec_and_test(&ip->i_pincount))
+		wake_up(&ip->i_ipin_wait);
 }
 
 /* ARGSUSED */
@@ -568,7 +572,7 @@ xfs_inode_item_unpin_remove(
 	xfs_inode_log_item_t	*iip,
 	xfs_trans_t		*tp)
 {
-	xfs_iunpin(iip->ili_inode);
+	xfs_inode_item_unpin(iip, 0);
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
