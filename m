Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7RNF5Pq116157 for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 18:15:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 879B0156975B
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 16:15:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id WiwMgDa0lX9nWDLH for
	<xfs@oss.sgi.com>; Thu, 27 Aug 2009 16:15:59 -0700 (PDT)
Message-Id: <20090827231558.701516609@bombadil.infradead.org>
Date: Thu, 27 Aug 2009 19:15:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/4] [PATCH 5/5] xfs: fix xfs_quiesce_data 
References: <20090827231536.646792672@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-xfs_quiesce_data
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

From: Dave Chinner <david@fromorbit.com>

We need to do a synchronous xfs_sync_fsdata to make sure the superblock
actually is on disk when we return.

Also remove SYNC_BDFLUSH flag to xfs_sync_inodes because that particular
flag is never checked.

Move xfs_filestream_flush call later [hch: why?  seems unrelated].


Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-08-27 20:06:39.889355294 -0300
+++ linux-2.6/fs/xfs/linux-2.6/xfs_sync.c	2009-08-27 20:08:01.169357854 -0300
@@ -426,14 +426,16 @@ xfs_quiesce_data(
 	/* push non-blocking */
 	xfs_sync_data(mp, 0);
 	xfs_qm_sync(mp, SYNC_TRYLOCK);
-	xfs_filestream_flush(mp);
 
-	/* push and block */
+	/* push and block till complete */
 	xfs_sync_data(mp, SYNC_WAIT);
 	xfs_qm_sync(mp, SYNC_WAIT);
 
+	/* drop inode references pinned by filestreams */
+	xfs_filestream_flush(mp);
+
 	/* write superblock and hoover up shutdown errors */
-	error = xfs_sync_fsdata(mp, 0);
+	error = xfs_sync_fsdata(mp, SYNC_WAIT);
 
 	/* flush data-only devices */
 	if (mp->m_rtdev_targp)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
