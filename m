Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o58Jugbi230005 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 14:56:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0272D14A978E
	for <xfs@oss.sgi.com>; Tue,  8 Jun 2010 12:59:14 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id BhkDNAabYWUU5XH0 for <xfs@oss.sgi.com>;
	Tue, 08 Jun 2010 12:59:14 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OM4x1-00012z-Ir
	for xfs@oss.sgi.com; Tue, 08 Jun 2010 19:59:08 +0000
Date: Tue, 8 Jun 2010 15:59:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: avoid synchronous transaction in xfs_fs_write_inode
Message-ID: <20100608195905.GA577@infradead.org>
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


We already rely on the fact that the sync code will cause a synchronous
log force later on (currently via xfs_fs_sync_fs -> xfs_quiesce_data ->
xfs_sync_data), so no need to do this here.  This allows us to avoid
a lot of synchronous log forces during sync, which pays of especially
with delayed logging enabled.   Some compilebench numbers that show
this:

xfs (delayed logging, 256k logbufs)
===================================

intial create		  25.94 MB/s	  25.75 MB/s	  25.64 MB/s
create			   8.54 MB/s	   9.12 MB/s	   9.15 MB/s
patch			   2.47 MB/s	   2.47 MB/s	   3.17 MB/s
compile			  29.65 MB/s	  30.51 MB/s	  27.33 MB/s
clean			  90.92 MB/s	  98.83 MB/s	 128.87 MB/s
read tree		  11.90 MB/s	  11.84 MB/s	   8.56 MB/s
read compiled		  28.75 MB/s	  29.96 MB/s	  24.25 MB/s
delete tree		8.39 seconds	8.12 seconds	8.46 seconds
delete compiled		8.35 seconds	8.44 seconds	5.11 seconds
stat tree		6.03 seconds	5.59 seconds	5.19 seconds
stat compiled tree	9.00 seconds	9.52 seconds	8.49 seconds


xfs + write_inode log_force removal
===================================
intial create		  25.87 MB/s	  25.76 MB/s	  25.87 MB/s
create			  15.18 MB/s	  14.80 MB/s	  14.94 MB/s
patch			   3.13 MB/s	   3.14 MB/s	   3.11 MB/s
compile			  36.74 MB/s	  37.17 MB/s	  36.84 MB/s
clean			 226.02 MB/s	 222.58 MB/s	 217.94 MB/s
read tree		  15.14 MB/s	  15.02 MB/s	  15.14 MB/s
read compiled tree	  29.30 MB/s	  29.31 MB/s	  29.32 MB/s
delete tree		6.22 seconds	6.14 seconds	6.15 seconds
delete compiled tree	5.75 seconds	5.92 seconds	5.81 seconds
stat tree		4.60 seconds	4.51 seconds	4.56 seconds
stat compiled tree	4.07 seconds	3.87 seconds	3.96 seconds


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2010-06-08 21:14:40.509003917 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2010-06-08 21:16:41.078005872 +0200
@@ -1025,7 +1025,6 @@ xfs_log_inode(
 	 */
 	xfs_trans_ijoin(tp, ip);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp, 0);
 	xfs_ilock_demote(ip, XFS_ILOCK_EXCL);
 
@@ -1052,6 +1051,12 @@ xfs_fs_write_inode(
 		 * log and the fsync transactions we reduce the IOs we have
 		 * to do here from two (log and inode) to just the log.
 		 *
+		 * We do not even have to use a log force / synchronous
+		 * transaction here as the sync code will cause do
+		 * synchronous log force later durinc the sync process.
+		 * With delayed logging that means we reduce the amount
+		 * of required I/O requests dramatically.
+		 *
 		 * Note: We still need to do a delwri write of the inode after
 		 * this to flush it to the backing buffer so that bulkstat
 		 * works properly if this is the first time the inode has been

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
