Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB7AEsZv130564 for <xfs@oss.sgi.com>; Tue, 7 Dec 2010 04:14:55 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6FEEA1423160
	for <xfs@oss.sgi.com>; Tue,  7 Dec 2010 02:16:42 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id JVaSI3a18hijb6ys for
	<xfs@oss.sgi.com>; Tue, 07 Dec 2010 02:16:42 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PPubB-0006lK-PW
	for xfs@oss.sgi.com; Tue, 07 Dec 2010 10:16:41 +0000
Date: Tue, 7 Dec 2010 05:16:41 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: log timestamp changes to the source inode in rename
Message-ID: <20101207101641.GA25995@infradead.org>
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

Now that we don't mark VFS inodes dirty anymore for internal timestamp changes,
but rely on the transaction subsystem to push them out, we need to explicitly
log the source inode in rename after updating it's timestamps to make sure
the changes actually get forced out by sync/fsync or an AIL push.

We already account for the fourth inode in the log reservation, as a rename
of directories needs to update the nlink field, so just adding the
xfs_trans_log_inode call is enough.

This fixes the xfsqa 065 regression introduced by:

	"xfs: don't use vfs writeback for pure metadata modifications"


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_rename.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rename.c	2010-12-07 11:05:15.661253391 +0100
+++ xfs/fs/xfs/xfs_rename.c	2010-12-07 11:05:25.139275042 +0100
@@ -297,6 +297,7 @@ xfs_rename(
 	 * it and some incremental backup programs won't work without it.
 	 */
 	xfs_trans_ichgtime(tp, src_ip, XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, src_ip, XFS_ILOG_CORE);
 
 	/*
 	 * Adjust the link count on src_dp.  This is necessary when

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
