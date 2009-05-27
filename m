Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4RAwR1p188709 for <xfs@oss.sgi.com>; Wed, 27 May 2009 05:58:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5EB31A28F2A
	for <xfs@oss.sgi.com>; Wed, 27 May 2009 03:58:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id B6Dw1zjMFWZSjpxi for
	<xfs@oss.sgi.com>; Wed, 27 May 2009 03:58:41 -0700 (PDT)
Date: Wed, 27 May 2009 06:58:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/7] xfs: split inode flushing from xfs_sync_inodes_ag
Message-ID: <20090527105841.GA10545@infradead.org>
References: <20090514171233.942489000@bombadil.infradead.org>
	<20090514171558.298098000@bombadil.infradead.org>
	<4A1C54FB.2080705@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A1C54FB.2080705@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, May 26, 2009 at 03:45:47PM -0500, Eric Sandeen wrote:
> What happened to the XFS_IFLUSH_DELWRI case?
> 
> You mentioned "keep the current behavior exactly" but this seems like a
> change, no?

Yeah, this got lost when playing with variations of the patch.  Correct
version below:

Subject: xfs: split inode flushing from xfs_sync_inodes_ag
From: Christoph Hellwig <hch@lst.de>


In many cases we only want to sync inode metadata. Split out the inode
flushing into a separate helper to prepare factoring the inode sync code.

Based on a patch from Dave Chinner, but redone to keep the current behaviour
exactly and leave changes to the flushing logic to another patch.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-05-27 12:08:49.137850883 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2009-05-27 12:11:09.530815659 +0200
@@ -77,6 +77,35 @@ xfs_sync_inode_data(
 	return error;
 }
 
+STATIC int
+xfs_sync_inode_attr(
+	struct xfs_inode	*ip,
+	int			flags)
+{
+	int			error = 0;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	if (xfs_inode_clean(ip))
+		goto out_unlock;
+	if (!xfs_iflock_nowait(ip)) {
+		if (!(flags & SYNC_WAIT))
+			goto out_unlock;
+		xfs_iflock(ip);
+	}
+
+	if (xfs_inode_clean(ip)) {
+		xfs_ifunlock(ip);
+		goto out_unlock;
+	}
+
+	error = xfs_iflush(ip, (flags & SYNC_WAIT) ?
+			   XFS_IFLUSH_SYNC : XFS_IFLUSH_DELWRI);
+
+ out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	return error;
+}
+
 /*
  * Sync all the inodes in the given AG according to the
  * direction given by the flags.
@@ -96,7 +125,6 @@ xfs_sync_inodes_ag(
 	do {
 		struct inode	*inode;
 		xfs_inode_t	*ip = NULL;
-		int		lock_flags = XFS_ILOCK_SHARED;
 
 		/*
 		 * use a gang lookup to find the next inode in the tree
@@ -155,22 +183,10 @@ xfs_sync_inodes_ag(
 		if (flags & SYNC_DELWRI)
 			error = xfs_sync_inode_data(ip, flags);
 
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
-		if ((flags & SYNC_ATTR) && !xfs_inode_clean(ip)) {
-			if (flags & SYNC_WAIT) {
-				xfs_iflock(ip);
-				if (!xfs_inode_clean(ip))
-					error = xfs_iflush(ip, XFS_IFLUSH_SYNC);
-				else
-					xfs_ifunlock(ip);
-			} else if (xfs_iflock_nowait(ip)) {
-				if (!xfs_inode_clean(ip))
-					error = xfs_iflush(ip, XFS_IFLUSH_DELWRI);
-				else
-					xfs_ifunlock(ip);
-			}
-		}
-		xfs_iput(ip, lock_flags);
+		if (flags & SYNC_ATTR)
+			error = xfs_sync_inode_attr(ip, flags);
+
+		IRELE(ip);
 
 		if (error)
 			last_error = error;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
