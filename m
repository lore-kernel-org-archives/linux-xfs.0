Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6VL40rh171469 for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 16:04:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B420B39B441
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 14:04:48 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id kKuHXFChAgwkfwBe for
	<xfs@oss.sgi.com>; Fri, 31 Jul 2009 14:04:48 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MWzHT-0003XT-RG
	for xfs@oss.sgi.com; Fri, 31 Jul 2009 21:04:47 +0000
Message-Id: <20090731210447.584668000@bombadil.infradead.org>
Date: Fri, 31 Jul 2009 17:03:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] xfs: do not take the iolock in xfs_ireclaim
References: <20090731210340.638586000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-lockdep-ireclaim
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

While the comment claims we need it to synchronize with inode cache lookups
that is not the case.  Today we make sure to always do an igrab in all
sync variants which do the proper checks for a deleted inode, and we also
have the proper checks in xfs_iget.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_iget.c	2009-07-31 00:33:58.443352015 +0200
+++ linux-2.6/fs/xfs/xfs_iget.c	2009-07-31 00:34:02.742339834 +0200
@@ -507,13 +507,11 @@ xfs_ireclaim(
 	 * can reference the inodes in the cache without taking references.
 	 *
 	 * We make that OK here by ensuring that we wait until the inode is
-	 * unlocked after the lookup before we go ahead and free it.  We get
-	 * both the ilock and the iolock because the code may need to drop the
-	 * ilock one but will still hold the iolock.
+	 * unlocked after the lookup before we go ahead and free it.
 	 */
-	xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_qm_dqdetach(ip);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	switch (ip->i_d.di_mode & S_IFMT) {
 	case S_IFREG:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
