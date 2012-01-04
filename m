Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q049V7DH125055 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 03:31:07 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	gI60zhZuqUrJgee5 for <xfs@oss.sgi.com>;
	Wed, 04 Jan 2012 01:31:05 -0800 (PST)
Message-Id: <20120104093104.971865222@bombadil.infradead.org>
Date: Wed, 04 Jan 2012 04:30:16 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/2] xfs: log the inode in ->write_inode calls for kupdate
References: <20120104093015.056917499@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-kupdate
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
To: stable@vger.kernel.org, xfs@oss.sgi.com

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
