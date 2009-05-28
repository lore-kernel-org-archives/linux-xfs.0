Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SCJ2VY253000 for <xfs@oss.sgi.com>; Thu, 28 May 2009 07:19:04 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B69F1D377A4
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 05:19:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 0fbE5ic5kp39QTBB for
	<xfs@oss.sgi.com>; Thu, 28 May 2009 05:19:16 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1M9eZo-0000HQ-33
	for xfs@oss.sgi.com; Thu, 28 May 2009 12:19:16 +0000
Date: Thu, 28 May 2009 08:19:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 8/7] xfs: remove SYNC_IOWAIT
Message-ID: <20090528121915.GA30037@infradead.org>
References: <20090514171233.942489000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090514171233.942489000@bombadil.infradead.org>
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

We want to wait for all I/O to finish when we do data integrity syncs.  So
there is no reason to keep SYNC_WAIT separate from SYNC_IOWAIT.  This
causes a little change in behaviour for the ENOSPC flushing code which no
does a second submission and wait of buffered I/O, but that should finish
ASAP as we already did an asynchronous writeout earlier.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-05-27 12:59:57.115813662 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2009-05-27 13:01:14.634816358 +0200
@@ -226,7 +226,7 @@ xfs_sync_inode_data(
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
  out_wait:
-	if (flags & SYNC_IOWAIT)
+	if (flags & SYNC_WAIT)
 		xfs_ioend_wait(ip);
 	IRELE(ip);
 	return error;
@@ -277,7 +277,7 @@ xfs_sync_data(
 {
 	int			error;
 
-	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT|SYNC_IOWAIT)) == 0);
+	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT)) == 0);
 
 	error = xfs_inode_ag_iterator(mp, xfs_sync_inode_data, flags, -1);
 	if (error)
@@ -419,7 +419,7 @@ xfs_quiesce_data(
 	xfs_filestream_flush(mp);
 
 	/* push and block */
-	xfs_sync_data(mp, SYNC_WAIT|SYNC_IOWAIT);
+	xfs_sync_data(mp, SYNC_WAIT);
 	xfs_qm_sync(mp, SYNC_WAIT);
 
 	/* write superblock and hoover up shutdown errors */
@@ -532,7 +532,7 @@ xfs_flush_inodes_work(
 {
 	struct inode	*inode = arg;
 	xfs_sync_data(mp, SYNC_TRYLOCK);
-	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_IOWAIT);
+	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
 	iput(inode);
 }
 
Index: xfs/fs/xfs/linux-2.6/xfs_sync.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.h	2009-05-27 13:00:29.045814647 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.h	2009-05-27 13:01:39.162941539 +0200
@@ -31,7 +31,6 @@ typedef struct xfs_sync_work {
 
 #define SYNC_WAIT		0x0004	/* wait for i/o to complete */
 #define SYNC_BDFLUSH		0x0008	/* BDFLUSH is calling -- don't block */
-#define SYNC_IOWAIT		0x0010  /* wait for all I/O to complete */
 #define SYNC_TRYLOCK		0x0020  /* only try to lock inodes */
 
 int xfs_syncd_init(struct xfs_mount *mp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
