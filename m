Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB2HlhpY092674 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 11:47:44 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4FD224D4EE8
	for <xfs@oss.sgi.com>; Fri,  2 Dec 2011 09:47:42 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	i2ZKZlSf93ehd2ef for <xfs@oss.sgi.com>;
	Fri, 02 Dec 2011 09:47:42 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RWXD4-0000lF-BQ
	for xfs@oss.sgi.com; Fri, 02 Dec 2011 17:47:42 +0000
Message-Id: <20111202174742.307774458@bombadil.infradead.org>
Date: Fri, 02 Dec 2011 12:46:26 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/12] repair: fix another ABBA deadlock in inode prefetching
References: <20111202174619.179530033@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-fix-prefetch-deadlock
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

The inode prefetching code has a fixed limit of inodes that might are
submitted at a time.  Unfortunately the buffers for them get locked
once the prefetching starts.  That way the threads processing the inode
might get stuck on buffer locked, but not submitted for reading yet.

Fix this by kicking the queue as soon as we would have to wait on the
ra_count semaphore.

Reported-by: Arkadiusz Mi??kiewicz <arekm@maven.pl>
Tested-by: Arkadiusz Mi??kiewicz <arekm@maven.pl>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/prefetch.c
===================================================================
--- xfsprogs-dev.orig/repair/prefetch.c	2011-11-25 13:46:47.195999430 +0100
+++ xfsprogs-dev/repair/prefetch.c	2011-11-25 13:50:41.264731371 +0100
@@ -641,7 +641,18 @@ pf_queuing_worker(
 		pftrace("queuing irec %p in AG %d, sem count = %d",
 			irec, args->agno, i);
 #endif
-		sem_wait(&args->ra_count);
+		err = sem_trywait(&args->ra_count);
+		if (err == EAGAIN) {
+			/*
+			 * Kick the queue once we have reached the limit;
+			 * without this the threads processing the inodes
+			 * might get stuck on a buffer that has been locked
+			 * and added to the I/O queue but is waiting for
+			 * the thread to be woken.
+			 */
+			pf_start_io_workers(args);
+			sem_wait(&args->ra_count);
+		}
 
 		num_inos = 0;
 		bno = XFS_AGINO_TO_AGBNO(mp, cur_irec->ino_startnum);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
