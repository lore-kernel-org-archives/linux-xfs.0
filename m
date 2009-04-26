Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3QE7AQU233116 for <xfs@oss.sgi.com>; Sun, 26 Apr 2009 09:07:12 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80372144D3E7
	for <xfs@oss.sgi.com>; Sun, 26 Apr 2009 07:10:17 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FXiwLSzMg2WQnlsy for
	<xfs@oss.sgi.com>; Sun, 26 Apr 2009 07:10:17 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Ly50e-0008MN-C5
	for xfs@oss.sgi.com; Sun, 26 Apr 2009 14:07:08 +0000
Message-Id: <20090426140708.279368000@bombadil.infradead.org>
Date: Sun, 26 Apr 2009 10:03:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/5] xfs: fix xfs_quiesce_data
References: <20090426140305.113371000@bombadil.infradead.org>
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

We need to do a synchronous xfs_sync_fsdata to make sure the superblock
actually is on disk when we return.  While we're at it also remove the
superflous SYNC_BDFLUSH flag to xfs_sync_inodes, and move the xfs_filestream_flush
call later [hch: why?  seems unrelated].


Index: linux-2.6/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-04-26 10:46:17.112949525 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_sync.c	2009-04-26 10:48:19.713979813 +0200
@@ -323,16 +323,16 @@ xfs_quiesce_data(
 	int error;
 
 	/* push non-blocking */
-	xfs_sync_inodes(mp, SYNC_DELWRI|SYNC_BDFLUSH);
+	xfs_sync_inodes(mp, SYNC_DELWRI);
 	XFS_QM_DQSYNC(mp, SYNC_BDFLUSH);
-	xfs_filestream_flush(mp);
 
-	/* push and block */
+	/* push and block till complete */
 	xfs_sync_inodes(mp, SYNC_DELWRI|SYNC_WAIT|SYNC_IOWAIT);
 	XFS_QM_DQSYNC(mp, SYNC_WAIT);
+	xfs_filestream_flush(mp);
 
 	/* write superblock and hoover up shutdown errors */
-	error = xfs_sync_fsdata(mp, 0);
+	error = xfs_sync_fsdata(mp, SYNC_WAIT);
 
 	/* flush data-only devices */
 	if (mp->m_rtdev_targp)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
