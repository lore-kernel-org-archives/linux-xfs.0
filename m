Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7REjCqw207380 for <xfs@oss.sgi.com>; Sat, 27 Aug 2011 09:45:13 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F7BF1E7D106
	for <xfs@oss.sgi.com>; Sat, 27 Aug 2011 07:45:11 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	If3J4eUHruaSQvQL for <xfs@oss.sgi.com>;
	Sat, 27 Aug 2011 07:45:11 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QxK8F-0005AY-7z
	for xfs@oss.sgi.com; Sat, 27 Aug 2011 14:45:11 +0000
Date: Sat, 27 Aug 2011 10:45:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: avoid synchronous transactions when deleting attr blocks
Message-ID: <20110827144511.GB16381@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Currently xfs_attr_inactive causes a synchronous transactions if we are
removing a file that has any extents allocated to the attribute fork, and
thus makes XFS extremely slow at removing files with out of line extended
attributes. The code looks a like a relict from the days before the busy
extent list, but with the busy extent list we avoid reusing data and attr
extents that have been freed but not commited yet, so this code is just
as superflous as the synchronous transactions for data blocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2011-08-15 14:31:15.485329718 -0700
+++ xfs/fs/xfs/xfs_attr.c	2011-08-15 14:31:32.025240113 -0700
@@ -823,18 +823,6 @@ xfs_attr_inactive(xfs_inode_t *dp)
 	if (error)
 		goto out;
 
-	/*
-	 * Signal synchronous inactive transactions unless this is a
-	 * synchronous mount filesystem in which case we know that we're here
-	 * because we've been called out of xfs_inactive which means that the
-	 * last reference is gone and the unlink transaction has already hit
-	 * the disk so async inactive transactions are safe.
-	 */
-	if (!(mp->m_flags & XFS_MOUNT_WSYNC)) {
-		if (dp->i_d.di_anextents > 0)
-			xfs_trans_set_sync(trans);
-	}
-
 	error = xfs_itruncate_extents(&trans, dp, XFS_ATTR_FORK, 0);
 	if (error)
 		goto out;
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-08-15 14:33:59.801106208 -0700
+++ xfs/fs/xfs/xfs_bmap.c	2011-08-16 09:01:24.716497619 -0700
@@ -3782,19 +3782,11 @@ xfs_bmap_compute_maxlevels(
  * Routine to be called at transaction's end by xfs_bmapi, xfs_bunmapi
  * caller.  Frees all the extents that need freeing, which must be done
  * last due to locking considerations.  We never free any extents in
- * the first transaction.  This is to allow the caller to make the first
- * transaction a synchronous one so that the pointers to the data being
- * broken in this transaction will be permanent before the data is actually
- * freed.  This is necessary to prevent blocks from being reallocated
- * and written to before the free and reallocation are actually permanent.
- * We do not just make the first transaction synchronous here, because
- * there are more efficient ways to gain the same protection in some cases
- * (see the file truncation code).
+ * the first transaction.
  *
  * Return 1 if the given transaction was committed and a new one
  * started, and 0 otherwise in the committed parameter.
  */
-/*ARGSUSED*/
 int						/* error */
 xfs_bmap_finish(
 	xfs_trans_t		**tp,		/* transaction pointer addr */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
