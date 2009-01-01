Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n01JLI8J015967 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 13:21:19 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B3E358275
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 11:21:16 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id hSFeFEWLB3vQ8hzj for
	<xfs@oss.sgi.com>; Thu, 01 Jan 2009 11:21:16 -0800 (PST)
Date: Thu, 1 Jan 2009 14:21:16 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] pass XFS_IGET_BULKSTAT to xfs_iget for handle operations
Message-ID: <20090101192116.GA6986@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: Mario Becroft <mb@gem.win.co.nz>

NFS clients or users of the handle ioctls can pass us arbitrary inode
numbers through the exportfs interface.  Make sure we use the
XFS_IGET_BULKSTAT so that these don't cause shutdowns due to the corruption
checks.  Also translate the EINVAL we get back for invalid inode clusters
into an ESTALE which is more appropinquate, and remove the useless check
for a NULL inode on a successfull xfs_iget return.

I have a testcase to reproduce this using the handle interface which
I will submit to xfsqa.


Reported-by: Mario Becroft <mb@gem.win.co.nz>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_export.c	2009-01-01 20:06:06.145674550 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_export.c	2009-01-01 20:14:59.673658382 +0100
@@ -126,11 +126,26 @@ xfs_nfs_get_inode(
 	if (ino == 0)
 		return ERR_PTR(-ESTALE);
 
-	error = xfs_iget(mp, NULL, ino, 0, XFS_ILOCK_SHARED, &ip, 0);
-	if (error)
+	/*
+	 * The XFS_IGET_BULKSTAT means that an invalid inode number is just
+	 * fine and not an indication of a corrupted filesystem.  Because
+	 * clients can send any kind of invalid file handle, e.g. after
+	 * a restore on the server we have to deal with this case gracefully.
+	 */
+	error = xfs_iget(mp, NULL, ino, XFS_IGET_BULKSTAT,
+			 XFS_ILOCK_SHARED, &ip, 0);
+	if (error) {
+		/*
+		 * EINVAL means the inode cluster doesn't exist anymore.
+		 * This implies the filehandle is stale, so we should
+		 * translate it here.
+		 * We don't use ESTALE directly down the chain to not
+		 * confuse applications using bulkstat that expect EINVAL.
+		 */
+		if (error == EINVAL)
+			error = ESTALE;
 		return ERR_PTR(-error);
-	if (!ip)
-		return ERR_PTR(-EIO);
+	}
 
 	if (ip->i_d.di_gen != generation) {
 		xfs_iput_new(ip, XFS_ILOCK_SHARED);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
