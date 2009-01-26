Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q7WhOZ203675 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:32:44 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 62A20185E8EA
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:01 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id uGQYU8LDJuXC5aU6 for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:01 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LRLwu-00030n-Ut
	for xfs@oss.sgi.com; Mon, 26 Jan 2009 07:32:01 +0000
Message-Id: <20090126073200.781644000@bombadil.infradead.org>
Date: Mon, 26 Jan 2009 02:31:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/17] xfs: tiny cleanup for xfs_link
References: <20090126073136.384490000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xfs_link
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

The source and target inodes are guaranteed to never be the same by the VFS,
so no need to check for that (and we would get into bad trouble later anyway
if that were the case).  Also clean up the error handling to use two gotos
instead of nested conditions.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-dev/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs-dev.orig/fs/xfs/xfs_vnodeops.c	2008-12-01 12:56:22.000000000 +0100
+++ xfs-dev/fs/xfs/xfs_vnodeops.c	2008-12-01 12:56:43.000000000 +0100
@@ -2027,8 +2027,10 @@ xfs_link(
 	/* Return through std_return after this point. */
 
 	error = XFS_QM_DQATTACH(mp, sip, 0);
-	if (!error && sip != tdp)
-		error = XFS_QM_DQATTACH(mp, tdp, 0);
+	if (error)
+		goto std_return;
+
+	error = XFS_QM_DQATTACH(mp, tdp, 0);
 	if (error)
 		goto std_return;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
