Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBIFo0mN215233 for <xfs@oss.sgi.com>; Sun, 18 Dec 2011 09:50:00 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	rpj3fRWoCUNrtlOv for <xfs@oss.sgi.com>;
	Sun, 18 Dec 2011 07:49:56 -0800 (PST)
Date: Sun, 18 Dec 2011 10:49:55 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/1] xfs: log the inode in ->write_inode calls for kupdate
Message-ID: <20111218154955.GB17626@infradead.org>
References: <20111218154936.GA17626@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111218154936.GA17626@infradead.org>
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
Cc: Paul Anderson <pha@umich.edu>, Sean Thomas Caron <scaron@umich.edu>

If the writeback code writes back an inode because it has expired we currently
use the non-blockin ->write_inode path.  This means any inode that is pinned
is skipped.  With delayed logging and a workload that has very little log
traffic otherwise it is very likely that an inode that gets constantly
written to is always pinned, and thus we keep refusing to write it.  The VM
writeback code at that point redirties it and doesn't try to write it again
for another 30 seconds.  This means under certain scenarious time based
metadata writeback never happens.

Fix this by calling into xfs_log_inode for kupdate in addition to data
integrity syncs, and thus transfer the inode to the log ASAP.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c	2011-12-14 05:33:07.193262189 -0800
+++ xfs/fs/xfs/xfs_super.c	2011-12-14 05:38:56.108038623 -0800
@@ -905,7 +884,7 @@ xfs_fs_write_inode(
 	if (!ip->i_update_core)
 		return 0;
 
-	if (wbc->sync_mode == WB_SYNC_ALL) {
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->for_kupdate) {
 		/*
 		 * Make sure the inode has made it it into the log.  Instead
 		 * of forcing it all the way to stable storage using a

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
