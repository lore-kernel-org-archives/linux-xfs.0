Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB8FxKtx150222 for <xfs@oss.sgi.com>; Thu, 8 Dec 2011 09:59:20 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED2291DC4159
	for <xfs@oss.sgi.com>; Thu,  8 Dec 2011 07:59:19 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	lXnm0EXuAaEyRQxA for <xfs@oss.sgi.com>;
	Thu, 08 Dec 2011 07:59:19 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RYgNT-0006ro-8S
	for xfs@oss.sgi.com; Thu, 08 Dec 2011 15:59:19 +0000
Message-Id: <20111208155919.215723395@bombadil.infradead.org>
Date: Thu, 08 Dec 2011 10:58:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/11] xfs: always return with the iolock held from
	xfs_file_aio_write_checks
References: <20111208155755.323930705@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xfs_file_aio_write_checks
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

While xfs_iunlock is fine with 0 lockflags the calling conventions are much
cleaner if xfs_file_aio_write_checks never returns without the iolock held.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_file.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: xfs/fs/xfs/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/xfs_file.c	2011-12-07 12:46:31.343897882 +0100
+++ xfs/fs/xfs/xfs_file.c	2011-12-07 12:48:33.309903801 +0100
@@ -636,7 +636,9 @@ out_lock:
 /*
  * Common pre-write limit and setup checks.
  *
- * Returns with iolock held according to @iolock.
+ * Called with the iolocked held either shared and exclusive according to
+ * @iolock, and returns with it held.  Might upgrade the iolock to exclusive
+ * if called for a direct write beyond i_size.
  */
 STATIC ssize_t
 xfs_file_aio_write_checks(
@@ -653,8 +655,7 @@ xfs_file_aio_write_checks(
 restart:
 	error = generic_write_checks(file, pos, count, S_ISBLK(inode->i_mode));
 	if (error) {
-		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
-		*iolock = 0;
+		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
 		return error;
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
